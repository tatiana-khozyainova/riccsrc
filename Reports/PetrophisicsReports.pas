unit PetrophisicsReports;

interface

uses SDReport, Classes;

type

   TPetrophisicsReport = class(TSDSQLCollectionReport)
   protected
     procedure InternalOpenTemplate; override;
     procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
   public
     procedure PrepareReport; override;
     constructor Create(AOwner: TComponent); override;
   end;

   TGranulometryReport = class(TSDSQLCollectionReport)
   protected
     procedure InternalOpenTemplate; override;
     procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
   public
     procedure PrepareReport; override;
     constructor Create(AOwner: TComponent); override;
   end;


   TCentrifugingReport = class(TSDSQLCollectionReport)
   protected
     procedure InternalOpenTemplate; override;
     procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
   public
     procedure PrepareReport; override;
     constructor Create(AOwner: TComponent); override;
   end;


implementation

uses SysUtils, CommonReport;

{ TPetrophisicsReport }

constructor TPetrophisicsReport.Create(AOwner: TComponent);
begin
  inherited;
  ReportQueryTemplate :=  'select distinct 1, ds.vch_lab_number, s.vch_slotting_number||' + '''' + '/' + '''' + '||rs.vch_general_number, s.num_slotting_top, s.num_slotting_bottom, rs.num_from_slotting_top, ' +
                          '(select first 1 skip 0 l.vch_rock_name from tbl_lithology_dict l where rs.rock_id = l.rock_id), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 144 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (115, 116) and dr.rock_sample_uin = ds.rock_sample_uin and ds.dnr_sample_type_id <> 2), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (115, 116) and dr.rock_sample_uin = ds.rock_sample_uin and ds.dnr_sample_type_id = 2), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 101 and dr.side_id in (0, 1) and dr.rock_sample_uin = ds.rock_sample_uin),  ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 101 and dr.side_id in (2) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 101 and dr.side_id in (3) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 118 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (112, 113) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (114) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (141) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 131 and dr.side_id in (0, 1) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 131 and dr.side_id in (2) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 131 and dr.side_id in (3) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (142) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 132 and dr.side_id in (0, 1) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 132 and dr.side_id in (2) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 132 and dr.side_id in (3) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (133) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (134) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (143) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 102 and dr.side_id in (0, 1) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 102 and dr.side_id in (2) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 102 and dr.side_id in (3) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                          'ds.vch_dnr_comment_text ' +
                          'from tbl_slotting s, tbl_rock_sample rs, tbl_dnr_sample ds, tbl_dnr_research drs ' +
                          'where ds.rock_sample_uin = rs.rock_sample_uin ' +
                          'and rs.slotting_uin = s.slotting_uin ' +
                          'and drs.rock_sample_uin = ds.rock_sample_uin ' +
                          'and (drs.research_id >= 100 and drs.research_id < 200) ' +
                          'and s.well_uin in (%s) order by s.num_slotting_top, rs.num_from_slotting_top';
  NeedsExcel := true;
  SilentMode := true;
  SaveReport := true;
  AutoNumber := [anColumns, anRows];
  RemoveEmptyCols := true;
  DrawBorders := true;
  ReportName := 'Петрофизические_свойства'
end;

procedure TPetrophisicsReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(ParamStr(0))+'\Petrophisics.xltx');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TPetrophisicsReport.PrepareReport;
var cg: TColumnGroup;
begin
  //FExcel.Visible := true;
  inherited;
  FirstColIndex := 1;
  LastColIndex := 31;
  AutonumberRow := 13;
  FirstRowIndex := 14;
  LastRowIndex := 14;

  Replacements.Clear;
  Replacements.AddReplacementRow(7, 1, '#skv#', ReportingObjects.List());
  Replacements.AddReplacementColumn(7, 14, '<нет данных>', '');
  Replacements.AddReplacementColumn(7, 14, '  ', '');  
  Replacements.AddReplacementColumn(11, 14, '-1', 'Н/П');
  Replacements.AddReplacementColumn(12, 14, '-1', 'Н/П');
  Replacements.AddReplacementColumn(13, 14, '-1', 'Н/П');
  Replacements.AddReplacementColumn(6, 13, '-1', '');
  

  cg := ColumnGroups.Add('Пористость');
  cg.Add(8); cg.Add(9); cg.Add(10);
  cg := ColumnGroups.Add('Газопроницаемость');
  cg.Add(11); cg.Add(12); cg.Add(13);
  cg := ColumnGroups.Add('Нефтенасыщенность');
  cg.Add(14);
  cg := ColumnGroups.Add('Плотность');
  cg.Add(15); cg.Add(16);
  cg := ColumnGroups.Add('УЭС');
  cg.Add(17); cg.Add(18); cg.Add(19); cg.Add(20);
  cg := ColumnGroups.Add('Отнсопр');
  cg.Add(21); cg.Add(22); cg.Add(23); cg.Add(24);
  cg := ColumnGroups.Add('Сопрводы');
  cg.Add(25); cg.Add(26);
  cg := ColumnGroups.Add('Время');
  cg.Add(27); cg.Add(28); cg.Add(29);
  cg := ColumnGroups.Add('Заголовок');
  cg.Add(1); cg.Add(2); cg.Add(3); cg.Add(4); cg.Add(5); cg.Add(6); cg.Add(7); cg.Add(31); 
end;

procedure TPetrophisicsReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  inherited;
  FirstColIndex := 1;
  LastColIndex := 31;
  FirstRowIndex := 14;
  LastRowIndex := 14;

  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[(LastRowIndex + AQueryBlock.RecordCount - 1)*2, FirstColIndex + AQueryBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
end;


{ TGranulometryReport }

constructor TGranulometryReport.Create(AOwner: TComponent);
begin
  inherited;
  ReportQueryTemplate :=    'select distinct 1, ds.vch_lab_number, s.vch_slotting_number||' + '''' + '/' + '''' + '||rs.vch_general_number, ' +
                            's.num_slotting_top, s.num_slotting_bottom, rs.num_from_slotting_top, ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 301 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (302) and dr.value_type_id = 1 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (302) and dr.value_type_id = 2 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (302) and dr.value_type_id = 3 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (302) and dr.value_type_id = 4 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (302) and dr.value_type_id = 5 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (302) and dr.value_type_id = 6 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (302) and dr.value_type_id = 7 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (302) and dr.value_type_id = 8 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id in (303) and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 l.vch_rock_name from tbl_lithology_dict l where rs.rock_id = l.rock_id) ' +
                            'from tbl_slotting s, tbl_rock_sample rs, tbl_dnr_sample ds, tbl_dnr_research drs ' +
                            'where ds.rock_sample_uin = rs.rock_sample_uin and rs.slotting_uin = s.slotting_uin ' +
                            'and drs.rock_sample_uin = ds.rock_sample_uin and (drs.research_id >= 300 and drs.research_id < 400) ' +
                            'and s.well_uin in (%s) order by s.num_slotting_top, rs.num_from_slotting_top';

  NeedsExcel := true;
  SilentMode := true;
  SaveReport := true;
  AutoNumber := [anColumns, anRows];
  RemoveEmptyCols := true;
  DrawBorders := true;
  ReportName := 'Гран_сост'
end;

procedure TGranulometryReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(ParamStr(0))+'\Granulometry.xltx');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TGranulometryReport.PrepareReport;
var cg: TColumnGroup;
begin
  inherited;
  FirstColIndex := 1;
  LastColIndex := 17;
  FirstRowIndex := 13;
  LastRowIndex := 13;
  AutonumberRow := 12;

  Replacements.Clear;
  Replacements.AddReplacementRow(6, 1, '#skv#', ReportingObjects.List());
  Replacements.AddReplacementColumn(17, 13, '<нет данных>', '');
  Replacements.AddReplacementColumn(17, 13, '  ', '');
  Replacements.AddReplacementColumn(6, 13, '-1', '');

  cg := ColumnGroups.Add('Содержание частиц');
  cg.AddRange(8, 16);
  cg := ColumnGroups.Add('Карбонатность');
  cg.Add(7);
end;

