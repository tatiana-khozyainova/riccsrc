unit RRManagerBaseGUI;

interface

uses Classes, RRManagerBaseObjects, Controls, Windows,
     Grids, Forms, ActnList, SysUtils, ClientCommon, StdCtrls,
     Graphics, ExtCtrls, ComCtrls, FramesWizard, Dialogs, Contnrs,
     ImgList, Menus, BaseObjects;

type

  TBaseAction = class;

  TbaseActionClass = class of TBaseAction;



  TVisualizationOption = class(TPersistent)
  private
    FRepresent: smallint;
    FListOption: TListOption;
    FFixVisualization: boolean;
    FShowUINs: boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property  Represent: smallint read FRepresent write FRepresent;
    property  ListOption: TListOption read FListOption write FListOption;
    property  FixVisualization: boolean read FFixVisualization write FFixVisualization;
    property  ShowUINs: boolean read FShowUINs write FShowUINs;

  end;

  TVisualizationOptions = class(TList)
  private
    FCurrent: TVisualizationOption;
    function GetItem(const Index: integer): TVisualizationOption;
  public
    property  Items[const Index: integer]: TVisualizationOption read GetItem;
    property  Current: TVisualizationOption read FCurrent;
    procedure Push;
    procedure Pop;
  end;

  TParameterType = (ptChangesDisabled, ptDate, ptString, ptFloat, ptInteger, ptSelect, ptBoolean, ptNonEmptyList, ptTreeMultiSelect);

  TCheckEvent = procedure (Sender: TObject) of object;
  
  THintedControl = class
    // событие которое было повешено на элемент до этого
    FPreCheckEvent: TCheckEvent;
    // основной компонент
    Control: TControl;
    // дополнение, например, строка или столбец  таблицы
    Additional: TObject;
    ValueType: TParameterType;
    // не считать пустое значение ошибкой
    EmptyAllowed: boolean;
    Name: string;
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
  public
    function  Add(AControl: TControl; AAdditional: TObject; const AValueType: TParameterType; const AName: string; const AEmptyAllowed: boolean): THintedControl;
    procedure RemoveByName(const AName: string);
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



  TBaseFrame = class(TFrame)
  private
    FEditingClass: TbaseObjectClass;
    FParentClass: TBaseObjectClass;
    FInspector: THintManager;
    FStatusBar: TStatusBar;
    FSaved: boolean;
    FEdited: boolean;
    FNeedCopyState: boolean;
    procedure SetEditingObject(const Value: TbaseObject);
    procedure SetNeedCopyState(const Value: boolean);
    function GetFormOwner: TForm;
  protected
    FEditingObject: TbaseObject;
    procedure PreloadObject(ABaseObject: TBaseObject); virtual;
    procedure FillControls(ABaseObject: TBaseObject); virtual; abstract;
    procedure ClearControls; virtual; abstract;
    procedure FillParentControls; virtual;
    procedure RegisterInspector; virtual;
    procedure CheckEvent(Sender: TObject);
  public
    property Inspector: THintManager read FInspector write FInspector;
    function Check: boolean; virtual;
    function UnCheck: boolean;
    property StatusBar: TStatusBar read FStatusBar  write FStatusBar;
    procedure ReportStatus(AStatus: string);
    property EditingClass: TbaseObjectClass read FEditingClass write FEditingClass;
    property ParentClass: TBaseObjectClass read FParentClass write FParentClass;

    property FormOwner: TForm read GetFormOwner;

    property EditingObject: TBaseObject read FEditingObject write SetEditingObject;

    property NeedCopyState: boolean read FNeedCopyState write SetNeedCopyState; 
    property Edited: boolean read FEdited write FEdited;
    property Saved: boolean read FSaved;
    procedure Save; virtual;
    procedure CancelEdit; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TBaseFrameClass = class of TBaseFrame;




  TBaseAction = class(TAction)
  private
    FLastCollection: TBaseCollection;
    FLastObject: TBaseObject;
    FCanUndo: boolean;
    FDestroyObject: boolean;
    FDestroyCollection: boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // последние над которыми проводились операции
    property LastObject: TBaseObject read FLastObject;
    property LastCollection: TBaseCollection read FLastCollection write FLastCollection;
    // методы выполнения с контекстом и без
    function Execute: boolean; overload; override;
    function Execute(ABaseObject: TBaseObject): boolean; reintroduce; overload; virtual;
    function Execute(ABaseCollection: TBaseCollection): boolean; reintroduce; overload; virtual;
    function Execute(ASQL: string): boolean; reintroduce; overload; virtual;
    // может быть откат или нет
    property CanUndo: boolean read FCanUndo write FCanUndo;
    // удалять ли последнюю коллекцию или объъект при уничтожении команды
    property DestroyCollection: boolean read FDestroyCollection write FDestroyCollection;
    property DestroyObject: boolean read FDestroyObject write FDestroyObject;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TBaseActionList = class(TActionList)
  private
    function GetActions(const Index: integer): TBaseAction;
    function GetActionByClassType(AClass: TBAseActionClass): TBaseAction;
  public
    property ActionByClassType[AClass: TBAseActionClass]: TBaseAction read GetActionByClassType;
    property Items[const Index: integer]: TBaseAction read GetActions;
    constructor Create(AOwner: TComponent); override;
  end;


  TCommonForm = class(TForm)
  private
    FTlbr:    TToolBar;
    FImageList: TImageList;
    FActnList:  TBaseActionList;
    FOnAfterBasketClosed: TNotifyEvent;
    FToolBarVisible: boolean;
    procedure FormCreate(Sender: TObject);
    procedure OnGetFromBasket(Sender: TObject);
    procedure SetToolBarVisible(const Value: boolean);
  protected
    procedure SetEditingObject(const Value: TBaseObject); virtual;
    function  GetEditingObject: TBaseObject; virtual;
    function  GetDlg: TDialogFrame; virtual; abstract;
    procedure NextFrame(Sender: TObject); virtual;
    function  GetEditingObjectName: string; virtual;
    procedure ValidateFinishButton(Sender: TObject; var EnabledState: boolean);
  public
    { Public declarations }
    property  Dlg: TDialogFrame read GetDlg;
    property  EditingObject: TBaseObject read GetEditingObject write SetEditingObject;
    property  EditingObjectName: string read GetEditingObjectName;
    property  OnAfterBasketClosed: TNotifyEvent read FOnAfterBasketClosed write FOnAfterBasketClosed;
    procedure Save; virtual;
    procedure CancelEdit;
    property  ToolBarVisible: boolean read FToolBarVisible write SetToolBarVisible;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;


  TSingleFramedForm = class(TForm)
  private
    FFrame:     TBaseFrame;
    FFrameClass: TBaseFrameClass;
    FShowButtons: boolean;
    FPnlButtons: TPanel;
    function    GetEditingObject: TBaseObject;
    function    GetFrame: TBaseFrame;
    procedure   SetFrameClass(const Value: TBaseFrameClass);
    procedure   SetShowButtons(const Value: boolean);
  protected
    procedure   SetEditingObject(const Value: TBaseObject); virtual;
    function    GetEditingObjectName: string; virtual;
  public
    property    Frame: TBaseFrame read GetFrame;
    property    FrameClass: TBaseFrameClass read FFrameClass write SetFrameClass;
    property    EditingObject: TBaseObject read GetEditingObject write SetEditingObject;
    property    EditingObjectName: string read GetEditingObjectName;
    procedure   Save; virtual;
    procedure   CancelEdit;
    property    ShowButtons: boolean read FShowButtons write SetShowButtons;
    constructor Create(AOwner: TComponent; AFrameClass: TBaseFrameClass); reintroduce; overload; virtual;
    constructor Create(AOwner: TComponent); overload; override;
  end;

  TAdditionalFilter = class(TCollectionItem)
  private
    FImageIndex: integer;
    FFilterName: string;
    FQuery: string;
  public
    property Query: string read FQuery;
    property ImageIndex: integer read FImageIndex;
    property FilterName: string read FFilterName;
  end;

  TAdditionalFilters = class(TCollection)
  private
    function GetItems(const Index: integer): TAdditionalFilter;
  public
    property Items[const Index: integer]: TAdditionalFilter read GetItems;
    function Add(const AFilterName, AQuery: string; const AImageIndex: integer): TAdditionalFilter;
    procedure MakeList(AList: TStrings);
    constructor Create; virtual;
  end;


  TMenuClass = class of TMenu;

  TMenuList = class(TObjectList)
  private
    FImages: TCustomImageList;
    function GetMenu(Index: integer): TMenu;
  public
    property Items[Index: integer]: TMenu read GetMenu;
    function AddMenuItem(AIndex: integer; AMenuItem: TMenuItem; AAction: TBaseAction): TMenuItem; overload;
    function AddMenuItem(AMenu: TMenu; AAction: TBaseAction): TMenuItem; overload;
    function AddMenu(AClass: TMenuClass; AOwner: TComponent): TMenu;
    constructor Create(AImages: TCustomImageList);
  end;

  function AddToolButton(AToolBar: TToolBar; AAction: TBaseAction): TToolButton;

