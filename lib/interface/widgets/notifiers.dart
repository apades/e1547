import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin ListenerCallbackMixin<T extends StatefulWidget> on State<T> {
  final Map<Listenable, VoidCallback> listeners = {};
  final Map<Listenable, VoidCallback> initListeners = {};

  @override
  void initState() {
    super.initState();
    for (final entry in initListeners.entries) {
      entry.value();
      entry.key.addListener(entry.value);
    }
    for (final entry in listeners.entries) {
      entry.key.addListener(entry.value);
    }
  }

  final Map<Listenable, VoidCallback> _attachedListeners = {};

  void _addListener(MapEntry<Listenable, VoidCallback> entry) {
    entry.key.addListener(entry.value);
    _attachedListeners.addEntries([MapEntry(entry.key, entry.value)]);
  }

  void _removeListener(MapEntry<Listenable, VoidCallback> entry) {
    entry.key.removeListener(entry.value);
    _attachedListeners.removeWhere(
      (key, value) => entry.key == key && entry.value == value,
    );
  }

  T attach<T>({
    required T? current,
    required Map<Listenable, VoidCallback> Function(T value) builder,
    bool init = false,
  }) =>
      listen<T>(
        current: current,
        create: Provider.of<T>,
        builder: builder,
        init: true,
      );

  T listen<T>({
    required T? current,
    required T Function(BuildContext context) create,
    required Map<Listenable, VoidCallback> Function(T value) builder,
    bool init = false,
  }) {
    if (current != null) {
      for (final entry in builder(current).entries) {
        _removeListener(entry);
      }
    }
    T result = create(context);
    for (final entry in builder(result).entries) {
      _addListener(entry);
      if (init) {
        entry.value();
      }
    }
    return result;
  }

  @override
  void dispose() {
    for (final entry in initListeners.entries) {
      entry.key.removeListener(entry.value);
    }
    for (final entry in _attachedListeners.entries) {
      entry.key.removeListener(entry.value);
    }
    super.dispose();
  }
}
