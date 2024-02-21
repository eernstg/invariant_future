// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:invariant_future/invariant_future_union.dart';

// A regular `Future` uses dynamically checked covariance.
Future<void> useFutureCatchError() async {
  final Future<num> fut = Future<int>.error("whatever");
  try {
    await fut.catchError((_) => 1.5);
  } catch (_) {
    print("The error handler did not return a value of the Future's type!");
  }
}

// An invariant `IFuture` rejects covariance at compile time.
Future<void> useIFutureCatchError() async {
  // final IFuture<num> fut = IFuture<int>.error("whatever"); // Error.
}

// A regular `Future.then` accepts an `onError` of type `Function`.
Future<void> useFutureThen() async {
  final fut = Future<int>.error("This is what the future throws");
  try {
    int i = await fut.then((_) => 1, onError: (int i) => i + 1);
  } catch (_) {
    print("`onError` has a type which cannot be used!");
    fut.ignore(); // Usage of `onError` failed.
  }

  final Future<num> fut2 = Future<int>.error("whatever");
  try {
    num n = await fut2.then((_) => 1, onError: (_) => "Hello!");
  } catch (_) {
    print("`onError` return value failed run-time type check!");
  }
}

// `IFuture.then` uses an `onError` that accepts both types, safely.
Future<void> useIFutureThen() async {
  final fut = IFuture<num>.error("This is what the iFuture throws");

  // Compile-time error:
  // int i = await fut.then((_) => 1, onError: ((int i) => i + 1).u21);

  // But this is OK:
  num n = await fut.then((_) => 1, onError: ((_) => 1.5).u21);
  print("Safe call of `IFuture.then` returned $n");

  // Again a compile-time error:
  // final IFuture<num> fut2 = IFuture<int>.error("whatever");

  // But this is OK:
  final fut2 = IFuture<num>.error("whatever");
  n = await fut2.then((_) => 1, onError: ((_, __) => 2.5).u22);
  print("Safe call of `IFuture.then` with stack trace returned $n");
}

void main() async {
  await useFutureCatchError();
  await useIFutureCatchError();
  await useFutureThen();
  await useIFutureThen();
}