var AllOpts: TVisualizationOptions;

implementation

uses RRManagerBasketForm, ToolEdit, ClientProgressBarForm, Facade;

type

  TBasketFormShowAction = class(TBaseAction)
  public
    function    Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


{ TMenuList }


function TMenuList.AddMenu(AClass: TMenuClass; AOwner: TComponent): TMenu;
begin
  Result := AClass.Create(AOwner);
  Result.Images := FImages;
  Add(Result);
end;

function TMenuList.AddMenuItem(AIndex: integer; AMenuItem: TMenuItem;
  AAction: TBaseAction): TMenuItem;
begin
  Result := TMenuItem.Create(AMenuItem.GetParentMenu);
  AMenuItem.Insert(AIndex, Result);
  if Assigned(AAction) then
    Result.Action := AAction
  else
    Result.Caption := '-';
end;

function TMenuList.AddMenuItem(AMenu: TMenu;
  AAction: TBaseAction): TMenuItem;
begin
  Result := TMenuItem.Create(AMenu);
  AMenu.Items.Add(Result);
  if Assigned(AAction) then
    Result.Action := AAction
  else
    Result.Caption := '-';
end;

constructor TMenuList.Create(AImages: TCustomImageList);
begin
  inherited;
  OwnsObjects := true;
  FImages := AImages;
