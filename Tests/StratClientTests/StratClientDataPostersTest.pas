unit StratClientDataPostersTest;

interface

uses TestFrameWork, SubdivisionComponent, SubdivisionComponentPoster, Well, BaseObjects;

type

   TStratClientDMTest = class(TTestCase)
   private
     FWell: TWell;
   protected
     // всё к скважине тестовая 2 8171

     procedure SetUp; override;
     procedure TearDown; override;
   published
     procedure TestGetThemes;
     procedure TestGetEmployees;
     procedure TestGetStratons;
     procedure TestGetTectonicBlocks;
     procedure TestGetSubdivisionComments;


     procedure TestAddSubdivision;
     procedure TestDeleteSubdivision;

     procedure TestAddSubdivisionComponent;
     procedure TestDeleteSubdivisionComponent;
   end;

implementation

uses Facade, SysUtils, SDFacade, DB, DBGate;

{ TStratClientDMTest }

procedure TStratClientDMTest.SetUp;
begin
  inherited;

  TMainFacade.GetInstance.AllWells.Reload('WELL_UIN = 8171');
  FWell := TMainFacade.GetInstance.AllWells.Items[0];
end;

procedure TStratClientDMTest.TearDown;
begin
  inherited;

end;

procedure TStratClientDMTest.TestAddSubdivision;
var s: TSubdivision;
    iCount, iID: integer;
    dp: TImplementedDataPoster;
    ds: TDataSet;

begin
  iCount := FWell.Subdivisions.Count;
  s := FWell.Subdivisions.Add as TSubdivision;
  s.Theme := (TMainFacade.GetInstance as TMainFacade).AllThemes.Items[0];
  s.SingingDate :=  Date;
  s.SigningEmployee := (TMainFacade.GetInstance as TMainFacade).AllEmployees.Items[0];
  s.Update();

  Check(FWell.Subdivisions.Count = iCount + 1, 'Не добавлена новая разбивка');
  Check(FWell.Subdivisions.Items[iCount].ID > 0, 'Новая разбивка не сохранена в БД (не присвоен идентификатор)');

  iID := FWell.Subdivisions.Items[iCount].ID;
  dp := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionDataPoster] as TImplementedDataPoster;
  dp.GetFromDB('Subdivision_ID = ' + IntToStr(iID), nil);
  ds := TMainFacade.GetInstance.DBGates.Add(dp) as TDataSet;
  Check(ds.RecordCount = 1, 'Разбивка не сохранена в БД');
end;

procedure TStratClientDMTest.TestAddSubdivisionComponent;
var s: TSubdivision;
    sc: TSubdivisionComponent;
    iCount, iID: integer;
    dp: TImplementedDataPoster;
    ds: TDataSet;
