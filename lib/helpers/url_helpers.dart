import 'package:cooli/config/app_config.dart';
import 'package:cooli/utils/enums.dart';

class UrlHelpers {
  static EnumBuildEnvironment get server => AppConfig.server;

  static String get baseURL {
    switch (server) {
      case EnumBuildEnvironment.live:
        return '/// add url for live';
      case EnumBuildEnvironment.uat:
        return '/// add url for uat';
      case EnumBuildEnvironment.dg:
        return '/// add url for dg';
      }
  }

  static String get key {
    switch (server) {
      case EnumBuildEnvironment.live:
        return '/// add key for live';
      case EnumBuildEnvironment.uat:
        return '/// add key for uat';
      case EnumBuildEnvironment.dg:
        return '/// add key for dg';
      }
  }

  static String get baseUrlApi {
    switch (server) {
      case EnumBuildEnvironment.live:
        return '/// add apiHead for live';
      case EnumBuildEnvironment.uat:
        return '/// add apiHead for uat';
      case EnumBuildEnvironment.dg:
        return '/// add apiHead for dg';
      }
  }
}
