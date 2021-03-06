program SeisMaterialClient.V3;

uses
  Forms,
  MainForm in 'MainForm.pas' {frmMain},
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
  GRRObligation in '..\SD\GRRObligation.pas',
  SeismWorkType in '..\SD\SeismWorkType.pas',
  GRRObligationPoster in '..\DP\GRRObligationPoster.pas',
  SeismWorkTypePoster in '..\DP\SeismWorkTypePoster.pas',
  ReadCommandLine in '..\Utils\ReadCommandLine.pas',
  FormSeisDict in 'FormSeisDict.pas' {frmSeisDict},
  SeisProfile in '..\SD\SeisProfile.pas',
  SeisMaterial in '..\SD\SeisMaterial.pas',
  SeisExemplePoster in '..\DP\SeisExemplePoster.pas',
  SeisMaterialPoster in '..\DP\SeisMaterialPoster.pas',
  SeisProfilePoster in '..\DP\SeisProfilePoster.pas',
  SeisExemple in '..\SD\SeisExemple.pas',
  FrameTestGridView in 'FrameTestGridView.pas' {Frame1: TFrame},
  FrameSeisMateralList in 'FrameSeisMateralList.pas' {Frame2: TFrame},
  FormEditSeisMaterial in 'FormEditSeisMaterial.pas' {frmSMEdit},
  FrameEditSMSimpleDocument in 'FrameEditSMSimpleDocument.pas' {Frame3: TFrame},
  FrameEditSMMaterialBind in 'FrameEditSMMaterialBind.pas' {Frame4: TFrame},
  FrameEditSMSeisMaterial in 'FrameEditSMSeisMaterial.pas' {Frame5: TFrame},
  FrameEditSMExemple in 'FrameEditSMExemple.pas' {Frame6: TFrame},
  FrameEditSMProfile in 'FrameEditSMProfile.pas' {Frame7: TFrame},
  FormEvent in 'FormEvent.pas',
  FormEditProfile in 'FormEditProfile.pas' {frmEditProfile},
  FrameEditProfile in 'FrameEditProfile.pas' {Frame8: TFrame},
  FrameFilter in 'FrameFilter.pas' {Frame9: TFrame},
  FormFilter in 'FormFilter.pas' {frmFilter},
  FormReports in 'FormReports.pas' {frmReports},
  FrameReportsAttribute in 'FrameReportsAttribute.pas' {frmReportsAtrtribute: TFrame},
  FrameReportsView in 'FrameReportsView.pas' {frmReportsView: TFrame},
  FrameReportsBut in 'FrameReportsBut.pas' {frmReportsBut: TFrame},
  SeisWorkReport in 'SeisWorkReport.pas',
  FormEditExemple in 'FormEditExemple.pas' {frmEditExemple},
  RegExpr in '..\Utils\regexpr.pas',
  CommonFilter in 'CommonFilter.pas',
  CommonObjectSelectFilter in 'CommonObjectSelectFilter.pas' {frmObjectSelect: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSeisDict, frmSeisDict);
  Application.CreateForm(TfrmSMEdit, frmSMEdit);
  Application.CreateForm(TfrmEditProfile, frmEditProfile);
  Application.CreateForm(TfrmFilter, frmFilter);
  Application.CreateForm(TfrmReports, frmReports);
  Application.CreateForm(TfrmEditExemple, frmEditExemple);
  Application.Run;
end.
