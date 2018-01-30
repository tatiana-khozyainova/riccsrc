unit CRReport;

interface

uses SDReport, Well, Classes, SysUtils, Forms,
     CommonReport, Slotting, GeneralizedSection, CoreTransfer;

const xlNone = -4142;
      xlContinuous = 1;
      xlThick = 4;
      xlDiagonalDown = 5;
      xlDiagonalUp = 6;
      xlEdgeLeft = 7;
      xlEdgeRight = 10;
      xlEdgeTop = 8;
      xlEdgeBottom = 9;
      xlThin = 2;
      xlAutomatic =  -4105;
      xlInsideHorizontal = 12;
      xlInsideVertical = 11;
      xlLeft = -4131;
      xlRight = -4152;



type
  TPetroliferousRegionReport = class(TSDSQLCollectionReport)
  protected
    procedure InternalOpenTemplate; override;
    procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
  public
    procedure PrepareReport; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TGeneralizedSectionReport = class(TSDReport)
  private
    FReportHeaderData, FReportData: OleVariant;
    function GetGenSection: TGeneralizedSection;
  public
    property GenSection: TGeneralizedSection read GetGenSection;
    constructor Create(AOwner: TComponent); override;
  end;

  TCoreTransferReport = class(TSDReport)
  private
    FReportData: OleVariant;
    FStartRow, FFinishRow, FLeftCol, FRightCol: integer;
    FResponsibleName: string;
    function GetCoreTransfer: TCoreTransfer;
  protected
    procedure InternalOpenTemplate; override;

    procedure InternalMoveData; override;
    procedure PostFormat; override;
  public
    property ResponsibleName: string read FResponsibleName write FResponsibleName;
    property CoreTransfer: TCoreTransfer read GetCoreTransfer;
    constructor Create(AOwner: TComponent); override;
  end;

  TRackContentBlankReport = class(TSDReport)
  private
    FRackNum: integer;
    FRackRomanNum: string;
    FSecondWorkSheet: OleVariant;
  protected
    procedure InternalOpenTemplate; override;
    procedure InternalMoveData; override;
    procedure PostFormat; override;
    function  GetReportFileName: string; override;
  public
    property    RackNum: integer read FRackNum write FRackNum;
    property    RackRomanNum: string read FRackRomanNum write FRackRomanNum;
    constructor Create(AOwner: TComponent); override;
  end;

  TRackContentReport = class(TRackContentBlankReport)
  private
    FQueryTemplate: string;
  protected
    function  GetReportFileName: string; override;
    property  QueryTemplate: string read FQueryTemplate write FQueryTemplate;
    procedure InternalMoveData; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TWellReport = class(TSDReport)
  private
    FReportHeaderData, FReportData: OleVariant;
    function GetWell: TWell;
  public
    property Well: TWell read GetWell;
    constructor Create(AOwner: TComponent); override;
  end;

  TCoreSlottingHeaderReport = class(TWellReport)
  private
    FShowMetersDrilled: boolean;
    FUseGenSection: Boolean;
  protected
    procedure InternalMoveData; override;
    procedure PostFormat; override;
  public

    property  UseGenSection: Boolean read FUseGenSection write FUseGenSection;
    property  ShowMetersDrilled: boolean read FShowMetersDrilled write FShowMetersDrilled;
    constructor Create(AOwner: TComponent); override;
  end;

  TGeneralizedSectionCoreSlottingHeaderReport  = class(TGeneralizedSectionReport)
  private
    FShowMetersDrilled: boolean;
  protected
    procedure InternalMoveData; override;
    procedure PostFormat; override;
  public
    property  ShowMetersDrilled: boolean read FShowMetersDrilled write FShowMetersDrilled;
    constructor Create(AOwner: TComponent); override;
  end;

  TCoreSampleHeaderReport = class(TWellReport)
  protected
    procedure InternalMoveData; override;
  end;


  TCoreSlottingBlankReport = class(TCoreSlottingHeaderReport)
  protected
    procedure InternalOpenTemplate; override;
    procedure InternalMoveData; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TGeneralizedSectionCoreSlottingBlankReport = class(TGeneralizedSectionCoreSlottingHeaderReport)
  protected
    procedure InternalOpenTemplate; override;
    procedure InternalMoveData; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;


  TCoreSampleBlankReport = class(TCoreSlottingHeaderReport)
  protected
    procedure InternalOpenTemplate; override;
    procedure InternalMoveData; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TCoreSampleResearchBlankReport = class(TCoreSlottingHeaderReport)
  protected
    procedure InternalOpenTemplate; override;
    procedure InternalMoveData; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBaseCoreSlottingReport = class(TCoreSlottingHeaderReport)
  private
    FFooterData: OleVariant;
    FUseCoreRepositoryStraton: boolean;
  protected
    procedure InternalMoveData; override;
  public
    property  UseCoreRepositoryStraton: boolean read FUseCoreRepositoryStraton write FUseCoreRepositoryStraton;
    constructor Create(AOwner: TComponent); override;
  end;

  TBaseGeneralizedSectionCoreSlottingReport = class(TGeneralizedSectionCoreSlottingHeaderReport)
  private
    FFooterData: OleVariant;
    FUseCoreRepositoryStraton: Boolean;
  protected
    procedure InternalMoveData; override;
  public
    property UseCoreRepositoryStraton: Boolean read FUseCoreRepositoryStraton write FUseCoreRepositoryStraton;
    constructor Create(AOwner: TComponent); override;

  end;

  TCoreSlottingReport = class(TBaseCoreSlottingReport)
  protected
    procedure InternalOpenTemplate; override;
    procedure InternalMoveData; override;
    procedure PostFormat; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TGeneralizedSectionCoreSlottingReport = class(TBaseGeneralizedSectionCoreSlottingReport)
  protected
    procedure InternalOpenTemplate; override;
    procedure InternalMoveData; override;
    procedure PostFormat; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TEtiquettesReport = class(TBaseReport)

  private
    FSlottingCount: integer;
    FEtiquettesSheet: OleVariant;
    FTemplateName: string;
    procedure MakeEtiquette(ANum: Integer; Range: OleVariant; Slotting: TSlotting; Mark: string);
    procedure MakeBlankEtiquette(ANum: Integer; Range: OleVariant);
  protected
    procedure InternalOpenTemplate; override;
    procedure InternalMoveData; override;
    procedure PostFormat; override;
  public
    property    TemplateName: string read FTemplateName;
    property    SlottingCount: integer read FSlottingCount write FSlottingCount;
    constructor Create(AOwner: TComponent); override;
  end;

  TBigEtiquettesReport = class(TEtiquettesReport)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TSmallEtiquettesReport = class(TEtiquettesReport)
  public
    constructor Create(AOwner: TComponent); override;
  end;


  TBaseCoreSampleReport = class(TCoreSampleHeaderReport)
  protected
    procedure InternalMoveData; override;
  end;

  TCoreSampleReport = class(TBaseCoreSampleReport)
  private
    FXLWorkBook: OleVariant;
    FXLWorksheet: OleVariant;
  protected
    procedure InternalOpenTemplate; override;
    procedure InternalMoveData; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TCorePetrolRegionStatReport = class(TSDSQLCollectionReport)
  private
    FNGOTotals: boolean;
    FOverallTotals: boolean;
    FAreaTotals: boolean;
    FNGRTotals: boolean;
    procedure SetAreaTotals(const Value: boolean);
    procedure SetNGOTotals(const Value: boolean);
    procedure SetNGRTotals(const Value: boolean);
    procedure SetOverallTotals(const Value: boolean);
  protected
    procedure InternalOpenTemplate; override;
    procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
    procedure ProcessTotalBlock(ATotalBlock: OleVariant); override;
  public
    procedure PrepareReport; override;
    property    AreaTotals: boolean read FAreaTotals write SetAreaTotals;
    property    NGRTotals: boolean read FNGRTotals write SetNGRTotals;
    property    NGOTotals: boolean read FNGOTotals write SetNGOTotals;
    property    OverallTotals: boolean read FOverallTotals write SetOverallTotals;

    constructor Create(AOwner: TComponent); override;
  end;


   TCoreDistrictStatReport = class(TSDSQLCollectionReport)
   private
     FAreaTotals: boolean;
     FOverallTotals: boolean;
     FDistrictTotals: boolean;
     procedure SetAreaTotals(const Value: boolean);
     procedure SetDistrictTotals(const Value: boolean);
     procedure SetOverallTotals(const Value: boolean);
   protected
     procedure InternalOpenTemplate; override;
     procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
     procedure ProcessTotalBlock(ATotalBlock: OleVariant); override;
   public
     procedure PrepareReport; override;
     property    AreaTotals: boolean read FAreaTotals write SetAreaTotals;
     property    DistrictTotals: boolean read FDistrictTotals write SetDistrictTotals;
     property    OverallTotals: boolean read FOverallTotals write SetOverallTotals;

     constructor Create(AOwner: TComponent); override;
   end;


  TCorePlacementStatReport = class(TSDSQLCollectionReport)
  private
    FOverallTotals: boolean;
    FAreaTotals: boolean;
    FPlacementTotals: boolean;
    procedure SetAreaTotals(const Value: boolean);
    procedure SetOverallTotals(const Value: boolean);
    procedure SetPlacementTotals(const Value: boolean);
  protected
    procedure InternalOpenTemplate; override;
    procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
    procedure ProcessTotalBlock(ATotalBlock: OleVariant); override;
  public

    property    AreaTotals: boolean read FAreaTotals write SetAreaTotals;
    property    PlacementTotals: boolean read FPlacementTotals write SetPlacementTotals;
    property    OverallTotals: boolean read FOverallTotals write SetOverallTotals;

    procedure PrepareReport; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TCoreTransferFullReport = class(TSDSQLCollectionReport)
  protected
    procedure InternalOpenTemplate; override;
    procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
    procedure ProcessTotalBlock(ATotalBlock: OleVariant); override;
  public
    procedure PrepareReport; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TCoreTransferFullReportForWells = class(TCoreTransferFullReport)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TCorePlacementReport = class(TSDSQLCollectionReport)
  private
    FXLWorkBook: OleVariant;
    FXLWorksheet: OleVariant;
  protected
    procedure InternalOpenTemplate; override;
    procedure PreProcessQueryBlock(AQueryBlock: OleVariant); override;
    procedure ProcessTotalBlock(ATotalBlock: OleVariant); override;
  public
    procedure PrepareReport; override;
    constructor Create(AOwner: TComponent); override;
  end;





implementation

uses Variants, BaseWellInterval, BaseObjects, SlottingPlacement,
     RockSample, Facade, StrUtils, BaseConsts, DBGate, Area;

