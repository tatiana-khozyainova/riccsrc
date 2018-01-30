unit Facade;

interface

uses BaseFacades, Registrator, Classes, DBGate, SDFacade,BaseObjects,
SeisMaterial,SeisExemple,SeisProfile,Material, Structure, Table, Organization, Employee, Area, PetrolRegion;

type
  TMainFacade = class (TSDFacade)
  private
    FFilter: string;

    FRegistrator: TRegistrator;
    FAllSeisWorkMethods: TSeisWorkMethods;
    FAllSeisWorkTypes: TSeisWorkTypes;
    FAllSeisCrews: TSeisCrews;
    FAllSeismicProfileTypes: TSeismicProfileTypes;
    FAllExempleTypes: TExempleTypes;
    FAllElementTypes: TElementTypes;
    FAllMaterialLocations: TMaterialLocations;
    FAllExempleLocations: TExempleLocations;
    FAllSimpleDocuments:TSimpleDocuments;
    FAllSeismicMaterials:TSeismicMaterials;
    FAllSeismicProfiles:TSeismicProfiles;
    FAllExempleSeismicMaterials:TExempleSeismicMaterials;
    FAllElementExemples:TElementExemples;
    FAllSeismicProfileCoordinates:TSeismicProfileCoordinates;
    //FAllStructures:TStructures;
    FAllRiccTables:TRICCTables;
    FAllRiccAttributes:TRICCAttributes;
    FAllObjectBindTypes:TObjectBindTypes;
    FAllMaterialBindings:TMaterialBindings;
    //FAllDocumentTypes:TDocumentTypes;
    FAllOrganizations:TOrganizations;
    //FAllEmployees:TEmployees;
    //FAllEmployeeOurs:TEmployeeOurs;
    //FAllEmployeeOutsides:TEmployeeOutsides;
    FAllMaterialAuthors:TMaterialAuthors;
    FAllObjectBindMaterialTypes:TObjectBindMaterialTypes;

    function GetAllSeisWorkMethods: TSeisWorkMethods;
    function GetAllSeisWorkTypes: TSeisWorkTypes;
    function GetAllSeisCrews: TSeisCrews;
    function GetAllSeismicProfileTypes: TSeismicProfileTypes;
    function GetAllExempleTypes: TExempleTypes;
    function GetAllElementTypes: TElementTypes;
    function GetAllMaterialLocations: TMaterialLocations;
    function GetAllSimpleDocuments: TSimpleDocuments;
    function GetAllExempleLocations: TExempleLocations;
    function GetAllSeismicMaterials:TSeismicMaterials;
    function GetAllSeismicProfiles:TSeismicProfiles;
    function GetAllExempleSeismicMaterials:TExempleSeismicMaterials;
    function GetAllElementExemples:TElementExemples;
    function GetAllSeismicProfileCoordinates:TSeismicProfileCoordinates;
    //function GetAllStructures:TStructures;
    function GetAllRiccTables:TRICCTables;
    function GetAllRiccAttributes:TRICCAttributes;
    function GetAllObjectBindTypes:TObjectBindTypes;
    function GetAllMaterialBindings:TMaterialBindings;
    //function GetAllDocumentTypes:TDocumentTypes;
    function GetAllOrganizations:TOrganizations;
    //function GetAllEmployeeOurs:TEmployeeOurs;
    //function GetAllEmployeeOutsides:TEmployeeOutsides;
    //function GetAllEmployees: TEmployees;
    function GetAllMaterialAuthors:TMaterialAuthors;
    function GetAllObjectBindMaterialTypes:TObjectBindMaterialTypes;
    function GetBindingObjects(const BindingObjectTypeID: integer): TIDObjects;
    function GetBindingObjectTypes(obj: TIDObject): Integer;

  protected
    function GetRegistrator: TRegistrator; override;
    function GetDataPosterByClassType(ADataPosterClass: TDataPosterClass): TDataPoster; override;

  public
    class function GetInstance: TMainFacade;
    procedure SkipSimpleDocuments;
    // фильтр
    property Filter: string read FFilter write FFilter;
    property AllSeisWorkMethods: TSeisWorkMethods read  GetAllSeisWorkMethods;
    property AllSeisWorkTypes: TSeisWorkTypes read  GetAllSeisWorkTypes;
    property AllSeisCrews: TSeisCrews read  GetAllSeisCrews;
    property AllSeismicProfileTypes: TSeismicProfileTypes read  GetAllSeismicProfileTypes;
    property AllExempleTypes: TExempleTypes read  GetAllExempleTypes;
    property AllElementTypes: TElementTypes read  GetAllElementTypes;
    property AllMaterialLocations: TMaterialLocations read  GetAllMaterialLocations;
    property AllSimpleDocuments: TSimpleDocuments read  GetAllSimpleDocuments;
    property AllExempleLocations: TExempleLocations read GetAllExempleLocations;
    property AllSeismicMaterials:TSeismicMaterials read GetAllSeismicMaterials;
    property ALLSeismicProfiles:TSeismicProfiles read GetAllSeismicProfiles;
    property ALLExempleSeismicMaterials:TExempleSeismicMaterials read GetAllExempleSeismicMaterials;
    property ALLElementExemples:TElementExemples read GetAllElementExemples;
    property AllSeismicProfileCoordinates:TSeismicProfileCoordinates read GetAllSeismicProfileCoordinates;
    //property AllStructure:TStructures read GetAllStructures;
    property AllRiccTables:TRICCTables read GetAllRiccTables;
    property AllRiccAttributes:TRICCAttributes read GetAllRiccAttributes;
    property AllObjectBindTypes:TObjectBindTypes read GetAllObjectBindTypes;
    property AllMaterialBindings:TMaterialBindings read GetAllMaterialBindings;
    //property AllDocumentTypes:TDocumentTypes read GetAllDocumentTypes;
    property AllOrganizations:TOrganizations read GetAllOrganizations;
    //property AllEmployees:TEmployees read GetAllEmployees;
    //property AllEmployeeOurs:TEmployeeOurs read GetAllEmployeeOurs;
    //property AllEmployeeOutsides:TEmployeeOutsides read GetAllEmployeeOutsides;
    property AllMaterialAuthors:TMaterialAuthors read GetAllMaterialAuthors;
    property AllObjectBindMaterialTypes:TObjectBindMaterialTypes read GetAllObjectBindMaterialTypes;


    property BindingObjects[const BindingObjectTypeID: integer]: TIDObjects read GetBindingObjects;
    property BindingObjectTypes[obj: TIDObject]:integer  read GetBindingObjectTypes;


    // в конструкторе создаются и настраиваются всякие
    // необходимые в скором времени вещи
    constructor Create(AOwner: TComponent); override;
  end;

  TConcreteRegistrator = class(TRegistrator)
  public
    constructor Create; override;
  end;

