unit CoreMechanicalStatePoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, CoreMechanicalState;

type

  TCoreMechanicalStateDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;override;

    constructor Create; override;
  end;

  TSlottingCoreMechanicalStateDataPoster = class(TImplementedDataPoster)
  private
    FAllMechanicalStates: TCoreMechanicalStates;
  public
    property AllMechanicalStates: TCoreMechanicalStates read FAllMechanicalStates write FAllMechanicalStates;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;override;

    constructor Create; override;
  end;


implementation

uses Facade, SysUtils, Variants;

{ TCoreMechanicalStateDataPoster }

constructor TCoreMechanicalStateDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_CORE_MECHANICAL_STATE_DICT';

  KeyFieldNames := 'Core_Mechanical_State_ID';
  FieldNames := 'Core_Mechanical_State_ID, vch_Core_Mech_State_Name, vch_Mech_State_Short_Name, num_Is_Visible';
  AccessoryFieldNames := 'Core_Mechanical_State_ID, vch_Core_Mech_State_Name, vch_Mech_State_Short_Name, num_Is_Visible';;
  AutoFillDates := false;

  Sort := 'vch_Core_Mech_State_Name';
end;

function TCoreMechanicalStateDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TCoreMechanicalStateDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TCoreMechanicalState;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      s := AObjects.Add as TCoreMechanicalState;

      s.ID := ds.FieldByName('Core_Mechanical_State_ID').AsInteger;
      s.Name := trim(ds.FieldByName('vch_Core_Mech_State_Name').AsString);
      s.ShortName := trim(ds.FieldByName('vch_Mech_State_Short_Name').AsString);
      s.IsVisible := (ds.FieldByName('num_Is_Visible').AsInteger > 0);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TCoreMechanicalStateDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    s: TCoreMechanicalState;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  s := AObject as TCoreMechanicalState;

  ds.FieldByName('Core_Mechanical_State_ID').AsInteger := s.ID;
  ds.FieldByName('vch_Core_Mech_State_Name').AsString := trim(s.Name);
  ds.FieldByName('vch_Mech_State_Short_Name').AsString := trim(s.ShortName);
  ds.FieldByName('num_Is_Visible').AsInteger := ord(s.IsVisible);

  ds.Post;

  if s.ID = 0 then
    s.ID := ds.FieldByName('Core_Mechanical_State_ID').AsInteger;
end;

{ TSlottingCoreMechanicalStateDataPoster }

constructor TSlottingCoreMechanicalStateDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_SLOTTING_MECH_STATE';

  KeyFieldNames := 'CORE_MECHANICAL_STATE_ID; SLOTTING_UIN';
  FieldNames := 'SLOTTING_UIN, CORE_MECHANICAL_STATE_ID';

  AccessoryFieldNames := 'SLOTTING_UIN, CORE_MECHANICAL_STATE_ID';
  AutoFillDates := false;

  Sort := '';
end;

function TSlottingCoreMechanicalStateDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
var ds: TCommonServerDataSet;
    cms: TSlottingCoreMechanicalState;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  try
    // находим строку соответствующую ключу
    //ds.Refresh;
    ds.First;
    cms := AObject as TSlottingCoreMechanicalState;
    if ds.Locate(ds.KeyFieldNames, VarArrayOf([cms.MechanicalState.ID, AObject.Owner.ID]),[]) then
      ds.Delete
  except
    Result := -1;
  end;
end;

function TSlottingCoreMechanicalStateDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TCoreMechanicalState;
    s: TSlottingCoreMechanicalState;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AllMechanicalStates.ItemsByID[ds.FieldByName('CORE_MECHANICAL_STATE_ID').AsInteger] as TCoreMechanicalState;
      if Assigned(o) then
      begin
        s := AObjects.Add as TSlottingCoreMechanicalState;
        s.MechanicalState := o;
        s.ID := o.ID;
      end;
      ds.Next;
    end;

    ds.First;
  end;
end;

function TSlottingCoreMechanicalStateDataPoster.PostToDB(
  AObject: TIDObject; ACollection: TIDObjects): integer;
var ds: TDataSet;
    s: TSlottingCoreMechanicalState;
begin
  s := AObject as TSlottingCoreMechanicalState;
  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    if not ds.Active then
      ds.Open;

    if ds.Locate(KeyFieldNames, varArrayOf([s.MechanicalState.ID, s.Collection.Owner.ID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;


  ds.FieldByName('Core_Mechanical_State_ID').AsInteger := s.MechanicalState.ID;
  ds.FieldByName('SLOTTING_UIN').AsInteger := s.Collection.Owner.ID;

  ds.Post;
end;

end.
