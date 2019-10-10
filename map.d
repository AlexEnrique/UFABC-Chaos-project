module map;

/**
    Range template class Map. It aims to store all the map information
    and update methods of a one dimensional map

    Temple values:
      alis f -- f must be a __lambda1 callable (one argument)

    Members:
      private real _x : the current value of the map
      (the current value of the orbit)

      enum bool empty : range parameter for emptiness
      (it is always false as Map is a infinity range)

      @property real front : get the current value of _x

      void popFront() : update the value of _x

      @property bool isAtFixedPoint : returns true if the
      current value of _x is a fixed point
*/
class Map(alias f) {
    private real _x;
    enum bool empty = false;

    this(real x) {
        _x = x;
    }

    @property real front() const {
        return _x;
    }

    void popFront() {
        _x = f(_x);
    }

    @property bool isAtFixedPoint() const {
        return _x == f(_x);
    }
}

unittest {
    import std.range : take;
    import std.algorithm.comparison : equal;
    import std.math : approxEqual;
    auto map = new Map!(x => 2*x*(1-x))(0.01);
    assert(map.take(12).approxEqual([0.01000, 0.01980, 0.0388159, 0.0746185,
                                     0.138101, 0.238058, 0.362773, 0.462338,
                                     0.497163, 0.499984, 0.50000, 0.50000]));
    //
    assert(map.isAtFixedPoint);
}
