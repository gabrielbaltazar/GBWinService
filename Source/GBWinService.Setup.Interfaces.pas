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
  TOnGBWinServiceStart = reference to procedure;
  TOnGBWinServiceStop  = reference to procedure;

  IGBWinServiceSetup = interface
    ['{28B8F3A1-8491-4695-8F4C-97B292E0CCF1}']
    function ServiceName  (Value: String): IGBWinServiceSetup;
    function ServiceTitle (Value: string): IGBWinServiceSetup;
    function ServiceDetail(Value: String): IGBWinServiceSetup;

    function OnStart(Value: TOnGBWinServiceStart): IGBWinServiceSetup;
    function OnStop (Value: TOnGBWinServiceStop) : IGBWinServiceSetup;

    function CreateForm(Component: TComponentClass; var Reference; ReportLeaks: Boolean = True): IGBWinServiceSetup;

    function RunAsService: Boolean;
  end;

  TGBWinServiceSetup = class(TInterfacedObject, IGBWinServiceSetup)
  private
    FOnStart: TOnGBWinServiceStart;
    FOnStop : TOnGBWinServiceStop;

    procedure OnServiceStart(Service: TService; var Started: Boolean);
    procedure OnServiceStop (Service: TService; var Stopped: Boolean);

  protected
    function ServiceName  (Value: String): IGBWinServiceSetup;
    function ServiceTitle (Value: string): IGBWinServiceSetup;
    function ServiceDetail(Value: String): IGBWinServiceSetup;

    function OnStart(Value: TOnGBWinServiceStart): IGBWinServiceSetup;
    function OnStop (Value: TOnGBWinServiceStop) : IGBWinServiceSetup;

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

procedure TGBWinServiceSetup.OnServiceStart(Service: TService; var Started: Boolean);
begin
  FOnStart;
end;

procedure TGBWinServiceSetup.OnServiceStop(Service: TService; var Stopped: Boolean);
begin
  FOnStop;
end;

function TGBWinServiceSetup.OnStart(Value: TOnGBWinServiceStart): IGBWinServiceSetup;
begin
  result   := Self;
  FOnStart := Value;
end;

function TGBWinServiceSetup.OnStop(Value: TOnGBWinServiceStop): IGBWinServiceSetup;
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
