// simple IUP dialog app, uses only direct IUP C

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0


import std.stdio;
import std.exception;
import std.string;
import std.conv;

import iup.iup;
import iup.controls;
import iup.utild;


extern(C) int quit_cb(Ihandle* self) {
    return IUP_CLOSE;
}

int main(string[] args)
{
    try {
        /* IUP initialization */
        IupOpenD(args);
        IupControlsOpen() ;

        Ihandle* dialog, quit_bt, vbox;

        /* Creating the button */
        quit_bt = IupButton("Quit", null);
        IupSetCallback(quit_bt, "ACTION", &quit_cb);

        vbox = IupVbox(
            IupSetAttributes(IupLabel("Very Long Text Label"), "EXPAND=YES, ALIGNMENT=ACENTER"),
            quit_bt,
            null
        );
        IupSetAttribute(vbox, "ALIGNMENT", "ACENTER");
        IupSetAttribute(vbox, "MARGIN", "10x10");
        IupSetAttribute(vbox, "GAP", "5");

        /* Creating the dialog */
        dialog = IupDialog(vbox);
        scope(exit) IupDestroy(dialog);
        IupSetAttribute(dialog, "TITLE", "Dialog Title");
        IupSetAttributeHandle(dialog, "DEFAULTESC", quit_bt);

        IupShow(dialog);

        /* main loop */
        IupMainLoop();
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

