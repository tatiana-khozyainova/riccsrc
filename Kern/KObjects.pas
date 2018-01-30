unit KObjects;

interface

uses Well, CoreDescription, Slotting, SysUtils;

type
  TDescriptedWell = class(TWell)
  protected
    function    GetSlottings: TSlottings; override;


  end;

  TDescriptedWells = class(TWells)
  private
    function GetItems(Index: integer): TDescriptedWell;
  public
    property Items[Index: integer]: TDescriptedWell read GetItems;
    constructor Create; override;

  end;

implementation

uses Contnrs;

{ TDescriptedWell }

function TDescriptedWell.GetSlottings: TSlottings;
begin
  if not Assigned(FSlottings) then
  begin
    try
      FSlottings := TDescriptedSlottings.Create;
      FSlottings.Owner := Self;
      FSlottings.Reload('well_uin = ' + IntToStr(id) + ' and dtm_kern_take_date is not null');
    except
      FSlottings := nil;
    end;
  end;

  Result := FSlottings;
end;

{ TDescriptedWells }

constructor TDescriptedWells.Create;
begin
  inherited;
  FObjectClass := TDescriptedWell;

  OwnsObjects := true;
end;

function TDescriptedWells.GetItems(Index: integer): TDescriptedWell;
begin
  Result := inherited Items[Index] as TDescriptedWell;
end;

end.
