unit SlottingPlacementDataPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, SlottingPlacement, Organization, CoreTransfer;

type

  TRackDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TPartPlacementTypeDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TPartPlacementDataPoster = class(TImplementedDataPoster)
  private
    FAllPartPlacementTypes: TPartPlacementTypes;
  public
    property AllPartPlacementTypes: TPartPlacementTypes read FAllPartPlacementTypes write FAllPartPlacementTypes;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TSlottingPlacementDataPoster = class(TImplementedDataPoster)
  private
    FPartPlacements: TPartPlacements;
    FAllOrganizations: TOrganizations;
    FAllCoreTransfers: TCoreTransfers;
  public
    property AllPartPlacements: TPartPlacements read FPartPlacements write FPartPlacements;
    property AllOrganizations: TOrganizations read FAllOrganizations write FAllOrganizations;
    property AllCoreTransfers: TCoreTransfers read FAllCoreTransfers write FAllCoreTransfers;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TBoxPictureDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TBoxDataPoster = class(TImplementedDataPoster)
  protected
    // локальная сортировка
    procedure LocalSort(AObjects: TIDObjects); override;
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TSlottingBoxDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TWellBoxDataPoster = class(TImplementedDataPoster)
  private
    FRacks: TRacks;
  public
    property Racks: TRacks read FRacks write FRacks;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TPlacementQualityDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    constructor Create; override;
  end;

implementation

uses Facade, SysUtils, Slotting, Variants, ClientCommon, Well, StrUtils, GeneralizedSection;

function SortBoxes(Item1, Item2: Pointer): Integer;
var b1, b2: TBox;
    iNum1, iNum2: integer;
begin
  Result := 0;
  b1 := TBox(Item1);
  b2 := TBox(Item2);

  // косяк
  try
    iNum1 := ExtractInt(b1.Name);
  except
    iNum1 := 0;
  end;

  try
    iNum2 := ExtractInt(b2.Name);
  except
    iNum2 := 0;
  end;

  if iNum1 > iNum2 then Result := 1
  else if iNum1 < iNum2 then Result := -1
  else if iNum1 = iNum2 then
  begin
    if b1.Name > b2.Name then Result := 1
    else if b1.Name < b2.Name then Result := -1
    else Result := 0;
  end;
end;

{ TPartPlacementTypeDataPoster }

constructor TPartPlacementTypeDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_Part_Placement_Property';

  KeyFieldNames := 'Placement_Property_ID';
  FieldNames := 'Placement_Property_ID, vch_Placement_Property_Name';

  AccessoryFieldNames := 'Placement_Property_ID, vch_Placement_Property_Name';
  AutoFillDates := false;

  Sort := 'vch_Placement_Property_Name';
end;

function TPartPlacementTypeDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TPartPlacementTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TPartPlacementType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TPartPlacementType;

      s.ID := ds.FieldByName('Placement_Property_ID').AsInteger;
      s.Name := trim(ds.FieldByName('vch_Placement_Property_Name').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TPartPlacementTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    p: TPartPlacementType;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  p := AObject as TPartPlacementType;

  ds.FieldByName('Placement_Property_ID').AsInteger := p.ID;
  ds.FieldByName('vch_Placement_Property_Name').AsString := trim(p.Name);

  ds.Post;

  if p.ID = 0 then
    p.ID := ds.FieldByName('Placement_Property_ID').AsInteger;
end;

{ TPartPlacementDataPoster }

constructor TPartPlacementDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_Part_Placement_Dict';

  KeyFieldNames := 'Part_Placement_ID';
  FieldNames := 'Part_Placement_ID, vch_Part_Placement, Placement_Property_ID, Main_Placement_ID';

  AccessoryFieldNames := 'Part_Placement_ID, vch_Part_Placement, Placement_Property_ID, Main_Placement_ID';
  AutoFillDates := false;

  Sort := 'vch_Part_Placement';
end;

function TPartPlacementDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TPartPlacementDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TPartPlacement;
begin
  Result := inherited GetFromDB(AFilter, AObjects);

  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TPartPlacement;

      s.ID := ds.FieldByName('Part_Placement_ID').AsInteger;
      s.Name := trim(ds.FieldByName('vch_Part_Placement').AsString);
      s.PartPlacementType := AllPartPlacementTypes.ItemsByID[ds.FieldByName('Placement_Property_ID').AsInteger] as TPartPlacementType;
      s.MainPlacementID := ds.FieldByName('Main_Placement_ID').AsInteger; 

      ds.Next;
    end;

    ds.First;
  end;
end;

function TPartPlacementDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TSlottingPlacementDataPoster }

