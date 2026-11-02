import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/beam_input.dart';
import '../theme/app_theme.dart';

/// Interactive vector visualization of the GFRP-RC beam cross-section.
/// Renders concrete boundary, stirrups, bottom tensile GFRP bars, and engineering dimension lines.
class BeamCrossSectionView extends StatelessWidget {
  final BeamInput input;
  final double? effectiveDepthD;
  final bool isSchematicOnly;
  final double canvasHeight;

  const BeamCrossSectionView({
    super.key,
    required this.input,
    this.effectiveDepthD,
    this.isSchematicOnly = false,
    this.canvasHeight = 180.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.crop_portrait, size: 16, color: AppTheme.secondarySteel),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Beam Cross-Section Schematic',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondarySteel,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlueLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${input.bMm.toStringAsFixed(0)} × ${input.hMm.toStringAsFixed(0)} mm',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: canvasHeight,
            width: double.infinity,
            child: CustomPaint(
              painter: _BeamCrossSectionPainter(
                input: input,
                effectiveDepthD: effectiveDepthD,
                isSchematicOnly: isSchematicOnly,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${input.nBars} × Ø${input.barDiaMm.toStringAsFixed(1)} mm GFRP Bars | Clear Cover: ${input.coverMm.toStringAsFixed(0)} mm',
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.mutedSlate,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BeamCrossSectionPainter extends CustomPainter {
  final BeamInput input;
  final double? effectiveDepthD;
  final bool isSchematicOnly;

  _BeamCrossSectionPainter({
    required this.input,
    this.effectiveDepthD,
    this.isSchematicOnly = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double marginX = 35.0;
    final double marginY = 20.0;
    final double availW = size.width - (2.0 * marginX);
    final double availH = size.height - (2.0 * marginY);

    if (availW <= 0 || availH <= 0) return;

    // Scale to fit within available area maintaining aspect ratio
    final double scale = math.min(availW / input.bMm, availH / input.hMm);
    final double beamW = input.bMm * scale;
    final double beamH = input.hMm * scale;

    final double originX = (size.width - beamW) / 2.0;
    final double originY = (size.height - beamH) / 2.0;

    final Rect concreteRect = Rect.fromLTWH(originX, originY, beamW, beamH);

    // 1. Concrete Fill & Boundary
    final Paint concreteFill = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.fill;
    canvas.drawRect(concreteRect, concreteFill);

    final Paint concreteBorder = Paint()
      ..color = AppTheme.secondarySteel
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawRect(concreteRect, concreteBorder);

    // 2. Concrete Hatch Lines (Subtle texture)
    final Paint hatchPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 0.8;
    for (double i = -beamH; i < beamW; i += 18.0) {
      final double x1 = (originX + i).clamp(originX, originX + beamW);
      final double y1 = originY;
      final double x2 = (originX + i + 18).clamp(originX, originX + beamW);
      final double y2 = originY + 18;
      if (x1 < originX + beamW) {
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), hatchPaint);
      }
    }

    // 3. Stirrup Rectangle
    const double dStirrup = 9.53;
    final double coverPx = (input.coverMm + (dStirrup / 2.0)) * scale;
    final Rect stirrupRect = Rect.fromLTWH(
      originX + coverPx,
      originY + coverPx,
      beamW - (2 * coverPx),
      beamH - (2 * coverPx),
    );

    final Paint stirrupPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(stirrupRect, const Radius.circular(4)),
      stirrupPaint,
    );

    // 4. Tensile GFRP Rebar
    final double barRadiusPx = math.max(3.0, (input.barDiaMm / 2.0) * scale);
    final double rebarCenterY = originY + beamH - coverPx - barRadiusPx;

    final double leftRebarX = originX + coverPx + barRadiusPx;
    final double rightRebarX = originX + beamW - coverPx - barRadiusPx;

    final Paint rebarFill = Paint()
      ..color = AppTheme.accentBlue
      ..style = PaintingStyle.fill;
    final Paint rebarBorder = Paint()
      ..color = AppTheme.primarySteel
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final int n = input.nBars;
    for (int i = 0; i < n; i++) {
      final double rebarX = n > 1
          ? leftRebarX + (i * (rightRebarX - leftRebarX) / (n - 1))
          : (leftRebarX + rightRebarX) / 2.0;

      canvas.drawCircle(Offset(rebarX, rebarCenterY), barRadiusPx, rebarFill);
      canvas.drawCircle(Offset(rebarX, rebarCenterY), barRadiusPx, rebarBorder);
    }

    // 5. Dimension lines & annotations
    final Paint dimPaint = Paint()
      ..color = AppTheme.secondarySteel
      ..strokeWidth = 1.0;

    // Top Width b Dimension
    final double dimY = originY - 10.0;
    canvas.drawLine(Offset(originX, dimY), Offset(originX + beamW, dimY), dimPaint);
    canvas.drawLine(Offset(originX, dimY - 4), Offset(originX, dimY + 4), dimPaint);
    canvas.drawLine(Offset(originX + beamW, dimY - 4), Offset(originX + beamW, dimY + 4), dimPaint);

    _drawText(
      canvas,
      'b = ${input.bMm.toStringAsFixed(0)}',
      Offset(originX + (beamW / 2.0), dimY - 9),
    );

    // Left Depth h Dimension
    final double dimX = originX - 12.0;
    canvas.drawLine(Offset(dimX, originY), Offset(dimX, originY + beamH), dimPaint);
    canvas.drawLine(Offset(dimX - 4, originY), Offset(dimX + 4, originY), dimPaint);
    canvas.drawLine(Offset(dimX - 4, originY + beamH), Offset(dimX + 4, originY + beamH), dimPaint);

    _drawRotatedText(
      canvas,
      'h = ${input.hMm.toStringAsFixed(0)}',
      Offset(dimX - 10, originY + (beamH / 2.0)),
    );

    // Right Effective Depth d Dimension (if provided)
    if (effectiveDepthD != null && !isSchematicOnly) {
      final double dPx = effectiveDepthD! * scale;
      final double rightDimX = originX + beamW + 12.0;
      canvas.drawLine(Offset(rightDimX, originY), Offset(rightDimX, originY + dPx), dimPaint);
      canvas.drawLine(Offset(rightDimX - 4, originY), Offset(rightDimX + 4, originY), dimPaint);
      canvas.drawLine(Offset(rightDimX - 4, originY + dPx), Offset(rightDimX + 4, originY + dPx), dimPaint);

      _drawRotatedText(
        canvas,
        'd = ${effectiveDepthD!.toStringAsFixed(0)}',
        Offset(rightDimX + 10, originY + (dPx / 2.0)),
      );
    }
  }

  void _drawText(Canvas canvas, String text, Offset center) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        color: AppTheme.secondarySteel,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - (textPainter.width / 2.0), center.dy - (textPainter.height / 2.0)),
    );
  }

  void _drawRotatedText(Canvas canvas, String text, Offset center) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        color: AppTheme.secondarySteel,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 2.0);
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2.0, -textPainter.height / 2.0),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BeamCrossSectionPainter oldDelegate) {
    return oldDelegate.input != input ||
        oldDelegate.effectiveDepthD != effectiveDepthD ||
        oldDelegate.isSchematicOnly != isSchematicOnly;
  }
}
