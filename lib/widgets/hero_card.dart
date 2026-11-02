import 'package:flutter/material.dart';
import '../models/prediction_response.dart';
import '../theme/app_theme.dart';

/// Card 1: Nominal Flexural Capacity Comparison (Hero Display)
/// AI Predicted Mn vs ACI 440.1R-15 Code with +X.X% AI Gain Badge
/// Fully responsive across mobile phones, tablets, and desktops.
class HeroCard extends StatelessWidget {
  final PredictionResponse response;

  const HeroCard({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final ai = response.aiPrediction;
    final aci = response.aciBenchmark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 460;
        final isNarrowPhone = constraints.maxWidth < 360;

        return Container(
          decoration: AppTheme.cardDecoration(),
          padding: EdgeInsets.all(isMobile ? 14 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ==========================================
              // 1. Header Row (Responsive Badge & Title)
              // ==========================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppTheme.accentBlueLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.compare_arrows,
                      color: AppTheme.accentBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nominal Flexural Capacity (Mn)',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primarySteel,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          isMobile
                              ? 'AI Model vs ACI 440.1R-15 Code'
                              : 'AI Surrogate Model vs ACI 440.1R-15 Code Baseline',
                          style: TextStyle(
                            fontSize: isMobile ? 11 : 11.5,
                            color: AppTheme.mutedSlate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // AI Gain / Recovery Pill Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.accentBlueLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accentBlueBorder, width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.trending_up, size: 14, color: AppTheme.accentBlue),
                        const SizedBox(width: 4),
                        Text(
                          '${aci.gainFormatted} AI Gain',
                          style: TextStyle(
                            fontSize: isNarrowPhone ? 10.5 : 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.accentBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: isMobile ? 14 : 20),

              // ==========================================
              // 2. Comparison Metrics Display
              // ==========================================
              if (isMobile)
                _buildMobileMetrics(ai, aci)
              else
                _buildDesktopSideBySideMetrics(ai, aci),

              const SizedBox(height: 12),

              // ==========================================
              // 3. Engineering Insight Tooltip / Note
              // ==========================================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 1.5),
                      child: Icon(Icons.lightbulb_outline, size: 15, color: AppTheme.accentBlue),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI accounts for continuous parabolic concrete softening curves, recovering ~3-5% capacity lost to ACI\'s simplified rectangular stress block.',
                        style: TextStyle(
                          fontSize: isMobile ? 10.5 : 11,
                          color: AppTheme.secondarySteel,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Mobile-optimized stacked comparison view (prevents side-by-side cramping on phones)
  Widget _buildMobileMetrics(AiPrediction ai, AciBenchmark aci) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderSlate),
      ),
      child: Column(
        children: [
          // 1. AI Prediction Box (Tinted Blue Accent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.accentBlue.withValues(alpha: 0.35), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentBlue.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.accentBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Flexible(
                            child: Text(
                              'AI PREDICTED (Mn,AI)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.accentBlue,
                                letterSpacing: 0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'ANN Model (R² = ${ai.r2Score.toStringAsFixed(4)})',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppTheme.mutedSlate,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: ai.mnAiKNm.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.accentBlue,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const TextSpan(
                        text: ' kN·m',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondarySteel,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Central Comparison Divider Pill
          Row(
            children: [
              const Expanded(child: Divider(color: AppTheme.borderSlate, height: 1)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'vs code baseline',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.mutedSlate,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: AppTheme.borderSlate, height: 1)),
            ],
          ),

          const SizedBox(height: 8),

          // 2. ACI Code Baseline Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderSlate),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.secondarySteel,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Flexible(
                            child: Text(
                              'ACI 440.1R-15 (Mn,ACI)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.secondarySteel,
                                letterSpacing: 0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Rectangular Stress Block',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppTheme.mutedSlate,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: aci.mnAciKNm.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primarySteel,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const TextSpan(
                        text: ' kN·m',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondarySteel,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Desktop / Tablet side-by-side metrics display
  Widget _buildDesktopSideBySideMetrics(AiPrediction ai, AciBenchmark aci) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderSlate),
      ),
      child: Row(
        children: [
          // 1. AI Prediction (Highlight Blue)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Flexible(
                      child: Text(
                        'AI PREDICTED (Mn,AI)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.secondarySteel,
                          letterSpacing: 0.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: ai.mnAiKNm.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.accentBlue,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const TextSpan(
                        text: ' kN·m',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondarySteel,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ANN Pipeline (R² = ${ai.r2Score.toStringAsFixed(4)})',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedSlate,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Vertical Divider
          Container(
            width: 1.2,
            height: 65,
            color: AppTheme.cardBorder,
          ),

          // 2. ACI Code Baseline
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.secondarySteel,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Flexible(
                        child: Text(
                          'ACI 440.1R-15 (Mn,ACI)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.secondarySteel,
                            letterSpacing: 0.4,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: aci.mnAciKNm.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primarySteel,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const TextSpan(
                          text: ' kN·m',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.secondarySteel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rectangular Stress Block',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.mutedSlate,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
