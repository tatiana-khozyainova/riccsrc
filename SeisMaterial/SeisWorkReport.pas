unit SeisWorkReport;

interface

uses SDReport, Classes, Grids;

type

  TFieldList = class(TStringList);
  //public

  //end;

  TSeisReport = class(TSDReport)
  private
    FFieldList: TFieldList;
    FExcount:Integer;
  protected
    procedure InternalOpenTemplate; override;
    procedure InternalMoveData; override;
    procedure PostFormat; override;
  public
    procedure MakeGrid(SG:TStringGrid);
    property FieldList: TFieldList read FFieldList write FFieldList;
    constructor Create(AOwner: TComponent); override;
  end;



implementation


uses SysUtils, Forms, CommonReport, Material, Facade, ComObj;

{ TSeisReport }

constructor TSeisReport.Create(AOwner: TComponent);
begin
  inherited;
  FieldList:=TFieldList.Create;
  NeedsExcel := true;
  SilentMode := false;
  SaveReport := true;
  //AutoNumber := [anRows];
  RemoveEmptyCols := false;
  DrawBorders := false;
  ReportName := 'Список отчетов';
  FirstRowIndex := 2;
  FirstColIndex := 2;
  AutonumberColumn:=1;
  //ReportPath:='D:\riccsrc\current\SeisMaterial\report'
end;

