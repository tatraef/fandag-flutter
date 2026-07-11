import 'dart:io';

import 'package:mad_scripts_base/mad_scripts_base.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'generate_theme_colors_command.dart';

/// Adds a new semantic color to theme_colors.yaml and regenerates
/// theme_colors.dart
class AddThemeColorCommand extends ScriptCommand<void> {
  AddThemeColorCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Semantic color name (camelCase, e.g., "buttonPrimary")',
        mandatory: true,
      )
      ..addOption(
        'doc',
        abbr: 'd',
        help: 'Documentation string (e.g., "Primary button background")',
        mandatory: true,
      )
      ..addOption(
        'light',
        abbr: 'l',
        help: 'Light theme color (AppColors name). '
            'Use with --dark for adaptive colors.',
      )
      ..addOption(
        'dark',
        abbr: 'k',
        help: 'Dark theme color (AppColors name). '
            'Use with --light for adaptive colors.',
      )
      ..addOption(
        'value',
        abbr: 'v',
        help: 'Static color (AppColors name). '
            'Use for non-adaptive colors.',
      );
  }

  @override
  String get name => 'add-theme-color';

  @override
  String get description =>
      'Add a new semantic color to theme_colors.yaml '
      'and regenerate theme_colors.dart';

  @override
  Future<void> runWrapped() async {
    final colorName = argResults!['name'] as String;
    final doc = argResults!['doc'] as String;
    final light = argResults!['light'] as String?;
    final dark = argResults!['dark'] as String?;
    final value = argResults!['value'] as String?;

    // Validate inputs
    if (!RegExp(r'^[a-z][a-zA-Z0-9]*$').hasMatch(colorName)) {
      output.error('Color name must be camelCase (e.g., "buttonPrimary")');
      throw UsageException('Invalid color name', usage);
    }

    // Must provide either (light + dark) OR value, not both
    final isAdaptive = light != null && dark != null;
    final isStatic = value != null;

    if (!isAdaptive && !isStatic) {
      output.error('Must provide either (--light AND --dark) OR --value');
      throw UsageException('Missing color values', usage);
    }

    if (isAdaptive && isStatic) {
      output.error('Cannot provide both (--light/--dark) AND --value');
      throw UsageException('Conflicting color values', usage);
    }

    // Paths
    final projectRoot = Directory.current.path;
    final configPath = path.join(
      projectRoot,
      'tools',
      'template_scripts',
      'config',
      'theme_colors.yaml',
    );

    // Read YAML
    final configFile = File(configPath);
    if (!configFile.existsSync()) {
      output.error('Config file not found: $configPath');
      return;
    }

    final yamlString = await configFile.readAsString();
    final yaml = loadYaml(yamlString) as YamlMap;
    final colors = yaml['colors'] as YamlMap;

    // Check if color already exists
    if (colors.containsKey(colorName)) {
      output.error('Color "$colorName" already exists');
      return;
    }

    // Build new YAML content
    final buffer = StringBuffer();
    buffer.writeln('# Flutter Template v3 Theme Colors');
    buffer.writeln('# Semantic, theme-aware color definitions');
    buffer.writeln();
    buffer.writeln('colors:');

    // Write existing colors
    for (final colorEntry in colors.entries) {
      final name = colorEntry.key as String;
      final colorData = colorEntry.value as YamlMap;
      final colorDoc = colorData['doc'] as String;
      final colorLight = colorData['light'] as String?;
      final colorDark = colorData['dark'] as String?;
      final colorValue = colorData['value'] as String?;

      buffer.writeln('  $name:');
      if (colorLight != null && colorDark != null) {
        buffer.writeln('    light: $colorLight');
        buffer.writeln('    dark: $colorDark');
      } else if (colorValue != null) {
        buffer.writeln('    value: $colorValue');
      }
      buffer.writeln('    doc: "$colorDoc"');
      buffer.writeln();
    }

    // Add new color at the end
    buffer.writeln('  $colorName:');
    if (isAdaptive) {
      buffer.writeln('    light: $light');
      buffer.writeln('    dark: $dark');
    } else {
      buffer.writeln('    value: $value');
    }
    buffer.writeln('    doc: "$doc"');

    // Write updated YAML
    await configFile.writeAsString(buffer.toString());

    if (isAdaptive) {
      output.success('Added adaptive color "$colorName"');
      output.info('Light: AppColors.$light');
      output.info('Dark: AppColors.$dark');
    } else {
      output.success('Added static color "$colorName"');
      output.info('Value: AppColors.$value');
    }
    output.info('Doc: $doc');
    output.info('');

    // Regenerate theme_colors.dart
    output.info('Regenerating theme_colors.dart...');
    final generateCommand = GenerateThemeColorsCommand();
    await generateCommand.runWrapped();
  }
}
