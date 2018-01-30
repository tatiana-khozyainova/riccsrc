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
  Check(False, 'Тест не реализован');
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
  // проверяем, записались ли все поля
  iRecordCount := Poster.GetFromDB(Poster.KeyFieldNames + ' = ' + IntToStr(AObject.ID), nil);
  Check(iRecordCount = 1, 'Ошибка добавления/редакции. Не найдено строки, соответствующей введенному объекту');
end;

procedure TRecordingComponentImplementorTest.TestAdd;
var iInputObjectCount, iRecordCount: integer;
    ds: TDataSet;
begin
  Check(Assigned(TestingComp), 'Ошибка добавления. Для теста не задан тестируемый компонент, задайте непустое значение свойства TestingComp');
  Check(Assigned(Poster), 'Ошибка добавления. Не задан материализатор для компонента, задайте непустое значение свойства Poster');

  // восстанавливаем материализатор в состоянии, соответствующем коллекции
  Poster.RestoreState(IBaseComponent(TestingComp).InputObjects.PosterState);

  iInputObjectCount := IBaseComponent(TestingComp).InputObjects.Count;
  ds := TMainFacade.GetInstance.DBGates.ItemByPoster[Poster as TImplementedDataPoster];
  iRecordCount := ds.RecordCount;

  FCurrentObject := CallAddition;
  Check(Assigned(FCurrentObject), 'Ошибка добавления. Объект не был возвращен для дальнейшей работы');
  Check(ds.RecordCount - iRecordCount = 1, 'Ошибка добавления. В базу данных не была добавлена строка, соответсвтующая элементу');
  Check(FCurrentObject.ID > 0, 'Ошибка добавления. Объект не получил верного идентификатора');
  Check(IBaseComponent(TestingComp).InputObjects.Count - iInputObjectCount = 1, 'Ошибка добавления. Во входную коллекцию не добавлен элемент');

  CheckValidMaterialization(FCurrentObject);
end;

procedure TRecordingComponentImplementorTest.TestDelete;
var iInputObjectCount, iRecordCount, iID: integer;
    ds: TDataSet;
begin
  // проверяем предусловия
  Check(Assigned(CurrentObject), 'Ошибка удаления. Не задан удаляемый объект');
  Check(Assigned(TestingComp), 'Ошибка удаления. Для теста не задан тестируемый компонент, задайте непустое значение свойства TestingComp');
  Check(Assigned(Poster), 'Ошибка удаления. Не задан материализатор для компонента, задайте непустое значение свойства Poster');

  // восстанавливаем материализатор в состоянии, соответствующем коллекции
  Poster.RestoreState(IBaseComponent(TestingComp).InputObjects.PosterState);

  // запоминаем начальное состояние
  iInputObjectCount := IBaseComponent(TestingComp).InputObjects.Count;
  ds := TMainFacade.GetInstance.DBGates.ItemByPoster[Poster as TImplementedDataPoster];
  iRecordCount := ds.RecordCount;
  iID := CurrentObject.ID;

  // удаляем
  IBaseComponent(TestingComp).InputObjects.Remove(CurrentObject);

  // проверяем - удалено ли
  Check(iRecordCount - ds.RecordCount = 1, 'Ошибка удаления. Строка, соответствующая элементу не была удалена из БД');
  Check(IBaseComponent(TestingComp).InputObjects.Count - iInputObjectCount = -1, 'Ошибка удаления. Элемент не удален из входной коллекции');
  Check(not Assigned(IBaseComponent(TestingComp).InputObjects.ItemsByID[iID]), 'Ошибка удаления. Элемент с идентификатором, совпадающим с идентификатором удаленного элемента по прежнему присутствует в коллекции');
end;

