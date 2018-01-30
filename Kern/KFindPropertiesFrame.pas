unit KFindPropertiesFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ActnList, Buttons, CoreDescription,
  ImgList, ToolWin, Menus, Slotting, Lithology, Search, BaseObjects, Registrator;

type
  TfrmFindProperties = class(TFrame)
    Panel1: TPanel;
    btnSearch: TSpeedButton;
    actnList: TActionList;
    actnFind: TAction;
    imgLst: TImageList;
    actnSortTypeDict: TAction;
    actnSortWord: TAction;
    btnClose: TBitBtn;
    btnClear: TBitBtn;
    actnClear: TAction;
    pm: TPopupMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Splitter1: TSplitter;
    lstFilter: TListBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    edtText: TEdit;
    dtmDate: TDateTimePicker;
    Panel2: TPanel;
    lstDicts: TListBox;
    procedure actnFindExecute(Sender: TObject);
    procedure lstFilterDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstFilterClick(Sender: TObject);
    procedure lstDictsDblClick(Sender: TObject);
    procedure dtmDateChange(Sender: TObject);
    procedure edtTextChange(Sender: TObject);
    procedure lstDictsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstFilterDblClick(Sender: TObject);
  private
    FActiveWell: TDescriptedWell;
    FActiveWells: TDescriptedWells;
    FActiveSlottings: TSlottings;
    FSearchOptions: TSimpleSearchs;
    FActiveOption: TSimpleSearch;

    function GetActiveOption: TSimpleSearch;
  public
    property ActiveOption: TSimpleSearch read GetActiveOption;
    property SearchOptions: TSimpleSearchs read FSearchOptions write FSearchOptions;

    property ActiveWell: TDescriptedWell read FActiveWell write FActiveWell;
    property ActiveWells: TDescriptedWells read FActiveWells write FActiveWells;

    property ActiveSlottings: TSlottings read FActiveSlottings write FActiveSlottings;

    procedure   Clear;
    procedure   Reload;

    procedure   SetOptions (aText, aDate, aDict: boolean; aCollection: TRegisteredIDObjects);

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade, MainForm, SDFacade;

{$R *.dfm}

procedure TfrmFindProperties.actnFindExecute(Sender: TObject);
var i, j: integer;
    FilterDate, FilterText, FilterObjs, Filter: string;
    s : TSlotting;
begin
  if lstFilter.Items.Count > SearchOptions.Count then
  begin
    FActiveSlottings.Clear;

    FilterText := '';
    FilterDate := '';
    FilterObjs := '';

    for i := 0 to SearchOptions.Count - 1 do
    begin
      if SearchOptions.Items[i].FieldSimple then
      begin
        //FilterText := FilterText + '(' + SearchOptions.Items[i].FieldName + ' like ' + '''' + trim (SearchOptions.Items[i].TextValue) + '''' + ')';
      end
      else if SearchOptions.Items[i].FieldDate then
      begin
        FilterDate := FilterDate + '(' + SearchOptions.Items[i].FieldName + ' = ' + '''' + DateToStr(SearchOptions.Items[i].DateValue) + '''' + ')';
      end
      else
      begin
        if (trim(FilterObjs) <> '') and (SearchOptions.Items[i].Os.Count <> 0) then
        if (FilterObjs[Length(FilterObjs)] = ')') then FilterObjs := FilterObjs + ' and ';

        for j := 0 to SearchOptions.Items[i].Os.Count - 1 do
        begin
          if j = 0 then FilterObjs := FilterObjs + '(' + SearchOptions.Items[i].FieldName + ' in (' + IntToStr(SearchOptions.Items[i].Os.Items[j].ID)
          else FilterObjs := FilterObjs + ', ' + IntToStr(SearchOptions.Items[i].Os.Items[j].ID);

          if SearchOptions.Items[i].Os.Count - 1 = j then FilterObjs := FilterObjs + '))';
        end;
      end;
    end;

    Filter := '';
    if trim (FilterText) <> '' then Filter := FilterText;

    if (trim (FilterDate) <> '') then
      if (trim (Filter) = '') then Filter := FilterDate
      else Filter := Filter + ' and ' + FilterDate;

    if (trim (FilterObjs) <> '') then
      if (trim (Filter) = '') then Filter := FilterObjs
      else Filter := Filter + ' and ' + FilterObjs;

    FActiveSlottings.Clear;
    FActiveSlottings.Poster.GetFromDB('slotting_uin in (select distinct slotting_uin from VW_DESCRIPTION where ' + Filter + ')', FActiveSlottings);

    if FActiveSlottings.Count > 0 then
    begin
      // получаем все скважины по заданным словам
      Filter := IntToStr(FActiveSlottings.Items[0].Owner.ID);
      for i := 1 to FActiveSlottings.Count - 1 do
        Filter := Filter + ',' + IntToStr(FActiveSlottings.Items[i].Owner.ID);

      FActiveWells.Poster.GetFromDB('well_uin in (' + Filter + ')', FActiveWells);

      for i := 0 to FActiveWells.Count - 1 do
        FActiveWells.Items[i].Slottings.Clear;

      for i := 0 to FActiveSlottings.Count - 1 do
      for j := 0 to FActiveWells.Count - 1 do
      if FActiveSlottings.Items[i].Owner.ID = FActiveWells.Items[j].ID then
      begin
        s := FActiveSlottings.Items[i];

        FActiveWells.Items[j].Slottings.Add(s, false, false);
      end;

      TMainFacade.GetInstance.AllWells.Assign(FActiveWells);
      TMainFacade.GetInstance.AllWells.MakeList(frmMain.frmInfoObject.frmInfoSlottings.tvwWells.Items, true, true);
    end
    else MessageBox(0, 'Поиск не дал результатов.', 'Сообщение',  MB_OK + MB_ICONINFORMATION + MB_SYSTEMMODAL);
  end
  else MessageBox(0, 'Не указаны условия поиска.', 'Ошибка',  MB_OK + MB_ICONERROR + MB_SYSTEMMODAL);
