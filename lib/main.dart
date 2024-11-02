// main.dart
import 'package:banner_example/plugins/00_base/plugin_manager.dart';
import 'package:banner_example/plugins/admobs/modules/banner/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'plugins/00_base/plugin_registry.dart';
import 'navigation/navigation_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register all plugins
  registerPlugins();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppStateProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use addPostFrameCallback to set the initial app state and initialize plugins after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set the initial app state
      Provider.of<AppStateProvider>(context, listen: false).setMainAppState({
        "app_main_state": "init",
      });

      // Initialize all plugins with the current context
      PluginManager().initializeAllPlugins(context);
    });

    return const MaterialApp(
      title: 'Banner Example',
      home: NavigationContainer(
        child: Center(
          child: BannerAdWidget(),
        ),
      ),
    );
  }
}
