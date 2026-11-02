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
        // 1. Primary Header Bar (Responsive for Mobile & Desktop)
        Container(
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              final isNarrow = constraints.maxWidth < 400;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 24,
                  vertical: isMobile ? 12 : 16,
                ),
                child: Row(
                  children: [
                    // Custom Civil Engineering GFRP Beam Emblem Logo
                    BeamEmblemLogo(size: isMobile ? 38 : 44),
                    SizedBox(width: isMobile ? 10 : 14),

                    // Title & Conference Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  isMobile
                                      ? (isNarrow ? 'GFRP-RC Analyzer' : 'GFRP-RC Beam Analyzer')
                                      : 'GFRP-RC Flexural Capacity Analyzer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 16 : 19,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Conference Pill Badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 6 : 8,
                                  vertical: isMobile ? 2 : 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  isMobile ? 'ICEC 2026' : 'ICEC 2026 Paper',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 10 : 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isMobile
                                ? 'ANN (R² = 0.9982) vs ACI 440.1R-15 Code'
                                : 'AI Surrogate Model (ANN R²=0.9982) & ACI 440.1R-15 Code Comparison Tool',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: isMobile ? 11 : 12.5,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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

/// Custom Civil Engineering Vector Emblem Logo:
/// Pixel-for-pixel mathematical 1:1 replica of `web/favicon.svg`
/// Renders concrete cross-section, dimension line, stirrups, anchor bars, and 4 evenly spaced GFRP bars.
class BeamEmblemLogo extends StatelessWidget {
  final double size;

  const BeamEmblemLogo({super.key, this.size = 42.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * (26.0 / 128.0)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentBlue.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: const _ExactSvgEmblemPainter(),
      ),
    );
  }
}

class _ExactSvgEmblemPainter extends CustomPainter {
  const _ExactSvgEmblemPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Exact mapping from 128x128 SVG viewBox to target widget size
    canvas.save();
    canvas.scale(size.width / 128.0, size.height / 128.0);

    // 1. Background Steel Squircle:
    // <rect x="4" y="4" width="120" height="120" rx="26" fill="url(#bgGrad)" stroke="#0284C7" stroke-width="3.5" />
    final bgRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(4, 4, 120, 120),
      const Radius.circular(26),
    );
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
      ).createShader(const Rect.fromLTWH(4, 4, 120, 120))
      ..style = PaintingStyle.fill;
    canvas.drawRRect(bgRect, bgPaint);

    final bgStroke = Paint()
      ..color = const Color(0xFF0284C7)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(bgRect, bgStroke);

    // 2. Concrete Cross-Section Block:
    // <rect x="28" y="26" width="72" height="78" rx="8" fill="url(#beamGrad)" stroke="#64748B" stroke-width="2.5" />
    final beamRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(28, 26, 72, 78),
      const Radius.circular(8),
    );
    final beamPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF334155), Color(0xFF1E293B)],
      ).createShader(const Rect.fromLTWH(28, 26, 72, 78))
      ..style = PaintingStyle.fill;
    canvas.drawRRect(beamRect, beamPaint);

    final beamStroke = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(beamRect, beamStroke);

    // 3. Stirrup Inner Outline:
    // <rect x="37" y="35" width="54" height="60" rx="5" fill="none" stroke="#94A3B8" stroke-width="2" stroke-dasharray="5,2" />
    final stirrupPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(37, 35, 54, 60),
          const Radius.circular(5),
        ),
      );
    _drawDashedPath(
      canvas,
      stirrupPath,
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke,
      dashLength: 5.0,
      dashGap: 2.5,
    );

    // 4. Top Bars (Anchor Rebar):
    // <circle cx="46" cy="44" r="3.5" fill="#64748B" />
    // <circle cx="82" cy="44" r="3.5" fill="#64748B" />
    final anchorPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(46, 44), 3.5, anchorPaint);
    canvas.drawCircle(const Offset(82, 44), 3.5, anchorPaint);

    // 5. Bottom Tensile GFRP Rebar (4 evenly spaced glowing cyan bars):
    // <circle cx="45" cy="83" r="5.5" fill="url(#rebarGrad)" stroke="#FFFFFF" stroke-width="1.2" />
    // <circle cx="57.5" cy="83" r="5.5" fill="url(#rebarGrad)" stroke="#FFFFFF" stroke-width="1.2" />
    // <circle cx="70.5" cy="83" r="5.5" fill="url(#rebarGrad)" stroke="#FFFFFF" stroke-width="1.2" />
    // <circle cx="83" cy="83" r="5.5" fill="url(#rebarGrad)" stroke="#FFFFFF" stroke-width="1.2" />
    final rebarShader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
    ).createShader(const Rect.fromLTWH(40, 77, 50, 12));

    final rebarFill = Paint()
      ..shader = rebarShader
      ..style = PaintingStyle.fill;

    final rebarBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const xs = [45.0, 57.5, 70.5, 83.0];
    for (final x in xs) {
      canvas.drawCircle(Offset(x, 83), 5.5, rebarFill);
      canvas.drawCircle(Offset(x, 83), 5.5, rebarBorder);
    }

    // 6. Dimension Indicator Line:
    // <path d="M 28 17 L 100 17 M 28 13 L 28 21 M 100 13 L 100 21" stroke="#38BDF8" stroke-width="2.5" stroke-linecap="round" />
    // <circle cx="64" cy="17" r="2.5" fill="#38BDF8" />
    final dimPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Horizontal line
    canvas.drawLine(const Offset(28, 17), const Offset(100, 17), dimPaint);
    // Left tick
    canvas.drawLine(const Offset(28, 13), const Offset(28, 21), dimPaint);
    // Right tick
    canvas.drawLine(const Offset(100, 13), const Offset(100, 21), dimPaint);

    // Center indicator dot
    final centerDotPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(64, 17), 2.5, centerDotPaint);

    canvas.restore();
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashLength,
    required double dashGap,
  }) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + dashLength < metric.length)
            ? dashLength
            : metric.length - distance;
        final extract = metric.extractPath(distance, distance + length);
        canvas.drawPath(extract, paint);
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
