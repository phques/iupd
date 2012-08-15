
// the real C struct Ihandle_ .. contains fields
struct Ihandle_;
alias Ihandle_ Ihandle;
//alias void Ihandle;

extern(C) {
    int IupOpen(int* argc, char*** argv);
    void IupClose();

    void IupControlsOpen();
    void IupControlsClose();

    int IupMainLoop();

    char *IupLoad(const char *filename);
    Ihandle *IupGetHandle(const char *name);

    int IupShow(Ihandle *ih);
    int IupHide(Ihandle *ih);

    void IupMessage(const char *title, const char *message);
}

/+The IupLoopStep and the IupFlush+/


