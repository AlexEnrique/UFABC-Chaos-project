module map.logistic_map;

import map.map;
import map.traits;

/**
    Range template class LogisticMap.
      This class inherits from the Map class. It defines the
      logistic family.

    Temple values:
      a : the parameter of the logistic map. Given 'a', the class become
      an alias for Map!(x => a*x*(1-x))

    Members:
      this(real x) : sets the initial value of the Map!(x => a*x*(1-x))
*/

/**
    Dynamic LogisticMap!real class.
    This is used to avoid the necessity of the compile time nature
    of the real template value passed to the LogisticMap!real class
*/
auto logisticMap(double a) {
    return new Map!((real x) => a * x * (1 - x));
}

import std.range.primitives;
unittest {
    auto map = logisticMap(2);
    map.setInitialPoint(.01);

    /* BUG: Fix the implementation of isMap!M */
    /* assert(!is(typeof(cast(Map) map) == void)); */
    /* assert(isMap!(typeof(map2))); */

    import std.range : take;
    import std.math : approxEqual;
    assert(map.take(12).approxEqual([0.010000, 0.01980, 0.038816, 0.0746185,
                                     0.138100, 0.23806, 0.362773, 0.4623380,
                                     0.497158, 0.49998, 0.500000, 0.5000000]));
    //
    assert(map.isAtFixedPoint);
    assert(map[0].approxEqual(0.01));
    assert(map[11].approxEqual(0.5));
    assert(map[15464].approxEqual(0.5));
}
