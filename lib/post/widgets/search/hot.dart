import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/data/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HotPage extends StatefulWidget {
  const HotPage();

  @override
  _HotPageState createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> with ProviderCreatorMixin {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider2<Settings, Client, PostController>(
      update: guard2(
        create: (context, value, value2) => PostController(
          search: "order:rank",
          settings: value,
          client: value2,
        ),
        dispose: (context, value) => value.dispose,
      ),
      dispose: (context, value) => value.dispose,
      child: PostsPage(
        appBarBuilder: (context) => DefaultAppBar(
          title: Text('Hot'),
          actions: [SizedBox.shrink()],
        ),
      ),
    );
  }
}
