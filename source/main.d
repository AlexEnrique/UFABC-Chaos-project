module main;
import std.math;
import std.range : take;
import std.algorithm;
import std.random;
import std.array;
import std.stdio;

import plt = matplotlibd.pyplot;

import map.map;
import map.logistic_map;
import map.functions;
import map.traits;


void main() {
    auto map = new Map!((real x) => 2 * x * (1 - x));
    map.setInitialPoint(.01);


    /*
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
