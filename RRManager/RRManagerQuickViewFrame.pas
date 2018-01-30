unit RRManagerQuickViewFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerObjects, RRManagerBaseObjects, ComCtrls, RRManagerBaseGUI, BaseObjects;

type


//  TfrmQuickView = class(TFrame)
  TfrmQuickView = class(TFrame, IConcreteVisitor)
    lwProperties: TListView;
    procedure lwPropertiesInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure lwPropertiesAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure lwPropertiesResize(Sender: TObject);
  private
    { Private declarations }
    FActiveObject: TBaseObject;
    FFakeObject: TObject;
  protected
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function  GetActiveObject: TIDObject;
    procedure SetActiveObject(const Value: TIDObject);
  public
    { Public declarations }



    procedure VisitWell(AWell: TIDObject);
    procedure VisitTestInterval(ATestInterval: TIDObject);
    procedure VisitLicenseZone(ALicenseZone: TIDObject);
    procedure VisitSlotting(ASlotting: TIDObject);


    property  ActiveObject: TBaseObject read FActiveObject write FActiveObject;

    procedure VisitVersion(AVersion: TOldVersion);
    procedure VisitStructure(AStructure: TOldStructure);

    procedure VisitDiscoveredStructure(ADiscoveredStructure: TOldDiscoveredStructure);
    procedure VisitPreparedStructure(APreparedStructure: TOldPreparedStructure);
    procedure VisitDrilledStructure(ADrilledStructure: TOldDrilledStructure);
    procedure VisitField(AField: TOldField);

    procedure VisitHorizon(AHorizon: TOldHorizon);

    procedure VisitSubstructure(ASubstructure: TOldSubstructure);

    procedure VisitLayer(ALayer: TOldLayer);

    procedure VisitBed(ABed: TOldBed);

    procedure VisitAccountVersion(AAccountVersion: TOldAccountVersion);
    procedure VisitStructureHistoryElement(AHistoryElement: TOldStructureHistoryElement);
    procedure VisitOldLicenseZone(ALicenseZone: TOldLicenseZone);


    procedure VisitCollectionWell(AWell: TIDObject);
    procedure VisitCollectionSample(ACollectionSample: TIDObject);
    procedure VisitDenudation(ADenudation: TIDObject);
    procedure VisitWellCandidate(AWellCandidate: TIDObject);


    procedure Clear;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;



implementation

uses RRManagerLoaderCommands, BaseConsts, LicenseZone;

{$R *.DFM}

type
  TFakeObject = class

  end;

{ TfrmQuickView }

