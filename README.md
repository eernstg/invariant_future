# Invariant Futures

The repository `invariant_future` provides the libraries
`invariant_future_union.dart` and `invariant_future_member.dart` that
export an extension type `IFuture<T>` which is intended to be used as a
replacement for types of the form `Future<T>` (where `Future` is the
built-in class of that name).

The intention is that one of these libraries is imported into a library
where there is a perceived need for improved type safety with futures, but
not both. The two libraries use the same name `IFuture` for the "More
Typesafe Future" class because they aren't expected to be imported
together. The difference is described below.

The two libraries illustrate two different ways to improve the safety of
futures. They use exactly the same approach to make `Future` invariant in
its type parameter. However, they use two different approaches to make two
specific methods type safe, namely `catchError` and `then`. Those two
methods both have a formal parameter whose declared type is `Function`.
The type `Function` is basically the same thing as `dynamic`, but for
functions. Consequently, invocations of those two methods are not type
safe. This package improves on that situation.

The `IFuture` in `invariant_future_union.dart` uses a union type as the
declared type of those parameters. The `IFuture` in
`invariant_future_member.dart` uses a plain function type, but it
introduces an additional member name (`catchErrorWithStack` and
`thenWithStack`) to allow for an actual argument which is a function that
accepts a `StackTrace` as well as the `Object` which was thrown.

Both approaches require a certain amount of code migration, and the
provision of both variants makes it easy to experiment with both approaches
and see what works better. 

The `..._union.dart` approach requires the function arguments to have a
suffix in order to indicate explicitly which variant of the union type is
being used for this call. So `myFuture.catchError((x) => e)` would become
`myFuture(((e) => e).u21)` to indicate that we're using a function that
doesn't accept a stack trace, that is, type number 1 in the union
type. Similarly, `myFuture.catchError((x, s) => e)` becomes
`myFuture.catchError(((x, s) => e).u22)`, indicating that we're using the
type which is number 2 in the union type.

The `..._member.dart` approach allows us to use the source code with no
changes in the case where the given function does not accept a
`StackTrace`. Hence, `myFuture.catchError((x) => e)` stays the same.
On the other hand, `myFuture.catchError((x, s) => e)` becomes
`myFuture.catchErrorWithStack((x, s) => e)`, indicating that we're
passing a function that does accept a `StackTrace`.

The two libraries are otherwise identical, and the following applies to
both.

`IFuture<T>` can be used as the type of a variable, parameter, etc, but it
is not usable as a superinterface (no extension type can be used as any
kind of superinterface), and it cannot be used as the return type of a
function whose body is `async` (because `IFuture<T>` isn't a supertype of
`Future<Never>`).

In other words, `IFuture` is helpful in that it provides a safer signature
for several members of `Future`, but it must in general be introduced in
client code (e.g., as the type of a local variable) because it can't be the
return type of a typical function that returns a future (because most of
those have an `async` body).

Finally, an extension getter `iFuture` is provided in order to make it more
convenient to access a given future using the interface of `IFuture`.