begin
  if FWell.Subdivisions.Count = 0 then
  begin
    s := FWell.Subdivisions.Add as TSubdivision;
    s.Theme := (TMainFacade.GetInstance as TMainFacade).AllThemes.Items[0];
    s.SingingDate :=  Date;
    s.SigningEmployee := (TMainFacade.GetInstance as TMainFacade).AllEmployees.Items[0];
    s.Update();
  end
  else s := FWell.Subdivisions.ITems[0];

  iCount := s.SubdivisionComponents.Count;
  sc := s.SubdivisionComponents.Add as TSubdivisionComponent;
  sc.Straton := TMainFacade.GetInstance.AllSimpleStratons.Items[0];
  sc.Block := (TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks.Items[0];
  sc.Comment := (TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments.Items[0];
  sc.Depth := 100;
  sc.Verified := 1;
  sc.Update();


  Check(s.SubdivisionComponents.Count = iCount + 1, 'Не добавлен новый элемент разбивки');
  Check(s.SubdivisionComponents.Items[iCount].ID > 0, 'Новый элемент разбивки не сохранен в БД (не присвоен идентификатор)');

  iID := s.SubdivisionComponents.Items[iCount].ID;
  dp := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionComponentDataPoster] as TImplementedDataPoster;
  dp.GetFromDB('Subdivision_ID = ' + IntToStr(s.ID) + ' and ' + 'Straton_ID = ' + IntToStr(sc.Straton.ID), nil);
  ds := TMainFacade.GetInstance.DBGates.Add(dp) as TDataSet;
  Check(ds.RecordCount = 1, 'Элемент разбивки не сохранен в БД');
end;

procedure TStratClientDMTest.TestDeleteSubdivision;
var iCount: integer;
    iId: integer;
    dp: TImplementedDataPoster;
    ds: TDataSet;
begin
  iCount := FWell.Subdivisions.Count;
  if iCount > 0 then
  begin
    iID := FWell.Subdivisions.Items[0].ID;


    FWell.Subdivisions.MarkDeleted(0);
    FWell.Subdivisions.Update(nil);
    Check(FWell.Subdivisions.Count = iCount - 1, 'Разбивка не удалена');

    dp := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionDataPoster] as TImplementedDataPoster;
    dp.GetFromDB('Subdivision_ID = ' + IntToStr(iID), nil);
    ds := TMainFacade.GetInstance.DBGates.Add(dp) as TDataSet;
    Check(ds.RecordCount = 0, 'Разбивка не удалена из БД');
  end;
end;


procedure TStratClientDMTest.TestDeleteSubdivisionComponent;
var iCount: integer;
    iId, iStratonID: integer;
    dp: TImplementedDataPoster;
    ds: TDataSet;
    s: TSubdivision;
begin

  if FWell.Subdivisions.Count = 0 then
  begin
    s := FWell.Subdivisions.Add as TSubdivision;
    s.Theme := (TMainFacade.GetInstance as TMainFacade).AllThemes.Items[0];
    s.SingingDate :=  Date;
    s.SigningEmployee := (TMainFacade.GetInstance as TMainFacade).AllEmployees.Items[0];
    s.Update();
  end
  else s := FWell.Subdivisions.ITems[0];

  iCount := s.SubdivisionComponents.Count;
  if iCount > 0 then
  begin
    iID := s.ID;
    iStratonID := s.SubdivisionComponents.Items[0].Straton.ID;


    s.SubdivisionComponents.MarkDeleted(0);
    s.SubdivisionComponents.Update(nil);
    Check(s.SubdivisionComponents.Count = iCount - 1, 'Элемент разбивки не удален');

    dp := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionComponentDataPoster] as TImplementedDataPoster;
    dp.GetFromDB('Subdivision_ID = ' + IntToStr(iID) + ' and ' + 'Straton_ID ' + ' = ' + IntToStr(iStratonID), nil);
    ds := TMainFacade.GetInstance.DBGates.Add(dp) as TDataSet;
    Check(ds.RecordCount = 0, 'Разбивка не удалена из БД');
  end;
end;

procedure TStratClientDMTest.TestGetEmployees;
begin
  Check((TMainFacade.GetInstance as TMainFacade).AllEmployees.Count > 0, 'Не загружен список сотрудников');
end;

procedure TStratClientDMTest.TestGetStratons;
begin
  Check((TMainFacade.GetInstance as TMainFacade).AllSimpleStratons.Count > 0, 'Не загружен список тем НИР');
end;

procedure TStratClientDMTest.TestGetSubdivisionComments;
begin
  Check((TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments.Count > 0, 'На загружен список комментариев к разбивкам');
end;

procedure TStratClientDMTest.TestGetTectonicBlocks;
begin
  Check((TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks.Count > 0, 'На загружен список тектонических блоков');
end;

procedure TStratClientDMTest.TestGetThemes;
begin
  Check((TMainFacade.GetInstance as TMainFacade).AllThemes.Count > 0, 'Не загружен список тем НИР');
end;

initialization
  RegisterTest('StratClientTests\StratClientDMTest', TStratClientDMTest.Suite);
end.
