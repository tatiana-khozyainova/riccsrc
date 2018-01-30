unit LicenseZoneReports;

interface

uses SDReport, Classes, RRManagerObjects, CommonReport, Version, Contnrs;

type
  TLicenseZoneBlankReport = class(TSDSQLCollectionReport)
  private
    function GetOldLicenseZone: TOldLicenseZone;
   protected
     procedure InternalOpenTemplate; override;
     procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
   public
     property  LicenseZone: TOldLicenseZone read GetOldLicenseZone;
     procedure PrepareReport; override;
     constructor Create(AOwner: TComponent); override;
   end;

  TDrillingResultBlankReport = class(TSDSQLCollectionReport)
  private
    function GetOldLicenseZone: TOldLicenseZone;
   protected
     procedure InternalOpenTemplate; override;
     procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
   public
     property  LicenseZone: TOldLicenseZone read GetOldLicenseZone;
     procedure PrepareReport; override;
     constructor Create(AOwner: TComponent); override;
   end;


   TSeismicResultBlankReport = class(TSDSQLCollectionReport)
   private
    function GetOldLicenseZone: TOldLicenseZone;
   protected
     procedure InternalOpenTemplate; override;
     procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
   public
     property  LicenseZone: TOldLicenseZone read GetOldLicenseZone;
     procedure PrepareReport; override;
     constructor Create(AOwner: TComponent); override;
   end;


   TNIRResultBlankReport = class(TSDSQLCollectionReport)
   private
    function GetOldLicenseZone: TOldLicenseZone;
   protected
     procedure InternalOpenTemplate; override;
     procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
   public
     property  LicenseZone: TOldLicenseZone read GetOldLicenseZone;
     procedure PrepareReport; override;
     constructor Create(AOwner: TComponent); override;
   end;

   TDrillingAccDTOList = class;
   TSeismicAccDTOList = class;
   TNirAccDTOList = class;

   TLicenseForReportDTO = class
   private
     FLicenseZoneID: integer;
     FLicenseID: integer;
     FLicenseZoneNumber: string;
     FLicenseZoneName: string;
     FLicenseZoneFullNumber: string;
     FLicenzeOrganizationFullName: string;
     FLicenseOrganizationID: integer;
     FDistrict: string;
     FSeismicCount: Integer;
     FDrillingCount: integer;
     FNIRCount: Integer;
     FDrillingAccDTOList: TDrillingAccDTOList;
     FSeismicAccDTOList: TSeismicAccDTOList;
     FNIRAccDTOList: TNirAccDTOList;
     function GetIsEmpty: boolean;
     function GetDrillingAccDTOList: TDrillingAccDTOList;
     function GetSeismicAccDTOList: TSeismicAccDTOList;
     function GetNIRAccDTOList: TNirAccDTOList;
   public
     property LicenseZoneID: integer read FLicenseZoneID;
     property LicenseID: integer read FLicenseID;
     property LicenseOrganizationID: integer read FLicenseOrganizationID;

     property LicenseZoneNumber: string read FLicenseZoneNumber;
     property LicenseZoneFullNumber: string read FLicenseZoneFullNumber;
     property LicenseZoneName: string read FLicenseZoneName;
     property LicenseOrganizationFullName: string read FLicenzeOrganizationFullName;
     property District: string read FDistrict;

     property DrillingCount: integer read FDrillingCount;
     property SeismicCount: Integer read FSeismicCount;
     property NIRCount: Integer read FNIRCount;

     property IsEmpty: boolean read GetIsEmpty;
     property DrillingAccDTOList: TDrillingAccDTOList read GetDrillingAccDTOList;
     property SeismicAccDTOList: TSeismicAccDTOList read GetSeismicAccDTOList;
     property NIRAccDTOList: TNirAccDTOList read GetNIRAccDTOList;

     destructor Destroy; override;
   end;


   TDrillingAccDTO = class
   private
     FCategoryID: Integer;
     FTrueDepth: Single;
     FAreaName: string;
     FWellNum: string;
     FCategory: string;
     FStraton: string;
     FCost: Double;
     FRate: Single;
     FWellUIN: integer;
     FID: Integer;
     function GetIsStruct: boolean;
   public
     property ID: integer read FID;
     property WellUIN: integer read FWellUIN;
     property AreaName: string read FAreaName;
     property WellNum: string read FWellNum;
     property TrueDepth: Single read FTrueDepth;
     property Straton: string read FStraton;
     property Category: string read FCategory;
     property CategoryID: Integer read FCategoryID;

     property Rate: Single read FRate;
     property Cost: Double read FCost;


     property IsStruct: boolean read GetIsStruct;
   end;

   TSeisWorkType = (swt2D, swt3D, swtVSP, swtElectro, swtSeisCarotage);

   TSeismicAccDTO = class
   private
     FID: integer;
     FWorkTypeID: integer;
     FVolume: Single;
     FCost: Double;
     FSeismicPlace: string;
     FWorkType: string;
     FStateID: integer;
     FState: string;
     function GetSeisWorkType: TSeisWorkType;
   public
     property ID: Integer read FID;
     property SeismicPlace: string read FSeismicPlace;
     property Volume: Single read FVolume;
     property Cost: Double read FCost;
     property WorkType: string read FWorkType;
     property WorkTypeID: integer read FWorkTypeID;
     property StateID: integer read FStateID;
     property State: string read FState;

     property SeisWorkType: TSeisWorkType read GetSeisWorkType;
   end;

   TNirType = (ntGeochem, ntNir, ntSuper, ntOther);

   TNIRAccDTO = class
   private
     FCost: double;
     FID: integer;
     FMainNirTypeID: integer;
     FStateID: Integer;
     FMainNirType: string;
     FWorkDescription: string;
     FState: string;
    function GetNirType: TNirType;
   public
     property ID: integer read FID;
     property Cost: double read FCost;

     property MainNirTypeID: integer read FMainNirTypeID;
     property MainNirType: string read FMainNirType;

     property StateID: Integer read FStateID;
     property State: string read FState;

     property WorkDescription: string read FWorkDescription;
     property NirType: TNirType read GetNirType;
   end;

   TOverallDTO = class
   private
     FNIRCost: double;
     FProspectDrillCost: double;
     FGeochemCost: double;
     FSuperCost: double;
     FCost2D: double;
     FElectroCost: double;
     FStructDrillCost: double;
     FCost3D: double;
     FOtherCost: double;
     FVolume2D: single;
     FVolume3D: single;
     FStructDrillRate: single;
     FElectroVolume: single;
     FProspectDrillRate: single;
     FVSPCost: double;
     FOrganizationID: integer;
     FOrganizationName: string;
     function GetOverallCost: double;
   public
     property OrganizationID: integer read  FOrganizationID;
     property OrganizationName: string read FOrganizationName;

     property StructDrillRate: single read FStructDrillRate;
     property StructDrillCost: double read FStructDrillCost;
     property ProspectDrillRate: single read FProspectDrillRate;
     property ProspectDrillCost: double read FProspectDrillCost;
     property Volume2D: single read FVolume2D;
     property Cost2D: double read FCost2D;
     property Volume3D: single read FVolume3D;
     property Cost3D: double read FCost3D;
     property VSPCost: double read FVSPCost;
     property ElectroVolume: single read FElectroVolume;
     property ElectroCost: double read FElectroCost;
     property GeochemCost: double read FGeochemCost;
     property NIRCost: double read FNIRCost;
     property SuperCost: double read FSuperCost;
     property OtherCost: double read FOtherCost;
     property OverallCost: double read GetOverallCost;
   end;

   TLicenseForReportDTOList = class(TObjectList)
   private
     function GetItems(const Index: integer): TLicenseForReportDTO;
   public
     property Items[const Index: integer]: TLicenseForReportDTO read GetItems;
     function Add(ALicenseZoneID, ALicenseID, AOrgID: Integer; ALicenseZoneNumber, ALicenseZoneFullNumber, ALicenseZoneName, AOrganizationFullName, ADistrict: string; ADrillingCount, ASeismicCount, ANIRCount: integer): TLicenseForReportDTO;
     constructor Create;
   end;

   TDrillingAccDTOList = class(TObjectList)
   private
     function GetItems(const Index: integer): TDrillingAccDTO;
   public
     property Items[const Index: integer]: TDrillingAccDTO read GetItems;
     function Add(AID, AWellUIN, ACategoryID: integer;  AAreaName, AWellNum, AStraton, ACategory: string; ATrueDepth, ARate: Single; ACost: Double): TDrillingAccDTO;
     constructor Create;
   end;

   TSeismicAccDTOList = class(TObjectList)
   private
     function GetItems(const Index: integer): TSeismicAccDTO;
   public
     property Items[const Index: integer]: TSeismicAccDTO read GetItems;
     function Add(AID, AWorkTypeID: Integer; ASeismicPlace, AWorkType: string; AVolume: Single; ACost: Double; AStateID: integer; AState: string): TSeismicAccDTO;

     function GetDTOByWorkType(ASeisWorkType: TSeisWorkType): TSeismicAccDTO;
   end;

   TNirAccDTOList = class(TObjectList)
   private
     function GetItems(const Index: Integer): TNIRAccDTO;
   public
     property Items[const Index: Integer]: TNIRAccDTO read GetItems;
     function Add(AID, AMainNirTypeID: Integer; AWorkDescription, AMainNIRType: string; ACost: Double; AStateID: integer; AState: string): TNIRAccDTO;

     function GetDTOByNIRType(ANIRType: TNIRType): TNIRAccDTO;
     constructor Create;
   end;

   TOverallDTOList = class(TObjectList)
   private
    function GetItems(const Index: integer): TOverallDTO;
   public
     property Items[const Index: integer]: TOverallDTO read GetItems;
     function Add: TOverallDTO;
     constructor Create;
   end;

   TLicenseHolderReport = class(TBaseReport)
   private
     FLicenseDTOList: TLicenseForReportDTOList;
     FOverallDTOList: TOverallDTOList;
     FFinal: TOverallDTO;
     function  GetVersion: TVersion;
     procedure GetLicenseDTOList;
     procedure GetDrillingDTOList(ALicenseID: Integer; ADrillingAccDTOList: TDrillingAccDTOList);
     procedure GetSeismicDTOList(ALicenseID: integer; ASeismicDTOList: TSeismicAccDTOList);
     procedure GetNirDTOList(ALicenseID: integer; ANIRDTOList: TNIRAccDTOList);
     procedure GetOrganizationOveralls;
     procedure GetOveralls;
     procedure ReplaceBaseData(AStartRow: Integer; ALicenseDTO: TLicenseForReportDTO);
     procedure ReplaceDrillingData(AStartRow: Integer; ADrillingAccDTO: TDrillingAccDTO);
     procedure ReplaceSeismicData(AStartRow: Integer; ALicenseDTO: TLicenseForReportDTO);
     procedure ReplaceNIRData(AStartRow: Integer; ALicenseDTO: TLicenseForReportDTO);
     procedure ReplaceOrganizationOverallData(AStartRow: Integer; AOverallDTO: TOverallDTO);

   protected
     procedure InternalOpenTemplate; override;
     procedure InternalMoveData; override;
     procedure DoAdjustPrintArea(); override;
   public
     procedure PrepareReport; override;
     property  ObjectVersion: TVersion read GetVersion;

     constructor Create(AOwner: TComponent); override;
     destructor  Destroy; override;
   end;

