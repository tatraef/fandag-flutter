import 'dart:io';

import 'package:mad_scripts_base/mad_scripts_base.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'generate_fonts_command.dart';

/// Adds a new font style to fonts.yaml and regenerates primary_fonts.dart
class AddFontCommand extends ScriptCommand<void> {
  AddFontCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Font style name (camelCase, e.g., "semibold28")',
        mandatory: true,
      )
      ..addOption(
        'size',
        abbr: 's',
        help: 'Font size in pixels (e.g., "28")',
        mandatory: true,
      )
      ..addOption(
        'weight',
        abbr: 'w',
        help: 'Font weight (400=regular, 500=medium, 600=semibold, 700=bold)',
        mandatory: true,
      )
      ..addOption(
        'doc',
        abbr: 'd',
        help: 'Documentation string (e.g., "Large headlines")',
        mandatory: true,
      );
  }

  @override
  String get name => 'add-font';

  @override
  String get description =>
      'Add a new font style to fonts.yaml '
      'and regenerate primary_fonts.dart';

  @override
  Future<void> runWrapped() async {
    final styleName = argResults!['name'] as String;
    final sizeStr = argResults!['size'] as String;
    final weightStr = argResults!['weight'] as String;
    final doc = argResults!['doc'] as String;

    // Validate inputs
    if (!RegExp(r'^[a-z][a-zA-Z0-9]*$').hasMatch(styleName)) {
      output.error('Font style name must be camelCase (e.g., "semibold28")');
      throw UsageException('Invalid style name', usage);
    }

    final size = int.tryParse(sizeStr);
    if (size == null || size <= 0) {
      output.error('Size must be a positive integer');
      throw UsageException('Invalid size', usage);
    }

    final weight = int.tryParse(weightStr);
    if (weight == null || ![400, 500, 600, 700].contains(weight)) {
      output.error('Weight must be one of: 400, 500, 600, 700');
      throw UsageException('Invalid weight', usage);
    }

    // Paths
    final projectRoot = Directory.current.path;
    final configPath = path.join(
      projectRoot,
      'tools',
      'template_scripts',
      'config',
      'fonts.yaml',
    );

    // Read YAML
    final configFile = File(configPath);
    if (!configFile.existsSync()) {
      output.error('Config file not found: $configPath');
      return;
    }

    final yamlString = await configFile.readAsString();
    final yaml = loadYaml(yamlString) as YamlMap;
    final styles = yaml['styles'] as YamlMap;

    // Check if style already exists
    if (styles.containsKey(styleName)) {
      output.error('Font style "$styleName" already exists');
      return;
    }

    // Build new YAML content
    final buffer = StringBuffer();
    buffer.writeln('# Flutter Template v3 Typography');
    buffer.writeln('# Font styles for PrimaryThemeFonts');
    buffer.writeln();
    buffer.writeln('styles:');

    // Write existing styles
    for (final styleEntry in styles.entries) {
      final name = styleEntry.key as String;
      final styleData = styleEntry.value as YamlMap;
      final styleSize = styleData['size'] as int;
      final styleWeight = styleData['weight'] as int;
      final styleDoc = styleData['doc'] as String;

      buffer.writeln('  $name:');
      buffer.writeln('    size: $styleSize');
      buffer.writeln('    weight: $styleWeight');
      buffer.writeln('    doc: "$styleDoc"');
      buffer.writeln();
    }

    // Add new style at the end
    buffer.writeln('  $styleName:');
    buffer.writeln('    size: $size');
    buffer.writeln('    weight: $weight');
    buffer.writeln('    doc: "$doc"');

    // Write updated YAML
    await configFile.writeAsString(buffer.toString());

    output.success('Added font style "$styleName"');
    output.info('Size: ${size}px');
    output.info('Weight: $weight');
    output.info('Doc: $doc');
    output.info('');

    // Regenerate primary_fonts.dart
    output.info('Regenerating primary_fonts.dart...');
    final generateCommand = GenerateFontsCommand();
    await generateCommand.runWrapped();
  }
}
