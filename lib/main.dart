// main.dart
import 'package:flutter/material.dart';
import 'plugins/base/plugin_manager.dart';
import 'plugins/base/plugin_registry.dart';
import 'services/admobs/ads/banner_ad_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register all plugins using the registry
  PluginManager().registerAllPlugins(pluginRegistrations);
  // Initialize all registered plugins
  PluginManager().initializeAllPlugins();

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Banner Example'),
        ),
        body: const Center(
          child: BannerAdWidget(),
        ),
      ),
    );
  }
}