procedure TfrmQuickView.VisitBed(ABed: TOldBed);
var li: TListItem;
    actn: TBaseAction;
    i, j: integer;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  if AllOpts.Current.FixVisualization then
  begin
    if Assigned(ABed.Substructure) then
      VisitSubstructure(ABed.Substructure)
    else VisitStructure(ABed.Structure);

    li := lwProperties.Items.Add;
    li.Caption := 'Залежь';
    li.Data := FFakeObject;
  end;

  li := lwProperties.Items.Add;
  li.Caption := 'Идентификатор залежи (BedUIN)';
  li := lwProperties.Items.Add;
  li.Caption := IntToStr(ABed.ID);
  li.Data := ABed;

  if trim(ABed.BedIndex) <> '' then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Индекс залежи';
    li := lwProperties.Items.Add;
    li.Caption := ABed.BedIndex;
    li.Data := ABed;
  end;

  if Trim(ABed.Name) <> '' then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Примечание';
    li := lwProperties.Items.Add;
    li.Caption := ABed.Name;
    li.Data := ABed;
  end;

  if trim(ABed.BedType) <> '' then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Тип залежи';
    li := lwProperties.Items.Add;
    li.Caption := ABed.BedType;
    li.Data := ABed;
  end;

  if trim(ABed.FluidType) <> '' then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Тип флюида';
    li := lwProperties.Items.Add;
    li.Caption := ABed.FluidType;
    li.Data := ABed;
  end;

  if trim(ABed.ComplexName) <> '' then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Комплекс';
    li := lwProperties.Items.Add;
    li.Caption := ABed.ComplexName;
    li.Data := ABed;
  end;


  if trim(ABed.CollectorType) <> '' then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Тип коллектора';
    li := lwProperties.Items.Add;
    li.Caption := ABed.CollectorType;
    li.Data := ABed;
  end;

  if trim(ABed.Age) <> '' then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Возраст залежи';
    li := lwProperties.Items.Add;
    li.Caption := ABed.Age;
    li.Data := ABed;
  end;

  li := lwProperties.Items.Add;
  li.Caption := 'Глубина кровли';
  li := lwProperties.Items.Add;
  li.Caption := Trim(Format('%8.2f', [ABed.Depth]));
  li.Data := ABed;


  actn := TVersionBaseLoadAction.Create(Self);
  actn.LastCollection := ABed.Versions;
  actn.LastCollection.NeedsUpdate := true;
  actn.Execute(ABed);
  actn.Free;


  actn := TReserveByVersionBaseLoadAction.Create(Self);
  for i := 0 to ABed.Versions.Count - 1 do
  begin


    actn.LastCollection := ABed.Versions.Items[i].Reserves;
    actn.LastCollection.NeedsUpdate := true;
    actn.Execute(ABed.Versions.Items[i]);

    if ABed.Versions.Items[i].Reserves.Count > 0 then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Запасы - ' + ABed.Versions.Items[i].List(loBrief, False, False);
      li.Data := FFakeObject;

      for j := 0 to ABed.Versions.Items[i].Reserves.Count - 1 do
      if ABed.Versions.Items[i].Reserves.Items[j].ReserveValueTypeID = RESERVES_RESERVE_VALUE_TYPE_ID then
      begin
        li := lwProperties.Items.Add;
        with ABed.Versions.Items[i].Reserves.Items[j] do
          li.Caption := FluidType + '-' + ReserveCategory + '(' + ReserveType + ';' + ReserveKind + ')';


        li := lwProperties.Items.Add;
        li.Caption := Format('%.3f', [ABed.Versions.Items[i].Reserves.Items[j].Value]);
        li.Data := ABed;
      end;

      // те, которые подсчитываются
      ABed.Versions.Items[i].Reserves.CalculateReserves;
      for j := 0 to ABed.Versions.Items[i].Reserves.CalculatedReserves.Count - 1 do
      if ABed.Versions.Items[i].Reserves.CalculatedReserves.Items[j].ReserveValueTypeID = RESERVES_RESERVE_VALUE_TYPE_ID then
      begin
        li := lwProperties.Items.Add;
        with ABed.Versions.Items[i].Reserves.CalculatedReserves.Items[j] do
          li.Caption := FluidType + '-' + ReserveCategory + '(' + ReserveType + ';' + ReserveKind + ')';


        li := lwProperties.Items.Add;
        li.Caption := Format('%.3f', [ABed.Versions.Items[i].Reserves.CalculatedReserves.Items[j].Value]);
        li.Data := ABed;
      end;
    end;
  end;
  actn.Free;

  ActiveObject := ABed;
  lwProperties.Items.EndUpdate;
end;

procedure TfrmQuickView.VisitDiscoveredStructure(
  ADiscoveredStructure: TOldDiscoveredStructure);
var li: TListItem;
begin
  lwProperties.Items.BeginUpdate;
  VisitStructure(ADiscoveredStructure);

  // типа пустая строка чтобы отделять элементы друг от друга
  li := lwProperties.Items.Add;
  li.Caption := 'Выявленная структура';
  li.Data := FFakeObject;


  if AllOpts.Current.ListOption >= loBrief then
  begin
    if trim(ADiscoveredStructure.Year) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Год выявления';
      li := lwProperties.Items.Add;
      li.Caption := ADiscoveredStructure.Year;
      li.Data := ADiscoveredStructure;
    end;
  end;

  if AllOpts.Current.ListOption >= loMedium then
  begin
    if trim(ADiscoveredStructure.Method) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Метод выявления';
      li := lwProperties.Items.Add;
      li.Caption := ADiscoveredStructure.Method;
      li.Data := ADiscoveredStructure;
    end;
  end;

  if AllOpts.Current.ListOption = loFull then
  begin
    if trim(ADiscoveredStructure.ReportAuthor) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Автор отчёта';
      li := lwProperties.Items.Add;
      li.Caption := ADiscoveredStructure.ReportAuthor;
      li.Data := ADiscoveredStructure;
    end;
  end;

  ActiveObject := ADiscoveredStructure;
  lwProperties.Items.EndUpdate;  
end;

