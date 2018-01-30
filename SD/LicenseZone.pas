unit LicenseZone;

interface

uses Registrator, BaseObjects, ComCtrls, Classes, Variants, Organization,
     SysUtils, Area, MeasureUnits, GRRParameter, District,
     NGDR, GRRObligation, Well;

type
  TLicenseConditionKind = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TLicenseConditionKinds = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TLicenseConditionKind;
  public
    property Items[Index: integer]: TLicenseConditionKind read GetItems;
    constructor Create; override;
  end;

  TLicenseConditionType = class(TRegisteredIDObject)
  private
    FHasRelativeDate: boolean;
    FBoundingDates: boolean;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
  public
    property    HasRelativeDate: boolean read FHasRelativeDate write FHasRelativeDate;
    property    BoundingDates: boolean read FBoundingDates write FBoundingDates;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TLicenseConditionTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TLicenseConditionType;
  public
    property Items[Index: integer]: TLicenseConditionType read GetItems;
    constructor Create; override;
  end;

  TLicenseCondition = class(TRegisteredIDObject)
  private
    FIsDefault: boolean;
    FDaysAfterRegistration: integer;
    FLicenseConditionKind: TLicenseConditionKind;
    FLicenseConditionType: TLicenseConditionType;
    FMeasureUnit: TMeasureUnit;
    FHasVolume: boolean;
    FNonPeriodic: boolean;
    FHasRelativeDate: boolean;
    FDateMeasureUnit: TMeasureUnit;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
  public
    // единица измерения
    property VolumeMeasureUnit: TMeasureUnit read FMeasureUnit write FMeasureUnit;
    property DateMeasureUnit: TMeasureUnit read FDateMeasureUnit write FDateMeasureUnit;
    // тип условия
    property LicenseConditionKind: TLicenseConditionKind read FLicenseConditionKind write FLicenseConditionKind;
    // вид условия
    property LicenseConditionType: TLicenseConditionType read FLicenseConditionType write FLicenseConditionType;
    // относительный срок с даты регистрации
    property DaysAfterRegistration: integer read FDaysAfterRegistration write FDaysAfterRegistration;
    // условие, применяемое по умолчанию
    property IsDefault: boolean read FIsDefault write FIsDefault;
    // одно значение на весь период владения
    property NonPeriodic: boolean read FNonPeriodic write FNonPeriodic;
    // имеет объем (а не только сроки)
    property HasVolume: boolean read FHasVolume write FHasVolume;
    // имеет относительную дату
    property HasRelativeDate: boolean read FHasRelativeDate write FHasRelativeDate;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TLicenseConditions = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TLicenseCondition;
  public
    property Items[Index: integer]: TLicenseCondition read GetItems;
    constructor Create; override;
  end;

  TLicenseConditionValue = class(TRegisteredIDObject)
  private
    FDateAfterRegistration: integer;
    FStartVolume: single;
    FFinishVolume: single;
    FFinishDateTime: TDateTime;
    FStartDateTime: TDateTime;
    FLicenseCondition: TLicenseCondition;
    FVolumeMeasureUnit: TMeasureUnit;
    FDateMeasureUnit: TMeasureUnit;
    function GetOwnerObject: TIDObject;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
  public
    property LicenseCondition: TLicenseCondition read FLicenseCondition write FLicenseCondition;
    property OwnerObject: TIDObject read GetOwnerObject;
    property StartDate: TDateTime read FStartDateTime write FStartDateTime;
    property FinishDate: TDateTime read FFinishDateTime write FFinishDateTime;
    property VolumeMeasureUnit: TMeasureUnit read FVolumeMeasureUnit write FVolumeMeasureUnit;
    property DateMeasureUnit: TMeasureUnit read FDateMeasureUnit write FDateMeasureUnit;

    property DaysAfterRegistration: integer read FDateAfterRegistration write FDateAfterRegistration;
    property StartVolume: single read FStartVolume write FStartVolume;
    property FinishVolume: single read FFinishVolume write FFinishVolume;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TLicenseConditionValues = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TLicenseConditionValue;
  public
    procedure Reload; override;
    property Items[Index: integer]: TLicenseConditionValue read GetItems;
    constructor Create; override;
  end;

  TLicenseZoneType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TLicenseZoneTypes = class(TRegisteredIDObjects)
  public
    constructor Create; override;
  end;

  TLicenseType = class(TRegisteredIDObject)
  public

  end;

  TLicense = class(TRegisteredIDObject)
  private
    FLicenseZoneNum: string;
    FRegistrationStartDate: TDateTime;
    FRegistrationFinishDate: TDateTime;
    FSeria: string;
    FLicenseTitle: string;
    FDocHolderDate: TDateTime;
    FDocHolder: string;
    FIssuerSubject: string;
    //FSiteHolderOrganization: TOrganization;
    FOwnerOrganization: TOrganization;
    FDeveloperOrganization: TOrganization;
    FIssuer: TOrganization;
    FLicenzeZoneType: TLicenseZoneType;
    FLicenzeType: TLicenseType;
    FNirObligations: TNirObligations;
    FSeismicObligations: TSeismicObligations;
    FDrillObligations: TDrillObligations;

  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
    function GetAllNirObligations: TNirObligations; virtual;
    function GetAllSeismicObligations: TSeismicObligations; virtual;
    function GetAllDrillObligations: TDrillObligations; virtual;
    function GetLicenseId: integer; virtual;
    procedure SetLicenseID(const Value: integer); virtual;
    function GetLicenseName: string; virtual;
    procedure SetLicenseName(const Value: string); virtual;
  public
    property  LicenseZoneNum: string read FLicenseZoneNum write FLicenseZoneNum;

    property  OwnerOrganization: TOrganization read FOwnerOrganization write FOwnerOrganization;
    property  DeveloperOrganization: TOrganization read FDeveloperOrganization write FDeveloperOrganization;
    //property  SiteHolderOrganization: TOrganization read FSiteHolderOrganization write FSiteHolderOrganization;

    property  DocHolderDate: TDateTime read FDocHolderDate write FDocHolderDate;
    property  DocHolder: string read FDocHolder write FDocHolder;

    property  Issuer: TOrganization read FIssuer write FIssuer;
    property  IssuerSubject: string read FIssuerSubject write FIssuerSubject;


    property  LicenseID: integer read GetLicenseId write SetLicenseID;
    property  LicenseName: string read GetLicenseName write SetLicenseName; 

    property  LicenzeZoneType: TLicenseZoneType read FLicenzeZoneType write FLicenzeZoneType;
    property  LicenzeType: TLicenseType read FLicenzeType write FLicenzeType;

    property  LicenseTitle: string read FLicenseTitle write FLicenseTitle;

    property  RegistrationStartDate: TDateTime read FRegistrationStartDate write FRegistrationStartDate;
    property  RegistrationFinishDate: TDateTime read FRegistrationFinishDate write FRegistrationFinishDate;

    // три коллекции облигэйшенов
    property AllNirObligations: TNirObligations read GetAllNirObligations;
    property AllSeismicObligations: TSeismicObligations read GetAllSeismicObligations;
    property AllDrillObligations: TDrillObligations read GetAllDrillObligations;

    procedure ClearDrillObligations;
    procedure ClearSeismicObligations;
    procedure ClearNirObligations;

    property  Seria: string read FSeria write FSeria;

    function  List(AListOption: TListOption = loBrief): string; override;
  end;


  TLicenseZoneOwnedWells = class(TWells)
  public
    constructor Create; override;
  end;


  TSimpleLicenseZone = class(TLicense)
  private
    FWells: TLicenseZoneOwnedWells;
    FAreas: TAreas;
    FWellGRRParameterValues: TLicenseZoneWellGRRParameterValueSets;
    FReworkSeismicReports: TGRRSeisimicReports;
    FGRRDocuments: TGRRDocuments;
    FGRRReservesRecount: TGRRReservesRecountDocuments;
    FNGDR: TNGDR;    

    function   GetLicenseZoneName: string;
    function   GetWells: TLicenseZoneOwnedWells;
    function   GetAreas: TAreas;
    function   GetWellGRRParameterValues: TLicenseZoneWellGRRParameterValueSets;
    function   GetGRRParametersReworkSeismicReports: TGRRSeisimicReports;
    function   GetNIRGRRPrograms: TGRRDocuments;
    function   GetNIRReservesRecount: TGRRDocuments;
  protected
    procedure  AssignTo(Dest: TPersistent); override;
  public
    property    LicenseZoneName: string read GetLicenseZoneName;
    property    Wells: TLicenseZoneOwnedWells read GetWells;
    // параметры ГРР
    property    WellGRRParameterValues: TLicenseZoneWellGRRParameterValueSets read GetWellGRRParameterValues;
    // отчеты о сейсморазведочных работах
    property    ReworkSesimicReports: TGRRSeisimicReports read GetGRRParametersReworkSeismicReports;
    // отчеты о НИР - программы ГРР
    property    NIRGRRPrograms: TGRRDocuments read GetNIRGRRPrograms;
    // оотчеты о НИР - подсчет запасов
    property    NIRReservesRecount: TGRRDocuments read GetNIRReservesRecount;
    // НГДР
    property    NGDR: TNGDR read FNGDR write FNGDR;


    procedure   RefreshWells;
    procedure   RefreshSeismicReports;

    property    Areas: TAreas read GetAreas;
    function    List(AListOption: TListOption = loBrief): string; override;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TSimpleLicenseZones = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: integer): TSimpleLicenseZone;
  public
    function    OrganizationList: string;
    property    Items[const Index: integer]: TSimpleLicenseZone read GetItems;

    function    Add: TSimpleLicenseZone; reintroduce; overload;

    procedure   SortByLicenseTypeAndNum;

    constructor Create; override;
  end;

  TLicenseZone = class(TSimpleLicenseZone)
  private
    FDistrictID: integer;
    FLicenseZoneStateID: integer;
    FDepthFrom: single;
    FDepthTo: single;
    FArea: single;
    FLicenseZoneState: string;
    FVchDistrict: string;
    FLicense: TLicense;
    FPetrolRegionID: integer;
    FPetrolRegion: string;
    FTectonicStructID: integer;
    FTectonicStruct: string;
    FCompetitionID: integer;
    FCompetitionDate: TDateTime;
    FCompetitionName: string;
    FLicenseID: integer;
    FLicenseName: string;
    function GetLicense: TLicense;
    function GetRegistrationFinishDate: TDateTime;
    function GetRegistrationStartDate: TDateTime;
    function GetDistrict: TDistrict;
  protected
    // присвоить
    procedure AssignTo(Dest: TPersistent); override;
    function GetLicenseId: integer; override;
    procedure SetLicenseID(const Value: integer); override;
    function GetLicenseName: string; override;
    procedure SetLicenseName(const Value: string); override;

  public
    property  LicenseZoneStateID: integer read FLicenseZoneStateID write FLicenseZoneStateID;
    property  LicenseZoneState: string read FLicenseZoneState write FLicenseZoneState;

    property  DistrictID: integer read FDistrictID write FDistrictID;
    property  VchDistrict: string read FVchDistrict write FVchDistrict;
    property  District: TDistrict read GetDistrict;

    property  PetrolRegionID: integer read FPetrolRegionID write FPetrolRegionID;
    property  PetrolRegion: string read FPetrolRegion write FPetrolRegion;

    property  TectonicStructID: integer read FTectonicStructID write FTectonicStructID;
    property  TectonicStruct: string read FTectonicStruct write FTectonicStruct;


    property  RegistrationStartDate: TDateTime read GetRegistrationStartDate;
    property  RegistrationFinishDate: TDateTime read GetRegistrationFinishDate;


    property  Area: single read FArea write FArea;
    property  DepthFrom: single read FDepthFrom write FDepthFrom;
    property  DepthTo: single read FDepthTo write FDepthTo;

    property  CompetitionID: integer read FCompetitionID write FCompetitionID;
    property  CompetitionName: string read FCompetitionName write FCompetitionName;
    property  CompetitionDate: TDateTime read FCompetitionDate write FCompetitionDate;

    property  License: TLicense read GetLicense;





    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;

    function    List(AListOption: TListOption = loBrief): string; override;
    procedure   Accept(Visitor: IVisitor); override;
  end;

  TLicenseZones = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: integer): TLicenseZone;
  public
    property Items[const Index: integer]: TLicenseZone read GetItems;

    function  GetLicenseZoneByNumber(const ANumber: string): TLicenseZone;
    function  Add: TLicenseZone; reintroduce; overload;

    { TODO : Правила сортировки }
    procedure SortByName;
    procedure SortByLicenseNumber;
    procedure SortByDistrict;
    procedure SortByPetrolRegion;
    procedure SortByNGO;
    procedure SortByOrganization;
    procedure SortByTectStruct;
    procedure SortByLicenseType;
    procedure SortByLicenseZoneType;

    constructor Create; override;
  end;

  TGRRLicenseZone = class(TLicenseZone)
  public
    function    List(AListOption: TListOption = loBrief): string; override;
  end;

  TGRRLicenseZones = class(TLicenseZones)
  private
    function    GetItems(const Index: integer): TGRRLicenseZone;
  public
    property    Items[const Index: integer]: TGRRLicenseZone read GetItems;
  end;
