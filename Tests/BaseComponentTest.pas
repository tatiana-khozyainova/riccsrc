unit BaseComponentTest;

interface

uses TestFramework, BaseComponent, BaseObjects, Classes;

type
  TBaseComponentImplementorTest = class(TTestCase)
  protected
    FTestingComp: TBaseComponentImplementor ;
    procedure Setup; override;
    procedure TearDown; override;
  public
    property  TestingComp: TBaseComponentImplementor read FTestingComp;
  published
    procedure TestFill; virtual;
  end;



  TRecordingComponentImplementorTest = class(TBaseComponentImplementorTest)
  private
    FCurrentObject: TIDObject;
  protected
    FPoster: TDataPoster;
    function  CallAddition: TIDObject; virtual;
    function  CallUpdate: TIDObject; virtual;
    procedure CheckValidMaterialization(AObject: TIDObject); virtual;
  public
    property  Poster: TDataPoster read FPoster;

    procedure TestAdd; virtual;
    procedure TestUpdate; virtual;
    procedure TestDelete; virtual;
  published
    property  CurrentObject: TIDObject read FCurrentObject;
    procedure TestRecordingCycle; virtual;
    procedure TestFill; override;
  end;

  TGUIRecordingComponentImplementorTest = class(TRecordingComponentImplementorTest)
  public
    function GetListIndexByObject(AObject: TIDObject): integer; virtual;
    function GetListCount: integer; virtual;
    function GetObjectByIndex(AIndex: integer): TObject; virtual;
  public
    procedure TestAdd; override;
    procedure TestUpdate; override;
    procedure TestDelete; override;
    procedure TestFill; override;
  published
  end;

implementation

uses SysUtils, DB, Facade, DBGate;

{ TBaseComponentImplementorTest }

procedure TBaseComponentImplementorTest.Setup;
begin
  inherited;

end;

procedure TBaseComponentImplementorTest.TearDown;
begin
  inherited;

end;



procedure TBaseComponentImplementorTest.TestFill;
begin
  Check(False, '���� �� ����������');
end;

{ TRecordingComponentImplementorTest }

function TRecordingComponentImplementorTest.CallAddition: TIDObject;
begin
  Result := nil;
end;

function TRecordingComponentImplementorTest.CallUpdate: TIDObject;
begin
  Result := nil;
end;

procedure TRecordingComponentImplementorTest.CheckValidMaterialization(AObject: TIDObject);
var iRecordCount: integer;
begin
  // ���������, ���������� �� ��� ����
  iRecordCount := Poster.GetFromDB(Poster.KeyFieldNames + ' = ' + IntToStr(AObject.ID), nil);
  Check(iRecordCount = 1, '������ ����������/��������. �� ������� ������, ��������������� ���������� �������');
end;

procedure TRecordingComponentImplementorTest.TestAdd;
var iInputObjectCount, iRecordCount: integer;
    ds: TDataSet;
begin
  Check(Assigned(TestingComp), '������ ����������. ��� ����� �� ����� ����������� ���������, ������� �������� �������� �������� TestingComp');
  Check(Assigned(Poster), '������ ����������. �� ����� �������������� ��� ����������, ������� �������� �������� �������� Poster');

  // ��������������� �������������� � ���������, ��������������� ���������
  Poster.RestoreState(IBaseComponent(TestingComp).InputObjects.PosterState);

  iInputObjectCount := IBaseComponent(TestingComp).InputObjects.Count;
  ds := TMainFacade.GetInstance.DBGates.ItemByPoster[Poster as TImplementedDataPoster];
  iRecordCount := ds.RecordCount;

  FCurrentObject := CallAddition;
  Check(Assigned(FCurrentObject), '������ ����������. ������ �� ��� ��������� ��� ���������� ������');
  Check(ds.RecordCount - iRecordCount = 1, '������ ����������. � ���� ������ �� ���� ��������� ������, ��������������� ��������');
  Check(FCurrentObject.ID > 0, '������ ����������. ������ �� ������� ������� ��������������');
  Check(IBaseComponent(TestingComp).InputObjects.Count - iInputObjectCount = 1, '������ ����������. �� ������� ��������� �� �������� �������');

  CheckValidMaterialization(FCurrentObject);
end;

procedure TRecordingComponentImplementorTest.TestDelete;
var iInputObjectCount, iRecordCount, iID: integer;
    ds: TDataSet;
begin
  // ��������� �����������
  Check(Assigned(CurrentObject), '������ ��������. �� ����� ��������� ������');
  Check(Assigned(TestingComp), '������ ��������. ��� ����� �� ����� ����������� ���������, ������� �������� �������� �������� TestingComp');
  Check(Assigned(Poster), '������ ��������. �� ����� �������������� ��� ����������, ������� �������� �������� �������� Poster');

  // ��������������� �������������� � ���������, ��������������� ���������
  Poster.RestoreState(IBaseComponent(TestingComp).InputObjects.PosterState);

  // ���������� ��������� ���������
  iInputObjectCount := IBaseComponent(TestingComp).InputObjects.Count;
  ds := TMainFacade.GetInstance.DBGates.ItemByPoster[Poster as TImplementedDataPoster];
  iRecordCount := ds.RecordCount;
  iID := CurrentObject.ID;

  // �������
  IBaseComponent(TestingComp).InputObjects.Remove(CurrentObject);

  // ��������� - ������� ��
  Check(iRecordCount - ds.RecordCount = 1, '������ ��������. ������, ��������������� �������� �� ���� ������� �� ��');
  Check(IBaseComponent(TestingComp).InputObjects.Count - iInputObjectCount = -1, '������ ��������. ������� �� ������ �� ������� ���������');
  Check(not Assigned(IBaseComponent(TestingComp).InputObjects.ItemsByID[iID]), '������ ��������. ������� � ���������������, ����������� � ��������������� ���������� �������� �� �������� ������������ � ���������');