implementation

uses SysUtils, Facade, Variants, DateUtils, BaseConsts;

{ TLicenseZoneBlankReport }

constructor TLicenseZoneBlankReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  SilentMode := false;
  SaveReport := true;
  AutoNumber := [];
  RemoveEmptyCols := false;
  DrawBorders := true;
  ReportName := 'Усл_лиц_согл'
end;

function TLicenseZoneBlankReport.GetOldLicenseZone: TOldLicenseZone;
begin
  Result := ReportingObjects.Items[0] as TOldLicenseZone;
end;

procedure TLicenseZoneBlankReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(ParamStr(0))+'\LicenseConditions.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TLicenseZoneBlankReport.PrepareReport;
begin
  inherited;
  FirstColIndex := 1;
  LastColIndex := 7;
  FirstRowIndex := 1;
  LastRowIndex := 100;
  AutoNumber := [];
  DrawBorders := False;
  MakeVisible := true;


  Replacements.Clear;
  Replacements.AddReplacementRow(3, 1, '#LICNUM#', LicenseZone.LicenseZoneNum);
  Replacements.AddReplacementRow(3, 1, '#LICTYPE#', LicenseZone.License.LicenseTypeShortName);
  Replacements.AddReplacementRow(3, 1, '#ORG#', LicenseZone.License.OwnerOrganizationName);

  Replacements.AddReplacementRow(5, 1, '#LICNAME#', LicenseZone.LicenseZoneName);
  Replacements.AddReplacementRow(7, 1, '#LICDOCNAME#', LicenseZone.License.LicenseTitle);
  SQLQueries.Clear;
end;

procedure TLicenseZoneBlankReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
begin
  inherited;
end;

{ TDrillingResultBlankReport }

constructor TDrillingResultBlankReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  SilentMode := false;
  SaveReport := true;
  AutoNumber := [];
  RemoveEmptyCols := false;
  DrawBorders := true;
  ReportName := 'Рез_бур'
end;

function TDrillingResultBlankReport.GetOldLicenseZone: TOldLicenseZone;
begin
  Result := ReportingObjects.Items[0] as TOldLicenseZone;
end;

