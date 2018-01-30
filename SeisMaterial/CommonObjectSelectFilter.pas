unit CommonObjectSelectFilter;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, CommonFilter, ImgList, BaseObjects
  {$IFDEF VER150}
  , Variants
  {$ENDIF}
  ;


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
    chbxFilterSelected: TCheckBox;
    sbtnShowFilter: TSpeedButton;
    sbtnDetach: TSpeedButton;
    sbtnExecute: TSpeedButton;
    procedure lswSearchKeyPress(Sender: TObject; var Key: Char);
    procedure lswSearchMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spdbtnDeselectAllClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure lswSearchInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure sbtnSelectAllClick(Sender: TObject);
    procedure chbxFilterSelectedClick(Sender: TObject);
    procedure sbtnDetachClick(Sender: TObject);
    procedure sbtnExecuteClick(Sender: TObject);
    procedure sbtnShowFilterClick(Sender: TObject);
//    procedure pnlButtonsClick(Sender: TObject);
  private
    FActiveButton: TSpeedButton;
    FOnReloadData: TNotifyEvent;
    FSQL: string;
    fFilterValues: OleVariant;
    FActiveImageIndex: integer;
    FSelectImmediately: boolean;
    procedure SetActiveButton(const Value: TSpeedButton);
    function GetActiveObject: TIdObject;
    function GetActiveObjectName: string;
  private
    { Private declarations }
    FFilterID: integer;
    Filters:  TWellFilters;
    AreaListItems: TListItems;
    procedure btnClickAction(Sender: TObject);
    procedure CreateButtons(FilterTable: variant);
    property  ActiveButton: TSpeedButton read FActiveButton write SetActiveButton;
    function  GetCurrentlySelected: string;
    procedure LoadSettings;
  public
    { Public declarations }
    procedure Reload(AFilterID: integer; SavePreviousValues: boolean);
    procedure Prepare;

    property  FilterID: integer read FFilterID write FFilterID;
    property  FilterValues: OleVariant read fFilterValues write FFilterValues;

    property  ActiveObject: TIdObject read GetActiveObject;
    property  ActiveObjectName: string read GetActiveObjectName;
    property  ActiveImageIndex: integer read FActiveImageIndex write FActiveImageIndex;

    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

    property   OnReloadData: TNotifyEvent read FOnReloadData write FOnReloadData;
    property   SQL: string read FSQL write FSQL;
    property   SelectImmediately: boolean read FSelectImmediately write FSelectImmediately;

    procedure SetState(AState: boolean);
    procedure Clear;
  end;

implementation

uses CommonFilterContentForm, Facade, StringUtils;

{$R *.DFM}

{ TfrmObjectSelect }

