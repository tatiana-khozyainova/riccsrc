unit RRManagerLoaderCommands;

interface

uses Classes, RRManagerBaseObjects, RRManagerObjects, ClientCommon, ComCtrls,
     RRmanagerPersistentObjects, RRManagerDataPosters, SysUtils, RRManagerBaseGUI;

type
  EExecutionFailure = class(Exception)
    constructor Create(ACause: TBaseAction);
  end;

  TFundVersionBaseLoadAction = class(TbaseAction)
  private
    FLastFilter: string;
  public
    property LastFilter: string read FLastFilter write FLastFilter;
    function Execute(AFilter: string): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TStructureBaseLoadAction = class(TBaseAction)
  private
    FLastFilter: string;
  public
    property LastFilter: string read FLastFilter write FLastFilter;
    function Execute(AFilter: string): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TLicenseZoneBaseLoadAction = class(TBaseAction)
  private
    FLastFilter: string;
  public
    property LastFilter: string read FLastFilter write FLastFilter;
    function Execute(AFilter: string): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TStructureBasePreEditAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  THorizonBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TSubstructureBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TLayerBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TBedLayerBaseLoadAction = class(TbaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;


  TBedBaseLoadAction = class(TBaseAction)
  private
    FShowBalancedOnly: boolean;
  public
    property ShowBalancedOnly: boolean read FShowBalancedOnly write FShowBalancedOnly;
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TBedSubstructureBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TBedHorizonBaseLoadAction = class(TbaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;

  TBedHorizonSubstructureBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;



  TDrilledStructureWellsBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TResourcesBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TParameterBaseLoadAction = class(TbaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TVersionBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TResourceByVersionBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TReserveByVersionBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TFieldReserveByVersionBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TParamByVersionBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TDocumentByVersionBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TStructureHistoryBaseLoadAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TWellsBaseLoadAction = class(TBaseAction)
  public
    function Execute(ASQL: string): boolean; override;
  end;



implementation

uses RRManagerMainTreeFrame, RRManagerCommon, Facade, Dialogs;


{ TDrilledStructurePreEditAction }

constructor TDrilledStructureWellsBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Visible := false;
  DestroyCollection := false;
  Caption := 'Загрузить скважины по структуре';
end;

function TDrilledStructureWellsBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldDrilledStructure).Wells;
  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;

    Result := inherited Execute(ABaseObject);
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TDrilledStructureWellDataPoster];
    // инициализируем коллекцию
    dp.LastGotCollection := LastCollection;
    // берем данные
    LastCollection := dp.GetFromDB('Structure_ID = ' + IntToStr(ABaseObject.ID) + ' and ' + 'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID));

    // если ничего не выбрано
    // пробуем выбрать скважины по площади
    if LastCollection.Count = 0 then
    begin
      // берем постер
      dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TDrilledStructureAreaWellDataPoster];
      // инициализируем коллекцию
      dp.LastGotCollection := LastCollection;
      // берем данные
      LastCollection := dp.GetFromDB('Area_Id = ' + IntToStr((ABaseObject as TOldStructure).AreaID));
    end;
  end;
end;


{ TStructureBaseLoadAction }

constructor TStructureBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
end;

function TStructureBaseLoadAction.Execute(AFilter: string): boolean;
var dp: TDataPoster;
begin
  LastCollection.NeedsUpdate := false;
  Result := inherited Execute(AFilter);
  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TStructureDataPoster];
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  LastCollection := dp.GetFromDB(AFilter);
end;



{ THorizonBaseLoadAction }

function THorizonBaseLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
    i: integer;
    cl: TCollection;