procedure TfrmQuickView.VisitDrilledStructure(
  ADrilledStructure: TOldDrilledStructure);
var li: TListItem;
begin
  lwProperties.Items.BeginUpdate;
  VisitStructure(ADrilledStructure);

  li := lwProperties.Items.Add;
  li.Caption := 'Структура в бурении';
  li.Data := FFakeObject;

  if AllOpts.Current.ListOption >= loBrief then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Скважин';
    li := lwProperties.Items.Add;
    li.Caption := IntToStr(ADrilledStructure.Wells.Count);
    li.Data := ADrilledStructure;
  end;

  ActiveObject := ADrilledStructure;
  lwProperties.Items.EndUpdate;  
end;

procedure TfrmQuickView.VisitField(AField: TOldField);
var li: TListItem;
    i, j: integer;
    actn: TBaseAction;
begin
  lwProperties.Items.BeginUpdate;
  VisitStructure(AField);

  li := lwProperties.Items.Add;
  li.Caption := 'Месторождение';
  li.Data := FFakeObject;

  if trim(AField.FieldType) <> '' then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Тип месторождения';
    li := lwProperties.Items.Add;
    li.Caption := AField.FieldType;
    li.Data := AField;
  end;

  if trim(AField.DevelopingDegree) <> '' then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Степень освоения';
    li := lwProperties.Items.Add;
    li.Caption := AField.DevelopingDegree;
    li.Data := AField;
  end;

  if AField.LicenseZones.Count > 0 then
  begin
    li := lwProperties.Items.Add;
    li.Caption := '№ лицензии';
    li := lwProperties.Items.Add;
    li.Caption := AField.LicenseZones.List;
    li.Data := AField;

    if Trim(AField.LicenseZones.OrganizationList) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Организация-недропользователь';
      li := lwProperties.Items.Add;
      li.Caption := AField.LicenseZones.OrganizationList;
      li.Data := AField;
    end;
  end;

  actn := TVersionBaseLoadAction.Create(Self);
  actn.LastCollection := AField.Versions;
  actn.LastCollection.NeedsUpdate := true;
  actn.Execute(AField);
  actn.Free;


  actn := TFieldReserveByVersionBaseLoadAction.Create(Self);

  for i := 0 to AField.Versions.Count - 1 do
  begin


    actn.LastCollection := AField.Versions.Items[i].Reserves;
    actn.LastCollection.NeedsUpdate := true;
    actn.Execute(AField.Versions.Items[i]);

    if AField.Versions.Items[i].Reserves.Count > 0 then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Запасы - ' + AField.Versions.Items[i].List(loBrief, False, False);
      li.Data := FFakeObject;

      for j := 0 to AField.Versions.Items[i].Reserves.Count - 1 do
      if AField.Versions.Items[i].Reserves.Items[j].ReserveValueTypeID = RESERVES_RESERVE_VALUE_TYPE_ID then
      begin
        li := lwProperties.Items.Add;
        with AField.Versions.Items[i].Reserves.Items[j] do
          li.Caption := FluidType + '-' + ReserveCategory + '(' + ReserveType + ';' + ReserveKind + ')';


        li := lwProperties.Items.Add;
        li.Caption := Format('%.3f', [AField.Versions.Items[i].Reserves.Items[j].Value]);
        li.Data := AField;
      end;

      // те, которые подсчитываются
      AField.Versions.Items[i].Reserves.CalculateReserves;
      for j := 0 to AField.Versions.Items[i].Reserves.CalculatedReserves.Count - 1 do
      if AField.Versions.Items[i].Reserves.CalculatedReserves.Items[j].ReserveValueTypeID = RESERVES_RESERVE_VALUE_TYPE_ID then
      begin
        li := lwProperties.Items.Add;
        with AField.Versions.Items[i].Reserves.CalculatedReserves.Items[j] do
          li.Caption := FluidType + '-' + ReserveCategory + '(' + ReserveType + ';' + ReserveKind + ')';


        li := lwProperties.Items.Add;
        li.Caption := Format('%.3f', [AField.Versions.Items[i].Reserves.CalculatedReserves.Items[j].Value]);
        li.Data := AField;
      end;
    end;
  end;
  actn.Free;
  ActiveObject := AField;
  lwProperties.Items.EndUpdate;
end;

procedure TfrmQuickView.VisitHorizon(AHorizon: TOldHorizon);
var li: TListItem;
    s: string;
