// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

typedef _Inv<T> = T Function(T);
typedef IFuture<T> = _IFuture<T, _Inv<T>>;

// See https://github.com/dart-lang/sdk/issues/54543:
// ignore_for_file: unused_element

// Use the same syntax as in the declaration of `Future`.
// ignore_for_file: use_function_type_syntax_for_parameters

extension type _IFuture<T, Invariance extends _Inv<T>>._(Future<T> it)
    implements Future<T> {
  /// Create an [IFuture] by forwarding to the constructor [Future].
  _IFuture(FutureOr<T> computation()) : this._(Future(computation));

  /// Create an [IFuture] by forwarding to the constructor [Future.microtask].
  _IFuture.microtask(FutureOr<T> computation())
      : this._(Future.microtask(computation));

  /// Create an [IFuture] by forwarding to the constructor [Future.sync].
  _IFuture.sync(FutureOr<T> computation()) : this._(Future.sync(computation));

  /// Create an [IFuture] by forwarding to the constructor [Future.value].
  _IFuture.value(FutureOr<T> value) : this._(Future.value(value));

  /// Create an [IFuture] by forwarding to the constructor [Future.error].
  _IFuture.error(Object error, [StackTrace? stackTrace])
      : this._(Future.error(error, stackTrace));

  /// Create an [IFuture] by forwarding to the constructor [Future.delayed].
  _IFuture.delayed(Duration duration, [FutureOr<T> computation()?])
      : this._(Future.delayed(duration, computation));

  /// Forward to [Future.any] and return the corresponding [IFuture].
  static IFuture<T> any<T>(Iterable<Future<T>> futures) =>
      IFuture<T>._(Future.any<T>(futures));

  /// Forward to [Future.doWhile] and return the corresponding [IFuture].
  static IFuture<void> doWhile(FutureOr<bool> action()) =>
      IFuture<void>._(Future.doWhile(action));

  /// Forward to [Future.forEach] and return the corresponding [IFuture].
  static IFuture<void> forEach<T>(
    Iterable<T> elements,
    FutureOr action(T element),
  ) =>
      IFuture<void>._(Future.forEach<T>(elements, action));

  /// Forward to [Future.wait] and return the corresponding [IFuture].
  static IFuture<List<T>> wait<T>(
    Iterable<Future<T>> futures, {
    bool eagerError = false,
    void cleanUp(T successValue)?,
  }) =>
      IFuture<List<T>>._(
          Future.wait<T>(futures, eagerError: eagerError, cleanUp: cleanUp));

  /// Forward to [Future.catchError] and return the corresponding [IFuture].
  ///
  /// This method has a more type safe signature than [Future.catchError],
  /// because it only accepts an [onError] argument whose type is a function
  /// that accepts the thrown object.
  ///
  /// When the function also accepts a stack trace, please use
  /// [IFuture.catchErrorWithStack] rather than this method.
  IFuture<T> catchError(FutureOr<T> Function(Object) onError,
          {bool test(Object error)?}) =>
      IFuture<T>._(it.catchError(onError as Function, test: test));

  /// Forward to [Future.catchError] and return the corresponding [IFuture].
  ///
  /// This method has a more type safe signature than [Future.catchError],
  /// because it only accepts an [onError] argument whose type is a function
  /// that accepts the thrown object and a stack trace.
  ///
  /// When the function accepts just one argument, please use
  /// [IFuture.catchError] rather than this method.
  IFuture<T> catchErrorWithStack(
          FutureOr<T> Function(Object, StackTrace) onError,
          {bool test(Object error)?}) =>
      IFuture<T>._(it.catchError(onError as Function, test: test));

  /// Forward to [Future.then] and return the corresponding [IFuture].
  ///
  /// This method has a more type safe signature than [Future.then],
  /// because it only accepts an [onError] argument whose type is a function
  /// that accepts the thrown object.
  ///
  /// When the function also accepts a stack trace, please use
  /// [IFuture.thenWithStack] rather than this method.
  IFuture<R> then<R>(FutureOr<R> onValue(T value),
          {FutureOr<R> Function(Object)? onError}) =>
      IFuture<R>._(it.then<R>(onValue, onError: onError as Function));

  /// Forward to [Future.then] and return the corresponding [IFuture].
  ///
  /// This method has a more type safe signature than [Future.then],
  /// because it only accepts an [onError] argument whose type is a function
  /// that accepts the thrown object and a stack trace.
  ///
  /// When the function accepts just one argument, please use
  /// [IFuture.then] rather than this method.
  IFuture<R> thenWithStack<R>(FutureOr<R> onValue(T value),
          {FutureOr<R> Function(Object, StackTrace)? onError}) =>
      IFuture<R>._(it.then<R>(onValue, onError: onError as Function));

  /// Forward to [Future.timeout] and return the corresponding [IFuture].
  IFuture<T> timeout(Duration timeLimit, {FutureOr<T> onTimeout()?}) =>
      IFuture<T>._(it.timeout(timeLimit, onTimeout: onTimeout));

  /// Forward to [Future.whenComplete] and return the corresponding [IFuture].
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
