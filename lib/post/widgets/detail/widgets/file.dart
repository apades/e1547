import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/tag/tag.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

class FileDisplay extends StatelessWidget {
  final Post post;
  final PostController? controller;

  const FileDisplay({required this.post, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            'File',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TagGesture(
                tag: 'rating:${post.rating.name}',
                controller: controller,
                child: Text(ratingTexts[post.rating]!),
              ),
              Text('${post.file.width} x ${post.file.height}'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getCurrentDateTimeFormat().format(post.createdAt.toLocal())),
              Text(filesize(post.file.size, 1)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (post.updatedAt != null)
                Text(getCurrentDateTimeFormat()
                    .format(post.updatedAt!.toLocal())),
              TagGesture(
                tag: 'type:${post.file.ext}',
                controller: controller,
                child: Text(post.file.ext),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
