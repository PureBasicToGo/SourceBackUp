#EX_Name = "Exit"

;{ ©Header / Exit 
;
; Programmpaket     : SourceBackUp
; Progrmiersprache  : PureBasic 6.10
; Programmart       : Include
; Programmteil      : Exit
; GrundprogrammDate : 30.5.2024
;
; By | TFT | Temuçin SourceMagic | Schweiz | 2018
; © Turgut Frank Temuçin 2018. Alle Rechte vorbehalten.
; turgut.frank.temucin@sourcemagic.ch
;
; Last Update 1.6.2024
; 
; 
;}


  LockMutex(SY_PrefsMutex)  
  If OpenPreferences(SY_PrefsFilePfad.s)  
    For i = 1 To 6
      WritePreferenceString  ("Pfad_"+Str(i), Pfade(i)) 
    Next
    
    ClosePreferences() 
  Else
    ClosePreferences() 
  EndIf
  UnlockMutex(SY_PrefsMutex)
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 23
; Folding = -
; EnableThread
; EnableXP
; DPIAware
; UseMainFile = ..\..\SourceBackUp.pb
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant