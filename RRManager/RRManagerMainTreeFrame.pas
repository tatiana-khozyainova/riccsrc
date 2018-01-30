unit RRManagerMainTreeFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, RRManagerLoaderCommands, RRManagerObjects, RRManagerBaseObjects,
  RRManagerStructureInfoForm, Menus, RRManagerDataPosters, RRManagerPersistentObjects,
  RRManagerHorizonInfoForm, ImgList, RRManagerBedInfoForm, ClientCommon,
  RRManagerLayerInfoForm, StdCtrls, ExtCtrls, Contnrs, Buttons, RRManagerBaseGUI,
  RRManagerCommon, ToolWin, BaseObjects
  {$IFDEF VER150}
  , Variants
  {$ENDIF}
  ;


type

  TfrmMainTree = class(TFrame)
    trwMain: TTreeView;
    imgList: TImageList;
    pnlTop: TPanel;
    tlbrActions: TToolBar;
    Label3: TLabel;
    cmbxFilter: TComboBox;
    chbxShowBalancedOnly: TCheckBox;
    procedure trwMainExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure trwMainChange(Sender: TObject; Node: TTreeNode);
    procedure trwMainGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure cmbxVersionChange(Sender: TObject);
    procedure cmbxListOptionChange(Sender: TObject);
    procedure trwMainDeletion(Sender: TObject; Node: TTreeNode);
    procedure cmbxFilterDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmbxFilterMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure cmbxFilterChange(Sender: TObject);
    procedure sbtnUINClick(Sender: TObject);
    procedure trwMainAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure trwMainDblClick(Sender: TObject);
  private
    { Private declarations }
    FAdditionalFilters: TCollection;
    FStructures: TOldStructures;
    actnList: TBaseActionList;
    ReportActnList: TBaseActionList;
    FFilterID: integer;
    FFilterValues: OleVariant;

    FClassTypes, FAllClassTypes: TClassList;
    FOnChangeLevel: TNotifyEvent;
    FMenus, FToolBars: TObjectList;
    pmn: TPopupMenu;
    FOnChangeItem: TNotifyEvent;
    FMenuVisible: boolean;
    FToolBarVisible: boolean;
    FUpperPanelVisible: boolean;
    FOnChangeStructure: TNotifyEvent;
    FExternalToolBars: TList;
    FVersions: TOldVersions;
    FOnCreateArchive: TNotifyEvent;

    procedure DeleteNodes;
    function GetMenus(const AName: string): TMenu;
    function GetBedHorizonLoadAction: TBaseAction;
    function GetBedLayerLoadAction: TBaseAction;
    function GetBedLoadAction: TBaseAction;
    function GetBedSubstructureLoadAction: TBaseAction;
    function GetClearAction: TBaseAction;
    function GetDeselectAllAction: TBaseAction;
    function GetHorizonLoadAction: TbaseAction;
    function GetLayerLoadAction: TBaseAction;
    function GetStrLoadAction: TBaseAction;
    function GetSubstructureLoadAction: TBaseAction;
    procedure SetMenuVisible(const Value: boolean);
    procedure SetToolBarVisible(const Value: boolean);
    procedure SetUpperPanelVisible(const Value: boolean);
    function GetExternalToolBar(AIndex: integer): TToolBar;
    function GetExternalToolbarsCount: integer;
    function GetStructure: TOldStructure;
    function GetResourceLoadAction: TBaseAction;
  public
    { Public declarations }
    property    StructureLoadAction: TBaseAction read GetStrLoadAction;
    property    HorizonLoadAction: TbaseAction read GetHorizonLoadAction;
    property    SubstructureLoadAction: TBaseAction read GetSubstructureLoadAction;
    property    LayerLoadAction: TBaseAction read GetLayerLoadAction;
    property    BedLayerLoadAction: TBaseAction read GetBedLayerLoadAction;
    property    BedLoadAction: TBaseAction read GetBedLoadAction;
    property    BedSubstructureLoadAction: TBaseAction read GetBedSubstructureLoadAction;
    property    BedHorizonLoadAction: TBaseAction read GetBedHorizonLoadAction;
    property    ResourceLoadAction: TBaseAction read GetResourceLoadAction;

    property    DeselectAllAction: TBaseAction read GetDeselectAllAction;
    property    ClearAction: TBaseAction read GetClearAction;

    property    FilterID: integer read FFilterID write FFilterID;
    property    FilterValues: OleVariant read FFilterValues write FFilterValues;
    // уровень до которого можно раскрывать дерево
    // 0 - структуры
    // 1 - горизонт
    // 2 - подструктура
    // 3 - продуктивный пласт
    // дополнительное действие при изменении уровня
    property    OnChangeLevel: TNotifyEvent read FOnChangeLevel write FOnChangeLevel;
    // показывать ли панель инструментов
    property    ToolBarVisible: boolean read FToolBarVisible write SetToolBarVisible;
    // показывать ли менюху
    property    MenuVisible: boolean read FMenuVisible write SetMenuVisible;
    // показывать верхнюю панельку
    property    UpperPanelVisible: boolean read FUpperPanelVisible write SetUpperPanelVisible;
    // отреагировать на изменение уровня отображения объектов в дереве
    procedure   ChangeLevel;

    // дополнительное действие при изменении выделенного объекта
    property    OnChangeItem: TNotifyEvent read FOnChangeItem write FOnChangeItem;
    property    OnChangeStructures: TNotifyEvent read FOnChangeStructure write FOnChangeStructure;
    property    OnCreateArchive: TNotifyEvent read FOnCreateArchive write FOnCreateArchive;

    constructor Create(AOwner: TComponent); override;

    property    Structures: TOldStructures read FStructures write FStructures;

    destructor  Destroy; override;

    // меню, которые фрэйм выставляет вовне
    property Menus[const AName: string]: TMenu read GetMenus;

    // индекс элемента по UINу
    function IndexOfUIN(AUIN, ALevel: integer): integer;
    // внешние тулбары
    property  ExternalToolbars[AIndex: integer]: TToolBar read GetExternalToolBar;
    function  AddExternalToolbar(AToolBar: TToolBar): integer;
    property  ExternalToolbarsCount: integer read GetExternalToolbarsCount;
    procedure FillExternalToolBars;
    // очистка фильтров
    procedure Clear;
    // выделенная структура
    property  Structure: TOldStructure read GetStructure;
  end;


  TMainTreeActionList = class(TBaseActionList)
  private
    FHorizon: TOldHorizon;
    FStructure: TOldStructure;
    FSubstructure: TOldSubstructure;
    FFilter: string;
    FBed: TOldBed;
    FLayer: TOldLayer;
    procedure SetHorizon(const Value: TOldHorizon);
    procedure SetStructure(const Value: TOldStructure);
    procedure SetSubstructure(const Value: TOldSubstructure);
    procedure SetFilter(const Value: string);
    procedure SetBed(const Value: TOldBed);
    procedure SetLayer(const Value: TOldLayer);
  public
    property Structure: TOldStructure read FStructure write SetStructure;
    property Horizon: TOldHorizon read FHorizon write SetHorizon;
    property Substructure: TOldSubstructure read FSubstructure write SetSubstructure;
    property Bed: TOldBed read FBed write SetBed;
    property Layer: TOldLayer read FLayer write SetLayer;
    property Filter: string read FFilter write SetFilter;
    constructor Create(AOwner: TComponent); override;
  end;


  TReportActionList = class(TBaseActionList)
  public
    constructor Create(AOwner: TComponent); override;
  end;



implementation


uses RRManagerSubstructureInfoForm, RRManagerReportForm,
  RRManagerDictEditor, RRManagerReservesLayerInfoForm,
  RRManagerCreateReportForm, RRManagerReport, RRManagerNewReportForm, RRManagerEditCommands,
  RRManagerObjectVersionCreationForm, ActnList, Facade;

type