begin

  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;


  if AllOpts.Current.FixVisualization then
  begin
    VisitStructure(AHorizon.Structure);
    li := lwProperties.Items.Add;
    li.Caption := 'Горизонт';
    li.Data := FFakeObject;
  end;

  if AllOpts.Current.ListOption >= loBrief then
  begin
    s := AHorizon.FirstStratum + '(' + AHorizon.FirstStratumPostfix + ')';
    if AHorizon.SecondStratum <> '' then
      s := s + '-' + AHorizon.SecondStratum + AHorizon.SecondStratumPostfix;

    if trim(s) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Название';
      li := lwProperties.Items.Add;
      li.Caption := s;
      li.Data := AHorizon;
    end;

    if trim(AHorizon.Complex) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Комплекс';
      li := lwProperties.Items.Add;
      li.Caption := AHorizon.Complex;
      li.Data := AHorizon;
    end;

    li := lwProperties.Items.Add;
    li.Caption := 'Участвует в подсчётах';
    li := lwProperties.Items.Add;
    if AHorizon.Active then
      li.Caption := 'да'
    else li.Caption := 'нет';
    li.Data := AHorizon;
  end;

  if AllOpts.Current.ListOption >= loMedium then
  begin
    if trim(AHorizon.Organization) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Организация';
      li := lwProperties.Items.Add;
      li.Caption := AHorizon.Organization;
      li.Data := AHorizon;
    end;
  end;

  if AllOpts.Current.ListOption = loFull then
  begin
    if trim(AHorizon.InvestigationYear) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Год исследования';
      li := lwProperties.Items.Add;
      li.Caption := AHorizon.InvestigationYear;
      li.Data := AHorizon;
    end;

    if trim(AHorizon.Comment) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Описание';
      li := lwProperties.Items.Add;
      li.Caption := AHorizon.Comment;
      li.Data := AHorizon;
    end;

    if AHorizon.FundTypes.Count > 0 then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Виды фондов';
      li := lwProperties.Items.Add;
      li.Caption := AHorizon.FundTypes.List(loBrief, false, false);
      li.Data := AHorizon;
    end;
  end;

  ActiveObject := AHorizon;
  lwProperties.Items.EndUpdate;
end;

procedure TfrmQuickView.VisitLayer(ALayer: TOldLayer);
var li: TListItem;
    i, j: integer;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  if AllOpts.Current.FixVisualization then
  begin
    if Assigned(ALayer.Bed) then VisitBed(ALayer.Bed)
    else if Assigned(ALayer.Substructure) then VisitSubstructure(ALayer.Substructure);

    li := lwProperties.Items.Add;
    li.Caption := 'Продуктивный пласт';
    li.Data := FFakeObject;
  end;

  if AllOpts.Current.ListOption >= loBrief then
  begin
    if trim(ALayer.LayerIndex) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Индекс';
      li := lwProperties.Items.Add;
      li.Caption := ALayer.LayerIndex;
      li.Data := ALayer;
    end;

    // тип коллеектора
    if trim(ALayer.CollectorType) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Тип коллектора';
      li := lwProperties.Items.Add;
      li.Caption := ALayer.CollectorType;
      li.Data := ALayer;
    end;

    if trim(ALayer.RockName) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Литология коллектора';
      li := lwProperties.Items.Add;
      li.Caption := ALayer.RockName;
      li.Data := ALayer;
    end;

    // тип ловушки
    if trim(ALayer.TrapType) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Тип ловушки';
      li := lwProperties.Items.Add;
      li.Caption := ALayer.TrapType;
      li.Data := ALayer;
    end;
  end;

  if AllOpts.Current.ListOption >= loMedium then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Мощность';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ALayer.Power]));
    li.Data := ALayer;

    li := lwProperties.Items.Add;
    li.Caption := 'Эффективная мощность';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ALayer.EffectivePower]));
    li.Data := ALayer;


    li := lwProperties.Items.Add;
    li.Caption := 'Коэффициент заполнения';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ALayer.FillingCoef]));
    li.Data := ALayer;
  end;

  if AllOpts.Current.ListOption = loFull then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Высота ловушки';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ALayer.TrapHeight]));
    li.Data := ALayer;

    li := lwProperties.Items.Add;
    li.Caption := 'Площадь ловушки';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ALayer.TrapArea]));
    li.Data := ALayer;

    li := lwProperties.Items.Add;
    li.Caption := 'Высота залежи';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ALayer.BedHeight]));
    li.Data := ALayer;

    li := lwProperties.Items.Add;
    li.Caption := 'Площадь залежи';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ALayer.BedArea]));
    li.Data := ALayer;
  end;

  if AllOpts.Current.ListOption >= loMedium then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Ресурсы';
    li.Data := FFakeObject;

    for i := 0 to ALayer.Versions.Count - 1 do
    with ALayer.Versions.Items[i] do
    begin
       for j := 0 to Resources.Count - 1 do
       begin
         li := lwProperties.Items.Add;
         li.Caption := Resources.Items[j].FluidType + ' ' + Resources.Items[j].ResourceCategory +  '(' + Resources.Items[j].ResourceType + ')';
         li := lwProperties.Items.Add;
         li.Caption := Trim(Format('%8.4f', [Resources.Items[j].Value]));
         li.Data := Resources.Items[j];
       end;
    end;
  end;

  ActiveObject := ALayer;
  lwProperties.Items.EndUpdate;
