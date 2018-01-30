unit ClientDicts;

interface

uses BaseDicts, Forms;

type

   TClientDicts = class(TDicts)
   public
     constructor Create; override;

   end;

  TDictEditForm = class(TForm)
  protected
    FDict: TDict;
    procedure SetDict(const Value: TDict); virtual; abstract;
  public
    property Dict: TDict read FDict write SetDict;
    procedure ClearControls; virtual;
    procedure SaveValues; virtual;
    procedure AdditionalSave; virtual;
  end;


implementation

uses Variants, Facade, SysUtils, RRManagerLayerEditForm, RRManagerStratumEditForm;

{ TClientDicts }

constructor TClientDicts.Create;
var iRes: integer;
    d: TDict;
    vCols, vValues: variant;
begin
  inherited Create;
  vCols := varArrayOf(['distinct Table_ID', 'vch_Table_Name', 'vch_Rus_Table_Name']);
  vValues := varArrayOf([TMainFacade.GetInstance.ClientAppTypeID, TMainFacade.GetInstance.DBGates.GroupID, 2]);

 iRes := TMainFacade.GetInstance.DBGates.Server.SelectRows('SPD_GET_TABLES', vCols, '', vValues);

//  iRes := IServer.ExecuteQuery('select distinct Table_ID, vch_Table_Name, vch_Rus_Table_Name from spd_Get_Tables(' + IntToStr(iClientAppType) + ',' +  IntToStr(iGroupID) + ', 2)');
  if iRes > 0 then
    TableDict:=TMainFacade.GetInstance.DBGates.Server.QueryResult;

  d := TDict.Create(Self, 'TBL_AREA_DICT', true, '*', '', 'VCH_AREA_STATE, NUM_OLD_AREA_CODE');
  d.IsEditable := false;


  d := TDict.Create(Self, 'TBL_PETROLIFEROUS_REGION_DICT', true, '*', 'NUM_REGION_TYPE = 3',
                    'VCH_REGION_SHORT_NAME, VCH_OLD_REGION_CODE, NUM_REGION_TYPE, MAIN_REGION_ID' );
  d.IsEditable := false;

  d := TDict.Create(Self, 'TBL_TECTONIC_STRUCT_DICT', true, '*', '', 'VCH_OLD_STRUCT_CODE, VCH_STRUCT_CODE, NUM_STRUCT_TYPE, MAIN_STRUCT_ID');
  d.IsEditable := false;

  d := TDict.Create(Self, 'TBL_DISTRICT_DICT', true, '*', '', 'NUM_OLD_DISTRICT_CODE, NUM_DISTRICT_TYPE, MAIN_DISTRICT_ID');
  d.IsEditable := false;


  d := TDict.Create(Self, 'TBL_ORGANIZATION_DICT', true, '*',  '', 'VCH_ORG_SHORT_NAME, NUM_OLD_ORG_CODE, NUM_ORG_TYPE');
  d.IsEditable := false;


  d := TDict.Create(Self, 'TBL_STRUCTURE_TECTONIC_ELEMENT', true, 'STRUCTURE_TECTONIC_ELEMENT_ID, VCH_SUBSTRUCTURE_NAME, SUBSTRUCTURE_TYPE_ID', '', 'STRUCTURE_ID');

  TDict.Create(Self, 'TBL_RRCOUNT_PARAM_DICT', true,
               UpperCase('Parameter_ID, vch_Param_Name, vch_Param_Short_Name, vch_Param_Sign, Param_Type_ID'),
               '(Parameter_ID in (select Parameter_ID from TBL_CLIENT_RRCOUNT_PARAM where CLIENT_APP_TYPE_ID = ' +
               IntToStr(TMainFacade.GetInstance.DBGates.ClientAppTypeID) + ')) order by vch_Param_Name', '');

  d := TDict.Create(Self, 'TBL_FLUID_TYPE_DICT', true, '*', 'NUM_BALANCE_FLUID = 1');
  d.IsEditable := false;

  d := TDict.Create(Self, 'TBL_RESOURCES_CATEGORY_DICT', true, '*');

  TDict.Create(Self, 'TBL_RRCOUNT_PARAM_TYPE_DICT', true, '*');


  d := TDict.Create(Self, 'TBL_STRATIGRAPHY_NAME_DICT', true, '*');
  d.IsEditable := false;

  TDict.Create(Self, 'TBL_TRAP_TYPE_DICT', true);
  TDict.Create(Self, 'TBL_PREPDIS_METHOD_DICT', true);
  TDict.Create(Self, 'TBL_STRUCTURE_FUND_TYPE_DICT', true);
  TDict.Create(Self, 'TBL_BED_TYPE_DICT', true);
  TDict.Create(Self, 'TBL_RESOURSE_TYPE_DICT', true);

  d := TDict.Create(Self, 'TBL_LAYER', true);
  d.DictEditFormClass := TfrmEditLayer;

  TDict.Create(Self, 'TBL_STRATUM', true);
  d := TDict.Create(Self, 'TBL_CONCRETE_STRATUM', true, 'Concrete_Stratum_Id, vch_Concrete_Stratum_Name, Stratum_ID');
  d.DictEditFormClass := TfrmEditStratum;

  TDict.Create(Self, 'TBL_ACTION_TYPE_DICT', true);
  TDict.Create(Self, 'TBL_ACTION_REASON_DICT', true);
