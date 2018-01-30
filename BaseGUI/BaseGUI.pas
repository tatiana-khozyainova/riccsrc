unit BaseGUI;

interface

uses Classes, Forms, Windows, Controls, StdCtrls, Contnrs,
     SysUtils, CheckLst, Grids, ComCtrls, Graphics, ActnList;

type
  TAdapterButton = (abAutoSave, abClear, abSave, abReload, abAdd, abDelete, abFind,
                    abSort, abSelectAll, abAddGroup, abEdit, abCancel);
  TAdapterButtons = set of TAdapterButton;

  TCheckEvent = procedure (Sender: TObject) of object;
  TParameterType = (ptChangesDisabled, ptDate, ptString, ptFloat, ptInteger, ptSelect, ptBoolean, ptNonEmptyList, ptTreeMultiSelect);


  THintedControl = class
  private
    FEmptyAllowed: boolean;
    FName: string;
    FPreCheckEvent: TCheckEvent;
    FControl: TControl;
    FAdditional: TObject;
    FValueType: TParameterType;
  public
    // событие которое было повешено на элемент до этого
    property PreCheckEvent: TCheckEvent read FPreCheckEvent write FPreCheckEvent; 
    // основной компонент
    property Control: TControl read FControl write FControl;
    // дополнение, например, строка или столбец  таблицы
    property Additional: TObject read FAdditional write FAdditional;
    property ValueType: TParameterType read FValueType write FValueType;
    // не считать пустое значение ошибкой
    property EmptyAllowed: boolean read FEmptyAllowed write FEmptyAllowed; 
    property Name: string read FName write FName;
  end;


  THintManager = class(TList)
  private
    FStatus:  TControl;
    FErrorRow: integer;
    FCheckEvent: TCheckEvent;

    function  GetItem(const Index: integer): THintedControl;
    procedure sgrDrawCell(Sender: TObject; ACol, ARow: Integer;
                          Rect: TRect; State: TGridDrawState);
    procedure CheckArray(const AParamIndex: integer);
    function  GetByName(const AName: string): integer;
    function  GetItemsByName(const AName: string): THintedControl;
    function  TreeViewMultiSelectionApplied(ATrw: TTreeView): integer;

    function  GetValue(AHintedControl: THintedControl): string;
  public
    function  Add(AControl: TControl; AAdditional: TObject; const AValueType: TParameterType; const AName: string; const AEmptyAllowed: boolean): THintedControl;
    property  Status: TControl read FStatus write FStatus;
    property  Items[const Index: integer]: THintedControl read GetItem;
    property  ItemsByName[const AName: string]: THintedControl read GetItemsByName;


    // проверяет всюду ли введены валидные значения
    function  Check: boolean;
    property  CheckEvent: TCheckEvent read FCheckEvent write FCheckEvent;
    procedure Clear; override;

    constructor Create(AStatus: TControl);
    destructor Destroy; override;
  end;



  IGUIAdapter = interface
    function    GetChangeMade: boolean;
    procedure   SetChangeMade(const Value: boolean);
    function    GetAutoSave: boolean;
    procedure   SetAutoSave(const Value: boolean);
    function    GetAdapterButtons: TAdapterButtons;
    procedure   SetAdapterButtons(const Value: TAdapterButtons);

    procedure   BeforeReload;
    procedure   AfterReload;
    procedure   AfterAdd;
    procedure   AfterDelete;

    procedure   Clear;
    procedure   SelectAll;
    function    Save: integer;

    procedure   Reload;
    function    Add: integer;
    function    Delete: integer;

    function    StartFind: integer;

    property    Buttons: TAdapterButtons read GetAdapterButtons write SetAdapterButtons;
    property    ChangeMade: boolean read GetChangeMade write SetChangeMade;
    property    AutoSave: boolean read GetAutoSave write SetAutoSave;
  end;

  TGUIAdapter = class(TComponent)
  private
    FChangeMade: boolean;
    FAutoSave: boolean;
    FAdapterButtons: TAdapterButtons;
    FOnAfterReload, FOnAfterAdd, FOnAfterDelete: TNotifyEvent;
    FOnBeforeReload: TNotifyEvent;
    procedure   DoOnExitEvent(Sender: TObject);
    function    GetFrame: TFrame;
    procedure   BtnFindFormClose(Sender: TObject);
    function    GetApplyCancelSaveMode: boolean;

  protected
    frmFind:    TForm;
    function    GetChangeMade: boolean;
    procedure   SetChangeMade(const Value: boolean);
    function    GetAutoSave: boolean;
    procedure   SetAutoSave(const Value: boolean);
    function    GetAdapterButtons: TAdapterButtons;
    procedure   SetAdapterButtons(const Value: TAdapterButtons);
    procedure   BeforeReload; virtual;
    procedure   AfterReload; virtual;
    procedure   AfterAdd; virtual;
    procedure   AfterDelete; virtual;

    function    GetCanAddGroup: boolean; virtual;    
    function    GetCanAdd: boolean; virtual;
    function    GetCanDelete: boolean; virtual;
    function    GetCanEdit: boolean; virtual;
    function    GetCanSave: boolean; virtual;
    function    GetCanReload: boolean; virtual;
    function    GetCanClear: boolean; virtual;
    function    GetCanFind: boolean; virtual;
    function    GetCanCancel: boolean; virtual;
  public
    property    CanClear: boolean read GetCanClear;
    procedure   Clear; virtual;


    procedure   SelectAll; virtual;

    property    CanSave: boolean read GetCanSave;
    function    Save: integer; virtual;

    property    CanReload: boolean read GetCanReload;
    procedure   Reload; virtual;

    property    CanAdd: boolean read GetCanAdd;
    function    Add (): integer; virtual;

    property    CanEdit: boolean read GetCanEdit;
    function    Edit: integer; virtual;

    function    Cancel: boolean; virtual;
    property    CanCancel: boolean read GetCanCancel;   

    property    CanAddGroup: boolean read GetCanAddGroup;
    procedure   AddGroup; virtual;

    property    CanDelete: boolean read GetCanDelete;
    function    Delete: integer; virtual;

    property    CanFind: boolean read GetCanFind;
    function    StartFind: integer; virtual;

    property    ChangeMade: boolean read GetChangeMade write SetChangeMade;
    property    AutoSave: boolean read GetAutoSave write SetAutoSave;
    property    Buttons: TAdapterButtons read GetAdapterButtons write SetAdapterButtons;

    property    ApplyCancelSaveMode: boolean read GetApplyCancelSaveMode;

    property    Frame: TFrame read GetFrame;

    property    OnBeforeReload: TNotifyEvent read FOnBeforeReload write FOnBeforeReload;
    property    OnAfterReload: TNotifyEvent read FOnAfterReload write FOnAfterReload;
    property    OnAfterAdd: TNotifyEvent read FOnAfterAdd write FOnAfterAdd;
    property    OnAfterDelete: TNotiFyEvent read FOnAfterDelete write FOnAfterDelete;

    constructor Create(AOwner: TComponent); override;
  end;

  TSortOrder = class
  private
    FName: string;
    FCompare: TListSortCompare;
    FReverseCompare: TListSortCompare;
  public
    property Name: string read FName write FName;
    property Compare: TListSortCompare read FCompare write FCompare;
    property ReverseCompare: TListSortCompare read FReverseCompare write FReverseCompare;
    constructor Create;
  end;

  TSortOrders = class(TObjectList)
  private
    function GetItems(Index: integer): TSortOrder;
  public
    function    AddOrder(AName: string; ACompare, AReverseCompare: TListSortCompare): TSortOrder;
    property    Items[Index: integer]: TSortOrder read GetItems;
    constructor Create;
  end;

  TCollectionGUIAdapter = class(TGUIAdapter)
  private
    FList: TListBox;
    FSortOrders: TSortOrders;
    FStraightOrder: boolean;
    FOrderBy: integer;
    FCheckList: TCheckListBox;
  protected
    function    GetCanSort: boolean; virtual;
  public
    property    OrderBy: integer read FOrderBy write FOrderBy;
    property    StraightOrder: boolean read FStraightOrder write FStraightOrder;

    function    Add: integer; override;

    procedure   AddGroup; override;
    procedure   SelectAll; override;

    property    CanSort: boolean read getCanSort;
    property    SortOrders: TSortOrders read FSortOrders;

    property    List: TListBox read FList write FList;
    property    CheckList: TCheckListBox read FCheckList write FCheckList;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;








  TSubStringFunction = function (SubStr, S: string): boolean;

  var comps: array[0 .. 3] of TSubStringFunction;

  procedure Invert(AListBox: TListBox);

