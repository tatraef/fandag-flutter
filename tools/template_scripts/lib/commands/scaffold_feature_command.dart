import 'dart:convert';
import 'dart:io';

import 'package:mad_scripts_base/mad_scripts_base.dart';
import 'package:path/path.dart' as path;

import '../utils/string_case_converter.dart';

/// Creates feature folder structure with Riverpod architecture
class ScaffoldFeatureCommand extends ScriptCommand<void> {
  ScaffoldFeatureCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Feature name (snake_case, e.g., "user_profile")',
        mandatory: true,
      )
      // Presets (mutually exclusive)
      ..addFlag(
        'full',
        help: 'Full: domain + data + presentation',
        negatable: false,
      )
      ..addFlag(
        'minimal',
        help: 'Minimal: domain + presentation (no data)',
        negatable: false,
      )
      ..addFlag(
        'data-only',
        help: 'Data-only: domain + data (no presentation)',
        negatable: false,
      )
      ..addFlag(
        'ui-only',
        help: 'UI only: presentation/pages only',
        negatable: false,
      );
  }

  @override
  String get name => 'scaffold-feature';

  @override
  String get description =>
      'Create Riverpod architecture structure for a new feature';

  @override
  Future<void> runWrapped() async {
    final featureName = argResults!['name'] as String;

    // Validate feature name
    if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(featureName)) {
      output.error(
        'Feature name must be snake_case '
        '(e.g., "user_profile", "age_verification")',
      );
      throw UsageException('Invalid feature name', usage);
    }

    // Determine structure from presets
    final config = _parseConfig(featureName);

    // Paths
    final projectRoot = Directory.current.path;
    final featurePath =
        path.join(projectRoot, 'lib', 'features', featureName);

    // Check if feature already exists
    if (Directory(featurePath).existsSync()) {
      output.error(
        'Feature "$featureName" already exists at $featurePath',
      );
      return;
    }

    output.info('Creating feature: $featureName');
    output.info('Structure: ${config.description}');
    output.info('');

    // Create directories
    final createdDirs = <String>[];

    for (final dir in config.directories) {
      final fullPath = path.join(featurePath, dir);
      await Directory(fullPath).create(recursive: true);
      createdDirs.add('lib/features/$featureName/$dir/');
    }

    // Generate template files
    final generatedFiles = await _generateTemplateFiles(
      featureName: featureName,
      featurePath: featurePath,
      config: config,
    );

    // Generate barrel files
    final barrelFiles = await _generateBarrelFiles(
      featureName: featureName,
      featurePath: featurePath,
      config: config,
    );

    final totalFiles = generatedFiles.length + barrelFiles.length;

    output.success(
      'Created ${createdDirs.length} directories and $totalFiles files',
    );
    output.info('');
    output.info('Files generated:');
    for (final file in [...generatedFiles, ...barrelFiles]) {
      output.info('  $file');
    }
    output.info('');
    output.info('Next steps:');
    output.info('  1. Review generated files and fill in TODOs');
    if (config.hasDomain) {
      output.info('  2. Add fields to entities');
    }
    if (config.hasData) {
      output.info('  3. Implement datasource and repository');
    }
    if (config.hasPresentation) {
      output.info('  4. Build UI in page and controller');
    }
    output.info('  5. Run: make gen');
  }

  Future<List<String>> _generateTemplateFiles({
    required String featureName,
    required String featurePath,
    required _FeatureConfig config,
  }) async {
    final generatedFiles = <String>[];
    final projectRoot = Directory.current.path;

    // Set templates path
    final templatesPath = path.join(
      projectRoot,
      'tools',
      'template_scripts',
      'templates',
    );
    ScriptTemplates.templatesPath = templatesPath;

    // Read templates config
    final configPath = path.join(
      projectRoot,
      'tools',
      'template_scripts',
      'config',
      'templates.json',
    );
    final configFile = File(configPath);

    if (!configFile.existsSync()) {
      output.warning(
        'Templates config not found, skipping file generation',
      );
      return generatedFiles;
    }

    final configJson =
        jsonDecode(await configFile.readAsString()) as Map<String, dynamic>;
    final projectName = configJson['project_name'] as String;

    // Prepare Mustache variables
    final variables = _buildTemplateVariables(featureName, projectName);

    // Determine preset name
    final presetName = config.presetName;

    final presets = configJson['presets'] as Map<String, dynamic>;
    final preset = presets[presetName] as Map<String, dynamic>?;

    if (preset == null) {
      output.warning('Preset "$presetName" not found in templates.json');
      return generatedFiles;
    }

    // Generate files for each layer
    for (final layerEntry in preset.entries) {
      final layerTemplates = layerEntry.value as Map<String, dynamic>;

      for (final templateEntry in layerTemplates.entries) {
        final templateFile = templateEntry.value as String;
        final outputFile = _getOutputFilePath(
          featureName: featureName,
          featurePath: featurePath,
          templateType: templateEntry.key,
        );

        try {
          final content = ScriptTemplates.fromFile(
            templateFile,
            values: variables,
          );
          await File(outputFile).create(recursive: true);
          await File(outputFile).writeAsString(content);
          generatedFiles.add(outputFile.replaceFirst('$projectRoot/', ''));
        } catch (e) {
          output.warning('Failed to generate $templateFile: $e');
        }
      }
    }

    return generatedFiles;
  }

  Future<List<String>> _generateBarrelFiles({
    required String featureName,
    required String featurePath,
    required _FeatureConfig config,
  }) async {
    final barrelFiles = <String>[];
    final projectRoot = Directory.current.path;

    // Domain barrels
    if (config.hasDomain) {
      // Sub-barrels
      await _writeBarrel(
        path.join(featurePath, 'domain', 'entities', 'entities.dart'),
        ["export '$featureName.dart';"],
      );
      barrelFiles.add(
        'lib/features/$featureName/domain/entities/entities.dart',
      );

      await _writeBarrel(
        path.join(
          featurePath,
          'domain',
          'repositories',
          'repositories.dart',
        ),
        ["export '${featureName}_repository.dart';"],
      );
      barrelFiles.add(
        'lib/features/$featureName/domain/repositories/repositories.dart',
      );

      // Layer barrel
      await _writeBarrel(
        path.join(featurePath, 'domain.dart'),
        [
          "export 'domain/entities/entities.dart';",
          "export 'domain/repositories/repositories.dart';",
        ],
      );
      barrelFiles.add('lib/features/$featureName/domain.dart');
    }

    // Data barrels
    if (config.hasData) {
      // Sub-barrels
      await _writeBarrel(
        path.join(featurePath, 'data', 'models', 'models.dart'),
        ["export '${featureName}_dto.dart';"],
      );
      barrelFiles.add(
        'lib/features/$featureName/data/models/models.dart',
      );

      await _writeBarrel(
        path.join(
          featurePath,
          'data',
          'datasources',
          'datasources.dart',
        ),
        ["export '${featureName}_datasource.dart';"],
      );
      barrelFiles.add(
        'lib/features/$featureName/data/datasources/datasources.dart',
      );

      await _writeBarrel(
        path.join(
          featurePath,
          'data',
          'repositories',
          'repositories.dart',
        ),
        ["export '${featureName}_repository_impl.dart';"],
      );
      barrelFiles.add(
        'lib/features/$featureName/data/repositories/repositories.dart',
      );

      // Layer barrel
      await _writeBarrel(
        path.join(featurePath, 'data.dart'),
        [
          "export 'data/datasources/datasources.dart';",
          "export 'data/models/models.dart';",
          "export 'data/repositories/repositories.dart';",
        ],
      );
      barrelFiles.add('lib/features/$featureName/data.dart');
    }

    // Presentation barrels
    if (config.hasPresentation) {
      final subBarrels = <String>[];

      // Controllers sub-barrel (for full and minimal)
      if (config.presetName != 'ui-only') {
        await _writeBarrel(
          path.join(
            featurePath,
            'presentation',
            'controllers',
            'controllers.dart',
          ),
          ["export '${featureName}_controller.dart';"],
        );
        barrelFiles.add(
          'lib/features/$featureName/presentation/controllers/controllers.dart',
        );
        subBarrels
            .add("export 'presentation/controllers/controllers.dart';");
      }

      // Pages sub-barrel
      await _writeBarrel(
        path.join(featurePath, 'presentation', 'pages', 'pages.dart'),
        ["export '${featureName}_page.dart';"],
      );
      barrelFiles.add(
        'lib/features/$featureName/presentation/pages/pages.dart',
      );
      subBarrels.add("export 'presentation/pages/pages.dart';");

      // Layer barrel
      await _writeBarrel(
        path.join(featurePath, 'presentation.dart'),
        subBarrels,
      );
      barrelFiles.add('lib/features/$featureName/presentation.dart');
    }

    return barrelFiles
        .map((f) => f.replaceFirst('$projectRoot/', ''))
        .toList();
  }

  Future<void> _writeBarrel(String filePath, List<String> exports) async {
    final file = File(filePath);
    await file.create(recursive: true);
    await file.writeAsString('${exports.join('\n')}\n');
  }

  Map<String, String> _buildTemplateVariables(
    String featureName,
    String projectName,
  ) {
    return {
      'feature_name': featureName,
      'feature_name_pascal':
          StringCaseConverter.snakeToPascal(featureName),
      'feature_name_camel':
          StringCaseConverter.snakeToCamel(featureName),
      'feature_name_title':
          StringCaseConverter.snakeToTitle(featureName),
      'project_name': projectName,
    };
  }

  String _getOutputFilePath({
    required String featureName,
    required String featurePath,
    required String templateType,
  }) {
    switch (templateType) {
      // Domain
      case 'entity':
        return path.join(
          featurePath,
          'domain',
          'entities',
          '$featureName.dart',
        );
      case 'repository':
        return path.join(
          featurePath,
          'domain',
          'repositories',
          '${featureName}_repository.dart',
        );

      // Data
      case 'dto':
        return path.join(
          featurePath,
          'data',
          'models',
          '${featureName}_dto.dart',
        );
      case 'datasource':
        return path.join(
          featurePath,
          'data',
          'datasources',
          '${featureName}_datasource.dart',
        );
      case 'repository_impl':
        return path.join(
          featurePath,
          'data',
          'repositories',
          '${featureName}_repository_impl.dart',
        );

      // Presentation
      case 'controller':
        return path.join(
          featurePath,
          'presentation',
          'controllers',
          '${featureName}_controller.dart',
        );
      case 'page':
        return path.join(
          featurePath,
          'presentation',
          'pages',
          '${featureName}_page.dart',
        );

      default:
        throw ArgumentError('Unknown template type: $templateType');
    }
  }

  _FeatureConfig _parseConfig(String featureName) {
    final full = argResults!['full'] as bool;
    final minimal = argResults!['minimal'] as bool;
    final dataOnly = argResults!['data-only'] as bool;
    final uiOnly = argResults!['ui-only'] as bool;

    // Check for mutually exclusive presets
    final presetCount =
        [full, minimal, dataOnly, uiOnly].where((p) => p).length;
    if (presetCount > 1) {
      output.error('Cannot use multiple presets together');
      throw UsageException('Conflicting presets', usage);
    }

    if (full) return _FeatureConfig.full(featureName);
    if (minimal) return _FeatureConfig.minimal(featureName);
    if (dataOnly) return _FeatureConfig.dataOnly(featureName);
    if (uiOnly) return _FeatureConfig.uiOnly(featureName);

    // Default to full
    output.info('No preset provided, using --full');
    return _FeatureConfig.full(featureName);
  }
}

