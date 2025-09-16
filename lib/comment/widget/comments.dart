import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostCommentsPage extends StatelessWidget {
  const PostCommentsPage({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context) {
    return CommentProvider(
      postId: postId,
      child: Consumer<CommentController>(
        builder: (context, controller, child) => RefreshableDataPage(
          appBar: DefaultAppBar(
            title: Text('#$postId comments'),
            actions: const [ContextDrawerButton()],
          ),
          floatingActionButton: context.read<Client>().hasLogin
              ? FloatingActionButton(
                  heroTag: 'float',
                  backgroundColor: Theme.of(context).cardColor,
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () =>
                      writeComment(context: context, postId: postId).then((
                        value,
                      ) {
                        if (value) {
                          controller.refresh(force: true);
                        }
                      }),
                )
              : null,
          controller: controller,
          endDrawer: ContextDrawer(
            title: const Text('Comments'),
            children: [
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) => SwitchListTile(
                  secondary: const Icon(Icons.sort),
                  title: const Text('Comment order'),
                  subtitle: Text(
                    controller.orderByOldest ? 'oldest first' : 'newest first',
                  ),
                  value: controller.orderByOldest,
                  onChanged: (value) {
                    controller.orderByOldest = value;
                    Scaffold.of(context).closeEndDrawer();
                  },
                ),
              ),
            ],
          ),
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) => PagedListView<int, Comment>(
              primary: true,
              padding: defaultActionListPadding,
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
      ),
    );
  }
}
