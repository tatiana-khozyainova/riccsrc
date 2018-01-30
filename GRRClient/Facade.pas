unit Facade;

interface

uses BaseFacades, Registrator, Classes, DBGate, SDFacade,
     LicenseZOne, GRRObligation, MeasureUnits, BaseObjects,Well, State, SeismWorkType,
     GRRClientGISQueries, GRRParameter;

type
  TMainFacade = class (TSDFacade)
  private
    FFilter: string;
    FRegistrator: TRegistrator;
    FLicenseZone: TLicenseZone;
    FOnActiveLicenseZoneChanged: TNotifyEvent;
    FNirTypes: TNirTypes;
    FNirStates: TNIRStates;
    FMeasureUnits : TMeasureUnits;
    FWellCategories: TWellCategories;
    FWellStates: TStates;
    FMainNirObligations: TNIRObligations;
    FSeisWorkTypes : TSeismWorkTypes;
    FGRRReportConcreteQueries: TGRRReportConcreteQueries;
    FGRRReportGISExcelQueries: TGRRReportGISXLQueries;
    FActiveWell: TWell;
    FParameterTypes: TGRRParameterTypes;
    FParamGroups : TGRRParamGroups;
    FGRRWellItervalTypes : TGRRWellIntervalTypes;

    //FNirObligation:

    procedure SetLicenseZone(const Value: TLicenseZone);
    function GetAllNirStates: TNIRStates;
    function GetAllNirTypes: TNirTypes;
    function GetAllMeasureUnits: TMeasureUnits;
    function GetAllWellCategories: TWellCategories;
    function GetAllWellStates: TStates;
    function GetAllMainNirObligations: TNIRObligations;
    function GetAllSeisWorkTypes: TSeismWorkTypes;
    function GetGRRReportConcreteQueries: TGRRReportConcreteQueries;
    function GetGRRReportGISXLQueries: TGRRReportGISXLQueries;
    function GetParameterTypes: TGRRParameterTypes;
    function GetGRRParamGroups: TGRRParamGroups;
    function GeTWellIntervalTypes: TGRRWellIntervalTypes;

  protected
    function GetRegistrator: TRegistrator; override;
    function GetDataPosterByClassType(ADataPosterClass: TDataPosterClass): TDataPoster; override;
  public
    class function GetInstance: TMainFacade;
    // фильтр
    property Filter: string read FFilter write FFilter;

    property ActiveLicenseZone: TLicenseZone read FLicenseZone write SetLicenseZone;
    property OnActiveLicenseZoneChanged: TNotifyEvent read FOnActiveLicenseZoneChanged write FOnActiveLicenseZoneChanged;

    //все состояния работ
    property AllNirStates : TNIRStates read GetAllNirStates;
    // все типы работы
    property AllNirTypes: TNirTypes read GetAllNirTypes;
    // все единицы измерения
    property AllMeasureUnits: TMeasureUnits read GetAllMeasureUnits;
    //все категории скважин
    property AllWellCategories : TWellCategories read GetAllWellCategories;
    // все типы скважин
    property AllWellStates: TStates read GetAllWellStates;
    // все обязательства по НИР
    property AllMainNirObligations: TNIRObligations read GetAllMainNirObligations;
    //все типы сейсморазведочных работ
    property AllSeisWorkTypes: TSeismWorkTypes read GetAllSeisWorkTypes;

    property GRRReportConcreteQueries: TGRRReportConcreteQueries read GetGRRReportConcreteQueries;
    property GRRReportGISXLQueries: TGRRReportGISXLQueries read GetGRRReportGISXLQueries;

    // выбранная скважина
    property ActiveWell: TWell read FActiveWell write FActiveWell;
    // типы параметров
    property ParameterTypes: TGRRParameterTypes read GetParameterTypes;
    // все группы параметров
    property ParamGroups: TGRRParamGroups read GetGRRParamGroups;
    // все типы интервалов
    property WellIntervalTypes: TGRRWellIntervalTypes read GeTWellIntervalTypes;

    
    
    

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

uses Math, GRRObligationPoster, TypInfo, SysUtils;


{ TMDFacade }

constructor TMainFacade.Create(AOwner: TComponent);
begin
  inherited;
  // настройка соединения с бд
  //DBGates.ServerClassString := 'RiccServer.CommonServer';
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;
  // обязательно также тип клиента прям здесь указать
  //DBGates.ClientAppTypeID := 19;

  // нам нужны только версии фонда лицензионных участков
  VersionFilter := '(CLIENT_APP_TYPE_ID = 16) OR (VERSION_ID = 0)';
  LicenseZoneFilter := '(VCH_SERIA = ' + '''' + 'СЫК'  + '''' + ') AND (LICENSE_TYPE_ID IS NOT NULL)';
end;

destructor TMainFacade.Destroy;
begin
  FreeAndNil(FGRRReportConcreteQueries);
  inherited;
end;

function TMainFacade.GetAllMainNirObligations: TNIRObligations;
begin
  if not Assigned(FMainNirObligations) then
    begin
       FMainNirObligations := TNirObligations.Create;
       FMainNirObligations.Reload('', true);
    end;
    Result := FMainNirObligations;
end;

