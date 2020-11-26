program SampleVCLAndWinService;

uses
  Vcl.Forms,
  System.SysUtils,
  System.Classes,
  GBWinService.Setup.Interfaces,
  FMain in 'FMain.pas' {frmMain};

{$R *.res}

begin
  WinServiceSetup
    .ServiceName('SampleVCL')
    .ServiceTitle('Sample VCL')
    .ServiceDetail('Test Service')
    .OnStart(
      procedure
      var
        fileLog : TStringList;
        fileName: string;
      begin
        fileName := ExtractFilePath(GetModuleName(HInstance)) + 'sample.txt';
        fileLog := TStringList.Create;
        try
          if FileExists(fileName) then
            fileLog.LoadFromFile(fileName);
          fileLog.Add('startou');
          fileLog.SaveToFile( fileName );
        finally
          fileLog.Free;
        end;
      end
    );

  if not WinServiceSetup.RunAsService then
    WinServiceSetup.CreateForm(TfrmMain, frmMain);
end.
