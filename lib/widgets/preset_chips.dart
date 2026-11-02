import 'package:flutter/material.dart';
import '../models/beam_input.dart';
import '../theme/app_theme.dart';

enum PresetType {
  standard,
  heavyGirder,
  tensionControlled,
}

class PresetChips extends StatelessWidget {
  final PresetType? activePreset;
  final ValueChanged<BeamInput> onSelectPreset;

  const PresetChips({
    super.key,
    required this.activePreset,
    required this.onSelectPreset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.flash_on, size: 16, color: AppTheme.accentBlue),
            const SizedBox(width: 6),
            const Text(
              'Quick-Test Presets',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondarySteel,
                letterSpacing: 0.2,
              ),
            ),
            const Spacer(),
            Text(
              '1-Click Demo Fill',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.mutedSlate.withValues(alpha: 0.85),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChip(
              label: 'Standard Beam',
              subtitle: '250×500 mm | 4 #5 | 35 MPa',
              isActive: activePreset == PresetType.standard,
              onTap: () => onSelectPreset(BeamInput.presetStandard()),
            ),
            _buildChip(
              label: 'Heavy Girder',
              subtitle: '350×750 mm | 6 #7 | 45 MPa',
              isActive: activePreset == PresetType.heavyGirder,
              onTap: () => onSelectPreset(BeamInput.presetHeavyGirder()),
            ),
            _buildChip(
              label: 'Tension-Controlled',
              subtitle: '200×400 mm | 2 #3 | 50 MPa',
              isActive: activePreset == PresetType.tensionControlled,
              onTap: () => onSelectPreset(BeamInput.presetTensionControlled()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required String subtitle,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.accentBlueLight : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppTheme.accentBlue : AppTheme.cardBorder,
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: AppTheme.accentBlue.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? Icons.check_circle : Icons.bookmark_outline,
                  size: 13,
                  color: isActive ? AppTheme.accentBlue : AppTheme.mutedSlate,
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? AppTheme.accentBlue : AppTheme.primarySteel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.5,
                color: isActive ? AppTheme.secondarySteel : AppTheme.mutedSlate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
