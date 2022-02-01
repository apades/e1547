import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class TopicController extends DataController<Topic>
    with RefreshableController, SearchableController {
  @override
  late ValueNotifier<String> search;

  final Client client;

  TopicController({String? search, required this.client})
      : search = ValueNotifier<String>(search ?? '');

  @override
  Future<List<Topic>> provide(int page, bool force) =>
      client.topics(page, search: search.value, force: force);
}
