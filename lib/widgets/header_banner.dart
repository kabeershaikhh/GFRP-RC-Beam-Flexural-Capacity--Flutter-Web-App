import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Top branding header and dismissible research context banner
class HeaderBanner extends StatefulWidget {
  const HeaderBanner({super.key});

  @override
  State<HeaderBanner> createState() => _HeaderBannerState();
}

class _HeaderBannerState extends State<HeaderBanner> {
  bool _showBanner = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Primary Header Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.primarySteel,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Structural Engineering Icon
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentBlue.withValues(alpha: 0.4)),
                ),
                child: const Icon(
                  Icons.architecture,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // Title & Conference Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Flexible(
                          child: Text(
                            'GFRP-RC Flexural Capacity Analyzer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Conference Pill Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'ICEC 2026 Paper',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'AI Surrogate Model (ANN R²=0.9982) & ACI 440.1R-15 Code Comparison Tool',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 2. Slim Dismissible Research Context Banner
        if (_showBanner)
          Container(
            color: const Color(0xFFE2E8F0),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppTheme.secondarySteel,
                  size: 18,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Predicts nominal flexural capacity (Mn) of GFRP-RC rectangular beams using an Artificial Neural Network (MLP) trained on 15,000 fiber FE simulations and validated on 12 physical lab-tested beams. Directly benchmarked against ACI 440.1R-15 code equations.',
                    style: TextStyle(
                      color: AppTheme.secondarySteel,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => _showBanner = false),
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.close,
                      color: AppTheme.mutedSlate,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
