module main;

import std.stdio;
import std.string;
import std.utf;

import iupFuncs;

int main(string[] args)
{
    // convert 'args' to an argv array to pass to window.show(argc, char** argv)
    char*[] argv;
    foreach (arg; args)
        argv ~=  toUTFz!(char*)(arg);

    /* IUP initialization */
    char **argvp= argv.ptr;
    int argc = args.length;
    IupOpen(&argc, &argvp);
    IupControlsOpen () ;

    /* loads LED */
    char* error = IupLoad("vbox.led");

    if (!error) {
        auto dlg = IupGetHandle("Alinhav");
        if (dlg) {
            /* shows dialog */
            //  IupShowXY(dlg,IUP_CENTER,IUP_CENTER);
            IupShow(dlg);

            /* main loop */
            IupMainLoop();
        }
        else {
            IupMessage("Error", "cant find the dialog in the LED resource");
        }
    }
    else {
        IupMessage("LED error", error);
    }

    /* ends IUP */
    IupControlsClose();
    IupClose();

	return 0;
}
