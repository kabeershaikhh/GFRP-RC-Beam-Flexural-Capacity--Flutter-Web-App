/// ASTM Standard GFRP Bar Specification
class BarSpec {
  final String designation; // e.g., "#3"
  final double diameterMm;   // Nominal diameter in mm
  final double areaMm2;      // Nominal cross-sectional area in mm^2

  const BarSpec({
    required this.designation,
    required this.diameterMm,
    required this.areaMm2,
  });

  String get label => '$designation (${diameterMm.toStringAsFixed(2)} mm)';

  /// Standard ASTM sizes from #3 to #8 as specified in ICEC 2026 specs
  static const List<BarSpec> standardCatalog = [
    BarSpec(designation: '#3', diameterMm: 9.53, areaMm2: 71.3),
    BarSpec(designation: '#4', diameterMm: 12.70, areaMm2: 126.7),
    BarSpec(designation: '#5', diameterMm: 15.88, areaMm2: 197.9),
    BarSpec(designation: '#6', diameterMm: 19.05, areaMm2: 285.0),
    BarSpec(designation: '#7', diameterMm: 22.23, areaMm2: 387.9),
    BarSpec(designation: '#8', diameterMm: 25.40, areaMm2: 506.7),
  ];

  /// Find closest bar specification by diameter in mm
  static BarSpec fromDiameter(double dia) {
    BarSpec closest = standardCatalog.first;
    double minDiff = (closest.diameterMm - dia).abs();
    for (final bar in standardCatalog) {
      final diff = (bar.diameterMm - dia).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = bar;
      }
    }
    return closest;
  }
}
