unit BaseConsts;

interface

const
  sAutoSaveMessage = '��������� ���������? '+ #13 + #10  + '(���� �� ������ �� ����� �������� �� ���� ������ - ��������� ���� ��������������).';

  EMPLOYEE_NIKONOV = 3;

  NO_TECTONIC_BLOCK_ID = 0;
  PODV_TECTONIC_BLOCK_ID = 7;
  

  CORE_MECH_STATE_STRINGS = 10; // ���� �������� - ����� ��������

  EXCEL_XL_SOLID = 1;
  EXCEL_XL_AUTOMATIC = -4105;
  EXCEL_XL_ThemeColorDark1 = 1;

  SUBDIVISION_COMMENT_NULL = 0;
  SUBDIVISION_COMMENT_STOP = 5;
  SUBDIVISION_COMMENT_NOT_PRESENT = 3;
  SUBDIVISION_COMMENT_NOT_DIVIDED = 1; // ��
  SUBDIVISION_COMMENT_NO_DATA = 2;
  SUBDIVISION_COMMENT_NOT_CROSSED = 4; // �� �������

  sNoDataMessage = '�� ������';

  CoreDirector1 = '�������� �.�.';
  CoreDirector2 = '����� �.�.';
  CoreDirector3 = '�������������� �.�.';


  RemoteCoreFilesPath = '\\srvdb.tprc\DocsBank$\PhotoBoxs\';
  RemoteCoreFilesDiskLetter = 'F:';
  RemoteSrvName = '\\srvdb.tprc';

  GARAGE_PART_PLACEMENT_ID = 2500; //�����
  BASEMENT_PART_PLACEMENT_ID = 2700; // ������

  // ���� ���������
  CORE_TRANSFER_TYPE_TRANSFER_ID = 1;
  CORE_TRANSFER_TYPE_REPLACING_ID = 2;
  CORE_TRANSFER_TYPE_LIC_ID = 3;
  CORE_TRANSFER_TYPE_ARRIVE_ID = 4;
  CORE_TRANSFER_TYPE_PASS_ID = 5;


  DISTRICT_OBJECT_TYPE_ID = 37; // ��� ������� - ���������
  PETROL_REGION_OBJECT_TYPE_ID = 38; // ��� ������� - ��������������� ������
  TECTONIC_STRUCT_OBJECT_TYPE_ID = 39; // ��� ������� - ������������� ���������
  LICENSE_ZONE_OBJECT_TYPE_ID = 29; // ��� ������� - ������������ �������
  ORGANIZATION_OBJECT_TYPE_ID = 40; // ��� ������� - ����������� �����������������


  RESERVES_RESERVE_VALUE_TYPE_ID = 1;

  // ��� ������ ����������
  GRR_WELL_PARAM_GROUP_TYPE = 1;
  GRR_GEOPHYSICAL_PARAM_GROUP_TYPE = 9;
  GRR_NIR_PARAM_GROUP_TYPE = 5;


  // ���� ����������
  GRR_NUMERIC_PARAM_TYPE_ID = 1;
  GRR_STRING_PARAM_TYPE_ID = 2;
  GRR_DATE_PARAM_TYPE_ID = 3;
  GRR_DOMAIN_PARAM_TYPE_ID = 4;

  // ������ ����������
  GRR_GENERAL_PARAMETER_GROUP = 1;
  GRR_CONSTRUCTION_PARAMETER_GROUP = 2;
  GRR_WELL_TEST_PARAMETER_GROUP = 3; // ��������� � �������� ������
  GRR_CORE_PARAMETER_GROUP = 4;
  GRR_STRAT_PARAMETER_GROUP = 5;
  GRR_COST_PARAMETER_GROUP = 16;
  GRR_COLUMN_WELL_TEST_PARAMETER_GROUP = 17; // ��������� � �������
  GRR_OIL_SHOWING_WELL_PARAMETER_GROUP = 18; // �������������������
  GRR_ACCIDENT_WELL_PARAMETER_GROUP = 19; // ������
  GRR_SEISMIC_REWORK_PARAMETER_GROUP = 23;
  GRR_SEISMIC_2D_PARAMETER_GROUP = 12;
  GRR_SEISMIC_3D_PARAMETER_GROUP = 13;
  GRR_SEISMIC_VSP_GROUP = 29;
  GRR_SEISMIC_MKS_GROUP = 30;
  GRR_ELECTRO_GROUP = 31;

  GRR_PROGRAM_GROUP = 20;
  GRR_RESERVES_RECOUNTING_GROUP = 21;
  GRR_BED_RESERVES_GROUP = 22;
  GRR_OTHER_NIR_GROUP = 34;  


  // ���������
  ROTOR_ALTITUDE_ID = 1;
  EARTH_ALTITUDE_ID = 2;
  FLOOR_ALTITUDE_ID = 3;

  // ��� �����������
  RAZVED_ORG_STATUS_ID = 5;

  // ��� ������� ��������� ��� ��������
  BALT_ALT_MEASURE_SYSTEM_ID = 1;


  // ��� ��������� - �������������
  FIELD_STRUCTURE_TYPE_ID = 4;


  // ������ ��� ��� ��������� ���������� �������
  RESERVE_VALUE_TYPE_RESERVE = 1;

  // ��������� �������
  RESOURCE_CATEGORY_A = 1;
  RESOURCE_CATEGORY_B = 2;
  RESOURCE_CATEGORY_C1 = 11;

  RESOURCE_CATEGORY_AB = 8;
  RESOURCE_CATEGORY_ABC1 = 7;

  // ������������� � ����������� �������
  RESOURCE_TYPE_GEO = 1;
  RESOURCE_TYPE_RECOVERABLE = 2;

  // ��������� � ���������� ������
  RESERVE_KIND_START = 1;
  RESERVE_KIND_REM = 2;

  // ��� ��������� - ��� ���������� ���������
  GRR_WELL_INTERVAL_TYPE_UNK = 0;
  GRR_WELL_INTERVAL_TYPE_TEST = 1;
  GRR_WELL_INTERVAL_TYPE_CORE = 2;
  GRR_WELL_INTERVAL_TYPE_STRAT = 3;
  GRR_COLUMN_WELL_INTERVAL_TYPE_TEST = 4; // �������� ��������� � �������
  GRR_WELL_INTERVAL_TYPE_CONSTRUCTION = 5; // �������� �� �����������
  GRR_WELL_INTERVAL_TYPE_OIL = 6;
  GRR_WELL_INTERVAL_TYPE_ACCIDENT = 7;


  // ��� ���������
  PALEONTHOLOGIC_COLLECTION_ID = 1;

  // ���������� �����-�������������
  // �������
  SYSTEM_TAXONOMY_ID = 3;
  // �����
  SERIES_TAXONOMY_ID = 4;
  // ����
  STAGE_TAXONOMY_ID = 6;
  // ��������
  SUBSTAGE_TAXONOMY_ID = 7;
  // ��������
  SUPERSTAGE_TAXONOMY_ID = 5;

  //���� ��������������� ������
  GENERAL_TAXONOMY_TYPE_ID = 1;
  REGIONAL_TAXONOMY_TYPE_ID = 2;
  SUBREGIONAL_TAXONOMY_TYPE_ID = 6;
  LOCAL_TAXONOMY_TYPE_ID = 4;
  UNKNOWN_TAXONOMY_TYPE_ID = 0;


  // ������� ���������
  NO_REASON_CHANGE_ID = 1;

  // ������� ��������� �� ������
  DEFAULT_MEASURE_UNIT_ID = 0;

  // ��������� �������
  WELL_CATEGORY_NOT_DEFINED = 7;
  WELL_CATEGORY_PROSPECTING = 13; //���������
  WELL_CATEGORY_PROSPECTING_AND_EVALUATION = 14; //��������-���������
  WELL_CATEGORY_STRUCTURAL_PROSPECT = 19; //



  // ��������� �������
  WELL_STATE_LIQIUDATED = 3;

  // ���� �������������
  SEISMIC_REPORT_TYPE_REWORK = 1;
  SEISMIC_REPORT_TYPE_2D = 2;
  SEISMIC_REPORT_TYPE_3D = 3;
  GRR_PROGRAM_REPORT_TYPE = 4;
  RESERVES_RECOUNTING_REPORT_TYPE = 5;
  SEISMIC_REPORT_TYPE_VSP = 6;
  SEISMIC_REPORT_TYPE_MKS = 7;
  SEISMIC_REPORT_TYPE_ELECTRO = 8;
  GRR_OTHER_NIR_REPORT_TYPE = 9;


  // ���� ����� ��������
  FIELD_FUND_TYPE_ID = 4;


  CORE_SAMPLE_TYPE_COMMON_ID = 6;


  // ���� ��������
  LICENSE_ZONE_CLIENT_TYPE_ID = 16;

  // ���� ��������
  LICENSE_TYPE_ID_NE = 2;
  LICENSE_TYPE_ID_NR = 1;
  LICENSE_TYPE_ID_NP = 3;


  SEISWORK_TYPE_2D = 1;
  SEISWORK_TYPE_3D = 2;
  SEISWORK_TYPE_UNKNOWN = 3;
  SEISWORK_TYPE_CAROTAGE = 5;
  SEISWORK_TYPE_VSP = 6;
  SEISWORK_TYPE_ELECTRO = 7;
  SEISWORK_TYPE_2D_AND_3D = 8;



  BINDING_OBJECT_TYPE_WELL = 1; 
  BINDING_OBJECT_TYPE_AREA = 2;
  BINDING_OBJECT_TYPE_NGR = 3;
  BINDING_OBJECT_TYPE_NGO = 4;
  BINDING_OBJECT_TYPE_NGP = 5;

  // ���� ���� �������� �����
  CORE_MAIN_GARAGE_ID = 2500;


  // ���� ����� �� ��� (tbl_NIR_Type_Dict)
  NIR_TYPE_OTHER = -1; // ������ ������
  NIR_TYPE_ECO = -2; // ������������� ������
  NIR_TYPE_COUNTING = -3; // ������� �������
  NIR_TYPE_SEISMIC = -4; //
  NIR_TYPE_NIR = -5;
  NIR_TYPE_DRILLING = -6;
  NIR_TYPE_EXP = -7;
  NIR_TYPE_GEOPHIS = -8;
  NIR_TYPE_GEOCHEM = -9;
  NIR_TYPE_GRR_REPORT = -10;
  NIR_TYPE_START_WORKS = -11;
  NIR_TYPE_GRR_PROGRAM = -12;
  NIR_TYPE_UNK = -13;
  NIR_TYPE_SUPER = -14;
  NIR_TYPE_PIR = -15;
  NIR_TYPE_KRS = -16;



implementation

end.