end;

procedure TfrmQuickView.VisitPreparedStructure(
  APreparedStructure: TOldPreparedStructure);
var li: TListItem;
begin
  lwProperties.Items.BeginUpdate;
  VisitStructure(APreparedStructure);

  li := lwProperties.Items.Add;
  li.Caption := 'Подготовленная структура';
  li.Data := FFakeObject;

  if AllOpts.Current.ListOption >= loBrief then
  begin
    if trim(APreparedStructure.Year) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Год подготовки';
      li := lwProperties.Items.Add;
      li.Caption := APreparedStructure.Year;
      li.Data := APreparedStructure;
    end;
  end;

  if AllOpts.Current.ListOption >= loMedium then
  begin
    if trim(APreparedStructure.Method) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Метод подготовки';
      li := lwProperties.Items.Add;
      li.Caption := APreparedStructure.Method;
      li.Data := APreparedStructure;
    end;
  end;

  if AllOpts.Current.ListOption = loFull then
  begin
    if trim(APreparedStructure.ReportAuthor) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Автор отчёта';
      li := lwProperties.Items.Add;
      li.Caption := APreparedStructure.ReportAuthor;
      li.Data := APreparedStructure;
    end;
  end;

  ActiveObject := APreparedStructure;
  lwProperties.Items.EndUpdate;
end;

procedure TfrmQuickView.VisitStructure(AStructure: TOldStructure);
var li: TListItem;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  if AllOpts.Current.ListOption >= loBrief then
  begin
    if trim(AStructure.Name) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'ID';
      li := lwProperties.Items.Add;
      li.Caption := IntToStr(AStructure.ID);
      li.Data := AStructure;
    end;

    if trim(AStructure.Name) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Название';
      li := lwProperties.Items.Add;
      li.Caption := AStructure.Name;
      li.Data := AStructure;
    end;

    if trim(AStructure.StructureType) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Тип';
      li := lwProperties.Items.Add;
      li.Caption := AStructure.StructureType;
      li.Data := AStructure;
    end;
  end;

  if AllOpts.Current.ListOption >= loMedium then
  begin
    if trim(AStructure.Organization) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Организация';
      li := lwProperties.Items.Add;
      li.Caption := AStructure.Organization;
      li.Data := AStructure;
    end;

    if trim(AStructure.OwnerOrganization) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Недропользователь';
      li := lwProperties.Items.Add;
      li.Caption := AStructure.OwnerOrganization;
      li.Data := AStructure;
    end;

    if AStructure.PetrolRegions.Count > 0 then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'НГР';
      li := lwProperties.Items.Add;
      li.Caption := AStructure.PetrolRegions.List;
      li.Data := AStructure;
    end;

    if AStructure.Districts.Count > 0 then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Регион';
      li := lwProperties.Items.Add;
      li.Caption := AStructure.Districts.List;
      li.Data := AStructure;
    end;

    if AStructure.CartoHorizonID > 0 then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Горизонт нанесения на карту';
      li := lwProperties.Items.Add;
      li.Caption := AStructure.CartoHorizon.List(AllOpts.Current.ListOption, false, false);
      li.Data := AStructure;
    end;
  end;

  if AllOpts.Current.ListOption = loFull then
  begin
    if AStructure.TectonicStructs.Count > 0 then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Тектоническая структура';
      li := lwProperties.Items.Add;
      li.Caption := AStructure.TectonicStructs.List;
      li.Data := AStructure;
    end;

    if trim(AStructure.Area) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Площадь';
      li := lwProperties.Items.Add;
      li.Caption := AStructure.Area;
      li.Data := AStructure;
    end;
  end;
  ActiveObject := AStructure;
  lwProperties.Items.EndUpdate;
