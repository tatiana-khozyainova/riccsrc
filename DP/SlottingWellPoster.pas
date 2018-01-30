unit SlottingWellPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Organization, State, Area, Well;


type

  TSlottingWellDataPoster = class(TImplementedDataPoster)
  private
    FAllOrganizations: TOrganizations;
    FAllAreas: TSimpleAreas;
    FAllWellCategories: TWellCategories;
    FAllWellStates: TStates;
    procedure SetOrganizations(const Value: TOrganizations);
    procedure SetAllAreas(const Value: TSimpleAreas);
    procedure SetAllWellCategories(const Value: TWellCategories);
    procedure SetAllWellStates(const Value: TStates);
  protected
    procedure LocalSort(AObjects: TIDObjects); override;
  public
    property AllOrganizations: TOrganizations read  FAllOrganizations write SetOrganizations;
    property AllWellStates: TStates read FAllWellStates write SetAllWellStates;
    property AllWellCategories: TWellCategories read FAllWellCategories write SetAllWellCategories;
    property AllAreas: TSimpleAreas read FAllAreas write SetAllAreas;
    

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;


implementation

uses SlottingWell, Facade, SysUtils, ClientCommon, Comparers;




{ TWellDataPoster }

constructor TSlottingWellDataPoster.Create;
begin
  inherited;

  Options := [];
  DataSourceString := 'VW_KERN_STATISTICS';
  DataDeletionString := '';
  DataPostString := '';

  KeyFieldNames := 'WELL_UIN';
  FieldNames := 'WELL_UIN, VCH_AREA_NAME, VCH_WELL_NUM, NUM_ROTOR_ALTITUDE, ' +
                'DTM_DRILLING_START, DTM_DRILLING_FINISH, NUM_TRUE_DEPTH, ' +
                'VCH_AGE_CODE, VCH_CATEGORY_NAME, VCH_WELL_STATE_NAME, ' +
                'VCH_REGION_FULL_NAME, VCH_PART_PLACEMENT, VCH_MAIN_PART_PLACEMENT, LICENSE_ORGANIZATION_ID, RE_ORGANIZATION_ID, AREA_ID, WELL_CATEGORY_ID, WELL_STATE_ID, NUM_CORE_FINAL_YIELD, VCH_WELL_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_AREA_NAME, VCH_WELL_NUM';
end;

function TSlottingWellDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; 
begin
  Result := 0;
end;

function TSlottingWellDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSlottingWell;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSlottingWell;
      o.ID := ds.FieldByName('WELL_UIN').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_WELL_NAME').AsString);
      o.NumberWell := trim(ds.FieldByName('VCH_WELL_NUM').AsString);
      o.DtDrillingStart := ds.FieldByName('DTM_DRILLING_START').AsDateTime;
      o.DtDrillingFinish := ds.FieldByName('DTM_DRILLING_FINISH').AsDateTime;
      o.TrueDepth := ds.FieldByName('NUM_TRUE_DEPTH').AsFloat;
      //o.Age := trim(ds.FieldByName('VCH_AGE_CODE').AsString);
      o.Area := FAllAreas.ItemsByID[ds.FieldByName('AREA_ID').AsInteger] as TSimpleArea;
      o.Category := FAllWellCategories.ItemsByID[ds.FieldByName('WELL_CATEGORY_ID').AsInteger] as TWellCategory;
      o.State := FAllWellStates.ItemsByID[ds.FieldByName('WELL_STATE_ID').AsInteger] as TState;
      o.CorePresence := ds.FieldByName('NUM_CORE_FINAL_YIELD').AsFloat;

      //o.State := trim(ds.FieldByName('VCH_WELL_STATE_NAME').AsString);
      //o.Region := trim(ds.FieldByName('VCH_REGION_FULL_NAME').AsString);

      if Assigned(AllOrganizations) then
        o.OwnerOrganization := AllOrganizations.ItemsByID[ds.FieldByName('RE_ORGANIZATION_ID').AsInteger] as TOrganization;


      ds.Next;
    end;

    LocalSort(AObjects);    
    ds.First;
  end;
end;

procedure TSlottingWellDataPoster.LocalSort(AObjects: TIDObjects);
begin
  inherited;
  AObjects.Sort(WellNumAndAreaCompare);
end;

function TSlottingWellDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

procedure TSlottingWellDataPoster.SetAllAreas(const Value: TSimpleAreas);
begin
  if FAllAreas <> Value then
    FAllAreas := Value;
end;

procedure TSlottingWellDataPoster.SetAllWellCategories(
  const Value: TWellCategories);
begin
  if FAllWellCategories <> Value then
    FAllWellCategories := Value;
end;

procedure TSlottingWellDataPoster.SetAllWellStates(
  const Value: TStates);
begin
  if FAllWellStates <> Value then
    FAllWellStates := Value;
end;

procedure TSlottingWellDataPoster.SetOrganizations(
  const Value: TOrganizations);
begin
  if FAllOrganizations <> Value then
    FAllOrganizations := Value;
end;

end.