procedure TDrillingResultBlankReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(ParamStr(0))+'\DrillingResults.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TDrillingResultBlankReport.PrepareReport;
begin
  inherited;
  FirstColIndex := 1;
  LastColIndex := 7;
  FirstRowIndex := 1;
  LastRowIndex := 100;
  AutoNumber := [];
  DrawBorders := False;
  MakeVisible := true;


  Replacements.Clear;
  Replacements.AddReplacementRow(3, 1, '#LICNUM#', LicenseZone.LicenseZoneNum);
  Replacements.AddReplacementRow(3, 1, '#LICTYPE#', LicenseZone.License.LicenseTypeShortName);
  Replacements.AddReplacementRow(3, 1, '#ORG#', LicenseZone.License.OwnerOrganizationName);
  
  Replacements.AddReplacementRow(4, 1, '#LICNAME#', LicenseZone.LicenseZoneName);
  SQLQueries.Clear;
end;

procedure TDrillingResultBlankReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
begin
  inherited;

end;

{ TSeismicResultBlankReport }

constructor TSeismicResultBlankReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  SilentMode := false;
  SaveReport := true;
  AutoNumber := [];
  RemoveEmptyCols := false;
  DrawBorders := true;
  ReportName := 'Рез_геофиз'
end;

function TSeismicResultBlankReport.GetOldLicenseZone: TOldLicenseZone;
begin
  Result := ReportingObjects.Items[0] as TOldLicenseZone;
end;

procedure TSeismicResultBlankReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(ParamStr(0))+'\GeophisicsResults.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TSeismicResultBlankReport.PrepareReport;
begin
  inherited;
  FirstColIndex := 1;
  LastColIndex := 7;
  FirstRowIndex := 1;
  LastRowIndex := 100;
  AutoNumber := [];
  DrawBorders := False;
  MakeVisible := true;


  Replacements.Clear;
  Replacements.AddReplacementRow(3, 1, '#LICNUM#', LicenseZone.LicenseZoneNum);
  Replacements.AddReplacementRow(3, 1, '#LICTYPE#', LicenseZone.License.LicenseTypeShortName);
  Replacements.AddReplacementRow(3, 1, '#ORG#', LicenseZone.License.OwnerOrganizationName);
  Replacements.AddReplacementRow(5, 1, '#LICNAME#', LicenseZone.LicenseZoneName);


  SQLQueries.Clear;
end;

procedure TSeismicResultBlankReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
begin
  inherited;
end;

{ TNIRResultBlankReport }

constructor TNIRResultBlankReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  SilentMode := false;
  SaveReport := true;
  AutoNumber := [];
  RemoveEmptyCols := false;
  DrawBorders := true;
  ReportName := 'Рез_НИР'
end;

function TNIRResultBlankReport.GetOldLicenseZone: TOldLicenseZone;
begin
  Result := ReportingObjects.Items[0] as TOldLicenseZone;
end;

procedure TNIRResultBlankReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(ParamStr(0))+'\NIRResults.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TNIRResultBlankReport.PrepareReport;
begin
  inherited;
  FirstColIndex := 1;
  LastColIndex := 7;
  FirstRowIndex := 1;
  LastRowIndex := 100;
  AutoNumber := [];
  DrawBorders := False;
  MakeVisible := true;


  Replacements.Clear;
  Replacements.AddReplacementRow(3, 1, '#LICNUM#', LicenseZone.LicenseZoneNum);
  Replacements.AddReplacementRow(3, 1, '#LICTYPE#', LicenseZone.License.LicenseTypeShortName);
  Replacements.AddReplacementRow(3, 1, '#ORG#', LicenseZone.License.OwnerOrganizationName);
  Replacements.AddReplacementRow(5, 1, '#LICNAME#', LicenseZone.LicenseZoneName);
  SQLQueries.Clear;
end;

procedure TNIRResultBlankReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
begin
  inherited;
end;

{ TLicenseHolderReport }

constructor TLicenseHolderReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  SilentMode := false;
  SaveReport := true;
  AutoNumber := [];
  RemoveEmptyCols := false;
  DrawBorders := false;
  MakeVisible := True;
  ReportName := 'Прил3_по_недроп';
  LastColIndex := 20;
  LastRowIndex := 32000;
end;

destructor TLicenseHolderReport.Destroy;
begin
  FreeAndNil(FLicenseDTOList);
  FreeAndNil(FOverallDTOList);
  FreeAndNil(FFinal);
  inherited;
end;

procedure TLicenseHolderReport.GetDrillingDTOList(ALicenseID: Integer;
  ADrillingAccDTOList: TDrillingAccDTOList);
var sQuery: string;
    vResult: OleVariant;
    i: integer;
begin
  if Assigned(ADrillingAccDTOList) then
  begin
    sQuery := 'select * from spd_Get_Drilling_Acc(%s, %s)';

    if TMainFacade.GetInstance.ExecuteQuery(Format(sQuery, [IntToStr(ALicenseID), IntToStr(ObjectVersion.ID)]), vResult) > 0 then
    begin
      for i := 0 to VarArrayHighBound(vResult, 2) do
        ADrillingAccDTOList.Add(vResult[0, i], vResult[1, i], vResult[2, i], vResult[3, i], vResult[4, i], vResult[5,i], vResult[6, i], vResult[7, i], vResult[8, i], vResult[9, i])
    end;
  end;
end;

procedure TLicenseHolderReport.GetLicenseDTOList;
var vResult: OleVariant;
    sQuery: string;
    i: integer;
    licDTO: TLicenseForReportDTO;
begin
  if Not Assigned(FLicenseDTOList) then FLicenseDTOList := TLicenseForReportDTOList.Create else FLicenseDTOList.Clear;


  sQuery := 'select * from spd_Get_License_Acc(%s)';

  if TMainFacade.GetInstance.ExecuteQuery(Format(sQuery, [IntToStr(ObjectVersion.ID)]), vResult) > 0 then
  begin
    for i := 0 to VarArrayHighBound(vResult, 2) do
    begin
      licDTO := FLicenseDTOList.Add(vResult[0, i], vResult[1, i], vResult[2, i], vResult[3, i], vResult[4, i], vResult[5,i], vResult[6, i], vResult[7, i], vResult[8, i], vResult[9, i], vResult[10, i]);
      GetDrillingDTOList(licDTO.LicenseID, licDTO.DrillingAccDTOList);
      GetSeismicDTOList(licDTO.LicenseID, licDTO.SeismicAccDTOList);
      GetNirDTOList(licDTO.LicenseID, licDTO.NIRAccDTOList);      
    end;

    GetOrganizationOveralls;
    GetOveralls;
  end;

end;

procedure TLicenseHolderReport.GetSeismicDTOList(ALicenseID: integer;
  ASeismicDTOList: TSeismicAccDTOList);
var sQuery: string;
    vResult: OleVariant;
    i: integer;
