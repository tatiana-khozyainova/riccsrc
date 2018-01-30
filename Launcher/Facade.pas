unit Facade;

interface

uses BaseFacades, Registrator, Classes, DBGate, SDFacade;

type
  TMainFacade = class (TSDFacade)
  private
    FFilter: string;
    FRegistrator: TRegistrator;
  protected
    function GetRegistrator: TRegistrator; override;
  public
    // фильтр
    property Filter: string read FFilter write FFilter;
    // в конструкторе создаются и настраиваются всякие
    // необходимые в скором времени вещи
    constructor Create(AOwner: TComponent); override;
  end;

  TConcreteRegistrator = class(TRegistrator)
  public
    constructor Create; override;
  end;

implementation


{ TMDFacade }

constructor TMainFacade.Create(AOwner: TComponent);
begin
  inherited;
  // настройка соединения с бд
  //DBGates.ServerClassString := 'RiccServer.CommonServer';
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;
  // обязательно также тип клиента прям здесь указать
end;

function TMainFacade.GetRegistrator: TRegistrator;
begin
  if not Assigned(FRegistrator) then
    FRegistrator := TConcreteRegistrator.Create;
  Result := FRegistrator;
end;


{ TConcreteRegistrator }

constructor TConcreteRegistrator.Create;
begin
  inherited;
  AllowedControlClasses.Add(TStringsRegisteredObject);
  AllowedControlClasses.Add(TTreeViewRegisteredObject);
end;


end.