begin
  // устанавливаем флаг "свежести" для коллекции
  LastCollection.NeedsUpdate := false;

  Result := inherited Execute(ABaseObject);

  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[THorizonDataPoster];
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  if ABaseObject is TOldStructure then
    LastCollection := dp.GetFromDB('Structure_ID = ' + IntToStr(ABaseObject.ID) + ' and ' + 'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID))
  else if ABaseObject is TOldHorizon then
    LastCollection := dp.GetFromDB(ABaseObject.ID);

  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[THorizonFundTypeDataPoster];
  for i := 0 to LastCollection.Count - 1 do
  begin
    dp.LastGotCollection := (LastCollection.Items[i] as TOldHorizon).FundTypes;
    dp.GetFromDB(LastCollection.Items[i].ID);
  end;
end;

{ TSubstructureLoadAction }

function TSubstructureBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  // устанавливаем флаг "свежести" для коллекции
  LastCollection.NeedsUpdate := false;

  Result := inherited Execute(ABaseObject);
  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TSubstructureDataPoster];
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  if ABaseObject is TOldHorizon then
    LastCollection := dp.GetFromDB('Structure_Stratum_ID = ' + IntToStr(ABaseObject.ID) + ' and ' + 'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID))
  else LastCollection := dp.GetFromDB(ABaseObject.ID);

end;

{ TResourcesBaseLoadAction }

constructor TResourcesBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Visible := false;
  DestroyCollection := false;
end;

function TResourcesBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  Result := false;
//  LastCollection := (ABaseObject as TOldSubstructure).Resources;
  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;


    Result := inherited Execute(ABaseObject);
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TResourceDataPoster];
    // инициализируем коллекцию
    dp.LastGotCollection := LastCollection;
    // берем данные
    LastCollection := dp.GetFromDB('Concrete_Layer_ID = ' + IntToStr((ABaseObject as TOldAccountVersion).Layer.ID)+ ' and ' +
                                   'Document_ID = ' + IntToStr(ABaseObject.ID)+ ' and ' +
                                   'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID));
  end;
end;

{ TParameterBaseLoadAction }

constructor TParameterBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Visible := false;
  DestroyCollection := false;
end;

function TParameterBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldSubstructure).Parameters;
  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;

    Result := inherited Execute(ABaseObject);
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TParameterDataPoster];
    // инициализируем коллекцию
    dp.LastGotCollection := LastCollection;
    // берем данные
    LastCollection := dp.GetFromDB('Substructure_ID = ' + IntToStr(ABaseObject.ID));
  end;
end;

{ TBedSubstructureBaseLoadAction }

function TBedSubstructureBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  // устанавливаем флаг "свежести" для коллекции
  LastCollection.NeedsUpdate := false;

  Result := inherited Execute(ABaseObject);
  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TSubstructureDataPoster];
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  if ABaseObject is TOldBed then
    LastCollection := dp.GetFromDB('(Substructure_ID in (Select Substructure_ID from tbl_Bed_Substructure where Bed_ID = ' + IntToStr(ABaseObject.ID) + '))')
  else raise EExecutionFailure.Create(Self);

end;

{ EExecutionFailure }

constructor EExecutionFailure.Create(ACause: TBaseAction);
begin
  inherited CreateFmt('Ошибка выполнения комманды %s', [ACause.ClassName]);
end;

{ TBedHorizonBaseLoadAction }

function TBedHorizonBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  // устанавливаем флаг "свежести" для коллекции
  LastCollection.NeedsUpdate := false;

  Result := inherited Execute(ABaseObject);
  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[THorizonDataPoster];
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  if ABaseObject is TOldBed then
    LastCollection := dp.GetFromDB('(Structure_Stratum_ID in (Select Structure_Stratum_ID from tbl_Bed_Stratum_Set where Bed_ID = ' + IntToStr(ABaseObject.ID) + '))')
  else raise EExecutionFailure.Create(Self);

end;

{ TBedBaseLoadAction }

function TBedBaseLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
    sFilter: string;
