module map.standard_map;

import std.typecons : Tuple;
import std.math : sin;

import map.map;
import map.traits;

private alias ThetaPTuple = Tuple!(real, "theta", real, "p");

auto standardMap(real k) {
    return new Map!( (real theta, real p) =>
                     ThetaPTuple(theta + p, p + k * sin(theta)) );
}

unittest {
    real k = 0.1;
    auto stdMap = standardMap(k);
    stdMap.setInitialPoint(0, 0);
    assert(stdMap.isAtFixedPoint);


    stdMap.reset();
    auto points = ThetaPTuple(1.0, 0.5);
    stdMap.setInitialPoint(points);
}
