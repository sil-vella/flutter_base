import 'package:flutter/material.dart';
import '../plugins/base/plugin_manager.dart'; // Import PluginRegistry

class CustomNavigationDrawer extends StatelessWidget {
  final PluginRegistry pluginRegistry;

  const CustomNavigationDrawer({Key? key, required this.pluginRegistry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch navigation items from the registry
    final navigationItems = pluginRegistry.collectNavigationItems();

    return Drawer(
      child: ListView.builder(
        itemCount: navigationItems.length,
        itemBuilder: (context, index) {
          final item = navigationItems[index];
          return ListTile(
            title: Text(item.title),
            onTap: () {
              Navigator.pushNamed(context, item.route);
            },
          );
        },
      ),
    );
  }
}
