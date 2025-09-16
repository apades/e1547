import 'package:e1547/account/account.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/stream/stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class AccountConnector extends StatelessWidget {
  const AccountConnector({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return AvailabilityCheck(
      navigatorKey: navigatorKey,
      child: SubEffect(
        effect: () {
          client.follows.sync();
          return null;
        },
        keys: [client],
        child: SubStream<List<Follow>>(
          create: () => client.follows.all().streamed,
          keys: [client],
          listener: (event) => client.follows.sync(),
          builder: (context, _) => SubEffect(
            effect: () {
              client.accounts.pull(force: true);
              return null;
            },
            keys: [client],
            child: SubValueListener(
              listenable: client.traits,
              listener: (traits) => client.accounts.push(traits: traits),
              builder: (context, _) => child,
            ),
          ),
        ),
      ),
    );
  }
}