constructor TSlottingPlacementDataPoster.Create;
begin
  inherited;


  Options := [];
  DataSourceString := 'VW_SLOTTING_PLACEMENT';
  DataPostString := 'tbl_Slotting_Placement';
  DataDeletionString := 'tbl_Slotting_Placement';

  KeyFieldNames := 'WELL_UIN';
  FieldNames := 'WELL_UIN, VCH_OWNER_PART_PLACEMENT, VCH_WAREHOUSE_BOX_NUMBERS, NUM_BOX_FINAL_COUNT, STATE_PART_PLACEMENT_ID, NUM_BOX_COUNT, CORE_OWNER_ORGANIZATION_ID, VCH_RACK_LIST_GS, VCH_RACK_LIST, NUM_CORE_FINAL_YIELD, NUM_CORE_YIELD, ' +
                'NUM_CORE_FINAL_YIELD_GS, NUM_CORE_YIELD_GS, NUM_BOX_FINAL_COUNT_GS, VCH_TRANSFER_HISTORY,  CORE_REPLACEMENT_ID, CORE_REPLACEMENT_TASK_ID';

  AccessoryFieldNames := 'WELL_UIN, VCH_OWNER_PART_PLACEMENT, VCH_WAREHOUSE_BOX_NUMBERS, NUM_BOX_FINAL_COUNT, STATE_PART_PLACEMENT_ID, NUM_BOX_COUNT, CORE_OWNER_ORGANIZATION_ID';
  AutoFillDates := false;

  Sort := '';
end;

function TSlottingPlacementDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDb(AObject, ACollection);
end;

function TSlottingPlacementDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TSlottingPlacement;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TSlottingPlacement;

      s.ID := ds.FieldByName('Well_UIN').AsInteger;
      s.StatePartPlacement := AllPartPlacements.ItemsByID[ds.FieldByName('STATE_PART_PLACEMENT_ID').AsInteger] as TPartPlacement;
      s.OwnerPartPlacement := trim(ds.FieldByName('VCH_OWNER_PART_PLACEMENT').AsString);
      s.BoxCount := ds.FieldByName('num_Box_Count').AsInteger;
      s.FinalBoxCount := ds.FieldByName('NUM_BOX_FINAL_COUNT').AsInteger;
      s.FinalBoxCountWithGenSection := ds.FieldByName('NUM_BOX_FINAL_COUNT_GS').AsInteger;

      s.SampleBoxNumbers := trim(ds.FieldByName('VCH_WAREHOUSE_BOX_NUMBERS').AsString);
      s.RackList := trim(ds.FieldByName('VCH_RACK_LIST').AsString);
      s.RackListWithGenSection := trim(ds.FieldByName('VCH_RACK_LIST_GS').AsString);
      s.CoreFinalYield := ds.FieldByName('NUM_CORE_FINAL_YIELD').AsFloat;
      s.CoreYield := ds.FieldByName('NUM_CORE_YIELD').AsFloat;

      s.CoreFinalYieldWithGenSection := ds.FieldByName('NUM_CORE_FINAL_YIELD_GS').AsFloat;
      s.CoreYieldWithGenSection := ds.FieldByName('NUM_CORE_YIELD_GS').AsFloat;
      s.TransferHistory := Trim(ds.FieldByName('VCH_TRANSFER_HISTORY').AsString);

      if Assigned(AllCoreTransfers) then
      begin
        s.LastCoreTransfer := AllCoreTransfers.ItemsByID[ds.FieldByName('CORE_REPLACEMENT_ID').AsInteger];
        if Assigned(s.LastCoreTransfer) then
          s.LastCoreTransferTask := (s.LastCoreTransfer as TCoreTransfer).CoreTransferTasks.ItemsByID[ds.FieldByName('CORE_REPLACEMENT_TASK_ID').AsInteger];
      end;

      if Assigned(AllOrganizations) then
        s.Organization := AllOrganizations.ItemsById[ds.FieldByName('CORE_OWNER_ORGANIZATION_ID').AsInteger] as TOrganization;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TSlottingPlacementDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    s: TSlottingPlacement;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  s := AObject as TSlottingPlacement;

  ds.FieldByName('Well_UIN').AsInteger := s.Owner.ID;
  if not Assigned(s.StatePartPlacement) then s.StatePartPlacement := AllPartPlacements.CoreLibrary;

  ds.FieldByName('STATE_PART_PLACEMENT_ID').AsInteger := s.StatePartPlacement.ID;
  ds.FieldByName('VCH_OWNER_PART_PLACEMENT').AsString := s.OwnerPartPlacement;
  ds.FieldByName('num_Box_Count').AsInteger := s.BoxCount;
  ds.FieldByName('num_Box_Final_Count').AsInteger := s.FinalBoxCount;

  if Assigned(s.Organization) then
    ds.FieldByName('CORE_OWNER_ORGANIZATION_ID').AsInteger := s.Organization.ID
  else
    ds.FieldByName('CORE_OWNER_ORGANIZATION_ID').Value := null;


  ds.Post;

  if s.ID = 0 then
    s.ID := ds.FieldByName('Well_UIN').AsInteger;