//{$DEFINE LIC}
//{$DEFINE STRUCT}

implementation

uses LicenseZonePoster, Facade, Contnrs, BaseConsts, StringUtils
{$IFDEF LIC}
, RRManagerObjects
{$ENDIF}
;


function LicenseTypeAndNumSort(Item1, Item2: Pointer): integer;
var l1, l2: TSimpleLicenseZone;
begin
  l1 := TSimpleLicenseZone(Item1);
  l2 := TSimpleLicenseZone(Item2);

  Result := 0;
  if Assigned(l1.LicenzeZoneType) and Assigned(l2.LicenzeZoneType) then
    Result := -CompareStr(l1.LicenzeZoneType.Name, l2.LicenzeZoneType.Name);
  if Result = 0 then Result := CompareStr(l1.LicenseZoneNum, l2.LicenseZoneNum);
end;

{ TLicenseZones }

function TLicenseZones.Add: TLicenseZone;
begin
  Result := Inherited Add As TLicenseZone;
end;


constructor TLicenseZones.Create;
begin
  inherited;
  FObjectClass := TLicenseZone;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseZonePoster];
end;

function TLicenseZones.GetItems(const Index: integer): TLicenseZone;
begin
  Result := inherited Items[Index] as TLicenseZone;
end;

function TSimpleLicenseZones.OrganizationList: string;
var i: integer;
begin
  Result := '';

  for i := 0 to Count - 1 do
  if Assigned(Items[i].OwnerOrganization) then 
    Result := Result + Items[i].OwnerOrganization.List() + '; ';

  Result := trim(Result);   