end;

function TMenuList.GetMenu(Index: integer): TMenu;
begin
  Result := inherited Items[Index] as TMenu;
end;


{ TAdditionalFilters }

function TAdditionalFilters.Add(const AFilterName, AQuery: string;
  const AImageIndex: integer): TAdditionalFilter;
begin
  Result := inherited Add as TAdditionalFilter;
  with Result do
  begin
    FFilterName := AFilterName;
    FQuery := AQuery;
    FImageIndex := AImageIndex;
  end;
end;

constructor TAdditionalFilters.Create;
begin
  inherited Create(TAdditionalFilter);
end;

function TAdditionalFilters.GetItems(
  const Index: integer): TAdditionalFilter;
begin
   Result := inherited Items[Index] as TAdditionalFilter;
end;

procedure TAdditionalFilters.MakeList(AList: TStrings);
var i: integer;
begin
  AList.Clear;
  for i := 0 to Count - 1 do
    AList.AddObject(Items[i].FilterName, Items[i]);
end;
  

{ TBaseAction }

function AddToolButton(AToolBar: TToolBar; AAction: TBaseAction): TToolButton;
begin
  Result := TToolButton.Create(AToolBar);
  Result.Parent := AToolBar;

  if Assigned(AAction) then
  begin
    Result.Action := AAction;
    Result.Enabled := AAction.Enabled;
    Result.Visible := AAction.Visible;
  end;
end;

function TBaseAction.Execute: boolean;
var bacls: TBaseActionClass;
begin
  inherited Execute;
  Result := true;
  bacls := TBaseActionClass(Self.ClassType);
end;

function TBaseAction.Execute(ABaseObject: TBaseObject): boolean;
begin
  FLastObject := ABaseObject;
  Result := Execute;
end;

