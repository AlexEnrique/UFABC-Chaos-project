module main;
import std.math;
import std.range;
import std.algorithm;
import std.random;
import std.array;
import std.stdio;

import plt = matplotlibd.pyplot;

import map.map;
import map.logistic;
import map.functions;
import map.primitives;


// alias Coordinates = Tuple!(real, "x", real, "y"); // <-- map.primitives

Coordinates randomMap(Coordinates input, real randomNo) {
    Coordinates coordinates;
    auto x = input.x, y = input.y;

    if (randomNo < .01) { // [0, .01]
        coordinates.x = 0;
        coordinates.y = 0.16 * y;
    }
    else if (randomNo < .08) { // (.01, .08]
        coordinates.x = 0.20 * x - 0.26 * y;
        coordinates.y = 0.23 * x + 0.22 * y + 1.60;
    }
    else if (randomNo < .15) { // (.08, .15]
        coordinates.x = -0.15 * x + 0.28 * y;
        coordinates.y = 0.26 * x + 0.24 * y + 0.44;
    }
    else { // (.15, 1.0]
        coordinates.x = 0.85 * x + 0.04 * y;
        coordinates.y = -0.04 * x + 0.85 * y + 1.6;
    }

    return coordinates;
}


void main() {
    auto rnd = Mt19937_64(unpredictableSeed!ulong);

    foreach (a; iota(1, 4, .05))
        auto map = logisticMap(a, rnd.uniform01);

    /* real[] x, y;
    foreach (_; 0 .. 100_000) {
        auto coord = Coordinates(rnd.uniform01(), rnd.uniform01());
        foreach (k; 0 .. 100)
            coord = coord.randomMap(rnd.uniform01);
        //
        x ~= coord.x;
        y ~= coord.y;
    }

    // matplotlib
    plt.plot(x, y, "g,");
    plt.title("Barnsley fern");
    plt.xlim(0, 4);
    plt.ylim(0, 1);
    plt.xlabel("parameter $a$");
    plt.ylabel("orbit");
    plt.savefig("./figures/barnsley_fern.png");
    plt.show();
    plt.clear(); */
}
