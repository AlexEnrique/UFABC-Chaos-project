module tasks.standard_map_phase_portrait;

import std.math;
import std.range : take, iota;
import std.algorithm;
import std.random;
import std.array;
import std.stdio;
import std.format : format;

import plt = matplotlibd.pyplot;

import map.map;
import map.traits;
import map.functions;
import map.logistic_map;
import map.standard_map;

alias mapTo = std.algorithm.map;


void task1() {
    real k;
    write("What is the value of k?", '\n', "> ");
    stdin.readf("%f\n", k);
    writeln("Running...");

    auto map = standardMap(k);
    foreach (_; 0 .. 100) {
        auto rnd = Random(unpredictableSeed);
        map.reset();
        map.setInitialPoint(uniform(0, 2* PI, rnd), uniform(- 2 * PI, 2 * PI, rnd));

        auto orbit = map.take(300.points);
        auto theta = mapTo!(tup => tup.theta)(orbit).array;
        auto p = mapTo!(tup => tup.p)(orbit).array;

        plt.plot(theta, p, ",");
    }

    writeln("\nPlotting...");

    // matplotlib-d
    plt.title(format("Standard Map evolution for k = %.2f", k));
    plt.xlim(0, 2 * PI);
    plt.ylim(0, 2 * PI);
    plt.xlabel("angle $theta$");
    plt.ylabel("momentum $p$");

    string figurePath = format("./figures/standard_map_(k=%.2f).png", k);
    plt.savefig(figurePath);
    writefln("Figure generated for k = %.2f at %s", k, figurePath);

    write("\n\aShow figure? [s/n]", '\n', "> ");
    char show;
    readf("%s\n", show);

    if (show == 's')
        plt.show();
    //
    plt.clear();
}



void task2() {
    alias mapTo = std.algorithm.map;

    writeln("Running...");
    foreach (real k; iota(0.0, .5, 0.01)) {
        auto map = standardMap(k);

        foreach (_; 0 .. 100) {
            auto rnd = Random(unpredictableSeed);
            map.reset();
            map.setInitialPoint(uniform(0, 2* PI, rnd), uniform(- 2 * PI, 2 * PI, rnd));

            auto orbit = map.take(300.points);
            auto theta = mapTo!(tup => tup.theta)(orbit).array;
            auto pMomentum = mapTo!(tup => tup.p)(orbit).array;

            plt.plot(theta, pMomentum, ",", ["linewidth":0.1]);
        }

        // matplotlib-d
        plt.title(format("Standard Map evolution for k = %.2f", k));
        plt.xlim(0, 2 * PI);
        plt.ylim(0, 2 * PI);
        plt.xlabel("angle $theta$");
        plt.ylabel("momentum $p$");

        string figurePath = format("./figures/standard_map/(k=%.2f).png", k);
        plt.savefig(figurePath);
        writefln("Figure generated for k = %.2f ", k);

        plt.clear();
    }

    writefln("\n\aFigures generated at ", "./figures/standard_map/");
}