end;

{ TBoxDataPoster }

constructor TBoxDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_Box';

  KeyFieldNames := 'Box_UIN';
  FieldNames := 'Box_UIN, vch_Box_Number, Rack_ID';

  AccessoryFieldNames := 'Box_UIN, vch_Box_Number, Rack_ID';
  AutoFillDates := false;

  Sort := '';
end;

function TBoxDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TBoxDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    b: TBox;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      b := AObjects.Add as TBox;
      b.ID := ds.FieldByName('Box_UIN').AsInteger;
      b.BoxNumber := trim(ds.FieldByName('vch_Box_Number').AsString);
      ds.Next;
    end;
    ds.First;
  end;

  LocalSort(AObjects);
end;

procedure TBoxDataPoster.LocalSort(AObjects: TIDObjects);
begin
  AObjects.Sort(SortBoxes);
end;

function TBoxDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var b: TBox;
    ds: TDataSet;
begin
  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    if (ds.Locate(KeyFieldNames, AObject.ID, [])) or (AObject.ID > 0) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  b := AObject as TBox;
  if b.ID >= 0 then
    ds.FieldByName('Box_UIN').AsInteger := b.ID;

  if not (b.Rack is TNullRack) then
    ds.FieldByName('RACK_ID').AsInteger := b.Rack.ID
  else
    ds.FieldByName('RACK_ID').Value := null;

  ds.FieldByName('vch_Box_Number').AsString := b.BoxNumber;

  ds.Post;
  
  if b.ID <= 0 then
    b.ID := ds.FieldByName('Box_UIN').AsInteger;
end;

{ TSlottingBoxDataPoster }

constructor TSlottingBoxDataPoster.Create;
begin
  inherited;
  Options := [];
  DataSourceString := 'vw_Slotting_Box';
  DataPostString := 'tbl_Slotting_Box';
  DataDeletionString := 'tbl_Slotting_Box';

  KeyFieldNames := 'Box_UIN; Slotting_UIN';
  FieldNames := 'Box_UIN, Slotting_UIN, Part_Placement_ID, VCH_BOX_NUMBER, VCH_RACK, VCH_SHELF, VCH_CELL';

  AccessoryFieldNames := 'Box_UIN, Slotting_UIN';
  AutoFillDates := false;

  Sort := '';
end;

function TSlottingBoxDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
begin
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  try
    // находим строку соответствующую ключу
    //ds.Refresh;
    ds.First;
    if ds.Locate(ds.KeyFieldNames, varArrayOf([AObject.ID, AObject.Collection.Owner.ID]), []) then
      ds.Delete
  except
    Result := -1;
  end;
end;

function TSlottingBoxDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    sb: TSlottingBox;
    s: TSlotting;
    w: TWell;
    b: TBox;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Owner as TSlotting;

      w := nil;
      if s.Owner is TWell then
        w := s.Owner as TWell
      else if s is TGeneralizedSectionSlotting then
        w := (s as TGeneralizedSectionSlotting).Well;
        
      b := w.SlottingPlacement.Boxes.ItemsByID[ds.FieldByName('Box_UIN').AsInteger] as TBox;
      if Assigned(b) then
      begin
        sb := AObjects.Add as TSlottingBox;
        sb.Assign(b);
      end;
      ds.Next;
    end;
    ds.First;
  end;
end;

function TSlottingBoxDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var b: TSlottingBox;
    ds: TDataSet;
begin
  Result := 0;
  b := AObject as TSlottingBox;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;
    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, b.Collection.Owner.ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  ds.FieldByName('Box_UIN').AsInteger := b.ID;
  ds.FieldByName('Slotting_UIN').AsInteger := b.Collection.Owner.ID;
  ds.Post;
end;

{ TWellBoxDataPoster }

constructor TWellBoxDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_Box';

  KeyFieldNames := 'Box_UIN';
  FieldNames := 'Box_UIN, vch_Box_Number, Rack_ID';

  AccessoryFieldNames := 'Box_UIN, vch_Box_Number, Rack_ID';
  AutoFillDates := false;

  Sort := '';
end;

function TWellBoxDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TWellBoxDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var
    wb: TWellBox;
    w: TSlottingPlacement;
    ds: TDataSet;
    r: TRack;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      w := AObjects.Owner as TSlottingPlacement;
      wb := w.Boxes.Add as TWellBox;

      wb.ID := ds.FieldByName('Box_UIN').AsInteger;
      wb.BoxNumber := trim(ds.FieldByName('vch_Box_Number').AsString);

      if Assigned(FRacks) then
      begin
        r := Racks.ItemsById[ds.FieldByName('Rack_ID').AsInteger] as TRack;
        if Assigned(r) then
          wb.Rack := r
        else
          wb.Rack := TNullRack.GetInstance;
      end
      else
        wb.Rack := TNullRack.GetInstance;

      ds.Next;
    end;
    ds.First;
  end;
