#SY_ErrorMassage = "ErrorMassage"

;{ ©Header / ErrorMassage für alle Processe
;
; Programmpaket     : Driving Scool Evergarden
; Progrmiersprache  : PureBasic 6.10
; Programmart       : Include
; Programmteil      : ErrorMassage
; GrundprogrammDate : 30.5.2024
;
; By | TFT | Temuçin SourceMagic | Schweiz | 2018
; © Turgut Frank Temuçin 2018. Alle Rechte vorbehalten.
; turgut.frank.temucin@sourcemagic.ch
;
; Last Update 30.5.2024
; 
; 
;}

;{ ErrorMassagRequest
;
; 
;{ Flags
;
; Dies kann eine der folgenden Konstanten sein: 
;   #PB_MessageRequester_Ok          : Um nur einen 'Ok' Schalter zu erhalten (Standard)
;   #PB_MessageRequester_YesNo       : Um die 'Yes' (Ja) oder 'No' (Nein) Schalter zu erhalten
;   #PB_MessageRequester_YesNoCancel : Um die 'Yes' (Ja), 'No' (Nein) und 'Cancel' (Abbruch) Schalter zu erhalten
; 
; kombiniert mit einer der folgenden Werte: 
;   #PB_MessageRequester_Info       : zeigt ein Info-Icon an
;   #PB_MessageRequester_Warning    : zeigt ein Warnungs-Icon an
;   #PB_MessageRequester_Error      : zeigt ein Fehler-Icon an
;
;}

; Hier habe ich eine ganze Menge umgebaut. Und schlussendlich die Erormessage in einer externe Datei verfrachtet. Dazu musste ich einiges umbauen, ist aber 
; nicht weiter schlimm gewesen, denn jetzt habe ich im Grunde genommen ein Error message Teil, das ich nicht nur von allen Prozessen, sondern auch von Inkluddateien 
; aus benutzen kann, um zum Beispiel sicherzustellen, dass eine Inklud nicht von alleine läuft. 



; Der Vorteil von x includ ist, dass man eine, dass man ein und dieselbe inklud Datei in einem Gesamtprojekt jeweils nur einmal lädt, sodass man diese auch in inkludierten Dateien benutzen kann .

; Das hier ist die Originalprozedur, so wie sie in diesem Projekt bei Grundprogramm einmal entstanden ist. Ich habe sie als Kommentarfeil dagelassen, damit ich für spätere Experimente oder 
; Problemlösungen immer noch das Original habe. 
;{ Procedure.i SY_ErrorMassage(ErrorName.s="Request", Massage.s="NOP", CodeLine.i=0, ProcedureName.s="SY_ErrorMassage", ProgrammName.s="NOP", 
;                             IncludeName.s="Main", Flag.i= 0, Exit.i=0, Debugger.i=0, Log.i=0 , SendTo.s="", EMail.s = "turgut.frank.temucin@sourcemagic.ch")
;   
;   Protected rcode= -1
;   Protected Date.s = FormatDate("%dd_%mm_%yyyy", #PB_Compiler_Date)
;   Protected Time.s = FormatDate("%hh_%ii_%ss"  , #PB_Compiler_Date)
;   Protected et.s   = Date+" "+Time+" PureBasic "+StrF(#PB_Compiler_Version/100.0,2)
;   Protected es.s = ""
;   Protected rn.s =  ProgrammName+" "+ErrorName.s
;   Protected mt.s =  "Compile at "+Date+" "+Time+" PureBasic "+StrF(#PB_Compiler_Version/100.0,2) +Chr(13)+
;                     "ErrorTime   "+FormatDate("%dd_%mm_%yyyy", Date())+" "+FormatDate("%hh_%ii_%ss", Date())+Chr(13)+Chr(13)+
;                     "Include from = "+IncludeName.s+Chr(13)+
;                     "Procedure = "+ProcedureName.s+"()"+Chr(13)+
;                     "Line = "+Str(CodeLine.i)+Chr(13)+Chr(13)+
;                     Massage.s+Chr(13)+Chr(13)+
;                     "Contackt us via E-Mail"+Chr(13)+EMail.s
;   
;   rcode = MessageRequester(rn.s,  mt.s, Flag.i) 
;   ; rcode 2 = Abbrechen
;   ; rcode 7 = Nein
;   ; rcode 6 = ja
;   
;   es.s = rn.s+Chr(13)+mt.s+Chr(13)+"Flag "+Str(Flag.i)+Chr(13)+"----------------------------"
;   If Debugger = -1 : Debug es.s : EndIf 
;   If Log = -1 
;     LockMutex(SY_Log_Mutex)
;     If OpenFile(#SY_LogFileNr,ProgrammName+"_EM_Log.txt")
;       FileSeek(#SY_LogFileNr, Lof(#SY_LogFileNr))
;       WriteString(#SY_LogFileNr,es.s)
;       CloseFile(#SY_LogFileNr)
;     Else
;       Debug "Cant open "+ProgrammName+"_EM_log.txt"
;     EndIf
;     UnlockMutex(SY_Log_Mutex)
;   EndIf 
;   If SendTo <> ProgrammName And SendTo <> ""
;     SY_ErrorMassage(#PB_Compiler_Procedure,"Die Funktion SentTo, ist noch nicht implementiert",
;                     #PB_Compiler_Line,#PB_Compiler_Procedure,ProgrammName,IncludeName,
;                     #PB_MessageRequester_Ok,0,0,0,"")
;   EndIf
;   
;   If Exit = -1 : End : EndIf
;     
;   ProcedureReturn rcode
; EndProcedure
;}

; Und damit ich den Request da und seine einzelnen Funktionen, die sind nämlich mehr als hier zu sehen sind, prüfen kann, habe ich hier diese Zeile eingelegt. Schlussendlich damit man am 
; Start des Programms mal diesen Request da prüfen kann. 

; SY_RCode = SY_ErrorMassage("Requester","Requester Test.",#PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,"NOP",#PB_MessageRequester_Ok,0,-1,-1)

;}

If #PB_Compiler_IsIncludeFile = 0  
  Global SY_Log_Mutex = CreateMutex()
EndIf

Procedure.i SY_ErrorMassage(ErrorName.s="Request", Massage.s="NOP", CodeLine.i=0, ProcedureName.s="SY_ErrorMassage", ProgrammName.s="NOP", 
                            IncludeName.s="Main", Flag.i= 0, Exit.i=0, Debugger.i=0, Log.i=0 , SendTo.s="",
                            EMail.s = "turgut.frank.temucin@sourcemagic.ch", LogFileNr.i=255,ComplierCount.s="????")
  
  Protected rcode= -1
  Protected Date.s = FormatDate("%dd_%mm_%yyyy", #PB_Compiler_Date)
  Protected Time.s = FormatDate("%hh_%ii_%ss"  , #PB_Compiler_Date)
  Protected et.s   = Date+" "+Time+" PureBasic "+StrF(#PB_Compiler_Version/100.0,2)
  Protected es.s = ""
  Protected rn.s =  ProgrammName+" "+ErrorName.s
  Protected mt.s =  "Compile at  "+Date+" "+Time+" PureBasic "+StrF(#PB_Compiler_Version/100.0,2)+Chr(13)+
                    "ErrorTime   "+FormatDate("%dd_%mm_%yyyy", Date())+" "+FormatDate("%hh_%ii_%ss", Date())+Chr(13)+Chr(13)+
                    "CompilerCount "+ComplierCount.s+Chr(13)+
                    "Include from = "+IncludeName.s+Chr(13)+
                    "Procedure = "+ProcedureName.s+"()"+Chr(13)+
                    "Line = "+Str(CodeLine.i)+Chr(13)+Chr(13)+
                    Massage.s+Chr(13)+Chr(13)+
                    "Contackt us via E-Mail"+Chr(13)+EMail.s
  
  rcode = MessageRequester(rn.s,  mt.s, Flag.i) 
  ; rcode 2 = Abbrechen
  ; rcode 7 = Nein
  ; rcode 6 = ja
  
  es.s = rn.s+Chr(13)+mt.s+Chr(13)+"Flag "+Str(Flag.i)+Chr(13)+"----------------------------"
  If Debugger = -1 : Debug es.s : EndIf 
  If Log = -1 
    LockMutex(SY_Log_Mutex)
    If OpenFile(LogFileNr,ProgrammName.s+"\_ErrorLog.txt")
      FileSeek(LogFileNr, Lof(LogFileNr))
      WriteString(LogFileNr,es.s)
      CloseFile(LogFileNr)
    Else
      Debug "Cant open "+ProgrammName.s+"\_Errorlog.txt"
    EndIf
    UnlockMutex(SY_Log_Mutex)
  EndIf 
  If SendTo <> ProgrammName.s And SendTo <> ""
    SY_ErrorMassage(#PB_Compiler_Procedure,"Die Funktion SentTo, ist noch nicht implementiert",
                          #PB_Compiler_Line,#PB_Compiler_Procedure,ProgrammName.s,IncludeName,
                          #PB_MessageRequester_Ok,-1,-1,-1,"","turgut.frank.temucin@sourcemagic.ch",255,"0000")
  EndIf
  
  If Exit = -1 : End : EndIf
    
  ProcedureReturn rcode
EndProcedure

If #PB_Compiler_IsIncludeFile = 0  
  ;- Load Preferenz Werte, wenn vorhanden, ansonsten mit Defoult werten lade
  SY_ErrorMassage(#SY_ErrorMassage+" Requester","Dieses Programm ist alleine nicht lauffähig",
                   #PB_Compiler_Line,#PB_Compiler_Procedure,"",#SY_ErrorMassage,
                   #PB_MessageRequester_Ok,-1,-1,-1,"","turgut.frank.temucin@sourcemagic.ch",255,"0000")
EndIf

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 127
; FirstLine = 10
; Folding = 0
; EnableXP
; DPIAware
; Executable = test.exe
; CompileSourceDirectory
; EnableCompileCount = 18
; EnableBuildCount = 2
; EnableExeConstant