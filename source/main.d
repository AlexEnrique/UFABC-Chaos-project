module main;
import std.math;
import std.range;
import std.algorithm;
import std.random;
import std.array;
import plt = matplotlibd.pyplot;

import map.map;
import map.logistic;

// Bifurcation diagram example using the logistic map and matplotlibd
void main() {
    auto rnd = Mt19937_64(unpredictableSeed!ulong);

    real[] y;
    real[] x;
    foreach (real a; iota(0, 4, .005)) {
        auto logisticMap = new Map!(x => a*x*(1-x))(rnd.uniform01());
        y ~= logisticMap.drop(100)
                        .take(200)
                        .array;
        x ~= replicate!(real[])([a], 200);
    }

    // matplotlib
    plt.plot(x, y, "r,");
    plt.title("Bifurcation Diagram for the logistic $f_a$ map");
    plt.xlim(0, 4);
    plt.ylim(0, 1);
    plt.xlabel("parameter $a$");
    plt.ylabel("orbit");
    plt.savefig("./figures/bifurcation_diagram.png");
    plt.show();
    plt.clear();
}
