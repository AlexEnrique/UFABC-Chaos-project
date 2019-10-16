module main;
import std.math;
import std.range;
import std.algorithm;
import plt = matplotlibd.pyplot;

import map.map;
import map.logistic;

// Example using the logistic map and matplotlibd
void main() {
    auto logisticMap = new LogisticMap!(4)(0.01);
    auto map2 = new LogisticMap!(4)(0.010001);

    uint numPoints = 50;
    auto x = iota(numPoints);
    auto y = logisticMap.take(numPoints);

    auto x2 = iota(numPoints);
    auto y2 = map2.take(numPoints);

    plt.plot(x, y, "b-", ["label": "$f_4$ with $x_0$ = .01"]);
    plt.plot(x2, y2, "r--", ["label": "$f_4$ with $x_0$ = .010001"]);
    plt.legend(["loc": "upper left"]);
    plt.ylim(0, 1);
    plt.title("Two orbits for the logistic map with parameter 4");
    plt.xlabel("step (n)");
    plt.ylabel("$x_n$");
    plt.savefig("./figures/logistic.png");
    plt.show();
    plt.clear();
}
