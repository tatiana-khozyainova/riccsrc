unit BaseFacades;

interface

uses Classes, BaseObjects, Registrator, Options, DBGate, BaseDicts, ClientDicts, BaseActions, ActnList, Version,
     Organization, BaseObjectType, CommonReport, ClientType, PasswordForm, Controls, StdCtrls, Variants, Windows;

type
  TVersionChanged = procedure (OldVersion, NewVersion: TVersion) of object;

  TBaseFacade = class(TComponent)
  private
    FDataPosters: TDataPosters;
    FActionList: TBaseActionList;
    
    FSystemSettings: TSystemSettings;
    FDBGates: TDBGates;
    FSettingsFileName: string;
    FClientAppTypeID: integer;
    FAllVersions: TVersions;
    FAllReports: TBaseReports;
    FActiveVersion: TVersion;
    FClientAppTypeName: string;
    FClientAppTypes: TClientTypes;
    FOnAfterSettingsLoaded: TNotifyEvent;
    FOnActiveVersionChanged: TVersionChanged;
    FUserName: string;
    FPwd: string;
    FAuthorizationError: string;

    function GetDBGates: TDBGates;
    function GetSystemSettings: TSystemSettings;
    procedure SetClientAppTypeID(const Value: integer);

    function GetActionByClassType(
      ABaseActionClass: TBaseActionClass): TAction;
    function GetAllVersions: TVersions;
    function GetAllOrganizations: TOrganizations;
    function GetAllReports: TBaseReports;
    function GetClientAppTypes: TClientTypes;
    function GetActiveVersion: TVersion;
  protected
    FRegistrator: TRegistrator;
    FAllDicts: TDicts;
    FAllOrganizations: TOrganizations;
    FAllObjectsTypes: TObjectTypes;
    FObjectTypeMapper: TObjectTypeMapper;

    function GetRegistrator: TRegistrator; virtual;
    function GetDataPosterByClassType(
      ADataPosterClass: TDataPosterClass): TDataPoster; virtual;
    function GetAllDicts: TDicts; virtual;
    function GetAllObjectTypes: TObjectTypes; virtual;
    function getObjectTypeMapper: TObjectTypeMapper; virtual;
    procedure SetActiveVersion(const Value: TVersion); virtual;
    procedure DoVersionChanged(AOldVersion, ANewVersion: TVersion); virtual;
  public
    property UserName: string read FUserName;
    property Pwd: string read FPwd;

    property DataPosterByClassType[ADataPosterClass: TDataPosterClass]: TDataPoster read GetDataPosterByClassType;
    property ActionByClassType[ABaseActionClass: TBaseActionClass]: TAction read GetActionByClassType;

    property Registrator: TRegistrator read GetRegistrator;

    property SystemSettings: TSystemSettings read GetSystemSettings;
    // где сохранять настройки - переопределяется в потомках фасада
    property  SettingsFileName: string read FSettingsFileName write FSettingsFileName;
    procedure SaveSettings; virtual;
    procedure LoadSettings; virtual;
    property  OnAfterSettingsLoaded: TNotifyEvent read FOnAfterSettingsLoaded write FOnAfterSettingsLoaded;

    property DBGates: TDBGates read GetDBGates;
    function ExecuteQuery(const ASQL: string; var AResult: OleVariant): integer; overload;
    function ExecuteQuery(const ASQL: string): integer; overload;

    // идентификатор типа клиента
    property ClientAppTypeID: integer read FClientAppTypeID write SetClientAppTypeID;
    // наименование типа клиента
    property ClientAppTypeName: string read FClientAppTypeName write FClientAppTypeName;

    // все справочники
    property AllDicts: TDicts read GetAllDicts;
    // все организации
    property AllOrganizations: TOrganizations read GetAllOrganizations;
    // список типов объектов
    property AllObjectTypes: TObjectTypes read GetAllObjectTypes;

    //
    property AllVersions: TVersions read GetAllVersions;
    // версия
    property ActiveVersion: TVersion read GetActiveVersion write SetActiveVersion;

    property OnActiveVersionChanged: TVersionChanged read FOnActiveVersionChanged write FOnActiveVersionChanged;

    // все отчеты
    property AllReports: TBaseReports read GetAllReports;
    // все типы клиентов
    property AllClientTypes: TClientTypes read GetClientAppTypes;

    // связыватель объектов со всякими их характеристиками в БД
    property ObjectTypeMapper: TObjectTypeMapper read getObjectTypeMapper;


    function   Authorize: boolean;
    property   AuthorizationError: string read FAuthorizationError write FAuthorizationError; 

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;




