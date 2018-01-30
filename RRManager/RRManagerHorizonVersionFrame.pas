unit RRManagerHorizonVersionFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBaseGUI, StdCtrls, ComCtrls, RRManagerObjects, CheckLst, 
  RRManagerBaseObjects;

type
//TfrmHorizonVersion = class(TFrame)
  TfrmHorizonVersion = class(TBaseFrame)
    gbxVersion: TGroupBox;
    Label1: TLabel;
    edtYear: TEdit;
    Label2: TLabel;
    chbxCounting: TCheckBox;
    chlbxFund: TCheckListBox;
    Label3: TLabel;
    cmbxComment: TComboBox;
  private
    { Private declarations }
    procedure ClearCheck;
    function  GetHorizon: TOldHorizon;
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;    
  public
    { Public declarations }
    property Horizon: TOldHorizon read GetHorizon;
    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
  end;

implementation

uses FramesWizard, Facade;

{$R *.dfm}

{ TfrmHorizonVersion }

procedure TfrmHorizonVersion.ClearCheck;
var i: integer;
begin
  for i := 0 to chlbxFund.Count - 1 do
    chlbxFund.Checked[i] := false;
end;

procedure TfrmHorizonVersion.ClearControls;
begin
  edtYear.Clear;
  cmbxComment.Text := '';
  chbxCounting.Checked := false;
  ClearCheck;
end;

constructor TfrmHorizonVersion.Create(AOwner: TComponent);
begin
  inherited;

  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(chlbxFund.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('TBL_STRUCTURE_FUND_TYPE_DICT'));
end;

procedure TfrmHorizonVersion.FillControls(ABaseObject: TBaseObject);
var i, iIndex: integer;
    h: TOldHorizon;
begin
  if not Assigned(ABaseObject) then H := Horizon
  else H := ABaseObject as TOldHorizon;

  // загрузить старые комменты
  edtYear.Text := H.InvestigationYear;
  cmbxComment.Text := H.Comment;
  chbxCounting.Checked := H.Active;
  ClearCheck;
  for i := 0 to H.FundTypes.Count - 1 do
  begin
    iIndex := chlbxFund.Items.IndexOfObject(TObject(H.FundTypes.Items[i].ID));
    if iIndex > -1 then chlbxFund.Checked[iIndex] := true;
  end;
end;

procedure TfrmHorizonVersion.FillParentControls;
begin
  inherited;
end;

function TfrmHorizonVersion.GetHorizon: TOldHorizon;
begin
  Result := EditingObject as TOldHorizon;
end;

procedure TfrmHorizonVersion.RegisterInspector;
begin
  inherited;

end;

procedure TfrmHorizonVersion.Save;
var i: integer;
    ft: TOldFundType;
begin
 if not Assigned(EditingObject) then
    // если что берем объект из предыдущего фрэйма
    FEditingObject := ((Owner as TDialogFrame).Frames[0] as TBaseFrame).EditingObject;

  Horizon.InvestigationYear := edtYear.Text;
  Horizon.Comment := cmbxComment.Text;
  Horizon.Active := chbxCounting.Checked;
  Horizon.FundTypes.Clear;
  for i := 0 to chlbxFund.Items.Count - 1 do
  if chlbxFund.Checked[i] then
  begin
    ft := Horizon.FundTypes.Add;
    ft.ID := Integer(chlbxFund.Items.Objects[i]);
    ft.FundTypeName := chlbxFund.Items[i];
  end;
end;

end.