begin
  if Assigned(ASeismicDTOList) then
  begin
    sQuery := 'select * from spd_Get_Seismic_Acc(%s, %s)';

    if TMainFacade.GetInstance.ExecuteQuery(Format(sQuery, [IntToStr(ALicenseID), IntToStr(ObjectVersion.ID)]), vResult) > 0 then
    begin
      for i := 0 to VarArrayHighBound(vResult, 2) do
        ASeismicDTOList.Add(vResult[0, i], vResult[1, i], vResult[2, i], vResult[3, i], vResult[4, i], vResult[5,i], vResult[6, i], vResult[7, i])
    end;
  end;
end;

function TLicenseHolderReport.GetVersion: TVersion;
begin
  Result := ReportingObjects.Items[0] as TVersion;
end;

procedure TLicenseHolderReport.InternalMoveData;
var i, j: integer;
    iStartTop: integer;
begin
  inherited;
  FExcel.Visible := true;
  FExcel.DisplayAlerts := false;

  // выбираем все лицензии по версии
  // для каждой лицензии выбираем нир, дрилл, и сейсм

  GetLicenseDTOList;
  Replacements.Clear;
  Replacements.AddReplacementRow(2, 1, '#Date#', DateToStr(ObjectVersion.VersionStartDate));
  iStartTop := 8;
  for i := 0 to FLicenseDTOList.Count  - 1 do
  begin
    if (i > 0) and (FLicenseDTOList.Items[i].LicenseOrganizationID <> FLicenseDTOList.Items[i - 1].LicenseOrganizationID) then
    begin
      ReplaceOrganizationOverallData(iStartTop, FOverallDTOList.Items[0]);
      CopyRange('OrganizationOverallRow', 1, 1, 20, 2, iStartTop, 1);
      FOverallDTOList.Delete(0);
      iStartTop := iStartTop + 2;
    end;

    for j := 0 to FLicenseDTOList.Items[i].DrillingCount - 1 do
    begin
      ReplaceBaseData(iStartTop, FLicenseDTOList.Items[i]);
      ReplaceDrillingData(iStartTop, FLicenseDTOList.Items[i].DrillingAccDTOList.Items[j]);
      CopyRange('WellLicenseRow', 1, 1, 20, 2, iStartTop, 1);
      iStartTop := iStartTop + 2;
    end;


    if FLicenseDTOList.Items[i].SeismicCount > 0 then
    while FLicenseDTOList.Items[i].SeismicAccDTOList.Count > 0 do 
    begin
      ReplaceBaseData(iStartTop, FLicenseDTOList.Items[i]);
      ReplaceSeismicData(iStartTop, FLicenseDTOList.Items[i]);
      CopyRange('SeismLicenseRow', 1, 1, 20, 2, iStartTop, 1);
      iStartTop := iStartTop + 2;
    end;

    if FLicenseDTOList.Items[i].NirCount > 0 then
    while FLicenseDTOList.Items[i].NIRAccDTOList.Count > 0 do
    begin
      ReplaceBaseData(iStartTop, FLicenseDTOList.Items[i]);
      ReplaceNIRData(iStartTop, FLicenseDTOList.Items[i]);

      CopyRange('NIRLicenseRow', 1, 1, 20, 2, iStartTop, 1);
      iStartTop := iStartTop + 2;
    end;

    if FLicenseDTOList.Items[i].IsEmpty then
    begin
      ReplaceBaseData(iStartTop, FLicenseDTOList.Items[i]);

      CopyRange('EmptyRow', 1, 1, 20, 2, iStartTop, 1);
      iStartTop := iStartTop + 2;
    end;
  end;

  ReplaceOrganizationOverallData(iStartTop, FOverallDTOList.Items[0]);
  CopyRange('OrganizationOverallRow', 1, 1, 20, 2, iStartTop, 1);
  iStartTop := iStartTop + 2;

  ReplaceOrganizationOverallData(iStartTop, FFinal);
  CopyRange('OverallRow', 1, 1, 20, 2, iStartTop, 1);

  iStartTop := iStartTop + 2;
  LastRowIndex := iStartTop;

  DoMakeReplacements;
end;

procedure TLicenseHolderReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(ParamStr(0))+'\LicenseHoldersReport.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TLicenseHolderReport.ReplaceBaseData(AStartRow: Integer; ALicenseDTO: TLicenseForReportDTO);
begin
  Replacements.AddReplacementRow(AStartRow, 1, '#District#', ALicenseDTO.District);
  Replacements.AddReplacementRow(AStartRow + 1, 1, '#District#', ALicenseDTO.District);

  Replacements.AddReplacementRow(AStartRow, 1, '#Organization#', ALicenseDTO.LicenseOrganizationFullName);
  Replacements.AddReplacementRow(AStartRow, 1, '#LicNum#', ALicenseDTO.LicenseZoneFullNumber);
  Replacements.AddReplacementRow(AStartRow + 1, 1, '#LicName#', ALicenseDTO.LicenseZoneName);

  Replacements.AddReplacementRow(AStartRow, 1, '#NGDR#', '');
  Replacements.AddReplacementRow(AStartRow + 1, 1, '#NGDR#', '');

  Replacements.AddReplacementRow(AStartRow, 1, '#NGR#', '');
  Replacements.AddReplacementRow(AStartRow + 1, 1, '#NGO#', '');  
end;

procedure TLicenseHolderReport.PrepareReport;
begin
  inherited;
  FirstColIndex := 1;
  LastColIndex := 20;
  FirstRowIndex := 1;
  LastRowIndex := 400;
  AutoNumber := [];
  DrawBorders := False;
  MakeVisible := true;


  Replacements.Clear;
  Replacements.AddReplacementRow(2, 1, '#Year#', IntToStr(ObjectVersion.Year));
end;


procedure TLicenseHolderReport.ReplaceDrillingData(AStartRow: Integer;
  ADrillingAccDTO: TDrillingAccDTO);
begin
  Replacements.AddReplacementRow(AStartRow, 1, '#WellName#', ADrillingAccDTO.WellNum + ' - ' + Trim(StringReplace(ADrillingAccDTO.AreaName, '(-ое)','', [rfReplaceAll])));

  if ADrillingAccDTO.TrueDepth > 0 then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#Depth#', Format('%.1f',[ADrillingAccDTO.TrueDepth]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#Depth#', '');

  if Trim(ADrillingAccDTO.Straton) <> '' then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#Straton#', ADrillingAccDTO.Straton)
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#Straton#', '');

  if (ADrillingAccDTO.TrueDepth > 0) and (Trim(ADrillingAccDTO.Straton) <> '') then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#Delim#', ',')
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#Delim#', '');

  if ADrillingAccDTO.IsStruct then
  begin
    if ADrillingAccDTO.Rate > 0 then
      Replacements.AddReplacementRow(AStartRow, 1, '#StructDrill#', Format('%.2f', [ADrillingAccDTO.Rate]))
    else
      Replacements.AddReplacementRow(AStartRow, 1, '#StructDrill#', '');

    Replacements.AddReplacementRow(AStartRow + 1, 1, '#StructDrillCost#', Format('%.3f', [ADrillingAccDTO.Cost/1000]));
    Replacements.AddReplacementRow(AStartRow, 1, '#ProspectDrill#', '');
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#ProspectDrillCost#', '');
  end
  else
  begin
    Replacements.AddReplacementRow(AStartRow, 1, '#StructDrill#', '');
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#StructDrillCost#', '');

    if (ADrillingAccDTO.Rate > 0) then
      Replacements.AddReplacementRow(AStartRow, 1, '#ProspectDrill#', Format('%.2f', [ADrillingAccDTO.Rate]))
    else
      Replacements.AddReplacementRow(AStartRow, 1, '#ProspectDrill#', '');
          
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#ProspectDrillCost#', Format('%.3f', [ADrillingAccDTO.Cost/1000]));
  end;

  Replacements.AddReplacementRow(AStartRow + 1, 1, '#OverallCost#', Format('%.3f', [ADrillingAccDTO.Cost/1000]));
