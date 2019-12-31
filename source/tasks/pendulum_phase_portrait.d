module tasks.pendulum_phase_portrait;

import std.math;
import std.range : take, iota;
import std.algorithm;
import std.random;
import std.array;
import std.stdio;
import std.format : format;
import std.typecons;

import plt = matplotlibd.pyplot;

import map.map;
import map.traits;
import map.functions;
import map.logistic_map;
import map.standard_map;

import ode.runge_kutta;

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


// generating points
import std.typecons : Tuple;
import std.range : iota;
import std.math : PI;
Tuple!(real, "theta", real, "p")[] generatePoints()
{
    auto thetaArray = iota(- 2 * PI, 2 * PI + PI / 4, PI / 4);
    auto pArray = iota(- 2.5, 2.5 + 0.25, 0.25);

    typeof(return) tuples;
    foreach (theta; thetaArray)
    {
        foreach (p; pArray)
        {
            tuples ~= Tuple!(real, "theta", real, "p")(theta, p);
        }
    }

    return tuples;
}


// taks3
void task3() {
    writeln("Running...");

    alias Vector2R = Vector!(real, 2);
    auto vectorField =
        VectorField!(Vector2R)((Vector2R v) => Vector2R(v[1], - sin(v[0])));
    //


    real h = 1e-2;
    int steps = 1_000;
    auto time = iota(0, steps * h, h);

    auto points = generatePoints();
    foreach (point; points) // with (point)
    {
        auto orbit = rungeKutta!(vectorField)(Vector2R(point.theta, point.p), time);

        auto theta = orbit.mapTo!(vec => vec[0]).array;
        auto p = orbit.mapTo!(vec => vec[1]).array;

        plt.plot(theta, p, "-", ["linewidth":0.5]);

        writefln("Calculations done for initial conditions " ~
                 "sets to (%.2f, %.2f)", point.theta, point.p);
    }

    writeln("\nPlotting...");

    // matplotlib-d
    plt.title("Pendulum phase portrait");
    plt.xlim(- 2 * PI, 2 * PI);
    plt.ylim(-2.5, 2.5);
    plt.xlabel("angle $theta$");
    plt.ylabel("conjugated momentum $p$");

    string figurePath = "./figures/pendulum_phase_portrait.png";
    plt.savefig(figurePath);

    writefln("\nFigure generated at %s", figurePath);

    write("\n\aShow figure? [s/n]", '\n', "> ");
    char show;
    readf("%s\n", show);

    if (show == 's')
        plt.show();
    //

    plt.clear();
}