end;

procedure TfrmQuickView.VisitSubstructure(ASubstructure: TOldSubstructure);
var li: TListItem;
    sName: string;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  if AllOpts.Current.FixVisualization then
  begin
    VisitHorizon(ASubstructure.Horizon);
    li := lwProperties.Items.Add;
    li.Caption := 'Подструктура';
    li.Data := FFakeObject;
  end;


  if AllOpts.Current.ListOption >= loBrief then
  begin
    if trim(ASubstructure.StructureElementType) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Тип';
      li := lwProperties.Items.Add;
      li.Caption := ASubstructure.StructureElementType;
      li.Data := ASubstructure;
    end;

    // наименование
    if ASubstructure.RealName <> '' then
      sName := ASubstructure.RealName
    else sName := ASubstructure.StructureElement;

    if trim(sName) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Имя';
      li := lwProperties.Items.Add;
      li.Caption := sName;
      li.Data := ASubstructure;
    end;

    // литология
    if trim(ASubstructure.RockName) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Литология коллектора';
      li := lwProperties.Items.Add;
      li.Caption := ASubstructure.RockName;
      li.Data := ASubstructure;
    end;

    // тип коллектора
    if trim(ASubstructure.CollectorType) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Тип коллектора';
      li := lwProperties.Items.Add;
      li.Caption := ASubstructure.CollectorType;
      li.Data := ASubstructure;
    end;

    // тип залежи
    if trim(ASubstructure.BedType) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Тип залежи';
      li := lwProperties.Items.Add;
      li.Caption := ASubstructure.BedType;
      li.Data := ASubstructure;
    end;
  end;

  if AllOpts.Current.ListOption >= loMedium then
  begin
    // НГК
    if trim(ASubstructure.SubComplex) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Подкомплекс';
      li := lwProperties.Items.Add;
      li.Caption := ASubstructure.SubComplex;
      li.Data := ASubstructure;
    end;

    // вероятность существования
    li := lwProperties.Items.Add;
    li.Caption := 'Вероятность существования';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ASubstructure.Probability]));
    li.Data := ASubstructure;

    // надежность
    li := lwProperties.Items.Add;
    li.Caption := 'Надежность';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ASubstructure.Reliability]));
    li.Data := ASubstructure;

    // оценка качества
    if trim(ASubstructure.QualityRange) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Оценка качества';
      li := lwProperties.Items.Add;
      li.Caption := ASubstructure.QualityRange;
      li.Data := ASubstructure;
    end;
  end;

  if AllOpts.Current.ListOption = loFull then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'Изогипса';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ASubstructure.ClosingIsogypse]));
    li.Data := ASubstructure;

    // перспективная площадь
    li := lwProperties.Items.Add;
    li.Caption := 'Персп. площадь';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ASubstructure.PerspectiveArea]));
    li.Data := ASubstructure;

    //амплитуда
    li := lwProperties.Items.Add;
    li.Caption := 'Амплитуда';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ASubstructure.Amplitude]));
    li.Data := ASubstructure;

    li := lwProperties.Items.Add;
    li.Caption := 'Контр. плотность';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ASubstructure.ControlDensity]));
    li.Data := ASubstructure;

    li := lwProperties.Items.Add;
    li.Caption := 'Ст. ош. карты';
    li := lwProperties.Items.Add;
    li.Caption := Trim(Format('%8.2f', [ASubstructure.MapError]));
    li.Data := ASubstructure;
  end;

  ActiveObject := ASubstructure;
  lwProperties.Items.EndUpdate;  
end;

function TfrmQuickView._AddRef: Integer;
begin
  Result := 0;
end;

function TfrmQuickView._Release: Integer;
begin
  Result := 0;
end;

procedure TfrmQuickView.lwPropertiesInfoTip(Sender: TObject;
  Item: TListItem; var InfoTip: String);
begin
  if Assigned(Item) then
    InfoTip := Item.Caption;
end;