end;

procedure TLicenseHolderReport.ReplaceSeismicData(AStartRow: Integer;
  ALicenseDTO: TLicenseForReportDTO);
var seisDTO: TSeismicAccDTO;
    fCost: double;
    sPlace: string;
begin
  seisDTO := ALicenseDTO.SeismicAccDTOList.GetDTOByWorkType(swtSeisCarotage);
  fCost := 0; sPlace := '';
  if Assigned(seisDTO) then ALicenseDTO.SeismicAccDTOList.Remove(seisDTO);



  seisDTO := ALicenseDTO.SeismicAccDTOList.GetDTOByWorkType(swt2D);
  if Assigned(seisDTO) then
  begin
    if seisDTO.Volume > 0 then
      Replacements.AddReplacementRow(AStartRow, 1, '#2DVolume#', Format('%.2f',[seisDTO.Volume]))
    else if Trim(seisDTO.State) <> '' then
      Replacements.AddReplacementRow(AStartRow, 1, '#2DVolume#', seisDTO.State)
    else
      Replacements.AddReplacementRow(AStartRow, 1, '#2DVolume#', '');

    if trim(seisDTO.SeismicPlace) <> '' then sPlace := seisDTO.SeismicPlace;

    Replacements.AddReplacementRow(AStartRow + 1, 1, '#2DCost#', Format('%.3f',[seisDTO.Cost/1000]));
    fCost := seisDTO.Cost;
    ALicenseDTO.SeismicAccDTOList.Remove(seisDTO);
  end
  else
  begin
    Replacements.AddReplacementRow(AStartRow, 1, '#2DVolume#', '');
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#2DCost#', '');
  end;

  seisDTO := ALicenseDTO.SeismicAccDTOList.GetDTOByWorkType(swt3D);
  if Assigned(seisDTO) then
  begin
    if seisDTO.Volume > 0 then
      Replacements.AddReplacementRow(AStartRow, 1, '#3DVolume#', Format('%.2f',[seisDTO.Volume]))
    else if Trim(seisDTO.State) <> '' then
      Replacements.AddReplacementRow(AStartRow, 1, '#3DVolume#', seisDTO.State)
    else
      Replacements.AddReplacementRow(AStartRow, 1, '#3DVolume#', '');

    if (trim(seisDTO.SeismicPlace) <> '') then
    begin
      if Trim(sPlace) = '' then
        sPlace := seisDTO.SeismicPlace
      else
        sPlace := sPlace + Chr(13) + Chr(10) + seisDTO.SeismicPlace;
    end;

    Replacements.AddReplacementRow(AStartRow + 1, 1, '#3DCost#', Format('%.3f',[seisDTO.Cost/1000]));
    fCost := fCost + seisDTO.Cost;
    ALicenseDTO.SeismicAccDTOList.Remove(seisDTO);
  end
  else
  begin
    Replacements.AddReplacementRow(AStartRow, 1, '#3DVolume#', '');
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#3DCost#', '');
  end;

  seisDTO := ALicenseDTO.SeismicAccDTOList.GetDTOByWorkType(swtVSP);
  if Assigned(seisDTO) then
  begin
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#VSPCost#', Format('%.3f',[seisDTO.Cost/1000]));
    fCost := fCost + seisDTO.Cost;
    ALicenseDTO.SeismicAccDTOList.Remove(seisDTO);
  end
  else Replacements.AddReplacementRow(AStartRow + 1, 1, '#VSPCost#', '');

  seisDTO := ALicenseDTO.SeismicAccDTOList.GetDTOByWorkType(swtElectro);
  if Assigned(seisDTO) then
  begin
    if seisDTO.Volume > 0 then
      Replacements.AddReplacementRow(AStartRow, 1, '#ElectroVolume#', Format('%.2f',[seisDTO.Volume]))
    else
      Replacements.AddReplacementRow(AStartRow, 1, '#ElectroVolume#',  '');

    Replacements.AddReplacementRow(AStartRow + 1, 1, '#ElectroCost#', Format('%.3f',[seisDTO.Cost/1000]));
    fCost := fCost + seisDTO.Cost;
    ALicenseDTO.SeismicAccDTOList.Remove(seisDTO);
  end
  else
  begin
    Replacements.AddReplacementRow(AStartRow, 1, '#ElectroVolume#', '');
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#ElectroCost#', '');
  end;

  Replacements.AddReplacementRow(AStartRow, 1, '#SeisPlaceName#', sPlace);
  Replacements.AddReplacementRow(AStartRow + 1, 1, '#OverallCost#', Format('%.3f', [fCost/1000]));
end;

procedure TLicenseHolderReport.ReplaceNIRData(AStartRow: Integer;
  ALicenseDTO: TLicenseForReportDTO);
var nirDTO: TNIRAccDTO;
    fSubCost, fCost: double;
    sSubName: string;
