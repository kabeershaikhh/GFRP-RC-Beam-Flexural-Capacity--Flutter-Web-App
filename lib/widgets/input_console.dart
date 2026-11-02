import 'package:flutter/material.dart';
import '../models/bar_spec.dart';
import '../models/beam_input.dart';
import '../theme/app_theme.dart';
import 'preset_chips.dart';

class InputConsole extends StatefulWidget {
  final BeamInput initialInput;
  final bool isLoading;
  final ValueChanged<BeamInput> onCalculate;
  final ValueChanged<BeamInput>? onInputChange;

  const InputConsole({
    super.key,
    required this.initialInput,
    required this.isLoading,
    required this.onCalculate,
    this.onInputChange,
  });

  @override
  State<InputConsole> createState() => _InputConsoleState();
}

class _InputConsoleState extends State<InputConsole> {
  final _formKey = GlobalKey<FormState>();

  // State values
  late double _bMm;
  late double _hMm;
  late double _coverMm;
  late double _fcMpa;
  late double _efGpa;
  late double _ffuMpa;
  late BarSpec _selectedBar;
  late int _nBars;

  // Controllers
  late TextEditingController _bController;
  late TextEditingController _hController;
  late TextEditingController _coverController;
  late TextEditingController _fcController;
  late TextEditingController _efController;
  late TextEditingController _ffuController;

  PresetType? _activePreset = PresetType.standard;

  @override
  void initState() {
    super.initState();
    _initFromInput(widget.initialInput);
  }

  void _initFromInput(BeamInput input) {
    _bMm = input.bMm;
    _hMm = input.hMm;
    _coverMm = input.coverMm;
    _fcMpa = input.fcMpa;
    _efGpa = input.efGpa;
    _ffuMpa = input.ffuMpa;
    _selectedBar = BarSpec.fromDiameter(input.barDiaMm);
    _nBars = input.nBars;

    _bController = TextEditingController(text: _bMm.toStringAsFixed(0));
    _hController = TextEditingController(text: _hMm.toStringAsFixed(0));
    _coverController = TextEditingController(text: _coverMm.toStringAsFixed(0));
    _fcController = TextEditingController(text: _fcMpa.toStringAsFixed(0));
    _efController = TextEditingController(text: _efGpa.toStringAsFixed(0));
    _ffuController = TextEditingController(text: _ffuMpa.toStringAsFixed(0));
  }

  void _applyPreset(BeamInput preset, PresetType type) {
    setState(() {
      _activePreset = type;
      _bMm = preset.bMm;
      _hMm = preset.hMm;
      _coverMm = preset.coverMm;
      _fcMpa = preset.fcMpa;
      _efGpa = preset.efGpa;
      _ffuMpa = preset.ffuMpa;
      _selectedBar = BarSpec.fromDiameter(preset.barDiaMm);
      _nBars = preset.nBars;

      _bController.text = _bMm.toStringAsFixed(0);
      _hController.text = _hMm.toStringAsFixed(0);
      _coverController.text = _coverMm.toStringAsFixed(0);
      _fcController.text = _fcMpa.toStringAsFixed(0);
      _efController.text = _efGpa.toStringAsFixed(0);
      _ffuController.text = _ffuMpa.toStringAsFixed(0);
    });
    _formKey.currentState?.validate();
    _notifyParent();
  }

  BeamInput _getCurrentInput() {
    return BeamInput(
      bMm: _bMm,
      hMm: _hMm,
      coverMm: _coverMm,
      fcMpa: _fcMpa,
      efGpa: _efGpa,
      ffuMpa: _ffuMpa,
      barDiaMm: _selectedBar.diameterMm,
      nBars: _nBars,
    );
  }

