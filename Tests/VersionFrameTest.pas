unit VersionFrameTest;

interface

uses BaseComponent, BaseComponentTest, TestFramework, VersionFrame, DB, BaseObjects;

type
  TVersionFrameTest = class(TGUIRecordingComponentImplementorTest)
  protected
    FVersionFrame: TfrmVersion;
    procedure Setup; override;
    procedure TearDown; override;

    function  CallAddition: TIDObject; override;
    function  CallUpdate: TIDObject; override;
    procedure CheckValidMaterialization(AObject: TIDObject); override;
  public
    function GetListIndexByObject(AObject: TIDObject): integer; override;
    function GetListCount: integer; override;
    function GetObjectByIndex(AIndex: integer): TObject; override;
  end;

implementation

uses SysUtils, Facade, Version, DBGate, BaseFacades, VersionPoster,
     ComCtrls, DateUtils, Forms;

{ TVersionFrameTest }

function TVersionFrameTest.CallAddition: TIDObject;
begin
  Result  := FVersionFrame.AddVersion('Тестовая версия', 'Проверка ввода', Now) as TIDObject;
end;

function TVersionFrameTest.CallUpdate: TIDObject;
begin
  (CurrentObject as TVersion).VersionName := 'Измененная тестовая версия';
  (CurrentObject as TVersion).VersionName := 'Проверка редакции';
  (CurrentObject as TVersion).VersionDate := Now;
  (CurrentObject as TVersion).Update(nil);
  Result := CurrentObject;    
end;

procedure TVersionFrameTest.CheckValidMaterialization(AObject: TIDObject);
var ds: TDataSet;
    v: TVersion;
begin
  inherited;
  v := AObject as TVersion;
  ds := TMainFacade.GetInstance.DBGates.ItemByPoster[FVersionFrame.Versions.Poster as TImplementedDataPoster];
  Check(trim(v.VersionName) = trim(ds.FieldByName('VCH_VERSION_NAME').AsString), 'Значение поля VCH_VERSION_NAME в БД не совпадает с введенным значением');
  Check(trim(v.VersionReason) = trim(ds.FieldByName('VCH_VERSION_REASON').AsString), 'Значение поля VCH_VERSION_REASON в БД не совпадает с введенным значением');
  Check(DateOf(v.VersionDate) = DateOf(ds.FieldByName('DTM_VERSION_DATE').AsDateTime), 'Значение поля DTM_VERSION_DATE в БД не совпадает с введенным значением');
end;

function TVersionFrameTest.GetListCount: integer;
begin
  Result := FVersionFrame.lwVersions.Items.Count;
end;

function TVersionFrameTest.GetListIndexByObject(
  AObject: TIDObject): integer;
var i: integer;
begin
  Result := -1; 
  with FVersionFrame.lwVersions do
  for i := 0 to Items.Count - 1 do
  if  Items[i].Data = AObject then
  begin
    Result := i;
    break;
  end;
end;

function TVersionFrameTest.GetObjectByIndex(AIndex: integer): TObject;
begin
  if AIndex <= FVersionFrame.lwVersions.Items.Count - 1 then
    Result := FVersionFrame.lwVersions.Items[AIndex].Data
  else
    Result := nil;
end;

procedure TVersionFrameTest.Setup;
begin
  inherited;
  FVersionFrame := TfrmVersion.Create(Application.MainForm);
  FVersionFrame.Prepare;

  FTestingComp := FVersionFrame.Implementor;
  FPoster := TMainFacade.GetInstance.DataPosterByClassType[TVersionDataPoster];
end;

procedure TVersionFrameTest.TearDown;
begin
  inherited;
end;





initialization
//  RegisterTest('TVersionFrameTest', TVersionFrameTest.Suite);
end.