constructor TBaseAction.Create(AOwner: TComponent);
begin
  inherited;
  // это перенастраивается в потомках
  // коллекции унеичтожаем по умолчанию
  DestroyCollection := true;
  // объекты оставляем
  DestroyObject := false;
  // всегда разрешено
  DisableIfNoHandler := false;
end;

destructor TBaseAction.Destroy;
begin
  // LastObject и LastCollection создаются илм ассоциируются с какими-то глобальными переменными -
  // в конструкторах потомков, а уничтодаются - здесь
  if DestroyCollection then
  try
    if Assigned(LastCollection) then LastCollection.Free;
    LastCollection := nil;
  except

  end;

  if DestroyObject then
  try
    if Assigned(LastObject) then LastObject.Free;
  except

  end;

  inherited;  
end;

function TBaseAction.Execute(ABaseCollection: TBaseCollection): boolean;
begin
  FLastCollection := ABaseCollection;
  Result := Execute;
end;

function TBaseAction.Execute(ASQL: string): boolean;
var iResult: integer;
begin
  inherited Execute;
  Result := true;

  if trim(ASQL) <> '' then
    iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery(ASQL)
  else iResult := 0;

  Result := iResult >= 0;
end;

procedure TBaseAction.AssignTo(Dest: TPersistent);
var ba: TBaseAction;
begin
  inherited;
  ba := Dest as TBaseAction;
  ba.DestroyCollection := false;
  ba.DestroyObject := false;
  ba.FLastCollection := LastCollection;
  ba.FLastObject := LastObject;
  ba.CanUndo := false;
end;

{ TBaseActionList }

constructor TBaseActionList.Create(AOwner: TComponent);
begin
  inherited;

end;

function TBaseActionList.GetActionByClassType(
  AClass: TBAseActionClass): TBaseAction;
var i: integer;
begin
  Result := nil;
  for i := 0 to ActionCount - 1 do
  if Actions[i].ClassType = AClass then
  begin
    Result := Actions[i] as TBaseAction;
    break;
  end;

  if not Assigned(Result) then
  begin
    for i := 0 to ActionCount - 1 do
    if Actions[i] is AClass then
    begin
      Result := Actions[i] as TBaseAction;
      break;
    end;
  end;


  if not Assigned(Result) then
  begin
    Result := AClass.Create(Self);
    Result.ActionList := Self;
  end;
end;

function TBaseActionList.GetActions(const Index: integer): TBaseAction;
begin
  result := inherited Actions[Index] as TBaseAction;
end;

{ TBaseFrame }


{ TBaseFrame }

procedure TBaseFrame.CancelEdit;
begin
end;

function TBaseFrame.Check: boolean;
begin
  Result := FInspector.Check;
  if Owner is TDialogFrame then
  with Owner as TDialogFrame do
    btnNext.Enabled :=  (NextActiveFrameIndex < FrameCount - 1) and Result;
end;

procedure TBaseFrame.CheckEvent(Sender: TObject);
begin
  Check;
end;


constructor TBaseFrame.Create(AOwner: TComponent);
begin
  inherited;
  Parent := AOwner as TWinControl;
  
  FEdited := false;
  FSaved := false;
  FNeedCopyState := true;

  FEditingClass := TBaseObject;

  FStatusBar := TStatusBar.Create(Self);
  FStatusBar.Parent := Self;
  FStatusBar.Visible := true;
  FStatusBar.Font.Style := [fsBold];
  FStatusBar.Panels.Add.Width := Round(Width*0.5);
  FStatusBar.Panels.Add;


  FInspector := THintManager.Create(FStatusBar);
  FInspector.CheckEvent := CheckEvent;
end;

destructor TBaseFrame.Destroy;
begin
  FInspector.Free;
  inherited;
end;

procedure TBaseFrame.FillParentControls;
begin

end;

function TBaseFrame.GetFormOwner: TForm;
var lo: TComponent;
begin
  Result := nil;

  lo := Owner;
  if Assigned(lo) then 
  while not (lo is TForm) do
  begin
    lo := lo.Owner;
    if not Assigned(lo) then break;
  end;

  Result := lo as TForm;
end;

procedure TBaseFrame.PreloadObject(ABaseObject: TBaseObject);
begin

