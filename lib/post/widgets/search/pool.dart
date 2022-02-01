import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PoolPage extends StatefulWidget {
  final Pool pool;

  const PoolPage({required this.pool});

  @override
  _PoolPageState createState() => _PoolPageState();
}

class _PoolPageState extends State<PoolPage> with ProviderCreatorMixin {
  bool reversePool = false;

  @override
  Widget build(BuildContext context) {
    return ProxyProvider2<Settings, Client, PostController>(
      update: guard2(
        create: (context, value, value2) => PostController(
          provider: (tags, page, force) => value2.poolPosts(
              widget.pool.id, page,
              reverse: reversePool, force: force),
          canSearch: false,
          settings: value,
          client: value2,
        ),
        dispose: (context, value) => value.dispose(),
      ),
      dispose: (context, value) => value.dispose(),
      builder: (context, child) => PostsPage(
        appBarBuilder: (context) => DefaultAppBar(
          title: Text(tagToTitle(widget.pool.name)),
          leading: BackButton(),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              tooltip: 'Info',
              onPressed: () => poolSheet(context, widget.pool),
            ),
            ContextDrawerButton(),
          ],
        ),
        drawerActions: [
          PoolOrderSwitch(
            reversePool: reversePool,
            onChange: (value) {
              setState(() {
                reversePool = value;
              });
              Provider.of<PostController>(context, listen: false).refresh();
              Navigator.of(context).maybePop();
            },
          ),
        ],
      ),
    );
  }
}

class PoolOrderSwitch extends StatelessWidget {
  final bool reversePool;
  final void Function(bool value) onChange;
  const PoolOrderSwitch({required this.reversePool, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(Icons.sort),
      title: Text('Pool order'),
      subtitle: Text(reversePool ? 'newest first' : 'oldest first'),
      value: reversePool,
      onChanged: onChange,
    );
  }
}