implementation

uses SysUtils, ReadCommandLine;

{ TBaseFacade }


function TBaseFacade.GetRegistrator: TRegistrator;
begin
  if not Assigned(FRegistrator) then
    FRegistrator := TRegistrator.Create;
  Result := FRegistrator;
end;



destructor TBaseFacade.Destroy;
begin
  FreeAndNil(FObjectTypeMapper);
  FreeAndNil(FDataPosters);
  FreeAndNil(FActionList);
  FreeAndNil(FSystemSettings);
  FreeAndNil(FDBGates);
  FreeAndNil(FRegistrator);
  FreeAndNil(FClientAppTypes);
  inherited;
end;


function TBaseFacade.GetDBGates: TDBGates;
begin
  if not Assigned(FDBGates) then
    FDBGates := TDBGates.Create(Self);
  Result := FDBGates;
end;

function TBaseFacade.GetSystemSettings: TSystemSettings;
begin
  if not Assigned(FSystemSettings) then
    FSystemSettings := TSystemSettings.Create(SettingsFileName);
  Result := FSystemSettings;
end;


procedure TBaseFacade.SetClientAppTypeID(const Value: integer);
begin
  FClientAppTypeID := Value;
  DBGates.ClientAppTypeID := FClientAppTypeID;
end;

function TBaseFacade.GetAllDicts: TDicts;
begin
  if not Assigned(FAllDicts) then
    FAllDicts := TClientDicts.Create;

  Result := FAllDicts;
end;

function TBaseFacade.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
begin
  if not Assigned(FDataPosters) then FDataPosters := TDataPosters.Create;
  Result := FDataPosters.DataPosterByClassType[ADataPosterClass];
end;

function TBaseFacade.GetActionByClassType(
  ABaseActionClass: TBaseActionClass): TAction;
begin
  if not Assigned(FActionList) then FActionList := TBaseActionList.Create(Self);
  Result := FActionList.ActionByClassType[ABaseActionClass];
end;

function TBaseFacade.GetAllVersions: TVersions;
begin
  if not Assigned(FAllVersions) then
  begin
    FAllVersions := TVersions.Create;
    FAllVersions.Reload('', true);
  end;

  Result := FAllVersions;
end;



function TBaseFacade.GetAllOrganizations: TOrganizations;
begin
  if not Assigned (FAllOrganizations) then
  begin
    FAllOrganizations := TOrganizations.Create;
    FAllOrganizations.Reload('', true);
  end;

  Result := FAllOrganizations;
end;

function TBaseFacade.GetAllObjectTypes: TObjectTypes;
begin
  if not Assigned (FAllObjectsTypes) then
  begin
    FAllObjectsTypes := TObjectTypes.Create;
    FAllObjectsTypes.Reload('', true);
  end;

  Result := FAllObjectsTypes;
end;

function TBaseFacade.ExecuteQuery(const ASQL: string;
  var AResult: OleVariant): integer;
begin
  Result := DBGates.ExecuteQuery(ASQL, AResult);
end;

function TBaseFacade.GetAllReports: TBaseReports;
begin
  if not Assigned(FAllReports) then
    FAllReports := TBaseReports.Create(Self);

  Result := FAllReports;
end;

function TBaseFacade.GetClientAppTypes: TClientTypes;
begin
  if not Assigned(FClientAppTypes) then
  begin
    FClientAppTypes := TClientTypes.Create;
    FClientAppTypes.Reload('', true);
  end;
  Result := FClientAppTypes;
end;

function TBaseFacade.getObjectTypeMapper: TObjectTypeMapper;
begin
  if not Assigned(FObjectTypeMapper) then
    FObjectTypeMapper := TDefaultObjectTypeMapper.Create;

  Result := FObjectTypeMapper;