procedure TSeisReport.InternalMoveData;
var i,j,k,n,m,o,p,sdpos,exstep,spstep,addstep,step3: integer;sm,sp:Boolean;strprof,strex,strel:string;
Cells_1,Cells_2,Range_1:OleVariant;
begin
  inherited;

  LastRowIndex:=FirstRowIndex+ReportingObjects.Count-1;
  FXLWorksheet.Cells.Item[FirstRowIndex-1, FirstColIndex-1]:='№';
  for j := 0 to FieldList.Count-1 do
  FXLWorksheet.Cells.Item[FirstRowIndex-1, FirstColIndex+j]:=FieldList.Strings[j];

  step3:=0;

  // перебор репортинг обджектс и выкидывание в отчет нужных полей
  for sdpos := 0 to ReportingObjects.Count - 1 do
  begin
    sm:=False;
    for k:=0 to TMainFacade.GetInstance.AllSeismicMaterials.Count-1 do
    if TMainFacade.GetInstance.AllSeismicMaterials.Items[k].SimpleDocument.ID=(ReportingObjects.Items[sdpos] as TSimpleDocument).ID  then
    begin
    sm:=True;
    Break;
    end;
    strprof:='';
    if sm then
    for n:=0 to  TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
    if Assigned(TMainFacade.GetInstance.ALLSeismicProfiles.Items[n].SeismicMaterial) then
    if TMainFacade.GetInstance.ALLSeismicProfiles.Items[n].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].ID then
    strprof:=strprof+IntToStr(TMainFacade.GetInstance.ALLSeismicProfiles.Items[k].SeisProfileNumber)+', ';

    for j := 0 to FieldList.Count - 1 do
    begin
      with (ReportingObjects.Items[sdpos] as TSimpleDocument) do
      begin
      FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex-1] :=sdpos+1;
      case Integer(FieldList.Objects[j]) of
      0: FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j] := (ReportingObjects.Items[sdpos] as TSimpleDocument).InventNumber; // заполнение
      1: FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j] := (ReportingObjects.Items[sdpos] as TSimpleDocument).TGFNumber; // заполнение
      2: FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j] := (ReportingObjects.Items[sdpos] as TSimpleDocument).Name; // заполнение
      3: FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j] := (ReportingObjects.Items[sdpos] as TSimpleDocument).Authors; // заполнение
      4: FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j] := (ReportingObjects.Items[sdpos] as TSimpleDocument).Bindings; // заполнение
      5: FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j] := DateToStr((ReportingObjects.Items[sdpos] as TSimpleDocument).CreationDate); // заполнение
      6: if Assigned(Organization) then FXLWorksheet.Cells.Item[FirstRowIndex+sdpos, FirstColIndex+j]:=Organization.Name;
      7: if Assigned(MaterialLocation) then FXLWorksheet.Cells.Item[FirstRowIndex+sdpos, FirstColIndex+j]:=MaterialLocation.Name;
      end;
      if (sm) and (Integer(FieldList.Objects[j])>7) then
      case Integer(FieldList.Objects[j]) of
      8:FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j]:=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].SeisWorkType.Name;
      9:FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j]:=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].SeisWorkMethod.Name;
      10:FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j]:=IntToStr(TMainFacade.GetInstance.AllSeismicMaterials.Items[k].SeisCrew.SeisCrewNumber);
      11:FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j]:=IntToStr(TMainFacade.GetInstance.AllSeismicMaterials.Items[k].SeisWorkScale);
      12:FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j]:=DateToStr(TMainFacade.GetInstance.AllSeismicMaterials.Items[k].BeginWorksDate);
      13:FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j]:=DateToStr(TMainFacade.GetInstance.AllSeismicMaterials.Items[k].EndWorksDate);
      14:FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j]:=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].StructMapReflectHorizon;
      15:FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j]:=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].CrossSection;
      16:FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j]:=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].ReferenceComposition;
      end;
      if (strprof<>'') and (Integer(FieldList.Objects[j])=17) then
      FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3, FirstColIndex+j]:=Copy(strprof,1,Length(strprof)-2);
      end;

      if Integer(FieldList.Objects[j])=18 then
      begin
      exstep:=0;
      for m:=0 to TMainFacade.GetInstance.ALLExempleSeismicMaterials.Count-1 do
      if TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[m].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].ID then
      begin
      FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3+exstep, FirstColIndex+j]:=TMainFacade.GetInstance.AllExempleTypes.ItemsByID[TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[m].ExempleType.ID].Name;
      inc(exstep);
      end;
      end;
      if Integer(FieldList.Objects[j])=19 then
      begin
      exstep:=0;
      for m:=0 to TMainFacade.GetInstance.ALLExempleSeismicMaterials.Count-1 do
      if TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[m].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].ID then
      begin
      FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3+exstep, FirstColIndex+j]:=TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[m].ExempleSum;
      inc(exstep);
      end;
      end;
      if Integer(FieldList.Objects[j])=20 then
      begin
      exstep:=0;
      for m:=0 to TMainFacade.GetInstance.ALLExempleSeismicMaterials.Count-1 do
      if TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[m].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].ID then
      begin
      FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3+exstep, FirstColIndex+j]:=TMainFacade.GetInstance.AllExempleLocations.ItemsByID[TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[m].ExempleLocation.ID].List;
      inc(exstep);
      end;
      end;

      if Integer(FieldList.Objects[j])=25 then
      begin
      spstep:=0;
      for m:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
      if TMainFacade.GetInstance.ALLSeismicProfiles.Items[m].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].ID then
      begin
      FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3+spstep, FirstColIndex+j]:=TMainFacade.GetInstance.ALLSeismicProfiles.Items[m].SeisProfileNumber;
      inc(spstep);
      end;
      end;
      if Integer(FieldList.Objects[j])=26 then
      begin
      spstep:=0;
      for m:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
      if TMainFacade.GetInstance.ALLSeismicProfiles.Items[m].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].ID then
      begin
      FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3+spstep, FirstColIndex+j]:=TMainFacade.GetInstance.AllSeismicProfileTypes.ItemsByID[TMainFacade.GetInstance.ALLSeismicProfiles.Items[m].SeismicProfileType.ID].Name;
      inc(spstep);
      end;
      end;
      if Integer(FieldList.Objects[j])=27 then
      begin
      spstep:=0;
      for m:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
      if TMainFacade.GetInstance.ALLSeismicProfiles.Items[m].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].ID then
      begin
      FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3+spstep, FirstColIndex+j]:=IntToStr(TMainFacade.GetInstance.ALLSeismicProfiles.Items[m].PiketBegin)+' - '+IntToStr(TMainFacade.GetInstance.ALLSeismicProfiles.Items[m].PiketEnd);
      inc(spstep);
      end;
      end;
      if Integer(FieldList.Objects[j])=28 then
      begin
      spstep:=0;
      for m:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
      if TMainFacade.GetInstance.ALLSeismicProfiles.Items[m].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].ID then
      begin
      FXLWorksheet.Cells.Item[FirstRowIndex+sdpos+step3+spstep, FirstColIndex+j]:=TMainFacade.GetInstance.ALLSeismicProfiles.Items[m].SeisProfileLenght;
      inc(spstep);
      end;
      end;



    end;

    if exstep=0 then exstep:=1;
    if spstep=0 then spstep:=1;
    if spstep>exstep then addstep:=spstep else addstep:=exstep;
    for j := 0 to FieldList.Count - 1 do
    if ((Integer(FieldList.Objects[j])<>18) and (Integer(FieldList.Objects[j])<>19) and (Integer(FieldList.Objects[j])<>20) and (Integer(FieldList.Objects[j])<>25)  and (Integer(FieldList.Objects[j])<>26)  and (Integer(FieldList.Objects[j])<>27)  and (Integer(FieldList.Objects[j])<>28)) then
    begin
    Cells_1:=FXLWorksheet.Cells[FirstRowIndex+sdpos+step3, FirstColIndex+j];
    Cells_2:=FXLWorksheet.Cells[FirstRowIndex+sdpos+step3+addstep-1, FirstColIndex+j];
    Range_1:=FXLWorksheet.Range[Cells_1, Cells_2];
    Range_1.Merge;
    end;
    Cells_1:=FXLWorksheet.Cells[FirstRowIndex+sdpos+step3, FirstColIndex-1];
    Cells_2:=FXLWorksheet.Cells[FirstRowIndex+sdpos+step3+addstep-1, FirstColIndex-1];
    Range_1:=FXLWorksheet.Range[Cells_1, Cells_2];
    Range_1.Merge;

    step3:=step3+addstep-1;

  end;
  FExcount:=step3;
