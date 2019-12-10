module ode.runge_kutta;

import std.traits : isNumeric, isIntegral, Unqual, CommonType;
import std.format : format;
import std.conv : to;
import std.algorithm.searching : startsWith;

/*  TODO:
    Usar operador "with" para lidar com Vector!(Type, ulong)
*/

template isVector(V : Vec!Args, alias Vec, Args...)
{
    enum bool isVector = (V.stringof).startsWith("Vector") &&
                         isNumeric!(Args[0]) && isIntegral!(typeof(Args[1]));
}

template CommonType(A : Vec!(T[0, 1]), B : Vec!(T[2, 3]), alias Vec, T...)
    if (T[1] == T[3])
{
    enum auto CommonType = V!(CommonType!(T[0], T[2]), T[1]);
}

struct Vector(T, ulong d)
{
    private T[d] _coordinates;

    // Constructors
    // TODO: implement constructors to accept ranges(/generative ranges)
    this(T[d] coordinates)
    {
        _coordinates = coordinates.dup;
    }

    this(Args...)(Args args)
        if (Args.length == d && is(CommonType!Args : T))
    {
        _coordinates = [args];
    }


    // Methods
    @property size_t length()
    {
        return d;
    }

    string toString()
    {
        string output = format("Vector!(%s, %d)", T.stringof, d);

        output ~= '(';
        foreach (x; _coordinates[0 .. $ - 1])
            output ~= format("%s, ", x);
        //
        output ~= _coordinates[$ - 1].to!string;
        output ~= ')';

        return output;
    }

    // Operators
    /* TODO: Implement opAssing overload */
    T opIndex(size_t n)
    {
        return _coordinates[n];
    }

    size_t opDollar() const
    {
        return d;
    }

    T[] opSlice()
    {
        return _coordinates.dup;
    }

    T[] opSlice(size_t i, size_t j)
    {
        return _coordinates[i .. j];
    }

    Vector!(T, d) opBinaryRight(string op : "*", S)(S scalar)
        if (isNumeric!(Unqual!S))
    {
        T[d] scaledCoordinates;

        foreach (n; 0 .. this.length)
        {
            scaledCoordinates[n] = _coordinates[n] * scalar;
        }

        return Vector!(T, d)(scaledCoordinates);
    }

    Vector!(T, d) opBinary(string op, S)(S scalar)
        if (isNumeric!(Unqual!S) && (op == "*" || op == "/"))
    {
        T[d] scaledCoordinates;

        foreach (n; 0 .. this.length)
        {
            mixin("scaledCoordinates[n] = _coordinates[n] " ~ op ~ " scalar;");
        }

        return Vector!(T, d)(scaledCoordinates);
    }

    auto opBinary(string op, V : U!Args, alias U, Args...)(V lhs)
        if ((op == "+" || op == "-") &&
            isNumeric!(CommonType!(T, Args[0])) && Args[1] == d)
    {
        alias Common = CommonType!(T, Args[0]);
        Common[d] newCoordinates;

        foreach (n; 0 .. this.length)
        {
            mixin("newCoordinates[n] =
                   this._coordinates[n] " ~ op ~ " lhs[n];");
        }

        return Vector!(Common, d)(newCoordinates);
    }
}


template isVectorField(VField : V!IO, alias V, IO...)
{
    enum bool isVectorField = (VField.stringof).startsWith("VectorField") &&
                              isVector!(IO[0]) && isVector!(IO[1]);
}

template CommonType(A : VF!(T[0, 1]), B : VF!(T[2, 3]), alias VF, T...)
{
    // The common type between VectorField!(F, G) && VectorField!(H, J)
    enum auto CommonType =
        VectorField!( CommonType!(T[0], T[2]), CommonType!(T[1], T[3]) );
}

struct VectorField(InputType, OutputType)
{
    private OutputType delegate(real, InputType) _f;

    this(F : OutputType function(InputType))(F func)
    {
        _f = delegate OutputType(real t, InputType v) { return func(v); };
    }


    this(F)(F func)
        if (is(F == OutputType function(real, InputType)) ||
            is(F == OutputType delegate(real, InputType)))
    {
        _f = delegate OutputType(real t, InputType v) { return func(t, v); };
    }

    OutputType opCall(real t, InputType v)
    {
        return _f(t, v);
    }

    auto opBinary(string op, VField : VF!IO, alias VF, IO...)(VField rhs)
        if (op == "+" || op == "-" && isVectorField!VField)
    {
        alias Input = CommonType!(InputType, IO[0]);
        alias Output = CommonType!(OutputType, IO[1]);
        alias ReturnType = CommonType!(typeof(this), VField);

        return mixin("ReturnType((real t, Input v) =>
            cast(Output)( this._f(t, v) " ~ op ~ " rhs._f(t, v)) )");
    }
}

struct VectorField(InputType : OutputType, OutputType)
{
    alias VectorType = OutputType;
    private VectorType delegate(real, VectorType) _f;

    this(F : VectorType function(VectorType))(F func)
    {
        _f = delegate VectorType(real t, VectorType v) { return func(v); };
    }


    this(F)(F func)
        if (is(F == VectorType function(real, VectorType)) ||
            is(F == VectorType delegate(real, VectorType)))
    {
        _f = delegate VectorType(real t, VectorType v) { return func(t, v); };
    }

    // TODO: Implement
    // this(string fx, string fy, string fz)
    // {
    //    _f = (real t, Vector v) => mixin();
    // }

    VectorType opCall(real t, VectorType v)
    {
        return _f(t, v);
    }

    auto opBinary(string op, VField : VF!IO, alias VF, IO...)(VField rhs)
        if (op == "+" || op == "-" && isVectorField!VField)
    {
        alias Input = CommonType!(InputType, IO[0]);
        alias Output = CommonType!(OutputType, IO[1]);
        alias ReturnType = CommonType!(typeof(this), VField);

        return mixin("ReturnType((real t, Input v) =>
            cast(Output)( this._f(t, v) " ~ op ~ " rhs._f(t, v)) )");
    }
}


V[] rungeKutta(alias vectorField, V, R)(V w0, R time)
    if (isVectorField!(typeof(vectorField)))
in
{
    assert(time.length > 1);
}
body
{
    V[] w = [w0];
    V[4] k;
    real h = time[1] - time[0];

    foreach (t; time[1 .. $])
    {
        k[0] = h * vectorField(t,         w[$ - 1]);
        k[1] = h * vectorField(t + h / 2, w[$ - 1] + k[0] / 2);
        k[2] = h * vectorField(t + h / 2, w[$ - 1] + k[1] / 2);
        k[3] = h * vectorField(t + h,     w[$ - 1] + k[2]);

        w ~= w[$ - 1] + (k[0] + 2 * k[1] + 2 * k[2] + k[3]) / 6;
    }

    return w;
}
