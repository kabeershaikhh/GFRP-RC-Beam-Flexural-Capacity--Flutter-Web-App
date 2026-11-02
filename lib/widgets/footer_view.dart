import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Academic Citation & Conference Presentation Footer
class FooterView extends StatelessWidget {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: AppTheme.primarySteel,
        border: Border(top: BorderSide(color: Color(0xFF334155), width: 1)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Research Paper Title
              const Text(
                'Machine-Learning-Assisted Flexural Capacity Prediction of GFRP-Reinforced Concrete Beams',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 6),

              // Conference Details & Affiliations
              const Text(
                '16th International Civil Engineering Conference (ICEC-2026) • Karachi, Pakistan\n'
                'Department of Civil Engineering, NED University of Engineering & Technology & Mehran University of Engineering and Technology (MUET)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),

              // Model Accuracy Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: const Text(
                  'ANN MLP Model: R² = 0.9982 (15,000 Synthetic FE Beams) | R² = 0.8700 (12 Published Lab Beams)',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF38BDF8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
