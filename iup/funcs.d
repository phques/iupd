// iupFuncs.d, defines IUP functions etc

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0


enum {
    IUP_IGNORE = -1,
    IUP_DEFAULT = -2,
    IUP_CLOSE = -3,
    IUP_CONTINUE = -4
}

extern(C) {

    // the real C struct Ihandle_ .. contains fields
    struct Ihandle_;
    alias Ihandle_ Ihandle;

    alias int function(Ihandle*) Icallback;

    int IupOpen(int* argc, char*** argv);
    void IupClose();

    void IupControlsOpen();
    void IupControlsClose();

    int IupMainLoop();

    Icallback IupSetFunction(const char *name, Icallback func);
    Icallback IupSetCallback(Ihandle* ih, const char *name, Icallback func);

    char *IupLoad(const char *filename);
    Ihandle *IupGetHandle(const char *name);

    void IupStoreAttribute(Ihandle *ih, const char *name, const char *value);
    char *IupGetAttribute(Ihandle *ih, const char *name);

    int IupShow(Ihandle *ih);
    int IupHide(Ihandle *ih);

    void IupMessage(const char *title, const char *message);
}

/+The IupLoopStep and the IupFlush+/