procedure TfrmQuickView.lwPropertiesAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var r: TRect;
begin
  r := Item.DisplayRect(drBounds);
  if Item.Index = lwProperties.Items.Count - 1 then
  begin
    lwProperties.Canvas.Pen.Color := $00ACB9AF;
    lwProperties.Canvas.MoveTo(r.Left, r.Bottom);
    lwProperties.Canvas.LineTo(r.Right, r.Bottom);
    lwProperties.Canvas.Brush.Color := $00FFFFFF;//$00F7F4E1;//$00F2EDDF;//$00DCF5D6;//$00FBFAF0;//$00DAFCDB;//$00EFFAEB;
    lwProperties.Canvas.FillRect(r);
    lwProperties.Canvas.Font.Style := [];
    lwProperties.Canvas.TextOut(r.Left + 2, r.Top, Item.Caption);
  end;



  if not Assigned(Item.Data) then
  begin
    DefaultDraw := false;

    lwProperties.Canvas.Brush.Color := $00EFEFEF;//$00F7F4E1;//$00F2EDDF;//$00DCF5D6;//$00FBFAF0;//$00DAFCDB;//$00EFFAEB;
    lwProperties.Canvas.FillRect(r);

    lwProperties.Canvas.Font.Color := $00ACB9AF;//clGray;
    lwProperties.Canvas.Font.Style := [fsBold];

    if    (Item.Index < lwProperties.Items.Count - 1)
      and (TBaseObject(lwProperties.Items[Item.Index + 1].Data) = ActiveObject) then
      lwProperties.Canvas.Font.Color := lwProperties.Canvas.Font.Color + $00330000;

    lwProperties.Canvas.TextOut(r.Left + 2, r.Top, Item.Caption);
  end
  else
  begin
    if (TObject(Item.Data) is TFakeObject) then
    begin
      DefaultDraw := false;
      lwProperties.Canvas.Brush.Color := $00E4EAD7;//$00FBFAF0;//$00DAFCDB;//$00EFFAEB;
      lwProperties.Canvas.FillRect(r);
      lwProperties.Canvas.Font.Color := $00ACB9AF;//clGray;
      lwProperties.Canvas.Font.Style := [fsBold];

      if  (Item.Index < lwProperties.Items.Count - 2)
      and (TBaseObject(lwProperties.Items[Item.Index + 2].Data) = ActiveObject) then
        lwProperties.Canvas.Font.Color := lwProperties.Canvas.Font.Color + $0000AA00;

      lwProperties.Canvas.TextOut(r.Left + r.Right - lwProperties.Canvas.TextWidth(Item.Caption), r.Top, Item.Caption);
    end
{    else
    if (TBaseObject(Item.Data) = ActiveObject) then
    begin
      lwProperties.Canvas.Font.Color := lwProperties.Canvas.Font.Color + $00770033;
      lwProperties.Canvas.FillRect(r);
      lwProperties.Canvas.TextOut(r.Left + 2, r.Top, Item.Caption);
    end;}
  end;
end;

procedure TfrmQuickView.Clear;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;
  lwProperties.Items.EndUpdate;
end;

constructor TfrmQuickView.Create(AOwner: TComponent);
begin
  inherited;
  FFakeObject := TFakeObject.Create;
end;

destructor TfrmQuickView.Destroy;
begin
  FFakeObject.Free;
  inherited;
end;

procedure TfrmQuickView.lwPropertiesResize(Sender: TObject);
begin
  lwProperties.Columns[0].Width := lwProperties.Width - 3;
end;

procedure TfrmQuickView.VisitAccountVersion(
  AAccountVersion: TOldAccountVersion);
begin

end;

procedure TfrmQuickView.VisitStructureHistoryElement(
  AHistoryElement: TOldStructureHistoryElement);
begin

end;

procedure TfrmQuickView.VisitVersion(AVersion: TOldVersion);
begin
  { TODO : добавить просмотр информации о версии }
end;

