# Safe Futures

The repository `safe_future` provides the library `safe_future.dart` that
exports an extension type `SafeFuture<T>` which is intended to be used as
a replacement for types of the form `Future<T>` where `Future` resolves
to the class of that name which is exported by 'dart:core'.

Note that `SafeFuture<T>` can be used as the type of a variable, parameter,
etc, but it is not usable as a superinterface (no extension type can be used
as any kind of superinterface), and it cannot be used as the return type of a
function whose body is `async` (because `SafeFuture<T>` isn't a supertype of
`Future<Never>`).

In other words, `SafeFuture` is helpful in that it provides a safer signature
for several members of `Future`, but it must in general be introduced in
client code (e.g., as the type of a local variable) because it can't be the
return type of a typical function that returns a future (because most of
those have an `async` body).

An extension getter `safe` is provided in order to make it more convenient
to access a given future using the interface of `SafeFuture`.

