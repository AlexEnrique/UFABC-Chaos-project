module map.functions;
import std.math;
import scid.calculus : diff;

import map.map;
import map.logistic;
import map.primitives;


bool isSink(alias f)(Map!f map, real point) {
    auto func = function real(real x) { return f(x); };
    return abs(diff(func, point).value) < 1;
}

bool isSource(alias f)(Map!f map, real point) {
    auto func = function real(real x) { return f(x); };
    return abs(diff(func, point).value) > 1;
}

unittest {
    auto map = new LogisticMap!(2);
    assert(map.isSink(.5));
    assert(map.isSource(0));
}
