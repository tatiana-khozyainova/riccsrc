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
  // ����� ����������� ���� ����������� - � ��������� ��������, �������� � �������
end;

end.