{  TToolBarList = class(TObjectList)
  private
    FImages: TCustomImageList;
    function GetToolButton(Index: integer): TToolBar;
  public
    property Items[Index: integer]: TToolBar read GetToolButton;
    function AddToolBar(AOwner: TComponent): TToolBar;
    constructor Create(AImages: TCustomImageList);
  end;}

  TFundTypeAdditionalFilters = class(TAdditionalFilters)
  public
    constructor Create; override;
  end;

  TStructureEditAction = class(TStructureBaseEditAction)
  private
    procedure PrepareForm;
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;


  TStructureAddAction = class(TStructureEditAction)
  public
    function Execute: boolean; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  THorizonEditAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  THorizonAddAction = class(THorizonEditAction)
  public
    function Execute: boolean; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TSubstructureEditAction = class(TbaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TSubstructureAddAction = class(TSubstructureEditAction)
  public
    function Execute: boolean; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TBedEditAction = class(TBaseAction)
  public
    function Execute: boolean; overload; override;
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TBedAddAction = class(TBedEditAction)
  public
    function Execute: boolean; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TLayerEditAction = class(TBaseAction)
  public
    function Execute: boolean; overload; override;
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TLayerAddAction = class(TLayerEditAction)
  public
    function Execute: boolean; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;



  TBedDeleteAction = class(TbaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TStructurePreEditAction = class(TStructureBasePreEditAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TStructureDeleteAction = class(TStructureBaseDeleteAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  THorizonDeleteAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TSubstructureDeleteAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TLayerDeleteAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;


  TDeleteAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;


  TStructureLoadAction = class(TStructureBaseLoadAction)
  public
    function Execute: boolean; overload; override;
    function Execute(AFilter: string): boolean; override;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TLicenseZoneLoadAction = class(TLicenseZoneBaseLoadAction)
  public
    function Execute: boolean; overload; override;
    function Execute(AFilter: string): boolean; override;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  THorizonLoadAction = class(THorizonBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TSubstructureLoadAction = class(TSubstructureBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TLayerLoadAction = class(TLayerBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TRecourceLoadAction = class(TVersionBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TBedLayerLoadAction = class(TBedLayerBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TBedLoadAction = class(TBedBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TBedSubstructureLoadAction = class(TBedSubstructureBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TBedHorizonLoadAction = class(TBedHorizonBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TSelectAllAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TDeselectAllAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TClearAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TDictEditAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TMakeReportAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TCreateNewReportAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TAddNewReportAction = class(TReportBaseAddAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TMakeArchiveAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;




{$R *.DFM}

{ TfrmMainTree }

constructor TfrmMainTree.Create(AOwner: TComponent);
var aMenus: TMenuList;
    //aToolBars: TToolBarList;
    mn: TMenu;
    mi: TMenuItem;
    actn: TbaseAction;
begin
  inherited;

  FExternalToolBars := TList.Create;


  FAdditionalFilters := TFundTypeAdditionalFilters.Create;
  (FAdditionalFilters as TAdditionalFilters).MakeList(cmbxFilter.Items);
  cmbxFilter.ItemIndex := 0;

  FMenus := TMenuList.Create(imgList);
  //FToolBars := TToolBarList.Create(imgList);
  aMenus := FMenus as TMenuList;
  //aToolBars := FToolBars as TToolBarList;

  AllOpts := TVisualizationOptions.Create;
  AllOpts.Push;
  AllOpts.Current.ListOption := loBrief;
  AllOpts.Current.Represent := 4;
  AllOpts.Current.FixVisualization := true;

  // уровень по умолчанию - грузить все - до подструктур
  FClassTypes := TClassList.Create;
  FAllClassTypes := TClassList.Create;






  FOnChangeLevel := nil;
  actnList := TMainTreeActionList.Create(Self);
  actnList.Images := imgList;


  ReportActnList := TReportActionList.Create(Self);
  ReportActnList.Images := imgList;



  mn := AMenus.AddMenu(TMainMenu, AOwner);

  mn.Name := 'mnActions';

  mi := AMenus.AddMenuItem(mn, nil);
  mi.Caption := 'Структуры';
  mi.GroupIndex := 3;

  actn := (actnList as TMainTreeActionList).ActionByClassType[TDeleteAction];
  AMenus.AddMenuItem(0, mi, actn);
  AMenus.AddMenuItem(0, mi, nil);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TMainTreeActionList).ActionByClassType[TLayerEditAction];
  AMenus.AddMenuItem(0, mi, actn);
  AMenus.AddMenuItem(0, mi, nil);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TMainTreeActionList).ActionByClassType[TLayerAddAction];
  AMenus.AddMenuItem(0, mi, actn);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TMainTreeActionList).ActionByClassType[TBedEditAction];
  AMenus.AddMenuItem(0, mi, actn);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TMainTreeActionList).ActionByClassType[TBedAddAction];
  AMenus.AddMenuItem(0, mi, actn);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TMainTreeActionList).ActionByClassType[TSubstructureEditAction];
  AMenus.AddMenuItem(0, mi, actn);
  AMenus.AddMenuItem(0, mi, nil);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TMainTreeActionList).ActionByClassType[TSubstructureAddAction];
  AMenus.AddMenuItem(0, mi, actn);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TMainTreeActionList).ActionByClassType[THorizonEditAction];
  AMenus.AddMenuItem(0, mi, actn);
  AMenus.AddMenuItem(0, mi, nil);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TMainTreeActionList).ActionByClassType[THorizonAddAction];
  AMenus.AddMenuItem(0, mi, actn);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TMainTreeActionList).ActionByClassType[TStructureEditAction];
  AMenus.AddMenuItem(0, mi, actn);
  AMenus.AddMenuItem(0, mi, nil);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TMainTreeActionList).ActionByClassType[TStructureAddAction];
  AMenus.AddMenuItem(0, mi, actn);
  AddToolButton(tlbrActions, actn);


  mi := AMenus.AddMenuItem(mn, nil);
  mi.Caption := 'Отчеты';
  mi.GroupIndex := 6;
  // приходится менять индексы иконок, потому что меню и тулбар
  // привязаны к разным спискам картинок
  // потом надо будет чёто придумать
  { TODO : потом надо будет чёто придумать }
  actn := ReportActnList.ActionByClassType[TAddNewReportAction];
  AMenus.AddMenuItem(0, mi, actn).ImageIndex := 28;

  actn := ReportActnList.ActionByClassType[TCreateNewReportAction];
  AMenus.AddMenuItem(0, mi, actn).ImageIndex := 27;

  AMenus.AddMenuItem(0, mi, nil);
  actn := ReportActnList.ActionByClassType[TMakeReportAction];
  AMenus.AddMenuItem(0, mi, actn).ImageIndex := 25;

  mi := AMenus.AddMenuItem(mn, nil);
  mi.Caption := 'Сервис';
  mi.GroupIndex := 7;
  actn := (actnList as TMainTreeActionList).ActionByClassType[TMakeArchiveAction];
  AMenus.AddMenuItem(0, mi, actn);
  actn := (actnList as TMainTreeActionList).ActionByClassType[TDictEditAction];
  AMenus.AddMenuItem(0, mi, actn);




  mn := AMenus.AddMenu(TPopupMenu, AOwner);
  mn.Name := 'mnPopup';

  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[TDeselectAllAction]);
  AMenus.AddMenuItem(mn, nil);



  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[TStructureAddAction]);
  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[TStructureEditAction]);
  AMenus.AddMenuItem(mn, nil);

  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[THorizonAddAction]);
  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[THorizonEditAction]);
  AMenus.AddMenuItem(mn, nil);

  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[TSubstructureAddAction]);
  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[TSubstructureEditAction]);
  AMenus.AddMenuItem(mn, nil);

  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[TBedAddAction]);
  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[TBedEditAction]);
  AMenus.AddMenuItem(mn, nil);

  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[TLayerAddAction]);
  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[TLayerEditAction]);
  AMenus.AddMenuItem(mn, nil);

  AMenus.AddMenuItem(mn, (actnList as TMainTreeActionList).ActionByClassType[TDeleteAction]);
  AMenus.AddMenuItem(mn, nil);

  pmn := mn as TPopupMenu;
  trwMain.PopupMenu := pmn;



end;

destructor TfrmMainTree.Destroy;
var i, j: integer;
begin
  if Assigned(AllOpts) then
  begin
    AllOpts.Pop;
    AllOpts.Free;
    AllOpts := nil;
  end;

  FAdditionalFilters.Free;
  FMenus.Free;
  FClassTypes.Free;
  FAllClassTypes.Free;
  FExternalToolBars.Free;


  actnList.Free;
  ReportActnList.Free;


  inherited;
end;




procedure TfrmMainTree.DeleteNodes;
var Node: TTreeNode;
    lst: TList;
    i: integer;
begin
  lst := TList.Create;
  Node := trwMain.Items.GetFirstNode;
  while Assigned(Node) do
  begin
    if (not Assigned(Node.Data)) or (FClassTypes.IndexOf(TObject(Node.Data).ClassType) > -1) then
      lst.Add(Node);
      
    Node := Node.GetNext;
  end;

  for i := 0 to lst.Count - 1 do
    TTreeNode(lst.Items[i]).Delete;

  lst.Free;
end;

function TfrmMainTree.GetMenus(const AName: string): TMenu;
var i: integer;
    mns: TMenuList;
begin
  Result := nil;
  mns := FMenus as TMenuList;
  for i := 0 to mns.Count - 1 do
  if mns.Items[i].Name = AName then
  begin
    Result := mns.Items[i] as TMenu;
    break;
  end;
end;

function TfrmMainTree.GetBedHorizonLoadAction: TBaseAction;
begin
  Result := (actnList as TMainTreeActionList).ActionByClassType[TBedHorizonLoadAction];
end;

function TfrmMainTree.GetBedLayerLoadAction: TBaseAction;
begin
  Result := (actnList as TMainTreeActionList).ActionByClassType[TBedLayerLoadAction];
end;

function TfrmMainTree.GetBedLoadAction: TBaseAction;
begin
  Result := (actnList as TMainTreeActionList).ActionByClassType[TBedLoadAction];
end;

function TfrmMainTree.GetBedSubstructureLoadAction: TBaseAction;
begin
  Result := (actnList as TMainTreeActionList).ActionByClassType[TBedSubstructureLoadAction];
end;

function TfrmMainTree.GetClearAction: TBaseAction;
begin
  Result := (actnList as TMainTreeActionList).ActionByClassType[TClearAction];
end;

function TfrmMainTree.GetDeselectAllAction: TBaseAction;
begin
  Result := (actnList as TMainTreeActionList).ActionByClassType[TDeselectAllAction];

end;

function TfrmMainTree.GetHorizonLoadAction: TbaseAction;
begin
  Result := (actnList as TMainTreeActionList).ActionByClassType[THorizonLoadAction];
end;

function TfrmMainTree.GetLayerLoadAction: TBaseAction;
begin
  Result := (actnList as TMainTreeActionList).ActionByClassType[TLayerLoadAction];
end;

function TfrmMainTree.GetStrLoadAction: TBaseAction;
begin
  Result := (actnList as TMainTreeActionList).ActionByClassType[TStructureLoadAction];
end;

function TfrmMainTree.GetSubstructureLoadAction: TBaseAction;
begin
  Result := (actnList as TMainTreeActionList).ActionByClassType[TSubstructureLoadAction];
end;

