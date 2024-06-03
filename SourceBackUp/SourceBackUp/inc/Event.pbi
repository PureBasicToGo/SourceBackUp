#EV_Name = "Event"

;{ ©Header / Exit 
;
; Programmpaket     : SourceBackUp
; Progrmiersprache  : PureBasic 6.10
; Programmart       : Include
; Programmteil      : Event
; GrundprogrammDate : 31.5.2024
;
; By | TFT | Temuçin SourceMagic | Schweiz | 2018
; © Turgut Frank Temuçin 2018. Alle Rechte vorbehalten.
; turgut.frank.temucin@sourcemagic.ch
;
; Last Update 1.6.2024
; 
; 
;}

Define SBU_TC.s

If EventWindow() = #WindowNummer 
  If SY_Event <>  0    
    
    Select SY_Event
      Case #PB_Event_Timer 
        If EventTimer() = 123
          Debug "Timer"
        EndIf
        

      Case #PB_Event_CloseWindow      ; Programm beenden bei betätigen des CloseBotton (X) am Fenster
        SY_Quit = 1          
      Case #WM_KEYDOWN
        Select EventwParam()
          Case #ESC                   ; Programm beenden bei drücken der ESC Taste wenn Fenster im Fokus
            SY_Quit = 1
        EndSelect
      Case #WM_CHAR      
        
        SBU_TC.s = Chr(EventwParam())
        If FindString("abcdefghijklmnopqrstuvwxyz", SBU_TC.s)
          Debug SBU_TC.s
        ElseIf SBU_TC.s = Chr(13)
          
          If StringGedGadFokus > 0          
            SetGadgetText(#DisplayPfad_1,Pfade(StringGedGadFokus))
          EndIf
          
        EndIf
        
        ;Case #WM_APP + 1                ; Eine Nachricht über PostMassage ist angekommen
        
      Case #PB_Event_Gadget 
        
        Select EventType()
          Case #PB_EventType_Focus 
            ; Ein String Input Gadget braucht den Fokus
            Select EventGadget() 
              Case #DisplayPfad_1
                Debug "Gib den Pfad Manuell ein"
                StringGedGadFokus = 1
                Debug "StrinFokus = "+StringGedGadFokus
              Case #DisplayPfad_2
                Debug "Gib den Pfad Manuell ein"
                StringGedGadFokus = 2
                Debug "StrinFokus = "+StringGedGadFokus
              Case #DisplayPfad_3
                Debug "Gib den Pfad Manuell ein"
                StringGedGadFokus = 3
                Debug "StrinFokus = "+StringGedGadFokus
              Case #DisplayPfad_4
                Debug "Gib den Pfad Manuell ein"
                StringGedGadFokus = 4
                Debug "StrinFokus = "+StringGedGadFokus
              Case #DisplayPfad_5
                Debug "Gib den Pfad Manuell ein"
                StringGedGadFokus = 5
                Debug "StrinFokus = "+StringGedGadFokus
              Case #DisplayPfad_6
                Debug "Gib den Pfad Manuell ein" 
                StringGedGadFokus = 6
                Debug "StrinFokus = "+StringGedGadFokus
            EndSelect
          Case #PB_EventType_LeftClick 
            ; Ein Butto braucht den Mouse Klick
            Select EventGadget() 
              Case #TextZeile_1
                SetGadgetState(#TextZeile_1,1)
                StringGedGadFokus = 0
                Debug "StrinFokus = "+StringGedGadFokus
              Case #TextZeile_2
                SetGadgetState(#TextZeile_2,1)
                StringGedGadFokus = 0
                Debug "StrinFokus = "+StringGedGadFokus
              Case #GetDirektoryFrom_1
                
                Define InitialPath$ = SY_Pfad   ; anfänglichen Pfad für die Anzeige festlegen (kann auch leer sein)
                Define Path$ = PathRequester("Bitte wählen Sie einen Pfad aus", InitialPath$)
                If PruefePfadeAufDoppelt(Path$) = 0
                  Pfade(1) = Path$                
                  SetGadgetText(#DisplayPfad_1,Path$)
                Else
                  SY_ErrorMassage("Pfad Requester","Der Pfad wurde bereits gewält"+Chr(13)+"Bitte wählen sie einen anderen",
                                 #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,#EV_Name,
                                    #PB_MessageRequester_Ok,0,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
                EndIf                
                StringGedGadFokus = 0
                Debug "StrinFokus = "+StringGedGadFokus
              Case #GetDirektoryFrom_2
                
                Define InitialPath$ = SY_Pfad   ; anfänglichen Pfad für die Anzeige festlegen (kann auch leer sein)
                Define Path$ = PathRequester("Bitte wählen Sie einen Pfad aus", InitialPath$)
                If PruefePfadeAufDoppelt(Path$) = 0
                  Pfade(2) = Path$                
                  SetGadgetText(#DisplayPfad_2,Path$)
                Else
                  SY_ErrorMassage("Pfad Requester","Der Pfad wurde bereits gewält"+Chr(13)+"Bitte wählen sie einen anderen",
                               #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,#EV_Name,
                                    #PB_MessageRequester_Ok,0,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
                EndIf                           
                StringGedGadFokus = 0
                Debug "StrinFokus = "+StringGedGadFokus
              Case #GetDirektoryFrom_3
                
                Define InitialPath$ = SY_Pfad   ; anfänglichen Pfad für die Anzeige festlegen (kann auch leer sein)
                Define Path$ = PathRequester("Bitte wählen Sie einen Pfad aus", InitialPath$)
                If PruefePfadeAufDoppelt(Path$) = 0
                  Pfade(3) = Path$                
                  SetGadgetText(#DisplayPfad_3,Path$)
                Else
                  SY_ErrorMassage("Pfad Requester","Der Pfad wurde bereits gewält"+Chr(13)+"Bitte wählen sie einen anderen",
                                  #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,#EV_Name,
                                    #PB_MessageRequester_Ok,0,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
                EndIf                         
                Debug "StrinFokus = "+StringGedGadFokus
                
              Case #GetDirektoryFrom_4
                
                Define InitialPath$ = SY_Pfad   ; anfänglichen Pfad für die Anzeige festlegen (kann auch leer sein)
                Define Path$ = PathRequester("Bitte wählen Sie einen Pfad aus", InitialPath$)
                If PruefePfadeAufDoppelt(Path$) = 0
                  Pfade(4) = Path$                
                  SetGadgetText(#DisplayPfad_4,Path$)
                Else
                  SY_ErrorMassage("Pfad Requester","Der Pfad wurde bereits gewält"+Chr(13)+"Bitte wählen sie einen anderen",
                                    #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,#EV_Name,
                                    #PB_MessageRequester_Ok,0,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
                EndIf                         
                Debug "StrinFokus = "+StringGedGadFokus
                
              Case #BottonRow
                SetGadgetState(#BottonRow,1)
                SetGadgetState(#BottonZip,0)
                StringGedGadFokus = 0
                Debug "StrinFokus = "+StringGedGadFokus
              Case #BottonZip
                SetGadgetState(#BottonRow,1)
                SetGadgetState(#BottonZip,0)
                SY_ErrorMassage("Funktion Requester","Diese Funktion wird zur Zeit"+Chr(13)+"nicht unterstützt",
                    #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,#EV_Name,
                    #PB_MessageRequester_Ok,0,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
                StringGedGadFokus = 0
                Debug "StrinFokus = "+StringGedGadFokus
              Case #GetDirektoryFrom_5
 ;{ GetDirektoryFrom_5               
                Define InitialPath$ = SY_Pfad   ; anfänglichen Pfad für die Anzeige festlegen (kann auch leer sein)
                Define Path$ = PathRequester("Bitte wählen Sie einen Pfad aus", InitialPath$)
                If PruefePfadeAufDoppelt(Path$) = 0
                  Pfade(5) = Path$                
                  SetGadgetText(#DisplayPfad_5,Path$)
                Else
                  SY_ErrorMassage("Pfad Requester","Der Pfad wurde bereits gewält"+Chr(13)+"Bitte wählen sie einen anderen",
                                    #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,#EV_Name,
                                    #PB_MessageRequester_Ok,0,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
                EndIf                          
                StringGedGadFokus = 0
                Debug "StrinFokus = "+StringGedGadFokus
                ;}
              Case #GetDirektoryFrom_6
 ;{ GetDirektoryFrom_6               
                Define InitialPath$ = SY_Pfad   ; anfänglichen Pfad für die Anzeige festlegen (kann auch leer sein)
                Define Path$ = PathRequester("Bitte wählen Sie einen Pfad aus", InitialPath$)
                If PruefePfadeAufDoppelt(Path$) = 0
                  Pfade(6) = Path$                
                  SetGadgetText(#DisplayPfad_6,Path$)
                Else
                  SY_ErrorMassage("Pfad Requester","Der Pfad wurde bereits gewält"+Chr(13)+"Bitte wählen sie einen anderen",
                                    #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,#EV_Name,
                                    #PB_MessageRequester_Ok,0,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
                EndIf                            
                StringGedGadFokus = 0
                Debug "StrinFokus = "+StringGedGadFokus
                ;}
              Case #Actiobutton
 ;{ ActionButton              
                If NextThreadOk = 0 ; Keine mehrfachen aufrufe
                  NextThreadOk = 1
                  listcounter = 0
                  If FileSize(SY_pfad+#SY_ProgrammName+"/Liste.txt")
                    If ReadFile(0,SY_pfad+#SY_ProgrammName+"/Liste.txt") 
                      
                      While Eof(0)=0
                        s= ReadString(0)
                        Listcounter + 1
                      Wend
                      CloseFile(0)
                    Else
                      Debug "Konte ListFile nicht öffnen"
                    EndIf
                    Debug " Die Liste enthält "+Str(Listcounter)+" Einträge"
                  EndIf
                  
                  
                  If Pfade(1) = "" And Pfade(2) = "" And Pfade(3) = "" And Pfade(4) = "" 
                    SY_ErrorMassage(" Requester","Es sind keine Quell Pfade angegeben",
                                    #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,#EV_Name,
                                    #PB_MessageRequester_Ok,0,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
                    Break
                  EndIf
                  If Pfade(5) = "" And Pfade(6) = "" 
                    SY_ErrorMassage(" Requester","Es sind keine Ziehl Pfade angegeben",
                                    #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,#EV_Name,
                                    #PB_MessageRequester_Ok,0,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
                    Break
                  EndIf
                  
                       
                  Define *Parameters.BackUpPfade = AllocateMemory(SizeOf(BackUpPfade))
                  *Parameters\pf1$ = Pfade(1)
                  *Parameters\pf2$ = Pfade(2)
                  *Parameters\pf3$ = Pfade(3)
                  *Parameters\pf4$ = Pfade(4)
                  *Parameters\pf5$ = Pfade(5)
                  *Parameters\pf6$ = Pfade(6)
                  *Parameters\SY_Pfad$ = SY_Pfad
                  
                  Define WorkThread = CreateThread(@MakeBackUp(), *Parameters)
                  
     
                EndIf
;}                
              Case #Exit
 ;{ Exit
                If NextThreadOk = 1
                  SY_RCode= SY_ErrorMassage("Exit Requester","Copy Files läuft noch."+Chr(13)+"Sollen wir dennoch beänden?",
                                  #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,#EV_Name,
                                  #PB_MessageRequester_YesNo,0,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
                  If SY_RCode = 6 : SY_Quit = 1 : EndIf
                Else
                    SY_Quit = 1
                EndIf 
              ;}
            EndSelect            
        EndSelect            
    EndSelect
    
  EndIf
EndIf


; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 162
; FirstLine = 144
; Folding = h
; EnableThread
; EnableXP
; DPIAware
; UseMainFile = ..\..\SourceBackUp.pb
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant