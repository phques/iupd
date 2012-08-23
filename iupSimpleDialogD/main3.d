
import std.stdio;
import std.exception;
import std.string;
import std.conv;
import std.typecons;
import std.typetuple;

import iup.iup;
import iup.utild;
import iup.controls;
import iup.widget;


extern(C) int quit_cb(Ihandle* self) {
    return IUP_CLOSE;
}


const(char*) Z(string s) { return s.toStringz; }

enum Null = cast(const(char*))null ;

IupWidget Iup(string name, Args...)(Args args) {
    Ihandle* ih = null;

    writeln(typeid(Args));

/+    for (int i=0; i < Args.length; i++)
        writeln(Args[i]);+/
    string[] ss;
    foreach (arg; args) {
        writefln(" %s : %s", typeid(arg), arg);
        ss ~= to!string(arg);
    }
    writeln(ss);

    // 1 string param
    static if (Args.length==1 && is(Args[0] == string)) {
        ih = mixin("Iup"~name)(args[0].toStringz);
    }
    // 2 string params
    else static if (Args.length==2 && is(Args[0] == string) && is(Args[1] == string)) {
        ih = mixin("Iup"~name)(args[0].toStringz, args[1].toStringz);
    }
    // 1 string params, 1 other
    else static if (Args.length==2 && is(Args[0] == string) && !is(Args[1] == string)) {
        ih = mixin("Iup"~name)(args[0].toStringz, args[1]);
    }
    // 1 IupWidget param
    else static if (Args.length==1 && is(Args[0] == IupWidget)) {
        ih = mixin("Iup"~name)(args[0].ihandle);
    }
    else {
        ih = mixin("Iup"~name)(args);
    }

    return new IupWidget(ih);
}

//------------------

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

void titi(Args...)(Args args) {
    alias Toto!Args TotoType;
    TotoType toto;

    writeln(typeid(toto));
    writeln(typeid(Args));
    writeln(typeid(toto.argsSpecs));
}


int main(string[] args)
{
    writeln("\ntoto()");
    toto!"allo"(1,'a',"stt");

    writeln("\nToto");
    alias Toto!(int,char) TToto;
    TToto atoto;
    writeln(typeid(atoto));
    writeln(typeid(atoto.argsSpecs));

    writeln("\ntiti()");
    titi('a', 10, "allo");

    writeln("\nTuple");
    alias Tuple!(int, "index", string, "value") Entry;
    Entry e;
    e.index = 4;
    e.value = "Hello";
    assert(e[1] == "Hello");
    assert(e[0] == 4);
    writeln(typeid(e.Types));

    version(none){
    try {
        /* IUP initialization */
        IupOpenD(args);
        IupControlsOpen() ;

        IupWidget quit_bt, vbox, dialog;

        /* Creating the button */
        quit_bt = Iup!"Button"("Quit", Null);
        quit_bt.SetCallback("ACTION", &quit_cb);

        vbox = Iup!"Vbox"(
            Iup!"Label"("Very Long Text Label").SetAttributes("EXPAND=YES, ALIGNMENT=ACENTER"),
            *quit_bt,
            null
        );
        vbox["ALIGNMENT"] = "ACENTER";
        vbox["MARGIN"] = "10x10";
        vbox["GAP"] = "5";

        /* Creating the dialog */
        dialog = Iup!"Dialog"(vbox);
        dialog["TITLE"] = "Dialog Title";
        dialog.SetAttributeHandle("DEFAULTESC", *quit_bt);
        dialog.SetAttributeHandle("DEFAULTENTER", *quit_bt);
        scope(exit) dialog.Destroy();

        dialog.Show();

        /* main loop */
        IupMainLoop();
    }
    catch (Exception e) {
        IupMessage("error", e.msg.toStringz);
    }
    finally {
        /* ends IUP */
        IupControlsClose();
        IupClose();
    }
    }//versionnone

	return 0;
}