end;


function TLicenseZones.GetLicenseZoneByNumber(
  const ANumber: string): TLicenseZone;
var i: integer;
    sLNumber, sRNumber: string;
begin
  Result := nil;
  sLNumber := PadSymbolL(Trim(ANumber), '0', 10);
  for i := 0 to Count - 1 do
  begin
    sRNumber := PadSymbolL(Trim(Items[i].LicenseZoneNum), '0', 10);
    if sLNumber = sRNumber then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

procedure TLicenseZones.SortByDistrict;
begin

end;

procedure TLicenseZones.SortByLicenseNumber;
begin

end;

procedure TLicenseZones.SortByLicenseType;
begin

end;

procedure TLicenseZones.SortByLicenseZoneType;
begin

end;

procedure TLicenseZones.SortByName;
begin

end;

procedure TLicenseZones.SortByNGO;
begin

end;

procedure TLicenseZones.SortByOrganization;
begin

end;

procedure TLicenseZones.SortByPetrolRegion;
begin

end;

procedure TLicenseZones.SortByTectStruct;
begin

end;



{ TLicenseZone }


procedure TLicenseZone.Accept(Visitor: IVisitor);
begin
  inherited;
  IVisitor(Visitor).VisitTestInterval(Self);
end;

procedure TLicenseZone.AssignTo(Dest: TPersistent);
var lz: TLicenseZone;
begin
  lz := Dest as TLicenseZone;

  lz.LicenseZoneStateID := LicenseZoneStateID;
  lz.LicenseZoneState := LicenseZoneState;

  lz.DepthFrom := DepthFrom;
  lz.DepthTo := DepthTo;
  lz.Area := Area;

  lz.DistrictID := DistrictID;
  lz.VchDistrict := VchDistrict;

