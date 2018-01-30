unit RRManagerEditObjectVersionFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBaseGUI, StdCtrls, Mask, ToolEdit, RRManagerObjects, RRManagerBaseObjects;

type
//  TfrmEditObjectVersion = class(TFrame)
  TfrmEditObjectVersion = class(TBaseFrame)
    gbxVersionInfo: TGroupBox;
    Label1: TLabel;
    edtVersionName: TEdit;
    Label2: TLabel;
    dtedtVersionDate: TDateEdit;
    Label3: TLabel;
    mmVersionReason: TMemo;
  private
    { Private declarations }
    function GetVersion: TOldVersion;
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure FillParentControls; override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property Version: TOldVersion read GetVersion;

    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
    procedure   CancelEdit; override;
  end;

implementation

uses RRManagerCommon, Facade;

{$R *.dfm}

{ TfrmEditObjectVersion }

procedure TfrmEditObjectVersion.CancelEdit;
begin
  inherited;
  EditingClass := TOldVersion;
end;

procedure TfrmEditObjectVersion.ClearControls;
begin
  edtVersionName.Clear;
  dtedtVersionDate.Date := Date;
  mmVersionReason.Clear;
end;

constructor TfrmEditObjectVersion.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TfrmEditObjectVersion.FillControls(ABaseObject: TBaseObject);
var v: TOldVersion;
begin
  if not Assigned(ABaseObject) then
    ClearControls
  else
  begin
    v := ABaseObject as TOldVersion;

    edtVersionName.Text := v.VersionName;
    edtVersionName.Text := v.VersionReason;
    dtedtVersionDate.Date := v.VersionDate;
  end;
end;

procedure TfrmEditObjectVersion.FillParentControls;
begin


end;

function TfrmEditObjectVersion.GetVersion: TOldVersion;
begin
  Result := EditingObject as TOldVersion;
end;

procedure TfrmEditObjectVersion.RegisterInspector;
begin
  inherited;
  // регистрируем контролы, которые под инспектором
  Inspector.Add(edtVersionName, nil, ptString, 'наименование версии', false);
end;

procedure TfrmEditObjectVersion.Save;
begin
  inherited;

  if not Assigned(EditingObject) then
    FEditingObject := (TMainFacade.GetInstance as TMainFacade).AllVersions.Add;

  Version.VersionName := edtVersionName.Text;
  Version.VersionDate := dtedtVersionDate.Date;
  Version.VersionReason := mmVersionReason.Text;
end;

end.
