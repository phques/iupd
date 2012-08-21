// main.d, test using IUP in D (with LED file)

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

module main;

import std.stdio;
import std.string;
import std.utf;
import std.exception;
import std.conv;

import iup.iup;
import iup.controls;
import iup.utild;
import iup.widget;


// shortcut for toStringz
auto z(string s) { return s.toStringz; }


// 'static' button callbacks
extern (C) int static_button_cb(Ihandle* self) {
    writeln("static_button_cb");
    return IUP_DEFAULT;
}


class MainWindow {

    IupWidget dlg, button2, button3, button4;
    int val = 123;

    this() {
        // get handles to dialog & some buttons
        dlg = new IupWidget("Alinhav");
        button2 = new IupWidget("button2");
        button3 = new IupWidget("button3");
        button4 = new IupWidget("button4");

        // set button1 callback, "button1_cb" is specified as callback name in LED
        IupSetFunction("button1_cb", &static_button_cb);

        // or do it directly: button <--> callback
        // (static function)
        IupSetCallback(button2.ihandle, "ACTION", &static_button_cb);
        IupSetCallback(*button2, "ACTION", &static_button_cb);
        button2.SetCallback("ACTION", &static_button_cb);

        // or callbacks = methods of MainWindow
        button2.setCallback!"button2Cb"(this);
        button3.setCallback!"button3Cb"(this);

        // Set button4 to inactive (ie set widget's attribute "ACTIVE" = "No")
        // same as IupStoreAttribute(button4.ihandle, "ACTIVE", "No");
        //      or button4.StoreAttribute("ACTIVE", "No");
        button4["ACTIVE"] = "No";
    }

    // button event callback
    int button2Cb(Ihandle* ihandle) {
        assert(ihandle == button2.ihandle);
        writeln("MainWindow.button2Cb val = ", val, " ihandle = ", ihandle);
        return IUP_DEFAULT;
    }

    int button3Cb(Ihandle* ihandle) {
        assert(ihandle == button3.ihandle);
        writeln("MainWindow.button3Cb val = ", val, " ihandle = ", ihandle);
        return IUP_CLOSE;
    }

    void run() {
        writeln("click buttons 1,2,3 !");

        /* shows dialog */
        dlg.Show();

        /* main loop */
        IupMainLoop();
    }
}

//---------------------

int main(string[] args)
{
    try {
        /* IUP initialization */
        IupOpenD(args);
        IupControlsOpen() ;

        /* loads LED 'resource' file */
        char* error = IupLoad("vbox.led");
        enforce(!error, to!string(error));

        auto window = new MainWindow;
        window.run();
    }
    catch (Exception e) {
        IupMessage("error", e.msg.toStringz);
    }
    finally {
        /* ends IUP */
        IupControlsClose();
        IupClose();
    }

	return 0;
}
