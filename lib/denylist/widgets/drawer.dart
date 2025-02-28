import 'package:e1547/denylist/denylist.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class DrawerDenySwitch extends StatelessWidget {
  final PostController controller;

  const DrawerDenySwitch({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => DrawerDenySwitchBody(
        denying: controller.denying,
        denied: controller.deniedPosts ?? {},
        updateAllowedList: controller.setAllowedTags,
        updateDenying: controller.setDenying,
        allowedList: controller.allowedTags,
      ),
    );
  }
}

class DrawerMultiDenySwitch extends StatefulWidget {
  final List<PostController> controllers;

  const DrawerMultiDenySwitch({required this.controllers});

  @override
  State<DrawerMultiDenySwitch> createState() => _DrawerMultiDenySwitchState();
}

class _DrawerMultiDenySwitchState extends State<DrawerMultiDenySwitch> {
  bool denying = true;
  List<String> allowedList = [];

  void updateDenying(bool value) {
    denying = value;
    widget.controllers.forEach((element) => element.setDenying(denying));
  }

  void updateAllowedList(List<String> value) {
    allowedList = value;
    widget.controllers
        .forEach((element) => element.setAllowedTags(allowedList));
  }

  @override
  void initState() {
    super.initState();
    updateDenying(denying);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(widget.controllers),
      builder: (context, child) {
        Map<String, List<Post>> denied = {};
        List<String> allowedList = [];
        for (PostController controller in widget.controllers) {
          if (controller.deniedPosts != null) {
            denied.addAll(controller.deniedPosts!);
          }
          allowedList.addAll(controller.allowedTags);
        }
        allowedList = allowedList.toSet().toList();

        return DrawerDenySwitchBody(
          denying: denying,
          denied: denied,
          updateAllowedList: updateAllowedList,
          updateDenying: updateDenying,
          allowedList: allowedList,
        );
      },
    );
  }
}

class DrawerDenyTile extends StatelessWidget {
  final bool isAllowed;
  final void Function(bool? value) onChanged;
  final MapEntry<String, List<Post>> entry;

  const DrawerDenyTile({
    required this.entry,
    required this.isAllowed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isAllowed,
      onChanged: onChanged,
      title: Row(
        children: [
          Expanded(
            child: Wrap(
              children: entry.key
                  .split(' ')
                  .where((tag) => tag.isNotEmpty)
                  .map(DenyListTagCard.new)
                  .toList(),
            ),
          ),
        ],
      ),
      secondary: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 24),
        child: TweenAnimationBuilder(
          tween: IntTween(begin: 0, end: entry.value.length),
          duration: const Duration(milliseconds: 200),
          builder: (context, value, child) => Text(
            value.toString(),
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class DrawerDenySwitchBody extends StatelessWidget {
  final bool denying;
  final Map<String, List<Post>> denied;
  final List<String> allowedList;

  final void Function(bool value) updateDenying;
  final void Function(List<String> value) updateAllowedList;

  const DrawerDenySwitchBody({
    required this.denying,
    required this.denied,
    required this.allowedList,
    required this.updateDenying,
    required this.updateAllowedList,
  });

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, List<Post>>> entries = [];

    entries.addAll(denied.entries);
    entries.addAll(allowedList.map((e) => MapEntry(e, <Post>[])));

    entries.sort((a, b) => a.key.compareTo(b.key));

    int count = denied.values
        .fold<List<Post>>(
            [], (previousValue, element) => previousValue..addAll(element))
        .toSet()
        .toList()
        .length;

    return Column(
      children: [
        SwitchListTile(
          title: const Text('Blacklist'),
          subtitle: denying && count > 0
              ? TweenAnimationBuilder(
                  tween: IntTween(begin: 0, end: count),
                  duration: defaultAnimationDuration,
                  builder: (context, int value, child) =>
                      Text('blocked $value posts'),
                )
              : null,
          secondary: const Icon(Icons.block),
          value: denying,
          onChanged: updateDenying,
        ),
        CrossFade(
          showChild: denied.isNotEmpty || allowedList.isNotEmpty,
          child: Column(
            children: [
              const Divider(),
              ...entries.map(
                (entry) => DrawerDenyTile(
                  entry: entry,
                  isAllowed: !allowedList.contains(entry.key),
                  onChanged: (value) {
                    List<String> allowed = List.from(allowedList);
                    if (value!) {
                      allowed.remove(entry.key);
                    } else {
                      allowed.add(entry.key);
                    }
                    updateAllowedList(allowed);
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: denylistController,
                builder: (context, child) {
                  int count = denylistController.items.length;
                  if (denying) {
                    count -= denied.keys.length;
                    count -= allowedList.length;
                  }
                  return CrossFade(
                    showChild: 0 < count,
                    child: TweenAnimationBuilder(
                      tween: IntTween(begin: 0, end: count),
                      duration: defaultAnimationDuration,
                      builder: (context, int value, child) => Text(
                        '$value inactive entries',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: dimTextColor(context),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
