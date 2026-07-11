import 'dart:io';

import 'package:mad_scripts_base/mad_scripts_base.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

/// Regenerates lib/core/theme/primary_fonts.dart from config/fonts.yaml
class GenerateFontsCommand extends ScriptCommand<void> {
  @override
  String get name => 'generate-fonts';

  @override
  String get description => 'Regenerate primary_fonts.dart from fonts.yaml';

  @override
  Future<void> runWrapped() async {
    // Paths
    final projectRoot = Directory.current.path;
    final configPath = path.join(
      projectRoot,
      'tools',
      'template_scripts',
      'config',
      'fonts.yaml',
    );
    final outputPath =
        path.join(projectRoot, 'lib', 'core', 'theme', 'primary_fonts.dart');

    // Read YAML
    final configFile = File(configPath);
    if (!configFile.existsSync()) {
      output.error('Config file not found: $configPath');
      return;
    }

    final yamlString = await configFile.readAsString();
    final yaml = loadYaml(yamlString) as YamlMap;
    final styles = yaml['styles'] as YamlMap;

    // Parse styles into structured data
    final styleEntries = <_StyleEntry>[];
    for (final entry in styles.entries) {
      final name = entry.key as String;
      final data = entry.value as YamlMap;
      styleEntries.add(_StyleEntry(
        name: name,
        size: data['size'] as int,
        weight: data['weight'] as int,
        doc: data['doc'] as String,
      ));
    }

    // Collect unique font sizes (sorted)
    final uniqueSizes = styleEntries.map((s) => s.size).toSet().toList()..sort();

    // Generate Dart code
    final buffer = StringBuffer();

    _writeHeader(buffer);
    _writeConstructor(buffer, styleEntries);
    _writeFields(buffer, styleEntries);
    _writeSizeConstants(buffer, uniqueSizes);
    _writeInstance(buffer, styleEntries);
    _writeCopyWith(buffer, styleEntries);
    _writeLerp(buffer, styleEntries);

    buffer.writeln('}');

    // Write to file
    final outputFile = File(outputPath);
    await outputFile.writeAsString(buffer.toString());

    output.success(
      'Generated primary_fonts.dart (${styleEntries.length} styles)',
    );
    output.info('Output: $outputPath');
  }

  void _writeHeader(StringBuffer buffer) {
    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln();
    buffer.writeln(
      'class PrimaryThemeFonts extends ThemeExtension<PrimaryThemeFonts> {',
    );
  }

  void _writeConstructor(StringBuffer buffer, List<_StyleEntry> styles) {
    buffer.writeln('  const PrimaryThemeFonts({');
    for (final style in styles) {
      buffer.writeln('    required this.${style.name},');
    }
    buffer.writeln('  });');
    buffer.writeln();
  }

  void _writeFields(StringBuffer buffer, List<_StyleEntry> styles) {
    for (final style in styles) {
      buffer.writeln('  final TextStyle ${style.name};');
    }
    buffer.writeln();
  }

  void _writeSizeConstants(StringBuffer buffer, List<int> sizes) {
    for (final size in sizes) {
      buffer.writeln(
        '  static const double _fontSize$size = $size;',
      );
    }
    buffer.writeln();
  }

  void _writeInstance(StringBuffer buffer, List<_StyleEntry> styles) {
    buffer.writeln('  static const PrimaryThemeFonts instance = PrimaryThemeFonts(');
    for (final style in styles) {
      buffer.writeln(
        '    ${style.name}: TextStyle('
        'fontSize: _fontSize${style.size}, '
        'fontWeight: FontWeight.w${style.weight}),',
      );
    }
    buffer.writeln('  );');
    buffer.writeln();
  }

  void _writeCopyWith(StringBuffer buffer, List<_StyleEntry> styles) {
    buffer.writeln('  @override');
    buffer.writeln('  PrimaryThemeFonts copyWith({');
    for (final style in styles) {
      buffer.writeln('    TextStyle? ${style.name},');
    }
    buffer.writeln('  }) {');
    buffer.writeln('    return PrimaryThemeFonts(');
    for (final style in styles) {
      buffer.writeln(
        '      ${style.name}: ${style.name} ?? this.${style.name},',
      );
    }
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln();
  }

  void _writeLerp(StringBuffer buffer, List<_StyleEntry> styles) {
    buffer.writeln('  @override');
    buffer.writeln(
      '  PrimaryThemeFonts lerp(PrimaryThemeFonts? other, double t) {',
    );
    buffer.writeln('    if (other is! PrimaryThemeFonts) {');
    buffer.writeln('      return this;');
    buffer.writeln('    }');
    buffer.writeln();
    buffer.writeln('    return PrimaryThemeFonts(');
    for (final style in styles) {
      buffer.writeln(
        '      ${style.name}: '
        'TextStyle.lerp(${style.name}, other.${style.name}, t)!,',
      );
    }
    buffer.writeln('    );');
    buffer.writeln('  }');
  }
}

/// Represents a font style entry from YAML
class _StyleEntry {
  _StyleEntry({
    required this.name,
    required this.size,
    required this.weight,
    required this.doc,
  });

  final String name;
  final int size;
  final int weight;
  final String doc;
}
