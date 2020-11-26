unit GBWinService.Service;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Win.Registry,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.SvcMgr;

type
  TGBWinService = class(TService)
    procedure ServiceExecute(Sender: TService);
    procedure ServiceAfterInstall(Sender: TService);
  private
    FOnExecute: TServiceEvent;
    FOnAfterInstall: TServiceEvent;

    procedure saveDetails;
    procedure saveDetailsAfterInstall;

  public
    procedure SetOnExecute(Value: TServiceEvent);
    procedure SetOnAfterInstall(Value: TServiceEvent);

    constructor Create(AOwner: TComponent); override;
    function GetServiceController: TServiceController; override;
    { Public declarations }

  end;

var
  GBWinServiceApp : TGBWinService;
  ServiceName     : string;
  ServiceTitle    : string;
  ServiceDetail   : string;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  GBWinServiceApp.Controller(CtrlCode);
end;

{ TDataModule2 }

constructor TGBWinService.Create(AOwner: TComponent);
begin
  inherited;
  Self.Name        := ServiceName;
  Self.DisplayName := ServiceTitle;
end;

function TGBWinService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TGBWinService.saveDetails;
var
  regEdit : TRegistry;
begin
  if ServiceDetail.IsEmpty then
    Exit;

  regEdit := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    regEdit.RootKey := HKEY_LOCAL_MACHINE;
    if regEdit.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Name, False) then
    begin
      regEdit.WriteString('Description', ServiceDetail);
      regEdit.WriteInteger('ErrorControl', 2);
//      regEdit.WriteString('ImagePath', FConfig.infoSO.path + ExtractFileName(Application.Name));
      regEdit.CloseKey;
    end;
  finally
    regEdit.Free;
  end;
end;

procedure TGBWinService.saveDetailsAfterInstall;
var
  reg : TRegIniFile;
begin
  if ServiceDetail.IsEmpty then
    Exit;

  saveDetails;
  Reg := TRegIniFile.Create(KEY_ALL_ACCESS);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\Eventlog\Application\' + Name, True) then
    begin
      TRegistry(Reg).WriteString('EventMessageFile', ParamStr(0));
      TRegistry(Reg).WriteInteger('TypesSupported', 7);
      TRegistry(Reg).WriteString('Description', ServiceDetail);
    end;

    if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Name, True) then
    begin
      if FindCmdLineSwitch('NOVALIDATE', ['-', '/'], True) then
        TRegistry(Reg).WriteString('ImagePath', GetModuleName(HInstance) + ' -NOVALIDATE')
      Else
        TRegistry(Reg).WriteString('ImagePath', GetModuleName(HInstance) +  ' -RunService' );
    end;

  finally
    Reg.Free;
  end;
end;

procedure TGBWinService.ServiceAfterInstall(Sender: TService);
begin
  saveDetailsAfterInstall;
  if Assigned(FOnAfterInstall) then
    FOnAfterInstall(Sender);
end;

procedure TGBWinService.ServiceExecute(Sender: TService);
begin
  while not self.Terminated do
    ServiceThread.ProcessRequests(true);

  if Assigned(FOnExecute) then
    FOnExecute(Sender);
end;

procedure TGBWinService.SetOnAfterInstall(Value: TServiceEvent);
begin
  FOnAfterInstall := Value;
end;

procedure TGBWinService.SetOnExecute(Value: TServiceEvent);
begin
  FOnExecute := Value;
end;

end.
