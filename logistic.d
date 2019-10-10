module logistic;
import map;

class LogisticMap(real a) : Map!(x => a*x*(1-x)) {
    this(real x) {
        super(x);
    }
}

unittest {
    auto map = new LogisticMap!2(0.01);

    import std.stdio : writefln;
    while (!map.isAtFixedPoint) {
        writefln(" %s%.5f", (map.front > 0 ? " " : ""), map.front);
        map.popFront();
    }
}