//  TDict.Create(Self, 'TBL_SUBSTRUCT_PARAM_TYPE_DICT', true);
  // вид запасов
  TDict.Create(Self, 'TBL_RESERVES_KIND_DICT', true);
  TDict.Create(Self, 'TBL_OIL_COMPLEX_DICT', true, 'COMPLEX_ID, VCH_COMPLEX_NAME, VCH_COMPLEX_SHORT_NAME, NUM_IS_SUBCOMPLEX, NUM_CARBONATE', '', 'FIRST_STRATON_ID, SECOND_STRATON_ID');
  d.IsEditable := false;
  
  d := TDict.Create(Self, 'TBL_MATERIAL_TYPE', true, 'Material_Type_ID, vch_Material_Type_Name', '', 'NUM_BIND_REQUIER, VCH_FILE_REQUIER');
  d.IsEditable := false;
  d := TDict.Create(Self, 'TBL_MEDIUM', true, 'Medium_ID, vch_Medium_Name');
  d.IsEditable := false;
  d := TDict.Create(Self, 'TBL_THEME', true, 'Theme_ID, vch_Theme_Name, vch_Theme_Number', '', 'DTM_ACTUAL_PERIOD_START, DTM_ACTUAL_PERIOD_FINISH');
  d.IsEditable := false;







  TDict.Create(Self, 'TBL_LITHOLOGY_DICT', true).IsEditable := false;
  // тип месторождения
  TDict.Create(Self, 'TBL_FIELD_TYPE_DICT', true, 'Field_Type_ID, vch_Field_Type_Short_Name, vch_Field_Type_Name, num_L_Code');
  // лицензионный участок
  d := TDict.Create(Self, 'VW_CURRENT_LICENSE_ZONES', true, 'license_zone_id, VCH_LICENSE_ZONE_FULL_NAME, vch_license_zone_name, dtm_registration_date, dtm_registration_date_finish',
                    'LICENSE_ZONE_ID > 0 ORDER BY rf_rupper(VCH_LICENSE_ZONE_FULL_NAME)');
  d.IsEditable := false;
  // степень освоения
  TDict.Create(Self, 'TBL_DEVELOPMENT_DEGREE_DICT', true);

  // версия подсчета
  TDict.Create(Self, 'TBL_COUNT_VERSION_DICT', true);
  // тип подсчетного документа
  TDict.Create(Self, 'TBL_COUNT_DOCUMENT_TYPE_DICT', true);
  // служащие
  TDict.Create(Self, 'TBL_EMPLOYEE', true).IsEditable := false;

  TDict.Create(Self, 'TBL_MEASURE_UNIT_DICT', true, 'Measure_Unit_ID, vch_Measure_Unit_Name', '', 'MEASURE_UNIT_CTGR_ID');





  d := TDict.Create(Self, 'SPD_GET_REPORT_AUTHORS', true, 'distinct vch_Report_Author', 'order by 1');
  d.IsEditable := false;

  d := TDict.Create(Self, 'SPD_GET_SEISMOGROUP_NUMBER', true, 'distinct vch_Seismogroup_Number', 'order by 1');
  d.IsEditable := false;

  // представления для отчетов
  // данные не выбираем
  // только структуру
  d := TDict.Create(Self, 'VW_STRUCTURE', false, '*', 'Version_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  d.IsVisible := false;

  d := TDict.Create(Self, 'VW_STRUCTURE_RESOURCES', false, '*', 'Version_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  d.IsVisible := false;


  d := TDict.Create(Self, 'VW_HORIZON', false, '*', 'Version_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  d.IsVisible := false;

  d := TDict.Create(Self, 'VW_HORIZON_RESOURCES', false, '*', 'Version_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  d.IsVisible := false;


  d := TDict.Create(Self, 'vw_Count_Document', true,
                    'DOCUMENT_ID, VCH_DOC_NAME, ' +
                    'DOC_TYPE_ID, VCH_DOC_TYPE_NAME, ' +
                    'CREATOR_ORGANIZATION_ID, VCH_CREATOR_ORG_FULL_NAME, ' +
                    'VERSION_ID, VCH_VERSION_NAME, ' +
                    'VCH_AUTHORS, ' +
                    'DTM_CREATION_DATE, ORGANIZATION_ID, VCH_ORG_FULL_NAME, ' +
                    'DTM_AFFIRMATION_DATE, NUM_AFFIRMED');
  d.IsVisible := false;
  d.IsEditable := false;

  d := TDict.Create(Self, 'VW_SUBSTRUCTURE', false, '*', 'Version_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  d.IsVisible := false;

  d := TDict.Create(Self, 'VW_CONCRETE_LAYER', false, '*', 'Version_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  d.IsVisible := false;

  d := TDict.Create(Self, 'VW_RESERVE', false, '*', 'Version_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  d.IsVisible := false;

  d := TDict.Create(Self, 'VW_RESOURCE', false, '*', 'Version_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  d.IsVisible := false;

  d := TDict.Create(Self, 'VW_ACTION', false, '*', 'Version_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  d.IsVisible := false;

  d := TDict.Create(Self, 'VW_BED', false, '*', 'Version_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveVersion.ID));
  d.IsVisible := false;

  d := TDict.Create(Self, 'TBL_LICENSE_ZONE_STATE_DICT', true, 'LICENSE_ZONE_STATE_ID, VCH_LICENSE_ZONE_STATE_NAME', '');
  d.IsVisible := false;

  d := TDict.Create(Self, 'TBL_LICENSE_TYPE_DICT', true, 'LICENSE_TYPE_ID, VCH_LICENSE_TYPE_NAME, VCH_LIC_TYPE_SHORT_NAME', '');
  d.IsVisible := false;

  d := TDict.Create(Self, 'TBL_LICENSE_ZONE_TYPE_DICT', true, 'LICENSE_ZONE_TYPE_ID, VCH_LICENSE_ZONE_TYPE_NAME, VCH_LICENSE_ZONE_TP_SHORT_NAME', '');
  d.IsVisible := false;

  d := TDict.Create(Self, 'TBL_COMPETITION_TYPE_DICT', true, '*', '');
  d.IsVisible := false;


  d := TDict.Create(Self, 'TBL_RELATIONSHIP_TYPE_DICT', true, '*', '');
  d.IsVisible := false;

  d := TDict.Create(Self, 'TBL_RESERVES_VALUE_TYPE', true, '*', '');
  d.IsVisible := false;

end;

{ TDictEditForm }

procedure TDictEditForm.AdditionalSave;
begin

end;

procedure TDictEditForm.ClearControls;
begin

end;

procedure TDictEditForm.SaveValues;
begin

end;

end.
