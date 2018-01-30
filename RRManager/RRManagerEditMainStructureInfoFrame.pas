unit RRManagerEditMainStructureInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CommonComplexCombo, RRmanagerBaseObjects,
  RRManagerObjects, RRManagerCommon, ComCtrls, ClientCommon, RRManagerBaseGUI,
  FramesWizard;

type
//  TfrmMainStructureInfo = class(TFrame)
  TfrmMainStructureInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    edtStructureName: TEdit;
    lblStrructureName: TLabel;
    lblStrucureType: TLabel;
    cmbxStructureType: TComboBox;
    chbxOutOfFund: TCheckBox;
    cmbxCartoHorizon: TComboBox;
    lblCartoHorizon: TLabel;
    cmplxNewArea: TfrmComplexCombo;
    cmplxPetrolRegion: TfrmComplexCombo;
    cmplxTectStruct: TfrmComplexCombo;
    cmplxDistrict: TfrmComplexCombo;
    cmplxOrganization: TfrmComplexCombo;
    cmplxLicenzeZone: TfrmComplexCombo;
    procedure cmbxStructureTypeChange(Sender: TObject);
    procedure cmplxNewAreacmbxNameChange(Sender: TObject);
    procedure edtStructureNameChange(Sender: TObject);
    procedure edtStructureNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FLastKeyPressed: integer;
    FLastHistoryElementAdded: TOldStructureHistoryElement;
    LastStructureTypeID: integer;
    function GetStructure: TOldStructure;
    function CreateHistoryElement: TOldStructureHistoryElement;
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure FillParentControls; override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
    procedure PreloadObject(ABaseObject: TBaseObject); override;
  public
    { Public declarations }
    property    Structure: TOldStructure read GetStructure;
    constructor Create(AOwner: TComponent); override;
    procedure   Save; override;
    procedure   CancelEdit; override;
  end;

implementation

uses RRManagerStructureInfoForm, Facade;

{$R *.DFM}

{ TfrmMainStructureInfo }

procedure TfrmMainStructureInfo.ClearControls;
begin
  //
  edtStructureName.Clear;
  cmbxStructureType.ItemIndex := -1;
  cmplxPetrolRegion.Clear;
  cmplxNewArea.Clear;
  cmplxTectStruct.Clear;
  cmplxDistrict.Clear;
  cmplxOrganization.Clear;
  cmbxCartoHorizon.Clear;
  cmplxLicenzeZone.Clear;
end;

constructor TfrmMainStructureInfo.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := TOldStructure;


  cmplxNewArea.Caption := 'Площадь';
  cmplxNewArea.FullLoad := true;
  { TODO : Временно, пока не разберусь с ассайном TListItems }
  cmplxNewArea.ShowButton := false;
  cmplxNewArea.DictName := 'TBL_AREA_DICT';

  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxStructureType.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('tbl_Structure_Fund_Type_dict'));


  cmplxPetrolRegion.Caption := 'Нефтегазоносный регион';
  cmplxPetrolRegion.FullLoad := false;
  cmplxPetrolRegion.DictName := 'TBL_PETROLIFEROUS_REGION_DICT';
  cmplxPetrolRegion.MultipleSelect := true;

  cmplxTectStruct.Caption := 'Тектоническая структура';
  cmplxTectStruct.FullLoad := false;
  cmplxTectStruct.DictName := 'TBL_TECTONIC_STRUCT_DICT';
  cmplxTectStruct.MultipleSelect := true;

  cmplxDistrict.Caption := 'Географический регион';
  cmplxDistrict.FullLoad := false;
  cmplxDistrict.DictName := 'TBL_DISTRICT_DICT';
  cmplxDistrict.MultipleSelect := true;

  cmplxOrganization.Caption := 'Организация-недропользователь';
  cmplxOrganization.FullLoad := false;
  cmplxOrganization.DictName := 'TBL_ORGANIZATION_DICT';

  cmplxLicenzeZone.Caption := 'Лицензионный участок';
  cmplxLicenzeZone.FullLoad := true;
  cmplxLicenzeZone.DictName := 'VW_CURRENT_LICENSE_ZONES';
  cmplxLicenzeZone.MultipleSelect := True;
end;

