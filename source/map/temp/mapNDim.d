module map.temp.mapNDim;
import std.array : Appender;
import std.traits : isCallable, ReturnType, isImplicitlyConvertible;
import std.meta : allSatisfy;
import std.range : drop;
import std.typecons : Tuple, tuple;


// Remove latter; it's here to tests
import std.traits : isNumeric;
//


import map.functions;

class Map(alias mapFunc) if (isCallable!mapFunc) {
    public alias Type = ReturnType!mapFunc;

    private Type _point;
    private Appender!(Type[]) _orbit;
    public enum bool empty = true; // infinity range

    // Constructors
    this() {
        _point = _point.init;
        _orbit.clear();
    }

    this(Type initialPoint) {
        _point = initialPoint;
        _orbit.put(initialPoint);
    }

    this(Args...)(Args initialPoint)
        if (Args.length == _point.length && allSatisfy!(isNumeric, Args)) // TODO: Change this
    {
        _point = Type(initialPoint);
        _orbit.put(_point);
    }

    // Range functions
    @property Type front() const {
        return _point;
    }

    void popFront() {
        _point = mapFunc(_point[]);
        _orbit.put(_point);
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

    @property isAtFixedPoint() const {
        return _point == mapFunc(_point[]);
    }

    void resetMap() {
        _orbit.clear();
        _point = _point.init;
    }

    void setInitialPoint(Args...)(Args point)
        if (Args.length == _point.length && allSatisfy!(isNumeric, Args))
    {
        if (this.alreadyInitialized) {
            string msg =
                typeof(this).stringof ~ " already initialized to the value " ~
                this._orbit.data[0].toString();
            //
            throw new MapInitializationException(msg);
        }

        _point = Type(point);
        _orbit.put(_point);
    }

    void setInitialPoint(Type point) {
        if (this.alreadyInitialized) {
            string msg =
                typeof(this).stringof ~ " already initialized to the value " ~
                this._orbit.data[0].toString();
            //
            throw new MapInitializationException(msg);
        }

        _point = point;
        _orbit.put(_point);
    }

    @property private bool alreadyInitialized() {
        return _orbit.data.length != 0;
    }

    typeof(this) save() {
        return this;
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

    assert(map[0] == Tuple!(real, "x", real, "y")(1, 0.5));
    assert(map[1] == Tuple!(real, "x", real, "y")(0.5, - 1));
    assert(map[2] == Tuple!(real, "x", real, "y")(- 1, - 0.5));
    assert(map[3] == Tuple!(real, "x", real, "y")(- 0.5, 1));
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

    standardMap.setInitialPoint(1.0, 0.5);
}