implementation

uses BaseConsts, ExtCtrls;

{ TGUIAdapter }

function Starting(SubStr, S: string): boolean;
begin
  Result := pos(AnsiUpperCase(SubStr), AnsiUpperCase(S)) = 1;
end;

function Containing(SubStr, S: string): boolean;
begin
  Result := pos(AnsiUpperCase(SubStr), AnsiUpperCase(S)) > 0;
end;

function NotContaining(SubStr, S: string): boolean;
begin
  Result := Not Containing(SubStr, S);
end;

function Equal(SubStr, S: string): boolean;
begin
  Result := AnsiUpperCase(SubStr) = AnsiUpperCase(S);
end;


procedure Invert(AListBox: TListBox);
var i: integer;
begin
  for i := 0 to AListBox.Items.Count - 1 do
    AListBox.Selected[i] := not AListBox.Selected[i];
end;

function TGUIAdapter.Add: integer;
begin
  Result := 0;
  AfterAdd;
end;

procedure TGUIAdapter.AddGroup;
begin
  AfterAdd;
end;

procedure TGUIAdapter.AfterAdd;
begin
  if Assigned(FOnAfterAdd) then FOnAfterAdd(Self);
end;

procedure TGUIAdapter.AfterDelete;
begin
  if Assigned(FOnAfterDelete) then FOnAfterDelete(Self);
