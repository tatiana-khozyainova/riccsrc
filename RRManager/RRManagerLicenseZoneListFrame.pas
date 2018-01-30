unit RRManagerLicenseZoneListFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerObjects, StdCtrls, ComCtrls, RRManagerBaseGUI, RRManagerBaseObjects,
  ExtCtrls, ToolWin, RRManagerLicenseZoneInfoForm, RRManagerPersistentObjects,
  RRManagerDataPosters, ImgList, Menus;

type
  TfrmLicenseZoneList = class(TFrame)
    gbxAll: TGroupBox;
    lwLicenseZone: TListView;
    pnlFilter: TPanel;
    cmbxLicenseZoneType: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cmbxLicenseType: TComboBox;
    tlbrActions: TToolBar;
    imgList: TImageList;
    procedure lwLicenseZoneColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure lwLicenseZoneChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure cmbxLicenseZoneTypeChange(Sender: TObject);
    procedure cmbxLicenseTypeChange(Sender: TObject);
    procedure lwLicenseZoneDblClick(Sender: TObject);
    procedure lwLicenseZoneAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure cmbxLicenseTypeDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmbxLicenseTypeDropDown(Sender: TObject);
  private
    { Private declarations }
    actnList: TBaseActionList;
    FLicenseZones: TOldLicenseZones;
    FFilterID: integer;
    FFilterValues: OleVariant;
    FOnChangeItem: TNotifyEvent;
    FZoneFilters, FZoneTypeFilters: TAdditionalFilters;
    FMenus: TMenuList;
    FFilterList: TStringList;
    procedure RefreshStructs;
    procedure SetLicenseZones(const Value: TOldLicenseZones);
    function  GetDeselectAllAction: TBaseAction;
    function  GetLicenseZoneLoadAction: TBaseAction;
    function  GetMenus(AItemName: string): TMenu;
    function  GetActiveLicenseZone: TOldLicenseZone;
  public
    { Public declarations }
    property    Menus[AItemName: string]: TMenu read GetMenus;
    property    LicenseZoneLoadAction: TBaseAction read GetLicenseZoneLoadAction;
    property    DeselectAllAction: TBaseAction read GetDeselectAllAction;
    property    LicenseZones: TOldLicenseZones read FLicenseZones write SetLicenseZones;
    property    FilterID: integer read FFilterID write FFilterID;
    property    FilterValues: OleVariant read FFilterValues write FFilterValues;

    property    ActiveLivenseZone: TOldLicenseZone read GetActiveLicenseZone;

    property    OnChangeItem: TNotifyEvent read FOnChangeItem write FOnChangeItem;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses RRManagerLoaderCommands, RRManagerHorizonInfoForm, RRManagerEditCommands,
     ActnList, RRManagerBasicLicenseZoneInfoForm,
     RRManagerChangeLicenseZoneFundForm, Facade,
     CommonIDObjectListForm, IDObjectBaseActions,
     RRManagerLicenseConditionTypeEditForm;

{$R *.dfm}

