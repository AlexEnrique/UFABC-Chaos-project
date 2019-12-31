module main;
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
alias mapTo = std.algorithm.map;

import tasks.pendulum_phase_portrait;
import tasks.standard_map_phase_portrait;
import tasks.sensitive_dependence;
import tasks.stable_and_unstable_manifolds;

string[] taskOptions;
void function()[uint] taskList;

static this() {
    taskOptions ~= "1. Plot the phase portrait of the standard map for a " ~
        "specific value of the parameter k.";
    //
    taskOptions ~= "2. Plot the phase portrait of the standard map varying " ~
        "the parameter k.";
    //
    taskOptions ~= "3. Plot the phase portrait of the pendulum.";
    //
    taskOptions ~= "4. List 1 - problem 10";
    //
    taskOptions ~= "5. Sensitive dependence of the logistic map f_4";
    //
    taskOptions ~= "6. Stable and unstable manifolds of the standard map " ~
                    "at the origin";
    //

    ///

    taskList[1] = &tasks.standard_map_phase_portrait.task1;
    taskList[2] = &tasks.standard_map_phase_portrait.task2;
    taskList[3] = &tasks.pendulum_phase_portrait.task3;
    taskList[4] = &tasks.sensitive_dependence.task4;
    taskList[5] = &tasks.sensitive_dependence.task5;
    taskList[6] = &tasks.stable_and_unstable_manifolds.task6;
}

void writeList(string[] list) {
    foreach (item; list[0 .. $ - 1]) {
        writeln(item, '\n');
    }
    writeln(list[$ - 1]);
}


// main()
void main() {
    writeln();
    writeln("================================================================");

    writeln(" ** Which task would you like the program to perform? **\n");
    taskOptions.writeList();

    writeln("================================================================");

    uint option;
    write("> ");
    stdin.readf("%d\n", option);
    writeln();

    if (!taskList.keys.canFind(option)) {
        writefln("\n\aError: invalid option %d.", option);
        writeln("\nExiting...");
        return;
    }

    auto task = taskList[option];
    task();

    writeln("\nExiting...");
}
