unit Facade;

interface

uses BaseFacades, Registrator, Classes, DBGate, SDFacade,
     SlottingWell, Straton, CoreMechanicalState,
     BaseDicts, BaseObjects, SlottingPlacement,
     RockSample, CommonStepForm, PetrolRegion,
     CoreCollection, GeneralizedSection, CoreTransfer;

type
  TMainFacade = class (TSDFacade)
  private
    frmStep: TfrmStep;
    FFilter: string;
    FCoreLibrary: TCoreLibrary;
    FRegistrator: TRegistrator;
    FWells: TSlottingWells;
    FCollectionWells: TCollectionWells;
    FCoreMechanicalStates: TCoreMechanicalStates;
    FTaxonomies: TStratTaxonomies;
    FPartPlacementTypes: TPartPlacementTypes;
    FRockSampleSizeTypes: TRockSampleSizeTypes;
    FRockSampleTypes: TRockSampleTypes;
    FAllFossilTypes: TFossilTypes;
    FAllCoreCollectionTypes: TCoreCollectionTypes;
    FAllCoreCollections: TCoreCollections;
    FActiveCollection: TCoreCollection;
    FCollectionSampleTypes: TCollectionSampleTypes;
    FAllDenudations: TDenudations;
    FGeneralizedSections: TGeneralizedSections;
    FCoreTransferTypes: TCoreTransferTypes;
    FCoreTransfers: TCoreTransfers;
    function GetWells: TSlottingWells;
    function GetCoreMechanicalStatets: TCoreMechanicalStates;
    function GetTaxonomies: TStratTaxonomies;
    function GetAllPartPlacementTypes: TPartPlacementTypes;
    function GetCoreLibrary: TCoreLibrary;
    function GetAllRockSampleSizeTypes: TRockSampleSizeTypes;
    function GetAllRockSampleTypes: TRockSampleTypes;
    function GetAllCollectionTypes: TCoreCollectiontypes;
    function GetAllFossilTypes: TFossilTypes;
    function GetAllCoreCollections: TCoreCollections;
    function GetAllCollectionWells: TCollectionWells;
    function GetCollectionSampleTypes: TCollectionSampleTypes;
    function GetAllDenudations: TDenudations;
    function GetAllWellsCandidates: TWellCandidates;
    function GetGeneralizedSections: TGeneralizedSections;
    function GetCoreTransferTypes: TCoreTransferTypes;
    function GetCoreTransfers: TCoreTransfers;
  protected
    function GetRegistrator: TRegistrator; override;
    function GetAllDicts: TDicts; override;

    function GetDataPosterByClassType(
      ADataPosterClass: TDataPosterClass): TDataPoster; override;
  public
    // фильтр
    property Filter: string read FFilter write FFilter;
    // в конструкторе создаютс€ и настраиваютс€ вс€кие
    // необходимые в скором времени вещи
    constructor Create(AOwner: TComponent); override;

    // скважины-кернохранилище
    property AllWells: TSlottingWells read GetWells;
    procedure RefreshWells;
    // таксономии стратподразделений
    property AllTaxonomies: TStratTaxonomies read GetTaxonomies;
    // все механические состо€ни€
    property AllMechanicalStates: TCoreMechanicalStates read GetCoreMechanicalStatets;
    // все типы местоположений керна
    property AllPartPlacementTypes: TPartPlacementTypes read GetAllPartPlacementTypes;
    // кернохранилище
    property CoreLibrary: TCoreLibrary read GetCoreLibrary;
    procedure ClearCoreLibrary;
    // типоразмеры образцов
    property AllRockSampleSizeTypes: TRockSampleSizeTypes read GetAllRockSampleSizeTypes;
    // типы образцов
    property AllRockSampleTypes: TRockSampleTypes read GetAllRockSampleTypes;
    // сводные разрезы
    property GeneralizedSections: TGeneralizedSections read GetGeneralizedSections;
    procedure RefreshGeneralizedSections;

    // типы перемещени€ керна
    property AllCoreTransferTypes: TCoreTransferTypes read GetCoreTransferTypes;
    // все перемещени€ керна
    property AllCoreTransfers: TCoreTransfers read GetCoreTransfers;
    // все типы органических остатков
    property AllFossilTypes: TFossilTypes read GetAllFossilTypes;
    // все типы коллекций
    property AllCollectionTypes: TCoreCollectiontypes read GetAllCollectionTypes;
    // все коллекции
    property AllCoreCollections: TCoreCollections read GetAllCoreCollections;
    // скважины - коллекции
    property AllCollectionWells: TCollectionWells read GetAllCollectionWells;
    // активна€ коллекци€
    property ActiveCollection: TCoreCollection read FActiveCollection write FActiveCollection;
    // все типы образцов в коллекции
    property CollectionSampleTypes: TCollectionSampleTypes read GetCollectionSampleTypes;

    property AllDenudations: TDenudations read GetAllDenudations;
    property AllWellCandidates: TWellCandidates read GetAllWellsCandidates;

    procedure LoadDicts;
    procedure UploadBoxPictures(ABox: TBox);
    function  ClearBoxPictures(ABoxes: TBoxes): boolean;

    class function GetInstance: TMainFacade; reintroduce;
    destructor Destroy; override;
  end;

  TConcreteRegistrator = class(TRegistrator)
  public
    constructor Create; override;
  end;

  TConcreteDicts = class(TDicts)
  public
    constructor Create; override;
  end;