end;

procedure TBaseFrame.RegisterInspector;
begin
  FInspector.Clear;
end;

procedure TBaseFrame.ReportStatus(AStatus: string);
begin
  StatusBar.Panels[0].Text := AStatus;
end;

procedure TBaseFrame.Save;
begin
  FEdited := false;
  FSaved := true;
end;

procedure TBaseFrame.SetEditingObject(const Value: TbaseObject);
begin
  if (Value = nil) and ((not Edited) or Saved) then ClearControls;
  RegisterInspector;
  PreloadObject(Value);

  if FEditingObject <> Value then
  begin
    FEditingObject := Value;
    if  Assigned(FEditingObject) and (FEditingObject.ID > 0) and (FEditingObject is EditingClass) then
      FillControls(FEditingObject)
    else if (Assigned(FEditingObject) and
            (FEditingObject.ID <= 0) and (FEditingObject is EditingClass)) then
    begin
      FillControls(nil);
      FillParentControls;
    end
    else if (Assigned(FEditingObject) and Assigned(ParentClass) and (FEditingObject is ParentClass)) then
      FillParentControls
    else ClearControls;

    if Assigned(FEditingObject) then
    begin
      StatusBar.Panels[1].Text := FEditingObject.List(loHierarchicalName, false, true);
      StatusBar.Hint := StatusBar.Panels[1].Text;
      Caption := StatusBar.Panels[1].Text;
      //if Assigned(FormOwner) then FormOwner.Caption := Caption;
      StatusBar.ShowHint := true;
    end
  end;

  FEdited := true;
  FSaved := false;
  Check;
end;

procedure TBaseFrame.SetNeedCopyState(const Value: boolean);
begin
  if FNeedCopyState <> Value then
  begin
    FNeedCopyState := Value;
  end;
end;

function TBaseFrame.UnCheck: boolean;
var i: integer;
begin
  Result := true;
  if Owner is TDialogFrame then
  with Owner as TDialogFrame do
  begin
    btnNext.Enabled := (ActiveFrameIndex < FrameCount);


    if FinishEnableIndex > -1 then
       btnFinish.Enabled := (FrameCount > 0) and (ActiveFrameIndex >= FinishEnableIndex)
    else btnFinish.Enabled := (FrameCount > 0) and not btnNext.Enabled;

    for i := 0 to FStatusBar.Panels.Count - 2 do
      FStatusBar.Panels[i].Text := '';
  end;
end;

{ TVisualizationOption }

procedure TVisualizationOption.AssignTo(Dest: TPersistent);
var vo: TVisualizationOption;
begin
  vo := Dest as TVisualizationOption;
  vo.Represent := Represent;
  vo.ListOption := ListOption;
  vo.ShowUINs := ShowUINs;
  vo.FixVisualization := FixVisualization;
end;


{ TVisualizationOptions }

function TVisualizationOptions.GetItem(
  const Index: integer): TVisualizationOption;
begin
  Result := TVisualizationOption(inherited Items[Index]);
end;

procedure TVisualizationOptions.Pop;
begin
  FCurrent.Free;
  FCurrent := nil;
  Delete(Count - 1);
  if Count > 0 then 
    FCurrent := Items[Count - 1];
end;

procedure TVisualizationOptions.Push;
var o: TVisualizationOption;
begin
  o := TVisualizationOption.Create;
  if Assigned(FCurrent) then o.Assign(FCurrent);
  FCurrent := o;
  Add(FCurrent);
end;


{ THintManager }

function THintManager.Add(AControl: TControl; AAdditional: TObject;
  const AValueType: TParameterType; const AName: string;
  const AEmptyAllowed: boolean): THintedControl;
var hC: THintedControl;
begin
  hC := ItemsByName[AName];
  if not Assigned(hC) then
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
      else if (Control is TDateEdit) then
      begin
        if Assigned((Control as TDateEdit).OnChange) and not Assigned(FPreCheckEvent) then
          FPreCheckEvent := (Control as TDateEdit).OnChange;
        (Control as TDateEdit).OnChange := CheckEvent
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

    if Assigned(FPreCheckEvent) and (@FPreCheckEvent <> @FCheckEvent) then FPreCheckEvent(nil);

    if Control is TCustomEdit then
    begin
      val := (Control as TCustomEdit).Text;
      if Control is TEdit then
      begin
        edt := (Control as TEdit);
        edt.Font.Color := clBlack;
        edt.Font.Style := [];
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


    try
      Val := trim(val);

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