function TfrmMainTree.IndexOfUIN(AUIN, ALevel: integer): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to trwMain.Items.Count - 1 do
  if (trwMain.Items[i].Level = ALevel) and (TObject(trwMain.Items[i].Data) is TBaseObject) then
  begin
    if TBaseObject(trwMain.Items[i].Data).ID = AUIN then
    begin
      Result := i;
      break;
    end;
  end;
end;


procedure TfrmMainTree.SetMenuVisible(const Value: boolean);
begin
  FMenuVisible := Value;
  pmn.AutoPopup := FMenuVisible;
end;

procedure TfrmMainTree.SetToolBarVisible(const Value: boolean);
begin
  FToolBarVisible := Value;
  tlbrActions.Visible := FToolBarVisible;  
end;

procedure TfrmMainTree.SetUpperPanelVisible(const Value: boolean);
begin
  FUpperPanelVisible := Value;
  pnlTop.Visible := Value;
end;

function TfrmMainTree.GetExternalToolBar(AIndex: integer): TToolBar;
begin
  Result := TToolBar(FExternalToolBars.Items[AIndex]);
end;

function TfrmMainTree.AddExternalToolbar(AToolBar: TToolBar): integer;
begin
  Result := FExternalToolBars.Add(AToolBar);
end;

function TfrmMainTree.GetExternalToolbarsCount: integer;
begin
  Result := FExternalToolBars.Count;
end;

procedure TfrmMainTree.FillExternalToolBars;
var actn: TBaseAction;
begin
  // делаем панельку отчётов
  if ExternalToolbarsCount > 0 then
  begin
    actn := ReportActnList.ActionByClassType[TAddNewReportAction];
    AddToolButton(ExternalToolbars[0], actn);


    actn := ReportActnList.ActionByClassType[TCreateNewReportAction];
    AddToolButton(ExternalToolbars[0], actn);

    actn := ReportActnList.ActionByClassType[TMakeReportAction];
    AddToolButton(ExternalToolbars[0], actn);
  end;
end;

procedure TfrmMainTree.ChangeLevel;
var i: integer;
begin
  cmbxFilter.ItemIndex := 0;
  DeselectAllAction.Execute;

  // если уровень уменьшается, то из дерева надо удалить все узлы
  // которые выше по уровню
//  if AllOpts.Current.Represent <> cmbxLevel.ItemIndex then
{  begin
    FClassTypes.Clear;
    for i := cmbxLevel.ItemIndex + 1 to 4 do
      FClassTypes.Add(FAllClassTypes.Items[i]);

    if AllOpts.Current.Represent > cmbxLevel.ItemIndex then
      DeleteNodes
    else if AllOpts.Current.Represent < cmbxLevel.ItemIndex then
    begin
      // это все делается чтоб обновить - неудобно конечно, но что ж.
      (StructureLoadAction as TStructureBaseLoadAction).LastFilter := '';
      StructureLoadAction.Execute;
    end;

    AllOpts.Current.Represent := cmbxLevel.ItemIndex;

    if Assigned(FOnChangeLevel) then FOnChangeLevel(nil);
  end;}
end;

procedure TfrmMainTree.Clear;
begin
  if Assigned(FOnChangeStructure) then FOnChangeStructure(nil);
  if Assigned(FOnChangeItem) then FOnChangeLevel(nil);
  cmbxFilter.ItemIndex := 0;
  trwMain.Items.Clear;
end;

function TfrmMainTree.GetStructure: TOldStructure;
begin
  Result := (actnList as TMainTreeActionList).Structure;
end;



function TfrmMainTree.GetResourceLoadAction: TBaseAction;
begin
  Result := (actnList as TMainTreeActionList).ActionByClassType[TRecourceLoadAction];
end;


{ TStructureLoadAction }

constructor TStructureLoadAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CanUndo := false;
  Visible := false;
end;

function TStructureLoadAction.Execute(AFilter: string): boolean;
var Node: TTreeNode;
    i: integer;
begin
  (ActionList as TMainTreeActionList).Filter := AFilter;
  Result := false;
  LastCollection := (ActionList.Owner as TfrmMainTree).Structures;
  LastCollection.NeedsUpdate := AFilter <> LastFilter;
  LastFilter := AFilter;
  if LastCollection.NeedsUpdate then
  with ActionList.Owner as TfrmMainTree do
  begin
    trwMain.Items.BeginUpdate;
    trwMain.Items.Clear;

    Result := inherited Execute(AFilter);
    if Result then
    begin
      // загружаем в интерфейс
      if Assigned(LastCollection) then
      begin

        for i := 0 to LastCollection.Count - 1 do
        begin
          Node := nil;
          Node := trwMain.Items.AddObject(Node, LastCollection.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), LastCollection.Items[i]);
          if LastCollection.Items[i] is TOldDiscoveredStructure then
            Node.SelectedIndex := 4
          else if LastCollection.Items[i] is TOldPreparedStructure then
            Node.SelectedIndex := 5
          else if LastCollection.Items[i] is TOldDrilledStructure then
            Node.SelectedIndex := 6
          else if LastCollection.Items[i] is TOldField then
            Node.SelectedIndex := 7
          else if (LastCollection.Items[i] as TOldStructure).StructureTypeID in [5, 7] then
            Node.SelectedIndex := 29
          else if (LastCollection.Items[i] as TOldStructure).StructureTypeID = 6 then
            Node.SelectedIndex := 30;


          if not ((LastCollection as TOldStructures).Items[i] is TOldField) then
          begin
            Node := trwMain.Items.AddChildObject(Node, 'Горизонты', (LastCollection.Items[i] as TOldStructure).Horizons);
            Node.SelectedIndex := 3;
            // если гориизонты не запрещены к загрузке выбранным уровнем
            if FClassTypes.IndexOf(TOldHorizon) = -1 then
              trwMain.Items.AddChild(Node, 'будут горизонты');
          end
          else
          begin
            Node := trwMain.Items.AddChildObject(Node, 'Залежи', (LastCollection.Items[i] as TOldField).Beds);
            Node.SelectedIndex := 3;
            // если залежи не запрещены к загрузке выбранным уровнем
            if FClassTypes.IndexOf(TOldBed) = -1 then
              trwMain.Items.AddChild(Node, 'будут залежи');
          end;



        end;
      end
      else
      with ActionList.Owner as TfrmMainTree do
      begin
        trwMain.Items.BeginUpdate;
        trwMain.Items.Clear;
        trwMain.Items.EndUpdate;
      end;

    end;
    trwMain.Items.EndUpdate;
  end;
end;

function TStructureLoadAction.Execute: boolean;
begin
  Result := Execute((ActionList as TMainTreeActionList).Filter);
end;

function TStructureLoadAction.Execute(ABaseObject: TBaseObject): boolean;
begin
  Result := true;
  if ABaseObject is TOldStructure then
   Result := Execute('Structure_ID = ' + IntToStr(ABaseObject.ID));
end;

{ THorizonLoadAction }

constructor THorizonLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
  CanUndo := false;
  Visible := false;
end;

function THorizonLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var i: integer;
    Node: TTreeNode;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldStructure).Horizons;
  if LastCollection.NeedsUpdate then
  begin
    Result := inherited Execute(ABaseObject);
    if Result then
    begin
      // загружаем в интерфейс
      if Assigned(LastCollection) then
      with ActionList.Owner as TfrmMainTree do
      begin
        trwMain.Items.BeginUpdate;

        // чистим
        Node := trwMain.Selected.getFirstChild;
        while Assigned(Node) do
        begin
          Node.Delete;
          Node := trwMain.Selected.getFirstChild;
        end;

        // добавляем
        for i := 0 to LastCollection.Count - 1 do
        begin
          Node := trwMain.Items.AddChildObject(trwMain.Selected, (LastCollection as TOldHorizons).Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), LastCollection.Items[i]);
          Node.SelectedIndex  := 8;
          // если подструктуры не запрещены к загрузке выбранным уровнем
          if FClassTypes.IndexOf(TOldSubstructure) = -1 then
            trwMain.Items.AddChild(Node, 'будут подструктуры');
        end;

        trwMain.Items.EndUpdate;
      end;
    end;
  end;
end;

procedure TfrmMainTree.trwMainExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  Node.Selected := true;
  // если горизонт
  if Assigned(Node.Parent) then
  begin
    if (TObject(Node.Data) is TOldHorizons) and (TBaseObject(Node.Parent.Data) is TOldStructure) then
      HorizonLoadAction.Execute(TOldStructure(Node.Parent.Data))
    else if (TObject(Node.Data) is TOldBeds) then
    begin
      (BedLoadAction as TBedLoadAction).ShowBalancedOnly := chbxShowBalancedOnly.Checked;
      BedLoadAction.Execute(TOldStructure(Node.Parent.Data));
    end
    else if (TBaseObject(Node.Data) is TOldHorizon) then
      SubstructureLoadAction.Execute(TOldHorizon(Node.Data))
    else if (TObject(Node.Data) is TOldSubstructure) and (TObject(Node.Parent.Data) is TOldHorizon) then
      LayerLoadAction.Execute(TOldSubstructure(Node.Data))
    else if (TObject(Node.Data) is TOldLayer) and (TObject(Node.Parent.Data) is TOldSubstructure) then
      ResourceLoadAction.Execute(TOldLayer(Node.Data))
    else if (TObject(Node.Data) is TOldBed) then
      BedLayerLoadAction.Execute(TOldSubstructure(Node.Data))
  end;
 end;


{ TSubstructureLoadAction }

constructor TSubstructureLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
  CanUndo := false;
  Visible := false;
end;

function TSubstructureLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var i: integer;
    Node: TTreeNode;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldHorizon).Substructures;
  if LastCollection.NeedsUpdate then
  begin
    Result := inherited Execute(ABaseObject);
    if Result then
    begin
      // загружаем в интерфейс
      if Assigned(LastCollection) then
      with ActionList.Owner as TfrmMainTree do
      begin
        trwMain.Items.BeginUpdate;

        // чистим
        Node := trwMain.Selected.getFirstChild;
        while Assigned(Node) do
        begin
          Node.Delete;
          Node := trwMain.Selected.getFirstChild;
        end;

        // добавляем
        for i := 0 to LastCollection.Count - 1 do
        begin
          Node := trwMain.Items.AddChildObject(trwMain.Selected, (LastCollection as TOldSubstructures).Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), LastCollection.Items[i]);
          Node.SelectedIndex := 7 + (LastCollection.Items[i] as TOldSubstructure).StructureElementTypeID  + ord((LastCollection.Items[i] as TOldSubstructure).StructureElementTypeID = 0);

          // если продуктивные пласты не запрещены к загрузке выбранным уровнем
          if FClassTypes.IndexOf(TOldLayer) = -1 then
            trwMain.Items.AddChild(Node, 'будут продуктивные пласты');
        end;

        trwMain.Items.EndUpdate;
      end;
    end;
  end;
end;

{ TStructureEditForm }

constructor TStructureEditAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Редактировать структуру';
  CanUndo := false;
  ImageIndex := 4;
end;

function TStructureEditAction.Execute(ABaseObject: TBaseObject): boolean;
var trw: TTreeView;
    i, iUIN, iNewUIN: integer;
begin
  Result := true;
  if not Assigned(frmStructureInfo) then frmStructureInfo := TfrmStructureInfo.Create(Self);
  if not Assigned(ABaseObject) then
    PrepareForm;

//  iUIN := -1;
 { if Assigned(ABaseObject) then
    iNewUIN := ABaseObject.UIN
  else
    iNewUIN := 0;}

  // обновляем представление
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  if not Assigned(ABaseObject) then trw.Selected := nil;

  Result := inherited Execute(ABaseObject);
  if Result then
  begin
    //iUIN := ABaseObject.UIN;
    ABaseObject := frmStructureInfo.EditingObject; 
    if Assigned(trw.Selected) and Assigned(ABaseObject) then
    begin
      trw.Selected.Text := ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
    end;
    if Assigned(ABaseObject) then iNewUIN := ABaseObject.ID;
  end;

  if (TMainFacade.GetInstance as TMainFacade).AllStructures.NeedsUpdate then
  begin
    trw.Selected := nil;
    // очищаем фрэйм простмотра
    if Assigned((ActionList.Owner as TfrmMainTree).OnChangeItem) then (ActionList.Owner as TfrmMainTree).OnChangeItem(nil);
    // пока что не возвращается выделение
    (ActionList.Actions[0] as TStructureLoadAction).LastFilter := '';
    try
      ActionList.Actions[0].Execute;
    except

    end;

    iUIN := (ActionList.Owner as TfrmMainTree).IndexOfUIN(iNewUIN, 0);
    if iUIN > -1 then
    try
      trw.Items[iUIN].MakeVisible;
      trw.Items[iUIN].Expand(false);
    except

    end;

  end;
end;


{ TMainTreeActionList }

constructor TMainTreeActionList.Create(AOwner: TComponent);
var  actn: TBaseAction;
begin
  inherited;


  actn := TStructureLoadAction.Create(Self);
  actn.ActionList := Self;

  actn := THorizonLoadAction.Create(Self);
  actn.ActionList := Self;

  actn := TSubstructureLoadAction.Create(Self);
  actn.ActionList := Self;

  actn := TStructurePreEditAction.Create(Self);
  actn.ActionList := Self;

  actn := TDeselectAllAction.Create(Self);
  actn.ActionList := Self;

  actn := TStructureEditAction.Create(Self);
  actn.ActionList := Self;

  actn := THorizonEditAction.Create(Self);
  actn.ActionList := Self;

  actn := TSubstructureEditAction.Create(Self);
  actn.ActionList := Self;

  actn := TStructureDeleteAction.Create(Self);
  actn.ActionList := Self;

  actn := THorizonDeleteAction.Create(Self);
  actn.ActionList := Self;

  actn := TSubstructureDeleteAction.Create(Self);
  actn.ActionList := Self;

  actn := TBedEditAction.Create(Self);
  actn.ActionList := Self;

  actn := TBedLoadAction.Create(Self);
  actn.ActionList := Self;

  actn := TBedDeleteAction.Create(Self);
  actn.ActionList := Self;

  actn := TLayerEditAction.Create(Self);
  actn.ActionList := Self;

  actn := TDeleteAction.Create(Self);
  actn.ActionList := Self;

  actn := TClearAction.Create(Self);
  actn.ActionList := Self;

  actn := TLayerLoadAction.Create(Self);
  actn.ActionList := Self;

  actn := TBedLayerLoadAction.Create(Self);
  actn.ActionList := Self;

  actn := TLayerDeleteAction.Create(Self);
  actn.ActionList := Self;

end;




procedure TMainTreeActionList.SetBed(const Value: TOldBed);
begin
  FBed := Value;
end;

procedure TMainTreeActionList.SetFilter(const Value: string);
begin
  FFilter := Value;
end;

procedure TMainTreeActionList.SetHorizon(const Value: TOldHorizon);
begin
  FHorizon := Value;
end;

procedure TMainTreeActionList.SetLayer(const Value: TOldLayer);
begin
  FLayer := Value;
end;

procedure TMainTreeActionList.SetStructure(const Value: TOldStructure);
begin
  FStructure := Value;
end;

procedure TMainTreeActionList.SetSubstructure(const Value: TOldSubstructure);
begin
  FSubstructure := Value;
end;

procedure TfrmMainTree.trwMainChange(Sender: TObject; Node: TTreeNode);
var aList: TMainTreeActionList;
begin
  aList := actnList as TMainTreeActionList;
  if Assigned(Node) and not(Node.Deleting) then
  begin
    if Node.Selected then
    begin
      if TObject(Node.Data) is TOldStructure then
      begin
        aList.Structure := TOldStructure(Node.Data);
        aList.Horizon := nil;
        aList.Substructure := nil;
        aList.Bed := nil;
        aList.Layer := nil;
        // догружаем
        { DONE : разобраться - вызывает акссесс виолэйшн }
        try
          (aList.Actions[3] as TStructurePreEditAction).Execute(aList.Structure);
        except

        end;

        if not (TObject(Node.Data) is TOldField) then HorizonLoadAction.Execute(TObject(Node.Data) as TOldStructure);
      end
      else
      if ((TObject(Node.Data) is TOldHorizons) or (TObject(Node.Data) is TOldBeds))
      and (TBaseObject(Node.Parent.Data) is TOldStructure) then
      begin
        aList.Structure := TOldStructure(Node.Parent.Data);
        aList.Horizon := nil;
        aList.Substructure := nil;
        aList.Bed := nil;
        aList.Layer := nil;
        // догружаем
        { DONE : разобраться - вызывает акссесс виолэйшн }
        try
          (aList.Actions[3] as TStructurePreEditAction).Execute(aList.Structure);
        except

        end;

      end
      else
      if (TBaseObject(Node.Data) is TOldHorizon) then
      begin
        //aList.Structure := TOldStructure(Node.Parent.Parent.Data);
        aList.Structure := TOldStructure(Node.Parent.Data);
        aList.Horizon := TOldHorizon(Node.Data);
        aList.Substructure := nil;
        aList.Bed := nil;
        aList.Layer := nil;
      end
      else
      if (TBaseObject(Node.Data) is TOldSubstructure) then
      begin
        aList.Structure := TOldStructure(Node.Parent.Parent.Data);
        aList.Horizon := TOldHorizon(Node.Parent.Data);
        aList.Substructure := TOldSubstructure(Node.Data);
        aList.Bed := nil;
        aList.Layer := nil;
      end
      else
      if (TBaseObject(Node.Data) is TOldBed) then
      begin
        aList.Structure := TOldStructure(Node.Parent.Data);
        aList.Horizon := nil;
        aList.Substructure := nil;
        aList.Bed := TOldBed(Node.Data);
        aList.Layer := nil;
      end
      else if (TBaseObject(Node.Data) is TOldLayer)
           and (TBaseObject(Node.Parent.Data) is TOldSubstructure) then
      begin
        // перегружаем
        ResourceLoadAction.Execute(TOldLayer(Node.Data));

        aList.Structure := TOldStructure(Node.Parent.Parent.Parent.Data);
        aList.Horizon := TOldHorizon(Node.Parent.Parent.Data);
        aList.Substructure := TOldSubstructure(Node.Parent.Data);
        aList.Bed := nil;
        aList.Layer := TOldLayer(Node.Data);
      end
      else if (TBaseObject(Node.Data) is TOldLayer)
           and (TBaseObject(Node.Parent.Data) is TOldBed) then
      begin
        aList.Structure := TOldStructure(Node.Parent.Parent.Data);
        aList.Horizon := nil;
        aList.Substructure := nil;
        aList.Bed := TOldBed(Node.Parent.Data);
        aList.Layer := TOldLayer(Node.Data);
      end;
    end;
    if Assigned(FOnChangeItem) then FOnChangeItem(TObject(Node.Data));
  end
  else
  begin
    AList.Structure := nil;
    AList.Horizon := nil;
    aList.Substructure := nil;
    aList.Bed := nil;
    aList.Layer := nil;
    if Assigned(FOnChangeItem) then FOnChangeItem(nil);    
  end;
end;


function TStructureEditAction.Execute: boolean;
begin
  Result := Execute((ActionList as TMainTreeActionList).Structure);
end;

