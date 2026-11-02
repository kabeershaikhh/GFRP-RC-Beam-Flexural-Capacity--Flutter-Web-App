import 'package:flutter/material.dart';
import '../models/prediction_response.dart';
import '../theme/app_theme.dart';

/// Card 3: Constructability & Detailing Checks
/// Checks clear bar spacing for aggregate clearance, minimum reinforcement ratio,
/// and effective depth.
class DetailingCard extends StatelessWidget {
  final PredictionResponse response;

  const DetailingCard({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final detail = response.detailingChecks;

    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Row(
            children: [
              Icon(Icons.rule, size: 18, color: AppTheme.accentBlue),
              SizedBox(width: 8),
              Text(
                'Detailing & Constructability Compliance',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primarySteel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 1. Clear Bar Spacing Check (Critical Constructability)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: detail.spacingOk ? AppTheme.crushingGreenBg : AppTheme.hazardRoseBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: detail.spacingOk ? AppTheme.crushingGreenBorder : AppTheme.hazardRoseBorder,
                width: 1.2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  detail.spacingOk ? Icons.check_circle : Icons.cancel,
                  color: detail.spacingOk ? AppTheme.crushingGreen : AppTheme.hazardRose,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            detail.spacingOk
                                ? 'Clear Bar Spacing: ${detail.clearSpacingMm.toStringAsFixed(1)} mm [PASS]'
                                : 'Clear Bar Spacing: ${detail.clearSpacingMm.toStringAsFixed(1)} mm [ALERT]',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: detail.spacingOk
                                  ? const Color(0xFF065F46)
                                  : const Color(0xFF991B1B),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: detail.spacingOk
                                  ? AppTheme.crushingGreen
                                  : AppTheme.hazardRose,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              detail.spacingOk ? 'OK' : 'CONGESTION',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        detail.spacingOk
                            ? 'Adequate clearance for aggregate flow during vibration (> 25 mm).'
                            : 'Spacing is under 25 mm limit! Risk of aggregate honeycombing and voiding. Recommend 2 layers or wider beam.',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: detail.spacingOk
                              ? const Color(0xFF047857)
                              : const Color(0xFFB91C1C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 2. Minimum Reinforcement & Effective Depth Grid
          Row(
            children: [
              // Minimum Reinforcement (rho_min)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.borderSlate),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        detail.rhoMinOk ? Icons.check_circle_outline : Icons.error_outline,
                        color: detail.rhoMinOk ? AppTheme.crushingGreen : AppTheme.hazardRose,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MIN REINFORCEMENT (ρmin)',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.mutedSlate,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              detail.rhoMinOk ? 'Meets ACI 440.1R' : 'Below Minimum',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: detail.rhoMinOk
                                    ? AppTheme.secondarySteel
                                    : AppTheme.hazardRose,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Effective Depth (d)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.borderSlate),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.height,
                        color: AppTheme.accentBlue,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'EFFECTIVE DEPTH (d)',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.mutedSlate,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${detail.effectiveDepthDMm.toStringAsFixed(1)} mm',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primarySteel,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