type

  TFilterList = class(TStringList)
  public
    constructor Create;
  end;


  TLicenseTypeAdditionalFilters = class(TAdditionalFilters)
  public
    constructor Create; override;
  end;

  TLicenseZoneTypeFilters = class(TAdditionalFilters)
  public
    constructor Create; override;
  end;


  TDeselectAllAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TLicenseZoneLoadAction = class(TLicenseZoneBaseLoadAction)
  public
    function Execute: boolean; overload; override;
    function Execute(AFilter: string): boolean; override;
    function Execute(ABaseObject: TBaseObject): boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;


  TLicenseZoneFrameActionList = class(TBaseActionList)
  private
    FFilter: string;
    FLicenseZone: TOldLicenseZone;
    procedure SetFilter(const Value: string);
    procedure SetLicenseZone(const Value: TOldLicenseZone);
  public
    property    LicenseZone: TOldLicenseZone read FLicenseZone write SetLicenseZone;
    property    Filter: string read FFilter write SetFilter;
    constructor Create(AOwner: TComponent); override;
  end;

  TLicenseZoneEditAction = class(TBaseAction)
  protected
    procedure DoAfterExecute(ABaseObject: TBaseObject); virtual;
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    function Execute: boolean; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TLicenseZoneChangeStateAction = class(TLicenseZoneEditAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;



  TLicenseZoneAddAction = class(TLicenseZoneEditAction)
  protected
    procedure DoAfterExecute(ABaseObject: TBaseObject); override;
  public
    function Execute: boolean; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TBasicLicenseZoneEditAction = class(TBaseAction)
  protected
    procedure DoAfterExecute(ABaseObject: TBaseObject); virtual;
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    function Execute: boolean; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TBasicLicenseZoneAddAction = class(TBasicLicenseZoneEditAction)
  protected
    procedure DoAfterExecute(ABaseObject: TBaseObject); override;
  public
    function Execute: boolean; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TLicenseZoneDeleteAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;


  TLicenseKindShowDictAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TLicenseConditionTypeShowDictAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TLicenseConditionTypeEditAction = class(TIDObjectEditAction)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TLicenseConditionTypeAddAction = class(TIDObjectAddAction)
  public
    constructor Create(AOwner: TComponent); override;
  end;



{ TfrmLicenseZoneList }

constructor TfrmLicenseZoneList.Create(AOwner: TComponent);
var mn: TMenu;
    mi: TMenuItem;
    actn: TBaseAction;
begin
  inherited;
  FFilterList := TFilterList.Create;

  actnList := TLicenseZoneFrameActionList.Create(Self);
  actnList.Images := imgList;

  FZoneFilters := TLicenseZoneTypeFilters.Create;
  FZoneFilters.MakeList(cmbxLicenseZoneType.Items);
  cmbxLicenseZoneType.ItemIndex := 0;

  FZoneTypeFilters := TLicenseTypeAdditionalFilters.Create;
  FZoneTypeFilters.MakeList(cmbxLicenseType.Items);
  cmbxLicenseType.ItemIndex := 0;

  FMenus := TMenuList.Create(imgList);

  mn := FMenus.AddMenu(TMainMenu, AOwner);

  mn.Name := 'mnLicenseActions';

  mi := FMenus.AddMenuItem(mn, nil);
  mi.Caption := 'Лицензионные участки';
  mi.GroupIndex := 4;


  actn := (actnList as TLicenseZoneFrameActionList).ActionByClassType[TLicenseConditionTypeShowDictAction];
  FMenus.AddMenuItem(0, mi, actn);

  actn := (actnList as TLicenseZoneFrameActionList).ActionByClassType[TLicenseKindShowDictAction];
  FMenus.AddMenuItem(0, mi, actn);
  FMenus.AddMenuItem(0, mi, nil);

  actn := (actnList as TLicenseZoneFrameActionList).ActionByClassType[TLicenseZoneDeleteAction];
  FMenus.AddMenuItem(0, mi, actn);
  FMenus.AddMenuItem(0, mi, nil);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TLicenseZoneFrameActionList).ActionByClassType[TLicenseZoneChangeStateAction];
  FMenus.AddMenuItem(0, mi, actn);
  FMenus.AddMenuItem(0, mi, nil);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TLicenseZoneFrameActionList).ActionByClassType[TBasicLicenseZoneAddAction];
  FMenus.AddMenuItem(0, mi, actn);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TLicenseZoneFrameActionList).ActionByClassType[TLicenseZoneAddAction];
  FMenus.AddMenuItem(0, mi, actn);
  AddToolButton(tlbrActions, actn);


  actn := (actnList as TLicenseZoneFrameActionList).ActionByClassType[TBasicLicenseZoneEditAction];
  FMenus.AddMenuItem(0, mi, actn);
  AddToolButton(tlbrActions, actn);

  actn := (actnList as TLicenseZoneFrameActionList).ActionByClassType[TLicenseZoneEditAction];
  FMenus.AddMenuItem(0, mi, actn);
  FMenus.AddMenuItem(0, mi, nil);
  AddToolButton(tlbrActions, actn);





  mn := FMenus.AddMenu(TPopupMenu, AOwner);
  mn.Name := 'mnLicensePopup';

  FMenus.AddMenuItem(mn, (actnList as TLicenseZoneFrameActionList).ActionByClassType[TDeselectAllAction]);
  FMenus.AddMenuItem(mn, nil);
  FMenus.AddMenuItem(mn, (actnList as TLicenseZoneFrameActionList).ActionByClassType[TLicenseZoneAddAction]);
  FMenus.AddMenuItem(mn, (actnList as TLicenseZoneFrameActionList).ActionByClassType[TLicenseZoneEditAction]);
end;

