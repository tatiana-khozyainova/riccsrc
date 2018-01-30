unit CommonBasketFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseObjects, ComCtrls, ToolWin, Contnrs;

type
  TOnAcceptObjectEvent = procedure (ANewObject: TIDObject; var Accept: boolean);
  TOnPlaceObjectEvent = procedure (APlacingObject: TIDObject);

  TfrmBasketFrame = class(TFrame)
    lwBasket: TListView;
    procedure lwBasketDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  private
    { Private declarations }
    FIDObjects, FSelectiveIDObjects: TIDObjects;
    FIDObjectClassList: TClassList;
    FOnAccept: TOnAcceptObjectEvent;
    FOnPlace: TOnPlaceObjectEvent;
    FNewObject: TIDObject;
    FDragSources: TObjectList;
    function GetIDObjectClassTypes: TClassList;
    function GetBasketObjectView(AObject: TIDObject): integer;
    function GetDragSources: TObjectList;
    procedure DoEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure SetEndDrag(ANewSource: TObject);
  public
    { Public declarations }
    property    IDObjects: TIDObjects read FIDObjects;
    property    IDObjectClassTypes: TClassList read GetIDObjectClassTypes;

    function    Add(AObject: TIDObject): boolean; overload;
    function    Add(AObjects: TIDObjects): boolean; overload;

    function    GetObjectsByClassType(AClassType: TIDObjectClass): TIDObjects;

    property    OnAccept: TOnAcceptObjectEvent read FOnAccept write FOnAccept;
    property    OnPlace: TOnPlaceObjectEvent read FOnPlace write FOnPlace;

    property    NewObject: TIDObject read FNewObject write FNewObject;

    property    DragSources: TObjectList read GetDragSources;


    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.dfm}

{ TfrmBasketFrame }

function TfrmBasketFrame.Add(AObject: TIDObject): boolean;
var iSelectedIndex: integer;
    o: TIDObject;
begin
  if IDObjectClassTypes.IndexOf(AObject.ClassType) > -1 then
  begin
    Result := true;
    o := IDObjects.ItemsByIDAndClassType[TIDObjectClass(AObject.ClassType), AObject.ID];
    if not Assigned(o) then
    begin
      lwBasket.Selected := lwBasket.Items.Add;
      o := IDObjects.Add(AObject, false, false);
      lwBasket.Selected.Data := o;
      lwBasket.Selected.Caption := o.List(loFull);
    end
    else
    begin
      iSelectedIndex := GetBasketObjectView(o);
      if iSelectedIndex > -1 then lwBasket.Selected := lwBasket.Items[iSelectedIndex];
    end;
  end
  else Result := false;
end;

function TfrmBasketFrame.Add(AObjects: TIDObjects): boolean;
var i: integer;
begin
  Result := true;
  for i := 0 to AObjects.Count - 1 do
  begin
    Result := Result and Add(AObjects.Items[i]);
    if not Result then break;
  end;
end;

constructor TfrmBasketFrame.Create(AOwner: TComponent);
begin
  inherited;

  FIDObjects := TIDObjects.Create;
end;

destructor TfrmBasketFrame.Destroy;
begin
  FIDObjects.Free;
  if Assigned(FSelectiveIDObjects) then FSelectiveIDObjects.Free;
  inherited;
end;

procedure TfrmBasketFrame.DoEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  Add(NewObject);
end;

function TfrmBasketFrame.GetBasketObjectView(AObject: TIDObject): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to lwBasket.Items.Count - 1 do
  if lwBasket.Items[i].Data = AObject then
  begin
    Result := i;
    break;
  end;  
end;

function TfrmBasketFrame.GetDragSources: TObjectList;
begin
  if not Assigned(FDragSources) then
    FDragSources := TObjectList.Create(false);

  Result := FDragSources;
end;

function TfrmBasketFrame.GetIDObjectClassTypes: TClassList;
begin
  if not Assigned(FIDObjectClassList) then
    FIDObjectClassList := TClassList.Create;

  Result := FIDObjectClassList;
end;

function TfrmBasketFrame.GetObjectsByClassType(
  AClassType: TIDObjectClass): TIDObjects;
var i: integer;
begin
  if not Assigned(FSelectiveIDObjects) then
  begin
    FSelectiveIDObjects := TIDObjects.Create;
    FSelectiveIDObjects.OwnsObjects := false;
  end;

  for i := 0 to FIDObjects.Count - 1 do
  if FIDObjects.Items[i] is AClassType then
    FSelectiveIDObjects.Add(FIDObjects.Items[i], false, false);

  Result := FSelectiveIDObjects;
end;

procedure TfrmBasketFrame.lwBasketDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var iIndex: integer;
begin
  if Assigned(FNewObject) then
  begin
    iIndex := IDObjectClassTypes.IndexOf(FNewObject.ClassType);
    Accept := iIndex > -1;

    if Assigned(FOnAccept) then FOnAccept(FNewObject, Accept);

    if DragSources.IndexOf(Source) = -1 then
    begin
      DragSources.Add(Source);
      SetEndDrag(Source);
    end;
  end
  else Accept := false;
end;

procedure TfrmBasketFrame.SetEndDrag(ANewSource: TObject);
begin
  if (ANewSource is TTreeView) then
   (ANewSource as TTreeView).OnEndDrag := DoEndDrag;
end;

end.
