unit SlottingPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Straton;

type

  // для долблений
  TSlottingDataPoster = class(TImplementedDataPoster)
  private
    FStratons: TSimpleStratons;
    procedure SetStratons(const Value: TSimpleStratons);
  public
    property AllStratons: TSimpleStratons read FStratons write SetStratons;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;



implementation

uses Facade, Slotting, SysUtils, Math, DateUtils;

{ TSlottingdDataPoster }

constructor TSlottingDataPoster.Create;
begin
  inherited;
  Options := [soGetKeyValue];
  DataSourceString := 'VW_SLOTTING_DESCRIPTION';
  DataDeletionString := 'TBL_SLOTTING';
  DataPostString := 'TBL_SLOTTING';


  KeyFieldNames := 'SLOTTING_UIN';
  FieldNames := 'SLOTTING_UIN, WELL_UIN, VCH_SLOTTING_NUMBER, ' +
                'NUM_SLOTTING_TOP, NUM_SLOTTING_BOTTOM, ' +
                'NUM_CORE_YIELD, NUM_CORE_FINAL_YIELD, TRUE_DESCRIPTION, ' +
                'DTM_KERN_TAKE_DATE, NUM_DNR_SAMPLE_COUNT, NUM_SLOTTING_CHECKED, NUM_DIAMETER, VCH_COMMENT, STRATON_ID, VCH_SUBS_STRATON_INDEX';

  AccessoryFieldNames := 'SLOTTING_UIN, WELL_UIN, VCH_SLOTTING_NUMBER, NUM_SLOTTING_TOP, NUM_SLOTTING_BOTTOM, ' +
                         'NUM_CORE_YIELD, NUM_DIAMETER, VCH_BOX_NUMBER, NUM_CORE_FINAL_YIELD, NUM_DNR_SAMPLE_COUNT, ' +
                         'VCH_CORE_STATE, NUM_COLLECTION_MEMBER, VCH_COMMENT, DTM_KERN_TAKE_DATE, ' +
                         'NUM_SLOTTING_CHECKED, STRATON_ID';
  AutoFillDates := false;

  Sort := 'NUM_SLOTTING_TOP';
end;

function TSlottingDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSlottingDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TSlotting;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TSlotting;

      o.ID := ds.FieldByName('SLOTTING_UIN').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_SLOTTING_NUMBER').AsString);
      o.Top := ds.FieldByName('NUM_SLOTTING_TOP').AsFloat;
      o.Bottom := ds.FieldByName('NUM_SLOTTING_BOTTOM').AsFloat;
      o.CoreYield := ds.FieldByName('NUM_CORE_YIELD').AsFloat;
      o.CoreFinalYield := ds.FieldByName('NUM_CORE_FINAL_YIELD').AsFloat;
      o.Diameter := ds.FieldByName('NUM_DIAMETER').Value;
      o.Comment := trim(ds.FieldByName('VCH_COMMENT').AsString);
      o.Straton := AllStratons.ItemsByID[ds.FieldByName('STRATON_ID').AsInteger] as TSimpleStraton;
      o.SubDivisionStratonName := ds.FieldByName('VCH_SUBS_STRATON_INDEX').AsString;

      if ds.FieldByName('TRUE_DESCRIPTION').AsInteger > 0 then o.TrueDescription := true
      else o.TrueDescription := False;

      o.CoreTakeDate := ds.FieldByName('DTM_KERN_TAKE_DATE').AsDateTime;
      ds.Next;
    end;

    ds.First;
  end;
end;

function TSlottingDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TSlotting;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TSlotting;


  ds.FieldByName('SLOTTING_UIN').Value := o.ID;
  ds.FieldByName('WELL_UIN').Value := o.Collection.Owner.ID;
  ds.FieldByName('VCH_SLOTTING_NUMBER').Value := o.Name;
  ds.FieldByName('NUM_SLOTTING_TOP').Value := o.Top;
  ds.FieldByName('NUM_SLOTTING_BOTTOM').Value := o.Bottom;
  ds.FieldByName('NUM_CORE_YIELD').Value := o.CoreYield;
  ds.FieldByName('NUM_CORE_FINAl_YIELD').Value := o.CoreFinalYield;

  if Assigned(o.Straton) then
    ds.FieldByName('STRATON_ID').Value := o.Straton.ID;
  ds.FieldByName('NUM_SLOTTING_CHECKED').Value := 1;
  ds.FieldByName('NUM_DIAMETER').Value := o.Diameter;
  ds.FieldByName('DTM_KERN_TAKE_DATE').Value := DateOf(o.CoreTakeDate);
  ds.FieldByName('VCH_COMMENT').Value := trim(o.Comment);

  ds.Post;

  if o.ID = 0 then
    o.ID := ds.FieldByName('SLOTTING_UIN').Value;

end;



procedure TSlottingDataPoster.SetStratons(const Value: TSimpleStratons);
begin
  if FStratons <> Value then
    FStratons := Value;
end;

end.
