unit Search;

interface

uses BaseObjects, Registrator, Classes;

type
  TSimpleSearch = class (TRegisteredIDObject)
  private
    FNameDict: string;
    FFieldSimple: boolean;
    FFieldDate: boolean;
    FNameCollection: TRegisteredIDObjects;
    FFieldDict: boolean;
    FFieldType: string;
    FOs: TIDObjects;
    FTextValue: string;
    FDateValue: TDateTime;
    FFieldName: string;
  public
    // ���������
    property NameCollection: TRegisteredIDObjects read FNameCollection write FNameCollection;
    // �������� �����������
    property NameDict: string read FNameDict write FNameDict;

    // ��� ����
    property FieldType: string read FFieldType write FFieldType;
    // �������� ����
    property FieldName: string read FFieldName write FFieldName;

    // ������� ������
    // ���������
    property Os: TIDObjects read FOs write FOs;
    // ����
    property DateValue: TDateTime read FDateValue write FDateValue;
    // �����
    property TextValue: string read FTextValue write FTextValue;

    // ����������
    property FieldDict: boolean read FFieldDict write FFieldDict;
    // ������� ����
    property FieldSimple: boolean read FFieldSimple write FFieldSimple;
    // ����
    property FieldDate: boolean read FFieldDate write FFieldDate;

    procedure Clear;
    procedure Reload;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TSimpleSearchs = class (TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TSimpleSearch;
  public
    property    Items[Index: Integer]: TSimpleSearch read GetItems;

    procedure   MakeList(ALst: TStrings; NeedsRegistering: boolean = true; NeedsClearing: boolean = true); overload; virtual;

    constructor Create; override;
  end;

implementation

uses SysUtils, Contnrs;

{ TSimpleSearch }

procedure TSimpleSearch.Clear;
begin
  FName := '';
  FNameDict := '';
  FFieldDate := false;
  FFieldSimple := false;
  FFieldDict := false;
end;

constructor TSimpleSearch.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := '�������������� ������';

  FOs := TIDObjects.Create;
  FOs.Owner := Self;

  DateValue := Date;
  TextValue := '';
end;

procedure TSimpleSearch.Reload;
begin

end;

{ TSimpleSearchs }

constructor TSimpleSearchs.Create;
begin
  inherited;
  FObjectClass := TSimpleSearch;

  OwnsObjects := true;
end;

function TSimpleSearchs.GetItems(Index: Integer): TSimpleSearch;
begin
  Result := inherited Items[Index] as TSimpleSearch; 
end;

procedure TSimpleSearchs.MakeList(ALst: TStrings; NeedsRegistering: boolean = true;
  NeedsClearing: boolean = true);
var i, j: integer;
begin
  if NeedsClearing then ALst.Clear;

  for i := 0 to Count - 1 do
  begin
    ALst.AddObject(Items[i].Name, Items[i]);
    for j := 0 to Items[i].Os.Count - 1 do
      ALst.AddObject('     ' + Items[i].Os.Items[j].Name, Items[i].Os.Items[j]);

    if Items[i].FFieldDate then ALst.AddObject('     ' + DateToStr(Items[i].FDateValue), nil);//, Items[i]);

    if Items[i].FFieldSimple then ALst.AddObject('     ' + Items[i].FTextValue, nil);//, Items[i]);
  end;
end;

end.
