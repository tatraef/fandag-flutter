import 'dart:io';

import 'package:mad_scripts_base/mad_scripts_base.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

/// Regenerates lib/core/theme/app_colors.dart from config/palette_colors.yaml
class GeneratePaletteCommand extends ScriptCommand<void> {
  @override
  String get name => 'generate-palette';

  @override
  String get description =>
      'Regenerate app_colors.dart from palette_colors.yaml';

  @override
  Future<void> runWrapped() async {
    // Paths
    final projectRoot = Directory.current.path;
    final configPath = path.join(
      projectRoot,
      'tools',
      'template_scripts',
      'config',
      'palette_colors.yaml',
    );
    final outputPath =
        path.join(projectRoot, 'lib', 'core', 'theme', 'app_colors.dart');

    // Read YAML
    final configFile = File(configPath);
    if (!configFile.existsSync()) {
      output.error('Config file not found: $configPath');
      return;
    }

    final yamlString = await configFile.readAsString();
    final yaml = loadYaml(yamlString) as YamlMap;
    final sections = yaml['sections'] as YamlMap;

    // Generate Dart code
    final buffer = StringBuffer();

    // 1. Header
    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln();
    buffer.writeln('abstract class AppColors {');

    // 2. Sections and colors
    int totalColors = 0;
    bool isFirstSection = true;

    for (final sectionEntry in sections.entries) {
      final sectionName = sectionEntry.key as String;
      final colors = sectionEntry.value as YamlMap;

      // Section header
      if (!isFirstSection) {
        buffer.writeln();
      }
      buffer.writeln('  // $sectionName');
      isFirstSection = false;

      // Colors in section
      for (final colorEntry in colors.entries) {
        final colorName = colorEntry.key as String;
        final colorData = colorEntry.value as YamlMap;
        final hex = colorData['hex'] as String;

        buffer
            .writeln('  static const Color $colorName = Color(0x$hex);');

        totalColors++;
      }
    }

    // 3. Class closing
    buffer.writeln('}');

    // Write to file
    final outputFile = File(outputPath);
    await outputFile.writeAsString(buffer.toString());

    output.success(
      'Generated app_colors.dart '
      '($totalColors colors from ${sections.length} sections)',
    );
    output.info('Output: $outputPath');
  }
}