end;

procedure TBaseFacade.SetActiveVersion(const Value: TVersion);
var old: TVersion;
begin
  if FActiveVersion <> Value then
  begin
    old := FActiveVersion;
    FActiveVersion := Value;
    DoVersionChanged(old, FActiveVersion);
    if Assigned(OnActiveVersionChanged) then OnActiveVersionChanged(old, FActiveVersion);
  end;
end;

procedure TBaseFacade.SaveSettings;
begin

  SystemSettings.SaveAllToFile;
end;

procedure TBaseFacade.LoadSettings;
begin
  if Assigned(FOnAfterSettingsLoaded) then FOnAfterSettingsLoaded(Self);
end;

function TBaseFacade.ExecuteQuery(const ASQL: string): integer;
begin
  Result := DBGates.ExecuteQuery(ASQL);
end;

function TBaseFacade.GetActiveVersion: TVersion;
begin
  if not Assigned(FActiveVersion) then FActiveVersion := AllVersions.ItemsById[0] as TVersion;
  Result := FActiveVersion;
end;


procedure TBaseFacade.DoVersionChanged(AOldVersion, ANewVersion: TVersion);
begin
  
end;

function TBaseFacade.Authorize: Boolean;
const cnMaxUserNameLen = 254;
var bWithForm: Boolean;
sUserName: string;
dwUserNameLen: DWORD;
begin
  Result := false;
  bWithForm := false;
  FUserName := ''; FPwd := '';

  {$IFOPT D+}
  // получаем имя пользователя и пароль
    if Assigned(TCommandLineParams.GetInstance.FindParam('-u')) then
    begin
      FUserName := TCommandLineParams.GetInstance.ParamValues['-u'];
    end
    else
    begin
      dwUserNameLen := cnMaxUserNameLen - 1;
      SetLength(sUserName, cnMaxUserNameLen);
      GetUserName(PChar(sUserName), dwUserNameLen);
      SetLength(sUserName, dwUserNameLen);
      FUserName:=sUserName;
    end;
  {$ELSE}
    if not Assigned(TCommandLineParams.GetInstance.FindParam('-a')) then
    begin
      dwUserNameLen := cnMaxUserNameLen - 1;
      SetLength(sUserName, cnMaxUserNameLen);
      GetUserName(PChar(sUserName), dwUserNameLen);
      SetLength(sUserName, dwUserNameLen);
      FUserName:=sUserName;
    end
    else
    begin
      frmPassword := TfrmPassword.Create(Self);
      bWithForm := true;
      if frmPassword.ShowModal = mrOk then
      begin
        FUserName := frmPassword.UserName;
        FPwd := frmPassword.Pwd;
      end;
    end;
  {$ENDIF}

  if (trim(FUserName) = '') {and (Trim(FPwd) = '')} then Exit;



  try
    DBGates.InitializeServer(UserName, '');
    DBGates.EmployeeTabNumber := UserName;

    if DBGates.Autorized then
    if DBGates.EmployeePriority > 0 then
    begin
      Result := true;
      if bWithForm then
      begin
        frmPassword.Status := 'Здравствуйте, ' + DBGates.EmployeeName;
        Sleep(100);      
        frmPassword.Close;
      end;
    end
    else
      if bWithForm then
      begin
        frmPassword.Status := 'Авторизация завершилась неудачей. Обратитесь в к.320';
        Result := Authorize;
      end;
  except
    on E: Exception do
    begin
      FAuthorizationError := e.Message;
      if bWithForm then frmPassword.Status := FAuthorizationError;
      Result := false;
    end;
  end;
end;

constructor TBaseFacade.Create(AOwner: TComponent);
begin
  inherited;

  {$IFOPT D+}
  if (Assigned(TCommandLineParams.GetInstance.FindParam('-test'))) then
    DBGates.ServerClassString := 'RiccServerTest.CommonServerTest'
  else
    DBGates.ServerClassString := 'RiccServer.CommonServer';
  {$ELSE}
  DBGates.ServerClassString := 'RiccServer.CommonServer';
  {$ENDIF}
    
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;  
end;

end.