procedure THintManager.RemoveByName(const AName: string);
var hC: THintedControl;
begin
  hC := ItemsByName[AName];
  if Assigned(hc) then
  begin
    Remove(hc);
    hc.Free;
  end;
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

procedure TCommonForm.CancelEdit;
var i: integer;
begin
  for i := 0 to dlg.FrameCount - 1 do
    (dlg.Frames[i] as TBaseFrame).CancelEdit;
end;

constructor TCommonForm.Create(AOwner: TComponent);
var bmp: TBitmap;
    actn: TBaseAction;
begin
  inherited;
  dlg.OnBeforePageChange := NextFrame;
  dlg.OnFinishValidate := ValidateFinishButton;
  Width := 718;
  Height := 527;
  Position := poMainFormCenter;

  FImageList := TImageList.Create(Self);
  bmp := TBitmap.Create;
  try
    bmp.LoadFromResourceName(hInstance, 'TrashEmpty');
    FImageList.Add(bmp, nil);
  finally
    bmp.Free;
  end;

  bmp := TBitmap.Create;
  try
    bmp.LoadFromResourceName(hInstance, 'TrashFull');
    FImageList.Add(bmp, nil);
  finally
    bmp.Free;
  end;

  FActnList := TBaseActionList.Create(Self);
  FActnList.Images := FImageList;
  actn := FActnList.ActionByClassType[TBasketFormShowAction];




  ftlbr := TToolBar.Create(Self);
  ftlbr.Flat := true;
  ftlbr.Parent := Self;
  ftlbr.Align := alRight;
  ftlbr.EdgeBorders := [];
  ftlbr.Images := FImageList;

  AddToolButton(ftlbr, actn);

  ToolBarVisible := true;
end;

destructor TCommonForm.Destroy;
begin

  inherited;
end;

procedure TCommonForm.FormCreate(Sender: TObject);
begin

end;


function TCommonForm.GetEditingObject: TBaseObject;
begin
 try
   Result := (dlg.Frames[0] as TBaseFrame).EditingObject;
 except
   Result := nil;
 end;
end;

function TCommonForm.GetEditingObjectName: string;
begin
  Result := '';
end;

procedure TCommonForm.NextFrame(Sender: TObject);
begin
  if Dlg.LastActiveFrameIndex < Dlg.NextActiveFrameIndex then
  begin
    // проверка при переходе от фрэйма к фрэйму
    (dlg.Frames[dlg.ActiveFrameIndex + 1] as TBaseFrame).EditingObject := EditingObject;
    (dlg.Frames[dlg.ActiveFrameIndex + 1] as TBaseFrame).Check;
     FTlbr.Visible := ToolBarVisible and (dlg.Frames[dlg.NextActiveFrameIndex] as TBaseFrame).NeedCopyState;
  end
  else
  begin
    (dlg.Frames[dlg.ActiveFrameIndex - 1] as TBaseFrame).EditingObject := EditingObject;
    (dlg.Frames[dlg.ActiveFrameIndex - 1] as TBaseFrame).Check;
     FTlbr.Visible := ToolBarVisible and (dlg.Frames[dlg.NextActiveFrameIndex] as TBaseFrame).NeedCopyState;
  end;
  Caption := EditingObjectName + '(шаг ' + IntToStr(dlg.NextActiveFrameIndex + 1) + ' из ' + IntToStr(dlg.FrameCount) + ')';


end;