  void _notifyParent() {
    widget.onInputChange?.call(_getCurrentInput());
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onCalculate(_getCurrentInput());
    }
  }

  @override
  void dispose() {
    _bController.dispose();
    _hController.dispose();
    _coverController.dispose();
    _fcController.dispose();
    _efController.dispose();
    _ffuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Section: Title & Presets
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlueLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: AppTheme.accentBlue,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Input Console',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primarySteel,
                  ),
                ),
                const SizedBox(width: 8),
                const Spacer(),
                const Flexible(
                  child: Text(
                    '8 Parameters',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppTheme.mutedSlate,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Quick-Test Presets Chips
            PresetChips(
              activePreset: _activePreset,
              onSelectPreset: (preset) {
                if (preset.bMm == 250.0 && preset.nBars == 4) {
                  _applyPreset(preset, PresetType.standard);
                } else if (preset.bMm == 350.0 && preset.nBars == 6) {
                  _applyPreset(preset, PresetType.heavyGirder);
                } else {
                  _applyPreset(preset, PresetType.tensionControlled);
                }
              },
            ),

            const SizedBox(height: 20),
            const Divider(color: AppTheme.borderSlate, height: 1),
            const SizedBox(height: 16),

            // Group A: Cross-Section Geometry
            _buildGroupHeader('1. Cross-Section Geometry', Icons.straighten),
            const SizedBox(height: 12),
            _buildSliderWithBox(
              label: 'Beam Width (b)',
              unit: 'mm',
              min: 150.0,
              max: 400.0,
              step: 10.0,
              value: _bMm,
              controller: _bController,
              onChanged: (val) {
                setState(() {
                  _bMm = val;
                  _activePreset = null;
                });
                _notifyParent();
              },
              validator: (val) {
                final n = double.tryParse(val ?? '');
                if (n == null || n < 150.0 || n > 400.0) {
                  return '150 - 400 mm';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildSliderWithBox(
              label: 'Total Depth (h)',
              unit: 'mm',
              min: 300.0,
              max: 900.0,
              step: 25.0,
              value: _hMm,
              controller: _hController,
              onChanged: (val) {
                setState(() {
                  _hMm = val;
                  _activePreset = null;
                });
                _notifyParent();
              },
              validator: (val) {
                final n = double.tryParse(val ?? '');
                if (n == null || n < 300.0 || n > 900.0) {
                  return '300 - 900 mm';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildCoverSelector(),

            const SizedBox(height: 20),
            const Divider(color: AppTheme.borderSlate, height: 1),
            const SizedBox(height: 16),

            // Group B: Concrete Material
            _buildGroupHeader('2. Concrete Material Properties', Icons.layers),
            const SizedBox(height: 12),
            _buildSliderWithBox(
              label: "Compressive Strength (f'c)",
              unit: 'MPa',
              min: 20.0,
              max: 55.0,
              step: 1.0,
              value: _fcMpa,
              controller: _fcController,
              onChanged: (val) {
                setState(() {
                  _fcMpa = val;
                  _activePreset = null;
                });
                _notifyParent();
              },
              validator: (val) {
                final n = double.tryParse(val ?? '');
                if (n == null || n < 20.0 || n > 55.0) {
                  return '20 - 55 MPa';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),
            const Divider(color: AppTheme.borderSlate, height: 1),
            const SizedBox(height: 16),

            // Group C: GFRP Reinforcement
            _buildGroupHeader('3. GFRP Reinforcement Specifications', Icons.grid_view),
            const SizedBox(height: 12),
            _buildBarSizeDropdown(),
            const SizedBox(height: 12),
            _buildBarsStepSelector(),
            const SizedBox(height: 12),
            _buildSliderWithBox(
              label: 'Elastic Modulus (Ef)',
              unit: 'GPa',
              min: 40.0,
              max: 65.0,
              step: 1.0,
              value: _efGpa,
              controller: _efController,
              onChanged: (val) {
                setState(() {
                  _efGpa = val;
                  _activePreset = null;
                });
                _notifyParent();
              },
              validator: (val) {
                final n = double.tryParse(val ?? '');
                if (n == null || n < 40.0 || n > 65.0) {
                  return '40 - 65 GPa';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildSliderWithBox(
              label: 'Tensile Strength (ffu)',
              unit: 'MPa',
              min: 700.0,
              max: 900.0,
              step: 10.0,
              value: _ffuMpa,
              controller: _ffuController,
              onChanged: (val) {
                setState(() {
                  _ffuMpa = val;
                  _activePreset = null;
                });
                _notifyParent();
              },
              validator: (val) {
                final n = double.tryParse(val ?? '');
                if (n == null || n < 700.0 || n > 900.0) {
                  return '700 - 900 MPa';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Primary Action Button
            ElevatedButton(
              onPressed: widget.isLoading ? null : _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentBlue,
                disabledBackgroundColor: AppTheme.accentBlue.withValues(alpha: 0.6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: widget.isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Evaluating AI Model & ACI 440...',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt, size: 20, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'CALCULATE CAPACITIES',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.accentBlue),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppTheme.primarySteel,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSliderWithBox({
    required String label,
    required String unit,
    required double min,
    required double max,
    required double step,
    required double value,
    required TextEditingController controller,
    required ValueChanged<double> onChanged,
    required FormFieldValidator<String> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondarySteel,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 85,
              height: 36,
              child: TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primarySteel,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  suffixText: unit,
                  suffixStyle: const TextStyle(fontSize: 11, color: AppTheme.mutedSlate),
                  isDense: true,
                ),
                validator: validator,
                onChanged: (text) {
                  final parsed = double.tryParse(text);
                  if (parsed != null && parsed >= min && parsed <= max) {
                    onChanged(parsed);
                  }
                },
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: ((max - min) / step).round(),
          label: '${value.toStringAsFixed(0)} $unit',
          onChanged: (newVal) {
            controller.text = newVal.toStringAsFixed(0);
            onChanged(newVal);
          },
        ),
      ],
    );
  }

  Widget _buildCoverSelector() {
    const covers = [20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 60.0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clear Cover (to stirrup)',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondarySteel,
                ),
              ),
              Text(
                'Range: 20 – 60 mm',
                style: TextStyle(fontSize: 11, color: AppTheme.mutedSlate),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderSlate),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<double>(
              value: covers.contains(_coverMm) ? _coverMm : 35.0,
              items: covers.map((c) {
                return DropdownMenuItem<double>(
                  value: c,
                  child: Text(
                    '${c.toStringAsFixed(0)} mm',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primarySteel,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _coverMm = val;
                    _coverController.text = val.toStringAsFixed(0);
                    _activePreset = null;
                  });
                  _notifyParent();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarSizeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'GFRP Bar Size (ASTM)',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.secondarySteel,
              ),
            ),
            Text(
              '#3 to #8 Standard',
              style: TextStyle(fontSize: 11, color: AppTheme.mutedSlate),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderSlate),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BarSpec>(
              value: _selectedBar,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: AppTheme.secondarySteel),
              items: BarSpec.standardCatalog.map((bar) {
                return DropdownMenuItem<BarSpec>(
                  value: bar,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bar.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primarySteel,
                        ),
                      ),
                      Text(
                        'Ab = ${bar.areaMm2.toStringAsFixed(1)} mm²',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppTheme.mutedSlate,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedBar = val;
                    _activePreset = null;
                  });
                  _notifyParent();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarsStepSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Number of Bottom Bars (n)',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondarySteel,
                ),
              ),
              Text(
                'Integer count: 2 to 8 bars',
                style: TextStyle(fontSize: 11, color: AppTheme.mutedSlate),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderSlate),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 16),
                color: _nBars > 2 ? AppTheme.primarySteel : AppTheme.borderSlate,
                splashRadius: 18,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: _nBars > 2
                    ? () {
                        setState(() {
                          _nBars--;
                          _activePreset = null;
                        });
                        _notifyParent();
                      }
                    : null,
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 36),
                alignment: Alignment.center,
                child: Text(
                  '$_nBars',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primarySteel,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 16),
                color: _nBars < 8 ? AppTheme.primarySteel : AppTheme.borderSlate,
                splashRadius: 18,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: _nBars < 8
                    ? () {
                        setState(() {
                          _nBars++;
                          _activePreset = null;
                        });
                        _notifyParent();
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
