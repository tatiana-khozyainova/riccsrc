unit RRManagerBasketActions;

interface

uses RRManagerBaseGUI, RRManagerBasketFrame, RRManagerBasketForm, RRManagerBaseObjects;

type

   TPutToBasketAction = class(TBaseAction)
   public
     function Execute(ABaseObject: TBaseObject): boolean; override;
   end;

   TGetFromBasketAction = class(TBaseAction)
   public
     function Execute(ABaseObject: TBaseObject): boolean; override;
   end;


implementation

uses Classes;

{ TGetFromBasketAction }

function TGetFromBasketAction.Execute(ABaseObject: TBaseObject): boolean;
var bo: TBaseObject;
begin
  Result := false;
  if not Assigned(frmBasketView) then frmBasketView := TfrmBasketView.Create(ActionList.Owner);
  if ABaseObject is frmBasketView.frmBasket.ActiveClass then
  begin
    Result := true;
  end;
  // устроить загрузку в потомках
end;

{ TPutToBasketAction }

function TPutToBasketAction.Execute(ABaseObject: TBaseObject): boolean;
begin
  Result := true;
  if not Assigned(frmBasketView) then frmBasketView := TfrmBasketView.Create(ActionList.Owner);
  frmBasketView.frmBasket.Basket.Add(ABaseObject);
  // устроить добавление
  frmBasketView.frmBasket.Reload;
end;

end.
