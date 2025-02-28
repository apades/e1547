import 'package:e1547/denylist/denylist.dart';
import 'package:e1547/post/post.dart';
import 'package:flutter/material.dart';

class TagGesture extends StatelessWidget {
  final bool safe;
  final bool wiki;
  final String tag;
  final Widget child;
  final PostController? controller;

  const TagGesture({
    required this.child,
    required this.tag,
    this.controller,
    this.safe = true,
    this.wiki = false,
  });

  @override
  Widget build(BuildContext context) {
    void sheet() =>
        tagSearchSheet(context: context, tag: tag, controller: controller);

    return InkWell(
      onTap: () async {
        if (wiki || (safe && denylistController.denies(tag))) {
          sheet();
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchPage(tags: tag),
          ));
        }
      },
      onLongPress: sheet,
      child: child,
    );
  }
}
