import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../screens/base_screen.dart';
import '../../../providers/app_state_provider.dart';
import '../functions/example_plugin_helper.dart';
import '../plugin_example_main.dart';

class DefaultScreen extends BaseScreen {
  const DefaultScreen({Key? key}) : super(key: key);

  @override
  String get title => "Screen01";

  @override
  PrefScreenState createState() => PrefScreenState();
}

// Rename _PrefScreenState to PrefScreenState
class PrefScreenState extends BaseScreenState<DefaultScreen> {
  bool _isLoading = true; // Track loading state
  List<dynamic> _categories = []; // Store fetched categories

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Screen01",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