implementation

uses Slotting, SlottingPoster, StratonPoster, CoreMechanicalStatePoster,
     SlottingPlacementDataPoster, RockSamplePoster, SlottingWellPoster, Forms,
     Controls, CoreCollectionPoster, SysUtils, VarFileUtils, BaseConsts,
     GeneralizedSectionDataPoster, CoreTransferDataPoster, WellPoster;


{ TMDFacade }


function TMainFacade.ClearBoxPictures(ABoxes: TBoxes): boolean;
var i, j: integer;
    strlstPaths: TStringList;
begin
  try
    Result := true;
    DBGates.Server.StartTrans;
    strlstPaths := TStringList.Create;
    for i := 0 to ABoxes.Count - 1 do
    begin
      for j := 0 to ABoxes.Items[i].BoxPictures.Count - 1 do
        strlstPaths.Add(ABoxes.Items[i].BoxPictures.Items[j].RemoteFullName);

      ABoxes.Items[i].BoxPictures.MarkAllDeleted;
      ABoxes.Items[i].BoxPictures.Update(nil);
    end;

    DBGates.DeleteFiles(strlstPaths);
    strlstPaths.Free;
    DBGates.Server.CommitTrans;
  except
    for i := 0 to ABoxes.Count - 1 do
      ABoxes.Items[i].ClearBoxPictures;
    DBGates.Server.RollBackTrans;
    Result := false;
  end;
end;

procedure TMainFacade.ClearCoreLibrary;
begin
  //CoreLibrary.PartPlacementPlainList
end;

constructor TMainFacade.Create(AOwner: TComponent);
begin
  SettingsFileName :=  ExtractFilePath(ParamStr(0))+'CR.ini';
  inherited;
  // настройка соединени€ с бд
  //DBGates.ServerClassString := 'RiccServerTest.CommonServerTest';
  DBGates.ServerClassString := 'RiccServer.CommonServer';
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;
  // об€зательно также тип клиента пр€м здесь указать
  //DBGates.ClientAppTypeID := 2;
end;

destructor TMainFacade.Destroy;
begin
  inherited;
  if Assigned(FCoreMechanicalStates) then FCoreMechanicalStates.Free;
  if Assigned(FWells) then FWells.Free;
  if Assigned(FTaxonomies) then FTaxonomies.Free;
  if Assigned(FPartPlacementTypes) then FPartPlacementTypes.Free;
  if Assigned(FCollectionWells) then FCollectionWells.Free;
  FreeAndNil(FGeneralizedSections);
  FreeAndNil(FCoreTransfers);
  FreeAndNil(FCoreTransferTypes);
  FreeAndNil(FCollectionSampleTypes);
  FreeAndNil(FAllDenudations);
  FreeAndNil(FCoreLibrary);

  try
    if Assigned(FCoreLibrary) then FCoreLibrary.Free;
  except
    // что-то дестроитс€ дважды, потом разберусь
  end;
end;

function TMainFacade.GetAllCollectionTypes: TCoreCollectiontypes;
begin
  if not Assigned(FAllCoreCollectionTypes) then
  begin
    FAllCoreCollectionTypes := TCoreCollectionTypes.Create;
    FAllCoreCollectionTypes.Reload('', true);
  end;

  Result := FAllCoreCollectionTypes;
