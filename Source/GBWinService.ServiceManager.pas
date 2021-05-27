unit GBWinService.ServiceManager;

interface

uses
  GBWinService.Model.Interfaces,
  System.SysUtils,
  Winapi.Windows,
  Winapi.Winsvc;

type
  TGBWinServiceManager = class
  private
    { Private declarations }
    ServiceControlManager: SC_Handle;
    ServiceHandle: SC_Handle;
  protected
    function DoStartService(NumberOfArgument: DWORD; ServiceArgVectors: PChar): Boolean;
  public
    { Public declarations }
    function Connect(MachineName: PChar = nil; DatabaseName: PChar = nil;
      Access: DWORD = SC_MANAGER_ALL_ACCESS): Boolean;  // Access may be SC_MANAGER_ALL_ACCESS
    function OpenServiceConnection(ServiceName: PChar): Boolean;
    function StartService: Boolean; overload; // Simple start
    function StartService(NumberOfArgument: DWORD; ServiceArgVectors: PChar): Boolean; overload; // More complex start

    function StopService: Boolean;
    procedure PauseService;
    procedure ContinueService;
    procedure ShutdownService;
    procedure DisableService;
    function GetStatus: DWORD;
    function ServiceRunning: Boolean;
    function ServiceStopped: Boolean;

    Class Function Singleton(AServiceName: String) : TGBWinServiceManager;
    Class Procedure FreeSingleton(AServiceName: String);

    class function IsServiceRunning(ServiceName : PWideChar): Boolean;
    class function IsDesktopMode(ServiceName :PWideChar) : Boolean;

    destructor Destroy; override;
  end;

implementation

var
  ServiceMng : TGBWinServiceManager;

{ TGBWinServiceManager }

function TGBWinServiceManager.Connect(MachineName, DatabaseName: PChar; Access: DWORD): Boolean;
begin
  { open a connection to the windows service manager }
  ServiceControlManager := OpenSCManager(MachineName, DatabaseName, Access);
  Result := (ServiceControlManager <> 0);
end;

function TGBWinServiceManager.OpenServiceConnection(ServiceName: PChar): Boolean;
begin
  { open a connetcion to a specific service }
  ServiceHandle := OpenService(ServiceControlManager, ServiceName, SERVICE_ALL_ACCESS);
  Result := (ServiceHandle <> 0);
end;

procedure TGBWinServiceManager.PauseService;
var
  ServiceStatus: TServiceStatus;
begin
  { Pause the service: attention not supported by all services }
  ControlService(ServiceHandle, SERVICE_CONTROL_PAUSE, ServiceStatus);
end;

function TGBWinServiceManager.StopService: Boolean;
var
  ServiceStatus: TServiceStatus;
begin
  { Stop the service }
  Result := ControlService(ServiceHandle, SERVICE_CONTROL_STOP, ServiceStatus);
end;

procedure TGBWinServiceManager.ContinueService;
var
  ServiceStatus: TServiceStatus;
begin
  { Continue the service after a pause: attention not supported by all services }
  ControlService(ServiceHandle, SERVICE_CONTROL_CONTINUE, ServiceStatus);
end;

procedure TGBWinServiceManager.ShutdownService;
var
  ServiceStatus: TServiceStatus;
begin
  { Shut service down: attention not supported by all services }
  ControlService(ServiceHandle, SERVICE_CONTROL_SHUTDOWN, ServiceStatus);
end;

function TGBWinServiceManager.StartService: Boolean;
begin
  Result := DoStartService(0, '');
end;

function TGBWinServiceManager.StartService(NumberOfArgument: DWORD;
  ServiceArgVectors: PChar): Boolean;
begin
  Result := DoStartService(NumberOfArgument, ServiceArgVectors);
end;

function TGBWinServiceManager.GetStatus: DWORD;
var
  ServiceStatus: TServiceStatus;