function TfrmLicenseZoneList.GetDeselectAllAction: TBaseAction;
begin
  Result := (actnList as TLicenseZoneFrameActionList).ActionByClassType[TDeselectAllAction];
end;

function TfrmLicenseZoneList.GetLicenseZoneLoadAction: TBaseAction;
begin
  Result := (actnList as TLicenseZoneFrameActionList).ActionByClassType[TLicenseZoneLoadAction];
end;

procedure TfrmLicenseZoneList.SetLicenseZones(const Value: TOldLicenseZones);
var i: integer;
    li: TListItem;
begin
  if FLicenseZones <> Value then
  begin
    FLicenseZones := Value;
    lwLicenseZone.Items.Clear;
    for i := 0 to FLicenseZones.Count - 1 do
    begin
      li := lwLicenseZone.Items.Add;

      li.Data := FLicenseZones.Items[i];
      li.Caption := FLicenseZones.Items[i].LicenseZoneName;
      li.SubItems.Add(FLicenseZones.Items[i].LicenseZoneNum);
    end;
  end;
end;

procedure TfrmLicenseZoneList.RefreshStructs;
begin

end;

destructor TfrmLicenseZoneList.Destroy;
begin
  FFilterList.Free;
  FZoneFilters.Free;
  FZoneTypeFilters.Free;
  FMenus.Free;
  inherited;
end;

function TfrmLicenseZoneList.GetMenus(AItemName: string): TMenu;
var i: integer;
    mns: TMenuList;
begin
  Result := nil;
  mns := FMenus as TMenuList;
  for i := 0 to mns.Count - 1 do
  if mns.Items[i].Name = AItemName then
  begin
    Result := mns.Items[i] as TMenu;
    break;
  end;
end;

function TfrmLicenseZoneList.GetActiveLicenseZone: TOldLicenseZone;
begin
  if Assigned(lwLicenseZone.Selected) then
    Result := TOldLicenseZone(lwLicenseZone.Selected.Data)
  else
    Result := nil;
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
begin
  Result := true;
  with ActionList.Owner as TfrmLicenseZoneList do
    lwLicenseZone.Selected := nil;
end;

{ TLicenseZoneFrameActionList }

constructor TLicenseZoneFrameActionList.Create(AOwner: TComponent);
var actn: TBaseAction;
begin
  inherited;

  actn := TDeselectAllAction.Create(Self);
  actn.ActionList := Self;


  actn := TLicenseZoneLoadAction.Create(Self);
  actn.ActionList := Self;

  actn := TLicenseZoneAddAction.Create(Self);
  actn.ActionList := Self;

  actn := TBasicLicenseZoneAddAction.Create(Self);
  actn.ActionList := Self;

  actn := TLicenseZoneEditAction.Create(Self);
  actn.ActionList := Self;

  actn := TBasicLicenseZoneEditAction.Create(Self);
  actn.ActionList := Self;

  actn := TLicenseZoneChangeStateAction.Create(Self);
  actn.ActionList := Self;

  actn := TLicenseZoneDeleteAction.Create(Self);
  actn.ActionList := Self;  
end;

procedure TLicenseZoneFrameActionList.SetFilter(const Value: string);
begin
  FFilter := Value;
end;

procedure TLicenseZoneFrameActionList.SetLicenseZone(
  const Value: TOldLicenseZone);
begin
  FLicenseZone := Value;
end;

{ TLicenseZoneLoadAction }

constructor TLicenseZoneLoadAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CanUndo := false;
  Visible := false;
end;

function TLicenseZoneLoadAction.Execute: boolean;
begin
  Result := Execute((ActionList as TLicenseZoneFrameActionList).Filter);
end;

function TLicenseZoneLoadAction.Execute(AFilter: string): boolean;
var li: TListItem;
    i: integer;
    lz: TOldLicenseZone;
