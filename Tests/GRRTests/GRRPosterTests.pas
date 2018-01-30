unit GRRPosterTests;

interface

uses TestFramework, GRRObligationPoster, Facade,
     BaseObjects, PersistentObjects, DBGate, GRRObligation;

type
  TCheckGetError = procedure(ADataPoster: TImplementedDataPoster; ARecordCount: integer; AText: string);
  TCheckSetError = procedure (ADataPoster: TImplementedDataPoster; AResult: integer; AText: string);


  TNirStatePosterTest = class(TTestCase)
  private
    procedure CheckGetError(ADataPoster: TImplementedDataPoster; ARecordCount: integer; AText: string);
    //CheckGetError: TCheckGetError;
    procedure CheckSetError(ADataPoster: TImplementedDataPoster; AResult: integer; AText: string);

  protected
    procedure SetUp; override;
  published
    procedure TestGetNirStates;
    procedure TestSetNirState;
  public
    //property CheckError: TCheckGetError read CheckGetError write CheckGetError;
  end;

  TNirTypePosterTest = class(TTestCase)
  private
    procedure CheckGetError(ADataPoster: TImplementedDataPoster; ARecordCount: integer; AText: string);
    procedure CheckSetError(ADataPoster: TImplementedDataPoster; AResult: integer; AText: string);
  protected
    procedure SetUp; override;
  published
    procedure TestGetNirType;
    procedure TestSetNirType;
  end;

  TNIRObligationPosterTest = class (TTestCase)
  private
    procedure CheckGetError(ADataPoster: TImplementedDataPoster; ARecordCount: integer; AText: string);
   // CheckSetError: TCheckSetError;
    procedure CheckSetError(ADataPoster: TImplementedDataPoster; AResult: integer; AText: string);
  protected
    procedure SetUp; override;
  published
    procedure TestGetNirObligation;
    procedure TestSetNirObligation;
  end;

  TSeismicObligationPosterTest = class (TTestCase)
  private
    procedure CheckGetError(ADataPoster: TImplementedDataPoster; ARecordCount: integer; AText: string);
  protected
    procedure SetUp; override;
  published
    procedure TestGetSeismicObligation;
  end;

  TDrillingObligationPosterTest = class (TTestCase)
  private
    procedure CheckGetError(ADataPoster: TImplementedDataPoster; ARecordCount: integer; AText: string);
  protected
    procedure SetUp; override;
  published
    procedure TestGetDrillingObligation;
  end;

  TNirObligationPlacePosterTest = class (TTestCase)
  private
    procedure CheckGetError(ADataPoster: TImplementedDataPoster; ARecordCount: integer; AText: string);
  protected
    procedure SetUp; override;
  published
    procedure TestGetNirObligationPlace;
  end;

  TSeismicObligationPlacePosterTest = class (TTestCase)
  private
    procedure CheckGetError(ADataPoster: TImplementedDataPoster; ARecordCount: integer; AText: string);
  protected
    procedure SetUp; override;
  published
    procedure TestGetSeismicObligationPlace;
  end;

  TDrillingObligationWellPosterTest = class (TTestCase)
  private
    procedure CheckGetError(ADataPoster: TImplementedDataPoster; ARecordCount: integer; AText: string);
  protected
    procedure SetUp; override;
  published
    procedure TestGetDrillingObligationWell;
  end;

 // procedure CheckSetError(ADataPoster: TImplementedDataPoster; AResult: integer; AText: string);

implementation

uses SysUtils;