procedure TStructureEditAction.PrepareForm;
var vValues: OleVariant;
begin
  vValues := (ActionList.Owner as TfrmMainTree).FilterValues;
  if  (not varIsEmpty(vValues))
  and (varIsArray(vValues)) then
  case (ActionList.Owner as TfrmMainTree).FilterID of
  1: frmStructureInfo.AreaID := vValues[0];
  2: frmStructureInfo.PetrolRegionID := vValues[0];
  3: frmStructureInfo.TectStructID := vValues[0];
  4: frmStructureInfo.DistrictID := vValues[0];
  5: frmStructureInfo.OrganizationID := vValues[0];
  end;
end;

function TStructureEditAction.Update: boolean;
var trw: TTreeView;
begin
  inherited Update;

  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result :=  (Assigned(trw.Selected) and (trw.Selected.Level = 0));
  Enabled := Result;

  if Result then
  begin
    if TObject(trw.Selected.Data) is TOldField then
      Caption := 'Редактировать месторождение'
    else
      Caption := 'Редактировать структуру';    
  end;
end;

{ THorizonEditAction }

constructor THorizonEditAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Редактировать горизонт';
  ImageIndex := 8;
end;

function THorizonEditAction.Execute: boolean;
begin
  if Assigned((ActionList as TMainTreeActionList).Horizon) then
    Result := Execute((ActionList as TMainTreeActionList).Horizon)
  else
    Result := Execute((ActionList as TMainTreeActionList).Structure);
end;

function THorizonEditAction.Execute(ABaseObject: TBaseObject): boolean;
var trw: TTreeView;
    actn: THorizonBaseSaveAction;
    Node: TTreeNode;
begin
  Result := true;
  if not Assigned(frmHorizonInfo) then frmHorizonInfo := TfrmHorizonInfo.Create(Self);
  frmHorizonInfo.Prepare;
  frmHorizonInfo.EditingObject := ABaseObject;
  frmHorizonInfo.dlg.ActiveFrameIndex := 0;
  if frmHorizonInfo.ShowModal = mrOK then
  begin
    frmHorizonInfo.Save;
    ABaseObject := (frmHorizonInfo.Dlg.Frames[0] as TbaseFrame).EditingObject;
    actn := THorizonBaseSaveAction.Create(nil);
    actn.Execute(ABaseObject);
    actn.Free;


    // обновляем представление
    trw := (ActionList.Owner as TfrmMainTree).trwMain;
    if TObject(trw.Selected.Data) is TOldHorizon then
      trw.Selected.Text := ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false)
    else
    if TObject(trw.Selected.Data) is TOldStructure then
    begin
      TOldStructure(trw.Selected.Data).Horizons.NeedsUpdate := true;
      (ActionList.Actions[1] as TBaseAction).Execute(TOldStructure(trw.Selected.Data));
      trw.Selected.Expand(false);
      Node := trw.Selected.GetLastChild;
      Node.Selected := true;
    end
    else
    begin
      TOldHorizons(trw.Selected.Data).NeedsUpdate := true;
      (ActionList.Actions[1] as TBaseAction).Execute(TOldStructure(trw.Selected.Parent.Data));
      trw.Selected.Expand(false);

      Node := trw.Selected.GetLastChild;
      Node.Selected := true;
    end;
  end;
end;

function THorizonEditAction.Update: boolean;
var trw: TTreeView;
begin
  inherited Update;
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result :=  (Assigned(trw.Selected) and
             (TObject(trw.Selected.Data) is TOldHorizon));


  Enabled := Result;
end;

{ TStructurePreEditAction }

constructor TStructurePreEditAction.Create(AOwner: TComponent);
begin
  inherited;
end;

function TStructurePreEditAction.Execute(
  ABaseObject: TBaseObject): boolean;
begin
  Result := Inherited Execute(ABaseObject);
end;


{ TDeselectAllAction }

constructor TDeselectAllAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Снять выделение';
  Visible := true;
  CanUndo := false;
end;

function TDeselectAllAction.Execute: boolean;
//var i: integer;
begin
  Result := true;
  with ActionList.Owner as TfrmMainTree do
  begin
{    if Checkboxes then
    begin
      for i := 0 to trwMain.Items.Count - 1 do
      if  trwMain.Items[i].Level = 0 then
      begin
        trwMain.Items[i].SelectedIndex := 0;
        trwMain.Items[i].ImageIndex := 0;
        CheckChildState(trwMain.Items[i].Parent);
        DeriveParentState(trwMain.Items[i]);
      end;
      Refresh;
    end;}
    trwMain.Selected := nil;
  end;
end;

{ TSubstructureEditAction }

constructor TSubstructureEditAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Редактировать подструктуру';
  ImageIndex := 10;
end;

function TSubstructureEditAction.Execute(
  ABaseObject: TBaseObject): boolean;
var trw: TTreeView;
    actn: TSubstructureBaseSaveAction;
begin
  Result := true;
  if not Assigned(frmSubstructureInfo) then frmSubstructureInfo := TfrmSubstructureInfo.Create(Self);

  frmSubstructureInfo.EditingObject := ABaseObject;
  frmSubstructureInfo.dlg.ActiveFrameIndex := 0;

  if frmSubstructureInfo.ShowModal = mrOK then
  begin
    frmSubstructureInfo.Save;
    ABaseObject := (frmSubstructureInfo.Dlg.Frames[0] as TbaseFrame).EditingObject;

    actn := TSubstructureBaseSaveAction.Create(nil);
    actn.Execute(ABaseObject);
    actn.Free;

    // обновляем представление
    trw := (ActionList.Owner as TfrmMainTree).trwMain;
    if TObject(trw.Selected.Data) is TOldSubstructure  then
      trw.Selected.Text := ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false)
    else
    if TObject(trw.Selected.Data) is TOldHorizon then
    begin
      TOldHorizon(trw.Selected.Data).Substructures.NeedsUpdate := true;
      (ActionList.Actions[2] as TBaseAction).Execute(TOldHorizon(trw.Selected.Data));
      trw.Selected.Expand(false);
    end;
  end;
end;

function TSubstructureEditAction.Execute: boolean;
begin
  if Assigned((ActionList as TMainTreeActionList).Substructure) then
    Result := Execute((ActionList as TMainTreeActionList).Substructure)
  else
  if Assigned((ActionList as TMainTreeActionList).Horizon) then
    Result := Execute((ActionList as TMainTreeActionList).Horizon)
  else Result := false;
end;

function TSubstructureEditAction.Update: boolean;
var trw: TTreeView;
begin
  inherited Update;
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result :=  (Assigned(trw.Selected)
         and (TObject(trw.Selected.Data) is TOldSubstructure));


  Enabled := Result;
end;

{ TStructureDeleteAction }

constructor TStructureDeleteAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Удалить структуру';
  Visible := false;
end;

function TStructureDeleteAction.Execute: boolean;
begin
  Result := Execute((ActionList as TMainTreeActionList).Structure);
end;

function TStructureDeleteAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
    trw: TTreeView;
begin
  Result := inherited Execute(ABaseObject);
  if Result then
  begin
    trw := (ActionList.Owner as TfrmMainTree).trwMain;
    trw.Selected.Delete;
  end;
end;

function TStructureDeleteAction.Update: boolean;
var trw: TTreeView;
begin
  inherited Update;
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result :=  (Assigned(trw.Selected) and (TObject(trw.Selected.Data) is TOldStructure));
  Enabled := Result;

  if Result then
  begin
    if TObject(trw.Selected.Data) is TOldField then
      Caption := 'Удалить месторождение'
    else
      Caption := 'Удалить структуру';    
  end;
end;

{ THorizonDeleteAction }

constructor THorizonDeleteAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Удалить горизонт';
  Visible := false;
end;

function THorizonDeleteAction.Execute: boolean;
begin
  Result := Execute((ActionList as TMainTreeActionList).Horizon)
end;

function THorizonDeleteAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
begin
  Result := true;
  if MessageBox(0, PChar('Вы действительно хотите удалить горизонт ' +  #13#10 +
                         ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false) + '?'), 'Вопрос',
                         MB_YESNO+MB_APPLMODAL+MB_DEFBUTTON2+MB_ICONQUESTION) = ID_YES then
  begin
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[THorizonDataPoster];
    dp.DeleteFromDB(ABaseObject);
    (ActionList.Owner as TfrmMainTree).trwMain.Selected.Delete;
    (ActionList.Owner as TfrmMainTree).trwMain.Selected := nil;
  end;
end;

function THorizonDeleteAction.Update: boolean;
var trw: TTreeView;
begin
  inherited Update;
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result :=  Assigned(trw.Selected) and (TObject(trw.Selected.Data) is TOldHorizon);
  Enabled := Result;
end;

{ TSubstructureDeleteAction }

constructor TSubstructureDeleteAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Удалить подструктуру';
  Visible := false;
end;

function TSubstructureDeleteAction.Execute: boolean;
begin
  Result := Execute((ActionList as TMainTreeActionList).Substructure)
end;

function TSubstructureDeleteAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
begin
  Result := true;
  if MessageBox(0, PChar('Вы действительно хотите удалить подструктуру ' +  #13#10 +
                         ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false) + '?'), 'Вопрос',
                         MB_YESNO+MB_APPLMODAL+MB_DEFBUTTON2+MB_ICONQUESTION) = ID_YES then
  begin
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TSubstructureDataPoster];
    dp.DeleteFromDB(ABaseObject);
    (ActionList.Owner as TfrmMainTree).trwMain.Selected.Delete;
  end;
end;

function TSubstructureDeleteAction.Update: boolean;
var trw: TTreeView;
begin
  inherited Update;
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result :=  Assigned(trw.Selected) and (TObject(trw.Selected.Data) is TOldSubstructure);
  Enabled := Result;
end;

{ TDeleteAction }

constructor TDeleteAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Удалить';
  ImageIndex := 24;
