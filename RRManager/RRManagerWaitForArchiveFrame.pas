unit RRManagerWaitForArchiveFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBaseGUI, RRManagerObjects, RRManagerBaseObjects,
  StdCtrls, ComCtrls, Gauges, RRManagerLoaderCommands;

type
//  TfrmWaitForArchive = class(TFrame)
  TfrmWaitForArchive = class(TBaseFrame)
    gbxWaitForArchive: TGroupBox;
    ggStructure: TGauge;
    mmStructuresState: TRichEdit;
    lblStructure: TLabel;
    Label2: TLabel;
    prgStructure: TProgressBar;
  private
    { Private declarations }
    FArchivingStructures: TOldStructures;
    FStructureLoadAction: TStructureBaseLoadAction;
    function  GetVersion: TOldVersion;
    procedure DoPercentProgress(Sender: TObject);
    procedure DoProgress(Sender: TObject);
    procedure DoGaugeProgress(Sender: TObject);
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
  public
    { Public declarations }
    property    Version: TOldVersion read GetVersion;
    procedure   Save; override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses RRManagerCommon, RRManagerEditCommands, Facade;

{$R *.dfm}

type
  TArchivingStructureLoadAction = class(TStructureBaseLoadAction)
  private
    FOnProgress: TNotifyEvent;
    FSubObjectsCountList: TList;
    FOnSubprogress: TNotifyEvent;
  public
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    property OnSubprogress: TNotifyEvent read FOnSubprogress write FOnSubprogress;
    function Execute(AFilter: string): boolean; override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TArchivingStructurePreEditAction = class(TStructureBasePreEditAction)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TArchivingHorizonLoadAction = class(THorizonBaseLoadAction)
  private
    FOnProgress: TNotifyEvent;
  public
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TArchivingSubstructureLoadAction = class(TSubstructureBaseLoadAction)
  private
    FOnProgress: TNotifyEvent;
  public
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TArchivingLayerLoadAction = class(TLayerBaseLoadAction)
  private
    FOnProgress: TNotifyEvent;
  public
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TArchivingBedLoadAction = class(TBedBaseLoadAction)
  private
    FOnProgress: TNotifyEvent;
  public
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TArchivingBedLayerLoadAction = class(TBedLayerBaseLoadAction)
  private
    FOnProgress: TNotifyEvent;
  public
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TArchivingPropertiesLoadAction = class(TVersionBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TArchivingVersionSaveAction = class(TVersionBaseSaveAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TArchivingStructureSaveAction = class(TStructureBaseSaveAction)
  private
    FOnProgress: TNotifyEvent;
  public
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TArchivingHorizonSaveAction = class(THorizonBaseSaveAction)
  private
    FOnProgress: TNotifyEvent;
  public
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TArchivingSubstructureSaveAction = class(TSubstructureBaseSaveAction)
  private
    FOnProgress: TNotifyEvent;
  public
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TArchivingLayerSaveAction = class(TLayerBaseSaveAction)
  private
    FOnProgress: TNotifyEvent;
  public
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TArchivingBedSaveAction = class(TBedBaseSaveAction)
  private
    FOnProgress: TNotifyEvent;
  public
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;



  const sSuccess: string = 'Успешно';
        sUnSuccess: string = 'Неудачно';


procedure ReportStatus(AControl: TRichEdit; S: string; State: boolean; AColor: TColor);
var iLen: integer;
    sState: string;
    StateColor: TColor;
    StateStyles: TFontStyles;
begin
  iLen := Length(AControl.Text);
  if State then
  begin
    sState := '[' + DateTimeToStr(Now) + ']' + S + '...' + sSuccess;
    StateColor := AColor;
    AControl.Lines.AddObject(sState, TObject(1));
    StateStyles := [];
  end
  else
  begin
    sState := '[' + DateTimeToStr(Now) + ']' +S + '...' + sUnSuccess;
    StateColor := AColor;
    AControl.Lines.AddObject(sState, nil);
    StateStyles := [fsBold];
  end;


  AControl.SelStart := iLen;
  AControl.SelLength := Length(sState);
  AControl.SelAttributes.Color := StateColor;
  AControl.SelAttributes.Style := StateStyles;
end;




{ TfrmWaitForArchive }

procedure TfrmWaitForArchive.ClearControls;
begin
  FArchivingStructures.Clear;

  prgStructure.Min := 0;
  prgStructure.Max := 200;
  prgStructure.Position := 0;

  ggStructure.MinValue := 0;
  ggStructure.MaxValue := 100;
  ggStructure.Progress := 0;

//  mmStructuresState.Clear;

end;

constructor TfrmWaitForArchive.Create(AOwner: TComponent);
begin
  inherited;
  NeedCopyState := true;

  FArchivingStructures := TOldStructures.Create(nil);
  FStructureLoadAction := TArchivingStructureLoadAction.Create(Self);
  FStructureLoadAction.LastCollection := FArchivingStructures;

end;

destructor TfrmWaitForArchive.Destroy;
begin
  FArchivingStructures.Free;
  inherited;
end;

procedure TfrmWaitForArchive.DoGaugeProgress(Sender: TObject);
begin
  ggStructure.AddProgress(1);

  if ggStructure.Progress = ggStructure.MaxValue then ggStructure.Progress := 0; 
end;

procedure TfrmWaitForArchive.DoPercentProgress(Sender: TObject);
begin
  prgStructure.StepBy(Round((prgStructure.Max - prgStructure.Min)/FArchivingStructures.Count));
  Update;
end;

procedure TfrmWaitForArchive.DoProgress(Sender: TObject);
begin
  prgStructure.StepIt;
  Update;  
end;

procedure TfrmWaitForArchive.FillControls(ABaseObject: TBaseObject);
begin
  inherited;

end;

procedure TfrmWaitForArchive.FillParentControls;
begin
  inherited;

end;

function TfrmWaitForArchive.GetVersion: TOldVersion;
begin
  Result := EditingObject as TOldVersion;
end;

procedure TfrmWaitForArchive.Save;
var i: integer;
    actn: TArchivingStructureSaveAction;
    actnLoad: TArchivingStructureLoadAction;
    actnSaveVersion: TArchivingVersionSaveAction;
begin
  inherited;
  mmStructuresState.Clear;

  if not Assigned(EditingObject) then
    // если что берем последнюю добавленную версию
    FEditingObject := (TMainFacade.GetInstance as TMainFacade).AllVersions.Items[(TMainFacade.GetInstance as TMainFacade).AllVersions.Count - 1];

  lblStructure.Caption := 'Сохраняем версию';

  // сохраняем версию
  actnSaveVersion := TArchivingVersionSaveAction.Create(Self);
  actnSaveVersion.Execute(FEditingObject);
  actnSaveVersion.Free;


  lblStructure.Caption := 'Загружаем структуры для сохранения';
  // грузим структуры
  prgStructure.Min := 0;
  prgStructure.Max := 1000;
  ggStructure.MinValue := 0;
  ggStructure.MaxValue := 4;

  actnLoad := (FStructureLoadAction as TArchivingStructureLoadAction);
  actnLoad.OnProgress := DoPercentProgress;
  actnLoad.OnSubprogress := DoGaugeProgress;

  FStructureLoadAction.LastCollection := FArchivingStructures;
  if FStructureLoadAction.Execute('Structure_ID > 0 and Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID)) then
  begin
    lblStructure.Caption := 'Начинаем сохранение структур';
    // делаем активным новй архив
    //(TMainFacade.GetInstance as TMainFacade).ActiveVersion := Version;
    // параметризуем прогресс
    prgStructure.Min := 0;
    prgStructure.Max := FArchivingStructures.Count;
    // проходим циклом по всем загруженным структурам
    actn := TArchivingStructureSaveAction.Create(Self);
    actn.OnProgress := DoGaugeProgress;
    for i := 0 to FArchivingStructures.Count - 1 do
//    for i := 0 to 25 do
    begin
      ggStructure.MinValue := 0;
      ggStructure.MaxValue := Integer(actnLoad.FSubObjectsCountList.Items[i]);
      ggStructure.Progress := 0;

      lblStructure.Caption := 'Сохраняем структуру ' + FArchivingStructures.Items[i].List(AllOpts.Current.ListOption, false, false);

      DoProgress(Self);
      actn.Execute(FArchivingStructures.Items[i]);
    end;
    actn.Free;

    ggStructure.Progress := ggStructure.MaxValue;
    lblStructure.Caption := 'Сохранение структур завершено. Повторное нажатие кнопки "Готово" приведёт к пересохранению структур в эту же версию архива. Если хотите новую версию - закончите этот сеанс архивирования (кнопка "Закрыть") и начните новый.';
  end;
end;

{ TArchivingStructureLoadAction }

constructor TArchivingStructureLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Загрузить структуры';
  FSubObjectsCountList := TList.Create;
  DestroyCollection := false;
end;

destructor TArchivingStructureLoadAction.Destroy;
begin
  FSubObjectsCountList.Free;
  inherited;
end;

function TArchivingStructureLoadAction.Execute(AFilter: string): boolean;
var i: integer;
    actn: TArchivingHorizonLoadAction;
    actnPreEdit: TStructureBasePreEditAction;
    actnProperties: TArchivingPropertiesLoadAction;
    actnDrilledWells: TDrilledStructureWellsBaseLoadAction;
    actnHistory: TStructureHistoryBaseLoadAction;
    actnBed: TArchivingBedLoadAction;
    s: TOLdStructure;
    LastAction: TBaseAction;
    LastUsedObject: TBaseObject;
begin
  Result := true;
  try
    LastAction := Self;
    LastUsedObject := nil;
    Result := inherited Execute(AFilter);
    ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, Caption, true, clGray);

    actn := TArchivingHorizonLoadAction.Create(Owner);
    actnPreEdit := TArchivingStructurePreEditAction.Create(Owner);
    actnProperties := TArchivingPropertiesLoadAction.Create(Owner);
    actnDrilledWells := TDrilledStructureWellsBaseLoadAction.Create(Owner);
    actnHistory := TStructureHistoryBaseLoadAction.Create(Owner);
    actnBed := TArchivingBedLoadAction.Create(Owner);


    for i := 0 to LastCollection.Count - 1 do
//    for i := 0 to 25 do
    begin
      s := LastCollection.Items[i] as TOLdStructure;

      LastAction := actnPreEdit;
      LastUsedObject := S;
      actnPreEdit.Execute(s);
      ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, LastAction.Caption + '(' + LastUsedObject.List(AllOpts.Current.ListOption, true, true) + ')', true, clGray);
      if Assigned(FOnSubprogress) then FOnSubprogress(Self);

      LastAction := actn;
      LastUsedObject := S;
      actn.LastCollection := s.Horizons;
      actn.Execute(s);
      ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, LastAction.Caption + '(' + LastUsedObject.List(AllOpts.Current.ListOption, true, true) + ')', true, clGray);
      if Assigned(FOnSubprogress) then FOnSubprogress(Self);

      LastAction := actnProperties;
      LastUsedObject := S;
      actnProperties.LastCollection := s.Versions;
      actnProperties.Execute(s);
      ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, LastAction.Caption + '(' + LastUsedObject.List(AllOpts.Current.ListOption, true, true) + ')', true, clGray);
      if Assigned(FOnSubprogress) then FOnSubprogress(Self);

      if s is TOldDrilledStructure then
      begin
        LastAction := actnDrilledWells;
        LastUsedObject := S;
        actnDrilledWells.LastCollection := (s as TOldDrilledStructure).Wells;
        actnDrilledWells.Execute(s);
        ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, LastAction.Caption + '(' + LastUsedObject.List(AllOpts.Current.ListOption, true, true) + ')', true, clGray);
      end
      else if s is TOldField then
      begin
        LastAction := actnBed;
        LastUsedObject := S;
        actnBed.LastCollection := (s as TOldField).Beds;
        actnBed.Execute(s);
        ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, LastAction.Caption + '(' + LastUsedObject.List(AllOpts.Current.ListOption, true, true) + ')', true, clGray);
      end;

      LastAction := actnHistory;
      LastUsedObject := S;
      actnHistory.LastCollection := s.History;
      actnHistory.Execute(s);
      ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, LastAction.Caption + '(' + LastUsedObject.List(AllOpts.Current.ListOption, true, true) + ')', true, clGray);
      if Assigned(FOnSubprogress) then FOnSubprogress(Self);

      if Assigned(FOnProgress) then FOnProgress(Self);

      FSubObjectsCountList.Add(Pointer(s.SubObjectsCount));
    end;

    actnPreEdit.Free;
    actn.Free;
    actnProperties.Free;
    actnDrilledWells.Free;
    actnBed.Free;
  except
    Result := false;
    if Assigned(LastUsedObject) then
      ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, LastAction.Caption + '(' + LastUsedObject.List(AllOpts.Current.ListOption, true, true) + ')', false, clRed)
    else
      ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, LastAction.Caption, false, clRed)
  end;