procedure TGranulometryReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  inherited;
  FirstColIndex := 1;
  LastColIndex := 17;
  FirstRowIndex := 13;
  LastRowIndex := 13;

  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[(LastRowIndex + AQueryBlock.RecordCount - 1)*2, FirstColIndex + AQueryBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
end;

{ TCentrifugingReport }

constructor TCentrifugingReport.Create(AOwner: TComponent);
begin
  inherited;
  ReportQueryTemplate :=    'select distinct 1, ds.vch_lab_number, s.vch_slotting_number||' + '''' + '/' + '''' + '||rs.vch_general_number, ' +
                            's.num_slotting_top, s.num_slotting_bottom, rs.num_from_slotting_top, ' +
                            '(select first 1 skip 0 l.vch_rock_name from tbl_lithology_dict l where rs.rock_id = l.rock_id), ' +

                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 203 and dr.value_type_id = 2 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 202 and dr.value_type_id = 2 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 201 and dr.value_type_id = 2 and dr.rock_sample_uin = ds.rock_sample_uin), ' +

                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 203 and dr.value_type_id = 3 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 202 and dr.value_type_id = 3 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 201 and dr.value_type_id = 3 and dr.rock_sample_uin = ds.rock_sample_uin), ' +

                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 203 and dr.value_type_id = 4 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 202 and dr.value_type_id = 4 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 201 and dr.value_type_id = 4 and dr.rock_sample_uin = ds.rock_sample_uin), ' +

                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 203 and dr.value_type_id = 5 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 202 and dr.value_type_id = 5 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 201 and dr.value_type_id = 5 and dr.rock_sample_uin = ds.rock_sample_uin), ' +

                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 203 and dr.value_type_id = 6 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 202 and dr.value_type_id = 6 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 201 and dr.value_type_id = 6 and dr.rock_sample_uin = ds.rock_sample_uin), ' +

                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 203 and dr.value_type_id = 7 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 202 and dr.value_type_id = 7 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 201 and dr.value_type_id = 7 and dr.rock_sample_uin = ds.rock_sample_uin), ' +

                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 203 and dr.value_type_id = 8 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 202 and dr.value_type_id = 8 and dr.rock_sample_uin = ds.rock_sample_uin), ' +
                            '(select first 1 skip 0 dr.num_value from tbl_dnr_research dr where dr.research_id = 201 and dr.value_type_id = 8 and dr.rock_sample_uin = ds.rock_sample_uin) ' +


                            'from tbl_slotting s, tbl_rock_sample rs, tbl_dnr_sample ds, tbl_dnr_research drs ' +
                            'where ds.rock_sample_uin = rs.rock_sample_uin and rs.slotting_uin = s.slotting_uin ' +
                            'and drs.rock_sample_uin = ds.rock_sample_uin and (drs.research_id >= 200 and drs.research_id < 300) ' +
                            'and s.well_uin in (%s) order by s.num_slotting_top, rs.num_from_slotting_top';


  NeedsExcel := true;
  SilentMode := true;
  SaveReport := true;
  AutoNumber := [anColumns, anRows];
  RemoveEmptyCols := false;
  DrawBorders := true;
  ReportName := 'Центрифугирование_'
end;

procedure TCentrifugingReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(ParamStr(0))+'\Centrifuging.xltx');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TCentrifugingReport.PrepareReport;
begin
  inherited;
  FirstColIndex := 1;
  LastColIndex := 29;
  FirstRowIndex := 13;
  LastRowIndex := 13;
  AutonumberRow := 12;

  Replacements.Clear;
  Replacements.AddReplacementRow(7, 1, '#skv#', ReportingObjects.List());
  Replacements.AddReplacementColumn(7, 13, '<нет данных>', '');
  Replacements.AddReplacementColumn(7, 13, '  ', '');
  Replacements.AddReplacementColumn(6, 13, '-1', '');

end;

procedure TCentrifugingReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  inherited;
  FirstColIndex := 1;
  LastColIndex := 29;
  FirstRowIndex := 13;
  LastRowIndex := 13;

  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[(LastRowIndex + AQueryBlock.RecordCount - 1)*2, FirstColIndex + AQueryBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
end;

end.
