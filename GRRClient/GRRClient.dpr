program GRRClient;

uses
  Forms,
  MainForm in 'MainForm.pas' {frmMain},
  CommonObjectSelectFilter in '..\BaseGUI\CommonObjectSelectFilter.pas' {frmObjectSelect: TFrame},
  CommonFilter in '..\BaseGUI\CommonFilter.pas',
  BaseFacades in '..\Base\BaseFacades.pas',
  BaseObjects in '..\Base\BaseObjects.pas',
  PersistentObjects in '..\Base\PersistentObjects.pas',
  BasePosters in '..\Base\BasePosters.pas',
  ParentedObjects in '..\Base\ParentedObjects.pas',
  Registrator in '..\Base\Registrator.pas',
  Options in '..\Base\Options.pas',
  DBGate in '..\Base\DBGate.pas',
  PasswordForm in '..\BaseGUI\PasswordForm.pas' {frmPassword},
  CommonComplexList in '..\BaseGUI\CommonComplexList.pas' {frmComplexList: TFrame},
  CommonComplexCombo in '..\BaseGUI\CommonComplexCombo.pas' {frmComplexCombo: TFrame},
  ClientCommon in '..\Utils\ClientCommon.pas',
  ClientDicts in 'ClientDicts.pas',
  BaseDicts in '..\Base\BaseDicts.pas',
  DictEditor in '..\BaseGUI\DictEditor.pas' {frmDictEditor},
  Facade in 'Facade.pas',
  BaseGUI in '..\BaseGUI\BaseGUI.pas',
  BaseConsts in '..\Utils\BaseConsts.pas',
  FileUtils in '..\Utils\FileUtils.pas',
  OsUtils in '..\Utils\OsUtils.pas',
  StringUtils in '..\Utils\StringUtils.pas',
  BaseActions in '..\Base\BaseActions.pas',
  Version in '..\SD\Version.pas',
  Organization in '..\SD\Organization.pas',
  BaseObjectType in '..\Base\BaseObjectType.pas',
  CommonReport in '..\Base\CommonReport.pas',
  CommonStepForm in '..\BaseGUI\CommonStepForm.pas',
  CalculationLoggerFrame in '..\BaseGUI\CalculationLoggerFrame.pas' {frmCalculationLogger: TFrame},
  CalculationLogger in '..\Base\CalculationLogger.pas',
  CommonFilterContentForm in '..\BaseGUI\CommonFilterContentForm.pas' {frmFilterContent},
  ObjectTypePoster in '..\DP\ObjectTypePoster.pas',
  OrganizationPoster in '..\DP\OrganizationPoster.pas',
  ClientType in '..\SD\ClientType.pas',
  VersionPoster in '..\DP\VersionPoster.pas',
  SDFacade in '..\SD\SDFacade.pas',
  Work in '..\SD\Work.pas',
  Altitude in '..\SD\Altitude.pas',
  Area in '..\SD\Area.pas',
  BaseWellInterval in '..\SD\BaseWellInterval.pas',
  Coord in '..\SD\Coord.pas',
  CoreCollection in '..\SD\CoreCollection.pas',
  CoreDescription in '..\SD\CoreDescription.pas',
  CoreMechanicalState in '..\SD\CoreMechanicalState.pas',
  District in '..\SD\District.pas',
  Employee in '..\SD\Employee.pas',
  FieldWork in '..\SD\FieldWork.pas',
  FinanceSource in '..\SD\FinanceSource.pas',
  Fluid in '..\SD\Fluid.pas',
  GRRParameter in '..\SD\GRRParameter.pas',
  LayerSlotting in '..\SD\LayerSlotting.pas',
  LicenseZone in '..\SD\LicenseZone.pas',
  Lithology in '..\SD\Lithology.pas',
  Material in '..\SD\Material.pas',
  MeasureUnits in '..\SD\MeasureUnits.pas',
  Parameter in '..\SD\Parameter.pas',
  PetrolRegion in '..\SD\PetrolRegion.pas',
  Plan in '..\SD\Plan.pas',
  Profile in '..\SD\Profile.pas',
  ReasonChange in '..\SD\ReasonChange.pas',
  RockSample in '..\SD\RockSample.pas',
  SDReport in '..\SD\SDReport.pas',
  SeismicObject in '..\SD\SeismicObject.pas',
  Slotting in '..\SD\Slotting.pas',
  SlottingBox in '..\SD\SlottingBox.pas',
  SlottingPlacement in '..\SD\SlottingPlacement.pas',
  SlottingWell in '..\SD\SlottingWell.pas',
  State in '..\SD\State.pas',
  Straton in '..\SD\Straton.pas',
  Structure in '..\SD\Structure.pas',
  TectonicStructure in '..\SD\TectonicStructure.pas',
  TestInterval in '..\SD\TestInterval.pas',
  TestIntervalParameter in '..\SD\TestIntervalParameter.pas',
  Theme in '..\SD\Theme.pas',
  Topolist in '..\SD\Topolist.pas',
  TypeResearch in '..\SD\TypeResearch.pas',
  TypeWork in '..\SD\TypeWork.pas',
  Well in '..\SD\Well.pas',
  WorkDataPoster in '..\DP\WorkDataPoster.pas',
  AltitudePoster in '..\DP\AltitudePoster.pas',
  AreaPoster in '..\DP\AreaPoster.pas',
  CoordPoster in '..\DP\CoordPoster.pas',
  CoreCollectionPoster in '..\DP\CoreCollectionPoster.pas',
  CoreDescriptionPoster in '..\DP\CoreDescriptionPoster.pas',
  CoreMechanicalStatePoster in '..\DP\CoreMechanicalStatePoster.pas',
  DistrictPoster in '..\DP\DistrictPoster.pas',
  EmployeePoster in '..\DP\EmployeePoster.pas',
  FieldWorkPoster in '..\DP\FieldWorkPoster.pas',
  FinanceSourcePoster in '..\DP\FinanceSourcePoster.pas',
  FluidPoster in '..\DP\FluidPoster.pas',
  GRRParameterPoster in '..\DP\GRRParameterPoster.pas',
  LayerSlottingPoster in '..\DP\LayerSlottingPoster.pas',
  LicenseZonePoster in '..\DP\LicenseZonePoster.pas',
  LithologyPoster in '..\DP\LithologyPoster.pas',
  MaterialPoster in '..\DP\MaterialPoster.pas',
  MeasureUnitPoster in '..\DP\MeasureUnitPoster.pas',
  ParameterPoster in '..\DP\ParameterPoster.pas',
  PetrolRegionDataPoster in '..\DP\PetrolRegionDataPoster.pas',
  PlanPoster in '..\DP\PlanPoster.pas',
  ProfilePoster in '..\DP\ProfilePoster.pas',
  ReasonChangePoster in '..\DP\ReasonChangePoster.pas',
  RockSamplePoster in '..\DP\RockSamplePoster.pas',
  SeismicObjectDataPoster in '..\DP\SeismicObjectDataPoster.pas',
  SlottingPlacementDataPoster in '..\DP\SlottingPlacementDataPoster.pas',
  SlottingPoster in '..\DP\SlottingPoster.pas',
  SlottingWellPoster in '..\DP\SlottingWellPoster.pas',
  StatePoster in '..\DP\StatePoster.pas',
  StratonPoster in '..\DP\StratonPoster.pas',
  StructurePoster in '..\DP\StructurePoster.pas',
  TectonicStructurePoster in '..\DP\TectonicStructurePoster.pas',
  TestIntervalParameterDataPoster in '..\DP\TestIntervalParameterDataPoster.pas',
  TestIntervalPoster in '..\DP\TestIntervalPoster.pas',
  ThemePoster in '..\DP\ThemePoster.pas',
  TopoListDataPoster in '..\DP\TopoListDataPoster.pas',
  TypeResearchPoster in '..\DP\TypeResearchPoster.pas',
  TypeWorkPoster in '..\DP\TypeWorkPoster.pas',
  WellPoster in '..\DP\WellPoster.pas',
  MapFile in '..\Utils\MapFile.pas',
  VarFileUtils in '..\Utils\VarFileUtils.pas',
  PictureObject in '..\Base\PictureObject.pas',
  SubdivisionComponent in '..\SD\SubdivisionComponent.pas',
  SubdivisionComponentPoster in '..\DP\SubdivisionComponentPoster.pas',
  ResearchGroup in '..\SD\ResearchGroup.pas',
  BaseReport in '..\Base\BaseReport.pas',
  LasFile in '..\SD\LasFile.pas',
  ExceptionExt in '..\Base\ExceptionExt.pas',
  Table in '..\SD\Table.pas',
  NGDR in '..\SD\NGDR.pas',
  NGDRDataPoster in '..\DP\NGDRDataPoster.pas',
  TablePoster in '..\DP\TablePoster.pas',
  Comparers in '..\SD\Comparers.pas',
  PetrophisicsReports in '..\Reports\PetrophisicsReports.pas',
  Encoder in '..\Utils\Encoder.pas',
  SubdivisionReports in '..\Reports\SubdivisionReports.pas',
  LasFileDataPoster in '..\DP\LasFileDataPoster.pas',
  ClientTypeDataPoster in '..\DP\ClientTypeDataPoster.pas',
  CommonVersionSelectFrame in '..\CommonGUI\CommonVersionSelectFrame.pas' {frmSelectVersion: TFrame},
  VersionFrame in '..\CommonGUI\VersionFrame.pas' {frmVersion: TFrame},
  BaseComponent in '..\Base\BaseComponent.pas',
  LicenseZoneSelectFrame in '..\CommonGUI\LicenseZoneSelectFrame.pas' {frmLicenseZoneSelect: TFrame},
  LicenseInformFrame in '..\CommonGUI\LicenseInformFrame.pas' {frmLicenseInform: TFrame},
  DrillingPlanFrame in 'DrillingPlanFrame.pas' {frmDrillingPlan: TFrame},
  SeismPlanFrame in 'SeismPlanFrame.pas' {frmSeismPlan: TFrame},
  NirPlanFrame in 'NirPlanFrame.pas' {frmNirPlan: TFrame},
  DrillingFact in 'DrillingFact.pas' {frmDrillingFact: TFrame},
  GRRObligation in '..\SD\GRRObligation.pas',
  SeismWorkType in '..\SD\SeismWorkType.pas',
  SeismWorkTypePoster in '..\DP\SeismWorkTypePoster.pas',
  GRRObligationPoster in '..\DP\GRRObligationPoster.pas',
  YearFrm in 'YearFrm.pas' {YearFrame: TFrame},
  ChoiceObligation in 'ChoiceObligation.pas' {frmObligationChoice: TFrame},
  ObligationToolsFrame in 'ObligationToolsFrame.pas' {frmObligationTools: TFrame},
  GRRClientGISReports in 'GRRClientGISReports.pas' {frmGISReports},
  GRRClientGISQueries in 'GRRClientGISQueries.pas',
  GRRClientXLGISReports in 'GRRClientXLGISReports.pas' {frmGRRClientGISXLReports},
  CommonFrame in '..\BaseGUI\CommonFrame.pas' {frmCommonFrame: TFrame},
  FramesWizard in '..\Components\FramesWizard\FramesWizard.pas' {DialogFrame: TFrame},
  CoreInterfaces in '..\Base\CoreInterfaces.pas',
  LoggerImpl in '..\Base\LoggerImpl.pas',
  DateTimeCore in '..\Base\DateTimeCore.pas',
  CommonObjectSelector in '..\BaseGUI\CommonObjectSelector.pas',
  IDObjectBaseActions in '..\ACTN\IDObjectBaseActions.pas',
  CommonIDObjectEditForm in '..\CommonGUI\CommonIDObjectEditForm.pas' {frmIDObjectEdit},
  DialogForm in '..\BaseGUI\DialogForm.pas' {CommonDialogForm},
  CommonIDObjectEditFrame in '..\CommonGUI\CommonIDObjectEditFrame.pas' {frmIDObjectEditFrame: TFrame},
  Unit1 in 'Unit1.pas' {Frame1: TFrame},
  ReadCommandLine in '..\Utils\ReadCommandLine.pas',
  ExcelImporter in '..\Importers\ExcelImporter.pas',
  GRRExcelImporter in 'GRRExcelImporter.pas',
  GRRImportingDataInterpreter in 'GRRImportingDataInterpreter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
