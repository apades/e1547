import 'package:e1547/follow/follow.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

typedef StartupCallback = void Function(BuildContext context);

final List<StartupCallback> actions = [
  initAvatar,
  (context) => Provider.of<FollowUpdater>(context).update(),
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (StartupCallback element in actions) {
      element(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