procedure TCommonForm.OnGetFromBasket(Sender: TObject);
var iUIN, i: integer;
begin
  begin
{    iUIN := frmBasketView.frmBasket.PuttingObject.ID;

    frmBasketView.frmBasket.PuttingObject.Assign(frmBasketView.frmBasket.GettingObject);
    frmBasketView.frmBasket.PuttingObject.ID := iUIN;}


    (dlg.Frames[Dlg.ActiveFrameIndex] as TBaseFrame).FillControls(frmBasketView.frmBasket.GettingObject);
    // чтобы значения скопированные из состояния буферного элемента - не подтирались
    (dlg.Frames[Dlg.ActiveFrameIndex] as TBaseFrame).FEdited := true;

    if Assigned(EditingObject) then
    begin
      iUIN := EditingObject.ID;
      frmBasketView.frmBasket.PuttingObject := EditingObject;
      frmBasketView.frmBasket.PuttingObject.Assign(frmBasketView.frmBasket.GettingObject);
      frmBasketView.frmBasket.PuttingObject.ID := iUIN;
    end;

    for i := Dlg.ActiveFrameIndex + 1 to dlg.FrameCount - 1 do
    if (dlg.Frames[i] as TBaseFrame).NeedCopyState then 
    begin
     (dlg.Frames[i] as TBaseFrame).FillControls(frmBasketView.frmBasket.GettingObject);
     // чтобы значения скопированные из состояния буферного элемента - не подтирались
     (dlg.Frames[i] as TBaseFrame).FEdited := true;
    end;
    // если в процессе загрузки вдруг случилось так, что
    // появился выделенный объект
    // то копируем в него состояние
  end;
end;

procedure TCommonForm.Save;
var i: integer;
    frm: TBaseFrame;
begin
  for i := 0 to dlg.FrameCount - 1 do
  begin
    // если не было ничего загружено
    // то при сохранении может получиться так,
    // что данные будут почищены
    // поэтому прежде чем сохранить
    // обязательно загрузить инфу
    // с другой стороны может быть случай,
    // когда этого как раз делать не надо
    // добавиль новый элемент
    // editingObject не назначен
    // в результате переназначения теряется редактирование
    // поэтому переназначаем только в том случае,
    // если это не вновь добавленный объект
    frm := dlg.Frames[i] as TBaseFrame;
    if (not Assigned(frm.EditingObject))
        and Assigned(EditingObject)
        and (EditingObject.ID > 0) then
      frm.EditingObject := EditingObject;
    (dlg.Frames[i] as TBaseFrame).Save;
  end;

  // обнуляем на всякий случай
  // на первом оставляем, потому что именно с него читается
  // загруженный объект
  if dlg.CloseAfterFinish then
  for i := 1 to dlg.FrameCount - 1 do
    (dlg.Frames[i] as TBaseFrame).EditingObject := nil;
end;

procedure TCommonForm.SetEditingObject(const Value: TBaseObject);
//var i: integer;
var bo: TBaseObject;
begin
  (dlg.Frames[0] as TBaseFrame).EditingObject := Value;
  if not Assigned(frmBasketView) then frmBasketView := TfrmBasketView.Create(Self);
  bo := (dlg.Frames[0] as TBaseFrame).EditingObject;
  // убеждаемся что редактируемое создано
  if  Assigned(bo)
  and (bo is (dlg.Frames[0] as TBaseFrame).EditingClass)
  and (bo.ID > 0) then
    bo.Accept(frmBasketView.frmBasket.ConcreteVisitor)
  else
  begin
    frmBasketView.frmBasket.PuttingObject := nil;
    frmBasketView.frmBasket.ActiveClass := (dlg.Frames[0] as TBaseFrame).EditingClass;
  end;


end;

function THintManager.TreeViewMultiSelectionApplied(ATrw: TTreeView): integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to ATrw.Items.Count - 1 do
    Result := Result + ord(ATrw.Items[i].SelectedIndex = 1);
end;

{ TSingleFramedForm }

procedure TSingleFramedForm.CancelEdit;
begin
  if Assigned(Frame) then
    Frame.CancelEdit;
end;

