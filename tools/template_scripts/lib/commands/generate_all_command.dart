import 'package:mad_scripts_base/mad_scripts_base.dart';

import 'generate_fonts_command.dart';
import 'generate_palette_command.dart';
import 'generate_theme_colors_command.dart';

/// Regenerates all theme files (palette, theme colors, fonts)
class GenerateAllCommand extends ScriptCommand<void> {
  @override
  String get name => 'generate-all';

  @override
  String get description =>
      'Regenerate all theme files (palette, theme colors, fonts)';

  @override
  Future<void> runWrapped() async {
    output.info('Regenerating all theme files...');
    output.info('');

    // 1. Generate palette
    final paletteCommand = GeneratePaletteCommand();
    await paletteCommand.runWrapped();
    output.info('');

    // 2. Generate theme colors
    final themeColorsCommand = GenerateThemeColorsCommand();
    await themeColorsCommand.runWrapped();
    output.info('');

    // 3. Generate fonts
    final fontsCommand = GenerateFontsCommand();
    await fontsCommand.runWrapped();
    output.info('');

    output.success('All theme files regenerated successfully!');
  }
}
