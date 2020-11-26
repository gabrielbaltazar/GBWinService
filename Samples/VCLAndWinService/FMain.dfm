object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmMain'
  ClientHeight = 71
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnInstallService: TButton
    Left = 32
    Top = 24
    Width = 131
    Height = 25
    Caption = 'Install Service'
    TabOrder = 0
    OnClick = btnInstallServiceClick
  end
  object btnUninstallService: TButton
    Left = 169
    Top = 24
    Width = 131
    Height = 25
    Caption = 'Uninstall Service'
    TabOrder = 1
    OnClick = btnUninstallServiceClick
  end
end
