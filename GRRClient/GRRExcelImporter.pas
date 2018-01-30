unit GRRExcelImporter;

interface

uses ExcelImporter, Contnrs, Classes, GRRObligation, LicenseZone;

type

  TStringTable = class(TObjectList)
  private
    FColCount: integer;
    function GetRow(const Index: integer): TStringList;
  public
    property ColCount: integer read FColCount;
    function AddRow: TStringList;
    property Row[const Index: integer]: TStringList read GetRow; 
    constructor Create(AColCount: Integer);
  end;


  TGRRConditionsImporter = class(TExcelImporter)
  private
    FLicenseNumber: string;
    FLicenseName: string;
    FDrillingData: TStringTable; FSeismicData: TStringTable; FNirData: TStringTable;
    FDrillingObligations: TDrillObligations;
    FNIRObligations: TNIRObligations;
    FSeismicObligations: TSeismicObligations;
    FOnChangeActiveLicenseZone: TNotifyEvent;
    FOnAfterImport: TNotifyEvent;
    procedure ReadDrillingConditions;
    procedure ReadSeismicConditions;
    procedure ReadNIRConditions;

    procedure ConvertDrillingConditions;
    procedure ConvertSeismicConditions;
    procedure ConvertNIRConditions;
  protected
    class function CreateInstance: TExcelImporter; override;
  public
    property LicenseNumber: string read FLicenseNumber;
    property LicenseName: string read FLicenseName;

    property DrillingData: TStringTable read FDrillingData;
    property SeismicData: TStringTable read FSeismicData;
    property NirData: TStringTable read FNirData;

    property DrillingObligations: TDrillObligations read FDrillingObligations;
    property SeismicObligations: TSeismicObligations read FSeismicObligations;
    property NIRObligations: TNIRObligations read FNIRObligations;


    property  OnChangeActiveLicenseZone: TNotifyEvent read FOnChangeActiveLicenseZone write FOnChangeActiveLicenseZone;
    property  OnAfterImport: TNotifyEvent read FOnAfterImport write FOnAfterImport; 
    procedure Execute; override;
    class function GetInstance(const AFileName: string): TGRRConditionsImporter;
  end;



implementation

uses SysUtils, GRRImportingDataInterpreter, BaseObjects, Facade, State, Well, SeismworkType;


{ TGRRConditionsImporter }

procedure TGRRConditionsImporter.ConvertDrillingConditions;
var i, iOut: integer;
    d: TDrillObligation;
    interpreter: TDataInterpreter;
    dOut: TDateTime;
    oOut: TIDObject;
begin
  FreeAndNil(FDrillingObligations);
  FDrillingObligations := TDrillObligations.Create;
  interpreter := TDataInterpreter.Create;

  for i := 0 to DrillingData.Count - 1 do
  begin
    d := FDrillingObligations.Add as TDrillObligation;

    if interpreter.ReadInteger(DrillingData.Row[i][0], iOut) then d.WellCount := iOut
    else
    begin
      d.WellCount := 0;
      d.WellCountIsUndefined := 1;
    end;


    if interpreter.ReadDate(DrillingData.Row[i][1], dOut) then d.StartDate := dOut
    else d.StartDate := 0;

    if interpreter.ReadDate(DrillingData.Row[i][2], dOut) then d.FinishDate := dOut
    else d.FinishDate := 0;

    if interpreter.ReadObject(DrillingData.Row[i][3], TMainFacade.GetInstance.AllWellStates, oOut) then d.WellState := oOut as TState
    else d.WellState := nil;

    if interpreter.ReadObject(DrillingData.Row[i][4], TMainFacade.GetInstance.AllWellCategories, oOut) then d.WellCategory := oOut as TWellCategory
    else d.WellCategory := nil;

    d.Comment := DrillingData.Row[i][5];
  end;

  FreeAndNil(interpreter);
end;

procedure TGRRConditionsImporter.ConvertNIRConditions;
var i: integer;
    n: TNIRObligation;
    interpreter: TDataInterpreter;
    dOut: TDateTime;
begin
  FreeAndNil(FNIRObligations);
  FNIRObligations := TNIRObligations.Create;
  interpreter := TDataInterpreter.Create;

  for i := 0 to NirData.Count - 1 do
  begin
    n := FNIRObligations.Add as TNIRObligation;

    n.Name := trim(NirData.Row[i][0]);

    if interpreter.ReadDate(NirData.Row[i][1], dOut) then n.FinishDate := dOut
    else n.FinishDate := 0;

    n.Comment := trim(NirData.Row[i][2]);
  end;

  FreeAndNil(interpreter);
end;

procedure TGRRConditionsImporter.ConvertSeismicConditions;
var i: integer;
    s: TSeismicObligation;
    interpreter: TDataInterpreter;
    dOut: TDateTime;
    oOut: TIDObject;
    fOut: single;
begin
  FreeAndNil(FSeismicObligations);
  FSeismicObligations := TSeismicObligations.Create;
  interpreter := TDataInterpreter.Create;

  for i := 0 to SeismicData.Count - 1 do
  begin
    s := FSeismicObligations.Add as TSeismicObligation;

    if interpreter.ReadObject(SeismicData.Row[i][0], TMainFacade.GetInstance.AllSeisWorkTypes, oOut) then s.SeisWorkType := oOut as TSeismWorkType
    else s.SeisWorkType := nil;

    if interpreter.ReadFloat(SeismicData.Row[i][1], fOut) then s.Volume := fOut
    else s.Volume := 0;

    if interpreter.ReadDate(SeismicData.Row[i][3], dOut) then s.StartDate := dOut
    else s.StartDate := 0;

    if interpreter.ReadDate(SeismicData.Row[i][4], dOut) then s.FinishDate := dOut
    else s.FinishDate := 0;


    s.Comment := trim(SeismicData.Row[i][5]);
  end;

  FreeAndNil(interpreter);
