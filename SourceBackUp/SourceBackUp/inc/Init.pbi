#IN_Name = "Init"

;{ ©Header / Init

;
; Programmpaket     : SourceBackUp
; Progrmiersprache  : PureBasic 6.10
; Programmart       : Include
; Programmteil      : Init
; GrundprogrammDate : 31.5.2024
;
; By | TFT | Temuçin SourceMagic | Schweiz | 2018
; © Turgut Frank Temuçin 2018. Alle Rechte vorbehalten.
; turgut.frank.temucin@sourcemagic.ch
;
; Last Update 1.6.2024
;  

; Fenster sichtbar machen, und in den sichbaren Bereich schieben
;ShowWindow_(SY_hwnd, #SW_SHOW)
;MoveWindow_(SY_hwnd, 0, 0, 400, 30, #False)

;}

UsePNGImageDecoder()
UseJPEGImageDecoder()

;{ Load Prefs (Pfade)
Dim Pfade.s(6)

LockMutex(SY_PrefsMutex)
OpenPreferences(SY_PrefsFilePfad.s)
For i = 1 To 6
  Pfade.s(i) =  ReadPreferenceString  ("Pfad_"+Str(i)  , "" )  
Next
ClosePreferences()  
UnlockMutex(SY_PrefsMutex)
;}

Global ReadFile
Global FileCounter
Global FileCounterMutex = CreateMutex()
Global FileCounterRefrechTimer = ElapsedMilliseconds()
Global FileCounterRefrechIntervall = 100
Define s.s
Define listcounter

If FileSize(SY_pfad+#SY_ProgrammName+"/Liste.txt")
      If ReadFile(0,SY_pfad+#SY_ProgrammName+"/Liste.txt") 
        listcounter = 0
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
    
Procedure CopyFileFromList(sourcePath.s,targetPath.s)
  
  Protected i,entry.s,relativePath.s,directoryParts,currentPath.s,fileName.s,zielVerzeichnis.s
  ;Debug "***********************************************"
  
    ; Wandle alle Trennzeichen "/" in "\"
  sourcePath = ReplaceString(sourcePath, "/", "\")
  targetPath = ReplaceString(targetPath, "/", "\")
  ;Debug "SourcePfad: " + sourcePath
  ;Debug "TargetPfad: " + targetPath
  
  ; Entferne die Laufwerkskennung links in RelativPfad
  relativePath.s = Mid(sourcePath, 3, Len(sourcePath) - 2)
  ;Debug "Relative Path (nach Entfernen der Laufwerkskennung): " + relativePath

  ; Zerlege den String in alle Pfade
  directoryParts = CountString(relativePath, "\")
  currentPath.s = targetPath
  ;Debug "Target Path: " + currentPath

  ; Schleife zum Erstellen der Verzeichnisse
  For i = 1 To directoryParts ;- 1  ; -1, da der letzte Eintrag ein Dateiname ist
    entry.s = StringField(relativePath, i, "\")
    If entry <> ""
      currentPath + entry + "\"
      ;Debug "Erzeugt werden muss: " + currentPath

      ; Erstelle das Verzeichnis
      If CreateDirectory(currentPath)
        ;Debug "Verzeichnis erstellt: " + currentPath
      ElseIf FileSize(currentPath) = -2
        ;Debug "Verzeichnis existiert bereits: " + currentPath
      Else
        Debug "Fehler beim Erstellen des Verzeichnisses: " + currentPath
      EndIf
    EndIf
  Next i
  
  ;Debug "------- Copy Files -----------------------------"
  ; Letzter Eintrag ist die Datei
  fileName.s = StringField(relativePath, directoryParts, "\")
  If fileName <> ""
    ;Debug "Datei: " + currentPath + fileName
    
    ; Entferne das linke trennzeichen
    relativePath.s = Mid(relativePath.s, 2, Len(relativePath.s) - 1)
    
    ; Berechne das Zielverzeichnis
    zielVerzeichnis.s = targetPath  + relativePath
    ;Debug "Zielverzeichnis (vor Entfernen des letzten Trennzeichens): " + zielVerzeichnis
    zielVerzeichnis = RTrim(zielVerzeichnis, "\")
    ;Debug "Zielverzeichnis : " + zielVerzeichnis
    sourcePath = RTrim(sourcePath, "\")
    ;Debug "Source Path : " + sourcePath

    ; Prüfe, ob die Quelldatei existiert
    If FileSize(sourcePath) = -1
      Debug "Fehler: Die Quelldatei existiert nicht: " + sourcePath
    EndIf
    Define Copy = 1
    ; Prüfe, ob die Target Datei schon existiert
    Define fs = FileSize(zielVerzeichnis)
    If fs > -1
      ;Debug "Info: Die Targetdatei existiert bereits: " + zielVerzeichnis
      Define s1.q = GetFileDate(sourcePath, #PB_Date_Modified)
      ;Debug "      Hole das änderungs Datum von Source"+s1
      Define s2.q = GetFileDate(zielVerzeichnis, #PB_Date_Modified) 
      ;Debug "      Hole das änderungs Datum des Target"+s2 
      If s1<> s2
        ;Debug "------- Repleace"
        copy = 0
      Else
        ;Debug "------- Holde"
      EndIf
    Else
      
      Debug "-----( "+Str(fs)+" )"
      copy = 0
    EndIf
    
    ; Kopiere die Datei ins Zielverzeichnis
    If Copy = 0 And CopyFile(sourcePath, zielVerzeichnis)
      Debug "Datei kopiert: " + sourcePath
    ElseIf Copy = 0
      Debug "Fehler beim Kopieren der Datei: " +Chr(13)+
            sourcePath +Chr(13)+
            zielVerzeichnis
    EndIf
  EndIf

  ; Beende das Programm ohne Requester
  
EndProcedure

Procedure.i PruefePfadeAufDoppelt(pf.s)
  Protected i,Rexit = 0
  Shared Pfade()  
    For i = 1 To 6      
        If Pfade(i)=pf And pf<> ""
          Debug "Pfad schon vorhanden "+Pfade(i)
          Rexit = -1
          Break
        EndIf   
    Next
  ProcedureReturn Rexit
EndProcedure
Procedure ListDirectoryContents(targetPath.s,directory.s, readfile.i, SY_Pfad.s , indent.s = "")
  
  Shared FileCounter
  Static AC_Pfad.s, AC_File.s
  Protected dir, file, entry.s,DateNummer.q
  ; Chat GPT4o. Hat gleich funktioniert
  
  dir = ExamineDirectory(#PB_Any, directory, "*.*")
  If dir
    While NextDirectoryEntry(dir)
      entry = DirectoryEntryName(dir)
      If DirectoryEntryType(dir) = #PB_DirectoryEntry_File
        ;Debug indent + "File: " + entry
        DateNummer.q = GetFileDate(Directory+"/"+Entry, #PB_Date_Modified)
        If IsFile(Readfile)
          WriteStringN(Readfile,Str(DateNummer.q)+"]"+Directory+"/"+Entry+"/")
          LockMutex(FileCounterMutex)
          FileCounter + 1
          UnlockMutex(FileCounterMutex)
          CopyFileFromList(Directory+"/"+Entry,targetPath.s)
        EndIf
        ;Debug Directory+"/"+Entry
      ElseIf DirectoryEntryType(dir) = #PB_DirectoryEntry_Directory
        If entry <> "." And entry <> ".."
          ;Debug indent + "Directory: " + entry
          
          ListDirectoryContents(targetPath.s,directory +"/"+ entry, Readfile, SY_Pfad.s, indent + "  ")
        EndIf
      EndIf
      
    Wend
    FinishDirectory(dir)
  Else
    Debug "Error: Unable to open directory " + directory
  EndIf
EndProcedure

#SUCCESS = 1
#FAILURE = 0

Global FileReadMutex1 = CreateMutex()

Structure BackUpPfade
  pf1$
  pf2$
  pf3$
  pf4$
  pf5$
  pf6$
  SY_Pfad$
EndStructure


Procedure MakeBackUp(*Parameters.BackUpPfade)
  
 
  Shared FileCounter
  Shared FileReadMutex1
  Protected i, readfile, SY_pfad.s, targetPath.s, readFileNummer.i = 0 , s.s, listcounter.i, nex = 0
  
  
  Debug "I am in the Work Thread "
  Debug "Destination Pfad 1 = "+*Parameters\pf1$
  Debug "Destination Pfad 2 = "+*Parameters\pf2$
  Debug "Destination Pfad 3 = "+*Parameters\pf3$
  Debug "Destination Pfad 4 = "+*Parameters\pf4$
  Debug "Target Pfad 5 = "+*Parameters\pf5$
  Debug "Target Pfad 6 = "+*Parameters\pf6$
  Debug "SY_Pfad = "+*Parameters\SY_Pfad$
  
  SY_pfad = *Parameters\SY_Pfad$
  targetPath.s = *Parameters\pf5$
  
  dannebennochmal:
  If targetPath.s <> ""
          LockMutex(FileCounterMutex)
          FileCounter = 0
          UnlockMutex(FileCounterMutex)
    LockMutex(FileReadMutex1)
    ;Debug "("+SY_pfad+#SY_ProgrammName+"/Liste.txt)"
    
    If FileSize(SY_pfad+#SY_ProgrammName+"/Liste.txt")
      If ReadFile(readFileNummer,SY_pfad+#SY_ProgrammName+"/Liste.txt") 
        listcounter = 0
        While Eof(readFileNummer)=0
          s= ReadString(readFileNummer)
          Listcounter + 1
        Wend
        CloseFile(readFileNummer)
      Else
        Debug "Konte ListFile nicht öffnen"
      EndIf
      Debug " Die Liste enthält "+Str(Listcounter)+" Einträge"
    EndIf
    
    ReadFile = CreateFile(#PB_Any,SY_pfad+#SY_ProgrammName+"/Liste.txt")  
    If ReadFile > 0 
      WriteStringN(ReadFile,*Parameters\pf1$)
      WriteStringN(ReadFile,*Parameters\pf2$)
      WriteStringN(ReadFile,*Parameters\pf3$)
      WriteStringN(ReadFile,*Parameters\pf4$)
      WriteStringN(ReadFile,*Parameters\pf5$)
      WriteStringN(ReadFile,*Parameters\pf6$)
      
      If *Parameters\pf1$<>""
        ListDirectoryContents( targetPath.s,Left( *Parameters\pf1$ ,Len( *Parameters\pf1$)-1 ) , ReadFile,SY_Pfad.s)
      EndIf
      If *Parameters\pf2$<>""
        ListDirectoryContents( targetPath.s,Left( *Parameters\pf2$ ,Len( *Parameters\pf2$)-1 ) , ReadFile,SY_Pfad.s)
      EndIf
      If *Parameters\pf3$<>""
        ListDirectoryContents( targetPath.s,Left( *Parameters\pf3$ ,Len( *Parameters\pf3$)-1 ) , ReadFile,SY_Pfad.s)
      EndIf
      If *Parameters\pf4$<>""
        ListDirectoryContents( targetPath.s,Left( *Parameters\pf4$ ,Len( *Parameters\pf4$)-1 ) , ReadFile,SY_Pfad.s)
      EndIf    
 
      CloseFile(ReadFile)
    Else
      Debug "CantOpenFile "+ReadFile
    EndIf
    
    UnlockMutex(FileReadMutex1)
    
    If nex=0
      nex = 1
      targetPath.s = *Parameters\pf6$
      Listcounter = 0
      Goto dannebennochmal
    EndIf
    
  ElseIf nex=0
    nex = 1
    targetPath.s = *Parameters\pf6$
    Listcounter = 0
    Goto dannebennochmal
  Else
     Debug "Target 2 not found"
  EndIf
  
  ClearStructure(*Parameters, BackUpPfade)
  FreeMemory(*Parameters)
  
  ProcedureReturn #SUCCESS
EndProcedure

Define NextThreadOk = 0
Define FL

; Define *Parameters.BackUpPfade = AllocateMemory(SizeOf(BackUpPfade))
; *Parameters\pf1$ = ""
; *Parameters\pf2$ = ""
; *Parameters\pf3$ = ""
; *Parameters\pf4$ = ""
; *Parameters\pf5$ = ""
; *Parameters\pf6$ = ""
; *Parameters\SY_Pfad$ = SY_Pfad
; 
; Define WorkThread = CreateThread(@MakeBackUp(), *Parameters)

;{ Fenster mit GadGets

Define StringGedGadFokus=0

Define ButtoImageDammy = CreateImage(#ButtoImageDammy,30,30)
Define hwnd = OpenWindow(#WindowNummer,0,0,980,420,"SourceBackUp Tool für - Driving School Evergarden -",#PB_Window_ScreenCentered| #PB_Window_SystemMenu)

;AddWindowTimer(0, 123, 250)

If LoadFont(#Font1,"Arial",16) :EndIf
Define LB= LoadImage(#BottonImage,SY_Pfad+#SY_Programmname+"/"+"loadbutton.jpg")
Define Ap = LoadImage(#AYAX,SY_Pfad+#SY_Programmname+"\"+"AJAX.png")
Define lo = LoadImage(#Logo,SY_Pfad+#SY_Programmname+"\"+"logo.png")
Define ImageCount=0
Define ImageMaxCount = 10
Define ImageDelay = 60
Define ImageDelayTimer = ElapsedMilliseconds()

Define y1.i=10

CanvasGadget(#Logo, 5, y1.i-10, 48, 46 )

  If StartDrawing(CanvasOutput(#Logo))

      Box(1,0,52,52,RGB(0,200,0))
      DrawAlphaImage(lo,1,0)
     
    StopDrawing()
  EndIf
  
ButtonGadget     (#TextZeile_1   , 60, y1.i, 900, 30, "Du kannst vier Pfade wählen, die gesichert werden sollen.",#PB_Button_Toggle)
SetGadgetFont(#TextZeile_1,FontID(#Font1))
SetGadgetState(#TextZeile_1,1)
y1 + 40

ButtonImageGadget(#GetDirektoryFrom_1, 10, y1.i, 30, 30, lb ) 
StringGadget     (#DisplayPfad_1   , 60, y1.i, 900, 30, Pfade.s(1))
SetGadgetFont(#DisplayPfad_1,FontID(#Font1))
y1 + 40  
ButtonImageGadget(#GetDirektoryFrom_2, 10, y1.i, 30, 30, lb ) 
StringGadget     (#DisplayPfad_2   , 60, y1.i, 900, 30, Pfade.s(2))
SetGadgetFont(#DisplayPfad_2,FontID(#Font1))
y1 + 40
ButtonImageGadget(#GetDirektoryFrom_3, 10, y1.i, 30, 30, lb) 
StringGadget     (#DisplayPfad_3   , 60, y1.i, 900, 30, Pfade.s(3))
SetGadgetFont(#DisplayPfad_3,FontID(#Font1))
y1 + 40
ButtonImageGadget(#GetDirektoryFrom_4, 10, y1.i, 30, 30, lb ) 
StringGadget     (#DisplayPfad_4   , 60, y1.i, 900, 30, Pfade.s(4))
SetGadgetFont(#DisplayPfad_4,FontID(#Font1))
y1 + 40

ButtonGadget(#BottonRow,60, y1.i, 445, 30,"Die Daten werden Roh gespeichert",#PB_Button_Toggle)
SetGadgetFont(#BottonRow,FontID(#Font1))
SetGadgetState(#BottonRow,1)
ButtonGadget(#BottonZip,515, y1.i, 445, 30,"Die Daten werden als Zip gespeichert", #PB_Button_Toggle)
SetGadgetFont(#BottonZip,FontID(#Font1))
SetGadgetState(#BottonZip,0)
y1 + 40

ButtonGadget     (#TextZeile_2   , 60, y1.i, 900, 30, "Wähle bis zu 2 Ziehl Pfade aus. Um die Daten zu sichern.",#PB_Button_Toggle)
SetGadgetFont(#TextZeile_2,FontID(#Font1))
SetGadgetState(#TextZeile_2,1)
y1 + 40
ButtonImageGadget(#GetDirektoryFrom_5, 10, y1.i, 30, 30, lb ) 
StringGadget     (#DisplayPfad_5   , 60, y1.i, 900, 30, Pfade.s(5))
SetGadgetFont(#DisplayPfad_5,FontID(#Font1))
y1 + 40  
ButtonImageGadget(#GetDirektoryFrom_6, 10, y1.i, 30, 30, lb ) 
StringGadget     (#DisplayPfad_6   , 60, y1.i, 900, 30, Pfade.s(6))
SetGadgetFont(#DisplayPfad_6,FontID(#Font1))
y1 + 46 

ButtonGadget(#Actiobutton,100, y1.i, 450, 30,"Dann mal los, Action")
SetGadgetFont(#Actiobutton,FontID(#Font1))
ButtonGadget(#ReadCounter,560, y1.i, 180, 30,"Counter")
SetGadgetFont(#ReadCounter,FontID(#Font1))
SetGadgetText(#ReadCounter,"00000000")
ButtonGadget(#Exit,800, y1.i, 130, 30,"I go Home")
SetGadgetFont(#Exit,FontID(#Font1))

CanvasGadget(#Canvas, 5, y1.i-10, 50, 48 )



;}


; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 336
; FirstLine = 178
; Folding = h-
; EnableThread
; EnableXP
; DPIAware
; UseMainFile = ..\..\SourceBackUp.pb
; CompileSourceDirectory
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant