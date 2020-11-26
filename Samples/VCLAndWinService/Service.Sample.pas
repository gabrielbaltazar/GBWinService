unit Service.Sample;

interface

uses
  System.SysUtils,
  System.Classes;

procedure OnStartService;
procedure OnStopService;

function FileLogName: string;
procedure WriteLog(ALog: String);

implementation

procedure OnStartService;
begin
  WriteLog('Service Started');
end;

procedure OnStopService;
begin
  WriteLog('Service Stopped');
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