begin
  // устанавливаем флаг "свежести" для коллекции
  LastCollection.NeedsUpdate := false;

  Result := inherited Execute(ABaseObject);
  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TBedDataPoster];
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  if ABaseObject is TOldStructure then
  begin
    sFilter := 'Structure_ID = ' + IntToStr(ABaseObject.ID) + ' and ' + 'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID);
    if ShowBalancedOnly then
      sFilter := sFilter + ' and (NUM_BALANCED > 0)';
    LastCollection := dp.GetFromDB(sFilter)
  end
  else LastCollection := dp.GetFromDB(ABaseObject.ID);

end;

{ TBedHorizonSubstructureLoadAction }

function TBedHorizonSubstructureBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  // устанавливаем флаг "свежести" для коллекции
  LastCollection.NeedsUpdate := false;

  Result := inherited Execute(ABaseObject);
  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TSubstructureDataPoster];
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  if ABaseObject is TOldBed then
    LastCollection := dp.GetFromDB('(Substructure_ID in (Select Substructure_ID ' +
                                   'from tbl_Bed_Substructure bs, tbl_Bed_Horizon bh ' +
                                   'where bs.Bed_ID = bh.Bed_ID and bh.Horizon_ID = ' + IntToStr(ABaseObject.ID) + ' ' +
                                   '))')
  else raise EExecutionFailure.Create(Self);

end;

{ TLayerBaseLoadAction }

function TLayerBaseLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  // устанавливаем флаг "свежести" для коллекции
  LastCollection.NeedsUpdate := false;

  Result := inherited Execute(ABaseObject);
  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TLayerDataPoster];
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  if not(ABaseObject is TOldLayer) then
    LastCollection := dp.GetFromDB('Substructure_ID = ' + IntToStr(ABaseObject.ID) + ' and ' + 'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID))
  else LastCollection := dp.GetFromDB(ABaseObject.ID);

end;

{ TBedLayerBaseLoadAction }

function TBedLayerBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  // устанавливаем флаг "свежести" для коллекции
  LastCollection.NeedsUpdate := false;

  Result := inherited Execute(ABaseObject);
  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TLayerDataPoster];
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  if ABaseObject is TOldBed then
    LastCollection := dp.GetFromDB('Bed_ID = ' + IntToStr(ABaseObject.ID) + ' and ' + 'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID))
  else LastCollection := dp.GetFromDB(ABaseObject.ID);

end;

{ TVersionBaseLoadAction }

constructor TVersionBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  DestroyCollection := false;
  Visible := false;
end;

function TVersionBaseLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
    iUIN: integer;
    b: TBaseObject;
begin
  Result := true;
  if LastCollection.NeedsUpdate
  and Assigned(ABaseObject) then
  begin
    LastCollection.NeedsUpdate := false;

    Result := inherited Execute(ABaseObject);
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TAccountVersionDataPoster];
    // инициализируем коллекцию
    dp.LastGotCollection := LastCollection;
    // ABaseObject - может быть любой объект
    // поэтому сначала выясняем какой
    // и получаем идентификатор структуры, для которой спрашиваются подсчетные документы
    if Assigned(ABaseObject.Collection) then
      b := (ABaseObject.Collection as TBaseCollection).Owner
    else b := nil;

    iUIN := 0;
    if b is TOldSubstructure then
      iUIN := (((b as TOldSubstructure).Collection as TBaseCollection).Owner.Collection as TBaseCollection).Owner.ID
    else if (b is TOldHorizon) then
      iUIN := ((b as TOldHorizon).Collection as TBaseCollection).Owner.ID
    else if (b is TOldBed) then
      iUIN := ((b as TOldBed).Collection as TBaseCollection).Owner.ID
    else if b is TOldStructure then
      iUIN := b.ID
    else if not Assigned(b) then
      iUIN := AbaseObject.ID;

    // берем данные
    //LastCollection := dp.GetFromDB('(Document_ID in (Select Document_ID from tbl_Structure_Count_Document where Structure_ID = ' + IntToStr(iUIN) + '))');
    LastCollection := dp.GetFromDB('(Document_ID > 0)');
  end
end;

{ TResourceByVersionBaseLoadAction }