//  lz.LicenseZoneName := LicenseZoneName;
  lz.CompetitionID := CompetitionID;
  lz.CompetitionDate := CompetitionDate;
  lz.License.Assign(License);
end;

constructor TLicenseZone.Create(ACollection: TIDObjects); 
begin
  inherited;
  ClassIDString := 'Лицензионнный участок';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseZonePoster];
end;


destructor TLicenseZone.Destroy;
begin
  if Assigned(FLicense) then FLicense.Free;
  inherited;
end;



function TLicenseZone.GetDistrict: TDistrict;
begin
  Result := nil;

  if Assigned (TMainFacade.GetInstance.AllDistricts.ItemsByID[DistrictID]) then
    Result := TMainFacade.GetInstance.AllDistricts.ItemsByID[DistrictID] as TDistrict;
end;

function TLicenseZone.GetLicense: TLicense;
begin
  Result := Self;
end;


function TLicenseZone.GetLicenseId: integer;
begin
  Result := FLicenseID;
end;

function TLicenseZone.GetLicenseName: string;
begin
  Result := FLicenseName;
end;

function TLicenseZone.GetRegistrationFinishDate: TDateTime;
begin
  Result := License.RegistrationFinishDate;
end;

function TLicenseZone.GetRegistrationStartDate: TDateTime;
begin
  Result := License.RegistrationStartDate;
