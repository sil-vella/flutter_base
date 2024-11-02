// plugin_manager.dart
import 'package:flutter/material.dart';

/// Interface that all plugins must implement.
abstract class AppPlugin {
  void initialize();
}

class PluginManager {
  static final PluginManager _instance = PluginManager._internal();

  factory PluginManager() => _instance;

  PluginManager._internal();

  final List<AppPlugin> _registeredPlugins = [];

  /// Register all plugins by calling their `register` method dynamically
  void registerAllPlugins(List<Function> pluginRegistrations) {
    for (var register in pluginRegistrations) {
      register(); // Each plugin calls its `register` method
    }
  }

  /// Adds a plugin to the list of registered plugins
  void registerPlugin(AppPlugin plugin) {
    _registeredPlugins.add(plugin);
  }

  /// Initialize all registered plugins
  void initializeAllPlugins() {
    for (var plugin in _registeredPlugins) {
      plugin.initialize();
    }
  }
}
