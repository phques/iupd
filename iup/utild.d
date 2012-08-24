// iup/utild.d, utility D funcs for easier use of IUP
module iup.utild;

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

import std.string;
import std.utf;
import iup.iup;
import iup.widget;

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
