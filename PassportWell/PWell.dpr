program PWell;

uses
  Forms,
  MainForm in 'MainForm.pas' {frmMain},
  Facade in 'Facade.pas',
  BaseFacades in '..\Base\BaseFacades.pas',
  BaseObjects in '..\Base\BaseObjects.pas',
  PersistentObjects in '..\Base\PersistentObjects.pas',
  BasePosters in '..\Base\BasePosters.pas',
  ParentedObjects in '..\Base\ParentedObjects.pas',
  Registrator in '..\Base\Registrator.pas',
  Options in '..\Base\Options.pas',
  FileUtils in '..\Utils\FileUtils.pas',
  OsUtils in '..\Utils\OsUtils.pas',
  StringUtils in '..\Utils\StringUtils.pas',
  DBGate in '..\Base\DBGate.pas',
  BaseDicts in '..\Base\BaseDicts.pas',
  ClientCommon in '..\Utils\ClientCommon.pas',
  ClientDicts in 'ClientDicts.pas',
  BaseActions in '..\Base\BaseActions.pas',
  Version in '..\SD\Version.pas',
  Organization in '..\SD\Organization.pas',
  BaseObjectType in '..\Base\BaseObjectType.pas',
  CommonReport in '..\Base\CommonReport.pas',
  CommonStepForm in '..\BaseGUI\CommonStepForm.pas' {frmStep},
  CalculationLoggerFrame in '..\BaseGUI\CalculationLoggerFrame.pas' {frmCalculationLogger: TFrame},
  CalculationLogger in '..\Base\CalculationLogger.pas',
  SDFacade in '..\SD\SDFacade.pas',
  District in '..\SD\District.pas',
  Employee in '..\SD\Employee.pas',
  Fluid in '..\SD\Fluid.pas',
  LicenseZone in '..\SD\LicenseZone.pas',
  MeasureUnits in '..\SD\MeasureUnits.pas',
  PetrolRegion in '..\SD\PetrolRegion.pas',
  Structure in '..\SD\Structure.pas',
  TypeWork in '..\SD\TypeWork.pas',
  Well in '..\SD\Well.pas',
  Area in '..\SD\Area.pas',
  Slotting in '..\SD\Slotting.pas',
  RockSample in '..\SD\RockSample.pas',
  TypeResearch in '..\SD\TypeResearch.pas',
  Lithology in '..\SD\Lithology.pas',
  TypeResearchPoster in '..\Dp\TypeResearchPoster.pas',
  TypeWorkPoster in '..\Dp\TypeWorkPoster.pas',
  AreaPoster in '..\Dp\AreaPoster.pas',
  EmployeePoster in '..\Dp\EmployeePoster.pas',
  LicenseZonePoster in '..\Dp\LicenseZonePoster.pas',
  LithologyPoster in '..\Dp\LithologyPoster.pas',
  MeasureUnitPoster in '..\Dp\MeasureUnitPoster.pas',
  PetrolRegionDataPoster in '..\Dp\PetrolRegionDataPoster.pas',
  StructurePoster in '..\Dp\StructurePoster.pas',
  BaseWellInterval in '..\SD\BaseWellInterval.pas',
  Straton in '..\SD\Straton.pas',
  CoreMechanicalState in '..\SD\CoreMechanicalState.pas',
  SlottingPlacement in '..\SD\SlottingPlacement.pas',
  PictureObject in '..\Base\PictureObject.pas',
  SlottingPlacementDataPoster in '..\Dp\SlottingPlacementDataPoster.pas',
  LayerSlotting in '..\SD\LayerSlotting.pas',
  TestInterval in '..\SD\TestInterval.pas',
  Parameter in '..\SD\Parameter.pas',
  DistrictPoster in '..\Dp\DistrictPoster.pas',
  ParameterPoster in '..\Dp\ParameterPoster.pas',
  WellPoster in '..\Dp\WellPoster.pas',
  TestIntervalPoster in '..\Dp\TestIntervalPoster.pas',
  FluidPoster in '..\Dp\FluidPoster.pas',
  SlottingPoster in '..\Dp\SlottingPoster.pas',
  CoreDescription in '..\SD\CoreDescription.pas',
  LayerSlottingPoster in '..\Dp\LayerSlottingPoster.pas',
  CoreDescriptionPoster in '..\Dp\CoreDescriptionPoster.pas',
  VarFileUtils in '..\Utils\VarFileUtils.pas',
  MapFile in '..\Utils\MapFile.pas',
  CoreMechanicalStatePoster in '..\Dp\CoreMechanicalStatePoster.pas',
  RockSamplePoster in '..\Dp\RockSamplePoster.pas',
  StratonPoster in '..\Dp\StratonPoster.pas',
  ObjectTypePoster in '..\Dp\ObjectTypePoster.pas',
  OrganizationPoster in '..\Dp\OrganizationPoster.pas',
  CommonFilterContentForm in '..\BaseGUI\CommonFilterContentForm.pas' {frmFilterContent},
  CommonFrame in '..\BaseGUI\CommonFrame.pas' {frmCommonFrame: TFrame},
  BaseGUI in '..\BaseGUI\BaseGUI.pas',
  BaseConsts in '..\Utils\BaseConsts.pas',
  FramesWizard in '..\Components\FramesWizard\FramesWizard.pas' {DialogFrame: TFrame},
  InfoPropertiesFrame in '..\CommonGUI\InfoPropertiesFrame.pas' {frmInfoProperties: TFrame},
  InfoWellsFrame in '..\CommonGUI\InfoWellsFrame.pas' {frmInfoWells: TFrame},
  InfoObjectFrame in '..\CommonGUI\InfoObjectFrame.pas' {frmInfoObject: TFrame},
  DialogForm in '..\BaseGUI\DialogForm.pas' {CommonDialogForm},
  AllObjectsCbxFilterFrame in '..\BaseGUI\AllObjectsCbxFilterFrame.pas' {frmAllObjectsFilter: TFrame},
  AllObjectsFilterFrame in '..\BaseGUI\AllObjectsFilterFrame.pas' {frmAllObjs: TFrame},
  PWInfoWellFrame in 'PWInfoWellFrame.pas' {frmInfoWell: TFrame},
  PWInfoWellBindingFrame in 'PWInfoWellBindingFrame.pas' {frmWellBinding: TFrame},
  PWInfoWellParametrsFrame in 'PWInfoWellParametrsFrame.pas' {frmInfoWellParametrs: TFrame},
  PWInfoChangesWellFrame in 'PWInfoChangesWellFrame.pas' {InfoChangesWell: TFrame},
  PWEditorWell in 'PWEditorWell.pas' {frmEditorWell},
  CommonValueDictFrame in '..\BaseGUI\CommonValueDictFrame.pas' {frmFilter: TFrame},
  CommonValueDictSelectForm in '..\BaseGUI\CommonValueDictSelectForm.pas' {frmValueDictSelect},
  LoadThread in '..\BaseGUI\LoadThread.pas',
  AllUnits in '..\BaseGUI\AllUnits.pas' {frmAllUnits},
  AllObjectsFrame in '..\BaseGUI\AllObjectsFrame.pas' {frmAllObjects: TFrame},
  UniButtonsFrame in '..\BaseGUI\UniButtonsFrame.pas' {frmButtons: TFrame},
  AddUnits in '..\BaseGUI\AddUnits.pas' {frmEditor},
  AddObjectFrame in '..\BaseGUI\AddObjectFrame.pas' {frmAddObject: TFrame},
  ReasonChange in '..\SD\ReasonChange.pas',
  ReasonChangePoster in '..\Dp\ReasonChangePoster.pas',
  Profile in '..\SD\Profile.pas',
  ProfilePoster in '..\Dp\ProfilePoster.pas',
  State in '..\SD\State.pas',
  StatePoster in '..\Dp\StatePoster.pas',
  FinanceSource in '..\SD\FinanceSource.pas',
  FinanceSourcePoster in '..\DP\FinanceSourcePoster.pas',
  PWEditInfoWell in 'PWEditInfoWell.pas' {frmEditInfoWell},
  PWEditInfoWellBinding in 'PWEditInfoWellBinding.pas' {frmEditInfoWellBinding},
  PWEditInfoWellParametrs in 'PWEditInfoWellParametrs.pas' {frmEditInfoWellParameters},
  Load in '..\BaseGUI\Load.pas' {frmLoad},
  ClientType in '..\SD\ClientType.pas',
  Topolist in '..\SD\Topolist.pas',
  TopoListDataPoster in '..\DP\TopoListDataPoster.pas',
  TectonicStructure in '..\SD\TectonicStructure.pas',
  TectonicStructurePoster in '..\DP\TectonicStructurePoster.pas',
  CoreInterfaces in '..\Base\CoreInterfaces.pas',
  LoggerImpl in '..\Base\LoggerImpl.pas',
  DateTimeCore in '..\Base\DateTimeCore.pas',
  ExceptionExt in '..\Base\ExceptionExt.pas',
  AltitudePoster in '..\DP\AltitudePoster.pas',
  Altitude in '..\SD\Altitude.pas',
  PWInfoWellAltitudeFrame in 'PWInfoWellAltitudeFrame.pas' {frmAltitudesWell: TFrame},
  PWEditInfoWellAltitude in 'PWEditInfoWellAltitude.pas' {frmEditWellAltitude},
  PWEditInfoCoordWell in 'PWEditInfoCoordWell.pas' {frmEditInfoCoordWell},
  PWInfoCoordWell in 'PWInfoCoordWell.pas' {frmInfoCoordWell: TFrame},
  Coord in '..\SD\Coord.pas',
  CoordPoster in '..\DP\CoordPoster.pas',
  CommonValueDictChkBxFrame in '..\BaseGUI\CommonValueDictChkBxFrame.pas' {frmFilterChkBx: TFrame},
  CommonValueDictSelectChkBxForm in '..\BaseGUI\CommonValueDictSelectChkBxForm.pas' {frmValueDictSelectChkBx},
  Material in '..\SD\Material.pas',
  MaterialPoster in '..\DP\MaterialPoster.pas',
  GRRParameter in '..\SD\GRRParameter.pas',
  GRRParameterPoster in '..\DP\GRRParameterPoster.pas',
  VersionPoster in '..\DP\VersionPoster.pas',
  Table in '..\SD\Table.pas',
  TablePoster in '..\DP\TablePoster.pas',
  PasswordForm in '..\BaseGUI\PasswordForm.pas' {frmPassword},
  PWSearchingWell in 'PWSearchingWell.pas' {frmFindWell},
  CommonFilterSearchingFrame in '..\BaseGUI\CommonFilterSearchingFrame.pas' {Frame1: TFrame},
  ClientTypeDataPoster in '..\DP\ClientTypeDataPoster.pas',
  NGDR in '..\SD\NGDR.pas',
  NGDRDataPoster in '..\DP\NGDRDataPoster.pas',
  PWReportWells in 'PWReportWells.pas' {frmReportByWells},
  SubdivisionComponent in '..\SD\SubdivisionComponent.pas',
  SubdivisionComponentPoster in '..\DP\SubdivisionComponentPoster.pas',
  ResearchGroup in '..\SD\ResearchGroup.pas',
  BaseReport in '..\Base\BaseReport.pas',
  LasFile in '..\SD\LasFile.pas',
  GRRObligation in '..\SD\GRRObligation.pas',
  SeismicObject in '..\SD\SeismicObject.pas',
  SeismicObjectDataPoster in '..\DP\SeismicObjectDataPoster.pas',
  SeismWorkType in '..\SD\SeismWorkType.pas',
  Work in '..\SD\Work.pas',
  GRRObligationPoster in '..\DP\GRRObligationPoster.pas',
  SeismWorkTypePoster in '..\DP\SeismWorkTypePoster.pas',
  WorkDataPoster in '..\DP\WorkDataPoster.pas',
  Comparers in '..\SD\Comparers.pas',
  PetrophisicsReports in '..\Reports\PetrophisicsReports.pas',
  SDReport in '..\SD\SDReport.pas',
  Encoder in '..\Utils\Encoder.pas',
  SubdivisionReports in '..\Reports\SubdivisionReports.pas',
  LasFileDataPoster in '..\DP\LasFileDataPoster.pas',
  ReadCommandLine in '..\Utils\ReadCommandLine.pas',
  RegExpr in '..\Utils\regexpr.pas',
  CoreTransfer in '..\SD\CoreTransfer.pas',
  SlottingWell in '..\SD\SlottingWell.pas',
  SlottingWellPoster in '..\DP\SlottingWellPoster.pas',
  GeneralizedSection in '..\SD\GeneralizedSection.pas',
  GeneralizedSectionDataPoster in '..\DP\GeneralizedSectionDataPoster.pas',
  CoreTransferDataPoster in '..\DP\CoreTransferDataPoster.pas',
  Bed in '..\SD\Bed.pas',
  Field in '..\SD\Field.pas',
  PWSelectVersionForm in 'PWSelectVersionForm.pas' {frmSelectVersion},
  Theme in '..\SD\Theme.pas',
  ThemePoster in '..\DP\ThemePoster.pas',
  CommonWellSearchForm in '..\CommonGUI\CommonWellSearchForm.pas' {frmWellSearch},
  CommonFilter in '..\CommonGUI\CommonFilter.pas',
  CommonObjectSelectFilter in '..\CommonGUI\CommonObjectSelectFilter.pas' {frmObjectSelect: TFrame},
  WellSearchController in '..\CommonGUI\WellSearchController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '����� �������� �������';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmWellSearch, frmWellSearch);
  Application.Run;
end.
