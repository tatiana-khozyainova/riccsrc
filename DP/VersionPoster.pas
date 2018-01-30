unit VersionPoster;

interface

uses PersistentObjects, BaseObjects, DBGate, DB;

type
  TVersionDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


implementation

uses Facade, Version, SysUtils, Variants, ClientType, BaseFacades;

{ TVersionDataPoster }

constructor TVersionDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_OBJECT_VERSION';

  KeyFieldNames := 'VERSION_ID';
  FieldNames := 'VERSION_ID, VCH_VERSION_NAME, VCH_VERSION_REASON, DTM_VERSION_DATE, EMPLOYEE_ID, CLIENT_APP_TYPE_ID';
  AccessoryFieldNames := FieldNames;
  AutoFillDates := false;

  Sort := 'DTM_VERSION_DATE desc';
end;

function TVersionDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TVersionDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    v: TVersion;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  if Assigned(AObjects) then 
  begin
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Eof then
    begin
      ds.First;

      while not ds.Eof do
      begin
        v := AObjects.Add as TVersion;
        v.ID := ds.FieldByName('VERSION_ID').AsInteger;
        v.VersionName := trim(ds.FieldByName('VCH_VERSION_NAME').AsString);
        v.VersionReason := trim(ds.FieldByName('VCH_VERSION_REASON').AsString);
        v.VersionDate := ds.FieldByName('DTM_VERSION_DATE').AsDateTime;
        v.ClientType := TMainFacade.GetInstance.AllClientTypes.ItemsByID[ds.FieldByName('CLIENT_APP_TYPE_ID').AsInteger] as TClientType;
        ds.Next;
      end;

      ds.First;
    end;
  end;  
end;

function TVersionDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TVersion;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TVersion;


  ds.FieldByName('VERSION_ID').Value := o.ID;
  ds.FieldByName('VCH_VERSION_NAME').Value := o.VersionName;
  ds.FieldByName('VCH_VERSION_REASON').Value := o.VersionReason;
  ds.FieldByName('DTM_VERSION_DATE').AsString := FormatDateTime('dd.mm.yyyy', o.VersionDate);
  ds.FieldByName('CLIENT_APP_TYPE_ID').Value := TMainFacade.GetInstance.ClientAppTypeID; // по умолчанию версия делается через данный тип клиента
  if TMainFacade.GetInstance.DBGates.EmployeeID > 0 then
    ds.FieldByName('EMPLOYEE_ID').Value := TMainFacade.GetInstance.DBGates.EmployeeID
  else
    ds.FieldByName('EMPLOYEE_ID').Value := Null;

  ds.Post;

  if o.ID = -1 then
    o.ID := ds.FieldByName('VERSION_ID').Value;
end;

end.
