
import std.stdio;
import std.exception;
import std.string;
import std.conv;
import std.typecons;
import std.typetuple;

import iup.iup;
import iup.utild;
import iup.controls;
import iup.widget;


extern(C) int quit_cb(Ihandle* self) {
    return IUP_CLOSE;
}


int main(string[] args)
{

    try {
        /* IUP initialization */
        IupOpenD(args);
        IupControlsOpen() ;

        IupWidget quit_bt, vbox;

        /* Creating the button */
        quit_bt = Iup!"Button"("Quit", nullz);
        quit_bt.SetCallback("ACTION", &quit_cb);

        vbox = Iup!"Vbox"(
            Iup!"Label"("Very Long Text Label").SetAttributes("EXPAND=YES, ALIGNMENT=ACENTER"),
            quit_bt,
            null
        );
        vbox["ALIGNMENT"] = "ACENTER";
        vbox["MARGIN"] = "10x10";
        vbox["GAP"] = "5";

        /* Creating the dialog */
        scope auto dialog = Iup!"Dialog"(vbox);
        dialog["TITLE"] = "Dialog Title";
        dialog.SetAttributeHandle("DEFAULTESC", quit_bt);
        dialog.SetAttributeHandle("DEFAULTENTER", quit_bt);

        dialog.Show();

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