{ TCoreSlottingBlankReport }

constructor TCoreSlottingBlankReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  ShowMetersDrilled := false;
end;

procedure TCoreSlottingBlankReport.InternalMoveData;
var cell1, cell2, range: OleVariant;
begin
  inherited;

  Cell1 := FXLWorksheet.Cells.Item[1, 7 + ord(ShowMetersDrilled)];
  Cell2 := FXLWorksheet.Cells.Item[12, 7 + ord(ShowMetersDrilled)];
  Range := FXLWorksheet.Range[Cell1,Cell2];
  Range.Value := FReportHeaderData;
end;


procedure TCoreSlottingBlankReport.InternalOpenTemplate;
begin
  if not ShowMetersDrilled then
    FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\VedomostKern.xlt')
  else
    FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\VedomostKernMD.xlt');

  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;



{ TCoreSlottingHeaderReport }

constructor TCoreSlottingHeaderReport.Create(AOwner: TComponent);
begin
  inherited;
  FShowMetersDrilled := false;
end;

procedure TCoreSlottingHeaderReport.InternalMoveData;
begin
  if Assigned(Well) then
  with Well do
  begin
     FReportHeaderData := varArrayCreate([0, 11, 0, 0], varVariant);

     // наименование скважины
     FReportHeaderData[0, 0] := List(loBrief);
     // пропуск строки
     FReportHeaderData[1, 0] := null;
     // НГО
     if Assigned(WellPosition) then
     begin
       if Assigned(WellPosition.Ngo) then
         FReportHeaderData[2, 0] := WellPosition.NGO.List(loBrief);
       // НГР
       if Assigned(WellPosition.NGR) then
         FReportHeaderData[3, 0] := WellPosition.NGR.List(loBrief);
     end
     else
     begin
       FReportHeaderData[2, 0] := '<не указана>';
       FReportHeaderData[3, 0] := '<не указан>';
     end;
     // ведомственная принадлежность
     if (not Assigned(RealOwner)) and Assigned(SlottingPlacement.Organization) then
       FReportHeaderData[4, 0] := SlottingPlacement.Organization.List(loBrief)
     else if Assigned(RealOwner) then
     begin
       if (RealOwner.ID <> 0) then
         FReportHeaderData[4, 0] := RealOwner.List(loBrief)
       else if  Assigned(SlottingPlacement.Organization) then
         FReportHeaderData[4, 0] := SlottingPlacement.Organization.List(loBrief)
     end;
     // дата начала - окончания бурения
     if DtDrillingStart <> 0 then
       FReportHeaderData[5, 0] := DtDrillingStart;
     if DtDrillingFinish <> 0 then
       FReportHeaderData[6, 0] := DtDrillingFinish;
     // категория скважины

     if Assigned(Category) then
       FReportHeaderData[7, 0] := Category.List;
     // местонахождение государственной части керна
     if Assigned(SlottingPlacement) then
     begin
       if Assigned(SlottingPlacement.StatePartPlacement) then
       begin
         if SlottingPlacement.StatePartPlacement.ID <> CORE_MAIN_GARAGE_ID then
           FReportHeaderData[8, 0] := SlottingPlacement.StatePartPlacement.List(loBrief)
         else
         begin
           if UseGenSection then
             FReportHeaderData[8, 0] := SlottingPlacement.RackListWithGenSection
           else
             FReportHeaderData[8, 0] := SlottingPlacement.RackList;
         end;
       end;
     end;

     // местонахождение части керна владельца
     FReportHeaderData[9, 0] := null;

     // номера ящиков петрофизических образцов
     if Assigned(SlottingPlacement) then
       FReportHeaderData[10, 0] := varAsType(SlottingPlacement.SampleBoxNumbers, varOleStr);
     // количества образцов
     FReportHeaderData[11, 0] := Slottings.SampleCountInCoreLib;
  end;
end;

{ TWellReport }

constructor TWellReport.Create(AOwner: TComponent);
begin
  inherited;
  SilentMode := false;
end;

function TWellReport.GetWell: TWell;
begin
  Result := ReportingObject as TWell;
end;

{ TCoreSlottingReport }

constructor TBaseCoreSlottingReport.Create(AOwner: TComponent);
begin
  inherited;
  UseCoreRepositoryStraton := true;
end;

procedure TBaseCoreSlottingReport.InternalMoveData;
var i, j: integer;
    sComment: string;
begin
  inherited;

  with Well do
  begin
     FReportData := varArrayCreate([0, Slottings.GetSlottingsCount(UseGenSection) - 1, 0, 9 + ord(ShowMetersDrilled)], varVariant);
     j := 0;
     for i := 0 to Slottings.Count - 1 do
     if UseGenSection or (not UseGenSection and not Slottings.Items[i].IsInGenSection) then
     begin
       // номера ящиков петрофизических образцов
       FReportData[j, 0] := Slottings.Items[i].ListBoundaryBoxes;
       // номер долбления
       FReportData[j, 1] := Slottings.Items[i].Number;
       // интервал - начало - окончание
       FReportData[j, 2] := Slottings.Items[i].Top;
       FReportData[j, 3] := Slottings.Items[i].Bottom;
       if ShowMetersDrilled then
         FReportData[j, 3 + ord(ShowMetersDrilled)] := Abs(Slottings.Items[i].Bottom - Slottings.Items[i].Top);

       // выход керна
       FReportData[j, 4  + ord(ShowMetersDrilled)] := Slottings.Items[i].CoreYield;
       // факт. выход керна
       FReportData[j, 5  + ord(ShowMetersDrilled)] := Slottings.Items[i].CoreFinalYield;
       // возраст
       if UseCoreRepositoryStraton then
       begin
         if Assigned(Slottings.Items[i].Straton) then
           FReportData[j, 6  + ord(ShowMetersDrilled)] := Slottings.Items[i].Straton.List(loBrief)
       end
       else
         FReportData[j, 6  + ord(ShowMetersDrilled)] := Slottings.Items[i].SubDivisionStratonName;
       // диаметр
       if (Slottings.Items[i].Diameter <> 0) then
         FReportData[j, 7  + ord(ShowMetersDrilled)] := Slottings.Items[i].Diameter;
       // мех. состояние

       if Slottings.Items[i].CoreFinalYield > 0 then
       begin
         FReportData[j, 8  + ord(ShowMetersDrilled)] := AnsiLowerCase(Slottings.Items[i].CoreMechanicalStates.List(loBrief));

         if trim(varAsType(FReportData[j, 8  + ord(ShowMetersDrilled)], varOleStr)) = '' then
           FReportData[j, 8  + ord(ShowMetersDrilled)] := (TMainFacade.GetInstance as TMainFacade).AllMechanicalStates.ItemsByID[CORE_MECH_STATE_STRINGS].List();
       end
       else FReportData[j, 8  + ord(ShowMetersDrilled)] := '';

       // примечание
       // если находится в сводном разрезе - пишем об этом
       sComment := '';
       if UseGenSection and Slottings.Items[i].IsInGenSection then sComment := Slottings.Items[i].GenSection.List(loBrief);
       if (sComment <> '') and (Slottings.Items[i].Comment <> '') then sComment := sComment + ';' + Slottings.Items[i].Comment
       else sComment := Slottings.Items[i].Comment;

       FReportData[j, 9  + ord(ShowMetersDrilled)] := sComment;
       Inc(j);
    end;
  end;


  FFooterData := varArrayCreate([0, 1, 0, 10], varVariant);
  FFooterData[0, 0] := 'Количество керна поступило/в.к.(м)';
  FFooterData[1, 0] := 'Количество ящиков поступило';
  if UseGenSection then
    FFooterData[0, 4] := Well.SlottingPlacement.CoreYieldWithGenSection
  else
    FFooterData[0, 4] := Well.SlottingPlacement.CoreYield;

  FFooterData[1, 4] := Well.SlottingPlacement.BoxCount;

  FFooterData[0, 6 + Ord(ShowMetersDrilled)] := 'Керна после упорядочения(м)';
  FFooterData[1, 6 + Ord(ShowMetersDrilled)] := 'Ящиков после упорядочения';
  if UseGenSection then
  begin
    FFooterData[0, 9 + Ord(ShowMetersDrilled)] := Well.SlottingPlacement.CoreFinalYieldWithGenSection;
    FFooterData[1, 9 + Ord(ShowMetersDrilled)] := Well.SlottingPlacement.FinalBoxCountWithGenSection;
  end
  else
  begin
    FFooterData[0, 9 + Ord(ShowMetersDrilled)] := Well.SlottingPlacement.CoreFinalYield;
    FFooterData[1, 9 + Ord(ShowMetersDrilled)] := Well.SlottingPlacement.FinalBoxCount;
  end

end;

{ TCoreSlottingReport }

constructor TCoreSlottingReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  SilentMode := false;
end;

procedure TCoreSlottingReport.InternalMoveData;

var Cell11, Cell12, Cell21, Cell22, Range: OleVariant;
    iSlottingsCount: integer;
begin
  inherited;

  Cell11 := FXLWorksheet.Cells.Item[1, 7 + ord(ShowMetersDrilled)];
  Cell21 := FXLWorksheet.Cells.Item[12, 7 + ord(ShowMetersDrilled)];
  Range := FXLWorksheet.Range[Cell11,Cell21];
  Range.Value := FReportHeaderData;
  iSlottingsCount := Well.Slottings.GetSlottingsCount(UseGenSection);

  Cell11 := FXLWorksheet.Cells.Item[16, 1];
  Cell21 := FXLWorksheet.Cells.Item[16 + iSlottingsCount - 1, 10 + Ord(ShowMetersDrilled)];
  Range := FXLWorksheet.Range[Cell11,Cell21];
  Range.Value := FReportData;

  Cell11 := FXLWorksheet.Cells.Item[16 + iSlottingsCount + 1, 1];
  Cell12 := FXLWorksheet.Cells.Item[16 + iSlottingsCount + 2, 1];

  Cell21 := FXLWorksheet.Cells.Item[16 + iSlottingsCount + 1, 10 + Ord(ShowMetersDrilled)];
  Cell22 := FXLWorksheet.Cells.Item[16 + iSlottingsCount + 2, 10 + Ord(ShowMetersDrilled)];

  Cell11.HorizontalAlignment := xlLeft;
  Cell12.HorizontalAlignment := xlLeft;

  Cell21.HorizontalAlignment := xlRight;
  Cell22.HorizontalAlignment := xlRight;
  Cell21.NumberFormat := '0'+DecimalSeparator + '00';
  Cell22.NumberFormat := '0';

  Range := FXLWorksheet.Range[Cell11,Cell22];
  Range.Value := FFooterData;

  Cell12 := FXLWorksheet.Cells.Item[16 + iSlottingsCount + 2, 5];
  Cell12.NumberFormat := '0';

  Cell21 := FXLWorksheet.Cells.Item[16 + iSlottingsCount + 1, 7 + Ord(ShowMetersDrilled)];
  Cell22 := FXLWorksheet.Cells.Item[16 + iSlottingsCount + 2, 7 + Ord(ShowMetersDrilled)];
  Cell21.Font.Size := 8;
  Cell22.Font.Size := 8;
