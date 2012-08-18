// iupWidget.d, simple D class to wrap a IUP control

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0


import std.stdio;
import std.string;
import std.exception;

import iup.funcs;

class IupWidget {

    Ihandle* _ihandle;  // the IUP C object

    // lookup IUP control 'widgetName' from a loaded LED file
    this(string widgetName) {
        _ihandle = enforce(IupGetHandle(widgetName.toStringz),
                          "cant find '" ~ widgetName ~ "' in the LED resource");
    }

    this(Ihandle* ih) {
        _ihandle = ih;
    }

    Ihandle* ihandle() { return _ihandle; }

    Ihandle* opUnary(string s)() if (s == "*") { return _ihandle; }  // *widget ==> Ihandle*
    Ihandle* opCall() { return _ihandle; }                  // widget() ==> Ihandle*
    Ihandle* opCast(Type = Ihandle*)() { return _ihandle; } // cast(Ihandle*)

    //--------------------

    // widget.FuncAbc(...) ==> IupFuncAbc(_ihandle,...)
    auto opDispatch(string iupFuncName, Args...)(Args args) {
        debug writefln("opDispatch name:%s, Args%s", iupFuncName, typeid(Args));

        // Specialized: 1 string param, pass with .toStringz
        static if (Args.length==1 && is(Args[0] == string)) {
            debug writeln("  specific 1string");
            return mixin("Iup" ~ iupFuncName ~ "(_ihandle, args[0].toStringz)");
        }
        // 2 string params
        else static if (Args.length==2 && is(Args[0] == string) && is(Args[1] == string)) {
            debug writeln("  specific 2string");
            return mixin("Iup" ~ iupFuncName ~ "(_ihandle, args[0].toStringz, args[1].toStringz)");
        }
        // 1 string param + other non-string param
        else static if (Args.length==2 && is(Args[0] == string) && !is(Args[1] == string)) {
            debug writeln("  specific 1string+?");
            return mixin("Iup" ~ iupFuncName ~ "(_ihandle, args[0].toStringz, args[1])");
        }
        // generic case
        else {
            debug writeln("  generic args");
            return mixin("Iup" ~ iupFuncName ~ "(_ihandle, args)");
        }
    }


    // x = widget["attribX"];
    char* opIndex(string attribName) {
        return IupGetAttribute(_ihandle, toUpper(attribName).toStringz);
    }

    // widget["attribX"] = "value";
    void opIndexAssign(string value, string attribName) {
        IupStoreAttribute(_ihandle, toUpper(attribName).toStringz, value.toStringz);
    }

}