implementation

uses SeisMaterialPoster,SeisExemplePoster,SeisProfilePoster,MaterialPoster, StructurePoster, TablePoster, BaseConsts, SysUtils;

{ TMDFacade }

constructor TMainFacade.Create(AOwner: TComponent);
begin
  inherited;
  // настройка соединения с бд
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;
  // обязательно также тип клиента прям здесь указать
  //DBGates.ClientAppTypeID := 23;
  //DBGates.ClientName := 'Отчет о сейсморазведочных работах';
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

class function TMainFacade.GetInstance: TMainFacade;
const FInstance: TMainFacade = nil;
begin
  if FInstance = nil then
  FInstance :=Create(nil);
  Result := FInstance;
end;

function TMainFacade.GetAllSeisWorkMethods: TSeisWorkMethods;
begin
  if not Assigned (FAllSeisWorkMethods) then
  begin
    FAllSeisWorkMethods := TSeisWorkMethods.Create;
    FAllSeisWorkMethods.Reload('', True);
  end;
  Result := FAllSeisWorkMethods;
end;



function TMainFacade.GetAllElementTypes: TElementTypes;
begin
if not Assigned (FAllElementTypes) then
  begin
    FAllElementTypes := TElementTypes.Create;
    FAllElementTypes.Reload('', True);
  end;
  Result := FAllElementTypes;
end;

function TMainFacade.GetAllExempleTypes: TExempleTypes;
begin
if not Assigned (FAllExempleTypes) then
  begin
    FAllExempleTypes := TExempleTypes.Create;
    FAllExempleTypes.Reload('', True);
  end;
  Result := FAllExempleTypes;
