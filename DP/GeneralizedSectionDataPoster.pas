unit GeneralizedSectionDataPoster;

interface

uses
  PersistentObjects, DBGate, BaseObjects, DB, Straton, Area, Well;

type
  TGeneralizedSectionSlottingDataPoster = class(TImplementedDataPoster)
  private
    FAreas: TSimpleAreas;
    FWellCategories: TWellCategories;
    FSimpleStratons: TSimpleStratons;
  public
    property AllAreas: TSimpleAreas read FAreas write FAreas;
    property AllWellCategories: TWellCategories read FWellCategories write FWellCategories;
    property AllStratons: TSimpleStratons read FSimpleStratons write FSimpleStratons;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

  TGeneralizedSectionDataPoster = class(TImplementedDataPoster)
  private
    FAllStratons: TSimpleStratons;
  public
    property AllStratons: TSimpleStratons read FAllStratons write FAllStratons;
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

  TGeneralizedSectionSlottingPlacementDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    constructor Create; override;
  end;

implementation

uses
  GeneralizedSection, Facade, SysUtils, Variants, SlottingWell;

{ TGeneralizedSectionDataPoster }

constructor TGeneralizedSectionDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_GENERALIZED_SECTION';

  KeyFieldNames := 'SECTION_ID';
  FieldNames := 'SECTION_ID, VCH_SECTION_NAME, TOP_STRATON_ID, BASE_STRATON_ID';

  AccessoryFieldNames := 'SECTION_ID, VCH_SECTION_NAME, TOP_STRATON_ID, BASE_STRATON_ID';
  AutoFillDates := false;

  Sort := 'VCH_SECTION_NAME';

end;

function TGeneralizedSectionDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TGeneralizedSectionDataPoster.GetFromDB(AFilter: string; AObjects: TIdObjects): integer;
var
  ds: TDataSet;
  s: TGeneralizedSection;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TGeneralizedSection;

      s.ID := ds.FieldByName('Section_ID').AsInteger;
      s.Name := trim(ds.FieldByName('vch_Section_Name').AsString);

      if Assigned(AllStratons) then
      begin
        s.TopStraton := AllStratons.ItemsByID[ds.FieldByName('Top_Straton_ID').AsInteger] as TSimpleStraton;
        s.BaseStraton := AllStratons.ItemsByID[ds.FieldByName('Base_Straton_ID').AsInteger] as TSimpleStraton;
      end;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TGeneralizedSectionDataPoster.PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer;
var
  ds: TDataSet;
  s: TGeneralizedSection;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  s := AObject as TGeneralizedSection;

  ds.FieldByName('Section_ID').AsInteger := s.ID;
  ds.FieldByName('vch_Section_Name').AsString := trim(s.Name);
  if Assigned(s.TopStraton) then
    ds.FieldByName('Top_Straton_ID').AsInteger := s.TopStraton.ID
  else
    ds.FieldByName('Top_Straton_ID').Value := null;

  if Assigned(s.BaseStraton) then
    ds.FieldByName('Base_Straton_ID').AsInteger := s.BaseStraton.ID
  else
    ds.FieldByName('Base_Straton_ID').Value := null;

  ds.Post;

  if s.ID = 0 then
    s.ID := ds.FieldByName('Section_ID').AsInteger;
end;

{ TGeneralizedSectionSlottingDataPoster }

constructor TGeneralizedSectionSlottingDataPoster.Create;
begin
  inherited;

  Options := [];
  DataSourceString := 'VW_GEN_SECTION_SLOTTING';
  DataPostString := 'TBL_GEN_SECTION_SLOTTING';
  DataDeletionString := 'TBL_GEN_SECTION_SLOTTING';

  KeyFieldNames := 'Slotting_UIN; Section_ID';
  FieldNames := 'WELL_UIN, AREA_ID, VCH_AREA_NAME, VCH_WELL_NUM, NUM_TRUE_DEPTH, WELL_CATEGORY_ID, VCH_CATEGORY_NAME, ' + 'SLOTTING_UIN, VCH_SLOTTING_NUMBER, NUM_SLOTTING_TOP, NUM_SLOTTING_BOTTOM, NUM_CORE_YIELD, NUM_DIAMETER, ' + 'NUM_CORE_FINAL_YIELD, DTM_KERN_TAKE_DATE, SECTION_ID, VCH_SECTION_NAME, STRATON_ID, VCH_SUBS_STRATON_INDEX, NUM_MIN_BOX_NUMBER, NUM_MAX_BOX_NUMBER';

  AccessoryFieldNames := 'Slotting_UIN, Section_ID';
  AutoFillDates := false;

  Sort := 'NUM_MIN_BOX_NUMBER, NUM_MAX_BOX_NUMBER, VCH_AREA_NAME, VCH_WELL_NUM, NUM_SLOTTING_TOP, NUM_SLOTTING_BOTTOM';
