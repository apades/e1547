import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:flutter/material.dart';

import 'reply.dart';

class ReplyController extends CursorDataController<Reply>
    with RefreshableController {
  final int topicId;
  final ValueNotifier<bool> orderByOldest;

  final Client client;

  ReplyController(
      {required this.topicId, required this.client, bool orderByOldest = true})
      : orderByOldest = ValueNotifier(orderByOldest);

  @override
  Future<List<Reply>> provide(String page, bool force) =>
      client.replies(topicId, page, force: force);

  @override
  int getId(Reply item) => item.id;
}