function CreateFilterTable: variant;
var sFilter: string;
begin
  // таблица задействованных таблиц
  // 0 - идентификатор
  // 1 - аглицкое название
  // 2 - название ключа
  // 3 - русское название
  // 4 - ограничение при скачивании справочника
  // 5 - индекс картинки
  // 6 - строка сортировки

  Result := varArrayCreate([0,8,0,19],varVariant);

  Result[0,0] := 0;
  Result[1,0] := 'TBL_TIME';
  Result[2,0] := 'DTM_ENTERING_DATE';
  Result[3,0] := 'Время';
  Result[4,0] := '';
  Result[5,0] := 0;
  Result[6,0] := '';
  Result[7, 0] := '';
  Result[8, 0] := 1;

  Result[0,1] := 1;
  Result[1,1] := 'SPD_GET_AREA_DICT';
  Result[2,1] := 'AREA_ID';
  //Result[1,1] := 'tbl_seis_work_method';
  //Result[2,1] := 'seis_work_method_id';
  Result[3,1] := 'Площади';
  Result[4,1] := '';
  Result[5,1] := 1;
  Result[6,1] := '';
  Result[7,1] := '';
  Result[8,1] := 1;

  Result[0,2] := 2;
  Result[1,2] := 'TBL_NEW_PETROL_REGION_DICT';
  Result[2,2] := 'PETROL_REGION_ID';
  Result[3,2] := 'Новые НГР';
  Result[4,2] := '';
  Result[5,2] := 2;
  Result[6,2] := '';
  Result[7,2] := '';
  Result[8,2] := 1;


  Result[0,3] := 6;
  Result[1,3] := 'TBL_NEW_PETROL_REGION_DICT';
  Result[2,3] := 'MAIN_REGION_ID';
  Result[3,3] := 'Новые НГО';
  // включаем насильственно идентификатор региона
  Result[4,3] := 'NUM_REGION_TYPE = 2';
  Result[5,3] := 6;
  Result[6,3] := '';
  Result[7,3] := '';
  Result[8,3] := 1;

  Result[0,4] := 3;
  Result[1,4] := 'TBL_NEW_TECTONIC_STRUCT_DICT';
  Result[2,4] := 'STRUCT_ID';
  Result[3,4] := 'Новые тект. структуры';
  Result[4,4] := 'NUM_STRUCT_TYPE=3 OR NUM_STRUCT_TYPE=4';
  Result[5,4] := 3;
  Result[6,4] := 'vch_Struct_Full_Name';
  Result[7,4] := '';
  Result[8,4] := 1;

  Result[0,5] := 4;
  Result[1,5] := 'TBL_DISTRICT_DICT';
  Result[2,5] := 'DISTRICT_ID';
  Result[3,5] := 'Географические регионы';
  Result[4,5] := '';
  Result[5,5] := 4;
  Result[6,5] := '';
  Result[7,5] := '';
  Result[8,5] := 1;

  Result[0,6] := 5;
  Result[1,6] := 'TBL_ORGANIZATION_DICT';
  Result[2,6] := 'ORGANIZATION_ID';
  Result[3,6] := 'Недропользователь';
  Result[4,6] := '';
  Result[5,6] := 5;
  Result[6,6] := 'vch_Org_Full_Name';
  Result[7,6] := '';
  Result[8,6] := 1;


  Result[0,7] := 7;
  Result[1,7] := 'VW_STRATIGRAPHY_NAME_DICT';
  Result[2,7] := 'STRATON_ID';
  Result[3,7] := 'Страт. подразделение';
  sFilter := '(rf_trim(VCH_STRATON_INDEX) <> ' + QuotedStr('') + ')';
  Result[4,7] := sFilter + ' AND (TAXONOMY_UNIT_ID in (1, 2, 3, 4, 5, 6, 7, 17, 18, 19, 40,41,42,43,44,45,46,47,48,0,49,50,51,53,56,57,58,70))';
  Result[5,7] := 7;
  Result[6,7] := 'VCH_STRATON_FULL_NAME';
  Result[7,7] := 'Well_UIN in (select Well_UIN from tbl_subdivision_component sc where (%s) and sc.num_depth > 0)';
  Result[8,7] := 3;

  Result[0,8] := 2;
  Result[1,8] := 'SPD_GET_PETROL_REGION_DICT';
  Result[2,8] := 'OLD_NGR_ID';
  Result[3,8] := 'Старые НГР';
  Result[4,8] := '';
  Result[5,8] := 2;
  Result[6,8] := '';
  Result[7,8] := '';
  Result[8,8] := 1;


  Result[0,9] := 6;
  Result[1,9] := 'TBL_PETROLIFEROUS_REGION_DICT';
  Result[2,9] := 'OLD_NGO_ID';
  Result[3,9] := 'Старые НГО';
  // включаем насильственно идентификатор региона
  Result[4,9] := 'NUM_REGION_TYPE = 2';
  Result[5,9] := 6;
  Result[6,9] := '';
  Result[7,9] := '';
  Result[8,9] := 1;

  Result[0,10] := 3;
  Result[1,10] := 'SPD_GET_TECTONIC_STRUCT_DICT';
  Result[2,10] := 'OLD_TSTRUCT_ID';
  Result[3,10] := 'Старые тектонические структуры';
  Result[4,10] := 'NUM_STRUCT_TYPE=3 OR NUM_STRUCT_TYPE=4';
  Result[5,10] := 3;
  Result[6,10] := 'vch_Struct_Full_Name';
  Result[7,10] := '';
  Result[8,10] := 1;

  Result[0,11] := 8;
  Result[1,11] := 'tbl_seis_work_method';
  Result[2,11] := 'seis_work_method_id';
  Result[3,11] := 'Метод работ';
  Result[4,11] := '';
  Result[5,11] := 14;
  Result[6,11] := '';
  Result[7,11] := '';
  Result[8,11] := 1;

  Result[0,12] := 9;
  Result[1,12] := 'tbl_seis_work_type';
  Result[2,12] := 'seis_work_type_id';
  Result[3,12] := 'Тип работ';
  Result[4,12] := '';
  Result[5,12] := 13;
  Result[6,12] := '';
  Result[7,12] := '';
  Result[8,12] := 1;

  Result[0,13] := 10;
  Result[1,13] := 'tbl_seis_crews';
  Result[2,13] := 'seis_crews_id';
  Result[3,13] := 'Сейсмопартии';
  Result[4,13] := '';
  Result[5,13] := 11;
  Result[6,13] := '';
  Result[7,13] := '';
  Result[8,13] := 1;

  Result[0,14] := 11;
  Result[1,14] := 'tbl_location';
  Result[2,14] := 'location_id';
  Result[3,14] := 'Место хранения';
  Result[4,14] := '';
  Result[5,14] := 12;
  Result[6,14] := '';
  Result[7,14] := '';
  Result[8,14] := 1;

  Result[0,15] := 12;
  Result[1,15] := 'tbl_employee';
  Result[2,15] := 'employee_id';
  Result[3,15] := 'Авторы внутр';
  Result[4,15] := '';
  Result[5,15] := 15;
  Result[6,15] := 'vch_employee_full_name';
  Result[7,15] := '';
  Result[8,15] := 1;

  Result[0,16] := 13;
  Result[1,16] := 'tbl_employee_outside';
  Result[2,16] := 'employee_outside_id';
  Result[3,16] := 'Авторы внеш';
  Result[4,16] := '';
  Result[5,16] := 16;
  Result[6,16] := 'vch_employee_outside_full_name';
  Result[7,16] := '';
  Result[8,16] := 1;

  Result[0,17] := 14;
  Result[1,17] := 'tbl_seismic_profile';
  Result[2,17] := 'seis_profile_id';
  Result[3,17] := 'Сейсмопрофили';
  Result[4,17] := '';
  Result[5,17] := 10;
  Result[6,17] := 'num_seis_profile_number';
  Result[7,17] := '';
  Result[8,17] := 1;

  Result[0,18] := 15;
  Result[1,18] := 'tbl_seismic_profile_type';
  Result[2,18] := 'seis_profile_type_id';
  Result[3,18] := 'Типы профилей';
  Result[4,18] := '';
  Result[5,18] := 10;
  Result[6,18] := '';
  Result[7,18] := '';
  Result[8,18] := 1;

  Result[0,19] := 16;
  Result[1,19] := 'tbl_material';
  Result[2,19] := 'material_id';
  Result[3,19] := 'Отчеты';
  Result[4,19] := 'material_type_id=70';
  Result[5,19] := 17;
  Result[6,19] := 'num_inventory_number';
  Result[7,19] := '';
  Result[8,19] := 17;
