object frmSettings: TfrmSettings
  Left = 462
  Top = 258
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  ClientHeight = 457
  ClientWidth = 620
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object fraHotkey: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 8
    object chkAlt: TCheckBox
      Left = 8
      Top = 16
      Width = 473
      Height = 17
      Caption = '&Alt +'
      TabOrder = 0
    end
    object chkCtrl: TCheckBox
      Left = 8
      Top = 40
      Width = 473
      Height = 17
      Caption = '&Ctrl +'
      TabOrder = 1
    end
    object chkShift: TCheckBox
      Left = 8
      Top = 64
      Width = 473
      Height = 17
      Caption = '&Shift +'
      TabOrder = 2
    end
    object chkWin: TCheckBox
      Left = 8
      Top = 88
      Width = 473
      Height = 17
      Caption = '&Win +'
      TabOrder = 3
    end
    object htkHotkey: THotKey
      Left = 8
      Top = 112
      Width = 473
      Height = 21
      InvalidKeys = [hcShift, hcCtrl, hcAlt, hcShiftCtrl, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt]
      Modifiers = []
      TabOrder = 4
    end
  end
  object fraUndo: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 17
    object chkUseUndo: TCheckBox
      Left = 8
      Top = 16
      Width = 473
      Height = 17
      Caption = 'Use Undo function'
      TabOrder = 0
    end
  end
  object fraLanguage: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 15
    object lblLanguage: TLabel
      Left = 8
      Top = 16
      Width = 80
      Height = 13
      Caption = 'Select language:'
    end
    object lblAuthor: TLabel
      Left = 8
      Top = 64
      Width = 34
      Height = 13
      Caption = 'Author:'
    end
    object lblVersion: TLabel
      Left = 8
      Top = 88
      Width = 38
      Height = 13
      Caption = 'Version:'
    end
    object boxLanguage: TComboBox
      Left = 8
      Top = 32
      Width = 473
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = boxLanguageChange
    end
    object txtAuthor: TEdit
      Left = 80
      Top = 64
      Width = 401
      Height = 21
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object txtVersion: TEdit
      Left = 80
      Top = 88
      Width = 401
      Height = 21
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
  end
  object fraFont: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 7
    object lblFont: TLabel
      Left = 8
      Top = 52
      Width = 61
      Height = 16
      Caption = 'Courier yo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblTextAlignment: TLabel
      Left = 8
      Top = 152
      Width = 72
      Height = 13
      Caption = 'Text alignment:'
    end
    object btnFont: TButton
      Left = 8
      Top = 16
      Width = 473
      Height = 25
      Caption = 'Change font'
      TabOrder = 0
      OnClick = btnFontClick
    end
    object optAlignLeft: TRadioButton
      Left = 8
      Top = 176
      Width = 473
      Height = 17
      Caption = 'Align left'
      TabOrder = 2
    end
    object optAlignCenter: TRadioButton
      Left = 8
      Top = 200
      Width = 473
      Height = 17
      Caption = 'Align center'
      TabOrder = 3
    end
    object optAlignRight: TRadioButton
      Left = 8
      Top = 224
      Width = 473
      Height = 17
      Caption = 'Align right'
      TabOrder = 4
    end
    object chkLockEnglish: TCheckBox
      Left = 8
      Top = 280
      Width = 473
      Height = 17
      Caption = 'Lock English layout in the console'
      TabOrder = 6
    end
    object chkApplyEnglish: TCheckBox
      Left = 8
      Top = 256
      Width = 473
      Height = 17
      Caption = 'Apply English layout every push hotkey'
      TabOrder = 5
    end
    object chkFontAutoSize: TCheckBox
      Left = 8
      Top = 120
      Width = 473
      Height = 17
      Caption = 'Autosize font to console height'
      TabOrder = 1
    end
  end
  object fraHistory: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 10
    object lblMaxHistory: TLabel
      Left = 24
      Top = 372
      Width = 143
      Height = 13
      Caption = 'Max history strings (0 - infinite):'
    end
    object optNoSaveHistory: TRadioButton
      Left = 8
      Top = 16
      Width = 473
      Height = 17
      Caption = 'Don'#39't save history to file'
      TabOrder = 0
      OnClick = optNoSaveHistoryClick
    end
    object optSaveHistory: TRadioButton
      Left = 8
      Top = 40
      Width = 473
      Height = 17
      Caption = 'Save history to file:'
      TabOrder = 1
      OnClick = optSaveHistoryClick
    end
    object chkSaveAlias: TCheckBox
      Left = 24
      Top = 88
      Width = 257
      Height = 17
      Caption = 'Save alias'
      TabOrder = 4
    end
    object chkSaveAliasParam: TCheckBox
      Left = 284
      Top = 88
      Width = 201
      Height = 17
      Caption = '... with parameters'
      TabOrder = 5
    end
    object chkSaveWWW: TCheckBox
      Left = 24
      Top = 136
      Width = 457
      Height = 17
      Caption = 'Save URL'#39's'
      TabOrder = 8
    end
    object chkSaveEMail: TCheckBox
      Left = 24
      Top = 160
      Width = 457
      Height = 17
      Caption = 'Save E-Mail'#39's'
      TabOrder = 9
    end
    object chkSaveFolder: TCheckBox
      Left = 24
      Top = 184
      Width = 457
      Height = 17
      Caption = 'Save Folder'#39's'
      TabOrder = 10
    end
    object chkSaveShell: TCheckBox
      Left = 24
      Top = 232
      Width = 457
      Height = 17
      Caption = 'Save shell commands (all other AKA unknown)'
      TabOrder = 13
    end
    object btnClearHistory: TButton
      Left = 8
      Top = 392
      Width = 473
      Height = 25
      Caption = 'Clear history'
      TabOrder = 19
      OnClick = btnClearHistoryClick
    end
    object txtMaxHistory: TEdit
      Left = 416
      Top = 368
      Width = 41
      Height = 21
      TabOrder = 17
      Text = '0'
      OnChange = txtMaxHistoryChange
    end
    object chkSaveSysAlias: TCheckBox
      Left = 24
      Top = 112
      Width = 257
      Height = 17
      Caption = 'Save system alias'
      TabOrder = 6
    end
    object chkSaveSysAliasParam: TCheckBox
      Left = 284
      Top = 112
      Width = 201
      Height = 17
      Caption = '... with parameters'
      TabOrder = 7
    end
    object chkSaveInternalParam: TCheckBox
      Left = 284
      Top = 64
      Width = 201
      Height = 17
      Caption = '... with parameters'
      TabOrder = 3
    end
    object chkSaveInternal: TCheckBox
      Left = 24
      Top = 64
      Width = 257
      Height = 17
      Caption = 'Save internal commands'
      TabOrder = 2
    end
    object spnMaxHistory: TUpDown
      Left = 457
      Top = 368
      Width = 16
      Height = 21
      Associate = txtMaxHistory
      Max = 10000
      TabOrder = 18
    end
    object chkSavePlugins: TCheckBox
      Left = 24
      Top = 208
      Width = 257
      Height = 17
      Caption = 'Save plugins'#39's'
      TabOrder = 11
    end
    object chkSaveCommandLine: TCheckBox
      Left = 24
      Top = 272
      Width = 457
      Height = 17
      Caption = 'Save strings from command line (--exec=string)'
      TabOrder = 14
    end
    object chkSaveMessage: TCheckBox
      Left = 24
      Top = 296
      Width = 457
      Height = 17
      Caption = 'Save strings from message WM_COPYDATA to console window'
      TabOrder = 15
    end
    object chkInvertScroll: TCheckBox
      Left = 24
      Top = 336
      Width = 457
      Height = 17
      Caption = 'Invert history scroll'
      TabOrder = 16
    end
    object chkSavePluginParam: TCheckBox
      Left = 284
      Top = 208
      Width = 201
      Height = 17
      Caption = '... with parameters'
      TabOrder = 12
    end
  end
  object lstSettings: TListBox
    Left = 0
    Top = 0
    Width = 129
    Height = 457
    Align = alLeft
    ItemHeight = 13
    Items.Strings = (
      'Appearance'
      'Console look'
      'Hint popup'
      'Dropdown list'
      'Colors'
      'Font'
      'HotKey'
      'EasyType'
      'Exec'
      'History'
      'Pathes'
      'Registry'
      'Language'
      'Undo'
      'Sounds'
      'Config'
      'Edit Config'
      'Plugins')
    TabOrder = 0
    OnClick = lstSettingsClick
  end
  object btnOK: TButton
    Left = 136
    Top = 430
    Width = 153
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 300
    Top = 430
    Width = 153
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnApply: TButton
    Left = 464
    Top = 430
    Width = 153
    Height = 25
    Caption = 'Apply'
    TabOrder = 3
    OnClick = btnApplyClick
  end
  object fraAppearance: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 4
    object lblPriority: TLabel
      Left = 8
      Top = 184
      Width = 76
      Height = 13
      Caption = 'Running priority:'
    end
    object chkShowConsoleOnStart: TCheckBox
      Left = 8
      Top = 16
      Width = 473
      Height = 17
      Caption = 'Show console window on start'
      TabOrder = 0
    end
    object chkHideConsole: TCheckBox
      Left = 8
      Top = 40
      Width = 473
      Height = 17
      Caption = 'Hide console with Enter'
      TabOrder = 1
    end
    object chkTriggerShow: TCheckBox
      Left = 8
      Top = 64
      Width = 473
      Height = 17
      Caption = 'Trigger show (Hotkey or Esc)'
      TabOrder = 2
    end
    object chkTrayIcon: TCheckBox
      Left = 8
      Top = 88
      Width = 473
      Height = 17
      Caption = 'Show icon in system tray'
      TabOrder = 3
      OnClick = chkTrayIconClick
    end
    object chkAutoHide: TCheckBox
      Left = 8
      Top = 160
      Width = 401
      Height = 17
      Caption = 'AutoHide console after (in millisecs):'
      TabOrder = 6
      OnClick = chkAutoHideClick
    end
    object txtAutoHide: TEdit
      Left = 416
      Top = 158
      Width = 41
      Height = 21
      TabOrder = 7
      Text = '1'
      OnChange = txtAutoHideChange
    end
    object boxPriority: TComboBox
      Left = 8
      Top = 200
      Width = 153
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 9
      Items.Strings = (
        '-1 - Low'
        '0 - Normal'
        '1 - High'
        '2 - Realtime')
    end
    object spnAutoHide: TUpDown
      Left = 457
      Top = 158
      Width = 16
      Height = 21
      Associate = txtAutoHide
      Min = 1
      Max = 30000
      Position = 1
      TabOrder = 8
    end
    object chkShowBalloonTips: TCheckBox
      Left = 8
      Top = 112
      Width = 473
      Height = 17
      Caption = 'Show balloon tips in system tray'
      TabOrder = 4
      OnClick = chkShowBalloonTipsClick
    end
    object chkPutMouseIntoConsole: TCheckBox
      Left = 8
      Top = 136
      Width = 473
      Height = 17
      Caption = 'Put mouse cursor into console every show console window'
      TabOrder = 5
    end
  end
  object fraExec: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 9
    object chkExecInternal: TCheckBox
      Left = 8
      Top = 16
      Width = 473
      Height = 17
      Caption = 'Execute internal commands'
      TabOrder = 0
    end
    object chkExecAlias: TCheckBox
      Left = 8
      Top = 40
      Width = 209
      Height = 17
      Caption = 'Execute aliases'
      TabOrder = 1
    end
    object chkExecWWW: TCheckBox
      Left = 8
      Top = 88
      Width = 473
      Height = 17
      Caption = 'Execute URL'#39's'
      TabOrder = 4
    end
    object chkExecEMail: TCheckBox
      Left = 8
      Top = 112
      Width = 473
      Height = 17
      Caption = 'Execute E-Mail'#39's'
      TabOrder = 5
    end
    object chkExecFolder: TCheckBox
      Left = 8
      Top = 136
      Width = 473
      Height = 17
      Caption = 'Execute folders'
      TabOrder = 6
    end
    object chkExecShell: TCheckBox
      Left = 8
      Top = 208
      Width = 473
      Height = 17
      Caption = 'Execute shell commands (all other)'
      TabOrder = 9
    end
    object chkExecSysAlias: TCheckBox
      Left = 8
      Top = 64
      Width = 473
      Height = 17
      Caption = 'Execute system aliases'
      TabOrder = 3
    end
    object chkExecFile: TCheckBox
      Left = 8
      Top = 160
      Width = 473
      Height = 17
      Caption = 'Execute files'
      TabOrder = 7
    end
    object chkExecPlugins: TCheckBox
      Left = 8
      Top = 184
      Width = 473
      Height = 17
      Caption = 'Execute plugins'
      TabOrder = 8
    end
    object chkExecUseDefaultAction: TCheckBox
      Left = 224
      Top = 40
      Width = 257
      Height = 17
      Caption = '... with default shell action'
      TabOrder = 2
    end
  end
  object fraType: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 13
    object optNoType: TRadioButton
      Left = 8
      Top = 16
      Width = 473
      Height = 17
      Caption = 'Don'#39't use EasyType'
      TabOrder = 0
      OnClick = optNoTypeClick
    end
    object optEasyType: TRadioButton
      Left = 8
      Top = 40
      Width = 473
      Height = 17
      Caption = 'Use EasyType'
      TabOrder = 1
      OnClick = optEasyTypeClick
    end
    object optLinuxType: TRadioButton
      Left = 8
      Top = 64
      Width = 473
      Height = 17
      Caption = 'Use Linux model of EasyType'
      TabOrder = 2
      OnClick = optLinuxTypeClick
    end
    object chkETInternal: TCheckBox
      Left = 24
      Top = 96
      Width = 457
      Height = 17
      Caption = 'Use EasyType for internal commands'
      TabOrder = 3
    end
    object chkETAlias: TCheckBox
      Left = 24
      Top = 120
      Width = 457
      Height = 17
      Caption = 'Use EasyType for aliases'
      TabOrder = 4
    end
    object chkETPath: TCheckBox
      Left = 24
      Top = 168
      Width = 457
      Height = 17
      Caption = 'Use EasyType for path browser'
      TabOrder = 6
    end
    object chkETHistory: TCheckBox
      Left = 24
      Top = 216
      Width = 457
      Height = 17
      Caption = 'Use EasyType for history'
      TabOrder = 8
    end
    object chkCase: TCheckBox
      Left = 8
      Top = 296
      Width = 473
      Height = 17
      Caption = 'Case sensitivity (www <> WWW)'
      TabOrder = 10
    end
    object chkETSysAlias: TCheckBox
      Left = 24
      Top = 144
      Width = 457
      Height = 17
      Caption = 'Use EasyType for system aliases'
      TabOrder = 5
    end
    object chkSpace: TCheckBox
      Left = 24
      Top = 248
      Width = 457
      Height = 17
      Caption = 'Add space to alias name'
      TabOrder = 9
    end
    object chkETPlugins: TCheckBox
      Left = 24
      Top = 192
      Width = 457
      Height = 17
      Caption = 'Use EasyType for plugins aliases'
      TabOrder = 7
    end
    object chkEnableET: TCheckBox
      Left = 8
      Top = 320
      Width = 473
      Height = 17
      Caption = 'Enable EasyType every hotkey push'
      TabOrder = 11
    end
    object chkAdvancedBackspace: TCheckBox
      Left = 8
      Top = 344
      Width = 473
      Height = 17
      Caption = 'Enable advanced backspace'
      TabOrder = 12
    end
    object chkAdvancedSpace: TCheckBox
      Left = 8
      Top = 368
      Width = 473
      Height = 17
      Caption = 'Enable advanced space'
      TabOrder = 13
    end
    object chkDeleteDuplicate: TCheckBox
      Left = 8
      Top = 392
      Width = 473
      Height = 17
      Caption = 'Delete duplicates in the EasyType completion list'
      TabOrder = 14
    end
  end
  object fraSounds: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 21
    object chkEnableSounds: TCheckBox
      Left = 8
      Top = 16
      Width = 473
      Height = 17
      Caption = '&Enable sounds'
      TabOrder = 0
      OnClick = chkEnableSoundsClick
    end
    object lstSounds: TListBox
      Left = 8
      Top = 40
      Width = 473
      Height = 345
      ItemHeight = 13
      Items.Strings = (
        'Execute internal command'
        'Execute alias'
        'Execute system alias'
        'Execute URL'
        'Execute E-Mail'
        'Execute folder'
        'Execute file'
        'Execute plugin'
        'Execute all other')
      TabOrder = 1
      OnClick = lstSoundsClick
    end
    object btnBrowseSound: TButton
      Left = 344
      Top = 392
      Width = 137
      Height = 25
      Caption = 'btnBrowseSound'
      TabOrder = 2
      OnClick = btnBrowseSoundClick
    end
    object txtSoundPath: TEdit
      Left = 8
      Top = 394
      Width = 329
      Height = 21
      TabOrder = 3
      OnChange = txtSoundPathChange
    end
  end
  object fraRegistry: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 12
    object lblMultiUsers: TLabel
      Left = 24
      Top = 152
      Width = 142
      Height = 13
      Caption = '* Require restart TypeAndRun'
    end
    object chkAddTo: TCheckBox
      Left = 8
      Top = 104
      Width = 473
      Height = 17
      Caption = 'Shell intergration ("Add to TypeAndRun..." context menu)'
      TabOrder = 3
    end
    object optNoAutorun: TRadioButton
      Left = 8
      Top = 16
      Width = 473
      Height = 17
      Caption = 'No autostart'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object optAutostartLM: TRadioButton
      Left = 8
      Top = 40
      Width = 473
      Height = 17
      Caption = 'HKLM - for all users'
      TabOrder = 1
    end
    object optAutostartCU: TRadioButton
      Left = 8
      Top = 64
      Width = 473
      Height = 17
      Caption = 'HKCU - for current user'
      TabOrder = 2
    end
    object chkMultiUsers: TCheckBox
      Left = 8
      Top = 128
      Width = 473
      Height = 17
      Caption = '&Use multi users config system'
      TabOrder = 4
    end
  end
  object fraLook: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 5
    object lblConsoleWidth: TLabel
      Left = 8
      Top = 88
      Width = 69
      Height = 13
      Caption = 'Console width:'
    end
    object lblConsoleHeight: TLabel
      Left = 8
      Top = 120
      Width = 73
      Height = 13
      Caption = 'Console height:'
    end
    object lblBorderSize: TLabel
      Left = 8
      Top = 160
      Width = 55
      Height = 13
      Caption = 'Border size:'
    end
    object lblTransparent: TLabel
      Left = 8
      Top = 212
      Width = 100
      Height = 13
      Caption = 'Transparent console:'
    end
    object txtConsoleY: TEdit
      Left = 416
      Top = 46
      Width = 41
      Height = 21
      TabOrder = 4
      Text = '0'
      OnChange = txtConsoleYChange
    end
    object txtConsoleWidth: TEdit
      Left = 416
      Top = 86
      Width = 41
      Height = 21
      TabOrder = 7
      Text = '0'
      OnChange = txtConsoleWidthChange
    end
    object txtConsoleHeight: TEdit
      Left = 416
      Top = 118
      Width = 41
      Height = 21
      TabOrder = 9
      Text = '0'
      OnChange = txtConsoleHeightChange
    end
    object txtBorderSize: TEdit
      Left = 416
      Top = 158
      Width = 41
      Height = 21
      TabOrder = 11
      Text = '0'
      OnChange = txtBorderSizeChange
    end
    object chkShowCenterX: TCheckBox
      Left = 8
      Top = 16
      Width = 401
      Height = 17
      Caption = 'Show in center X'
      TabOrder = 0
      OnClick = chkShowCenterXClick
    end
    object chkShowCenterY: TCheckBox
      Left = 8
      Top = 48
      Width = 401
      Height = 17
      Caption = 'Show in center Y'
      TabOrder = 3
      OnClick = chkShowCenterYClick
    end
    object spnConsoleX: TUpDown
      Left = 457
      Top = 14
      Width = 16
      Height = 21
      Associate = txtConsoleX
      TabOrder = 2
    end
    object spnConsoleY: TUpDown
      Left = 457
      Top = 46
      Width = 16
      Height = 21
      Associate = txtConsoleY
      TabOrder = 5
    end
    object txtConsoleX: TEdit
      Left = 416
      Top = 14
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '0'
      OnChange = txtConsoleXChange
    end
    object spnConsoleWidth: TUpDown
      Left = 457
      Top = 86
      Width = 16
      Height = 21
      Associate = txtConsoleWidth
      TabOrder = 8
    end
    object spnConsoleHeight: TUpDown
      Left = 457
      Top = 118
      Width = 16
      Height = 21
      Associate = txtConsoleHeight
      TabOrder = 10
    end
    object spnBorderSize: TUpDown
      Left = 457
      Top = 158
      Width = 16
      Height = 21
      Associate = txtBorderSize
      TabOrder = 12
    end
    object chkConsoleWidthPercent: TCheckBox
      Left = 216
      Top = 88
      Width = 193
      Height = 17
      Caption = '(in percents of screen width)'
      TabOrder = 6
    end
    object chkDestroyForm: TCheckBox
      Left = 8
      Top = 184
      Width = 473
      Height = 17
      Caption = 'Show border only (OS >= NT5)'
      TabOrder = 13
    end
    object txtTransValue: TEdit
      Left = 416
      Top = 210
      Width = 41
      Height = 21
      TabOrder = 14
      Text = '0'
      OnChange = txtTransValueChange
    end
    object spnTransValue: TUpDown
      Left = 457
      Top = 210
      Width = 16
      Height = 21
      Associate = txtTransValue
      Max = 255
      TabOrder = 15
    end
  end
  object fraHintPopup: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 19
    object lblHintBorderSize: TLabel
      Left = 8
      Top = 48
      Width = 55
      Height = 13
      Caption = 'Border size:'
    end
    object lblHintTransparent: TLabel
      Left = 8
      Top = 100
      Width = 80
      Height = 13
      Caption = 'Transparent hint:'
    end
    object chkShowHint: TCheckBox
      Left = 8
      Top = 16
      Width = 473
      Height = 17
      Caption = 'Show hint while typing alises and system aliases in console'
      TabOrder = 0
    end
    object txtHintBorderSize: TEdit
      Left = 416
      Top = 46
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '0'
      OnChange = txtHintBorderSizeChange
    end
    object spnHintBorderSize: TUpDown
      Left = 457
      Top = 46
      Width = 16
      Height = 21
      Associate = txtHintBorderSize
      TabOrder = 2
    end
    object chkHintShowBorderOnly: TCheckBox
      Left = 8
      Top = 72
      Width = 473
      Height = 17
      Caption = 'Show border only (OS >= NT5)'
      TabOrder = 3
    end
    object txtHintTransparent: TEdit
      Left = 416
      Top = 98
      Width = 41
      Height = 21
      TabOrder = 4
      Text = '0'
      OnChange = txtHintTransparentChange
    end
    object spnHintTransparent: TUpDown
      Left = 457
      Top = 98
      Width = 16
      Height = 21
      Associate = txtHintTransparent
      Max = 255
      TabOrder = 5
    end
  end
  object fraDropdownList: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 20
    object lblDropdownLineNum: TLabel
      Left = 8
      Top = 16
      Width = 138
      Height = 13
      Caption = 'Lines count in DropDown list:'
    end
    object lblDropdownBorderSize: TLabel
      Left = 8
      Top = 48
      Width = 55
      Height = 13
      Caption = 'Border size:'
    end
    object lblDropdownTransparent: TLabel
      Left = 8
      Top = 100
      Width = 114
      Height = 13
      Caption = 'Transparent DropDown:'
    end
    object txtDropDownLineCount: TEdit
      Left = 416
      Top = 14
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '1'
      OnChange = txtDropDownLineCountChange
    end
    object spnDropDownLineCount: TUpDown
      Left = 457
      Top = 14
      Width = 16
      Height = 21
      Associate = txtDropDownLineCount
      Min = 1
      Max = 1000
      Position = 1
      TabOrder = 1
    end
    object txtDropdownBorderSize: TEdit
      Left = 416
      Top = 46
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '0'
      OnChange = txtDropdownBorderSizeChange
    end
    object spnDropdownBorderSize: TUpDown
      Left = 457
      Top = 46
      Width = 16
      Height = 21
      Associate = txtDropdownBorderSize
      TabOrder = 3
    end
    object spnDropdownTransparent: TUpDown
      Left = 457
      Top = 98
      Width = 16
      Height = 21
      Associate = txtDropdownTransparent
      Max = 255
      TabOrder = 4
    end
    object txtDropdownTransparent: TEdit
      Left = 416
      Top = 98
      Width = 41
      Height = 21
      TabOrder = 5
      Text = '0'
      OnChange = txtDropdownTransparentChange
    end
    object chkDropdownShowBorderOnly: TCheckBox
      Left = 8
      Top = 72
      Width = 473
      Height = 17
      Caption = 'Show border only (OS >= NT5)'
      TabOrder = 6
    end
  end
  object fraPlugins: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 18
    object lblPluginStatus: TLabel
      Left = 168
      Top = 16
      Width = 33
      Height = 13
      Caption = 'Status:'
    end
    object lblPluginName: TLabel
      Left = 168
      Top = 32
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object lblPluginVersion: TLabel
      Left = 168
      Top = 48
      Width = 38
      Height = 13
      Caption = 'Version:'
    end
    object lblPluginDescription: TLabel
      Left = 168
      Top = 64
      Width = 56
      Height = 13
      Caption = 'Description:'
    end
    object lblPluginAuthor: TLabel
      Left = 168
      Top = 112
      Width = 34
      Height = 13
      Caption = 'Author:'
    end
    object lblPluginCopyright: TLabel
      Left = 168
      Top = 128
      Width = 47
      Height = 13
      Caption = 'Copyright:'
    end
    object lblPluginHomepage: TLabel
      Left = 168
      Top = 144
      Width = 55
      Height = 13
      Caption = 'Homepage:'
    end
    object lblPluginPath: TLabel
      Left = 168
      Top = 168
      Width = 25
      Height = 13
      Caption = 'Path:'
    end
    object lstPluginList: TListBox
      Left = 8
      Top = 10
      Width = 145
      Height = 407
      ItemHeight = 13
      TabOrder = 0
      OnClick = lstPluginListClick
    end
    object txtPluginName: TEdit
      Left = 256
      Top = 32
      Width = 225
      Height = 17
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 1
      Text = 'txtPluginName'
    end
    object txtPluginVersion: TEdit
      Left = 256
      Top = 48
      Width = 225
      Height = 17
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 2
      Text = 'txtPluginName'
    end
    object txtPluginAuthor: TEdit
      Left = 256
      Top = 112
      Width = 225
      Height = 17
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 4
      Text = 'txtPluginName'
    end
    object txtPluginCopyright: TEdit
      Left = 256
      Top = 128
      Width = 225
      Height = 17
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 5
      Text = 'txtPluginName'
    end
    object txtPluginHomepage: TEdit
      Left = 256
      Top = 144
      Width = 225
      Height = 17
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 6
      Text = 'txtPluginName'
    end
    object btnPluginAdd: TButton
      Left = 184
      Top = 392
      Width = 145
      Height = 25
      Caption = '&Add plugin...'
      TabOrder = 12
      OnClick = btnPluginAddClick
    end
    object btnPluginDelete: TButton
      Left = 336
      Top = 392
      Width = 145
      Height = 25
      Caption = '&Delete plugin'
      TabOrder = 13
      OnClick = btnPluginDeleteClick
    end
    object txtPluginPath: TEdit
      Left = 256
      Top = 168
      Width = 225
      Height = 17
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 7
      Text = 'txtPluginName'
    end
    object btnLoadPlugin: TButton
      Left = 160
      Top = 192
      Width = 321
      Height = 25
      Caption = 'Load plugin'
      TabOrder = 8
      OnClick = btnLoadPluginClick
    end
    object btnUnloadPlugin: TButton
      Left = 160
      Top = 192
      Width = 321
      Height = 25
      Caption = 'Unload plugin'
      TabOrder = 9
      OnClick = btnUnloadPluginClick
    end
    object chkLoadingPlugin: TCheckBox
      Left = 160
      Top = 224
      Width = 321
      Height = 17
      Caption = 'Load plugin on T&&R start'
      TabOrder = 10
      OnClick = chkLoadingPluginClick
    end
    object txtPluginDescription: TMemo
      Left = 256
      Top = 64
      Width = 225
      Height = 49
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'txtPluginName')
      TabOrder = 3
    end
    object chkSaveHistoryPlugin: TCheckBox
      Left = 160
      Top = 248
      Width = 321
      Height = 17
      Caption = 'Save history of this plugin'
      TabOrder = 11
      OnClick = chkSaveHistoryPluginClick
    end
    object lstPluginAliases: TListBox
      Left = 160
      Top = 272
      Width = 321
      Height = 113
      ItemHeight = 13
      TabOrder = 14
      OnDblClick = lstPluginAliasesDblClick
    end
    object spnSortPlugins: TUpDown
      Left = 160
      Top = 392
      Width = 17
      Height = 25
      Increment = -1
      TabOrder = 15
      OnChangingEx = spnSortPluginsChangingEx
    end
  end
  object fraColors: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 6
    object lblTextcolor: TLabel
      Left = 8
      Top = 54
      Width = 50
      Height = 13
      Caption = 'Text color:'
    end
    object shpTextColor: TShape
      Left = 424
      Top = 48
      Width = 57
      Height = 25
      OnMouseDown = shpTextColorMouseDown
    end
    object lblConsoleColor: TLabel
      Left = 8
      Top = 86
      Width = 67
      Height = 13
      Caption = 'Console color:'
    end
    object shpConsoleColor: TShape
      Left = 424
      Top = 80
      Width = 57
      Height = 25
      OnMouseDown = shpConsoleColorMouseDown
    end
    object shpBorderColor: TShape
      Left = 424
      Top = 112
      Width = 57
      Height = 25
      OnMouseDown = shpBorderColorMouseDown
    end
    object lblBorderColor: TLabel
      Left = 8
      Top = 118
      Width = 60
      Height = 13
      Caption = 'Border color:'
    end
    object lblHintTextColor: TLabel
      Left = 8
      Top = 166
      Width = 68
      Height = 13
      Caption = 'Hint text color:'
    end
    object shpHintTextColor: TShape
      Left = 424
      Top = 160
      Width = 57
      Height = 25
      OnMouseDown = shpHintTextColorMouseDown
    end
    object lblHintColor: TLabel
      Left = 8
      Top = 198
      Width = 68
      Height = 13
      Caption = 'Hint text color:'
    end
    object shpHintColor: TShape
      Left = 424
      Top = 192
      Width = 57
      Height = 25
      OnMouseDown = shpHintColorMoueDown
    end
    object lblDropdownTextColor: TLabel
      Left = 8
      Top = 278
      Width = 98
      Height = 13
      Caption = 'Dropdown text color:'
    end
    object lblDropdownColor: TLabel
      Left = 8
      Top = 310
      Width = 78
      Height = 13
      Caption = 'Dropdown color:'
    end
    object shpDropdownColor: TShape
      Left = 424
      Top = 304
      Width = 57
      Height = 25
      OnMouseDown = shpDropdownColorMouseDown
    end
    object shpDropdownTextColor: TShape
      Left = 424
      Top = 272
      Width = 57
      Height = 25
      OnMouseDown = shpDropdownTextColorMouseDown
    end
    object lblHintBorderColor: TLabel
      Left = 8
      Top = 230
      Width = 81
      Height = 13
      Caption = 'Hint border color:'
    end
    object shpHintBorderColor: TShape
      Left = 424
      Top = 224
      Width = 57
      Height = 25
      OnMouseDown = shpHintBorderColorMouseDown
    end
    object lblDropDownBorderColor: TLabel
      Left = 8
      Top = 342
      Width = 111
      Height = 13
      Caption = 'Dropdown border color:'
    end
    object shpDropdownBorderColor: TShape
      Left = 424
      Top = 336
      Width = 57
      Height = 25
      OnMouseDown = shpDropdownBorderColorMouseDown
    end
    object boxETColor: TComboBox
      Left = 8
      Top = 16
      Width = 473
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'Normal EasyType'
      OnChange = boxETColorChange
      Items.Strings = (
        'Normal EasyType'
        'No EasyType')
    end
  end
  object fraPathes: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 11
    object lblBrowser: TLabel
      Left = 8
      Top = 16
      Width = 103
      Height = 13
      Caption = 'Your internet browser:'
    end
    object lblFileManager: TLabel
      Left = 8
      Top = 80
      Width = 196
      Height = 13
      Caption = 'Your file manager (example: explorer.exe):'
    end
    object lblShell: TLabel
      Left = 8
      Top = 144
      Width = 221
      Height = 13
      Caption = 'Your command shell (example: command.com):'
    end
    object lblCmdParamClose: TLabel
      Left = 32
      Top = 184
      Width = 173
      Height = 13
      Caption = 'Parameter for command shell - Enter:'
    end
    object lblCmdParamNoclose: TLabel
      Left = 32
      Top = 224
      Width = 200
      Height = 13
      Caption = 'Parameter for command shell - Shift+Enter:'
    end
    object txtBrowser: TEdit
      Left = 8
      Top = 32
      Width = 449
      Height = 21
      TabOrder = 0
      Text = 'txtBrowser'
    end
    object btnBrowser: TButton
      Left = 460
      Top = 32
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = btnBrowserClick
    end
    object txtFileManager: TEdit
      Left = 8
      Top = 96
      Width = 449
      Height = 21
      TabOrder = 2
      Text = 'txtBrowser'
    end
    object btnFileManager: TButton
      Left = 460
      Top = 96
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 3
      OnClick = btnFileManagerClick
    end
    object txtShell: TEdit
      Left = 8
      Top = 160
      Width = 449
      Height = 21
      TabOrder = 4
      Text = 'txtBrowser'
    end
    object btnShell: TButton
      Left = 460
      Top = 160
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 5
      OnClick = btnShellClick
    end
    object txtCmdParamClose: TEdit
      Left = 32
      Top = 200
      Width = 449
      Height = 21
      TabOrder = 6
      Text = 'txtBrowser'
    end
    object txtCmdParamNoclose: TEdit
      Left = 32
      Top = 240
      Width = 449
      Height = 21
      TabOrder = 7
      Text = 'txtBrowser'
    end
  end
  object fraConfig: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 14
    object lblChecking: TLabel
      Left = 8
      Top = 382
      Width = 473
      Height = 13
      AutoSize = False
      Caption = 'Checking alias:'
      Visible = False
    end
    object chkMoveTop: TCheckBox
      Left = 8
      Top = 16
      Width = 361
      Height = 17
      Caption = 'Move executed alias to first position'
      TabOrder = 0
      OnClick = chkMoveTopClick
    end
    object chkAutoReread: TCheckBox
      Left = 8
      Top = 80
      Width = 401
      Height = 17
      Caption = 'Auto reread Config.ini every (in millisecs):'
      TabOrder = 2
      OnClick = chkAutoRereadClick
    end
    object txtAutoReread: TEdit
      Left = 416
      Top = 78
      Width = 45
      Height = 21
      TabOrder = 3
      Text = '1'
      OnChange = txtAutoRereadChange
    end
    object chkAutoSort: TCheckBox
      Left = 8
      Top = 40
      Width = 361
      Height = 17
      Caption = 'Autosort config by alias name'
      TabOrder = 1
      OnClick = chkAutoSortClick
    end
    object chkRereadHotKey: TCheckBox
      Left = 8
      Top = 104
      Width = 473
      Height = 17
      Caption = 'Auto reread Config.ini every push hotkey'
      TabOrder = 5
      OnClick = chkAutoRereadClick
    end
    object chkCreateOldFile: TCheckBox
      Left = 8
      Top = 232
      Width = 473
      Height = 17
      Caption = 'Create Config.old files with removed dead aliases?'
      TabOrder = 6
    end
    object chkConfirm: TCheckBox
      Left = 8
      Top = 256
      Width = 473
      Height = 17
      Caption = 'Get confirmation before removing dead alias'
      TabOrder = 7
    end
    object chkStartCDA: TCheckBox
      Left = 8
      Top = 328
      Width = 473
      Height = 17
      Caption = 'Check dead aliases on every execute TypeAndRun'
      TabOrder = 10
    end
    object chkSearchFileCDA: TCheckBox
      Left = 8
      Top = 280
      Width = 473
      Height = 17
      Caption = 'Search file on this disk but another folder'
      TabOrder = 8
    end
    object spnAutoReread: TUpDown
      Left = 461
      Top = 78
      Width = 16
      Height = 21
      Associate = txtAutoReread
      Min = 1
      Max = 30000
      Position = 1
      TabOrder = 4
    end
    object pbrCheckDA: TProgressBar
      Left = 8
      Top = 400
      Width = 473
      Height = 17
      Smooth = True
      Step = 1
      TabOrder = 13
      Visible = False
    end
    object chkSearchPluginsCDA: TCheckBox
      Left = 8
      Top = 304
      Width = 473
      Height = 17
      Caption = 'Search alias in connected plugins'
      TabOrder = 9
    end
    object btnBackAllDA: TButton
      Left = 248
      Top = 352
      Width = 233
      Height = 25
      Caption = 'Get back all dead aliases'
      TabOrder = 12
      OnClick = btnBackAllDAClick
    end
    object btnCheckDeadAliases: TButton
      Left = 8
      Top = 352
      Width = 233
      Height = 25
      Caption = 'Check dead aliases!'
      TabOrder = 11
      OnClick = btnCheckDeadAliasesClick
    end
  end
  object fraEditor: TGroupBox
    Left = 132
    Top = 2
    Width = 489
    Height = 423
    TabOrder = 16
    object lblAliasName: TLabel
      Left = 160
      Top = 32
      Width = 54
      Height = 13
      Caption = 'Alias name:'
    end
    object lblAliasAction: TLabel
      Left = 160
      Top = 72
      Width = 33
      Height = 13
      Caption = 'Action:'
    end
    object lblAliasParams: TLabel
      Left = 160
      Top = 112
      Width = 56
      Height = 13
      Caption = 'Parameters:'
    end
    object lblAliasStartPath: TLabel
      Left = 160
      Top = 152
      Width = 49
      Height = 13
      Caption = 'Start path:'
    end
    object lblAliasState: TLabel
      Left = 160
      Top = 192
      Width = 79
      Height = 13
      Caption = 'State of window:'
    end
    object lblAliasHistory: TLabel
      Left = 160
      Top = 232
      Width = 70
      Height = 13
      Caption = 'Add to history?'
    end
    object lblAliasMoveTop: TLabel
      Left = 160
      Top = 272
      Width = 139
      Height = 13
      Caption = 'Move runing alias top config?'
    end
    object lblAliasPriori: TLabel
      Left = 160
      Top = 312
      Width = 34
      Height = 13
      Caption = 'Priority:'
    end
    object lblAliasComment: TLabel
      Left = 160
      Top = 352
      Width = 47
      Height = 13
      Caption = 'Comment:'
    end
    object lstConfig: TListBox
      Left = 8
      Top = 34
      Width = 145
      Height = 359
      ItemHeight = 13
      TabOrder = 0
      OnClick = lstConfigClick
      OnKeyDown = lstConfigKeyDown
      OnKeyPress = lstConfigKeyPress
      OnKeyUp = lstConfigKeyUp
      OnMouseDown = lstConfigMouseDown
      OnMouseMove = lstConfigMouseMove
      OnMouseUp = lstConfigMouseUp
    end
    object txtAliasName: TEdit
      Left = 160
      Top = 48
      Width = 321
      Height = 21
      TabOrder = 4
      Text = 'txtAliasName'
      OnChange = txtAliasNameChange
      OnKeyPress = txtAliasNameKeyPress
    end
    object txtAliasAction: TEdit
      Left = 160
      Top = 88
      Width = 281
      Height = 21
      TabOrder = 5
      Text = 'txtAliasAction'
      OnChange = txtAliasActionChange
    end
    object txtAliasParams: TEdit
      Left = 160
      Top = 128
      Width = 321
      Height = 21
      TabOrder = 8
      Text = 'txtAliasParams'
      OnChange = txtAliasParamsChange
    end
    object txtAliasStartPath: TEdit
      Left = 160
      Top = 168
      Width = 297
      Height = 21
      TabOrder = 9
      Text = 'txtAliasStartPath'
      OnChange = txtAliasStartPathChange
    end
    object boxAliasState: TComboBox
      Left = 160
      Top = 208
      Width = 321
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 11
      Text = '1 - Normal'
      OnChange = boxAliasStateChange
      Items.Strings = (
        '0 - Hide'
        '1 - Normal'
        '2 - Minimize'
        '3 - Maximize'
        '4 - Normal NO FOCUS'
        '5 - Minimize NO FOCUS')
    end
    object boxAliasHistory: TComboBox
      Left = 160
      Top = 248
      Width = 321
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 12
      Text = '0 - Default'
      OnChange = boxAliasHistoryChange
      Items.Strings = (
        '0 - Default'
        '1 - Always'
        '2 - Never')
    end
    object boxAliasMoveTop: TComboBox
      Left = 160
      Top = 288
      Width = 321
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 13
      Text = '0 - Default'
      OnChange = boxAliasMoveTopChange
      Items.Strings = (
        '0 - Default'
        '1 - Always'
        '2 - Never')
    end
    object btnAliasAction: TButton
      Left = 464
      Top = 88
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 7
      OnClick = btnAliasActionClick
    end
    object txtFullAlias: TEdit
      Left = 8
      Top = 10
      Width = 454
      Height = 21
      TabOrder = 2
      Text = 'txtFullAlias'
      Visible = False
    end
    object btnApplyFullAlias: TButton
      Left = 464
      Top = 10
      Width = 21
      Height = 21
      Caption = '+'
      TabOrder = 3
      Visible = False
      OnClick = btnApplyFullAliasClick
    end
    object btnAddAlias: TButton
      Left = 184
      Top = 392
      Width = 145
      Height = 25
      Caption = '&New Alias'
      TabOrder = 16
      OnClick = btnAddAliasClick
    end
    object btnDeleteAlias: TButton
      Left = 336
      Top = 392
      Width = 145
      Height = 25
      Caption = '&Delete Alias'
      TabOrder = 17
      OnClick = btnDeleteAliasClick
    end
    object spnConfig: TUpDown
      Left = 160
      Top = 392
      Width = 17
      Height = 25
      Increment = -1
      TabOrder = 18
      OnChangingEx = spnConfigChangingEx
    end
    object btnStartPath: TButton
      Left = 464
      Top = 168
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 10
      OnClick = btnStartPathClick
    end
    object boxAliasPriori: TComboBox
      Left = 160
      Top = 328
      Width = 321
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 14
      Text = '0 - Normal'
      OnChange = boxAliasPrioriChange
      Items.Strings = (
        '-1 - Low'
        '0 - Normal'
        '1 - High'
        '2 - Realtime')
    end
    object txtQuickSearch: TEdit
      Left = 8
      Top = 396
      Width = 145
      Height = 21
      TabStop = False
      TabOrder = 1
      Visible = False
      OnChange = txtQuickSearchChange
      OnExit = txtQuickSearchExit
      OnKeyDown = txtQuickSearchKeyDown
      OnKeyPress = txtQuickSearchKeyPress
    end
    object btnSelectPlugin: TButton
      Left = 442
      Top = 88
      Width = 21
      Height = 21
      Caption = '&P'
      TabOrder = 6
      OnClick = btnSelectPluginClick
    end
    object txtAliasComment: TEdit
      Left = 160
      Top = 368
      Width = 321
      Height = 21
      TabOrder = 15
      Text = 'txtAliasComment'
      OnChange = txtAliasCommentChange
    end
    object treePluginStrings: TTreeView
      Left = 464
      Top = 112
      Width = 17
      Height = 17
      Indent = 19
      ReadOnly = True
      TabOrder = 19
      Visible = False
      OnDblClick = treePluginStringsDblClick
      OnExit = treePluginStringsExit
      OnKeyPress = treePluginStringsKeyPress
    end
  end
end