begin

  fCost := 0; fSubCost := 0;

  nirDTO := ALicenseDTO.NIRAccDTOList.GetDTOByNIRType(ntGeochem);
  if Assigned(nirDTO) then
  begin
    while Assigned(nirDTO) do
    begin
      fSubCost := fSubCost + nirDTO.Cost;
      ALicenseDTO.NIRAccDTOList.Remove(nirDTO);
      nirDTO := ALicenseDTO.NIRAccDTOList.GetDTOByNIRType(ntGeochem);
    end;

    Replacements.AddReplacementRow(AStartRow, 1, '#GeochemVolume#', '');
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#GeochemCost#', Format('%.3f',[fSubCost/1000]));
  end
  else
  begin
    Replacements.AddReplacementRow(AStartRow, 1, '#GeochemVolume#', '');
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#GeochemCost#', '');
  end;

  nirDTO := ALicenseDTO.NIRAccDTOList.GetDTOByNIRType(ntNir);
  fCost := fCost + fSubCost;
  fSubCost := 0;

  if Assigned(nirDTO) then
  begin
    sSubName := '';
    while Assigned(nirDTO) do
    begin
      fSubCost := fSubCost + nirDTO.Cost;
      if Trim(nirDTO.WorkDescription) <> '' then
        sSubName := sSubName + nirDTO.WorkDescription + ';';
      ALicenseDTO.NIRAccDTOList.Remove(nirDTO);
      nirDTO := ALicenseDTO.NIRAccDTOList.GetDTOByNIRType(ntNir);
    end;

    Replacements.AddReplacementRow(AStartRow, 1, '#NirName#', sSubName);
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#NirCost#', Format('%.3f',[fSubCost/1000]));
  end
  else
  begin
    Replacements.AddReplacementRow(AStartRow, 1, '#NirName#', '');
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#NirCost#', '');
  end;

  nirDTO := ALicenseDTO.NIRAccDTOList.GetDTOByNIRType(ntSuper);
  fCost := fCost + fSubCost;
  fSubCost := 0;

  if Assigned(nirDTO) then
  begin
    while Assigned(nirDTO) do
    begin
      fSubCost := fSubCost + nirDTO.Cost;
      ALicenseDTO.NIRAccDTOList.Remove(nirDTO);
      nirDTO := ALicenseDTO.NIRAccDTOList.GetDTOByNIRType(ntSuper);
    end;

    Replacements.AddReplacementRow(AStartRow, 1, '#SuperVolume#', '');
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#SuperCost#', Format('%.3f',[fSubCost/1000]));
  end
  else
  begin
    Replacements.AddReplacementRow(AStartRow, 1, '#SuperVolume#', '');
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#SuperCost#', '');
  end;


  nirDTO := ALicenseDTO.NIRAccDTOList.GetDTOByNIRType(ntOther);
  fCost := fCost + fSubCost;
  fSubCost := 0;

  if Assigned(nirDTO) then
  begin
    sSubName := '';
    while Assigned(nirDTO) do
    begin
      fSubCost := fSubCost + nirDTO.Cost;
      if Trim(nirDTO.WorkDescription) <> '' then
        sSubName := sSubName + nirDTO.WorkDescription + ';';
      ALicenseDTO.NIRAccDTOList.Remove(nirDTO);
      nirDTO := ALicenseDTO.NIRAccDTOList.GetDTOByNIRType(ntOther);
    end;

    Replacements.AddReplacementRow(AStartRow, 1, '#OtherName#', sSubName);
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#OtherCost#', Format('%.3f',[fSubCost/1000]));
  end
  else
  begin
    Replacements.AddReplacementRow(AStartRow, 1, '#OtherName#', '');
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#OtherCost#', '');
  end;

  fCost := fCost + fSubCost;
  Replacements.AddReplacementRow(AStartRow + 1, 1, '#OverallCost#', Format('%.3f',[fCost/1000]));
end;

procedure TLicenseHolderReport.GetNirDTOList(ALicenseID: integer;
  ANIRDTOList: TNIRAccDTOList);
var sQuery: string;
    vResult: OleVariant;
    i: integer;
begin
  if Assigned(ANIRDTOList) then
  begin
    sQuery := 'select * from spd_Get_NIR_Acc(%s, %s)';

    if TMainFacade.GetInstance.ExecuteQuery(Format(sQuery, [IntToStr(ALicenseID), IntToStr(ObjectVersion.ID)]), vResult) > 0 then
    begin
      for i := 0 to VarArrayHighBound(vResult, 2) do
        ANIRDTOList.Add(vResult[0, i], vResult[1, i], vResult[2, i], vResult[3, i], vResult[4, i], vResult[5,i], vResult[6, i])
    end;
  end;
end;

procedure TLicenseHolderReport.ReplaceOrganizationOverallData(
  AStartRow: Integer; AOverallDTO: TOverallDTO);
begin
  Replacements.AddReplacementRow(AStartRow, 1, '#Organization#', AOverallDTO.OrganizationName);

  if AOverallDTO.StructDrillRate > 0 then
    Replacements.AddReplacementRow(AStartRow, 1, '#StructDrill#', Format('%.2f', [AOverallDTO.StructDrillRate]))
  else
    Replacements.AddReplacementRow(AStartRow, 1, '#StructDrill#', '');

  if AOverallDTO.StructDrillCost > 0 then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#StructDrillCost#', Format('%.3f', [AOverallDTO.StructDrillCost/1000]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#StructDrillCost#', '');

  if (AOverallDTO.ProspectDrillRate > 0) then
    Replacements.AddReplacementRow(AStartRow, 1, '#ProspectDrill#', Format('%.2f', [AOverallDTO.ProspectDrillRate]))
  else
    Replacements.AddReplacementRow(AStartRow, 1, '#ProspectDrill#', '');

  if (AOverallDTO.ProspectDrillCost > 0) then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#ProspectDrillCost#', Format('%.3f', [AOverallDTO.ProspectDrillCost/1000]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#ProspectDrillCost#', '');

  if (AOverallDTO.Volume2D > 0) then
    Replacements.AddReplacementRow(AStartRow, 1, '#2DVolume#', Format('%.2f',[AOverallDTO.Volume2D]))
  else
    Replacements.AddReplacementRow(AStartRow, 1, '#2DVolume#', '');

  if (AOverallDTO.Cost2D > 0) then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#2DCost#', Format('%.3f',[AOverallDTO.Cost2D/1000]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#2DCost#', '');

  if (AOverallDTO.Volume3D > 0) then
    Replacements.AddReplacementRow(AStartRow, 1, '#3DVolume#', Format('%.2f',[AOverallDTO.Volume3D]))
  else
    Replacements.AddReplacementRow(AStartRow, 1, '#3DVolume#', '');

  if (AOverallDTO.Cost3D > 0) then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#3DCost#', Format('%.3f',[AOverallDTO.Cost3D/1000]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#3DCost#', '');

  if (AOverallDTO.VSPCost > 0) then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#VSPCost#', Format('%.3f',[AOverallDTO.VSPCost/1000]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#VSPCost#', '');

  if (AOverallDTO.ElectroVolume > 0) then
    Replacements.AddReplacementRow(AStartRow, 1, '#ElectroVolume#', Format('%.2f',[AOverallDTO.ElectroVolume]))
  else
    Replacements.AddReplacementRow(AStartRow, 1, '#ElectroVolume#', '');

  if (AOverallDTO.ElectroCost > 0) then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#ElectroCost#', Format('%.3f',[AOverallDTO.ElectroCost/1000]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#ElectroCost#', '');

  if (AOverallDTO.GeochemCost > 0) then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#GeochemCost#', Format('%.3f',[AOverallDTO.GeochemCost/1000]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#GeochemCost#', '');

  if (AOverallDTO.NIRCost > 0) then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#NIRCost#', Format('%.3f',[AOverallDTO.NIRCost/1000]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#NIRCost#', '');

  if (AOverallDTO.SuperCost > 0) then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#SuperCost#', Format('%.3f',[AOverallDTO.SuperCost/1000]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#SuperCost#', '');

  if (AOverallDTO.OtherCost > 0) then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#OtherCost#', Format('%.3f',[AOverallDTO.OtherCost/1000]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#OtherCost#', '');

  if (AOverallDTO.OverallCost > 0) then
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#OverallCost#', Format('%.3f',[AOverallDTO.OverallCost/1000]))
  else
    Replacements.AddReplacementRow(AStartRow + 1, 1, '#OverallCost#', '');