end;

procedure TCoreSlottingReport.InternalOpenTemplate;
begin
  if not ShowMetersDrilled then
    FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\VedomostKern.xlt')
  else
    FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\VedomostKernMD.xlt');

  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;


procedure TCoreSlottingReport.PostFormat;
const xlNone = -4142;
      xlContinuous = 1;
      xlThick = 4;
      xlDiagonalDown = 5;
      xlDiagonalUp = 6;
      xlEdgeLeft = 7;
      xlEdgeRight = 10;
      xlEdgeTop = 8;
      xlEdgeBottom = 9;
      xlThin = 2;
      xlAutomatic =  -4105;
      xlInsideHorizontal = 12;
      xlInsideVertical = 11;

var Cell1, Cell2, Range: OleVariant;
    iSlottingCount: integer;
begin
  inherited;

  // рисуем границы
  Cell1 := FXLWorksheet.Cells.Item[16, 1];
  iSlottingCount := Well.Slottings.GetSlottingsCount(UseGenSection);
  Cell2 := FXLWorksheet.Cells.Item[16 + iSlottingCount - 1, 10 + ord(ShowMetersDrilled)];
  Range := FXLWorksheet.Range[Cell1,Cell2];

  Range.Borders.Item[xlDiagonalDown].LineStyle := xlNone;
  Range.Borders.Item[xlDiagonalUp].LineStyle := xlNone;

  Range.Borders.Item[xlEdgeLeft].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeLeft].Weight := xlThin;
  Range.Borders.Item[xlEdgeLeft].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeTop].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeTop].Weight := xlThin;
  Range.Borders.Item[xlEdgeTop].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeBottom].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeBottom].Weight := xlThin;
  Range.Borders.Item[xlEdgeBottom].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeRight].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeRight].Weight := xlThin;
  Range.Borders.Item[xlEdgeRight].ColorIndex := xlAutomatic;

  if Range.Rows.Count > 1 then
  begin
    Range.Borders.Item[xlInsideHorizontal].LineStyle := xlContinuous;
    Range.Borders.Item[xlInsideHorizontal].Weight := xlThin;
    Range.Borders.Item[xlInsideHorizontal].ColorIndex := xlAutomatic;
  end;

  Range.Borders.Item[xlInsideVertical].LineStyle := xlContinuous;
  Range.Borders.Item[xlInsideVertical].Weight := xlThin;
  Range.Borders.Item[xlInsideVertical].ColorIndex := xlAutomatic;

  // задаем область печати
  if not ShowMetersDrilled then
    FExcel.ActiveSheet.PageSetup.PrintArea := '$A$1:$J$' + IntToStr(16 + iSlottingCount + 2)
  else
    FExcel.ActiveSheet.PageSetup.PrintArea := '$A$1:$K$' + IntToStr(16 + iSlottingCount + 2);

  // форматируем индекс для стратона
  Cell1 := FXLWorksheet.Cells.Item[16, 7 + ord(ShowMetersDrilled)];
  Cell2 := FXLWorksheet.Cells.Item[16 + iSlottingCount - 1, 7 + ord(ShowMetersDrilled)];
  Range := FXLWorksheet.Range[Cell1,Cell2];

  FExcel.Run('PostFormat');
  FExcel.Run('SubscriptRange', Range);
end;

{ TCoreSampleHeaderReport }

procedure TCoreSampleHeaderReport.InternalMoveData;
begin
  with Well do
  begin
    FReportHeaderData := varArrayCreate([0, 8, 0, 0], varVariant);

    // наименование скважины
    FReportHeaderData[0, 0] := List(loBrief);
    // пропуск строки
    FReportHeaderData[1, 0] := null;
    // НГО
    FReportHeaderData[2, 0] := WellPosition.NGO.List(loBrief);
    // НГР
    FReportHeaderData[3, 0] := WellPosition.NGR.List(loBrief);
    // ведомственная принадлежность
    if (not Assigned(RealOwner)) and Assigned(SlottingPlacement.Organization) then
      FReportHeaderData[4, 0] := SlottingPlacement.Organization.List(loBrief)
    else if Assigned(RealOwner) then
    begin
      if (RealOwner.ID <> 0) then
        FReportHeaderData[4, 0] := RealOwner.List(loBrief)
      else if  Assigned(SlottingPlacement.Organization) then
        FReportHeaderData[4, 0] := SlottingPlacement.Organization.List(loBrief)
    end;

    // дата начала - окончания бурения
    if (DtDrillingStart <> 0) then
      FReportHeaderData[5, 0] := DtDrillingStart;
    if (DtDrillingFinish <> 0) then
      FReportHeaderData[6, 0] := DtDrillingFinish;
    // категория скважины
    FReportHeaderData[7, 0] := Category.List;
    // номера ящиков петрофизических образцов
    //FReportData[10, 0] := (Owner as TWell).SlottingPlacement.
  end;
end;

procedure TCoreSlottingHeaderReport.PostFormat;
begin
  inherited;
  FExcel.ActiveSheet.PageSetup.CenterFooter := 'стр.&[Страница]';
  if Assigned(Well) then
    FExcel.ActiveSheet.PageSetup.RightFooter := Well.List(loBrief);
end;

{ TCoreSampleBlankReport }

constructor TCoreSampleBlankReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
end;

procedure TCoreSampleBlankReport.InternalMoveData;
var Cell1, Cell2, Range: OleVariant;
begin
  inherited;

  Cell1 := FXLWorksheet.Cells.Item[4, 6];
  Cell2 := FXLWorksheet.Cells.Item[12, 6];
  Range := FXLWorksheet.Range[Cell1,Cell2];
  Range.Value := FReportHeaderData;
end;

procedure TCoreSampleBlankReport.InternalOpenTemplate;
begin
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\VedomostSample.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;


{ TBaseCoreSampleReport }

procedure TBaseCoreSampleReport.InternalMoveData;
var i: integer;
    rstp: TRockSampleSizeTypePresence;
