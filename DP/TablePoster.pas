unit TablePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Table;

type
  TRICCTableDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

  TRICCAttributeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;


implementation

uses Facade, SysUtils;

{ TRICCTableDataPoster }

constructor TRICCTableDataPoster.Create;
begin
  inherited;
  Options := [soNoInsert, soNoUpdate, soNoDelete];
  DataSourceString := 'tbl_Table';

  KeyFieldNames := 'TABLE_ID';;
  FieldNames := 'TABLE_ID, VCH_TABLE_NAME, VCH_RUS_TABLE_NAME';

  AccessoryFieldNames := 'TABLE_ID, VCH_TABLE_NAME, VCH_RUS_TABLE_NAME';;
  AutoFillDates := false;

  Sort := 'VCH_TABLE_NAME';
end;

function TRICCTableDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TRICCTableDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TRiccTable;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TRiccTable;

      o.ID := ds.FieldByName('Table_ID').AsInteger;
      o.Name := trim(ds.FieldByName('vch_Table_Name').AsString);
      o.RusTableName := trim(ds.FieldByName('vch_Rus_Table_Name').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TRICCTableDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TRICCAttributeDataPoster }

constructor TRICCAttributeDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_ATTRIBUTE';
  DataDeletionString := 'TBL_ATTRIBUTE';
  DataPostString := 'TBL_ATTRIBUTE';

  KeyFieldNames := 'ATTRIBUTE_ID';
  FieldNames := 'ATTRIBUTE_ID, VCH_ATTRIBUTE_NAME, VCH_RUS_ATTRIBUTE_NAME, NUM_DICT_VALUE';

  AccessoryFieldNames := 'ATTRIBUTE_ID, VCH_ATTRIBUTE_NAME, VCH_RUS_ATTRIBUTE_NAME, NUM_DICT_VALUE';
  AutoFillDates := false;

  Sort := 'VCH_ATTRIBUTE_NAME';
end;

function TRICCAttributeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TRICCAttributeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TRiccAttribute;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TRiccAttribute;

      o.ID := ds.FieldByName('Attribute_ID').AsInteger;
      o.Name := trim(ds.FieldByName('vch_Attribute_Name').AsString);
      o.RusAttributeName := trim(ds.FieldByName('vch_Rus_Attribute_Name').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TRICCAttributeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result:=0;
end;

end.