end;

procedure TRecordingComponentImplementorTest.TestFill;
begin
  Check(Assigned(TestingComp), '������ ���������� ������� ���������. ��� ����� �� ����� ����������� ���������, ������� �������� �������� �������� TestingComp');
  Check(Assigned(Poster), '������ ���������� ������� ���������. �� ����� �������������� ��� ����������, ������� �������� �������� �������� Poster');

  Check(IBaseComponent(TestingComp).InputObjects.Count > 0, '������ ���������� ������� ���������. ��� ����������� ��������');
end;

procedure TRecordingComponentImplementorTest.TestRecordingCycle;
begin
  TestAdd;
  TestUpdate;
  TestDelete;
end;

procedure TRecordingComponentImplementorTest.TestUpdate;
var iInputObjectCount, iRecordCount: integer;
    ds: TDataSet;
begin
  Check(Assigned(TestingComp), '������ ��������. ��� ����� �� ����� ����������� ���������, ������� �������� �������� �������� TestingComp');
  Check(Assigned(Poster), '������ ��������. �� ����� �������������� ��� ����������, ������� �������� �������� �������� Poster');

  // ��������������� �������������� � ���������, ��������������� ���������
  Poster.RestoreState(IBaseComponent(TestingComp).InputObjects.PosterState);

  // ���������� �������� ���������
  iInputObjectCount := IBaseComponent(TestingComp).InputObjects.Count;
  ds := TMainFacade.GetInstance.DBGates.ItemByPoster[Poster as TImplementedDataPoster];
  iRecordCount := ds.RecordCount;

  FCurrentObject := CallUpdate;
  Check(Assigned(FCurrentObject), '������ ��������. ������ �� ��� ��������� ��� ���������� ������');
  Check(iRecordCount - ds.RecordCount = 0, '������ ��������. ���������� ����� � ������ ������ ���������� ����� ��������.');
  Check(FCurrentObject.ID > 0, '������ ��������. ������ �� ������� ������� ��������������');
  Check(IBaseComponent(TestingComp).InputObjects.Count - iInputObjectCount = 0, '������ ��������. ���������� ��������� � ����� ���������� ����� ��������');

  CheckValidMaterialization(FCurrentObject);
end;

{ TGUIRecordingComponentImplementorTest }

function TGUIRecordingComponentImplementorTest.GetListCount: integer;
begin
  Result := -1;
  Assert(False, '����� GetListCount �� ����������');
end;

function TGUIRecordingComponentImplementorTest.GetListIndexByObject(
  AObject: TIDObject): integer;
begin
  Result := -1;
  Assert(False, '����� GetListIndexByObject �� ����������');
end;

function TGUIRecordingComponentImplementorTest.GetObjectByIndex(
  AIndex: integer): TObject;
begin
  Result := nil;
  Assert(False, '����� GetObjectByIndex �� ����������');
end;

procedure TGUIRecordingComponentImplementorTest.TestAdd;
begin
  inherited;
  Check(IBaseComponent(TestingComp).InputObjects.Count = GetListCount, '������ ����������. �� ��� �������� ���������� � ���������������� ���������� ����� ��������');
  Check(GetListIndexByObject(CurrentObject) > -1, '������ ����������. ��������� ����������� ������� �� ��������� � ���������������� ����������');
end;

procedure TGUIRecordingComponentImplementorTest.TestDelete;
var iIndex: integer;
    o1, o2: TObject;
begin
  iIndex := GetListIndexByObject(CurrentObject);
  Check(iIndex > -1, '������ ��������. ��������� ������� ����������� � ����������');

  o1 := GetObjectByIndex(iIndex);

  inherited;

  Check(IBaseComponent(TestingComp).InputObjects.Count - GetListCount = 0, '������ ��������. ������� ����������, ��������������� ���������� ������� - �� ������');

  try
    o2 := GetObjectByIndex(iIndex);
  except
    o2 := nil;
  end;
  Check(o1 <> o2, '������ ��������. ��������� ��������� ������� ��-�������� ������������ � ���������������� ����������');
end;

procedure TGUIRecordingComponentImplementorTest.TestFill;
begin
  inherited;
  Check(IBaseComponent(TestingComp).InputObjects.Count = GetListCount, '�� ��� �������� ���������� � ���������������� ���������� ����� ��������');
end;

procedure TGUIRecordingComponentImplementorTest.TestUpdate;
begin
  inherited;
  Check(IBaseComponent(TestingComp).InputObjects.Count = GetListCount, '������ ��������. �� ��� �������� ���������� � ���������������� ���������� ����� �������� ��������');
  Check(GetListIndexByObject(CurrentObject) > -1, '������ ��������. ��������� ����������������� ������� �� ��������� � ���������������� ����������');
end;


end.