end;

procedure TGUIAdapter.AfterReload;
begin
  if Assigned(FOnAfterReload) then FOnAfterReload(Self);
end;

procedure TGUIAdapter.BeforeReload;
begin
  DoOnExitEvent(nil);
  if Assigned(FOnBeforeReload) then FOnBeforeReload(Self);
end;

procedure TGUIAdapter.BtnFindFormClose(Sender: TObject);
begin
  if Assigned(frmFind) then frmFind.Close;
end;

function TGUIAdapter.Cancel: boolean;
begin
  Result := false;
end;

procedure TGUIAdapter.Clear;
begin
  ChangeMade := false;
end;

constructor TGUIAdapter.Create(AOwner: TComponent);
begin
  inherited;
  if (AOwner is TFrame) then (AOwner as TFrame).OnExit := DoOnExitEvent;
  FAutoSave := true;
  //FAutoSave := false;
  FAdapterButtons := [abClear, abSave, abReload, abFind]
end;

function TGUIAdapter.Delete: integer;
begin
  Result := 0;
  AfterDelete;
end;

procedure TGUIAdapter.DoOnExitEvent(Sender: TObject);
begin
  if ChangeMade then
  begin
    if AutoSave or (MessageBox(Frame.Handle, PChar(sAutoSaveMessage), PChar('Есть вопрос'), MB_YESNO	+ MB_ICONQUESTION	+ MB_DEFBUTTON1	+ MB_APPLMODAL) = ID_YES) then
      Save
    else ChangeMade := false;
  end;  
end;

function TGUIAdapter.Edit: integer;
begin
  Result := 0;
  AfterAdd;
end;

function TGUIAdapter.GetAdapterButtons: TAdapterButtons;
begin
  Result := FAdapterButtons;
end;

function TGUIAdapter.GetApplyCancelSaveMode: boolean;
begin
  Result := abCancel in Buttons;
end;

function TGUIAdapter.GetAutoSave: boolean;
begin
  Result := FAutoSave;
end;

function TGUIAdapter.GetCanAdd: boolean;
begin
  Result := true;
end;

function TGUIAdapter.GetCanAddGroup: boolean;
begin
  Result := true;
end;

function TGUIAdapter.GetCanCancel: boolean;
begin
  Result := true;
end;

function TGUIAdapter.GetCanClear: boolean;
begin
  Result := true; 
end;

function TGUIAdapter.GetCanDelete: boolean;
begin
  Result := true;
end;

function TGUIAdapter.GetCanEdit: boolean;
begin
  Result := true;
end;

function TGUIAdapter.GetCanFind: boolean;
begin
  Result := true; 
end;

