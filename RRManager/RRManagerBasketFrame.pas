unit RRManagerBasketFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBaseGUI, RRManagerObjects, RRManagerBaseObjects, Contnrs,
  StdCtrls, ComCtrls, ExtCtrls, ToolWin, ImgList, RRManagerReport, BaseObjects;

  {$DEFINE LIC}
  //{$DEFINE STRUCT}
type
  TBasketItem = class(TObject)
  private
    FOwnerDefinition: string;
    FBasketObject: TBaseObject;
  public
    property BasketObject: TBaseObject read FBasketObject write FBasketObject;
    property Definition: string read FOwnerDefinition write FOwnerDefinition;
  end;

  TBasket = class(TObjectList)
  private
    function GetItems(const Index: integer): TBasketItem;
  public
    property    Items[const Index: integer]: TBasketItem read GetItems;
    function    Add(AObject: TBaseObject): integer;
    function    FindByClassType(AFrom: integer; AClassType: TClass): integer;
    function    Find(AUIN: integer; AClassType: TClass): integer;
    constructor Create;
    destructor  Destroy; override;
  end;

  TfrmBasket = class(TFrame, IConcreteVisitor)
    gbxAll: TGroupBox;
    pnlTop: TPanel;
    lwBasket: TListView;
    tlbr: TToolBar;
    cmbxType: TComboBox;
    ToolButton1: TToolButton;
    imgList: TImageList;
    pnlButtons: TPanel;
    btnClose: TButton;
    tlbrBasketActions: TToolBar;
    procedure cmbxTypeChange(Sender: TObject);
  private
    FActiveObject: TBaseObject;
    FBasket: TBasket;
    FBaseObjectClass: TBaseObjectClass;
    FActnList: TBaseActionList;
    FOnGetFromBasket: TNotifyEvent;
    FPuttingClass: TBaseObjectClass;
    procedure SetBaseObjectClass(const Value: TBaseObjectClass);
    function  GetActiveClassObjectsCount: integer;
    function GetGettingObject: TBaseObject;
    function GetConcreteVisitor: IConcreteVisitor;
    { Private declarations }
  protected
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function  GetActiveObject: TIDObject;
    procedure SetActiveObject(const Value: TIDObject);
  public
    { Public declarations }
    property  ConcreteVisitor: IConcreteVisitor read GetConcreteVisitor;
    property  Basket: TBasket read FBasket;
    property  PuttingObject: TBaseObject read FActiveObject write FActiveObject;
    property  GettingObject: TBaseObject read GetGettingObject;
    property  ActiveClass: TBaseObjectClass read FBaseObjectClass write SetBaseObjectClass;
    property  ActiveClassObjectsCount: integer read GetActiveClassObjectsCount;

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

    procedure VisitWell(AWell: TIDObject);
    procedure VisitTestInterval(ATestInterval: TIDObject);
    procedure VisitSlotting(ASlotting: TIDObject);
    procedure VisitLicenseZone(ALicenseZone: TIDObject);

    procedure VisitCollectionWell(AWell: TIDObject);
    procedure VisitCollectionSample(ACollectionSample: TIDObject);
    procedure VisitDenudation(ADenudation: TIDObject);
    procedure VisitWellCandidate(AWellCandidate: TIDObject);




    procedure Clear;
    procedure Reload;

    property  OnGetFromBasket: TNotifyEvent read FOnGetFromBasket write FOnGetFromBasket;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.dfm}

uses RRManagerBasketActions, ActnList;

type
  TImmediatelyPutToBasket = class(TPutToBasketAction)
  public
    function Update: boolean; override;
    function Execute: boolean; override;
  end;

  TImmediatelyGetFromBasket = class(TGetFromBasketAction)
  public
    function Update: boolean; override;
    function Execute: boolean; override;
    function Execute(AObject: TBaseObject): boolean; override;
  end;

  TDeleteFromBasket = class(TBaseAction)
  public
    function Update: boolean; override;
    function Execute: boolean; override;
  end;


  TBasketActionList = class(TBaseActionList)
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;


{ TfrmBasket }

function TfrmBasket._AddRef: Integer;
begin
  Result := 0;
end;

function TfrmBasket._Release: Integer;
begin
  Result := 0;
end;

procedure TfrmBasket.Clear;
begin
  Basket.Clear;
  lwBasket.Items.Clear;
end;

