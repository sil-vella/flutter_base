// plugins/shared_plugin/connect_to_db_main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state_provider.dart';
import '../base/app_plugin.dart';
import '../base/module_manager.dart';
import 'modules/connection_module.dart';

class ConnectToDb implements AppPlugin {
  ConnectToDb._internal();

  static final ConnectToDb _instance = ConnectToDb._internal();

  factory ConnectToDb() => _instance;

  @override
  void initialize(BuildContext context) {
    print("ConnectToDb initialized");
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    // Get state of other plugin
    final otherPluginState = appState.getPluginState<Map<String, dynamic>>("PluginBState");

    registerModules(); // Register shared modules during initialization
  }

  @override
  void registerModules() {
    // Register a factory function for ConnectionModule
    ModuleManager().registerModule("ConnectionModule", (String baseUrl) => ConnectionModule(baseUrl));
  }
}
