EnableExplicit

;Eigene Fehlermeldung
Declare ErrorHandler()
OnErrorCall(@ErrorHandler())

;Nur einmal starten
If CreateSemaphore_(0, 0, 1, "0615f306-d805-11db-8314-0820200c9a67") <> 0
  If GetLastError_() = #ERROR_ALREADY_EXISTS
    End
  EndIf
EndIf

Macro MsgBox_Error(Text)
  MessageRequester("Fehler", Text, #MB_OK|#MB_ICONERROR)
EndMacro

;{ Ressource
Enumeration
  #Win_Main
  #Win_New
  #Win_Preview
  #Win_OpenImg
EndEnumeration

Enumeration
  ;Main
  #G_CN_Toolbar
  #G_LV_Ebenen
  #G_CN_EbenenInfo
  #G_LI_Info
  #G_SP_1
  #G_CN_ImageBorder
  #G_IM_Image
  #G_SP_2
  ;New
  #G_TX_New_Format
  #G_CB_New_Format
  #G_SR_New_Width
  #G_TX_New_Size
  #G_SR_New_Height
  #G_FR_New_Gap
  #G_BN_New_Cancel
  #G_BN_New_Create
  ;Preview
  #G_OP_Preview_1
  #G_OP_Preview_2
  #G_OP_Preview_3
  #G_OP_Preview_4
  #G_BN_Preview_OK
  #G_IG_Preview_Image
  ;OpenImg
  #G_EL_OpenImg_File
  #G_CB_OpenImg_Folder
  #G_FR_OpenImg_Preview
  #G_IG_OpenImg_Preview
  #G_CB_OpenImg_Zoomed
  #G_TX_OpenImg_PreviewSize
  #G_BN_OpenImg_OK
  #G_BN_OpenImg_Cancel
EndEnumeration

Enumeration
  #ToolBar_Main
EndEnumeration

Enumeration
  #Mnu_New
  #Mnu_Open
  #Mnu_Save
  #Mnu_Close
  #Mnu_Copy
  #Mnu_AddEbene
  #Mnu_DelEbene
  #Mnu_RenameEbene
  #Mnu_RefreshImg
  #Mnu_SetImg
  #Mnu_RemImg
  #Mnu_SetClr
  #Mnu_EbeneUp
  #Mnu_EbeneDown
  #Mnu_ResetOffSet
  #Mnu_OffSetLeft
  #Mnu_OffSetRight
  #Mnu_OffSetUp
  #Mnu_OffSetDown
  #Mnu_ResetZoom
  #Mnu_ZoomIn
  #Mnu_ZoomOut
  #Mnu_Preview
  #Mnu_ShowFPS
  #Mnu_ShowBorder
  #Mnu_Backround
  #Mnu_Update
  #Mnu_Info
EndEnumeration

Structure Ebene
  Name.s
  hImg.l
  Mem.l
  Size.l
  OffSetX.w
  OffSetY.w
EndStructure
Global NewList Ebene.Ebene()

Structure Format
  Name.s
  Width.l
  Height.l
  FramesW.b
  FramesH.b
EndStructure
Global NewList Format.Format()

AddElement(Format()): Format()\Name = "RPG-Maker 2000": Format()\Width = 72:  Format()\Height = 128: Format()\FramesW = 3 :Format()\FramesH = 4
AddElement(Format()): Format()\Name = "RPG-Maker 2003": Format()\Width = 72:  Format()\Height = 128: Format()\FramesW = 3 :Format()\FramesH = 4
AddElement(Format()): Format()\Name = "RPG-Maker XP":   Format()\Width = 128: Format()\Height = 192: Format()\FramesW = 4 :Format()\FramesH = 4

Global Dim Anim.l(0)

UsePNGImageDecoder()
UsePNGImageEncoder()

#PrgName                                = "CharacterEditor"
#PrgVers                                = 209
#FileTestString                         = "CE_3"
#FileTestStringN                        = "CE_4"
#CharSizeX                              = 128
#CharSizeY                              = 192
#maxEbenen                              = 25
#maxENameChar                           = 30
#CharFolder                             = "Save\"
#ImageFolder                            = "Image\"
#DefaultBGClr                           = $FF80FF
#EMail                                  = "angel-kai@hotmail.de"
#URL_Homepage                           = "http://www.kaisnet.de/"
#URL_Update                             = "http://www.kaisnet.de/data/version/charedit.inf"

Global WindowEvent.l, EventWindow.l, EventGadget.l, EventMenu.l, EventType.l
Global BackroundColor.l
Global ZoomF.f
Global frame.l
Global threadAnim.l
Global Img_Preview.l
Global L_IsSaveFile.l, S_OpenFilePath.s
Global L_CharSetW.l, L_CharSetH.l, L_CharSetF.l
Global Img_CharSetDisp.l, Img_CharSetDraw.l

;Include
Global Icn_DelEbene.l                   = CatchImage(#PB_Any, ?Icn_DelEbene)
Global Icn_Down.l                       = CatchImage(#PB_Any, ?Icn_Down)
Global Icn_EbeneDown.l                  = CatchImage(#PB_Any, ?Icn_EbeneDown)
Global Icn_EbeneUp.l                    = CatchImage(#PB_Any, ?Icn_EbeneUp)
Global Icn_Left.l                       = CatchImage(#PB_Any, ?Icn_Left)
Global Icn_New.l                        = CatchImage(#PB_Any, ?Icn_New)
Global Icn_Open.l                       = CatchImage(#PB_Any, ?Icn_Open)
Global Icn_Right.l                      = CatchImage(#PB_Any, ?Icn_Right)
Global Icn_Save.l                       = CatchImage(#PB_Any, ?Icn_Save)
Global Icn_Up.l                         = CatchImage(#PB_Any, ?Icn_Up)
Global Icn_AddEbene.l                   = CatchImage(#PB_Any, ?Icn_AddEbene)
Global Icn_Close.l                      = CatchImage(#PB_Any, ?Icn_Close)
Global Icn_SetImg.l                     = CatchImage(#PB_Any, ?Icn_SetImg)
Global Icn_RemImg.l                     = CatchImage(#PB_Any, ?Icn_RemImg)
Global Icn_Info.l                       = CatchImage(#PB_Any, ?Icn_Info)
Global Icn_Backround.l                  = CatchImage(#PB_Any, ?Icn_Backround)
Global Icn_Clipboard.l                  = CatchImage(#PB_Any, ?Icn_Clipboard)
Global Icn_ResetZoom.l                  = CatchImage(#PB_Any, ?Icn_ResetZoom)
Global Icn_ZoomIn.l                     = CatchImage(#PB_Any, ?Icn_ZoomIn)
Global Icn_ZoomOut.l                    = CatchImage(#PB_Any, ?Icn_ZoomOut)
Global Icn_ResetOffSet.l                = CatchImage(#PB_Any, ?Icn_ResetOffSet)
Global Icn_RefreshImg.l                 = CatchImage(#PB_Any, ?Icn_RefreshImg)
Global Icn_Preview.l                    = CatchImage(#PB_Any, ?Icn_Preview)
Global Icn_Update.l                     = CatchImage(#PB_Any, ?Icn_Update)
DataSection
  IncludePath "G:\PureBasic\Projekte\CharEdit\Source\"
  Icn_DelEbene:      IncludeBinary "Icn_DelEbene.ico"
  Icn_Down:          IncludeBinary "Icn_Down.ico"
  Icn_EbeneDown:     IncludeBinary "Icn_EbDown.ico"
  Icn_EbeneUp:       IncludeBinary "Icn_EbUp.ico"
  Icn_Left:          IncludeBinary "Icn_Left.ico"
  Icn_New:           IncludeBinary "Icn_New.ico"
  Icn_Open:          IncludeBinary "Icn_Open.ico"
  Icn_Right:         IncludeBinary "Icn_Right.ico"
  Icn_Save:          IncludeBinary "Icn_Save.ico"
  Icn_Up:            IncludeBinary "Icn_Up.ico"
  Icn_AddEbene:      IncludeBinary "Icn_AddEbene.ico"
  Icn_Close:         IncludeBinary "Icn_Close.ico"
  Icn_SetImg:        IncludeBinary "Icn_SetImg.ico"
  Icn_RemImg:        IncludeBinary "Icn_RemImg.ico"
  Icn_Info:          IncludeBinary "Icn_Info.ico"
  Icn_Backround:     IncludeBinary "Icn_Fill.ico"
  Icn_Clipboard:     IncludeBinary "Icn_Clipboard.ico"
  Icn_ResetZoom:     IncludeBinary "Icn_Zoom.ico"
  Icn_ZoomIn:        IncludeBinary "Icn_ZoomIn.ico"
  Icn_ZoomOut:       IncludeBinary "Icn_ZoomOut.ico"
  Icn_ResetOffSet:   IncludeBinary "Icn_ResetOffSet.ico"
  Icn_RefreshImg:    IncludeBinary "Icn_RefreshImg.ico"
  Icn_Preview:       IncludeBinary "Icn_Preview.ico"
  Icn_Update:        IncludeBinary "Icn_Update.ico"
EndDataSection
;}

;{ Prozeduren
Procedure ErrorHandler()
  MessageRequester("Fehler", "Datei: " + GetFilePart(ErrorFile()) + #CR$ + "Adresse: " + Hex(ErrorAddress()) + #CR$ + "Zeile: " + Str(ErrorLine()) + #CR$ + #CR$ + ErrorMessage(ErrorCode()), #MB_ICONERROR|#MB_OK)
  End
EndProcedure

Procedure.s ExePath()
  Protected temp$ = Space(#MAX_PATH)
  GetModuleFileName_(0, @temp$, #MAX_PATH)
  ProcedureReturn GetPathPart(temp$)
EndProcedure

Procedure.l Window_GetDesktopPosition(Window, Direction)
  If IsWindow(Window) <> #False And Direction >= 1 And Direction <= 2
    Window = WindowID(Window)
    Protected W.RECT
    GetWindowRect_(Window, @W)
    Select Direction
      Case 1: ProcedureReturn (GetSystemMetrics_(#SM_CXSCREEN) - (W\right - W\left)) / 2
      Case 2: ProcedureReturn (GetSystemMetrics_(#SM_CYSCREEN) - (W\bottom - W\top)) / 2
    EndSelect
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure.l Window_GetWidth(Window)
  If IsWindow(Window) <> #False
    Window = WindowID(Window)
    Protected W.RECT
    GetWindowRect_(Window, @W)
    ProcedureReturn W\right - W\left
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure.l Window_GetHeight(Window)
  If IsWindow(Window) <> #False
    Window = WindowID(Window)
    Protected W.RECT
    GetWindowRect_(Window, @W)
    ProcedureReturn W\bottom - W\top
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure CenterWinOnMainWin(MainWindow.l, ChildrenWindow.l)
  Protected PosX.l, PosY.l
  If IsWindow(MainWindow) <> 0 And IsWindow(ChildrenWindow) <> 0
    PosX = WindowX(MainWindow) + (WindowWidth(MainWindow)/2) - (WindowWidth(ChildrenWindow)/2)
    PosY = WindowY(MainWindow) + (WindowHeight(MainWindow)/2) - (WindowHeight(ChildrenWindow)/2)
    ResizeWindow(ChildrenWindow, PosX, PosY, #PB_Ignore, #PB_Ignore)
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure.s ReadFixedString(File, Length)
  Protected result.s, memory.l

  If IsFile(File) <> #False And Length > 0
    memory = AllocateMemory(Length)
    If memory <> #False
      ReadData(File, memory, Length)
      result = PeekS(memory, Length)
      FreeMemory(memory)
      ProcedureReturn result
    EndIf
  EndIf
EndProcedure

Procedure.l Window_GetBorderWidth(Window)
  If IsWindow(Window) <> #False
    Window = WindowID(Window)
    Protected W.RECT, C.RECT
    GetWindowRect_(Window, @W)
    GetClientRect_(Window, @C)
    ProcedureReturn w\right - w\left - c\right
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure.l Window_GetBorderHight(Window)
  If IsWindow(Window) <> #False
    Window = WindowID(Window)
    Protected W.RECT, C.RECT
    GetWindowRect_(Window, @W)
    GetClientRect_(Window, @C)
    ProcedureReturn w\bottom - w\top - c\bottom
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure.l Window_GetClientWidth(Window)
  If IsWindow(Window) <> 0 Or IsWindow_(Window) <> 0
    If IsWindow(Window) <> 0: Window = WindowID(Window): EndIf
    Protected C.RECT
    GetClientRect_(Window, @C)
    ProcedureReturn C\right - C\left
  EndIf
EndProcedure

Procedure.l Toolbar_GetWidth(Toolbar)
  If IsToolBar(Toolbar) <> 0
    Protected S.SIZE

    SendMessage_(ToolBarID(Toolbar), #TB_GETMAXSIZE, #Null, @S)
    ProcedureReturn S\cx
  EndIf
EndProcedure

Procedure.l Toolbar_GetHeight(Toolbar)
  If IsToolBar(Toolbar) <> 0
    Protected S.SIZE

    SendMessage_(ToolBarID(Toolbar), #TB_GETMAXSIZE, #Null, @S)
    ProcedureReturn S\cy
  EndIf
EndProcedure
;}

;{ Window
If OpenWindow(#Win_Main, 0, 0, 640, 480, #PrgName, #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
  ;ToolBar
  If CreateToolBar(#ToolBar_Main, WindowID(#Win_Main))
    SetWindowLong_(ToolBarID(#ToolBar_Main), #GWL_STYLE, GetWindowLong_(ToolBarID(#ToolBar_Main), #GWL_STYLE)|#CCS_NODIVIDER)
    ToolBarImageButton(#Mnu_New, ImageID(Icn_New)) : ToolBarToolTip(#ToolBar_Main, #Mnu_New, "Neu [Strg + N]")
    ToolBarImageButton(#Mnu_Open, ImageID(Icn_Open)) : ToolBarToolTip(#ToolBar_Main, #Mnu_Open, "Öffnen [Strg + O]")
    ToolBarImageButton(#Mnu_Save, ImageID(Icn_Save)) : ToolBarToolTip(#ToolBar_Main, #Mnu_Save, "Speichern [Strg + S]")
    ToolBarImageButton(#Mnu_Close, ImageID(Icn_Close)) : ToolBarToolTip(#ToolBar_Main, #Mnu_Close, "Schliessen [Strg + C]")
    ToolBarImageButton(#Mnu_Copy, ImageID(Icn_Clipboard)) : ToolBarToolTip(#ToolBar_Main, #Mnu_Copy, "Kopieren [C]")
    ToolBarSeparator()
    ToolBarImageButton(#Mnu_AddEbene, ImageID(Icn_AddEbene)) : ToolBarToolTip(#ToolBar_Main, #Mnu_AddEbene, "Ebene hinzufügen [E]")
    ToolBarImageButton(#Mnu_DelEbene, ImageID(Icn_DelEbene)) : ToolBarToolTip(#ToolBar_Main, #Mnu_DelEbene, "Ebene löschen [F]")
    ToolBarSeparator()
    ToolBarImageButton(#Mnu_EbeneUp, ImageID(Icn_EbeneUp)) : ToolBarToolTip(#ToolBar_Main, #Mnu_EbeneUp, "Ebene hoch [U]")
    ToolBarImageButton(#Mnu_EbeneDown, ImageID(Icn_EbeneDown)) : ToolBarToolTip(#ToolBar_Main, #Mnu_EbeneDown, "Ebene runter [D]")
    ToolBarImageButton(#Mnu_ResetOffSet, ImageID(Icn_ResetOffSet)) : ToolBarToolTip(#ToolBar_Main, #Mnu_ResetOffSet, "Position zurücksetzen [X]")
    ToolBarImageButton(#Mnu_OffSetLeft, ImageID(Icn_Left)) : ToolBarToolTip(#ToolBar_Main, #Mnu_OffSetLeft, "Ebene nach links verschieben [Alt + Cursor Links]")
    ToolBarImageButton(#Mnu_OffSetUp, ImageID(Icn_Up)) : ToolBarToolTip(#ToolBar_Main, #Mnu_OffSetUp, "Ebene nach oben verschieben [Alt + Cursor Hoch]")
    ToolBarImageButton(#Mnu_OffSetDown, ImageID(Icn_Down)) : ToolBarToolTip(#ToolBar_Main, #Mnu_OffSetDown, "Ebene nach unten verschieben [Alt + Cursor Runter]")
    ToolBarImageButton(#Mnu_OffSetRight, ImageID(Icn_Right)) : ToolBarToolTip(#ToolBar_Main, #Mnu_OffSetRight, "Ebene nach rechts verschieben [Alt + Cursor Rechts]")
    ToolBarSeparator()
    ToolBarImageButton(#Mnu_RefreshImg, ImageID(Icn_RefreshImg)) : ToolBarToolTip(#ToolBar_Main, #Mnu_RefreshImg, "Aktualisieren [G]")
    ToolBarImageButton(#Mnu_SetImg, ImageID(Icn_SetImg)) : ToolBarToolTip(#ToolBar_Main, #Mnu_SetImg, "Grafik zuweisen [I]")
    ToolBarImageButton(#Mnu_RemImg, ImageID(Icn_RemImg)) : ToolBarToolTip(#ToolBar_Main, #Mnu_RemImg, "Grafik entfernen [R]")
    ToolBarImageButton(#Mnu_Backround, ImageID(Icn_Backround)) : ToolBarToolTip(#ToolBar_Main, #Mnu_Backround, "Hintergrundfarbe [B]")
    ToolBarSeparator()
    ToolBarImageButton(#Mnu_ResetZoom, ImageID(Icn_ResetZoom)) : ToolBarToolTip(#ToolBar_Main, #Mnu_ResetZoom, "Normalgröße [N]")
    ToolBarImageButton(#Mnu_ZoomIn, ImageID(Icn_ZoomIn)) : ToolBarToolTip(#ToolBar_Main, #Mnu_ZoomIn, "Vergrößern [+]")
    ToolBarImageButton(#Mnu_ZoomOut, ImageID(Icn_ZoomOut)) : ToolBarToolTip(#ToolBar_Main, #Mnu_ZoomOut, "Verkleinern [-]")
    ToolBarImageButton(#Mnu_Preview, ImageID(Icn_Preview)) : ToolBarToolTip(#ToolBar_Main, #Mnu_Preview, "Vorschau [P]")
    ToolBarSeparator()
    ToolBarImageButton(#Mnu_Update, ImageID(Icn_Update)): ToolBarToolTip(#ToolBar_Main, #Mnu_Update, "Nach Update suchen")
    ToolBarImageButton(#Mnu_Info, ImageID(Icn_Info)) : ToolBarToolTip(#ToolBar_Main, #Mnu_Info, "Informationen")
  Else
    MsgBox_Error("ToolBar Main konnte nicht erstellt werden."): End
  EndIf
  ;Gadgets
  ContainerGadget(#G_CN_Toolbar, 2, 2, Toolbar_GetWidth(#ToolBar_Main), Toolbar_GetHeight(#ToolBar_Main))
    SetParent_(ToolBarID(#ToolBar_Main), GadgetID(#G_CN_Toolbar))
  CloseGadgetList()
  ListViewGadget(#G_LV_Ebenen, 2, GadgetHeight(#G_CN_Toolbar) + 4, 180, 350)
  ListIconGadget(#G_LI_Info, 2, GadgetHeight(#G_CN_Toolbar) + 356, 180, WindowHeight(#Win_Main) - GadgetHeight(#G_CN_Toolbar) - 358, "Type", 50, #PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect|#LVS_NOCOLUMNHEADER)
  AddGadgetColumn(#G_LI_Info, 1, "Content", 126)
  AddGadgetItem(#G_LI_Info, 0, "Name")
  AddGadgetItem(#G_LI_Info, 1, "Breite")
  AddGadgetItem(#G_LI_Info, 2, "Höhe")
  AddGadgetItem(#G_LI_Info, 3, "Memory")
  AddGadgetItem(#G_LI_Info, 4, "OffSet")
  AddGadgetItem(#G_LI_Info, 5, "Zoom")
  SetGadgetItemAttribute(#G_LI_Info, -1, #PB_ListIcon_ColumnWidth, Window_GetClientWidth(GadgetID(#G_LI_Info)) - GetGadgetItemAttribute(#G_LI_Info, -1, #PB_ListIcon_ColumnWidth, 0), 1)
  ContainerGadget(#G_CN_ImageBorder, 184, GadgetHeight(#G_CN_Toolbar) + 4, WindowWidth(#Win_Main) - 186, WindowHeight(#Win_Main) - GadgetHeight(#G_CN_Toolbar) - 6, #PB_Container_Flat)
    ImageGadget(#G_IM_Image, 182, GadgetHeight(#G_CN_Toolbar), #CharSizeX, #CharSizeY, 0)
    DisableGadget(#G_IM_Image, #True)
  CloseGadgetList()
  Global mWinW_Main = Window_GetWidth(#Win_Main)
  Global mWinH_Main = Window_GetHeight(#Win_Main)
Else
  MsgBox_Error("Fenster Main konnte nicht erstellt werden."): End
EndIf

If OpenWindow(#Win_New, 419, 358, 235, 125, "Neu", #PB_Window_Invisible|#PB_Window_SystemMenu, WindowID(#Win_Main))
  TextGadget(#G_TX_New_Format, 5, 5, 225, 13, "Format:")
  ComboBoxGadget(#G_CB_New_Format, 5, 20, 225, 20)
  ForEach Format()
    AddGadgetItem(#G_CB_New_Format, -1, Format()\Name)
  Next
  StringGadget(#G_SR_New_Width, 10, 55, 65, 20, "", #PB_String_ReadOnly)
  TextGadget(#G_TX_New_Size, 75, 55, 15, 20, "x", #PB_Text_Center)
  StringGadget(#G_SR_New_Height, 90, 55, 65, 20, "", #PB_String_ReadOnly)
  Frame3DGadget(#G_FR_New_Gap, -5, 85, 245, 2, "", #PB_Frame3D_Single)
  ButtonGadget(#G_BN_New_Cancel, 155, 95, 75, 24, "Abbrechen")
  ButtonGadget(#G_BN_New_Create, 78, 95, 75, 24, "Erstellen")
  
  DisableWindow(#Win_New, #True)
Else
  MsgBox_Error("Fenster New konnte nicht erstellt werden."): End
EndIf

If OpenWindow(#Win_Preview, 0, 0, 150, 160, "Vorschau", #PB_Window_Invisible|#PB_Window_SystemMenu, WindowID(#Win_Main))
  OptionGadget(#G_OP_Preview_1, 10, 10, 20, 20, "") : GadgetToolTip(#G_OP_Preview_1, "Richtung 1")
  OptionGadget(#G_OP_Preview_2, 10, 35, 20, 20, "") : GadgetToolTip(#G_OP_Preview_2, "Richtung 2")
  OptionGadget(#G_OP_Preview_3, 10, 60, 20, 20, "") : GadgetToolTip(#G_OP_Preview_3, "Richtung 3")
  OptionGadget(#G_OP_Preview_4, 10, 85, 20, 20, "") : GadgetToolTip(#G_OP_Preview_4, "Richtung 4")
  ImageGadget(#G_IG_Preview_Image, 60, 35, 32, 48, 0)
  ButtonGadget(#G_BN_Preview_OK, 35, 125, 80, 24, "OK")

  DisableWindow(#Win_Preview, #True)
Else
  MsgBox_Error("Fenster Preview konnte nicht erstellt werden."): End
EndIf

If OpenWindow(#Win_OpenImg, 0, 0, 525, 325, "Grafik zuweisen", #PB_Window_Invisible|#PB_Window_SizeGadget|#PB_Window_SystemMenu, WindowID(#Win_Main))
  ComboBoxGadget(#G_CB_OpenImg_Folder, 5, 5, 350, 20)
  ExplorerListGadget(#G_EL_OpenImg_File, 5, 30, 350, 290, "", #PB_Explorer_NoDirectoryChange|#PB_Explorer_NoParentFolder|#PB_Explorer_NoFolders|#PB_Explorer_AlwaysShowSelection)
  SetGadgetAttribute(#G_EL_OpenImg_File, #PB_Explorer_DisplayMode, #PB_Explorer_SmallIcon)
  Frame3DGadget(#G_FR_OpenImg_Preview, 365, 10, 150, 265, "Vorschau")
  ImageGadget(#G_IG_OpenImg_Preview, 375, 35, 128, 192, 0)
  CheckBoxGadget(#G_CB_OpenImg_Zoomed, 375, 230, 130, 13, "vergrößert")
  TextGadget(#G_TX_OpenImg_PreviewSize, 375, 255, 130, 15, "", #PB_Text_Center)
  ButtonGadget(#G_BN_OpenImg_OK, 442, 290, 72, 24, "Öffnen")
  ButtonGadget(#G_BN_OpenImg_Cancel, 366, 290, 72, 24, "Abbrechen")

  Global mWinW_OpenImg = Window_GetWidth(#Win_OpenImg)
  Global mWinH_OpenImg = Window_GetHeight(#Win_OpenImg)
  DisableWindow(#Win_OpenImg, #True)
Else
  MsgBox_Error("Fenster OpenImg konnte nicht erstellt werden."): End
EndIf
;}

;{ Prozeduren
Procedure WinCallback(hWnd, Msg, wParam, lParam)
  Protected Result.l = #PB_ProcessPureBasicEvents, *pMinMax.MINMAXINFO

  If hWnd = WindowID(#Win_OpenImg)
    If Msg = #WM_GETMINMAXINFO
      *pMinMax.MINMAXINFO       = lParam
      *pMinMax\ptMinTrackSize\x = mWinW_OpenImg
      *pMinMax\ptMinTrackSize\y = mWinH_OpenImg
      Result = 0
    EndIf
  EndIf

  If hWnd = WindowID(#Win_Main) Or hWnd = WindowID(#Win_New) Or hWnd = WindowID(#Win_OpenImg) Or hWnd = WindowID(#Win_Preview)
    If Msg = #WM_LBUTTONDOWN
      ReleaseCapture_()
      SendMessage_(hWnd, #WM_NCLBUTTONDOWN, #HTCAPTION, #Null)
    EndIf
  EndIf

  ProcedureReturn Result
EndProcedure

Procedure ResetEbenenList() ;Setzt auf standardebenen zurück
  ForEach Ebene()
    If IsImage(Ebene()\hImg) <> #False
      FreeImage(Ebene()\hImg)
    EndIf
    If Ebene()\Mem <> #False
      FreeMemory(Ebene()\Mem)
    EndIf
  Next

  ClearList(Ebene())
  ClearGadgetItems(#G_LV_Ebenen)

  AddElement(Ebene()) : Ebene()\Name = "Körper"
  AddElement(Ebene()) : Ebene()\Name = "Augen"
  AddElement(Ebene()) : Ebene()\Name = "Haare"
  AddElement(Ebene()) : Ebene()\Name = "Helm"
  AddElement(Ebene()) : Ebene()\Name = "Schuhe"
  AddElement(Ebene()) : Ebene()\Name = "Hose"
  AddElement(Ebene()) : Ebene()\Name = "Rüstung"
  AddElement(Ebene()) : Ebene()\Name = "Sonstiges"
EndProcedure

Procedure RefreshEbenenList() ;Liest die Ebenenliste erneut ein
  ClearGadgetItems(#G_LV_Ebenen)

  ForEach Ebene()
    AddGadgetItem(#G_LV_Ebenen, -1, Ebene()\Name)
  Next
EndProcedure

Procedure RefreshEbenenInfo() ;Erneuert die Informationen der aktuellen Ebene
  Protected Sel.l, Infotext.s

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    SelectElement(Ebene(), Sel)

    SetGadgetItemText(#G_LI_Info, 0, Ebene()\Name, 1)
    If IsImage(Ebene()\hImg) <> #False
      SetGadgetItemText(#G_LI_Info, 1, Str(ImageWidth(Ebene()\hImg)), 1)
      SetGadgetItemText(#G_LI_Info, 2, Str(ImageHeight(Ebene()\hImg)), 1)
      SetGadgetItemText(#G_LI_Info, 3, Str(Ebene()\Size), 1)
    Else
      SetGadgetItemText(#G_LI_Info, 1, "", 1)
      SetGadgetItemText(#G_LI_Info, 2, "", 1)
      SetGadgetItemText(#G_LI_Info, 3, "", 1)
    EndIf
    SetGadgetItemText(#G_LI_Info, 4, Str(Ebene()\OffSetX) + ", " + Str(Ebene()\OffSetY), 1)
    SetGadgetItemText(#G_LI_Info, 5, Str(ZoomF * 100 / 1) + "%", 1)
  Else ;Reset
    SetGadgetItemText(#G_LI_Info, 0, "", 1)
    SetGadgetItemText(#G_LI_Info, 1, "", 1)
    SetGadgetItemText(#G_LI_Info, 2, "", 1)
    SetGadgetItemText(#G_LI_Info, 3, "", 1)
    SetGadgetItemText(#G_LI_Info, 4, "", 1)
    SetGadgetItemText(#G_LI_Info, 5, "", 1)
  EndIf
EndProcedure

Procedure RefreshImage() ;Zeichnet das Characterimage neu
  If ListSize(Ebene()) > 0

    If IsImage(Img_CharSetDisp) = 0
      Img_CharSetDisp = CreateImage(#PB_Any, L_CharSetW, L_CharSetH)
    Else
      ResizeImage(Img_CharSetDisp, L_CharSetW, L_CharSetH)
    EndIf
    If IsImage(Img_CharSetDraw) = 0
      Img_CharSetDraw = CreateImage(#PB_Any, L_CharSetW, L_CharSetH)
    Else
      ResizeImage(Img_CharSetDraw, L_CharSetW, L_CharSetH)
    EndIf
    If IsImage(Img_CharSetDisp) = #False Or IsImage(Img_CharSetDraw) = #False
      MsgBox_Error("Fehler beim erstellen der Grafiken"): End
    EndIf

    If IsImage(Img_CharSetDraw) <> #False And IsImage(Img_CharSetDisp) <> #False
      If StartDrawing(ImageOutput(Img_CharSetDraw)) <> 0
        Box(0, 0, #CharSizeX, #CharSizeY, BackroundColor)
        ForEach Ebene()
          If IsImage(Ebene()\hImg) <> #False
            DrawAlphaImage(ImageID(Ebene()\hImg), Ebene()\OffSetX, Ebene()\OffSetY)
          EndIf
        Next
        StopDrawing()
      Else
        MsgBox_Error("Ungültiger Output DC"): End
      EndIf

      ResizeImage(Img_CharSetDisp, L_CharSetW, L_CharSetH)
      If StartDrawing(ImageOutput(Img_CharSetDisp)) <> 0
        Box(0, 0, Round(ZoomF * L_CharSetW, 1), Round(ZoomF * L_CharSetH, 1), BackroundColor)
        DrawImage(ImageID(Img_CharSetDraw), 0, 0)
        StopDrawing()
      Else
        MsgBox_Error("Ungültiger Output DC")
      EndIf
      ResizeImage(Img_CharSetDisp, Round(ZoomF * L_CharSetW, 1), Round(ZoomF * L_CharSetH, 1), #PB_Image_Raw)

      SetGadgetState(#G_IM_Image, ImageID(Img_CharSetDisp))
    Else
      MsgBox_Error("Fehler beim neuzeichnen der Grafik")
      End
    EndIf

  EndIf
EndProcedure

Procedure EbeneUp() ;Ebene nach oben verschieben
  Protected First.l = 0, Second.l = 0, Sel.l

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1 And ListSize(Ebene()) > 1 And Sel > 0
    SelectElement(Ebene(), Sel)
    First = @Ebene()
    SelectElement(Ebene(), Sel - 1)
    Second = @Ebene()
    SwapElements(Ebene(), First, Second)
    RefreshImage()
    RefreshEbenenList()
    SetGadgetState(#G_LV_Ebenen, Sel - 1)
    L_IsSaveFile = #False
  EndIf
EndProcedure

Procedure EbeneDown() ;Ebene nach unten verschieben
  Protected Sel.l, First.l = 0, Second.l = 0

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1 And ListSize(Ebene()) > 1 And Sel < ListSize(Ebene()) - 1
    SelectElement(Ebene(), Sel)
    First = @Ebene()
    SelectElement(Ebene(), Sel + 1)
    Second = @Ebene()
    SwapElements(Ebene(), First, Second)
    RefreshImage()
    RefreshEbenenList()
    SetGadgetState(#G_LV_Ebenen, Sel + 1)
    L_IsSaveFile = #False
  EndIf
EndProcedure

Procedure RemoveEbene() ;Ebene löschen
  Protected Sel.l

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    SelectElement(Ebene(), Sel)

    If MessageRequester("Ebene löschen", "Soll die Ebene " + Ebene()\Name + " wirklich gelöscht werden?", #MB_YESNO|#MB_ICONQUESTION) = #IDYES
      If IsImage(Ebene()\hImg) <> #False
        FreeImage(Ebene()\hImg)
      EndIf
      If Ebene()\Mem <> #False
        FreeMemory(Ebene()\Mem)
        Ebene()\Mem = 0
        Ebene()\Size = 0
      EndIf
      DeleteElement(Ebene())

      RefreshEbenenList()

      If ListSize(Ebene()) >= Sel + 1
        SetGadgetState(#G_LV_Ebenen, Sel)
      Else
        If ListSize(Ebene()) > 0
          SetGadgetState(#G_LV_Ebenen, Sel - 1)
        EndIf
      EndIf

      RefreshEbenenInfo()
      RefreshImage()

      L_IsSaveFile = #False
    EndIf

  EndIf
EndProcedure

Procedure AddEbene() ;Neue Ebene erstellen
  Protected Sel.l, Name.s

  Sel = GetGadgetState(#G_LV_Ebenen)

  If ListSize(Ebene()) < #maxEbenen
    Name = InputRequester("Neue Ebene", "Name: (max. " + Str(#maxENameChar) + " Zeichen)", "")
    If Name <> ""
      Name = Left(Name, #maxENameChar)
      If Sel = -1
        Sel = ListSize(Ebene()) - 1
        LastElement(Ebene())
      Else
        SelectElement(Ebene(), Sel)
      EndIf
      AddElement(Ebene())
      Ebene()\Name = Name

      RefreshEbenenList()
      SetGadgetState(#G_LV_Ebenen, Sel + 1)
      RefreshEbenenInfo()

      L_IsSaveFile = #False
    EndIf
  Else
    MessageRequester("Neue Ebene", "Die maximale anzahl von Ebenen beträgt " + Str(#maxEbenen), #MB_OK|#MB_ICONEXCLAMATION)
  EndIf
EndProcedure

Procedure RenameEbene() ;Ebene umbenennen
  Protected Sel.l, Name.s

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    SelectElement(Ebene(), Sel)

    Name = InputRequester("Ebene umbenennen", "Name: (max " + Str(#maxENameChar) + " Zeichen)", Ebene()\Name)
    If Name <> "" And Name <> Ebene()\Name
      Name = Left(Name, #maxENameChar)
      Ebene()\Name = Name

      RefreshEbenenList()
      SetGadgetState(#G_LV_Ebenen, Sel)
      RefreshEbenenInfo()

      L_IsSaveFile = #False
    EndIf
  EndIf
EndProcedure

Procedure CenterImage() ;ImageGadget im Fenster zentrieren
  If IsImage(Img_CharSetDisp) <> #False
    ResizeGadget(#G_IM_Image, (GadgetWidth(#G_CN_ImageBorder)/2)  - (Round(ZoomF * ImageWidth(Img_CharSetDraw), 1)/2), (GadgetHeight(#G_CN_ImageBorder)/2) - (Round(ZoomF * ImageHeight(Img_CharSetDraw), 1)/2), Round(ZoomF * ImageWidth(Img_CharSetDraw), 1), Round(ZoomF * ImageHeight(Img_CharSetDraw), 1))
  EndIf
EndProcedure

Procedure RefreshFileList() ;Aktualisiert die Dateiliste im Grafik zuordnen Fenster
  If GetGadgetState(#G_CB_OpenImg_Folder) <> -1
    If GetGadgetText(#G_EL_OpenImg_File) <> ExePath() + #ImageFolder + Str(L_CharSetW) + "-" + Str(L_CharSetH) + "\" + GetGadgetText(#G_CB_OpenImg_Folder) + "\"
      Debug "Refresh Filelist"
      SetGadgetText(#G_EL_OpenImg_File, ExePath() + #ImageFolder + Str(L_CharSetW) + "-" + Str(L_CharSetH) + "\" + GetGadgetItemText(#G_CB_OpenImg_Folder, GetGadgetState(#G_CB_OpenImg_Folder), 0) + "\*.png")
      SetGadgetState(#G_EL_OpenImg_File, -1)
      SetGadgetState(#G_IG_OpenImg_Preview, 0)
      SetGadgetText(#G_TX_OpenImg_PreviewSize, "Datei wählen")
      DisableGadget(#G_BN_OpenImg_OK, #True)
    EndIf
  EndIf
EndProcedure

Procedure OpenOpenImgWindow() ;Öffnet und initialisiert das Grafik zuordnen Fenster
  Protected Sel.l

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    Protected dirid.l

    ;Ordnerliste initialisieren
    ClearGadgetItems(#G_CB_OpenImg_Folder)
    If FileSize(ExePath() + #ImageFolder + Str(L_CharSetW) + "-" + Str(L_CharSetH) + "\") = -2
      dirid = ExamineDirectory(#PB_Any, ExePath() + #ImageFolder + Str(L_CharSetW) + "-" + Str(L_CharSetH) + "\", "")
      While NextDirectoryEntry(dirid) <> #False
        If DirectoryEntryType(dirid) = #PB_DirectoryEntry_Directory
          If DirectoryEntryName(dirid) <> "." And DirectoryEntryName(dirid) <> ".."
            AddGadgetItem(#G_CB_OpenImg_Folder, -1, DirectoryEntryName(dirid))
          EndIf
        EndIf
      Wend
      FinishDirectory(dirid)
    EndIf

    ;Standardordner auswählen
    If GetGadgetState(#G_LV_Ebenen) <> -1 And ListSize(Ebene()) >= GetGadgetState(#G_LV_Ebenen) And CountGadgetItems(#G_CB_OpenImg_Folder) > 0
      SelectElement(Ebene(), GetGadgetState(#G_LV_Ebenen))
      Define x.l
      For x = 0 To CountGadgetItems(#G_CB_OpenImg_Folder)
        If Ebene()\Name = GetGadgetItemText(#G_CB_OpenImg_Folder, x, 0)
          Debug "Select dafault Folder"
          SetGadgetState(#G_CB_OpenImg_Folder, x)
        EndIf
      Next
      If GetGadgetState(#G_CB_OpenImg_Folder) = -1
        SetGadgetState(#G_CB_OpenImg_Folder, 0)
      EndIf
    EndIf

    SetGadgetText(#G_EL_OpenImg_File, "")
    RefreshFileList()
    SetGadgetState(#G_IG_OpenImg_Preview, 0)
    SetGadgetText(#G_TX_OpenImg_PreviewSize, "Datei wählen")
    DisableGadget(#G_BN_OpenImg_OK, #True)
    DisableWindow(#Win_Main, #True)
    CenterWinOnMainWin(#Win_Main, #Win_OpenImg)
    HideWindow(#Win_OpenImg, #False)
    DisableWindow(#Win_OpenImg, #False)
  EndIf
EndProcedure

Procedure RefreshPreview() ;Aktualisiert das Vorschau bei Grafik zuordnen Dialog
  Protected fileid.l
  Protected filepath.s
  Protected tmp_img.l

  If GetGadgetState(#G_EL_OpenImg_File) <> -1
    filepath = ExePath() + #ImageFolder + Str(L_CharSetW) + "-" + Str(L_CharSetH) + "\" + GetGadgetItemText(#G_CB_OpenImg_Folder, GetGadgetState(#G_CB_OpenImg_Folder), 0) + "\" + GetGadgetItemText(#G_EL_OpenImg_File, GetGadgetState(#G_EL_OpenImg_File), 0)

    fileid   = ReadFile(#PB_Any, filepath)
    If fileid <> #False

      ;Test auf PNG
      If ReadQuad(fileid) <> 727905341920923785
        SetGadgetState(#G_IG_OpenImg_Preview, 0)
        SetGadgetText(#G_TX_OpenImg_PreviewSize, "Ungültige Datei")
        DisableGadget(#G_BN_OpenImg_OK, #True)
        CloseFile(fileid)
        ProcedureReturn #False
      EndIf
      CloseFile(fileid)

      ;Alte Images entfernen
      If IsImage(Img_Preview) <> #False : FreeImage(Img_Preview) : EndIf
      If IsImage(tmp_img) <> #False: FreeImage(tmp_img) : EndIf

      ;Imagevorschau
      tmp_img = LoadImage(#PB_Any, filepath)
      If tmp_img = #False
        SetGadgetState(#G_IG_OpenImg_Preview, 0)
        SetGadgetText(#G_TX_OpenImg_PreviewSize, "Ungültige Datei")
        DisableGadget(#G_BN_OpenImg_OK, #True)
        ProcedureReturn #False
      Else

        If GetGadgetState(#G_CB_OpenImg_Zoomed) = #False
          Img_Preview = CreateImage(#PB_Any, #CharSizeX, #CharSizeY)
        Else
          Img_Preview = GrabImage(tmp_img, #PB_Any, 0, 0, #CharSizeX/4, #CharSizeY/4)
        EndIf

        StartDrawing(ImageOutput(Img_Preview))
        Box(0, 0, #CharSizeX, #CharSizeY, GetSysColor_(#COLOR_BTNFACE))
        DrawAlphaImage(ImageID(tmp_img), 0, 0)
        StopDrawing()

        If GetGadgetState(#G_CB_OpenImg_Zoomed) = #True
          ResizeImage(Img_Preview, #CharSizeX, #CharSizeY)
        EndIf

        FreeImage(tmp_img)

        SetGadgetState(#G_IG_OpenImg_Preview, ImageID(Img_Preview))

        SetGadgetText(#G_TX_OpenImg_PreviewSize, GetFilePart(filepath))
        DisableGadget(#G_BN_OpenImg_OK, #False)
        ProcedureReturn #True
      EndIf
    Else
      SetGadgetState(#G_IG_OpenImg_Preview, 0)
      SetGadgetText(#G_TX_OpenImg_PreviewSize, "Ungültige Datei")
      DisableGadget(#G_BN_OpenImg_OK, #True)
      ProcedureReturn #False
    EndIf
  Else
    SetGadgetState(#G_IG_OpenImg_Preview, 0)
    SetGadgetText(#G_TX_OpenImg_PreviewSize, "Datei wählen")
    DisableGadget(#G_BN_OpenImg_OK, #True)
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure CloseOpenImgWindow() ;Schliess das Grafik zuordnen Fenster
  If IsImage(Img_Preview) <> #False
    FreeImage(Img_Preview)
  EndIf

  DisableWindow(#Win_Main, #False)
  HideWindow(#Win_OpenImg, #True)
  DisableWindow(#Win_OpenImg, #True)
EndProcedure

Procedure SetImg() ;Der Ebene eine Grafik zuweisen
  Protected Sel.l
  Protected filepath.s
  Protected fileid.l

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    SelectElement(Ebene(), Sel)

    filepath = ExePath() + #ImageFolder + Str(L_CharSetW) + "-" + Str(L_CharSetH) + "\" + GetGadgetItemText(#G_CB_OpenImg_Folder, GetGadgetState(#G_CB_OpenImg_Folder), 0) + "\" + GetGadgetItemText(#G_EL_OpenImg_File, GetGadgetState(#G_EL_OpenImg_File), 0)
    If filepath <> "" And FileSize(filepath) > 0

      ;Auf PNG-Format testen und im Speicher laden
      fileid = ReadFile(#PB_Any, filepath)
      If fileid <> #False
        If ReadQuad(fileid) <> 727905341920923785
          MsgBox_Error("Ungültiges Grafikformat" + #CR$ + "Die Grafik muß eine 32 Bit PNG sein.")
          CloseFile(fileid)
          ProcedureReturn #False
        Else
          FileSeek(fileid, 0)
          Ebene()\Size = FileSize(filepath)
          Ebene()\Mem  = AllocateMemory(Ebene()\Size)
          If Ebene()\Mem <> #False
            ReadData(fileid, Ebene()\Mem, Ebene()\Size)
          Else
            MsgBox_Error("Speicher konnte nicht reserviert werden.")
            CloseFile(fileid)
            ProcedureReturn #False
          EndIf
          CloseFile(fileid)
        EndIf
      Else
        MsgBox_Error("Datei konnte nicht geöffnet werden." + #CR$ + "'" + filepath + "'")
        ProcedureReturn #False
      EndIf

      ;Image aus Speicher laden
      fileid = CatchImage(#PB_Any, Ebene()\Mem)
      If fileid <> #False
        If ImageDepth(fileid) = 32
          Ebene()\hImg = fileid
          RefreshImage()
          RefreshEbenenInfo()
          L_IsSaveFile = #False
        Else
          FreeImage(fileid)
          If Ebene()\Mem <> #False And Ebene()\Size <> 0
            FreeMemory(Ebene()\Mem)
          EndIf
          MsgBox_Error("Ungültiges Grafikformat" + #CR$ + "Die Grafik muß eine 32 Bit PNG sein.")
          ProcedureReturn #False
        EndIf
      Else
        If Ebene()\Mem <> #False And Ebene()\Size <> 0
          FreeMemory(Ebene()\Mem)
        EndIf
        MsgBox_Error("Die Grafik konnte nicht geladen werden." + #CR$ + "'" + filepath + "'")
        ProcedureReturn #False
      EndIf

      DisableWindow(#Win_Main, #False)
      HideWindow(#Win_OpenImg, #True)
      DisableWindow(#Win_OpenImg, #True)

    EndIf ;filepath
  EndIf ;Sel
EndProcedure

Procedure RemImg() ;Ebenengrafik entfernen
  Protected Sel.l

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    SelectElement(Ebene(), Sel)

    ;Image entfernen
    If IsImage(Ebene()\hImg) <> #False
      FreeImage(Ebene()\hImg)
      Ebene()\hImg = 0
    EndIf
    ;Speicher leeren
    If Ebene()\Mem <> #False
      FreeMemory(Ebene()\Mem)
      Ebene()\Mem  = 0
      Ebene()\Size = 0
    EndIf

    RefreshImage()
    RefreshEbenenInfo()

    L_IsSaveFile = #False
  EndIf
EndProcedure

Procedure ResetOffSet() ;OffSet zurücksetzen
  Protected Sel.l

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    SelectElement(Ebene(), Sel)
    If Ebene()\hImg <> 0
      Ebene()\OffSetX = 0
      Ebene()\OffSetY = 0
    EndIf
    RefreshImage()
    RefreshEbenenInfo()

    L_IsSaveFile = #False
  EndIf
EndProcedure

Procedure OffSetX_Right() ;OffSet nach rechts
  Protected Sel.l

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    SelectElement(Ebene(), Sel)
    If Ebene()\hImg <> 0
      Ebene()\OffSetX + 1
    EndIf
    RefreshImage()
    RefreshEbenenInfo()

    L_IsSaveFile = #False
  EndIf
EndProcedure

Procedure OffSetX_Left() ;OffSet nach links
  Protected Sel.l

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    SelectElement(Ebene(), Sel)
    If Ebene()\hImg <> 0
      Ebene()\OffSetX - 1
    EndIf
    RefreshImage()
    RefreshEbenenInfo()

    L_IsSaveFile = #False
  EndIf
EndProcedure

Procedure OffSet_Up() ;OffSet nach oben
  Protected Sel.l

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    SelectElement(Ebene(), Sel)
    If Ebene()\hImg <> 0
      Ebene()\OffSetY - 1
    EndIf
    RefreshImage()
    RefreshEbenenInfo()

    L_IsSaveFile = #False
  EndIf
EndProcedure

Procedure OffSet_Down() ;OffSet nach unten
  Protected Sel.l

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    SelectElement(Ebene(), Sel)
    If Ebene()\hImg <> 0
      Ebene()\OffSetY + 1
    EndIf
    RefreshImage()
    RefreshEbenenInfo()

    L_IsSaveFile = #False
  EndIf
EndProcedure

Procedure RefreshWindowTitle()
  If S_OpenFilePath <> ""
    SetWindowTitle(#Win_Main, #PrgName + " - " + GetFilePart(S_OpenFilePath))
  Else
    SetWindowTitle(#Win_Main, #PrgName)
  EndIf
EndProcedure

Declare New()
Declare Open(filepath.s = "")
Declare Save()
Declare Close()

Procedure New() ;Neuen Character
  Protected New.l

  If S_OpenFilePath <> "" And L_IsSaveFile = #False
    Select MessageRequester(#PrgName, "Änderungen in " + GetFilePart(S_OpenFilePath) + " speichern?", #MB_YESNOCANCEL|#MB_ICONEXCLAMATION)
      Case #IDYES : Save()
      Case #IDNO : New = #True
      Case #IDABORT : New = #False
    EndSelect
  Else
    New = #True
  EndIf

  If New = #True
    DisableWindow(#Win_Main, #True)
    CenterWinOnMainWin(#Win_Main, #Win_New)

    SetGadgetState(#G_CB_New_Format, 0)
    SelectElement(Format(), 0)
    SetGadgetText(#G_SR_New_Width, Str(Format()\Width))
    SetGadgetText(#G_SR_New_Height, Str(Format()\Height))

    HideWindow(#Win_New, #False)
    DisableWindow(#Win_New, #False)
  EndIf
EndProcedure

Procedure New_Create()
  Debug "New.."

  ResetEbenenList()
  RefreshEbenenList()
  SetGadgetState(#G_LV_Ebenen, 0)

  SelectElement(Format(), GetGadgetState(#G_CB_New_Format))
  L_CharSetF      = GetGadgetState(#G_CB_New_Format)
  L_CharSetW      = Format()\Width
  L_CharSetH      = Format()\Height
  BackroundColor  = #DefaultBGClr
  ZoomF           = 1

  If IsImage(Img_CharSetDisp) = 0
    Img_CharSetDisp = CreateImage(#PB_Any, L_CharSetW, L_CharSetH)
  Else
    ResizeImage(Img_CharSetDisp, L_CharSetW, L_CharSetH)
  EndIf
  If IsImage(Img_CharSetDraw) = 0
    Img_CharSetDraw = CreateImage(#PB_Any, L_CharSetW, L_CharSetH)
  Else
    ResizeImage(Img_CharSetDraw, L_CharSetW, L_CharSetH)
  EndIf
  If IsImage(Img_CharSetDisp) = #False Or IsImage(Img_CharSetDraw) = #False
    MsgBox_Error("Fehler beim erstellen der Grafiken"): End
  EndIf
  RefreshImage()
  CenterImage()

  RefreshEbenenInfo()

  L_IsSaveFile    = #False
  S_OpenFilePath  = ExePath() + #CharFolder + "Unbenannt"
  RefreshWindowTitle()

  HideWindow(#Win_New, #True)
  DisableWindow(#Win_New, #True)
  DisableWindow(#Win_Main, #False)
EndProcedure

Procedure CloseNewWindow()
  HideWindow(#Win_New, #True)
  DisableWindow(#Win_New, #True)
  DisableWindow(#Win_Main, #False)
EndProcedure

Procedure Open(filepath.s = "") ;Character öffnen
  Protected Open.l, fileid.l, amount.b, OldSel.b, TestString.s

  If S_OpenFilePath <> "" And L_IsSaveFile = #False
    Select MessageRequester(#PrgName, "Änderungen in " + GetFilePart(S_OpenFilePath) + " speichern?", #MB_YESNOCANCEL|#MB_ICONEXCLAMATION)
      Case #IDYES : Save()
      Case #IDNO : Open = #True
      Case #IDABORT : Open = #False
    EndSelect
  Else
    Open = #True
  EndIf

  If Open = #True
    If filepath = ""
      ;Standardpath ermiteln
      If FileSize(ExePath() + #CharFolder) = -2
        filepath = ExePath() + #CharFolder
      Else
        filepath = ExePath()
      EndIf

      filepath = OpenFileRequester("Öffnen", filepath, "Speicherdatei|*.chs|Alle Dateien|*.*", 0)
    EndIf

    If filepath <> ""
      fileid = ReadFile(#PB_Any, filepath)
      If fileid <> #False
        TestString = ReadFixedString(fileid, Len(#FileTestString))

        If TestString = #FileTestString Or TestString = #FileTestStringN
          ;Alte Grafiken freigeben
          ForEach Ebene()
            If IsImage(Ebene()\hImg) <> #False
              FreeImage(Ebene()\hImg)
            EndIf
            If Ebene()\Mem <> #False
              FreeMemory(Ebene()\Mem)
            EndIf
          Next
          ClearList(Ebene())

          ;Einlesen
          If TestString = #FileTestStringN
            Debug "Neues Format CE_4"
            L_CharSetF = ReadByte(fileid)
            SelectElement(Format(), L_CharSetF)
            L_CharSetW = Format()\Width
            L_CharSetH = Format()\Height
          Else
            Debug "Altes Format CE_3"
            L_CharSetF = 2
            L_CharSetW = 128
            L_CharSetH = 192
          EndIf

          amount.b = ReadByte(fileid)
          Debug "############################################################"
          Debug "Amount: " + Str(amount)

          Define x.b
          For x = 1 To amount
            AddElement(Ebene())

            Ebene()\Name      = ReadFixedString(fileid, ReadByte(fileid))
            Ebene()\Size      = ReadLong(fileid)

            Debug "----------------------------------------------------------"
            Debug "Name: " + Ebene()\Name
            Debug "Size: " + Str(Ebene()\Size)

            If Ebene()\Size <> 0
              Ebene()\Mem = AllocateMemory(Ebene()\Size)
              If Ebene()\Mem = #False
                MsgBox_Error("Speicherbereich konnte nicht reserviert werden.")
                ForEach Ebene()
                  If IsImage(Ebene()\hImg) <> #False
                    FreeImage(Ebene()\hImg)
                  EndIf
                  If Ebene()\Mem <> #False
                    FreeMemory(Ebene()\Mem)
                  EndIf
                Next
                ClearList(Ebene())
                CloseFile(fileid)
                ProcedureReturn #False
              Else
                Debug "Mem: " + Str(Ebene()\Mem)
                Debug "Read Data.."
                ReadData(fileid, Ebene()\Mem, Ebene()\Size)
              EndIf
            EndIf

            If Ebene()\Mem <> #False And Ebene()\Size <> 0
              Ebene()\hImg = CatchImage(#PB_Any, Ebene()\Mem)
            EndIf

            Ebene()\OffSetX = ReadLong(fileid)
            Ebene()\OffSetY = ReadLong(fileid)

            Debug "hImg: " + Str(Ebene()\hImg)
            Debug "OffSetX: " + Str(Ebene()\OffSetX)
            Debug "OffSetY: " + Str(Ebene()\OffSetY)
          Next

          BackroundColor = ReadLong(fileid)
          ZoomF          = ReadFloat(fileid)
          OldSel         = ReadByte(fileid)

          RefreshEbenenList()

          If OldSel >= 0 And OldSel <= ListSize(Ebene())
            SetGadgetState(#G_LV_Ebenen, OldSel)
          Else
            SetGadgetState(#G_LV_Ebenen, 0)
          EndIf

          RefreshImage()
          CenterImage()
          RefreshEbenenInfo()

          CloseFile(fileid)

          S_OpenFilePath = filepath
          L_IsSaveFile   = #True
          SetWindowTitle(#Win_Main, #PrgName + " - " + GetFilePart(filepath))

          MessageBeep_(#MB_ICONINFORMATION)
        Else
          MsgBox_Error("Ungültiges Dateiformat." + #CR$ + "'" + filepath + "'")
          CloseFile(fileid)
        EndIf
      Else
        MsgBox_Error("Datei konnte nicht geöffnet werden." + #CR$ + "'" + filepath + "'")
      EndIf ;fileid
    EndIf ;filepath

  EndIf
EndProcedure

Procedure Save() ;Speichern von Character oder Grafik
  Protected fileid.l, filepath.s, selPattern.l, imgFormat.l, true.l

  ;Inhaltetest
  ForEach Ebene()
    If IsImage(Ebene()\hImg) <> #False
      true = #True
    EndIf
  Next

  If ListSize(Ebene()) > 0 And true = #True

    If true = #True
      ;Standardordner
      If FileSize(ExePath() + #CharFolder) = -2
        filepath = ExePath() + #CharFolder
      Else
        filepath = ExePath()
      EndIf

      filepath = SaveFileRequester("Speichern", filepath, "Speicherdatei|*.chs|Bitmap Image|*.bmp|Portable Network Graphics Image|*.png", 0)
      If filepath <> ""
        selPattern = SelectedFilePattern()

        ;Erweiterung hinzufügen
        If GetExtensionPart(filepath) = ""
          Select selPattern
            Case 0: filepath + ".chs"
            Case 1: filepath + ".bmp"
            Case 2: filepath + ".png"
          EndSelect
        EndIf

        ;Speichern
        Select selPattern

          Case 0 ;Speicherdatei
            fileid = CreateFile(#PB_Any, filepath)
            If fileid <> #False
              WriteString(fileid, #FileTestStringN)
              Debug "write teststring"
              WriteByte(fileid, L_CharSetF)
              Debug "write format"
              WriteByte(fileid, ListSize(Ebene()))
              Debug "write amount"

              ForEach Ebene()
                WriteByte(fileid, Len(Ebene()\Name))
                Debug "write len name"
                WriteString(fileid, Ebene()\Name)
                Debug "write name"

                If Ebene()\Size = 0 Or Ebene()\Mem = 0
                  WriteLong(fileid, 0)
                  Debug "write memsize 0"
                Else
                  WriteLong(fileid, Ebene()\Size)
                  Debug "write memsize " + Str(Ebene()\Size)
                  WriteData(fileid, Ebene()\Mem, Ebene()\Size)
                  Debug "write data"
                EndIf

                WriteLong(fileid, Ebene()\OffSetX)
                Debug "write OffSetX"
                WriteLong(fileid, Ebene()\OffSetY)
                Debug "write OffSetY"
              Next

              WriteLong(fileid, BackroundColor)
              Debug "write BackroundColor"
              WriteFloat(fileid, ZoomF)
              Debug "write Zoom"
              WriteByte(fileid, GetGadgetState(#G_LV_Ebenen))
              Debug "write sel"

              CloseFile(fileid)

              L_IsSaveFile   = #True
              S_OpenFilePath = filepath
              SetWindowTitle(#Win_Main, #PrgName + " - " + GetFilePart(S_OpenFilePath))

              MessageBeep_(#MB_ICONINFORMATION)
            Else
              MsgBox_Error("Datei konnte nicht gespeichert werden." + #CR$ + "'" + filepath + "'")
            EndIf

          Case 1 To 2 ;Image
            If IsImage(Img_CharSetDraw) <> #False
              Select selPattern
                Case 1: imgFormat = #PB_ImagePlugin_BMP
                Case 2: imgFormat = #PB_ImagePlugin_PNG
              EndSelect
              If SaveImage(Img_CharSetDraw, filepath, imgFormat) = #False
                MsgBox_Error("Die Grafik konnte nicht gespeichert werden.")
              Else
                MessageBeep_(#MB_ICONINFORMATION)
              EndIf
            EndIf

        EndSelect ;Speichern
      EndIf ;FilePath
    EndIf ;trueSave
  EndIf ;CountList
EndProcedure

Procedure Close() ;Character schliessen
  Protected Close.l

  If S_OpenFilePath <> "" And L_IsSaveFile = #False
    Select MessageRequester(#PrgName, "Änderungen in " + GetFilePart(S_OpenFilePath) + " speichern?", #MB_YESNOCANCEL|#MB_ICONEXCLAMATION)
      Case #IDYES : Save()
      Case #IDNO : Close = #True
      Case #IDABORT : Close = #False
    EndSelect
  Else
    Close = #True
  EndIf

  If Close = #True And ListSize(Ebene()) > 0
    Debug "Close.."

    ForEach Ebene()
      ;Image entfernen
      If IsImage(Ebene()\hImg) <> #False
        FreeImage(Ebene()\hImg)
        Ebene()\hImg = 0
      EndIf
      ;Speicher leeren
      If Ebene()\Mem <> #False
        FreeMemory(Ebene()\Mem)
        Ebene()\Mem  = 0
        Ebene()\Size = 0
      EndIf
    Next

    ClearList(Ebene())
    ClearGadgetItems(#G_LV_Ebenen)
    RefreshEbenenInfo()
    SetGadgetState(#G_IM_Image, 0)

    S_OpenFilePath = ""
    L_IsSaveFile   = #False
    RefreshWindowTitle()
  EndIf
EndProcedure

Procedure Copy() ;Grafik in Zwischenablage kopieren
  Protected trueCopy.l

  If ListSize(Ebene()) > 0 And IsImage(Img_CharSetDraw) <> #False
    ;Test ob überhaupt Images existieren
    ForEach Ebene()
      If IsImage(Ebene()\hImg) <> #False
        trueCopy = #True
      EndIf
    Next
    ;Kopieren
    If trueCopy = #True
      SetClipboardImage(Img_CharSetDraw)
      MessageBeep_(#MB_ICONINFORMATION)
    EndIf
  EndIf
EndProcedure

Procedure BackroundColor() ;Hintergrundfarbe setzen
  Protected Sel.l

  Sel = GetGadgetState(#G_LV_Ebenen)
  If Sel <> -1 And ListSize(Ebene()) >= Sel + 1
    Protected Clr.l

    Clr = ColorRequester(BackroundColor)
    If Clr <> -1 And BackroundColor <> Clr
      BackroundColor = Clr
      RefreshImage()

      L_IsSaveFile = #False
    EndIf
  EndIf
EndProcedure

Procedure ResetZoom() ;Zoom zurücksetzen
  If ListSize(Ebene()) > 0
    ZoomF = 1

    RefreshImage()
    CenterImage()
    RefreshEbenenInfo()
  EndIf
EndProcedure

Procedure ZoomIn() ;Vergrößern
  If ListSize(Ebene()) > 0
    If ZoomF < 2
      ZoomF + 0.1
    EndIf

    RefreshImage()
    CenterImage()
    RefreshEbenenInfo()
  EndIf
EndProcedure

Procedure ZoomOut() ;Verkleinern
  If ListSize(Ebene()) > 0
    If ZoomF > 1
      ZoomF - 0.1
    EndIf

    RefreshImage()
    CenterImage()
    RefreshEbenenInfo()
  EndIf
EndProcedure

Procedure LoadPreferences() ;Einstellungen laden
  Protected Pre_fileid.l
  Protected Pre_useDefault.l
  Protected Pre_WinPosX.l
  Protected Pre_WinPosY.l
  Protected Pre_ZoomedPref.l

  Pre_fileid = ReadFile(#PB_Any, ExePath() + "CharEdit.cfg")
  If Pre_fileid <> #False
    If ReadLong(Pre_fileid) = #PrgVers
      Pre_WinPosX    = ReadWord(Pre_fileid)
      Pre_WinPosY    = ReadWord(Pre_fileid)
      Pre_ZoomedPref = ReadByte(Pre_fileid)
      BackroundColor = ReadLong(Pre_fileid)
      ZoomF          = ReadFloat(Pre_fileid)
      Pre_useDefault = #False
      CloseFile(Pre_fileid)
    Else
      MessageRequester("Neue Version", "Die Einstellungen sind von einer älteren Version und müssen deshalb erneut gestzt werden.", #MB_OK|#MB_ICONEXCLAMATION)
      Pre_useDefault = #True
      CloseFile(Pre_fileid)
    EndIf
  Else
    Pre_useDefault = #True
  EndIf

  If Pre_useDefault = #True
    Pre_WinPosX     = Window_GetDesktopPosition(#Win_Main, 1)
    Pre_WinPosY     = Window_GetDesktopPosition(#Win_Main, 2)
    Pre_ZoomedPref  = #False
    BackroundColor  = #DefaultBGClr
    ZoomF           = 2
  EndIf

  ResizeWindow(#Win_Main, Pre_WinPosX, Pre_WinPosY, #PB_Ignore, #PB_Ignore)
  SetGadgetState(#G_CB_OpenImg_Zoomed, Pre_ZoomedPref)
EndProcedure

Procedure SavePreferences() ;Einstellungen speichern
  Protected Pre_fileid.l

  Pre_fileid = CreateFile(#PB_Any, ExePath() + "CharEdit.cfg")
  If Pre_fileid <> #False
    WriteLong(Pre_fileid, #PrgVers)
    WriteWord(Pre_fileid, WindowX(#Win_Main))
    WriteWord(Pre_fileid, WindowY(#Win_Main))
    WriteByte(Pre_fileid, GetGadgetState(#G_CB_OpenImg_Zoomed))
    WriteLong(Pre_fileid, BackroundColor)
    WriteFloat(Pre_fileid, ZoomF)
    CloseFile(Pre_fileid)
  Else
    MsgBox_Error("Die Einstellungen konnten nicht gespeichert werden." + #CR$ + "'" + ExePath() + "CharEdit.cfg")
  EndIf
EndProcedure

Procedure Preview() ;Vorschauthread
  Repeat
    SelectElement(Format(), L_CharSetF)

    If GetGadgetState(#G_OP_Preview_1) = #True
      Debug "DIR1"
      If frame < Format()\FramesW - 1 And frame >= 0
        frame + 1
      Else
        frame = 0
      EndIf
    EndIf

    If GetGadgetState(#G_OP_Preview_2) = #True
      Debug "DIR2"
      If frame < (Format()\FramesW * 2) - 1 And frame >= Format()\FramesW
        frame + 1
      Else
        frame = Format()\FramesW
      EndIf
    EndIf

    If GetGadgetState(#G_OP_Preview_3) = #True
      Debug "DIR3"
      If frame < (Format()\FramesW * 3) - 1 And frame >= (Format()\FramesW * 2) - 1
        frame + 1
      Else
        frame = Format()\FramesW * 2
      EndIf
    EndIf

    If GetGadgetState(#G_OP_Preview_4) = #True
      Debug "DIR4"
      If frame < (Format()\FramesW * 4) - 1 And frame >= (Format()\FramesW * 3) - 1
        frame + 1
      Else
        frame = Format()\FramesW * 3
      EndIf
    EndIf

    Debug frame
    SetGadgetState(#G_IG_Preview_Image, ImageID(Anim(frame)))
    Delay(150)
  ForEver
EndProcedure

Procedure StartPreview() ;Initialisierung und Start der Vorschau
  Protected TruePref.l, tmp_img.l, x.l, y.l, count.l, frameW.l, frameH.l

  If ListSize(Ebene()) > 0
    ;Test ob überhaupt Images existieren
    ForEach Ebene()
      If IsImage(Ebene()\hImg) <> #False
        TruePref = #True
      EndIf
    Next
    ;StartPreview..
    If TruePref <> #False

      tmp_img = CreateImage(#PB_Any, L_CharSetW, L_CharSetH)
      If tmp_img <> #False
        StartDrawing(ImageOutput(tmp_img))
        Box(0, 0, L_CharSetW, L_CharSetH, GetSysColor_(#COLOR_BTNFACE))
        ForEach Ebene()
          If IsImage(Ebene()\hImg) <> #False
            DrawAlphaImage(ImageID(Ebene()\hImg), Ebene()\OffSetX, Ebene()\OffSetY)
          EndIf
        Next
        StopDrawing()
      Else
        MsgBox_Error("Temporäres Vorschaubild konnte nicht erstellt werden.")
        ProcedureReturn #False
      EndIf

      If IsImage(tmp_img) <> #False
        SelectElement(Format(), L_CharSetF)
        ReDim Anim((Format()\FramesW * Format()\FramesH) - 1)

        frameW = L_CharSetW / Format()\FramesW
        frameH = L_CharSetH / Format()\FramesH
        count = -1

        For y = 0 To Format()\FramesH - 1
          For x = 0 To Format()\FramesW - 1
            count + 1
            Anim(count) = GrabImage(tmp_img, #PB_Any, x * frameW, y * frameH, frameW, frameH)
          Next
        Next

        If IsImage(tmp_img) <> #False
          FreeImage(tmp_img)
        EndIf
        threadAnim = CreateThread(@Preview(), 0)

        SetGadgetState(#G_OP_Preview_1, #True)
        SetGadgetState(#G_OP_Preview_2, #False)
        SetGadgetState(#G_OP_Preview_3, #False)
        SetGadgetState(#G_OP_Preview_4, #False)
        DisableWindow(#Win_Main, #True)
        ResizeWindow(#Win_Preview, WindowX(#Win_Main) + GadgetX(#G_CN_ImageBorder) + 10 + Window_GetBorderWidth(#Win_Preview)/2, WindowY(#Win_Main) + GadgetY(#G_CN_ImageBorder) + 10 + (Window_GetBorderHight(#Win_Preview) - Window_GetBorderWidth(#Win_Preview)/2), #PB_Ignore, #PB_Ignore)
        HideWindow(#Win_Preview, #False)
        DisableWindow(#Win_Preview, #False)
      Else
        MsgBox_Error("Fehler beim erstellen der Vorschaubilder.")
      EndIf
    EndIf

  EndIf
EndProcedure

Procedure StopPreview() ;Vorschau beenden
  Protected x.l

  KillThread(threadAnim)

  SelectElement(Format(), L_CharSetF)

  For x = 0 To (Format()\FramesW * Format()\FramesH) - 1
    If IsImage(Anim(x)) <> #False
      FreeImage(Anim(x))
    EndIf
  Next

  DisableWindow(#Win_Main, #False)
  HideWindow(#Win_Preview, #True)
  DisableWindow(#Win_Preview, #True)
EndProcedure

Procedure Update()
  Protected hFile.l, sTempFile.s, lNewVers.l, lResult.l

  sTempFile = GetTemporaryDirectory() + "~" + Str(Date()) + "-ce-" + Str(Random(1000)) + ".tmp"
  If ReceiveHTTPFile(#URL_Update, sTempFile) <> 0
    If OpenPreferences(sTempFile) <> 0
      PreferenceGroup("version")
      lNewVers = ReadPreferenceLong("charedit", -1)
      If lNewVers = -1 Or lNewVers = 0
        lResult = 0
      Else
        If lNewVers > #PrgVers
          If MessageRequester("Update", "Eine neue Version ist verfügbar, Updateseite öffnen?", #MB_YESNO|#MB_ICONQUESTION) = #IDYES
            RunProgram(#URL_Homepage)
          EndIf
        Else
          MessageRequester("Update", "Sie haben bereits die neuste Version!", #MB_OK|#MB_ICONINFORMATION)
        EndIf
        lResult = 1
      EndIf

      ClosePreferences()
      DeleteFile(sTempFile)
    Else
      lResult = 0
    EndIf
  Else
    lResult = 0
  EndIf

  ProcedureReturn lResult
EndProcedure

Procedure Beenden() ;Programm beenden
  SavePreferences()
  End
EndProcedure
;}

;{ Programmschleife
LoadPreferences()
RefreshEbenenInfo()

AddKeyboardShortcut(#Win_Main, #PB_Shortcut_Control|#PB_Shortcut_N, #Mnu_New)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_Control|#PB_Shortcut_O, #Mnu_Open)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_Control|#PB_Shortcut_S, #Mnu_Save)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_Control|#PB_Shortcut_C, #Mnu_Close)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_C, #Mnu_Copy)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_E, #Mnu_AddEbene)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_F, #Mnu_DelEbene)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_U, #Mnu_EbeneUp)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_D, #Mnu_EbeneDown)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_X, #Mnu_ResetOffSet)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_Alt|#PB_Shortcut_Left, #Mnu_OffSetLeft)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_Alt|#PB_Shortcut_Up, #Mnu_OffSetUp)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_Alt|#PB_Shortcut_Down, #Mnu_OffSetDown)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_Alt|#PB_Shortcut_Right, #Mnu_OffSetRight)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_G, #Mnu_RefreshImg)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_I, #Mnu_SetImg)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_R, #Mnu_RemImg)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_B, #Mnu_Backround)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_N, #Mnu_ResetZoom)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_Add, #Mnu_ZoomIn)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_Subtract, #Mnu_ZoomOut)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_P, #Mnu_Preview)
AddKeyboardShortcut(#Win_Main, #PB_Shortcut_Control|#PB_Shortcut_R, #Mnu_RenameEbene)

SetWindowCallback(@WinCallback())

HideWindow(#Win_Main, #False)

If InitNetwork() = 0
  ToolBarToolTip(#ToolBar_Main, #Mnu_Update, "Fehler beim initialisieren der Updatefunktion")
  DisableToolBarButton(#ToolBar_Main, #Mnu_Update, 1)
EndIf

;Verknüpfte Datei automatisch öffnen
If FileSize(ProgramParameter(0)) > 0
  Open(ProgramParameter(0))
Else
  SetWindowTitle(#Win_Main, #PrgName + " - " + "Unbenannt")
EndIf

Repeat
  WindowEvent = WindowEvent()
  EventWindow = EventWindow()
  EventGadget = EventGadget()
  EventMenu   = EventMenu()
  EventType   = EventType()

  Select WindowEvent
    ;Event_Menu
    Case #PB_Event_Menu
      Select EventWindow
        Case #Win_Main
          Select EventMenu
            Case #Mnu_New
              New()
            Case #Mnu_Open
              Open()
            Case #Mnu_Save
              Save()
            Case #Mnu_Close
              Close()
            Case #Mnu_Copy
              Copy()
            Case #Mnu_AddEbene
              AddEbene()
            Case #Mnu_DelEbene
              RemoveEbene()
            Case #Mnu_RefreshImg
              RefreshImage()
            Case #Mnu_SetImg
              OpenOpenImgWindow()
            Case #Mnu_RemImg
              RemImg()
            Case #Mnu_EbeneUp
              EbeneUp()
            Case #Mnu_EbeneDown
              EbeneDown()
            Case #Mnu_RenameEbene
              RenameEbene()
            Case #Mnu_ResetOffSet
              ResetOffSet()
            Case #Mnu_OffSetLeft
              OffSetX_Left()
            Case #Mnu_OffSetRight
              OffSetX_Right()
            Case #Mnu_OffSetUp
              OffSet_Up()
            Case #Mnu_OffSetDown
              OffSet_Down()
            Case #Mnu_Backround
              BackroundColor()
            Case #Mnu_ResetZoom
              ResetZoom()
            Case #Mnu_ZoomIn
              ZoomIn()
            Case #Mnu_ZoomOut
              ZoomOut()
            Case #Mnu_Preview
              StartPreview()
            Case #Mnu_Update
              If Update() = 0
                MsgBox_Error("Updatefehler")
              EndIf
            Case #Mnu_Info
              MessageRequester("Informationen", #PrgName + " " + StrF(#PrgVers/100, 2) + #CR$ + #CR$ + #PrgName + " ist Freeware" + #CR$ + "und darf sowohl privat wie" + #CR$ + "auch kommerziell frei benutzt werden." + #CR$ + #CR$ + "Copyright Kai Gartenschläger, 2007" + #CR$ + #CR$ + "Kontakt:" + #CR$ + #URL_Homepage + #CR$ + #EMail + #CR$ + #CR$ + "Programmiert in PureBasic" + #CR$ + "Feel the ..Pure.. Power" + #CR$ + "http://www.purebasic.com", #MB_OK|#MB_ICONINFORMATION)
          EndSelect
      EndSelect

      ;Event_Gadget
    Case #PB_Event_Gadget
      Select EventWindow
        Case #Win_Main
          Select EventGadget
            Case #G_LV_Ebenen
              If EventType = #PB_EventType_LeftClick
                RefreshEbenenInfo()
              EndIf
              If EventType = #PB_EventType_LeftDoubleClick
                RenameEbene()
              EndIf
          EndSelect
        Case #Win_New
          Select EventGadget
            Case #G_BN_New_Create
              New_Create()
            Case #G_BN_New_Cancel
              CloseNewWindow()
            Case #G_CB_New_Format
              SelectElement(Format(), GetGadgetState(#G_CB_New_Format))
              SetGadgetText(#G_SR_New_Width, Str(Format()\Width))
              SetGadgetText(#G_SR_New_Height, Str(Format()\Height))
          EndSelect
        Case #Win_Preview
          Select EventGadget
            Case #G_OP_Preview_1
              If GetGadgetState(#G_OP_Preview_1) = #False
                frame = 0
              EndIf
            Case #G_OP_Preview_2
              If GetGadgetState(#G_OP_Preview_2) = #False
                frame = 4
              EndIf
            Case #G_OP_Preview_3
              If GetGadgetState(#G_OP_Preview_3) = #False
                frame = 8
              EndIf
            Case #G_OP_Preview_4
              If GetGadgetState(#G_OP_Preview_4) = #False
                frame = 12
              EndIf
            Case #G_BN_Preview_OK
              StopPreview()
          EndSelect
        Case #Win_OpenImg
          Select EventGadget
            Case #G_CB_OpenImg_Folder
              RefreshFileList()
            Case #G_EL_OpenImg_File
              RefreshPreview()
              If EventType = #PB_EventType_LeftDoubleClick
                SetImg()
              EndIf
            Case #G_BN_OpenImg_Cancel
              CloseOpenImgWindow()
            Case #G_BN_OpenImg_OK
              SetImg()
            Case #G_CB_OpenImg_Zoomed
              RefreshPreview()
          EndSelect
      EndSelect

      ;Event_SizeWindow
    Case #PB_Event_SizeWindow
      Select EventWindow
        Case #Win_OpenImg
          ResizeGadget(#G_CB_OpenImg_Folder, #PB_Ignore, #PB_Ignore, WindowWidth(#Win_OpenImg) - 175, #PB_Ignore)
          ResizeGadget(#G_EL_OpenImg_File, #PB_Ignore, #PB_Ignore, WindowWidth(#Win_OpenImg) - 175, WindowHeight(#Win_OpenImg) - 35)
          ResizeGadget(#G_FR_OpenImg_Preview, WindowWidth(#Win_OpenImg) - 160, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ResizeGadget(#G_IG_OpenImg_Preview, WindowWidth(#Win_OpenImg) - 150, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ResizeGadget(#G_CB_OpenImg_Zoomed, WindowWidth(#Win_OpenImg) - 150, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ResizeGadget(#G_TX_OpenImg_PreviewSize, WindowWidth(#Win_OpenImg) - 150, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ResizeGadget(#G_BN_OpenImg_Cancel, WindowWidth(#Win_OpenImg) - 159, WindowHeight(#Win_OpenImg) - 35, #PB_Ignore, #PB_Ignore)
          ResizeGadget(#G_BN_OpenImg_OK, WindowWidth(#Win_OpenImg) - 83, WindowHeight(#Win_OpenImg) - 35, #PB_Ignore, #PB_Ignore)
      EndSelect

      ;Event_CloseWindow
    Case #PB_Event_CloseWindow
      Select EventWindow
        Case #Win_Main
          Beenden()
        Case #Win_New
          CloseNewWindow()
        Case #Win_Preview
          StopPreview()
        Case #Win_OpenImg
          CloseOpenImgWindow()
      EndSelect

      ;Event_None
    Case #False
      Delay(1)
  EndSelect
ForEver
;}
; IDE Options = PureBasic 4.20 Beta 2 (Windows - x86)
; CursorPosition = 125
; FirstLine = 105
; Folding = +LA5-------
; EnableXP
; EnableOnError
; UseIcon = Icn_CharEdit.ico
; Executable = ..\CharEdit.exe
; CPU = 1
; CompileSourceDirectory
; EnableCompileCount = 268
; EnableBuildCount = 99
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 2,0,7,0
; VersionField1 = 2,0,7,0
; VersionField2 = PureSoft
; VersionField3 = Character Editor BETA
; VersionField4 = 2.07
; VersionField5 = 2.07
; VersionField6 = Verwaltung von Charactersets
; VersionField7 = Character Editor
; VersionField8 = CharEdit.exe
; VersionField9 = Copyright©Kai Gartenschläger, 2007
; VersionField13 = dergarty@freenet.de
; VersionField14 = http://www.kaisnet.de.vu
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_APP
; VersionField17 = 0407 German (Standard)
; IDE Options = PureBasic 5.10 Beta 1 (Windows - x86)
; CursorPosition = 176
; FirstLine = 175
; Folding = -fAw----------------------------------------
; EnableXP
; EnableOnError
; UseIcon = Icn_CharEdit.ico
; Executable = ..\CharEdit.exe
; CPU = 1
; CompileSourceDirectory
; EnableCompileCount = 36
; EnableBuildCount = 9
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 2,0,9,0
; VersionField1 = 2,0,9,0
; VersionField2 = PureSoft
; VersionField3 = Character Editor
; VersionField4 = 2.09
; VersionField5 = 2.09
; VersionField6 = Tool zum erstellen von Character Tilesets
; VersionField7 = Character Editor
; VersionField8 = CharEdit.exe
; VersionField9 = Copyright©2008, Kai Gartenschläger
; VersionField13 = dergarty@freenet.de
; VersionField14 = http://purefreak.pu.funpic.de/