unit StratClientSubdivisionEditFrameTest;

interface

uses TestFrameWork,StratClientSubdivisionEditFrame, SubdivisionTable, Forms, Well;

type

   TStratClientSibdivisionEditFrameTest = class(TTestCase)
   private
     FSubdivisionTable: TSubdivisionTable;
     FWells: TWells;
     FFileName: string;
     frm: TForm;
   protected
     procedure SetUp; override;
     procedure TearDown; override;
   published
     procedure TestLoadFromFile;
     procedure TestLoadFromDB;
   end;

implementation

uses SysUtils, Facade, Controls, StratClientSubdivisionEditForm;

{ TStratClientSibdivisionEditFrameTest }

procedure TStratClientSibdivisionEditFrameTest.SetUp;
begin
  inherited;
  FSubdivisionTable := TSubdivisionTable.Create;
  FSubdivisionTable.FirstCol := 1;
  FSubdivisionTable.FirstRow := 1;
  FFileName := ExtractFilePath(ParamStr(0)) + '\BaseTests\MadeBagan2.xlsx';

  FWells := TWells.Create;
  FWells.Reload('Area_ID = 32', false); 
end;

procedure TStratClientSibdivisionEditFrameTest.TearDown;
begin
  //FreeAndNil(FSubdivisionTable);
  FreeAndNil(FWells);
  inherited;
end;

procedure TStratClientSibdivisionEditFrameTest.TestLoadFromDB;
begin
  FSubdivisionTable.LoadSubdivisions(FWells);

  FSubdivisionTable.LoadSubdivisionTable(TMainFacade.GetInstance.AllSimpleStratons, (TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments, (TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks);

  frm := TfrmSubdivisionEditForm.Create(Application.MainForm);

  with (frm as TfrmSubdivisionEditForm).frmSubdivisionEditFrame1 do
  begin
    SubdivisionTable := FSubdivisionTable;
    Reload;
  end;

  frm.Show;
end;

procedure TStratClientSibdivisionEditFrameTest.TestLoadFromFile;
begin
  // ���������� ��
  FSubdivisionTable.LoadFromFile(FFileName);

  // ����������� �� ������ �����������
  Check(TMainFacade.GetInstance.AllSimpleStratons.Count > 0, '�� �������� ���������� ���������');
  Check((TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments.Count > 0, '�� �������� ���������� ��������� � ���������');
  Check((TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks.Count > 0, '�� �������� ���������� ������������� ������');

  // ����������� �� ��������
  FSubdivisionTable.LoadSubdivisionTable(TMainFacade.GetInstance.AllSimpleStratons, (TMainFacade.GetInstance as TMainFacade).AllSubdivisionComments, (TMainFacade.GetInstance as TMainFacade).AllTectonicBlocks);

  frm := TfrmSubdivisionEditForm.Create(Application.MainForm);

  with (frm as TfrmSubdivisionEditForm).frmSubdivisionEditFrame1 do
  begin
    SubdivisionTable := FSubdivisionTable;
    Reload;
  end;

  frm.Show;


end;


initialization
  RegisterTest('StratClientTests\TStratClientSibdivisionEditFrameTest', TStratClientSibdivisionEditFrameTest.Suite);


end.