function TGUIAdapter.GetCanReload: boolean;
begin
  Result := true;
end;

function TGUIAdapter.GetCanSave: boolean;
begin
  Result := true;
end;

function TGUIAdapter.GetChangeMade: boolean;
begin
  Result := FChangeMade;
end;

function TGUIAdapter.GetFrame: TFrame;
begin
  Result := nil;
  if Owner is TFrame then
    Result := Owner as TFrame
end;

procedure TGUIAdapter.Reload;
begin
  ChangeMade := false;
  AfterReload;
end;

function TGUIAdapter.Save: integer;
begin
  ChangeMade := false;
  Result := 0;
end;

procedure TGUIAdapter.SelectAll;
begin
  ChangeMade := false;
end;

procedure TGUIAdapter.SetAdapterButtons(const Value: TAdapterButtons);
begin
  FAdapterButtons := Value;

end;

procedure TGUIAdapter.SetAutoSave(const Value: boolean);
begin
  FAutoSave := Value;
end;

procedure TGUIAdapter.SetChangeMade(const Value: boolean);
begin
  FChangeMade := Value;
end;

function TGUIAdapter.StartFind: integer;
var pnl: TPanel;
    btn: TButton;
begin
  Result := 0;
  if not Assigned(frmFind) then
  begin
    // создаём форму с панелькой и кнопкой закрыть
    frmFind := TForm.Create(Application.MainForm);
    frmFind.Parent := nil;
    frmFind.FormStyle := fsStayOnTop;
    frmFind.BorderIcons := [biSystemMenu];
    frmFind.Position := poMainFormCenter;
    frmFind.Tag := 0;
    frmFind.Height := 400;
    frmFind.Width := 400;

    pnl := TPanel.Create(frmFind);
    pnl.Parent := frmFind;
    pnl.Align := alBottom;
    pnl.Height := 50;
    pnl.BevelOuter := bvLowered;


    btn := TButton.Create(pnl);
    btn.Parent := pnl;
    btn.Anchors := [akRight, akBottom];
    btn.OnClick := BtnFindFormClose; 

    btn.Top := 14;
    btn.Left := 100;

    btn.Caption := 'Закрыть';
//    btn.ModalResult := mrCancel;
    Result := 0;
  end;
end;


{ TSortOrder }

constructor TSortOrder.Create;
begin
  
end;


{ TSortOrders }

function TSortOrders.AddOrder(AName: string;
  ACompare, AReverseCompare: TListSortCompare): TSortOrder;
begin
  Result := TSortOrder.Create;
  Result.Name := AName;
  Result.Compare := ACompare;
  Result.ReverseCompare := AReverseCompare;

  Add(Result);
end;

constructor TSortOrders.Create;
begin
  inherited Create(true);
end;

function TSortOrders.GetItems(Index: integer): TSortOrder;
begin
   Result := inherited Items[Index] as TSortOrder;
end;

{ TCollectionGUIAdapter }

function TCollectionGUIAdapter.Add: integer;
begin
  if Assigned (List) then
  begin
    List.ItemIndex := List.Count - 1;
    List.Selected[List.ItemIndex] := true;
  end;
    
  Result := inherited Add;
end;

procedure TCollectionGUIAdapter.AddGroup;
begin
  inherited;

end;

constructor TCollectionGUIAdapter.Create(AOwner: TComponent);
begin
  inherited;
  FSortOrders := TSortOrders.Create;
end;

destructor TCollectionGUIAdapter.Destroy;
begin
  FSortOrders.Free;
  inherited;
end;

function TCollectionGUIAdapter.getCanSort: boolean;
begin
  Result := SortOrders.Count > 0;
end;

procedure TCollectionGUIAdapter.SelectAll;
var i: integer;
begin
  inherited;
  if Assigned (CheckList) then
    for i := 0 to CheckList.Count - 1 do
      CheckList.Checked[i] := true;
  ChangeMade := true;
end;



{ THintManager }

function THintManager.Add(AControl: TControl; AAdditional: TObject;
  const AValueType: TParameterType; const AName: string;
  const AEmptyAllowed: boolean): THintedControl;
