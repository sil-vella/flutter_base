import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../navigation/navigation_container.dart';
import '../screens/default_screen.dart';

class PluginHelper {

  static void registerNavigation(BuildContext context) {
    final navigationContainer = Provider.of<NavigationContainer>(
        context, listen: false);
    navigationContainer.registerNavigationLinks(
      drawerLinks: [
        ListTile(
          leading: const Icon(Icons.play_arrow),
          title: const Text('Screen01'),
          onTap: () {
            NavigationContainer.navigateTo('/screen01');
          },
        )
      ],
      bottomNavLinks: [],
      routes: {
        '/screen01': (context) => const DefaultScreen(),
      },
    );
  }
}
