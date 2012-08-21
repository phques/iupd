
import std.stdio;
import std.exception;
import std.string;
import std.conv;

import iup.funcs;


extern(C) int ok_butt_cb(Ihandle* self) {
    return IUP_CLOSE;
}

int main(string[] args)
{
    try {
        /* IUP initialization */
        IupOpenD(args);
        IupControlsOpen() ;

        /* loads LED 'resource' file */
        char* error = IupLoad("hello.led");
        enforce(!error, to!string(error));

        auto dlg = IupGetHandle("main");

        /* sets callbacks */
        IupSetFunction( "ok_butt_cb", cast(Icallback)&ok_butt_cb);

        /* shows dialog */
        IupShow(dlg);

        /* main loop */
        IupMainLoop();

        IupDestroy(dlg);
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