end;



function TLicenseZone.List(AListOption: TListOption = loBrief): string;
begin
  if trim(LicenseZoneNum) <> '' then
    Result := Trim(LicenseZoneName) + ' (Номер лицензии: '  + Trim(LicenseZoneNum)
  else Result := Trim(LicenseZoneName) + ' (Номер лицензии: <не указан>';

  if Assigned(OwnerOrganization) then
    Result := Result +  ';' + ' Владелец лицензии: ' + OwnerOrganization.List + ')'
  else
    Result := Result + ')';
end;


procedure TLicenseZone.SetLicenseID(const Value: integer);
begin
  FLicenseID := Value;
end;

procedure TLicenseZone.SetLicenseName(const Value: string);
begin
  FLicenseName := Value;
end;

{ TLicense }

procedure TLicense.AssignTo(Dest: TPersistent);
var l: TLicense;
begin
  inherited;

  l := Dest as TLicense;

  l.OwnerOrganization := OwnerOrganization;
  l.DeveloperOrganization := DeveloperOrganization;
  //l.SiteHolderOrganization := SiteHolderOrganization;

  l.DocHolderDate := DocHolderDate;

  l.LicenseZoneNum := LicenseZoneNum;
  l.LicenseTitle := LicenseTitle;
  l.Seria := Seria;

  l.LicenzeZoneType := LicenzeZoneType;
  l.LicenzeType := LicenzeType;

  l.RegistrationStartDate := RegistrationStartDate;
  l.RegistrationFinishDate := RegistrationFinishDate;
end;