end;

{ TArchivingPropertiesByVersionLoadAction }

constructor TArchivingPropertiesLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
  Caption := 'Загрузить свойства структуры';
end;

function TArchivingPropertiesLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var v: TOldAccountVersion;
    i: integer;
    actnParams, actnResources, actnReserves, actnDocs: TBaseAction;
begin
  Result := inherited Execute(ABaseObject);

  actnParams := TParamByVersionBaseLoadAction.Create(nil);
  actnResources := TResourceByVersionBaseLoadAction.Create(nil);
  actnReserves := TReserveByVersionBaseLoadAction.Create(nil);
  actnDocs := TDocumentByVersionBaseLoadAction.Create(nil);


  for i := 0 to LastCollection.Count - 1 do
  begin
    v := LastCollection.Items[i] as TOldAccountVersion;

    actnParams.LastCollection := v.Parameters;
    actnParams.Execute(v);

    actnDocs.LastCollection := v.Documents;
    actnDocs.Execute(v);

    if ABaseObject is TOldLayer then
    begin
      actnResources.LastCollection := v.Resources;
      actnResources.Execute(v);

      actnReserves.LastCollection := v.Reserves;
      actnReserves.Execute(v);
    end;
  end;

  actnParams.Free;
  actnResources.Free;
  actnReserves.Free;
  actnDocs.Free;