end;

function TMainFacade.GetAllCollectionWells: TCollectionWells;
begin
  Result := nil;

  if Assigned(ActiveCollection) then
    Result := ActiveCollection.CollectionWells;

end;

function TMainFacade.GetAllCoreCollections: TCoreCollections;
begin
  if not Assigned(FAllCoreCollections) then
  begin
    FAllCoreCollections := TCoreCollections.Create;
    FAllCoreCollections.Reload('', true);
  end;

  Result := FAllCoreCollections;
end;

function TMainFacade.GetAllDenudations: TDenudations;
begin
  Result := nil;
  if Assigned(ActiveCollection) then
    Result := ActiveCollection.Denudations;
end;

function TMainFacade.GetAllDicts: TDicts;
begin
  if not Assigned(FAllDicts) then
    FAllDicts := TConcreteDicts.Create;
  Result := FAllDicts;
end;

function TMainFacade.GetAllFossilTypes: TFossilTypes;
begin
  if not Assigned(FAllFossilTypes) then
  begin
    FAllFossilTypes := TFossilTypes.Create;
    FAllFossilTypes.Reload('', true);
  end;

  Result := FAllFossilTypes;
end;

function TMainFacade.GetAllPartPlacementTypes: TPartPlacementTypes;
begin
  if not Assigned(FPartPlacementTypes) then
  begin
    FPartPlacementTypes := TPartPlacementTypes.Create;
    FPartPlacementTypes.OwnsObjects := true;
  end;

  if FPartPlacementTypes.Count = 0 then
    FPartPlacementTypes.Reload('', true);

  Result := FPartPlacementTypes;
end;


function TMainFacade.GetAllRockSampleSizeTypes: TRockSampleSizeTypes;
begin
  if not Assigned(FRockSampleSizeTypes) then
  begin
    FRockSampleSizeTypes := TRockSampleSizeTypes.Create;
    FRockSampleSizeTypes.Reload('', true);
    FRockSampleSizeTypes.OwnsObjects := true;
  end;

  Result := FRockSampleSizeTypes;
end;

function TMainFacade.GetAllRockSampleTypes: TRockSampleTypes;
begin
  if not Assigned(FRockSampleTypes) then
  begin
    FRockSampleTypes := TRockSampleTypes.Create;
    FRockSampleTypes.Reload('', true);
    FRockSampleTypes.OwnsObjects := true;
  end;

  Result := FRockSampleTypes;
end;

function TMainFacade.GetAllWellsCandidates: TWellCandidates;
begin
  Result := nil;
  if Assigned(ActiveCollection) then
    Result := ActiveCollection.WellCandidates;
end;

function TMainFacade.GetCollectionSampleTypes: TCollectionSampleTypes;
begin
  if not Assigned(FCollectionSampleTypes) then
  begin
    FCollectionSampleTypes := TCollectionSampleTypes.Create;
    FCollectionSampleTypes.Reload('', true);
  end;

  Result := FCollectionSampleTypes;
end;

function TMainFacade.GetCoreLibrary: TCoreLibrary;
begin
  if not Assigned(FCoreLibrary) then FCoreLibrary := TCoreLibrary.Create();
  Result := FCoreLibrary;
end;

function TMainFacade.GetCoreMechanicalStatets: TCoreMechanicalStates;
begin
  if not Assigned(FCoreMechanicalStates) then
  begin
    FCoreMechanicalStates := TCoreMechanicalStates.Create;
    FCoreMechanicalStates.OwnsObjects := true;
  end;

  if FCoreMechanicalStates.Count = 0 then
    FCoreMechanicalStates.Reload('', true);

  Result := FCoreMechanicalStates;
end;

function TMainFacade.GetCoreTransfers: TCoreTransfers;
begin
  if not Assigned(FCoreTransfers) then
  begin
    FCoreTransfers := TCoreTransfers.Create;
    FCoreTransfers.Reload('', True);
  end;

  Result := FCoreTransfers;
end;

function TMainFacade.GetCoreTransferTypes: TCoreTransferTypes;
begin
  if not Assigned(FCoreTransferTypes) then
  begin
    FCoreTransferTypes := TCoreTransferTypes.Create;
    FCoreTransferTypes.Reload('', true);
  end;
  Result := FCoreTransferTypes;
