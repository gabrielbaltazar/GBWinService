unit GBWinService.Model.Default;

interface

uses
  GBWinService.Model.Interfaces,
  GBWinService.ServiceManager,
  System.SysUtils,
  System.Generics.Collections,
  Winapi.Windows,
  Winapi.WinSvc;

type TGBWinServiceModelDefault = class(TInterfacedObject, IGBWinService)

  private
    FServiceName: PChar;
    FExeName: string;

    function getStrParams(AParams: TDictionary<String,String>): string;
    procedure ExecProcess(AExeName: string; AParams: TDictionary<String,String>; AType: TInstallType);

  protected
    function ServiceName(Value: String): IGBWinService; overload;
    function ServiceName: string; overload;

    function ExeName: string; overload;
    function ExeName(Value: String): IGBWinService; overload;

    procedure Install; overload;
    procedure Install(Params: TDictionary<string, String>); overload;

    procedure Uninstall; overload;
    procedure Uninstall(Params: TDictionary<string, String>); overload;

    procedure Start;
    procedure Stop;
    procedure Restart;
    function  IsRunnig: Boolean;

  public
    constructor create;
    destructor  Destroy; override;
    class function New: IGBWinService;
end;

implementation

{ TGBWinServiceModelDefault }

procedure TGBWinServiceModelDefault.Install;
begin
  Install(nil);
end;

constructor TGBWinServiceModelDefault.create;
begin
  FExeName := GetModuleName(HInstance);
end;

destructor TGBWinServiceModelDefault.Destroy;
begin

  inherited;
end;

procedure TGBWinServiceModelDefault.ExecProcess(AExeName: string; AParams: TDictionary<String, String>; AType: TInstallType);
var
  sParams            : string;
  StartupInfo        : TStartupInfo;
  ProcessInformation : TProcessInformation;
begin
  case AType of
    itInstall  : sParams := ' /Install';
    itUnInstall: sParams := ' /UnInstall';
  end;

  sParams := sParams + getStrParams(AParams);

  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE;

  if CreateProcess( Nil, PChar( AExeName + sParams ), Nil, Nil, False,
                           NORMAL_PRIORITY_CLASS, Nil,
                           PChar( ExtractFileDir( AExeName ) ),
                           StartupInfo, ProcessInformation ) then
  begin
    try
      WaitForSingleObject( ProcessInformation.hProcess, INFINITE);
    finally
      CloseHandle( ProcessInformation.hProcess);
      CloseHandle( ProcessInformation.hThread);
    end;
  end
  else
    Raise Exception.Create(Format('The operation %s could not executed.', [sParams]));
end;

function TGBWinServiceModelDefault.ExeName(Value: String): IGBWinService;
begin
  result := Self;
  FExeName := Value;
end;

function TGBWinServiceModelDefault.ExeName: string;
begin
  result := FExeName;
end;

function TGBWinServiceModelDefault.getStrParams(AParams: TDictionary<String, String>): string;
var
  key: string;
begin
  result := ' /Silent';

  if AParams <> nil then
  begin
    for key in AParams.Keys do
      result := result + ' ' + key + '"' + AParams.Items[key] + '"';
  end;
end;

procedure TGBWinServiceModelDefault.Install(Params: TDictionary<string, String>);
begin
  ExecProcess(FExeName, Params, itInstall);
  Sleep(2000);
end;

function TGBWinServiceModelDefault.IsRunnig: Boolean;
begin
  result := TGBWinServiceManager.IsServiceRunning(FServiceName);
end;

class function TGBWinServiceModelDefault.New: IGBWinService;
begin
  result := Self.Create;
end;

procedure TGBWinServiceModelDefault.Restart;
begin
  Stop;
  Start;
end;

function TGBWinServiceModelDefault.ServiceName(Value: String): IGBWinService;
begin
  result := Self;
  FServiceName := PChar( Value );
end;

function TGBWinServiceModelDefault.ServiceName: string;
begin
  result := FServiceName;
end;

procedure TGBWinServiceModelDefault.Start;
begin
  if TGBWinServiceManager.Singleton(FServiceName).StartService then
    Sleep(2000)
  else
    raise Exception.Create(Format('The service %s was not started', [FServiceName]));
end;

procedure TGBWinServiceModelDefault.Stop;
begin
  if TGBWinServiceManager.Singleton(FServiceName).StopService then
    Sleep(2000)
  else
    raise Exception.Create(Format('The service %s was not stopped', [FServiceName]));
end;

procedure TGBWinServiceModelDefault.Uninstall;
begin
  Uninstall(nil);
end;

procedure TGBWinServiceModelDefault.Uninstall(Params: TDictionary<string, String>);
begin
  ExecProcess(FExeName, Params, itUnInstall);
  Sleep(2000);
end;

end.
