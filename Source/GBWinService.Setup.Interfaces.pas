unit GBWinService.Setup.Interfaces;

interface

uses
  GBWinService.Model.Interfaces,
  GBWinService.Service,
  System.Classes,
  System.SysUtils,
  Vcl.Forms,
  Vcl.SvcMgr,
  Winapi.WinSvc;

type
  TOnGBWinServiceEvent = reference to procedure;

  IGBWinServiceSetup = interface
    ['{28B8F3A1-8491-4695-8F4C-97B292E0CCF1}']
    function ServiceName  (Value: String): IGBWinServiceSetup;
    function ServiceTitle (Value: string): IGBWinServiceSetup;
    function ServiceDetail(Value: String): IGBWinServiceSetup;

    function OnStart(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnStop (Value: TOnGBWinServiceEvent) : IGBWinServiceSetup;
    function OnPause(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnExecute(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnCreate(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnContinue(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnDestroy(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnShutdown(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnBeforeUninstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnBeforeInstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnAfterInstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnAfterUninstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;

    function CreateForm(Component: TComponentClass; var Reference; ReportLeaks: Boolean = True): IGBWinServiceSetup;

    function RunAsService: Boolean;
  end;

  TGBWinServiceSetup = class(TInterfacedObject, IGBWinServiceSetup)
  private
    FOnStart: TOnGBWinServiceEvent;
    FOnStop : TOnGBWinServiceEvent;
    FOnPause: TOnGBWinServiceEvent;
    FOnExecute: TOnGBWinServiceEvent;
    FOnShutdown: TOnGBWinServiceEvent;
    FOnCreate: TOnGBWinServiceEvent;
    FOnDestroy: TOnGBWinServiceEvent;
    FOnContinue: TOnGBWinServiceEvent;
    FOnBeforeInstall: TOnGBWinServiceEvent;
    FOnBeforeUninstall: TOnGBWinServiceEvent;
    FOnAfterInstall: TOnGBWinServiceEvent;
    FOnAfterUninstall: TOnGBWinServiceEvent;

    procedure OnServiceStart(Service: TService; var Started: Boolean);
    procedure OnServiceStop (Service: TService; var Stopped: Boolean);
    procedure OnServicePause(Sender: TService; var Paused: Boolean);
    procedure OnServiceExecute(Sender: TService);
    procedure OnServiceCreate(Sender: TObject);
    procedure OnServiceDestroy(Sender: TObject);
    procedure OnServiceShutdown(Sender: TService);
    procedure OnServiceContinue(Sender: TService; var Continued: Boolean);
    procedure OnServiceBeforeInstall(Sender: TService);
    procedure OnServiceBeforeUninstall(Sender: TService);
    procedure OnServiceAfterInstall(Sender: TService);
    procedure OnServiceAfterUninstall(Sender: TService);

  protected
    function ServiceName  (Value: String): IGBWinServiceSetup;
    function ServiceTitle (Value: string): IGBWinServiceSetup;
    function ServiceDetail(Value: String): IGBWinServiceSetup;

    function OnStart(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnStop (Value: TOnGBWinServiceEvent) : IGBWinServiceSetup;
    function OnPause(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnExecute(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnContinue(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnCreate(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnDestroy(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnShutdown(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnBeforeUninstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnBeforeInstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnAfterInstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnAfterUninstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;

    function CreateForm(Component: TComponentClass; var Reference; ReportLeaks: Boolean = True): IGBWinServiceSetup;

    function RunAsService: Boolean;
  public
    class function New: IGBWinServiceSetup;
  end;

function WinServiceSetup: IGBWinServiceSetup;

function IsRunning: Boolean;
procedure StartService;
procedure StopService;
procedure RestartService;
procedure InstallService;
procedure UninstallService;

var
  GBSetup: IGBWinServiceSetup;

implementation

uses
  GBWinService.Model.Default;

function IsRunning: Boolean;
begin
  result := TGBWinServiceModelDefault
              .New
              .ServiceName(GBWinService.Service.ServiceName)
              .IsRunnig;
end;

procedure StartService;
begin
  TGBWinServiceModelDefault
    .New
    .ServiceName(GBWinService.Service.ServiceName)
    .Start;
end;

procedure StopService;
begin
  TGBWinServiceModelDefault
    .New
    .ServiceName(GBWinService.Service.ServiceName)
    .Stop;
end;

procedure RestartService;
begin
  TGBWinServiceModelDefault
    .New
    .ServiceName(GBWinService.Service.ServiceName)
    .Restart;
end;

procedure InstallService;
begin
  TGBWinServiceModelDefault
    .New
    .ServiceName(GBWinService.Service.ServiceName)
    .Install;
end;

procedure UninstallService;
begin
  TGBWinServiceModelDefault
    .New
    .ServiceName(GBWinService.Service.ServiceName)
    .Uninstall;
end;

function WinServiceSetup: IGBWinServiceSetup;
begin
  if not Assigned(GBSetup) then
    GBSetup := TGBWinServiceSetup.New;
  result := GBSetup;
end;

{ TGBWinServiceSetup }

function TGBWinServiceSetup.CreateForm(Component: TComponentClass; var Reference; ReportLeaks: Boolean = True): IGBWinServiceSetup;
begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := ReportLeaks;
  {$ENDIF}

  Vcl.Forms.Application.Initialize;
  Vcl.Forms.Application.Title := GBWinService.Service.ServiceTitle;

  Application.CreateForm(Component, Reference);
  Vcl.Forms.Application.Run;
end;

class function TGBWinServiceSetup.New: IGBWinServiceSetup;
begin
  result := Self.Create;
end;

function TGBWinServiceSetup.OnAfterInstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
begin
  result := Self;
  FOnAfterInstall := Value;
end;

function TGBWinServiceSetup.OnAfterUninstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
begin
  result := Self;
  FOnAfterUninstall := Value;
end;

function TGBWinServiceSetup.OnBeforeInstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
begin
  result := Self;
  FOnBeforeInstall := Value;
end;

procedure TGBWinServiceSetup.OnServiceAfterInstall(Sender: TService);
begin
  if Assigned(FOnAfterInstall) then
    FOnAfterInstall;
end;

procedure TGBWinServiceSetup.OnServiceAfterUninstall(Sender: TService);
begin
  if Assigned(FOnAfterUninstall) then
    FOnAfterUninstall;
end;

procedure TGBWinServiceSetup.OnServiceBeforeInstall(Sender: TService);
begin
  if Assigned(FOnBeforeInstall) then
    FOnBeforeInstall;
end;

function TGBWinServiceSetup.OnBeforeUninstall(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
begin
  result := Self;
  FOnBeforeUninstall := value;
end;

procedure TGBWinServiceSetup.OnServiceBeforeUninstall(Sender: TService);
begin
  if Assigned(FOnBeforeUninstall) then
    FOnBeforeUninstall;
end;

function TGBWinServiceSetup.OnContinue(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
begin
  result := Self;
  FOnContinue := Value;
end;

function TGBWinServiceSetup.OnCreate(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
begin
  result := Self;
  FOnCreate := Value;
end;

function TGBWinServiceSetup.OnDestroy(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
begin
  result := Self;
  FOnDestroy := Value;
end;

function TGBWinServiceSetup.OnExecute(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
begin
  Result := Self;
  FOnExecute := Value;
end;

function TGBWinServiceSetup.OnPause(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
begin
  Result := Self;
  FOnPause := Value;
end;

procedure TGBWinServiceSetup.OnServiceContinue(Sender: TService; var Continued: Boolean);
begin
  if Assigned(FOnContinue) then
    FOnContinue;
end;

procedure TGBWinServiceSetup.OnServiceCreate(Sender: TObject);
begin
  if Assigned(FOnCreate) then
    FOnCreate;
end;

procedure TGBWinServiceSetup.OnServiceDestroy(Sender: TObject);
begin
  if Assigned(FOnDestroy) then
    FOnDestroy;
end;

procedure TGBWinServiceSetup.OnServiceExecute(Sender: TService);
begin
  if Assigned(FOnExecute) then
    FOnExecute;
end;

procedure TGBWinServiceSetup.OnServicePause(Sender: TService; var Paused: Boolean);
begin
  if Assigned(FOnPause) then
    FOnPause;
end;

procedure TGBWinServiceSetup.OnServiceShutdown(Sender: TService);
begin
  if Assigned(FOnShutdown) then
    FOnShutdown;
end;

procedure TGBWinServiceSetup.OnServiceStart(Service: TService; var Started: Boolean);
begin
  if Assigned(FOnStart) then
    FOnStart;
end;

procedure TGBWinServiceSetup.OnServiceStop(Service: TService; var Stopped: Boolean);
begin
  if Assigned(FOnStop) then
    FOnStop;
end;

function TGBWinServiceSetup.OnShutdown(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
begin
  result := Self;
  FOnShutdown := Value;
end;

function TGBWinServiceSetup.OnStart(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
begin
  result   := Self;
  FOnStart := Value;
end;

function TGBWinServiceSetup.OnStop(Value: TOnGBWinServiceEvent) : IGBWinServiceSetup;
begin
  result  := Self;
  FOnStop := Value;
end;

function TGBWinServiceSetup.RunAsService: Boolean;
begin
  result := False;
  if not IsDesktopMode(GBWinService.Service.ServiceName) then
  begin
    if (not Vcl.SvcMgr.Application.DelayInitialize) or (Vcl.SvcMgr.Application.Installing) then
      Vcl.SvcMgr.Application.Initialize;

    Vcl.SvcMgr.Application.Title := GBWinService.Service.ServiceTitle;

    Application.CreateForm(TGBWinService, GBWinServiceApp);

    if Assigned(FOnStart) then GBWinServiceApp.OnStart := OnServiceStart;
    if Assigned(FOnStop)  then GBWinServiceApp.OnStop  := OnServiceStop;
    if Assigned(FOnPause) then GBWinServiceApp.OnPause := OnServicePause;
    if Assigned(FOnShutdown) then GBWinServiceApp.OnShutdown := OnServiceShutdown;
    if Assigned(FOnCreate) then GBWinServiceApp.OnCreate := OnServiceCreate;
    if Assigned(FOnDestroy) then GBWinServiceApp.OnDestroy := OnServiceDestroy;
    if Assigned(FOnContinue) then GBWinServiceApp.OnContinue := OnServiceContinue;
    if Assigned(FOnBeforeInstall) then GBWinServiceApp.BeforeInstall := OnServiceBeforeInstall;
    if Assigned(FOnBeforeUninstall) then GBWinServiceApp.BeforeUninstall := OnServiceBeforeUninstall;
    if Assigned(FOnAfterUninstall) then GBWinServiceApp.AfterUninstall := OnServiceAfterUninstall;
    if Assigned(FOnAfterInstall) then GBWinServiceApp.SetOnAfterInstall( OnServiceAfterInstall );
    if Assigned(FOnExecute) then GBWinServiceApp.SetOnExecute( OnServiceExecute );

    Vcl.SvcMgr.Application.Run;
    result := True;
  end;
end;

function TGBWinServiceSetup.ServiceDetail(Value: String): IGBWinServiceSetup;
begin
  result := Self;
  GBWinService.Service.ServiceDetail := Value;
end;

function TGBWinServiceSetup.ServiceName(Value: String): IGBWinServiceSetup;
begin
  result := Self;
  GBWinService.Service.ServiceName := Value;
end;

function TGBWinServiceSetup.ServiceTitle(Value: string): IGBWinServiceSetup;
begin
  result := Self;
  GBWinService.Service.ServiceTitle := Value;
end;

end.
