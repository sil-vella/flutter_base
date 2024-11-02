
# Navigation System Documentation

This documentation provides an overview of the navigation system, explaining its components, how plugins register navigation items, and how the system integrates with routes and navigational elements like drawers and bottom navigation bars.

## Overview

The navigation system is designed to support dynamic, plugin-based navigation. Plugins can register navigation items for the drawer and bottom navigation bar, as well as custom routes. The main components of the navigation system are:

1. **NavigationContainer**: The central container managing navigation elements.
2. **Global Routes and Links**: Dynamic registration of routes, drawer links, and bottom navigation links from plugins.

---

## Components

### 1. NavigationContainer

**File:** `navigation/navigation_container.dart`

`NavigationContainer` is a central widget responsible for managing and displaying navigation elements. It allows plugins to register routes, drawer links, and bottom navigation items.

- **registerNavigationLinks**: Static method allowing plugins to register links and routes.
- **navigateTo**: Static method for programmatically navigating to registered routes.
- **navigatorKey**: A global key that enables navigation within the `MaterialApp`.
  
**Features**:
- **Drawer Links**: Registered by plugins and displayed in the drawer.
- **Bottom Navigation Links**: Registered by plugins and limited to a maximum of 4 items.
- **Dynamic Routes**: Plugins can register routes, making them accessible across the app.

```dart
// navigation/navigation_container.dart
import 'package:flutter/material.dart';

typedef NavigationLink = ListTile;
typedef BottomNavigationLink = BottomNavigationBarItem;

class NavigationContainer extends StatelessWidget {
  final Widget child;
  static final List<NavigationLink> _drawerLinks = [];
  static final List<BottomNavigationLink> _bottomNavLinks = [];
  static final Map<String, WidgetBuilder> _routes = {};

  const NavigationContainer({Key? key, required this.child}) : super(key: key);

  /// Hook for plugins to register navigation links and routes
  static void registerNavigationLinks({
    required List<NavigationLink> drawerLinks,
    required List<BottomNavigationLink> bottomNavLinks,
    required Map<String, WidgetBuilder> routes,
  }) {
    _drawerLinks.addAll(drawerLinks);
    _bottomNavLinks.addAll(bottomNavLinks);
    _routes.addAll(routes);
  }

  /// Static method to navigate to a route
  static void navigateTo(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: _routes,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("App Navigation"),
        ),
        drawer: _buildDrawer(context),
        body: child,
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: const Text('Navigation Drawer', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ..._drawerLinks,
        ],
      ),
    );
  }

  Widget? _buildBottomNavigationBar(BuildContext context) {
    if (_bottomNavLinks.isEmpty) {
      print("No items in bottom navigation bar. At least 1 item is required.");
      return null;
    } else if (_bottomNavLinks.length > 4) {
      print("Too many items in bottom navigation bar. Limiting to 4 items.");
    }

    return BottomNavigationBar(
      items: _bottomNavLinks.take(4).toList(),
      onTap: (index) {
        final selectedRoute = _routes.keys.elementAt(index);
        navigatorKey.currentState?.pushNamed(selectedRoute);
      },
    );
  }
}
```

---

### 2. Screen Components

**Files:** `screen_one.dart`, `screen_two.dart`

These files define basic screens used for testing navigation. Plugins can define their own screens and register routes to these screens via `NavigationContainer`.

#### Example: ScreenOne

```dart
// screen_one.dart
import 'package:flutter/material.dart';

class ScreenOne extends StatelessWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example Plugin Screen"),
      ),
      body: const Center(
        child: Text("Welcome to the Example Plugin Screen!"),
      ),
    );
  }
}
```

#### Example: ScreenTwo

```dart
// screen_two.dart
import 'package:flutter/material.dart';

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Screen Two"),
      ),
      body: const Center(
        child: Text("Welcome to Screen Two!"),
      ),
    );
  }
}
```

---

### 3. Plugin Integration

**File:** `shared_plugin_main.dart`

`PluginExample` demonstrates how plugins can register navigation links and routes using `NavigationContainer`. In this example:
- **Drawer Links**: Registers an item labeled "Shared Plugin Item" in the drawer.
- **Bottom Navigation Links**: Registers two items in the bottom navigation bar, limited to 4 items in total.
- **Routes**: Registers `/screen_one` and `/screen_two` routes, mapped to `ScreenOne` and `ScreenTwo` respectively.

```dart
// example_plugin_main.dart
import 'package:flutter/material.dart';
import '../../navigation/navigation_container.dart';
import '../base/app_plugin.dart';
import 'screens/screen_one.dart';
import 'screens/screen_two.dart';

class PluginExample implements AppPlugin {
  PluginExample._internal();
  static final PluginExample _instance = PluginExample._internal();

  factory PluginExample() => _instance;

  @override
  void initialize() {
    registerNavigation();
  }

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
}
```

### 4. Main Application Setup

**File:** `main.dart`

The main application entry point sets up the `NavigationContainer` as the root widget, ensuring that all registered plugins' navigation links and routes are available throughout the app.

```dart
// main.dart
import 'package:flutter/material.dart';
import 'plugins/base/plugin_registry.dart';
import 'navigation/navigation_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerPlugins(); // Register all plugins
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banner Example',
      home: NavigationContainer(
        child: Center(child: Text("Home Screen")),
      ),
    );
  }
}
```

---

## Usage Summary

1. **Dynamic Navigation**: `NavigationContainer` allows plugins to dynamically register navigation elements, including drawer and bottom navigation links, as well as routes.
2. **Global Navigation Access**: The `navigateTo` method and `navigatorKey` in `NavigationContainer` provide global navigation capabilities.
3. **Plugin Flexibility**: Each plugin can independently register its own navigation items and routes, making the navigation system extensible and modular.

This setup supports a highly modular and flexible navigation system that adapts to dynamically loaded plugins, enhancing the overall structure and usability of the app.
