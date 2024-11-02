import 'package:flutter/material.dart';
import 'plugins/base/plugin_manager.dart';
import 'plugins/base/plugin_registry.dart';
import 'services/admobs/banner_ad_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register all plugins using the registry
  PluginManager().registerAllPlugins(pluginRegistrations);
  // Initialize all registered plugins
  PluginManager().initializeAllPlugins();

  runApp(const MaterialApp(
    home: BannerExample(),
  ));
}

class BannerExample extends StatefulWidget {
  const BannerExample({super.key});

  @override
  BannerExampleState createState() => BannerExampleState();
}

class BannerExampleState extends State<BannerExample> {
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