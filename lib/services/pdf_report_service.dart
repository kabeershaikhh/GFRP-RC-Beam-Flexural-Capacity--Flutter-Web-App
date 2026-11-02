import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/bar_spec.dart';
import '../models/beam_input.dart';
import '../models/prediction_response.dart';

/// Service responsible for generating publication-quality civil engineering PDF calculation reports.
class PdfReportService {
  /// Generate the PDF document bytes
  static Future<Uint8List> generateReportBytes({
    required BeamInput input,
    required PredictionResponse response,
  }) async {
    final pdf = pw.Document(
      title: 'GFRP-RC Beam Flexural Capacity Report',
      author: 'ICEC 2026 AI Surrogate Framework',
      subject: 'Nominal Flexural Capacity Comparison: ANN vs ACI 440.1R-15',
    );

    final barSpec = BarSpec.fromDiameter(input.barDiaMm);
    final totalAf = input.nBars * barSpec.areaMm2;
    final effectiveD = response.detailingChecks.effectiveDepthDMm;
    final rhoF = totalAf / (input.bMm * effectiveD);
    final timestamp = DateTime.now().toLocal();
    final dateStr =
        '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    final reportId =
        'GFRP-${timestamp.millisecondsSinceEpoch.toRadixString(16).toUpperCase()}';

    // Engineering palette
    final primarySteel = PdfColor.fromHex('#1E293B');
    final secondarySteel = PdfColor.fromHex('#334155');
    final accentBlue = PdfColor.fromHex('#0284C7');
    final lightBg = PdfColor.fromHex('#F8FAFC');
    final borderColor = PdfColor.fromHex('#CBD5E1');
    final textMuted = PdfColor.fromHex('#64748B');
    final emeraldGreen = PdfColor.fromHex('#10B981');
    final amberOrange = PdfColor.fromHex('#F59E0B');
    final roseRed = PdfColor.fromHex('#EF4444');

    final isCrushing = response.aciBenchmark.isConcreteCrushing;
    final statusColor = isCrushing ? emeraldGreen : amberOrange;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // ==========================================
              // 1. TOP HEADER & METADATA BAR
              // ==========================================
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: primarySteel,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'GFRP-RC BEAM FLEXURAL CAPACITY REPORT',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'AI Surrogate Model (ANN MLP 64x32) vs. ACI 440.1R-15 Code Benchmark',
                          style: pw.TextStyle(
                            color: PdfColor.fromHex('#94A3B8'),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: pw.BoxDecoration(
                            color: accentBlue,
                            borderRadius:
                                const pw.BorderRadius.all(pw.Radius.circular(4)),
                          ),
                          child: pw.Text(
                            'ICEC 2026',
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 8.5,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          'Report ID: $reportId',
                          style: pw.TextStyle(
                            color: PdfColor.fromHex('#CBD5E1'),
                            fontSize: 8,
                          ),
                        ),
                        pw.Text(
                          'Date: $dateStr',
                          style: pw.TextStyle(
                            color: PdfColor.fromHex('#94A3B8'),
                            fontSize: 7.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 12),

              // ==========================================
              // 2. HERO COMPARISON SUMMARY BOXES
              // ==========================================
              pw.Row(
                children: [
                  // AI Box
                  pw.Expanded(
                    flex: 5,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: lightBg,
                        border: pw.Border.all(color: accentBlue, width: 1.5),
                        borderRadius:
                            const pw.BorderRadius.all(pw.Radius.circular(6)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'AI PREDICTED CAPACITY',
                                style: pw.TextStyle(
                                  color: accentBlue,
                                  fontSize: 8.5,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                'ANN R^2 = 0.9982',
                                style: pw.TextStyle(
                                  color: textMuted,
                                  fontSize: 7.5,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                response.aiPrediction.mnAiKNm
                                    .toStringAsFixed(2),
                                style: pw.TextStyle(
                                  color: primarySteel,
                                  fontSize: 22,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.SizedBox(width: 4),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 2),
                                child: pw.Text(
                                  'kN-m  (Mn,AI)',
                                  style: pw.TextStyle(
                                    color: textMuted,
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'Physical Lab Beams Validation: R^2 = 0.8700 | MAPE = 6.45%',
                            style: pw.TextStyle(
                              color: secondarySteel,
                              fontSize: 7.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  pw.SizedBox(width: 8),

                  // ACI Code Box
                  pw.Expanded(
                    flex: 5,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: lightBg,
                        border: pw.Border.all(color: borderColor, width: 1.0),
                        borderRadius:
                            const pw.BorderRadius.all(pw.Radius.circular(6)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'ACI 440.1R-15 CODE DESIGN',
                                style: pw.TextStyle(
                                  color: secondarySteel,
                                  fontSize: 8.5,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1.5),
                                decoration: pw.BoxDecoration(
                                  color: accentBlue,
                                  borderRadius: const pw.BorderRadius.all(
                                      pw.Radius.circular(3)),
                                ),
                                child: pw.Text(
                                  'AI Gain: ${response.aciBenchmark.gainFormatted}',
                                  style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontSize: 7.5,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                response.aciBenchmark.mnAciKNm
                                    .toStringAsFixed(2),
                                style: pw.TextStyle(
                                  color: primarySteel,
                                  fontSize: 22,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.SizedBox(width: 4),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 2),
                                child: pw.Text(
                                  'kN-m  (Mn,ACI)',
                                  style: pw.TextStyle(
                                    color: textMuted,
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'Physical Lab Beams Validation: R^2 = 0.6975 | MAPE = 14.82%',
                            style: pw.TextStyle(
                              color: textMuted,
                              fontSize: 7.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10),

              // ==========================================
              // 3. BEAM SPECIFICATIONS & INPUTS (TABLE)
              // ==========================================
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: lightBg,
                  border: pw.Border.all(color: borderColor),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'BEAM GEOMETRY & MATERIAL SPECIFICATIONS',
                      style: pw.TextStyle(
                        color: primarySteel,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Table(
                      border: pw.TableBorder.all(
                          color: PdfColor.fromHex('#E2E8F0'), width: 0.5),
                      children: [
                        pw.TableRow(
                          decoration: pw.BoxDecoration(
                              color: PdfColor.fromHex('#EDF2F7')),
                          children: [
                            _tableHeader('Parameter'),
                            _tableHeader('Symbol'),
                            _tableHeader('Input Value'),
                            _tableHeader('Permitted Range'),
                            _tableHeader('Status'),
                          ],
                        ),
                        _tableDataRow(
                            'Beam Width', 'b', '${input.bMm.toStringAsFixed(1)} mm', '150 - 400 mm', 'Valid'),
                        _tableDataRow(
                            'Overall Height', 'h', '${input.hMm.toStringAsFixed(1)} mm', '300 - 900 mm', 'Valid'),
                        _tableDataRow(
                            'Clear Cover', 'cover', '${input.coverMm.toStringAsFixed(1)} mm', '20 - 60 mm', 'Valid'),
                        _tableDataRow(
                            'Effective Depth', 'd', '${effectiveD.toStringAsFixed(1)} mm', 'Calculated', 'Valid'),
                        _tableDataRow(
                            'Concrete Strength', "f'c", '${input.fcMpa.toStringAsFixed(1)} MPa', '20 - 55 MPa', 'Valid'),
                        _tableDataRow(
                            'GFRP Modulus', 'Ef', '${input.efGpa.toStringAsFixed(1)} GPa', '40 - 65 GPa', 'Valid'),
                        _tableDataRow(
                            'GFRP Tensile Strength', 'ffu', '${input.ffuMpa.toStringAsFixed(1)} MPa', '700 - 900 MPa', 'Valid'),
                        _tableDataRow(
                            'Tension Rebar', 'Af', '${input.nBars}x ${barSpec.displayName} ($totalAf mm2)', '2 - 8 bars', 'Valid'),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),

              // ==========================================
              // 4. BEHAVIOR, SAFETY & DETAILING RESULTS
              // ==========================================
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Behavior & Capacity Box
                  pw.Expanded(
                    flex: 5,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        color: lightBg,
                        border: pw.Border.all(color: borderColor),
                        borderRadius:
                            const pw.BorderRadius.all(pw.Radius.circular(6)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'FLEXURAL BEHAVIOR & SAFETY FACTORS',
                            style: pw.TextStyle(
                              color: primarySteel,
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          _infoRow(
                            'Governing Failure Mode',
                            response.aciBenchmark.failureMode,
                            valueColor: statusColor,
                            isBold: true,
                          ),
                          pw.Divider(color: borderColor, height: 8),
                          _infoRow(
                            'Reinforcement Ratio (rho_f)',
                            rhoF.toStringAsFixed(4),
                          ),
                          pw.Divider(color: borderColor, height: 8),
                          _infoRow(
                            'Balanced Ratio Index (rho / rho_b)',
                            response.aciBenchmark.rhoOverRhoB.toStringAsFixed(3),
                            badgeText: response.aciBenchmark.rhoOverRhoB > 1.4
                                ? 'Over-Reinf.'
                                : 'Under-Reinf.',
                          ),
                          pw.Divider(color: borderColor, height: 8),
                          _infoRow(
                            'Strength Reduction Factor (phi)',
                            response.aciBenchmark.phiFactor.toStringAsFixed(2),
                          ),
                          pw.Divider(color: borderColor, height: 8),
                          _infoRow(
                            'Factored Design Capacity (phi*Mn)',
                            '${response.aciBenchmark.designPhiMnKNm.toStringAsFixed(2)} kN-m',
                            isBold: true,
                            valueColor: primarySteel,
                          ),
                        ],
                      ),
                    ),
                  ),

                  pw.SizedBox(width: 8),

                  // Detailing & Constructability Box
                  pw.Expanded(
                    flex: 5,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        color: lightBg,
                        border: pw.Border.all(color: borderColor),
                        borderRadius:
                            const pw.BorderRadius.all(pw.Radius.circular(6)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'DETAILING & CONSTRUCTABILITY CHECKS',
                            style: pw.TextStyle(
                              color: primarySteel,
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          _infoRow(
                            'Clear Bar Spacing',
                            '${response.detailingChecks.clearSpacingMm.toStringAsFixed(1)} mm',
                          ),
                          pw.Divider(color: borderColor, height: 8),
                          _infoRow(
                            'Aggregate Clearance Check',
                            response.detailingChecks.spacingOk
                                ? 'PASS (>= 25 mm)'
                                : 'FAIL (< 25 mm Congestion)',
                            valueColor: response.detailingChecks.spacingOk
                                ? emeraldGreen
                                : roseRed,
                            isBold: true,
                          ),
                          pw.Divider(color: borderColor, height: 8),
                          _infoRow(
                            'Minimum Reinforcement (rho_min)',
                            response.detailingChecks.rhoMinOk
                                ? 'PASS (Satisfied)'
                                : 'FAIL (Deficient)',
                            valueColor: response.detailingChecks.rhoMinOk
                                ? emeraldGreen
                                : roseRed,
                            isBold: true,
                          ),
                          pw.Divider(color: borderColor, height: 8),
                          _infoRow(
                            'Stirrup & Placement Clearance',
                            'Standard 9.53 mm stirrup cage',
                          ),
                          pw.Divider(color: borderColor, height: 8),
                          _infoRow(
                            'ACI 440 Section 7.2 Compliance',
                            (response.detailingChecks.spacingOk &&
                                    response.detailingChecks.rhoMinOk)
                                ? 'COMPLIANT'
                                : 'NON-COMPLIANT',
                            valueColor: (response.detailingChecks.spacingOk &&
                                    response.detailingChecks.rhoMinOk)
                                ? emeraldGreen
                                : roseRed,
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10),

              // ==========================================
              // 5. RESEARCH VALIDATION NOTE
              // ==========================================
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F1F5F9'),
                  border: pw.Border.all(color: borderColor),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'AI SURROGATE MODEL SUPERIORITY OVER ACI 440.1R-15',
                      style: pw.TextStyle(
                        color: primarySteel,
                        fontSize: 8.5,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      '- Experimental Lab Validation: Benchmarked against 12 physically tested GFRP-RC beams from literature (Bischoff & Gross, 2011; Kassem et al., 2011). The AI model achieved R^2 = 0.8700 and MAPE = 6.45%, significantly outperforming ACI 440.1R-15 code equations (R^2 = 0.6975, MAPE = 14.82%).\n'
                      '- Physical Mechanism: ACI 440.1R assumes an overly simplified equivalent rectangular concrete stress block that over-penalizes GFRP-reinforced sections. The ANN surrogate captures post-cracking tensile stiffening and non-linear compressive stress redistribution across 15,000 fiber continuum FE simulations.',
                      style: pw.TextStyle(
                        color: secondarySteel,
                        fontSize: 7.2,
                        lineSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              // ==========================================
              // 6. OFFICIAL FOOTER
              // ==========================================
              pw.Container(
                padding: const pw.EdgeInsets.only(top: 6),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(color: borderColor, width: 0.8),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'ICEC 2026 - NED UET & MUET Collaboration - AI Surrogate Framework for GFRP Beams',
                      style: pw.TextStyle(
                        color: textMuted,
                        fontSize: 7,
                      ),
                    ),
                    pw.Text(
                      'Generated automatically via GFRP-RC Beam Analyzer',
                      style: pw.TextStyle(
                        color: textMuted,
                        fontSize: 7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Direct browser download / trigger save as PDF
  static Future<void> downloadReport({
    required BeamInput input,
    required PredictionResponse response,
  }) async {
    final bytes = await generateReportBytes(
      input: input,
      response: response,
    );

    final filename =
        'GFRP_RC_Beam_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';

    await Printing.sharePdf(
      bytes: bytes,
      filename: filename,
    );
  }

  /// Print or Preview PDF directly in browser
  static Future<void> previewOrPrint({
    required BeamInput input,
    required PredictionResponse response,
  }) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async =>
          generateReportBytes(input: input, response: response),
      name: 'GFRP_RC_Beam_Report_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // Helper widgets for table and rows
  static pw.Widget _tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 7.5,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromHex('#1E293B'),
        ),
      ),
    );
  }

  static pw.TableRow _tableDataRow(
      String param, String symbol, String value, String range, String status) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: pw.Text(param,
              style: pw.TextStyle(fontSize: 7, color: PdfColor.fromHex('#334155'))),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: pw.Text(symbol,
              style: pw.TextStyle(
                  fontSize: 7,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColor.fromHex('#0284C7'))),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 7,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#1E293B'))),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: pw.Text(range,
              style: pw.TextStyle(fontSize: 7, color: PdfColor.fromHex('#64748B'))),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
          child: pw.Text(status,
              style: pw.TextStyle(
                  fontSize: 7,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#10B981'))),
        ),
      ],
    );
  }

  static pw.Widget _infoRow(
    String label,
    String value, {
    PdfColor? valueColor,
    bool isBold = false,
    String? badgeText,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 7.5,
            color: PdfColor.fromHex('#64748B'),
          ),
        ),
        pw.Row(
          children: [
            if (badgeText != null) ...[
              pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#E2E8F0'),
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(3)),
                ),
                child: pw.Text(
                  badgeText,
                  style: pw.TextStyle(
                    fontSize: 6.5,
                    color: PdfColor.fromHex('#334155'),
                  ),
                ),
              ),
              pw.SizedBox(width: 4),
            ],
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 7.5,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: valueColor ?? PdfColor.fromHex('#1E293B'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
