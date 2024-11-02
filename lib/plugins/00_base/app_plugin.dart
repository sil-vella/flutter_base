// plugins/base/app_plugin.dart
import 'package:flutter/material.dart';

abstract class AppPlugin {
  void initialize(BuildContext context); // Initializes the plugin

  /// Optional method for plugins that need to register shared modules
  void registerModules() {}
}
