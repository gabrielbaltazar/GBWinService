unit Service.Sample;

interface

uses
  System.SysUtils,
  System.Classes;

procedure OnStartService;
procedure OnStopService;
procedure OnPauseService;
procedure OnExecuteService;
procedure OnShutdownService;
procedure OnCreateService;
procedure OnDestroyService;
procedure OnContinueService;
procedure OnBeforeInstallService;
procedure OnBeforeUninstallService;
procedure OnAfterInstallService;
procedure OnAfterUninstallService;

function FileLogName: string;
procedure WriteLog(ALog: String);

implementation

procedure OnAfterInstallService;
begin
  WriteLog('Service After Install');
end;

procedure OnAfterUninstallService;
begin
  WriteLog('Service After Uninstall');
end;

procedure OnBeforeInstallService;
begin
  WriteLog('Service Before Install');
end;

procedure OnBeforeUninstallService;
begin
  WriteLog('Service Before Uninstall');
end;

procedure OnContinueService;
begin
  WriteLog('Service Continue');
end;

procedure OnCreateService;
begin
  WriteLog('Service Created');
end;

procedure OnDestroyService;
begin
  WriteLog('Service Destroy');
end;

procedure OnStartService;
begin
  WriteLog('Service Started');
end;

procedure OnStopService;
begin
  WriteLog('Service Stopped');
end;

procedure OnPauseService;
begin
  WriteLog('Service Paused');
end;

procedure OnExecuteService;
begin
  WriteLog('Service Execute');
end;

procedure OnShutdownService;
begin
  WriteLog('Service Shutdown');
end;

function FileLogName: string;
begin
  Result := ExtractFilePath(GetModuleName(HInstance)) + 'sample.log';
end;

procedure WriteLog(ALog: String);
var
  fileName: string;
begin
  fileName := FileLogName;
  with TStringList.Create do
  try
    if FileExists(FileName) then
      LoadFromFile(fileName);

    Add(FormatDateTime('yyyy-MM-dd hh:mm:ss', now) + ' ' + ALog);
    SaveToFile(fileName);
  finally
    Free;
  end;
end;

end.
