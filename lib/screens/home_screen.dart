import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import 'base_screen.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  String get title => 'Home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  Widget buildContent(BuildContext context) {
    // Access AppStateProvider to pass into PlayFunctions
    final appStateProvider = Provider.of<AppStateProvider>(context, listen: false);

    return Center(
      child: Text("Home")
    );
  }
}
