
// the real C struct Ihandle_ .. contains fields
struct Ihandle_;
alias Ihandle_ Ihandle;
//alias void Ihandle;

extern(C) int IupOpen(int* argc, char*** argv);
extern(C) void IupClose();

extern(C) void IupControlsOpen();
extern(C) void IupControlsClose();

extern(C) int IupMainLoop();

extern(C) char *IupLoad(const char *filename);
extern(C) Ihandle *IupGetHandle(const char *name);

extern(C) int IupShow(Ihandle *ih);
extern(C) int IupHide(Ihandle *ih);

extern(C) void IupMessage(const char *title, const char *message);

/+The IupLoopStep and the IupFlush+/


