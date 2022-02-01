import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavPage extends StatefulWidget {
  const FavPage();

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> with ProviderCreatorMixin {
  bool orderFavorites = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Credentials?>(
      valueListenable: Provider.of<Settings>(context).credentials,
      builder: (context, credentials, child) => PageLoader(
        isEmpty: credentials == null,
        isError: credentials == null,
        onError: IconMessage(
          icon: Icon(Icons.login),
          title: Text('You are not logged in'),
        ),
        loadingBuilder: (context, child) => Scaffold(
          appBar: DefaultAppBar(
            title: Text('Favorites'),
          ),
          body: Center(
            child: child,
          ),
        ),
        builder: (context) => ProxyProvider2<Settings, Client, PostController>(
          update: guard2(
            create: (context, value, value2) => PostController(
              provider: (tags, page, force) => value2.posts(
                page,
                search: tags,
                orderFavorites: orderFavorites,
                force: force,
              ),
              search: 'fav:${credentials!.username}',
              canDeny: false,
              settings: value,
              client: value2,
            ),
            conditions: [credentials, orderFavorites],
            dispose: (context, value) => value.dispose(),
          ),
          dispose: (context, value) => value.dispose(),
          builder: (context, child) {
            PostController controller = Provider.of<PostController>(context);
            return ValueListenableBuilder<String>(
              valueListenable: controller.search,
              builder: (context, value, child) => PostsPage(
                appBarBuilder: (context) => DefaultAppBar(
                  title: Text('Favorites'),
                  actions: [ContextDrawerButton()],
                ),
                drawerActions: [
                  if (value == credentials!.username)
                    SwitchListTile(
                      secondary: Icon(Icons.sort),
                      title: Text(
                        'Favorite order',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      subtitle:
                          Text(orderFavorites ? 'added order' : 'id order'),
                      value: orderFavorites,
                      onChanged: (value) {
                        setState(() {
                          orderFavorites = !orderFavorites;
                        });
                        controller.refresh();
                        Navigator.of(context).maybePop();
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