constructor TResourceByVersionBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  DestroyCollection := false;
  Visible := false;
end;

function TResourceByVersionBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
    v: TOldAccountVersion;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldAccountVersion).Resources;
  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;

    Result := inherited Execute(ABaseObject);
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TResourceDataPoster];
    // инициализируем коллекцию
    dp.LastGotCollection := LastCollection;
    // берем данные
    v := ABaseObject as TOldAccountVersion;
    LastCollection := dp.GetFromDB('DOCUMENT_ID = ' + IntToStr(ABaseObject.ID) + ' and CONCRETE_LAYER_ID = ' + IntToStr(v.Layer.ID)+ ' and ' + 'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID));
  end;
end;

{ TReserveByVersionBaseLoadAction }

constructor TReserveByVersionBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  DestroyCollection := false;
  Visible := false;
end;

function TReserveByVersionBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
    v: TOldAccountVersion;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldAccountVersion).Reserves;
  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;

    Result := inherited Execute(ABaseObject);
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TReserveDataPoster];
    // инициализируем коллекцию
    dp.LastGotCollection := LastCollection;
    // берем данные
    v := ABaseObject as TOldAccountVersion;
    LastCollection := dp.GetFromDB('DOCUMENT_ID = ' + IntToStr(ABaseObject.ID) + ' and BED_ID = ' + IntToStr(v.Bed.ID)+ ' and ' + 'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID));
  end;
end;

{ TParamByVersionLoadAction }

constructor TParamByVersionBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  DestroyCollection := false;
  Visible := false;
end;

function TParamByVersionBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldAccountVersion).Parameters;
  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;

    Result := inherited Execute(ABaseObject);
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TParameterDataPoster];
    // инициализируем коллекцию
    dp.LastGotCollection := LastCollection;


    LastCollection := dp.GetFromDB('DOCUMENT_ID = ' + IntToStr(ABaseObject.ID) + ' and OBJECT_UIN = ' + IntToStr((ABaseObject.Collection as TBaseCollection).Owner.ID) + ' and NUM_OBJECT_TYPE = ' + IntToStr((ABaseObject.Collection as TBaseCollection).Owner.ObjectType)+ ' and ' + 'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID));
  end;
end;

{ TStructureHistoryBaseLoadAction }

constructor TStructureHistoryBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  DestroyCollection := false;
  Visible := false;
  Caption := 'Загрузить историю структуры';
end;

function TStructureHistoryBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  Result := true;
  LastCollection := (ABaseObject as TOldStructure).History;
  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;

    //Result := inherited Execute(ABaseObject);
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TStructureHistoryDataPoster];
    // инициализируем коллекцию
    dp.LastGotCollection := LastCollection;


    LastCollection := dp.GetFromDB('OBJECT_UIN = ' + IntToStr(ABaseObject.ID) + ' and NUM_OBJECT_TYPE = ' + IntToStr(ABaseObject.ObjectType)+ ' and ' + 'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID));
  end;
end;

{ TWellsByAreaBaseLoadAction }

function TWellsBaseLoadAction.Execute(ASQL: string): boolean;
var dp: TDataPoster;
begin
  Result := inherited Execute;
  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TDrilledStructureAreaWellDataPoster];
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  LastCollection := dp.GetFromDB(ASQL);
end;

{ TDocumentByVersionBaseLoadAction }

constructor TDocumentByVersionBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  DestroyCollection := false;
  Visible := false;
end;

function TDocumentByVersionBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldAccountVersion).Documents;
  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;

    Result := inherited Execute(ABaseObject);
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TDocumentDataPoster];
    // инициализируем коллекцию
    dp.LastGotCollection := LastCollection;


    LastCollection := dp.GetFromDB('Material_ID in (' + 'select Material_ID from tbl_Count_Doc_Material cdm where cdm.Document_ID = '
                                  + IntToStr(ABaseObject.ID) + ') ' +
                                  'and Material_Id in (select Material_ID from tbl_material_binding mb where mb.object_bind_type_id = ' +
                                  IntToStr(((ABaseObject.Collection as TBaseCollection).Owner as TBaseObject).MaterialBindType) +
                                  ' and mb.Object_bind_id = ' + IntToStr(((ABaseObject.Collection as TBaseCollection).Owner as TBaseObject).ID) +
                                  ')');
  end;
