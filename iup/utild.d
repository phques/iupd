// iup/utild.d, utility D funcs for easier use of IUP
module iup.utild;

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

import std.utf;
import iup.iup;

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