procedure TfrmMainStructureInfo.FillControls(ABaseObject: TBaseObject);
var S: TOldStructure;
begin
  if not Assigned(ABaseObject) then S := Structure
  else S := ABaseObject as TOldStructure;

  FLastHistoryElementAdded := nil;
  LastStructureTypeID := S.StructureTypeID;


  cmbxStructureType.ItemIndex := cmbxStructureType.Items.IndexOfObject(TObject(S.StructureTypeID));
  cmplxNewArea.AddItem(S.AreaID, S.Area);
  cmplxPetrolRegion.AddItems(s.PetrolRegions);
  cmplxTectStruct.AddItems(s.TectonicStructs);
  cmplxDistrict.AddItems(s.Districts);
  cmplxOrganization.AddItem(S.OwnerOrganizationID, S.OwnerOrganization);


  with (Owner as TDialogFrame).Owner as TfrmStructureInfo do
  begin
    AreaID := S.AreaID;
    //PetrolRegionID := S.PetrolRegionID;
    //TectStructID := S.TectonicStructID;
    //DistrictID := S.DistrictID;
    OrganizationID := S.OwnerOrganizationID;
  end;
  cmplxLicenzeZone.AddItems(s.LicenseZones);

  edtStructureName.Text := S.Name;

  chbxOutOfFund.Checked := S.OutOfFund;

  cmbxCartoHorizon.Items.Clear;
  s.Horizons.MakeList(cmbxCartoHorizon.Items, AllOpts.Current.ListOption, false);
  cmbxCartoHorizon.ItemIndex := cmbxCartoHorizon.Items.IndexOfObject(s.CartoHorizon);

  cmbxCartoHorizon.Visible := not (S is TOldField);
  lblCartoHorizon.Visible := not (S is TOldField);
  cmplxOrganization.Visible := not (S is TOldField);
  chbxOutOfFund.Visible := not (S is TOldField);

end;

function TfrmMainStructureInfo.GetStructure: TOldStructure;
begin
  Result := EditingObject as TOldStructure;
end;

procedure TfrmMainStructureInfo.Save;
var iID, i: integer;
begin
  inherited;

  iID := Integer(cmbxStructureType.Items.Objects[cmbxStructureType.ItemIndex]);


  if not Assigned(EditingObject) then
    FEditingObject := (TMainFacade.GetInstance as TMainFacade).AllStructures.Add(iID);

  Structure.StructureTypeID := iID;
  Structure.StructureType := cmbxStructureType.Items[cmbxStructureType.ItemIndex];

  Structure.PetrolRegions.MarkAllDeleted;
  for i := 0 to cmplxPetrolRegion.SelectedElementIDs.Count - 1 do
    Structure.PetrolRegions.Add(TMainFacade.GetInstance.AllPetrolRegions.ItemsByID[Integer(cmplxPetrolRegion.SelectedElementIDs.Objects[i])], false, false);

  Structure.TectonicStructs.MarkAllDeleted;
  for i := 0 to cmplxTectStruct.SelectedElementIDs.Count - 1 do
    Structure.TectonicStructs.Add(TMainFacade.GetInstance.AllTectonicStructures.ItemsByID[Integer(cmplxTectStruct.SelectedElementIDs.Objects[i])], false, false);

  Structure.Districts.MarkAllDeleted;
  for i := 0 to cmplxDistrict.SelectedElementIDs.Count - 1 do
    Structure.Districts.Add(TMainFacade.GetInstance.AllDistricts.ItemsByID[Integer(cmplxDistrict.SelectedElementIDs.Objects[i])], false, false);

  Structure.LicenseZones.MarkAllDeleted;
  for i := 0 to cmplxLicenzeZone.SelectedElementIDs.Count - 1 do
    Structure.LicenseZones.Add(TMainFacade.GetInstance.AllLicenseZones.ItemsByID[Integer(cmplxLicenzeZone.SelectedElementIDs.Objects[i])], false, false);



  Structure.AreaID := cmplxNewArea.SelectedElementID;
  Structure.Area := cmplxNewArea.SelectedElementName;

  Structure.OwnerOrganizationID := cmplxOrganization.SelectedElementID;
  Structure.OwnerOrganization := cmplxOrganization.SelectedElementName;

  Structure.Name := edtStructureName.Text;
  Structure.OutOfFund := chbxOutOfFund.Checked;

  Structure.LastHistoryElement := FLastHistoryElementAdded;

  if cmbxCartoHorizon.ItemIndex > -1 then
    Structure.CartoHorizonID := TOldHorizon(cmbxCartoHorizon.Items.Objects[cmbxCartoHorizon.ItemIndex]).ID
  else
    Structure.CartoHorizonID := -1; 
end;

procedure TfrmMainStructureInfo.cmbxStructureTypeChange(Sender: TObject);
var iLastID, iID, iUIN, iLastIndex: integer;
    sLastFundType: string;
