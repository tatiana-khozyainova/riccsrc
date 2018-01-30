unit RRManagerDataPosters;

interface

uses RRManagerObjects, RRManagerPersistentObjects, RRManagerBaseObjects, ClientCommon, SysUtils, Classes
  {$IFDEF VER150}
  , Variants
  {$ENDIF}
  ;


type

  TVersionDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // читает данные для удаления в массив вариантов
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;


  TStructureDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // читает данные для удаления в массив вариантов
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TLicenseZoneDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // читает данные для удаления в массив вариантов
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // получаем значение нового ключа лицензии
    function ExtendedPost(ABaseObject: TBaseObject): integer; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TDiscoveredStructureDataPoster = class(TStructureDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TPreparedStructureDataPoster = class(TStructureDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TDrilledStructureDataPoster = class(TStructureDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TDrilledStructureWellDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // читает данные для удаления в массив вариантов
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; overload; override;
    // читает данные для удаления всех (поверх буду записаны новые)
    function GetDeletingData(ABaseCollection: TBaseCollection): OleVariant; overload; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  // если никакие скважины ещё не приурочены к данному месторождению
  // грузим просто скважины с площади
  TDrilledStructureAreaWellDataPoster = class(TDrilledStructureWellDataPoster)
  protected
    procedure Prepare; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
  end;

  TFieldDataPoster = class(TStructureDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  THorizonDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // читает данные для удаления в массив вариантов
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  THorizonFundTypeDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // читает данные для удаления в массив вариантов
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; overload; override;
    function GetDeletingData(ABaseCollection: TBaseCollection): OleVariant; overload; override;    
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;


  TSubstructureDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // читает данные для удаления в массив вариантов
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TLayerDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // читает данные для удаления в массив вариантов
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; overload; override;
    // читает данные для удаления в массив вариантов
    function GetDeletingData(ABaseCollection: TBaseCollection): OleVariant; overload; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TBedDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // читает данные для удаления в массив вариантов
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TAccountVersionDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // читает данные для удаления в массив вариантов
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; override;
    // читает данные для удаления всех документов
    // связанны с объектом
    function GetDeletingData(ABaseCollection: TBaseCollection): OleVariant; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TResourceDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // удалает записи по номеру документа и ид продуктивного пласта
    // внимание!: в качестве параметра передается набор ресурсов, а не ресурс
    function GetDeletingData(ABaseCollection: TBaseCollection): OleVariant; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TReserveDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // удалает записи по номеру документа и ид продуктивного пласта
    // внимание!: в качестве параметра передается набор запасов, а не единичный элемент
    function GetDeletingData(ABaseCollection: TBaseCollection): OleVariant; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TFieldReserveDataPoster = class(TReserveDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // удалает записи по номеру документа и ид продуктивного пласта
    // внимание!: в качестве параметра передается набор запасов, а не единичный элемент
    function GetDeletingData(ABaseCollection: TBaseCollection): OleVariant; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TParameterDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // удалает записи по номеру документа и ид продуктивного пласта
    // внимание!: в качестве параметра передается набор параметров, а не единичный элемент
    function GetDeletingData(ABaseCollection: TBaseCollection): OleVariant; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;


  THistoryDataPoster = class(TDataPoster)
  private
    procedure InitElement(AHistoryElement: TOldHistoryElement; AIndex: integer; AData: variant);
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TStructureHistoryDataPoster = class(THistoryDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;

  TDocumentDataPoster = class(TDataPoster)
  protected
    procedure Prepare; override;
    // читает данные объекта в массив вариантов
    function GetPostingData(ABaseObject: TBaseObject): OleVariant; override;
    // инициализирует объект
    function GetObject(AData: variant): TBaseCollection; override;
    // удалает записи по номеру документа и ид продуктивного пласта
    // внимание!: в качестве параметра передается набор документов, а не единичный элемент
    function GetDeletingData(ABaseObject: TBaseObject): OleVariant; override;
    // записывает документ на физическое место
    function  ExtendedPost(ABaseObject: TBaseObject): integer; override;    
  public
    function GetProxy(const AUIN: integer): TBaseCollection; override;
  end;


  TConcretePosters = class(TDataPosters)
  public
    constructor Create; override;
  end;

implementation

uses RRManagerCommon, Facade, LicenseZone;

{ TStructureDataPoster }

function TStructureDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := varArrayOf([ABaseObject.ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TStructureDataPoster.GetObject(AData: variant): TBaseCollection;
var i: integer;
    s: TOldStructure;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldStructures.Create(nil)
  else
  if ClearFirst then FLastGotCollection.Clear;


  Result := FLastGotCollection;
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    if not ClearFirst then
      S := (Result as TOldStructures).ItemsByUIN[AData[0, i]] as TOldStructure
    else S := nil;

    if not Assigned(S) then S := (Result as TOldStructures).Add(AData[5, i]);

    S.ID  := AData[0, i];
    S.Name := AData[1, i];

    S.OwnerOrganizationID := AData[2, i];
    S.OwnerOrganization := AData[3, i];

    S.StructureTypeID := AData[5, i];
    S.StructureType := AData[6, i];

    S.AreaID := AData[14, i];
    S.Area := AData[15, i];

    s.CartoHorizonID := AData[18, i];
  end;
end;

function TStructureDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var S: TOldStructure;
    vAreaID, vTectStructID, vDistrictID, vPetrolRegionID, vHorizonID, vOrgID: variant;
begin
 {
     STRUCTURE_ID INTEGER,
    ORGANIZATION_ID INTEGER,
    STRUCTURE_FUND_TYPE_ID INTEGER,
    PETROL_REGION_ID INTEGER,
    STRUCT_ID INTEGER,
    DISTRICT_ID SMALLINT,
    AREA_ID INTEGER,
    VCH_STRUCTURE_NAME VARCHAR(150),
    NUM_OUT_OF_FUND SMALLINT,
    MODIFIER_APP_TYPE_ID SMALLINT,
    EMPLOYEE_ID SMALLINT,
    CARTOGRAPHIC_HORIZON_ID


 }
  S := ABaseObject as TOldStructure;
  // значение NULL для площади
  if s.AreaID = 0 then vAreaID := null
  else vAreaID := s.AreaID;



  if s.CartoHorizonID <= 0 then vHorizonID := null
  else vHorizonID := s.CartoHorizonID;

  if s.OwnerOrganizationID <= 0 then vOrgID := null
  else vOrgID := s.OwnerOrganizationID;

  Result := varArrayOf([S.ID, vOrgID, S.StructureTypeID,
                        vPetrolRegionID,  vTectStructID, vDistrictID,
                        vAreaID, S.Name, ord(S.OutOfFund),
                        TMainFacade.GetInstance.ClientAppTypeID, TMainFacade.GetInstance.DBGates.EmployeeID, vHorizonID,
                        (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TStructureDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
   Result := nil;
end;

procedure TStructureDataPoster.Prepare;
begin
  FObjectClass := TOldStructure;
  FCollectionClass := TOldStructures;
  
  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'vch_Area_Name';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Structure';
  FQuery := 'select structure_id, vch_structure_name, organization_id, ' +
            'vch_org_full_name, vch_org_short_name, structure_fund_type_id, ' +
            'vch_structure_fund_type_name, petrol_region_id, vch_region_full_name, ' +
            'vch_region_short_name, struct_id, vch_struct_full_name, district_id, ' +
            'vch_district_name, area_id, vch_area_name, num_out_of_fund, dtm_entering_date, ' +
            'CARTOGRAPHIC_HORIZON_ID ' +
            'from vw_Structure ';
//             + 'where Version_ID =' + IntToStr(ActiveVersion.ID);
  FKeyColumn := 'Structure_ID';
  FDeletingTable := 'spd_Delete_Structure';
  FOrder := 'vch_Structure_Name';
end;


{ THorizonDataPoster }

function THorizonDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := varArrayOf([AbaseObject.ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function THorizonDataPoster.GetObject(AData: variant): TBaseCollection;
var i: integer;
    h: TOldHorizon;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldHorizons.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin

{
0 STRUCTURE_STRATUM_ID,
1 ORGANIZATION_ID,
2 VCH_ORG_FULL_NAME,
3 VCH_ORG_SHORT_NAME,
4 FIRST_STRATUM_ID,
5 VCH_FIRST_STRATUM_NAME,
6 VCH_FIRST_STRATUM_POSTFIX,
7 SECOND_STRATUM_ID,
8 VCH_SECOND_STRATUM_NAME,
9 VCH_SECOND_STRATUM_POSTFIX,
10 NUM_OUT_OF_FUND,
11 NUM_ACTIVE_FUND,
12 VCH_OUT_OF_FUND_DECISION,
13 COMPLEX_ID,
14 VCH_COMPLEX_NAME,
15 VCH_COMPLEX_SHORT_NAME,
16 VCH_INVESTIGATION_YEAR,
17 VCH_COMMENT
}
    h := (Result as TOldHorizons).Add;
{
0 STRUCTURE_STRATUM_ID,
}
    h.ID  := AData[0, i];

{
1 ORGANIZATION_ID,
2 VCH_ORG_FULL_NAME,
3 VCH_ORG_SHORT_NAME,
}


    h.OrganizationID := AData[1, i];
    h.Organization := AData[2, i];

{
4 FIRST_STRATUM_ID,
5 VCH_FIRST_STRATUM_NAME,
6 VCH_FIRST_STRATUM_POSTFIX,

}
    h.FirstStratumID := AData[4, i];
    h.FirstStratum := AData[5, i];
    h.FirstStratumPostfix := AData[6, i];

{
7 SECOND_STRATUM_ID,
8 VCH_SECOND_STRATUM_NAME,
9 VCH_SECOND_STRATUM_POSTFIX,
}

    h.SecondStratumID := AData[7, i];
    h.SecondStratum := AData[8, i];
    h.SecondStratumPostfix := AData[9, i];

{
10 NUM_OUT_OF_FUND,
}

    h.OutOfFund := AData[10, i];
{
11 NUM_ACTIVE_FUND,
12 VCH_OUT_OF_FUND_DECISION,
}

    h.Active := AData[11, i];
{
13 COMPLEX_ID,
14 VCH_COMPLEX_NAME,
15 VCH_COMPLEX_SHORT_NAME,
}
    h.ComplexID := AData[13, i];
    h.Complex   := AData[14, i];
{
16 VCH_INVESTIGATION_YEAR,
17 VCH_COMMENT
}
    h.InvestigationYear := AData[16, i];
    h.Comment := AData[17, i];
  end;
end;

function THorizonDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var h: TOldHorizon;
    vSecondStratum: variant;
begin
  h := ABaseObject as TOldHorizon;
{
    STRUCTURE_STRATUM_ID INTEGER,
    ORGANIZATION_ID INTEGER,
    TRAP_TYPE_ID INTEGER,
    FIRST_STRATUM_ID SMALLINT,
    SECOND_STRATUM_ID SMALLINT,
    STRUCTURE_ID INTEGER,
    NUM_OUT_OF_FUND SMALLINT,
    NUM_ACTIVE_FUND SMALLINT,
    VCH_OUT_OF_FUND_DECISION VARCHAR(8000),
    LAYER_ID INTEGER,
    COMPLEX_ID SMALLINT,
    vch_Investigation_Year varchar(10),
    vch_Comment varchar(2500),
    MODIFIER_APP_TYPE_ID SMALLINT,
    EMPLOYEE_ID SMALLINT
}

  if h.SecondStratumID > 0 then
    vSecondStratum := h.SecondStratumID
  else vSecondStratum := null;

  Result := varArrayOf([h.ID, h.OrganizationId, h.FirstStratumID, vSecondStratum,
                        (h.Collection as TOldHorizons).Owner.ID, ord(h.OutOfFund),
                        ord(h.Active), '', h.ComplexID,  h.InvestigationYear, h.Comment,
                        TMainFacade.GetInstance.ClientAppTypeID, TMainFacade.GetInstance.DBGates.EmployeeID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function THorizonDataPoster.GetProxy(const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure THorizonDataPoster.Prepare;
begin
  FObjectClass := TOldHorizon;
  FCollectionClass := TOldHorizons;

  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'Structure_Stratum_ID';

  FPostingTable := 'spd_Add_Horizon';
  FPostingColumns := '*';
  FQuery := 'select ' +
            'STRUCTURE_STRATUM_ID, ORGANIZATION_ID, VCH_ORG_FULL_NAME, VCH_ORG_SHORT_NAME, ' +
            'FIRST_STRATUM_ID, VCH_FIRST_STRATUM_NAME, VCH_FIRST_STRATUM_POSTFIX, ' +
            'SECOND_STRATUM_ID, VCH_SECOND_STRATUM_NAME, VCH_SECOND_STRATUM_POSTFIX, ' +
            'NUM_OUT_OF_FUND,  ' +
            'NUM_ACTIVE_FUND, VCH_OUT_OF_FUND_DECISION, ' +
            'COMPLEX_ID, VCH_COMPLEX_NAME, VCH_COMPLEX_SHORT_NAME, ' +
            'vch_Investigation_Year, vch_Comment, VERSION1_ID, DTM_VERSION1_DATE, VCH_VERSION1_NAME, VCH_VERSION1_NUMBER ' + 
            'from vw_Horizon ';
//          + 'where Version_ID = ' + IntToStr(ActiveVersion.ID);
  FKeyColumn := 'Structure_Stratum_ID';
  FDeletingTable := 'spd_Delete_Horizon';
end;

{ TSubstructureDataPoster }

function TSubstructureDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := varArrayOf([AbaseObject.ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TSubstructureDataPoster.GetObject(
  AData: variant): TBaseCollection;
var i: integer;
    s: TOldSubstructure;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldSubstructures.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
{
   0 SUBSTRUCTURE_ID,
   1 ROCK_ID,
   2 VCH_ROCK_NAME,
   3 COLLECTOR_TYPE_ID,
   4 VCH_COLLECTOR_TYPE_NAME,
   5 VCH_COLLECTOR_TYPE_SHORT,
   6 BED_TYPE_ID,
   7 VCH_BED_TYPE_NAME,
   8 VCH_BED_TYPE_SHORT_NAME,
   9 STRUCTURE_TECTONIC_ELEMENT_ID,
   10 VCH_SUBSTRUCTURE_NAME,
   11 SUBSTRUCTURE_TYPE_ID,
   12 VCH_SUBSTRUCTURE_TYPE_NAME,
   13 STRUCTURE_STRATUM_ID,
   14 VCH_SUBSTRUCTURE_ORDER,
   15 VCH_SUBSTRUCT_ADDITIONAL_NAME,
   16 DTM_ACTUAL_UNTIL,
   17 NUM_PROBABILITY,
   18 NUM_RELIABILITY,
   19 VCH_QUALITY_RANGE,
   20 COMPLEX_ID,
   21 VCH_COMPLEX_NAME,
   22 VCH_COMPLEX_SHORT_NAME,
   23 TRAP_TYPE_ID,
   24 VCH_TRAP_TYPE_NAME,
   25 VCH_TRAP_TYPE_SHORT_NAME,
   26 NUM_CLOSING_ISOGIPSE,
   27 NUM_PERSPECTIVE_AREA,
   28 NUM_AMPLITUDE,
   29 NUM_CONTROL_DENSITY,
   30 NUM_MAP_ERROR
}

  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    s := (Result as TOldSubstructures).Add;

{
  0 SUBSTRUCTURE_ID,
  1 ROCK_ID,
  2 VCH_ROCK_NAME,
}
    s.ID := AData[0, i];
    s.RockID := AData[1, i];
    s.RockName := AData[2, i];
{
  3 COLLECTOR_TYPE_ID,
  4 VCH_COLLECTOR_TYPE_NAME,
  5 VCH_COLLECTOR_TYPE_SHORT,
}
    s.CollectorTypeID := AData[3, i];
    s.CollectorType := AData[4, i];
{
  6 BED_TYPE_ID,
  7 VCH_BED_TYPE_NAME,
  8 VCH_BED_TYPE_SHORT_NAME,
}

    s.BedTypeID := AData[6, i];
    s.BedType := AData[7, i];
{
   9 STRUCTURE_TECTONIC_ELEMENT_ID,
   10 VCH_SUBSTRUCTURE_NAME,
}

    s.StructureElementID := AData[9, i];
    s.StructureElement := AData[10, i];

{
   11 SUBSTRUCTURE_TYPE_ID,
   12 VCH_SUBSTRUCTURE_TYPE_NAME,
}
    s.StructureElementTypeID := AData[11, i];
    s.StructureElementType := AData[12, i];

{
   13 STRUCTURE_STRATUM_ID,
   14 VCH_SUBSTRUCTURE_ORDER,
   15 VCH_SUBSTRUCT_ADDITIONAL_NAME,
}

    s.RealName := AData[15, i];
    s.Order := AData[14, i];

{
   16 DTM_ACTUAL_UNTIL,
}
    s.ActualUntil := AData[16, i];

{
   17 NUM_PROBABILITY,
   18 NUM_RELIABILITY,
   19 VCH_QUALITY_RANGE,
}
    s.Probability := AData[17, i];
    s.Reliability := AData[18, i];
    s.QualityRange := AData[19, i];

{
   20 COMPLEX_ID,
   21 VCH_COMPLEX_NAME,
   22 VCH_COMPLEX_SHORT_NAME,
}
    s.SubComplexID := AData[20, i];
    s.SubComplex   := AData[21, i];

{
   23 NUM_CLOSING_ISOGIPSE,
   24 NUM_PERSPECTIVE_AREA,
   25 NUM_AMPLITUDE,
   26 NUM_CONTROL_DENSITY,
   27 NUM_MAP_ERROR
}
    s.ClosingIsogypse := AData[23, i];
    s.PerspectiveArea := AData[24, i];
    s.Amplitude := AData[25, i];
    s.ControlDensity := AData[26, i];
    s.MapError := AData[27, i];
  end;
end;

function TSubstructureDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var s: TOldSubstructure;
    vCollectorTypeID, vComplexID, vStructureElementID, vRockID, vBedTypeID: variant;
begin
  {

    SUBSTRUCTURE_ID INTEGER,
    ROCK_ID INTEGER,
    COLLECTOR_TYPE_ID INTEGER,
    BED_TYPE_ID SMALLINT,
    LAYER_ID SMALLINT,
    STRUCTURE_TECTONIC_ELEMENT_ID SMALLINT,
    STRUCTURE_STRATUM_ID INTEGER,
    VCH_SUBSTRUCTURE_ORDER VARCHAR(10),
    VCH_SUBSTRUCTURE_NAME VARCHAR(150),
    NUM_BED_HEIGHT NUMERIC(7,2),
    NUM_AREA NUMERIC(7,2),
    NUM_VNK NUMERIC(9,4),
    DTM_ACTUAL_UNTIL DATE,
    NUM_PROBABILITY NUMERIC(4,2),
    NUM_RELIABILITY NUMERIC(7,2),
    VCH_QUALITY_RANGE VARCHAR(20),
    COMPLEX_ID INTEGER,
    TRAP_TYPE_ID SMALLINT,
    NUM_CLOSING_ISOGIPSE NUMERIC(7,2),
    NUM_PERSPECTIVE_AREA NUMERIC(7,2),
    NUM_AMPLITUDE NUMERIC(7,2),
    NUM_CONTROL_DENSITY NUMERIC(5,2),
    NUM_MAP_ERROR NUMERIC(5,2),

    MODIFIER_APP_TYPE_ID SMALLINT,
    EMPLOYEE_ID SMALLINT

  }
  S := ABaseObject as TOldSubstructure;

  if s.RockID = 0 then
    vRockID := null
  else
    vRockID := s.RockID;

  if s.CollectorTypeID = 0 then
    vCollectorTypeID := null
  else
    vCollectorTypeID := s.CollectorTypeID;

  if s.BedTypeID = 0 then
    vBedTypeID := null
  else
    vBedTypeID := s.BedTypeID;

  if s.StructureElementID = 0 then
    vStructureElementID := null
  else
    vStructureElementID := s.StructureElementID;

  if s.SubComplexID = 0 then
    vComplexID := null
  else
    vComplexID := s.SubComplexID;


  Result := varArrayOf([s.ID, vRockID, vCollectorTypeID,
                        vBedTypeID, vStructureElementID,
                        s.Horizon.ID, s.Order, s.RealName,
                        s.ActualUntil, s.Probability, s.Reliability, s.QualityRange,
                        vComplexID,
                        s.ClosingIsoGypse, s.perspectiveArea,
                        s.Amplitude, s.ControlDensity, S.MapError,
                        TMainFacade.GetInstance.ClientAppTypeID, TMainFacade.GetInstance.DBGates.EmployeeID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TSubstructureDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TSubstructureDataPoster.Prepare;
begin
  FObjectClass := TOldSubstructure;
  FCollectionClass := TOldSubstructures;

  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'vch_Substructure_Name';

  FPostingColumns := 'New_Substructure_ID';
  FPostingTable := 'spd_Add_Substructure';
  FQuery := 'select ' +
            'SUBSTRUCTURE_ID, ROCK_ID, VCH_ROCK_NAME, COLLECTOR_TYPE_ID, ' +
            'VCH_COLLECTOR_TYPE_NAME, VCH_COLLECTOR_TYPE_SHORT, BED_TYPE_ID, ' +
            'VCH_BED_TYPE_NAME, VCH_BED_TYPE_SHORT_NAME, ' +
            'STRUCTURE_TECTONIC_ELEMENT_ID, VCH_SUBSTRUCTURE_NAME, ' +
            'SUBSTRUCTURE_TYPE_ID, VCH_SUBSTRUCTURE_TYPE_NAME, STRUCTURE_STRATUM_ID, ' +
            'VCH_SUBSTRUCTURE_ORDER, VCH_SUBSTRUCT_ADDITIONAL_NAME, ' +
            'DTM_ACTUAL_UNTIL, ' +
            'NUM_PROBABILITY, NUM_RELIABILITY, VCH_QUALITY_RANGE, ' +
            'COMPLEX_ID, VCH_COMPLEX_NAME, VCH_COMPLEX_SHORT_NAME, ' +
            'NUM_CLOSING_ISOGIPSE, NUM_PERSPECTIVE_AREA, NUM_AMPLITUDE, ' +
            'NUM_CONTROL_DENSITY, NUM_MAP_ERROR ' + 
            'from vw_Substructure ';
//            + 'where Version_ID = ' + IntToStr(ActiveVersion.ID);
  FKeyColumn := 'Substructure_ID';
  FDeletingTable := 'spd_Delete_Substructure';
end;

{ TDiscoveredStructureDataPoster }

function TDiscoveredStructureDataPoster.GetObject(
  AData: variant): TBaseCollection;
var S: TOldDiscoveredStructure;
begin
  if not Assigned(FLastGotObject) then
    FLastGotObject := TOldDiscoveredStructure.Create(FLastGotCollection);

{
012
'STRUCTURE_ID, DISCOVER_METHOD_ID, VCH_DISCOVER_METHOD_NAME, ' +
34
'VCH_SHORT_DISCOVER_METHOD_NAME, DISCOVER_ORGANIZATION_ID, ' +
56
'VCH_DISCOVER_ORG_FULL_NAME, VCH_DISCOVER_ORG_SHORT_NAME, ' +
789
'VCH_DISCOVER_YEAR, NUM_DISCOVER_ACTUAL, VCH_DISCOVER_REPORT_AUTHOR, ' +
1011
'VCH_DISCOVER_SEISMOGROUP_NUMBER, DTM_DISCOVER_ENTERING_DATE';
}
  Result := FLastGotCollection;
  S := FLastGotObject as TOldDiscoveredStructure;
  if not varIsEmpty(AData) then
  begin
    S.MethodID := AData[1, 0];
    S.Method := AData[2, 0];

    S.OrganizationID := AData[4, 0];
    S.Organization   := AData[5, 0];

    s.Year := AData[7, 0];
    s.Actual := AData[8, 0];
    s.ReportAuthor := AData[9, 0];
    s.SeismoGroupName := AData[10, 0];
  end;
end;

function TDiscoveredStructureDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var s: TOldDiscoveredStructure;
begin
  S := ABaseObject as TOldDiscoveredStructure;
  Result := varArrayOf([S.ID, S.MethodID, S.OrganizationID,
                        S.Year,  ord(S.Actual), s.ReportAuthor,
                        s.SeismoGroupName, TMainFacade.GetInstance.ClientAppTypeID, TMainFacade.GetInstance.DBGates.EmployeeID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TDiscoveredStructureDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TDiscoveredStructureDataPoster.Prepare;
begin
  inherited;
  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'vch_Area_Name';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Discovered_Structure';
  FQuery := 'select ' +
            'STRUCTURE_ID, DISCOVER_METHOD_ID, VCH_DISCOVER_METHOD_NAME, ' +
            'VCH_SHORT_DISCOVER_METHOD_NAME, DISCOVER_ORGANIZATION_ID, ' +
            'VCH_DISCOVER_ORG_FULL_NAME, VCH_DISCOVER_ORG_SHORT_NAME, ' +
            'VCH_DISCOVER_YEAR, NUM_DISCOVER_ACTUAL, VCH_DISCOVER_REPORT_AUTHOR, ' +
            'VCH_DISCOVER_SEISMOGROUP_NUMBER, DTM_DISCOVER_ENTERING_DATE ' +
            'from vw_Structure ';
//             + 'where Version_ID = ' + IntToStr(ActiveVersion.ID);

  FKeyColumn := 'Structure_ID';
  FDeletingTable := 'tbl_Discovered_Structure';
  FInsertReturnsData := false;
end;

{ TPreparedStructureDataPoster }

function TPreparedStructureDataPoster.GetObject(
  AData: variant): TBaseCollection;
var S: TOldPreparedStructure;
begin
  if not Assigned(FLastGotObject) then
    FLastGotObject := TOldPreparedStructure.Create(FLastGotCollection);

{
012
STRUCTURE_ID, PREPARE_METHOD_ID, VCH_PREPARE_METHOD_NAME, ' +
34
VCH_PREPARE_SHORT_METHOD_NAME, PREPARE_ORGANIZATION_ID, ' +
56
VCH_PREPARE_ORG_FULL_NAME, VCH_PREPARE_ORG_SHORT_NAME, ' +
789
VCH_PREPARATION_YEAR,   NUM_PREPARE_ACTUAL, VCH_PREPARE_REPORT_AUTHOR, ' +
1011
VCH_PREPARE_SEISMOGROUP_NUMBER, DTM_PREPARE_ENTERING_DATE';
}

  Result := FLastGotCollection;
  S := FLastGotObject as TOldPreparedStructure;
  if not varIsEmpty(AData) then
  begin
    S.MethodID := AData[1, 0];
    S.Method := AData[2, 0];

    S.OrganizationID := AData[4, 0];
    S.Organization   := AData[5, 0];

    s.Year := AData[7, 0];
    s.Actual := AData[8, 0];
    s.ReportAuthor := AData[9, 0];
    s.SeismoGroupName := AData[10, 0];
  end;
end;

function TPreparedStructureDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var S: TOldPreparedStructure;
begin
  S := ABaseObject as TOldPreparedStructure;
  Result := varArrayOf([S.ID, S.MethodID, S.OrganizationID,
                        S.Year,  ord(S.Actual), s.ReportAuthor,
                        s.SeismoGroupName, TMainFacade.GetInstance.ClientAppTypeID, TMainFacade.GetInstance.DBGates.EmployeeID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TPreparedStructureDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TPreparedStructureDataPoster.Prepare;
begin
  inherited;
  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'vch_Area_Name';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Prepared_Structure';
  FQuery := 'select ' +
            'STRUCTURE_ID, PREPARE_METHOD_ID, VCH_PREPARE_METHOD_NAME, ' +
            'VCH_PREPARE_SHORT_METHOD_NAME, PREPARE_ORGANIZATION_ID, ' +
            'VCH_PREPARE_ORG_FULL_NAME, VCH_PREPARE_ORG_SHORT_NAME, ' +
            'VCH_PREPARATION_YEAR,   NUM_PREPARE_ACTUAL, VCH_PREPARE_REPORT_AUTHOR, ' +
            'VCH_PREPARE_SEISMOGROUP_NUMBER, DTM_PREPARE_ENTERING_DATE ' +
            'from vw_Structure ';
//             +'where Version_ID = ' + IntToStr(ActiveVersion.ID);
  FKeyColumn := 'Structure_ID';
  FDeletingTable := 'tbl_Prepared_Structure';
  FInsertReturnsData := false;
end;

{ TDrilledStructureDataPoster }

function TDrilledStructureDataPoster.GetObject(
  AData: variant): TBaseCollection;
var S: TOldDrilledStructure;
begin
  if not Assigned(FLastGotObject) then
    FLastGotObject := TOldDrilledStructure.Create(FLastGotCollection);

{
01
STRUCTURE_ID,     DRILL_ORGANIZATION_ID, ' +
23
VCH_DRILL_ORG_FULL_NAME,   VCH_DRILL_ORG_SHORT_NAME ';
}

  Result := FLastGotCollection;
  S := FLastGotObject as TOldDrilledStructure;
  if not varIsEmpty(AData) then
  begin
    S.OrganizationID := AData[1, 0];
    S.Organization   := AData[2, 0];
  end;
end;

function TDrilledStructureDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var S: TOldDrilledStructure;
begin
  S := ABaseObject as TOldDrilledStructure;
  Result := varArrayOf([S.ID, S.OrganizationID, Ord(S.Actual),
                        TMainFacade.GetInstance.ClientAppTypeID, TMainFacade.GetInstance.DBGates.EmployeeID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TDrilledStructureDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TDrilledStructureDataPoster.Prepare;
begin
  inherited;
  FGettingTable := '';
  FGettingColumns := '';
  FOrder := 'vch_Area_Name';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Drilled_Structure';
  FQuery := 'select ' +
            'STRUCTURE_ID, DRILL_ORGANIZATION_ID, ' +
            'VCH_DRILL_ORG_FULL_NAME,   VCH_DRILL_ORG_SHORT_NAME ' +
            'from vw_Structure ';
//            + 'where Version_ID = ' + IntToStr(ActiveVersion.ID);

  FKeyColumn := 'Structure_ID';
  FDeletingTable := 'tbl_Drilled_Structure';
  FInsertReturnsData := false;
end;

{ TDrilledStructureWellDataPoster }

function TDrilledStructureWellDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
var w: TOldDrilledStructureWell;
begin
  w := ABaseObject as TOldDrilledStructureWell;

  Result := varArrayOf([w.ID, (w.Collection as TOldDrilledStructureWells).Structure.ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TDrilledStructureWellDataPoster.GetDeletingData(
  ABaseCollection: TBaseCollection): OleVariant;
begin
  Result := varArrayOf([(ABaseCollection as TOldDrilledStructureWells).Structure.ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TDrilledStructureWellDataPoster.GetObject(
  AData: variant): TBaseCollection;
var i: integer;
    w: TOldDrilledStructureWell;
begin
  if Assigned(FLastGotCollection) then
    FLastGotCollection.Clear;

  Result := FLastGotCollection;
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    w := (Result as TOldDrilledStructureWells).Add;
{

            'w.vch_area_name, ' +
            'w.vch_well_num, ' +
            'w.VCH_CATEGORY_NAME, ' +
            'w.VCH_DISTRICT, ' +
            'w.VCH_NGO, ' +
            'w.VCH_REGION_FULL_NAME, ' +
            'DTM_DRILLING_START, ' +
            'DTM_DRILLING_FINISH, ' +
            'dsw.structure_id, ' +
            'w.num_Rotor_Altitude, ' +
            'w.num_True_Depth, ' +
            'dsw.vch_gis_confirmation, ' +
            'dsw.vch_struct_model_confirmation, ' +
            'dsw.vch_negative_result_reason ' +


}
    w.ID := AData[0, i];
    w.AreaName := AData[1, i];
    w.WellNum  := AData[2, i];
    w.Altitude := AData[10, i];
    w.Depth    := AData[11, i];
    w.GISConfirmation := AData[12, i];
    w.StructModelConfirmation := AData[13, i];
    w.NegativeResultReason := AData[14, i];
  end;
end;

function TDrilledStructureWellDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var w: TOldDrilledStructureWell;
begin
  w := ABaseObject as TOldDrilledStructureWell;
  {
    WELL_UIN INTEGER,
    STRUCTURE_ID INTEGER,
    VCH_GIS_CONFIRMATION VARCHAR(8000),
    VCH_STRUCT_MODEL_CONFIRMATION VARCHAR(8000),
    VCH_NEGATIVE_RESULT_REASON VARCHAR(8000)
  }

  Result := varArrayOf([w.ID, (w.Collection as TOldDrilledStructureWells).Structure.ID, w.GisConfirmation, w.StructModelConfirmation, w.NegativeResultReason, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TDrilledStructureWellDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TDrilledStructureWellDataPoster.Prepare;
begin
  FObjectClass := TOldDrilledStructureWell;
  FCollectionClass := TOldDrilledStructureWells;

  FQuery := 'select w.well_uin, ' +
            'w.vch_area_name, ' +
            'w.vch_well_num, ' +
            'w.VCH_CATEGORY_NAME, ' +
            'w.VCH_DISTRICT, ' +
            'w.VCH_NGO, ' +
            'w.VCH_REGION_FULL_NAME, ' +
            'DTM_DRILLING_START, ' +
            'DTM_DRILLING_FINISH, ' +
            'dsw.structure_id, ' +
            'w.num_Rotor_Altitude, ' +
            'w.num_True_Depth, ' +
            'dsw.vch_gis_confirmation, ' +
            'dsw.vch_struct_model_confirmation, ' +
            'dsw.vch_negative_result_reason ' +
            'from ' +
            'tbl_drilled_structure_well dsw, ' +
            'vw_well_main_info w ' +
            'where dsw.well_uin = w.well_uin ';
//             + 'and dsw.Version_ID = ' + IntToStr(ActiveVersion.ID);
  FGettingColumns := '';

  FOrder := 'vch_Area_Name, vch_Well_Num';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Drilled_Structure_Well';
  FKeyColumn := 'Well_UIN';
  FDeletingTable := 'spd_Delete_Drilled_Struct_Well';
  FInsertReturnsData := false;
end;

{ TResourceDataPoster }

function TResourceDataPoster.GetDeletingData(
  ABaseCollection: TBaseCollection): OleVariant;
var v: TOldAccountVersion;
begin
  v := ABaseCollection.Owner as TOldAccountVersion;
  Result := varArrayOf([v.ID,
                       (v.Collection as TBaseCollection).Owner.ID,
                       (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TResourceDataPoster.GetObject(AData: variant): TBaseCollection;
var R: TOldResource;
    i: integer;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldResources.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
{
0 CONCRETE_LAYER_ID,
1 FLUID_TYPE_ID,
2 VCH_FLUID_TYPE_NAME,
3 VCH_FLUID_SHORT_NAME,
4 RESOURCE_TYPE_ID,
5 VCH_RESOURCE_TYPE,
6 CATEGORY_ID,
7 VCH_CATEGORY_NAME,
8 VCH_CATEGORY_SHORT_NAME,
9 NUM_VALUE,
10 DOCUMENT_ID
}

  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    R := (Result as TOldResources).Add;

{
  1 FLUID_TYPE_ID,
  2 VCH_FLUID_TYPE_NAME,
  3 VCH_FLUID_SHORT_NAME,
}
    R.FluidTypeID := AData[1, i];
    R.FluidType := AData[2, i];

{
   4 RESOURCE_TYPE_ID,
   5 VCH_RESOURCE_TYPE,
}
   R.ResourceTypeID := AData[4, i];
   R.ResourceType   := AData[5, i];

{
   6 CATEGORY_ID,
   7 VCH_CATEGORY_NAME,
   8 VCH_CATEGORY_SHORT_NAME,
}
    R.ResourceCategoryID := AData[6, i];
    R.ResourceCategory := AData[7, i];

{
   9 NUM_VALUE,
}
    R.Value := AData[9, i];
  end;
end;

function TResourceDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var R: TOldResource;
begin
{
    FLUID_TYPE_ID SMALLINT,
    STRUCTURE_FUND_TYPE_ID INTEGER,
    CONCRETE_LAYER_ID INTEGER,
    RESOURCE_TYPE_ID SMALLINT,
    CATEGORY_ID INTEGER,
    DOCUMENT_ID INTEGER,

    NUM_VALUE NUMERIC(9,4)
}
  R := ABaseObject as TOldResource;
  Result := varArrayOf([R.FluidTypeID,
                        1,
                        (R.Version.Collection as TBaseCollection).Owner.ID,
                        R.ResourceTypeID,
                        R.ResourceCategoryID,
                        R.Version.ID,
                        R.Value,
                        (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TResourceDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TResourceDataPoster.Prepare;
begin
  FObjectClass := TOldResource;
  FCollectionClass := TOldResources;

  FGettingTable := '';
  FGettingColumns := '';
  FOrder := '';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Resource';
  FQuery := 'select ' +
            'CONCRETE_LAYER_ID, FLUID_TYPE_ID, VCH_FLUID_TYPE_NAME, ' +
            'VCH_FLUID_SHORT_NAME, RESOURCE_TYPE_ID, ' +
            'VCH_RESOURCE_TYPE, CATEGORY_ID, VCH_CATEGORY_NAME, ' +
            'VCH_CATEGORY_SHORT_NAME, NUM_VALUE, DOCUMENT_ID ' + 
            'from vw_Resource ';
//            + 'where Version_ID = ' + IntToStr(ActiveVersion.ID);
            
  FKeyColumn := 'CONCRETE_LAYER_ID';
  FDeletingTable := 'spd_Delete_Resource';
  FInsertReturnsData := false;
end;

{ TParameterDataPoster }

function TParameterDataPoster.GetDeletingData(
  ABaseCollection: TBaseCollection): OleVariant;
var v: TOldAccountVersion;
begin
 {
    OBJECT_UIN INTEGER,
    NUM_OBJECT_TYPE SMALLINT,
    DOCUMENT_ID INTEGER
 }
  v := ABaseCollection.Owner as TOldAccountVersion;
  Result := varArrayOf([
                        (v.Collection as TBaseCollection).Owner.ID,
                        (v.Collection as TBaseCollection).Owner.ObjectType,
                         v.ID,
                         (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID
                        ]);
end;

function TParameterDataPoster.GetObject(AData: variant): TBaseCollection;
var i: integer;
    P: TOldParam;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldParams.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
{
  0 parameter_id,
  1 vch_param_name,
  2 vch_param_short_name,
  3 vch_param_sign,
  4 fluid_type_id,
  5 vch_fluid_type_name,
  6 vch_fluid_short_name,
  7 measure_unit_id,
  8 vch_measure_unit_name,
  9 num_param_value,
  10 Object_UIN,
  11 num_OBJECT_TYPE,
  12 param_type_id,
  13 vch_param_type_name,
  14 vch_param_type_short_name,
  15 document_id,
  16 CATEGORY_ID,
  17 VCH_CATEGORY_NAME
}
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    P := (Result as TOldParams).Add;
{
  0 parameter_id,
  1 vch_param_name,
  2 vch_param_short_name,
  3 vch_param_sign,
}
    P.ParamID := AData[0, i];
    p.ID := P.ParamID;
    p.ParamName := AData[1, i];
    p.ParamSign := AData[3, i];

{
  4 fluid_type_id,
  5 vch_fluid_type_name,
  6 vch_fluid_short_name,

}
    p.FluidTypeID := AData[4, i];
    P.FluidType   := AData[5, i];
{
  7 num_param_value,
}
    p.Value := AData[7, i];

{

  8 param_type_id,
  9 vch_param_type_name,
  10 vch_param_type_short_name,

}
   p.ParamTypeID := AData[8, i];
   p.ParamType := AData[9, i];

{
  14 CATEGORY_ID,
  15 VCH_CATEGORY_NAME
}
    p.ResourceCategoryID := AData[14, i];
    p.ResourceCategory := AData[15, i];

    p.RelationshipID := AData[16, i];
    p.RelationshipName := AData[17, i];

    p.LicenseZone := TMainFacade.GetInstance.AllLicenseZones.ItemsByID[AData[18, i]] as TSimpleLicenseZone;
    p.NextValue := AData[19, i];
    p.IsRange := AData[20, i] > 0;
  end;
end;

function TParameterDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var p: TOldParam;
    LicZoneID: integer;
begin
{
    PARAMETER_ID INTEGER,
    OBJECT_UIN INTEGER,
    NUM_OBJECT_TYPE SMALLINT,
    DOCUMENT_ID INTEGER,
    FLUID_TYPE_ID SMALLINT,
    CATEGORY_ID
    NUM_PARAM_VALUE NUMERIC(9,4),
}
  p := ABaseObject as TOldParam;

  if Assigned(p.LicenseZone) then
    LicZoneID := p.LicenseZone.ID
  else
    LicZoneID := 0;

  Result := varArrayOf([p.ParamID,
                       ((p.Collection as TBaseCollection).Owner.Collection as TBaseCollection).Owner.ID,
                       ((p.Collection as TBaseCollection).Owner.Collection as TBaseCollection).Owner.ObjectType,
                        (p.Collection as TBaseCollection).Owner.ID,
                        p.FluidTypeID,
                        p.ResourceCategoryID,
                        p.Value,
                        p.NextValue,
                        p.RelationshipID,
                        LicZoneID,
                        ord(p.IsRange),
                        (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TParameterDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TParameterDataPoster.Prepare;
begin
  FObjectClass := TOldParam;
  FCollectionClass := TOldParams;

  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'vch_param_name';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_RRCount_Param';
  FQuery := 'select ' +
            'parameter_id,  vch_param_name,  vch_param_short_name, ' +
            'vch_param_sign, fluid_type_id,  vch_fluid_type_name, ' +
            'vch_fluid_short_name,  ' +
            'num_param_value,  Object_UIN,  num_OBJECT_TYPE, ' +
            'param_type_id,  vch_param_type_name,  vch_param_type_short_name, ' +
            'document_id, CATEGORY_ID, VCH_CATEGORY_NAME, Relation_Type_ID, vch_relation_type_name, ' +
            'License_Zone_ID, NUM_NEXT_PARAM_VALUE, NUM_IS_RANGE_VALUE ' +
            'from vw_RRCount_Parameter ' +
            'where (parameter_Id in (select Parameter_ID from TBL_CLIENT_RRCOUNT_PARAM where CLIENT_APP_TYPE_ID = ' +
                                   IntToStr(TMainFacade.GetInstance.DBGates.ClientAppTypeID) + '))';


  FKeyColumn := 'Parameter_ID';
  FDeletingTable := 'spd_Delete_RRCount_Param';
  FInsertReturnsData := false;
end;

{ TFieldDataPoster }

function TFieldDataPoster.GetObject(AData: variant): TBaseCollection;
var f: TOldField;
begin
  if not Assigned(FLastGotObject) then
    FLastGotObject := TOldField.Create(FLastGotCollection);


  Result := FLastGotCollection;
  f := FLastGotObject as TOldField;
{
 STRUCTURE_ID, DEVELOPMENT_DEGREE_ID, VCH_DEVE, ' +
                     'LICENSE_ZONE_ID, VCH_LICENSE_ZONE_NUM, DTM_REG_DATE, ' +
                     'FIELD_ORGANIZATION_ID, VCH_FIELD_ORG_FULL_NAME, VCH_FIELD_ORG_SHORT_NAME, ' +
                     'FIELD_TYPE_ID, VCH_FIELD_TYPE_NAME, FIELD_WELL_UIN, VCH_FIELD_WELL_NUM, ' +
                     'VCH_FIELD_WELL_NAME, VCH_FIELD_AREA_NAME, ' +
                     'num_discovering_year, num_start_developing_year, num_conservation_year ' +

}
  if not varIsEmpty(AData) then
  begin
    f.DevelopingDegreeID := AData[1, 0];
    f.DevelopingDegree := AData[2, 0];

    f.OrganizationID := AData[6, 0];
    f.Organization   := AData[7, 0];

    f.FieldTypeID := AData[9, 0];
    f.FieldType := AData[10, 0];

    f.DiscoveringYear := AData[15, 0];
    f.ExploitationStartYear := AData[16, 0];
    f.ExploitationFinishYear := AData[17, 0];
  end;
end;

function TFieldDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var f: TOldField;
    vDevelopingDegreeID, vLicenseZoneID, vOrganizationID, vFieldTypeID,
    vDiscoveringYear, vDevelopmentStartYear, vConservationYear: variant;
begin
{
    structure_id integer,
    development_degree_id smallint,
    license_zone_id smallint,
    organization_id integer,
    field_type_id smallint,
    well_uin integer,
    num_actual smallint,
    num_discovering_year smallint,
    num_start_developing_year smallint,
    num_conservation_year smallint, 
    modifier_app_type_id smallint,
    employee_id smallint,
    version_id integer
}
  f := ABaseObject as TOldField;

  if f.DevelopingDegreeID > 0 then
    vDevelopingDegreeID := f.DevelopingDegreeID
  else
    vDevelopingDegreeID := null;


  if f.OrganizationID > 0 then
    vOrganizationID := f.OrganizationID
  else
    vOrganizationID := null;

  if f.FieldTypeID > 0 then
    vFieldTypeID := f.FieldTypeID
  else
    vFieldTypeID := null;

  if f.DiscoveringYear > 0 then
    vDiscoveringYear := f.DiscoveringYear
  else
    vDiscoveringYear := null;

  if f.ExploitationStartYear > 0 then
    vDevelopmentStartYear := f.ExploitationStartYear
  else
    vDevelopmentStartYear := null;

  if f.ExploitationFinishYear > 0 then
    vConservationYear := f.ExploitationFinishYear
  else
    vConservationYear := null;





  Result := varArrayOf([f.ID, vDevelopingDegreeID, vLicenseZoneID,
                        vOrganizationID, vFieldTypeID, null, 1,
                        vDiscoveringYear, vDevelopmentStartYear, vConservationYear,
                        TMainFacade.GetInstance.ClientAppTypeID, TMainFacade.GetInstance.DBGates.EmployeeID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);

end;

function TFieldDataPoster.GetProxy(const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TFieldDataPoster.Prepare;
begin
  inherited;

  FQuery := '';
  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'vch_Area_Name';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Field';
  FQuery := 'select ' +
            'STRUCTURE_ID, DEVELOPMENT_DEGREE_ID, VCH_DEVELOPMENT_DEGREE_NAME, ' +
            'LICENSE_ZONE_ID, VCH_LICENSE_ZONE_NUM, DTM_REG_DATE, ' +
            'FIELD_ORGANIZATION_ID, VCH_FIELD_ORG_FULL_NAME, VCH_FIELD_ORG_SHORT_NAME, ' +
            'FIELD_TYPE_ID, vch_Field_Type_Short_Name, FIELD_WELL_UIN, VCH_FIELD_WELL_NUM, ' +
            'VCH_FIELD_WELL_NAME, VCH_FIELD_AREA_NAME, ' +
            'num_discovering_year, num_start_developing_year, num_conservation_year ' +
            'from vw_Structure ';
//             + 'where Version_ID = ' + IntToStr(ActiveVersion.ID);
  FKeyColumn := 'Structure_ID';
  FDeletingTable := 'spd_Delete_Field';
  FInsertReturnsData := false;
end;

{ TBedSubstructureDataPoster }


{ TBedDataPoster }

function TBedDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := varArrayOf([AbaseObject.ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TBedDataPoster.GetObject(AData: variant): TBaseCollection;
var i: integer;
    b: TOldBed;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldBeds.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
{
0   BED_ID,
1   ROCK_ID,
2   VCH_ROCK_NAME,
3   COLLECTOR_TYPE_ID,
4   VCH_COLLECTOR_TYPE_NAME,
5   VCH_COLLECTOR_TYPE_SHORT,
6   BED_TYPE_ID,
7   VCH_BED_TYPE_NAME,
8   VCH_BED_TYPE_SHORT_NAME,
9    VCH_BED_NAME,
10    VCH_BED_INDEX,
11    NUM_TOP_DEPTH,
12    NUM_BED_HEIGHT,
13    COMPLEX_ID,
14    VCH_COMPLEX_NAME,
15    VCH_COMPLEX_SHORT_NAME,
16    NUM_BED_AREA
17    FIELD_TYPE_ID,
18    VCH_FIELD_TYPE_NAME,
19    STRUCTURE_TECTONIC_ELEMENT_ID,
20    VCH_SUBSTRUCTURE_NAME,
21    SUBSTRUCTURE_TYPE_ID,
22    VCH_SUBSTRUCTURE_TYPE
23    VCH_SITE_NAME,
24    License_Zone_ID,
25    VCH_LICENSE_ZONE_FULL_NAME
}

  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    b := (Result as TOldBeds).Add;

{
0   BED_ID,
1   ROCK_ID,
2   VCH_ROCK_NAME,
}
    b.ID := AData[0, i];
    b.RockID := AData[1, i];
    b.RockName := AData[2, i];
{
3   COLLECTOR_TYPE_ID,
4   VCH_COLLECTOR_TYPE_NAME,
5   VCH_COLLECTOR_TYPE_SHORT,
}
    b.CollectorTypeID := AData[3, i];
    b.CollectorType := AData[4, i];
{
6   BED_TYPE_ID,
7   VCH_BED_TYPE_NAME,
8   VCH_BED_TYPE_SHORT_NAME,
}

    b.BedTypeID := AData[6, i];
    b.BedType := AData[7, i];
{
9    VCH_BED_NAME,
10    VCH_BED_INDEX,
11    NUM_TOP_DEPTH,
12    NUM_BED_HEIGHT,
}

    b.Name := AData[23, i];
    b.BedIndex := AData[10, i];
    b.Depth := AData[11, i];
    b.BedHeight := AData[12, i];
{
13    COMPLEX_ID,
14    VCH_COMPLEX_NAME,
15    VCH_COMPLEX_SHORT_NAME,
}
    b.ComplexId := AData[13, i];
    b.ComplexName := AData[14, i];

{
16    NUM_BED_AREA
}
    b.BedArea := AData[16, i];

{
17    FIELD_TYPE_ID,
18    VCH_FIELD_TYPE_NAME,
}
    b.FluidTypeID := AData[17, i];
    b.FluidType := AData[18, i];

{
19    STRUCTURE_TECTONIC_ELEMENT_ID,
20    VCH_SUBSTRUCTURE_NAME,
21    SUBSTRUCTURE_TYPE_ID,
22    VCH_SUBSTRUCTURE_TYPE
}
    b.StructureElementID := AData[19, i];
    b.StructureElement := AData[20, i];
    b.StructureElementTypeID := AData[21, i];
    b.StructureElementType := AData[22, i];

    b.IsBalanced := varAsType(AData[26, i], varInteger) > 0;
  end;
end;

function TBedDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var b: TOldBed;
begin
{
    BED_ID INTEGER,
    ROCK_ID INTEGER,
    COLLECTOR_TYPE_ID INTEGER,
    BED_TYPE_ID SMALLINT,
    STRUCTURE_ID INTEGER,
    COMPLEX_ID SMALLINT,
    VCH_BED_NAME VARCHAR(150),
    VCH_BED_INDEX VARCHAR(100),
    NUM_TOP_DEPTH NUMERIC(9,4),
    NUM_BED_HEIGHT NUMERIC(7,2),
    NUM_BED_AREA NUMERIC(7,2),
    FIELD_TYPE_ID SMALLINT,
    VERSION_ID INTEGER
}
  b := ABaseObject as TOldBed;


  Result := varArrayOf([b.ID, b.RockID, b.CollectorTypeID,
                        b.BedTypeID, (b.Collection as TBaseCollection).Owner.ID,
                        b.ComplexID, '', b.BedIndex,
                        b.Depth, b.BedHeight, b.BedArea, b.FluidTypeID, b.Name,
                        b.StructureElementID, null,
                        Ord(b.IsBalanced),
                        (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);

end;

function TBedDataPoster.GetProxy(const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TBedDataPoster.Prepare;
begin
  FObjectClass := TOldBed;
  FCollectionClass := TOldBeds;

  FGettingTable := '';
  { DONE :
Добавить в таблицу (процедуру и представление) тип флюида для залежи
(не из таблицы типов флюидов, а из таблицы месторождений). }
  FGettingColumns := '';

  FOrder := 'vch_Bed_Index';

  FPostingColumns := 'New_Bed_ID';
  FPostingTable := 'spd_Add_Bed';
  FQuery := 'select ' +
            'BED_ID, ROCK_ID, VCH_ROCK_NAME, ' +
            'COLLECTOR_TYPE_ID, VCH_COLLECTOR_TYPE_NAME, VCH_COLLECTOR_TYPE_SHORT, ' +
            'BED_TYPE_ID, VCH_BED_TYPE_NAME, VCH_BED_TYPE_SHORT_NAME, ' +
            'VCH_BED_NAME, VCH_BED_INDEX, ' +
            'NUM_TOP_DEPTH, NUM_BED_HEIGHT, ' +
            'COMPLEX_ID, VCH_COMPLEX_NAME, VCH_COMPLEX_SHORT_NAME, ' +
            'NUM_BED_AREA,  FIELD_TYPE_ID, vch_Field_Type_Short_Name, ' +
            'STRUCTURE_TECTONIC_ELEMENT_ID, VCH_SUBSTRUCTURE_NAME, ' +
            'SUBSTRUCTURE_TYPE_ID, VCH_SUBSTRUCTURE_TYPE_NAME, VCH_BED_SITE_NAME, ' +
            'License_Zone_ID, VCH_LICENSE_ZONE_FULL_NAME, NUM_BALANCED ' +
            'from vw_Bed ';
//             + 'where Version_Id = ' + IntToStr(ActiveVersion.ID);
  FKeyColumn := 'Bed_ID';
  FDeletingTable := 'spd_Delete_Bed';
end;

{ TLayerDataPoster }

function TLayerDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := varArrayOf([ABaseObject.ID, 0, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TLayerDataPoster.GetDeletingData(
  ABaseCollection: TBaseCollection): OleVariant;
var b: TOldBed;
begin
  b := ((ABaseCollection as TOldLayers).Owner As TOldBed);
  Result := varArrayOf([0, b.ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TLayerDataPoster.GetObject(AData: variant): TBaseCollection;
var i: integer;
    l: TOldLayer;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldSubstructures.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;

  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    l := (Result as  TOldLayers).Add;
{
  0 CONCRETE_LAYER_ID,
}
    l.ID := AData[0, i];

{  1 ROCK_ID,
   2 VCH_ROCK_NAME,
}   l.RockID := AData[1, i];
    l.RockName := AData[2, i];

{
  3 COLLECTOR_TYPE_ID,
  4  VCH_COLLECTOR_TYPE_NAME,
  5  VCH_COLLECTOR_TYPE_SHORT,
}
    l.CollectorTypeID := AData[3, i];
    l.CollectorType := AData[4, i];

{
  6  LAYER_ID,
  7  VCH_LAYER_INDEX,
}
    l.LayerID := AData[6, i];
    l.LayerIndex := AData[7, i];

{
  8  NUM_POWER,
  9  NUM_EFFECTIVE_POWER,
  10  NUM_FILLING_COEF,
  11  NUM_TRAP_HEIGHT,
  12  NUM_TRAP_AREA,
  13  NUM_BED_HEIGHT,
  14  NUM_BED_AREA;
}
    l.Power := AData[8, i];
    l.EffectivePower := AData[9, i];
    l.FillingCoef := AData[10, i];
    l.TrapHeight := AData[11, i];
    l.TrapArea := AData[12, i];
    l.BedHeight := AData[13, i];
    l.BedArea := AData[14, i];

{
  15 TRAP_TYPE_ID,
  16 vch_trap_type_name,
  17 vch_trap_type_short_name
}
    l.TrapTypeID := AData[15, i];
    l.TrapType := AData[16, i];

{
   18 SUBSTRUCTURE_ID
   19 Bed_ID,
   20 Bed_Type_ID,
   21 vch_Bed_Type_Name
   22 vch_Bed_Type_Short_Name
}
    l.SubstructureUIN := AData[18, i];
    l.BedTypeID := AData[20, i];
    l.BedType := AData[21, i];
  end;
end;

function TLayerDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var l: TOldLayer;
    vSubstructureUIN, vBedID, vCollectorTypeID, vLayerID, vTrapTypeID, vRockID, vBedTypeID: variant;
begin
  l := ABaseObject as TOldLayer;
  if Assigned(l.Substructure) then
    vSubstructureUIN := l.Substructure.ID
  else if l.SubstructureUIN > 0 then
    vSubstructureUIN := l.SubstructureUIN
  else vSubstructureUIN := null;

  if Assigned(l.Bed) then
    vBedID := l.Bed.ID
  else if l.BedID > 0 then
    vBedID := l.BedID
  else vBedID := null;

  if l.CollectorTypeID = 0 then
    vCollectorTypeID := null
  else
    vCollectorTypeID := l.CollectorTypeID;

  if l.LayerID = 0 then
    vLayerID := null
  else
    vLayerID := l.LayerID;

  if l.TrapTypeID = 0 then
    vTrapTypeID  := null
  else
    vTrapTypeID  := l.TrapTypeID;

  if l.RockID = 0 then
    vRockID := null
  else
    vRockID := l.RockID;

  if l.BedTypeID = 0 then
    vBedTypeID := null
  else
    vBedTypeID := l.BedTypeID;

  Result := varArrayOf([l.ID, vRockID, vCollectorTypeID,
                        vSubstructureUIN, vBedID,
                        vLayerID, vTrapTypeID, vBedTypeID,
                        l.Power, l.EffectivePower, l.FillingCoef,
                        l.TrapHeight, l.TrapArea,
                        l.BedHeight, l.BedArea,
                        TMainFacade.GetInstance.ClientAppTypeID, TMainFacade.GetInstance.DBGates.EmployeeID,(TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TLayerDataPoster.GetProxy(const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TLayerDataPoster.Prepare;
begin
  FObjectClass := TOldLayer;
  FCollectionClass := TOldLayers;

  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'vch_Layer_Index';

  FPostingColumns := 'New_Concrete_Layer_ID';
  FPostingTable := 'spd_Add_Concrete_Layer';
  FQuery := 'select ' +
            'CONCRETE_LAYER_ID, ' +
            'ROCK_ID, VCH_ROCK_NAME, ' +
            'COLLECTOR_TYPE_ID, VCH_COLLECTOR_TYPE_NAME, VCH_COLLECTOR_TYPE_SHORT, ' +
            'LAYER_ID, VCH_LAYER_INDEX, ' +
            'NUM_POWER, NUM_EFFECTIVE_POWER, ' +
            'NUM_FILLING_COEF, NUM_TRAP_HEIGHT, ' +
            'NUM_TRAP_AREA, NUM_BED_HEIGHT, NUM_BED_AREA, ' +
            'TRAP_TYPE_ID, vch_trap_type_name, vch_trap_type_short_name, ' +
            'SUBSTRUCTURE_ID, Bed_ID, Bed_Type_ID, vch_Bed_Type_Name, vch_Bed_Type_Short_Name ' +
            'from vw_Concrete_Layer ';
//            + 'where Version_ID = ' + IntToStr(ActiveVersion.ID);

  FKeyColumn := 'Concrete_Layer_ID';
  FDeletingTable := 'spd_Delete_Concrete_Layer';
end;

{ TAccountVersionDataPoster }

function TAccountVersionDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  // удаляем документ по идентификатору
  Result := varArrayOf([ABaseObject.ID, Null, Null, 0, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TAccountVersionDataPoster.GetDeletingData(
  ABaseCollection: TBaseCollection): OleVariant;
begin
  // удаляем все документы с запасами и ресурсами по идентификатору слоя
  Result := varArrayOf([Null, ABaseCollection.Owner.ID, ABaseCollection.Owner.ID, 3, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TAccountVersionDataPoster.GetObject(
  AData: variant): TBaseCollection;
var i: integer;
    v: TOldAccountVersion;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldAccountVersions.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
{
  0 DOCUMENT_ID,
  1 DOC_TYPE_ID,
  2 VCH_DOC_TYPE_NAME,
  3 CREATOR_ORGANIZATION_ID,
  4 VCH_ORG_FULL_NAME,
  5 VCH_ORG_SHORT_NAME,
  6 VERSION_ID,
  7 VCH_VERSION_NAME,
  8 VCH_DOC_NAME,
  9 VCH_AUTHORS,
  10 DTM_CREATION_DATE,
  11 ORGANIZATION_ID,
  12 VCH_ORG_FULL_NAME,
  13 VCH_ORG_SHORT_NAME,
  14 DTM_AFFIRMATION_DATE;
  15 NUM_AFFIRMED
  16 NUM_RESERVES,
  17 NUM_RESOURCES,
  18 NUM_PARAMETERS
}

  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    v := (Result as TOldAccountVersions).Add;

{
  0 DOCUMENT_ID,
  1 DOC_TYPE_ID,
  2 VCH_DOC_TYPE_NAME,
}
    v.ID := AData[0, i];
    v.DocTypeID := AData[1, i];
    v.DocType := AData[2, i];
{
  3 ORGANIZATION_ID,
  4 VCH_ORG_FULL_NAME,
  5 VCH_ORG_SHORT_NAME,
}
    v.CreatorOrganizationID := AData[3, i];
    v.CreatorOrganization := AData[4, i];
{
  6 VERSION_ID,
  7 VCH_VERSION_NAME,
}

    v.VersionID := AData[6, i];
    v.Version := AData[7, i];
{
  8 VCH_DOC_NAME,
  9 VCH_AUTHORS,
  10 DTM_AFFIRMATION_DATE
}

    v.DocName := AData[8, i];
    v.Authors := AData[9, i];
    v.CreationDate := AData[10, i];
{
  11 ORGANIZATION_ID,
  12 VCH_ORG_FULL_NAME,
  13 VCH_ORG_SHORT_NAME,
  14 DTM_AFFIRMATION_DATE;
  15 NUM_AFFIRMED
}

    v.AffirmatorOrganizationID := AData[11, i];
    v.AffirmatorOrganization := AData[12, i];
    v.AffirmationDate := AData[14, i];
    v.Affirmed := AData[15, i];
{
  16 NUM_RESERVES,
  17 NUM_RESOURCES,
  18 NUM_PARAMETERS
}

    v.ContainsReserves := AData[16, i] > 0;
    v.ContainsResources := AData[17, i] > 0;
    v.ContainsParams := AData[18, i] > 0;
  end;
end;

function TAccountVersionDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var v: TOldAccountVersion;
begin
  {
    DOCUMENT_ID INTEGER,
    CREATOR_ORGANIZATION_ID INTEGER,
    DOC_TYPE_ID INTEGER,
    VERSION_ID INTEGER,
    VCH_DOC_NAME VARCHAR(120),
    VCH_AUTHORS VARCHAR(120),
    DTM_CREATION_DATE DATE,
    ORGANIZATION_ID,
    DTM_AFFIRMATION_DATE
    NUM_AFFIRMED smallint
    STRUCTURE_ID integer,
    STRUCTURE_VERSION_ID INTEGER
  }

  v := ABaseObject as TOldAccountVersion;

  Result := varArrayOf([v.ID, v.CreatorOrganizationID, v.DocTypeID,
                        v.VersionID, v.DocName, v.Authors,
                        v.CreationDate,
                        v.AffirmatorOrganizationID,v.AffirmationDate,
                        ord(v.Affirmed),
                        v.Structure.ID,
                        (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID
                        ]);
end;

function TAccountVersionDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TAccountVersionDataPoster.Prepare;
begin
  FObjectClass := TOldAccountVersion;
  FCollectionClass := TOldAccountVersions;

  FGettingTable := 'vw_Count_Document';
  FGettingColumns := 'DOCUMENT_ID, DOC_TYPE_ID, VCH_DOC_TYPE_NAME, ' +
                     'CREATOR_ORGANIZATION_ID, VCH_CREATOR_ORG_FULL_NAME, VCH_CREATOR_ORG_SHORT_NAME, ' +
                     'VERSION_ID, VCH_VERSION_NAME, VCH_DOC_NAME, ' +
                     'VCH_AUTHORS, DTM_CREATION_DATE, ' +
                     'ORGANIZATION_ID, VCH_ORG_FULL_NAME, VCH_ORG_SHORT_NAME, ' +
                     'DTM_AFFIRMATION_DATE, NUM_AFFIRMED, ' +
                     'NUM_RESERVES, NUM_RESOURCES, NUM_PARAMETERS';

  FOrder := 'Version_ID asc';

  FPostingColumns := 'New_Document_ID';
  FPostingTable := 'spd_Add_Count_Document';
  FQuery := '';
  FKeyColumn := 'Document_ID';
//  FDeletingTable := 'spd_Delete_Count_Document';
end;

{ TReserveDataPoster }

function TReserveDataPoster.GetDeletingData(
  ABaseCollection: TBaseCollection): OleVariant;
var v: TOldAccountVersion;
begin
  v := ABaseCollection.Owner as TOldAccountVersion;
  Result := varArrayOf([v.ID,
                       (v.Collection as TBaseCollection).Owner.ID,
                       (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function TReserveDataPoster.GetObject(AData: variant): TBaseCollection;
var R: TOldReserve;
    i: integer;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldReserves.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
{
  0 CONCRETE_LAYER_ID,
  1 FLUID_TYPE_ID,
  2 VCH_FLUID_TYPE_NAME,
  3 VCH_FLUID_SHORT_NAME,
  4 CATEGORY_ID,
  5 VCH_CATEGORY_NAME,
  6 VCH_CATEGORY_SHORT_NAME,
  7 RESERVES_KIND_ID,
  8 VCH_RESERVES_KIND_NAME,
  9 NUM_VALUE,
  10 DOCUMENT_ID
  11 resource_type_id,
  12 vch_resource_type

}

  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    R := (Result as TOldReserves).Add;
{
  1 FLUID_TYPE_ID,
  2 VCH_FLUID_TYPE_NAME,
  3 VCH_FLUID_SHORT_NAME,
}
    R.FluidTypeID := AData[1, i];
    R.FluidType := AData[2, i];
{
  4 CATEGORY_ID,
  5 VCH_CATEGORY_NAME,
  6 VCH_CATEGORY_SHORT_NAME,
}
    R.ReserveCategoryID := AData[4, i];
    R.ReserveCategory := AData[5, i];      
{
  7 RESERVES_KIND_ID,
  8 VCH_RESERVES_KIND_NAME,
}
   R.ReserveKindID := AData[7, i];
   R.ReserveKind   := AData[8, i];
{
  9 NUM_VALUE,
}
    R.Value := AData[9, i];

    r.ReserveTypeID := AData[11, i];
    r.ReserveType := AData[12, i];

    r.ReserveValueTypeID := AData[13, i];
    r.ReserveValueTypeName := AData[14, i];

    r.LicenseZone := TMainFacade.GetInstance.AllLicenseZones.ItemsByID[AData[15, i]] as TSimpleLicenseZone;    
  end;
end;

function TReserveDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var r: TOldReserve;
    LicZoneID: integer;
begin
{
    CATEGORY_ID INTEGER,
    FLUID_TYPE_ID INTEGER,
    DOCUMENT_ID INTEGER,
    RESERVES_KIND_ID SMALLINT,
    BED_ID INTEGER,
    NUM_VALUE NUMERIC(7,2)
}
  R := AbaseObject as TOldReserve;

  if Assigned(r.LicenseZone) then
    LicZoneID := r.LicenseZone.ID
  else
    LicZoneID := 0;

  Result := varArrayOf([R.ReserveCategoryID,
                        R.FluidTypeID,
                        R.Version.ID,
                        R.ReserveKindID,
                        r.ReserveTypeID,
                        (R.Version.Collection as TBaseCollection).Owner.ID,
                         R.Value,
                         (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID,
                         r.ReserveValueTypeID,
                         LicZoneID]);

end;

function TReserveDataPoster.GetProxy(const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TReserveDataPoster.Prepare;
begin
  FObjectClass := TOldReserve;
  FCollectionClass := TOldReserves;

  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'VCH_CATEGORY_NAME, vch_resource_type';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Reserve';
  FQuery := 'select ' +
            'BED_ID, ' +
            'FLUID_TYPE_ID, VCH_FLUID_TYPE_NAME, VCH_FLUID_SHORT_NAME, ' +
            'CATEGORY_ID, VCH_CATEGORY_NAME, VCH_CATEGORY_SHORT_NAME, ' +
            'RESERVES_KIND_ID, VCH_RESERVES_KIND_NAME, ' +
            'NUM_VALUE, DOCUMENT_ID, resource_type_id, vch_resource_type, ' +
            'reserve_value_type_id, vch_value_type_name, License_Zone_ID ' +
            'from vw_Bed_Reserve ';
//            + 'where Version_ID = ' + IntToStr(ActiveVersion.ID);
  FKeyColumn := 'BED_ID';
  FDeletingTable := 'spd_Delete_Reserve';
  FInsertReturnsData := false;
end;

{ THistoryDataPoster }

function THistoryDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := varArrayOF([ABaseObject.ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function THistoryDataPoster.GetObject(AData: variant): TBaseCollection;
var i: integer;
    h: TOldHistoryElement;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldHistory.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
{
  0 action_id,
  1 action_type_id,
  2 vch_action_type_name,
  3 action_reason_id,
  4 vch_action_reason,
  5 dtm_action_date,
  6 vch_Action_Reason_Details,
  7 dtm_Last_Modify_Date,
  8 dtm_Entering_Date,
  9 Employee_ID,
  10 vch_Employee_Name,
  11 Object_UIN,
  12 num_Object_Type
}
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    h := (Result as TOldHistory).Add;

    InitElement(h, i, AData);
  end;
end;

function THistoryDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var h: TOldHistoryElement;
begin
{
  action_id,
  action_type_id,
  action_reason_id,
  dtm_action_date,
  vch_Action_Reason_Details,
  Object_UIN,
  num_Object_Type,
  Client_App_Type_ID,
  Employee_ID
}
  h := AbaseObject as TOldHistoryElement;
  Result := varArrayOf([h.ID,
                        h.ActionTypeID,
                        h.ActionReasonID,
                        h.ActionDate,
                        h.Comment,
                        h.HistoryOwner.ID,
                        h.HistoryOwner.ObjectType,
                        TMainFacade.GetInstance.ClientAppTypeID,
                        TMainFacade.GetInstance.DBGates.EmployeeID,
                        (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);

end;

function THistoryDataPoster.GetProxy(const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure THistoryDataPoster.InitElement(AHistoryElement: TOldHistoryElement;
  AIndex: integer; AData: variant);
begin
{
  0 action_id,
  1 action_type_id,
  2 vch_action_type_name,
  3 action_reason_id,
  4 vch_action_reason,
  5 dtm_action_date,
  6 vch_Action_Reason_Details,
  7 dtm_Last_Modify_Date,
  8 dtm_Entering_Date,
  9 Employee_ID,
  10 vch_Employee_Name,
  11 Object_UIN,
  12 num_Object_Type
}

{
  0 action_id,
}
  AHistoryElement.ID := AData[0, AIndex];
{
  1 action_type_id,
  2 vch_action_type_name,
}
  AHistoryElement.ActionTypeID := AData[1, AIndex];
  AHistoryElement.ActionType := AData[2, AIndex];
{
  3 action_reason_id,
  4 vch_action_reason,
}
  AHistoryElement.ActionReasonID := AData[3, AIndex];
  AHistoryElement.ActionReason := AData[4, AIndex];

{
  5 dtm_action_date,
}
  AHistoryElement.ActionDate := varAsType(AData[5, AIndex], varDate);
{
  6 vch_Action_Reason_Details,
}
  AHistoryElement.Comment := AData[6, AIndex];

{
  7 dtm_Last_Modify_Date,
}
  AHistoryElement.RealDate := varAsType(AData[7, AIndex], varDate);

{  9 Employee_ID,
  10 vch_Employee_Name,
}
  AHistoryElement.EmployeeID := AData[9, AIndex];
  AHistoryElement.Employee := AData[10, AIndex];
end;

procedure THistoryDataPoster.Prepare;
begin
  FObjectClass := TOldHistoryElement;
  FCollectionClass := TOldHistory;

  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'dtm_action_date';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Action';
  FQuery := 'select ' +
            'action_id, ' +
            'action_type_id, vch_action_type_name, ' +
            'action_reason_id, vch_action_reason, ' +
            'dtm_action_date, vch_Action_Reason_Details, ' +
            'dtm_Last_Modify_Date, dtm_Entering_Date, ' +
            'Employee_ID, vch_Employee_Full_Name, ' +
            'Object_UIN, num_Object_Type ' +
            'from vw_Action ';
//             + 'where Version_ID = ' + IntToStr(ActiveVersion.ID);
  FKeyColumn := 'Action_ID';
  FDeletingTable := 'spd_Delete_Action';
  FInsertReturnsData := true;
end;

{ TStructureHistoryDataPoster }


function TStructureHistoryDataPoster.GetObject(
  AData: variant): TBaseCollection;
var i: integer;
    h: TOldStructureHistoryElement;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldHistory.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
{
  0 action_id,
  1 action_type_id,
  2 vch_action_type_name,
  3 action_reason_id,
  4 vch_action_reason,
  5 dtm_action_date,
  6 vch_Action_Reason_Details,
  7 dtm_Last_Modify_Date,
  8 dtm_Entering_Date,
  9 Employee_ID,
  10 vch_Employee_Name,
  11 Object_UIN,
  12 num_Object_Type
  13 Last_Fund_Type_ID,
  14 vch_Last_Fund_Type_Name,
  15 Fund_Type_ID,
  16 vch_Fund_Type_Name

}
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    h := (Result as TOldStructureHistory).Add;

    InitElement(h, i, AData);

    h.LastFundTypeID := AData[13, i];
    h.LastFundType := AData[14, i];

    h.FundTypeID := AData[15, i];
    h.FundType := AData[16, i];
  end;
end;

function TStructureHistoryDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var h: TOldStructureHistoryElement;
    vStructureLastFundID: variant;
    vActionReasonID: variant;
begin
{
  action_id,
  action_type_id,
  action_reason_id,
  dtm_action_date,
  vch_Action_Reason_Details,
  Last_Fund_Type_ID,
  Fund_Type_ID,
  Object_UIN,
  num_Object_Type,
  Client_App_Type_ID,
  Employee_ID
}
  h := AbaseObject as TOldStructureHistoryElement;

  if h.LastFundTypeID > 0 then
    vStructureLastFundID := h.LastFundTypeID
  else
    vStructureLastFundID := null;

  if h.ActionReasonID > 0 then
    vActionReasonID := h.ActionReasonID
  else
    vActionReasonID := null;

  Result := varArrayOf([h.ID,
                        h.ActionTypeID,
                        vActionReasonID,
                        h.ActionDate,
                        h.Comment,
                        vStructureLastFundID,
                        h.FundTypeID,
                        h.HistoryOwner.ID,
                        h.HistoryOwner.ObjectType,
                        TMainFacade.GetInstance.ClientAppTypeID,
                        TMainFacade.GetInstance.DBGates.EmployeeID,
                        (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);

end;

function TStructureHistoryDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TStructureHistoryDataPoster.Prepare;
begin
  inherited Prepare;
  FObjectClass := TOldStructureHistoryElement;
  FCollectionClass := TOldStructureHistory;


  FQuery := 'select action_id, ' +
            'action_type_id, vch_action_type_name, ' +
            'action_reason_id, vch_action_reason, ' +
            'dtm_action_date, vch_Action_Reason_Details, ' +
            'dtm_Last_Modify_Date, dtm_Entering_Date, ' +
            'Employee_ID, vch_Employee_Full_Name, ' +
            'Object_UIN, num_Object_Type, ' +
            'Last_Structure_Fund_Type_ID, vch_Last_Struct_Fund_Type_Name, ' +
            'Structure_Fund_Type_ID, vch_Structure_Fund_Type_Name ' +
            'from vw_Action ';
//             + 'where Version_ID = ' + IntToStr(ActiveVersion.ID);
            


  FPostingTable := 'spd_Add_Structure_Action';
end;

{ TConcretePosters }

constructor TConcretePosters.Create;
begin
  inherited;
  // заранее создаваемые постеры
  Posters[TStructureDataPoster];
  Posters[THorizonDataPoster];
  Posters[TSubstructureDataPoster];
  Posters[TBedDataPoster];
  Posters[TLayerDataPoster];      

end;

{ TDrilledStructureAreaWellDataPoster }

function TDrilledStructureAreaWellDataPoster.GetObject(
  AData: variant): TBaseCollection;
var i: integer;
    w: TOldDrilledStructureWell;
begin
  if Assigned(FLastGotCollection) then
    FLastGotCollection.Clear;

  Result := FLastGotCollection;
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    w := (Result as TOldDrilledStructureWells).Add;
{

            'w.vch_area_name, ' +
            'w.vch_well_num, ' +
            'w.VCH_CATEGORY_NAME, ' +
            'w.VCH_DISTRICT, ' +
            'w.VCH_NGO, ' +
            'w.VCH_REGION_FULL_NAME, ' +
            'DTM_DRILLING_START, ' +
            'DTM_DRILLING_FINISH, ' +
            'dsw.structure_id, ' +
            'w.num_Rotor_Altitude, ' +
            'w.num_True_Depth, '


}
    w.ID := AData[0, i];
    w.AreaName := AData[1, i];
    w.WellNum  := AData[2, i];
    w.Altitude := AData[10, i];
    w.Depth    := AData[11, i];
  end;
end;



procedure TDrilledStructureAreaWellDataPoster.Prepare;
begin
  inherited;
  FQuery := 'select w.well_uin, ' +
            'w.vch_area_name, ' +
            'w.vch_well_num, ' +
            'w.VCH_CATEGORY_NAME, ' +
            'w.VCH_DISTRICT, ' +
            'w.VCH_NGO, ' +
            'w.VCH_REGION_FULL_NAME, ' +
            'DTM_DRILLING_START, ' +
            'DTM_DRILLING_FINISH, ' +
            'w.Area_id, ' +
            'w.num_Rotor_Altitude, ' +
            'w.num_True_Depth ' +
            'from ' +
            'vw_well_main_info w ';
end;

{ THorizonFundTypeDataPoster }

function THorizonFundTypeDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := null;
  if ABaseObject is  TOldHorizon then
    Result := varArrayOf([(ABaseObject as TOldHorizon).ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID])
  else
  if (ABaseObject is TOldFundType) then
    Result := varArrayOf([(((ABaseObject as TOldFundType).Collection as TBaseCollection).Owner as TOldHorizon).ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID])
end;

function THorizonFundTypeDataPoster.GetDeletingData(
  ABaseCollection: TBaseCollection): OleVariant;
begin
  Result := varArrayOf([(ABaseCollection.Owner as TOldHorizon).ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
end;

function THorizonFundTypeDataPoster.GetObject(
  AData: variant): TBaseCollection;
var ft: TOldFundType;
    i: integer;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldFundTypes.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    ft := (Result as TOldFundTypes).Add;
    {
      0 sf.Structure_Fund_Type_ID,
      1 sfd.vch_Structure_Fund_Type_Name,
      2 sfd.vch_Fund_Type_Short_Name
    }
    ft.ID := AData[0, i];
    ft.FundTypeName := AData[1, i];
  end;
end;

function THorizonFundTypeDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var ft: TOldFundType;
    h: TOldHorizon;
begin
  ft := ABaseObject as TOldFundType;
  Result := null;

  if (ft.Collection as TBaseCollection).Owner is TOldHorizon then
  begin
    h := (ft.Collection  as TBaseCollection).Owner as  TOldHorizon;
    Result := varArrayOf([ft.ID, h.ID, (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID]);
  end;
end;

function THorizonFundTypeDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure THorizonFundTypeDataPoster.Prepare;
begin
  FObjectClass := TOldFundType;
  FCollectionClass := TOldFundTypes;

  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'sf.Structure_Fund_Type_ID';

  FPostingTable := 'tbl_Stratum_Set_Fund_Type';
  FPostingColumns := 'Structure_Fund_Type_ID, Structure_Stratum_ID, Version_ID';
  FQuery := 'select distinct sf.Structure_Fund_Type_ID, sfd.vch_Structure_Fund_Type_Name, sfd.vch_struct_fund_type_short_name  ' +
            'from tbl_Stratum_Set_Fund_Type sf, tbl_Structure_Fund_Type_Dict sfd ' +
            'where sf.Structure_Fund_Type_ID = sfd.Structure_Fund_Type_ID';
//          +'and Version_ID = ' + IntToStr(ActiveVersion.ID);

  FKeyColumn := 'Structure_Stratum_ID';
  FDeletingTable := 'tbl_Stratum_Set_Fund_Type';
  FInsertReturnsData := false;
end;

{ TDocumentPoster }

function TDocumentDataPoster.ExtendedPost(
  ABaseObject: TBaseObject): integer;
var d: TOldDocument;
    fsSource, fsDest: TFileStream;
begin
  Result := inherited ExtendedPost(ABaseObject);
  d := ABaseObject as TOldDocument;
  if d.PreLocation <> d.Location then
  begin

    // пишем новый файл
    // удалить старый было бы неплохо
    // но не будем, вдруг на него тоже кто-то ссылается
    fsSource := TFileStream.Create(d.PreLocation, fmOpenRead);
    fsDest := TFileStream.Create(d.Location, fmCreate);
    try
      fsDest.CopyFrom(fsSource, fsSource.Size);
    finally
      fsSource.Free;
      fsDest.Free;
    end;
  end;
end;

function TDocumentDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := VarArrayOf([ABaseObject.ID]);
end;

function TDocumentDataPoster.GetObject(AData: variant): TBaseCollection;
var i: integer;
    d: TOldDocument;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldDocuments.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
{
  0 material_id,
  1 vch_material_header,
  2 vch_authors,
  3 dtm_creation_date,
  4 vch_location,
  5 vch_comments,
  6 m.theme_id
  7 vch_theme_name,
  8 organization_id,
  9 vch_org_full_name,
  10 medium_id,
  11 vch_medium_name,
  12 material_type_id,
  13 vch_material_type_name,
  14 vch_user_bind_attributes
}
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    d := (Result as TOldDocuments).Add;
{
  0 material_id,
  1 vch_material_header,
  2 vch_authors,
  3 dtm_creation_date,
  4 vch_location,
  5 vch_comments,
}

    d.ID := AData[0, i];
    d.DocName := AData[1, i];
    d.Authors := AData[2, i];
    d.CreationDate := AData[3, i];
    d.PreLocation := AData[4, i];
    d.Comment := AData[5, i];

{
  6 m.theme_id
  7 vch_theme_name,
}
    d.ThemeID := AData[6, i];
    d.ThemeName := AData[7, i];
{
  8 organization_id,
  9 vch_org_full_name,
}
    d.OrganizationID := AData[8, i];
    d.OrganizationName := AData[9, i];
{
  10 medium_id,
  11 vch_medium_name,

}
    d.MediumID := AData[10, i];
    d.MediumName := AData[11, i];
{
  12 material_type_id,
  13 vch_material_type_name,
  14 vch_user_bind_attributes
}
    d.MaterialTypeID := AData[12, i];
    d.MaterialType := AData[13, i];
    d.UserBindAttrbutes := AData[14, i];
  end;
end;

function TDocumentDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var d: TOldDocument;
begin
  d := ABaseObject as TOldDocument;
{
    MATERIAL_ID INTEGER,
    VCH_HEADER VARCHAR(2500),
    VCH_AUTHORS VARCHAR(255),
    DTM_CREATION_DATE DATE,
    VCH_LOCATION VARCHAR(255),
    VCH_COMMENTS VARCHAR(8000),
    THEME_ID INTEGER,
    ORGANIZATION_ID INTEGER,
    MEDIUM_ID INTEGER,
    MATERIAL_TYPE_ID INTEGER,
    VCH_BIND_ATTRIBUTES VARCHAR(8000),
    VCH_USER_BIND_ATTRIBUTES VARCHAR(8000),
    Binding_Object_ID integer
    num_Object_Type
}
  Result := varArrayOf([d.ID, d.DocName, d.Authors, d.CreationDate,
                        sDocPath,
                        d.FileName,
                        d.Comment, d.ThemeID, d.OrganizationID, d.MediumID,
                        d.MaterialTypeID, d.BindAttributes, d.UserBindAttrbutes,
                        ((d.Collection as TBaseCollection).Owner as TOldAccountVersion).ID,
                        ((((d.Collection as TBaseCollection).Owner as TOldAccountVersion).Collection as TBaseCollection).Owner as TBaseObject).ID,
                        ((((d.Collection as TBaseCollection).Owner as TOldAccountVersion).Collection as TBaseCollection).Owner as TBaseObject).MaterialBindType]);

end;

function TDocumentDataPoster.GetProxy(const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TDocumentDataPoster.Prepare;
begin
  FObjectClass := TOldDocument;
  FCollectionClass := TOldDocuments;

  FGettingTable := '';
  FGettingColumns := '';

  FQuery := 'select material_id, vch_material_header, vch_authors, ' +
                     'dtm_creation_date, vch_location, vch_comments, theme_id, ' +
                     'vch_theme_name, organization_id, vch_org_full_name, ' +
                     'medium_id, vch_medium_name, material_type_id, vch_material_type_name, ' +
                     'vch_user_bind_attributes from vw_Materials ';


  FOrder := '';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Structure_Material';
  FKeyColumn := 'Material_ID';
  FDeletingTable := 'spd_Delete_Structure_Material';
  FInsertReturnsData := true;
end;

{ TVersionDataPoster }

function TVersionDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := varArrayOf([ABaseObject.ID]);
end;

function TVersionDataPoster.GetObject(AData: variant): TBaseCollection;
var i: integer;
    v: TOldVersion;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldVersions.Create(nil)
  else
  if ClearFirst then FLastGotCollection.Clear;


  Result := FLastGotCollection;
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    if not ClearFirst then
      v := (Result as TOldVersions).ItemsByUIN[AData[0, i]] as TOldVersion
    else v := nil;

    if not Assigned(v) then v:= (Result as TOldVersions).Add;

    v.ID  := AData[0, i];
    v.VersionName := AData[1, i];
    v.VersionReason := AData[2, i];
    v.VersionDate := AData[3, i];
  end;
end;

function TVersionDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var v: TOldVersion;
begin
 {
    VERSION_ID INTEGER,
    VCH_VERSION_NAME VARCHAR(255),
    VCH_VERSION_REASON VARCHAR(255),
    DTM_VERSION_DATE DATE,
    EMPLOYEE_ID SMALLINT
 }

  v := ABaseObject as TOldVersion;
  Result := varArrayOf([v.ID, v.VersionName,
                        v.VersionReason, v.VersionDate,
                        TMainFacade.GetInstance.DBGates.EmployeeID]);

end;

function TVersionDataPoster.GetProxy(const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TVersionDataPoster.Prepare;
begin
  FObjectClass := TOldVersion;
  FCollectionClass := TOldVersions;

  FGettingTable := 'tbl_Object_Version';
  FGettingColumns := 'Version_ID, vch_Version_Name, vch_Version_Reason, dtm_Version_Date';

  FOrder := 'vch_Version_Name';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_Object_Version';
  FQuery := '';
  FKeyColumn := 'Version_ID';
  FDeletingTable := 'spd_Delete_Object_Version';
  FOrder := 'Version_ID';

end;

{ TLicenseZoneDataPoster }

function TLicenseZoneDataPoster.ExtendedPost(
  ABaseObject: TBaseObject): integer;
begin
  Result := 0;
end;

function TLicenseZoneDataPoster.GetDeletingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := varArrayOf([ABaseObject.ID]);
end;

function TLicenseZoneDataPoster.GetObject(AData: variant): TBaseCollection;
var lz: TOldLicenseZone;
    i: integer;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldStructures.Create(nil)
  else
  if ClearFirst then FLastGotCollection.Clear;


  Result := FLastGotCollection;
  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    if not ClearFirst then
      lz := (Result as TOldLicenseZones).ItemsByUIN[AData[0, i]] as TOldLicenseZone
    else lz := nil;

    if not Assigned(lz) then lz := (Result as TOldLicenseZones).Add;

{
    LICENSE_ZONE_ID,
    VCH_LICENSE_NUM,
    DTM_REG_DATE,
    VCH_LICENSE_ZONE_NAME,
}

    lz.ID  := AData[0, i];
    lz.License.LicenseZoneNum := AData[1, i];
    lz.LicenseZoneName := AData[2, i];

{
    LICENSE_ZONE_TYPE_ID,
    VCH_LICENSE_ZONE_TYPE_NAME,
    VCH_LICENSE_ZONE_TP_SHORT_NAME,
}
    lz.License.LicenzeZoneTypeID := AData[3, i];
    lz.License.LicenzeZoneType := AData[4, i];

{
    NUM_AREA,
    NUM_DEPTH_FROM,
    NUM_DEPTH_TO,
}
    lz.Area := AData[6, i];
    lz.DepthFrom := AData[7, i];
    lz.DepthTo := AData[8, i];
{
    DISTRICT_ID,
    VCH_DISTRICT_NAME,
    LICENSE_ZONE_STATE_ID,
    VCH_LICENSE_ZONE_STATE_NAME,
}
    lz.DistrictID := AData[9, i];
    lz.District := AData[10, i];
    lz.LicenseZoneStateID := AData[11, i];
    lz.LicenseZoneState := AData[12, i];

{
    ORGANIZATION_ID,
    VCH_ORG_FULL_NAME,
    VCH_ORG_SHORT_NAME,
}
    lz.License.OwnerOrganizationID := AData[13, i];
    lz.License.OwnerOrganizationName := AData[14, i];

{
    LICENSE_TYPE_ID,
    VCH_LICENSE_TYPE_NAME,
    VCH_LIC_TYPE_SHORT_NAME,
}

    lz.License.LicenseTypeID := AData[16, i];
    lz.License.LicenseType := AData[17, i];
    lz.License.LicenseTypeShortName := AData[18, i];

{
    DTM_REGISTRATION_DATE,
    DTM_REGISTRATION_DATE_FINISH,
    VCH_LICENSE_NAME,
    VERSION_ID
}
    lz.License.RegistrationStartDate := AData[19, i];
    lz.License.RegistrationFinishDate := AData[20, i];
    lz.License.LicenseTitle := AData[21, i];

{
    competition_type_id,
    vch_competition_type_name,
    dtm_competition_date,
    vch_Seria 
}
    lz.CompetitionID := AData[23, i];
    lz.CompetitionName := AData[24, i];
    lz.CompetitionDate := AData[25, i];
    lz.License.Seria := AData[26, i];


{
    issuer_organization_id,
    vch_issuer_org_full_name,
    vch_issuer_org_short_name,
    vch_issuer_subject
}

    lz.License.IssuerID := AData[27, i];
    lz.License.IssuerName := AData[28, i];
    lz.License.IssuerSubject := AData[30, i];

{
     site_holder_organization_id,
     dtm_site_holding_date,
     vch_site_holder_document,
     vch_site_holder_org_full_name,
     vch_site_holder_org_short_name
}
     lz.License.SiteHolderID := AData[31, i];
     lz.License.DocHolderDate := AData[32, i];
     lz.License.DocHolder := AData[33, i];
     lz.License.SiteHolder := AData[34, i];

{
      DEVELOPER_ORGANIZATION_ID,
      VCH_DEVELOPER_ORG_FULL_NAME,
      VCH_DEVELOPER_ORG_SHORT_NAME,
}

     lz.License.DeveloperOrganizationID := AData[36, i];
     lz.License.DeveloperOrganizationName := AData[37, i];

{
      NGDR_ID,
      VCH_NGDR_NAME
}

     lz.NGDRID := AData[39, i];
     lz.NGDRName := AData[40, i];

  end;
end;

function TLicenseZoneDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
var lz: TOldLicenseZone;
    vTectonicStructID, vPetrolRegionID, vLicenseZoneStateID,
    vDistrictID, vOwnerOrganizationID, vLicenzeZoneTypeID, vLicenseTypeID,
    vDeveloperOrganizationID, vSiteHolderID, vIssuerID, vCompetitionID, vCompetitionDate, vNGDRID: variant;
begin
  lz := ABaseObject as TOldLicenseZone;

  {
    LICENSE_ZONE_ID INTEGER,
    VERSION_ID SMALLINT,
    STRUCT_ID INTEGER,
    PETROL_REGION_ID INTEGER,
    LICENSE_ZONE_STATE_ID SMALLINT,
    DISTRICT_ID SMALLINT,
    EMPLOYEE_ID SMALLINT,
    UPDATE_EMPLOYEE_ID SMALLINT,
    VCH_LICENSE_ZONE_NAME VARCHAR(1000),
    NUM_AREA NUMERIC(9,2),
    NUM_DEPTH_FROM NUMERIC(10,4),
    NUM_DEPTH_TO NUMERIC(10,4),
    LICENSE_ID INTEGER,
    ORGANIZATION_ID INTEGER,
    LICENSE_ZONE_TYPE_ID SMALLINT,
    LICENSE_TYPE_ID SMALLINT,
    VCH_LICENSE_NUM VARCHAR(30),
    VCH_LICENSE_NAME VARCHAR(8000),
    DTM_REGISTRATION_DATE DATE,
    DTM_REGISTRATION_DATE_FINISH DATE

  }

  if lz.TectonicStructID > 0 then vTectonicStructID := lz.TectonicStructID
  else vTectonicStructID := null;

  if lz.PetrolRegionID > 0 then vPetrolRegionID := lz.PetrolRegionID
  else vPetrolRegionID := null;

  if lz.DistrictID > 0 then vDistrictID := lz.DistrictID
  else vDistrictID := null;

  if lz.LicenseZoneStateID > 0 then vLicenseZoneStateID := lz.LicenseZoneStateID
  else vLicenseZoneStateID := null;

  if lz.License.OwnerOrganizationID > 0 then vOwnerOrganizationID := lz.License.OwnerOrganizationID
  else vOwnerOrganizationID := null;

  if lz.License.DeveloperOrganizationID > 0 then vDeveloperOrganizationID := lz.License.DeveloperOrganizationID
  else vDeveloperOrganizationID := null;

  if lz.License.SiteHolderID > 0 then vSiteHolderID := lz.License.SiteHolderID
  else vSiteHolderID := null;

  if lz.License.IssuerID > 0 then vIssuerID := lz.License.IssuerID
  else vIssuerID := null;

  if lz.License.LicenzeZoneTypeID > 0 then vLicenzeZoneTypeID := lz.License.LicenzeZoneTypeID
  else vLicenzeZoneTypeID := null;

  if lz.License.LicenseTypeID > 0 then vLicenseTypeID := lz.License.LicenseTypeID
  else vLicenseTypeID := null;

  if lz.CompetitionID > 0 then
  begin
    vCompetitionID := lz.CompetitionID
  end
  else
  begin
    vCompetitionID := null;
    vCompetitionDate := null;
  end;

  if lz.NGDRID > 0 then
    vNgdrID := lz.NGDRId
  else
    vNgdrID := null;


{
    Developer_Organization_ID integer,
    Site_Holder_Organization_ID integer,
    dtm_Site_Holding_Date date,
    vch_Site_Holder_Document varchar(2500),
    Issuer_Organization_ID integer,
    vch_Issuer_Subject varchar(200)

}



  Result := varArrayOf([lz.ID,
                        (TMainFacade.GetInstance as TMainFacade).ActiveVersion.ID,
                        vTectonicStructID,
                        vPetrolRegionID,
                        vLicenseZoneStateID,
                        vDistrictID,
                        TMainFacade.GetInstance.DBGates.EmployeeID,
                        TMainFacade.GetInstance.DBGates.EmployeeID,
                        lz.LicenseZoneName,
                        lz.Area,
                        lz.DepthFrom,
                        lz.DepthTo,
                        vOwnerOrganizationID,
                        vLicenzeZoneTypeID,
                        vLicenseTypeID,
                        lz.License.LicenseZoneNum,
                        lz.License.LicenseTitle,
                        lz.License.RegistrationStartDate,
                        lz.License.RegistrationFinishDate,
                        vDeveloperOrganizationID,
                        vSiteHolderID,
                        lz.License.DocHolderDate,
                        lz.License.DocHolder,
                        vIssuerID,
                        lz.License.IssuerSubject,
                        vCompetitionID,
                        vCompetitionDate,
                        lz.License.Seria,
                        vNGDRID]);
end;

function TLicenseZoneDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TLicenseZoneDataPoster.Prepare;
begin
  FObjectClass := TOldLicenseZone;
  FCollectionClass := TOldLicenseZones;

  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'vch_License_Zone_Name';

  FPostingColumns := '*';
  FPostingTable := 'spd_Add_License_Zone_All';
  FQuery := 'select LICENSE_ZONE_ID, VCH_LICENSE_NUM, VCH_LICENSE_ZONE_NAME, ' +
            'LICENSE_ZONE_TYPE_ID, VCH_LICENSE_ZONE_TYPE_NAME, VCH_LICENSE_ZONE_TP_SHORT_NAME, ' +
            'NUM_AREA, NUM_DEPTH_FROM, NUM_DEPTH_TO, DISTRICT_ID, VCH_DISTRICT_NAME, ' +
            'LICENSE_ZONE_STATE_ID, VCH_LICENSE_ZONE_STATE_NAME, ORGANIZATION_ID, ' +
            'VCH_ORG_FULL_NAME, VCH_ORG_SHORT_NAME, LICENSE_TYPE_ID, VCH_LICENSE_TYPE_NAME, ' +
            'VCH_LIC_TYPE_SHORT_NAME, DTM_REGISTRATION_DATE, DTM_REGISTRATION_DATE_FINISH, ' +
            'VCH_LICENSE_NAME, VERSION_ID,   competition_type_id,   vch_competition_type_name,   dtm_competition_date, vch_Seria, ' +
            'issuer_organization_id, vch_issuer_org_full_name, vch_issuer_org_short_name, vch_issuer_subject, ' +
            'site_holder_organization_id, dtm_site_holding_date, vch_site_holder_document, vch_site_holder_org_full_name, vch_site_holder_org_short_name, ' +
            'DEVELOPER_ORGANIZATION_ID, VCH_DEVELOPER_ORG_FULL_NAME, VCH_DEVELOPER_ORG_SHORT_NAME, NGDR_ID, VCH_NGDR_NAME ' +
            'from vw_license_zones';

  FKeyColumn := 'LICENSE_ZONE_ID';
  FDeletingTable := 'spd_Delete_License_Zone';
end;

{ TFieldReserveDataPoster }

function TFieldReserveDataPoster.GetDeletingData(
  ABaseCollection: TBaseCollection): OleVariant;
begin
  Result := null;
end;

function TFieldReserveDataPoster.GetObject(
  AData: variant): TBaseCollection;
var R: TOldReserve;
    i: integer;
begin
  if not Assigned(FLastGotCollection) then
    FLastGotCollection := TOldReserves.Create(nil)
  else FLastGotCollection.Clear;

  Result := FLastGotCollection;
{
   0 STRUCTURE_ID,
}

  if not varIsEmpty(AData) then
  for i := 0 to varArrayHighBound(AData, 2) do
  begin
    R := (Result as TOldReserves).Add;
{

   1 FLUID_TYPE_ID,
   2 VCH_FLUID_TYPE_NAME,
   3 VCH_FLUID_SHORT_NAME,

}
    R.FluidTypeID := AData[1, i];
    R.FluidType := AData[2, i];
{

   4 CATEGORY_ID
   5 VCH_CATEGORY_NAME
   6 VCH_CATEGORY_SHORT_NAME
}
    R.ReserveCategoryID := AData[4, i];
    R.ReserveCategory := AData[5, i];
{
   7 RESERVES_KIND_ID
   8 VCH_RESERVES_KIND_NAME
}
   R.ReserveKindID := AData[7, i];
   R.ReserveKind   := AData[8, i];
{
   9 NUM_VALUE
}
    R.Value := AData[9, i];

{
   10 DOCUMENT_ID
   11 resource_type_id,
   12 vch_resource_type,
}

    r.ReserveTypeID := AData[11, i];
    r.ReserveType := AData[12, i];

{   13 reserve_value_type_id,
    14 vch_value_type_name,
    15 License_Zone_ID
}
    r.ReserveValueTypeID := AData[13, i];
    r.ReserveValueTypeName := AData[14, i];

    r.LicenseZone := TMainFacade.GetInstance.AllLicenseZones.ItemsByID[AData[15, i]] as TSimpleLicenseZone;
  end;
end;

function TFieldReserveDataPoster.GetPostingData(
  ABaseObject: TBaseObject): OleVariant;
begin
  Result := null;
end;

function TFieldReserveDataPoster.GetProxy(
  const AUIN: integer): TBaseCollection;
begin
  Result := nil;
end;

procedure TFieldReserveDataPoster.Prepare;
begin
  FObjectClass := TOldReserve;
  FCollectionClass := TOldReserves;

  FGettingTable := '';
  FGettingColumns := '';

  FOrder := 'VCH_CATEGORY_NAME, vch_resource_type';

  FPostingColumns := '';
  FPostingTable := '';
  FQuery := 'select ' +
            'STRUCTURE_ID, ' +
            'FLUID_TYPE_ID, VCH_FLUID_TYPE_NAME, VCH_FLUID_SHORT_NAME, ' +
            'CATEGORY_ID, VCH_CATEGORY_NAME, VCH_CATEGORY_SHORT_NAME, ' +
            'RESERVES_KIND_ID, VCH_RESERVES_KIND_NAME, ' +
            'NUM_VALUE, DOCUMENT_ID, resource_type_id, vch_resource_type, ' +
            'reserve_value_type_id, vch_value_type_name, License_Zone_ID ' +
            'from vw_FIELD_Reserve ';
  FKeyColumn := 'STRUCTURE_ID';
  FDeletingTable := '';
  FInsertReturnsData := false;
end;

end.
