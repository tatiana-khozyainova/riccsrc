unit FinanceSourcePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, FinanceSource;

type
  TFinanceSourceDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TFinanceSourceWellDataPoster = class(TImplementedDataPoster)
  private
    FAllFinanceSources: TFinanceSources;
    procedure SetAllFinanceSources(const Value: TFinanceSources);
  public
    property AllFinanceSources: TFinanceSources read FAllFinanceSources write SetAllFinanceSources;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;  override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils, well, Variants;

{ TFinanceSourceDataPoster }

constructor TFinanceSourceDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_FINANCE_SOURCE_DICT';

  KeyFieldNames := 'FINANCE_SOURCE_ID';
  FieldNames := 'FINANCE_SOURCE_ID, VCH_FINANCE_SOURCE_NAME';

  AccessoryFieldNames := 'FINANCE_SOURCE_ID, VCH_FINANCE_SOURCE_NAME';
  AutoFillDates := false;

  Sort := 'VCH_FINANCE_SOURCE_NAME';
end;

function TFinanceSourceDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TFinanceSourceDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TFinanceSource;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TFinanceSource;

      o.ID := ds.FieldByName('FINANCE_SOURCE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_FINANCE_SOURCE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TFinanceSourceDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o:  TFinanceSource;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := TFinanceSource(AObject);

  ds.FieldByName('FINANCE_SOURCE_ID').AsInteger := o.ID;
  ds.FieldByName('VCH_FINANCE_SOURCE_NAME').AsString := trim (o.Name);

  ds.Post;

  o.ID := ds.FieldByName('FINANCE_SOURCE_ID').AsInteger;
end;

{ TFinanceSourceWellDataPoster }

constructor TFinanceSourceWellDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_FINANCE_SOURCE';

  KeyFieldNames := 'WELL_UIN; FINANCE_SOURCE_ID';
  FieldNames := 'WELL_UIN, FINANCE_SOURCE_ID';

  AccessoryFieldNames := 'WELL_UIN, FINANCE_SOURCE_ID';
  AutoFillDates := false;

  Sort := 'WELL_UIN, FINANCE_SOURCE_ID';
end;

function TFinanceSourceWellDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TFinanceSourceWellDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o:  TFinanceSourceWell;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TFinanceSourceWell;

      if Assigned (FAllFinanceSources) then
        o.Assign(FAllFinanceSources.ItemsByID[ds.FieldByName('FINANCE_SOURCE_ID').AsInteger]);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TFinanceSourceWellDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TFinanceSourceWell;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  o := AObject as TFinanceSourceWell;

  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);

    if not ds.Active then
      ds.Open;

    if ds.Locate('WELL_UIN', o.Collection.Owner.ID, []) then
    begin
      ds.Delete;
      ds.First;
    end;

    ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  ds.FieldByName('WELL_UIN').AsInteger := o.Collection.Owner.ID;
  ds.FieldByName('FINANCE_SOURCE_ID').AsInteger := o.ID;

  ds.Post;
end;

procedure TFinanceSourceWellDataPoster.SetAllFinanceSources(
  const Value: TFinanceSources);
begin
  if FAllFinanceSources <> Value then
    FAllFinanceSources := Value;
end;

end.
