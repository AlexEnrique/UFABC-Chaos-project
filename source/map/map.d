module map.map;

import std.array : Appender;
import std.traits : isCallable, isNumeric, ReturnType;
import std.meta : allSatisfy;
import std.typecons : Tuple, tuple, isTuple;
import std.range : take;

import map.functions;
import map.traits;

// Remove latter; it's here for tests
import std.conv : to;
import std.stdio;


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
class Map(alias mapFunc)
    if (isCallable!mapFunc)
{
    public alias Type = ReturnType!mapFunc;

    private Type _point;
    private Appender!(Type[]) _orbit;
    enum bool empty = false; // infinity range


    // Constructors
    this() {
        _point = _point.init;
        _orbit.clear();
    }

    this(Type initialPoint) {
        _point = initialPoint;
        _orbit.put(initialPoint);
    }

    this(InputType...)(InputType point)
        if (isTuple!Type &&
            InputType.length == _point.length &&
            allSatisfy!(isNumeric, InputType) &&
            areConvertibleTuples!(Tuple!InputType, Type))
    {
        _point = Type(point);
        _orbit.put(_point);
    }

    // Range functions
    @property Type front() const {
        return _point;
    }

    void popFront() {
        static if (isTuple!Type) {
            _point = mapFunc(_point[]);
        }
        else {
            _point = mapFunc(_point);
        }

        _orbit.put(_point);
    }

    typeof(this) save() {
        return this;
    }

    // for convenience to avoid using std.range.drop(R)(R, int)
    void iterate(int numTimes = 1) {
        foreach (_; 0 .. numTimes) popFront();
    }

    Type opIndex(size_t n) {
        while (_orbit.data.length <= n) {
            if (isAtFixedPoint) return _orbit.data[$ - 1];
            popFront();
        }

        return _orbit.data[n];
    }

    @property bool isAtFixedPoint() const {
        import std.math : approxEqual;
        static if (isTuple!Type) {
            return _point == mapFunc(_point[]);
        }
        else {
            return _point == mapFunc(_point);
        }
    }

    // functions to change initial point
    void reset() {
        _orbit.clear();
        _point = _point.init;
    }

    void setInitialPoint(InputType...)(InputType point)
        if (isTuple!Type &&
            InputType.length == _point.length &&
            allSatisfy!(isNumeric, InputType) &&
            areConvertibleTuples!(Tuple!InputType, Type))
    {
        if (this.alreadyInitialized) {
            static if (isTuple!Type) {
                string msg =
                    typeof(this).stringof ~ " already initialized to the value " ~
                    this._orbit.data[0].toString() ~ "\nCall the \"reset()\" member " ~
                    "function to prepare the map for a new initial point";
            }
            else {
                string msg =
                    typeof(this).stringof ~ " already initialized to the value " ~
                    this._orbit.data[0].to!string ~ "\nCall the \"reset()\" member " ~
                    "function to prepare the map for a new initial point";
            }
            //
            throw new MapInitializationException(msg);
        }

        _point = Type(point);
        _orbit.put(_point);
    }

    void setInitialPoint(Type point) {
        if (this.alreadyInitialized) {
            static if (isTuple!Type) {
                string msg =
                    typeof(this).stringof ~ " already initialized to the value " ~
                    this._orbit.data[0].toString() ~ "\nCall the \"reset()\" member " ~
                    "function to prepare the map for a new initial point";
            }
            else {
                string msg =
                    typeof(this).stringof ~ " already initialized to the value " ~
                    this._orbit.data[0].to!string ~ "\nCall the \"reset()\" member " ~
                    "function to prepare the map for a new initial point";
            }
            //
            throw new MapInitializationException(msg);
        }

        _point = point;
        _orbit.put(_point);
    }

    @property private bool alreadyInitialized() {
        return _orbit.data.length != 0;
    }

    public Array apply(Array)(Array array) // Add constaits latter
    {
        Array result;
        foreach (element; array) {
            result ~= mapFunc(element.theta, element.p);
        }

        return result;
    }
}

class MapInitializationException : Exception {
    this(alias f)(Map!f map, string file = __FILE__, size_t line = __LINE__) {
        string msg = Map!f.stringof ~ " already initialized to the value " ~
                     map._orbit.data[0].toString();
        //
        super(msg, file, line);
    }

    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}


unittest {
    alias f = (real x, real y) => tuple!(real, "x", real, "y")(y, - x);
    auto map = new Map!f(1, 0.5);
    map.iterate(7.times);

    alias XYCoordinates = Tuple!(real, "x", real, "y");
    assert(map[0] == XYCoordinates(1, 0.5));
    assert(map[1] == XYCoordinates(0.5, - 1));
    assert(map[2] == XYCoordinates(- 1, - 0.5));
    assert(map[3] == XYCoordinates(- 0.5, 1));
    assert(map[4] == map[0]);

    try {
        map.setInitialPoint(1, 1);
    }
    catch (Exception exception) {
        if (is(typeof(exception) == MapInitializationException))
            assert(1);
    }
}

unittest {
    import std.math : sin;

    real k = 0.1;
    alias stdMapExpression = (real theta, real p) =>
        tuple!(real, "theta", real, "p")(theta + p, p + k * sin(theta));
    //

    auto standardMap = new Map!stdMapExpression;

    auto points = tuple!(real, "theta", real, "p")(1.0, 0.5);
    standardMap.setInitialPoint(points);
}

unittest {
    auto map = new Map!((real x) => 2 * x * (1 - x));
    map.setInitialPoint(0.6);
    map.reset();
    map.setInitialPoint(.01);

    import std.math : approxEqual;
    assert(map.take(12).approxEqual([0.01000, 0.01980, 0.0388158, 0.074618,
                                     0.13810, 0.23806, 0.362773, 0.462338,
                                     0.497158, 0.49998, 0.500000, 0.500000]));
    //

    assert(map.isAtFixedPoint);
    assert(map[0].approxEqual(0.01));
    assert(map[11].approxEqual(0.5));
    assert(map[99915546555464].approxEqual(0.5));
}