end;




procedure TSeisReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\SeisReport.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TSeisReport.MakeGrid(SG: TStringGrid);
var i,j,k,n:Integer;sm,sp:Boolean;strprof:string;
begin

  for j := 0 to FieldList.Count-1 do
  SG.Cells[1+j,0]:=FieldList.Strings[j];
  SG.Objects[0,0]:=TObject(1);
  for i := 0 to ReportingObjects.Count - 1 do
  begin
    SG.Objects[0,1+i]:=TObject(1);
    sm:=False;
    for k:=0 to TMainFacade.GetInstance.AllSeismicMaterials.Count-1 do
    if TMainFacade.GetInstance.AllSeismicMaterials.Items[k].SimpleDocument.ID=(ReportingObjects.Items[i] as TSimpleDocument).ID  then
    begin
    sm:=True;
    Break;
    end;
    strprof:='';
    if sm then
    for n:=0 to  TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
    if Assigned(TMainFacade.GetInstance.ALLSeismicProfiles.Items[n].SeismicMaterial) then
    if TMainFacade.GetInstance.ALLSeismicProfiles.Items[n].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].ID then
    strprof:=strprof+IntToStr(TMainFacade.GetInstance.ALLSeismicProfiles.Items[n].SeisProfileNumber)+', ';

    for j := 0 to FieldList.Count - 1 do
    begin
      with (ReportingObjects.Items[i] as TSimpleDocument) do
      begin
      SG.Objects[1+j,1+i]:=(ReportingObjects.Items[i] as TSimpleDocument);
      case Integer(FieldList.Objects[j]) of
      0: SG.Cells[1+j,1+i] := IntToStr((ReportingObjects.Items[i] as TSimpleDocument).InventNumber); // заполнение
      1: SG.Cells[1+j,1+i] := IntToStr((ReportingObjects.Items[i] as TSimpleDocument).TGFNumber); // заполнение
      2: SG.Cells[1+j,1+i] := (ReportingObjects.Items[i] as TSimpleDocument).Name; // заполнение
      3: SG.Cells[1+j,1+i] := (ReportingObjects.Items[i] as TSimpleDocument).Authors; // заполнение
      4: SG.Cells[1+j,1+i] := (ReportingObjects.Items[i] as TSimpleDocument).Bindings; // заполнение
      5: SG.Cells[1+j,1+i] := DateToStr((ReportingObjects.Items[i] as TSimpleDocument).CreationDate); // заполнение
      6: if Assigned(Organization) then SG.Cells[1+j,1+i]:=Organization.Name;
      7: if Assigned(MaterialLocation) then SG.Cells[1+j,1+i]:=MaterialLocation.Name;
      end;
      if (sm) and (Integer(FieldList.Objects[j])>7) then
      case Integer(FieldList.Objects[j]) of
      8:SG.Cells[1+j,1+i]:=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].SeisWorkType.Name;
      9:SG.Cells[1+j,1+i]:=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].SeisWorkMethod.Name;
      10:SG.Cells[1+j,1+i]:=IntToStr(TMainFacade.GetInstance.AllSeismicMaterials.Items[k].SeisCrew.SeisCrewNumber);
      11:SG.Cells[1+j,1+i]:=IntToStr(TMainFacade.GetInstance.AllSeismicMaterials.Items[k].SeisWorkScale);
      12:SG.Cells[1+j,1+i]:=DateToStr(TMainFacade.GetInstance.AllSeismicMaterials.Items[k].BeginWorksDate);
      13:SG.Cells[1+j,1+i]:=DateToStr(TMainFacade.GetInstance.AllSeismicMaterials.Items[k].EndWorksDate);
      14:SG.Cells[1+j,1+i]:=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].StructMapReflectHorizon;
      15:SG.Cells[1+j,1+i]:=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].CrossSection;
      16:SG.Cells[1+j,1+i]:=TMainFacade.GetInstance.AllSeismicMaterials.Items[k].ReferenceComposition;
      end;
      if (strprof<>'') and (Integer(FieldList.Objects[j])=17) then
      SG.Cells[1+j,1+i]:=Copy(strprof,1,Length(strprof)-2);
      end;
    end;
  end;
