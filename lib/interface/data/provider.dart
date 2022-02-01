import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef GuardedProviderBuilder0<R> = R Function(
  BuildContext context,
);

typedef GuardedProviderBuilder<T, R> = R Function(
  BuildContext context,
  T value,
);

typedef GuardedProviderBuilder2<T, T2, R> = R Function(
  BuildContext context,
  T value,
  T2 value2,
);

typedef GuardedProviderBuilder3<T, T2, T3, R> = R Function(
  BuildContext context,
  T value,
  T2 value2,
  T3 value3,
);

typedef GuardedProviderBuilder4<T, T2, T3, T4, R> = R Function(
  BuildContext context,
  T value,
  T2 value2,
  T3 value3,
  T4 value4,
);

typedef GuardedProviderBuilder5<T, T2, T3, T4, T5, R> = R Function(
  BuildContext context,
  T value,
  T2 value2,
  T3 value3,
  T4 value4,
  T5 value5,
);

typedef GuardedProviderBuilder6<T, T2, T3, T4, T5, T6, R> = R Function(
  BuildContext context,
  T value,
  T2 value2,
  T3 value3,
  T4 value4,
  T5 value5,
  T6 value6,
);

mixin ProviderCreatorMixin<X extends StatefulWidget> on State<X> {
  Map<Type, List<dynamic>> registered = {};

  R Function(BuildContext context, R? value) guard0<R>({
    required GuardedProviderBuilder0<R> create,
    Dispose<R>? dispose,
    List<dynamic>? conditions,
  }) =>
      (context, previous) {
        List<dynamic> values = [];
        if (conditions != null) {
          values.add(conditions);
        }
        if (previous != null &&
            registered.containsKey(R) &&
            const DeepCollectionEquality().equals(registered[R], values)) {
          return previous;
        } else {
          if (previous != null) {
            dispose?.call(context, previous);
          }
          registered[R] = values;
          return create(context);
        }
      };

  ProxyProviderBuilder<T, R> guard<T, R>({
    required GuardedProviderBuilder<T, R> create,
    Dispose<R>? dispose,
    List<dynamic>? conditions,
  }) =>
      (context, value, previous) => guard0<R>(
            create: (context) => create(context, value),
            conditions: [value],
            dispose: dispose,
          )(context, previous);

  ProxyProviderBuilder2<T, T2, R> guard2<T, T2, R>({
    required GuardedProviderBuilder2<T, T2, R> create,
    Dispose<R>? dispose,
    List<dynamic>? conditions,
  }) =>
      (context, value, value2, previous) => guard<T, R>(
            create: (context, value) => create(context, value, value2),
            conditions: [value2],
            dispose: dispose,
          )(context, value, previous);

  ProxyProviderBuilder3<T, T2, T3, R> guard3<T, T2, T3, R>({
    required GuardedProviderBuilder3<T, T2, T3, R> create,
    Dispose<R>? dispose,
    List<dynamic>? conditions,
  }) =>
      (context, value, value2, value3, previous) => guard2<T, T2, R>(
            create: (context, value, value2) =>
                create(context, value, value2, value3),
            conditions: [value3],
            dispose: dispose,
          )(context, value, value2, previous);

  ProxyProviderBuilder4<T, T2, T3, T4, R> guard4<T, T2, T3, T4, R>({
    required GuardedProviderBuilder4<T, T2, T3, T4, R> create,
    Dispose<R>? dispose,
    List<dynamic>? conditions,
  }) =>
      (context, value, value2, value3, value4, previous) =>
          guard3<T, T2, T3, R>(
            create: (context, value, value2, value3) =>
                create(context, value, value2, value3, value4),
            conditions: [value4],
            dispose: dispose,
          )(context, value, value2, value3, previous);

  ProxyProviderBuilder5<T, T2, T3, T4, T5, R> guard5<T, T2, T3, T4, T5, R>({
    required GuardedProviderBuilder5<T, T2, T3, T4, T5, R> create,
    Dispose<R>? dispose,
    List<dynamic>? conditions,
  }) =>
      (context, value, value2, value3, value4, value5, previous) =>
          guard4<T, T2, T3, T4, R>(
            create: (context, value, value2, value3, value4) =>
                create(context, value, value2, value3, value4, value5),
            conditions: [value5],
            dispose: dispose,
          )(context, value, value2, value3, value4, previous);

  ProxyProviderBuilder6<T, T2, T3, T4, T5, T6, R> guard6<T, T2, T3, T4, T5, T6,
          R>({
    required GuardedProviderBuilder6<T, T2, T3, T4, T5, T6, R> create,
    Dispose<R>? dispose,
    List<dynamic>? conditions,
  }) =>
      (context, value, value2, value3, value4, value5, value6, previous) =>
          guard5<T, T2, T3, T4, T5, R>(
            create: (context, value, value2, value3, value4, value5) =>
                create(context, value, value2, value3, value4, value5, value6),
            conditions: [value6],
            dispose: dispose,
          )(context, value, value2, value3, value4, value5, previous);
}