end;

procedure TLicenseHolderReport.GetOrganizationOveralls;
var i, j: integer;
    overallDTO: TOverallDTO;
begin
  if not Assigned(FOverallDTOList) then FOverallDTOList := TOverallDTOList.Create else FOverallDTOList.Clear;

  overallDTO := FOverallDTOList.Add;
  for i := 0 to FLicenseDTOList.Count - 1 do
  begin
    if (i > 0) and (FLicenseDTOList.Items[i].LicenseOrganizationID <> FLicenseDTOList.Items[i - 1].LicenseOrganizationID) then
    begin
      overallDTO.FOrganizationID := FLicenseDTOList.Items[i - 1].LicenseOrganizationID;
      overallDTO.FOrganizationName := FLicenseDTOList.Items[i - 1].LicenseOrganizationFullName;

      overallDTO := FOverallDTOList.Add;
      overallDTO.FOrganizationID := FLicenseDTOList.Items[i].LicenseOrganizationID;
      overallDTO.FOrganizationName := FLicenseDTOList.Items[i].LicenseOrganizationFullName;
    end;
  
    for j := 0 to FLicenseDTOList.Items[i].DrillingAccDTOList.Count  - 1 do
    with FLicenseDTOList.Items[i].DrillingAccDTOList.Items[j] do
    begin
      if IsStruct then
      begin
        overallDTO.FStructDrillRate := overallDTO.FStructDrillRate + Rate;
        overallDTO.FStructDrillCost := overallDTO.FStructDrillCost + Cost;
      end
      else
      begin
        overallDTO.FProspectDrillRate := overallDTO.FProspectDrillRate + Rate;
        overallDTO.FProspectDrillCost := overallDTO.FProspectDrillCost + Cost;
      end;
    end;

    for j := 0 to FLicenseDTOList.Items[i].SeismicAccDTOList.Count - 1 do
  	with FLicenseDTOList.Items[i].SeismicAccDTOList.Items[j] do
	  begin
      case SeisWorkType of
        swt2D:
        begin
          overallDTO.FVolume2D := overallDTO.FVolume2D + Volume;
          overallDTO.FCost2D := overallDTO.FCost2D + Cost;
        end;
        swt3D:
        begin
          overallDTO.FVolume3D := overallDTO.FVolume3D + Volume;
          overallDTO.FCost3D := overallDTO.FCost3D + Cost;
        end;
        swtVSP:
          overallDTO.FVSPCost := overallDTO.FVSPCost + Cost;
        swtElectro:
        begin
          overallDTO.FElectroVolume := overallDTO.FElectroVolume + Volume;
          overallDTO.FElectroCost := overallDTO.FElectroCost + Cost;
        end;
      end;
  	end;


    for j := 0 to FLicenseDTOList.Items[i].NIRAccDTOList.Count - 1 do
    with FLicenseDTOList.Items[i].NIRAccDTOList.Items[j] do
    begin
      case NirType of
      ntGeochem:
          overallDTO.FGeochemCost := overallDTO.FGeochemCost + Cost;
      ntNIR:
        overallDTO.FNIRCost := overallDTO.FNIRCost + Cost;
      ntSuper:
        overallDTO.FSuperCost := overallDTO.FSuperCost + Cost;
      ntOther:
        overallDTO.FOtherCost := overallDTO.FOtherCost + Cost;
      end;
    end;
  end;
end;


procedure TLicenseHolderReport.GetOveralls;
var i: integer;
begin
  if Assigned(FFinal) then FreeAndNil(FFinal);
  FFinal := TOverallDTO.Create;


  for i := 0 to FOverallDTOList.Count - 1 do
  with FOverallDTOList.Items[i] do
  begin
    FFinal.FStructDrillRate := FFinal.FStructDrillRate + FStructDrillRate;
    FFinal.FStructDrillCost := FFinal.FStructDrillCost + FStructDrillCost;
    FFinal.FProspectDrillRate := FFinal.FProspectDrillRate + FProspectDrillRate;
    FFinal.FProspectDrillCost := FFinal.FProspectDrillCost + FProspectDrillCost;

    FFinal.FVolume2D := FFinal.FVolume2D + FVolume2D;
    FFinal.FCost2D := FFinal.FCost2D + FCost2D;
    FFinal.FVolume3D := FFinal.FVolume3D + FVolume3D;
    FFinal.FCost3D := FFinal.FCost3D + FCost3D;
    FFinal.FVSPCost := FFinal.VSPCost + FVSPCost;
    FFinal.FElectroVolume := FFinal.FElectroVolume + FElectroVolume;
    FFinal.FElectroCost := FFinal.FElectroCost + FElectroCost;

    FFinal.FGeochemCost := FFinal.FGeochemCost + FGeochemCost;
    FFinal.FNIRCost := FFinal.FNIRCost + FNIRCost;
    FFinal.FSuperCost := FFinal.FSuperCost + FSuperCost;
    FFinal.FOtherCost := FFinal.FOtherCost + FOtherCost;
  end;
end;

procedure TLicenseHolderReport.DoAdjustPrintArea;
var Cell1, Cell2, Range: OleVariant;
begin
  Cell1 := FXLWorksheet.Cells.Item[FirstRowIndex, FirstColIndex + 1];
  Cell2 := FXLWorksheet.Cells.Item[LastRowIndex, LastColIndex];
  Range := FXLWorksheet.Range[Cell1,Cell2];
  FXLWorksheet.PageSetup.PrintArea := Range.Address;
end;

{ TLicenseForReportDTOList }

function TLicenseForReportDTOList.Add(ALicenseZoneID, ALicenseID,
  AOrgID: Integer; ALicenseZoneNumber, ALicenseZoneFullNumber,
  ALicenseZoneName, AOrganizationFullName, ADistrict: string;
  ADrillingCount, ASeismicCount, ANIRCount: integer): TLicenseForReportDTO;
begin
  result := TLicenseForReportDTO.Create;
  inherited Add(Result);
  with Result do
  begin
    FLicenseZoneID := ALicenseZoneID;
    FLicenseID := ALicenseID;
    FLicenseOrganizationID := AOrgID;
    FLicenseZoneNumber := ALicenseZoneNumber;
    FLicenseZoneName := ALicenseZoneName;
    FLicenseZoneFullNumber := ALicenseZoneFullNumber;
    FLicenzeOrganizationFullName := AOrganizationFullName;
    FDistrict := ADistrict;

    FDrillingCount := ADrillingCount;
    FSeismicCount := ASeismicCount;
    FNIRCount := ANIRCount;
  end;
