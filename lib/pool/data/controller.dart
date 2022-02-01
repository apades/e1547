import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/settings/data/settings.dart';
import 'package:flutter/material.dart';

class PoolController extends DataController<Pool>
    with SearchableController, HostableController, RefreshableController {
  @override
  late ValueNotifier<String> search;

  final Settings settings;
  final Client client;

  PoolController({String? search, required this.client, required this.settings})
      : search = ValueNotifier<String>(search ?? '');

  @override
  Future<List<Pool>> provide(int page, bool force) =>
      client.pools(page, search: search.value, force: force);
}