end;

function TMainFacade.GetAllSeisCrews: TSeisCrews;
begin
if not Assigned (FAllSeisCrews) then
  begin
    FAllSeisCrews := TSeisCrews.Create;
    FAllSeisCrews.Reload('', True);
  end;
  Result := FAllSeisCrews;
end;

function TMainFacade.GetAllSeismicProfileTypes: TSeismicProfileTypes;
begin
if not Assigned (FAllSeismicProfileTypes) then
  begin
    FAllSeismicProfileTypes := TSeismicProfileTypes.Create;
    FAllSeismicProfileTypes.Reload('', True);
  end;
  Result := FAllSeismicProfileTypes;
end;

function TMainFacade.GetAllSeisWorkTypes: TSeisWorkTypes;
begin
if not Assigned (FAllSeisWorkTypes) then
  begin
    FAllSeisWorkTypes := TSeisWorkTypes.Create;
    FAllSeisWorkTypes.Reload('', True);
  end;
  Result := FAllSeisWorkTypes;
end;

function TMainFacade.GetAllMaterialLocations: TMaterialLocations;
begin
if not Assigned (FAllMaterialLocations) then
  begin
    FAllMaterialLocations := TMaterialLocations.Create;
    FAllMaterialLocations.Reload('', True);
  end;
  Result := FAllMaterialLocations;
end;





function TMainFacade.GetAllSimpleDocuments: TSimpleDocuments;
begin
if not Assigned (FAllSimpleDocuments) then
  begin
    FAllSimpleDocuments := TSimpleDocuments.Create;
    if Filter<>'' then FAllSimpleDocuments.Reload(Filter+'and material_type_id=70', True)
    else FAllSimpleDocuments.Reload('material_type_id=70', True);
  end;
  Result := FAllSimpleDocuments;
end;

function TMainFacade.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
begin
Result := inherited GetDataPosterByClassType(ADataPosterClass);
  if Result is TExempleLocationDataPoster then
  begin
    (Result as TExempleLocationDataPoster).AllMaterialLocations := AllMaterialLocations;
  end;

  if Result is TSeismicMaterialDataPoster then
  begin
    (Result as TSeismicMaterialDataPoster).AllSimpleDocuments := AllSimpleDocuments;
    (Result as TSeismicMaterialDataPoster).AllSeisWorkMethods := AllSeisWorkMethods;
    (Result as TSeismicMaterialDataPoster).AllSeisWorkTypes := AllSeisWorkTypes;
    (Result as TSeismicMaterialDataPoster).AllSeisCrews := AllSeisCrews;
    //(Result as TSeismicMaterialDataPoster).AllStructures := AllStructures;
  end;

  if Result is TExempleSeismicMaterialDataPoster then
  begin
    (Result as TExempleSeismicMaterialDataPoster).AllSeismicMaterials := AllSeismicMaterials;
    (Result as TExempleSeismicMaterialDataPoster).AllExempleTypes := AllExempleTypes;
    (Result as TExempleSeismicMaterialDataPoster).AllExempleLocations := AllExempleLocations;
  end;

   if Result is TElementExempleDataPoster then
  begin
    (Result as TElementExempleDataPoster).AllExempleSeismicMaterials := AllExempleSeismicMaterials;
    (Result as TElementExempleDataPoster).AllElementTypes := AllElementTypes;
  end;

  if Result is TSeismicProfileDataPoster then
  begin
    (Result as TSeismicProfileDataPoster).AllSeismicMaterials := AllSeismicMaterials;
    (Result as TSeismicProfileDataPoster).AllSeismicProfileTypes := AllSeismicProfileTypes;
  end;

  if Result is TSeismicProfileCoordinateDataPoster then
  begin
    (Result as TSeismicProfileCoordinateDataPoster).AllSeismicProfiles := AllSeismicProfiles;
  end;

  if Result is TObjectBindTypeDataPoster then
  begin
    (Result as TObjectBindTypeDataPoster).AllRiccTables:= AllRiccTables;
    (Result as TObjectBindTypeDataPoster).AllRiccAttributes:= AllRiccAttributes;
  end;

  if Result is TMaterialBindingDataPoster then
  begin
    (Result as TMaterialBindingDataPoster).AllSimpleDocuments:= AllSimpleDocuments;
    (Result as TMaterialBindingDataPoster).AllObjectBindTypes:= AllObjectBindTypes;
  end;

  if Result is TSimpleDocumentDataPoster then
  begin
    (Result as TSimpleDocumentDataPoster).AllDocTypes:= DocumentTypes;
    (Result as TSimpleDocumentDataPoster).AllMaterialLocations:= AllMaterialLocations;
    (Result as TSimpleDocumentDataPoster).AllOrganizations:= AllOrganizations;
    (Result as TSimpleDocumentDataPoster).AllEmployees:= AllEmployees;

  end;

  if Result is TMaterialAuthorDataPoster then
  begin
    (Result as TMaterialAuthorDataPoster).AllSimpleDocuments:= AllSimpleDocuments;

  end;

   if Result is TObjectBindMaterialTypeDataPoster then
  begin
    (Result as TObjectBindMaterialTypeDataPoster).AllObjectBindTypes:= AllObjectBindTypes;
    (Result as TObjectBindMaterialTypeDataPoster).AllDocumentTypes:= DocumentTypes;

  end;