constructor TfrmBasket.Create(AOwner: TComponent);
var actn: TBaseAction; 
begin
  inherited;
  FBasket := TBasket.Create;

  //
  FActnList := TBasketActionList.Create(Self);
  FActnList.Images := imgList;
  {$IFDEF STRUCT}
  cmbxType.Items.AddObject('выявленная структура', TObject(TOldDiscoveredStructure));
  cmbxType.Items.AddObject('подготовленная структура', TObject(TOldPreparedStructure));
  cmbxType.Items.AddObject('структура в бурении', TObject(TOldDrilledStructure));
  cmbxType.Items.AddObject('месторождение', TObject(TOldField));
  cmbxType.Items.AddObject('структура (прочие)', TObject(TOldStructure));

  cmbxType.Items.AddObject('горизонт', TObject(TOldHorizon));
  cmbxType.Items.AddObject('подструктура', TObject(TOldSubstructure));
  cmbxType.Items.AddObject('продуктивный пласт', TObject(TOldLayer));
  cmbxType.Items.AddObject('элемент истории', TObject(TOldStructureHistoryElement));

  cmbxType.Items.AddObject('документ', TObject(TOldAccountVersion));
  {$ENDIF}

  {$IFDEF LIC}
  cmbxType.Items.AddObject('лицензионный участок', TObject(TOldLicenseZone));
  {$ENDIF}

  AddToolButton(tlbrBasketActions, FActnList.ActionByClassType[TDeleteFromBasket]);
  AddToolButton(tlbrBasketActions, FActnList.ActionByClassType[TGetFromBasketAction]);
  AddToolButton(tlbrBasketActions, FActnList.ActionByClassType[TPutToBasketAction]);
end;

destructor TfrmBasket.Destroy;
begin
  FBasket.Free;
  FActnList.Free;
  inherited;
end;

procedure TfrmBasket.VisitBed(ABed: TOldBed);
begin
  ActiveClass := TOldBed;
  PuttingObject := ABed;
end;

procedure TfrmBasket.VisitDiscoveredStructure(
  ADiscoveredStructure: TOldDiscoveredStructure);
begin
  ActiveClass := TOldDiscoveredStructure;
  PuttingObject := ADiscoveredStructure;
end;

procedure TfrmBasket.VisitDrilledStructure(
  ADrilledStructure: TOldDrilledStructure);
begin
  ActiveClass := TOldDrilledStructure;
  PuttingObject := ADrilledStructure;
end;

procedure TfrmBasket.VisitField(AField: TOldField);
begin
  ActiveClass := TOldField;
  PuttingObject := AField;  
end;

procedure TfrmBasket.VisitHorizon(AHorizon: TOldHorizon);
begin
  ActiveClass := TOldHorizon;
  PuttingObject := AHorizon;
end;

procedure TfrmBasket.VisitLayer(ALayer: TOldLayer);
begin
  ActiveClass := TOldLayer;
  PuttingObject := ALayer;
end;

procedure TfrmBasket.VisitPreparedStructure(
  APreparedStructure: TOldPreparedStructure);
begin
  ActiveClass := TOldPreparedStructure;
end;

procedure TfrmBasket.VisitStructure(AStructure: TOldStructure);
begin
  ActiveClass := TOldStructure;
  PuttingObject := AStructure;
end;

procedure TfrmBasket.VisitSubstructure(ASubstructure: TOldSubstructure);
begin
  ActiveClass := TOldSubstructure;
  PuttingObject := ASubStructure;  
end;

procedure TfrmBasket.Reload;
var i: integer;
    li: TListItem;
begin
  lwBasket.Clear;
  lwBasket.Selected := nil;
  for i := 0 to Basket.Count - 1 do
  if Basket.Items[i].BasketObject is ActiveClass then
  begin
    li := lwBasket.Items.Add;
    li.Data := Basket.Items[i];
    li.Caption := Basket.Items[i].Definition;
  end;
end;

procedure TfrmBasket.SetBaseObjectClass(const Value: TBaseObjectClass);
begin
  if FBaseObjectClass <> Value then
  begin
    FBaseObjectClass := Value;
    cmbxType.ItemIndex := cmbxType.Items.IndexOfObject(TObject(FBaseObjectClass));
    Reload;
  end;
end;

function TfrmBasket.GetActiveClassObjectsCount: integer;
begin
  Result := lwBasket.Items.Count;
end;

procedure TfrmBasket.VisitAccountVersion(AAccountVersion: TOldAccountVersion);
begin
  ActiveClass := TOldAccountVersion;
  PuttingObject := AAccountVersion;
end;

function TfrmBasket.GetGettingObject: TBaseObject;
begin
  Result := nil;
  if Assigned(lwBasket.Selected) then
    Result := TBasketItem(lwBasket.Selected.Data).BasketObject;
end;

function TfrmBasket.GetConcreteVisitor: IConcreteVisitor;
begin
  Result := IConcreteVisitor(Self);
end;

procedure TfrmBasket.VisitStructureHistoryElement(
  AHistoryElement: TOldStructureHistoryElement);
begin
  ActiveClass := TOldStructureHistoryElement;
  PuttingObject := AHistoryElement;
end;

procedure TfrmBasket.VisitVersion(AVersion: TOldVersion);
begin
  ActiveClass := TOldVersion;
  PuttingObject := AVersion;
end;

procedure TfrmBasket.VisitOldLicenseZone(ALicenseZone: TOldLicenseZone);
begin
  ActiveClass := TOldLicenseZone;
  PuttingObject := ALicenseZone;
end;

function TfrmBasket.GetActiveObject: TIDObject;
begin
  Result := nil;
end;

procedure TfrmBasket.SetActiveObject(const Value: TIDObject);
begin

end;


procedure TfrmBasket.VisitSlotting(ASlotting: TIDObject);
begin

end;

