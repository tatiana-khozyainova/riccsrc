unit LasFileDataPoster;

interface

uses PersistentObjects, DBGate, BaseObjects,  Organization, Employee, LasFile, Variants ;


type
  TLasFileDataPoster = class(TImplementedDataPoster)
  private
    FAllOrganizations : TOrganizations;
    FAllEmployees: TEmployees;
  public
    property AllOrganizations : TOrganizations read FAllOrganizations write FAllOrganizations;
    property AllEmployees : TEmployees read FAllEmployees write FAllEmployees;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;

  end;

  TLasCurveDataPoster = class(TImplementedDataPoster)
  private
    FAllCurves : TCurves;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllCurves : TCurves read FAllCurves write FAllCurves;

    constructor Create; override;

  end;

  TCurveDataPoster = class(TImplementedDataPoster)
    private
    FAllCurveCategories : TCurveCategories;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllCurveCategories : TCurveCategories read FAllCurveCategories write FAllCurveCategories;
    constructor Create; override;
  end;

  TCurveCategoryDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

implementation

uses Facade,  SysUtils, Math, DateUtils, DB;

{TLasFileDataPoster}

constructor TLasFileDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue, soSingleDataSource];
  DataSourceString := 'TBL_LAS_FILE';


  KeyFieldNames := 'LAS_FILE_UIN';
  FieldNames := 'LAS_FILE_UIN, WELL_UIN, NUM_START, NUM_STOP, NUM_STEP, ' +
                'VCH_DATE, VCH_FILENAME, VCH_OLD_FILENAME, ' +
                'NUM_CD_NUMBER, ORGANIZATION_ID, EMPLOYEE_ID, DTM_DATE, NUM_DEBASED, NUM_HEADER_MARK';

  AccessoryFieldNames := 'LAS_FILE_UIN, WELL_UIN, NUM_START, NUM_STOP, NUM_STEP, ' +
                'VCH_DATE, VCH_FILENAME, VCH_OLD_FILENAME, ' +
                'NUM_CD_NUMBER, ORGANIZATION_ID, EMPLOYEE_ID, DTM_DATE, NUM_DEBASED, NUM_HEADER_MARK';

  AutoFillDates := false;

  Sort := 'NUM_START';
end;

function TLasFileDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TLasFileDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TLasFile;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLasFile;

      o.ID := ds.FieldByName('LAS_FILE_UIN').AsInteger;
      o.Start := ds.FieldByName('NUM_START').AsFloat;
      o.Stop := ds.FieldByName('NUM_STOP').AsFloat;
      o.Step := ds.FieldByName('NUM_STEP').AsFloat;
      o.FileDate := ds.FieldByName('VCH_DATE').AsString;
      o.FileName := ds.FieldByName('VCH_FILENAME').AsString;
      o.OldFileName := ds.FieldByName('VCH_OLD_FILENAME').AsString;
      o.CDNumber := ds.FieldByName('NUM_CD_NUMBER').AsInteger;
      o.Date := ds.FieldByName('DTM_DATE').AsDateTime;
      o.Debased := ds.FieldByName('NUM_DEBASED').AsInteger;
      o.Header := ds.FieldByName('NUM_HEADER_MARK').AsInteger;
      o.Organization :=  AllOrganizations.ItemsByID[ds.FieldByName('ORGANIZATION_ID').AsInteger] as TOrganization;
      o.Employee := AllEmployees.ItemsByID[ds.FieldByName('EMPLOYEE_ID').AsInteger] as TEmployee;
      ds.Next;
    end;

    ds.First;
  end;
end;


function TLasFileDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TLasFile;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TLasFile;
  //if Assigned(o.Owner) then
  //ds.FieldByName('WELL_UIN').Value:= o.Owner.ID;
  ds.FieldByName('WELL_UIN').Value:= o.WellID;
  ds.FieldByName('NUM_START').Value := o.Start;
  ds.FieldByName('NUM_STOP').Value := o.Stop;
  ds.FieldByName('NUM_STEP').Value := o.Step ;
  ds.FieldByName('VCH_DATE').Value := o.FileDate;
  ds.FieldByName('VCH_FILENAME').Value := o.FileName;
  ds.FieldByName('VCH_OLD_FILENAME').Value := o.OldFileName;
  ds.FieldByName('NUM_CD_NUMBER').Value := o.CDNumber;
  if Assigned(o.Organization) then
    ds.FieldByName('ORGANIZATION_ID').Value:= o.Organization.ID;
  if Assigned(o.Employee) then
    ds.FieldByName('EMPLOYEE_ID').Value:= o.Employee.ID;
  ds.FieldByName('DTM_DATE').Value := o.Date;
  ds.FieldByName('NUM_DEBASED').Value := o.Debased;
  ds.FieldByName('NUM_HEADER_MARK').Value := o.Header ;

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('LAS_FILE_UIN').Value;

end;



{ TLasCurveDataPoster }

