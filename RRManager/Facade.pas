unit Facade;

interface

uses BaseFacades, Registrator, Classes, DBGate, SDFacade, ComCtrls, RRManagerObjects,
     RRManagerPersistentObjects, LicenseZone, BaseObjects, Load, ClientDicts;

  {$DEFINE LIC}
  //{$DEFINE STRUCT}

type


  TMainFacade = class (TSDFacade)
  private
    FActiveVersion: TOldVersion;
    FAllLicenseZones: TOldLicenseZones;
    FAllStructures: TOldStructures;
    FAllVersions: TOldVersions;
    FAreaListItems: TListItems;
    FDataPosters: RRManagerPersistentObjects.TDataPosters;
    FLicenseConditionTypes: TLicenseConditionTypes;
    FLicenseConditionKinds: TLicenseConditionKinds;
    FLicenseConditions: TLicenseConditions;
    function GetAllStructures: TOldStructures;
    function GetAllVersions: TOldVersions;
    function GetDataPosters: RRManagerPersistentObjects.TDataPosters;
    function GetAllLicenseConditionKinds: TLicenseConditionKinds;
    function GetAllLicenseConditionTypes: TLicenseConditionTypes;
    function GetAllLicenseConditions: TLicenseConditions;
    function GetAllOldLicenseZones: TOldLicenseZones;
  protected
    function GetDataPosterByClassType(ADataPosterClass: TDataPosterClass): TDataPoster; override;
  public
    property AreaListItems: TListItems read FAreaListItems;
    property AllStructures: TOldStructures read GetAllStructures;
    property AllOldLicenseZones: TOldLicenseZones read GetAllOldLicenseZones;
    property AllVersions: TOldVersions read GetAllVersions;
    property AllPosters: RRManagerPersistentObjects.TDataPosters read GetDataPosters;

    property AllLicenseConditionTypes: TLicenseConditionTypes read GetAllLicenseConditionTypes;
    property AllLicenseConditionKinds: TLicenseConditionKinds read GetAllLicenseConditionKinds;
    property AllLicenseConditions: TLicenseConditions read GetAllLicenseConditions;


    procedure LoadDicts;
    // в конструкторе создаются и настраиваются всякие
    // необходимые в скором времени вещи
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

uses SysUtils, LicenseZonePoster;

{ TMainFacade }

constructor TMainFacade.Create(AOwner: TComponent);
begin
  inherited;
  // настройка соединения с бд
  //DBGates.ServerClassString := 'RiccServerTest.CommonServerTest';
  //DBGates.ServerClassString := 'RiccServer.CommonServer';
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;
  // обязательно также тип клиента прям здесь указать
  {$IFDEF STRUCT}
  ClientAppTypeID := 13;
  {$ENDIF}
  {$IFDEF LIC}
  ClientAppTypeID := 16;
  {$ENDIF}
end;

destructor TMainFacade.Destroy;
begin
  FreeAndNil(FAllLicenseZones);
  FreeAndNil(FAllStructures);
  FreeAndNil(FAllVersions);
  inherited;
end;


function TMainFacade.GetAllLicenseConditionKinds: TLicenseConditionKinds;
begin
  if not Assigned(FLicenseConditionKinds) then
  begin
    FLicenseConditionKinds := TLicenseConditionKinds.Create;
    FLicenseConditionKinds.Reload('', true);
    FLicenseConditionKinds.OwnsObjects := true;
  end;

  Result := FLicenseConditionKinds;
end;

function TMainFacade.GetAllLicenseConditions: TLicenseConditions;
begin
  if not Assigned(FLicenseConditions) then
  begin
    FLicenseConditions := TLicenseConditions.Create;
    FLicenseConditions.Reload('', true);
    FLicenseConditions.OwnsObjects := true;
  end;

  Result := FLicenseConditions;
end;

function TMainFacade.GetAllLicenseConditionTypes: TLicenseConditionTypes;
begin
  if not Assigned(FLicenseConditionTypes) then
  begin
    FLicenseConditionTypes := TLicenseConditionTypes.Create;
    FLicenseConditionTypes.Reload('', true);
    FLicenseConditionTypes.OwnsObjects := true;
  end;

  Result := FLicenseConditionTypes;
end;

function TMainFacade.GetAllOldLicenseZones: TOldLicenseZones;
begin
  if Not Assigned(FAllLicenseZones) then
    FAllLicenseZones := TOldLicenseZones.Create(nil);

  Result := FAllLicenseZones;
end;


function TMainFacade.GetAllStructures: TOldStructures;
begin
  if not Assigned(FAllStructures) then
    FAllStructures := TOldStructures.Create(nil);
  Result := FAllStructures;
end;

function TMainFacade.GetAllVersions: TOldVersions;
begin
  if not Assigned(FAllVersions) then
    FAllVersions := TOldVersions.Create(nil);
  Result := FAllVersions;
end;


function TMainFacade.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
begin
  Result := inherited GetDataPosterByClassType(ADataPosterClass);

  if Result is TLicenseConditionPoster then
  begin
    (Result as TLicenseConditionPoster).AllLicenseConditionKinds := AllLicenseConditionKinds;
    (Result as TLicenseConditionPoster).AllLicenseConditionTypes := AllLicenseConditionTypes;
  end
  else if Result is TLicenseConditionValuePoster then
    (Result as TLicenseConditionValuePoster).AllLicenseConditions := AllLicenseConditions;
end;

function TMainFacade.GetDataPosters: RRManagerPersistentObjects.TDataPosters;
begin
  if not Assigned(FDataPosters) then
    FDataPosters := RRManagerPersistentObjects.TDataPosters.Create;

  Result := FDataPosters;
end;

procedure TMainFacade.LoadDicts;
var bLoaded: Boolean;
begin
  bLoaded := false;  
  if not TfrmLoad.GetInstance.Visible then
  begin
    TfrmLoad.GetInstance.Load(aviFindFile, 'Пожалуйста, подождите', 1, 1);
    bLoaded := true;
  end;

  TfrmLoad.GetInstance.MakeStep('Загрузка справочника лицензионных участков');
  AllLicenseZones;

  if bLoaded then
    TfrmLoad.GetInstance.Hide;
end;

end.