begin
  if cmbxStructureType.ItemIndex > -1 then
  begin
    iID := Integer(cmbxStructureType.Items.Objects[cmbxStructureType.ItemIndex]);
    if Assigned(Structure) then
    begin
      if Structure.StructureTypeID <> iID then
      begin
        iLastID := Structure.StructureTypeID;
        sLastFundType := Structure.StructureType;

        iUIN := EditingObject.ID;

        //iLastIndex := EditingObject.Index;
        //AllStructures.Delete(EditingObject.Index);
        FEditingObject := (TMainFacade.GetInstance as TMainFacade).AllStructures.Add(iID);

        //Insert(iLastIndex, iID);

        (TMainFacade.GetInstance as TMainFacade).AllStructures.NeedsUpdate := true;
        EditingObject.ID := iUIN;

        FLastHistoryElementAdded := CreateHistoryElement;

        if Assigned(FLastHistoryElementAdded) then
        begin
          FLastHistoryElementAdded.LastFundTypeID := iLastID;
          FLastHistoryElementAdded.LastFundType := sLastFundType;
        end;
      end;
    end
    else
    begin
      FEditingObject := (TMainFacade.GetInstance as TMainFacade).AllStructures.Add(iID);
      (TMainFacade.GetInstance as TMainFacade).AllStructures.NeedsUpdate := true;

      FLastHistoryElementAdded := CreateHistoryElement;
      if Assigned(FLastHistoryElementAdded) then
      begin
        FLastHistoryElementAdded.LastFundTypeID := 0;
        FLastHistoryElementAdded.LastFundType := '';
      end;
    end;
  end;
end;

procedure TfrmMainStructureInfo.cmplxNewAreacmbxNameChange(
  Sender: TObject);
begin
  cmplxNewArea.cmbxNameChange(Sender);
  edtStructureName.Text := cmplxNewArea.cmbxName.Text;
  ((Owner as TDialogFrame).Owner as TfrmStructureInfo).AreaID := cmplxNewArea.SelectedElementID;
end;


function TfrmMainStructureInfo.CreateHistoryElement: TOldStructureHistoryElement;
begin
  Result := nil;
  if Assigned(Structure) then
  begin
    // добавляем или обновляем элемент истории
    Result := Structure.History.GetElementByFundType(Integer(cmbxStructureType.Items.Objects[cmbxStructureType.ItemIndex]));
    if not Assigned(Result) then
    begin
      Result := Structure.History.Add;


      // тип действия перевод из фонда в фонд
      Result.ActionTypeID := 1;
      Result.ActionType := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_ACTION_TYPE_DICT'].Dict, Result.ActionTypeID);

      Result.ActionDate := Date;
      Result.RealDate := Date;
      Result.EmployeeID := TMainFacade.GetInstance.DBGates.EmployeeID;

      Result.FundTypeID := Integer(cmbxStructureType.Items.Objects[cmbxStructureType.ItemIndex]);
      Result.FundType := cmbxStructureType.Text;
    end;
  end;
end;

procedure TfrmMainStructureInfo.CancelEdit;
begin
  inherited;
  if Assigned(Structure) then
  begin
    Structure.History.Clear;
    Structure.History.NeedsUpdate := true;
  end;
end;

procedure TfrmMainStructureInfo.RegisterInspector;
begin
  inherited;


  // регистрируем контролы, которые под инспектором
  Inspector.Add(edtStructureName, nil, ptString, 'наименование структуры', false);
  Inspector.Add(cmbxStructureType, nil, ptString, 'вид фонда', false);
  Inspector.Add(cmplxPetrolRegion.cmbxName, nil, ptString, 'нефтегазоносный регион', false);
  Inspector.Add(cmplxLicenzeZone.cmbxName, nil, ptString, 'лицензионный участок', false);

 { if cmplxOrganization.Visible then
    Inspector.Add(cmplxOrganization.cmbxName, nil, ptString, 'организация-недропользователь', false);}
end;

procedure TfrmMainStructureInfo.edtStructureNameChange(Sender: TObject);
//var sTypedText: string;
begin
//  cmplxNewArea.FindSimilarName(edtStructureName.Text);
{
  if trim(AnsiUpperCase(edtStructureName.Text)) <> trim(AnsiUpperCase(cmplxNewArea.cmbxName.Text)) then
  begin
    cmplxNewArea.FindSimilarName(edtStructureName.Text);
    sTypedText := edtStructureName.Text;

    if cmplxNewArea.SelectedElementID > 0 then
    begin
      if not (FLastKeyPressed in [VK_DELETE, VK_BACK]) then
      begin
        edtStructureName.Text := cmplxNewArea.SelectedElementName;
        edtStructureName.SelStart := Length(sTypedText);
        edtStructureName.SelLength := Length(edtStructureName.Text);
      end;
    end;
  end}
end;

procedure TfrmMainStructureInfo.edtStructureNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  FLastKeyPressed := Key;
end;

procedure TfrmMainStructureInfo.FillParentControls;
begin

end;

procedure TfrmMainStructureInfo.PreloadObject(ABaseObject: TBaseObject);
begin
  inherited;

  cmbxCartoHorizon.Items.Clear;
  if Assigned(ABaseObject) then
    (ABaseObject as TOldStructure).Horizons.MakeList(cmbxCartoHorizon.Items, AllOpts.Current.ListOption, false);
end;

end.