procedure TLicense.ClearDrillObligations;
begin
  FreeAndNil(FDrillObligations);
end;

procedure TLicense.ClearNirObligations;
begin
  FreeAndNil(FNirObligations);
end;

procedure TLicense.ClearSeismicObligations;
begin
  FreeAndNil(FSeismicObligations);
end;

function TLicense.GetAllDrillObligations: TDrillObligations;
begin
  if not Assigned(FDrillObligations) then
  begin
    FDrillObligations := TDrillObligations.Create;
    FDrillObligations.Owner := Self;
    FDrillObligations.Reload(Format('(LICENSE_ID = %d) and (Version_ID = %d)',[LicenseId, TMainFacade.GetInstance.ActiveVersion.ID]), true);
    FDrillObligations.Sort;
  end;
  Result:= FDrillObligations;
end;

function TLicense.GetAllNirObligations: TNirObligations;
begin
   if not Assigned(FNirObligations) then
  begin
    FNirObligations := TNIRObligations.Create;
    FNirObligations.Owner := Self;
    FNirObligations.Reload(Format('(LICENSE_ID = %d) and (Version_ID = %d)',[LicenseId, TMainFacade.GetInstance.ActiveVersion.ID]), true);
    FNirObligations.Sort;
  end;
  result:= FNirObligations;

end;

function TLicense.GetAllSeismicObligations: TSeismicObligations;
begin
    if not Assigned(FSeismicObligations) then
  begin
    FSeismicObligations := TSeismicObligations.Create;
    FSeismicObligations.Owner := Self;
    FSeismicObligations.Reload(Format('(LICENSE_ID = %d) and (Version_ID = %d)',[LicenseId, TMainFacade.GetInstance.ActiveVersion.ID]),  true);
    FSeismicObligations.Sort;
  end;
  result := FSeismicObligations;
end;

function TLicense.GetLicenseId: integer;
begin
  Result := ID;
end;

function TLicense.GetLicenseName: string;
begin
  Result := Name;
end;

function TLicense.List(AListOption: TListOption = loBrief): string;
begin
  Result := LicenseZoneNum;
end;

procedure TLicense.SetLicenseID(const Value: integer);
begin
  ID := Value;
end;

procedure TLicense.SetLicenseName(const Value: string);
begin
  Name := Value;
end;

{ TSimpleLicenseZones }

function TSimpleLicenseZones.Add: TSimpleLicenseZone;
begin
  Result := inherited Add as TSimpleLicenseZone;
end;

constructor TSimpleLicenseZones.Create;
begin
  inherited;
  FObjectClass := TSimpleLicenseZone;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSimpleLicenseZonePoster];

  OwnsObjects := true;
end;

function TSimpleLicenseZones.GetItems(
  const Index: integer): TSimpleLicenseZone;
begin
  Result := inherited Items[Index] as TSimpleLicenseZone;
end;

procedure TSimpleLicenseZones.SortByLicenseTypeAndNum;
begin
  Sort(LicenseTypeAndNumSort);
end;

{ TSimpleLicenseZone }

procedure TSimpleLicenseZone.AssignTo(Dest: TPersistent);
var lz: TSimpleLicenseZone;
begin
  inherited;

  lz := Dest as TSimpleLicenseZone;
  lz.LicenseZoneNum := LicenseZoneNum;
end;

constructor TSimpleLicenseZone.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Лицензионный участок';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSimpleLicenseZonePoster];
end;

destructor TSimpleLicenseZone.Destroy;
begin
  FreeAndNil(FWellGRRParameterValues);
  FreeAndNil(FWells);
  FreeAndNil(FGRRDocuments);
  inherited;
end;

function TSimpleLicenseZone.GetAreas: TAreas;
begin
  if not Assigned (FAreas) then
  begin
    FAreas := TAreas.Create;
    FAreas.Owner := Self;
    //FAreas.Reload('LICENSE_ZONE_ID = ' + inttostr(ID));
  end;

  Result := FAreas;
end;