begin

  (ActionList as TLicenseZoneFrameActionList).Filter := AFilter;
  Result := false;
  LastCollection := (ActionList.Owner as TfrmLicenseZoneList).LicenseZones;
  LastCollection.NeedsUpdate := AFilter <> LastFilter;
  LastFilter := AFilter;


  if LastCollection.NeedsUpdate then
  with ActionList.Owner as TfrmLicenseZoneList do
  begin
    lwLicenseZone.Items.BeginUpdate;
    lwLicenseZone.Items.Clear;

    Result := inherited Execute(AFilter);

    if Result then
    begin
      // загружаем в интерфейс
      if Assigned(LastCollection) then
      begin

        for i := 0 to LastCollection.Count - 1 do
        begin
          li := lwLicenseZone.Items.Add;

          lz := LastCollection.Items[i] as TOldLicenseZone;
          if lz.LicenseZoneStateID > 0 then
            li.ImageIndex := lz.LicenseZoneStateID + 1
          else
            li.ImageIndex := -1; 
          

          li.Caption := lz.LicenseZoneName;
          li.SubItems.Add(lz.LicenseZoneNum);
          li.SubItems.Add(lz.License.LicenseTypeShortName);
          li.SubItems.Add(lz.License.OwnerOrganizationName);

          li.Data := LastCollection.Items[i];
        end;
      end
    end;
    lwLicenseZone.Items.EndUpdate;
  end;
end;

function TLicenseZoneLoadAction.Execute(ABaseObject: TBaseObject): boolean;
begin
  Result := true;
  if ABaseObject is TOldLicenseZone then
    Result := Execute('License_Zone_ID = ' + IntToStr(ABaseObject.ID));
end;

procedure TfrmLicenseZoneList.lwLicenseZoneColumnClick(Sender: TObject;
  Column: TListColumn);
var sFilterSQL: string;
begin
  sFilterSQL := (LicenseZoneLoadAction as TLicenseZoneLoadAction).LastFilter;

  if Pos('order by', sFilterSQL) > 0 then
    sFilterSQL := Copy(sFilterSQL, 1, Pos('order by', sFilterSQL) - 1);

  if sFilterSQL <> '' then
    LicenseZoneLoadAction.Execute(sFilterSQL + ' order by ' + FFilterList.Strings[Column.Index])
  else LicenseZoneLoadAction.Execute('');

end;

procedure TfrmLicenseZoneList.lwLicenseZoneChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  if Assigned(Item) and (not Item.Deleting) then
  begin
    (actnList as TLicenseZoneFrameActionList).LicenseZone := TOldLicenseZone(Item.Data);
    if Assigned(FOnChangeItem) then FOnChangeItem(TObject(Item.Data));
  end;
end;

procedure TfrmLicenseZoneList.cmbxLicenseZoneTypeChange(Sender: TObject);
var sFilter, sAddedFilter, sLastFilter, sOrder: string;
    iPos: integer;
begin
  sFilter := (actnList as TLicenseZoneFrameActionList).Filter;
  sLastFilter := sFilter;
  sAddedFilter := TAdditionalFilter(cmbxLicenseZoneType.Items.Objects[cmbxLicenseZoneType.ItemIndex]).Query;


  if (trim(sFilter) <> '') and (trim(sAddedFilter) <> '') then
  if pos('order by', sFilter) = 0 then
     sFilter := sFilter + ' and ' + '(' + sAddedFilter + ')'
  else
  begin
    iPos := pos('order by', sFilter) ;
    sOrder := trim(Copy(sFilter, iPos, Length(sFilter)));
    sFilter := Copy(sFilter, 1, iPos - 1);

    sFilter := sFilter +  ' and ' + '(' + sAddedFilter + ')';
    sFilter := sFilter +  ' ' + sOrder;


  end
  else if trim(sFilter) = '' then sFilter := sAddedFilter;

  DeselectAllAction.Execute;
  LicenseZoneLoadAction.Execute(sFilter);

  (actnList as TLicenseZoneFrameActionList).Filter := sLastFilter;
  cmbxLicenseType.ItemIndex := 0;

  if Assigned(FOnChangeItem) then FOnChangeItem(nil);
end;

procedure TfrmLicenseZoneList.cmbxLicenseTypeChange(Sender: TObject);
var sFilter, sAddedFilter, sLastFilter, sOrder: string;
    iPos: integer;
