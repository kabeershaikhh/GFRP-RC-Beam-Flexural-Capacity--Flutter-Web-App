import 'package:flutter_test/flutter_test.dart';
import 'package:gfrp_ann/models/bar_spec.dart';
import 'package:gfrp_ann/models/beam_input.dart';
import 'package:gfrp_ann/models/prediction_response.dart';
import 'package:gfrp_ann/services/api_service.dart';

void main() {
  group('BarSpec Catalog Tests', () {
    test('Standard ASTM bars catalog contains #3 through #8', () {
      expect(BarSpec.standardCatalog.length, 6);
      expect(BarSpec.standardCatalog.map((b) => b.designation), containsAll(['#3', '#4', '#5', '#6', '#7', '#8']));
    });

    test('fromDiameter returns closest match accurately', () {
      final bar5 = BarSpec.fromDiameter(15.88);
      expect(bar5.designation, '#5');

      final bar7 = BarSpec.fromDiameter(22.23);
      expect(bar7.designation, '#7');
    });
  });

  group('BeamInput Model & Validation Tests', () {
    test('Standard Preset contains expected values', () {
      final input = BeamInput.presetStandard();
      expect(input.bMm, 250.0);
      expect(input.hMm, 500.0);
      expect(input.coverMm, 35.0);
      expect(input.fcMpa, 35.0);
      expect(input.efGpa, 50.0);
      expect(input.ffuMpa, 800.0);
      expect(input.barDiaMm, 15.88);
      expect(input.nBars, 4);
      expect(input.validate(), isEmpty);
    });

    test('Out of bounds parameters generate validation errors', () {
      const invalid = BeamInput(
        bMm: 100.0, // min 150
        hMm: 1000.0, // max 900
        coverMm: 10.0, // min 20
        fcMpa: 15.0, // min 20
        efGpa: 30.0, // min 40
        ffuMpa: 600.0, // min 700
        barDiaMm: 4.0, // min 6
        nBars: 1, // min 2
      );
      final errors = invalid.validate();
      expect(errors.length, 8);
    });

    test('JSON serialization matches FastAPI schema', () {
      final input = BeamInput.presetStandard();
      final json = input.toJson();

      expect(json['b_mm'], 250.0);
      expect(json['h_mm'], 500.0);
      expect(json['cover_mm'], 35.0);
      expect(json['fc_MPa'], 35.0);
      expect(json['Ef_GPa'], 50.0);
      expect(json['ffu_MPa'], 800.0);
      expect(json['bar_dia_mm'], 15.88);
      expect(json['n_bars'], 4);
    });
  });

  group('PredictionResponse Deserialization Tests', () {
    test('Parses complete FastAPI JSON response correctly', () {
      final sampleJson = {
        "success": true,
        "ai_prediction": {
          "model_name": "Artificial Neural Network (MLP 64x32)",
          "Mn_AI_kNm": 217.87,
          "model_r2_synthetic": 0.9982,
          "model_r2_real_beams": 0.87
        },
        "aci_benchmark": {
          "design_standard": "ACI 440.1R-15",
          "Mn_ACI_kNm": 209.21,
          "ai_vs_aci_gain_percent": 4.14,
          "failure_mode": "Concrete Crushing",
          "rho_over_rho_b": 1.506,
          "phi_factor": 0.65,
          "factored_phi_Mn_kNm": 135.98
        },
        "detailing_checks": {
          "effective_depth_d_mm": 447.1,
          "clear_spacing_mm": 32.5,
          "spacing_ok": true,
          "rho_min_ok": true
        }
      };

      final response = PredictionResponse.fromJson(sampleJson);
      expect(response.success, isTrue);
      expect(response.aiPrediction.mnAiKNm, 217.87);
      expect(response.aiPrediction.r2Score, 0.9982);
      expect(response.aciBenchmark.mnAciKNm, 209.21);
      expect(response.aciBenchmark.aiGainPercent, 4.14);
      expect(response.aciBenchmark.gainFormatted, '+4.1%');
      expect(response.aciBenchmark.isConcreteCrushing, isTrue);
      expect(response.aciBenchmark.rhoOverRhoB, 1.506);
      expect(response.aciBenchmark.designPhiMnKNm, 135.98);
      expect(response.detailingChecks.effectiveDepthDMm, 447.1);
      expect(response.detailingChecks.clearSpacingMm, 32.5);
      expect(response.detailingChecks.spacingOk, isTrue);
      expect(response.detailingChecks.rhoMinOk, isTrue);
    });
  });

  group('Offline Simulation Physics Engine Tests', () {
    test('Standard Beam simulation produces Concrete Crushing', () async {
      final input = BeamInput.presetStandard();
      final res = await const ApiService().predictCapacity(input, delay: Duration.zero);

      expect(res.success, isTrue);
      expect(res.aiPrediction.mnAiKNm, 217.87);
      expect(res.aciBenchmark.mnAciKNm, 209.21);
      expect(res.aciBenchmark.isConcreteCrushing, isTrue);
      expect(res.aciBenchmark.rhoOverRhoB, 1.506);
      expect(res.detailingChecks.spacingOk, isTrue);
      expect(res.detailingChecks.rhoMinOk, isTrue);
    });

    test('Tension-Controlled Beam produces GFRP Rupture', () async {
      final input = BeamInput.presetTensionControlled();
      final res = await const ApiService().predictCapacity(input, delay: Duration.zero);

      expect(res.success, isTrue);
      expect(res.aiPrediction.mnAiKNm, 54.86);
      expect(res.aciBenchmark.mnAciKNm, 36.03);
      expect(res.aciBenchmark.isConcreteCrushing, isFalse);
      expect(res.aciBenchmark.failureMode, contains('GFRP Rupture'));
      expect(res.aciBenchmark.rhoOverRhoB, 0.335);
    });
  });
}
