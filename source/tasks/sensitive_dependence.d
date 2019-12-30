module tasks.sensitive_dependence;

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
import map.functions;
import map.logistic_map;

string itinerary(Map)(Map map, long n = -1) {
    string it; // already initialized to "" in Dlang

    if (n == -1) n = 4;
    foreach (j; 0 .. n) it ~= map[j] < .5 ? "L" : "R";

    return it;
}

void task4() {
    alias TentMap = Map!((real x) => x < .5 ? 2 * x : 2 * (1 - x));

    auto rnd = Mt19937_64(unpredictableSeed!ulong);
    auto maps = [new TentMap(rnd.uniform01), new TentMap(rnd.uniform01)];

    while ( !(abs(maps[0][0] - maps[1][0]) < .01
              && abs(maps[0][7] - maps[1][7]) > .25) )
    {
        maps[1].reset();
        maps[1].setInitialPoint(rnd.uniform01);
    }

    writefln("Found points:" ~ "\n\t" ~
             "p = %.9f" ~ "\n\t" ~
             "q = %.9f" ~ "\n" ,
             maps[0][0], maps[1][0]);
    //

    writefln("Itineraries:" ~ "\n\t" ~
             "p <--> %s" ~ "\n\t" ~
             "q <--> %s" ~ "\n" ,
             maps[0].itinerary(9), maps[1].itinerary(9));
}


void task5() {
    writeln("Running...");
    auto map = logisticMap(4);

    auto initialConditions = [.01, .0100001];
    string[real] style = [initialConditions[0] : "b-",
                          initialConditions[1] : "r--"];
    //
    string[real] label = [initialConditions[0] : "$f_4$ with $x_0$ = .01",
                          initialConditions[1] : "$f_4$ with $x_0$ = .010001"];
    //

    writeln("Ploting...");
    foreach (init; initialConditions) {
        map.reset();
        map.setInitialPoint(init);
        auto points = map.take(51);

        plt.plot(iota(51), points, style[init], ["label" : label[init]]);
    }

    plt.title("Two orbits for the logistic map with parameter 4");
    plt.legend(["loc" : "upper left"]);
    plt.xlabel("step (n)");
    plt.ylabel("$x_n$");
    plt.ylim(0, 1);
    plt.savefig("./figures/logistic.png");


    writeln("\nFigure generated at ", `"figures/logistic.png"`);
    write("\n\aShow figure? [s/n]", '\n', "> ");
    char showOpt = 's';
    readf("%s\n", showOpt);

    if (showOpt == 's')
        plt.show();
    //
    plt.clear();
}
