import 'package:cached_network_image/cached_network_image.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> initAvatar(BuildContext context) async {
  Post? avatar =
      await Provider.of<Client>(context, listen: false).currentAvatar;
  if (avatar?.sample.url != null) {
    precacheImage(
      CachedNetworkImageProvider(avatar!.sample.url!),
      context,
    );
  }
}

class CurrentUserAvatar extends StatefulWidget {
  const CurrentUserAvatar();

  @override
  _CurrentUserAvatarState createState() => _CurrentUserAvatarState();
}

class _CurrentUserAvatarState extends State<CurrentUserAvatar>
    with ListenerCallbackMixin {
  Settings? settings;
  late Client client;
  late Future<Post?> avatar;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = Provider.of<Client>(context);
    settings?.credentials.removeListener(updateAvatar);
    settings?.host.removeListener(updateAvatar);
    settings = Provider.of<Settings>(context);
    settings?.credentials.addListener(updateAvatar);
    settings?.host.addListener(updateAvatar);
    updateAvatar();
  }

  void updateAvatar() {
    avatar = client.currentAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return AvatarLoader(avatar);
  }
}

class UserAvatar extends StatefulWidget {
  final int id;

  const UserAvatar({required this.id});

  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> with ListenerCallbackMixin {
  late Future<Post?> avatar;

  Future<Post?> getAvatar(Client client) async => await client.post(widget.id);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    avatar = getAvatar(Provider.of<Client>(context));
  }

  @override
  Widget build(BuildContext context) {
    return AvatarLoader(avatar);
  }
}

class AvatarLoader extends StatelessWidget {
  final Future<Post?> avatar;

  const AvatarLoader(this.avatar);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Post?>(
      future: avatar,
      builder: (context, snapshot) => Avatar(snapshot.data),
    );
  }
}

class Avatar extends StatelessWidget {
  final Post? post;

  const Avatar(this.post);

  @override
  Widget build(BuildContext context) {
    if (post != null && post!.sample.url != null) {
      return GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostLoadingPage(post!.id),
          ),
        ),
        child: PostTileOverlay(
          post: post!,
          child: Hero(
            tag: post!.hero,
            child: CircleAvatar(
              foregroundImage: (CachedNetworkImageProvider(post!.sample.url!)),
            ),
          ),
        ),
      );
    } else {
      return AppIcon();
    }
  }
}
