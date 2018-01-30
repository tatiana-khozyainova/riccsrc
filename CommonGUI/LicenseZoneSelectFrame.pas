unit LicenseZoneSelectFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LicenseZone, Facade, StdCtrls, ActnList, Buttons;

type
  TfrmLicenseZoneSelect = class(TFrame)
    lblCount: TLabel;
    grpLZSelect: TGroupBox;
    actlstLZSeach: TActionList;
    actSeach: TAction;
    cmbxLicenseZones: TComboBox;
    edtLZSeach: TEdit;
    act2: TAction;
    act1: TAction;
    btnPrev: TSpeedButton;
    btnNext: TSpeedButton;
    btnSearch: TSpeedButton;
    procedure act1PrevExecute(Sender : TObject);
    procedure act2NextExecute(Sender : TObject);
    procedure act1PrevUpdate(Sender : TObject);
    procedure act2NextUpdate(Sender : TObject);
    procedure actSeachExecute(Sender : TObject);
    procedure edtLZSeachEnter(Sender: TObject);
    procedure cmbxLicenseZonesChange(Sender: TObject);
    procedure actSeachUpdate(Sender: TObject);
  private
    { Private declarations }
    CurrentIndex: Integer;
    NewFrame: boolean;
    function GetActiveLicenseZone: TLicenseZone;
    procedure SetActiveLicenseZone(const Value: TLicenseZone);

  public
    { Public declarations }
    property    ActiveLicenseZone: TLicenseZone read GetActiveLicenseZone write SetActiveLicenseZone;
    procedure   PrepareLicenseZones;

  end;

implementation

{$R *.dfm}

{ TfrmLicenseZoneSelect }

procedure TfrmLicenseZoneSelect.PrepareLicenseZones;
begin
  CurrentIndex := 0;
  TMainFacade.GetInstance.AllLicenseZones.MakeList(cmbxLicenseZones.Items);
  lblCount.Caption := IntToStr(TMainFacade.GetInstance.AllLicenseZones.Count);
  NewFrame := true;
  edtLZSeach.Font.Color := clSilver;
  edtLZSeach.Text := 'Введите название лицензионного участка';
  //btnLZSeach.Default := true;
end;


procedure TfrmLicenseZoneSelect.act1PrevExecute(Sender : TObject);
begin
  cmbxLicenseZones.ItemIndex := cmbxLicenseZones.ItemIndex - 1;
  cmbxLicenseZonesChange(cmbxLicenseZones);
end;

procedure TfrmLicenseZoneSelect.act2NextExecute(Sender : Tobject);
begin
  cmbxLicenseZones.ItemIndex := cmbxLicenseZones.ItemIndex + 1;
  cmbxLicenseZonesChange(cmbxLicenseZones);
end;

procedure TfrmLicenseZoneSelect.act1PrevUpdate(Sender : TObject);
begin
   act1.Enabled := cmbxLicenseZones.ItemIndex > 0;
end;

procedure TfrmLicenseZoneSelect.act2NextUpdate(Sender : TObject);
begin
  act2.Enabled := cmbxLicenseZones.ItemIndex < cmbxLicenseZones.Items.Count - 1;
end;

procedure TfrmLicenseZoneSelect.actSeachExecute(Sender : TObject);
var
    i: integer;
    b: boolean;
begin
  b := false;
  for i := CurrentIndex to  cmbxLicenseZones.Items.Count - 1 do
  begin
    if Pos(AnsiUpperCase(edtLZSeach.Text), AnsiUpperCase(cmbxLicenseZones.Items[i])) > 0 then
    begin
      cmbxLicenseZones.ItemIndex := i;
      cmbxLicenseZonesChange(cmbxLicenseZones);
      CurrentIndex := i + 1;
      b := true;
      break;
    end;
  end;

  if not b then CurrentIndex := 0;
end;

 procedure TfrmLicenseZoneSelect.edtLZSeachEnter(Sender: TObject);
begin
  if NewFrame then
  begin
    edtLZSeach.Text := '';
    edtLZSeach.Font.Color := clBlack;
    NewFrame := false;
  end;
end;

procedure TfrmLicenseZoneSelect.cmbxLicenseZonesChange(Sender: TObject);
begin
  TMainFacade.GetInstance.ActiveLicenseZone := ActiveLicenseZone;
end;

function TfrmLicenseZoneSelect.GetActiveLicenseZone: TLicenseZone;
begin
  Result := cmbxLicenseZones.Items.Objects[cmbxLicenseZones.ItemIndex] as  TLicenseZone;
end;

procedure TfrmLicenseZoneSelect.SetActiveLicenseZone(const Value: TLicenseZone);
begin
     cmbxLicenseZones.ItemIndex := cmbxLicenseZones.Items.IndexOfObject(Value);
end;

procedure TfrmLicenseZoneSelect.actSeachUpdate(Sender: TObject);
begin
   actSeach.Enabled := (edtLZSeach.Font.Color = clBlack) and (edtLZSeach.Text <> '');
end;

end.