procedure TRecordingComponentImplementorTest.TestFill;
begin
  Check(Assigned(TestingComp), 'Ошибка заполнения входной коллекции. Для теста не задан тестируемый компонент, задайте непустое значение свойства TestingComp');
  Check(Assigned(Poster), 'Ошибка заполнения входной коллекции. Не задан материализатор для компонента, задайте непустое значение свойства Poster');

  Check(IBaseComponent(TestingComp).InputObjects.Count > 0, 'Ошибка заполнения входной коллекции. Нет загруженных объектов');
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
  Check(Assigned(TestingComp), 'Ошибка редакции. Для теста не задан тестируемый компонент, задайте непустое значение свойства TestingComp');
  Check(Assigned(Poster), 'Ошибка редакции. Не задан материализатор для компонента, задайте непустое значение свойства Poster');

  // восстанавливаем материализатор в состоянии, соответствующем коллекции
  Poster.RestoreState(IBaseComponent(TestingComp).InputObjects.PosterState);

  // запоминаем исходное состояние
  iInputObjectCount := IBaseComponent(TestingComp).InputObjects.Count;
  ds := TMainFacade.GetInstance.DBGates.ItemByPoster[Poster as TImplementedDataPoster];
  iRecordCount := ds.RecordCount;

  FCurrentObject := CallUpdate;
  Check(Assigned(FCurrentObject), 'Ошибка редакции. Объект не был возвращен для дальнейшей работы');
  Check(iRecordCount - ds.RecordCount = 0, 'Ошибка редакции. Количество строк в наборе данных изменилось после редакции.');
  Check(FCurrentObject.ID > 0, 'Ошибка редакции. Объект не получил верного идентификатора');
  Check(IBaseComponent(TestingComp).InputObjects.Count - iInputObjectCount = 0, 'Ошибка редакции. Количество элементов в списк изменилось после редакции');

  CheckValidMaterialization(FCurrentObject);
end;

{ TGUIRecordingComponentImplementorTest }

function TGUIRecordingComponentImplementorTest.GetListCount: integer;
begin
  Result := -1;
  Assert(False, 'Метод GetListCount не реализован');
end;

function TGUIRecordingComponentImplementorTest.GetListIndexByObject(
  AObject: TIDObject): integer;
begin
  Result := -1;
  Assert(False, 'Метод GetListIndexByObject не реализован');
end;

function TGUIRecordingComponentImplementorTest.GetObjectByIndex(
  AIndex: integer): TObject;
begin
  Result := nil;
  Assert(False, 'Метод GetObjectByIndex не реализован');
end;

procedure TGUIRecordingComponentImplementorTest.TestAdd;
begin
  inherited;
  Check(IBaseComponent(TestingComp).InputObjects.Count = GetListCount, 'Ошибка добавления. Не все элементы отображены в пользовательском интерфейсе после загрузки');
  Check(GetListIndexByObject(CurrentObject) > -1, 'Ошибка добавления. Последний добавленный элемент не отображен в пользовательском интерфейсе');
end;

procedure TGUIRecordingComponentImplementorTest.TestDelete;
var iIndex: integer;
    o1, o2: TObject;
begin
  iIndex := GetListIndexByObject(CurrentObject);
  Check(iIndex > -1, 'Ошибка удаления. Удаляемый элемент отсутствует в интерфейсе');

  o1 := GetObjectByIndex(iIndex);

  inherited;

  Check(IBaseComponent(TestingComp).InputObjects.Count - GetListCount = 0, 'Ошибка удаления. Элемент интерфейса, соответствующий удаляемому объекту - не удален');

  try
    o2 := GetObjectByIndex(iIndex);
  except
    o2 := nil;
  end;
  Check(o1 <> o2, 'Ошибка удаления. Последний удаленный элемент по-прежнему отображается в пользовательском интерфейсе');
end;

procedure TGUIRecordingComponentImplementorTest.TestFill;
begin
  inherited;
  Check(IBaseComponent(TestingComp).InputObjects.Count = GetListCount, 'Не все элементы отображены в пользовательском интерфейсе после загрузки');
end;

procedure TGUIRecordingComponentImplementorTest.TestUpdate;
begin
  inherited;
  Check(IBaseComponent(TestingComp).InputObjects.Count = GetListCount, 'Ошибка редакции. Не все элементы отображены в пользовательском интерфейсе после редакции элемента');
  Check(GetListIndexByObject(CurrentObject) > -1, 'Ошибка редакции. Последний отредактированный элемент не отображен в пользовательском интерфейсе');
end;


end.
