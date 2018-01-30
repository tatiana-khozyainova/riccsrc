unit PWReportWells;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Buttons, ExtCtrls, OleServer, ExcelXP;

type
  TfrmReportByWells = class(TForm)
    pnl1: TPanel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    grp1: TGroupBox;
    lstAttributes: TCheckListBox;
    chkSelectAll: TCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure chkSelectAllClick(Sender: TObject);
  private
    MSExcel: OLEVariant;
    lstParametrs: Variant;
  public

    procedure   MakeList ();

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmReportByWells: TfrmReportByWells;

implementation

uses Facade, ComObj, DateUtils;

{$R *.dfm}

{ TForm1 }

constructor TfrmReportByWells.Create(AOwner: TComponent);
begin
  inherited;
  MakeList;
end;

destructor TfrmReportByWells.Destroy;
begin

  inherited;
end;

procedure TfrmReportByWells.MakeList;
var sFilter: string;
    i: Integer;
begin
  // ������ ���������� �� ��������
  // 0 - �������������
  // 1 - ������� �������� ��������
  // 2 - �������� �������� � �����

  lstParametrs := varArrayCreate([0, 3, 0, 48], varVariant);

  lstParametrs[0 ,0] := 0;
  lstParametrs[1, 0] := 'UIN';
  lstParametrs[2, 0] := '';

  lstParametrs[0 ,1] := 1;
  lstParametrs[1, 1] := '��������';
  lstParametrs[2, 1] := '';

  lstParametrs[0 ,2] := 2;
  lstParametrs[1, 2] := '�����';
  lstParametrs[2, 2] := '';

  lstParametrs[0 ,3] := 3;
  lstParametrs[1, 3] := '���������� �����';
  lstParametrs[2, 3] := '';

  lstParametrs[0 ,4] := 4;
  lstParametrs[1, 4] := '������� ��������';
  lstParametrs[2, 4] := '';

  // ---------------------------------------------------------------------------

  lstParametrs[0, 5] := 5;
  lstParametrs[1, 5] := '���������';
  lstParametrs[2, 5] := '';

  lstParametrs[0 ,6] := 6;
  lstParametrs[1, 6] := '���������';
  lstParametrs[2, 6] := '';

  lstParametrs[0 ,7] := 7;
  lstParametrs[1, 7] := '���� ����������';
  lstParametrs[2, 7] := '';

  lstParametrs[0, 8] := 8;
  lstParametrs[1, 8] := '������� ���������� (����. ���)';
  lstParametrs[2, 8] := '';

  lstParametrs[0 ,9] := 9;
  lstParametrs[1, 9] := '���� ������ �������';
  lstParametrs[2, 9] := '';

  lstParametrs[0 ,10] := 10;
  lstParametrs[1, 10] := '���� ��������� �������';
  lstParametrs[2, 10] := '';

  // ---------------------------------------------------------------------------

  lstParametrs[0, 11] := 11;
  lstParametrs[1, 11] := '��������� ������';
  lstParametrs[2, 11] := '';

  lstParametrs[0, 12] := 12;
  lstParametrs[1, 12] := '��������� �����';
  lstParametrs[2, 12] := '';

  lstParametrs[0, 13] := 13;
  lstParametrs[1, 13] := '��������� ����';
  lstParametrs[2, 13] := '';

  lstParametrs[0, 14] := 14;
  lstParametrs[1, 14] := '��������� �����';
  lstParametrs[2, 14] := '';

  lstParametrs[0, 15] := 15;
  lstParametrs[1, 15] := '��������� �����';
  lstParametrs[2, 15] := '';

  // ------------ ��������� �������� -------------------------------------------

  lstParametrs[0, 16] := 16;
  lstParametrs[1, 16] := '���';
  lstParametrs[2, 16] := '';

  lstParametrs[0, 17] := 17;
  lstParametrs[1, 17] := '���';
  lstParametrs[2, 17] := '';

  lstParametrs[0, 18] := 18;
  lstParametrs[1, 18] := '���';
  lstParametrs[2, 18] := '';

  lstParametrs[0, 19] := 19;
  lstParametrs[1, 19] := '�������� ��������������� �������';
  lstParametrs[2, 19] := '';

  lstParametrs[0, 20] := 20;
  lstParametrs[1, 20] := '������ �������� ������������� ���������';
  lstParametrs[2, 20] := '';

  lstParametrs[0, 21] := 21;
  lstParametrs[1, 21] := '�������� ������������� �������';
  lstParametrs[2, 21] := '';

  lstParametrs[0, 22] := 22;
  lstParametrs[1, 22] := '�������� ���������������������� ���������';
  lstParametrs[2, 22] := '';

  lstParametrs[0, 23] := 23;
  lstParametrs[1, 23] := '�������� �������������';
  lstParametrs[2, 23] := '';

  // ------------ ����������� ���������� ---------------------------------------

  lstParametrs[0, 24] := 24;
  lstParametrs[1, 24] := '����������� �������';
  lstParametrs[2, 24] := '';

  lstParametrs[0, 25] := 25;
  lstParametrs[1, 25] := '������� �������� ��������� �� ����� (����������������� ������)';
  lstParametrs[2, 25] := '';

  lstParametrs[0, 26] := 26;
  lstParametrs[1, 26] := '������� �������� ��������� �� ����� (��������)';
  lstParametrs[2, 26] := '';

  lstParametrs[0, 27] := 27;
  lstParametrs[1, 27] := '��������������';
  lstParametrs[2, 27] := '';

  lstParametrs[0, 28] := 28;
  lstParametrs[1, 28] := '����������� ��������� (���.)';
  lstParametrs[2, 28] := '';

  lstParametrs[0, 29] := 29;
  lstParametrs[1, 29] := '��������� �������';
  lstParametrs[2, 29] := '';

  // --------------- ��������� ���������� --------------------------------------

  lstParametrs[0, 30] := 30;
  lstParametrs[1, 30] := '��������� ��������� (���.)';
  lstParametrs[2, 30] := '';

  lstParametrs[0, 31] := 31;
  lstParametrs[1, 31] := '��������� �������';
  lstParametrs[2, 31] := '';

  lstParametrs[0, 32] := 32;
  lstParametrs[1, 32] := '��������� �������� (����������������� ������)';
  lstParametrs[2, 32] := '';

  lstParametrs[0, 33] := 33;
  lstParametrs[1, 33] := '��������� �������� (��������)';
  lstParametrs[2, 33] := '';

  lstParametrs[0, 34] := 34;
  lstParametrs[1, 34] := '������� ����������';
  lstParametrs[2, 34] := '';

  //----------------------------------------------------------------------------

  lstParametrs[0, 35] := 35;
  lstParametrs[1, 35] := '���� ������ �������������';
  lstParametrs[2, 35] := '';

  lstParametrs[0, 36] := 36;
  lstParametrs[1, 36] := '���� ��������� �������������';
  lstParametrs[2, 36] := '';

  //----------------------------------------------------------------------------

  lstParametrs[0, 37] := 37;
  lstParametrs[1, 37] := '�������';
  lstParametrs[2, 37] := '';

  lstParametrs[0, 38] := 38;
  lstParametrs[1, 38] := '�������� ���������';
  lstParametrs[2, 38] := '';

  //----------------------------------------------------------------------------

  lstParametrs[0, 39] := 39;
  lstParametrs[1, 39] := '������ �������� �������������� ������������';
  lstParametrs[2, 39] := '';

  lstParametrs[0, 40] := 40;
  lstParametrs[1, 40] := '������ �������� �������������� ������';
  lstParametrs[2, 40] := '';

  lstParametrs[0, 41] := 41;
  lstParametrs[1, 41] := '������ �������� �������������� �����������';
  lstParametrs[2, 41] := '';

  lstParametrs[0, 42] := 42;
  lstParametrs[1, 42] := '������ �������� ���������������� ������������';
  lstParametrs[2, 42] := '';

  lstParametrs[0, 43] := 43;
  lstParametrs[1, 43] := '������ �������� ���������������� ������';
  lstParametrs[2, 43] := '';

  lstParametrs[0, 44] := 44;
  lstParametrs[1, 44] := '������ �������� ���������������� �����������';
  lstParametrs[2, 44] := '';

  //----------------------------------------------------------------------------

  lstParametrs[0, 45] := 45;
  lstParametrs[1, 45] := '���� ����� ������';
  lstParametrs[2, 45] := '';

  lstParametrs[0, 46] := 46;
  lstParametrs[1, 46] := '���� ��������� ���������';
  lstParametrs[2, 46] := '';

  lstParametrs[0, 47] := 47;
  lstParametrs[1, 47] := '������� ��������� ���������';
  lstParametrs[2, 47] := '';

  for i := 0 to 47 do
    lstAttributes.AddItem(lstParametrs[1, i], nil);
