unit CommonObjectSelectFilter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, CommonFilter, ImgList, ClientCommon,
  BaseConsts
  {$IFDEF VER150}
  , Variants
  {$ENDIF}
  ;

  { TODO :
    Версии потом надо будет нормально разделить - чтобы была видимость отдельного
    клиента для структур и месторождений и для лицензионных участков }
  {$DEFINE LIC}
  //{$DEFINE STRUCT}
  //  {$DEFINE FIELD}

type
  TfrmObjectSelect = class(TFrame)
    pnlLeft: TPanel;
    lswSearch: TListView;
    pnlButtons: TPanel;
    prg: TProgressBar;
    pnlSearch: TPanel;
    Label1: TLabel;
    spdbtnDeselectAll: TSpeedButton;
    edtName: TEdit;
    imgLst: TImageList;
    sbtnSelectAll: TSpeedButton;
    procedure lswSearchKeyPress(Sender: TObject; var Key: Char);
    procedure lswSearchMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spdbtnDeselectAllClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure lswSearchInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure sbtnSelectAllClick(Sender: TObject);
  private
    FActiveButton: TSpeedButton;
    FOnReloadData: TNotifyEvent;
    FSQL: string;
    fFilterValues: OleVariant;
    FAllowSelectAll: boolean;
    procedure SetActiveButton(const Value: TSpeedButton);
    procedure SetAllowSelectAll(const Value: boolean);
  private
    { Private declarations }
    FFilterID: integer;
    Filters:  TWellFilters;
    AreaListItems: TListItems;
    procedure btnClickAction(Sender: TObject);
    procedure CreateButtons(FilterTable: variant);
    property  ActiveButton: TSpeedButton read FActiveButton write SetActiveButton;
    function  GetCurrentlySelected: string;
    function  GetListItemByID(AID: Integer): TListItem;
  public
    { Public declarations }
    procedure Reload(AFilterID: integer);
    procedure Prepare;

    property  FilterID: integer read FFilterID write FFilterID;
    property  FilterValues: OleVariant read fFilterValues write FFilterValues;

    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
    property OnReloadData: TNotifyEvent read FOnReloadData write FOnReloadData;
    property AllowSelectAll: boolean read FAllowSelectAll write SetAllowSelectAll;
    property SQL: string read FSQL write FSQL;
    procedure SetState(AState: boolean);
    procedure Clear;
  end;

implementation

{$R *.DFM}

{ TfrmObjectSelect }

