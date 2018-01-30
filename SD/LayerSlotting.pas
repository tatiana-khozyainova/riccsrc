unit LayerSlotting;

interface

uses Registrator, BaseObjects, ComCtrls, Classes, RockSample;

type
  // ���� ���������
  TSimpleLayerSlotting = class (TRegisteredIDObject)
  private
    FRockSamples: TRockSamples;
    FBeginingLayer: double;
    FEndingLayer: Double;
    FCapacity: double;
    FDummyLayer: boolean;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // ������ ����
    property    BeginingLayer: double read FBeginingLayer write FBeginingLayer;
    // ��������� ����
    property    EndingLayer: double read FEndingLayer write FEndingLayer;
    // �������� ����
    property    Capacity: double read FCapacity write FCapacity;
    // ��������� ���� ��� ���������
    property    DummyLayer: boolean read FDummyLayer write FDummyLayer;
    // �������
    property    RockSamples: TRockSamples read FRockSamples write FRockSamples;

    function    List(AListOption: TListOption = loBrief): string; override;
    procedure   MakeList(AListView: TListItems; NeedsClearing: boolean = false); override;

    constructor Create(ACollection: TIDObjects); override;
  end;

  // ���� ���������
  TSimpleLayerSlottings = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TSimpleLayerSlotting;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TSimpleLayerSlotting read GetItems;

    procedure   Reload; override;

    constructor Create; override;
  end;

  // ���� �������
  TLayerRockSample = class (TSimpleLayerSlotting)
  private
    FRockSample: TRockSample;
    function    GetRockSamples: TRockSamples;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    RockSample: TRockSample read FRockSample write FRockSample;
    property    RockSamples: TRockSamples read GetRockSamples;

    constructor Create(ACollection: TIDObjects); override;
  end;

  // ���� �������
  TLayerRockSamples = class (TSimpleLayerSlottings)
  private
    function    GetItems(Index: integer): TLayerRockSample;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TLayerRockSample read GetItems;

    procedure   Reload; override;

    constructor Create; override;
  end;

implementation

uses Facade, BaseFacades, LayerSlottingPoster, CoreDescription, SysUtils;

{ TSimpleLayerSlottings }

procedure TSimpleLayerSlottings.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TSimpleLayerSlottings.Create;
begin
  inherited;

  FObjectClass := TSimpleLayerSlotting;
end;

function TSimpleLayerSlottings.GetItems(
  Index: integer): TSimpleLayerSlotting;
begin
  Result := inherited Items[Index] as TSimpleLayerSlotting;
end;

procedure TSimpleLayerSlottings.Reload;
begin
  if Assigned(FDataPoster) then
  begin
    FDataPoster.GetFromDB('', Self);
    FDataPoster.SaveState(PosterState);    
  end;
end;

{ TSimpleLayerSlotting }

procedure TSimpleLayerSlotting.AssignTo(Dest: TPersistent);
var o: TSimpleLayerSlotting;
begin
  inherited;

  o := Dest as TSimpleLayerSlotting;

  o.BeginingLayer := BeginingLayer;
  o.EndingLayer := EndingLayer;
  o.Capacity := Capacity;
  o.FDummyLayer := DummyLayer;
  o.RockSamples.Assign(RockSamples);
end;

constructor TSimpleLayerSlotting.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := '���� ���������';

  CountFields := 9;

  FDummyLayer := false;
end;

function TSimpleLayerSlotting.List(AListOption: TListOption): string;
begin
  Result := '���� ' + trim (Name);
end;

procedure TSimpleLayerSlotting.MakeList(AListView: TListItems;
  NeedsClearing: boolean);
var index : integer;
begin
  inherited;

  Index := AListView.Count - 1 - CountFields;

  AListView.Item[Index + 1].Caption := '����';
  AListView.Item[Index + 1].Data := nil;
  AListView.Item[Index + 1].Data := TObject;

  AListView.Item[Index + 2].Caption := '����� ����: ';
  AListView.Item[Index + 2].Data := nil;
  AListView.Item[Index + 3].Caption := '     ' + FName;

  AListView.Item[Index + 4].Caption := '������ ���� :';
  AListView.Item[Index + 4].Data := nil;
  AListView.Item[Index + 5].Caption := '     ' + FloatToStr(FBeginingLayer);

  AListView.Item[Index + 6].Caption := '��������� ���� :';
  AListView.Item[Index + 6].Data := nil;
  AListView.Item[Index + 7].Caption := '     ' + FloatToStr(FEndingLayer);

  AListView.Item[Index + 8].Caption := '�������� :';
  AListView.Item[Index + 8].Data := nil;
  AListView.Item[Index + 9].Caption := '     ' + FloatToStr(FCapacity);

  {
  AListView.Item[Index + 10].Caption := '������� �������� � ���� :';
  AListView.Item[Index + 10].Data := nil;
  if FTrueDescription then AListView.Item[Index + 11].Caption := '     ��'
  else AListView.Item[Index + 11].Caption := '     ���';
  }
end;

{ TLayerRockSamples }

procedure TLayerRockSamples.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TLayerRockSamples.Create;
begin
  inherited;
  FObjectClass := TLayerRockSample;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TLayerRockSampleDataPoster]
end;

function TLayerRockSamples.GetItems(Index: integer): TLayerRockSample;
begin
  Result := inherited Items[Index] as TLayerRockSample;
end;

procedure TLayerRockSamples.Reload;
begin
  if Assigned(FDataPoster) then
  begin
    FDataPoster.GetFromDB('', Self);
    FDataPoster.SaveState(PosterState);    
  end;
end;

{ TLayerRockSample }

procedure TLayerRockSample.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TLayerRockSample.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := '���� �������';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLayerRockSampleDataPoster];
end;

function TLayerRockSample.GetRockSamples: TRockSamples;
begin
  if not Assigned (FRockSamples) then
  begin
    FRockSamples := TRockSamples.Create;
    FRockSamples.Reload('(slotting_uin = ' + IntToStr(Collection.Owner.ID) + ' and rock_sample_uin not in (select rl.rock_sample_uin from tbl_rock_sample_layer rl)) or ' +
                        'rock_sample_uin in (select rl.rock_sample_uin from tbl_rock_sample_layer rl where rl.layer_slotting_id = ' + IntToStr(ID) + ')');
    FRockSamples.Owner := Self;
  end;

  Result := FRockSamples;
end;

end.