begin
  //cmbxLicenseType.Style := csOwnerDrawFixed;
  sFilter := (actnList as TLicenseZoneFrameActionList).Filter;
  sLastFilter := sFilter;
  sAddedFilter := TAdditionalFilter(cmbxLicenseType.Items.Objects[cmbxLicenseType.ItemIndex]).Query;



  if (trim(sFilter) <> '') and (trim(sAddedFilter) <> '') then
  if pos('order by', sFilter) = 0 then
     sFilter := sFilter + ' and ' + '(' + sAddedFilter + ')'
  else
  begin
    iPos := pos('order by', sFilter) ;
    sOrder := trim(Copy(sFilter, iPos, Length(sFilter)));
    sFilter := Copy(sFilter, 1, iPos - 1);

    sFilter := sFilter +  ' and ' + '(' + sAddedFilter + ')';
    sFilter := sFilter +  ' ' + sOrder;
  end
  else if trim(sFilter) = '' then sFilter := sAddedFilter;

  
  DeselectAllAction.Execute;
  LicenseZoneLoadAction.Execute(sFilter);

  (actnList as TLicenseZoneFrameActionList).Filter := sLastFilter;
  cmbxLicenseZoneType.ItemIndex := 0;

  if Assigned(FOnChangeItem) then FOnChangeItem(nil);
end;

{ TLicenseTypeAdditionalFilters }

constructor TLicenseTypeAdditionalFilters.Create;
begin
  inherited;
  Add('<нет>', '', 0);
  Add('НР (поисковые и разведочные работы на нефть, газ, конденсат)', 'LICENSE_TYPE_ID = 1', 0);
  Add('НЭ (эксплуатационные работы на нефть, газ, конденсат)', 'LICENSE_TYPE_ID = 2', 0);
  Add('НП (геологическое изучение)', 'LICENSE_TYPE_ID = 3', 0);
end;

{ TLicenseZoneTypeFilters }

constructor TLicenseZoneTypeFilters.Create;
begin
  inherited;
  Add('<нет>', '', 0);
  Add('действующий', 'LICENSE_ZONE_STATE_ID = 1', 0);
  Add('перспективный', 'LICENSE_ZONE_STATE_ID = 2', 0);
  Add('выведенный', 'LICENSE_ZONE_STATE_ID = 3', 0);  
end;

{ TLicenseZoneAddAction }

constructor TLicenseZoneAddAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Редактировать лицензионный участок';
  ImageIndex := 0;
end;

procedure TLicenseZoneAddAction.DoAfterExecute(ABaseObject: TBaseObject);
var lv: TListView;
    li: TListItem;
    lz: TOldLicenseZone;
begin
  lv := (ActionList.Owner as TfrmLicenseZoneList).lwLicenseZone;

  li := lv.Items.Add;

  lz := ABaseObject as TOldLicenseZone;

  li.Caption := lz.LicenseZoneName;
  li.SubItems.Add(lz.LicenseZoneNum);

  li.Data := ABaseObject;
end;

function TLicenseZoneAddAction.Execute: boolean;
begin
  Result := inherited Execute(nil);
end;


function TLicenseZoneAddAction.Update: boolean;
begin
  Result := inherited Update;
  Enabled := Result;
end;

{ TLicenseZoneEditAction }

constructor TLicenseZoneEditAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Visible := true;
  Caption := 'Редактировать лицензионный участок';
  ImageIndex := 2;
end;

procedure TLicenseZoneEditAction.DoAfterExecute(ABaseObject: TBaseObject);
var lv: TListView;
begin
  lv := (ActionList.Owner as TfrmLicenseZoneList).lwLicenseZone;
  if TObject(lv.Selected.Data) is TOldLicenseZone then
  begin
    lv.Selected.SubItems.Clear;
    lv.Selected.Caption := (ABaseObject as TOldLicenseZone).LicenseZoneName;
    lv.Selected.SubItems.Add((TObject(lv.Selected.Data) as TOldLicenseZone).LicenseZoneNum);
    lv.Selected.SubItems.Add((TObject(lv.Selected.Data) as TOldLicenseZone).License.LicenseTypeShortName);
    lv.Selected.ImageIndex := (TObject(lv.Selected.Data) as TOldLicenseZone).LicenseZoneStateID + 1;
    lv.Selected.MakeVisible(false);
  end;
end;

function TLicenseZoneEditAction.Execute: boolean;
begin
  if Assigned((ActionList as TLicenseZoneFrameActionList).LicenseZone) then
    Result := Execute((ActionList as TLicenseZoneFrameActionList).LicenseZone)
  else Result := false;
end;

function TLicenseZoneEditAction.Execute(ABaseObject: TBaseObject): boolean;
var actn: TLicenseZoneBaseSaveAction;
    qResult: integer;
