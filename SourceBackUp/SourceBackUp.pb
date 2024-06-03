#SY_ProgrammName = "SourceBackUp" ; muss dem FileNamen des Code entsprechen

CompilerIf Not Defined(PB_Editor_CreateExecutable, #PB_Constant)
  #PB_Editor_CreateExecutable = 0
CompilerEndIf

; Mit den Zeichenfolgen ;{ und ;} kanst du bereiche einrahmen die sich Falten lassen. Das ist gut für die
; übersicht.

;{ ©Header / SourceBackUp
;
; Programmpaket     : Driving School Evergarden
; Progrmiersprache  : PureBasic 6.10
; Programmart       : Process
; Programmteil      : Main Loop
; GrundprogrammDate : 1.6.2024
;
; By | TFT | Temuçin SourceMagic | Schweiz | 2018
; © Turgut Frank Temuçin 2018. Alle Rechte vorbehalten.
; turgut.frank.temucin@sourcemagic.ch
;
; Last Update 2.6.2024
; 
; 
;}

; Was macht das Programm SourceBackUp

; Es ist dafür gemacht, ohne viel Aufwand ein BackUp System zu haben.
; Es können bis zu vier Source Pfade eingegeben werden.
; Doppelte sind nicht möglich. 
; Es können bis zu zwei Target Pfade gewält werden.
; Bei los gets los. Mermaliges Starten Des Copier Thread ist unterbunden.
; Die Entsprechenden Pfade werden erzeugt und das File Kopiert.
; Wenn das File im Target bereits existiert, wird das Änderungs Datum mit
; dem Datum des Aktuellen Files Verglichen. Ist das Source File Jünger wird es
; ins Target Kopiert. Die Anzeige neben dem Go zeigt an, wiefiel Files Bearbeitet
; werden / wiefiel es in der letzten Liste waren.
; Wenn der Copier Thread noch läuft, und du beänden möchtest. Must du das mit einem
; Requester bestätigen. Bei drücken der ESC Taste beändet das Programm sofort.
; 
;
; 2 dinge sind aus meiner sicht noch wichtig. Die Möglichkeit das gantze als ZIP
; zu komprimieren oder wenigstens zusammenzufassen . Und ein Ajax Spinner
; der Anzeigt das sich noch was tut. Bei Gross fiels ist es sonst zu komisch.
; 
;-
;{ TODO SourceBackUp
;- TUDO SourceBackUp
;-
;- Es gibt Files die werden immer kopiert
;- [Done]!! Der Counter für die anzahl zeilen im list.txt muss bei wider einlesen aktualisiet werden
;- [DONE]Die Oberfläche sollte schlicht sein. Funktionell
;- Funktions Botton (Nur Veränderte Dateien Sicher)
;- Funktions Botton (Alle Deiten sichern)
;- Bei Go, Müssen die Pfade geprüft werden.
;- Es muss geprüft werden ob es From und To einträge gibt
;- Es wir eine Aktuelle Liste eller Files erstellt und das erstellungsdatum registriert.
;  diese wird in eine separate FileListe geschrieben.
;- Der Kopier auftrag sollte in eine Thread erfolgen
;- es braucht eine Fortschrits anzeige
;  Ayax Spinner in einem kleine Fenster recht oben
;  wenn man drauf klicht öffnet sich ein Fortschrits Balken
;- Es muss möglich sein, die sicherung auch von einem PB Code mittels RUN() zu aktivieren
;- Mehsprachig
;-

;}
;-
;-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;-
;-
;{ TODO Grundprogramm
;- TUDO Grundprogramm
;-
;
; Bei Desktop Scalierung > 100% funktioniert OpenScreen nicht richtig
;     Wird erstmal abgefangen.

; Fenster öffnen ausserhalb des sichbereiches.
;     [Done] Fenster wird ausserhalb, unsichtbar erzeugt. ToolWindor ohne TaskIcon.
;            Dann in den Sichtbaren Bereich geschoben und eingeschaltet. Es hat sich herausgestellt
;            das Positinen in X/Y Grösser 10000 + sowie -, zu Funktions störungen des Event Handling führt.

; Es braucht eine Windows Komforme Event behandlug
;     [Done] Standart Eventschleife mit Exit bearbeitung. Event Loop mit 10 MS Delay.
;            Sowie ESC Tasten abfrage.

; Das Fenster wird normalerweise ausserhalb des sichtbaren Bereiches sein. Ich brauche eine TastenKombi
;     [Done] Mit GetAsyncKey() werden die tasten CTRL+F12 abgefragt. Das funktioniert auch wenn das Fenster
;            nicht den Fokus hat.
;     [Done] WindowsCallBack um Postmassage zu empfangen SetWindowCallback(@SY_MyWindowCallback())
;     [Done] Postmassage Emfangen und an die Mainschleife weitergeben . !! Zur Zeit keine Funktion
 
;-Ich brauch eine Komunikation zwischen den Processen, Damit das MultiProcess Konstruckt funkioniert.
;     [Done] Parameter bei Aufruf empfangen, Damit der Prozess weis wer ihn gestartet hat
;     [Done] Nach dem Namen des Startprogramms suche. SY_FindWindow(WindowText.s)
;     []     Senden einer Antwort an den Aufrufenden Process
;     []     Antwort eines gestarteten Process über Event entgegennehmen
;     []     Senden und Empfangen von Massage zwischen den Prozessen
;      []    Verwenden von SharedMem() für grössere Datenmengen. Das öffen für den Erzeugenden Prozess
;            Funktioniert schon, es gab einen Namens Space Conflickt mit CreateMutex_()
;      []    Auswerten der Massage in der Main Event Schleife  

;-Wenn das Fenster mit der  Mouse Verschoben wird. Bleibt die Mainschleife stehe. Das ist seid W7 so.
;      []    Meine lösung zur Zeit. Das fenster wird ausserhalb des Sichbaren Bereiches verschoben.
;            so kann es nicht angeklickt werden. Fenster und die 3DEngine müssen im HauptProzess geöffnet werden.
;            Da bedarf es einer komplett anderen herangehensweise.

;-Ich brauche eine eigene ErrorMassag() Funktion. Die von Jedem Prozess benutzt werden kann
;     [Done] Als Inklude Ausfüren
;     [Done] Lock/Unlock für schreibzugriff
;     [Done] Alle nötigen angaben wie ZeilenNumemr, ProzedureName, ProgrammName, InkfileName, Zeit und Datums Angaben
;            ProzessCompileCounter
;     [Done] Ausgabe im Debugger
;     [Done] Ausgabe als LogFile
;       []   Postmassage an Debagger Prozess (Vorbereitet)

; ich möchte verhindern das das Programm merfach läuft.
;     [Done] eine einfache Funktion SY_ProgramExists(), die einen Mutex verwendet.

; Bei Programmstart durch RUN() können Paramerter übergeben werden.
;     [Done] finden sich als Sring in (SY_PPV1.s)

; Ich brauche die Angaben zur Monitor Auflösung etc
;     [Done] (SY_DTSX), (SY_DTSY), (SY_Width), (SY_Height), (SY_Depth), (SY_RefreshRate) 

; Ich brauche einen Ort wo ich Programm Variablen Extern Speichern kann
;     [Done] Laden von Variablen, Speicher von Variablen, mit angabe einens Defould Wertes
;            wenn die Variablen nicht vorhanden ist. (SY_PrefsFilePfad.s)

; Ich brauche einen CompilerCounter um die Versionsnummer zu speichern
;     [Done] Abschliesend wird ein Prefs Variable verwendt (SY_CompilerCount.s)

; Da die Zahlen wenn sie in einen String gewandelt werden ein undefinierte Länge haben. Brauche ich eine Funktion.
;     [Done] Das macht dies Hier SY_FormatNumber() Die Stringlänge eine Zahl kann angepast werden

; Die Mainschleife muss man überspringen können um Init zu testen
;     [Done] Der Schalter (SY_InitBreak), "inc\Exit.pbi" wird berücksichtigt.

;- SourceCode Archivierung mit einbinden von Process Daten. Via "Grundprogramm_BackUpList.txt"
;     [Done] Zip Archivirung Aktiviert durch (SY_UseZip)
;     [Done] ArchivePfad wälbar mit (SY_ArchivePfad.s)
;       []   Prozess eigene Daten mit archivieren

; Das schreiben der Prefenrence kann von anderen Prozessen gleichzeitig geschehen.
;     [Done] Lock/Unlock Mutex bei Schreibzugriffen

;- Versions Kontrolle, damit die Prozesse erkennen, wenn sich das Grundprogramm geendert hat.
;       []

;- DebugLog() , eine erweiterte Debugausgabe
;       []

;- Process Komunikation via PostMassage ausarbeiten, daten und Empfangs Strukturen festlegen damit alle Prozesse sie Verwenden können.
;       [] 
; 
;- Ein Tool bauen um Strings zusammen zu basteln
;       []

;- Ergnis Verarbeitung Window hat den Fokus nicht
;       [] Sound abschalten
;       [] Mouse position Merken und Bewegung in Game unterbinden
;       [] Einen Idle Modus implementieren.

; Prozess Code muss in das Grundprogramm eingebunden werden können
;   [Done] Include Dateien für die einzelnen Code Abschnitte erzeugen und in ein inc\ verzeichniss einlagern.
;   [Done] Code Archivierung entsprechend anpassen.

; Programm Teile wie ErroMassage für alle Prozessoren als .pbi einbinden
;   [Done] Self Run abfrage mithilfe von #PB_Compiler_IsIncludeFile, erzeugt eine ErroMassage() wenn das Programm ohne
;          Grundprogramm leuft.

; Ich brauch ein Log File um die ErrorMassage zu speichern
;   [Done] ErrorMassage um diverse Funktionen erweitert.
;          ProgrammName_ErrorLog.txt Erzeugen und schreiben
;          Parameter für use END

; Bei start des Grundprogrammes, muss geprüft werden ob die anderen Processe, Compiliert werden müssen. Und dann mit RUN Starten
;   [Done] FileDaten holen in die Erstellung oder Modivizierung zu prüfen.
;   [Done] Process Namen als Liste in segment Data / SY_IncProzessStartName:
;   [Done] Liste abarbeiten und Prozesse Starten
;   [Done] Der Compiler output braucht eine Ausgabe, Der einfache Aufruf wurde ersetzt
;   []     Es braucht eine Schalter Variable, um den Lade und Start Mechanismuss für das MultiProzessing abzuschalten.
;
;   Hirzu gab es massive Probleme mit dem Compiler. Die Konstanten die über die IDE deviniert werden
;   Existiren nicht, wenn der Compiler direckt verwendet wird. Nachstehender Code 
;   Beseitigt das Problem. Defined() gibt dabei aus, ob eine Konstate bereits definiert ist.
;
;   CompilerIf Not Defined(PB_Editor_CreateExecutable, #PB_Constant)
;     #PB_Editor_CreateExecutable = 0
;   CompilerEndIf
 
;-Ein Anleitung verfassen, damit ich weis wie man aus einem Grundprogramm ein Prozess Program vorbereite.
;   [Done] Vorgehen getesttet und Schriftlich niedergelegt. Alle Daten befinden sich in "Anleitung, Ein Projekt anlegen\"
;   [Done] Bilder der Einstllungen Für den Compiler und Projekt Manager
;     []   Dockfile angefertigt und ausgearbeitet

; Ich benötigr mer infos im Header Teile jeden einzelnes Codes
;   [Dome] Code Header ausgearbeitet und alle Includes angepast

;-Infos zum Code und den Aufrufen und alle Infos muss ich irgendwo sammeln
;   [Dome] CodeInfo.pbi als Include dasselber nicht lauffähig ist Vorbereitet.
;     []   Diese Daten werden wärend der gesamten Projekt Phase erweitert.

; Ich könnte sichtbare Marker gebrauchen. Um Positionen im Code zu kenzeichen
;   [Dome] mit ;- läst siech im Prozedure Brouser eine Markirung anzeigen, Die man dann anspringen Kann.

; Der Code beginnt langsam unübersichtlich zu werden.
;   [Dome] Es gibt die möglichkeit Inkludes zu verwenden, Besonderst interesant ist dabei XInclude
;   [Done] Mit den zeichen ;{ ;} lassen sich Blöcke zusammen falten.

;-Ich brauche unter der MainSchleife eine Ende Sektion. Um das Programm ordentlch schliessen zu können
;   [Done] Grundlagen zum Korekten Beönden eingefürt. Auch die inc\ um Exit.pbi erweitert.
;   [Done] ScharedMem muss beändet werden
;     []   Schlieseen des CallBacks.
;   [Done] Fenster Schliessen
;   [Done] Speicher der Preverences eingeführt.

; Ich brauche es etwas übersichtlich. ich finde ja keine Varible mer.
;   [Done] Veränderbare VAriablen zusammengefast
;   [Done] Funktions Declarationen zusammengefast
;   [Done] Konstanten zusammen gefast
;   [Done] Programm funktions Variabnlen zusammengefast.

;-Ogre kann bei Dateipfaden nicht mit Umlauten umgehen
;   [Done] SY_CheckPfadUmlaute(pfad.s) mit Requester und Rückgabe Wert
;     []   Die Anfrage kann über PostMassage erfolgen.

;-Wenn das Programm weggetabt wird. Also nicht mer den Focus hat. Sollten alle Resourcen Frei gegeben werden
;     []   Freigabe und neu laden der Recourcen in Idle Mode

;-Bei erstellung eines neuen Projektes ware es Hilfreich den Projektnahmen überall wo es relevant ist zu ändern
;     []   PfadRequester zum setzen der nötigen Pfade 
;     []   Eingabe des Projekt namen
;     []   Erzeugen der Ziel Direktory
;     []   Copieren aller daten
;     []   Umbenennen aller Projekt files
;     []   Umbennen aller Variablen und Komentare
;     []   

;-Der Name für eine Projekt Vorlage kann durchaus XXXXXXX sein. Das würde verdeutlichen das es ein Dammy ist
;     []   Test ob das so überhaupt Funktioniert.

;-ich brauch ein Funktions Diagramm das das Zusammenspiel der Prozesse zeigen kann
;     []   In PRESENTATION Angefangen

;-Ich brauche Asynkrones Laden von Daten via Thread
;     []   Ein lade thread erstellen der Musikläd
;     []   Durch drücken der taste F1 wird der Thread gestartet.
;     []   im Grundprogramm leift ein Ayax Spinner
;     []   Massage system so anlegen das darüber thread nachrichten emfpangen kann.
;     [] 

;-Die BackUp Funktion mus so Umgebaut werden. Das das BackUp immer im Main Verzeichniss erfolgd. Und auf wunsch auch in einem Separaten Pfad.
;     []

; Verzeichniss strucktur anpassen, da bei mereren Prozesse es sehr schnell unübersichtlich wird
;  [Done]  Verzeichniss STrucktur ändern
;  [Done]  Alle Pfad anpassen , auch im ErrorMassage.pbi

; Die Fenster der Processe müssen sich untereinander aufbeuen.
;    []

;}
;-
;-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
;-

EnableExplicit ; Varriablen müssen declariert werden

UseZipPacker()

;{ Grundprogramm Funktions Schalter

;- * E-Mail defoult
Global SY_EMail.s       = "turgut.frank.temucin@sourcemagic.ch"
;- * InitBreak On/Off
Define SY_InitBreak     = 0 ; zu testzwecken kann nach dem Init die Eventschleife übersprungen werden
;                             um das Program ordentlich zu verlassen
;- * Use Zip
Define SY_UseZip        = 1
;- * Archive Pfad
Define SY_ArchivePfad.s = "";"D:\SY_Archive\" ; Wenn kein Pfad angegeben ist. Wird vom Defould ausgegangen

;}
;{ Funktions Deklarationen

Declare.i SY_FindWindow(WindowText.s,ErrorMassage = 0)
Declare   SY_CheckKeyCombination()
Declare.s SY_FormatNumber(number.i, digits.i = 4)
Declare   SY_ErrorMassage(ErrorName.s="Request", Massage.s="NOP", CodeLine.i=0, ProcedureName.s="SY_ErrorMassage", ProgrammName.s="NOP", 
                          IncludeName.s="Main", Flag.i= 0, Exit.i=0, Debugger.i=0, Log.i=0 , SendTo.s="",
                          EMail.s = "turgut.frank.temucin@sourcemagic.ch", LogFileNr.i=255,ComplierCount.s="????")
;-___ Inklude FunkDeclare.pbi
IncludeFile(#SY_ProgrammName+"\inc\FunkDeclare.pbi")

;}
;{ Konstanten die Ihren Wert nie ändern und nicht ändern können, anlegen.

#SY_ = 1000       ; Für alle nummern die etwas öffnen gibts hier einen Offset
#SY_EventWindow  = #sy_+1

#SY_VK_LALT     = $A4 ; Virtueller Tastencode für die linke ALT-Taste

#SY_ErrorSendTo = "" ; "debugger"
#SY_LogFileNr   = 0

;-___ Inklude Konstanten.pbi
IncludeFile(#SY_ProgrammName+"\inc\Konstanten.pbi")

;}
;{ Veränderbare Variablen deklarieren

; Variablen die keinen bestimmten Zweck haben

Define i, i1, i2, i3, i4, s0.s, s1.s, s2.s, s3.s, s4.s, s5.s, s6.s

Define wParam.i
Define lParam.i

; Funktions Varialblen

Define SY_Event ; Enthält den Rückgabe Wert von WindowEvent(), Um in der Eventabfrage das Event zu ermittlen.
Define SY_Quit  ; Wenn Quit 1 ist, wird das Programm beändet.


Global SY_RCode ; Funktionen die Werte zurückgeben. Legen in wenn nicht anders gebraucht hir ab.

Global SY_Date.s =          FormatDate("%dd_%mm_%yyyy", #PB_Compiler_Date)
Global SY_Time.s =          FormatDate("%hh_%ii_%ss", #PB_Compiler_Date)
Global SY_Version.s =       "Compile at "+SY_Date+" "+SY_Time+" PureBasic "+StrF(#PB_Compiler_Version/100.0,2) 
Global SY_Run.s=            "Run at     "+FormatDate("%dd_%mm_%yyyy", Date())+" "+FormatDate("%hh_%ii_%ss", Date())
 
Global SY_pfad.s=           GetPathPart(ProgramFilename())

Global SY_Log_Mutex  =      CreateMutex() ; Damit auf dasLogFile nicht aus mehreren Ecken schreibend zugegriffen werden kann

Debug SY_pfad.s
Global SY_PrefsMutex =      CreateMutex()
Global SY_PrefsFilePfad.s
Global SY_CompilerCount.s = "0000"

Global SY_Executable

; Desktop Data
Global SY_DTSX 
Global SY_DTSY
Global SY_Width 
Global SY_Height 
Global SY_Depth 
Global SY_RefreshRate
;}

;-___ Inklude Variablen.pbi
IncludeFile(#SY_ProgrammName+"\inc\Variablen.pbi")

;{ ProgrammParamerter Bearbeiten die bei Aufruf übergeben werden

;- Aufruf Parameter rein wenn das Programm mit Run gestartet wurde
Define SY_PPV1.s = ProgramParameter(0) ; FensterName vom Aufrufenden Programm

If SY_PPV1.s = ""
  Debug "Dieses programm wurde von Niemanden Aufgerufen"
Else
  
  ; Anzahl der Felder im String herausfinden
  
  ; es gabe 2 Möglichkeiten das zu realisieren. Zum einen könnte man
  ; von Aufrufenden Programmaus, eine Weitere Variable setzen.
  ; Global Enviament Variablen funkirniren da nicht. Schared Ram 
  ; wäre da noch ein Möglichkeit.
  
  Define fieldCount = CountString(SY_PPV1.s, ",") + 1
  If fieldCount > 0
    ; Jedes Wort einzeln extrahieren und ausgeben
    For i = 1 To fieldCount
      Define word.s = StringField(SY_PPV1.s, i, ",")
      Debug "Wort " + Str(i) + ": " + word
    Next i
  EndIf

  Debug "Dieses programm wurde von "+SY_PPV1.s+" Aufgerufen"
  SY_Rcode = SY_FindWindow(SY_PPV1.s)
  If SY_Rcode > 0 ; Das Fenster wurde gefunden
    Debug "Aufrufendes Fenster "+SY_PPV1.s+" gefunden"
  Else
    Debug "Aufrufenden Process/Fenster nicht gefunden"
  EndIf  
EndIf


;}
;{ Desktop Daten holen
  
SY_DTSX = DesktopScaledX(100)
SY_DTSY = DesktopScaledY(100)
Debug("DesktopScalierung X "+Str(SY_DTSX)+" : Y "+Str(SY_DTSY))
If SY_DTSX > 100 Or SY_DTSY > 100 
  MessageRequester("Breake Requester","Desktop Scaling > 100" ) 
  End
EndIf
 
ExamineDesktops()

Global SY_Width       = DesktopWidth(0)
Global SY_Height      = DesktopHeight(0)
Global SY_Depth       = DesktopDepth(0)
Global SY_RefreshRate = DesktopFrequency(0)

;}
;{ Preference

; Erzeuge Preferenc File

SY_PrefsFilePfad.s = SY_pfad+#SY_ProgrammName+"\_prefs.txt"
Debug SY_PrefsFilePfad.s
If FileSize(SY_PrefsFilePfad.s) = -1
  LockMutex(SY_PrefsMutex)
  CreatePreferences(SY_PrefsFilePfad.s)
  If FileSize(SY_PrefsFilePfad.s) = -1
;-++++++++ ErrorMassage() Musteaufruf    
    SY_ErrorMassage("Preference Requester","Cant create "+#SY_ProgrammName+"\_prefs.txt",
                    #PB_Compiler_Line,#PB_Compiler_Procedure,"",#SY_ProgrammName,
                    #PB_MessageRequester_Ok,-1,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
  Else
    i = 1   
  EndIf  
  ClosePreferences()
  UnlockMutex(SY_PrefsMutex)
Else
  i=1    
EndIf

;- Load Preferenz Werte, wenn vorhanden, ansonsten mit Defoult werten laden
LockMutex(SY_PrefsMutex)
OpenPreferences(SY_PrefsFilePfad.s)

SY_CompilerCount.s =  ReadPreferenceString  ("CompilerCount"  , "0000" )
SY_EMail.s =          ReadPreferenceString  ("EMail"          , SY_EMail.s )
SY_ArchivePfad.s =    ReadPreferenceString  ("ArchivePfad"    , SY_ArchivePfad.s)

ClosePreferences()  
UnlockMutex(SY_PrefsMutex)

If i = 1
  ;Debug SY_PrefsFilePfad.s
EndIf  
i = 0

;}  
;{ Add CompilerCount wenn das Programm nicht als EXE läuft
;-+++++++++ Muster Prefs Write
If #PB_Editor_CreateExecutable = 0 ; Der CompilerCounter darf nur hochgezält werden. Wenn es sich um ein Editor Run handelt
  
  i = Val(SY_CompilerCount.s)
  i=i+1
  SY_CompilerCount.s = SY_FormatNumber(i, 4)
  LockMutex(SY_PrefsMutex)  
  If OpenPreferences(SY_PrefsFilePfad.s)     
    WritePreferenceString  ("CompilerCount"   , SY_CompilerCount.s)      
    ClosePreferences() 
  Else
    ClosePreferences() 
  EndIf
  UnlockMutex(SY_PrefsMutex)
  
EndIf

;}
;{ Run from Editor make Code Archive BackUp

;{ Read inc Filname from Data

; Aus der Datasektion am Ende des Programms werden die Pfeilnamen entnommen, um das Backup Programm zu unterstützen. 
; Im Moment sind es 7 Stück an der Zahl. Während eines laufenden Projekts musst du immer wieder mal checken, ob das 
; noch so geblieben ist oder ob sich in den include Files Directories noch weitere befinden, die du gerne Als Backup
; dazu nehmen möchtest 

Restore SY_IncFileNameToBackUp
Read.i i
Global SY_IncBackupFileNameCount = i
Dim SY_IncBackupFileName.s(i)
For i1 = 1 To i
   Read.s SY_IncBackupFileName.s(i1) 
Next

;}

;{ Info

;Dieser Bereich des Codes dient ausschließlich dem Backup. Es soll darauf hinauslaufen, dass Code-Schnipsel, 
;also die PureBasic-Dateien, an einem Ort gesichert werden, der physikalisch getrennt von dem Laufwerk ist, das 
;man zum Arbeiten benutzt.

;Backups zu erstellen, kann einem eine Menge Arbeit ersparen. Ich selbst habe schon so manches Projekt verloren, 
;weil ich nicht daran gedacht habe.

;Deshalb werde ich im Grundprogramm eine Funktion vorsehen, die bei jedem Start automatisch die Source-Files sichert, 
;und zwar wenn möglich an einem Ort, der physikalisch getrennt ist. Dazu habe ich eine Variable angelegt, die man ändern 
;kann, um den Pfad des Ziellaufwerks festzulegen. Dieser Pfad kann vollständig ausgeschrieben werden und ersetzt dann den 
;Standardpfad, wenn er nicht verwendet wird. SY_ArchivePfad.s, SY_pfad.s

;Der Ort, an dem die Archiv-Dateien gespeichert werden, ist nicht strukturiert. Alle Code-Teile werden dort mit einem 
;Datum versehen, sodass sie leicht gefunden werden können. Ein Beispiel: Du hast gerade einen Code verändert, und das 
;Programm läuft nicht mehr. Du bekommst es einfach nicht wieder zum Laufen. Dann brauchst du nur im Archiv nachzuschauen 
;und kannst 12 Archive zurücksetzen, um einen funktionierenden Code wiederherzustellen.

;Die PureBasic-Maßnahme hat zwar auch eine ähnliche Funktion, die mit Sicherheit auch speichersparender ist, aber ich mag es 
;einfach auf die harte Tour.
;}

If #PB_Editor_CreateExecutable = 0
  Debug("Run from Editor")
  If SY_ArchivePfad.s = ""
    s4 = SY_pfad.s
    s3 = s4 + #SY_ProgrammName+"\archiv\"
  Else
    s4 = SY_ArchivePfad.s
    s3 = SY_ArchivePfad.s
  EndIf  
  If FileSize(s3)=-2  
    
    ;s0 = s4  
    ;Debug "*"+s3  
    s1 = SY_pfad.s + #SY_ProgrammName+ ".pb"
    ;Debug ">"+s1  
    ;Debug( "Sorce Copy From " + s1)
    s2 = s3+SY_CompilerCount.s+"-"+#SY_ProgrammName+"-"+SY_Date+"_"+SY_time+".pb"
    ;Debug( "to " + s2)
    
    s5 = SY_pfad.s + #SY_ProgrammName+"\_prefs.txt"
    ;Debug ">"+s1  
    ;Debug( "Sorce Copy From " + s1)
    s6 = s3+SY_CompilerCount.s+"-"+#SY_ProgrammName+"\_prefs-"+SY_Date+"_"+SY_time+".txt"
    ;Debug( "to " + s2)    
    i1 = 0
    If SY_UseZip = 1
      i1 = CreatePack(#PB_Any, s3+SY_CompilerCount.s+"-"+#SY_ProgrammName+".zip",#PB_PackerPlugin_Zip)
      ;Debug i1
      If i1 = 0
        SY_ErrorMassage("CreateZipArchive Requester","Zip Archive konnte nicht erstellt werden",
                        #PB_Compiler_Line,#PB_Compiler_Procedure,"",#SY_ProgrammName,
                        #PB_MessageRequester_Ok,0,-1,-1,"",SY_Email,255,SY_CompilerCount.s)
      Else        
        AddPackFile(i1,s1,#SY_ProgrammName+".pbi")
        AddPackFile(i1,s5,#SY_ProgrammName+"_prefs.txt")
      EndIf
    Else
      CopyFile(s1,  s2)  
      CopyFile(s5,  s6)  
    EndIf
    
    s1 = SY_pfad.s + #SY_ProgrammName+"\inc\"
    ;Debug "Pfad von "+s1
    For i = 1 To SY_IncBackupFileNameCount
      s2 = s1 + SY_IncBackupFileName.s(i)+".pbi"
      s4 = s3 + SY_CompilerCount.s+"-"+SY_IncBackupFileName.s(i)+"-"+SY_Date+"_"+SY_time+".pbi"
      ;Debug "von "+s2
      ;Debug "nach "+s4
      ;Debug i1
      If i1=0
        CopyFile(s2,  s4)
      Else
        ;Debug "( "+s2+" "+SY_IncBackupFileName.s(i)+".pbi"
        AddPackFile(i1,s2,SY_IncBackupFileName.s(i)+".pbi")
      EndIf      
    Next
    
    If i1     
      ClosePack(i1)
    Else
      
    EndIf
    
  Else
    SY_ErrorMassage(#SY_ProgrammName+" Code Backup Requester","Habe Archive direktory nicht gefunden",
                    #PB_Compiler_Line,#PB_Compiler_Procedure,"",#SY_ProgrammName,
                    #PB_MessageRequester_Ok,0,-1,-1,"",SY_EMail,255,SY_CompilerCount.s)
  EndIf
Else
  ;Debug("Run as Executable")
  
EndIf

 
;}       

;-___ XInklude ErrorMassage.pbi
XIncludeFile("ErrorMassage.pbi")

;{ Test auf Aplikation is running

Procedure.a SY_ProgramExists(_PN.s)
  Protected er.a
 
  CreateMutex_(0, 1, _PN.s+".m") ; der sufix +".m" muss sein. Da es sich sonst mit dem Namenspace von CreateFileMapping_ beist
  
  If (GetLastError_() = #ERROR_ALREADY_EXISTS) 
    
    SY_RCode = SY_ErrorMassage("ProgramExists Requester","Programm läuft bereits",
                               #PB_Compiler_Line,#PB_Compiler_Procedure,"",#SY_ProgrammName,
                               #PB_MessageRequester_Ok,-1,-1,-1,#SY_ErrorSendTo,SY_EMail.s,255,SY_CompilerCount.s)
    er = #True
  Else
    er = #False      
  EndIf

  ProcedureReturn er
EndProcedure

SY_ProgramExists(#SY_ProgrammName )

;}
;{ Pfade auf umlaute prüfen

; Pfad.s Da dieser Pfad auch von der 3DEngine verwedet werden kann.
; muss das überprüft werden

Procedure.i SY_CheckPfadUmlaute(pfad.s)
  
  Protected rc, s.s, s1.s, i, i1, c.s, pos=0
  
s = ""
i = Len(pfad.s)
;Debug pfad
For i1 = 1 To i
  c= Mid(pfad.s,i1,1)
  s=s+c
  If FindString("éàè£üöäÜÖÄÈÉÀ", c) ; oder die von Ihnen ausgewählten gültigen Zeichen
    s1 = "Pfad Char wrong found éàè£üöäÜÖÄÈÉÀ"+Chr(13)+
         "at position "+Str(i1)+"[ "+c+" ]"+Chr(13)+
         "in "+pfad.s+Chr(13)+
         "Would you like To exit "+#SY_ProgrammName+" ?"
         
    rc = SY_ErrorMassage(#SY_ProgrammName+" Requester",s1,
                    #PB_Compiler_Line,#PB_Compiler_Procedure,"",#SY_ProgrammName,
                    #PB_MessageRequester_YesNo ,0,-1,-1,"","turgut.frank.temucin@sourcemagic.ch",255,SY_CompilerCount.s)
    If rc = 6 : End : EndIf
    
    ;DebugLog( #PB_Compiler_Line, #PB_Compiler_Procedure, "Pfad Char wrong , found éàè£üöäÜÖÄÈÉÀ at position "+Str(i1)+"/"+c )
    ;DebugLog( #PB_Compiler_Line, #PB_Compiler_Procedure, s)
    ;DebugLog( #PB_Compiler_Line, #PB_Compiler_Procedure, pfad.s)
    ;MessageRequester("Breake at line "+#PB_Compiler_Line, "Pfad Char wrong "+Chr(13)+"found éàè£üöäÜÖÄÈÉÀ"+Chr(13)+
    ;                                                      "at position "+Str(i1)+"[ "+c+" ]"+Chr(13)+PP.s)
    ;End
    
    pos = i1
  EndIf 
Next
ProcedureReturn pos
EndProcedure

SY_RCode = SY_CheckPfadUmlaute(SY_pfad.s)

;}
;{ ZahlenString auf länge bringen
;
; number.i = 9
; String = SY_FormatNumber(number.i, 3)
; Debug String = "009"

Procedure.s SY_FormatNumber(number.i, digits.i = 4)
  ; Konvertiere die Ganzzahl in einen String
  Protected numberString.s = Str(number)
  
  ; Länge des Strings ermitteln
  Protected stringLength.i = Len(numberString)
  
  ; Wenn die Länge größer als 4 ist, kürze auf 4 Stellen
  If stringLength > digits
    numberString = Left(numberString, digits)
  EndIf
  
  ; Wenn die Länge kleiner als 4 ist, erweitere auf 4 Stellen mit führenden Nullen
  If stringLength < digits
    numberString = RSet(numberString, digits, "0")
  EndIf
  
  ; Gib den formatierten String zurück
  ProcedureReturn numberString
EndProcedure

;}

Procedure SY_CheckKeyCombination()
 
  If GetAsyncKeyState_(#VK_CONTROL) & $8000 And GetAsyncKeyState_(#VK_F12) & $8000
    ProcedureReturn #True
  EndIf

  ProcedureReturn #False
EndProcedure 

;{ Shared Memory erstellen

; Sherat Memory ist lokaler Speicher, auf den alle Prozesse und Tweets zugreifen können, wenn sie den Speicher in Ihren Speicherraum mappen. 
Define SY_SharedMemoryName.s = #SY_ProgrammName
Define SY_SharedMemorySize.i = 256
Define SY_SharedMemoryID.i = CreateFileMapping_(-1, #Null, #PAGE_READWRITE, 0, SY_SharedMemorySize, SY_SharedMemoryName.s)
If SY_SharedMemoryID.i = 0
    Define dwError.i = GetLastError_()
    If dwError = #ERROR_ALREADY_EXISTS
        SY_RCode = SY_ErrorMassage("Requester+Exit","File mapping already exists",#PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,"NOP",
                                   #PB_MessageRequester_Ok,-1,-1,-1,#SY_ErrorSendTo,SY_EMail.s,255,SY_CompilerCount.s)    
    Else
        SY_RCode = SY_ErrorMassage("Requester+Exit","Konte FileMap nicht einrichten",#PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,"NOP",
                                   #PB_MessageRequester_Ok,-1,-1,-1,#SY_ErrorSendTo,SY_EMail.s,255,SY_CompilerCount.s)    
    EndIf
;Else
;    MessageRequester("Success", "File mapping created successfully")
EndIf

If SY_SharedMemoryID <>0
 
  Define *SY_SharedMemory = MapViewOfFile_(SY_SharedMemoryID, #FILE_MAP_WRITE, 0, 0, 0)
  If *SY_SharedMemory
    ; 256 Byte langer String
    Define SY_SharedString.s = RSet("", 256, "*")
    PokeS(*SY_SharedMemory, SY_SharedString, 256, #PB_Ascii)    
  Else    
    SY_RCode = SY_ErrorMassage("Requester+Exit","Fehler beim Mapping der Shared Memory Ansicht.",#PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,"NOP",
                               #PB_MessageRequester_Ok,-1,-1,-1,#SY_ErrorSendTo,SY_EMail.s,255,SY_CompilerCount.s)    
  EndIf
  CloseHandle_(SY_SharedMemoryID)
Else  
   SY_RCode = SY_ErrorMassage("Requester+Exit","Fehler beim Erstellen des Shared Memory.",#PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,"NOP",
                               #PB_MessageRequester_Ok,-1,-1,-1,#SY_ErrorSendTo,SY_EMail.s,255,SY_CompilerCount.s)  
 EndIf
 
;}
;{ Window Stile ändern
#GWL_EXSTYLE = -20
#WS_EX_TOOLWINDOW = $00000080

Procedure SY_SetWindowExStyle(hwnd, style)
  SetWindowLong_(hwnd, #GWL_EXSTYLE, GetWindowLong_(hwnd, #GWL_EXSTYLE) | style)
EndProcedure

;}

Procedure.i SY_MyWindowCallback(WindowID, Message, wParam.i, lParam.i)
  Select Message
    Case #WM_USER + 1 
      PostMessage_(WindowID, #WM_APP + 1, wParam.i, lParam.i) 
  EndSelect
;-___ Inklude WindowsCallback  
  IncludeFile(#SY_ProgrammName+"\inc\CallBack.pbi")
  ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

Procedure.i SY_FindWindow(WindowText.s,ErrorMassage = 0)
  
;WindowText.s            = "Grundprogramm"
  Protected RCode.i = 0, *CharacterBuffer, TextLength.i
  Protected TargetWindowHandle.i    = FindWindow_(0, WindowText.s) 
  If TargetWindowHandle.i 
    ; für die eigentlich Funktion wird das nicht benötigt. Dient eher der kontrolle
    
;     Debug "Found Window Handle:  " + Str(TargetWindowHandle.i)   
;     TextLength.i = GetWindowTextLength_(TargetWindowHandle.i)+1
;     If TextLength.i     
;       Debug "Found title text of: " + Str(TextLength.i) + " characters in length "     
;       *CharacterBuffer = AllocateMemory(TextLength.i)     
;       If *CharacterBuffer       
;         GetWindowText_(TargetWindowHandle.i, *CharacterBuffer, TextLength.i)   
;         Debug PeekS(*CharacterBuffer)       
;       Else       
;         Debug "There was no character buffer allocated for some reason or other"       
;       EndIf     
;     Else     
;       Debug "No text found in the notepad window titlebar to display"     
;     EndIf 
    
    RCode = TargetWindowHandle.i  
    
  Else   
    
    SY_ErrorMassage(#PB_Compiler_Procedure+" Requester","Target window handle not found",
                #PB_Compiler_Line,#PB_Compiler_Procedure,"",#SY_ProgrammName,
                #PB_MessageRequester_Ok,-1,-1,-1,"",SY_EMail.s,255,SY_CompilerCount.s)
    RCode = -1
    
  EndIf
  
  ProcedureReturn RCode
EndProcedure

;{ Ein Fenster öffnen
Define SY_HWND = OpenWindow(#SY_EventWindow,2000,0,400,30,#SY_ProgrammName, #PB_Window_Invisible | #PB_Window_SystemMenu);| #PB_Window_NoGadgets  | #PB_Window_BorderLess  )

If SY_HWND ; Wurde das Fenster erstellt. Gibt es auch Events die Abgefragt werden müssen
  ; Fenster-Callback setzen
  ;SetWindowCallback(@SY_MyWindowCallback())
Else
  SY_RCode = SY_ErrorMassage("Requester to exit","Die Tastenkombination CTRL + F12 wurde gedrückt."+Chr(13)+#SY_ProgrammName+" wird geschlossen.",
                             #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,"NOP",
                             #PB_MessageRequester_Ok,-1,-1,-1,#SY_ErrorSendTo,SY_EMail.s,255,SY_CompilerCount.s)  
EndIf

StickyWindow(#SY_EventWindow,#True) ; Das fenster ist immer im Vordergrund
SY_SetWindowExStyle(SY_hwnd, #WS_EX_TOOLWINDOW)
  

;}
;{ Nur init & exit durchlaufen und dann End

If SY_InitBreak = 1 ; Nach der Inizialisierung kann das Programm zu Testzwecken abgebrochen Werden
  SY_Quit= 1        ; Es wird ordentlich beändet. Da nich das Exit Include abgearbeitet werden muss
EndIf


;}
;{ Prozesse Compilieren 

; Wenn dem Grundprogramm eine Liste mit Processen gegeben wird, Siehe SY_IncProzessStartName:
; Wird hir geprüft ob der Compiler instaliert ist. Ob das änderungs Datum des Process .pb
; Jünger ist als die exe. Wird diese Compiliert und im Anschluss gestartet. Der Fenster Name
; des Aufrufenden Programms wird als Parameter mitgeschickt.
;
;- +++++++++ Beispiel für Compiler Output
Procedure SY_GetCompilerInfo()
  
  Define Compiler = RunProgram(#PB_Compiler_Home+"compilers/pbcompiler", "-h", "", #PB_Program_Open | #PB_Program_Read)
  Define Output$ = ""
  If Compiler
    While ProgramRunning(Compiler)
      If AvailableProgramOutput(Compiler)
        Output$ + ReadProgramString(Compiler) + Chr(13)
      EndIf
    Wend
    Output$ + Chr(13) + Chr(13)
    Output$ + "Exitcode: " + Str(ProgramExitCode(Compiler))
    
    CloseProgram(Compiler) ; Schließt die Verbindung zum Programm
  EndIf
  
  MessageRequester("Output", Output$)
  
EndProcedure  
Procedure.s SY_GetCompilerVersion()
  
  Define Compiler = RunProgram(#PB_Compiler_Home+"compilers/pbcompiler", "--Version", "", #PB_Program_Open | #PB_Program_Read)
  Define Output$ = ""
  If Compiler
    While ProgramRunning(Compiler)
      If AvailableProgramOutput(Compiler)
        Output$ + ReadProgramString(Compiler) + Chr(13)
      EndIf
    Wend
    ;Output$ + "Exitcode: " + Str(ProgramExitCode(Compiler))
    
    CloseProgram(Compiler) ; Schließt die Verbindung zum Programm
  EndIf
  
  ProcedureReturn Output$
EndProcedure

Debug SY_GetCompilerVersion() 

;Global file.s = OpenFileRequester("Load file","","",0)

Global CompilerPfad.s = ""
Global FileName.s = #PB_Compiler_Home+"Compilers\pbcompiler.exe"
;Debug( "Compiler Home = ("+#PB_Compiler_Home+")")
If FileSize(FileName.s) > 0
  CompilerPfad.s = FileName.s
  Debug("Compiler found : "+CompilerPfad.s)
  
EndIf
  
Procedure.q SY_CreateAndRunProcessFromList()
    
    Protected Ergebniss.q , FileName.s = "", i,i1, Date.s, Time.s, t_pb.q, t_exe.q
    Protected sufix.s 
    Restore SY_IncProzessStartName
    Read i
    Read.s sufix.s
   
    If i>0 ; = 0 Es werden keine Prozesse geladen
      
      Dim ListOfRunProcess.s(i)
      
      For i1 = 1 To i
        
        Read.s ListOfRunProcess.s(i1)
        FileName.s = SY_pfad.s+ListOfRunProcess.s(i1)
        
        If FileSize(FileName.s+sufix.s) >0
  ;-+ ++++++++++ Get File Date        
          t_pb.q =  GetFileDate(FileName.s+sufix.s, #PB_Date_Modified)
          t_exe.q = GetFileDate(FileName.s+".exe", #PB_Date_Modified)
          
          Date.s =          FormatDate("%dd_%mm_%yyyy", t_pb.q)
          Time.s =          FormatDate("%hh_%ii_%ss", t_pb.q)
          
          Debug "Time Stamp "+sufix.s+": "+t_pb
          
          Date.s =          FormatDate("%dd_%mm_%yyyy", t_exe.q)
          Time.s =          FormatDate("%hh_%ii_%ss", t_exe.q)
          
          Debug "Time Stamp .exe: "+t_exe
          
          If t_pb > t_exe
            
            Debug "Der Code ist neuer wie die Exe"
            
            ; Teilprogramm Compilieren
            If FileSize(FileName.s+".exe") >0
              DeleteFile(FileName.s+".exe")
            EndIf
            Delay(100)
          
            Debug("Compile "+FileName.s+sufix.s)
            Debug(CompilerPfad.s+" "+FileName.s+sufix.s+" --thread --unicode --output "+FileName.s+".exe")
            ; RunProgram(CompilerPfad.s,FileName.s+sufix.s+" --thread --unicode --output "+FileName.s+".exe",SY_pfad.s,#PB_Program_Wait )
                     
            Define Compiler = RunProgram(CompilerPfad.s,FileName.s+sufix.s+" --thread --unicode --output "+FileName.s+".exe",SY_pfad.s,#PB_Program_Open | #PB_Program_Read  )
            Define Output$
            If Compiler
              While ProgramRunning(Compiler)
                If AvailableProgramOutput(Compiler)
                  Output$ + ReadProgramString(Compiler) + Chr(13)
                EndIf
              Wend
              Define ExitCode = ProgramExitCode(Compiler)
              Output$ + Chr(13) + Chr(13)
              Output$ + "Exitcode: " + Str(ExitCode)              
              CloseProgram(Compiler) ; Schließt die Verbindung zum Programm              
            EndIf
            If ExitCode <> 0
              MessageRequester("Output", Output$)  
            EndIf
          Else
            Debug "Muss nicht kompiliert werden"
          EndIf
        
        Else
          Debug("Source "+FileName.s+sufix.s+" Not found")
        EndIf
        Delay(100)
        ; Teilprogramm starten als Prozess-
        If FileSize(FileName.s+".exe") >0
          Debug("Run "+fileName.s+".exe")
          ; Dem zu startenden Programm wird als Parameter der Name des Starter Programmes mitgeteilt.
          Ergebniss.q = RunProgram(FileName.s+".exe",#SY_ProgrammName,SY_pfad.s,#PB_Program_Open   )
        Else
          Debug("Prozess "+fileName+".exe Not found")
        EndIf
      Next
      
    EndIf
  
    ProcedureReturn Ergebniss.q
    
  EndProcedure 
  
SY_RCode = SY_CreateAndRunProcessFromList() 
  
;}  
  
;-___ Include Init
IncludeFile(#SY_ProgrammName+"\inc\Init.pbi") 
  
;{ Main Loop 



  ;{ Event Schleife
  Repeat 
    
    ; Überprüfen der Tastenkombination CTRL + F12
    If SY_CheckKeyCombination()
      SY_RCode = SY_ErrorMassage("Requester to exit","Die Tastenkombination CTRL + F12 wurde gedrückt."+Chr(13)+#SY_ProgrammName+" wird geschlossen.",
                                 #PB_Compiler_Line,#PB_Compiler_Procedure,#SY_ProgrammName,"NOP",
                                 #PB_MessageRequester_Ok,-1,-1,-1,#SY_ErrorSendTo,SY_EMail.s,255,SY_CompilerCount.s)  
    EndIf

    SY_Event = WindowEvent()
    
      If SY_Event <>  0    
        Repeat
          If EventWindow() = #SY_EventWindow 
            Select SY_Event
              Case #PB_Event_CloseWindow      ; Programm beenden bei betätigen des CloseBotton (X) am Fenster
                SY_Quit = 1          
              Case #WM_KEYDOWN 
                Select EventwParam()
                  Case #ESC                   ; Programm beenden bei drücken der ESC Taste wenn Fenster im Fokus
                    SY_Quit = 1
                EndSelect      
              Case #WM_APP + 1                ; Eine Nachricht über PostMassage ist angekommen
                 
            EndSelect
          Else
            ;- ___ Inklude Event.pbi
            IncludeFile(#SY_ProgrammName+"\inc\Event.pbi")
 
          EndIf
          SY_Event = WindowEvent()           
        Until SY_Event = 0       
      EndIf
    
    Delay(10)                            ; 
    
    ;- ___ Inklude MainLoop.pbi
    IncludeFile(#SY_ProgrammName+"\inc\MainLoop.pbi")
    
  Until SY_Quit <> 0  
  
  ;}

;}
;{ Hier sollten alle Sachen geschlossen und entfernt werden, die Kritisch sein können.
;  Purebasic macht das in den meisten fällen selber.

If *SY_SharedMemory
  UnmapViewOfFile_(*SY_SharedMemory)
EndIf

;{ Save Main Pref

LockMutex(SY_PrefsMutex)
If OpenPreferences(SY_PrefsFilePfad.s)
  
  ; Das wurde bereits oben bei >- CompilerCounter erledigt.
  ; WritePreferenceString  ("CompilerCount"   , SY_CompilerCount.s)
    
  ClosePreferences() 
Else
  ClosePreferences() 
EndIf

UnlockMutex(SY_PrefsMutex)

;}
;- ___ Inklude Exit.pbi
IncludeFile(#SY_ProgrammName+"\inc\Exit.pbi")

If SY_InitBreak = 0 ; Nach der Inizialisierung kann das Programm zu Testzwecken sofort abgebrochen Werden
  ;MessageRequester(#SY_ProgrammName+" EXIT Requester","Close Programm",#PB_MessageRequester_Ok  )
EndIf

CloseWindow(#SY_EventWindow)

;}
;{ Data Sektion

DataSection
  
  ;- Filenamen aus dem inc Verzeichniss für Code Backup
  SY_IncFileNameToBackUp:
  Data.i 8
  Data.s "CallBack","Event","Exit","FunkDeclare","Init","Konstanten","MainLoop","Variablen"
  
  ;- Filenamen der zu startenden Prozesse
  SY_IncProzessStartName:
  Data.i 0
  Data.s ".pb"
  Data.s "Debugger"
  
EndDataSection

;}




; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 305
; FirstLine = 281
; Folding = uRBAC5+
; Optimizer
; EnableThread
; EnableXP
; DPIAware
; Executable = SourceBackUp.exe
; CompileSourceDirectory
; EnableCompileCount = 712
; EnableBuildCount = 7
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 0,0,0,128
; VersionField1 = 0,0,0,0
; VersionField2 = Temucin SourceMagic
; VersionField3 = Grundprogramm PureBasic 6.10
; VersionField4 = 19
; VersionField5 = 128
; VersionField6 = Grundprogramm  für Driving Scool Evergarden
; VersionField7 = Grundprogramm
; VersionField8 = Grundprogramm
; VersionField9 = Turgut Frank Temuçin
; VersionField13 = turgut.frank.temucin@sourcemagic.ch
; VersionField14 = www.sourcemagic.ch
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_APP