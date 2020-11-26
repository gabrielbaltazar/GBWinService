unit GBWinService.Model.Interfaces;

interface

uses
  System.Generics.Collections;

type
  TInstallType = ( itInstall, itUninstall );

  IGBWinService = interface
    ['{3FB2DA99-5CC1-4F38-ADFD-A4554896323E}']
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
  end;

function IsDesktopMode(ServiceName: String): Boolean;

implementation

uses
  GBWinService.ServiceManager;

function IsDesktopMode(ServiceName: String): Boolean;
begin
  result := TGBWinServiceManager.IsDesktopMode(PChar(ServiceName));
end;

end.