end;

function TWellBoxDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var b: TBox;
    ds: TDataSet;
begin
  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    if (ds.Locate(KeyFieldNames, AObject.ID, [])) or (AObject.ID > 0) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  b := AObject as TBox;
  if b.ID >= 0 then
    ds.FieldByName('Box_UIN').AsInteger := b.ID;

  if Assigned(b.Rack) and (not (b.Rack is TNullRack)) then
    ds.FieldByName('RACK_ID').AsInteger := b.Rack.ID
  else
    ds.FieldByName('RACK_ID').Value := null;
    
  ds.FieldByName('vch_Box_Number').AsString := b.BoxNumber;

  ds.Post;
  
  if b.ID <= 0 then
    b.ID := ds.FieldByName('Box_UIN').AsInteger;
end;

{ TBoxPictureDataPoster }

constructor TBoxPictureDataPoster.Create;
begin
  inherited;

  Options := [soKeyInsert];
  DataSourceString := 'TBL_BOX_PICTURE';
  DataPostString := 'SPD_ADD_BOX_PICTURE';
  DataDeletionString := 'SPD_DELETE_BOX_PICTURE';

  KeyFieldNames := 'BOX_PICTURE_UIN';
  FieldNames := 'BOX_PICTURE_UIN, BOX_UIN, VCH_BOX_PICTURE_PATH';

  AccessoryFieldNames := 'BOX_PICTURE_UIN, BOX_UIN, VCH_BOX_PICTURE_PATH';
  AutoFillDates := false;

  Sort := '';
end;

function TBoxPictureDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TBoxPictureDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    bp: TBoxPicture;
    sLocalName: string;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      bp := AObjects.Add as TBoxPicture;

      bp.ID := ds.FieldByName('BOX_PICTURE_UIN').AsInteger;
      bp.RemoteName := ExtractFileName(ds.FieldByName('VCH_BOX_PICTURE_PATH').AsString);

      sLocalName  := StringReplace(bp.RemoteName, IntToStr(bp.Collection.Owner.ID), '', [rfReplaceAll]);
      while sLocalName[1] = '_' do
        sLocalName := MidStr(sLocalName, 2, Length(sLocalName));

      bp.LocalName := sLocalName; // а localpath будет когда мы куда-нибудь скачаем их


      ds.Next;
    end;
    ds.First;
  end;
end;

function TBoxPictureDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var bp: TBoxPicture;
    ds: TDataSet;
begin
  Result := 0;

  bp := AObject as TBoxPicture;

  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    if (ds.Locate(KeyFieldNames, bp.ID, [])) or (bp.ID > 0) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;

  if bp.ID >= 0 then ds.FieldByName('BOX_PICTURE_UIN').AsInteger := bp.ID;

  ds.FieldByName('BOX_UIN').AsInteger := bp.Collection.Owner.ID;
  ds.FieldByName('VCH_BOX_PICTURE_PATH').AsString := bp.RemoteFullName;


  ds.Post;

  bp.ID := ds.FieldByName('BOX_PICTURE_UIN').AsInteger;
end;

{ TPlacementQualityDataPoster }

constructor TPlacementQualityDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'tbl_Placement_Quality';

  KeyFieldNames := 'PLACEMENT_QUALITY_ID';
  FieldNames := 'PLACEMENT_QUALITY_ID, VCH_PLACEMENT_QUALITY_NAME';

  AccessoryFieldNames := 'PLACEMENT_QUALITY_ID, VCH_PLACEMENT_QUALITY_NAME';
  AutoFillDates := false;

  Sort := '';
end;

function TPlacementQualityDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TPlacementQuality;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TPlacementQuality;

      s.ID := ds.FieldByName('Placement_Quality_ID').AsInteger;
      s.Name := ds.FieldByName('vch_Placement_Quality_Name').AsString;
      ds.Next;
    end;

    ds.First;
  end;
end;

{ TRackDataPoster }

constructor TRackDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'tbl_Rack';

  KeyFieldNames := 'Rack_ID';
  FieldNames := 'Rack_ID, vch_Rack_Name, Part_Placement_ID';

  AccessoryFieldNames := 'Rack_ID, vch_Rack_Name, Part_Placement_ID';
  AutoFillDates := false;

  Sort := 'vch_Rack_Name';
end;

function TRackDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TRackDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TRack;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TRack;

      s.ID := ds.FieldByName('Rack_ID').AsInteger;
      s.Name := trim(ds.FieldByName('vch_Rack_Name').AsString);
      s.ShortName := trim(ds.FieldByName('vch_Rack_Name').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TRackDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
