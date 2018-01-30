unit CoreTransferDataPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Straton, Area, Well, GeneralizedSection;

type

   TCoreTransferTypeDataPoster = class(TImplementedDataPoster)
   public
     function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
     function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
     function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

     constructor Create; override;
   end;

   TCoreTransferDataPoster = class(TImplementedDataPoster)
   public
     function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
     function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
     function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

     constructor Create; override;
   end;

   TCoreTransferTaskDataPoster = class(TImplementedDataPoster)
   private
     FTransferTypes: TIDObjects;
     FPartPlacements: TIDObjects;
     FAreas: TSimpleAreas;
     FWellCategories: TWellCategories;
     FGeneralizedSections: TGeneralizedSections;
     FNewPartPlacements: TIDObjects;
   public
     property OldPartPlacements: TIDObjects read FPartPlacements write FPartPlacements;
     property NewPartPlacements: TIDObjects read FNewPartPlacements write FNewPartPlacements;

     property AllTransferTypes: TIDObjects read FTransferTypes write FTransferTypes;
     property AllAreas: TSimpleAreas read FAreas write FAreas;
     property AllWellCategories: TWellCategories read FWellCategories write FWellCategories;
     property AllGeneralizedSections: TGeneralizedSections read FGeneralizedSections write FGeneralizedSections;


     function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
     function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
     function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

     constructor Create; override;
   end;

implementation

uses CoreTransfer, Facade, SysUtils, Variants, SlottingPlacement, SlottingWell,
  Classes, DateUtils;

{ TCoreTransferTypeDataPoster }

constructor TCoreTransferTypeDataPoster.Create;
begin
  inherited;


  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_CORE_TRANSFER_TYPE_DICT';

  KeyFieldNames := 'CORE_TRANSFER_TYPE_ID';
  FieldNames := 'CORE_TRANSFER_TYPE_ID, VCH_CORE_TRANSFER_TYPE_NAME, VCH_CORE_TRANS_TYPE_SHORT_NAME';

  AccessoryFieldNames := 'CORE_TRANSFER_TYPE_ID, VCH_CORE_TRANSFER_TYPE_NAME, VCH_CORE_TRANS_TYPE_SHORT_NAME';
  AutoFillDates := false;

  Sort := 'CORE_TRANSFER_TYPE_ID';
end;

function TCoreTransferTypeDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TCoreTransferTypeDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    ctt: TCoreTransferType;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      ctt := AObjects.Add as TCoreTransferType;

      ctt.ID := ds.FieldByName('CORE_TRANSFER_TYPE_ID').AsInteger;
      ctt.Name := trim(ds.FieldByName('VCH_CORE_TRANSFER_TYPE_NAME').AsString);
      ctt.ShortName := trim(ds.FieldByName('VCH_CORE_TRANS_TYPE_SHORT_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TCoreTransferTypeDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TCoreTransferDataPoster }

constructor TCoreTransferDataPoster.Create;
begin
  inherited;


  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_CORE_TRANSFER';

  KeyFieldNames := 'CORE_TRANSFER_ID';
  FieldNames := 'CORE_TRANSFER_ID, DTM_CORE_TRANSFER_START_DATE, DTM_CORE_TRANSFER_FINISH_DATE';

  AccessoryFieldNames := 'CORE_TRANSFER_ID, DTM_CORE_TRANSFER_START_DATE, DTM_CORE_TRANSFER_FINISH_DATE';
  AutoFillDates := false;

  Sort := 'DTM_CORE_TRANSFER_START_DATE';
end;

function TCoreTransferDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TCoreTransferDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    ct: TCoreTransfer;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      ct := AObjects.Add as TCoreTransfer;

      ct.ID := ds.FieldByName('CORE_TRANSFER_ID').AsInteger;
      ct.TransferStart := ds.FieldByName('DTM_CORE_TRANSFER_START_DATE').AsDateTime;
      if not ds.FieldByName('DTM_CORE_TRANSFER_FINISH_DATE').IsNull then
        ct.TransferFinish := ds.FieldByName('DTM_CORE_TRANSFER_FINISH_DATE').AsDateTime
      else
        ct.TransferFinish := ct.TransferStart;

      ds.Next;
    end;

    ds.First;
  end;

end;

function TCoreTransferDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    ct: TCoreTransfer;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  ct := AObject as TCoreTransfer;

  ds.FieldByName('CORE_TRANSFER_ID').AsInteger := ct.ID;
  ds.FieldByName('DTM_CORE_TRANSFER_START_DATE').AsString := DateToStr(ct.TransferStart);
  if ct.TransferStart <> ct.TransferFinish then
    ds.FieldByName('DTM_CORE_TRANSFER_FINISH_DATE').AsString := DateToStr(ct.TransferFinish)
  else
    ds.FieldByName('DTM_CORE_TRANSFER_FINISH_DATE').AsString := DateToStr(ct.TransferStart);

  ds.Post;

  if ct.ID = 0 then
    ct.ID := ds.FieldByName('CORE_TRANSFER_ID').AsInteger;
end;

{ TCoreTransferTaskDataPoster }

constructor TCoreTransferTaskDataPoster.Create;
begin
  inherited;

  Options := [soGetKeyValue];
  DataSourceString := 'VW_CORE_TRANSFER_TASK';
  DataPostString := 'TBL_CORE_TRANSFER_TASK';
  DataDeletionString := 'TBL_CORE_TRANSFER_TASK';

  KeyFieldNames := 'CORE_TRANSFER_TASK_ID';
  FieldNames := 'CORE_TRANSFER_TASK_ID, WELL_UIN, AREA_ID, VCH_AREA_NAME, VCH_WELL_NUM, NUM_TRUE_DEPTH, WELL_CATEGORY_ID, VCH_CATEGORY_NAME, ' +
                'SOURCE_PLACEMENT_ID, TARGET_PLACEMENT_ID, CORE_TRANSFER_TYPE_ID, NUM_BOX_COUNT, VCH_BOX_NUMBERS, GEN_SECTION_ID, CORE_TRANSFER_ID';

  AccessoryFieldNames := 'CORE_TRANSFER_TASK_ID, WELL_UIN, SOURCE_PLACEMENT_ID, TARGET_PLACEMENT_ID, CORE_TRANSFER_TYPE_ID, NUM_BOX_COUNT, VCH_BOX_NUMBERS, GEN_SECTION_ID, CORE_TRANSFER_ID';
  AutoFillDates := false;

  Sort := 'CORE_TRANSFER_TYPE_ID, VCH_AREA_NAME, VCH_WELL_NUM';

end;

function TCoreTransferTaskDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TCoreTransferTaskDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    ctt: TCoreTransferTask;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;



    while not ds.Eof do
    begin
      ctt := AObjects.Add as TCoreTransferTask;
      ctt.ID := ds.FieldByName('CORE_TRANSFER_TASK_ID').AsInteger;

      if not ds.FieldByName('Well_UIN').IsNull then
      begin
        ctt.TransferringObject := TSlottingWell.Create(nil);
        with ctt.Well do
        begin
          ID := ds.FieldByName('Well_UIN').AsInteger;
          NumberWell := Trim(ds.FieldByName('VCH_WELL_NUM').AsString);
          TrueDepth := ds.FieldByName('NUM_TRUE_DEPTH').AsFloat;
          if Assigned(AllAreas) then
            Area := AllAreas.ItemsByID[ds.FieldByName('AREA_ID').AsInteger] as TSimpleArea;
          if Assigned(AllWellCategories) then
            Category := AllWellCategories.ItemsByID[ds.FieldByName('WELL_CATEGORY_ID').AsInteger] as TWellCategory;
        end;
      end
      else if not ds.FieldByName('GEN_SECTION_ID').IsNull then
      begin
        if Assigned(AllGeneralizedSections) then
          ctt.TransferringObject := AllGeneralizedSections.ItemsByID[ds.FieldByName('GEN_SECTION_ID').AsInteger] as TGeneralizedSection
        else
          ctt.TransferringObject := nil;
      end;

      if Assigned(OldPartPlacements) then
        ctt.SourcePlacement := OldPartPlacements.ItemsByID[ds.FieldByName('SOURCE_PLACEMENT_ID').AsInteger] as TPartPlacement;

      if Assigned(NewPartPlacements) then
        ctt.TargetPlacement := NewPartPlacements.ItemsByID[ds.FieldByName('TARGET_PLACEMENT_ID').AsInteger] as TPartPlacement;

      if Assigned(AllTransferTypes) then
        ctt.TransferType := AllTransferTypes.ItemsByID[ds.FieldByName('CORE_TRANSFER_TYPE_ID').AsInteger] as TCoreTransferType;


      ctt.BoxCount := ds.FieldByName('NUM_BOX_COUNT').AsInteger;
      ctt.BoxNumbers := ds.FieldByName('VCH_BOX_NUMBERS').AsString;

      ds.Next;
    end;
    ds.First;
  end;
end;

function TCoreTransferTaskDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    ctt: TCoreTransferTask;
begin

  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  ctt := AObject as TCoreTransferTask;

  Assert(Assigned(ctt.CoreTransfer), 'не указан сеанс перемещения');
  Assert(Assigned(ctt.TransferType), 'не указан тип перемещения');
  Assert(Assigned(ctt.TransferringObject), 'не указан перемещаемый объект');


  ds.FieldByName('CORE_TRANSFER_TASK_ID').AsInteger := ctt.ID;

  if Assigned(ctt.Well) then
    ds.FieldByName('WELL_UIN').AsInteger := ctt.Well.ID
  else
    ds.FieldByName('WELL_UIN').Value := null;

  if Assigned(ctt.GenSection) then
    ds.FieldByName('GEN_SECTION_ID').AsInteger := ctt.GenSection.ID
  else
    ds.FieldByName('GEN_SECTION_ID').Value := Null;

  if Assigned(ctt.SourcePlacement) then
    ds.FieldByName('SOURCE_PLACEMENT_ID').AsInteger := ctt.SourcePlacement.ID
  else
    ds.FieldByName('SOURCE_PLACEMENT_ID').Value := null;

  if Assigned(ctt.TargetPlacement) then
    ds.FieldByName('TARGET_PLACEMENT_ID').AsInteger := ctt.TargetPlacement.ID
  else
    ds.FieldByName('TARGET_PLACEMENT_ID').Value := null;

  ds.FieldByName('CORE_TRANSFER_TYPE_ID').AsInteger := ctt.TransferType.ID;

  ds.FieldByName('NUM_BOX_COUNT').AsInteger := ctt.BoxCount;
  ds.FieldByName('VCH_BOX_NUMBERS').AsString := ctt.BoxNumbers;
  ds.FieldByName('CORE_TRANSFER_ID').AsInteger := ctt.CoreTransfer.ID;


  ds.Post;

  ctt.ID := ds.FieldByName('CORE_TRANSFER_TASK_ID').AsInteger;
end;

end.
