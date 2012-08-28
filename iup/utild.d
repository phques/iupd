// iup/utild.d, utility D funcs for easier use of IUP
module iup.utild;

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

import std.string;
import std.utf;
import std.conv;

import iup.iup;
import iup.widget;

//-----------------

// shortcut for toStringz !!  aString.Z
//const(char)* Z(string s) { return s.toStringz; }

// D null is void*, does not auto cast to char*,
// use nullz
enum nullz = cast(const(char)*)null;
alias nullz NULL;

//-----------------

// used w. staticMap to change types in a type tuple (==> new type tuple)
// changes string => const(char)*
//         IupWidget => Ihandle*
template chgTypes(Type) {
    static if (is(Type==string)) {
        alias const(char)* chgTypes;
    }
    else static if (is(Type==IupWidget)) {
        alias Ihandle* chgTypes;
    }
    else {
        alias Type chgTypes;
    }
}

auto chgArgType(Arg)(Arg arg) {
    static if (is(Arg==string))
        return arg.toStringz;
    else static if (is(Arg==IupWidget))
        return arg.ihandle;
    else
        return arg;
}

//-----------------

// helper func to call IupOpen with string[] args
int IupOpenD(string[] args) {
    // create char* array
    char*[] argv;
    foreach (arg; args)
        argv ~=  toUTFz!(char*)(arg);

    int argc = argv.length;
    char** argvp = argv.ptr;
    return IupOpen(&argc, &argvp);
}

//-----------------

// replaces IupSettAtt, handles converting strings ("") to stringz
// calls IupSetAtt once then IupSetAttribute for the rest of the attributes
// w. this we can compile the ledc generated C function
Ihandle* _IupSetAtt(const char* name, Ihandle* ih, const(char*)[] params...)
{
    // newp = params converted to stringz
    const(char)*[] newp = new const(char)*[params.length];
    for (int i=0; i < params.length; i++){
        newp[i] =  toUTFz!(const(char)*)(to!string(params[i]));
    }

    // call IupSetAtt & IupSetAttribute
    if (newp.length >= 2) {
        IupSetAtt(name, ih, newp[0], newp[1], nullz);

        // ps: only do pairs, last params supposed to be == null anyways
        for (int i = 2; i < (params.length & ~1); i+=2)
            IupSetAttribute(ih, newp[i], newp[i+1]);
    }

    return ih;
}
