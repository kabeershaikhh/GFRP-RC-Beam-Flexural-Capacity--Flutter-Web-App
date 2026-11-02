import 'dart:async';
import 'dart:math' as math;
import '../models/bar_spec.dart';
import '../models/beam_input.dart';
import '../models/prediction_response.dart';
import 'ann_weights.dart';

/// Standalone Computation Service for GFRP-RC Beam Flexural Capacity.
/// Directly evaluates the embedded Artificial Neural Network (MLP 64x32)
/// and the ACI 440.1R-15 structural physics engine 100% locally in Dart.
class ApiService {
  const ApiService();

  /// Predicts beam capacity and evaluates code benchmarks directly inside Flutter.
  /// Includes a 2-second calculation delay so the user experiences the circular loading state.
  Future<PredictionResponse> predictCapacity(
    BeamInput input, {
    Duration delay = const Duration(seconds: 2),
  }) async {
    // 1. Pre-transmission client-side validation
    final errors = input.validate();
    if (errors.isNotEmpty) {
      throw Exception(errors.join('\n'));
    }

    // 2-second calculation simulation to display circular progress loading state
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }

    return evaluateLocally(input);
  }

  /// 100% standalone evaluation of both the ANN Machine Learning model
  /// (trained on 15,000 fiber FE beams & validated on 12 lab beams)
  /// and the full ACI 440.1R-15 code benchmark.
  static PredictionResponse evaluateLocally(BeamInput input) {
    // 1. Evaluate the trained ANN Neural Network (MLP 64x32) forward pass
    final features = [
      input.bMm,
      input.hMm,
      input.coverMm,
      input.fcMpa,
      input.efGpa,
      input.ffuMpa,
      input.barDiaMm,
      input.nBars.toDouble(),
    ];
    final double mnAiKNm = AnnWeights.predict(features);

    // 2. Section geometry & material parameters matching ACI 440.1R-15
    final bar = BarSpec.fromDiameter(input.barDiaMm);
    final double db = bar.diameterMm;
    const double dStirrup = 9.53; // Standard #3 stirrup diameter mm
    final double d = input.hMm - input.coverMm - dStirrup - (0.5 * db);
    final double afTotal = input.nBars * bar.areaMm2;
    final double rhoF = afTotal / (input.bMm * d);

    final double fc = input.fcMpa;
    double beta1 = 0.85 - (0.05 * (fc - 28.0) / 7.0);
    if (beta1 > 0.85) beta1 = 0.85;
    if (beta1 < 0.65) beta1 = 0.65;
    const double ecu = 0.003;

    final double efMpa = input.efGpa * 1000.0;
    final double ffu = input.ffuMpa;
    final double epsFu = ffu / efMpa;

    // 3. Balanced reinforcement ratio (ACI 440.1R-15 Eq. 7-3)
    final double rhoFb = 0.85 * beta1 * (fc / ffu) * (ecu / (ecu + epsFu));
    final double rhoRatio = rhoF / rhoFb;

    // 4. Dual-failure-mode nominal moment calculation
    // Concrete-crushing branch (Eq. 7.2.2a-b)
    final double term1 = math.pow(efMpa * ecu, 2) / 4.0;
    final double term2 = (0.85 * beta1 * fc / rhoF) * efMpa * ecu;
    double ffCc = math.sqrt(term1 + term2) - (0.5 * efMpa * ecu);
    if (ffCc > ffu) ffCc = ffu;
    final double mnCc = rhoF * ffCc * (1.0 - 0.59 * rhoF * ffCc / fc) * input.bMm * d * d;

    // FRP-rupture branch (Eq. 7.2.2c)
    final double cb = d * ecu / (ecu + epsFu);
    final double mnFr = afTotal * ffu * (d - beta1 * cb / 2.0);

    // Governing failure mode (lower capacity governs)
    double mnAciNmm;
    String failureMode;
    if (mnCc <= mnFr) {
      mnAciNmm = mnCc;
      failureMode = 'Concrete Crushing';
    } else {
      mnAciNmm = mnFr;
      failureMode = 'GFRP Rupture';
    }
    final double mnAciKNm = mnAciNmm / 1e6;

    // 5. Strength reduction factor phi (ACI 440.1R-15 Eq. 7.2.3.1)
    double phi;
    if (rhoRatio <= 1.0) {
      phi = 0.55;
    } else if (rhoRatio >= 1.4) {
      phi = 0.65;
    } else {
      phi = 0.30 + 0.25 * rhoRatio;
    }
    final double phiMnKNm = phi * mnAciKNm;
    final double diffPercent = ((mnAiKNm - mnAciKNm) / mnAciKNm) * 100.0;

    // 6. Detailing & constructability checks
    final double clearCoverSide = input.coverMm + dStirrup;
    final double availableWidth = input.bMm - (2.0 * clearCoverSide) - (input.nBars * db);
    final double clearSpacing = input.nBars > 1 ? availableWidth / (input.nBars - 1) : availableWidth;
    final double minSpacing = math.max(25.0, db);
    final bool spacingOk = clearSpacing >= minSpacing;

    final double rhoMin = math.max(0.004, (0.41 * math.sqrt(fc)) / ffu);
    final bool rhoMinOk = rhoF >= rhoMin;

    return PredictionResponse(
      success: true,
      aiPrediction: AiPrediction(
        modelName: 'Artificial Neural Network (MLP 64x32)',
        mnAiKNm: double.parse(mnAiKNm.toStringAsFixed(2)),
        r2Score: 0.9982,
        r2RealBeams: 0.87,
      ),
      aciBenchmark: AciBenchmark(
        standard: 'ACI 440.1R-15',
        mnAciKNm: double.parse(mnAciKNm.toStringAsFixed(2)),
        aiGainPercent: double.parse(diffPercent.toStringAsFixed(2)),
        failureMode: failureMode,
        rhoOverRhoB: double.parse(rhoRatio.toStringAsFixed(3)),
        phiFactor: double.parse(phi.toStringAsFixed(2)),
        designPhiMnKNm: double.parse(phiMnKNm.toStringAsFixed(2)),
      ),
      detailingChecks: DetailingChecks(
        effectiveDepthDMm: double.parse(d.toStringAsFixed(1)),
        clearSpacingMm: double.parse(clearSpacing.toStringAsFixed(1)),
        spacingOk: spacingOk,
        rhoMinOk: rhoMinOk,
      ),
    );
  }

  // Alias for backward compatibility
  static PredictionResponse simulateOffline(BeamInput input) => evaluateLocally(input);
}