procedure TfrmQuickView.VisitOldLicenseZone(ALicenseZone: TOldLicenseZone);
var li: TListItem;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  if AllOpts.Current.ListOption >= loBrief then
  begin
    li := lwProperties.Items.Add;
    li.Caption := 'ID';
    li := lwProperties.Items.Add;
    li.Caption := IntToStr(ALicenseZone.ID);
    li.Data := ALicenseZone;

    if trim(ALicenseZone.LicenseZoneName) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Название';
      li := lwProperties.Items.Add;
      li.Caption := ALicenseZone.LicenseZoneName;
      li.Data := ALicenseZone;
    end;

    if trim(ALicenseZone.LicenseZoneNum) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Номер участка';
      li := lwProperties.Items.Add;
      li.Caption := ALicenseZone.LicenseZoneNum;
      li.Data := ALicenseZone;
    end;

    if trim(ALicenseZone.License.LicenseType) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Вид лицензии';
      li := lwProperties.Items.Add;
      li.Caption := ALicenseZone.License.LicenseTypeShortName + '(' + ALicenseZone.License.LicenseType + ')';
      li.Data := ALicenseZone;
    end;


    if trim(ALicenseZone.LicenseZoneState) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Статус участка';
      li := lwProperties.Items.Add;
      li.Caption := ALicenseZone.LicenseZoneState;
      li.Data := ALicenseZone;
    end;

    if ALicenseZone.LicenseZoneStateID = 1 then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Дата регистрации лицензии';
      li := lwProperties.Items.Add;
      li.Caption := DateTimeToStr(ALicenseZone.RegistrationStartDate);
      li.Data := ALicenseZone;

      li := lwProperties.Items.Add;
      li.Caption := 'Дата окончания регистрации лицензии';
      li := lwProperties.Items.Add;
      li.Caption := DateTimeToStr(ALicenseZone.RegistrationFinishDate);
      li.Data := ALicenseZone;
    end;
  end;

  if AllOpts.Current.ListOption >= loMedium then
  begin
    if trim(ALicenseZone.License.OwnerOrganizationName) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Организация-владелец лицензии';
      li := lwProperties.Items.Add;
      li.Caption := ALicenseZone.License.OwnerOrganizationName;
      li.Data := ALicenseZone;
    end;

    if trim(ALicenseZone.License.DeveloperOrganizationName) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Организация-недропользователь';
      li := lwProperties.Items.Add;
      li.Caption := ALicenseZone.License.DeveloperOrganizationName;
      li.Data := ALicenseZone;
    end;


    if trim(ALicenseZone.License.LicenzeZoneType) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Тип участка';
      li := lwProperties.Items.Add;
      li.Caption := ALicenseZone.License.LicenzeZoneType;
      li.Data := ALicenseZone;
    end;



    if trim(ALicenseZone.District) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Регион';
      li := lwProperties.Items.Add;
      li.Caption := ALicenseZone.District;
      li.Data := ALicenseZone;
    end;
  end;

  if AllOpts.Current.ListOption = loFull then
  begin
    if trim(ALicenseZone.TectonicStruct) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'Тектоническая структура';
      li := lwProperties.Items.Add;
      li.Caption := ALicenseZone.TectonicStruct;
      li.Data := ALicenseZone;
    end;

    if trim(ALicenseZone.PetrolRegion) <> '' then
    begin
      li := lwProperties.Items.Add;
      li.Caption := 'НГР';
      li := lwProperties.Items.Add;
      li.Caption := ALicenseZone.PetrolRegion;
      li.Data := ALicenseZone;
    end;
  end;
  ActiveObject := ALicenseZone;
  lwProperties.Items.EndUpdate;
end;


function TfrmQuickView.GetActiveObject: TIDObject;
begin
  Result := FActiveObject;
end;

procedure TfrmQuickView.SetActiveObject(const Value: TIDObject);
begin
  FActiveObject := Value as TBaseObject;
end;

procedure TfrmQuickView.VisitSlotting(ASlotting: TIDObject);
begin

end;

procedure TfrmQuickView.VisitTestInterval(ATestInterval: TIDObject);
begin

end;

procedure TfrmQuickView.VisitWell(AWell: TIDObject);
begin

end;

procedure TfrmQuickView.VisitLicenseZone(ALicenseZone: TIDObject);
begin
  VisitOldLicenseZone(ALicenseZone as TOldLicenseZone);
end;

procedure TfrmQuickView.VisitCollectionSample(
  ACollectionSample: TIDObject);
begin

end;

procedure TfrmQuickView.VisitCollectionWell(AWell: TIDObject);
begin

end;

procedure TfrmQuickView.VisitDenudation(ADenudation: TIDObject);
begin

end;

procedure TfrmQuickView.VisitWellCandidate(AWellCandidate: TIDObject);
begin

end;

end.