end;

constructor TLicenseForReportDTOList.Create;
begin
  inherited Create(True);
end;

function TLicenseForReportDTOList.GetItems(
  const Index: integer): TLicenseForReportDTO;
begin
  Result := inherited Items[Index] as TLicenseForReportDTO;
end;

{ TLicenseForReportDTO }

destructor TLicenseForReportDTO.Destroy;
begin
  FreeAndNil(FDrillingAccDTOList);
  FreeAndNil(FSeismicAccDToList);
  FreeAndNil(FNirAccDTOList);
  inherited;
end;

function TLicenseForReportDTO.GetDrillingAccDTOList: TDrillingAccDTOList;
begin
  if not Assigned(FDrillingAccDTOList) then
    FDrillingAccDTOList := TDrillingAccDTOList.Create;

  Result := FDrillingAccDTOList;
end;

function TLicenseForReportDTO.GetIsEmpty: boolean;
begin
  Result := (DrillingCount = 0) and (SeismicCount = 0) and (NirCount = 0);
end;

function TLicenseForReportDTO.GetNIRAccDTOList: TNirAccDTOList;
begin
  if not Assigned(FNIRAccDTOList) then FNIRAccDTOList := TNirAccDTOList.Create;
  Result := FNIRAccDTOList;
end;

function TLicenseForReportDTO.GetSeismicAccDTOList: TSeismicAccDTOList;
begin
  if not Assigned(FSeismicAccDTOList) then
    FSeismicAccDTOList := TSeismicAccDTOList.Create;

  Result := FSeismicAccDTOList;
end;

{ TDrillingAccDTOList }

function TDrillingAccDTOList.Add(AID, AWellUIN, ACategoryID: integer; AAreaName,
  AWellNum, AStraton, ACategory: string; ATrueDepth, ARate: Single;
  ACost: Double): TDrillingAccDTO;
begin
  Result := TDrillingAccDTO.Create;
  inherited Add(Result);

  with Result do
  begin
    FID := AID;
    FWellUIN := AWellUIN;
    FCategoryID := ACategoryID;
    FAreaName := AAreaName;
    FWellNum := AWellNum;
    FStraton := AStraton;
    FCategory := ACategory;
    FTrueDepth := ATrueDepth;
    FRate := ARate;
    FCost := ACost;
  end;
end;

constructor TDrillingAccDTOList.Create;
begin
  inherited Create(True);
end;

function TDrillingAccDTOList.GetItems(
  const Index: integer): TDrillingAccDTO;
begin
  Result := inherited Items[index] as TDrillingAccDTO;
end;

{ TDrillingAccDTO }

function TDrillingAccDTO.GetIsStruct: boolean;
begin
  Result := CategoryID in [WELL_CATEGORY_PROSPECTING, WELL_CATEGORY_PROSPECTING_AND_EVALUATION, WELL_CATEGORY_STRUCTURAL_PROSPECT];
end;

{ TSeismicAccDTO }


function TSeismicAccDTO.GetSeisWorkType: TSeisWorkType;
begin
  Result := swt3D;
  case FWorkTypeID of
    SEISWORK_TYPE_2D: Result := swt2D;
    SEISWORK_TYPE_3D, SEISWORK_TYPE_UNKNOWN, SEISWORK_TYPE_2D_AND_3D: Result := swt3D;
    SEISWORK_TYPE_VSP: Result := swtVSP;
    SEISWORK_TYPE_ELECTRO: Result := swtElectro;
    SEISWORK_TYPE_CAROTAGE: Result := swtSeisCarotage;
  end
end;

{ TSeismicAccDTOList }

function TSeismicAccDTOList.Add(AID, AWorkTypeID: Integer; ASeismicPlace,
  AWorkType: string; AVolume: Single; ACost: Double; AStateID: integer; AState: string): TSeismicAccDTO;
begin
  Result := TSeismicAccDTO.Create;
  inherited Add(Result);
  with Result do
  begin
    FID := AID;
    FWorkTypeID := AWorkTypeID;
    FVolume := AVolume;
    FCost := ACost;
    FWorkType := AWorkType;
    FSeismicPlace := ASeismicPlace;
    FStateID := AStateID;
    FState := AState;
  end;
end;

function TSeismicAccDTOList.GetDTOByWorkType(
  ASeisWorkType: TSeisWorkType): TSeismicAccDTO;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].SeisWorkType = ASeisWorkType then
  begin
    Result := Items[i];
    break;
  end;
end;

function TSeismicAccDTOList.GetItems(const Index: integer): TSeismicAccDTO;
begin
  result := inherited Items[Index] as TSeismicAccDTO;
end;

{ TNirAccDTOList }

function TNirAccDTOList.Add(AID, AMainNirTypeID: Integer; AWorkDescription,
  AMainNIRType: string; ACost: Double; AStateID: integer;
  AState: string): TNIRAccDTO;
begin
  Result := TNIRAccDTO.Create;
  inherited Add(Result);

  with Result do
  begin
    FID := AID;
    FMainNirTypeID := AMainNirTypeID;
    FWorkDescription := AWorkDescription;
    FMainNirType := AMainNIRType;
    FCost := ACost;
    FStateID := AStateID;
    FState := AState;
  end;
end;

constructor TNirAccDTOList.Create;
begin
  inherited Create(true);
end;

function TNirAccDTOList.GetDTOByNIRType(ANIRType: TNIRType): TNIRAccDTO;
var i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].NirType = ANIRType then
  begin
    Result := Items[i];
    break;
  end;
end;

function TNirAccDTOList.GetItems(const Index: Integer): TNIRAccDTO;
begin
  Result := inherited Items[index] as TNIRAccDTO;
end;

{ TNIRAccDTO }

function TNIRAccDTO.GetNirType: TNirType;
begin
  Result := ntOther;
  case MainNirTypeID of
  NIR_TYPE_GEOCHEM: Result := ntGeochem;
  NIR_TYPE_NIR, NIR_TYPE_COUNTING, NIR_TYPE_SEISMIC: Result := ntNir;
  NIR_TYPE_SUPER: Result := ntSuper;
  end;
end;

{ TOverallDTO }

function TOverallDTO.GetOverallCost: double;
begin
  Result := StructDrillCost + ProspectDrillCost + Cost2D + Cost3D + VSPCost + ElectroCost + GeochemCost + NIRCost + SuperCost + OtherCost; 
end;

{ TOverallDTOList }

function TOverallDTOList.Add: TOverallDTO;
begin
  Result := TOverallDTO.Create;
  inherited Add(Result);
end;

constructor TOverallDTOList.Create;
begin
  inherited Create(True);
end;

function TOverallDTOList.GetItems(const Index: integer): TOverallDTO;
begin
  Result := inherited Items[Index] as TOverallDTO;
end;

end.
