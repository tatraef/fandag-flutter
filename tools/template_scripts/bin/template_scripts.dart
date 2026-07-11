import 'package:mad_scripts_base/mad_scripts_base.dart';
import 'package:template_scripts/commands/add_font_command.dart';
import 'package:template_scripts/commands/add_palette_color_command.dart';
import 'package:template_scripts/commands/add_theme_color_command.dart';
import 'package:template_scripts/commands/generate_all_command.dart';
import 'package:template_scripts/commands/generate_fonts_command.dart';
import 'package:template_scripts/commands/generate_palette_command.dart';
import 'package:template_scripts/commands/generate_theme_colors_command.dart';
import 'package:template_scripts/commands/scaffold_feature_command.dart';

/// Flutter Template v3 CLI toolkit entry point
void main(List<String> arguments) async {
  final runner = CommandRunner(
    'template_scripts',
    'CLI toolkit for flutter_template_v3 code generation (theme, fonts, feature scaffolding)',
  )
    // Generation commands
    ..addCommand(GeneratePaletteCommand())
    ..addCommand(GenerateThemeColorsCommand())
    ..addCommand(GenerateFontsCommand())
    ..addCommand(GenerateAllCommand())
    // Interactive add commands
    ..addCommand(AddPaletteColorCommand())
    ..addCommand(AddThemeColorCommand())
    ..addCommand(AddFontCommand())
    // Feature scaffolding
    ..addCommand(ScaffoldFeatureCommand());

  await runner.run(arguments);
}
