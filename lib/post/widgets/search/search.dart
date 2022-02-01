import 'package:collection/collection.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/wiki/wiki.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final String? tags;
  final bool reversePools;

  const SearchPage({this.tags, this.reversePools = false});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with ProviderCreatorMixin {
  late bool reversePools = widget.reversePools;
  bool loading = true;
  Pool? pool;

  late List<Follow> follows;
  late PostController controller;
  late Settings settings;

  String getTitle() {
    Follow? follow = follows
        .singleWhereOrNull((follow) => follow.tags == controller.search.value);
    if (follow != null) {
      return follow.title;
    }
    if (pool != null) {
      return tagToTitle(pool!.name);
    }
    if (Tagset.parse(controller.search.value).length == 1) {
      return tagToTitle(controller.search.value);
    }
    return 'Search';
  }

  Future<void> updateFollow() async {
    Follow? follow = follows
        .singleWhereOrNull((follow) => follow.tags == controller.search.value);
    if (follow != null) {
      if (controller.itemList?.isNotEmpty ?? false) {
        follow
            .updateLatest(settings.host.value, controller.itemList!.first,
                foreground: true)
            .then((updated) {
          if (updated) {
            settings.follows.value = follows;
          }
        });
      }
      if (pool != null) {
        if (follow.updatePool(pool!)) {
          settings.follows.value = follows;
        }
      }
    }
  }

  Future<void> updatePool() async {
    setState(() {
      loading = true;
    });
    String input = Tagset.parse(controller.search.value).toString();
    RegExpMatch? match = poolRegex().firstMatch(input);
    if (input.length == 1 &&
        match != null &&
        match.namedGroup('id')! != pool?.id.toString()) {
      pool = await Provider.of<Client>(context, listen: false)
          .pool(int.parse(match.namedGroup('id')!));
    } else {
      pool = null;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Follow>>(
      valueListenable: Provider.of<Settings>(context).follows,
      builder: (context, follows, child) {
        this.follows = follows;
        return ProxyProvider2<Settings, Client, PostController>(
          update: guard2(
            create: (context, value, value2) {
              settings = value;
              controller = PostController(
                search: widget.tags,
                provider: (tags, page, force) => value2.posts(
                  page,
                  search: tags,
                  reversePools: reversePools,
                  force: force,
                ),
                settings: value,
                client: value2,
              );
              controller.search.addListener(updatePool);
              controller.search.addListener(updateFollow);
              updatePool();
              updateFollow();
              return controller;
            },
            conditions: [reversePools],
            dispose: (context, value) {
              controller.search.removeListener(updatePool);
              controller.search.removeListener(updateFollow);
              value.dispose();
            },
          ),
          dispose: (context, value) {
            controller.search.removeListener(updatePool);
            controller.search.removeListener(updateFollow);
            value.dispose();
          },
          builder: (context, child) {
            PostController controller = Provider.of<PostController>(context);
            return PostsPage(
              appBarBuilder: (context) => DefaultAppBar(
                title: Text(getTitle()),
                leading: BackButton(),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CrossFade(
                          showChild: !loading &&
                              Tagset.parse(controller.search.value).isNotEmpty,
                          child: IconButton(
                            icon: Icon(Icons.info_outline),
                            onPressed: pool != null
                                ? () => poolSheet(context, pool!)
                                : () => wikiSheet(
                                      context: context,
                                      tag: controller.search.value,
                                      controller: controller,
                                    ),
                          ),
                        ),
                        ContextDrawerButton(),
                      ],
                    ),
                  ),
                ],
              ),
              drawerActions: [
                if (pool != null)
                  PoolOrderSwitch(
                    reversePool: reversePools,
                    onChange: (value) {
                      setState(() {
                        reversePools = value;
                      });
                      controller.refresh();
                      Navigator.of(context).maybePop();
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