end;

function TDeleteAction.Execute: boolean;
var trw: TTreeView;
begin
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result := Execute(TBAseObject(trw.Selected.Data));
end;

function TDeleteAction.Execute(ABaseObject: TBaseObject): boolean;
var actn: TBaseAction;
begin
  Result := false;
  // выбираем какой выполнять
  actn := (ActionList as TMainTreeActionList).ActionByClassType[TStructureDeleteAction];
  if actn.Update then
  begin
    Result := actn.Execute(AbaseObject);
    exit;
  end;

  actn := (ActionList as TMainTreeActionList).ActionByClassType[THorizonDeleteAction];
  if actn.Update then
  begin
    Result := actn.Execute(AbaseObject);
    exit;
  end;

  actn := (ActionList as TMainTreeActionList).ActionByClassType[TSubstructureDeleteAction];
  if actn.Update then
  begin
    Result := actn.Execute(AbaseObject);
    exit;
  end;

  actn := (ActionList as TMainTreeActionList).ActionByClassType[TBedDeleteAction];
  if actn.Update then
  begin
    Result := actn.Execute(AbaseObject);
    exit;
  end;

  actn := (ActionList as TMainTreeActionList).ActionByClassType[TLayerDeleteAction];
  if actn.Update then
  begin
    Result := actn.Execute(AbaseObject);
    exit;
  end;
end;

function TDeleteAction.Update: boolean;
var trw: TTreeView;
begin
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result := Assigned(trw.Selected);
  if Result then
  if TObject(trw.Selected.Data) is TBaseCollection then
    Caption := 'Очистить'
  else
    Caption := 'Удалить';

  Enabled := Result;  
end;

{ TBedLoadAction }

constructor TBedLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
  CanUndo := false;
  Visible := false;
end;

function TBedLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var Node: TTreeNode;
    i: integer;    
begin
  Result := false;
  LastCollection := (ABaseObject as TOldField).Beds;
  if LastCollection.NeedsUpdate then
  begin
    Result := inherited Execute(ABaseObject);

    if Result then
    begin
      // загружаем в интерфейс
      if Assigned(LastCollection) then
      with ActionList.Owner as TfrmMainTree do
      begin
        trwMain.Items.BeginUpdate;

        // чистим
        Node := trwMain.Selected.getFirstChild;
        while Assigned(Node) do
        begin
          Node.Delete;
          Node := trwMain.Selected.getFirstChild;
        end;

        // добавляем
        for i := 0 to LastCollection.Count - 1 do
        begin
          Node := trwMain.Items.AddChildObject(trwMain.Selected, (LastCollection as TOldBeds).Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), LastCollection.Items[i]);
          Node.SelectedIndex := 11;
          // если продуктивные пласты не запрещены к загрузке выбранным уровнем
          //if FClassTypes.IndexOf(TOldLayer) = -1 then
          //  trwMain.Items.AddChild(Node, 'будут продуктивные пласты');
        end;

        trwMain.Items.EndUpdate;
      end;
    end;
  end;
end;

{ TBedHorizonBaseLoadAction }

constructor TBedHorizonLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
  CanUndo := false;
  Visible := false;
end;

function TBedHorizonLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var Node: TTreeNode;
    i: integer;    
begin
  Result := false;
  LastCollection := (ABaseObject as TOldBed).Horizons;
  if LastCollection.NeedsUpdate then
  begin
    Result := inherited Execute(ABaseObject);
    if Result then
    begin
      // загружаем в интерфейс
      if Assigned(LastCollection) then
      with ActionList.Owner as TfrmMainTree do
      begin
        trwMain.Items.BeginUpdate;

        // чистим
        Node := trwMain.Selected.getFirstChild;
        while Assigned(Node) do
        begin
          Node.Delete;
          Node := trwMain.Selected.getFirstChild;
        end;

        // добавляем
        for i := 0 to LastCollection.Count - 1 do
          trwMain.Items.AddChildObject(trwMain.Selected, (LastCollection as TOldHorizons).Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), LastCollection.Items[i]);

        trwMain.Items.EndUpdate;
      end;
    end;
  end;
end;

{ TBedSubstructureLoadAction }

constructor TBedSubstructureLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
  CanUndo := false;
  Visible := false;
end;

function TBedSubstructureLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var Node: TTreeNode;
    i: integer;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldBed).Substructures;
  if LastCollection.NeedsUpdate then
  begin
    Result := inherited Execute(ABaseObject);
    if Result then
    begin
      // загружаем в интерфейс
      if Assigned(LastCollection) then
      with ActionList.Owner as TfrmMainTree do
      begin
        trwMain.Items.BeginUpdate;

        // чистим
        Node := trwMain.Selected.getFirstChild;
        while Assigned(Node) do
        begin
          Node.Delete;
          Node := trwMain.Selected.getFirstChild;
        end;

        // добавляем
        for i := 0 to LastCollection.Count - 1 do
          trwMain.Items.AddChildObject(trwMain.Selected, (LastCollection as TOldSubstructures).Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), LastCollection.Items[i]);

        trwMain.Items.EndUpdate;
      end;
    end;
  end;
end;

procedure TfrmMainTree.trwMainGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  with Node do
    ImageIndex := SelectedIndex;
end;

{ TBedEditAction }

constructor TBedEditAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Редактировать залежь';
  ImageIndex := 11;
end;

function TBedEditAction.Execute(ABaseObject: TBaseObject): boolean;
var trw: TTreeView;
    actn: TBedBaseSaveAction;
    chld: TTreeNode;
    bStructure: boolean;
begin
  Result := true;
  if not Assigned(frmBedInfo) then frmBedInfo := TfrmBedInfo.Create(Self);
//  DebugFileSave('BedEditAction: ' + IntToStr(((ABaseObject as TOldBed).Field).UIN) + ';' + ((ABaseObject as TOldBed).Field).Name);

  frmBedInfo.dlg.ActiveFrameIndex := 0;
  frmBedInfo.EditingObject := ABaseObject;
//  DebugFileSave('frmEditingObject: ' + IntToStr(((frmBedInfo.EditingObject as TOldBed).Field).UIN) + ';' + ((frmBedInfo.EditingObject as TOldBed).Field).Name);

  if frmBedInfo.ShowModal = mrOK then
  begin
    bStructure := ABaseObject is TOldStructure;

    frmBedInfo.Save;
    ABaseObject := (frmBedInfo.Dlg.Frames[0] as TBaseFrame).EditingObject;

    actn := TBedBaseSaveAction.Create(nil);
    actn.Execute(ABaseObject);
    actn.Free;

    // обновляем представление
    trw := (ActionList.Owner as TfrmMainTree).trwMain;
    if (TObject(trw.Selected.Data) is TOldBed) and (not bStructure) then
    begin
      if not(trw.Selected.HasChildren) then
        trw.Items.AddChildFirst(trw.Selected, 'будут продуктивные пласты');
      trw.Selected.Collapse(true);
      trw.Selected.Text := ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
      TOldBed(trw.Selected.Data).Layers.NeedsUpdate := true;
      trw.Selected.Expand(false);
    end
    else
    if (TObject(trw.Selected.Data) is TOldField) then
    begin
      chld := trw.Selected.getFirstChild;
      while Assigned(chld) do
      begin
        if TObject(chld.Data) is TOldBeds then
        begin
          chld.Selected := true;
          break;
        end;
        chld := trw.Selected.GetNextChild(chld);
      end;



      TOldBeds(trw.Selected.Data).NeedsUpdate := true;
      // экшен перегрузки
      ((ActionList as TMainTreeActionList).ActionByClassType[TBedLoadAction] as TBaseAction).Execute(TOldField(trw.Selected.Parent.Data));
      trw.Selected.Expand(false);
    end
    else
    if (TObject(trw.Selected.Data) is TOldBeds) or bStructure then
    begin
      if (TObject(trw.Selected.Data) is TOldBed) then trw.Selected.Parent.Selected := true;

      TOldBeds(trw.Selected.Data).NeedsUpdate := true;
      // поменять экшен
      // экшен перегрузки
      ((ActionList as TMainTreeActionList).ActionByClassType[TBedLoadAction] as TBaseAction).Execute(TOldField(trw.Selected.Parent.Data));
      trw.Selected.Expand(false);
    end;
  end;
end;

function TBedEditAction.Execute: boolean;
begin
  if Assigned((ActionList as TMainTreeActionList).Bed) then
    Result := Execute((ActionList as TMainTreeActionList).Bed)
  else if Assigned((ActionList as TMainTreeActionList).Structure) then
    Result := Execute((ActionList as TMainTreeActionList).Structure)
  else Result := false;
end;

function TBedEditAction.Update: boolean;
var trw: TTreeView;
begin
  inherited Update;
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result :=  (Assigned(trw.Selected)
         and (TObject(trw.Selected.Data) is TOldBed));


  Enabled := Result;
end;

{ TBedDeleteAction }

constructor TBedDeleteAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Удалить залежь';
  Visible := false;
end;

function TBedDeleteAction.Execute: boolean;
begin
  Result := Execute((ActionList as TMainTreeActionList).Bed);
end;

function TBedDeleteAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
begin
  Result := true;
  if MessageBox(0, PChar('Вы действительно хотите удалить залежь ' +  #13#10 +
                         ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false) + '?'), 'Вопрос',
                         MB_YESNO+MB_APPLMODAL+MB_DEFBUTTON2+MB_ICONQUESTION) = ID_YES then
  begin
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TBedDataPoster];
    dp.DeleteFromDB(ABaseObject);
    (ActionList.Owner as TfrmMainTree).trwMain.Selected.Delete;
  end;
end;

