// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

extension type SafeFuture<T>._(Future<T> _it) implements Future<T> {
  SafeFuture(FutureOr<T> computation()) : this._(Future(computation));

  SafeFuture.microtask(FutureOr<T> computation())
      : this._(Future.microtask(computation));

  SafeFuture.sync(FutureOr<T> computation()) : this._(Future.sync(computation));

  SafeFuture.value([FutureOr<T>? value]) : this._(Future.value(value));

  SafeFuture.error(Object error, [StackTrace? stackTrace])
      : this._(Future.error(error, stackTrace));

  SafeFuture.delayed(Duration duration, [FutureOr<T> computation()?])
      : this._(Future.delayed(duration, computation));

  static SafeFuture<List<T>> wait<T>(
    Iterable<Future<T>> futures, {
    bool eagerError = false,
    void cleanUp(T successValue)?,
  }) =>
      SafeFuture<List<T>>._(Future.wait<T>(futures,
          eagerError: eagerError, cleanUp: cleanUp));

  static SafeFuture<T> any<T>(Iterable<Future<T>> futures) =>
      SafeFuture<T>._(Future.any<T>(futures));

  static SafeFuture<void> forEach<T>(
    Iterable<T> elements,
    FutureOr action(T element),
  ) =>
      SafeFuture<void>._(Future.forEach<T>(elements, action));

  static SafeFuture<void> doWhile(FutureOr<bool> action()) =>
      SafeFuture<void>._(Future.doWhile(action));

  SafeFuture<R> then<R>(FutureOr<R> onValue(T value), {Function? onError}) =>
      SafeFuture<R>._(_it.then<R>(onValue, onError: onError));

  SafeFuture<T> catchError(Function onError, {bool test(Object error)?}) =>
      SafeFuture<T>._(_it.catchError(onError, test: test));

  SafeFuture<T> whenComplete(FutureOr<void> action()) =>
      SafeFuture<T>._(_it.whenComplete(action));

  Stream<T> asStream() => _it.asStream();

  SafeFuture<T> timeout(Duration timeLimit, {FutureOr<T> onTimeout()?}) =>
      SafeFuture<T>._(_it.timeout(timeLimit, onTimeout: onTimeout));
}
