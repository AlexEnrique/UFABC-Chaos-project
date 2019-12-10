module map.functions;
import std.math;
import std.traits : isIntegral;

/* BUG: Crashed. See Below
import scid.calculus : diff; */

import map.map;
import map.logistic_map;
import map.traits;


/*
BUG: It was crashed by the new implementation of Map(alias f) for generic types

bool isSink(alias f)(Map!f map, real point) {
    auto func = function real(real x) { return f(x); };
    return abs(func.diff(point).value) < 1;
}

bool isSource(alias f)(Map!f map, real point) {
    auto func = function real(real x) { return f(x); };
    return abs(func.diff(point).value) > 1;
}
*/


/* BUG: Crashed. See above.
unittest {
    auto map = logisticMap(2);
    map.setInitialPoint(.01);

    assert(map.isSink(.5));
    assert(map.isSource(0));
}
*/


// Convenience
alias time = times;

@property T times(T)(T times) if (isIntegral!T) {
    return times;
}

unittest {
    assert(5.times == 5);
    assert(1564.times == 1564);
    assert(1.times == 1);
    assert(55.time == 55);
}
