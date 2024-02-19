// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:invariant_future/invariant_future.dart';

void main() async {
  // Regular `Future` uses dynamically checked covariance.
  {
    final Future<num> fut = Future<int>.error("whatever");
    try {
      await fut.catchError((_) => 1.5);
    } catch (_) {
      print('Return value from function literal failed run-time type check!');
    }
  }

  // Invariant `IFuture` rejects covariance at compile time.
  {
    // final IFuture<num> fut = IFuture<int>.error("whatever"); // Error.
  }
 
  // Regular `Future.then` accepts `onError` of type `Function`.
  {
    final fut = Future<int>.error("This is what the future throws");
    try {
      int i = await fut.then((_) => 1, onError: print);
    } catch (_) {
      print('`onError` has unusable type!');
    }

    final Future<num> fut2 = Future<int>.error("whatever");
    try {
      num n = await fut2.then((n) => n, onError: (_) => "Hello!");
    } catch (_) {
      print('`onError` return value failed run-time type check!');
    }
  }

  // `IFuture.then` accepts `onError` accepts both safe types.
  {
    final fut = IFuture<num>.error("whatever");

    // Compile-time error:
    // num n = await fut.then((n) => n, onError: ((_) => "Hello!").u21);

    num n = await fut.then((n) => n, onError: ((_) => 1.5).u21);
    print('Safe call of `IFuture` returned $n');
  }



}
