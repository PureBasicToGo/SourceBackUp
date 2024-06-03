#ML_Name = "MainLoop"

;{ ©Header / MainLoop
;
; Programmpaket     : Driving Scool Evergarden
; Progrmiersprache  : PureBasic 6.10
; Programmart       : Include
; Programmteil      : MainLoop
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

If IsThread(WorkThread) = 0 And NextThreadOk = 1
  NextThreadOk = 0
  LockMutex(FileCounterMutex)
  ;FileCounter = 0
  UnlockMutex(FileCounterMutex) 
  
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
   SetGadgetText(#ReadCounter,Str(FL)+"/"+Str(listcounter))
  
EndIf

If FileCounterRefrechTimer < ElapsedMilliseconds()
  LockMutex(FileCounterMutex)
  Define FL =  FileCounter 
  UnlockMutex(FileCounterMutex)
  FileCounterRefrechTimer = ElapsedMilliseconds() + FileCounterRefrechIntervall
  
  SetGadgetText(#ReadCounter,Str(FL)+"/"+Str(listcounter))
  UnlockMutex(FileCounterMutex)
  
EndIf



If ImageDelayTimer < ElapsedMilliseconds()
  ImageDelayTimer = ElapsedMilliseconds() + ImageDelay

  If StartDrawing(CanvasOutput(#Canvas))

    If NextThreadOk = 1
      Box(0,0,52,52,RGB(0,200,0))
      DrawAlphaImage(ap,1,ImageCount*-48)
    Else
      Box(0,0,52,52,RGB(150,150,150))
    EndIf
    
    StopDrawing()
  EndIf
  If ImageCount > ImageMaxCount 
    ImageCount = 0 
  Else
    ImageCount + 1
  EndIf  
EndIf

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 60
; FirstLine = 36
; Folding = -
; EnableThread
; EnableXP
; DPIAware
; UseMainFile = ..\..\SourceBackUp.pb
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant