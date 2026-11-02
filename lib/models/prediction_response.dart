/// Structured prediction result returned from the FastAPI computation backend.
class PredictionResponse {
  final bool success;
  final AiPrediction aiPrediction;
  final AciBenchmark aciBenchmark;
  final DetailingChecks detailingChecks;

  const PredictionResponse({
    required this.success,
    required this.aiPrediction,
    required this.aciBenchmark,
    required this.detailingChecks,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      success: json['success'] as bool? ?? true,
      aiPrediction: AiPrediction.fromJson(
        (json['ai_prediction'] as Map<String, dynamic>?) ?? {},
      ),
      aciBenchmark: AciBenchmark.fromJson(
        (json['aci_benchmark'] as Map<String, dynamic>?) ?? {},
      ),
      detailingChecks: DetailingChecks.fromJson(
        (json['detailing_checks'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }
}

class AiPrediction {
  final String modelName;
  final double mnAiKNm;
  final double r2Score;
  final double? r2RealBeams;

  const AiPrediction({
    required this.modelName,
    required this.mnAiKNm,
    required this.r2Score,
    this.r2RealBeams,
  });

  factory AiPrediction.fromJson(Map<String, dynamic> json) {
    return AiPrediction(
      modelName: json['model_name'] as String? ?? 'Artificial Neural Network (MLP)',
      mnAiKNm: (json['Mn_AI_kNm'] as num?)?.toDouble() ?? 0.0,
      r2Score: (json['model_r2_synthetic'] as num?)?.toDouble() ??
          (json['r2_score'] as num?)?.toDouble() ??
          0.9982,
      r2RealBeams: (json['model_r2_real_beams'] as num?)?.toDouble(),
    );
  }
}

class AciBenchmark {
  final String standard;
  final double mnAciKNm;
  final double aiGainPercent;
  final String failureMode;
  final double rhoOverRhoB;
  final double phiFactor;
  final double designPhiMnKNm;

  const AciBenchmark({
    required this.standard,
    required this.mnAciKNm,
    required this.aiGainPercent,
    required this.failureMode,
    required this.rhoOverRhoB,
    required this.phiFactor,
    required this.designPhiMnKNm,
  });

  /// Whether failure is governed by concrete crushing (ductile/preferred in GFRP design)
  bool get isConcreteCrushing {
    final lower = failureMode.toLowerCase();
    return lower.contains('crushing') || lower.contains('concrete');
  }

  /// Formatted AI gain string with sign
  String get gainFormatted {
    if (aiGainPercent >= 0) {
      return '+${aiGainPercent.toStringAsFixed(1)}%';
    }
    return '${aiGainPercent.toStringAsFixed(1)}%';
  }

  factory AciBenchmark.fromJson(Map<String, dynamic> json) {
    return AciBenchmark(
      standard: json['design_standard'] as String? ??
          json['standard'] as String? ??
          'ACI 440.1R-15',
      mnAciKNm: (json['Mn_ACI_kNm'] as num?)?.toDouble() ?? 0.0,
      aiGainPercent: (json['ai_vs_aci_gain_percent'] as num?)?.toDouble() ??
          (json['ai_gain_percent'] as num?)?.toDouble() ??
          0.0,
      failureMode: json['failure_mode'] as String? ?? 'Concrete Crushing',
      rhoOverRhoB: (json['rho_over_rho_b'] as num?)?.toDouble() ?? 1.0,
      phiFactor: (json['phi_factor'] as num?)?.toDouble() ?? 0.65,
      designPhiMnKNm: (json['factored_phi_Mn_kNm'] as num?)?.toDouble() ??
          (json['design_phi_Mn_kNm'] as num?)?.toDouble() ??
          0.0,
    );
  }
}

class DetailingChecks {
  final double effectiveDepthDMm;
  final double clearSpacingMm;
  final bool spacingOk;
  final bool rhoMinOk;

  const DetailingChecks({
    required this.effectiveDepthDMm,
    required this.clearSpacingMm,
    required this.spacingOk,
    required this.rhoMinOk,
  });

  factory DetailingChecks.fromJson(Map<String, dynamic> json) {
    return DetailingChecks(
      effectiveDepthDMm: (json['effective_depth_d_mm'] as num?)?.toDouble() ?? 0.0,
      clearSpacingMm: (json['clear_spacing_mm'] as num?)?.toDouble() ?? 0.0,
      spacingOk: json['spacing_ok'] as bool? ?? true,
      rhoMinOk: json['rho_min_ok'] as bool? ?? true,
    );
  }
}
