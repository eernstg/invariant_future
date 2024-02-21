// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:extension_type_unions/extension_type_unions.dart';
export 'package:extension_type_unions/extension_type_unions.dart';

typedef _Inv<T> = T Function(T);
typedef IFuture<T> = _IFuture<T, _Inv<T>>;

// See https://github.com/dart-lang/sdk/issues/54543:
// ignore_for_file: unused_element

// Use the same syntax as in the declaration of `Future`.
// ignore_for_file: use_function_type_syntax_for_parameters

extension type _IFuture<T, Invariance extends _Inv<T>>._(Future<T> it)
    implements Future<T> {
  _IFuture(FutureOr<T> computation()) : this._(Future(computation));

  _IFuture.microtask(FutureOr<T> computation())
      : this._(Future.microtask(computation));

  _IFuture.sync(FutureOr<T> computation()) : this._(Future.sync(computation));

  _IFuture.value(FutureOr<T> value) : this._(Future.value(value));

  _IFuture.error(Object error, [StackTrace? stackTrace])
      : this._(Future.error(error, stackTrace));

  _IFuture.delayed(Duration duration, [FutureOr<T> computation()?])
      : this._(Future.delayed(duration, computation));

  static IFuture<T> any<T>(Iterable<Future<T>> futures) =>
      IFuture<T>._(Future.any<T>(futures));

  static IFuture<void> doWhile(FutureOr<bool> action()) =>
      IFuture<void>._(Future.doWhile(action));

  static IFuture<void> forEach<T>(
    Iterable<T> elements,
    FutureOr action(T element),
  ) =>
      IFuture<void>._(Future.forEach<T>(elements, action));

  static IFuture<List<T>> wait<T>(
    Iterable<Future<T>> futures, {
    bool eagerError = false,
    void cleanUp(T successValue)?,
  }) =>
      IFuture<List<T>>._(
          Future.wait<T>(futures, eagerError: eagerError, cleanUp: cleanUp));

  Stream<T> asStream() => it.asStream();

  IFuture<T> catchError(
          Union2<FutureOr<T> Function(Object),
                  FutureOr<T> Function(Object, StackTrace)>
              onError,
          {bool test(Object error)?}) =>
      IFuture<T>._(it.catchError(onError as Function, test: test));

  IFuture<R> then<R>(FutureOr<R> onValue(T value),
          {Union2<FutureOr<R> Function(Object),
                  FutureOr<R> Function(Object, StackTrace)>?
              onError}) =>
      IFuture<R>._(it.then<R>(onValue, onError: onError as Function));

  IFuture<T> timeout(Duration timeLimit, {FutureOr<T> onTimeout()?}) =>
      IFuture<T>._(it.timeout(timeLimit, onTimeout: onTimeout));

  IFuture<T> whenComplete(FutureOr<void> action()) =>
      IFuture<T>._(it.whenComplete(action));
}

extension IFutureExtension<T> on Future<T> {
  IFuture<T> get iFuture => IFuture<T>._(this);

  Future<bool> get isInvariant async {
    var list = await asStream().take(0).toList();
    try {
      list.addAll(<T>[]);
    } catch (_) {
      return false;
    }
    return true;
  }
}
