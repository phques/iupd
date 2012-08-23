
import std.stdio;
import std.typecons;
import std.string;
import std.conv;
import std.typetuple;

void tata(int i, char c, immutable(char)* s) {
    writeln(i,c,s);
}

void toto(string name, Args...)(Args args) {
    writeln(typeid(Args));
    writeln(args[0]);
    writeln(args[1..$]);
    writeln();
    auto t = tuple(args[0..2], args[2].toStringz);
    writeln(t);
    writeln(typeid(t));
    tata(t.expand);
}

struct Toto(Specs...) {
    template parseSpecs(Specs...) {
        static if (Specs.length == 0)
        {
            alias TypeTuple!() parseSpecs;
        }
        else static if (is(Specs[0]))
        {
            static if (is(Specs[0] == string))
            {
                alias TypeTuple!(const(char)*,
                                 parseSpecs!(Specs[1 .. $])) parseSpecs;
            }
            else
            {
                alias TypeTuple!(Specs[0],
                                 parseSpecs!(Specs[1 .. $])) parseSpecs;
            }
        }
        else
        {
            static assert(0, "Attempted to instantiate Tuple with an "
                            ~"invalid argument: "~ Specs[0].stringof);
        }
    }

    alias parseSpecs!Specs argsSpecs;
}



void titi(Args...)(Args args) {
    alias Toto!Args TotoType;
    TotoType toto;

    writeln(typeid(toto));
    writeln(typeid(Args));
    writeln(typeid(toto.argsSpecs));
}

template chgTypes(alias spec) {
    static if (is(spec.Type==string))
        alias const(char)* chgTypes;
    else
        alias spec.Type chgTypes;
}

void toutou(Args...)(Args args) {
    alias staticMap!(chgTypes, Args) TotoType;
    TotoType toto;

    writeln(typeid(toto));
    writeln(typeid(Args));
}

int main(string[] args)
{
    writeln("\nTuple");
    alias Tuple!(int, "index", string, "value") Entry;
    Entry e;
    e.index = 4;
    e.value = "Hello";
    assert(e[1] == "Hello");
    assert(e[0] == 4);
    writeln(typeid(e.Types));

    writeln("\ntoto()");
    toto!"allo"(1,'a',"stt");

    writeln("\nToto");
    alias Toto!(int,char) TToto;
    TToto atoto;
    writeln(typeid(atoto));
    writeln(typeid(atoto.argsSpecs));

    writeln("\ntiti()");
    titi('a', 10, "allo");

    writeln("\toutou()");
//    toutou('a', 10, "allo");

return 0;
}