var hC: THintedControl;
begin
  hC := ItemsByName[AName];
  if Assigned(hC) then exit;


  hC := THintedControl.Create;

  with hC do
  begin
    Control := AControl;
    Additional := AAdditional;
    ValueType := AValueType;
    Name := AName;
    EmptyAllowed := AEmptyAllowed;

    if Assigned(CheckEvent) then
    begin
      //FPreCheckEvent := nil;
      if Control is TEdit then
      begin
        // сохраняем старое действие, которое там было
        // то есть пробуем
        if Assigned((Control as TEdit).OnChange) and not Assigned(FPreCheckEvent) then
          FPreCheckEvent := (Control as TEdit).OnChange;
        (Control as TEdit).OnChange := CheckEvent
      end
      else
      if Control is TCombobox then
      begin
        if (Assigned((Control as TComboBox).OnChange)) and not Assigned(FPreCheckEvent) then
          FPreCheckEvent := (Control as TComboBox).OnChange;
        (Control as TCombobox).OnChange := CheckEvent
      end
      {else if (Control is TDateEdit) then
      begin
        if Assigned((Control as TDateEdit).OnChange) and not Assigned(FPreCheckEvent) then
          FPreCheckEvent := (Control as TDateEdit).OnChange;
        (Control as TDateEdit).OnChange := CheckEvent
      end}
      else if (Control is TLabeledEdit) then
      begin
        if Assigned((Control as TLabeledEdit).OnChange) and not Assigned(FPreCheckEvent) then
          FPreCheckEvent := (Control as TLabeledEdit).OnChange;
        (Control as TLabeledEdit).OnChange := CheckEvent
      end;
    end;
  end;

  inherited Add(hC);
  Result := hC;
end;

function THintManager.Check: boolean;
var i, j: integer;
    Val: String;
    edt: TEdit;
begin
  Result := true;
  for i := 0 to Count - 1 do
  with Items[i] do
  begin
    Val := '';
    edt := nil;
    FErrorRow := -1;
    if (Status is TLabel) then
       (Status as TLabel).Caption := ''
    else if (Status is TStatusBar) then
    begin
      (Status as TStatusBar).SimpleText := '';
      for j := 0 to (Status as TStatusBar).Panels.Count - 2 do
        (Status as TStatusBar).Panels[j].Text := '';
    end;

    if Assigned(FPreCheckEvent) then
    if (@FPreCheckEvent <> @FCheckEvent) then
      FPreCheckEvent(nil);

    try
      Val := trim(GetValue(Items[i]));

      if not (Control is TStringGrid) then
      begin
        if EmptyAllowed and (trim(Val) = '') then continue;

        case ValueType of
        ptTreeMultiSelect: if Val = '0' then raise Exception.Create('Список не заполнен');
        ptNonEmptyList: if Val = '0' then raise Exception.Create('Список не заполнен');
        ptSelect: if Val = '' then raise Exception.Create('Ничего не выбрано');
        ptDate: StrToDateTime(Val);
        ptFloat:
        begin
          val := StringReplace(Val, ',', DecimalSeparator, []);
          val := StringReplace(Val, '.', DecimalSeparator, []);
          StrToFloat(Val);
        end;
        ptInteger: StrToInt(Val);
        ptBoolean: if not (StrToInt(Val) in [0, 1]) then raise Exception.Create('Неверное преобразование');
        ptString: if Val = '' then raise Exception.Create('Неверное преобразование');
        end
      end
      else CheckArray(i);

    except
      if (Status is TLabel) then
        (Status as TLabel).Caption := Format('Проверьте значение %s', [Name])
      else
      if (Status is TStatusBar) then
        (Status as TStatusBar).Panels[0].Text := Format('Проверьте значение %s', [Name]);

      if Assigned(edt) then
      begin
        edt.Font.Color := clRed;
        edt.Font.Style := [fsBold];
      end;

      if (Control is TStringGrid) then
         (Control as TStringGrid).OnDrawCell := sgrDrawCell;

      Result := false;
      break;
    end
  end;
end;

procedure THintManager.CheckArray(const AParamIndex: integer);
var i: integer;
    strs: TStrings;