end;

function TMainFacade.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
begin
  Result := inherited GetDataPosterByClassType(ADataPosterClass);

  // обеспечиваем постеры всем нужным дл€ материализации
  if Assigned(Result) then
  begin
    if Result is TSimpleStratonDataPoster then
      (Result as TSimpleStratonDataPoster).AllStratTaxonomies := AllStratTaxonomies
    else if Result is TSlottingCoreMechanicalStateDataPoster then
      (Result as TSlottingCoreMechanicalStateDataPoster).AllMechanicalStates := AllMechanicalStates
    else if Result is TPartPlacementDataPoster then
      (Result as TPartPlacementDataPoster).AllPartPlacementTypes := AllPartPlacementTypes
    else if Result is TSlottingPlacementDataPoster then
    begin
      (Result as TSlottingPlacementDataPoster).AllPartPlacements := CoreLibrary.PartPlacementPlainList;
      (Result as TSlottingPlacementDataPoster).AllOrganizations := AllOrganizations;
      (Result as TSlottingPlacementDataPoster).AllCoreTransfers := AllCoreTransfers;
    end
    else if Result is TWellBoxDataPoster then
      (Result as TWellBoxDataPoster).Racks := CoreLibrary.MainGarage.Racks
    else if Result is TRockSampleSizeTypePoster then
      (Result as TRockSampleSizeTypePoster).AllSampleTypes := AllRockSampleTypes
    else if Result is TRockSampleSizeTypePresencePoster then
      (Result as TRockSampleSizeTypePresencePoster).AllSampleSizeTypes := AllRockSampleSizeTypes
    else if Result is TSlottingWellDataPoster then
    begin
      (Result as TSlottingWellDataPoster).AllOrganizations := AllOrganizations;
      (Result as TSlottingWellDataPoster).AllWellStates := AllStatesWells;
      (Result as TSlottingWellDataPoster).AllWellCategories := AllCategoriesWells;
      (Result as TSlottingWellDataPoster).AllAreas := AllAreas;
    end
    else if Result is TGeneralizedSectionDataPoster then
      (Result as TGeneralizedSectionDataPoster).AllStratons := AllSimpleStratons
    else if Result is TGeneralizedSectionSlottingDataPoster then
    begin
      (Result as TGeneralizedSectionSlottingDataPoster).AllStratons := AllSimpleStratons;
      (Result as TGeneralizedSectionSlottingDataPoster).AllAreas := AllAreas;
      (Result as TGeneralizedSectionSlottingDataPoster).AllWellCategories := AllCategoriesWells;
    end
    else if Result is TCoreTransferTaskDataPoster then
    begin
      (Result as TCoreTransferTaskDataPoster).AllAreas := AllAreas;
      (Result as TCoreTransferTaskDataPoster).AllWellCategories := AllCategoriesWells;
      (Result as TCoreTransferTaskDataPoster).OldPartPlacements := CoreLibrary.OldPlacementPlainList;
      (Result as TCoreTransferTaskDataPoster).NewPartPlacements := CoreLibrary.NewPlacementPlainList;
      (Result as TCoreTransferTaskDataPoster).AllTransferTypes := AllCoreTransferTypes;
      (Result as TCoreTransferTaskDataPoster).AllGeneralizedSections := GeneralizedSections;
    end
    else if Result is TCoreCollectionPoster then
    begin
      // отдаем дл€ материализации набор типов органических остатков
      (Result as TCoreCollectionPoster).AllFossilTypes := AllFossilTypes;
      // набор типов коллекций
      (Result as TCoreCollectionPoster).AllCollectionTypes := AllCollectionTypes;
      // набор сотрудников
      (Result as TCoreCollectionPoster).AllEmployees := AllEmployees;
      // набор стратонов
      (Result as TCoreCollectionPoster).AllStratons := AllSimpleStratons;
    end
    else if Result is TCollectionSamplePoster then
    begin
      (Result as TCollectionSamplePoster).AllStratons := AllSimpleStratons;
      (Result as TCollectionSamplePoster).AllSampleTypes := CollectionSampleTypes; 
    end
    else if Result is TWellDynamicParametersDataPoster then
    begin
      (Result as TWellDynamicParametersDataPoster).AllCategories := AllCategoriesWells;
      (Result as TWellDynamicParametersDataPoster).AllStates := AllStatesWells;
      (Result as TWellDynamicParametersDataPoster).AllProfiles := AllProfiles;
      (Result as TWellDynamicParametersDataPoster).AllFluidTypes := AllFluidTypes;
      (Result as TWellDynamicParametersDataPoster).AllStratons := AllSimpleStratons;
      (Result as TWellDynamicParametersDataPoster).AllVersions := AllVersions;
    end;
  end;
