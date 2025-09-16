import 'package:e1547/client/client.dart';
import 'package:e1547/flag/flag.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class DeletionDisplay extends StatelessWidget {
  const DeletionDisplay({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    if (!post.isDeleted) return const SizedBox.shrink();
    return SubFuture<PostFlag>(
      create: () async {
        List<PostFlag> flags = await context.read<Client>().flags.list(
          limit: 1,
          query: {
            'type': 'deletion',
            'search[post_id]': post.id,
            'search[is_resolved]': 'false',
          }.toQuery(),
        );
        return flags.first;
      },
      builder: (context, value) => HiddenWidget(
        show: value.data != null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text('Deletion', style: TextStyle(fontSize: 16)),
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Theme.of(
                      context,
                    ).colorScheme.errorContainer.withAlpha(150),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: DText(value.data?.reason ?? ''),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
