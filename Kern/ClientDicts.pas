unit ClientDicts;

interface

uses BaseDicts;

type

   TClientDicts = class(TDicts)
   public
     constructor Create; override;

   end;

implementation

{ TClientDicts }

constructor TClientDicts.Create;
begin
  inherited;
  // здесь добавляются свои справочники - с правилами загрузки, редакции и прочего
end;

end.