end;

function TMainFacade.GetGeneralizedSections: TGeneralizedSections;
begin
  if not Assigned(FGeneralizedSections) then
  begin
    FGeneralizedSections := TGeneralizedSections.Create;
    FGeneralizedSections.Reload('', True);
  end;

  Result := FGeneralizedSections;
end;

class function TMainFacade.GetInstance: TMainFacade;
begin
  Result := inherited GetInstance as TMainFacade;
end;

function TMainFacade.GetRegistrator: TRegistrator;
begin
  if not Assigned(FRegistrator) then
    FRegistrator := TConcreteRegistrator.Create;
  Result := FRegistrator;
end;


{ TConcreteRegistrator }

constructor TConcreteRegistrator.Create;
begin
  inherited;
  AllowedControlClasses.Add(TStringsRegisteredObject);
  AllowedControlClasses.Add(TTreeViewRegisteredObject);
end;


function TMainFacade.GetTaxonomies: TStratTaxonomies;
begin
  if not Assigned(FTaxonomies) then
  begin
    FTaxonomies := TStratTaxonomies.Create;
    FTaxonomies.Reload('', true);
  end;

  Result := FTaxonomies;
end;

function TMainFacade.GetWells: TSlottingWells;
begin
  if not Assigned(FWells) then
    FWells := TSlottingWells.Create;

  if FWells.Count = 0 then
    FWells.Reload;

  Result := FWells;
end;

{ TConcreteDicts }

constructor TConcreteDicts.Create;
var d: TDict;
begin
  inherited;

  d := TDict.Create(Self, 'TBL_STRATIGRAPHY_NAME_DICT', true, 'STRATON_ID, VCH_STRATON_INDEX, VCH_STRATON_DEFINITION');
  d.IsEditable := false;
end;

procedure TMainFacade.LoadDicts;
begin

  frmStep.Free;
  frmStep := nil;

  try
    Screen.Cursor := crHourGlass;

    frmStep := TfrmStep.Create(Self);
    frmStep.Caption := '«агрузка справочников';
    frmStep.ShowLog := false;
    frmStep.InitProgress(1, 5, 1);

    frmStep.Show;
    frmStep.MakeStep('«агрузка справочника таксономических единиц');
    AllTaxonomies;

    frmStep.MakeStep('«агрузка справочника местоположений');
    CoreLibrary.PartPlacementPlainList;

    frmStep.MakeStep('«агрузка справочника стратиграфических подразделений');
    AllSimpleStratons;

    frmStep.MakeStep('«агрузка справочника нефтегазоносных регионов');
    AllPetrolRegions;
  finally
    Screen.Cursor := crDefault;
    Application.MainForm.Cursor := crDefault;
    frmStep.Free;
    frmStep := nil;
  end;
end;

procedure TMainFacade.RefreshGeneralizedSections;
begin
  FreeAndNil(FGeneralizedSections);
end;

procedure TMainFacade.RefreshWells;
begin
  FreeAndNil(FWells); 
end;

procedure TMainFacade.UploadBoxPictures(ABox: TBox);
var UploadPath: string;
    i, j: integer;
    f: Variant;
begin
  for i := 0 to ABox.BoxPictures.Count - 1 do
  begin
    // надо вырезать из Path до знака "$"
    UploadPath := ABox.BoxPictures.Items[i].RemoteFullName;

    UploadPath := StringReplace(UploadPath, '$', '',[]);
    UploadPath := StringReplace(UploadPath, RemoteSrvName, RemoteCoreFilesDiskLetter,[]);


    if j > 0 then
    begin
      Delete(UploadPath, 1, j);
      UploadPath := RemoteCoreFilesDiskLetter + UploadPath;
    end;
    
    f := CreateVariantByFile(ABox.BoxPictures.Items[i].LocalFullName);
    TMainFacade.GetInstance.DBGates.Server.UploadFile(f, UploadPath, false, false);
  end;
end;

end.

