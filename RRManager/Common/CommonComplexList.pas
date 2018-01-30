unit CommonComplexList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin, Buttons, Grids,
  ClientCommon, BaseDicts
  {$IFDEF VER150}
  , Variants
  {$ENDIF}
  ;


type
  TColumnNumbers = set of byte;

  TfrmComplexList = class(TFrame)
    gbxAll: TGroupBox;
    chbxShowIDs: TCheckBox;
    lblSearch: TLabel;
    edtSearch: TEdit;
    btnRefresh: TSpeedButton;
    btnFirst: TSpeedButton;
    btnInsert: TSpeedButton;
    btnEdit: TSpeedButton;
    btnDelete: TSpeedButton;
    btnLast: TSpeedButton;
    btnOK: TButton;
    btnCancel: TButton;
    lwCurrentDict: TListView;
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnNext: TSpeedButton;
    procedure lwListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure chbxShowIDsClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure strgrCurrentDictSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure strgrCurrentDictDblClick(Sender: TObject);
    procedure strgrCurrentDictKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lwCurrentDictMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnNextClick(Sender: TObject);
  private
    { Private declarations }
    frm: TForm;
    FDictObject: TDict;
    FSelectedElementID: integer;
    FCaption: string;
    FColumns: TColumnNumbers;
    FSelectedElementName: string;
    FDictName: string;
    FSelectedElement: TStrings;
    FMultipleSelect: boolean;
    FSelectedElementIDs: TStringList;
    procedure SetCaption(const Value: string);
    procedure SetSelectedElementID(const Value: integer);
    procedure SetDictName(const Value: string);
    procedure ClearTable;
    procedure CreateForm;
    procedure ClearForm;
    procedure SaveValues;
    procedure SetColumns(Full: boolean = true);
    procedure Reload;
    procedure SetMultipleSelect(const Value: boolean);
    function  GetSelectedElementIDs: TStringList;
    procedure SetSelectedElementIDs(const Value: TStringList);
    function  GetListItemByID(AID: integer): TListItem;
  public
    { Public declarations }
    // наименование справочника
    property DictName: string read FDictName write SetDictName;
    // столбцы, которые грузятся в список
    property Columns: TColumnNumbers read FColumns write FColumns;
    // наименование справочника
    property Caption: string read FCaption write SetCaption;
    // идентификатор выбранного элемента
    property SelectedElementID: integer read FSelectedElementID write SetSelectedElementID;
    // наименование выбранного элемента
    property SelectedElementName: string read FSelectedElementName;
    // целая строка про выбранный элемент
    property SelectedElement: TStrings read FSelectedElement;

    // множественное выделение
    property MultipleSelect: boolean read FMultipleSelect write SetMultipleSelect;
    // выделеннные элементы
    property SelectedElementIDs: TStringList read GetSelectedElementIDs write SetSelectedElementIDs;
    // очищаем выделение
    procedure ClearMultipleSelection;


    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.DFM}

uses CommonComplexCombo, Facade;

{ TfrmComplexList }

procedure TfrmComplexList.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    gbxAll.Caption := FCaption;
  end;
end;


procedure TfrmComplexList.lwListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected then
  begin
    FSelectedElementID := StrToInt(Item.Caption);
    if Item.Subitems.Count > 0 then
      FSelectedElementName := Item.Subitems[0]
    else FSelectedElementName := Item.Caption;
  end
  else
  begin
    FSelectedElementID := -1;
    FSelectedElementName := '';
  end;
end;

procedure TfrmComplexList.btnCancelClick(Sender: TObject);
begin
  FSelectedElementID := -1;
  FSelectedElementName := '';
end;

procedure TfrmComplexList.SetSelectedElementID(const Value: integer);
var i, j: integer;
begin
  if FSelectedElementID <> Value  then
  begin
    FSelectedElementID := Value;
    FSelectedElementName := '';
    for i := 0 to lwCurrentDict.Items.Count - 1 do
    if StrToInt(lwCurrentDict.Items[i].Caption) = FSelectedElementID then
    begin
      lwCurrentDict.Items[i].Selected := true;
      FSelectedElementName := lwCurrentDict.Items[i].SubItems[0];

      FSelectedElement.Clear;
      FSelectedElement.Add(IntToStr(SelectedElementID));
      FSelectedElement.Add(SelectedElementName);
      for j := 1 to lwCurrentDict.Items[i].SubItems.Count - 1 do
        FSelectedElement.Add(lwCurrentDict.Items[i].SubItems[j]);
        
      break;
    end;
  end;