end;

procedure TfrmFindProperties.Clear;
begin
  lstFilter.Clear;

  FActiveWell := nil;
  FActiveWells.Clear;

  FSearchOptions.Clear;
end;

constructor TfrmFindProperties.Create(AOwner: TComponent);
begin
  inherited;
  FSearchOptions := TSimpleSearchs.Create;
  FActiveOption := TSimpleSearch.Create(FSearchOptions);

  FActiveWells := TDescriptedWells.Create;
  FActiveWell := TDescriptedWell.Create(FActiveWells);

  FActiveSlottings := TSlottings.Create;
end;

destructor TfrmFindProperties.Destroy;
begin

  inherited;
end;

procedure TfrmFindProperties.Reload;
var s: TSimpleSearch;
begin
  Clear;

  s := TSimpleSearch.Create(SearchOptions);
  s.Name := 'Литология';
  s.NameCollection := (TMainFacade.GetInstance as TMainFacade).AllLithologies;
  s.FieldType := 'Dict';
  s.FieldName := 'rock_id';
  SearchOptions.Add(s, false, false);

  s := TSimpleSearch.Create(SearchOptions);
  s.Name := 'Сотрудники';
  s.NameCollection := TMainFacade.GetInstance.AllEmployees;
  s.FieldType := 'Dict';
  s.FieldName := 'employee_id';
  SearchOptions.Add(s, false, false);

  s := TSimpleSearch.Create(SearchOptions);
  s.Name := 'Дата описания';
  s.NameCollection := nil;
  s.FieldType := 'Date';
  s.FieldName := 'DTM_DATE_CREATION';
  SearchOptions.Add(s, false, false);

  s := TSimpleSearch.Create(SearchOptions);
  s.Name := 'Ключевые характеристики';
  s.NameCollection := (TMainFacade.GetInstance as TMainFacade).AllWords;
  s.FieldType := 'Dict';
  s.FieldName := 'KERN_VALUE_ID';
  SearchOptions.Add(s, false, false);

  SearchOptions.MakeList(lstFilter.Items, true, true);

  lstFilter.ItemIndex := 0;
  lstFilterClick(lstFilter);
end;

procedure TfrmFindProperties.lstFilterDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do
  begin
    Font.Color := clBlue;
    if Assigned (lstFilter.Items.Objects[Index]) then
    if lstFilter.Items.Objects[Index].ClassType = TSimpleSearch then
      Font.Color := clRed;

    Font.Style := [fsBold];
    FillRect(Rect);
    TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;

procedure TfrmFindProperties.SetOptions(aText, aDate, aDict: boolean; aCollection: TRegisteredIDObjects);
begin
  edtText.Enabled := aText;
  dtmDate.Enabled := aDate;
  lstDicts.Enabled := aDict;

  edtText.Text := '';
  dtmDate.DateTime := Date;
  lstDicts.Clear;

  if aDict then
    aCollection.MakeList(lstDicts.Items, true, true);
end;

