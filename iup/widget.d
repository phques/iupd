// iup/widget.d, simple D class to wrap a IUP control
module iup.widget;

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0


import std.stdio;
import std.string;
import std.exception;
import std.typetuple;
import std.typecons;

import iup.iup;
import iup.utild;


// Simple class to wrap a IUP Ihandle
class IupWidget {

    Ihandle* _ihandle;  // the IUP C object
    bool owner = false; // 'owns' the ihandle

    //------ CTORs -----

    // lookup IUP control 'widgetName' from a loaded LED file (or set w. IupSetHandle())
    // throws if it failed
    this(string widgetName, Flag!"Owner" owner = No.Owner) {
        _ihandle = enforce(IupGetHandle(widgetName.toStringz),
                          "Cant find '" ~ widgetName ~ "' in the LED resource");
        this.owner = owner;
    }

    this(Ihandle* ih = null, Flag!"Owner" owner = No.Owner) {
        _ihandle = ih;
        this.owner = owner;
    }

    //-------

    // destroy the ihandle if we own it
    ~this() {
        debug writeln("IupWidget ~this()");
        if (owner) {
            debug writeln("IupWidget ~this() owner");
            Destroy();
            owner = false;
        }
    }

    void Destroy() {
        debug writeln("IupWidget Destroy");
        if (_ihandle != null){
            IupDestroy(_ihandle);
            _ihandle = null;
            owner = false;
        }
    }

    //------ accessing/casting to/the Ihandle* ------

    Ihandle* ihandle() { return _ihandle; }

    Ihandle* opUnary(string s)() if (s == "*") { return _ihandle; }  // *widget ==> widget._ihandle
    Ihandle* opCast(Type = Ihandle*)()  { return _ihandle; }    // cast(Ihandle*) ==> widget._ihandle

    //--------------------

    // auto forwards method calls to calls of Iup functions, passing the ihandle:
    //   widget.FuncAbc(...) ==> IupFuncAbc(_ihandle, ...)
    // converts string to const(char)*, IupWidget to Ihandle*

    auto opDispatch(string iupFuncName, Args...)(Args args) {
        // Create new type tuple, 'string' changed to 'const(char)*' etc
        alias staticMap!(iup.utild.chgTypes, Args) NewTypes;
        NewTypes newArgs;

        // convert args to newArgs types
        foreach(i, arg; args)
            newArgs[i] = iup.utild.chgArgType(arg);

        // proxy/dispatch/forward call too Iup function
        return mixin("Iup" ~ iupFuncName)(_ihandle, newArgs);
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

    // Set the our callback = destThis.methodName, (called through proxyCB())
    // save the destination 'this' in attribute "myObjThis"
    // eg. button2.setCallback!"button2Cb"(this) => will call this.button2Cb
    void setCallback(string methodName, Class)(Class destThis) {
        // save 'this' as an attribute in the IUP control
        IupSetAttribute(_ihandle, "myObjThis", cast(char*)destThis);

        // set the callback = proxyCB()()
        IupSetCallback(_ihandle, "ACTION", &proxyCB!(Class, methodName));
    }

    // button2.setDelegate(&theObject.theMethod);
    // cf proxy() below
    void setDelegate(CbDelegate del) {
        this.SetAttribute("myObjThis", cast(char*)del.ptr);
        this.SetAttribute("myCbMethod", cast(char*)del.funcptr);
        this.SetCallback("ACTION", &proxy);
    }
}


/*------------------------------------*/

/* C callback, called by IUP on events,
 * will dispatch to a method inside a D object.
 *   ie calls Class.callbackMethodName(ihandle)
 *
 * nb: ihandle is the IUP C object/control that generated the event
 */
extern(C) int proxyCB(Class, string callbackMethodName)(Ihandle* ihandle) {
    // get 'this' of type Class, saved as attrib in the widget
    Class mythis = cast(Class)IupGetAttribute(ihandle, "myObjThis");

    // call this.callbackMethodName(ihandle);
    return mixin("mythis."~callbackMethodName~"(ihandle)");
}
/*
 The basic picture is thus like this:

 1) User clicks a button,
   2) IUP calls the button's callback passing the button's ihandle (proxyCB(ihandle))
     3) proxyCB() calls the registered Class.Method(button's ihandle)
*/

/*---------------------------*/

/* an alternative is to pass a delegate to a setDelegate() func, that :
  saves delegate.ptr ('this') as an attribute
  saves delegate.funcptr (&class.method) as an attribute
  sets the callback to a function proxy(Ihandle*) that :
    gets back the 2 attributes and
    sets the ptr/funcptr of a delegate variable .. and
    calls the delegate !!
*/
alias int delegate(Ihandle* ihandle) CbDelegate;
alias int function(Ihandle* ihandle) CbFunction;

extern(C) int proxy(Ihandle* ihandle) {
    CbDelegate del;
    del.ptr     = cast(void*)IupGetAttribute(ihandle, "myObjThis");
    del.funcptr = cast(CbFunction)IupGetAttribute(ihandle, "myCbMethod");

    return del(ihandle);
}


/*------------------------------------*/

/*
 * IupWidget button = Iup!"Button"("Quit", nullz);
 *        ie button = new IupWidget(IupButton("Quit", nullz));
 */
IupWidget Iup(string name, Args...)(Args args) {
    // Create new type tuple, 'string' changed to 'const(char)*' etc
    alias staticMap!(iup.utild.chgTypes, Args) NewTypes;
    NewTypes newArgs;

    // convert args to newArgs types
    foreach(i, arg; args)
        newArgs[i] = iup.utild.chgArgType(arg);

    Ihandle* ih = mixin("Iup"~name)(newArgs);
    return new IupWidget(ih);
}
