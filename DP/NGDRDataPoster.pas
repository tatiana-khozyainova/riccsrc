unit NGDRDataPoster;

interface

uses DBGate, BaseObjects, PersistentObjects;

type

   TNGDRRegionDataPoster = class(TImplementedDataPoster)
   public
     function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
     function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
     function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

     constructor Create; override;
   end;

implementation

uses NGDR,  DB, Facade, SysUtils;

{ TNGDRRegionDataPoster }

constructor TNGDRRegionDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_NGDR';

  KeyFieldNames := 'NGDR_ID';
  FieldNames := 'NGDR_ID, VCH_NGDR_NAME, VCH_NGDR_SHORT_NAME';
  AccessoryFieldNames := 'NGDR_ID, VCH_NGDR_NAME, VCH_NGDR_SHORT_NAME';
  AutoFillDates := false;

  Sort := 'VCH_NGDR_NAME';
end;

function TNGDRRegionDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TNGDRRegionDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TNGDR;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TNGDR;

      s.ID := ds.FieldByName('NGDR_ID').AsInteger;
      s.Name := trim(ds.FieldByName('VCH_NGDR_NAME').AsString);
      s.ShortName := trim(ds.FieldByName('VCH_NGDR_SHORT_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TNGDRRegionDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