end;

function TMainFacade.GetAllExempleLocations: TExempleLocations;
begin
if not Assigned (FAllExempleLocations) then
  begin
    FAllExempleLocations := TExempleLocations.Create;
    FAllExempleLocations.Reload('', True);
  end;
  Result := FAllExempleLocations;
end;

function TMainFacade.GetAllExempleSeismicMaterials: TExempleSeismicMaterials;
begin
if not Assigned (FAllExempleSeismicMaterials) then
  begin
    FAllExempleSeismicMaterials := TExempleSeismicMaterials.Create;
    FAllExempleSeismicMaterials.Reload('', True);
  end;
  Result := FAllExempleSeismicMaterials;
end;

function TMainFacade.GetAllSeismicMaterials: TSeismicMaterials;
begin
if not Assigned (FAllSeismicMaterials) then
  begin
    FAllSeismicMaterials := TSeismicMaterials.Create;
    FAllSeismicMaterials.Reload('', True);
  end;
  Result := FAllSeismicMaterials;
end;

function TMainFacade.GetAllSeismicProfiles: TSeismicProfiles;
begin
if not Assigned (FAllSeismicProfiles) then
  begin
    FAllSeismicProfiles := TSeismicProfiles.Create;
    FAllSeismicProfiles.Reload('', True);
  end;
  Result := FAllSeismicProfiles;
end;

function TMainFacade.GetAllElementExemples: TElementExemples;
begin
if not Assigned (FAllElementExemples) then
  begin
    FAllElementExemples := TElementExemples.Create;
    FAllElementExemples.Reload('', True);
  end;
  Result := FAllElementExemples;
end;

function TMainFacade.GetAllSeismicProfileCoordinates: TSeismicProfileCoordinates;
begin
if not Assigned (FAllSeismicProfileCoordinates) then
  begin
    FAllSeismicProfileCoordinates := TSeismicProfileCoordinates.Create;
    FAllSeismicProfileCoordinates.Reload('', True);
  end;
  Result := FAllSeismicProfileCoordinates;
end;

{function TMainFacade.GetAllStructures: TStructures;
begin
if not Assigned (FAllStructures) then
  begin
    FAllStructures := TStructures.Create;
    FAllStructures.Reload('', True);
  end;
  Result := FAllStructures;
end; }

function TMainFacade.GetAllMaterialBindings: TMaterialBindings;
begin
if not Assigned (FAllMaterialBindings) then
  begin
    FAllMaterialBindings := TMaterialBindings.Create;
    FAllMaterialBindings.Reload('material_id>29400', True);
  end;
  Result := FAllMaterialBindings;
end;

function TMainFacade.GetAllObjectBindTypes: TObjectBindTypes;
begin
if not Assigned (FAllObjectBindTypes) then
  begin
    FAllObjectBindTypes := TObjectBindTypes.Create;
    FAllObjectBindTypes.Reload('', True);
  end;
  Result := FAllObjectBindTypes;
end;