function TBedDeleteAction.Update: boolean;
var trw: TTreeView;
begin
  inherited Update;
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result := Assigned(trw.Selected) and (TObject(trw.Selected.Data) is TOldBed);

  Enabled := Result;
end;

{ TClearAction }

constructor TClearAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Очистить';
  Visible := false;
  CanUndo := false;
end;

function TClearAction.Execute: boolean;
begin
  Result := true;
  with (ActionList.Owner as TfrmMainTree) do
  begin
    Structures.Clear;
    trwMain.Items.Clear;
  end;
end;

{ TLayerLoadAction }
function TLayerLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var i: integer;
    Node: TTreeNode;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldSubstructure).Layers;
  if LastCollection.NeedsUpdate then
  begin
    Result := inherited Execute(ABaseObject);
    if Result then
    begin
      // загружаем в интерфейс
      if Assigned(LastCollection) then
      with ActionList.Owner as TfrmMainTree do
      begin
        trwMain.Items.BeginUpdate;

        // чистим
        Node := trwMain.Selected.getFirstChild;
        while Assigned(Node) do
        begin
          Node.Delete;
          Node := trwMain.Selected.getFirstChild;
        end;

        // добавляем
        for i := 0 to LastCollection.Count - 1 do
        begin
          Node := trwMain.Items.AddChildObject(trwMain.Selected, (LastCollection as TOldLayers).Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), LastCollection.Items[i]);
          Node.SelectedIndex := 12;
        end;

        trwMain.Items.EndUpdate;
      end;
    end;
  end;
end;


constructor TLayerLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
  CanUndo := false;
  Visible := false;
end;

{ TLayerEditAction }

constructor TLayerEditAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Visible := true;
  Caption := 'Редактировать продуктивный горизонт';
  ImageIndex := 12;
end;

function TLayerEditAction.Execute(ABaseObject: TBaseObject): boolean;
var dp, dpParam, dpd: RRManagerPersistentObjects.TDataPoster;
    trw: TTreeView;
    lr: TOldLayer;
    i: integer;
    pObj: TBaseObject;
    frm: TCommonForm;
    actn: TLayerBaseSaveAction;
begin
  Result := true;

  if ABaseObject is TOldLayer then
  if Assigned((ABaseObject as TOldLayer).Substructure) then
    pObj := (ABaseObject as TOldLayer).Substructure
  else
  if ABaseObject is TOldLayer then
  if Assigned((ABaseObject as TOldLayer).Bed) then
    pObj := (ABaseObject as TOldLayer).Bed
  else if Assigned(ABaseObject) then
    pObj := ABaseObject
  else pObj := nil;




  if Assigned(pObj) then
  begin
    if pObj is TOldSubstructure then
    begin
      if not Assigned(frmLayerInfo) then frmLayerInfo := TfrmLayerInfo.Create(Self);
      frm := frmLayerInfo;
    end
    else if pObj is TOldBed then
    begin
      if not Assigned(frmReservesLayerInfo) then frmReservesLayerInfo := TfrmReservesLayerInfo.Create(Self);
      frm := frmReservesLayerInfo;
    end;


    frm.EditingObject := ABaseObject;
    frm.dlg.ActiveFrameIndex := 0;


    if frm.ShowModal = mrOK then
    begin
      frm.Save;
      ABaseObject := (frm.dlg.Frames[0] as TbaseFrame).EditingObject;

      actn := TLayerBaseSaveAction.Create(nil);
      actn.Execute(ABaseObject);
      actn.Free;


      // обновляем представление
      trw := (ActionList.Owner as TfrmMainTree).trwMain;
      if TObject(trw.Selected.Data) is TOldLayer then
      begin
        trw.Selected.Text := ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false)
      end
      else
      if TObject(trw.Selected.Data) is TOldSubstructure then
      begin
        TOldSubstructure(trw.Selected.Data).Layers.NeedsUpdate := true;
        (ActionList as TMainTreeActionList).ActionByClassType[TLayerLoadAction].Execute(TOldSubstructure(trw.Selected.Data));
        trw.Selected.Expand(false);
      end
      else if TObject(trw.Selected.Data) is TOldBed then
      begin
        TOldBed(trw.Selected.Data).Layers.NeedsUpdate := true;
        (ActionList as TMainTreeActionList).ActionByClassType[TBedLayerLoadAction].Execute(TOldSubstructure(trw.Selected.Data));
        trw.Selected.Expand(false);
      end;
    end;
  end;
end;

function TLayerEditAction.Execute: boolean;
begin
  if Assigned((ActionList as TMainTreeActionList).Layer) then
    Result := Execute((ActionList as TMainTreeActionList).Layer)
  else if Assigned((ActionList as TMainTreeActionList).Substructure) then
    Result := Execute((ActionList as TMainTreeActionList).Substructure)
  else if Assigned((ActionList as TMainTreeActionList).Bed) then
    Result := Execute((ActionList as TMainTreeActionList).Bed)
  else Result := false;
end;

function TLayerEditAction.Update: boolean;
var trw: TTreeView;
begin
  inherited Update;
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result :=  (Assigned(trw.Selected)
         and (TObject(trw.Selected.Data) is TOldLayer));


  Enabled := Result;
end;

{ TBedLayerLoadAction }

constructor TBedLayerLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
  CanUndo := false;
  Visible := false;
end;

function TBedLayerLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var i: integer;
    Node: TTreeNode;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldBed).Layers;
  if LastCollection.NeedsUpdate then
  begin
    Result := inherited Execute(ABaseObject);
    if Result then
    begin
      // загружаем в интерфейс
      if Assigned(LastCollection) then
      with ActionList.Owner as TfrmMainTree do
      begin
        trwMain.Items.BeginUpdate;


        // чистим
        Node := trwMain.Selected.getFirstChild;
        while Assigned(Node) do
        begin
          Node.Delete;
          Node := trwMain.Selected.getFirstChild;
        end;

        // добавляем
        for i := 0 to LastCollection.Count - 1 do
        begin
          Node := trwMain.Items.AddChildObject(trwMain.Selected, (LastCollection as TOldLayers).Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), LastCollection.Items[i]);
          Node.SelectedIndex := 12;
        end;

        trwMain.Items.EndUpdate;
      end;
    end;
  end;
end;

{ TLayerDeleteAction }

constructor TLayerDeleteAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Удалить подструктуру';
  Visible := false;
end;

function TLayerDeleteAction.Execute: boolean;
begin
  Result := Execute((ActionList as TMainTreeActionList).Layer)
end;

function TLayerDeleteAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
begin
  Result := true;
  if MessageBox(0, PChar('Вы действительно хотите удалить продуктивный горизонт ' +  #13#10 +
                         ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false) + '?'), 'Вопрос',
                         MB_YESNO+MB_APPLMODAL+MB_DEFBUTTON2+MB_ICONQUESTION) = ID_YES then
  begin
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TLayerDataPoster];
    dp.DeleteFromDB(ABaseObject);
    (ActionList.Owner as TfrmMainTree).trwMain.Selected.Delete;
  end;
end;

function TLayerDeleteAction.Update: boolean;
var trw: TTreeView;
begin
  inherited Update;
  trw := (ActionList.Owner as TfrmMainTree).trwMain;
  Result :=  Assigned(trw.Selected) and (TObject(trw.Selected.Data) is TOldLayer);
  Enabled := Result;
end;

{ TMakeReportAction }

constructor TMakeReportAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Создать отчет';
  Visible := true;
  CanUndo := false;
  ImageIndex := 15;
end;

function TMakeReportAction.Execute: boolean;
begin
  Result := true;
  if not Assigned(frmReport) then frmReport := TfrmReport.Create(Self);
  frmReport.dlg.ActiveFrameIndex := 0;

  frmReport.Show;
end;



{ TSelectAllAction }

constructor TSelectAllAction.Create(AOwner: TComponent);
begin
  inherited Create(Self);
end;

function TSelectAllAction.Execute: boolean;
//var i: integer;
begin
  Result := true;
{  with (ActionList.Owner as TfrmMainTree) do
  if Checkboxes then
  begin
    for i := 0 to trwMain.Items.Count - 1 do
    if  trwMain.Items[i].Level = 0 then
    begin
      trwMain.Items[i].SelectedIndex := 1;
      trwMain.Items[i].ImageIndex := 1;
      CheckChildState(trwMain.Items[i].Parent);
      DeriveParentState(trwMain.Items[i]);
    end;
    Refresh;
  end;}
end;

procedure TfrmMainTree.cmbxVersionChange(Sender: TObject);
begin

end;


{ TStructureAddAction }

constructor TStructureAddAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Добавить структуру/месторождение';
  ImageIndex := 13;
end;

function TStructureAddAction.Execute: boolean;
begin
  Result := inherited Execute(nil);
end;

function TStructureAddAction.Update: boolean;
begin
  Result :=  true;
  Enabled := Result;


end;

{ THorizonAddAction }

constructor THorizonAddAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Добавить горизонт';
  ImageIndex := 14;
end;

function THorizonAddAction.Execute: boolean;
begin
  Result := inherited Execute((ActionList as TMainTreeActionList).Structure);
end;

function THorizonAddAction.Update: boolean;
begin
  inherited Update;

  Result :=  Assigned((ActionList as TMainTreeActionList).Structure);


  Enabled := Result;
end;

{ TSubstructureAddAction }

constructor TSubstructureAddAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Добавить подструктуру';
  ImageIndex := 15;
end;

function TSubstructureAddAction.Execute: boolean;
begin
  Result := inherited Execute((ActionList as TMainTreeActionList).Horizon);
end;

function TSubstructureAddAction.Update: boolean;
begin
  inherited Update;
  Result :=  Assigned((ActionList as TMainTreeActionList).Horizon);

  Enabled := Result;
end;

{ TBedAddAction }

