module map.algorithm;
import std.math;
import map.map;
import map.logistic;
import map.primitives;

bool isSink(M)(M map, real point)
    if(isMap!M)
{
    real epsilon = 10.0^^(-8);
    return abs((map(point + epsilon / 2) - map(point - epsilon / 2))
           / epsilon) < 1;
}

bool isSource(M)(M map, real point)
    if(isMap!M)
{
    real epsilon = 10.0^^(-8);
    return abs((map(point + epsilon / 2) - map(point - epsilon / 2))
           / epsilon) > 1;
}

unittest {
    auto map = new LogisticMap!(2);
    assert(map.isSink(.5));
    assert(map.isSource(0));
}