end;

function TGeneralizedSectionSlottingDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
var
  ds: TCommonServerDataSet;
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

function TGeneralizedSectionSlottingDataPoster.GetFromDB(AFilter: string; AObjects: TIdObjects): integer;
var
  ds: TDataSet;
  s: TGeneralizedSectionSlotting;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TGeneralizedSectionSlotting;
      s.ID := ds.FieldByName('Slotting_UIN').AsInteger;
      // материализуем всё, чтобы отчёты можно было генерировать
      s.Name := trim(ds.FieldByName('VCH_SLOTTING_NUMBER').AsString);
      s.Top := ds.FieldByName('NUM_SLOTTING_TOP').AsFloat;
      s.Bottom := ds.FieldByName('NUM_SLOTTING_BOTTOM').AsFloat;
      s.CoreYield := ds.FieldByName('NUM_CORE_YIELD').AsFloat;
      s.Diameter := ds.FieldByName('NUM_DIAMETER').AsFloat;
      s.CoreFinalYield := ds.FieldByName('NUM_CORE_FINAL_YIELD').AsFloat;
      s.CoreTakeDate := ds.FieldByName('DTM_KERN_TAKE_DATE').AsDateTime;
      if Assigned(AllStratons) then
        s.Straton := AllStratons.ItemsByID[ds.FieldByName('STRATON_ID').AsInteger] as TSimpleStraton;

      s.SubDivisionStratonName := ds.FieldByName('VCH_SUBS_STRATON_INDEX').AsString;

      s.Well := TSlottingWell.Create(nil);
      with s.Well do
      begin
        ID := ds.FieldByName('Well_UIN').AsInteger;
        NumberWell := Trim(ds.FieldByName('VCH_WELL_NUM').AsString);
        TrueDepth := ds.FieldByName('NUM_TRUE_DEPTH').AsFloat;
        if Assigned(AllAreas) then
          Area := AllAreas.ItemsByID[ds.FieldByName('AREA_ID').AsInteger] as TSimpleArea;
        if Assigned(AllWellCategories) then
          Category := AllWellCategories.ItemsByID[ds.FieldByName('WELL_CATEGORY_ID').AsInteger] as TWellCategory;
      end;

      ds.Next;
    end;
    ds.First;
  end;
end;

function TGeneralizedSectionSlottingDataPoster.PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer;
var
  s: TGeneralizedSectionSlotting;
  ds: TDataSet;
begin
  Result := 0;
  s := AObject as TGeneralizedSectionSlotting;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;
    if ds.Locate(KeyFieldNames, varArrayOf([AObject.ID, s.Collection.Owner.ID]), []) then
      ds.Edit
    else
      ds.Append;
  except
    on E: Exception do
    begin
      raise;
    end;
  end;

  ds.FieldByName('SLOTTING_UIN').AsInteger := s.ID;
  ds.FieldByName('SECTION_ID').AsInteger := s.Collection.Owner.ID;
  ds.Post;
end;

{ TGeneralizedSectionSlottingPlacementDataPoster }

constructor TGeneralizedSectionSlottingPlacementDataPoster.Create;
begin
  inherited;

  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'VW_GEN_SECTION_SLT_PLACEMENT';

  KeyFieldNames := 'SECTION_ID';
  FieldNames := 'SECTION_ID, NUM_CORE_FINAL_YIELD,NUM_BOX_COUNT,VCH_RACK_LIST,NUM_CORE_YIELD, VCH_TRANSFER_HISTORY';

  AccessoryFieldNames := 'SECTION_ID, NUM_CORE_FINAL_YIELD,NUM_BOX_COUNT,VCH_RACK_LIST,NUM_CORE_YIELD';
  AutoFillDates := false;

  Sort := 'SECTION_ID';
end;

function TGeneralizedSectionSlottingPlacementDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TGeneralizedSectionSlottingPlacementDataPoster.GetFromDB(AFilter: string; AObjects: TIdObjects): integer;
var
  ds: TDataSet;
  sp: TGeneralizedSectionSlottingPlacement;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      sp := AObjects.Add as TGeneralizedSectionSlottingPlacement;

      sp.ID := ds.FieldByName('Section_ID').AsInteger;

      sp.CoreFinalYield := ds.FieldByName('NUM_CORE_FINAL_YIELD').AsFloat;
      sp.CoreYield := ds.FieldByName('NUM_CORE_YIELD').AsFloat;
      sp.FinalBoxCount := ds.FieldByName('NUM_BOX_COUNT').AsInteger;
      sp.RackList := Trim(ds.FieldByName('VCH_RACK_LIST').AsString);
      sp.TransferHistory := Trim(ds.FieldByName('VCH_TRANSFER_HISTORY').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TGeneralizedSectionSlottingPlacementDataPoster.PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.

