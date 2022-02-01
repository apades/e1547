import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class CommentsPage extends StatefulWidget {
  final int postId;

  const CommentsPage({required this.postId});

  @override
  State createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late CommentController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = CommentController(
      postId: widget.postId,
      client: Provider.of<Client>(context),
      settings: Provider.of<Settings>(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider<CommentController>.value(
      value: controller,
      builder: (context, child) {
        return RefreshableControllerPage(
          appBar: DefaultAppBar(
            leading: BackButton(),
            title: Text('#${widget.postId} comments'),
            actions: [
              ContextDrawerButton(),
            ],
          ),
          floatingActionButton: controller.client.hasLogin
              ? FloatingActionButton(
                  heroTag: 'float',
                  backgroundColor: Theme.of(context).cardColor,
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () => writeComment(
                    context: context,
                    postId: widget.postId,
                  ),
                )
              : null,
          controller: controller,
          builder: (context) => PagedListView<String, Comment>(
            padding: defaultActionListPadding.copyWith(top: 8),
            pagingController: controller,
            builderDelegate: defaultPagedChildBuilderDelegate(
              pagingController: controller,
              itemBuilder: (context, item, index) => CommentTile(comment: item),
              onLoading: Text('Loading comments'),
              onEmpty: Text('No comments'),
              onError: Text('Failed to load comments'),
            ),
          ),
          endDrawer: ContextDrawer(
            title: Text('Comments'),
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: controller.orderByOldest,
                builder: (context, value, child) => SwitchListTile(
                  secondary: Icon(Icons.sort),
                  title: Text('Comment order'),
                  subtitle: Text(value ? 'oldest first' : 'newest first'),
                  value: value,
                  onChanged: (value) {
                    controller.orderByOldest.value = value;
                    Navigator.of(context).maybePop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
