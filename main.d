// main.d, test using IUP in D (with LED file)

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

module main;

import std.stdio;
import std.string;
import std.utf;
import std.exception;

import iupFuncs;
import iupWidget;


extern (C) int button1_cb(Ihandle* self) {
    writeln("button1_cb");
    return IUP_DEFAULT;
}

extern (C) int button2_cb(Ihandle* self) {
    writeln("button2_cb, ret close");
    return IUP_CLOSE;
}

auto z(string s) { return s.toStringz; }

void doit() {
    /* loads LED */
    char* error = IupLoad("vbox.led");

    if (!error) {

        auto dlg = new IupWidget("Alinhav");
        auto button2 = new IupWidget("button2");
        auto button3 = new IupWidget("button3");

        IupSetFunction("button1_cb", &button1_cb);

        IupSetCallback(button2.ihandle, "ACTION", &button2_cb);
        IupSetCallback(*button2, "ACTION", &button2_cb);
        button2.SetCallback("ACTION".z, &button2_cb);

        button3["ACTIVE"] = "No";

        /* shows dialog */
        dlg.Show();

        /* main loop */
        IupMainLoop();

    }
    else {
        IupMessage("LED error", error);
    }

}

int main(string[] args)
{
    // convert 'args' to an argv array to pass to window.show(argc, char** argv)
    char*[] argv;
    foreach (arg; args)
        argv ~=  toUTFz!(char*)(arg);

    /* IUP initialization */
    char **argvp = argv.ptr;
    int argc = args.length;

    IupOpen(&argc, &argvp);
    IupControlsOpen() ;

    doit();

    /* ends IUP */
    IupControlsClose();
    IupClose();

	return 0;
}
