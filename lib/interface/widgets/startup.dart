import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

typedef StartupCallback = void Function(BuildContext context);

final List<StartupCallback> actions = [
  // (context) => Provider.of<FollowUpdater>(context).update(),
  (_) => initializeDateFormatting(),
];

class StartupActions extends StatefulWidget {
  final Widget child;

  const StartupActions({required this.child});

  @override
  _StartupActionsState createState() => _StartupActionsState();
}

class _StartupActionsState extends State<StartupActions> {
  @override
  void initState() {
    super.initState();
    for (StartupCallback element in actions) {
      element(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