begin
  inherited;

  with Well do
  begin
     FReportData := varArrayCreate([0, Slottings.Count - 1, 0, 11], varVariant);

     for i := 0 to Slottings.Count - 1 do
     begin
       // номер долбления
       FReportData[i, 0] := Slottings.Items[i].Number;
       // интервал - начало - окончание
       FReportData[i, 1] := Format('%.2f', [Slottings.Items[i].Top]);
       FReportData[i, 2] := Format('%.2f', [Slottings.Items[i].Bottom]);
       // факт. выход керна
       FReportData[i, 3] := Format('%.2f', [Slottings.Items[i].CoreFinalYield]);
       // количество петрофизических образцов
       FReportData[i, 4] := Slottings.Items[i].RockSampleSizeTypePresences.GetSampleCount;
       // возраст
       if Assigned(Slottings.Items[i].Straton) then
         FReportData[i, 5] := Slottings.Items[i].Straton.List(loBrief)
       else
         FReportData[i, 5] := Slottings.Items[i].SubDivisionStratonName;       
       // 30
       rstp := Slottings.Items[i].RockSampleSizeTypePresences.GetPresenseBySizeType(TRockSampleSizeType((TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.ItemsByID[1]));
       if Assigned(rstp) then FReportData[i, 6] := rstp.Count
       else FReportData[i, 6] := 0;
       // 50
       rstp := Slottings.Items[i].RockSampleSizeTypePresences.GetPresenseBySizeType(TRockSampleSizeType((TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.ItemsByID[2]));
       if Assigned(rstp) then FReportData[i, 7] := rstp.Count
       else FReportData[i, 7] := 0;
       // 25x25
       rstp := Slottings.Items[i].RockSampleSizeTypePresences.GetPresenseBySizeType(TRockSampleSizeType((TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.ItemsByID[3]));
       if Assigned(rstp) then FReportData[i, 8] := rstp.Count
       else FReportData[i, 8] := 0;
       // 50x50
       rstp := Slottings.Items[i].RockSampleSizeTypePresences.GetPresenseBySizeType(TRockSampleSizeType((TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.ItemsByID[4]));
       if Assigned(rstp) then FReportData[i, 9] := rstp.Count
       else FReportData[i, 9] := 0;
       // вручную
       rstp := Slottings.Items[i].RockSampleSizeTypePresences.GetPresenseBySizeType(TRockSampleSizeType((TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.ItemsByID[5]));
       if Assigned(rstp) then FReportData[i, 10] := rstp.Count
       else FReportData[i, 10] := 0;       

       // примечание
       FReportData[i, 11] := Slottings.Items[i].Comment;
    end;
  end;
end;

{ TCoreSampleReport }

constructor TCoreSampleReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  SilentMode := false;
end;

procedure TCoreSampleReport.InternalMoveData;
var Cell1, Cell2, Range: OleVariant;
begin
  inherited;

  Cell1 := FXLWorksheet.Cells.Item[4, 6];
  Cell2 := FXLWorksheet.Cells.Item[12, 6];
  Range := FXLWorksheet.Range[Cell1,Cell2];
  Range.Value := FReportHeaderData;

  
  Cell1 := FXLWorksheet.Cells.Item[16, 1];
  Cell2 := FXLWorksheet.Cells.Item[16 + Well.Slottings.Count - 1, 11];
  Range := FXLWorksheet.Range[Cell1,Cell2];
  Range.Value := FReportData;
end;

procedure TCoreSampleReport.InternalOpenTemplate;
begin
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\VedomostSample.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

{ TCoreSampleResearchBlankReport }

constructor TCoreSampleResearchBlankReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
end;

procedure TCoreSampleResearchBlankReport.InternalMoveData;
var Cell1, Cell2, Range: OleVariant;
begin
  inherited;

  Cell1 := FXLWorksheet.Cells.Item[3, 6];
  Cell2 := FXLWorksheet.Cells.Item[12, 6];
  Range := FXLWorksheet.Range[Cell1,Cell2];
  Range.Value := FReportHeaderData;
end;

procedure TCoreSampleResearchBlankReport.InternalOpenTemplate;
begin
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\BlankSampleResearch.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

{ TCorePetrolRegionStatReport }

constructor TCorePetrolRegionStatReport.Create(AOwner: TComponent);
begin
  inherited;
  ReportQueryTemplate :=  'select '''''''', ks.well_uin, ks.vch_new_main_region_full_name, ks.vch_new_region_full_name, ' +
                          'ks.vch_area_name, ks.vch_well_num, ks.vch_category_name, ' +
                          'extract(year from ks.dtm_drilling_start), extract(year from ks.dtm_drilling_finish), ' +
                          'ks.num_core_yield, ks.num_box_count,  ' +
                          'ks.num_core_final_yield, ks.num_box_final_count, ks.vch_real_placement, ks.vch_Rack_List, ks.VCH_AGE_CODE, ' + '''' + '''' + ', ' +
                          'ks.Area_ID, ks.New_Petrol_Region_ID, ks.New_Main_Region_ID ' +
                          'from vw_kern_statistics ks ' +
                          'where not(ks.num_Core_Yield is null) and not(ks.num_Core_Final_Yield is null) and (ks.num_Core_Final_Yield  > 0) and (ks.new_petrol_region_id in (%s)) ' +
                          'order by 3, 4, 5, 6';


  AreaTotals := true;
  NGRTotals := true;
  NGOTotals := true;
  OverallTotals := true;

  NeedsExcel := true;
  SilentMode := false;
  SaveReport := false;
  AutoNumber := [anRows];
  SubtotalsColorFill := true;
  RemoveEmptyCols := false;
  DrawBorders := true;
  ReportName := 'Журнал_распределения_керна_по_НГР'




end;

procedure TCorePetrolRegionStatReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\NGR.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;


procedure TCorePetrolRegionStatReport.PrepareReport;
begin
  inherited;
  FirstColIndex := 1;
  FirstRowIndex := 6;
  AutonumberColumn := 1;
  LastRowIndex := 6;
  LastColIndex := 20;
end;

procedure TCorePetrolRegionStatReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  inherited;
  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[(LastRowIndex + AQueryBlock.RecordCount - 1)*2, FirstColIndex + AQueryBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
end;




procedure TCorePetrolRegionStatReport.ProcessTotalBlock(
  ATotalBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[LastRowIndex + ATotalBlock.RecordCount, FirstColIndex + ATotalBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
  inherited;
end;

                                                                                                                      


procedure TCorePetrolRegionStatReport.SetAreaTotals(const Value: boolean);
begin
  if FAreaTotals <> Value then
  begin
    FAreaTotals := Value;
    if FAreaTotals then
      SubTotals.AddSubTotal('Area_ID', 'New_petrol_region_id',
                            'select max(New_petrol_region_id), max(Area_ID), max(ks.vch_new_main_region_full_name), max(ks.vch_new_region_full_name), max(vch_area_name), null, null, null, null, ' +
                            'sum(ks.num_core_yield), sum(ks.num_box_count), sum(ks.num_core_final_yield), sum(ks.num_box_final_count) ' +
                            'from vw_kern_statistics ks ' +
                            'where ks.Area_ID in (%s) and (ks.new_petrol_region_id in (%s)) ' +
                            'order by 3, 4, 5')
    else
      SubTotals.DeleteSubTotal('Area_ID', 'New_petrol_region_id');

  end;
end;

procedure TCorePetrolRegionStatReport.SetNGOTotals(const Value: boolean);
begin
  if FNGOTotals <> Value then
  begin
    FNGOTotals := Value;
    if FNGOTotals then
      SubTotals.AddSubTotal('New_Main_Region_ID',
                            'select '''''''', max(New_Main_Region_ID), max(ks.vch_new_main_region_full_name), null, null, null, null, null, null, ' +
                            'sum(ks.num_core_yield), sum(ks.num_box_count), sum(ks.num_core_final_yield), sum(ks.num_box_final_count) ' +
                            'from vw_kern_statistics ks ' +
                            'where ks.New_Main_Region_ID in (%s)' +
                            'order by 3', true)
    else
      SubTotals.DeleteSubtotal('New_Main_Region_ID', '');
  end;
end;

procedure TCorePetrolRegionStatReport.SetNGRTotals(const Value: boolean);
begin
  if FNGRTotals <> Value then
  begin
    FNGRTotals := Value;

    if FNGRTotals then
      SubTotals.AddSubTotal('New_Petrol_Region_ID',
                            'select '''''''', max(New_Petrol_Region_ID), max(ks.vch_new_main_region_full_name), max(ks.vch_new_region_full_name), null, null, null, null, null, ' +
                            'sum(ks.num_core_yield), sum(ks.num_box_count), sum(ks.num_core_final_yield), sum(ks.num_box_final_count) ' +
                            'from vw_kern_statistics ks ' +
                            'where ks.New_Petrol_Region_ID in (%s) ' +
                            'order by 3, 4')
    else
      SubTotals.DeleteSubtotal('New_Petrol_Region_ID', '');
  end;
end;

procedure TCorePetrolRegionStatReport.SetOverallTotals(
  const Value: boolean);
begin
  if FOverallTotals <> Value then
  begin
    FOverallTotals := Value;
    if FOverallTotals then
      GeneralTotalQueryTemplate := 'select '''''''','''''''',' + '''' + 'Всего по выборке' + '''' + ', null, null, null, null, null, null, sum(ks.num_core_yield), sum(ks.num_box_count), ' +
                                   'sum(ks.num_core_final_yield), sum(ks.num_box_final_count) from vw_kern_statistics ks ' +
                                   'where ks.new_petrol_region_id in (%s)'
    else
      GeneralTotalQueryTemplate := '';

  end;
end;

{ TCorePlacementStatReport }

constructor TCorePlacementStatReport.Create(AOwner: TComponent);
begin
  inherited;
  ReportQueryTemplate := 'select null,ks.Well_UIN, ks.vch_real_placement, ks.vch_Area_Name, ks.vch_Well_Num, ks.vch_category_name, extract(year from ks.dtm_drilling_start), extract(year from ks.dtm_drilling_finish), ' +
                         'ks.num_core_yield, ks.num_box_count, ks.num_core_final_yield, ks.num_box_final_count, ' +
                         'ks.vch_age_code, ks.vch_Rack_List, null, ks.Real_Placement_ID, ks.Area_ID ' +
                         'from vw_kern_statistics ks where not(num_Core_Yield is null) and not(num_Core_Final_Yield is null) and Real_Placement_ID in (%s) ' +
                         'order by ks.vch_real_placement, ks.vch_Area_Name, ks.vch_Well_Num, ks.vch_Rack_List';


  AreaTotals := true;
  PlacementTotals := true;
  OverallTotals := true;

  NeedsExcel := true;
  SilentMode := false;
  SaveReport := false;
  AutoNumber := [anRows];
  SubtotalsColorFill := true;
  RemoveEmptyCols := false;
  DrawBorders := true;
  ReportName := 'Журнал_распределения_керна_по_местоположению'
end;

procedure TCorePlacementStatReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\Placements.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TCorePlacementStatReport.PrepareReport;
begin
  inherited;
  FirstColIndex := 1;
  FirstRowIndex := 6;
  AutonumberColumn := 1;
  LastRowIndex := 6;
  LastColIndex := 17;
end;

procedure TCorePlacementStatReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  inherited;


  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[(LastRowIndex + AQueryBlock.RecordCount - 1)*2, FirstColIndex + AQueryBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
end;


procedure TCorePlacementStatReport.ProcessTotalBlock(
  ATotalBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[LastRowIndex + ATotalBlock.RecordCount, FirstColIndex + ATotalBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
  inherited;
end;

procedure TCorePlacementStatReport.SetAreaTotals(const Value: boolean);
begin
  if FAreaTotals <> Value then
  begin
    FAreaTotals := Value;
    if FAreaTotals then
       SubTotals.AddSubTotal('Area_ID',
                             'Real_Placement_ID',
                             'select null,null, max(ks.vch_real_placement), max(vch_area_name), null, null, null, null, ' +
                             'sum(ks.num_core_yield), sum(ks.num_box_count), ' +
                             'sum(ks.num_core_final_yield), sum(ks.num_box_final_count) from vw_kern_statistics ks ' +
                             'where (ks.Area_ID in (%s)) and (ks.Real_Placement_ID in (%s)) order by 3, 4')
    else
      SubTotals.DeleteSubTotal('Real_Placement_ID', 'Area_ID');

  end;
end;

procedure TCorePlacementStatReport.SetOverallTotals(const Value: boolean);
begin
  if FOverallTotals <> Value then
  begin
    FOverallTotals := Value;
    if FOverallTotals then
      GeneralTotalQueryTemplate := 'select null, null, ' + '''' + 'Всего по выборке' + '''' + ', null, null, null, null, null, sum(ks.num_core_yield), sum(ks.num_box_count), ' +
                                   'sum(ks.num_core_final_yield), sum(ks.num_box_final_count) from vw_kern_statistics ks ' +
                                   'where ks.Part_Placement_ID in (%s)'
    else
      GeneralTotalQueryTemplate := '';

  end;
end;

procedure TCorePlacementStatReport.SetPlacementTotals(
  const Value: boolean);
begin
  if FPlacementTotals <> Value then
  begin
    FPlacementTotals := Value;
    if FPlacementTotals then
      SubTotals.AddSubTotal('Real_Placement_ID',
                            'select null,null, max(ks.vch_real_placement), null, null, null, null, null, ' +
                            'sum(ks.num_core_yield), sum(ks.num_box_count), ' +
                            'sum(ks.num_core_final_yield), sum(ks.num_box_final_count) from vw_kern_statistics ks ' +
                            'where ks.Real_Placement_ID in (%s) order by 3')
    else
      SubTotals.DeleteSubTotal('Real_Placement_ID', '');

  end;
end;

{ TCorePlacementReport }

constructor TCorePlacementReport.Create(AOwner: TComponent);
begin
  inherited;
  ReportQueryTemplate := 'select max(vch_part_placement), count(well_uin), sum(num_core_final_yield), sum(num_box_final_count) ' +
                         'from vw_kern_statistics ' +
                         'where num_core_yield <> 0 and num_core_final_yield <> 0 ' +
                         'and ((main_placement_id in (%s)) or (part_placement_id in (%s))) ' +
                         'group by part_placement_id ' +
                         'order by 1';

  GeneralTotalQueryTemplate := 'select ' + '''' + 'Всего ' + '''' + ', count(well_uin), sum(num_core_final_yield), sum(num_box_final_count) ' +
                               'from vw_kern_statistics ' +
                               'where num_core_yield <> 0 and num_core_final_yield <> 0 ' +
                               'and ((main_placement_id in (%s)) or (part_placement_id in (%s))) ';

  NeedsExcel := true;
end;

procedure TCorePlacementReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\StatPlacements.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;


procedure TCorePlacementReport.PrepareReport;
begin
  inherited;
  FirstColIndex := 1;
  LastRowIndex := 5;
end;

procedure TCorePlacementReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  inherited;
  FirstColIndex := 1;
  LastRowIndex := 6;

  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[(LastRowIndex + AQueryBlock.RecordCount - 1)*2, FirstColIndex + AQueryBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
end;


procedure TCorePlacementReport.ProcessTotalBlock(ATotalBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[LastRowIndex + ATotalBlock.RecordCount, FirstColIndex + ATotalBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
  inherited;
end;


{ TEtiquettesReport }

constructor TEtiquettesReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  SilentMode := false;
  SaveReport := true;
  AutoNumber := [];
  RemoveEmptyCols := false;
  DrawBorders := false;
  ReportName := 'Этикетки';
  SlottingCount := 12;
  FirstRowIndex := 1;
  LastRowIndex := 49;
  FirstColIndex := 1;
  LastColIndex := 24;
end;

procedure TEtiquettesReport.InternalMoveData;
var i, iSlotting: integer;
    Cell1, Cell2, Range: OleVariant;
    s: TSlotting;
begin
  inherited;
  iSlotting := 1;
  Cell1 := FXLWorksheet.Cells.Item[FirstRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[LastRowIndex, LastColIndex];
  Range := FXLWorksheet.Range[Cell1,Cell2];
  FEtiquettesSheet := FXLWorksheet;

  // в цикле
  for i := 0 to ReportingObjects.Count - 1 do
  begin
    // скопировать лист
    if i mod (SlottingCount div 2) = 0 then
    begin
      FEtiquettesSheet.Copy(FXLWorksheet);
      FXLWorksheet := FExcel.ActiveWorkbook.Sheets.Item[1];

      Cell1 := FXLWorksheet.Cells.Item[FirstRowIndex, FirstColIndex];
      Cell2 := FXLWorksheet.Cells.Item[LastRowIndex, LastColIndex];
      Range := FXLWorksheet.Range[Cell1,Cell2];
      iSlotting := 1;
    end;

    // раскидать 20 долблений
    s := ReportingObjects.Items[i] as TSlotting;
    MakeEtiquette(iSlotting, Range, s, 'начало');
    inc(iSlotting);
    MakeEtiquette(iSlotting, Range, s, 'конец');
    inc(iSlotting);
  end;


  // удалить лишние если их меньше SlottingCount
  if iSlotting < SlottingCount then
  begin
    for i := iSlotting to SlottingCount do
      MakeBlankEtiquette(i, Range);
  end;
  if (FExcel.ActiveWorkbook.Sheets.Count > 0) then FEtiquettesSheet.Visible := false;
end;

procedure TEtiquettesReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\' + TemplateName);
  FEtiquettesSheet := FExcel.ActiveWorkbook.ActiveSheet;
  FXLWorksheet := FEtiquettesSheet;
  FExcel.Visible := false;
end;

procedure TEtiquettesReport.MakeEtiquette(ANum: Integer; Range: OleVariant;
  Slotting: TSlotting; Mark: string);
begin
  if not (Slotting is TGeneralizedSectionSlotting) then
    Range.Replace('#WELL' + IntToStr(ANum) + '#', Slotting.Collection.Owner.List())
  else
    Range.Replace('#WELL' + IntToStr(ANum) + '#', (Slotting as TGeneralizedSectionSlotting).Well.List());

  Range.Replace('#SLOT' + IntToStr(ANum) + '#', Slotting.Number + ' ' + Mark);
  Range.Replace('#TOP' + IntToStr(ANum) + '#', Format('%.2f', [Slotting.Top]));
  Range.Replace('#BOT' + IntToStr(ANum) + '#', Format('%.2f', [Slotting.Bottom])+ ' м');
  Range.Replace('#STEP' + IntToStr(ANum) + '#', Format('%.2f', [Slotting.Bottom - Slotting.Top]) + ' м');
  Range.Replace('#YIELD' + IntToStr(ANum) + '#', Format('%.2f', [Slotting.CoreYield]) + ' м');
end;

procedure TEtiquettesReport.MakeBlankEtiquette(ANum: Integer;
  Range: OleVariant);
begin
  Range.Replace('#WELL' + IntToStr(ANum) + '#', '');
  Range.Replace('Долб. #SLOT' + IntToStr(ANum) + '#', '');
  Range.Replace('#TOP' + IntToStr(ANum) + '#' + ' - ' + '#BOT' + IntToStr(ANum) + '#', '');
  Range.Replace('Пр. - #STEP' + IntToStr(ANum) + '#', '');
  Range.Replace('В.к. - #YIELD' + IntToStr(ANum) + '#', '');
end;

procedure TEtiquettesReport.PostFormat;
begin
  inherited;

end;



{ TBigEtiquiettesReport }

constructor TBigEtiquettesReport.Create(AOwner: TComponent);
begin
  inherited;
  FTemplateName := 'Etiquettes_big.xlt';
  SlottingCount := 12;
end;

{ TSmallEtiquiettesReport }

constructor TSmallEtiquettesReport.Create(AOwner: TComponent);
begin
  inherited;
  FTemplateName := 'Etiquettes_small.xlt';
  SlottingCount := 20;
end;

{ TGeneralizedSectionReport }

constructor TGeneralizedSectionReport.Create(AOwner: TComponent);
begin
  inherited;
  SilentMode := false;
end;

function TGeneralizedSectionReport.GetGenSection: TGeneralizedSection;
begin
  Result := ReportingObject as TGeneralizedSection;
end;

{ TGeneralizedSectionCoreSlottingHeaderReport }

constructor TGeneralizedSectionCoreSlottingHeaderReport.Create(
  AOwner: TComponent);
begin
  inherited;
  FShowMetersDrilled := false;
end;

procedure TGeneralizedSectionCoreSlottingHeaderReport.InternalMoveData;
begin
  inherited;
  if Assigned(GenSection) then
  with GenSection do
  begin
     FReportHeaderData := varArrayCreate([0, 5, 0, 0], varVariant);

     // наименование сводного разреза
     FReportHeaderData[0, 0] := List(loBrief);
     // пропуск строки
     FReportHeaderData[1, 0] := null;
     // наименования скважин
     FReportHeaderData[2, 0] := GetWellNames;


     // номера ящиков петрофизических образцов
     FReportHeaderData[3, 0] := varAsType(SampleBoxNumbers, varOleStr);
     // количества образцов
     FReportHeaderData[4, 0] := 0;

     // количества образцов
     FReportHeaderData[5, 0] := SlottingPlacement.RackList;

  end;
end;

procedure TGeneralizedSectionCoreSlottingHeaderReport.PostFormat;
begin
  inherited;
  FExcel.ActiveSheet.PageSetup.CenterFooter := 'стр.&[Страница]';
  if Assigned(GenSection) then
    FExcel.ActiveSheet.PageSetup.RightFooter := GenSection.List(loBrief);
end;

{ TGeneralizedSectionCoreSlottingBlankReport }

constructor TGeneralizedSectionCoreSlottingBlankReport.Create(
  AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  ShowMetersDrilled := false;
end;

procedure TGeneralizedSectionCoreSlottingBlankReport.InternalMoveData;
var cell1, cell2, range: OleVariant;
begin
  inherited;

  Cell1 := FXLWorksheet.Cells.Item[1, 8 + ord(ShowMetersDrilled)];
  Cell2 := FXLWorksheet.Cells.Item[5, 8 + ord(ShowMetersDrilled)];
  Range := FXLWorksheet.Range[Cell1,Cell2];
  Range.Value := FReportHeaderData;
end;

procedure TGeneralizedSectionCoreSlottingBlankReport.InternalOpenTemplate;
begin
  inherited;
  if not ShowMetersDrilled then
    FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\VedomostKernGenSection.xlt')
  else
    FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\VedomostKernGenSectionMD.xlt');
  
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

{ TBaseGeneralizedSectionCoreSlottingBlankReport }

constructor TBaseGeneralizedSectionCoreSlottingReport.Create(
  AOwner: TComponent);
begin
  inherited;
  UseCoreRepositoryStraton := true;
end;

procedure TBaseGeneralizedSectionCoreSlottingReport.InternalMoveData;
var i, j: integer;
begin
  inherited;

  with GenSection do
  begin
     FReportData := varArrayCreate([0, Slottings.Count - 1, 0, 10 + ord(ShowMetersDrilled)], varVariant);
     j := 0;
     for i := 0 to Slottings.Count - 1 do
     begin
       // номера ящиков петрофизических образцов
       FReportData[j, 0] := Slottings.Items[i].ListBoundaryBoxes;
       // скважина
       FReportData[j, 1] := Slottings.Items[i].Well.List(loBrief);

       // номер долбления
       FReportData[j, 2] := Slottings.Items[i].Number;
       // интервал - начало - окончание
       FReportData[j, 3] := Slottings.Items[i].Top;
       FReportData[j, 4] := Slottings.Items[i].Bottom;
       if ShowMetersDrilled then
         FReportData[j, 4 + ord(ShowMetersDrilled)] := Abs(Slottings.Items[i].Bottom - Slottings.Items[i].Top);

       // выход керна
       FReportData[j, 5  + ord(ShowMetersDrilled)] := Slottings.Items[i].CoreYield;
       // факт. выход керна
       FReportData[j, 6  + ord(ShowMetersDrilled)] := Slottings.Items[i].CoreFinalYield;
       // возраст
       if UseCoreRepositoryStraton then
       begin
         if Assigned(Slottings.Items[i].Straton) then
           FReportData[j, 7  + ord(ShowMetersDrilled)] := Slottings.Items[i].Straton.List(loBrief)
       end
       else
         FReportData[j, 7  + ord(ShowMetersDrilled)] := Slottings.Items[i].SubDivisionStratonName;
       // диаметр
       if (Slottings.Items[i].Diameter <> 0) then
         FReportData[j, 8  + ord(ShowMetersDrilled)] := Slottings.Items[i].Diameter;
       // мех. состояние
       FReportData[j, 9 + ord(ShowMetersDrilled)] := AnsiLowerCase(Slottings.Items[i].CoreMechanicalStates.List(loBrief));
       // примечание
       FReportData[j, 10  + ord(ShowMetersDrilled)] := Slottings.Items[i].Comment;
       Inc(j);
    end;
  end;


  FFooterData := varArrayCreate([0, 1, 0, 11], varVariant);
  FFooterData[0, 0] := 'Количество керна поступило/в.к.(м)';
  FFooterData[1, 0] := 'Количество ящиков поступило';
  FFooterData[0, 4] := GenSection.SlottingPlacement.CoreYield;
  FFooterData[1, 4] := GenSection.SlottingPlacement.FinalBoxCount;

  FFooterData[0, 7 + Ord(ShowMetersDrilled)] := 'Керна после упорядочения(м)';
  FFooterData[1, 7 + Ord(ShowMetersDrilled)] := 'Ящиков после упорядочения';
  FFooterData[0, 8 + Ord(ShowMetersDrilled)] := GenSection.SlottingPlacement.CoreFinalYield;
  FFooterData[1, 8 + Ord(ShowMetersDrilled)] := GenSection.SlottingPlacement.FinalBoxCount;
end;

{ TCoreGeneralizedSectionSlottingReport }

constructor TGeneralizedSectionCoreSlottingReport.Create(
  AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  SilentMode := false;
end;

procedure TGeneralizedSectionCoreSlottingReport.InternalMoveData;
const xlLeft = -4131;
      xlRight = -4152;

var Cell11, Cell12, Cell21, Cell22, Range: OleVariant;
    iSlottingsCount: integer;
begin
  inherited;
  Cell11 := FXLWorksheet.Cells.Item[1, 8 + ord(ShowMetersDrilled)];
  Cell21 := FXLWorksheet.Cells.Item[6, 8 + ord(ShowMetersDrilled)];
  Range := FXLWorksheet.Range[Cell11,Cell21];
  Range.Value := FReportHeaderData;
  iSlottingsCount := GenSection.Slottings.GetSlottingsCount(true);

  Cell11 := FXLWorksheet.Cells.Item[10, 1];
  Cell21 := FXLWorksheet.Cells.Item[10 + iSlottingsCount - 1, 11 + Ord(ShowMetersDrilled)];
  Range := FXLWorksheet.Range[Cell11,Cell21];
  Range.Value := FReportData;

  Cell11 := FXLWorksheet.Cells.Item[10 + iSlottingsCount + 1, 1];
  Cell12 := FXLWorksheet.Cells.Item[10 + iSlottingsCount + 2, 1];

  Cell21 := FXLWorksheet.Cells.Item[10 + iSlottingsCount + 1, 11 + Ord(ShowMetersDrilled)];
  Cell22 := FXLWorksheet.Cells.Item[10 + iSlottingsCount + 2, 11 + Ord(ShowMetersDrilled)];

  Cell11.HorizontalAlignment := xlLeft;
  Cell12.HorizontalAlignment := xlLeft;

  Cell21.HorizontalAlignment := xlRight;
  Cell22.HorizontalAlignment := xlRight;
  Cell21.NumberFormat := '0'+DecimalSeparator + '00';
  Cell22.NumberFormat := '0';

  Range := FXLWorksheet.Range[Cell11,Cell22];
  Range.Value := FFooterData;

  Cell12 := FXLWorksheet.Cells.Item[10 + iSlottingsCount + 2, 5];
  Cell12.NumberFormat := '0';

  Cell21 := FXLWorksheet.Cells.Item[10 + iSlottingsCount + 1, 8 + Ord(ShowMetersDrilled)];
  Cell22 := FXLWorksheet.Cells.Item[10 + iSlottingsCount + 2, 8 + Ord(ShowMetersDrilled)];
  Cell21.Font.Size := 8;
  Cell22.Font.Size := 8;
  Cell21.HorizontalAlignment := xlRight;
  Cell22.HorizontalAlignment := xlRight;

  Cell21 := FXLWorksheet.Cells.Item[10 + iSlottingsCount + 1, 9 + Ord(ShowMetersDrilled)];
  Cell21.NumberFormat := '0'+DecimalSeparator + '00';
end;

procedure TGeneralizedSectionCoreSlottingReport.InternalOpenTemplate;
begin
  if not ShowMetersDrilled then
    FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\VedomostKernGenSection.xlt')
  else
    FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\VedomostKernGenSectionMD.xlt');

  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TGeneralizedSectionCoreSlottingReport.PostFormat;
const xlNone = -4142;
      xlContinuous = 1;
      xlThick = 4;
      xlDiagonalDown = 5;
      xlDiagonalUp = 6;
      xlEdgeLeft = 7;
      xlEdgeRight = 10;
      xlEdgeTop = 8;
      xlEdgeBottom = 9;
      xlThin = 2;
      xlAutomatic =  -4105;
      xlInsideHorizontal = 12;
      xlInsideVertical = 11;

var Cell1, Cell2, Range: OleVariant;
begin
  inherited;

  // рисуем границы
  Cell1 := FXLWorksheet.Cells.Item[10, 1];
  Cell2 := FXLWorksheet.Cells.Item[10 + GenSection.Slottings.GetSlottingsCount(true) - 1, 11 + ord(ShowMetersDrilled)];
  Range := FXLWorksheet.Range[Cell1,Cell2];

  Range.Borders.Item[xlDiagonalDown].LineStyle := xlNone;
  Range.Borders.Item[xlDiagonalUp].LineStyle := xlNone;

  Range.Borders.Item[xlEdgeLeft].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeLeft].Weight := xlThin;
  Range.Borders.Item[xlEdgeLeft].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeTop].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeTop].Weight := xlThin;
  Range.Borders.Item[xlEdgeTop].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeBottom].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeBottom].Weight := xlThin;
  Range.Borders.Item[xlEdgeBottom].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeRight].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeRight].Weight := xlThin;
  Range.Borders.Item[xlEdgeRight].ColorIndex := xlAutomatic;

  if Range.Rows.Count > 1 then
  begin
    Range.Borders.Item[xlInsideHorizontal].LineStyle := xlContinuous;
    Range.Borders.Item[xlInsideHorizontal].Weight := xlThin;
    Range.Borders.Item[xlInsideHorizontal].ColorIndex := xlAutomatic;
  end;

  Range.Borders.Item[xlInsideVertical].LineStyle := xlContinuous;
  Range.Borders.Item[xlInsideVertical].Weight := xlThin;
  Range.Borders.Item[xlInsideVertical].ColorIndex := xlAutomatic;

  // задаем область печати
  if not ShowMetersDrilled then
    FExcel.ActiveSheet.PageSetup.PrintArea := '$A$1:$K$' + IntToStr(10 + GenSection.Slottings.Count + 2)
  else
    FExcel.ActiveSheet.PageSetup.PrintArea := '$A$1:$L$' + IntToStr(10 + GenSection.Slottings.Count + 2);

  // форматируем индекс для стратона
  Cell1 := FXLWorksheet.Cells.Item[10, 8 + ord(ShowMetersDrilled)];
  Cell2 := FXLWorksheet.Cells.Item[10 + GenSection.Slottings.Count - 1, 8 + ord(ShowMetersDrilled)];
  Range := FXLWorksheet.Range[Cell1,Cell2];

  FExcel.Run('PostFormat');
  FExcel.Run('SubscriptRange', Range);
end;

{ TCoreTransferReport }

constructor TCoreTransferReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
end;

function TCoreTransferReport.GetCoreTransfer: TCoreTransfer;
begin
  Result := ReportingObject as TCoreTransfer;
end;

procedure TCoreTransferReport.InternalMoveData;
const       xlEdgeBottom = 9;

var sHeaderStr: string;
    i, k, iCount, iNext, iCell, iBoxCount, iFinalBoxCount, iGeneralBoxCount, iGeneralFinalBoxCount: Integer;
    fCoreYield, fCoreFinalYield, fGeneralCoreYield, fGeneralCoreFinalYield: single;
    Cell11, Cell21, Range: OleVariant;
begin
  inherited;
  if Assigned(CoreTransfer) then
  with CoreTransfer do
  begin
    sHeaderStr := 'АКТ %s керна от %s';
    sHeaderStr := Format(sHeaderStr, [CoreTransferTasks.GetTransferTypeString, List(loBrief)]);

    FExcel.Cells[1, 1] := sHeaderStr;

    //FExcel.Visible := True;

    CoreTransferTasks.SortByTransferType;

    iCell := 4;
    FStartRow := iCell;
    FLeftCol := 1; FRightCol := 8;
    iGeneralBoxCount := 0; iGeneralFinalBoxCount := 0;
    fGeneralCoreYield := 0; fGeneralCoreFinalYield := 0;
    for k := 0 to TMainFacade.GetInstance.AllCoreTransferTypes.Count - 1 do
    begin
      iCount := CoreTransferTasks.CountOfType(TMainFacade.GetInstance.AllCoreTransferTypes.Items[k]);
      if iCount > 0 then
      begin
        FReportData := varArrayCreate([0, iCount - 1, 0, 7], varVariant);

        iNext := 0;
        iBoxCount := 0; iFinalBoxCount := 0;
        fCoreYield := 0; fCoreFinalYield := 0;
        // набрали данные
        for i := 0 to CoreTransferTasks.Count - 1 do
        if Assigned(CoreTransferTasks.Items[i].TransferType) and (CoreTransferTasks.Items[i].TransferType.ID = TMainFacade.GetInstance.AllCoreTransferTypes.Items[k].ID) then
        begin
          FReportData[iNext, 0] := CoreTransferTasks.Items[i].TransferringObject.List(loBrief);

          if Assigned(CoreTransferTasks.Items[i].SourcePlacement) then
            FReportData[iNext, 1] := CoreTransferTasks.Items[i].SourcePlacement.List(loBrief);

          if Assigned(CoreTransferTasks.Items[i].TargetPlacement) then
            FReportData[iNext, 2] := CoreTransferTasks.Items[i].TargetPlacement.List(loBrief);

          if Assigned(CoreTransferTasks.Items[i].Well) then
          begin
            FReportData[iNext, 3] := CoreTransferTasks.Items[i].Well.SlottingPlacement.FinalBoxCount;
            FReportData[iNext, 5] := CoreTransferTasks.Items[i].Well.SlottingPlacement.CoreFinalYield;
            iFinalBoxCount := iFinalBoxCount + CoreTransferTasks.Items[i].Well.SlottingPlacement.FinalBoxCount;
            fCoreFinalYield := fCoreFinalYield + CoreTransferTasks.Items[i].Well.SlottingPlacement.CoreFinalYield;
          end
          else if Assigned(CoreTransferTasks.Items[i].GenSection) then
          begin
            FReportData[iNext, 3] := CoreTransferTasks.Items[i].GenSection.SlottingPlacement.FinalBoxCount;
            FReportData[iNext, 5] := CoreTransferTasks.Items[i].GenSection.SlottingPlacement.CoreFinalYield;
            iFinalBoxCount := iFinalBoxCount + CoreTransferTasks.Items[i].GenSection.SlottingPlacement.FinalBoxCount;
            fCoreFinalYield := fCoreFinalYield + CoreTransferTasks.Items[i].GenSection.SlottingPlacement.CoreFinalYield;
          end;

          FReportData[iNext, 4] := CoreTransferTasks.Items[i].BoxCount;
          FReportData[iNext, 6] := CoreTransferTasks.Items[i].CoreYield;

          iBoxCount := iBoxCount + CoreTransferTasks.Items[i].BoxCount;
          fCoreYield := fCoreYield + CoreTransferTasks.Items[i].CoreYield;


          FReportData[iNext, 7] := CoreTransferTasks.Items[i].BoxNumbers;

          Inc(iNext);
        end;

        iGeneralBoxCount := iGeneralBoxCount + iBoxCount;
        fGeneralCoreYield := fGeneralCoreYield + fCoreYield;
        iGeneralFinalBoxCount := iGeneralFinalBoxCount + iFinalBoxCount;
        fGeneralCoreFinalYield := fGeneralCoreFinalYield + fCoreFinalYield;

        // вставляем строку
        FXLWorksheet.Cells.Item[iCell, 1].Value := TMainFacade.GetInstance.AllCoreTransferTypes.Items[k].List(loBrief);
        FXLWorksheet.Range[FXLWorksheet.Cells.Item[iCell, 1], FXLWorksheet.Cells.Item[iCell, 8]].Merge;
        Inc(iCell);
        // вставляем данные
        Cell11 := FXLWorksheet.Cells.Item[iCell, 1];
        Cell21 := FXLWorksheet.Cells.Item[iCell + iCount - 1, 8];
        Range := FXLWorksheet.Range[Cell11,Cell21];
        Range.Value := FReportData;
        iCell := iCell + iCount;
        // вставляем итоговую строку
        FXLWorksheet.Cells.Item[iCell, 1].Value := 'Итого ' + AnsiLowerCase(TMainFacade.GetInstance.AllCoreTransferTypes.Items[k].List(loBrief));
        FXLWorksheet.Range[FXLWorksheet.Cells.Item[iCell, 1], FXLWorksheet.Cells.Item[iCell, 3]].Merge;

        FXLWorksheet.Cells.Item[iCell, 4].Value := iFinalBoxCount;
        FXLWorksheet.Cells.Item[iCell, 5].Value := iBoxCount;
        FXLWorksheet.Cells.Item[iCell, 6].Value := fCoreFinalYield;
        FXLWorksheet.Cells.Item[iCell, 7].Value := fCoreYield;
        iCell := iCell + 1;
      end;
    end;

    // вставляем строку общих итогов

    FXLWorksheet.Cells.Item[iCell, 1].Value := 'Всего ' + AnsiLowerCase(CoreTransferTasks.GetTransferTypeString);
    FXLWorksheet.Range[FXLWorksheet.Cells.Item[iCell, 1], FXLWorksheet.Cells.Item[iCell, 3]].Merge;

    FXLWorksheet.Cells.Item[iCell, 4].Value := iGeneralFinalBoxCount;
    FXLWorksheet.Cells.Item[iCell, 5].Value := iGeneralBoxCount;
    FXLWorksheet.Cells.Item[iCell, 6].Value := fGeneralCoreFinalYield;
    FXLWorksheet.Cells.Item[iCell, 7].Value := fGeneralCoreYield;
    FFinishRow := iCell;

    iCell := iCell + 2;
    FXLWorksheet.Cells.Item[iCell, 4].Value := 'Ответственный';
    FXLWorksheet.Cells.Item[iCell, 4].HorizontalAlignment := xlRight;
    FXLWorksheet.Cells.Item[iCell, 5].Borders.Item[xlEdgeBottom].LineStyle := xlContinuous;
    FXLWorksheet.Cells.Item[iCell, 5].Borders.Item[xlEdgeBottom].Weight := xlThin;
    FXLWorksheet.Cells.Item[iCell, 5].Borders.Item[xlEdgeBottom].ColorIndex := xlAutomatic;
    FXLWorksheet.Cells.Item[iCell, 6].Value := ResponsibleName;
    FXLWorksheet.Cells.Item[iCell, 6].HorizontalAlignment := xlLeft;
  end;

end;

procedure TCoreTransferReport.InternalOpenTemplate;
begin
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\CoreTransferReport.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TCoreTransferReport.PostFormat;

var Cell1, Cell2, Range: OleVariant;
begin
  inherited;

  // рисуем границы
  Cell1 := FXLWorksheet.Cells.Item[FStartRow, FLeftCol];
  Cell2 := FXLWorksheet.Cells.Item[FFinishRow, FRightCol];
  Range := FXLWorksheet.Range[Cell1,Cell2];

  Range.Borders.Item[xlDiagonalDown].LineStyle := xlNone;
  Range.Borders.Item[xlDiagonalUp].LineStyle := xlNone;

  Range.Borders.Item[xlEdgeLeft].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeLeft].Weight := xlThin;
  Range.Borders.Item[xlEdgeLeft].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeTop].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeTop].Weight := xlThin;
  Range.Borders.Item[xlEdgeTop].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeBottom].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeBottom].Weight := xlThin;
  Range.Borders.Item[xlEdgeBottom].ColorIndex := xlAutomatic;

  Range.Borders.Item[xlEdgeRight].LineStyle := xlContinuous;
  Range.Borders.Item[xlEdgeRight].Weight := xlThin;
  Range.Borders.Item[xlEdgeRight].ColorIndex := xlAutomatic;

  if Range.Rows.Count > 1 then
  begin
    Range.Borders.Item[xlInsideHorizontal].LineStyle := xlContinuous;
    Range.Borders.Item[xlInsideHorizontal].Weight := xlThin;
    Range.Borders.Item[xlInsideHorizontal].ColorIndex := xlAutomatic;
  end;

  Range.Borders.Item[xlInsideVertical].LineStyle := xlContinuous;
  Range.Borders.Item[xlInsideVertical].Weight := xlThin;
  Range.Borders.Item[xlInsideVertical].ColorIndex := xlAutomatic;

  Range.Columns.Item[1].AutoFit;
  Range.Columns.Item[2].AutoFit;
  Range.Columns.Item[3].AutoFit;
  Range.Columns.Item[8].AutoFit;


  FExcel.ActiveSheet.PageSetup.PrintArea := '$A$1:$H$' + IntToStr(FFinishRow + 2);
end;

{ TPetroliferousRegionReport }

constructor TPetroliferousRegionReport.Create(AOwner: TComponent);
begin
  inherited;
  ReportQueryTemplate :=  'select ks.well_uin, ks.vch_area_name, ks.vch_well_num, ks.vch_category_name, ' +
                          'ks.dtm_drilling_start, ks.dtm_drilling_finish, ks.num_core_yield, ks.num_core_final_yield, ' +
                          'ks.num_box_count, ks.num_box_final_count, ks.dtm_kern_take_date, ks.vch_new_region_full_name, ' +
                          'ks.vch_new_main_region_full_name ' +
                          'from vw_kern_statistics ks ' +
                          'where ks.num_core_final_yield is not null';
  NeedsExcel := true;
  SilentMode := false;
  SaveReport := false;
  AutoNumber := [anColumns, anRows];
  RemoveEmptyCols := true;
  DrawBorders := true;
  ReportName := 'Журнал_распределения_керна_по_НГР'
end;

procedure TPetroliferousRegionReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(ParamStr(0))+'\NGRCore.xltx');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TPetroliferousRegionReport.PrepareReport;
begin
  inherited;

end;

procedure TPetroliferousRegionReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
begin
  inherited;

end;

{ TCoreDistrictStatReport }

constructor TCoreDistrictStatReport.Create(AOwner: TComponent);
begin
  inherited;
  ReportQueryTemplate :=  'select '''''''', ks.well_uin, ks.vch_district_name, ' +
                          'ks.vch_area_name, ks.vch_well_num, ks.vch_category_name, ' +
                          'extract(year from ks.dtm_drilling_start), extract(year from ks.dtm_drilling_finish), ' +
                          'ks.num_core_yield, ks.num_box_count,  ' +
                          'ks.num_core_final_yield, ks.num_box_final_count, ks.vch_real_placement, ks.vch_Rack_List, ks.VCH_AGE_CODE, ' + '''' + '''' + ', ' +
                          'ks.Area_ID, ks.District_ID ' +
                          'from vw_kern_statistics ks ' +
                          'where not(ks.num_Core_Yield is null) and not(ks.num_Core_Final_Yield is null) and (ks.num_Core_Final_Yield  > 0) and (ks.district_id in (%s)) ' +
                          'order by 3, 4, 5';


  AreaTotals := true;
  DistrictTotals := true;
  OverallTotals := true;

  NeedsExcel := true;
  SilentMode := false;
  SaveReport := false;
  AutoNumber := [anRows];
  SubtotalsColorFill := true;
  RemoveEmptyCols := false;
  DrawBorders := true;
  ReportName := 'Журнал_распределения_керна_по_георегионам'
end;

procedure TCoreDistrictStatReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\District.xlt');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TCoreDistrictStatReport.PrepareReport;
begin
  inherited;
  FirstColIndex := 1;
  FirstRowIndex := 6;
  AutonumberColumn := 1;
  LastRowIndex := 6;
  LastColIndex := 19;
end;

procedure TCoreDistrictStatReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  inherited;

  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[(LastRowIndex + AQueryBlock.RecordCount - 1)*2, FirstColIndex + AQueryBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
end;

procedure TCoreDistrictStatReport.ProcessTotalBlock(
  ATotalBlock: OleVariant);
var Cell1, Cell2: OleVariant;
begin
  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  Cell2 := FXLWorksheet.Cells.Item[LastRowIndex + ATotalBlock.RecordCount, FirstColIndex + ATotalBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
  inherited;
end;

procedure TCoreDistrictStatReport.SetAreaTotals(const Value: boolean);
begin
  if FAreaTotals <> Value then
  begin
    FAreaTotals := Value;
    if FAreaTotals then
      SubTotals.AddSubTotal('Area_ID', 'District_ID',
                            'select max(Area_ID), max(District_ID), max(ks.vch_district_name), max(vch_area_name), null, null, null, null, ' +
                            'sum(ks.num_core_yield), sum(ks.num_box_count), sum(ks.num_core_final_yield), sum(ks.num_box_final_count) ' +
                            'from vw_kern_statistics ks ' +
                            'where ks.Area_ID in (%s) and (ks.District_ID in (%s)) ' +
                            'order by 3, 4')
    else
      SubTotals.DeleteSubTotal('Area_ID', 'District_ID');

  end;
end;

procedure TCoreDistrictStatReport.SetDistrictTotals(const Value: boolean);
begin
  if FDistrictTotals <> Value then
  begin
    FDistrictTotals := Value;

    if FDistrictTotals then
      SubTotals.AddSubTotal('District_ID',
                            'select '''''''', max(District_ID), max(ks.vch_District_Name), null, null, null, null, null, ' +
                            'sum(ks.num_core_yield), sum(ks.num_box_count), sum(ks.num_core_final_yield), sum(ks.num_box_final_count) ' +
                            'from vw_kern_statistics ks ' +
                            'where ks.District_ID in (%s) ' +
                            'order by 3')
    else
      SubTotals.DeleteSubtotal('District_ID', '');
  end;
end;


procedure TCoreDistrictStatReport.SetOverallTotals(const Value: boolean);
begin
  if FOverallTotals <> Value then
  begin
    FOverallTotals := Value;
    if FOverallTotals then
      GeneralTotalQueryTemplate := 'select '''''''','''''''',' + '''' + 'Всего по выборке' + '''' + ', null, null, null, null, null, sum(ks.num_core_yield), sum(ks.num_box_count), ' +
                                   'sum(ks.num_core_final_yield), sum(ks.num_box_final_count) from vw_kern_statistics ks ' +
                                   'where ks.district_id in (%s)'
    else
      GeneralTotalQueryTemplate := '';

  end;
end;

{ TCoreTransferFullReport }

constructor TCoreTransferFullReport.Create(AOwner: TComponent);
begin
  inherited;
  ReportQueryTemplate := 'Select WELL_UIN, VCH_AREA_NAME, VCH_WELL_NUM, vch_Category_name, ' +
                         'num_box_transfered_count, NUM_BOX_FINAL_COUNT - num_box_transfered_count, vch_box_comment, VCH_PREV_PLACEMENT, ' +
                         'NUM_TRANSFER_YEAR, NUM_DRILLING_START_YEAR, NUM_DRILLING_FINISH_YEAR, ' +
                         'NUM_CORE_FINAL_YIELD, NUM_BOX_FINAL_COUNT, VCH_REAL_PLACEMENT, ' +
                         'VCH_MAIN_DISCTRICT, VCH_CORE_TRANSFER_TYPE_NAME, VCH_PICTURE_EXISTS, NULL, ' +
                         'VCH_COORD_EXISTS, VCH_FUND_NAME, VCH_ORG_FULL_NAME, VCH_LICENSE_NUMBER ' +
                         'from VW_CORE_TRANSFER_TABLE ' +
                         'ORDER BY 2, 3';



  NeedsExcel := true;
  EmptyReportingObjects := true;
  SilentMode := false;
  SaveReport := false;
  AutoNumber := [];
  SubtotalsColorFill := true;
  RemoveEmptyCols := false;
  DrawBorders := true;
  ReportName := 'Текущая_таблица_перевозки'
end;

procedure TCoreTransferFullReport.InternalOpenTemplate;
begin
  inherited;
  FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\CurrentCoreTable.xltx');
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;
end;

procedure TCoreTransferFullReport.PrepareReport;
begin
  inherited;
  FirstColIndex := 1;
  LastRowIndex := 2;
  FirstRowIndex := 2;
  LastColIndex := 22;
end;

procedure TCoreTransferFullReport.PreProcessQueryBlock(
  AQueryBlock: OleVariant);
var Cell1, Cell2: OleVariant;
    i: integer;
begin
  inherited;
  Cell1 := FXLWorksheet.Cells.Item[LastRowIndex, FirstColIndex];
  i :=  LastRowIndex + AQueryBlock.RecordCount;
  Cell2 := FXLWorksheet.Cells.Item[i, FirstColIndex + AQueryBlock.Fields.Count - 1];
  NextRange := FXLWorksheet.Range[Cell1,Cell2];
end;

procedure TCoreTransferFullReport.ProcessTotalBlock(
  ATotalBlock: OleVariant);
begin
  inherited;

end;

{ TCoreTransferFullReportForWells }

constructor TCoreTransferFullReportForWells.Create(AOwner: TComponent);
begin
  inherited;
  ReportQueryTemplate := 'Select WELL_UIN, VCH_AREA_NAME, VCH_WELL_NUM, vch_Category_name, ' +
                         'num_box_transfered_count, NUM_BOX_FINAL_COUNT - num_box_transfered_count, vch_box_comment, VCH_PREV_PLACEMENT, ' +
                         'NUM_TRANSFER_YEAR, NUM_DRILLING_START_YEAR, NUM_DRILLING_FINISH_YEAR, ' +
                         'NUM_CORE_FINAL_YIELD, NUM_BOX_FINAL_COUNT, VCH_REAL_PLACEMENT, ' +
                         'VCH_MAIN_DISCTRICT, VCH_CORE_TRANSFER_TYPE_NAME, VCH_PICTURE_EXISTS, NULL, ' +
                         'VCH_COORD_EXISTS, VCH_FUND_NAME, VCH_ORG_FULL_NAME, VCH_LICENSE_NUMBER ' +
                         'from VW_CORE_TRANSFER_TABLE ' +
                         'where WELL_UIN in (%s) ' + 
                         'ORDER BY 2, 3';
  UseAllReportingObjectsAsOne := true;
  EmptyReportingObjects := true;
end;

{ TRackContentBlankReport }

constructor TRackContentBlankReport.Create(AOwner: TComponent);
begin
  inherited;
  NeedsExcel := true;
  ReportName := 'Бланк_стеллажа'
end;

function TRackContentBlankReport.GetReportFileName: string;
begin
  if trim(ReportName) <> '' then Result := ReportName + '_' + RackRomanNum + '.xls';

  Result := trim(Result);
end;

procedure TRackContentBlankReport.InternalMoveData;
var Range1, Range2: OleVariant;
begin
  inherited;
  Range1 := null; Range2 := null;

  Range1 := FXLWorksheet.Columns[FirstColIndex];
  Range1.Replace('#RACK#', RackRomanNum);

  if not varIsNull(FSecondWorksheet) then
  begin
    Range2 := FSecondWorkSheet.Columns[FirstColIndex];
    Range2.Replace('#RACK#', RackRomanNum);
  end;

end;

procedure TRackContentBlankReport.InternalOpenTemplate;
begin
  FSecondWorksheet := null;
  if RackNum = 11 then
    FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\CoreCellsXI.xlt')
  else if RackNum = 12 then
    FXLWorkBook := FExcel.Workbooks.add(ExtractFileDir(Application.ExeName)+'\CoreCellsXII.xlt')
  else
  begin
    if Odd(RackNum) then
      FXLWorkBook := FExcel.Workbooks.Add(ExtractFileDir(Application.ExeName)+'\CoreCells.xlt')
    else
      FXLWorkBook := FExcel.Workbooks.Add(ExtractFileDir(Application.ExeName)+'\CoreCellsRight.xlt');

    FSecondWorksheet := FExcel.ActiveWorkbook.Sheets[2];
  end;
  FXLWorksheet := FExcel.ActiveWorkbook.ActiveSheet;

  FirstRowIndex := 1;
  FirstColIndex := 1;
end;

procedure TRackContentBlankReport.PostFormat;
begin
  inherited;

end;

{ TRackContentReport }

constructor TRackContentReport.Create(AOwner: TComponent);
begin
  inherited;
  QueryTemplate :=  'select * from vw_rack_content rc where rc.vch_rack_name starting with ''%s'' order by rc.vch_rack_row, vch_rack_column, rc.num_min_box_number desc, rc.vch_area_name';
  NeedsExcel := true;
  SilentMode := true;
  SaveReport := false;
  AutoNumber := [];
  RemoveEmptyCols := false;
  DrawBorders := false;
  ReportName := 'Отчет_о_наполнении_стеллажа'
end;

function TRackContentReport.GetReportFileName: string;
begin


  if trim(ReportName) <> '' then Result := ReportName + '_' + RackRomanNum + '.xls';

  Result := trim(Result);

end;

procedure TRackContentReport.InternalMoveData;
var sQuery, sRackName, sLastWell, sLastArea, sArea, sLastRackName: string;
    iResult, i, j, iROffset, iCoffset: integer;
    vQueryResult: OleVariant;
begin
  inherited;

  sLastArea := ''; sLastRackName := '';
  sQuery := Format(QueryTemplate, [RackRomanNum + '-']);
  iROffset := 0;
  iCOffset := 0;

  iResult := TMainFacade.GetInstance.DBGates.ExecuteQuery(sQuery, vQueryResult);
  if iResult > 0 then
  begin
    for i := 0 to VarArrayHighBound(vQueryResult, 2) do
    begin
      sRackName := vQueryResult[2, i];
      sRackName := StringReplace(sRackName, RackRomanNum + '-', 'Rack', []);
      sRackName := StringReplace(sRackName, '-', '', []);


      FExcel.Goto(sRackName);
      sLastWell := trim(FExcel.ActiveCell.Text);
      
      sArea := TSimpleArea.ShortenAreaName(varAsType(vQueryResult[3, i], varOleStr));
      if sArea = sLastArea then
      begin
        if sLastWell <> '' then sLastWell := sLastWell + ', ' + TSimpleArea.ShortenAreaName(varAsType(vQueryResult[3, i], varOleStr))
        else sLastWell := sArea + '-' + varAsType(vQueryResult[4, i], varOleStr);
      end
      else
      begin
        if sLastWell <> '' then sLastWell := sLastWell + '; ';
        sLastWell := sLastWell + sArea + '-' + varAsType(vQueryResult[4, i], varOleStr);
      end;

      FExcel.ActiveCell.Value := sLastWell;

      if sRackName <> sLastRackName then
      begin
        iROffset := 0;
        iCOffset := 0;
      end;

      for j := varAsType(vQueryResult[6, i], varInteger) to varAsType(vQueryResult[7, i], varInteger) do
      begin
        FExcel.ActiveCell.Offset[-1, 0].Offset[-iROffset, iCoffset].Value := j;
        inc(iROffset);
        if iROffset >= 4 then
        begin
          iCOffset := iCOffset + 1;
          if iCOffset > 2 then iCOffset := 0;
          iROffset := 0;
        end
      end;

      if sRackName <> sLastRackName then
      begin
        sLastArea := '';
      end
      else sLastArea := sArea;

      sLastRackName := sRackName;
    end;
  end;
end;

end.