{procedure CheckSetError(ADataPoster: TImplementedDataPoster; AResult: integer; AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(AResult >= 0, Format('Данные о %s не записаны в БД. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end; }

{ TNirStatePosterTest }

procedure TNirStatePosterTest.CheckGetError(
  ADataPoster: TImplementedDataPoster; ARecordCount: integer;
  AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(ARecordCount > 0, Format('Данные о %s не получены. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end;

procedure TNirStatePosterTest.CheckSetError(
  ADataPoster: TImplementedDataPoster; AResult: integer; AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(AResult >= 0, Format('Данные о %s не записаны в БД. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end;

procedure TNirStatePosterTest.SetUp;
begin
  inherited;
end;

procedure TNirStatePosterTest.TestGetNirStates;
var dp: TDataPoster;
    objs: TNirStates;
begin
  dp := TMainFacade.GetInstance.DataPosterByClassType[TNIRStateDataPoster] as TImplementedDataPoster;
  CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', nil), 'состоянии работ по НИР');

  objs := TNIRStates.Create;
  CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', objs), 'состоянии работ по НИР в коллекцию объектов ');
  Check(objs.Count > 0, 'Коллекция состояний не заполнена');
end;

procedure TNirStatePosterTest.TestSetNirState;
var dp: TDataPoster;
    ns: TNIRState;
begin
  ns := TNIRState.Create(nil);
  ns.Name := 'Тестовое состояние';

  dp := TMainFacade.GetInstance.DataPosterByClassType[TNIRStateDataPoster] as TImplementedDataPoster;
  CheckSetError(dp as TImplementedDataPoster, dp.PostToDB(ns, nil), 'состоянии работ по НИР');
  Check(ns.ID > 0, 'Новый идентификатор состояния работ по НИР не получен');
end;

{ TNirTypePosterTest }

procedure TNirTypePosterTest.CheckGetError(
  ADataPoster: TImplementedDataPoster; ARecordCount: integer;
  AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(ARecordCount > 0, Format('Данные о %s не получены. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end;

procedure TNirTypePosterTest.CheckSetError(
  ADataPoster: TImplementedDataPoster; AResult: integer; AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(AResult >= 0, Format('Данные о %s не записаны в БД. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end;

procedure TNirTypePosterTest.SetUp;
begin
  inherited;
end;

procedure TNirTypePosterTest.TestGetNirType;
var dp: TDataPoster;
begin
  dp := TMainFacade.GetInstance.DataPosterByClassType[TNIRTypeDataPoster] as TImplementedDataPoster;
  CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', nil), 'типе работ по НИР');
end;

procedure TNirTypePosterTest.TestSetNirType;
var dp: TDataPoster;
    nt: TNIRType;
begin
  nt := TNIRType.Create(nil);
  nt.Name := 'Тестовое состояние';
  //nt.ID := 730;

  dp := TMainFacade.GetInstance.DataPosterByClassType[TNIRTypeDataPoster] as TImplementedDataPoster;
  CheckSetError(dp as TImplementedDataPoster, dp.PostToDB(nt, nil), 'типе работ по НИР');
  Check(nt.ID > 0, 'Новый идентификатор типа работ по НИР не получен');
end;

{ TNIRObligationPosterTest }

procedure TNIRObligationPosterTest.CheckGetError(ADataPoster: TImplementedDataPoster;
  ARecordCount: integer; AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(ARecordCount > 0, Format('Данные о %s не получены. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end;


procedure TNIRObligationPosterTest.CheckSetError(
  ADataPoster: TImplementedDataPoster; AResult: integer; AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(AResult >= 0, Format('Данные о %s не записаны в БД. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end;

procedure TNIRObligationPosterTest.SetUp;
begin
 inherited;
end;

procedure TNIRObligationPosterTest.TestGetNirObligation;
var dp: TDataPoster;
begin
  dp := TMainFacade.GetInstance.DataPosterByClassType[TNIRDataPoster] as TImplementedDataPoster;
  CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', nil), 'обязательствам по НИР');
end;

procedure TNIRObligationPosterTest.TestSetNirObligation;
var dp: TDataPoster;
    no: TNIRObligation;
begin
  no := TNIRObligation.Create(nil);
  //no. := '';
  //no.ID := 730;

  dp := TMainFacade.GetInstance.DataPosterByClassType[TNIRTypeDataPoster] as TImplementedDataPoster;
  CheckSetError(dp as TImplementedDataPoster, dp.PostToDB(no, nil), 'типе работ по НИР');
  Check(no.ID > 0, 'Новый идентификатор типа работ по НИР не получен');
end;

{ TSeismicObligationPosterTest }

procedure TSeismicObligationPosterTest.CheckGetError(
  ADataPoster: TImplementedDataPoster; ARecordCount: integer;
  AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(ARecordCount > 0, Format('Данные о %s не получены. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end;

procedure TSeismicObligationPosterTest.SetUp;
begin
  inherited;
end;

procedure TSeismicObligationPosterTest.TestGetSeismicObligation;
var dp: TDataPoster;
begin
  dp := TMainFacade.GetInstance.DataPosterByClassType[TSeismicObligationDataPoster] as TImplementedDataPoster;
   CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', nil), 'обязательствам по сейсмике');
end;

{ TDrillingObligationPosterTest }

procedure TDrillingObligationPosterTest.CheckGetError(
  ADataPoster: TImplementedDataPoster; ARecordCount: integer;
  AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(ARecordCount > 0, Format('Данные о %s не получены. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end;

procedure TDrillingObligationPosterTest.SetUp;
begin
  inherited;
end;

procedure TDrillingObligationPosterTest.TestGetDrillingObligation;
var dp: TDataPoster;
begin
  dp := TMainFacade.GetInstance.DataPosterByClassType[TDrillingObligationDataPoster] as TImplementedDataPoster;
  CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', nil), 'обязательствам по бурению');
end;

{ TNirObligationPlacePosterTest }

procedure TNirObligationPlacePosterTest.CheckGetError(
  ADataPoster: TImplementedDataPoster; ARecordCount: integer;
  AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(ARecordCount > 0, Format('Данные о %s не получены. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end;

procedure TNirObligationPlacePosterTest.SetUp;
begin
  inherited;
end;

procedure TNirObligationPlacePosterTest.TestGetNirObligationPlace;
var dp: TDataPoster;
    objs: TNirObligationPlaces;
begin
  dp := TMainFacade.GetInstance.DataPosterByClassType[TNirObligationPlaceDataPoster]
        as TImplementedDataPoster;
  CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', nil), 'месте проведения НИР');

  objs := TNirObligationPlaces.Create;
  CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', objs), 'места проведения НИР в коллекцию объектов ');
  Check(objs.Count > 0, 'Коллекция состояний не заполнена');
end;

{ TSeismicObligationPlacePosterTest }

procedure TSeismicObligationPlacePosterTest.CheckGetError(
  ADataPoster: TImplementedDataPoster; ARecordCount: integer;
  AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(ARecordCount > 0, Format('Данные о %s не получены. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end;

procedure TSeismicObligationPlacePosterTest.SetUp;
begin
  inherited;
end;

procedure TSeismicObligationPlacePosterTest.TestGetSeismicObligationPlace;
var dp: TDataPoster;
    objs: TSeismicObligationPlaces;
begin
  dp := TMainFacade.GetInstance.DataPosterByClassType[TSeismicObligationPlaceDataPoster]
        as TImplementedDataPoster;
  CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', nil), 'месте проведения сейсм работ');

  objs := TSeismicObligationPlaces.Create;
  CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', objs), 'места проведения сейсм работ в коллекцию объектов ');
  Check(objs.Count > 0, 'Коллекция состояний не заполнена');
  // тест на поиск хотя бы одного объекта с заданной структурой
  // тест на поиск хотя бы одного объекта с заданной площадью
end;

{ TDrillingObligationWellPosterTest }

procedure TDrillingObligationWellPosterTest.CheckGetError(
  ADataPoster: TImplementedDataPoster; ARecordCount: integer;
  AText: string);
var
  ds: TCommonServerDataset;
begin
  ds := TMainFacade.GetInstance.DBGates.Add(ADataPoster);
  Check(ARecordCount > 0, Format('Данные о %s не получены. Код ошибки [%s].', [AText, IntToStr(ds.LastResult)]));
end;

procedure TDrillingObligationWellPosterTest.SetUp;
begin
  inherited;

end;

procedure TDrillingObligationWellPosterTest.TestGetDrillingObligationWell;
var dp: TDataPoster;
    objs: TDrillingObligationWells;
begin
  dp := TMainFacade.GetInstance.DataPosterByClassType[TDrillingObligationWellDataPoster]
        as TImplementedDataPoster;
  CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', nil), 'скажине пробуренной на лиц участке');

  objs := TDrillingObligationWells.Create;
  CheckGetError(dp as TImplementedDataPoster, dp.GetFromDB('', objs), 'скважине пробуренной на лиц участке в коллекцию объектов ');
  Check(objs.Count > 0, 'Коллекция состояний не заполнена');
end;

initialization

  RegisterTest('PosterTests\GRRPosters\TNirStatePosterTest', TNirStatePosterTest.Suite);
  RegisterTest('PosterTests\GRRPosters\TNirTypePosterTest', TNirTypePosterTest.Suite);
  RegisterTest('PosterTests\GRRPosters\TNIRObligationPosterTest',  TNIRObligationPosterTest.Suite);
  RegisterTest('PosterTests\GRRPosters\TSeismicObligationPosterTest', TSeismicObligationPosterTest.Suite);
  RegisterTest('PosterTests\GRRPosters\TDrillingObligationPosterTest',TDrillingObligationPosterTest.Suite);
  RegisterTest('PosterTests\GRRPosters\TNirObligationPlacePosterTest', TNirObligationPlacePosterTest.Suite);
  RegisterTest('PosterTests\GRRPosters\TSeismicObligationPlacePosterTest', TSeismicObligationPlacePosterTest.Suite);
  RegisterTest('PosterTests\GRRPosters\TDrillingObligationWellPosterTest', TDrillingObligationWellPosterTest.Suite);
 // RegisterTest(t);
end.
