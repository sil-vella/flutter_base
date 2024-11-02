
# Plugin System Documentation

This documentation outlines the structure and functionality of the plugin system. It covers key components including `AppPlugin`, `PluginManager`, `ModuleManager`, and demonstrates how plugins interact with shared modules and navigation.

## Overview

The plugin system is designed to support modular and reusable components, with two main areas of focus:
1. **Plugin Management**: Using `PluginManager` to initialize and manage plugins.
2. **Module Management**: Using `ModuleManager` to handle shared modules that can be accessed by multiple plugins.

Each plugin can register itself with the `PluginManager`, and shared modules within plugins can be registered with `ModuleManager` for easy access by other plugins.

---

## Components

### 1. AppPlugin

**File:** `plugins/base/app_plugin.dart`

`AppPlugin` is an abstract base class that defines the standard interface for all plugins. Each plugin must implement:
- **initialize**: Initializes the plugin and registers any necessary components.
- **registerModules**: (Optional) Allows plugins to register shared modules with `ModuleManager`.

```dart
// plugins/base/app_plugin.dart
abstract class AppPlugin {
  void initialize(); // Initializes the plugin

  /// Optional method for plugins that need to register shared modules
  void registerModules() {}
}
```

### 2. ModuleManager

**File:** `plugins/base/module_manager.dart`

`ModuleManager` is a singleton class responsible for managing shared modules. It stores modules by name and allows plugins to retrieve them as needed. 

- **registerModule(String name, dynamic module)**: Registers a module by a unique name.
- **getModule<T>(String name)**: Retrieves a registered module by name, casting it to the specified type.

```dart
// plugins/base/module_manager.dart
class ModuleManager {
  static final ModuleManager _instance = ModuleManager._internal();
  final Map<String, dynamic> _modules = {}; // Store modules by name

  factory ModuleManager() => _instance;
  ModuleManager._internal();

  /// Registers a module with a specified name
  void registerModule(String name, dynamic module) {
    _modules[name] = module;
  }

  /// Retrieves a registered module by name
  T? getModule<T>(String name) {
    return _modules[name] as T?;
  }
}
```

### 3. PluginManager

**File:** `plugins/base/plugin_manager.dart`

`PluginManager` is a singleton that manages the lifecycle of all plugins. It registers each plugin and immediately calls `initialize` on it. 

- **registerPlugin(AppPlugin plugin)**: Registers and initializes a plugin.
- **initializeAllPlugins()**: Initializes all registered plugins, if required.

```dart
// plugins/base/plugin_manager.dart
import 'app_plugin.dart';

class PluginManager {
  static final PluginManager _instance = PluginManager._internal();
  final List<AppPlugin> _registeredPlugins = [];

  factory PluginManager() => _instance;
  PluginManager._internal();

  /// Registers a plugin with PluginManager
  void registerPlugin(AppPlugin plugin) {
    _registeredPlugins.add(plugin);
    plugin.initialize(); // Initialize the plugin immediately upon registration
  }

  /// Initializes all registered plugins
  void initializeAllPlugins() {
    for (var plugin in _registeredPlugins) {
      plugin.initialize();
    }
  }
}
```

### 4. Plugin Registry

**File:** `plugins/plugin_registry.dart`

This file contains the centralized function for registering all plugins. `registerPlugins()` is called at the start of the application to register each plugin with `PluginManager`.

```dart
// plugins/plugin_registry.dart
import '../shared_plugin/example_plugin_main.dart';
import 'plugin_manager.dart';

void registerPlugins() {
  PluginManager().registerPlugin(PluginExample());
}
```

---

## Example Plugin Implementations

### 1. ConnectToDb Plugin

**File:** `plugins/shared_plugin/connect_to_db_main.dart`

`ConnectToDb` is a plugin that registers a `ConnectionModule` as a shared module in `ModuleManager`. This module allows other plugins to connect to a database by specifying a `baseUrl`.

```dart
// plugins/shared_plugin/admobs_main.dart
import '../base/app_plugin.dart';
import '../base/module_manager.dart';
import 'modules/connection_module.dart';

class ConnectToDb implements AppPlugin {
  ConnectToDb._internal();

  static final ConnectToDb _instance = ConnectToDb._internal();

  factory ConnectToDb() => _instance;

  @override
  void initialize() {
    print("ConnectToDb initialized");
    registerModules(); // Register shared modules during initialization
  }

  @override
  void registerModules() {
    // Register a factory function for ConnectionModule
    ModuleManager().registerModule("ConnectionModule", (String baseUrl) => ConnectionModule(baseUrl));
  }
}
```

### 2. PluginExample

**File:** `plugins/shared_plugin/shared_plugin_main.dart`

`PluginExample` is a plugin that registers multiple components, including shared modules and navigation links. It demonstrates how a plugin can register itself with `ModuleManager` and `NavigationContainer`.

- **registerModules**: Registers shared modules `SharedModuleOne` and `SharedModuleTwo`.
- **registerNavigation**: Registers navigation links and routes with `NavigationContainer`.
- **connectToDb**: Uses `ModuleManager` to access `ConnectionModule` for database connections.

```dart
// plugins/shared_plugin/example_plugin_main.dart
import 'package:flutter/material.dart';
import '../../navigation/navigation_container.dart';
import '../base/app_plugin.dart';
import '../base/module_manager.dart';
import 'modules/shared_module_one.dart';
import 'modules/shared_module_two.dart';
import 'screens/screen_one.dart';
import 'screens/screen_two.dart';

class PluginExample implements AppPlugin {
  PluginExample._internal();

  static final PluginExample _instance = PluginExample._internal();

  factory PluginExample() => _instance;

  @override
  void initialize() {
    print("PluginExample initialized");
    registerModules(); // Register shared modules during initialization
    registerNavigation(); // Register navigation during initialization
    connectToDb();
  }

  @override
  void registerModules() {
    ModuleManager().registerModule("SharedModuleOne", SharedModuleOne());
    ModuleManager().registerModule("SharedModuleTwo", SharedModuleTwo());
  }

  /// Register navigation items for the shared plugin
  void registerNavigation() {
    NavigationContainer.registerNavigationLinks(
      drawerLinks: [
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Shared Plugin Item'),
          onTap: () {
            NavigationContainer.navigateTo('/shared_screen_one');
          },
        ),
      ],
      bottomNavLinks: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.share),
          label: 'Shared One',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Shared Two',
        ),
      ],
      routes: {
        '/screen_one': (context) => const ScreenOne(),
        '/screen_two': (context) => const ScreenTwo(),
      },
    );
  }

  void connectToDb() {
    // Retrieve ConnectionModule factory at the time of connection
    final createConnectionModule = ModuleManager().getModule<Function>("ConnectionModule");

    if (createConnectionModule != null) {
      // Create a ConnectionModule instance with a specific baseUrl
      final connectionModule = createConnectionModule("https://example.com/api/");
      connectionModule.sendGetRequest("/endpoint").then((response) {
        print("Response from ConnectionModule: $response");
      });
    } else {
      print("ConnectionModule is not available");
    }
  }
}
```

---

## Usage Summary

1. **Plugin Registration**: Plugins are registered with `PluginManager` in `plugin_registry.dart`, which initializes each plugin and invokes any shared module registrations.
2. **Shared Module Access**: Plugins register shared modules with `ModuleManager`, allowing other plugins to retrieve them dynamically when needed.
3. **Navigation**: Plugins can register navigation items using `NavigationContainer`, making them accessible through the app’s UI.

This modular plugin system enables plugins to be initialized, share modules, and register UI elements, promoting code reuse and extensibility.
