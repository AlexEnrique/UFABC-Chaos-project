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

string[] tasksOptions;
void function()[uint] taskList;

static this() {
    tasksOptions ~= "1. Plot the phase portrait of the standard map for a " ~
        "specific value of the parameter k.";
    //
    tasksOptions ~= "2. Plot the phase portrait of the standard map varying " ~
        "the parameter k.";
    //
    tasksOptions ~= "3. Plot the phase portrait of the pendulum.";

    ///

    taskList[1] = &tasks.standard_map_phase_portrait.task1;
    taskList[2] = &tasks.standard_map_phase_portrait.task2;
    taskList[3] = &tasks.pendulum_phase_portrait.task3;
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

    writeln("Which task would you like the program to perform?");
    tasksOptions.writeList();

    writeln("================================================================");

    uint option;
    write("> ");
    stdin.readf("%d\n", option);
    writeln();

    if (!taskList.keys.canFind(option)) {
        writefln("\n\aError: invalid option %d.", option);
        writeln("\nFinalizando...");
        return;
    }

    auto task = taskList[option];
    task();

    writeln("\nFinalizando...");
}