end;

class function TGRRConditionsImporter.CreateInstance: TExcelImporter;
begin
  Result := TGRRConditionsImporter.Create;
end;

procedure TGRRConditionsImporter.Execute;
var lic: TLicenseZone;
begin
  inherited;


  if FindCell('Номер лицензии') then FLicenseNumber := trim(Excel.Cells[ActiveRow + 1, ActiveColumn].Value) else raise ECellNotFound.Create('Номер лицензии');
  if FindCell('Наименование лицензионного участка') then FLicenseName := Trim(Excel.Cells[ActiveRow + 1, ActiveColumn].Value) else raise ECellNotFound.Create('Наименование лицензионного участка');

  lic := TMainFacade.GetInstance.AllLicenseZones.GetLicenseZoneByNumber(FLicenseNumber);
  if lic <> TMainFacade.GetInstance.ActiveLicenseZone then
  begin
    TMainFacade.GetInstance.ActiveLicenseZone := lic;
    if Assigned(OnChangeActiveLicenseZone) then OnChangeActiveLicenseZone(Self);
  end;

  // чтение данных
  if FindCell('Бурение') then ReadDrillingConditions else raise ECellNotFound.Create('Бурение');
  if FindCell('Сейсморазведочные работы') then ReadSeismicConditions else raise ECellNotFound.Create('Сейсморазведочные работы');
  if FindCell('НИР') then ReadNIRConditions else raise ECellNotFound.Create('НИР');

  // интерпретация
  ConvertDrillingConditions;
  ConvertSeismicConditions;
  ConvertNIRConditions;

  // копирование
  if Assigned(TMainFacade.GetInstance.ActiveLicenseZone) then
  begin
    TMainFacade.GetInstance.ActiveLicenseZone.AllDrillObligations.Copy(DrillingObligations);
    TMainFacade.GetInstance.ActiveLicenseZone.AllSeismicObligations.Copy(SeismicObligations);
    TMainFacade.GetInstance.ActiveLicenseZone.AllNirObligations.Copy(NIRObligations);        
  end;

  if Assigned(FOnAfterImport) then FOnAfterImport(Self);
end;


class function TGRRConditionsImporter.GetInstance(
  const AFileName: string): TGRRConditionsImporter;
begin
  Result := inherited GetInstance(AFileName) as TGRRConditionsImporter;
end;


procedure TGRRConditionsImporter.ReadDrillingConditions;
var FirstCell: OleVariant;
    Region: OleVariant;
    i, j: integer;
    r: TStringList;
begin
  if Assigned(FDrillingData) then FreeAndNil(FDrillingData);
  FDrillingData := TStringTable.Create(6);

  FirstCell := Excel.Cells[ActiveRow + 4, ActiveColumn];
  Region := FirstCell.CurrentRegion;
  Region.Select;
  // начинаем с пятой
  for i := 5 to Region.Rows.Count do
  begin
    r := FDrillingData.AddRow;
    for j := 1 to Region.Columns.Count do
      r[j - 1] := Region.Cells[i, j].Value;
  end
end;

procedure TGRRConditionsImporter.ReadNIRConditions;
var FirstCell: OleVariant;
    Region: OleVariant;
    i, j: integer;
    r: TStringList;
begin
  if Assigned(FNirData) then FreeAndNil(FNirData);
  FNirData := TStringTable.Create(3);

  FirstCell := Excel.Cells[ActiveRow + 4, ActiveColumn];
  Region := FirstCell.CurrentRegion;
  Region.Select;
  // начинаем с пятой
  for i := 5 to Region.Rows.Count do
  begin
    r := FNirData.AddRow;
    for j := 1 to Region.Columns.Count do
      r[j - 1] := Region.Cells[i, j].Value;
  end
end;

procedure TGRRConditionsImporter.ReadSeismicConditions;
var FirstCell: OleVariant;
    Region: OleVariant;
    i, j: integer;
    r: TStringList;
begin
  if Assigned(FSeismicData) then FreeAndNil(FSeismicData);
  FSeismicData := TStringTable.Create(6);

  FirstCell := Excel.Cells[ActiveRow + 4, ActiveColumn];
  Region := FirstCell.CurrentRegion;
  Region.Select;
  // начинаем с пятой
  for i := 5 to Region.Rows.Count do
  begin
    r := FSeismicData.AddRow;
    for j := 1 to Region.Columns.Count do
      r[j - 1] := Region.Cells[i, j].Value;
  end
end;

{ TStringTable }

function TStringTable.AddRow: TStringList;
var i: Integer;
begin
  Result := TStringList.Create;
  inherited Add(Result);

  for i := 0 to ColCount - 1 do
    Result.Add('');
end;

constructor TStringTable.Create(AColCount: Integer);
begin
  inherited Create(True);
  FColCount := AColCount;
end;

function TStringTable.GetRow(const Index: integer): TStringList;
begin
  Result := inherited Items[Index] as TStringList;
end;

end.
