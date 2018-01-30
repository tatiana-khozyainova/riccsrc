unit PetrolRegionDataPoster;

interface

uses DBGate, BaseObjects, PersistentObjects;

type

   TPetrolRegionDataPoster = class(TImplementedDataPoster)
   public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
   end;

   TNewPetrolRegionDataPoster = class(TImplementedDataPoster)
   public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
   end;


implementation

uses PetrolRegion, DB, Facade, SysUtils;

{ TPetrolRegionDataPoster }

constructor TPetrolRegionDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_petroliferous_region_dict';

  KeyFieldNames := 'PETROL_REGION_ID';
  FieldNames := 'PETROL_REGION_ID, VCH_REGION_FULL_NAME, VCH_REGION_SHORT_NAME, NUM_REGION_TYPE, MAIN_REGION_ID';
  AccessoryFieldNames := 'PETROL_REGION_ID, VCH_REGION_FULL_NAME, VCH_REGION_SHORT_NAME, NUM_REGION_TYPE, MAIN_REGION_ID';
  AutoFillDates := false;

  Sort := 'VCH_REGION_FULL_NAME';
end;

function TPetrolRegionDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TPetrolRegionDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TPetrolRegion;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TPetrolRegion;

      s.ID := ds.FieldByName('PETROL_REGION_ID').AsInteger;
      s.Name := trim(ds.FieldByName('VCH_REGION_FULL_NAME').AsString);
      s.ShortName := trim(ds.FieldByName('VCH_REGION_SHORT_NAME').AsString);
      s.MainPetrolRegionID := ds.FieldByName('MAIN_REGION_ID').AsInteger;

      case  ds.FieldByName('NUM_REGION_TYPE').AsInteger of
      1: s.RegionType := prtNGP;
      2: s.RegionType := prtNGO;
      3: s.RegionType := prtNGR;
      end;


      ds.Next;
    end;

    ds.First;
  end;
end;

function TPetrolRegionDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TNewPetrolRegionDataPoster }

constructor TNewPetrolRegionDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_NEW_PETROL_REGION_DICT';

  KeyFieldNames := 'PETROL_REGION_ID';

  FieldNames := 'PETROL_REGION_ID, VCH_REGION_FULL_NAME, NUM_REGION_TYPE, MAIN_REGION_ID, OLD_REGION_ID';
  AccessoryFieldNames := 'PETROL_REGION_ID, VCH_REGION_FULL_NAME, NUM_REGION_TYPE, MAIN_REGION_ID, OLD_REGION_ID';

  AutoFillDates := false;

  Sort := 'VCH_REGION_FULL_NAME';
end;

function TNewPetrolRegionDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TNewPetrolRegionDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s:  TNewPetrolRegion;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TNewPetrolRegion;

      s.ID := ds.FieldByName('PETROL_REGION_ID').AsInteger;
      s.Name := trim(ds.FieldByName('VCH_REGION_FULL_NAME').AsString);
      if not ds.FieldByName('MAIN_REGION_ID').IsNull then
        s.MainPetrolRegionID := ds.FieldByName('MAIN_REGION_ID').AsInteger
      else
        s.MainPetrolRegionID := -1;

      case  ds.FieldByName('NUM_REGION_TYPE').AsInteger of
      1: s.RegionType := prtNGP;
      2: s.RegionType := prtNGO;
      3: s.RegionType := prtNGR;
      end;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TNewPetrolRegionDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
