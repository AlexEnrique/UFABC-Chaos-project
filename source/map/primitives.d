module map.primitives;
import std.traits;
import std.range.primitives;

enum bool isMap(M) =
    isInputRange!M
    && isRandomAccessRange!M
    && is(ReturnType!((M m) => m.isAtFixedPoint) == bool)
    && is(typeof((return ref M m) => m.isAtFixedPoint))
    && __traits(hasMember, M, "opCall");
