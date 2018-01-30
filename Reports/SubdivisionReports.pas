unit SubdivisionReports;

interface

uses SDReport, Classes, BaseObjects, Well;



 type

  TQueryTemplateBuilder = class
  private
     FConstantFromPart: string;
     FConstantWherePart: string;
     FVariableSelectPart: string;
     FConstantJoinPart: string;
     FVariableJoinPart: string;
     FConstantSelectPart: string;
     FConstantOrderByPart: string;
     function BuildVariableSelectPart(AIDList: TStrings): string;
     function BuildVariableJoinPart(AIDList: TStrings): string;
   public
     property ConstantSelectPart: string read FConstantSelectPart write FConstantSelectPart;
     property VariableSelectPart: string read FVariableSelectPart write FVariableSelectPart;
     property ConstantFromPart: string read FConstantFromPart write FConstantFromPart;

     property ConstantJoinPart: string read FConstantJoinPart write FConstantJoinPart;
     property VariableJoinPart: string read FVariableJoinPart write FVariableJoinPart;

     property ConstantWherePart: string read FConstantWherePart write FConstantWherePart;
     property ConstantOrderByPart: string read FConstantOrderByPart write FConstantOrderByPart;

     function BuildQuery(AIDList: OleVariant): string; overload;
     function BuildQuery(AIDList: TStrings): string; overload;

   end;


   TStandardSubdivisionReport = class(TSDSQLCollectionReport)
   private
     FColumns: OleVariant;
     FTotalDepthReached: Boolean;
     HeaderRange: OleVariant;
     FQueryBuilder: TQueryTemplateBuilder;
     FXLHiddenWorksheet: OleVariant;
     procedure CreateQueryTemplate;
    function GetWell: TSimpleWell;
   protected
     procedure InternalOpenTemplate; override;
     procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
     procedure PostProcessQueryBlock(AQueryBlock: OleVariant); override;
     procedure ProcessVerticalReportRow(AQueryBlock: OleVariant; ARow: integer; IsFirstBlock: boolean); override;
     function  GetReportFileName: string; override;
     function  GetReportQueryTemplateForThisObject(AReportingObject: TIDObject): string; override;

   public
     property  Well: TSimpleWell read GetWell ; 
     procedure PrepareReport; override;
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
   end;

implementation

uses SysUtils, CommonReport, Variants, Facade, ClientCommon;

{ TStandardSubdivisionReport }

constructor TStandardSubdivisionReport.Create(AOwner: TComponent);
begin
  inherited;
  FQueryBuilder := TQueryTemplateBuilder.Create;
  FQueryBuilder.ConstantSelectPart := 'select distinct sn.straton_id, sn.vch_straton_index';
  FQueryBuilder.VariableSelectPart := 'sc%n.num_depth, ss%n.vch_short_subdivision_comment';
  FQueryBuilder.ConstantFromPart := 'from tbl_stratigraphy_name_dict sn';
  FQueryBuilder.ConstantJoinPart := 'left join tbl_straton_properties sp on sp.straton_id = sn.straton_id and sp.region_id = (select min(region_id) from tbl_straton_properties spp where spp.straton_id = sp.Straton_id)';
  FQueryBuilder.VariableJoinPart := 'left join tbl_subdivision_component sc%n on sc%n.straton_id = sn.straton_id and (sc%n.Subdivision_ID in (select first 1 skip 0 subdivision_id from tbl_subdivision s0%n where s0%n.well_uin = %s order by s0%n.dtm_signing_date desc)) and sc%n.block_id = %n ' +
                                    'left join tbl_subdivision_comment ss%n on ss%n.comment_id = sc%n.comment_id ' ;

  FQueryBuilder.ConstantWherePart := 'where sn.straton_id in (select straton_id from tbl_subdivision_component sc, tbl_subdivision s  where sc.Subdivision_id = s.Subdivision_ID and s.well_uin in (%a))';
  FQueryBuilder.ConstantOrderByPart := 'order by sp.num_age_of_base asc,  sp.num_age_of_top desc';

  NeedsExcel := true;
  SilentMode := true;
  SaveReport := true;
  AutoNumber := [];
  RemoveEmptyCols := true;
  DrawBorders := true;
  ReportName := 'Разбивки';
  IsHorizontal := False;
