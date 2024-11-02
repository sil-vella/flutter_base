// plugins/shared_plugin/connect_to_db_main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../navigation/navigation_container.dart';
import '../../providers/app_state_provider.dart';
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
  void initialize(BuildContext context) {
    print("PluginExample initialized");

    registerModules(); // Register shared modules during initialization
    registerNavigation(); // Register navigation during initialization
    // Register initial state for this plugin
    Provider.of<AppStateProvider>(context, listen: false)
        .registerPluginState("PluginBState", {"state_example": 0});

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

      // Use the instance's methods
      connectionModule.sendGetRequest("/endpoint").then((response) {
        print("Response from ConnectionModule: $response");
      });
    } else {
      print("ConnectionModule is not available");
    }
  }
}