begin
{ Returns the status of the service. Maybe you want to check this
  more than once, so just call this function again.
  Results may be: SERVICE_STOPPED
                  SERVICE_START_PENDING
                  SERVICE_STOP_PENDING
                  SERVICE_RUNNING
                  SERVICE_CONTINUE_PENDING
                  SERVICE_PAUSE_PENDING
                  SERVICE_PAUSED   }

  QueryServiceStatus(ServiceHandle, ServiceStatus);
  Result := ServiceStatus.dwCurrentState;
end;

class function TGBWinServiceManager.IsDesktopMode(ServiceName: PWideChar): Boolean;
begin
  if (Win32Platform <> VER_PLATFORM_WIN32_NT) or FindCmdLineSwitch('P',['-', '/'], True) or
     ((not FindCmdLineSwitch('INSTALL', ['-', '/'], True)) and
      (not FindCmdLineSwitch('UNINSTALL', ['-', '/'], True)) and
      (not FindCmdLineSwitch('RUNSERVICE', ['-', '/'], True))and
      (not FindCmdLineSwitch('RESTART', ['-', '/'], True))) then
    Result := True
  else
  begin
    Result := not FindCmdLineSwitch('INSTALL', ['-', '/'], True)    and
              not FindCmdLineSwitch('UNINSTALL', ['-', '/'], True)  and
              not FindCmdLineSwitch('RUNSERVICE', ['-', '/'], True) and
              not FindCmdLineSwitch('RESTART', ['-', '/'], True) ;
  end;


//  if (Win32Platform <> VER_PLATFORM_WIN32_NT) or FindCmdLineSwitch('p',['-', '/'], True) then // standard
//    Result := True
//  else
//    Result := not FindCmdLineSwitch('INSTALL', ['-', '/'], True) and
//                     not FindCmdLineSwitch('UNINSTALL', ['-', '/'], True) and
//                     not IsServiceRunning(ServiceName);
end;

class function TGBWinServiceManager.IsServiceRunning(ServiceName: PWideChar): Boolean;
var
  Svc: Integer;
  SvcMgr: Integer;
  ServSt: TServiceStatus;
begin

  Result := False;
  SvcMgr := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
  if SvcMgr = 0 then
    Exit;
  try
    Svc := OpenService (SvcMgr, ServiceName, SERVICE_QUERY_STATUS);
    if Svc = 0 then
      Exit;
    try
      if not QueryServiceStatus (Svc, ServSt) then
        Exit;
      Result := (ServSt.dwCurrentState = SERVICE_RUNNING) or (ServSt.dwCurrentState = SERVICE_START_PENDING);
    finally
      CloseServiceHandle(Svc);
    end;
  finally
    CloseServiceHandle(SvcMgr);
  end;
end;

destructor TGBWinServiceManager.Destroy;
begin
//  FreeAndNil(ServiceControlManager);
  inherited;
end;

procedure TGBWinServiceManager.DisableService;
begin
  { Implementation is following... }
end;

function TGBWinServiceManager.ServiceRunning: Boolean;
begin
  Result := (GetStatus = SERVICE_RUNNING);
end;

function TGBWinServiceManager.ServiceStopped: Boolean;
begin
  Result := (GetStatus = SERVICE_STOPPED);
end;

function TGBWinServiceManager.DoStartService(NumberOfArgument: DWORD;
  ServiceArgVectors: PChar): Boolean;
begin
  Result := Winapi.WinSvc.StartService(ServiceHandle, NumberOfArgument, ServiceArgVectors);
end;

class function TGBWinServiceManager.Singleton(AServiceName: String): TGBWinServiceManager;
begin

  if not ( Assigned( ServiceMng ) ) then
    begin
      ServiceMng := TGBWinServiceManager.Create;
      ServiceMng.Connect( '', Nil, SC_MANAGER_CONNECT );
      ServiceMng.OpenServiceConnection( PChar ( AServiceName ) );
    end;
  Result := ServiceMng;
end;

class procedure TGBWinServiceManager.FreeSingleton(AServiceName: String);
begin
  TGBWinServiceManager.Singleton(AServiceName).Free;
  ServiceMng := Nil;
end;

initialization

finalization
  TGBWinServiceManager.FreeSingleton(EmptyStr);

end.
