unit AllObjectsFilterFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registrator;

type
  TfrmAllObjs = class(TFrame)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    edtSearch: TEdit;
    lstObjects: TListBox;
    procedure edtSearchChange(Sender: TObject);
    procedure lstObjectsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    FActiveObjects: TRegisteredIDObjects;
    FAllObjects: TRegisteredIDObjects;

    HintRowT : Integer; // Номер строки в списке, на которую указывает мышь
    HintStringT : string;
  public
    // все объекты
    property AllObjects: TRegisteredIDObjects read FAllObjects write FAllObjects;
    // только выбранные объекты
    property ActiveObjects: TRegisteredIDObjects read FActiveObjects write FActiveObjects;

    // Обработчик подсказок
    procedure OnShowHint(var HintStr: string; var CanShow: Boolean;
      var HintInfo: THintInfo);

    constructor Create (AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses BaseObjects;

{$R *.dfm}

{ TfrmAllObjs }

constructor TfrmAllObjs.Create(AOwner: TComponent);
begin
  inherited;
  FActiveObjects := TRegisteredIDObjects.Create;

  HintRowT := -1;
  Application.OnShowHint := OnShowHint; // Установка обработчика
end;

destructor TfrmAllObjs.Destroy;
begin
  FActiveObjects.Free;
  inherited;
end;

procedure TfrmAllObjs.edtSearchChange(Sender: TObject);
var i: integer;
    o : TIDObject;
begin
  if (trim (edtSearch.Text) <> '') and (trim (edtSearch.Text) <> '<введите фильтр поиска>') then
  begin
    FActiveObjects.Clear;

    for i := 0 to AllObjects.Count - 1 do
    if Pos(AnsiLowerCase(trim(edtSearch.Text)), AnsiLowerCase(FAllObjects.Items[i].Name)) > 0 then
    begin
      o := FAllObjects.Items[i];
      FActiveObjects.Add (o, false, false);
    end;

    FActiveObjects.MakeList(lstObjects.Items);
  end
  else FAllObjects.MakeList(lstObjects.Items);
end;

procedure TfrmAllObjs.lstObjectsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var ItemNum: Integer;
begin
  ItemNum := lstObjects.ItemAtPos(Point(X, Y), True);
  if (ItemNum <> HintRowT) then
  begin
    HintRowT := ItemNum;
    Application.CancelHint;
    if HintRowT > -1 then
    begin
      HintStringT := lstObjects.Items[ItemNum];
      if (lstObjects.Canvas.TextWidth(HintStringT) <= lstObjects.ClientWidth - 25) then
        HintStringT := '';
    end
    else
      HintStringT := '';
  end;
end;

procedure TfrmAllObjs.OnShowHint(var HintStr: string; var CanShow: Boolean;
  var HintInfo: THintInfo);
begin
  if not (HintInfo.HintControl is TListBox) then Exit;
  with HintInfo.HintControl as TListBox do begin
    HintInfo.HintPos := lstObjects.ClientToScreen(Point(21,
      lstObjects.ItemRect(HintRowT).Top + 1));
    HintStr := HintStringT;
  end;
end;

end.