end;

procedure TfrmReportByWells.btnOkClick(Sender: TObject);
var i, j, CheckedCount, iChecked: Integer;
    lstObjects: Variant;
begin
  CheckedCount := 0;

  for i := 0 to lstAttributes.Count - 1 do
  if lstAttributes.Checked[i] then
    Inc (CheckedCount);

  lstObjects := VarArrayCreate([0, 3, 0, CheckedCount], varVariant);

  iChecked := 0;

  for i := 0 to lstAttributes.Count - 1 do
  if lstAttributes.Checked[i] then
  begin
    for j := 0 to varArrayHighBound(lstParametrs, 2) - 1 do
    if lstParametrs[1, j] = lstAttributes.Items[i] then
    begin
      lstObjects[0, iChecked] := lstParametrs[0 ,j];
      lstObjects[1, iChecked] := lstParametrs[1, j];
      lstObjects[2, iChecked] := lstParametrs[2, j];

      Inc(iChecked);

      Break;
    end;
  end;

  if CheckedCount > 0 then
  begin
    try
      MSExcel := CreateOleObject('Excel.Application');
    except
      Exception.Create('Error');
    end;

    MSExcel.WorkBooks.Add;

    // ������� �������� �����

    // ���������
    for i := 0 to varArrayHighBound(lstObjects, 2) - 1 do
      MSExcel.Cells[1, i + 1].value := lstObjects[1, i];

    // ���������� ��������
    for i := 0 to (TMainFacade.GetInstance as TMainFacade).ActiveWells.Count - 1 do
    for j := 0 to varArrayHighBound(lstObjects, 2) - 1 do
    case lstObjects[0, j] of
      0 : // UIN
          MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].ID;

      1 : // �������� �������
          MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].Area.List;

      2 : // ����� ��������
          MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].NumberWell;

      3 : // ���������� ����� ��������
          MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].PassportNumberWell;

      4 : // ������� �������� ��������
          MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].Name;

      5 : // ��������� ��������
          MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].Category.List;

      6 : // ��������� ��������
          MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].State.List();

      7 : // ���� ����������
          if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].AbandonReason) then
            MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].AbandonReason.DtLiquidation;

      8 : // ������� ���������� (����. ���)
          if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].AbandonReason) then
            MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].AbandonReason.Name;

      9 : // ���� ������ �������
          if YearOf((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].DtDrillingStart) <> 1899 then
            MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].DtDrillingStart;

      10 : // ���� ��������� �������
           if YearOf((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].DtDrillingFinish) <> 1899 then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].DtDrillingFinish;

      11 : // ��������� ������
           ;

      12 : // ��������� �����
           ;

      13 : // ��������� ����
           ;

      14 : // ��������� �����
           ;

      15 : // ��������� �����
           ;
           
      16 : // ���
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition) then
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.NGR) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.NGR.List();

      17 : // ���
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition) then
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.NGR) then
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.NGR.MainPetrolRegion) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.NGR.MainPetrolRegion.List();

      18 : // ���
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition) then
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.NGR) then
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.NGR.MainPetrolRegion) then
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.NGR.MainPetrolRegion.MainPetrolRegion) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.NGR.MainPetrolRegion.MainPetrolRegion.List();

      19 : // �������� ��������������� �������
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition) then
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.District) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.District.List;

      20 : // ������ �������� ������������� ���������
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition) then
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.TectonicStructure) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.TectonicStructure.List;

      (*
      21 : // �������� ������������� �������
            if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition) then
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.LicZone) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.LicZone.List;

      22 : // �������� ���������������������� ���������
           (* if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition) then
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.Structure) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.Structure.List; 

      23 : // �������� �������������
           (* if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition) then
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.Field) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellPosition.Field.List;  *)

      24 : // ����������� �������
           MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TrueDepth;

      25 : // ������� �������� ��������� �� ����� (����������������� ������)
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TrueStraton) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TrueStraton.List();

      26 : // ������� �������� ��������� �� ����� (��������)
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TrueStraton) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TrueStraton.Taxonomy.List();

      27 : // ��������������
           ;

      28 : // ����������� ��������� (���.)
           MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TrueCost;

      29 : // ��������� �������
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].FluidType) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].FluidType.List();

      30 : // ��������� ��������� (���.)
           MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TargetCost;

      31 : // ��������� �������
           MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TargetDepth;

      32 : // ��������� �������� (����������������� ������)
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TargetStraton) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TargetStraton.List();

      33 : // ��������� �������� (��������)
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TargetStraton) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].TargetStraton.Taxonomy.List();

      34 : // ������� ����������
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].FluidTypeByBalance) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].FluidTypeByBalance.List();

      35 : // ���� ������ �������������
           if YearOf((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].DtConstructionStart) <> 1899 then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].DtConstructionStart;

      36 : // ���� ��������� �������������
           if YearOf((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].DtConstructionFinish) <> 1899 then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].DtConstructionFinish;

      37 : // �������
           if Assigned ((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].Profile) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].Profile.List();

      38 : // �������� ���������
           ;
           
      39 : // ������ �������� �������������� ������������
           if (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.Count > 0 then
           if Assigned((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[3]) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[3].Organization.List;

      40 : // ������ �������� �������������� ������
           if (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.Count > 0 then
           if Assigned((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[5]) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[5].Organization.List;

      41 : // ������ �������� �������������� �����������
           if (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.Count > 0 then
           if Assigned((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[7]) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[7].Organization.List;

      42 : // ������ �������� ���������������� ������������
           if (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.Count > 0 then
           if Assigned((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[4]) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[4].Organization.List;

      43 : // ������ �������� ���������������� ������
           if (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.Count > 0 then
           if Assigned((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[6]) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[6].Organization.List;

      44 : // ������ �������� ���������������� �����������
           if (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.Count > 0 then
           if Assigned((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[8]) then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].WellOrgStatuses.ItemsByIDStatus[8].Organization.List;

      45 : // ���� ����� ������
           if YearOf((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].EnteringDate) <> 1899 then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].EnteringDate;

      46 : // ���� ��������� ���������
           if YearOf((TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].LastModifyDate) <> 1899 then
             MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].LastModifyDate;

      47 : // ������� ��������� ���������
           MSExcel.Cells[i + 2, j + 1].value := (TMainFacade.GetInstance as TMainFacade).ActiveWells.Items[i].DtConstructionFinish;
    end;

    MSExcel.Visible := True;
  end
  else MessageBox(0, '�� ������ �� ���� ������� ��� ������������ ������!', '������', MB_OK + MB_ICONERROR + MB_APPLMODAL);
end;

procedure TfrmReportByWells.chkSelectAllClick(Sender: TObject);
var i : Integer;
    flCheck : Boolean;
begin
  if chkSelectAll.Checked then flCheck := True else flCheck := False;

  for i := 0 to lstAttributes.Items.Count - 1 do
    lstAttributes.Checked[i] := flCheck;
end;

end.
