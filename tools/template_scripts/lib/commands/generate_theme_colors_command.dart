import 'dart:io';

import 'package:mad_scripts_base/mad_scripts_base.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

/// Regenerates lib/core/theme/theme_colors.dart from config/theme_colors.yaml
class GenerateThemeColorsCommand extends ScriptCommand<void> {
  @override
  String get name => 'generate-theme-colors';

  @override
  String get description =>
      'Regenerate theme_colors.dart from theme_colors.yaml';

  @override
  Future<void> runWrapped() async {
    // Paths
    final projectRoot = Directory.current.path;
    final configPath = path.join(
      projectRoot,
      'tools',
      'template_scripts',
      'config',
      'theme_colors.yaml',
    );
    final outputPath = path.join(
      projectRoot,
      'lib',
      'core',
      'theme',
      'theme_colors.dart',
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

    // Parse colors into structured data
    final colorEntries = <_ColorEntry>[];
    for (final entry in colors.entries) {
      final name = entry.key as String;
      final data = entry.value as YamlMap;
      final doc = data['doc'] as String;

      if (data.containsKey('light') && data.containsKey('dark')) {
        colorEntries.add(
          _ColorEntry(
            name: name,
            doc: doc,
            light: data['light'] as String,
            dark: data['dark'] as String,
          ),
        );
      } else if (data.containsKey('value')) {
        colorEntries.add(
          _ColorEntry(name: name, doc: doc, value: data['value'] as String),
        );
      }
    }

    // Generate Dart code
    final buffer = StringBuffer();

    _writeHeader(buffer);
    _writeConstructor(buffer, colorEntries);
    _writeFields(buffer, colorEntries);
    _writeLightInstance(buffer, colorEntries);
    _writeDarkInstance(buffer, colorEntries);
    _writeCopyWith(buffer, colorEntries);
    _writeLerp(buffer, colorEntries);

    buffer.writeln('}');

    // Write to file
    final outputFile = File(outputPath);
    await outputFile.writeAsString(buffer.toString());

    output.success(
      'Generated theme_colors.dart (${colorEntries.length} colors)',
    );
    output.info('Output: $outputPath');
  }

  void _writeHeader(StringBuffer buffer) {
    // Alphabetical: `directives_ordering` is an analyzer error for this project,
    // and the generated file is committed.
    buffer.writeln("import 'package:fandag/core/theme/app_colors.dart';");
    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln();
    buffer.writeln('class ThemeColors extends ThemeExtension<ThemeColors> {');
  }

  void _writeConstructor(StringBuffer buffer, List<_ColorEntry> colors) {
    buffer.writeln('  const ThemeColors({');
    for (final color in colors) {
      buffer.writeln('    required this.${color.name},');
    }
    buffer.writeln('  });');
    buffer.writeln();
  }

  void _writeFields(StringBuffer buffer, List<_ColorEntry> colors) {
    for (final color in colors) {
      buffer.writeln('  final Color ${color.name};');
    }
    buffer.writeln();
  }

  void _writeLightInstance(StringBuffer buffer, List<_ColorEntry> colors) {
    buffer.writeln('  static const ThemeColors light = ThemeColors(');
    for (final color in colors) {
      if (color.isAdaptive) {
        buffer.writeln('    ${color.name}: AppColors.${color.light},');
      } else {
        buffer.writeln('    ${color.name}: AppColors.${color.value},');
      }
    }
    buffer.writeln('  );');
    buffer.writeln();
  }

  void _writeDarkInstance(StringBuffer buffer, List<_ColorEntry> colors) {
    buffer.writeln('  static const ThemeColors dark = ThemeColors(');
    for (final color in colors) {
      if (color.isAdaptive) {
        buffer.writeln('    ${color.name}: AppColors.${color.dark},');
      } else {
        buffer.writeln('    ${color.name}: AppColors.${color.value},');
      }
    }
    buffer.writeln('  );');
    buffer.writeln();
  }

  void _writeCopyWith(StringBuffer buffer, List<_ColorEntry> colors) {
    buffer.writeln('  @override');
    buffer.writeln('  ThemeColors copyWith({');
    for (final color in colors) {
      buffer.writeln('    Color? ${color.name},');
    }
    buffer.writeln('  }) {');
    buffer.writeln('    return ThemeColors(');
    for (final color in colors) {
      buffer.writeln(
        '      ${color.name}: ${color.name} ?? this.${color.name},',
      );
    }
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln();
  }

  void _writeLerp(StringBuffer buffer, List<_ColorEntry> colors) {
    buffer.writeln('  @override');
    buffer.writeln('  ThemeColors lerp(ThemeColors? other, double t) {');
    buffer.writeln('    if (other is! ThemeColors) {');
    buffer.writeln('      return this;');
    buffer.writeln('    }');
    buffer.writeln();
    buffer.writeln('    return ThemeColors(');

    for (int i = 0; i < colors.length; i++) {
      final color = colors[i];
      final lerpExpr = 'Color.lerp(${color.name}, other.${color.name}, t)!';

      // Check if the line would be too long (80+ chars)
      final inlineLine = '      ${color.name}: $lerpExpr,';
      if (inlineLine.length <= 80) {
        buffer.writeln(inlineLine);
      } else {
        buffer.writeln('      ${color.name}: Color.lerp(');
        buffer.writeln('        ${color.name},');
        buffer.writeln('        other.${color.name},');
        buffer.writeln('        t,');
        buffer.writeln('      )!,');
      }
    }

    buffer.writeln('    );');
    buffer.writeln('  }');
  }
}

/// Represents a color entry from YAML
class _ColorEntry {
  _ColorEntry({
    required this.name,
    required this.doc,
    this.light,
    this.dark,
    this.value,
  });

  final String name;
  final String doc;
  final String? light;
  final String? dark;
  final String? value;

  bool get isAdaptive => light != null && dark != null;
}
