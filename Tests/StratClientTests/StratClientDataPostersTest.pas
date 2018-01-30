unit StratClientDataPostersTest;

interface

uses TestFrameWork, SubdivisionComponent, SubdivisionComponentPoster, Well, BaseObjects;

type

   TStratClientDMTest = class(TTestCase)
   private
     FWell: TWell;
   protected
     // �� � �������� �������� 2 8171

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

  Check(FWell.Subdivisions.Count = iCount + 1, '�� ��������� ����� ��������');
  Check(FWell.Subdivisions.Items[iCount].ID > 0, '����� �������� �� ��������� � �� (�� �������� �������������)');

  iID := FWell.Subdivisions.Items[iCount].ID;
  dp := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionDataPoster] as TImplementedDataPoster;
  dp.GetFromDB('Subdivision_ID = ' + IntToStr(iID), nil);
  ds := TMainFacade.GetInstance.DBGates.Add(dp) as TDataSet;
  Check(ds.RecordCount = 1, '�������� �� ��������� � ��');
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


  Check(s.SubdivisionComponents.Count = iCount + 1, '�� �������� ����� ������� ��������');
  Check(s.SubdivisionComponents.Items[iCount].ID > 0, '����� ������� �������� �� �������� � �� (�� �������� �������������)');

  iID := s.SubdivisionComponents.Items[iCount].ID;
  dp := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionComponentDataPoster] as TImplementedDataPoster;
  dp.GetFromDB('Subdivision_ID = ' + IntToStr(s.ID) + ' and ' + 'Straton_ID = ' + IntToStr(sc.Straton.ID), nil);
  ds := TMainFacade.GetInstance.DBGates.Add(dp) as TDataSet;
  Check(ds.RecordCount = 1, '������� �������� �� �������� � ��');
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
    Check(FWell.Subdivisions.Count = iCount - 1, '�������� �� �������');

    dp := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionDataPoster] as TImplementedDataPoster;
    dp.GetFromDB('Subdivision_ID = ' + IntToStr(iID), nil);
    ds := TMainFacade.GetInstance.DBGates.Add(dp) as TDataSet;
    Check(ds.RecordCount = 0, '�������� �� ������� �� ��');
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
    Check(s.SubdivisionComponents.Count = iCount - 1, '������� �������� �� ������');

    dp := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionComponentDataPoster] as TImplementedDataPoster;
    dp.GetFromDB('Subdivision_ID = ' + IntToStr(iID) + ' and ' + 'Straton_ID ' + ' = ' + IntToStr(iStratonID), nil);
    ds := TMainFacade.GetInstance.DBGates.Add(dp) as TDataSet;
    Check(ds.RecordCount = 0, '�������� �� ������� �� ��');
  end;
end;

procedure TStratClientDMTest.TestGetEmployees;
begin
  Check((TMainFacade.GetInstance as TMainFacade).AllEmployees.Count > 0, '�� �������� ������ �����������');
end;

procedure TStratClientDMTest.TestGetStratons;
begin
  Check((TMainFacade.GetInstance as TMainFacade).AllSimpleStratons.Count > 0, '�� �������� ������ ��� ���');
end;

procedure TStratClientDMTest.TestGetSubdivisionComments;
begin
  Check((TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments.Count > 0, '�� �������� ������ ������������ � ���������');
end;

procedure TStratClientDMTest.TestGetTectonicBlocks;
begin
  Check((TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks.Count > 0, '�� �������� ������ ������������� ������');
end;

procedure TStratClientDMTest.TestGetThemes;
begin
  Check((TMainFacade.GetInstance as TMainFacade).AllThemes.Count > 0, '�� �������� ������ ��� ���');
end;

initialization
  RegisterTest('StratClientTests\StratClientDMTest', TStratClientDMTest.Suite);
end.