end;

procedure TStandardSubdivisionReport.CreateQueryTemplate;
begin

end;

destructor TStandardSubdivisionReport.Destroy;
begin
  FreeAndNil(FQueryBuilder);
  inherited;
end;

function TStandardSubdivisionReport.GetReportFileName: string;
begin
  Result := IntToStr(ReportingObjects.Count);
  if trim(ReportName) <> '' then Result := ReportName + '_' + Result;

  Result := trim(Result);
end;

function TStandardSubdivisionReport.GetReportQueryTemplateForThisObject(
  AReportingObject: TIDObject): string;
var vResult: OleVariant;
    sQuery: string;
    iResult: integer;
begin
  sQuery := 'select distinct tb.block_id, tb.vch_short_block_name ' +
            'from tbl_subdivision s, tbl_subdivision_component sc, tbl_tectonic_block tb ' +
            'where s.well_uin = %s '+
            'and s.subdivision_id = sc.subdivision_id ' +
            'and sc.block_id = tb.block_id ' +
            'and sc.subdivision_id in (select first 1 skip 0 subdivision_id from tbl_subdivision s0 where s0.well_uin = s.Well_UIn order by s0.dtm_signing_date desc) ' +
            'order by tb.Num_order';

  
  iResult := TMainFacade.GetInstance.ExecuteQuery(StringReplace(sQuery, '%s', IntToStr(AReportingObject.ID), [rfReplaceAll]), vResult);
  if iResult >= 0 then
  begin
    if iResult = 0 then
    begin
      vResult := VarArrayCreate([0, 1, 0, 0], varVariant);
      vResult[0,0] := 0;
      vResult[1,0] := '<нет>';
    end;
    FColumns[ReportingObjects.IndexOf(AReportingObject)] := vResult;
    Result := FQueryBuilder.BuildQuery(vREsult)
  end
  else
    raise EReportQueryBuildingError.Create('Не удалось построить запрос для отчёта');
end;

function TStandardSubdivisionReport.GetWell: TSimpleWell;
begin
  Result := CurrentObject as TSimpleWell;
end;

procedure TStandardSubdivisionReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(ParamStr(0))+'\Stratreport.xltx');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
  FXLHiddenWorksheet := FExcel.ActiveWorkbook.Sheets[2];

  FColumns := VarArrayCreate([0, ReportingObjects.Count - 1], varVariant);

end;

procedure TStandardSubdivisionReport.PostProcessQueryBlock(
  AQueryBlock: OleVariant);
var vRange, Cell1, Cell2, vSubRange: OleVariant;
    i, iIndex: integer;
begin
  Cell1 := FXLWorksheet.Cells.Item[2, 2];
  Cell2 := FXLWorksheet.Cells.Item[6, CurrentColumn - 1];
  vRange := FXLWorksheet.Range[Cell1,Cell2];
  //vRange.Select;

  vRange.Replace('#Area#', (CurrentObject as TSimpleWell).Area.Name);
  vRange.Replace('#Well#', (CurrentObject as TSimpleWell).NumberWell);
  vRange.Replace('#Alt#', (CurrentObject as TSimpleWell).Altitude);
  vRange.Replace('#Dep#', (CurrentObject as TSimpleWell).TrueDepth);


end;

procedure TStandardSubdivisionReport.PrepareReport;
var CellL, CellR, Cell1, Cell2, vRange, vNext: OleVariant;
    i, iDim, j: integer;
    iLastColumn: integer;