end;

{ TFundVersionBaseLoadAction }

constructor TFundVersionBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
end;

function TFundVersionBaseLoadAction.Execute(AFilter: string): boolean;
var dp: TDataPoster;
begin
  LastCollection.NeedsUpdate := false;
  Result := inherited Execute(AFilter);
  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TVersionDataPoster];
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  LastCollection := dp.GetFromDB('Version_ID > -1');

  LastFilter := AFilter;
end;

{ TStructureBasePreEditAction }

function TStructureBasePreEditAction.Execute(
  ABaseObject: TBaseObject): boolean;
var s: TOldStructure;
    dp: TDataPoster;
    cls: TDataPosterClass;
begin
  Result := true;
  if ABaseObject is TOldStructure then
  begin
    S := ABaseObject as TOldStructure;

    if ABaseObject.NeedsUpdate then
    begin
      cls := nil;
      case S.StructureTypeID of
        // Выявленные
        1: cls := TDiscoveredStructureDataPoster;
        // подгтовленные
        2: cls := TPreparedStructureDataPoster;
        // в бурении
        3: cls := TDrilledStructureDataPoster;
        // месторождения
        4: cls := TFieldDataPoster;
      end;

      if Assigned(cls) then
      begin
        // берем постер
        dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[cls];
        // инициализируем коллекцию
        dp.LastGotObject := ABaseObject;
        // инициализируем коллекцию
        dp.GetFromDB(ABaseObject.ID);
        ABaseObject.NeedsUpdate := false;
      end;
    end;
  end;
end;

constructor TStructureBasePreEditAction.Create(AOwner: TComponent);
begin
  inherited;
  Visible := false;
  DestroyCollection := false;
  CanUndo := false;
end;

{ TLicenseZoneBaseLoadAction }

constructor TLicenseZoneBaseLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  DestroyCollection := false;
end;

function TLicenseZoneBaseLoadAction.Execute(AFilter: string): boolean;
var dp: TDataPoster;
    sFilter, sOrder: string;
begin
  LastCollection.NeedsUpdate := false;

  sFilter := AFilter;

  if pos('order by', AFilter) > 0 then
  begin
    sFilter := copy(AFilter, 1, pos('order by', AFilter) - 1);
    sOrder := copy(AFilter, pos('order by', AFilter) + Length('order by'), Length(AFilter))
  end
  else
    sOrder := '';

  LastFilter := sFilter;  
  //Result := inherited Execute(sFilter);



  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TLicenseZoneDataPoster];
  dp.Order := sOrder;
  // инициализируем коллекцию
  dp.LastGotCollection := LastCollection;
  // берем данные
  LastCollection := dp.GetFromDB(sFilter);
end;

{ TFieldReserveByVersionBaseLoadAction }

constructor TFieldReserveByVersionBaseLoadAction.Create(
  AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  DestroyCollection := false;
  Visible := false;
end;

function TFieldReserveByVersionBaseLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
    v: TOldAccountVersion;
begin
  Result := false;
  LastCollection := (ABaseObject as TOldAccountVersion).Reserves;
  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;

    Result := inherited Execute(ABaseObject);
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TFieldReserveDataPoster];
    // инициализируем коллекцию
    dp.LastGotCollection := LastCollection;
    // берем данные
    v := ABaseObject as TOldAccountVersion;
    LastCollection := dp.GetFromDB('DOCUMENT_ID = ' + IntToStr(ABaseObject.ID) + ' and STRUCTURE_ID = ' + IntToStr(v.Structure.ID)+ ' and ' + 'Version_ID = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID));
  end;
end;

end.