function TMainFacade.GetAllRiccAttributes: TRICCAttributes;
begin
if not Assigned (FAllRiccAttributes) then
  begin
    FAllRiccAttributes := TRiccAttributes.Create;
    FAllRiccAttributes.Reload('', True);
  end;
  Result := FAllRiccAttributes;
end;

function TMainFacade.GetAllRiccTables: TRICCTables;
begin
if not Assigned (FAllRiccTables) then
  begin
    FAllRiccTables := TRiccTables.Create;
    FAllRiccTables.Reload('', True);
  end;
  Result := FAllRiccTables;
end;

{function TMainFacade.GetAllDocumentTypes: TDocumentTypes;
begin
if not Assigned (FAllDocumentTypes) then
  begin
    FAllDocumentTypes := TDocumentTypes.Create;
    FAllDocumentTypes.Reload('', True);
  end;
  Result := FAllDocumentTypes;
end;  }

{function TMainFacade.GetAllEmployees: TEmployees;
begin
if not Assigned (FAllEmployees) then
  begin
    FAllEmployees := TEmployees.Create;
    FAllEmployees.Reload('', True);
  end;
  Result := FAllEmployees;
end; }

function TMainFacade.GetAllOrganizations: TOrganizations;
begin
if not Assigned (FAllOrganizations) then
  begin
    FAllOrganizations := TOrganizations.Create;
    FAllOrganizations.Reload('', True);
  end;
  Result := FAllOrganizations;
end;

{function TMainFacade.GetAllEmployeeOurs: TEmployeeOurs;
begin
if not Assigned (FAllEmployeeOurs) then
  begin
    FAllEmployeeOurs := TEmployeeOurs.Create;
    FAllEmployeeOurs.Reload('', True);
  end;
  Result := FAllEmployeeOurs;
end;

function TMainFacade.GetAllEmployeeOutsides: TEmployeeOutsides;
begin
if not Assigned (FAllEmployeeOutsides) then
  begin
    FAllEmployeeOutsides := TEmployeeOutsides.Create;
    FAllEmployeeOutsides.Reload('', True);
  end;
  Result := FAllEmployeeOutsides;
end;  }

function TMainFacade.GetAllMaterialAuthors: TMaterialAuthors;
begin
if not Assigned (FAllMaterialAuthors) then
  begin
    FAllMaterialAuthors := TMaterialAuthors.Create;
    FAllMaterialAuthors.Reload('material_id>29400', True);
  end;
  Result := FAllMaterialAuthors;
end;

function TMainFacade.GetAllObjectBindMaterialTypes: TObjectBindMaterialTypes;
begin
if not Assigned (FAllObjectBindMaterialTypes) then
  begin
    FAllObjectBindMaterialTypes := TObjectBindMaterialTypes.Create;
    FAllObjectBindMaterialTypes.Reload('material_type_id=70', True);
  end;
  Result := FAllObjectBindMaterialTypes;
end;

function TMainFacade.GetBindingObjects(
  const BindingObjectTypeID: integer): TIDObjects;
begin
  case  BindingObjectTypeID of
  BINDING_OBJECT_TYPE_AREA: Result := AllAreas;
  BINDING_OBJECT_TYPE_NGR: Result := AllNGRs;
  BINDING_OBJECT_TYPE_NGO: Result := AllNGOs;
  BINDING_OBJECT_TYPE_NGP: Result := AllNGPs;
  end;
end;

function TMainFacade.GetBindingObjectTypes(obj: TIDObject): Integer;
begin
 if obj is TSimpleArea then Result:=BINDING_OBJECT_TYPE_AREA;
 if ((obj is TPetrolRegion) and ((obj as TPetrolRegion).RegionType=prtNGP))  then Result:=BINDING_OBJECT_TYPE_NGP;
 if ((obj is TPetrolRegion) and ((obj as TPetrolRegion).RegionType=prtNGO))  then Result:=BINDING_OBJECT_TYPE_NGO;
 if ((obj is TPetrolRegion) and ((obj as TPetrolRegion).RegionType=prtNGR))  then Result:=BINDING_OBJECT_TYPE_NGR;
end;

procedure TMainFacade.SkipSimpleDocuments;
begin
FreeAndNil(FAllSimpleDocuments);
end;

end.
