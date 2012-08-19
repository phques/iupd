#include <stdio.h>
#include <string.h>
#include "iup.h"
#include "iupcontrols.h"
#include "cd.h"
#include "cdiup.h"

/* global variables that store handles used by the idle function */
Ihandle *dlg=NULL;
Ihandle *gauge=NULL;


/* main program */
int main(int argc, char **argv)
{
  char *error=NULL;

  /* IUP initialization */
  IupOpen(&argc, &argv);
  IupControlsOpen () ;

  /* loads LED */
  if((error = IupLoad("vbox.led")))
  {
    IupMessage("LED error", error);
    return 1 ;
  }

  dlg = IupGetHandle("Alinhav");

  /* sets callbacks */
//  IupSetFunction( "acao_pausa", (Icallback) btn_pause_cb );

  /* shows dialog */
//  IupShowXY(dlg,IUP_CENTER,IUP_CENTER);
  IupShow(dlg);

  /* main loop */
  IupMainLoop();

  IupDestroy(dlg);

  /* ends IUP */
  IupControlsClose() ;
  IupClose();

  return 0 ;
}
