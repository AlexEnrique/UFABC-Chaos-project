module tasks.stable_and_unstable_manifolds;

import std.math;
import std.range : take, iota;
import std.algorithm;
import std.algorithm.iteration : uniq;
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

void task6() {
    real k;
    write("What is the value of k?", '\n', "> ");
    stdin.readf("%f\n", k);
    writeln("Running...");

    auto map = standardMap(k);
    auto reverseMap = reversedStandardMap(k);

    real norm_plus = 1 / sqrt( (1 + k)^^2 / 2 + (k/2) * sqrt(k*(k+4)) );
    real norm_minos = 1 / sqrt( (1 + k)^^2 / 2 - (k/2) * sqrt(k*(k+4)) );

    alias Coordinates = Tuple!(real, "theta", real, "p");
    real eps = .01;
    auto stableManifold = iota(eps, 11 * eps, eps)
                            .mapTo!(x => Coordinates(x * norm_minos,
                                x * (k - sqrt(k*(k+4))) / 2 * norm_minos))
                            .array()
                            .to!(Coordinates[])
                        ~ iota(eps, 11 * eps, eps)
                            .mapTo!(x => - x)
                            .mapTo!(x => Coordinates(x * norm_plus,
                                    x * (k - sqrt(k*(k+4))) / 2 * norm_plus))
                            .array()
                            .to!(Coordinates[]);
    //
    auto unstableManifold = iota(eps, 11 * eps, eps)
                              .mapTo!(x => Coordinates(x * norm_plus,
                                  x * (k + sqrt(k*(k+4))) / 2 * norm_plus))
                              .array()
                              .to!(Coordinates[])
                          ~ iota(eps, 11 * eps, eps)
                              .mapTo!(x => - x)
                              .mapTo!(x => Coordinates(x * norm_plus,
                                  x * (k + sqrt(k*(k+4))) / 2 * norm_plus))
                              .array()
                              .to!(Coordinates[]);
    //

    foreach (_; 0 .. 150) {
        unstableManifold ~= map.apply(unstableManifold[$ - 6 .. $ - 1]);
        stableManifold ~= reverseMap.apply(stableManifold[$ - 6 .. $ - 1]);
    }
    unstableManifold = unstableManifold.uniq().array().to!(Coordinates[]);
    stableManifold = stableManifold.uniq().array().to!(Coordinates[]);
    //

    // Plot manifolds
    writeln("\nPlotting...");

    auto theta = unstableManifold.mapTo!(tup => tup.theta).array;
    auto p = unstableManifold.mapTo!(tup => tup.p).array;
    plt.plot(p, theta, "b,");

    theta = stableManifold.mapTo!(tup => tup.theta).array;
    p = stableManifold.mapTo!(tup => tup.p).array;
    plt.plot(p, theta, "r,");

    plt.title("Stable and unstable manifolds of the standard map");
    plt.xlabel("momentum $p$");
    plt.ylabel("angle $theta$");

    string figurePath = "./figures/manifolds_(k=%.2f).png".format(k);
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














//
