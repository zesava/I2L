object GrblSettings: TGrblSettings
  Left = 404
  Top = 86
  BorderStyle = bsDialog
  Caption = 'GRBL settings'
  ClientHeight = 585
  ClientWidth = 403
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 549
    Width = 403
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object btnSave: TButton
      Left = 320
      Top = 6
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 224
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 403
    Height = 549
    Align = alClient
    Caption = 'pnl2'
    ParentBackground = False
    TabOrder = 1
    object sgSet: TStringGrid
      Left = 1
      Top = 1
      Width = 401
      Height = 547
      Align = alClient
      BorderStyle = bsNone
      ColCount = 3
      Ctl3D = False
      DefaultRowHeight = 15
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goAlwaysShowEditor]
      ParentCtl3D = False
      ScrollBars = ssVertical
      TabOrder = 0
      OnDrawCell = sgSetDrawCell
      OnKeyPress = sgSetKeyPress
      OnSelectCell = sgSetSelectCell
      OnSetEditText = sgSetSetEditText
    end
  end
end
