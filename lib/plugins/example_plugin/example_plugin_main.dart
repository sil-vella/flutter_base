// example_plugin.dart
import 'package:banner_example/plugins/example_plugin/screens/screen_one.dart';
import 'package:banner_example/plugins/example_plugin/screens/screen_two.dart';
import 'package:flutter/material.dart';

import '../../navigation/navigation_container.dart';
import '../base/plugin_manager.dart';

class ExamplePlugin implements AppPlugin {
  ExamplePlugin._internal(); // Private constructor

  /// Registers the plugin with navigation links and routes
  static void register() {
    PluginManager().registerPlugin(ExamplePlugin._internal());

    NavigationContainer.registerNavigationLinks(
      drawerLinks: [
        ListTile(
          leading: const Icon(Icons.extension),
          title: const Text('Example Plugin Item'),
          onTap: () {
            NavigationContainer.navigateTo('/screen_one'); // Updated to use static navigation
          },
        ),
      ],
      bottomNavLinks: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.extension),
          label: 'One',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Two',
        ),
      ],
      routes: {
        '/screen_one': (context) => const ScreenOne(),
        '/screen_two': (context) => const ScreenTwo(),
      },
    );
  }

  @override
  void initialize() {
    print("ExamplePlugin initialized");
  }
}