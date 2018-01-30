unit Facade;

interface

uses BaseFacades, Registrator, Classes, DBGate, SDFacade, SubdivisionComponent, Straton, Theme, Well, BaseObjects;

type
  TMainFacade = class (TSDFacade)
  private
    FFilter: string;
    FRegistrator: TRegistrator;

    FSubdivisionComments: TSubdivisionComments;
    FTectonicBlocks: TTectonicBlocks;
    FStratons: TStratons;
    FThemes, FSubdivisionThemes: TThemes;
    FSelectedWells: TWells;

    function GetAllTexctonicBlocks: TTectonicBlocks;
    function GetStratons: TStratons;
    function GetSubdivisionComments: TSubdivisionComments;
    function GetThemes: TThemes;
    function GetSelectedWells: TWells;
    function GetSubdivisionThemes: TThemes;
  protected
    function GetRegistrator: TRegistrator; override;
    function GetDataPosterByClassType(ADataPosterClass: TDataPosterClass): TDataPoster; override;
  public
    // все комменты к разбивкам
    property AllSubdivisionComments: TSubdivisionComments read GetSubdivisionComments;
    // все тектонические бловки
    property AllTectonicBlocks: TTectonicBlocks read GetAllTexctonicBlocks;
    // темы НИР
    property AllThemes: TThemes read GetThemes;
    // темы, по которым уже есть разбивки
    property SubdivisionThemes: TThemes read GetSubdivisionThemes;
    procedure RefreshSubdivisionThemes;
    // стратоны
    property AllStratons: TStratons read GetStratons;
    // выбранные скважины
    property SelectedWells: TWells read GetSelectedWells;
  
    // фильтр
    property Filter: string read FFilter write FFilter;
    // в конструкторе создаются и настраиваются всякие
    // необходимые в скором времени вещи
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

  TConcreteRegistrator = class(TRegistrator)
  public
    constructor Create; override;
  end;

implementation

uses SysUtils,  WellPoster, SubdivisionComponentPoster, StratonPoster;

{ TMDFacade }

constructor TMainFacade.Create(AOwner: TComponent);
begin
  inherited;
  // настройка соединения с бд
  //DBGates.ServerClassString := 'RiccServer.CommonServer';
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;
  SettingsFileName := 'SR.ini'
  // обязательно также тип клиента прям здесь указать
end;

destructor TMainFacade.Destroy;
begin
  FreeAndNil(FTectonicBlocks);
  FreeAndNil(FSubdivisionComments);
  FreeAndNil(FStratons);
  FreeAndNil(FThemes);
  FreeAndNil(FSelectedWells);
  FreeAndNil(FSubdivisionThemes);
  inherited;
end;

function TMainFacade.GetAllTexctonicBlocks: TTectonicBlocks;
begin
  if not Assigned(FTectonicBlocks) then
  begin
    FTectonicBlocks := TTectonicBlocks.Create;
    FTectonicBlocks.Reload('', true);
  end;
  Result := FTectonicBlocks;
end;

function TMainFacade.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
begin
  Result := inherited GetDataPosterByClassType(ADataPosterClass);

  if Result is TWellDynamicParametersDataPoster then
  begin
    (Result as TWellDynamicParametersDataPoster).AllCategories := AllCategoriesWells;
    (Result as TWellDynamicParametersDataPoster).AllStates := AllStatesWells;
    (Result as TWellDynamicParametersDataPoster).AllProfiles := AllProfiles;
    (Result as TWellDynamicParametersDataPoster).AllFluidTypes := AllFluidTypes;
    (Result as TWellDynamicParametersDataPoster).AllStratons := AllSimpleStratons;
    (Result as TWellDynamicParametersDataPoster).AllVersions := AllVersions;
  end
  else if (Result is TSubdivisionDataPoster) then
  begin
    (Result as TSubdivisionDataPoster).AllThemes := AllThemes;
    (Result as TSubdivisionDataPoster).AllEmployees := AllEmployees;
  end
  else if (Result is TSubdivisionComponentDataPoster) then
  begin
    (Result as TSubdivisionComponentDataPoster).AllStratons := AllSimpleStratons;
    (Result as TSubdivisionComponentDataPoster).AllTectonicBlocks := AllTectonicBlocks;
    (Result as TSubdivisionComponentDataPoster).AllSubdivisionComments := AllSubdivisionComments;
  end
  else if (Result is TStratonDataPoster) then
    (Result as TStratonDataPoster).AllSimpleStratons := AllSimpleStratons;  
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


function TMainFacade.GetSelectedWells: TWells;
begin
  if not Assigned(FSelectedWells) then
  begin
    FSelectedWells := TWells.Create();
    FSelectedWells.OwnsObjects := false;
  end;

  Result := FSelectedWells;
end;

function TMainFacade.GetStratons: TStratons;
begin
  if not Assigned(FStratons) then
  begin
    FStratons := TStratons.Create;
    FStratons.Reload('', true);
  end;
  result := FStratons;
end;

function TMainFacade.GetSubdivisionComments: TSubdivisionComments;
begin
  if not Assigned(FSubdivisionComments) then
  begin
    FSubdivisionComments := TSubdivisionComments.Create;
    FSubdivisionComments.Reload('', true);
  end;
  Result := FSubdivisionComments;
end;

function TMainFacade.GetSubdivisionThemes: TThemes;
begin
  if not Assigned(FSubdivisionThemes) then
  begin
    FSubdivisionThemes := TThemes.Create;
    FSubdivisionThemes.Reload('theme_ID in (select distinct theme_id from tbl_subdivision)', false);
  end;
  Result := FSubdivisionThemes;
end;

function TMainFacade.GetThemes: TThemes;
begin
  if not Assigned(FThemes) then
  begin
    FThemes := TThemes.Create;
    FThemes.Reload('', true);
  end;

  Result := FThemes;
end;

procedure TMainFacade.RefreshSubdivisionThemes;
begin
  FreeAndNil(FSubdivisionThemes);
end;

end.
