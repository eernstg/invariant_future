// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async' as async show Future, FutureOr;

extension type Future<T>._(async.Future<T> _it) extends Future<T> {
  Future(FutureOr<T> computation()) : this._(async.Future(computation));

  Future.microtask(FutureOr<T> computation())
      : this._(async.Future.microtask(computation));

  Future.sync(FutureOr<T> computation())
      : this._(async.Future.sync(computation));

  Future.value([FutureOr<T>? value]) : this._(async.Future.value(value));

  Future.error(Object error, [StackTrace? stackTrace])
      : this._(async.Future.error(error, stackTrace));

  Future.delayed(Duration duration, [FutureOr<T> computation()?])
      : this._(async.Future.delayed(duration, computation));

  static Future<List<T>> wait<T>(
    Iterable<Future<T>> futures, {
    bool eagerError = false,
    void cleanUp(T successValue)?,
  }) =>
      _it.wait<T>(futures, eagerError: eagerError, cleanUp: cleanUp);

  static Future<T> any<T>(Iterable<Future<T>> futures) => _it.any<T>(futures);

  static Future<void> forEach<T>(
    Iterable<T> elements,
    FutureOr action(T element),
  ) =>
      _it.forEach<T>(elements, action);

  static Future<void> doWhile(FutureOr<bool> action()) => _it.doWhile(action);

  Future<R> then<R>(FutureOr<R> onValue(T value), {Function? onError}) =>
      _it.then<R>(onValue, onError: onError);

  Future<T> catchError(Function onError, {bool test(Object error)?}) =>
      _it.catchError(onError, test: test);

  Future<T> whenComplete(FutureOr<void> action()) => _it.whenComplete(action);

  Stream<T> asStream() => _it.asStream();

  Future<T> timeout(Duration timeLimit, {FutureOr<T> onTimeout()?}) =>
      _it.timeout(timeLimit, onTimeout: onTimeout);
}
