// iupWidget.d, simple D class to wrap a IUP control

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0


import std.stdio;
import std.string;
import std.exception;
import iupFuncs;

class IupWidget {

    Ihandle* _ihandle;

    this(Ihandle* ih) {
        _ihandle = ih;
    }

    this(string widgetName) {
        _ihandle = enforce(IupGetHandle(widgetName.toStringz),
                          "cant find '" ~ widgetName ~ "' in the LED resource");
    }

    Ihandle* opUnary(string s)() if (s == "*") { return _ihandle; }
    Ihandle* ihandle() { return _ihandle; }
//    Ihandle* opCall() { return _ihandle; }                  // widget() ==> Ihandle*
//    Ihandle* opCast(Type = Ihandle*)() { return _ihandle; } // cast to Ihandle*

    //--------------------

    // widget.FuncAbc(...) ==> IupFuncAbc(_ihandle,...)
    auto opDispatch(string iupFuncName, Args...)(Args args) {
        return mixin("Iup" ~ iupFuncName ~ "(_ihandle, args)");
    }

    // x = widget["attribX"];
    char* opIndex(string attribName) {
        return IupGetAttribute(_ihandle, toUpper(attribName).toStringz);
    }

    // widget["attribX"] = "value";
    void opIndexAssign(string value, string attribName) {
        IupStoreAttribute(_ihandle, toUpper(attribName).toStringz, value.toStringz);
    }


// widget.IupXyz(...)
//    auto opDispatch(string iupFuncName, Param1, Args...)(string param1, Args args)
//    if (iupFuncName.length > 3 && iupFuncName[0..3] == "Iup" && is(typeof(Param1) == string)) {
//        return mixin(iupFuncName ~ "(_ihandle, param1.toStringz, args)");
//    }

    // widget.attrib("val")
    // widget.attrib = "val"
//    auto opDispatch(string attribName, string)(string val)
//    if (attribName.length <= 3 || attribName[0..3] != "Iup") {
//        IupSetAttribute(_ihandle, toUpper(name), val);
//    }

    // auto x = widget.attrib
    // auto x = widget.attrib()
//    auto opDispatch(string attribName)() {
//        return IupGetAttribute(_ihandle, toUpper(name));
//    }
}