function TMainFacade.GetAllMeasureUnits: TMeasureUnits;
begin
if not Assigned(FMeasureUnits) then
    begin
       FMeasureUnits := TMeasureUnits.Create;
       FMeasureUnits.Reload('', true);
    end;
    Result := FMeasureUnits;
end;

function TMainFacade.GetAllNirStates: TNIRStates;
begin
  if not Assigned (FNirStates) then
  begin
    FNirStates := TNIRStates.Create;
    FNirStates.Reload('', true);
  end;
  Result := FNirStates;
end;

function TMainFacade.GetAllNirTypes: TNirTypes;
begin
  if not Assigned(FNirTypes) then
  begin
    FNirTypes := TNirTypes.Create;
    FNirTypes.Reload('NIR_TYPE_ID <= 0', true);
  end;
  Result := FNirTypes;
end;

function TMainFacade.GetAllSeisWorkTypes: TSeismWorkTypes;
begin
   if not Assigned(FSeisWorkTypes) then
   begin
     FSeisWorkTypes := TSeismWorkTypes.Create;
     FSeisWorkTypes.Reload('', true);
   end;
   Result := FSeisWorkTypes;
end;

function TMainFacade.GetAllWellCategories: TWellCategories;
begin
  if not Assigned(FWellCategories) then
  begin
    FWellCategories := TWellCategories.Create;
    FWellCategories.Reload('', true);
  end;
  Result := FWellCategories;
end;

function TMainFacade.GetAllWellStates: TStates;
begin
  if not Assigned(FWellStates) then
  begin
    FWellStates := TStates.Create;
    FWellStates.Reload('',true);
    end;
    Result := FWellStates;

end;

function TMainFacade.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
begin
  Result := inherited GetDataPosterByClassType(ADataPosterClass);
  if Result is TBaseObligationDataPoster then
  begin
    (Result as TBaseObligationDataPoster).AllNirTypes := AllNirTypes;
    (Result as TBaseObligationDataPoster).AllNirStates := AllNirStates;
  end;


  if Result is TNIRDataPoster then
  begin
    (Result as TNIRDataPoster).AllMeasureUnits := AllMeasureUnits;
    //(Result as TNIRDataPoster).AllMainNirObligations := AllMainNirObligations;
  end
  else if Result is TSeismicObligationDataPoster then
  begin
    (Result as TSeismicObligationDataPoster).AllSeismWorkTypes := AllSeisWorkTypes;
  end
  else if Result is TDrillingObligationDataPoster then
  begin
    (Result as TDrillingObligationDataPoster).AllWellStates := AllWellStates;
    (Result as TDrillingObligationDataPoster).AllWellCategories := AllWellCategories;
  end
  else if Result is TNirObligationPlaceDataPoster then
  begin
    (Result as TNirObligationPlaceDataPoster).AllStructures := AllStructures;
  end
  else if Result is TSeismicObligationPlaceDataPoster then
  begin
     (Result as TSeismicObligationPlaceDataPoster).AllAreas := AllAreas;
     (Result as TSeismicObligationPlaceDataPoster).AllStructures := AllStructures;
  end
  else if Result is TDrillingObligationWellDataPoster then
  begin
    (Result as TDrillingObligationWellDataPoster).AllNirStates := AllNirStates;
    (Result as TDrillingObligationWellDataPoster).AllWells := AllWells;
    (Result as TDrillingObligationWellDataPoster).AllStructures := AllStructures;
  end ;

end;

function TMainFacade.GetGRRParamGroups: TGRRParamGroups;
begin
  if not Assigned(FParamGroups) then
  begin
    FParamGroups := TGRRParamGroups.Create;
    FParamGroups.Reload('', true);
  end;

  Result := FParamGroups;
end;

function TMainFacade.GetGRRReportConcreteQueries: TGRRReportConcreteQueries;
begin
  if not Assigned(FGRRReportConcreteQueries) then
     FGRRReportConcreteQueries := TGRRReportConcreteQueries.Create;

  Result := FGRRReportConcreteQueries;
end;

function TMainFacade.GetGRRReportGISXLQueries: TGRRReportGISXLQueries;
begin
  if not Assigned(FGRRReportGISExcelQueries) then
     FGRRReportGISExcelQueries := TGRRReportGISXLQueries.Create;

  Result := FGRRReportGISExcelQueries;
end;

class function TMainFacade.GetInstance: TMainFacade;
begin
  Result := inherited GetInstance as TMainFacade;
end;

function TMainFacade.GetParameterTypes: TGRRParameterTypes;
begin
  if not Assigned(FParameterTypes) then
  begin
    FParameterTypes := TGRRParameterTypes.Create;
    FParameterTypes.Reload('', true);
  end;

  Result := FParameterTypes;
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


function TMainFacade.GeTWellIntervalTypes: TGRRWellIntervalTypes;
begin
  if not Assigned(FGRRWellItervalTypes) then
  begin
    FGRRWellItervalTypes := TGRRWellIntervalTypes.Create;
    FGRRWellItervalTypes .Reload('', true);
  end;

  Result := FGRRWellItervalTypes;
end;

procedure TMainFacade.SetLicenseZone(const Value: TLicenseZone);
begin
  if FLicenseZOne <> Value then
  begin
    FLicenseZone := Value;
    if Assigned(FOnActiveLicenseZoneChanged) then FOnActiveLicenseZoneChanged(Self);
  end;
end;

end.