constructor TSingleFramedForm.Create(AOwner: TComponent);
var btn: TButton;
begin
  inherited;
  FShowButtons := true;
  // создаем панельку
  FPnlButtons := TPanel.Create(Self);
  FPnlButtons.Parent := Self;
  FPnlButtons.Align := alBottom;
  // создаем кнопки
  btn := TButton.Create(Self);
  btn.Parent := FPnlButtons;
  btn.Left := FPnlButtons.Width - 2*btn.Width - 15;
  btn.Top := 8;
  btn.Anchors := [akRight, akBottom];
  btn.Caption := 'ОК';
  btn.ModalResult := mrOk;

  btn := TButton.Create(Self);
  btn.Parent := FPnlButtons;
  btn.Left := FPnlButtons.Width - btn.Width - 10;
  btn.Top := 8;
  btn.Anchors := [akRight, akBottom];
  btn.Caption := 'Отмена';
  btn.ModalResult := mrCancel;
  btn.Cancel := true;

  FFrame := nil; 
end;

constructor TSingleFramedForm.Create(AOwner: TComponent;
  AFrameClass: TBaseFrameClass);
begin
  Create(AOwner);
  FrameClass := AFrameClass;
end;

function TSingleFramedForm.GetEditingObject: TBaseObject;
begin
  if Assigned(Frame) then
    Result := Frame.EditingObject
  else
    Result := nil;
end;

function TSingleFramedForm.GetEditingObjectName: string;
begin
  Result := '';
end;

function TSingleFramedForm.GetFrame: TBaseFrame;
begin
  Result := FFrame;
end;

procedure TSingleFramedForm.Save;
begin
  if Assigned(Frame) then
  begin
    Frame.Save;
  end;
end;

procedure TSingleFramedForm.SetFrameClass(const Value: TBaseFrameClass);
begin
  if (not Assigned(Frame)) or (not (Frame is Value)) then
  begin
    Frame.Free;
    FFrame := nil;
    FFrameClass := Value;
    FFrame := FFrameClass.Create(Self);
    FFrame.Parent := Self;
    FFrame.Align := alClient;
  end;
end;

procedure TSingleFramedForm.SetEditingObject(const Value: TBaseObject);
begin
  if Assigned(Frame) then
    Frame.EditingObject := Value;
end;


procedure TSingleFramedForm.SetShowButtons(const Value: boolean);
begin
  FShowButtons := Value;
  FPnlButtons.Visible := FShowButtons;
end;

{ TBasketFormShowAction }

constructor TBasketFormShowAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Показать корзину';
  ImageIndex := 0;
end;

function TBasketFormShowAction.Execute: boolean;
var bo: TBaseObject;
begin
  if not Assigned(frmBasketView) then frmBasketView := TfrmBasketView.Create(Self);
  frmBasketView.frmBasket.OnGetFromBasket := (ActionList.Owner as TCommonForm).OnGetFromBasket;

  with (ActionList.Owner as TCommonForm) do
  begin
    bo := (dlg.Frames[0] as TBaseFrame).EditingObject;

    if Assigned(bo)
    and (bo is (dlg.Frames[0] as TBaseFrame).EditingClass)
    and (bo.ID > 0) then
      (dlg.Frames[0] as TBaseFrame).EditingObject.Accept(frmBasketView.frmBasket.ConcreteVisitor)
    else
    begin
      frmBasketView.frmBasket.PuttingObject := nil;
      frmBasketView.frmBasket.ActiveClass := (dlg.Frames[0] as TBaseFrame).EditingClass;
    end;
  end;

  if frmBasketView.ShowModal <> mrNone then
  begin
    // перерисовать дерево
    if frmBasketView.ModalResult = mrOK then if Assigned((ActionList.Owner as TCommonForm).FOnAfterBasketClosed) then (ActionList.Owner as TCommonForm).FOnAfterBasketClosed(nil);
    // сказать, что корзина не пуста
    ImageIndex := ord(frmBasketView.frmBasket.ActiveClassObjectsCount > 0);
  end;
end;

procedure TCommonForm.SetToolBarVisible(const Value: boolean);
begin
  if FToolBarVisible <> Value then
  begin
    FToolBarVisible := Value;
  end;
  FTlbr.Visible := FToolBarVisible;
end;

procedure TCommonForm.ValidateFinishButton(Sender: TObject;
  var EnabledState: boolean);
begin
  EnabledState := (Dlg.Frames[Dlg.ActiveFrameIndex] as TBaseFrame).Check;
end;

end.
