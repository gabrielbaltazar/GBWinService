unit FMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    btnInstallService: TButton;
    btnUninstallService: TButton;
    procedure btnInstallServiceClick(Sender: TObject);
    procedure btnUninstallServiceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  GBWinService.Setup.Interfaces;

procedure TfrmMain.btnInstallServiceClick(Sender: TObject);
begin
  InstallService;
end;

procedure TfrmMain.btnUninstallServiceClick(Sender: TObject);
begin
  UninstallService;
end;

end.