function TSimpleLicenseZone.GetNIRGRRPrograms: TGRRDocuments;
begin
  if not Assigned(FGRRDocuments) then
  begin
    FGRRDocuments := TGRRDocuments.Create;
    FGRRDocuments.Owner := Self;
    FGRRDocuments.Reload;
  end;
  Result := FGRRDocuments;
end;

function TSimpleLicenseZone.GetGRRParametersReworkSeismicReports: TGRRSeisimicReports;
begin
  if not Assigned(FReworkSeismicReports) then
  begin
    FReworkSeismicReports := TGRRSeisimicReports.Create;
    FReworkSeismicReports.Owner := Self;
    FReworkSeismicReports.OwnsObjects := true;
    FReworkSeismicReports.Reload;
  end;
  Result := FReworkSeismicReports;
end;

function TSimpleLicenseZone.GetLicenseZoneName: string;
begin
  Result := Name;
end;

function TSimpleLicenseZone.GetWellGRRParameterValues: TLicenseZoneWellGRRParameterValueSets;
begin
  if not Assigned(FWellGRRParameterValues) then
  begin
    FWellGRRParameterValues := TLicenseZoneWellGRRParameterValueSets.Create;
    FWellGRRParameterValues.Owner := Self;
    FWellGRRParameterValues.Reload;
  end;

  Result := FWellGRRParameterValues;
end;

function TSimpleLicenseZone.GetWells: TLicenseZoneOwnedWells;
begin
  if not Assigned (FWells) then
  begin
    FWells := TLicenseZoneOwnedWells.Create;
    FWells.Owner := Self;
    FWells.Reload('LICENSE_ZONE_ID = ' + IntToStr(ID));
    FWells.Sort;
  end;

  Result := FWells;
end;

function TSimpleLicenseZone.List(AListOption: TListOption): string;
begin
  if Assigned (FLicenzeZoneType) then
    Result := FLicenseZoneNum + ' ' + FLicenzeZoneType.ShortName + ' ' + FName
  else Result := FLicenseZoneNum + ' ' + FName;
end;

procedure TSimpleLicenseZone.RefreshSeismicReports;
begin
  //ReworkSesimicReports.Reload;
  ReworkSesimicReports.Refresh;
end;

procedure TSimpleLicenseZone.RefreshWells;
begin
  FreeAndNil(FWells);
  FreeAndNil(FWellGRRParameterValues);
  Wells;
end;

function TSimpleLicenseZone.GetNIRReservesRecount: TGRRDocuments;
begin
  if not Assigned(FGRRReservesRecount) then
  begin
    FGRRReservesRecount := TGRRReservesRecountDocuments.Create;
    FGRRReservesRecount.Owner := Self;
    FGRRReservesRecount.Reload;
  end;
  Result := FGRRReservesRecount;
end;

{ TLicenseZoneType }

constructor TLicenseZoneType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип лицензионного участка';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseZoneTypePoster];
end;

destructor TLicenseZoneType.Destroy;
begin

  inherited;
end;

{ TLicenseZoneTypes }

constructor TLicenseZoneTypes.Create;
begin
  inherited;
  FObjectClass := TLicenseZoneType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseZoneTypePoster];
end;

{ TLicenseCondition }

procedure TLicenseCondition.AssignTo(Dest: TPersistent);
var lc: TLicenseCondition;
begin
  inherited;

  lc := Dest as TLicenseCondition;

  lc.IsDefault := IsDefault;
  lc.DaysAfterRegistration := DaysAfterRegistration;
  lc.LicenseConditionKind := LicenseConditionKind;
  lc.LicenseConditionType := LicenseConditionType;
  lc.VolumeMeasureUnit := VolumeMeasureUnit;
  lc.DateMeasureUnit := DateMeasureUnit;
  lc.NonPeriodic := NonPeriodic;
  lc.HasVolume := HasVolume;
  lc.HasRelativeDate := HasRelativeDate;
end;

constructor TLicenseCondition.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Условия и ограничения пользования недрами';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseConditionPoster];
end;

