program SampleVCLAndWinService;

uses
  Vcl.Forms,
  System.SysUtils,
  System.Classes,
  GBWinService.Setup.Interfaces,
  FMain in 'FMain.pas' {frmMain},
  Service.Sample in 'Service.Sample.pas';

{$R *.res}

begin
  WinServiceSetup
    .ServiceName('SampleVCL')
    .ServiceTitle('Sample VCL')
    .ServiceDetail('Test Service')
    .OnStart(OnStartService)
    .OnStop(OnStopService)
    .OnPause(OnPauseService)
    .OnExecute(onExecuteService)
    .OnCreate(OnCreateService)
    .OnDestroy(OnDestroyService)
    .OnContinue(OnContinueService)
    .OnBeforeUninstall(OnBeforeUninstallService)
    .OnBeforeInstall(OnBeforeInstallService)
    .OnAfterInstall(OnAfterInstallService)
    .OnAfterUninstall(OnAfterUninstallService);

  if not WinServiceSetup.RunAsService then
    WinServiceSetup.CreateForm(TfrmMain, frmMain);
end.
