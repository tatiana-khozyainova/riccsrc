unit OrganizationPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB;

type
  // статус организации
  TOrganizationStatusDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  // организация
  TOrganizationDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


implementation

uses Organization, Facade, SysUtils;

{ TOrganizationDataPoster }

constructor TOrganizationDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_ORGANIZATION_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'ORGANIZATION_ID';
  FieldNames := 'ORGANIZATION_ID, VCH_ORG_FULL_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_ORG_FULL_NAME';
end;

function TOrganizationDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TOrganizationDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TOrganization;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TOrganization;
      o.ID := ds.FieldByName('ORGANIZATION_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_ORG_FULL_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TOrganizationDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;


{ TOrganizationStatusDataPoster }

constructor TOrganizationStatusDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'TBL_ORG_STATUS_DICT';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'ORG_STATUS_ID';
  FieldNames := 'ORG_STATUS_ID, VCH_ORG_STATUS_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_ORG_STATUS_NAME';
end;

function TOrganizationStatusDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := 0;
end;

function TOrganizationStatusDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TOrganizationStatus;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TOrganizationStatus;

      o.ID := ds.FieldByName('ORG_STATUS_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_ORG_STATUS_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TOrganizationStatusDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