begin
  inherited;
  iLastColumn := 2;



  for i := 0 to ReportingObjects.Count - 1 do
  begin
    iDim := varArrayHighBound(FColumns[i], 2) + 1;
    iDim := iDim * 2;
    CellL := FXLHiddenWorksheet.Cells.Item[2, 2];
    CellR := FXLHiddenWorksheet.Cells.Item[6, 2 + iDim - 1];

    vRange := FXLHiddenWorksheet.Range[CellL,CellR];

    Cell1 := FXLWorksheet.Cells.Item[2, iLastColumn ];
    Cell2 := FXLWorksheet.Cells.Item[6, iLastColumn + iDim - 1];

    vNext := FXLWorksheet.Range[Cell1,Cell2];
    vNext.Value := vRange.Value;
    for j := 0 to varArrayHighBound(FColumns[i], 2) do
    begin
      vNext.Cells[3, j * 2 + 1] := FColumns[i][1, j];
      vNext.Cells[3, j * 2 + 2] := FColumns[i][1, j];
    end;

    iLastColumn :=  iLastColumn + iDim
  end;
  LastColIndex := iLastColumn;
end;

procedure TStandardSubdivisionReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  inherited;
  FirstRowIndex := 7;
  LastRowIndex := 7;
  FirstColIndex := 1;
  FTotalDepthReached := false;
  Cell1 := FXLWorksheet.Cells.Item[FirstRowIndex, CurrentColumn];
  Cell2 := FXLWorksheet.Cells.Item[(LastRowIndex + AQueryBlock.RecordCount - 1)*2, CurrentColumn + 20 + Ord(CurrentColumn = 1)];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
end;

procedure TStandardSubdivisionReport.ProcessVerticalReportRow(
  AQueryBlock: OleVariant; ARow: integer; IsFirstBlock: boolean);
var j: integer;
    vNextArray: OleVariant;
    s: string;

    procedure MakeDepthMark;
    var sVal1, sVal2: String;
        fVal1: single;
    begin
      if (varIsNull(vNextArray[ARow, j - ord(not IsFirstBlock)])) then
        sVal1 := ''
      else
        sVal1 := varAsType(vNextArray[ARow, j - ord(not IsFirstBlock)],varOleStr);

      if (VarIsNull(vNextArray[ARow - 1, j - ord(not IsFirstBlock)])) then
        sVal2 := ''
      else
        sVal2 := varAsType(vNextArray[ARow - 1, j -  ord(not IsFirstBlock)], varOleStr);

      sVal1 := trim(sVal1);
      sVal2 := trim(sVal2);

      fVal1 := StrToFloatEx(sVal1);
      if fVal1 > -1 then
        if fVal1 >= Well.TrueDepth then FTotalDepthReached := True;

      if FTotalDepthReached and (fVal1 <= -1) then
        vNextArray[ARow, j - ord(not IsFirstBlock)] := 'нв'
      else
      begin
        if sVal1 = '' then vNextArray[ARow, j - ord(not IsFirstBlock)] := 'отс'
        else if (sVal1 = sVal2) then
          vNextArray[ARow - 1, j - ord(not IsFirstBlock)] := 'нр';
        end;
    end;
