unit SeisProfilePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, SeisProfile, SeisMaterial;

type

TSeismicProfileTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TSeismicProfileDataPoster = class(TImplementedDataPoster)
  private
    FAllSeismicMaterials: TSeismicMaterials;
    FAllSeismicProfileTypes: TSeismicProfileTypes;

  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllSeismicMaterials: TSeismicMaterials read FAllSeismicMaterials write FAllSeismicMaterials;
    property AllSeismicProfileTypes: TSeismicProfileTypes read FAllSeismicProfileTypes write FAllSeismicProfileTypes;
    constructor Create; override;
  end;

  TSeismicProfileCoordinateDataPoster = class(TImplementedDataPoster)
  private
    FAllSeismicProfiles: TSeismicProfiles;

  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    property AllSeismicProfiles: TSeismicProfiles read FAllSeismicProfiles write FAllSeismicProfiles;
    constructor Create; override;
  end;

implementation

uses Facade, SysUtils, Math, DateUtils, Variants;

{ TSeismicProfileTypeDataPoster }

constructor TSeismicProfileTypeDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_SEISMIC_PROFILE_TYPE';
  DataDeletionString := 'TBL_SEISMIC_PROFILE_TYPE';
  DataPostString := 'TBL_SEISMIC_PROFILE_TYPE';

  KeyFieldNames := 'SEIS_PROFILE_TYPE_ID';
  FieldNames := 'SEIS_PROFILE_TYPE_ID, VCH_SEIS_PROFILE_TYPE_NAME';

  AccessoryFieldNames := 'SEIS_PROFILE_TYPE_ID, VCH_SEIS_PROFILE_TYPE_NAME';
  AutoFillDates := false;

  Sort := 'VCH_SEIS_PROFILE_TYPE_NAME';
end;

function TSeismicProfileTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicProfileTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSeismicProfileType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSeismicProfileType;
      o.ID := ds.FieldByName('SEIS_PROFILE_TYPE_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_SEIS_PROFILE_TYPE_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;

end;

function TSeismicProfileTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TSeismicProfileType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TSeismicProfileType;

  ds.FieldByName('SEIS_PROFILE_TYPE_ID').AsInteger := w.ID;
  ds.FieldByName('VCH_SEIS_PROFILE_TYPE_NAME').AsString := w.Name;

  ds.Post;

  if w.ID = 0 then
    Result := ds.FieldByName('SEIS_PROFILE_TYPE_ID').AsInteger;
end;

{ TSeismicProfileDataPoster }

constructor TSeismicProfileDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'TBL_SEISMIC_PROFILE';
  DataDeletionString := 'TBL_SEISMIC_PROFILE';
  DataPostString := 'TBL_SEISMIC_PROFILE';

  KeyFieldNames := 'SEIS_PROFILE_ID';
  FieldNames := 'SEIS_PROFILE_ID,NUM_SEIS_PROFILE_NUMBER,NUM_PIKET_BEGIN,NUM_PIKET_END,NUM_SEIS_PROFILE_LENGHT,DTM_DATE_ENTRY,VCH_SEIS_PROFILE_COMMENT,SEIS_MATERIAL_ID,SEIS_PROFILE_TYPE_ID';

  AccessoryFieldNames := 'SEIS_PROFILE_ID,NUM_SEIS_PROFILE_NUMBER,NUM_PIKET_BEGIN,NUM_PIKET_END,NUM_SEIS_PROFILE_LENGHT,DTM_DATE_ENTRY,VCH_SEIS_PROFILE_COMMENT,SEIS_MATERIAL_ID,SEIS_PROFILE_TYPE_ID';
  AutoFillDates := false;

  Sort := 'NUM_SEIS_PROFILE_NUMBER';
end;

function TSeismicProfileDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicProfileDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSeismicProfile;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSeismicProfile;
      o.ID := ds.FieldByName('SEIS_PROFILE_ID').AsInteger;
      o.SeisProfileNumber := ds.FieldByName('NUM_SEIS_PROFILE_NUMBER').AsInteger;
      o.PiketBegin := ds.FieldByName('NUM_PIKET_BEGIN').AsInteger;
      o.PiketEnd := ds.FieldByName('NUM_PIKET_END').AsInteger;
      o.SeisProfileLenght := RoundTo(ds.FieldByName('NUM_SEIS_PROFILE_LENGHT').AsFloat,-5);
      o.DateEntry := ds.FieldByName('DTM_DATE_ENTRY').AsDateTime;
      o.SeisProfileComment := ds.FieldByName('VCH_SEIS_PROFILE_COMMENT').AsString;
      if Assigned(AllSeismicProfileTypes) then //FAllSeismicProfileTypes:=AllSeismicProfileTypes.Create;
      o.SeismicProfileType := AllSeismicProfileTypes.ItemsByID[ds.FieldByName('SEIS_PROFILE_TYPE_ID').AsInteger] as TSeismicProfileType;
      if Assigned(AllSeismicMaterials) then //FAllSeismicMaterials:=AllSeismicMaterials.Create;
      o.SeismicMaterial := AllSeismicMaterials.ItemsByID[ds.FieldByName('SEIS_Material_ID').AsInteger] as TSeismicMaterial;

      ds.Next;
    end;

    ds.First;
  end;

end;

function TSeismicProfileDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TSeismicProfile;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TSeismicProfile;

  ds.FieldByName('SEIS_PROFILE_ID').AsInteger := w.ID;
  ds.FieldByName('NUM_SEIS_PROFILE_NUMBER').AsInteger:=w.SeisProfileNumber;
  ds.FieldByName('NUM_PIKET_BEGIN').AsInteger:=w.PiketBegin;
  ds.FieldByName('NUM_PIKET_END').AsInteger:=w.PiketEnd;
  ds.FieldByName('NUM_SEIS_PROFILE_LENGHT').AsFloat:=w.SeisProfileLenght;
  ds.FieldByName('DTM_DATE_ENTRY').AsDateTime:= DateOf(w.DateEntry);
  ds.FieldByName('VCH_SEIS_PROFILE_COMMENT').AsString:=w.SeisProfileComment;
  ds.FieldByName('SEIS_PROFILE_TYPE_ID').AsInteger:= w.SeismicProfileType.Id;
  if Assigned(w.SeismicMaterial) then
  ds.FieldByName('SEIS_Material_ID').AsInteger:= w.SeismicMaterial.Id
  else
  ds.FieldByName('SEIS_Material_ID').Value:=null;

  ds.Post;

  if w.ID <= 0 then
    Result := ds.FieldByName('SEIS_PROFILE_ID').AsInteger;
end;

{ TSeismicProfileCoordinateDataPoster }

constructor TSeismicProfileCoordinateDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_SEISMIC_PROFILE_COORDINATE';
  DataDeletionString := 'TBL_SEISMIC_PROFILE_COORDINATE';
  //DataPostString := 'TBL_SEISMIC_PROFILE_COORDINATE';
  DataPostString := 'SPD_ADD_SEIS_PROFILE_COORD';

  KeyFieldNames := 'SEIS_PROFILE_ID,NUM_COORD_NUMBER';
  FieldNames := 'SEIS_PROFILE_ID,NUM_COORD_NUMBER,NUM_COORD_X,NUM_COORD_Y';

  AccessoryFieldNames := 'SEIS_PROFILE_ID,NUM_COORD_NUMBER,NUM_COORD_X,NUM_COORD_Y';
  AutoFillDates := false;

  Sort := 'SEIS_PROFILE_ID,NUM_COORD_NUMBER';
end;

function TSeismicProfileCoordinateDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  inherited DeleteFromDB(AObject, ACollection);
end;

function TSeismicProfileCoordinateDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSeismicProfileCoordinate;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSeismicProfileCoordinate;
      o.CoordNumber := ds.FieldByName('NUM_COORD_NUMBER').AsInteger;
      o.CoordX := RoundTo(ds.FieldByName('NUM_COORD_X').AsFloat,-4);
      o.CoordY := RoundTo(ds.FieldByName('NUM_COORD_Y').AsFloat,-4);
      if Assigned(AllSeismicProfiles) then //FAllSeismicProfiles:=AllSeismicProfiles.Create;
      o.SeismicProfile := AllSeismicProfiles.ItemsByID[ds.FieldByName('SEIS_PROFILE_ID').AsInteger] as TSeismicProfile;

      ds.Next;
    end;

    ds.First;
  end;

end;

function TSeismicProfileCoordinateDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    w: TSeismicProfileCoordinate;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  w := AObject as TSeismicProfileCoordinate;

  ds.FieldByName('NUM_COORD_NUMBER').AsInteger:=w.CoordNumber;
  ds.FieldByName('NUM_COORD_X').AsFloat:=w.CoordX;
  ds.FieldByName('NUM_COORD_Y').AsFloat:=w.CoordY;
  ds.FieldByName('SEIS_PROFILE_ID').AsInteger:= w.SeismicProfile.Id;

  ds.Post;

  //if w.ID = 0 then
  //  Result := ds.FieldByName('SEIS_PROFILE_ID').AsInteger;
end;

end.
