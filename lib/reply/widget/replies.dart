import 'package:e1547/history/history.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class RepliesPage extends StatelessWidget {
  const RepliesPage({super.key, required this.topic, this.orderByOldest});

  final Topic topic;
  final bool? orderByOldest;

  @override
  Widget build(BuildContext context) {
    return ReplyProvider(
      topicId: topic.id,
      orderByOldest: orderByOldest,
      child: Consumer<ReplyController>(
        builder: (context, controller, child) => ControllerHistoryConnector(
          controller: controller,
          addToHistory: (context, client, controller) => client.histories
              .addTopic(topic: topic, replies: controller.items!),
          child: RefreshableDataPage(
            appBar: DefaultAppBar(
              title: Text(topic.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'Info',
                  onPressed: () =>
                      showTopicPrompt(context: context, topic: topic),
                ),
                const ContextDrawerButton(),
              ],
            ),
            controller: controller,
            drawer: const RouterDrawer(),
            endDrawer: ContextDrawer(
              title: const Text('Replies'),
              children: [
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) => SwitchListTile(
                    secondary: const Icon(Icons.sort),
                    title: const Text('Reply order'),
                    subtitle: Text(
                      controller.orderByOldest
                          ? 'oldest first'
                          : 'newest first',
                    ),
                    value: controller.orderByOldest,
                    onChanged: (value) {
                      controller.orderByOldest = value;
                      Navigator.of(context).maybePop();
                    },
                  ),
                ),
              ],
            ),
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) => PagedListView(
                primary: true,
                padding: defaultActionListPadding,
                state: controller.state,
                fetchNextPage: controller.getNextPage,
                builderDelegate: defaultPagedChildBuilderDelegate<Reply>(
                  onRetry: controller.getNextPage,
                  itemBuilder: (context, item, index) => ReplyTile(reply: item),
                  onEmpty: const IconMessage(
                    icon: Icon(Icons.clear),
                    title: Text('No replies'),
                  ),
                  onError: const IconMessage(
                    icon: Icon(Icons.warning_amber_outlined),
                    title: Text('Failed to load replies'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
