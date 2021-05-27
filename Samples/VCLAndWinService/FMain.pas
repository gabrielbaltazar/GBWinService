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
    btnStart: TButton;
    btnStop: TButton;
    btnRestart: TButton;
    btnIsRunning: TButton;
    procedure btnInstallServiceClick(Sender: TObject);
    procedure btnUninstallServiceClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnRestartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnIsRunningClick(Sender: TObject);
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
  ShowMessage('Service Installed');
end;

procedure TfrmMain.btnIsRunningClick(Sender: TObject);
begin
  if IsRunning then
    ShowMessage('Service is running')
  else
    ShowMessage('Service is not running');
end;

procedure TfrmMain.btnRestartClick(Sender: TObject);
begin
  RestartService;
  ShowMessage('Service Restarted');
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  StartService;
  ShowMessage('Service Started');
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  StopService;
  ShowMessage('Service Stopped');
end;

procedure TfrmMain.btnUninstallServiceClick(Sender: TObject);
begin
  UninstallService;
  ShowMessage('Service Uninstalled');
end;

end.
