// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:extension_type_unions/extension_type_unions.dart';

typedef _Inv<X> = X Function(X);
typedef IFuture<X> = _IFuture<X, _Inv<X>>;

// See https://github.com/dart-lang/sdk/issues/54543:
// ignore_for_file: unused_element

// Use the same syntax as in the declaration of `Future`.
// ignore_for_file: use_function_type_syntax_for_parameters

extension type _IFuture<X, Invariance extends _Inv<X>>._(Future<X> it)
    implements Future<X> {
  _IFuture(FutureOr<X> computation()) : this._(Future(computation));

  _IFuture.microtask(FutureOr<X> computation())
      : this._(Future.microtask(computation));

  _IFuture.sync(FutureOr<X> computation()) : this._(Future.sync(computation));

  _IFuture.value(FutureOr<X> value) : this._(Future.value(value));

  _IFuture.error(Object error, [StackTrace? stackTrace])
      : this._(Future.error(error, stackTrace));

  _IFuture.delayed(Duration duration, [FutureOr<X> computation()?])
      : this._(Future.delayed(duration, computation));

  static IFuture<X> any<X>(Iterable<Future<X>> futures) =>
      IFuture<X>._(Future.any<X>(futures));

  static IFuture<void> doWhile(FutureOr<bool> action()) =>
      IFuture<void>._(Future.doWhile(action));

  static IFuture<void> forEach<X>(
    Iterable<X> elements,
    FutureOr action(X element),
  ) =>
      IFuture<void>._(Future.forEach<X>(elements, action));

  static IFuture<List<X>> wait<X>(
    Iterable<Future<X>> futures, {
    bool eagerError = false,
    void cleanUp(X successValue)?,
  }) =>
      IFuture<List<X>>._(
          Future.wait<X>(futures, eagerError: eagerError, cleanUp: cleanUp));

  Stream<X> asStream() => it.asStream();

  IFuture<X> catchError(
          Union2<FutureOr<X> Function(Object),
                  FutureOr<X> Function(Object, StackTrace)>
              onError,
          {bool test(Object error)?}) =>
      IFuture<X>._(it.catchError(onError as Function, test: test));

  IFuture<R> then<R>(FutureOr<R> onValue(X value),
          {Union2<FutureOr<R> Function(Object),
                  FutureOr<R> Function(Object, StackTrace)>?
              onError}) =>
      IFuture<R>._(it.then<R>(onValue, onError: onError as Function));

  IFuture<X> timeout(Duration timeLimit, {FutureOr<X> onTimeout()?}) =>
      IFuture<X>._(it.timeout(timeLimit, onTimeout: onTimeout));

  IFuture<X> whenComplete(FutureOr<void> action()) =>
      IFuture<X>._(it.whenComplete(action));
}

extension IFutureExtension<X> on Future<X> {
  IFuture<X> get iFuture => IFuture<X>._(this);

  Future<bool> get isInvariant async {
    var list = await asStream().take(0).toList();
    try {
      list.addAll(<X>[]);
    } catch (_) {
      return false;
    }
    return true;
  }

  IFuture<X> get safe => IFuture<X>._(this);
}
