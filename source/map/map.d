module map.map;
import map.primitives;
import std.array : Appender;

/**
    Range template class Map.
      It aims to store all the map information
      and update methods of a one dimensional map

    Temple values:
      alis f: f must be a __lambda1 callable (one argument)

    Members:
      this(real x) : 'x' is the initial condition (initial point of the
      orbit). The constructor sets the initial value of _x and _orbit[0]
      to x;

      private real _x : the current value of the map
      (the current value of the orbit)

      private real[] _orbit : the ordered set of _x_0, _x_1, ... points
      of the orbit, with _x_k = f^{k}(_x_0). If x_n is a fixed point, the
      _orbit is finite (although the rage is infinity;
      _x_m = _x_n, for m > n)

      enum bool empty : range parameter for emptiness
      (it is always false as Map is an infinity range)

      @property real front : get the current value of _x

      void popFront() : update the value of _x

      @property bool isAtFixedPoint : returns true if the
      current value of _x is a fixed point

      real opIndex(size_t) : overloads the [] operator. It is used to
      get an element of the _orbit array. If x_n is a fixed point, it
      is the last element of _orbit. opIndex(m) will return _orbit[n],
      for m > n, in this case.
*/
class Map(alias f) {
    private real _x;
    private Appender!(real[]) _orbit;
    enum bool empty = false;

    this() {}

    this(real x) {
        _x = x;
        _orbit.put(x);
    }

    @property real front() const {
        return _x;
    }

    void popFront() {
        _x = f(_x);
        _orbit.put(_x);
    }

    @property bool isAtFixedPoint() const {
        return _x == f(_x);
    }

    real opIndex(size_t n) {
        while (_orbit.data.length <= n) {
            if (isAtFixedPoint) return _orbit.data[$ - 1];
            popFront();
        }

        return _orbit.data[n];
    }

    auto save() {
        return this;
    }
}

unittest {
    auto map = new Map!(x => 2 * x * (1 - x))(0.01);

    assert(isMap!(typeof(map)));

    import std.range : take;
    import std.math : approxEqual;

    assert(map.take(12).approxEqual([0.01000, 0.01980, 0.038816, 0.074618,
                                     0.13810, 0.23806, 0.362773, 0.462338,
                                     0.49716, 0.49998, 0.500000, 0.500000]));
    //
    assert(map.isAtFixedPoint);
    assert(map[0].approxEqual(0.01));
    assert(map[11].approxEqual(0.5));
    assert(map[15464].approxEqual(0.5));
}
