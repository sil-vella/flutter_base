import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../main_providers/app_state_provider.dart';
import '../../utils/hooks/hook.dart';
import '../../utils/hooks/nav_hook.dart';
import 'app_plugin.dart';

class PluginManager {
  final AppStateProvider appStateProvider;
  final Map<String, Function()> _pluginConstructors = {};
  final PluginRegistry pluginRegistry = PluginRegistry();

  PluginManager(this.appStateProvider) {
    // Register default plugin constructors here
    registerDefaultPlugins();
  }

  void registerDefaultPlugins() {
    // Add other default plugin constructors here if needed
  }

  void registerPluginConstructor(
      String slug, Function(AppStateProvider, PluginRegistry) constructor) {
    _pluginConstructors[slug] =
        () => constructor(appStateProvider, pluginRegistry);
  }

  void initializePlugins(PluginConfig config) {
    final Set<String> initializedPlugins = {};

    for (var pluginInfo in config.plugins) {
      if (pluginInfo.enabled &&
          pluginInfo.initAtStartup &&
          !initializedPlugins.contains(pluginInfo.slug)) {
        var plugin = createPlugin(pluginInfo.slug);
        if (plugin != null) {
          plugin.init();
          pluginRegistry.registerPlugin(pluginInfo.slug, plugin);
          plugin.registerNavigationHook(
              pluginRegistry); // Register navigation hooks here
          initializedPlugins.add(pluginInfo.slug);
        }
      }
    }
  }

  AppPlugin? createPlugin(String slug) {
    final constructor = _pluginConstructors[slug];
    if (constructor != null) {
      return constructor();
    } else {
      print('Warning: Plugin $slug not found or not registered');
      return null;
    }
  }

  Map<String, WidgetBuilder> collectAllRoutes() {
    Map<String, WidgetBuilder> allRoutes = {};
    for (var plugin in pluginRegistry.getAllPlugins()) {
      var pluginRoutes = plugin.getRoutes();
      // Exclude the '/' route to avoid conflict with `home` property
      pluginRoutes.remove('/');
      allRoutes.addAll(pluginRoutes);
    }
    return allRoutes;
  }

  void disposeAllPlugins() {
    for (var plugin in pluginRegistry.getAllPlugins()) {
      plugin.dispose();
    }
  }
}

class PluginRegistry {
  final Map<String, AppPlugin> _registeredPlugins = {};
  final List<Hook<List<NavigationItem>>> _navigationHooks = [];

  void registerPlugin(String slug, AppPlugin plugin) {
    _registeredPlugins[slug] = plugin;
  }

  void registerNavigationHook(Hook<List<NavigationItem>> hook) {
    if (!_navigationHooks.contains(hook)) {
      _navigationHooks.add(hook);
    }
  }

  List<NavigationItem> collectNavigationItems() {
    List<NavigationItem> allNavigationItems = [];
    for (var hook in _navigationHooks) {
      var items = hook.execute();
      for (var itemList in items) {
        allNavigationItems.addAll(itemList);
      }
    }
    return allNavigationItems;
  }

  List<AppPlugin> getAllPlugins() {
    return _registeredPlugins.values.toList();
  }
}

class PluginConfig {
  final List<PluginInfo> plugins;

  PluginConfig({required this.plugins});

  factory PluginConfig.fromJson(Map<String, dynamic> json) {
    var pluginsJson = json['plugins'] as List;
    List<PluginInfo> pluginsList =
        pluginsJson.map((i) => PluginInfo.fromJson(i)).toList();
    return PluginConfig(plugins: pluginsList);
  }

  static Future<PluginConfig> loadConfig() async {
    String jsonString =
        await rootBundle.loadString('assets/config/plugins_config.json');
    Map<String, dynamic> json = jsonDecode(jsonString);
    return PluginConfig.fromJson(json);
  }
}

class PluginInfo {
  final String slug;
  final bool enabled;
  final bool initAtStartup;

  PluginInfo(
      {required this.slug, required this.enabled, required this.initAtStartup});

  factory PluginInfo.fromJson(Map<String, dynamic> json) {
    return PluginInfo(
      slug: json['slug'],
      enabled: json['enabled'],
      initAtStartup: json['initAtStartup'],
    );
  }
}