procedure TfrmBasket.VisitTestInterval(ATestInterval: TIDObject);
begin

end;

procedure TfrmBasket.VisitWell(AWell: TIDObject);
begin

end;

procedure TfrmBasket.VisitLicenseZone(ALicenseZone: TIDObject);
begin

end;

procedure TfrmBasket.VisitCollectionSample(ACollectionSample: TIDObject);
begin

end;

procedure TfrmBasket.VisitCollectionWell(AWell: TIDObject);
begin

end;

procedure TfrmBasket.VisitDenudation(ADenudation: TIDObject);
begin

end;

procedure TfrmBasket.VisitWellCandidate(AWellCandidate: TIDObject);
begin

end;

{ TBasket }

function TBasket.Add(AObject: TBaseObject): integer;
var bi: TBasketItem;
begin
  Result := Find(AObject.ID, AObject.ClassType);
  if Result = -1 then
  begin
    bi := TBasketItem.Create;
    Result := inherited Add(bi);
    bi.BasketObject := TBaseClass(AObject.ClassType).Create(nil);
  end
  else bi := Items[Result];


  bi.BasketObject.Assign(AObject);
  bi.Definition :=  AObject.List(loMedium, false, false);
end;

constructor TBasket.Create;
begin
  inherited Create(true);
end;

destructor TBasket.Destroy;
begin
  inherited;
end;

function TBasket.Find(AUIN: integer; AClassType: TClass): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
  if (Items[i].BasketObject is AClassType) and (Items[i].BasketObject.ID = AUIN) then
  begin
    Result := i;
    break;
  end;
end;

function TBasket.FindByClassType(AFrom: integer;
  AClassType: TClass): integer;
var i: integer;
begin
  Result := -1;
  for i := AFrom to Count - 1 do
  if (Items[i].BasketObject is AClassType) then
  begin
    Result := i;
    break;
  end;
end;

function TBasket.GetItems(const Index: integer): TBasketItem;
begin
  Result := inherited Items[Index] as TBasketItem;
end;

procedure TfrmBasket.cmbxTypeChange(Sender: TObject);
begin
  ActiveClass := TBaseObjectClass(cmbxType.Items.Objects[cmbxType.ItemIndex]);
end;

{ TBasketActionList }

constructor TBasketActionList.Create(AOwner: TComponent);
var actn: TBaseAction;
begin
  inherited;
  actn := TImmediatelyPutToBasket.Create(Self);
  actn.ActionList := Self;
  actn.ImageIndex := 0;

  actn := TImmediatelyGetFromBasket.Create(Self);
  actn.ActionList := Self;  
  actn.ImageIndex := 1;

  actn := TDeleteFromBasket.Create(Self);
  actn.ActionList := Self;  
  actn.ImageIndex := 2;
end;

destructor TBasketActionList.Destroy;
begin

  inherited;
end;

{ TImmediatelyPutToBasket }

function TImmediatelyPutToBasket.Execute: boolean;
begin
  Result := Execute(((Owner as TBaseActionList).Owner as TfrmBasket).PuttingObject);
end;

function TImmediatelyPutToBasket.Update: boolean;
begin
  Result := Assigned(((Owner as TBaseActionList).Owner as TfrmBasket).PuttingObject);
  Enabled := Result;
  if Result then Result := inherited Update;
end;

{ TImmediatelyGetFromBasket }

function TImmediatelyGetFromBasket.Execute: boolean;
begin
  Result := Execute(((Owner as TBaseActionList).Owner as TfrmBasket).GettingObject) ;
  ((Owner as TBaseActionList).Owner as TfrmBasket).btnClose.ModalResult := mrOk;
end;

function TImmediatelyGetFromBasket.Execute(AObject: TBaseObject): boolean;
begin
  Result := inherited Execute(AObject);
  if Result then
  with (Owner as TBaseActionList).Owner as TfrmBasket do
  if Assigned(FOnGetFromBasket) then FOnGetFromBasket(nil);
end;

function TImmediatelyGetFromBasket.Update: boolean;
var cls: TClass;
    bo: TBaseObject;
begin
  Result := Assigned(((Owner as TBaseActionList).Owner as TfrmBasket).GettingObject) and Assigned(((Owner as TBaseActionList).Owner as TfrmBasket).ActiveClass);
  if Result then
  begin
    cls := ((Owner as TBaseActionList).Owner as TfrmBasket).ActiveClass;

    bo := ((Owner as TBaseActionList).Owner as TfrmBasket).GettingObject;
    Result := Result and (bo is cls);
  end;
  Enabled := Result;
  inherited Update;
end;

{ TDeleteFromBasket }

function TDeleteFromBasket.Execute: boolean;
var i: integer;
begin
  with (Owner as TBaseActionList).Owner as TfrmBasket do
  begin
    i := FBasket.Find(GettingObject.ID, GettingObject.ClassType);
    if i > -1 then FBasket.Delete(i);
    Reload;
  end;
end;

function TDeleteFromBasket.Update: boolean;
begin
  Result := Assigned(((Owner as TBaseActionList).Owner as TfrmBasket).GettingObject);
  Enabled := Result;
end;

end.
