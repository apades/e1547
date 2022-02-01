import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ProviderCreatorMixin {
  late PostController controller;

  void updateTags() {
    Provider.of<Settings>(context, listen: false).homeTags.value =
        controller.search.value;
  }

  @override
  Widget build(BuildContext context) {
    return ProxyProvider2<Settings, Client, PostController>(
      update: guard2(
        create: (context, value, value2) {
          controller = PostController(
            search: value.homeTags.value,
            settings: value,
            client: value2,
          );
          controller.search.addListener(updateTags);
          return controller;
        },
        dispose: (context, value) {
          value.search.removeListener(updateTags);
          value.dispose();
        },
      ),
      dispose: (context, value) {
        value.search.removeListener(updateTags);
        value.dispose();
      },
      child: PostsPage(
        appBarBuilder: (context) => DefaultAppBar(
          title: Text('Home'),
          actions: [SizedBox.shrink()],
        ),
      ),
    );
  }
}
