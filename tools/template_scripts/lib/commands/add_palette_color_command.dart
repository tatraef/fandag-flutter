import 'dart:io';

import 'package:mad_scripts_base/mad_scripts_base.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'generate_palette_command.dart';

/// Adds a new color to palette_colors.yaml and regenerates app_colors.dart
class AddPaletteColorCommand extends ScriptCommand<void> {
  AddPaletteColorCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Color name (camelCase, e.g., "coralLight")',
        mandatory: true,
      )
      ..addOption(
        'hex',
        abbr: 'x',
        help: 'Color hex value (8 digits with alpha, e.g., "FFFF0000")',
        mandatory: true,
      )
      ..addOption(
        'doc',
        abbr: 'd',
        help: 'Documentation string (e.g., "Light coral")',
        mandatory: true,
      )
      ..addOption(
        'section',
        abbr: 's',
        help:
            'Section name (e.g., "Semantic"). If not provided, uses "Custom".',
      );
  }

  @override
  String get name => 'add-palette-color';

  @override
  String get description =>
      'Add a new color to palette_colors.yaml and regenerate app_colors.dart';

  @override
  Future<void> runWrapped() async {
    final colorName = argResults!['name'] as String;
    final hex = argResults!['hex'] as String;
    final doc = argResults!['doc'] as String;
    final sectionName = argResults!['section'] as String?;

    // Validate inputs
    if (!RegExp(r'^[a-z][a-zA-Z0-9]*$').hasMatch(colorName)) {
      output.error('Color name must be camelCase (e.g., "coralLight")');
      throw UsageException('Invalid color name', usage);
    }

    if (!RegExp(r'^[0-9A-F]{8}$').hasMatch(hex)) {
      output.error('Hex must be 8 uppercase hex digits (e.g., "FFFF0000")');
      throw UsageException('Invalid hex format', usage);
    }

    // Paths
    final projectRoot = Directory.current.path;
    final configPath = path.join(
      projectRoot,
      'tools',
      'template_scripts',
      'config',
      'palette_colors.yaml',
    );

    // Read YAML
    final configFile = File(configPath);
    if (!configFile.existsSync()) {
      output.error('Config file not found: $configPath');
      return;
    }

    final yamlString = await configFile.readAsString();
    final yaml = loadYaml(yamlString) as YamlMap;
    final sections = yaml['sections'] as YamlMap;

    // Check if color already exists
    for (final sectionEntry in sections.entries) {
      final colors = sectionEntry.value as YamlMap;
      if (colors.containsKey(colorName)) {
        output.error(
          'Color "$colorName" already exists '
          'in section "${sectionEntry.key}"',
        );
        return;
      }
    }

    // Determine target section
    final targetSection = sectionName ?? 'Custom';

    // Build new YAML content
    final buffer = StringBuffer();
    buffer.writeln('# Fandag Color Palette');
    buffer.writeln('# Generated color constants for AppColors class');
    buffer.writeln();
    buffer.writeln('sections:');

    var colorAdded = false;

    for (final sectionEntry in sections.entries) {
      final currentSection = sectionEntry.key as String;
      final colors = sectionEntry.value as YamlMap;

      buffer.writeln('  $currentSection:');

      // Write existing colors in this section
      for (final colorEntry in colors.entries) {
        final name = colorEntry.key as String;
        final colorData = colorEntry.value as YamlMap;
        final colorHex = colorData['hex'] as String;
        final colorDoc = colorData['doc'] as String;

        buffer.writeln('    $name:');
        buffer.writeln('      hex: "$colorHex"');
        buffer.writeln('      doc: "$colorDoc"');
      }

      // If this is the target section, add the new color
      if (currentSection == targetSection) {
        buffer.writeln('    $colorName:');
        buffer.writeln('      hex: "$hex"');
        buffer.writeln('      doc: "$doc"');
        colorAdded = true;
      }

      buffer.writeln();
    }

    // If section doesn't exist, create it
    if (!colorAdded) {
      buffer.writeln('  $targetSection:');
      buffer.writeln('    $colorName:');
      buffer.writeln('      hex: "$hex"');
      buffer.writeln('      doc: "$doc"');
      buffer.writeln();
    }

    // Write updated YAML
    await configFile.writeAsString(buffer.toString());

    output.success('Added color "$colorName" to section "$targetSection"');
    output.info('Hex: #$hex');
    output.info('Doc: $doc');
    output.info('');

    // Regenerate app_colors.dart
    output.info('Regenerating app_colors.dart...');
    final generateCommand = GeneratePaletteCommand();
    await generateCommand.runWrapped();
  }
}