begin
  Result := true;
  if not Assigned(frmLicenseZoneInfo) then frmLicenseZoneInfo := TfrmLicenseZoneInfo.Create(Self);
  frmLicenseZoneInfo.EditingObject := ABaseObject;
  frmLicenseZoneInfo.dlg.ActiveFrameIndex := 0;

  if Assigned(ABaseObject)
  and ((ABaseObject as TOldLicenseZone).LicenseZoneStateID = 2) then
    qResult := Application.MessageBox(PChar('Вы действительно хотите перевести участок из перспективных в действующие?'),
                                      PChar('Вопрос'),
                                      MB_YESNO)
  else
    qResult := ID_YES;


   if (qResult = ID_Yes) and (frmLicenseZoneInfo.ShowModal = mrOK) then
   begin
     frmLicenseZoneInfo.Save;



     ABaseObject := (frmLicenseZoneInfo.Dlg.Frames[0] as TbaseFrame).EditingObject;
     actn := TLicenseZoneBaseSaveAction.Create(nil);
     actn.Execute(ABaseObject);


     actn.Free;
     // обновляем представление
     DoAfterExecute(ABaseObject);
   end;
end;

function TLicenseZoneEditAction.Update: boolean;
var lv: TListView;
begin
  inherited Update;
  lv := (ActionList.Owner as TfrmLicenseZoneList).lwLicenseZone;
  Result :=  (Assigned(lv.Selected)
         and (TObject(lv.Selected.Data) is TOldLicenseZone));


  Enabled := Result;
end;

{ TLicenseZoneDeleteAction }

constructor TLicenseZoneDeleteAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Удалить лицензионный участок';
  ImageIndex := 4;
end;

function TLicenseZoneDeleteAction.Execute: boolean;
begin
  Result := Execute((ActionList as TLicenseZoneFrameActionList).LicenseZone)
end;

function TLicenseZoneDeleteAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  Result := true;
  if MessageBox(0, PChar('Вы действительно хотите удалить лицензионный участок ' +  #13#10 +
                         ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false) + '?'), 'Вопрос',
                         MB_YESNO+MB_APPLMODAL+MB_DEFBUTTON2+MB_ICONQUESTION) = ID_YES then
  begin
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TLicenseZoneDataPoster];
    dp.DeleteFromDB(ABaseObject);
    (actionList as TLicenseZoneFrameActionList).LicenseZone := nil; 
    (ActionList.Owner as TfrmLicenseZoneList).lwLicenseZone.Selected.Delete;
  end;
end;

function TLicenseZoneDeleteAction.Update: boolean;
var lv: TListView;
begin
  inherited Update;
  lv := (ActionList.Owner as TfrmLicenseZoneList).lwLicenseZone;
  Result :=  Assigned(lv.Selected) and (TObject(lv.Selected.Data) is TOldLicenseZone);
  Enabled := Result;
end;

{ TBasicLicenseZoneAddAction }

constructor TBasicLicenseZoneAddAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Visible := true;
  Caption := 'Добавить перспективный лицензионный участок';
  ImageIndex := 1;
end;

procedure TBasicLicenseZoneAddAction.DoAfterExecute(
  ABaseObject: TBaseObject);
var lv: TListView;
    li: TListItem;
begin
  lv := (ActionList.Owner as TfrmLicenseZoneList).lwLicenseZone;

  if (not Assigned(lv.Selected))
  or ((TObject(lv.Selected.Data) is TOldLicenseZone) and
      ((TBaseObject(lv.Selected.Data) as TOldLicenseZone).ID <> ABaseObject.ID)) then
  begin
    li := lv.Items.Add;
    li.Selected := true;
    li.Data := ABaseObject;
    li.MakeVisible(false);
  end;

  if  (TObject(lv.Selected.Data) is TOldLicenseZone) then
  begin
    lv.Selected.SubItems.Clear;
    lv.Selected.Caption := (ABaseObject as TOldLicenseZone).LicenseZoneName;
    lv.Selected.SubItems.Add((TObject(lv.Selected.Data) as TOldLicenseZone).LicenseZoneNum);
  end;
end;

function TBasicLicenseZoneAddAction.Execute: boolean;
begin
  Result := inherited Execute(nil);
end;

function TBasicLicenseZoneAddAction.Update: boolean;
begin
  Result := inherited Update;
  Enabled := Result;
end;

{ TBasicLicenseZoneEditAction }

constructor TBasicLicenseZoneEditAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Visible := true;
  Caption := 'Редактировать перспективный лицензионный участок';
  ImageIndex := 3;
