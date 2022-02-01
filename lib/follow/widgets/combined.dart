import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowsCombinedPage extends StatefulWidget {
  @override
  _FollowsCombinedPageState createState() => _FollowsCombinedPageState();
}

class _FollowsCombinedPageState extends State<FollowsCombinedPage>
    with ListenerCallbackMixin {
  List<String?>? tags;
  Settings? settings;
  late PostController controller;

  Future<void> updateTags() async {
    List<String?> update = settings!.follows.value.tags;
    if (tags == null) {
      tags = update;
    } else if (!listEquals(tags, update)) {
      controller.refresh();
      tags = update;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    settings = attach<Settings>(
      current: settings,
      builder: (value) => {
        value.follows: updateTags,
      },
      init: true,
    );
    controller = PostController(
      settings: settings!,
      client: Provider.of<Client>(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: controller,
      child: PostsPage(
        appBarBuilder: (context) => DefaultAppBar(
          title: Text('Following'),
          actions: [
            ContextDrawerButton(),
          ],
        ),
        drawerActions: [
          FollowSplitSwitchTile(),
          FollowSettingsTile(),
        ],
      ),
    );
  }
}
