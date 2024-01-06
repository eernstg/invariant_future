// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async' as async show Future, FutureOr;

extension type Future<T>._(async.Future<T> _it) implements async.Future<T> {
  Future(async.FutureOr<T> computation()) : this._(async.Future(computation));

  Future.microtask(async.FutureOr<T> computation())
      : this._(async.Future.microtask(computation));

  Future.sync(async.FutureOr<T> computation())
      : this._(async.Future.sync(computation));

  Future.value([async.FutureOr<T>? value]) : this._(async.Future.value(value));

  Future.error(Object error, [StackTrace? stackTrace])
      : this._(async.Future.error(error, stackTrace));

  Future.delayed(Duration duration, [async.FutureOr<T> computation()?])
      : this._(async.Future.delayed(duration, computation));

  static Future<List<T>> wait<T>(
    Iterable<Future<T>> futures, {
    bool eagerError = false,
    void cleanUp(T successValue)?,
  }) =>
      Future<List<T>>._(async.Future.wait<T>(futures, eagerError: eagerError, cleanUp: cleanUp));

  static Future<T> any<T>(Iterable<Future<T>> futures) =>
      Future<T>._(async.Future.any<T>(futures));

  static Future<void> forEach<T>(
    Iterable<T> elements,
    async.FutureOr action(T element),
  ) =>
      Future<void>._(async.Future.forEach<T>(elements, action));

  static Future<void> doWhile(async.FutureOr<bool> action()) =>
      Future<void>._(async.Future.doWhile(action));

  Future<R> then<R>(async.FutureOr<R> onValue(T value), {Function? onError}) =>
      Future<R>._(_it.then<R>(onValue, onError: onError));

  Future<T> catchError(Function onError, {bool test(Object error)?}) =>
      Future<T>._(_it.catchError(onError, test: test));

  Future<T> whenComplete(async.FutureOr<void> action()) =>
      Future<T>._(_it.whenComplete(action));

  Stream<T> asStream() => _it.asStream();

  Future<T> timeout(Duration timeLimit, {async.FutureOr<T> onTimeout()?}) =>
      Future<T>._(_it.timeout(timeLimit, onTimeout: onTimeout));
}
