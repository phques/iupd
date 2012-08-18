// main.d, test using IUP in D (with LED file)

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

module main;

import std.stdio;
import std.string;
import std.utf;
import std.exception;
import std.conv;

import iup.funcs;
import iup.widget;


extern (C) int button1_cb(Ihandle* self) {
    writeln("button1_cb");
    return IUP_DEFAULT;
}

extern (C) int button2_cb(Ihandle* self) {
    writeln("button2_cb, ret close");
    return IUP_CLOSE;
}

auto z(string s) { return s.toStringz; }

class MainWindow {

    IupWidget dlg, button2, button3;


    this() {
        /* loads LED */
        char* error = IupLoad("vbox.led");
        enforce(!error, to!string(error));

        // get handles to dialog & some buttons
        dlg = new IupWidget("Alinhav");
        button2 = new IupWidget("button2");
        button3 = new IupWidget("button3");

        // set button callback
        IupSetFunction("button1_cb", &button1_cb);

        IupSetCallback(button2.ihandle, "ACTION", &button2_cb);
        IupSetCallback(*button2, "ACTION", &button2_cb);
        button2.SetCallback("ACTION", &button2_cb);

        // set button3 to inactive
        button3["ACTIVE"] = "No";
    }

    void doit() {
        /* shows dialog */
        dlg.Show();

        /* main loop */
        IupMainLoop();
    }
}


int main(string[] args)
{
    // convert 'args' to an argv array to pass to IupOpen
    char*[] argv;
    foreach (arg; args)
        argv ~=  toUTFz!(char*)(arg);

    /* IUP initialization */
    char** argvp = argv.ptr;
    int argc = args.length;

    try {
        IupOpen(&argc, &argvp);
        IupControlsOpen() ;

        auto window = new MainWindow;
        window.doit();
    }
    catch (Exception e) {
        IupMessage("error", e.msg.z);
    }
    finally {
        /* ends IUP */
        IupControlsClose();
        IupClose();
    }

	return 0;
}
