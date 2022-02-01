import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/settings/data/settings.dart';

import 'comment.dart';

class CommentController extends CursorDataController<Comment>
    with RefreshableController, AccountableController {
  final int postId;
  final Client client;
  final Settings settings;

  CommentController({
    required this.postId,
    required this.client,
    required this.settings,
  });

  @override
  Future<List<Comment>> provide(String page, bool force) =>
      client.comments(postId, page, force: force);

  @override
  int getId(Comment item) => item.id;

  @override
  void disposeItems(List<Comment> items) async {
    if (itemList != null) {
      for (final comment in itemList!) {
        comment.dispose();
      }
    }
  }
}