procedure TfrmFindProperties.lstFilterClick(Sender: TObject);
begin
  if Assigned (ActiveOption) then
  begin
    if ActiveOption.FieldType = 'Dict' then
      SetOptions(false, false, true, ActiveOption.NameCollection)
    else if ActiveOption.FieldType = 'Text' then
    begin
      SetOptions(true, false, false, ActiveOption.NameCollection);
      if (lstFilter.ItemIndex < lstFilter.Count - 1) then
      if not Assigned(lstFilter.Items.Objects[lstFilter.ItemIndex + 1]) then
        edtText.Text := lstFilter.Items[lstFilter.ItemIndex + 1];
    end
    else
    begin
      SetOptions(false, true, false, ActiveOption.NameCollection);
      if (lstFilter.ItemIndex < lstFilter.Count - 1) then
      if not Assigned(lstFilter.Items.Objects[lstFilter.ItemIndex + 1]) then
        dtmDate.DateTime := StrToDateTime(lstFilter.Items[lstFilter.ItemIndex + 1]);
    end;
  end;
end;

function TfrmFindProperties.GetActiveOption: TSimpleSearch;
begin
  Result := nil;

  if (lstFilter.Items.Count > 0) and (lstFilter.ItemIndex > -1) then
  if Assigned (lstFilter.Items.Objects[lstFilter.ItemIndex]) then
  if (lstFilter.Items.Objects[lstFilter.ItemIndex].ClassType = TSimpleSearch) then
    Result := lstFilter.Items.Objects[lstFilter.ItemIndex] as TSimpleSearch
end;

procedure TfrmFindProperties.lstDictsDblClick(Sender: TObject);
var IndexActiveObj: integer;
begin
  IndexActiveObj := lstFilter.ItemIndex;

  if not Assigned (ActiveOption) then
   while lstFilter.Items.Objects[lstFilter.ItemIndex].ClassType <> TSimpleSearch do
      lstFilter.ItemIndex := lstFilter.ItemIndex - 1;

  ActiveOption.Os.Add(lstDicts.Items.Objects[lstDicts.ItemIndex] as TIDObject, false, false);
  SearchOptions.MakeList(lstFilter.Items, true, true);
  lstFilter.ItemIndex := IndexActiveObj;
end;

procedure TfrmFindProperties.dtmDateChange(Sender: TObject);
var IndexActiveObj: integer;
begin
  IndexActiveObj := lstFilter.ItemIndex;

  ActiveOption.FieldDate := true;
  ActiveOption.DateValue := dtmDate.DateTime;
  SearchOptions.MakeList(lstFilter.Items, true, true);

  lstFilter.ItemIndex := IndexActiveObj;
end;

procedure TfrmFindProperties.edtTextChange(Sender: TObject);
var IndexActiveObj: integer;
begin
  IndexActiveObj := lstFilter.ItemIndex;

  ActiveOption.FieldSimple := true;
  ActiveOption.TextValue := edtText.Text;
  SearchOptions.MakeList(lstFilter.Items, true, true);

  lstFilter.ItemIndex := IndexActiveObj;
end;

procedure TfrmFindProperties.lstDictsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do
  begin
    if (lstDicts.Items.Objects[Index].ClassType = TDictionaryWord) then
    begin
      Font.Name := ((lstDicts.Items.Objects[Index] as TDictionaryWord).Owner.Owner as TDictionary).Font.Name;
      Font.Charset := ((lstDicts.Items.Objects[Index] as TDictionaryWord).Owner.Owner as TDictionary).Font.Charset;
      Font.Color := ((lstDicts.Items.Objects[Index] as TDictionaryWord).Owner.Owner as TDictionary).Font.Color;
      Font.Style := ((lstDicts.Items.Objects[Index] as TDictionaryWord).Owner.Owner as TDictionary).Font.Style;
    end
    else
    begin
      Font.Name := 'MS Sans Serif';
      Font.Charset := DEFAULT_CHARSET;
      Font.Color := clBlack;
      Font.Style := [];
    end;

    Brush.Color := clWhite;

    FillRect(Rect);
    TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;

procedure TfrmFindProperties.lstFilterDblClick(Sender: TObject);
var i, index: integer;
begin
  if lstFilter.Items.Objects[lstFilter.ItemIndex].ClassType <> TSimpleSearch then
  begin
    for i := 0 to SearchOptions.Count - 1 do
    if SearchOptions.Items[i].Os.IndexOf(lstFilter.Items.Objects[lstFilter.ItemIndex]) > -1 then
    begin
      index := lstFilter.ItemIndex - 1;
      SearchOptions.Items[i].Os.Remove(lstFilter.Items.Objects[lstFilter.ItemIndex]);
      SearchOptions.MakeList(lstFilter.Items, true, true);
      lstFilter.ItemIndex := index;
      break;
    end;
  end;
end;

end.
