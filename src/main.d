module main;
import map.map;
import map.logistic;

void main() {
    auto map = new LogisticMap!(4)(0.01);
    import std.range : drop, take;
    import std.stdio : writeln;

    writeln(map.drop(100).front);
}
