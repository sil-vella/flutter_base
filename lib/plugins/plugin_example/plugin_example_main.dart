import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_base/plugins/plugin_example/modules/example_module/example_module.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../00_base/module_manager.dart';
import 'functions/example_plugin_helper.dart';
import '../00_base/app_plugin.dart';

class PluginExample implements AppPlugin {
  PluginExample._internal();

  static final PluginExample _instance = PluginExample._internal();

  factory PluginExample() => _instance;

  @override
  void onStartup() {
    // Add any non-context-dependent startup logic here
  }

  @override
  void initialize(BuildContext context) async {

    // Register modules
    registerModules();

    // Register navigation
    PluginHelper.registerNavigation(context);

    // Access and initialize app state
    final pluginStateKey = "${runtimeType}State";
    final appStateProvider = Provider.of<AppStateProvider>(context, listen: false);

  }

  void registerModules() {
    ModuleManager().registerModule("ExampleModule", () => ExampleModule());
  }

  // Default state
  Map<String, dynamic> reset() {
    return {
      "state": "idle",
    };
  }
}
