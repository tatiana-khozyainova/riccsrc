unit RRManagerStructureInfoForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FramesWizard, RRManagerEditMainStructureInfoFrame, RRmanagerBaseObjects,
  RRManagerDiscoveredStructureInfo, RRManagerPreparedStructureInfo,
  RRManagerDrilledStructureInfo, RRManagerEditMainFieldInfoFrame, ClientCommon, 
  RRManagerEditHistoryFrame, RRManagerBaseGUI, RRManagerCommon, RRManagerEditDocumentsFrame;

type
  TfrmStructureInfo = class(TCommonForm)
    DialogFrame1: TDialogFrame;
  private
    FAreaID: integer;
    FPetrolRegionID: integer;
    FTectStructID: integer;
    FDistrictID: integer;
    FOrganizationID: integer;
    procedure SetAreaID(const Value: integer);
    procedure SetPetrolRegionID(const Value: integer);
    procedure SetTectStructID(const Value: integer);
    procedure SetDistrictID(const Value: integer);
    procedure SetOrganizationID(const Value: integer);
    { Private declarations }
  protected
    function  GetDlg: TDialogFrame; override;
    procedure NextFrame(Sender: TObject); override;
    function  GetEditingObjectName: string; override;
  public
    { Public declarations }
    property    AreaID: integer read FAreaID write SetAreaID;
    property    PetrolRegionID: integer read FPetrolRegionID write SetPetrolRegionID;
    property    TectStructID: integer read FTectStructID write SetTectStructID;
    property    DistrictID: integer read FDistrictID write SetDistrictID;
    property    OrganizationID: integer read FOrganizationID write SetOrganizationID;
    procedure   Prepare;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmStructureInfo: TfrmStructureInfo;


implementation

uses RRManagerEditParamsFrame, Facade;

{$R *.DFM}


constructor TfrmStructureInfo.Create(AOwner: TComponent);
begin
  inherited;
//  Prepare;

  Width := 1000;
  Height := 700;
end;


function TfrmStructureInfo.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmStructureInfo.GetEditingObjectName: string;
begin
  Result := 'Стурктура';
end;

procedure TfrmStructureInfo.NextFrame;
var i, iStructureType: integer;
    cls: TbaseFrameClass;
    e: boolean;
    frm: TBaseFrame;
begin
  if  (dlg.ActiveFrameIndex = 0)
  and ((dlg.Frames[0] as TfrmMainStructureInfo).cmbxStructureType.ItemIndex > -1) then
  begin
    with (dlg.Frames[0] as TfrmMainStructureInfo).cmbxStructureType do
      iStructureType := Integer(Items.Objects[ItemIndex]);

    cls := nil;
    case iStructureType of
    // Выявленные
    1: cls := TfrmDiscoveredStructureInfo;
    // подгтовленные
    2: cls := TfrmPreparedStructureInfo;
    // в бурении
    3: cls := TfrmDrilledStructureInfo;
    // месторождения
    4: cls := TfrmMainFieldInfo;
    end;

    if not (dlg.Frames[1] is cls) then
    begin
      e := (dlg.Frames[1] as TBaseFrame).Edited;
      // добавяляем нормальные фрэймы
      for i := dlg.FrameCount - 1 downto 1 do
        dlg.Delete(i);

      if Assigned(cls) then
      begin
        frm := dlg.AddFrame(cls) as TBaseFrame;
        frm.Edited := e;
      end;

      // добавляем остальные разные
      // если был новый элемент истории
      with (dlg.Frames[0] as TfrmMainStructureInfo) do
      if Assigned(Structure) and (Structure.History.Count > 0)
      and assigned(Structure.LastHistoryElement) then 
      begin
        frm := dlg.AddFrame(TfrmHistory) as TBaseFrame;
        frm.Edited := e;

        dlg.FinishEnableIndex := 2;
      end;

      frm := dlg.AddFrame(TfrmParams) as TBaseFrame;
      frm.Edited := e;
      //frm := dlg.AddFrame(TfrmDocuments) as TBaseFrame;
      //frm.Edited := e;

    end;
  end;

  inherited;
end;

procedure TfrmStructureInfo.Prepare;
begin
  dlg.Clear;
  dlg.AddFrame(TfrmMainStructureInfo);
  // добавляем игрушечный фрэйм просто, чтоб можно было дяльше идти
  { DONE : Выяснить какие чаще попадаются.  Те и добавлять. }
  dlg.AddFrame(TfrmMainStructureInfo);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 1;  
end;

procedure TfrmStructureInfo.SetAreaID(const Value: integer);
begin
  if FAreaID <> Value then
  begin
    FAreaID := Value;
    (dlg.Frames[0] as TfrmMainStructureInfo).cmplxNewArea.AddItem(FAreaID, GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_AREA_DICT'].Dict, FAreaID));
    (dlg.Frames[0] as TfrmMainStructureInfo).cmplxNewAreacmbxNameChange(nil);
  end;
end;

procedure TfrmStructureInfo.SetDistrictID(const Value: integer);
begin
  if FDistrictID <> Value then
  begin
    FDistrictID := Value;
    (dlg.Frames[0] as TfrmMainStructureInfo).cmplxDistrict.AddItem(FDistrictID,
                                                                   GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_DISTRICT_DICT'].Dict, FDistrictID));
  end;
end;

procedure TfrmStructureInfo.SetOrganizationID(const Value: integer);
begin
  if FOrganizationID <> Value then
  begin
    FOrganizationID := Value;
    (dlg.Frames[0] as TfrmMainStructureInfo).cmplxOrganization.AddItem(FOrganizationID,
                                                                   GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_ORGANIZATION_DICT'].Dict, FOrganizationID));
  end;
end;

procedure TfrmStructureInfo.SetPetrolRegionID(const Value: integer);
begin
  if FPetrolRegionID <> Value then
  begin
    FPetrolRegionID := Value;
    (dlg.Frames[0] as TfrmMainStructureInfo).cmplxPetrolRegion.AddItem(FPetrolRegionID,
                                                                   GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_PETROLIFEROUS_REGION_DICT'].Dict, FPetrolRegionID));
  end;
end;

procedure TfrmStructureInfo.SetTectStructID(const Value: integer);
begin
  if FTectStructID <> Value then
  begin
    FTectStructID := Value;
    (dlg.Frames[0] as TfrmMainStructureInfo).cmplxTectStruct.AddItem(FTectStructID,
                                                                   GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_TECTONIC_STRUCT_DICT'].Dict, FTectStructID));
  end;
end;

end.