begin
  vNextArray := NextArray;
  if IsFirstBlock then
  begin
    j := 1;
    while j <= AQueryBlock.Fields.Count - 1  do
    begin

      s := '';
      if (j < AQueryBlock.Fields.Count - 1) and (not varIsNull(AQueryBlock.Fields[j + 1].Value))  then
        s := trim(varAsType(AQueryBlock.Fields[j + 1].Value, varOleStr));

      if (j > 1) and (j < AQueryBlock.Fields.Count - 1) and (not(varIsEmpty(AQueryBlock.Fields[j + 1].Value) or varIsNull(AQueryBlock.Fields[j + 1].Value) or (s = ''))) then
        vNextArray[ARow, j] := AQueryBlock.Fields[j + 1].Value
      else
        vNextArray[ARow, j] := AQueryBlock.Fields[j].Value ;


      if (ARow > 1) and (j > 1) then
      begin
        MakeDepthMark;
      end;

      if j > 1 then
        j := j + 2
      else
        j := j + 1;
    end;

  end
  else
  begin
    j := 2;
    while j <= AQueryBlock.Fields.Count - 1  do
    begin

      if (j < AQueryBlock.Fields.Count - 1) and (not(varIsEmpty(AQueryBlock.Fields[j + 1].Value) or varIsNull(AQueryBlock.Fields[j + 1].Value) or (trim(varAsType(AQueryBlock.Fields[j + 1].Value, varOleStr)) = ''))) then
        vNextArray[ARow, j-1]:= AQueryBlock.Fields[j + 1].Value
      else
        vNextArray[ARow, j-1] := AQueryBlock.Fields[j].Value;

      if ARow > 1 then
      begin
        MakeDepthMark;
      end;


      j := j + 2;
    end;
  end;
  NextArray := vNextArray;
end;

{ TQueryTemplateBuilder }

function TQueryTemplateBuilder.BuildQuery(AIDList: OleVariant): string;
var i: integer;
    lst: TStringList;
begin
  lst := TStringList.Create;
  for i := 0 to VarArrayHighBound(AIDList, 2) do 
    lst.Add(VarAsType(AIDList[0, i], varOleStr));
  Result := BuildQuery(lst); 
end;

function TQueryTemplateBuilder.BuildQuery(AIDList: TStrings): string;
var s, sTmp: string;

begin
  Assert((ConstantFromPart <> '') and ((ConstantSelectPart <> '') or (VariableSelectPart <> '')), 'Не задан раздел select или раздел from');
  Assert((ConstantFromPart = '') or ((pos('from', LowerCase(ConstantFromPart)) > 0) ), 'Раздел from должен начинаться с ключевого слова');
  Assert((ConstantWherePart = '') or ((pos('where', LowerCase(ConstantWherePart)) > 0) ), 'Раздел where должен начинаться с ключевого слова');
  Assert((ConstantOrderbyPart = '') or ((pos('order by', LowerCase(ConstantOrderbyPart)) > 0) ), 'Раздел order by должен начинаться с ключевого слова');



  if (Pos('select', LowerCase(ConstantSelectPart)) = 0) then s := 'Select ' else s := '';

  if ConstantSelectPart <> '' then
    s := s + ConstantSelectPart;

  if VariableSelectPart <> '' then
  begin
    sTmp := BuildVariableSelectPart(AIDList);
    if trim(s) = 'select' then s := s + Copy(sTmp, 2, Length(sTmp)) else s := s + sTmp;
  end;

  s := s + ' ' +  ConstantFromPart + ' ' ;
  if ConstantJoinPart <> '' then
    s := s + ConstantJoinPart + ' ';

  if VariableJoinPart <> '' then
    s := s + BuildVariableJoinPart(AIDList);

  if ConstantWherePart <> '' then s := s + ' ' + ConstantWherePart + ' ';

  if ConstantOrderByPart <> '' then s := s + ' ' +ConstantOrderByPart;

  Result := s;
end;

function TQueryTemplateBuilder.BuildVariableJoinPart(
  AIDList: TStrings): string;
var i: integer;
begin
  for i := 0 to AIDList.Count - 1 do
    Result := Result + ' ' + StringReplace(VariableJoinPart, '%n', AIDList[i], [rfReplaceAll]);
end;

function TQueryTemplateBuilder.BuildVariableSelectPart(
  AIDList: TStrings): string;
var i: integer;
begin
  for i := 0 to AIDList.Count - 1 do
    Result := Result + ',' + StringReplace(VariableSelectPart, '%n', AIDList[i], [rfReplaceAll]);
end;

end.