end;


procedure TfrmObjectSelect.btnClickAction(Sender: TObject);
begin
  ActiveButton := (Sender as TSpeedButton);
end;

constructor TfrmObjectSelect.Create(AOwner: TComponent);
begin
  inherited;
  FSelectImmediately := true;
end;

procedure TfrmObjectSelect.CreateButtons(FilterTable: variant);
var i, iHB,iTop: integer;
    btn: TSpeedButton;
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
      btn.ParentFont := false;
      btn.Font.Name := 'Arial';
      btn.Font.Style := [];
      btn.Flat := false;
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
  FActiveButton := (pnlButtons.Controls[9] as TSpeedButton);
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

procedure TfrmObjectSelect.Reload(AFilterID: integer; SavePreviousValues: boolean);
begin
  FilterID := AFilterID;
  if FilterID>-1 then
  begin
    Filters.LoadFilter(FilterID, SavePreviousValues,  FilterValues);
    ActiveImageIndex := Filters.CurrentFilter.ImageIndex;
  end;

  if FilterID = 1 then AreaListItems := lswSearch.Items;

  if Assigned(Filters.CurrentFilter) then
    FilterValues := Filters.CurrentFilter.FilterValues;

  FSQL := Filters.CreateSQLFilter2;

  TMainFacade.GetInstance.SystemSettings.SectionByName['OSF'].SectionValues.Values['FilterId'] := IntToStr(Filters.CurrentFilter.ID);
  TMainFacade.GetInstance.SystemSettings.SectionByName['OSF'].SectionValues.Values['FilterValues'] := Filters.CurrentFilter.FilterNumbers;

  if Assigned(FOnReloadData) then FOnReloadData(Self);
