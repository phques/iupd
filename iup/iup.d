// iup/iup.d, IUP C functions (iup.h)
module iup.iup;

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

public import iup.types;


//--------------------

//## TODO: all the enums !!

enum {
    IUP_IGNORE = -1,
    IUP_DEFAULT = -2,
    IUP_CLOSE = -3,
    IUP_CONTINUE = -4
}

/*Note:
 *  To pass a D string to a C func(char*), use thestring.toStringz,
 *
 *  Make sure to keep a ref to the D string if the C code keeps the pointer,
 *  otherwise, the D string could be garbage collected, creating a dangling ptr in C.
 *
 *  To avoid this for attribute values, use IupStoreAttribute iso IupSetAttibute,
 *  since IupStoreAttribute saves a copy of the string.
 */

extern(C) {

/************************************************************************/
/*                        Main API                                      */
/************************************************************************/

int       IupOpen          (int *argc, char ***argv);
void      IupClose         ();
void      IupImageLibOpen  ();

int       IupMainLoop      ();
int       IupLoopStep      ();
int       IupLoopStepWait  ();
int       IupMainLoopLevel ();
void      IupFlush         ();
void      IupExitLoop      ();

int       IupRecordInput(const char* filename, int mode);
int       IupPlayInput(const char* filename);

void      IupUpdate        (Ihandle* ih);
void      IupUpdateChildren(Ihandle* ih);
void      IupRedraw        (Ihandle* ih, int children);
void      IupRefresh       (Ihandle* ih);
void      IupRefreshChildren(Ihandle* ih);

char*     IupMapFont       (const char *iupfont);
char*     IupUnMapFont     (const char *driverfont);
int       IupHelp          (const char* url);
char*     IupLoad          (const char *filename);
char*     IupLoadBuffer    (const char *buffer);

char*     IupVersion       ();
char*     IupVersionDate   ();
int       IupVersionNumber ();
void      IupSetLanguage   (const char *lng);
char*     IupGetLanguage   ();

void      IupDestroy      (Ihandle* ih);
void      IupDetach       (Ihandle* child);
Ihandle*  IupAppend       (Ihandle* ih, Ihandle* child);
Ihandle*  IupInsert       (Ihandle* ih, Ihandle* ref_child, Ihandle* child);
Ihandle*  IupGetChild     (Ihandle* ih, int pos);
int       IupGetChildPos  (Ihandle* ih, Ihandle* child);
int       IupGetChildCount(Ihandle* ih);
Ihandle*  IupGetNextChild (Ihandle* ih, Ihandle* child);
Ihandle*  IupGetBrother   (Ihandle* ih);
Ihandle*  IupGetParent    (Ihandle* ih);
Ihandle*  IupGetDialog    (Ihandle* ih);
Ihandle*  IupGetDialogChild(Ihandle* ih, const char* name);
int       IupReparent     (Ihandle* ih, Ihandle* new_parent, Ihandle* ref_child);

int       IupPopup         (Ihandle* ih, int x, int y);
int       IupShow          (Ihandle* ih);
int       IupShowXY        (Ihandle* ih, int x, int y);
int       IupHide          (Ihandle* ih);
int       IupMap           (Ihandle* ih);
void      IupUnmap         (Ihandle *ih);

void      IupSetAttribute  (Ihandle* ih, const char* name, const char* value);
void      IupStoreAttribute(Ihandle* ih, const char* name, const char* value);
Ihandle*  IupSetAttributes (Ihandle* ih, const char *str);
char*     IupGetAttribute  (Ihandle* ih, const char* name);
char*     IupGetAttributes (Ihandle* ih);
int       IupGetInt        (Ihandle* ih, const char* name);
int       IupGetInt2       (Ihandle* ih, const char* name);
int       IupGetIntInt     (Ihandle *ih, const char* name, int *i1, int *i2);
float     IupGetFloat      (Ihandle* ih, const char* name);
void      IupSetfAttribute (Ihandle* ih, const char* name, const char* format, ...);
void      IupResetAttribute(Ihandle *ih, const char* name);
int       IupGetAllAttributes(Ihandle* ih, char** names, int n);
Ihandle*  IupSetAtt(const char* handle_name, Ihandle* ih, const char* name, ...);

void  IupSetAttributeId(Ihandle *ih, const char* name, int id, const char *value);
void  IupStoreAttributeId(Ihandle *ih, const char* name, int id, const char *value);
char* IupGetAttributeId(Ihandle *ih, const char* name, int id);
float IupGetFloatId(Ihandle *ih, const char* name, int id);
int   IupGetIntId(Ihandle *ih, const char* name, int id);
void  IupSetfAttributeId(Ihandle *ih, const char* name, int id, const char* format, ...);

void  IupSetAttributeId2(Ihandle* ih, const char* name, int lin, int col, const char* value);
void  IupStoreAttributeId2(Ihandle* ih, const char* name, int lin, int col, const char* value);
char* IupGetAttributeId2(Ihandle* ih, const char* name, int lin, int col);
int   IupGetIntId2(Ihandle* ih, const char* name, int lin, int col);
float IupGetFloatId2(Ihandle* ih, const char* name, int lin, int col);
void  IupSetfAttributeId2(Ihandle* ih, const char* name, int lin, int col, const char* format, ...);

void      IupSetGlobal     (const char* name, const char* value);
void      IupStoreGlobal   (const char* name, const char* value);
char*     IupGetGlobal     (const char* name);

Ihandle*  IupSetFocus      (Ihandle* ih);
Ihandle*  IupGetFocus      ();
Ihandle*  IupPreviousField (Ihandle* ih);
Ihandle*  IupNextField     (Ihandle* ih);

Icallback IupGetCallback(Ihandle* ih, const char *name);
Icallback IupSetCallback(Ihandle* ih, const char *name, Icallback func);
Ihandle*  IupSetCallbacks(Ihandle* ih, const char *name, Icallback func, ...);

Icallback   IupGetFunction   (const char *name);
Icallback   IupSetFunction   (const char *name, Icallback func);
const(char)* IupGetActionName ();

Ihandle*  IupGetHandle     (const char *name);
Ihandle*  IupSetHandle     (const char *name, Ihandle* ih);
int       IupGetAllNames   (char** names, int n);
int       IupGetAllDialogs (char** names, int n);
char*     IupGetName       (Ihandle* ih);

void      IupSetAttributeHandle(Ihandle* ih, const char* name, Ihandle* ih_named);
Ihandle*  IupGetAttributeHandle(Ihandle* ih, const char* name);

char*     IupGetClassName(Ihandle* ih);
char*     IupGetClassType(Ihandle* ih);
int       IupGetAllClasses(char** names, int n);
int       IupGetClassAttributes(const char* classname, char** names, int n);
int       IupGetClassCallbacks(const char* classname, char** names, int n);
void      IupSaveClassAttributes(Ihandle* ih);
void      IupCopyClassAttributes(Ihandle* src_ih, Ihandle* dst_ih);
void      IupSetClassDefaultAttribute(const char* classname, const char *name, const char* value);
int       IupClassMatch(Ihandle* ih, const char* classname);

Ihandle*  IupCreate (const char *classname);
Ihandle*  IupCreatev(const char *classname, void* *params);
Ihandle*  IupCreatep(const char *classname, void *first, ...);

/************************************************************************/
/*                        Elements                                      */
/************************************************************************/

Ihandle*  IupFill       ();
Ihandle*  IupRadio      (Ihandle* child);
Ihandle*  IupVbox       (Ihandle* child, ...);
Ihandle*  IupVboxv      (Ihandle* *children);
Ihandle*  IupZbox       (Ihandle* child, ...);
Ihandle*  IupZboxv      (Ihandle* *children);
Ihandle*  IupHbox       (Ihandle* child,...);
Ihandle*  IupHboxv      (Ihandle* *children);

Ihandle*  IupNormalizer (Ihandle* ih_first, ...);
Ihandle*  IupNormalizerv(Ihandle* *ih_list);

Ihandle*  IupCbox       (Ihandle* child, ...);
Ihandle*  IupCboxv      (Ihandle* *children);
Ihandle*  IupSbox       (Ihandle *child);
Ihandle*  IupSplit      (Ihandle* child1, Ihandle* child2);

Ihandle*  IupFrame      (Ihandle* child);

Ihandle*  IupImage      (int width, int height, const ubyte *pixmap);
Ihandle*  IupImageRGB   (int width, int height, const ubyte *pixmap);
Ihandle*  IupImageRGBA  (int width, int height, const ubyte *pixmap);

Ihandle*  IupItem       (const char* title, const char* action);
Ihandle*  IupSubmenu    (const char* title, Ihandle* child);
Ihandle*  IupSeparator  ();
Ihandle*  IupMenu       (Ihandle* child,...);
Ihandle*  IupMenuv      (Ihandle* *children);

Ihandle*  IupButton     (const char* title, const char* action);
Ihandle*  IupCanvas     (const char* action);
Ihandle*  IupDialog     (Ihandle* child);
Ihandle*  IupUser       ();
Ihandle*  IupLabel      (const char* title);
Ihandle*  IupList       (const char* action);
Ihandle*  IupText       (const char* action);
Ihandle*  IupMultiLine  (const char* action);
Ihandle*  IupToggle     (const char* title, const char* action);
Ihandle*  IupTimer      ();
Ihandle*  IupClipboard  ();
Ihandle*  IupProgressBar();
Ihandle*  IupVal        (const char *type);
Ihandle*  IupTabs       (Ihandle* child, ...);
Ihandle*  IupTabsv      (Ihandle* *children);
Ihandle*  IupTree       ();

/* Deprecated controls use SPIN attribute of IupText */
Ihandle*  IupSpin       ();
Ihandle*  IupSpinbox    (Ihandle* child);


/* IupImage utility */
int IupSaveImageAsText(Ihandle* ih, const char* file_name, const char* format, const char* name);

/* IupText utilities */
void  IupTextConvertLinColToPos(Ihandle* ih, int lin, int col, int *pos);
void  IupTextConvertPosToLinCol(Ihandle* ih, int pos, int *lin, int *col);

/* IupText, IupList and IupTree utility */
int   IupConvertXYToPos(Ihandle* ih, int x, int y);

/* IupTree utilities */
int   IupTreeSetUserId(Ihandle* ih, int id, void* userid);
void* IupTreeGetUserId(Ihandle* ih, int id);
int   IupTreeGetId(Ihandle* ih, void *userid);

/* Deprecated IupTree utilities, use Iup*AttributeId functions */
void  IupTreeSetAttribute  (Ihandle* ih, const char* name, int id, const char* value);
void  IupTreeStoreAttribute(Ihandle* ih, const char* name, int id, const char* value);
char* IupTreeGetAttribute  (Ihandle* ih, const char* name, int id);
int   IupTreeGetInt        (Ihandle* ih, const char* name, int id);
float IupTreeGetFloat      (Ihandle* ih, const char* name, int id);
void  IupTreeSetfAttribute (Ihandle* ih, const char* name, int id, const char* format, ...);
void  IupTreeSetAttributeHandle(Ihandle* ih, const char* a, int id, Ihandle* ih_named);


/************************************************************************/
/*                      Pre-definided dialogs                           */
/************************************************************************/

Ihandle* IupFileDlg();
Ihandle* IupMessageDlg();
Ihandle* IupColorDlg();
Ihandle* IupFontDlg();

int  IupGetFile(char *arq);
void IupMessage(const char *title, const char *msg);
void IupMessagef(const char *title, const char *format, ...);
int  IupAlarm(const char *title, const char *msg, const char *b1, const char *b2, const char *b3);
int  IupScanf(const char *format, ...);
int  IupListDialog(int type, const char *title, int size, const char** list,
                   int op, int max_col, int max_lin, int* marks);
int  IupGetText(const char* title, char* text);
int  IupGetColor(int x, int y, ubyte* r, ubyte* g, ubyte* b);

//typedef int (*Iparamcb)(Ihandle* dialog, int param_index, void* user_data);
alias int function(Ihandle* dialog, int param_index, void* user_data) Iparamcb;

int IupGetParam(const char* title, Iparamcb action, void* user_data, const char* format,...);
int IupGetParamv(const char* title, Iparamcb action, void* user_data, const char* format, int param_count, int param_extra, void** param_data);

Ihandle* IupLayoutDialog(Ihandle* dialog);
Ihandle* IupElementPropertiesDialog(Ihandle* elem);

}
