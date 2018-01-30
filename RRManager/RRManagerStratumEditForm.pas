unit RRManagerStratumEditForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CommonComplexCombo, StdCtrls, ExtCtrls, Buttons,
  ActnList, ImgList, ClientDicts, BaseDicts
  {$IFDEF VER150}
  , Variants
  {$ENDIF}
  ;


type
  TfrmEditStratum = class(TDictEditForm)
    gbxContainment: TGroupBox;
    pnlButtons: TPanel;
    lbxContainedStratons: TListBox;
    sbtnRight: TSpeedButton;
    sbtnLeft: TSpeedButton;
    sbtnFullLeft: TSpeedButton;
    btnOK: TButton;
    btnCancel: TButton;
    actnEditStratum: TActionList;
    MoveRight: TAction;
    MoveLeft: TAction;
    MoveAllLeft: TAction;
    pnlLeft: TPanel;
    lbxAllStratons: TListBox;
    edtSearch: TEdit;
    Label2: TLabel;
    imgList: TImageList;
    Panel1: TPanel;
    Label1: TLabel;
    edtStratumName: TEdit;
    cmplxHorizon: TfrmComplexCombo;
    actnOK: TAction;
    procedure FormCreate(Sender: TObject);
    procedure MoveRightExecute(Sender: TObject);
    procedure MoveRightUpdate(Sender: TObject);
    procedure MoveLeftExecute(Sender: TObject);
    procedure MoveLeftUpdate(Sender: TObject);
    procedure MoveAllLeftExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure cmplxHorizonbtnShowAdditionalClick(Sender: TObject);
    procedure actnOKUpdate(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure SetDict(const Value: TDict); override;
  public
    { Public declarations }
    procedure ClearControls; override;
    procedure SaveValues; override;
    procedure AdditionalSave; override;
  end;

var
  frmEditStratum: TfrmEditStratum;

implementation

uses Facade;

{$R *.DFM}

{ TStratumEditForm }

procedure TfrmEditStratum.SetDict(const Value: TDict);
begin
  FDict := Value;
  ClearControls;
end;




procedure TfrmEditStratum.FormCreate(Sender: TObject);
begin
  cmplxHorizon.Caption := 'Горизонт';
  cmplxHorizon.FullLoad := true;
  cmplxHorizon.DictName := 'TBL_STRATUM';

  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(lbxAllStratons.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('TBL_STRATIGRAPHY_NAME_DICT'));
  lbxAllStratons.Sorted := true;
  Width := 700;
  Height := 500;
end;

procedure TfrmEditStratum.MoveRightExecute(Sender: TObject);
begin
  with lbxAllStratons do
  begin
    lbxContainedStratons.ItemIndex := lbxContainedStratons.Items.IndexOfObject(Items.Objects[ItemIndex]);
    if lbxContainedStratons.ItemIndex = -1 then
      lbxContainedStratons.ItemIndex := lbxContainedStratons.Items.AddObject(Items[ItemIndex], Items.Objects[ItemIndex]);
    lbxContainedStratons.Sorted := true;  
  end;
end;

procedure TfrmEditStratum.MoveRightUpdate(Sender: TObject);
begin
  MoveRight.Enabled := lbxAllStratons.ItemIndex > -1;
end;

procedure TfrmEditStratum.MoveLeftExecute(Sender: TObject);
begin
  lbxContainedStratons.Items.Delete(lbxContainedStratons.ItemIndex);
end;

procedure TfrmEditStratum.MoveLeftUpdate(Sender: TObject);
begin
  MoveLeft.Enabled := lbxContainedStratons.ItemIndex > -1;
end;

procedure TfrmEditStratum.MoveAllLeftExecute(Sender: TObject);
begin
  lbxContainedStratons.Clear;
end;

procedure TfrmEditStratum.FormShow(Sender: TObject);
var v: variant;
    iHorizonID: integer;
begin
  iHorizonID := Dict.Columns[2].Value;
  if iHorizonID > 0 then
    cmplxHorizon.AddItem(iHorizonID, cmplxHorizon.cmbxName.Items[cmplxHorizon.cmbxName.Items.IndexOfObject(TObject(iHorizonID))]);
  edtStratumName.Text := Dict.Columns[1].Value;
  // загружаем зависимые
  v := Dict.Reference('TBL_STRATUM_STRATON', 'STRATON_ID');
  if not varIsEmpty(v) then (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(lbxContainedStratons.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('TBL_STRATIGRAPHY_NAME_DICT'), v, 0);
end;

procedure TfrmEditStratum.ClearControls;
begin
  cmplxHorizon.Clear;
  edtStratumName.Clear;
  lbxContainedStratons.Clear;
end;

procedure TfrmEditStratum.edtSearchChange(Sender: TObject);
var i: integer;
begin
  for i := 0 to lbxAllStratons.Items.Count - 1 do
  if pos(edtSearch.Text, lbxAllStratons.Items[i]) > 0 then
  begin
    lbxAllStratons.ItemIndex := i;
    break;
  end;
end;

procedure TfrmEditStratum.cmplxHorizonbtnShowAdditionalClick(
  Sender: TObject);
begin
  cmplxHorizon.btnShowAdditionalClick(Sender);

end;

procedure TfrmEditStratum.AdditionalSave;
begin
  inherited;
  FDict.SetRefer(lbxContainedStratons.Items);
end;

procedure TfrmEditStratum.SaveValues;
begin
  inherited;
  FDict.Columns[1].Value := edtStratumName.Text;
  FDict.Columns[2].Value := cmplxHorizon.SelectedElementID;
end;


procedure TfrmEditStratum.actnOKUpdate(Sender: TObject);
begin
  actnOK.Enabled := cmplxHorizon.SelectedElementID > 0
end;

end.
