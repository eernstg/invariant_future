// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'union/example.dart' as union show main;
import 'member/example.dart' as member show main;

void main() async {
  print("--- Try out invariant futures that are union type based.");
  await union.main();
  print("\n--- Try out invariant futures that are member based.");
  await member.main();
}