function CreateFilterTable: variant;
begin
  // таблица задействованных таблиц
  // 0 - идентификатор
  // 1 - аглицкое название
  // 2 - название ключа
  // 3 - русское название
  // 4 - ограничение при скачивании справочника
  // 5 - индекс картинки
  // 6 - строка сортировки


  {$IFDEF STRUCT}
  Result := varArrayCreate([0,6,0,7],varVariant);
  {$ENDIF}

  {$IFDEF LIC}
  Result := varArrayCreate([0,6,0,6],varVariant);
  {$ENDIF}



  Result[0,0] := 0;
  Result[1,0] := 'TBL_TIME';
  Result[2,0] := 'DTM_ENTERING_DATE';
  Result[3,0] := 'Время';
  Result[4,0] := '';
  Result[5,0] := 0;
  Result[6,0] := '';

  {$IFDEF STRUCT}
  Result[0,1] := 1;
  Result[1,1] := 'SPD_GET_AREA_DICT';
  Result[2,1] := 'AREA_ID in (%s)';
  Result[3,1] := 'Площади';
  Result[4,1] := '';
  Result[5,1] := 1;
  Result[6,1] := '';
  {$ENDIF}

  {$IFDEF LIC}
  Result[0,1] := 1;
  Result[1,1] := 'TBL_LICENSE_ZONE_STATE_DICT';
  Result[2,1] := 'LICENSE_ZONE_STATE_ID in (%s)';
  Result[3,1] := 'Состояние участка';
  Result[4,1] := '';
  Result[5,1] := 7;
  Result[6,1] := '';
  {$ENDIF}

  Result[0,2] := 2;
  Result[1,2] := 'SPD_GET_PETROL_REGION_DICT';
  Result[2,2] := 'structure_id in (select sob.structure_id from tbl_structure_object_binding sob where (sob.object_id in (%s)) and (sob.object_type_id = 38))';
  Result[3,2] := 'НГР';
  Result[4,2] := 'NUM_REGION_TYPE=3';
  Result[5,2] := 2;
  Result[6,2] := '';


  Result[0,3] := 6;
  Result[1,3] := 'TBL_PETROLIFEROUS_REGION_DICT';
  Result[2,3] := 'structure_id in (select sob.structure_id from tbl_structure_object_binding sob, tbl_petroliferous_region_dict p ' +
                 'where (sob.object_id = p.petrol_region_id) and (sob.object_type_id = 38) and ' +
                 '((p.main_region_id in (%s)) or (p.petrol_region_id in (%s)) ' +
                 'or (p.main_region_id in (select mp.petrol_region_id from tbl_petroliferous_region_dict mp where mp.main_region_id in (%s))))) ' +
                 'and (Version_ID = 0)';
  Result[3,3] := 'НГО, НГП';
  // включаем насильственно идентификатор региона
  Result[4,3] := '(NUM_REGION_TYPE=2) or (NUM_REGION_TYPE = 1)';
  Result[5,3] := 6;
  Result[6,3] := 'VCH_REGION_FULL_NAME';

  Result[0,4] := 3;
  Result[1,4] := 'SPD_GET_TECTONIC_STRUCT_DICT';
  Result[2,4] := 'structure_id in (select sob.structure_id from tbl_structure_object_binding sob where (sob.object_id in (%s)) and (sob.object_type_id = 39))';
  Result[3,4] := 'Тектонические структуры';
  Result[4,4] := 'NUM_STRUCT_TYPE=3 OR NUM_STRUCT_TYPE=4';
  Result[5,4] := 3;
  Result[6,4] := 'vch_Struct_Full_Name';

  Result[0,5] := 4;
  Result[1,5] := 'TBL_DISTRICT_DICT';
  Result[2,5] := 'structure_id in (select sob.structure_id from tbl_structure_object_binding sob where (sob.object_id in (%s)) and (sob.object_type_id = 37))';
  Result[3,5] := 'Географические регионы';
  Result[4,5] := '';
  Result[5,5] := 4;
  Result[6,5] := '';

  Result[0,6] := 5;
  Result[1,6] := 'TBL_ORGANIZATION_DICT';
  Result[2,6] := 'ORGANIZATION_ID in (%s)';
  Result[3,6] := 'Недропользователь';
  Result[4,6] := '';
  Result[5,6] := 5;
  Result[6,6] := 'vch_Org_Full_Name';

  {$IFDEF STRUCT}
  Result[0,7] := 7;
  Result[1,7] := 'TBL_STRUCTURE_FUND_TYPE_DICT';
  Result[2,7] := 'STRUCTURE_FUND_TYPE_ID in (%s)';
  Result[3,7] := 'Тип фонда';
  Result[4,7] := '';
  Result[5,7] := 8;
  Result[6,7] := 'VCH_STRUCTURE_FUND_TYPE_NAME';
  {$ENDIF}

end;


procedure TfrmObjectSelect.btnClickAction(Sender: TObject);
begin
  ActiveButton := (Sender as TSpeedButton);
end;

constructor TfrmObjectSelect.Create(AOwner: TComponent);
begin
  inherited;

  AllowSelectAll := false;
end;

procedure TfrmObjectSelect.CreateButtons(FilterTable: variant);
var i, iHB,iTop: integer;
    btn: TSpeedButton;
    Item: TListItem;
begin
  iHB := varArrayHighBound(FilterTable,2);
  pnlButtons.Height := (iHB+1)*21+14;
  iTop := 7; //btn := nil;
  for i:=iHB downto 0 do
  begin
    btn := TSpeedButton.Create(pnlButtons);
    with btn do
    begin
      btn.Parent := pnlButtons;
      Width := pnlButtons.Width - 2; Height:= 21;
      Top := pnlButtons.Height - 21 - iTop;
      Left := 1; Visible:=true; GroupIndex:=1;
      Caption := FilterTable[3,i];
      Tag := FilterTable[0,i]; Margin := 3; Spacing := 7;
      Anchors := [akTop, akLeft, akRight];
      if (FilterTable[5,i]>-1) and (FilterTable[5,i]<ImgLst.Count) then
        ImgLst.GetBitmap(FilterTable[5,i],Glyph);
      OnClick := btnClickAction;
    end;
    inc(iTop,21);
  end;
  FActiveButton := nil;

  {$IFDEF STRUCT}
  ActiveButton := (pnlButtons.Controls[4] as TSpeedButton);
  {$ENDIF}

  {$IFDEF FIELD}
  ActiveButton := (pnlButtons.Controls[0] as TSpeedButton);
  // ищем по номеру месторождения
  Item := GetListItemByID(FIELD_STRUCTURE_TYPE_ID);
  if Assigned(Item) then
  begin
    Item.Checked := true;
    Reload(-1);
  end;
  {$ENDIF}

  {$IFDEF LIC}
  ActiveButton := (pnlButtons.Controls[5] as TSpeedButton);
  {$ENDIF}