end;

procedure TBasicLicenseZoneEditAction.DoAfterExecute(
  ABaseObject: TBaseObject);
var lv: TListView;
begin
  lv := (ActionList.Owner as TfrmLicenseZoneList).lwLicenseZone;
  if TObject(lv.Selected.Data) is TOldLicenseZone then
  begin
    lv.Selected.SubItems.Clear;
    lv.Selected.Caption := (ABaseObject as TOldLicenseZone).LicenseZoneName;
    lv.Selected.SubItems.Add((TObject(lv.Selected.Data) as TOldLicenseZone).LicenseZoneNum);
    lv.Selected.MakeVisible(false);
  end;
end;

function TBasicLicenseZoneEditAction.Execute(
  ABaseObject: TBaseObject): boolean;
var actn: TLicenseZoneBaseSaveAction;
begin
  Result := true;
  if not Assigned(frmBasicLicenseZone) then frmBasicLicenseZone := TfrmBasicLicenseZone.Create(Self);
  frmBasicLicenseZone.EditingObject := ABaseObject;
  frmBasicLicenseZone.dlg.ActiveFrameIndex := 0;
  if frmBasicLicenseZone.ShowModal = mrOK then
  begin
    frmBasicLicenseZone.Save;



    ABaseObject := (frmBasicLicenseZone.Dlg.Frames[0] as TbaseFrame).EditingObject;
    actn := TLicenseZoneBaseSaveAction.Create(nil);
    actn.Execute(ABaseObject);


    actn.Free;
    // обновляем представление
    DoAfterExecute(ABaseObject);
  end;
end;

function TBasicLicenseZoneEditAction.Execute: boolean;
begin
  if Assigned((ActionList as TLicenseZoneFrameActionList).LicenseZone) then
    Result := Execute((ActionList as TLicenseZoneFrameActionList).LicenseZone)
  else Result := false;
end;

function TBasicLicenseZoneEditAction.Update: boolean;
var lv: TListView;
begin
  inherited Update;
  lv := (ActionList.Owner as TfrmLicenseZoneList).lwLicenseZone;
  Result :=  (Assigned(lv.Selected)
         and (TObject(lv.Selected.Data) is TOldLicenseZone)
// редактируем редактором перспективных участков только перспективные  
         and (TOldLicenseZone(lv.Selected.Data).LicenseZoneStateID = 2));


  Enabled := Result;
end;

{ TFilterList }

constructor TFilterList.Create;
begin
  Add('vch_License_Zone_Name');
  Add('vch_License_Num');
  Add('vch_lic_type_short_name');
  Add('vch_org_full_name');
end;

procedure TfrmLicenseZoneList.lwLicenseZoneDblClick(Sender: TObject);
begin
  if Assigned(ActiveLivenseZone) then
  if ActiveLivenseZone.LicenseZoneStateID = 1 then actnList.ActionByClassType[TLicenseZoneEditAction].Execute
  else actnList.ActionByClassType[TBasicLicenseZoneEditAction].Execute;
end;

procedure TfrmLicenseZoneList.lwLicenseZoneAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin

  if not Item.Deleting then
  case TOldLicenseZone(Item.Data).License.LicenseTypeID of
  1: lwLicenseZone.Canvas.Font.Color := clBlack;
  2: lwLicenseZone.Canvas.Font.Color := clPurple;
  3: lwLicenseZone.Canvas.Font.Color := clGreen;
  end;
end;

procedure TfrmLicenseZoneList.cmbxLicenseTypeDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  if cmbxLicenseType.ItemIndex > -1 then
  begin
    case Index of
    1: cmbxLicenseType.Canvas.Font.Color := clBlack;//cmbxLicenseType.Canvas.Brush.Color := clBlack; //
    2: cmbxLicenseType.Canvas.Font.Color := clPurple;//cmbxLicenseType.Canvas.Brush.Color := clPurple;//
    3: cmbxLicenseType.Canvas.Font.Color := clGreen;//cmbxLicenseType.Canvas.Brush.Color := clGreen;//
    end;
    //cmbxLicenseType.Canvas.Brush.Color := clWhite;
    //cmbxLicenseType.Canvas.FillRect(Rect);
    cmbxLicenseType.Canvas.TextOut(Rect.Left + 1, Rect.Top + 1, cmbxLicenseType.Items[cmbxLicenseType.ItemIndex]);
  end;
