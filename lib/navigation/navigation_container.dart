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
    // Global key for navigation
    navigatorKey.currentState?.pushNamed(routeName);
  }

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: _routes, // Register all plugin routes here
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
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: const Text(
              'Navigation Drawer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ..._drawerLinks, // Add registered drawer links here
        ],
      ),
    );
  }

  Widget? _buildBottomNavigationBar(BuildContext context) {
    if (_bottomNavLinks.length < 2) {
      return null;
    }
    return BottomNavigationBar(
      items: _bottomNavLinks,
      onTap: (index) {
        // Navigate to a route based on the selected item
        if (index < _bottomNavLinks.length) {
          final selectedRoute = _routes.keys.elementAt(index);
          navigatorKey.currentState?.pushNamed(selectedRoute);
        }
      },
    );
  }
}