destructor TLicenseCondition.Destroy;
begin

  inherited;
end;

{ TLicenseConditions }

constructor TLicenseConditions.Create;
begin
  inherited;
  FObjectClass := TLicenseCondition;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseConditionPoster];
end;

function TLicenseConditions.GetItems(Index: integer): TLicenseCondition;
begin
  Result := inherited Items[Index] as TLicenseCondition;
end;

{ TLicenseConditionType }

procedure TLicenseConditionType.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TLicenseConditionType).HasRelativeDate := HasRelativeDate;
  (Dest as TLicenseConditionType).BoundingDates := BoundingDates;
end;

constructor TLicenseConditionType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип условия';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseConditionTypePoster];
end;

{ TLicenseConditionTypes }

constructor TLicenseConditionTypes.Create;
begin
  inherited;
  FObjectClass := TLicenseConditionType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseConditionTypePoster];
end;

function TLicenseConditionTypes.GetItems(
  Index: integer): TLicenseConditionType;
begin
  Result := inherited Items[Index] as TLicenseConditionType;
end;

{ TLicenseConditionKinds }

constructor TLicenseConditionKinds.Create;
begin
  inherited;
  FObjectClass := TLicenseConditionKind;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseConditionKindPoster];
end;

function TLicenseConditionKinds.GetItems(
  Index: integer): TLicenseConditionKind;
begin
  Result := inherited Items[Index] as TLicenseConditionKind;
end;

{ TLicenseConditionKind }

constructor TLicenseConditionKind.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Вид условия';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseConditionTypePoster];
end;

{ TLicenseConditionValue }

procedure TLicenseConditionValue.AssignTo(Dest: TPersistent);
var lcv: TLicenseConditionValue;
begin
  inherited;

  lcv := Dest as TLicenseConditionValue;

  lcv.DateMeasureUnit := DateMeasureUnit;
  lcv.StartVolume := StartVolume;
  lcv.FinishVolume := FinishVolume;
  lcv.StartDate := StartDate;
  lcv.FinishDate := FinishDate;
  lcv.LicenseCondition := LicenseCondition;
  lcv.VolumeMeasureUnit := VolumeMeasureUnit;
  lcv.DaysAfterRegistration := DaysAfterRegistration;
end;

constructor TLicenseConditionValue.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'значение ограничения по лицензионному соглашению';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseConditionValuePoster];
  {$IFDEF LIC}
  StartDate := (Owner as TOldLicenseZone).License.RegistrationStartDate;
  FinishDate := (Owner as TOldLicenseZone).License.RegistrationFinishDate;
  {$ENDIF}  
end;

destructor TLicenseConditionValue.Destroy;
begin

  inherited;
end;

function TLicenseConditionValue.GetOwnerObject: TIDObject;
begin
  Result := Collection.Owner;
end;

{ TLicenseConditionValues }

constructor TLicenseConditionValues.Create;
begin
  inherited;
  FObjectClass := TLicenseConditionValue;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TLicenseConditionValuePoster];
end;

function TLicenseConditionValues.GetItems(
  Index: integer): TLicenseConditionValue;
begin
  Result := inherited Items[Index] as TLicenseConditionValue;
end;

procedure TLicenseConditionValues.Reload;
begin
  Reload('License_Zone_ID = ' + IntToStr(Owner.ID));
  inherited;
end;

{ TLicenseZoneOwnedWells }

constructor TLicenseZoneOwnedWells.Create;
begin
  inherited;

end;

{ TGRRLicenseZones }

function TGRRLicenseZones.GetItems(const Index: integer): TGRRLicenseZone;
begin
  Result := inherited Items[index] as TGRRLicenseZone;
end;

{ TGRRLicenseZone }

function TGRRLicenseZone.List(AListOption: TListOption): string;
begin
  Result := LicenseZoneNum + ' ' + LicenzeZoneType.ShortName + ' ' + LicenseZoneName;
end;

end.
