import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CommentDisplay extends StatelessWidget {
  const CommentDisplay({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    if (post.commentCount <= 0) return const SizedBox();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PostCommentsPage(postId: post.id),
                  ),
                ),
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                  overlayColor: WidgetStateProperty.all(
                    Theme.of(context).splashColor,
                  ),
                ),
                child: Text(
                  'COMMENTS'
                  ' (${post.commentCount})',
                ),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class SliverPostCommentSection extends StatelessWidget {
  const SliverPostCommentSection({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return CommentProvider(
      postId: post.id,
      child: Consumer<CommentController>(
        builder: (context, controller, child) => SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Comments',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          PopupMenuButton<VoidCallback>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) => value(),
                            itemBuilder: (context) => [
                              PopupMenuTile(
                                title: 'Refresh',
                                icon: Icons.refresh,
                                value: () => controller.refresh(force: true),
                              ),
                              PopupMenuTile(
                                icon: Icons.sort,
                                title: controller.orderByOldest
                                    ? 'Newest first'
                                    : 'Oldest first',
                                value: () => controller.orderByOldest =
                                    !controller.orderByOldest,
                              ),
                              PopupMenuTile(
                                title: 'Comment',
                                icon: Icons.comment,
                                value: () => guardWithLogin(
                                  context: context,
                                  callback: () async {
                                    PostController postsController = context
                                        .read<PostController>();
                                    bool success = await writeComment(
                                      context: context,
                                      postId: post.id,
                                    );
                                    if (success) {
                                      postsController.replacePost(
                                        post.copyWith(
                                          commentCount: post.commentCount + 1,
                                        ),
                                      );
                                      controller.refresh(force: true);
                                    }
                                  },
                                  error: 'You must be logged in to comment!',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ).add(const EdgeInsets.only(bottom: 30)),
              sliver: ListenableBuilder(
                listenable: controller,
                builder: (context, _) => PagedSliverList<int, Comment>(
                  state: controller.state,
                  fetchNextPage: controller.getNextPage,
                  builderDelegate: defaultPagedChildBuilderDelegate(
                    onRetry: controller.getNextPage,
                    itemBuilder: (context, item, index) =>
                        CommentTile(comment: item),
                    onEmpty: const Text('No comments'),
                    onError: const Text('Failed to load comments'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
