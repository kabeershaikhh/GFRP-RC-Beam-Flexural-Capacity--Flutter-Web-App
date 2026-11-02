/// Beam design input parameters sent from Flutter to the FastAPI backend.
class BeamInput {
  final double bMm;       // Beam width in mm (150.0 - 400.0)
  final double hMm;       // Total beam depth in mm (300.0 - 900.0)
  final double coverMm;   // Clear cover to stirrups in mm (20.0 - 60.0)
  final double fcMpa;     // Concrete compressive strength f'c in MPa (20.0 - 55.0)
  final double efGpa;     // GFRP tensile elastic modulus Ef in GPa (40.0 - 65.0)
  final double ffuMpa;    // GFRP ultimate tensile strength ffu in MPa (700.0 - 900.0)
  final double barDiaMm;  // Bar diameter in mm (6.0 - 30.0)
  final int nBars;        // Number of tensile bottom bars (2 - 8)

  const BeamInput({
    required this.bMm,
    required this.hMm,
    required this.coverMm,
    required this.fcMpa,
    required this.efGpa,
    required this.ffuMpa,
    required this.barDiaMm,
    required this.nBars,
  });

  /// Default engineering input baseline (Standard Beam)
  factory BeamInput.standardDefault() {
    return const BeamInput(
      bMm: 250.0,
      hMm: 500.0,
      coverMm: 35.0,
      fcMpa: 35.0,
      efGpa: 50.0,
      ffuMpa: 800.0,
      barDiaMm: 15.88, // #5 bar
      nBars: 4,
    );
  }

  /// Preset 1: Standard Beam (#5 bars, 4 bars, fc=35 MPa)
  factory BeamInput.presetStandard() {
    return const BeamInput(
      bMm: 250.0,
      hMm: 500.0,
      coverMm: 35.0,
      fcMpa: 35.0,
      efGpa: 50.0,
      ffuMpa: 800.0,
      barDiaMm: 15.88,
      nBars: 4,
    );
  }

  /// Preset 2: Heavy Girder (#7 bars, 6 bars, fc=45 MPa)
  factory BeamInput.presetHeavyGirder() {
    return const BeamInput(
      bMm: 350.0,
      hMm: 750.0,
      coverMm: 40.0,
      fcMpa: 45.0,
      efGpa: 55.0,
      ffuMpa: 850.0,
      barDiaMm: 22.23, // #7 bar
      nBars: 6,
    );
  }

  /// Preset 3: Tension-Controlled (#3 bars, 2 bars, fc=50 MPa)
  factory BeamInput.presetTensionControlled() {
    return const BeamInput(
      bMm: 200.0,
      hMm: 400.0,
      coverMm: 30.0,
      fcMpa: 50.0,
      efGpa: 45.0,
      ffuMpa: 750.0,
      barDiaMm: 9.53, // #3 bar
      nBars: 2,
    );
  }

  /// Converts the model to the exact JSON payload expected by FastAPI `/predict`
  Map<String, dynamic> toJson() {
    return {
      'b_mm': bMm,
      'h_mm': hMm,
      'cover_mm': coverMm,
      'fc_MPa': fcMpa,
      'Ef_GPa': efGpa,
      'ffu_MPa': ffuMpa,
      'bar_dia_mm': barDiaMm,
      'n_bars': nBars,
    };
  }

  factory BeamInput.fromJson(Map<String, dynamic> json) {
    return BeamInput(
      bMm: (json['b_mm'] as num).toDouble(),
      hMm: (json['h_mm'] as num).toDouble(),
      coverMm: (json['cover_mm'] as num).toDouble(),
      fcMpa: (json['fc_MPa'] as num).toDouble(),
      efGpa: (json['Ef_GPa'] as num).toDouble(),
      ffuMpa: (json['ffu_MPa'] as num).toDouble(),
      barDiaMm: (json['bar_dia_mm'] as num).toDouble(),
      nBars: (json['n_bars'] as num).toInt(),
    );
  }

  BeamInput copyWith({
    double? bMm,
    double? hMm,
    double? coverMm,
    double? fcMpa,
    double? efGpa,
    double? ffuMpa,
    double? barDiaMm,
    int? nBars,
  }) {
    return BeamInput(
      bMm: bMm ?? this.bMm,
      hMm: hMm ?? this.hMm,
      coverMm: coverMm ?? this.coverMm,
      fcMpa: fcMpa ?? this.fcMpa,
      efGpa: efGpa ?? this.efGpa,
      ffuMpa: ffuMpa ?? this.ffuMpa,
      barDiaMm: barDiaMm ?? this.barDiaMm,
      nBars: nBars ?? this.nBars,
    );
  }

  /// Pre-transmission validation against engineering parameter limits
  List<String> validate() {
    final errors = <String>[];
    if (bMm < 150.0 || bMm > 400.0) {
      errors.add('Beam width b must be between 150 and 400 mm.');
    }
    if (hMm < 300.0 || hMm > 900.0) {
      errors.add('Total depth h must be between 300 and 900 mm.');
    }
    if (coverMm < 20.0 || coverMm > 60.0) {
      errors.add('Clear cover must be between 20 and 60 mm.');
    }
    if (fcMpa < 20.0 || fcMpa > 55.0) {
      errors.add("Concrete f'c must be between 20 and 55 MPa.");
    }
    if (efGpa < 40.0 || efGpa > 65.0) {
      errors.add('Modulus Ef must be between 40 and 65 GPa.');
    }
    if (ffuMpa < 700.0 || ffuMpa > 900.0) {
      errors.add('Tensile strength ffu must be between 700 and 900 MPa.');
    }
    if (barDiaMm < 6.0 || barDiaMm > 30.0) {
      errors.add('Bar diameter must be between 6.0 and 30.0 mm.');
    }
    if (nBars < 2 || nBars > 8) {
      errors.add('Number of bars must be an integer between 2 and 8.');
    }
    return errors;
  }
}
