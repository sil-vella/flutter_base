import 'package:banner_example/plugins/base/plugin_manager.dart';
import 'package:flutter/material.dart';

import '../../main_providers/app_state_provider.dart';
import '../../utils/hooks/nav_hook.dart';

abstract class AppPlugin {
  final AppStateProvider appStateProvider;

  AppPlugin(this.appStateProvider);

  // Optional: Called when the plugin is initialized
  void init() {}

  // Optional: Called when the plugin is disposed
  void dispose() {}

  // Registers a plugin's state with the AppStateProvider
  void registerState(String pluginName, ChangeNotifier state) {
    appStateProvider.updatePluginState(pluginName, state);
  }

  // Registers navigation items through a hook
  NavigationItemHook? getNavigationHook() {
    return null; // Override this in specific plugins if they have navigation items
  }

  // Registers a plugin's specific hook into the PluginRegistry
  void registerNavigationHook(PluginRegistry pluginRegistry) {
    // Only register the hook if the plugin has navigation items
    final hook = getNavigationHook();
    if (hook != null) {
      pluginRegistry.registerNavigationHook(hook);
    }
  }

  // Gets routes defined by the plugin
  Map<String, WidgetBuilder> getRoutes() {
    return {};
  }
}