constructor TLasCurveDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_LAS_CURVE';
  KeyFieldNames := 'CURVE_ID; LAS_FILE_UIN';
  FieldNames := 'CURVE_ID, LAS_FILE_UIN';
  AccessoryFieldNames := 'CURVE_ID, LAS_FILE_UIN';

  AutoFillDates := false;

  Sort := 'CURVE_ID';
end;

function TLasCurveDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TLasCurveDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TLasCurve;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLasCurve;

      o.Curve:= AllCurves.ItemsById[ds.FieldByName('CURVE_ID').AsInteger] as TCurve;
      ds.Next;
    end;

    ds.First;
  end;
end;

function TLasCurveDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
   var ds: TDataSet;
    o: TLasCurve;
begin
  Result := 0;
  o := AObject as TLasCurve;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;
    if ds.Locate(KeyFieldNames, varArrayOf([o.Curve.ID, o.LasFile.ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;


  ds.FieldByName('CURVE_ID').Value := o.Curve.ID;
  ds.FieldByName('LAS_FILE_UIN').Value := o.LasFile.ID;

  ds.Post;

end;








{ TCurveDataPoster  - готов}

constructor TCurveDataPoster.Create;
begin
  inherited;
  DataSourceString := 'TBL_CURVE_DICT';
  DataDeletionString := 'TBL_CURVE_DICT';
  DataPostString := 'TBL_CURVE_DICT';

  KeyFieldNames := 'CURVE_ID';
  FieldNames := 'CURVE_ID, VCH_SHORT_NAME, VCH_FULL_NAME, ' +
                'VCH_UNIT, CURVE_CATEGORY_ID';

  AccessoryFieldNames := 'CURVE_ID, VCH_SHORT_NAME, VCH_FULL_NAME, ' +
                          'VCH_UNIT, CURVE_CATEGORY_ID';
  AutoFillDates := false;

  Sort := ''; 
end;

function TCurveDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TCurveDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TCurve;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  if not ds.Eof then
  begin
    ds.First;
    while not ds.Eof do
    begin
      o := AObjects.Add as TCurve;
      o.ID := ds.FieldByName('CURVE_ID').AsInteger;
      o.ShortName := trim(ds.FieldByName('VCH_SHORT_NAME').AsString);
      o.Name := trim(ds.FieldByName('VCH_FULL_NAME').AsString);
      o.CurveUnit := Trim(ds.FieldByName('VCH_UNIT').AsString);
      if Assigned(AllCurveCategories) then
        o.CurveCategory := AllCurveCategories.ItemsById[ds.FieldByName('CURVE_CATEGORY_ID').AsInteger] as TCurveCategory
      else
        o.CurveCategory := nil;
        
      ds.Next;
    end;
    ds.First;
  end;
end;

function TCurveDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TCurve;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  o := AObject as TCurve;
  ds.FieldByName('CURVE_ID').Value := o.ID;
  ds.FieldByName('VCH_SHORT_NAME').Value := o.ShortName;
  ds.FieldByName('VCH_FULL_NAME').Value := o.Name;
  ds.FieldByName('VCH_UNIT').Value := o.CurveUnit;
  if Assigned(o.CurveCategory) then
    ds.FieldByName('CURVE_CATEGORY_ID').Value := o.CurveCategory.ID;
  ds.Post;
  if o.ID = 0 then
    o.ID := ds.FieldByName('CURVE_ID').Value;
end;











{ TCurveCategoryDataPoster - готов}

constructor TCurveCategoryDataPoster.Create;
begin
  inherited;

  DataSourceString := 'TBL_CURVE_CATEGORY';
  DataDeletionString := 'TBL_CURVE_CATEGORY';
  DataPostString := 'TBL_CURVE_CATEGORY';

  KeyFieldNames := 'CURVE_CATEGORY_ID';
  FieldNames := 'CURVE_CATEGORY_ID, VCH_CATEGORY_NAME, VCH_CATEGORY_SHORT_NAME';

  AccessoryFieldNames := 'CURVE_CATEGORY_ID, VCH_CATEGORY_NAME, VCH_CATEGORY_SHORT_NAME';

  //AutoFillDates := false;

  Sort := 'VCH_CATEGORY_NAME';
end;

function TCurveCategoryDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TCurveCategoryDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TCurveCategory;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    while not ds.Eof do
    begin
      o := AObjects.Add as TCurveCategory;
      o.ID := ds.FieldByName('CURVE_CATEGORY_ID').AsInteger;
      o.ShortName := trim(ds.FieldByName('VCH_CATEGORY_SHORT_NAME').AsString);
      o.Name := trim(ds.FieldByName('VCH_CATEGORY_NAME').AsString);
      ds.Next;
    end;
    ds.First;
  end;
end;

function TCurveCategoryDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TCurveCategory;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  o := AObject as TCurveCategory;

  ds.FieldByName('CURVE_CATEGORY_ID').Value := o.ID;
  ds.FieldByName('CURVE_CATEGORY_NAME').Value := o.Name;
  ds.FieldByName('CURVE_CATEGORY_SHORT_NAME').Value := o.ShortName;
  ds.Post;
  if o.ID = 0 then
    o.ID := ds.FieldByName('CURVE_CATEGORY_ID').Value;
end;

end.
