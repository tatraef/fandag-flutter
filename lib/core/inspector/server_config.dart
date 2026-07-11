import 'package:fandag/core/environment/secrets.dart';
import 'package:mad_inspector_server_selection/mad_inspector_server_selection.dart';

abstract class ServerConfig {
  static const bool isInspectorOnDebugMode = bool.fromEnvironment(
    'mb.isInspectorOnDebugMode',
  );

  static const bool isTestBuild = bool.fromEnvironment('mb.isTestBuild');

  static const String _serverName = 'API';

  static List<ServerType> get servers {
    if (isTestBuild) {
      return <ServerType>[
        const ServerType(
          name: _serverName,
          selections: <String>[
            Secrets.baseUrlDev,
            Secrets.baseUrlStage,
            Secrets.baseUrlProd,
          ],
        ),
      ];
    }

    return <ServerType>[
      const ServerType(
        name: _serverName,
        selections: <String>[Secrets.baseUrlProd],
      ),
    ];
  }

  static String getCurrentServerUrl() {
    return MadServerSelectionModule.getCurrentServerSafe(
      _serverName,
      Secrets.baseUrlProd,
    );
  }
}
