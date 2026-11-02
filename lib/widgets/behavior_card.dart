import 'package:flutter/material.dart';
import '../models/prediction_response.dart';
import '../theme/app_theme.dart';

/// Card 2: Failure Mode & Safety Factors
/// Displays governing failure mechanism badge, reinforcement ratio (rho / rho_b),
/// and factored design capacity (phi * Mn).
class BehaviorCard extends StatelessWidget {
  final PredictionResponse response;

  const BehaviorCard({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final aci = response.aciBenchmark;
    final isCrushing = aci.isConcreteCrushing;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 460;

        return Container(
          decoration: AppTheme.cardDecoration(),
          padding: EdgeInsets.all(isMobile ? 14 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section Title
              Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 18, color: AppTheme.accentBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Safety Factors & Failure Mechanism',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primarySteel,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Governing Failure Mode Status Badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCrushing ? AppTheme.crushingGreenBg : AppTheme.ruptureAmberBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCrushing ? AppTheme.crushingGreenBorder : AppTheme.ruptureAmberBorder,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isCrushing ? AppTheme.crushingGreen : AppTheme.ruptureAmber,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCrushing ? Icons.check : Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCrushing
                                ? 'Concrete Crushing'
                                : 'GFRP Rupture',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isCrushing ? const Color(0xFF065F46) : const Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isCrushing
                                ? 'Ductile & Progressive Failure (Preferred in ACI 440.1R GFRP Design)'
                                : 'Brittle & Sudden Failure (Tension-Controlled Risk - Extra Caution Required)',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: isCrushing ? const Color(0xFF047857) : const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Balanced Ratio & Factored Design Strength (Responsive Stack on Mobile)
              if (isMobile)
                Column(
                  children: [
                    _buildBalancedRatioBox(aci, isCrushing),
                    const SizedBox(height: 10),
                    _buildFactoredStrengthBox(aci),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(child: _buildBalancedRatioBox(aci, isCrushing)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildFactoredStrengthBox(aci)),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalancedRatioBox(AciBenchmark aci, bool isCrushing) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderSlate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BALANCED RATIO (ρ / ρb)',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppTheme.mutedSlate,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            aci.rhoOverRhoB.toStringAsFixed(3),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isCrushing ? AppTheme.crushingGreen : AppTheme.ruptureAmber,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            aci.rhoOverRhoB >= 1.0
                ? 'Over-reinforced (ρ > ρb)'
                : 'Under-reinforced (ρ < ρb)',
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.secondarySteel,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactoredStrengthBox(AciBenchmark aci) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderSlate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FACTORED STRENGTH (φMn)',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppTheme.mutedSlate,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: aci.designPhiMnKNm.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primarySteel,
                  ),
                ),
                const TextSpan(
                  text: ' kN·m',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondarySteel,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Applied φ = ${aci.phiFactor.toStringAsFixed(2)} for drawings',
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.mutedSlate,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