end;



{ TArchivingHorizonLoadAction }

constructor TArchivingHorizonLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
  Caption := 'Загрузить состав структуры'
end;


function TArchivingHorizonLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var i: integer;
    actn: TArchivingSubstructureLoadAction;
    actnProperties: TArchivingPropertiesLoadAction;
    h: TOldHorizon;
begin
  Result := inherited Execute(ABaseObject);
  actn := TArchivingSubstructureLoadAction.Create(nil);
  actnProperties := TArchivingPropertiesLoadAction.Create(nil);

  for i := 0 to LastCollection.Count - 1 do
  begin
    h := LastCollection.Items[i] as TOldHorizon;

    actn.LastCollection := h.Substructures;
    actn.Execute(h);

    actnProperties.LastCollection := h.Versions;
    actnProperties.Execute(h);
    if Assigned(FOnProgress) then FOnProgress(Self);
  end;

  actn.Free;
  actnProperties.Free;
end;

{ TArchivingSubstructureLoadAction }

constructor TArchivingSubstructureLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
end;


function TArchivingSubstructureLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var i: integer;
    actn: TArchivingLayerLoadAction;
    actnProperties: TArchivingPropertiesLoadAction;
    s: TOldSubstructure;
begin
  Result := inherited Execute(ABaseObject);
  actn := TArchivingLayerLoadAction.Create(nil);
  actnProperties := TArchivingPropertiesLoadAction.Create(nil);

  for i := 0 to LastCollection.Count - 1 do
  begin
    s := LastCollection.Items[i] as TOldSubstructure;

    actn.LastCollection := s.Layers;
    actn.Execute(s);

    actnProperties.LastCollection := s.Versions;
    actnProperties.Execute(s);
    if Assigned(FOnProgress) then FOnProgress(Self);
  end;

  actn.Free;
  actnProperties.Free;
