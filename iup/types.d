// iup/types.d, IUP C base types
module iup.types;

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

extern(C) {

    // the real C struct Ihandle_ .. contains fields
    struct Ihandle_ {};
    alias Ihandle_ Ihandle;

    alias int function(Ihandle*) Icallback;
}

