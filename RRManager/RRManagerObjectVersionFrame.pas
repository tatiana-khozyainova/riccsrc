unit RRManagerObjectVersionFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RRManagerLoaderCommands, RRmanagerObjects, RRManagerBaseObjects,
  RRManagerBaseGUI, Version;

type

  TfrmObjectVersion = class(TFrame)
    gbxVersion: TGroupBox;
    cmbxVersion: TComboBox;
    procedure cmbxVersionChange(Sender: TObject);
  private
    { Private declarations }
    FVersions: TVersions;
    FOnChangeVersion: TNotifyEvent;
    procedure SetVersions(const Value: TVersions);
    function GetVersion: TVersion;
    function GetSQL: string;
  public
    { Public declarations }
    procedure   Reload;
    property    SQL: string read GetSQL;
    property    OnChangeVersion: TNotifyEvent read FOnChangeVersion write FOnChangeVersion;
    property    Versions: TVersions read FVersions write SetVersions;
    property    Version: TVersion read GetVersion;
    constructor Create(AOwner: TComponent); override;
  end;



implementation

uses RRManagerCommon, Facade;

{$R *.dfm}

{ TVersionLoadAction }



constructor TfrmObjectVersion.Create(AOwner: TComponent);
begin
  inherited;
end;

function TfrmObjectVersion.GetSQL: string;
begin
  Result := 'Version_ID = ' + IntToStr(Version.ID);
end;

function TfrmObjectVersion.GetVersion: TVersion;
begin
  Result := TVersion(cmbxVersion.Items.Objects[cmbxVersion.ItemIndex]);
end;

procedure TfrmObjectVersion.SetVersions(const Value: TVersions);
begin
  FVersions := Value;
  // и сразу грузим
end;





procedure TfrmObjectVersion.cmbxVersionChange(Sender: TObject);
begin
  (TMainFacade.GetInstance as TMainFacade).ActiveVersion := Version;
  if Assigned(FOnChangeVersion) then FOnChangeVersion(Sender);
end;

procedure TfrmObjectVersion.Reload;
begin
  cmbxVersion.Clear;
  (TMainFacade.GetInstance as TMainFacade).AllVersions.MakeList(cmbxVersion.Items, AllOpts.Current.ListOption, AllOpts.Current.ShowUINs);
  cmbxVersion.ItemIndex := cmbxVersion.Items.IndexOfObject((TMainFacade.GetInstance as TMainFacade).ActiveVersion); 
end;

end.