end;

{ TArchivingLayerLoadAction }

constructor TArchivingLayerLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
end;


function TArchivingLayerLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var i: integer;
    actnProperties: TArchivingPropertiesLoadAction;
    l: TOldLayer;
begin
  Result := inherited Execute(ABaseObject);
  actnProperties := TArchivingPropertiesLoadAction.Create(nil);

  for i := 0 to LastCollection.Count - 1 do
  begin
    l := LastCollection.Items[i] as TOldLayer;
    actnProperties.LastCollection := l.Versions;
    actnProperties.Execute(l);
    if Assigned(FOnProgress) then FOnProgress(Self);
  end;

  actnProperties.Free;
end;

{ TArchivingBedLoadAction }

constructor TArchivingBedLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
  Caption := 'Загрузить состав месторождения';
end;


function TArchivingBedLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var i: integer;
    actn: TArchivingBedLayerLoadAction;
    actnProperties: TArchivingPropertiesLoadAction;
    b: TOldBed;
begin
  Result := inherited Execute(ABaseObject);
  actn := TArchivingBedLayerLoadAction.Create(nil);
  actnProperties := TArchivingPropertiesLoadAction.Create(nil);

  for i := 0 to LastCollection.Count - 1 do
  begin
    b := LastCollection.Items[i] as TOldBed;

    actn.LastCollection := b.Layers;
    actn.Execute(b);

    actnProperties.LastCollection := b.Versions;
    actnProperties.Execute(b);
    if Assigned(FOnProgress) then FOnProgress(Self);
  end;

  actn.Free;
  actnProperties.Free;
