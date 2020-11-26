unit FMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  GBWinService.Setup.Interfaces, Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  InstallService;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  UninstallService;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
//  ShowMessage( Application.ExeName );
  
end;

end.
