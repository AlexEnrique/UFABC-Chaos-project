module map.traits;
import std.traits;
import std.range.primitives;
import std.typecons : Tuple, tuple, isTuple;


// Temp.
import std.stdio : writeln;
import std.meta : AliasSeq, allSatisfy;
import std.traits : isNumeric;



enum bool isMap(M) =
    isRandomAccessRange!M
    && __traits(hasMember, M, "isAtFixedPoint")
    && is(ReturnType!((M m) => m.isAtFixedPoint) == bool)
    && is(typeof((return ref M m) => m.isAtFixedPoint));
//


enum bool areConvertibleTuples(From, To) =
    isTuple!From && isTuple!To &&
    allSatisfy!(isNumeric, From.Types) &&
    allSatisfy!(isNumeric, To.Types) &&
    From.Types.length == To.Types.length &&
    {
        /* if (From.Types.length != To.Types.length) return false; */

        static foreach (i; 0 .. From.Types.length)
        {
            if ( !is(From.Types[i] : To.Types[i]) )
                return false;
        }

        return true;
    }();


unittest {
    assert(areConvertibleTuples!( Tuple!(int, int, long),
                                  Tuple!(uint, long, ulong) ));
    //
    assert(areConvertibleTuples!( Tuple!(int, int),
                                  Tuple!(real, real) ));
    //
    assert(areConvertibleTuples!( Tuple!(byte, short),
                                  Tuple!(ubyte, ushort) ));
    //
    assert(areConvertibleTuples!( Tuple!(ubyte, ushort),
                                  Tuple!(uint, uint) ));
    //
    assert(areConvertibleTuples!( Tuple!(ubyte, ushort),
                                  Tuple!(int, int) ));
    //
    assert(areConvertibleTuples!( Tuple!(double, float),
                                  Tuple!(real, real) ));
    //
    assert(areConvertibleTuples!( Tuple!(real, float, long),
                                  Tuple!(real, real, real) ));
    //
    assert(areConvertibleTuples!( Tuple!(uint, long, byte),
                                  Tuple!(long, ulong, int) ));
    //
    assert( !areConvertibleTuples!( Tuple!(uint, long),
                                    Tuple!(long, ulong, int) ));
    //
    assert( !areConvertibleTuples!( Tuple!(char, long),
                                    Tuple!(long, ulong, int) ));
    //

    /* BUG:
    source/map/traits.d(32,19): Error: tuple index 2 exceeds 2

    assert( !areConvertibleTuples!( Tuple!(char, long),
                                    Tuple!(long, ulong, int) ));
    //
    */

    /* BUG:
    source/map/traits.d(32,19): Error: tuple index 1 exceeds 1

    assert( !areConvertibleTuples!( Tuple!(string, uint),
                                    Tuple!(string) ));
    //
    */

    /* BUG: It seems the length comparison is evaluated to true
    source/map/traits.d(28,19): Error: tuple index 1 exceeds 1
    source/map/traits.d(32,9): Warning: statement is not reachable

    assert(areConvertibleTuples!( Tuple!(string, string),
                                  Tuple!(string) ));
    //
    assert(areConvertibleTuples!( Tuple!(string, int),
                                  Tuple!(string) ));
    //
    */


    /* BUG:
    source/map/traits.d(31,9): Warning: statement is not reachable
    /usr/bin/dmd failed with exit code 1.
    REMEBER: is(char : string) == false  and  is(char[] : string) == false;

    assert( !areConvertibleTuples!( Tuple!(string, char),
                                    Tuple!(string, string) ));
    //
    */
}
