module map.primitives;
import std.traits;
import std.range.primitives;

enum bool isMap(M) =
    isRandomAccessRange!M
    && is(ReturnType!((M m) => m.isAtFixedPoint) == bool)
    && __traits(hasMember, M, "isAtFixedPoint")
    && is(typeof((return ref M m) => m.isAtFixedPoint));
//

import std.typecons : Tuple;
alias Coordinates = Tuple!(real, "x", real, "y");
