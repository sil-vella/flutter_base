// navigation/navigation_container.dart
import 'package:flutter/material.dart';

typedef NavigationLink = ListTile;
typedef BottomNavigationLink = BottomNavigationBarItem;

class NavigationContainer extends StatelessWidget {
  final Widget child;
  static final List<NavigationLink> _drawerLinks = [];
  static final List<BottomNavigationLink> _bottomNavLinks = [];

  const NavigationContainer({Key? key, required this.child}) : super(key: key);

  /// Hook for plugins to register drawer and bottom navigation links
  static void registerNavigationLinks({
    required List<NavigationLink> drawerLinks,
    required List<BottomNavigationLink> bottomNavLinks,
  }) {
    _drawerLinks.addAll(drawerLinks);
    _bottomNavLinks.addAll(bottomNavLinks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Navigation"),
      ),
      drawer: _buildDrawer(context),
      body: child,
      bottomNavigationBar: _buildBottomNavigationBar(),
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

  Widget? _buildBottomNavigationBar() {
    // Check if there are fewer than two items
    if (_bottomNavLinks.length < 2) {
      // Provide default items to satisfy the BottomNavigationBar requirement
      return BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
        onTap: (index) {
          // Handle bottom navigation taps for default items
        },
      );
    }

    return BottomNavigationBar(
      items: _bottomNavLinks,
      onTap: (index) {
        // Handle bottom navigation taps for registered items
      },
    );
  }

}
