import 'package:e1547/client/client.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<bool> updateBlacklist({
  required BuildContext context,
  required List<String> denylist,
  bool immediate = false,
}) async {
  Client client = Provider.of<Client>(context);
  Settings settings = Provider.of<Settings>(context);
  bool success = true;

  if (await client.isLoggedIn) {
    List<String> old = List.from(settings.denylist.value);
    if (immediate) {
      settings.denylist.value = denylist;
    }
    try {
      await client.updateBlacklist(denylist);
      settings.denylist.value = denylist;
    } on ClientException {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Failed to update blacklist!'),
        behavior: SnackBarBehavior.floating,
      ));
      settings.denylist.value = old;
      success = false;
    }
  } else {
    settings.denylist.value = denylist;
  }

  return success;
}
