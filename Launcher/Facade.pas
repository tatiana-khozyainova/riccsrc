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
    // ������
    property Filter: string read FFilter write FFilter;
    // � ������������ ��������� � ������������� ������
    // ����������� � ������ ������� ����
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
  // ��������� ���������� � ��
  //DBGates.ServerClassString := 'RiccServer.CommonServer';
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;
  // ����������� ����� ��� ������� ���� ����� �������
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
