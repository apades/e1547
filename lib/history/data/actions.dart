import 'package:e1547/history/data/entry.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/data/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void addPostToHistory(BuildContext context, Post post) {
  Settings settings = Provider.of<Settings>(context, listen: false);
  if (!settings.writeHistory.value) {
    return;
  }
  withHistory(context, (history) {
    if (history.reversed.take(15).any((element) =>
        element.postId == post.id &&
        element.visitedAt.difference(DateTime.now()).inMinutes < 10)) {
      return;
    }
    String? thumbnail;
    if (!post.isDeniedBy(settings.denylist.value)) {
      thumbnail = post.sample.url;
    }
    history.add(
      HistoryEntry(
          visitedAt: DateTime.now(), postId: post.id, thumbnail: thumbnail),
    );
  });
}

void addToHistory(BuildContext context, HistoryEntry historyEntry) {
  withHistory(context, (history) => history.add(historyEntry));
}

void removeFromHistory(BuildContext context, HistoryEntry historyEntry) {
  withHistory(context, (history) => history.remove(historyEntry));
}

void withHistory(
    BuildContext context, void Function(List<HistoryEntry> history) callback) {
  Settings settings = Provider.of<Settings>(context, listen: false);
  String host = settings.host.value;
  Map<String, List<HistoryEntry>> history = Map.from(settings.history.value);
  List<HistoryEntry> currentHistory = history[host] ?? [];
  callback(currentHistory);
  currentHistory.sort((a, b) => a.visitedAt.compareTo(b.visitedAt));
  history[host] = currentHistory;
  settings.history.value = history;
}
