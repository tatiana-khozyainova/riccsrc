unit CommonValueDictSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registrator, BaseObjects;

type
  TfrmValueDictSelect = class(TForm)
    lblCaption: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    lstObjects: TListBox;
    edtSearch: TEdit;
    procedure edtSearchChange(Sender: TObject);
    procedure lstObjectsDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstObjectsClick(Sender: TObject);
    procedure lstObjectsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    FActiveObjects: TRegisteredIDObjects;
    FAllObjects: TRegisteredIDObjects;
    FActiveObject: TIDObject;

    HintRowT : Integer; // Номер строки в списке, на которую указывает мышь
    HintStringT : string;
  public

    // Обработчик подсказок
    procedure OnShowHint(var HintStr: string; var CanShow: Boolean;
      var HintInfo: THintInfo);

    property ActiveObject: TIDObject read FActiveObject write FActiveObject;
    property ActiveObjects: TRegisteredIDObjects read FActiveObjects write FActiveObjects;
    property AllObjects: TRegisteredIDObjects read FAllObjects write FAllObjects;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmValueDictSelect: TfrmValueDictSelect;

implementation

{$R *.dfm}

{ TForm2 }

constructor TfrmValueDictSelect.Create(AOwner: TComponent);
begin
  inherited;
  FActiveObjects := TRegisteredIDObjects.Create;

  HintRowT := -1;
  Application.OnShowHint := OnShowHint; // Установка обработчика
end;

destructor TfrmValueDictSelect.Destroy;
begin
  FActiveObjects.Free;
  inherited;
end;

procedure TfrmValueDictSelect.edtSearchChange(Sender: TObject);
var i: integer;
    o : TRegisteredIDObject;
begin
  if trim (edtSearch.Text) <> '' then
  begin
    FActiveObjects.Clear;

    for i := 0 to AllObjects.Count - 1 do
    if Pos(AnsiLowerCase(trim(edtSearch.Text)), AnsiLowerCase(FAllObjects.Items[i].Name)) > 0 then
    begin
      o := FAllObjects.Items[i] as TRegisteredIDObject;
      FActiveObjects.Add(o, false, false);
    end;

    FActiveObjects.MakeList(lstObjects.Items);
  end
  else FAllObjects.MakeList(lstObjects.Items);
end;

procedure TfrmValueDictSelect.lstObjectsDblClick(Sender: TObject);
begin
  if lstObjects.Items.Count > 0 then
  if lstObjects.ItemIndex > -1 then
    ActiveObject := lstObjects.Items.Objects[lstObjects.ItemIndex] as TIDObject;

  btnOK.Click;
end;

{
function TfrmValueDictSelect.GetActiveObject: TIDObject;
begin
  Result := nil;

  if (lstObjects.Items.Count > 0) and (lstObjects.ItemIndex > -1) then
    Result := lstObjects.Items.Objects[lstObjects.ItemIndex] as TRegisteredIDObject;
end;
}

procedure TfrmValueDictSelect.FormShow(Sender: TObject);
begin
  AllObjects.MakeList(lstObjects.Items);

  if Assigned (ActiveObject) then
    edtSearch.Text := ActiveObject.Name;

  edtSearch.SetFocus;
end;

procedure TfrmValueDictSelect.lstObjectsClick(Sender: TObject);
begin
  if lstObjects.Items.Count > 0 then
  if lstObjects.ItemIndex > -1 then
    ActiveObject := lstObjects.Items.Objects[lstObjects.ItemIndex] as TIDObject;
end;

procedure TfrmValueDictSelect.OnShowHint(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if not (HintInfo.HintControl is TListBox) then Exit;
  with HintInfo.HintControl as TListBox do begin
    HintInfo.HintPos := lstObjects.ClientToScreen(Point(21,
      lstObjects.ItemRect(HintRowT).Top + 1));
    HintStr := HintStringT;
  end;
end;

procedure TfrmValueDictSelect.lstObjectsMouseMove(Sender: TObject;
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

end.