begin
  FErrorRow := -1;
  strs := Items[AParamIndex].Additional as TStrings;
  for i := 1 to strs.Count - 1 do
  begin
    FErrorRow := i;
    if Items[AParamIndex].EmptyAllowed and (trim(Strs[i]) = '') then continue;
    case Items[AParamIndex].ValueType of
      ptDate: StrToDateTime(strs[i]);
      ptFloat:
      begin
        Strs[i] := StringReplace(Strs[i], ',', DecimalSeparator, []);
        Strs[i] := StringReplace(Strs[i], ',', DecimalSeparator, []);
        StrToFloat(Strs[i]);
      end;
      ptInteger: StrToInt(Strs[i]);
      ptBoolean: if not (StrToInt(Strs[i]) in [0, 1]) then raise Exception.Create('Неверное преобразование');
      ptString: if Strs[i] = '' then raise Exception.Create('Неверное преобразование');
    end;
  end;
end;

procedure THintManager.Clear;
var i: integer;
begin
  try
    for i := Count - 1 downto 0 do
    with Items[i] do
    begin
      if Control is TEdit then
        // возвращаем всё на место
        // если обработчик уничтожен (очищен)
        (Control as TEdit).OnChange := FPreCheckEvent
      else
      if Control is TCombobox then
        (Control as TCombobox).OnChange := FPreCheckEvent;
      Items[i].Free;
    end;
  finally
    inherited Clear;
  end;
  inherited Clear;
end;

constructor THintManager.Create(AStatus: TControl);
begin
  inherited Create;
  Status := AStatus;
end;

destructor THintManager.Destroy;
begin
  inherited Destroy;
end;

function THintManager.GetByName(const AName: string): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
  if AnsiUpperCase(Items[i].Name) = AnsiUpperCase(AName) then
  begin
    Result := i;
    break;
  end;
end;

function THintManager.GetItem(const Index: integer): THintedControl;
begin
  Result := THintedControl(inherited Items[Index]);
end;

function THintManager.GetItemsByName(const AName: string): THintedControl;
var i: integer;
begin
  i := GetByName(AName);
  if i > -1 then
    Result := Items[i]
  else
    Result := nil;
end;


function THintManager.GetValue(AHintedControl: THintedControl): string;
var val: string;
begin
  with AHintedControl do
  if Control is TCustomEdit then
  begin
    val := (Control as TCustomEdit).Text;
    if Control is TEdit then
    begin
      (Control as TEdit).Font.Color := clBlack;
      (Control as TEdit).Font.Style := [];
    end
    else if Control is TLabeledEdit then
    begin
      (Control as TLabeledEdit).Font.Color := clBlack;
      (Control as TLabeledEdit).Font.Style := [];
    end;
  end
  else if Control is TComboBox then Val := (Control as TComboBox).Text
  else if Control is TMemo then Val := (Control as TMemo).Text
  else if Control is TStringGrid then
    (Control as TStringGrid).OnDrawCell := nil
  else if Control is TRadioGroup then
  begin
    with (Control as TRadioGroup) do
    if ItemIndex > -1 then Val := trim(Items[ItemIndex]);
  end
  else if Control is TListBox then
  with Control as TListBox do
  begin
    case ValueType of
      ptNonEmptyList: Val := IntToStr(Items.Count);
      ptSelect: if ItemIndex > -1 then Val := trim(Items[ItemIndex]);
    end;
  end
  else if Control is TTreeView then
  with Control as TTreeView do
  begin
    case ValueType of
      ptNonEmptyList: Val := IntToStr(Items.Count);
      ptSelect: if Assigned(Selected) then Val := Selected.Text;
      ptTreeMultiSelect: Val := IntToStr(TreeViewMultiSelectionApplied(Control as TTreeView));
    end;
  end;

  Result := Val;
end;

procedure THintManager.sgrDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if  (FErrorRow > -1) then
  begin
    if (ARow = FErrorRow) then
    with (Sender  as TStringGrid) do
    begin
      Canvas.Font.Color := clRed;
      Canvas.Font.Style := [fsBold];
      Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
    end;
  end;
end;

function THintManager.TreeViewMultiSelectionApplied(ATrw: TTreeView): integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to ATrw.Items.Count - 1 do
    Result := Result + ord(ATrw.Items[i].SelectedIndex = 1);
end;





initialization
  comps[0] := Starting;
  comps[1] := Containing;
  comps[2] := Equal;
  comps[3] := NotContaining;
end.
