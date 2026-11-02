import 'package:flutter/material.dart';
import '../models/prediction_response.dart';
import '../theme/app_theme.dart';

/// Card 1: Nominal Flexural Capacity Comparison (Hero Display)
/// AI Predicted Mn vs ACI 440.1R-15 Code with +X.X% AI Gain Badge
class HeroCard extends StatelessWidget {
  final PredictionResponse response;

  const HeroCard({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final ai = response.aiPrediction;
    final aci = response.aciBenchmark;

    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nominal Flexural Capacity (Mn)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primarySteel,
                      ),
                    ),
                    Text(
                      'AI Surrogate Model vs ACI 440.1R-15 Code Baseline',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppTheme.mutedSlate,
                      ),
                    ),
                  ],
                ),
              ),

              // AI Gain / Recovery Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accentBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Large Side-by-Side Numbers
          Container(
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
                          const Text(
                            'AI PREDICTED (Mn,AI)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.secondarySteel,
                              letterSpacing: 0.4,
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
                            const Text(
                              'ACI 440.1R-15 (Mn,ACI)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.secondarySteel,
                                letterSpacing: 0.4,
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
          ),

          const SizedBox(height: 12),

          // Engineering Insight Tooltip / Note
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, size: 15, color: AppTheme.accentBlue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI accounts for continuous parabolic concrete softening curves, recovering ~3-5% capacity lost to ACI\'s simplified rectangular stress block.',
                    style: TextStyle(
                      fontSize: 11,
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
  }
}
