// iup/iup.d, IUP C functions (iup.h)
module iup.controls;

// Copyright 2012 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

import iup.types;

extern(C) {

int IupControlsOpen();
void IupControlsClose();   /* for backward compatibility only, does nothing since IUP 3 */

Ihandle* IupColorbar();
Ihandle* IupCells();
Ihandle *IupColorBrowser();
Ihandle *IupColorBrowser();
Ihandle *IupGauge();
Ihandle *IupDial(const(char)* type);
Ihandle* IupMatrix(const(char)*action);

/* IupMatrix utilities */
void  IupMatSetAttribute  (Ihandle* ih, const(char)* name, int lin, int col, const(char)* value);
void  IupMatStoreAttribute(Ihandle* ih, const(char)* name, int lin, int col, const(char)* value);
char* IupMatGetAttribute  (Ihandle* ih, const(char)* name, int lin, int col);
int   IupMatGetInt        (Ihandle* ih, const(char)* name, int lin, int col);
float IupMatGetFloat      (Ihandle* ih, const(char)* name, int lin, int col);
void  IupMatSetfAttribute (Ihandle* ih, const(char)* name, int lin, int col, const(char)* format, ...);

}
