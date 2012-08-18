// iup/widget.d, simple D class to wrap a IUP control

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0


import std.stdio;
import std.string;
import std.exception;

import iup.funcs;

class IupWidget {

    Ihandle* _ihandle;  // the IUP C object

    //------ CTORs -----

    // lookup IUP control 'widgetName' from a loaded LED file (or set w. IupSetHandle())
    // throws the error msg returned by Iup if if failed
    this(string widgetName) {
        _ihandle = enforce(IupGetHandle(widgetName.toStringz),
                          "Cant find '" ~ widgetName ~ "' in the LED resource");
    }

    this(Ihandle* ih) {
        _ihandle = ih;
    }

    //------ accessing/casting to/the Ihandle* ------

    Ihandle* ihandle() { return _ihandle; }

    Ihandle* opUnary(string s)() if (s == "*") { return _ihandle; }  // *widget ==> widget._ihandle
    Ihandle* opCall()                   { return _ihandle; }    // widget() ==> widget._ihandle
    Ihandle* opCast(Type = Ihandle*)()  { return _ihandle; }    // cast(Ihandle*) ==> widget._ihandle

    //--------------------

    // auto forwards method calls to calls of Iup functions, passing the ihandle:
    //   widget.FuncAbc(...) ==> IupFuncAbc(_ihandle, ...)
    auto opDispatch(string iupFuncName, Args...)(Args args) {

        // Specialized: 1 string param, pass with .toStringz
        static if (Args.length==1 && is(Args[0] == string)) {
            return mixin("Iup" ~ iupFuncName ~ "(_ihandle, args[0].toStringz)");
        }
        // 2 string params
        else static if (Args.length==2 && is(Args[0] == string) && is(Args[1] == string)) {
            return mixin("Iup" ~ iupFuncName ~ "(_ihandle, args[0].toStringz, args[1].toStringz)");
        }
        // 1 string param + other non-string param
        else static if (Args.length==2 && is(Args[0] == string) && !is(Args[1] == string)) {
            return mixin("Iup" ~ iupFuncName ~ "(_ihandle, args[0].toStringz, args[1])");
        }
        // generic case, pass paramters as-is,
        // caller must use .toStringz if passing D strings
        else {
            return mixin("Iup" ~ iupFuncName ~ "(_ihandle, args)");
        }
    }

    //--------- setting/getting attributes ---------
    // (attribName not case sensitive, will be passed to IUP uppercased)

    // Set attribute
    // widget["attribX"] = "value";
    void opIndexAssign(string value, string attribName) {
        IupStoreAttribute(_ihandle, toUpper(attribName).toStringz, value.toStringz);
    }

    // Get attribute
    // x = widget["attribX"];
    char* opIndex(string attribName) {
        return IupGetAttribute(_ihandle, toUpper(attribName).toStringz);
    }

    // Set the our callback = destThis.methodName, (through a proxy)
    // save the destination 'this' in attribute "myObjThis"
    void setCallback(string methodName, Class)(Class destThis) {
        // save 'this' as an attribute in the IUP control
        IupSetAttribute(_ihandle, "myObjThis", cast(char*)destThis);

        // set the callback = proxyCB()()
        IupSetCallback(_ihandle, "ACTION", &proxyCB!(Class, methodName));
    }
}


//--------------------


/* Sets a callback for a IUP control = proxyCB()() bellow, which will call a method inside of 'this'.
 * use: mixin SetCbMixin;  inside a class to add setCallback()() to the class, then
 * use: this.setCallback!"methodName"(widget);   to set the D method as the widget's callback
 *
 * 'deprecated', use widget.setCallback()() !!! ;-)
 */
mixin template SetCbMixin() {

    deprecated void setCallback(string methodName, this Class)(IupWidget widget) {
        // save 'this' as an attribute in the IUP control
        IupSetAttribute(widget.ihandle, "myObjThis", cast(char*)this);

        // set the callback = proxyCB()()
        IupSetCallback(widget.ihandle, "ACTION", &proxyCB!(Class, methodName));
    }
}

/* C callback, called by IUP on events,
 * will dispatch to a method inside a D object.
 *   ie calls Class.callbackMethodName(ihandle)
 *
 * nb: ihandle is the IUP C object/control that generaed the event
 */
extern(C) int proxyCB(Class, string callbackMethodName)(Ihandle* ihandle) {
    // get 'this' of type Class, saved as attrib in the widget
    Class mythis = cast(Class)IupGetAttribute(ihandle, "myObjThis");

    // call this.callbackMethodName(ihandle);
    return mixin("mythis." ~ callbackMethodName ~"(ihandle)");
}

/*
 The basic picture is thus like this:

 1) User clicks a button,
   2) IUP calls the button's callback pass the button's ihandle (proxyCB(ihandle))
     3) proxyCB() calls the registered Class.Method(button's ihandle)
*/


