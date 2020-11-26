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

    function CreateForm(Component: TComponentClass; var Reference; ReportLeaks: Boolean = True): IGBWinServiceSetup;

    function RunAsService: Boolean;
  end;

  TGBWinServiceSetup = class(TInterfacedObject, IGBWinServiceSetup)
  private
    FOnStart: TOnGBWinServiceEvent;
    FOnStop : TOnGBWinServiceEvent;
    FOnPause: TOnGBWinServiceEvent;
    FOnExecute: TOnGBWinServiceEvent;

    procedure OnServiceStart(Service: TService; var Started: Boolean);
    procedure OnServiceStop (Service: TService; var Stopped: Boolean);
    procedure OnServicePause(Sender: TService; var Paused: Boolean);
    procedure OnServiceExecute(Sender: TService);

  protected
    function ServiceName  (Value: String): IGBWinServiceSetup;
    function ServiceTitle (Value: string): IGBWinServiceSetup;
    function ServiceDetail(Value: String): IGBWinServiceSetup;

    function OnStart(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnStop (Value: TOnGBWinServiceEvent) : IGBWinServiceSetup;
    function OnPause(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;
    function OnExecute(Value: TOnGBWinServiceEvent): IGBWinServiceSetup;

    function CreateForm(Component: TComponentClass; var Reference; ReportLeaks: Boolean = True): IGBWinServiceSetup;

    function RunAsService: Boolean;
  public
    class function New: IGBWinServiceSetup;
  end;

function WinServiceSetup: IGBWinServiceSetup;

procedure InstallService;
procedure UninstallService;

var
  GBSetup: IGBWinServiceSetup;

implementation

uses
  GBWinService.Model.Default;

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
