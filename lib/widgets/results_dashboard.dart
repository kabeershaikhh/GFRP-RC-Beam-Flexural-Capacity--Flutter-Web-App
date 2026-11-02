import 'package:flutter/material.dart';
import '../models/beam_input.dart';
import '../models/prediction_response.dart';
import '../theme/app_theme.dart';
import 'beam_cross_section_painter.dart';
import 'behavior_card.dart';
import 'detailing_card.dart';
import 'hero_card.dart';

/// Right Column: Engineering Results Dashboard
/// Displays the 3 structured cards, vector cross-section, and the research validation card below.
class ResultsDashboard extends StatelessWidget {
  final PredictionResponse? response;
  final BeamInput currentInput;
  final bool isLoading;

  const ResultsDashboard({
    super.key,
    required this.response,
    required this.currentInput,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingSkeleton();
    }

    if (response == null) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Hero Comparison Card (AI vs ACI 440) - Kept clean on top
        HeroCard(response: response!),
        const SizedBox(height: 16),

        // 2. Behavior & Safety Factors Card
        BehaviorCard(response: response!),
        const SizedBox(height: 16),

        // 3. Detailing & Constructability Checks
        DetailingCard(response: response!),
        const SizedBox(height: 16),

        // 4. Live Vector Cross-Section Diagram with calculated d
        BeamCrossSectionView(
          input: currentInput,
          effectiveDepthD: response!.detailingChecks.effectiveDepthDMm,
        ),
        const SizedBox(height: 16),

        // 5. Why AI Model is Superior Card (Placed below the calculation results)
        _buildWhyAiSuperiorCard(),
      ],
    );
  }

  /// Dedicated Research & Laboratory Validation Card placed below calculation results
  Widget _buildWhyAiSuperiorCard() {
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlueLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.science,
                  color: AppTheme.accentBlue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Why AI Model is Superior • Tested on 12 Real Lab Beams',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primarySteel,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlueLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.accentBlueBorder),
                ),
                child: const Text(
                  'Lab R² = 0.8700',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderSlate),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Validated on 12 Physical Experimental Beams:\n'
                  'The AI model was trained on 15,000 fiber FE continuum simulations and verified against 12 real published lab-tested GFRP-RC beams, achieving high experimental accuracy (R² = 0.8700).',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.secondarySteel,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Recovers Conservatism in ACI 440.1R-15:\n'
                  'ACI 440.1R assumes an idealized rectangular Whitney stress block, which cuts capacity by ~3.5%–5.0% for concrete crushing. The AI model captures continuous parabolic concrete softening and actual GFRP tensile strain mobilization.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.secondarySteel,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Empty State Placeholder before the first calculation
  Widget _buildEmptyState() {
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Schematic beam sketch
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: BeamCrossSectionView(
              input: currentInput,
              isSchematicOnly: true,
              canvasHeight: 130,
            ),
          ),
          const SizedBox(height: 24),

          // Title & prompt
          const Text(
            'Ready for Flexural Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primarySteel,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: const Text(
              'Enter beam geometry and material properties on the left, or pick a Quick-Test Preset, then click "CALCULATE CAPACITIES" to run the ANN AI model and ACI 440.1R-15 code benchmark.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.mutedSlate,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Feature Highlights pills
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFeaturePill(Icons.psychology, 'MLP Neural Network (R²=0.998)'),
              _buildFeaturePill(Icons.menu_book, 'ACI 440.1R-15 Physics Engine'),
              _buildFeaturePill(Icons.verified, 'Instant Constructability Checks'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderSlate),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.accentBlue),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondarySteel,
            ),
          ),
        ],
      ),
    );
  }

  /// Sleek Loading Skeleton while awaiting backend response
  Widget _buildLoadingSkeleton() {
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              color: AppTheme.accentBlue,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Evaluating GFRP Beam Capacity...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.primarySteel,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Executing ANN MLP Regressor pipeline & ACI 440.1R-15 continuous stress strain integration.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: AppTheme.mutedSlate,
            ),
          ),
          const SizedBox(height: 28),

          // Skeleton Mock Cards
          _buildSkeletonBox(height: 100),
          const SizedBox(height: 12),
          _buildSkeletonBox(height: 80),
          const SizedBox(height: 12),
          _buildSkeletonBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox({required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderSlate),
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