constructor TBedAddAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Добавить залежь';
  ImageIndex := 17;
end;

function TBedAddAction.Execute: boolean;
begin


  Result := inherited Execute((ActionList as TMainTreeActionList).Structure);
end;

function TBedAddAction.Update: boolean;
begin
  inherited Update;

  Result :=  Assigned((ActionList as TMainTreeActionList).Structure);


  Enabled := Result;
end;

{ TLayerAddAction }

constructor TLayerAddAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Добавить продуктивный горизонт';
  ImageIndex := 16;
end;

function TLayerAddAction.Execute: boolean;
begin
  Result := false;
  if Assigned((ActionList as TMainTreeActionList).Substructure) then
    Result := inherited Execute((ActionList as TMainTreeActionList).Substructure)
  else
  if Assigned((ActionList as TMainTreeActionList).Bed) then
    Result := inherited Execute((ActionList as TMainTreeActionList).Bed);
end;

function TLayerAddAction.Update: boolean;
begin
  inherited Update;

  Result := Assigned((ActionList as TMainTreeActionList).Substructure);


  Enabled := Result;
end;

{ TDictEditAction }

constructor TDictEditAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Редактировать справочники';
  Visible := true;
  CanUndo := false;
  ImageIndex := 26;
end;

function TDictEditAction.Execute: boolean;
begin
  Result := true;
  if not Assigned(frmDictEditor) then frmDictEditor := TfrmDictEditor.Create(Self);
  frmDictEditor.ShowModal;
end;

procedure TfrmMainTree.cmbxListOptionChange(Sender: TObject);
begin
  trwMain.Selected := nil;
  // это все делается чтоб обновить - неудобно конечно, но что ж.
  (StructureLoadAction as TStructureBaseLoadAction).LastFilter := '';
  StructureLoadAction.Execute;
end;

procedure TfrmMainTree.trwMainDeletion(Sender: TObject; Node: TTreeNode);
begin
//  if Assigned(FOnChangeItem) then FOnChangeItem(nil);
//  if Assigned(Node) then Node.Data := nil;
end;






procedure TfrmMainTree.cmbxFilterDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  //
  if TAdditionalFilter(cmbxFilter.Items.Objects[Index]).ImageIndex > 0 then
    imgList.Draw(cmbxFilter.Canvas, Rect.Left + 1, Rect.Top + 1, TAdditionalFilter(cmbxFilter.Items.Objects[Index]).ImageIndex);
  cmbxFilter.Canvas.TextOut(Rect.Left + 22, Rect.Top + 2, cmbxFilter.Items[Index]);
end;


procedure TfrmMainTree.cmbxFilterMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
   Height := 18;
end;

procedure TfrmMainTree.cmbxFilterChange(Sender: TObject);
var sFilter, sAddedFilter, sLastFilter: string;
begin
  sFilter := (actnList as TMainTreeActionList).Filter;
  sLastFilter := sFilter;
  sAddedFilter := TAdditionalFilter(cmbxFilter.Items.Objects[cmbxFilter.ItemIndex]).Query;
  if (trim(sFilter) <> '') and (trim(sAddedFilter) <> '') then
     sFilter := sFilter + ' and ' + '(' + sAddedFilter + ')'
  else if trim(sFilter) = '' then sFilter := sAddedFilter;


  if chbxShowBalancedOnly.Checked then
    sFilter := sFilter + ' AND (NUM_BALANCED > 0)'
  else
    sFilter := sFilter + ' AND (NUM_BALANCED >= 0)';


  DeselectAllAction.Execute;
  StructureLoadAction.Execute(sFilter);
  
  (actnList as TMainTreeActionList).Filter := sLastFilter;

  if Assigned(FOnChangeStructure) then FOnChangeStructure(nil);
end;

{ TReportActionList }

constructor TReportActionList.Create(AOwner: TComponent);
var actn: TBaseAction;
begin
  inherited;

  actn := TMakeReportAction.Create(Self);
  actn.ActionList := Self;

  actn := TCreateNewReportAction.Create(Self);
  actn.ActionList := Self;

  actn := TAddNewReportAction.Create(Self);
  actn.ActionList := Self;
end;

{ TCreateNewReportAction }

constructor TCreateNewReportAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Редакция отчётов';
  Visible := true;
  CanUndo := false;
  ImageIndex := 16;
end;

function TCreateNewReportAction.Execute: boolean;
begin
  Result := true;

  if not Assigned(frmNewReport) then frmNewReport := TfrmNewReport.Create(Self);
  frmNewReport.dlg.ActiveFrameIndex := 0;

  if frmNewReport.ShowModal = mrOK then
    // выдача отчета
    frmNewReport.Save;
end;

{ TAddNewReportAction }

constructor TAddNewReportAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Новый отчет';
  Visible := true;
  CanUndo := false;

  ImageIndex := 17;
end;

function TAddNewReportAction.Execute: boolean;
begin
  Result := inherited Execute;
end;

procedure TfrmMainTree.sbtnUINClick(Sender: TObject);
begin

end;

{ TMakeArchiveAction }

constructor TMakeArchiveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Архивировать активную версию фонда структур';
  Visible := true;
  CanUndo := false;

  ImageIndex := 31;
end;

function TMakeArchiveAction.Execute: boolean;
begin
  // показать форму создания архива
  // после нажатия готово - обновить список на главной форме
  Result := true;
  if not Assigned(frmVersionInfo) then
  begin
    frmVersionInfo := TfrmVersionInfo.Create(Self.Owner);
    frmVersionInfo.OnAfterFinishClick := (ActionList.Owner as TfrmMainTree).OnCreateArchive;
  end;

  frmVersionInfo.EditingObject := nil;

  frmVersionInfo.dlg.ActiveFrameIndex := 0;


  frmVersionInfo.Show;
end;

{ TLicenseZoneLoadAction }

constructor TLicenseZoneLoadAction.Create(AOwner: TComponent);
begin
  inherited;

end;

function TLicenseZoneLoadAction.Execute: boolean;
begin
  Result := Execute((ActionList as TMainTreeActionList).Filter);
end;

function TLicenseZoneLoadAction.Execute(AFilter: string): boolean;
begin

end;

function TLicenseZoneLoadAction.Execute(ABaseObject: TBaseObject): boolean;
begin

end;

{ TFundTypeAdditionalFilter }

constructor TFundTypeAdditionalFilters.Create;
begin
  inherited;
  Add('<нет>', '', 0);
  Add('только выявленные', 'Structure_Fund_Type_ID = 1', 4);
  Add('только подготовленные', 'Structure_Fund_Type_ID = 2', 5);
  Add('только в бурении', 'Structure_Fund_Type_ID = 3', 6);
  Add('только месторождения', 'Structure_Fund_Type_ID = 4', 7);
  Add('вне фонда', 'Structure_Fund_Type_ID in (5, 7)', 29);
  Add('нет данных', 'Structure_Fund_Type_ID = 6', 30);
end;

{ TRecourceLoadAction }

constructor TRecourceLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
  CanUndo := false;
  Visible := false;
end;

function TRecourceLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var i: integer;
    actn: TBaseAction;
begin
  LastCollection := (ABaseObject as TOldLayer).Versions;
  Result := inherited Execute(ABaseObject);

  actn := TResourcesBaseLoadAction.Create(Owner);
  for i := 0 to (ABaseObject as TOldLayer).Versions.Count - 1 do
  begin
    actn.LastCollection := (ABaseObject as TOldLayer).Versions.Items[i].Resources;
    Result := actn.Execute((ABaseObject as TOldLayer).Versions.Items[i]);
  end;
end;

procedure TfrmMainTree.trwMainAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
var r: TRect;
begin
  trwMain.Canvas.Font.Style := [];
  trwMain.Canvas.Font.Color := clBlack;
  trwMain.Canvas.Brush.Color := clWhite;

  if cdsSelected in State then
    trwMain.Canvas.Brush.Color :=  $00EFEFEF;

  if TObject(Node.Data) is TOldHorizon then
  begin
    if (TObject(Node.Data) as TOldHorizon).Structure.CartoHorizon = (TObject(Node.Data) as TOldHorizon) then
    begin
      r := Node.DisplayRect(true);
      trwMain.Canvas.Font.Style := [fsBold];
      trwMain.Canvas.Font.Color := clBlack;
      trwMain.Canvas.FillRect(r);
      trwMain.Canvas.TextOut(r.Left + 1, r.Top + 1, Node.Text);
    end
    else trwMain.Canvas.Font.Style := [];
  end
  else trwMain.Canvas.Font.Style := [];


end;

procedure TfrmMainTree.trwMainDblClick(Sender: TObject);
var Node: TTreeNode;
begin
  Node := trwMain.Selected;
  if Assigned(Node) and (not Node.HasChildren) then
  begin
    if (TObject(Node.Data) is TOldStructure) then
      (actnList as TMainTreeActionList).ActionByClassType[TStructureEditAction].Execute(TBaseObject(Node.Data))
    else if (TObject(Node.Data) is TOldHorizon) then
      (actnList as TMainTreeActionList).ActionByClassType[THorizonEditAction].Execute(TBaseObject(Node.Data))
    else if (TObject(Node.Data) is TOldSubstructure) then
      (actnList as TMainTreeActionList).ActionByClassType[TSubstructureEditAction].Execute(TBaseObject(Node.Data))
    else if (TObject(Node.Data) is TOldLayer) then
      (actnList as TMainTreeActionList).ActionByClassType[TLayerEditAction].Execute(TBaseObject(Node.Data))
    else if (TObject(Node.Data) is TOldBed) then
      (actnList as TMainTreeActionList).ActionByClassType[TBedEditAction].Execute(TBaseObject(Node.Data));
  end;
end;

end.