end;

procedure TfrmLicenseZoneList.cmbxLicenseTypeDropDown(Sender: TObject);
var i: integer;
begin
  //cmbxLicenseType.Style := csDropDownList;
  { TODO : Криво отрисовывается - не обновляется при выпадении }
{  for i := 0 to cmbxLicenseType.Items.Count - 1 do
  begin
    cmbxLicenseType.ItemIndex := i;
    cmbxLicenseTypeDrawItem(cmbxLicenseType, i,
                            Rect(0, 0, cmbxLicenseType.Width, cmbxLicenseType.ItemHeight * (i + 1)),
                            [odSelected]);
  end;}

end;


{ TLicenseZoneChangeStateAction }

constructor TLicenseZoneChangeStateAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Visible := true;
  Caption := 'Сменить статус лицензионного участка';
  ImageIndex := 5;
end;


function TLicenseZoneChangeStateAction.Execute(
  ABaseObject: TBaseObject): boolean;
var actn: TBaseAction;
begin
  Result := true;
  if not Assigned(frmChangeState) then frmChangeState := TfrmChangeState.Create(Self);
  frmChangeState.EditingObject := ABaseObject;
  frmChangeState.dlg.ActiveFrameIndex := 0;

  if (frmChangeState.ShowModal = mrOK) then
  begin
    frmChangeState.Save;

    ABaseObject := (frmChangeState.Dlg.Frames[0] as TbaseFrame).EditingObject;
    actn := TLicenseZoneBaseSaveAction.Create(nil);
    actn.Execute(ABaseObject);


    actn.Free;
    // обновляем представление
    DoAfterExecute(ABaseObject);
  end;
end;

{ TLicenseKindShowDictAction }

constructor TLicenseKindShowDictAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Справочник видов условий лицензионного соглашения';
  ImageIndex := 6;
end;

function TLicenseKindShowDictAction.Execute: boolean;
begin
  Result := Execute(nil);
end;

function TLicenseKindShowDictAction.Execute(
  ABaseObject: TBaseObject): boolean;
begin
  if not Assigned(frmIDObjectList) then frmIDObjectList := TfrmIDObjectList.Create(Self);
  frmIDObjectList.IDObjects := (TMainFacade.GetInstance as TMainFacade).AllLicenseConditionKinds;
  frmIDObjectList.Caption := 'Вид условия лицензионного соглашения';

  frmIDObjectList.AddActionClass := TIDObjectAddAction;
  frmIDObjectList.EditActionClass := TIDObjectEditAction;
  frmIDObjectList.ShowShortName := false;

  frmIDObjectList.ShowModal;
end;

function TLicenseKindShowDictAction.Update: boolean;
begin
  Result := true;
end;

{ TLicenseConditionTypeShowDictAction }

constructor TLicenseConditionTypeShowDictAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Справочник видов условий лицензионного соглашения';
  ImageIndex := 6;
end;

function TLicenseConditionTypeShowDictAction.Execute: boolean;
begin
  Result := Execute(nil);
end;

function TLicenseConditionTypeShowDictAction.Execute(
  ABaseObject: TBaseObject): boolean;
begin
  if not Assigned(frmIDObjectList) then frmIDObjectList := TfrmIDObjectList.Create(Self);
  frmIDObjectList.IDObjects := (TMainFacade.GetInstance as TMainFacade).AllLicenseConditionTypes;
  frmIDObjectList.Caption := 'Тип условия лицензионного соглашения';

  frmIDObjectList.AddActionClass := TLicenseConditionTypeAddAction;
  frmIDObjectList.EditActionClass := TLicenseConditionTypeEditAction;
  frmIDObjectList.ShowShortName := false;

  frmIDObjectList.ShowModal;
end;

function TLicenseConditionTypeShowDictAction.Update: boolean;
begin
  Result := true;
end;

{ TLicenseConditionKindEditAction }

constructor TLicenseConditionTypeEditAction.Create(AOwner: TComponent);
begin
  inherited;
  frmIDObjectEditClass := TfrmLicenseConditionTypeEdit;
end;

{ TLicenseConditionKindAddAction }

constructor TLicenseConditionTypeAddAction.Create(AOwner: TComponent);
begin
  inherited;
  frmIDObjectEditClass := TfrmLicenseConditionTypeEdit;
end;

end.