end;

{ TArchivingBedLayerLoadAction }

constructor TArchivingBedLayerLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
end;


{ TArchivingStructureEditAction }

constructor TArchivingStructureSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Сохранить структуру';
end;

function TArchivingStructureSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
var s: TOLdStructure;
    f: TOldField;
    i: integer;
    actn: TArchivingHorizonSaveAction;
    actnBed: TArchivingBedSaveAction;
begin
  try
    Result := inherited Execute(ABaseObject);
    ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, Self.Caption + '(' + ABaseObject.List(AllOpts.Current.ListOption, true, true) + ')', true, clGreen);

    actn := TArchivingHorizonSaveAction.Create(Owner);
    actn.OnProgress := OnProgress;
    if Result then
    begin
      s := ABaseObject as TOLdStructure;

      for i := 0 to s.Horizons.Count - 1 do
      begin
        actn.Execute(s.Horizons.Items[i]);
        if Assigned(FOnProgress) then FOnProgress(Self);
      end;

      if ABaseObject is TOldField then
      begin
        actnBed := TArchivingBedSaveAction.Create(Owner);
        actnBed.OnProgress := OnProgress;
        f := s as TOldField;
        for i := 0 to f.Beds.Count - 1 do
        begin
          actnBed.Execute(f.Beds.Items[i]);
          if Assigned(FOnProgress) then FOnProgress(Self);
        end;

        actnBed.Free;
      end;
    end;
    actn.Free;
  except
    ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, Self.Caption + '(' + ABaseObject.List(AllOpts.Current.ListOption, true, true) + ')', false, clRed);
  end;
end;

function TArchivingBedLayerLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var i: integer;
    actnProperties: TArchivingPropertiesLoadAction;
    l: TOldLayer;
begin
  Result := inherited Execute(ABaseObject);
  actnProperties := TArchivingPropertiesLoadAction.Create(nil);

  for i := 0 to LastCollection.Count - 1 do
  begin
    l := LastCollection.Items[i] as TOldLayer;
    actnProperties.LastCollection := l.Versions;
    actnProperties.Execute(l);
    if Assigned(FOnProgress) then FOnProgress(Self);
  end;

  actnProperties.Free;