end;

procedure TfrmObjectSelect.SetActiveButton(const Value: TSpeedButton);
begin
  if (FActiveButton <> Value) then
  begin
    if Assigned(Filters.CurrentFilter) then
      Filters.CurrentFilter.SearchText := edtName.Text;

    FilterID := Value.Tag;
    Reload(FilterID, true);

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
  if (Key=#32) and (lswSearch.Selected<>nil) and SelectImmediately then
    Reload(-1, true);
end;

procedure TfrmObjectSelect.lswSearchMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Item: TListItem;
begin
  if ((Button = mbLeft) or (Button = mbRight)) and (X<=20)then
  begin
    Item := lswSearch.GetItemAt(X,Y);
    if (Item<>nil) and SelectImmediately then
      Reload(-1, true);
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

  LoadSettings;
end;

procedure TfrmObjectSelect.SetState(AState: boolean);
var i: integer;
begin
  for i:=0 to lswSearch.Items.Count - 1 do
    lswSearch.Items[i].Checked := AState;

  if SelectImmediately then
    Reload(-1, true);
end;

procedure TfrmObjectSelect.sbtnSelectAllClick(Sender: TObject);
begin
  SetState(true);
end;

procedure TfrmObjectSelect.Clear;
begin
  SetState(False);
end;

function TfrmObjectSelect.GetActiveObject: TIdObject;
begin
  Result := nil;
end;

procedure TfrmObjectSelect.chbxFilterSelectedClick(Sender: TObject);
begin
  Filters.FilterLastSelectedObjects := chbxFilterSelected.Checked;
  if SelectImmediately then Reload(-1, true);
end;

procedure TfrmObjectSelect.sbtnDetachClick(Sender: TObject);
begin
  FSelectImmediately := sbtnDetach.Down;
end;

procedure TfrmObjectSelect.sbtnExecuteClick(Sender: TObject);
begin
  Reload(-1, true);
end;

procedure TfrmObjectSelect.sbtnShowFilterClick(Sender: TObject);
begin
  if not Assigned(frmFilterContent) then frmFilterContent := TfrmFilterContent.Create(Self);
  frmFilterContent.WellFilters := Filters;
  frmFilterContent.Show;
end;

function TfrmObjectSelect.GetActiveObjectName: string;
var i : integer;
begin
  Result := '';

  for i := 0 to lswSearch.Items.Count - 1 do
  if lswSearch.Items.Item[i].Selected then
  begin
    Result := lswSearch.Items.Item[i].Caption;
    break;
  end;
end;

procedure TfrmObjectSelect.LoadSettings;
var sFilterType, sFilterValues: string;
    i: integer;
    fltr: TWellFilter;
begin
  sFilterType := TMainFacade.GetInstance.SystemSettings.SectionByName['OSF'].SectionValues.Values['FilterId'];
  sFilterValues := TMainFacade.GetInstance.SystemSettings.SectionByName['OSF'].SectionValues.Values['FilterValues'];

  try
    FilterID := StrToInt(sFilterType);
    FilterValues := Split(sFilterValues, ',');
    Reload(FilterID, false);
  except
    Reload(1, False);
  end;
end;

end.