end;

destructor TfrmObjectSelect.Destroy;
begin
  if Assigned(Filters) then
  begin
    Filters.Free;
    Filters := nil;
  end;
  inherited;
end;

procedure TfrmObjectSelect.Reload(AFilterID: integer);
begin
  FilterID := AFilterID;
  if FilterID>-1 then Filters.LoadFilter(FilterID);
  if FilterID = 1 then AreaListItems := lswSearch.Items;

  if Assigned(Filters.CurrentFilter) then
    FilterValues := Filters.CurrentFilter.FilterValues;

  FSQL := Filters.CreateSQLFilter;

  if Assigned(FOnReloadData) then FOnReloadData(Self);
end;

procedure TfrmObjectSelect.SetActiveButton(const Value: TSpeedButton);
begin
  if (FActiveButton<>Value) then
  begin
    if Assigned(Filters.CurrentFilter) then
      Filters.CurrentFilter.SearchText := edtName.Text;

    FilterID := Value.Tag;
    Reload(FilterID);
    
    if Assigned(Filters.CurrentFilter) then
      edtName.Text := Filters.CurrentFilter.SearchText;
    edtName.SelectAll;
    FActiveButton := Value;
    FActiveButton.Down := true;
  end;
end;

procedure TfrmObjectSelect.lswSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key=#32) and (lswSearch.Selected<>nil) then
    Reload(-1);
end;

procedure TfrmObjectSelect.lswSearchMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Item: TListItem;
begin
  if ((Button = mbLeft) or (Button = mbRight)) and (X<=20)then
  begin
    Item := lswSearch.GetItemAt(X,Y);
    if Item<>nil then
      Reload(-1);
  end;
end;

procedure TfrmObjectSelect.spdbtnDeselectAllClick(Sender: TObject);
begin
  SetState(false);
end;

procedure TfrmObjectSelect.edtNameChange(Sender: TObject);
var Item: TListItem;
begin
  Item:=lswSearch.FindCaption(0, AnsiUpperCase(trim(edtName.Text)), true,true,true);
  if Item<>nil then
  begin
    Item.Focused:=true;
    Item.Selected:=true;
    lswSearch.Scroll(0,Item.Position.Y);
  end;
end;

function TfrmObjectSelect.GetCurrentlySelected: string;
var i: integer;
begin
  Result := '';
  with lswSearch do
  for i:=0 to Items.Count - 1 do
  if Items[i].Checked then
    Result := Result + #13 + #10 + Items[i].Caption+',';
  if Result<>'' then Result := 'Выбраны: '+Copy (Result, 0, Length(Result)-1);
end;

procedure TfrmObjectSelect.lswSearchInfoTip(Sender: TObject;
  Item: TListItem; var InfoTip: String);
begin
  InfoTip := GetCurrentlySelected;
  if Assigned(Item) and (lswSearch.StringWidth(Item.Caption)>lswSearch.Width-60) then
    InfoTip := Item.Caption+#13+#10+InfoTip;
end;

procedure TfrmObjectSelect.Prepare;
var vFilterTable: variant;
begin
  vFilterTable := CreateFilterTable;
  Filters := TWellFilters.Create('', '', vFilterTable,lswSearch, prg);
  CreateButtons(vFilterTable);
end;

procedure TfrmObjectSelect.SetState(AState: boolean);
var i: integer;
begin
  for i:=0 to lswSearch.Items.Count - 1 do
    lswSearch.Items[i].Checked := AState;
  Reload(-1);
end;

procedure TfrmObjectSelect.SetAllowSelectAll(const Value: boolean);
begin
  FAllowSelectAll := Value;
  sbtnSelectAll.Visible := FAllowSelectAll;

  if FAllowSelectAll then
    pnlSearch.Height := 95
  else
    pnlSearch.Height := pnlSearch.Height - sbtnSelectAll.Height;
end;

procedure TfrmObjectSelect.sbtnSelectAllClick(Sender: TObject);
begin
  SetState(true);
end;

procedure TfrmObjectSelect.Clear;
begin
  SetState(False);
end;

function TfrmObjectSelect.GetListItemByID(AID: Integer): TListItem;
var i: integer;
begin
  Result := nil;
  for i := 0 to lswSearch.Items.Count - 1 do
  if Integer(lswSearch.Items[i].Data) = AID then
  begin
    Result := lswSearch.Items[i];
    Break;
  end;
end;

end.