end;


procedure TfrmComplexList.SetDictName(const Value: string);
var i, j: integer;
    lc: TListColumn;
    li: TListItem;
begin
  if FDictName <> Value then
  begin
    FDictName := Value;
    lwCurrentDict.Visible:= false;
    ClearTable;

    FDictObject := (TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName[Value];
    btnInsert.Enabled := FDictObject.IsEditable;
    btnEdit.Enabled := FDictObject.IsEditable;
    btnDelete.Enabled := FDictObject.IsEditable;

    for i := 0 to FDictObject.Columns.Count - 1 do
    begin
      lc := lwCurrentDict.Columns.Add;
      lc.Caption := FDictObject.Columns[i].RusColName;

      if trim(lc.Caption) <> '' then
        lc.Width := Length(FDictObject.Columns[i].RusColName)*7
      else
        lc.Width := 200;
    end;


    if (not chbxShowIDs.Checked) and (lwCurrentDict.Columns.Count > 0)
      then lwCurrentDict.Columns[0].Width := -2
      else lwCurrentDict.Columns[0].Width := 17;

    if FDictObject.RowCount > 0 then
    begin
      for i:=0 to varArrayHighBound(FDictObject.Dict, 2) do
      begin
        li := lwCurrentDict.Items.Add;
        li.Caption := GetSingleValue(FDictObject.Dict, 0, i);
        for j := 1 to FDictObject.Columns.Count - 1 do
          li.SubItems.Add(GetSingleValue(FDictObject.Dict, j, i));
      end;
    end
    else
      lwCurrentDict.Clear;

    for i := 0 to lwCurrentDict.Columns.Count - 1 do
      lwCurrentDict.Columns.Items[i].Width := -2;

    lwCurrentDict.Visible:=true;
  end;//if cmbxDictList.ItemIndex >= 0
end;

procedure TfrmComplexList.ClearTable;
begin
  lwCurrentDict.Clear;
end;

procedure TfrmComplexList.chbxShowIDsClick(Sender: TObject);
begin
  if lwCurrentDict.Columns.Count > 0 then
  begin
    if not chbxShowIDs.Checked
      then lwCurrentDict.Columns[0].Width := 17
      else lwCurrentDict.Columns[0].Width := -2;
  end;
end;

procedure TfrmComplexList.edtSearchChange(Sender: TObject);
var sSimilar: shortstring;
    iID: integer;
    i, j: word;
    grLastCell: TGridRect;
    bNoValue: boolean; //наличие такого текста в строке
begin
  bNoValue := true;
  if Trim(edtSearch.Text) <> '' then
  begin
    for j := 0 to lwCurrentDict.Items.Count - 1 do
    if pos(AnsiUpperCase(Trim(edtSearch.Text)), AnsiUpperCase(lwCurrentDict.Items[j].Caption)) = 1 then
    begin
      lwCurrentDict.Items[j].Selected := true;
      lwCurrentDict.Items[j].MakeVisible(false);
      bNoValue := false;
      Break;
    end;

    if bNoValue then
    begin
      for j := 0 to lwCurrentDict.Items.Count - 1 do
      if pos(AnsiUpperCase(Trim(edtSearch.Text)), AnsiUpperCase(lwCurrentDict.Items[j].Caption)) > 0 then
      begin
        lwCurrentDict.Items[j].Selected := true;
        lwCurrentDict.Items[j].MakeVisible(false);
        bNoValue := false;
        Break;
      end;
    end;

    if bNoValue then
    for i := 0 to lwCurrentDict.Columns.Count - 2 do
    begin
      for j := 0 to lwCurrentDict.Items.Count - 1 do
      if pos(AnsiUpperCase(Trim(edtSearch.Text)), AnsiUpperCase(lwCurrentDict.Items[j].SubItems[i])) = 1 then
      begin
        lwCurrentDict.Items[j].Selected := true;
        lwCurrentDict.Items[j].MakeVisible(false);
        bNoValue := False;
        Break;
      end;

      if bNoValue then
      for j := 0 to lwCurrentDict.Items.Count - 1 do
      if pos(AnsiUpperCase(Trim(edtSearch.Text)), AnsiUpperCase(lwCurrentDict.Items[j].SubItems[i])) > 0 then
      begin
        lwCurrentDict.Items[j].Selected := true;
        lwCurrentDict.Items[j].MakeVisible(false);
        Break;
      end;
    end;
  end;
end; //if Trim(edtSearch.Text) <> ''


procedure TfrmComplexList.btnFirstClick(Sender: TObject);
begin
  lwCurrentDict.Items[0].Selected := true;
end;

procedure TfrmComplexList.btnLastClick(Sender: TObject);
begin
  lwCurrentDict.Items[lwCurrentDict.Items.Count - 1].Selected := true;
  lwCurrentDict.Items[lwCurrentDict.Items.Count - 1].MakeVisible(false);
end;

procedure TfrmComplexList.btnRefreshClick(Sender: TObject);
begin
  Reload;
end;

procedure TfrmComplexList.btnInsertClick(Sender: TObject);
begin
  FDictObject.Columns.ClearValues;
  CreateForm;
  ClearForm;

  if frm.ShowModal = mrOk then
  begin
    SaveValues;
    if FDictObject.InsertRow >= 0 then
    begin
      if (frm is FDictObject.DictEditFormClass) then
      begin
        SetColumns;
        (frm as FDictObject.DictEditFormClass).AdditionalSave;
      end;
      Reload;
    end
    else
      MessageBox(Self.Handle,
                 'Не удалось добавить строку!',
                 'Сообщение', mb_OK + mb_IconError);
  end;
end;

procedure TfrmComplexList.btnEditClick(Sender: TObject);
var iSelectedElementID: integer;
begin
  SetColumns;
  CreateForm;
  iSelectedElementID := SelectedElementID;
  SelectedElementID := 0;

  if frm.ShowModal = mrOk then
  begin
    SaveValues;
    if FDictObject.UpdateRow >= 0 then
    begin
      if (frm is FDictObject.DictEditFormClass) then
      begin
        SetColumns;
        (frm as FDictObject.DictEditFormClass).AdditionalSave;
      end;
      Reload;
      SelectedElementId := iSelectedElementID;      
    end
    else
      MessageBox(Self.Handle,
                 'Не удалось изменить строку',
                 'Сообщение', mb_OK + mb_IconError);
  end;
end;

procedure TfrmComplexList.btnDeleteClick(Sender: TObject);
begin
  SetColumns;
  if MessageBox(Self.Handle,
                'Вы действительно хотите удалить' + #10 + #13 +
                  'строку справочника?',
                'Подтверждение',
                mb_YesNo + mb_IconWarning) = IDYes then
  begin
    if FDictObject.DeleteRow >= 0 then
      Reload
    else
      MessageBox(Self.Handle,
                 'Не удалось удалить строку',
                 'Сообщение',
                 mb_OK + mb_IconError);
  end;
end;


procedure TfrmComplexList.CreateForm;
var i, iID: integer;
    sID: string;
begin
  if Assigned(frm) then frm.Free;
  if not Assigned(FDictObject.DictEditFormClass) then
  begin
    frm := TForm.Create(Self);
    frm.Position := poOwnerFormCenter;
    frm.ClientWidth := 260;
    frm.ClientHeight:= 40 + FDictObject.Columns.Count * 40;


    with TButton.Create(frm) do
    begin
      Anchors := [akRight, akBottom];
      Parent:= frm;
      Height:= 25;
      Width:= 75;
      Caption:= 'OK';
      Left:= 50;
      Top:= frm.ClientHeight - 30;
      ModalResult:= mrOK;
      Default:= true;
      TabOrder:= 100;
    end;

    with TButton.Create(frm) do
    begin
      Anchors := [akRight, akBottom];
      Parent:= frm;
      Height:= 25;
      Width:= 75;
      Caption:= 'Отмена';
      Left:= 130;
      Top:= frm.ClientHeight - 30;
      ModalResult:= mrCancel;
      TabOrder:= 101;
    end;

    for i := 0 to FDictObject.Columns.Count - 1 do
    begin
      if not FDictObject.Columns[i].IsKey then
      begin
        with TLabel.Create(frm) do
        begin
          Parent:= frm;
          Left:= 5;
          Height:= 15;
          Top:= i * 40 + 5;
          Caption:= FDictObject.Columns[i].RusColName;
        end;

        if not FDictObject.Columns[i].IsForeignKey then
        with TEdit.Create(frm) do
        begin
          Parent:= frm;
          Left:= 5;
          Width:= 200;
          Height:= 20;
          Top:= i * 40 + 20;
          Width := frm.ClientWidth - 40;
          Anchors := [akLeft, akTop, akRight];
          TabOrder:= i;
          Text := varAsType(FDictObject.Columns[i].Value, varOleStr);
          Tag := Integer(FDictObject.Columns[i]);
        end
        else
        with TComboBox.Create(frm) do
        begin
          Parent:= frm;
          Left:= 5;
          Width:= 200;
          Height:= 20;
          Top:= i * 40 + 20;
          Width := frm.ClientWidth - 40;
          Anchors := [akLeft, akTop, akRight];
          TabOrder:= i;
          Style := csDropDownList;
          (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(Items, FDictObject.Columns[i].ReferDict.Dict);
          sID := trim(varAsType(FDictObject.Columns[i].Value, varOleStr));
          if sID <> '' then
          begin
            iID := StrToInt(sId);
            ItemIndex := Items.IndexOfObject(TObject(iID));
          end;
          Tag := Integer(FDictObject.Columns[i]);
        end
      end;
    end;//if iAttrCount > 0
  end
  else
  begin
    frm := FDictObject.DictEditFormClass.Create(Self);
    (frm as FDictObject.DictEditFormClass).Dict := FDictObject;
  end;
end;

procedure TfrmComplexList.ClearForm;
var i: integer;
begin
  if not (frm is FDictObject.DictEditFormClass) then
  begin
    for i := 0 to frm.ControlCount - 1 do
    if frm.Controls[i] is TEdit then
      (frm.Controls[i] as TEdit).Clear
  end
  else
    (frm as FDictObject.DictEditFormClass).ClearControls;
end;


procedure TfrmComplexList.SaveValues;
var i: integer;
    c: TColumn;
    v: variant;
begin
  if not (frm is FDictObject.DictEditFormClass) then
  begin
    for i := 1 to frm.ControlCount - 1 do
    if frm.Controls[i] is TEdit then
    with frm.Controls[i] as TEdit do
    begin
      c := TColumn(Tag);
      v := Text;
      c.Value := v;
    end
    else
    if frm.Controls[i] is TComboBox then
    with frm.Controls[i] as TComboBox do
    begin
      c := TColumn(Tag);
      if ItemIndex > -1 then
        v := Integer(Items.Objects[ItemIndex])
      else v := null;

      c.Value := v;
    end
  end
  else (frm as FDictObject.DictEditFormClass).SaveValues;
end;

procedure TfrmComplexList.SetColumns(Full: boolean = true);
var i: integer;
begin
  if Assigned(lwCurrentDict.Selected) then
  begin
    FDictObject.Columns[0].Value := lwCurrentDict.Selected.Caption;

    for i := 0 to lwCurrentDict.Selected.SubItems.Count - 1 do
      FDictObject.Columns[i + 1].Value := lwCurrentDict.Selected.SubItems[i];
  end;
end;

procedure TfrmComplexList.Reload;
var S: string;
begin
  S := FDictName;
  FDictName := '';
  DictName := S;
end;

procedure TfrmComplexList.strgrCurrentDictSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if trim(lwCurrentDict.Selected.Caption) <> '' then
    SelectedElementID := StrToInt(lwCurrentDict.Selected.Caption);
end;

constructor TfrmComplexList.Create(AOwner: TComponent);
begin
  inherited;
  FSelectedElement := TStringList.Create;
  chbxShowIDs.Checked := true;
end;

destructor TfrmComplexList.Destroy;
begin
  FSelectedElement.Free;
  FreeAndNil(FSelectedElementIDs);
  inherited;
end;

procedure TfrmComplexList.strgrCurrentDictDblClick(Sender: TObject);
begin
  if Owner.Owner is TfrmComplexCombo then
    (Owner as TForm).ModalResult := mrOk;
end;

procedure TfrmComplexList.strgrCurrentDictKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
//
end;


procedure TfrmComplexList.SetMultipleSelect(const Value: boolean);
begin
  FMultipleSelect := Value;
  lwCurrentDict.Checkboxes := FMultipleSelect;
  chbxShowIDs.Checked := FMultipleSelect;
  if lwCurrentDict.Columns.Count > 0 then
    lwCurrentDict.Columns[0].Width := 30;
end;

procedure TfrmComplexList.lwCurrentDictMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var li: TListItem;
    iIndex: integer;
begin
  li := lwCurrentDict.GetItemAt(X, Y);
  if Assigned(li) then
  begin
    if li.Checked then
    begin
      iIndex := SelectedElementIDs.IndexOfObject(TObject(StrToInt(li.Caption)));
      if iIndex = -1 then
        SelectedElementIDs.AddObject(li.SubItems[0], TObject(StrToInt(li.Caption)))
    end
    else
    begin
      iIndex := SelectedElementIDs.IndexOfObject(TObject(StrToInt(li.Caption)));
      if iIndex > -1 then
        SelectedElementIDs.Delete(iIndex);
    end;

    if not MultipleSelect then
    begin
      SelectedElementID := StrToInt(li.Caption);
      FSelectedElementName := li.SubItems[0];
    end;
  end;
end;

function TfrmComplexList.GetSelectedElementIDs: TStringList;
begin
  if not Assigned(FSelectedElementIDs) then
    FSelectedElementIDs := TStringList.Create;

  Result := FSelectedElementIDs;
end;

procedure TfrmComplexList.SetSelectedElementIDs(const Value: TStringList);
var i: integer;
    li: TListItem;
begin
  SelectedElementIDs.Clear;
  SelectedElementIDs.AddStrings(Value);

  ClearMultipleSelection;
  for i := 0 to SelectedElementIDs.Count - 1 do
  begin
    li := GetListItemByID(Integer(FSelectedElementIDs.Objects[i]));
    if Assigned(li) then
    begin
      li.Checked := true;
      li.MakeVisible(false);
    end;
  end;
end;

procedure TfrmComplexList.ClearMultipleSelection;
var i: integer;
begin
  for i := 0 to lwCurrentDict.Items.Count - 1 do
    lwCurrentDict.Items[i].Checked := false;
end;

function TfrmComplexList.GetListItemByID(AID: integer): TListItem;
var i: integer;
begin
  Result := nil;
  for i := 0 to lwCurrentDict.Items.Count - 1 do
  if StrToInt(lwCurrentDict.Items[i].Caption) = AID then
  begin
    Result := lwCurrentDict.Items[i];
    break;
  end;
end;

procedure TfrmComplexList.btnNextClick(Sender: TObject);
var i, j, iStartIndex: integer;
    bNoValue: Boolean;
begin
  if Assigned(lwCurrentDict.Selected) then iStartIndex := lwCurrentDict.Selected.Index + 1
  else iStartIndex := 0;

  if iStartIndex >= lwCurrentDict.Items.Count  then iStartIndex := 0;

  bNoValue := true;
  if Trim(edtSearch.Text) <> '' then
  begin
    for j := iStartIndex to lwCurrentDict.Items.Count - 1 do
    if pos(AnsiUpperCase(Trim(edtSearch.Text)), AnsiUpperCase(lwCurrentDict.Items[j].Caption)) = 1 then
    begin
      lwCurrentDict.Items[j].Selected := true;
      lwCurrentDict.Items[j].MakeVisible(false);
      bNoValue := false;
      Break;
    end;

    if bNoValue then
    begin
      for j := iStartIndex to lwCurrentDict.Items.Count - 1 do
      if pos(AnsiUpperCase(Trim(edtSearch.Text)), AnsiUpperCase(lwCurrentDict.Items[j].Caption)) > 0 then
      begin
        lwCurrentDict.Items[j].Selected := true;
        lwCurrentDict.Items[j].MakeVisible(false);
        bNoValue := false;
        Break;
      end;
    end;

    if bNoValue then
    for i := 0 to lwCurrentDict.Columns.Count - 2 do
    begin
      for j := iStartIndex to lwCurrentDict.Items.Count - 1 do
      if pos(AnsiUpperCase(Trim(edtSearch.Text)), AnsiUpperCase(lwCurrentDict.Items[j].SubItems[i])) = 1 then
      begin
        lwCurrentDict.Items[j].Selected := true;
        lwCurrentDict.Items[j].MakeVisible(false);
        bNoValue := False;
        Break;
      end;

      if bNoValue then
      for j := iStartIndex to lwCurrentDict.Items.Count - 1 do
      if pos(AnsiUpperCase(Trim(edtSearch.Text)), AnsiUpperCase(lwCurrentDict.Items[j].SubItems[i])) > 0 then
      begin
        lwCurrentDict.Items[j].Selected := true;
        lwCurrentDict.Items[j].MakeVisible(false);
        Break;
      end;
    end;
  end;
end;

end.
