unit RRManagerLayerEditForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ImgList, ActnList, ClientDicts, BaseDicts
  {$IFDEF VER150}
  , Variants
  {$ENDIF}
  ;


type
  TfrmEditLayer = class(TDictEditForm)
    Label1: TLabel;
    edtLayerName: TEdit;
    gbxContainment: TGroupBox;
    sbtnRight: TSpeedButton;
    sbtnLeft: TSpeedButton;
    sbtnFullLeft: TSpeedButton;
    lbxContainedStratons: TListBox;
    pnlLeft: TPanel;
    Label2: TLabel;
    lbxAllStratons: TListBox;
    edtSearch: TEdit;
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    actnEditStratum: TActionList;
    MoveRight: TAction;
    MoveLeft: TAction;
    MoveAllLeft: TAction;
    imgList: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure MoveRightExecute(Sender: TObject);
    procedure MoveRightUpdate(Sender: TObject);
    procedure MoveLeftExecute(Sender: TObject);
    procedure MoveLeftUpdate(Sender: TObject);
    procedure MoveAllLeftExecute(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbxAllStratonsDblClick(Sender: TObject);
    procedure lbxContainedStratonsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    
    procedure SetDict(const Value: TDict); override;
  public
    { Public declarations }
    procedure ClearControls; override;
    procedure SaveValues; override;
    procedure AdditionalSave; override;
  end;

var
  frmEditLayer: TfrmEditLayer;

implementation

uses Facade;

{$R *.DFM}

{ TfrmEditLayer }

procedure TfrmEditLayer.AdditionalSave;
begin
  inherited;
  FDict.SetRefer(lbxContainedStratons.Items);
end;

procedure TfrmEditLayer.ClearControls;
begin
  edtLayerName.Clear;
  lbxContainedStratons.Clear;
end;

procedure TfrmEditLayer.SaveValues;
begin
  inherited;
  FDict.Columns[1].Value := edtLayerName.Text;
end;

procedure TfrmEditLayer.SetDict(const Value: TDict);
begin
  FDict := Value;
  ClearControls;
end;

procedure TfrmEditLayer.FormCreate(Sender: TObject);
begin
  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(lbxAllStratons.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('TBL_STRATIGRAPHY_NAME_DICT'));
  lbxAllStratons.Sorted := true;
end;

procedure TfrmEditLayer.MoveRightExecute(Sender: TObject);
begin
  with lbxAllStratons do
  begin
    lbxContainedStratons.ItemIndex := lbxContainedStratons.Items.IndexOfObject(Items.Objects[ItemIndex]);
    if lbxContainedStratons.ItemIndex = -1 then
      lbxContainedStratons.ItemIndex := lbxContainedStratons.Items.AddObject(Items[ItemIndex], Items.Objects[ItemIndex]);
    lbxContainedStratons.Sorted := true;
  end;
end;

procedure TfrmEditLayer.MoveRightUpdate(Sender: TObject);
begin
  MoveRight.Enabled := lbxAllStratons.ItemIndex > -1;
end;

procedure TfrmEditLayer.MoveLeftExecute(Sender: TObject);
begin
  lbxContainedStratons.Items.Delete(lbxContainedStratons.ItemIndex);
end;

procedure TfrmEditLayer.MoveLeftUpdate(Sender: TObject);
begin
  MoveLeft.Enabled := lbxContainedStratons.ItemIndex > -1;
end;

procedure TfrmEditLayer.MoveAllLeftExecute(Sender: TObject);
begin
  lbxContainedStratons.Clear;
end;

procedure TfrmEditLayer.edtSearchChange(Sender: TObject);
var i: integer;
begin
  for i := 0 to lbxAllStratons.Items.Count - 1 do
  if pos(edtSearch.Text, lbxAllStratons.Items[i]) > 0 then
  begin
    lbxAllStratons.ItemIndex := i;
    break;
  end;
end;

procedure TfrmEditLayer.FormShow(Sender: TObject);
var v: variant;
begin
  edtLayerName.Text := Dict.Columns[1].Value;
  // загружаем зависимые
  v := Dict.Reference('TBL_STRATIGRAPHY_LAYER', 'STRATON_ID');
  if not varIsEmpty(v) then
    (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(lbxContainedStratons.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('TBL_STRATIGRAPHY_NAME_DICT'), v, 0);
end;

procedure TfrmEditLayer.lbxAllStratonsDblClick(Sender: TObject);
begin
  MoveRightExecute(Sender);
end;

procedure TfrmEditLayer.lbxContainedStratonsDblClick(Sender: TObject);
begin
  MoveLeftExecute(Sender);
end;

end.
