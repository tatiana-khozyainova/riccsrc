unit AllObjectsCbxFilterFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, Registrator;

type
  TfrmAllObjectsFilter = class(TFrame)
    GroupBox2: TGroupBox;
    edtFilter: TEdit;
    cbxAllObjects: TComboBox;
    btnEditor: TBitBtn;
    procedure edtFilterChange(Sender: TObject);
  private
    FActiveObjects: TRegisteredIDObjects;
    FAllObjects: TRegisteredIDObjects;
  public
    // все объекты
    property AllObjects: TRegisteredIDObjects read FAllObjects write FAllObjects;
    // только выбранные объекты
    property ActiveObjects: TRegisteredIDObjects read FActiveObjects write FActiveObjects;

    constructor Create (AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.dfm}

{ TFrame1 }

constructor TfrmAllObjectsFilter.Create(AOwner: TComponent);
begin
  inherited;
  AllObjects := TRegisteredIDObjects.Create;
  //AllObjects.MakeList(cbxAllObjects.Items);
end;

destructor TfrmAllObjectsFilter.Destroy;
begin

  inherited;
end;

procedure TfrmAllObjectsFilter.edtFilterChange(Sender: TObject);
var i: integer;
    o : TRegisteredIDObject;
begin
  if not Assigned (FActiveObjects) then
    FActiveObjects := TRegisteredIDObjects.Create;

  if (trim (edtFilter.Text) <> '') and (trim (edtFilter.Text) <> '<введите фильтр поиска>') then
  begin
    FActiveObjects.Clear;

    for i := 0 to cbxAllObjects.Items.Count - 1 do
    if Pos(AnsiLowerCase(trim(edtFilter.Text)), AnsiLowerCase(FAllObjects.Items[i].Name)) > 0 then
    begin
      o := FAllObjects.Items[i] as TRegisteredIDObject;
      FActiveObjects.Add (o, false, false);
    end;
  end;
end;

end.
