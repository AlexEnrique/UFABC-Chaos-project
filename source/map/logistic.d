module map.logistic;
import map.map;

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
class LogisticMap(real a) : Map!(x => a*x*(1-x)) {
    this(real x) {
        super(x);
    }
}

unittest {
    auto map = new LogisticMap!2(0.01);

    import std.range : take;
    import std.math : approxEqual;
    assert(map.take(12).approxEqual([0.01000, 0.01980, 0.0388159, 0.0746185,
                                     0.138101, 0.238058, 0.362773, 0.462338,
                                     0.497163, 0.499984, 0.50000, 0.50000]));
    //
    assert(map.isAtFixedPoint);
    assert(map[0].approxEqual(0.01));
    assert(map[11].approxEqual(0.5));
    assert(map[15464].approxEqual(0.5));
}