end;

{ TArchivingHorizonSaveAction }

constructor TArchivingHorizonSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Сохранить горизонт';
end;

function TArchivingHorizonSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
var h: TOldHorizon;
    i: integer;
    actn: TArchivingSubstructureSaveAction;
begin
  try
    Result := inherited Execute(ABaseObject);
    ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, Self.Caption + '(' + ABaseObject.List(AllOpts.Current.ListOption, true, true) + ')', true, clGreen);
    actn := TArchivingSubstructureSaveAction.Create(Owner);
    actn.FOnProgress := OnProgress;
    if Result then
    begin
      h := ABaseObject as TOldHorizon;

      for i := 0 to h.Substructures.Count - 1 do
      begin
        actn.Execute(h.Substructures.Items[i]);
        if Assigned(FOnProgress) then FOnProgress(Self);
      end;
    end;
    actn.Free;
  except
    ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, Self.Caption + '(' + ABaseObject.List(AllOpts.Current.ListOption, true, true) + ')', false, clRed);
  end;
end;

{ TArchivingSubstructureSaveAction }

constructor TArchivingSubstructureSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Сохранить подструктуру';
end;

function TArchivingSubstructureSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
var s: TOldSubstructure;
    i: integer;
    actn: TArchivingLayerSaveAction;
begin
  try
    Result := inherited Execute(ABaseObject);
    ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, Self.Caption + '(' + ABaseObject.List(AllOpts.Current.ListOption, true, true) + ')', true, clGreen);

    actn := TArchivingLayerSaveAction.Create(Owner);
    actn.OnProgress := FOnProgress;
    if Result then
    begin
      s := ABaseObject as TOldSubstructure;

      for i := 0 to s.Layers.Count - 1 do
      begin
        actn.Execute(s.Layers.Items[i]);
        if Assigned(FOnProgress) then FOnProgress(Self);
      end;
    end;
    actn.Free;
  except
    ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, Self.Caption + '(' + ABaseObject.List(AllOpts.Current.ListOption, true, true) + ')', false, clRed);
  end;
end;

{ TArchivingLayerSaveAction }

constructor TArchivingLayerSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Сохранить продуктивный пласт';
end;

function TArchivingLayerSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
begin
  try
    Result := inherited Execute(ABaseObject);
    ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, Self.Caption + '(' + ABaseObject.List(AllOpts.Current.ListOption, true, true) + ')', true, clGreen);
  except
    ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, Self.Caption + '(' + ABaseObject.List(AllOpts.Current.ListOption, true, true) + ')', false, clRed);
  end;
end;

{ TArchivingBedSaveAction }

constructor TArchivingBedSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Сохранить залежь';
end;

function TArchivingBedSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
var b: TOldBed;
    i: integer;
    actn: TArchivingBedSaveAction;
begin
  try
    Result := inherited Execute(ABaseObject);
    ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, Self.Caption + '(' + ABaseObject.List(AllOpts.Current.ListOption, true, true) + ')', true, clGreen);

    actn := TArchivingBedSaveAction.Create(Owner);
    actn.OnProgress := FOnProgress;
    if Result then
    begin
      b := ABaseObject as TOldBed;

      for i := 0 to b.Layers.Count - 1 do
      begin
        actn.Execute(b.Layers.Items[i]);
        if Assigned(FOnProgress) then FOnProgress(Self);
      end;
    end;
    actn.Free;
  except
    ReportStatus((Owner as TfrmWaitForArchive).mmStructuresState, Self.Caption + '(' + ABaseObject.List(AllOpts.Current.ListOption, true, true) + ')', false, clRed);
  end;
end;

{ TArchivingVersionSaveAction }

function TArchivingVersionSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
begin
  Result := inherited  Execute(ABaseObject);
end;

{ TArchivingStructurePreEditAction }

constructor TArchivingStructurePreEditAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Загрузить свойства структуры, определяемые видом фонда';
end;

end.
