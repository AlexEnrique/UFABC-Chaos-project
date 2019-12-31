module tasks.standard_map_phase_portrait;

import std.math;
import std.range : take, iota;
import std.algorithm;
import std.random;
import std.array;
import std.stdio;
import std.format : format;
import std.typecons;
import std.conv : to;

import plt = matplotlibd.pyplot;

import map.map;
import map.traits;
import map.functions;
import map.logistic_map;
import map.standard_map;

import std.range : isInputRange;
import std.traits : Unqual;
template mapTo(fun...) if (fun.length >= 1)
{
    auto mapTo(Range)(Range r)
        if (isInputRange!(Unqual!Range))
    {
        return std.algorithm.map!(fun)(r);
    }
}


void task1() {
    real k;
    write("What is the value of k?", '\n', "> ");
    stdin.readf("%f\n", k);
    writeln("Running...");

    auto map = standardMap(k);

    auto domain = iota(0, 2 * PI + 2 * PI / 10, 2 * PI / 10);
    auto initialConditions = cartesianProduct(domain, domain)
                                .array()
                                .to!(Tuple!(real, "theta", real, "p")[]);
    //
    foreach (n; 0 .. initialConditions.length) {
        map.reset();
        map.setInitialPoint(initialConditions[n]);

        auto orbit = map.take(300.points);
        auto theta = orbit.mapTo!(tup => tup.theta).array;
        auto p = orbit.mapTo!(tup => tup.p).array;

        plt.plot(p, theta, ",");
    }

    writeln("\nPlotting...");

    // matplotlib-d
    plt.title(format("Standard Map evolution for k = %.2f", k));
    plt.xlim(0, 2 * PI);
    plt.ylim(0, 2 * PI);
    plt.xlabel("momentum $p$");
    plt.ylabel("angle $theta$");

    string figurePath = format("./figures/standard_map_(k=%.2f).png", k);
    plt.savefig(figurePath);
    writefln("Figure generated for k = %.2f at %s", k, figurePath);

    write("\n\aShow figure? [s/n]", '\n', "> ");
    char show = 's';
    readf("%s\n", show);

    if (show == 's')
        plt.show();
    //
    plt.clear();
}



void task2() {
    alias mapTo = std.algorithm.map;

    writeln("Running...");
    foreach (real k; iota(0.0, 2.00 + 0.01, 0.01)) {
        auto map = standardMap(k);

        auto domain = iota(0, 2 * PI + 2 * PI / 10, 2 * PI / 10);
        auto initialConditions = cartesianProduct(domain, domain)
                                    .array()
                                    .to!(Tuple!(real, "theta", real, "p")[]);
        //
        foreach (n; 0 .. initialConditions.length) {
            map.reset();
            map.setInitialPoint(initialConditions[n]);

            auto orbit = map.take(400.points);
            auto theta = orbit.mapTo!(tup => tup.theta).array;
            auto p = orbit.mapTo!(tup => tup.p).array;

            plt.plot(p, theta, ",");
        }

        // matplotlib-d
        plt.title(format("Standard Map evolution for k = %.2f", k));
        plt.xlim(0, 2 * PI);
        plt.ylim(0, 2 * PI);
        plt.xlabel("momentum $p$");
        plt.ylabel("angle $theta$");

        string figurePath = format("./figures/standard_map/(k=%.2f).png", k);
        plt.savefig(figurePath);
        writefln("Figure generated for k = %.2f ", k);

        plt.clear();
    }

    writefln("\n\aFigures generated at %s", `./figures/standard_map/`);
}