/// Feature scaffolding configuration
class _FeatureConfig {
  const _FeatureConfig({
    required this.featureName,
    required this.description,
    required this.presetName,
    required this.directories,
    required this.hasDomain,
    required this.hasData,
    required this.hasPresentation,
  });

  final String featureName;
  final String description;
  final String presetName;
  final List<String> directories;
  final bool hasDomain;
  final bool hasData;
  final bool hasPresentation;

  /// Full: domain + data + presentation
  factory _FeatureConfig.full(String featureName) {
    return _FeatureConfig(
      featureName: featureName,
      description: 'Full (domain + data + presentation)',
      presetName: 'full',
      directories: [
        'domain/entities',
        'domain/repositories',
        'data/datasources',
        'data/models',
        'data/repositories',
        'presentation/controllers',
        'presentation/pages',
      ],
      hasDomain: true,
      hasData: true,
      hasPresentation: true,
    );
  }

  /// Minimal: domain + presentation (no data)
  factory _FeatureConfig.minimal(String featureName) {
    return _FeatureConfig(
      featureName: featureName,
      description: 'Minimal (domain + presentation)',
      presetName: 'minimal',
      directories: [
        'domain/entities',
        'domain/repositories',
        'presentation/controllers',
        'presentation/pages',
      ],
      hasDomain: true,
      hasData: false,
      hasPresentation: true,
    );
  }

  /// Data-only: domain + data (no presentation)
  factory _FeatureConfig.dataOnly(String featureName) {
    return _FeatureConfig(
      featureName: featureName,
      description: 'Data-only (domain + data)',
      presetName: 'data-only',
      directories: [
        'domain/entities',
        'domain/repositories',
        'data/datasources',
        'data/models',
        'data/repositories',
      ],
      hasDomain: true,
      hasData: true,
      hasPresentation: false,
    );
  }

  /// UI-only: presentation/pages
  factory _FeatureConfig.uiOnly(String featureName) {
    return _FeatureConfig(
      featureName: featureName,
      description: 'UI-only (presentation/pages)',
      presetName: 'ui-only',
      directories: [
        'presentation/pages',
      ],
      hasDomain: false,
      hasData: false,
      hasPresentation: true,
    );
  }
}
