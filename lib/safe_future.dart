// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async' as async;

// See https://github.com/dart-lang/sdk/issues/54543:
// ignore_for_file: unused_element

extension type Future<X>._(async.Future<X> it) implements async.Future<X> {
  Future(async.FutureOr<X> computation()) : this._(async.Future(computation));

  Future.microtask(async.FutureOr<X> computation())
      : this._(async.Future.microtask(computation));

  Future.sync(async.FutureOr<X> computation())
      : this._(async.Future.sync(computation));

  Future.value(async.FutureOr<X> value) : this._(async.Future.value(value));

  Future.error(Object error, [StackTrace? stackTrace])
      : this._(async.Future.error(error, stackTrace));

  Future.delayed(Duration duration, [async.FutureOr<X> computation()?])
      : this._(async.Future.delayed(duration, computation));

  static Future<X> any<X>(Iterable<async.Future<X>> futures) =>
      Future<X>._(async.Future.any<X>(futures));

  static Future<void> doWhile(async.FutureOr<bool> action()) =>
      Future<void>._(async.Future.doWhile(action));

  static Future<void> forEach<X>(
    Iterable<X> elements,
    async.FutureOr action(X element),
  ) =>
      Future<void>._(async.Future.forEach<X>(elements, action));

  static Future<List<X>> wait<X>(
    Iterable<async.Future<X>> futures, {
    bool eagerError = false,
    void cleanUp(X successValue)?,
  }) =>
      Future<List<X>>._(
          async.Future.wait<X>(futures, eagerError: eagerError, cleanUp: cleanUp));

  Stream<X> asStream() => it.asStream();

  Future<X> catchError(Function onError, {bool test(Object error)?}) =>
      Future<X>._(it.catchError(onError, test: test));

  Future<R> chain<R>(async.Future<R> onValue(X value), {Function? onError}) =>
      Future<R>._(it.then<R>(onValue, onError: onError));

  Future<R> then<R>(R onValue(X value), {Function? onError}) =>
      Future<R>._(it.then<R>(onValue, onError: onError));

  Future<X> timeout(Duration timeLimit, {async.FutureOr<X> onTimeout()?}) =>
      Future<X>._(it.timeout(timeLimit, onTimeout: onTimeout));

  Future<X> whenComplete(async.FutureOr<void> action()) =>
      Future<X>._(it.whenComplete(action));
}

extension FutureExtension<X> on async.Future<X> {
  async.Future<bool> get isInvariant async {
    var list = await this.asStream().take(0).toList();
    try {
      list.addAll(<X>[]);
    } catch (_) {
      return false;
    }
    return true;
  }

  Future<X> get coFuture => Future<X>._(this);
}
