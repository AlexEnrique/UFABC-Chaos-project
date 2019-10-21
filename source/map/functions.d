module map.functions;
import std.math;
import map.map;
import map.logistic;
import map.primitives;

bool isSink(alias f)(Map!f map, real point) {
    return abs(diff(&f, point).result) < 1;
}

bool isSource(alias f)(Map!f map, real point) {
    return abs(diff(&f, point).result) > 1;
}

unittest {
    auto map = new LogisticMap!(2);
    assert(map.isSink(.5));
    assert(map.isSource(0));
}
