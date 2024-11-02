import 'package:flutter/material.dart';

import '../../navigation/navigation_container.dart';
import '../base/plugin_manager.dart';

class ExamplePlugin implements AppPlugin {
  ExamplePlugin._internal(); // Private constructor

  /// Registers the plugin and navigation links
  static void register() {
    PluginManager().registerPlugin(ExamplePlugin._internal());

// example_plugin.dart
    NavigationContainer.registerNavigationLinks(
      drawerLinks: [
        ListTile(
          leading: const Icon(Icons.extension),
          title: const Text('Example Plugin'),
          onTap: () {
            // Handle drawer link tap
          },
        ),
      ],
      bottomNavLinks: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.extension),
          label: 'Example',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );

  }

  @override
  void initialize() {
    print("ExamplePlugin initialized");
  }
}