end;

procedure TSeisReport.PostFormat;
var Cell1, Cell2, Range: OleVariant;i:Integer;
begin
  inherited;

  Cell1 := FExcel.Cells.Item[FirstRowIndex-1, FirstColIndex-1];
  Cell2 := FExcel.Cells.Item[FirstRowIndex+ReportingObjects.Count-1+FExcount,FirstColIndex+FieldList.Count-1];
  Range:=FExcel.Range[Cell1,Cell2];

  for  i :=  7 to 12 do
  Range.Borders.Item[i].LineStyle := 1;

  FExcel.Columns[FirstRowIndex-1].ColumnWidth:=10;

  for i:=0 to FieldList.Count-1 do
  case  Integer(FieldList.Objects[i]) of
  0:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=10;
  FExcel.Columns[FirstColIndex+i].Font.Bold:=True;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
  1:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=10;
  FExcel.Columns[FirstColIndex+i].Font.Bold:=True;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
  2:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=30;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=2;
  FExcel.Selection.VerticalAlignment:=1;
  end;
  3:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=40;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=1;
  end;
  4:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=40;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=2;
  FExcel.Selection.VerticalAlignment:=1;
  end;
  5:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=10;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
  6:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=25;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=1;
  end;
  7:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=20;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=1;
  end;
  8:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=20;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=1;
  end;
  9:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=20;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=1;
  end;
  10:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=10;
  FExcel.Columns[FirstColIndex+i].Font.Bold:=True;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
  11:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=10;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=1;
  end;
  12:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=10;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
  13:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=10;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
  14:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=40;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=2;
  FExcel.Selection.VerticalAlignment:=1;
  end;
  15:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=40;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=2;
  FExcel.Selection.VerticalAlignment:=1;
  end;
  17:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=20;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=2;
  FExcel.Selection.VerticalAlignment:=1;
  end;
  18:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=25;
  FExcel.Columns[FirstColIndex+i].Font.Bold:=True;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
  19:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=10;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
  20:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=25;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
    25:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=15;
  FExcel.Columns[FirstColIndex+i].Font.Bold:=True;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
    26:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=25;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
    27:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=15;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;
    28:
  begin
  FExcel.Columns[FirstColIndex+i].ColumnWidth:=15;
  FExcel.Columns[FirstColIndex+i].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;
  end;


  end;

  FExcel.Rows[FirstRowIndex-1].Font.Bold:=True;
  FExcel.Rows[FirstRowIndex-1].Select;
  FExcel.Selection.HorizontalAlignment:=3;
  FExcel.Selection.VerticalAlignment:=2;

  FExcel.Range[Cell1,Cell2].Select;
  FExcel.Selection.WrapText:=True;
end;

{ TSeisProfile }



end.
