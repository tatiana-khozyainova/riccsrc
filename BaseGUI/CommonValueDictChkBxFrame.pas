unit CommonValueDictChkBxFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit, Registrator, BaseObjects;

type
  TfrmFilterChkBx = class(TFrame)
    grpgbx: TGroupBox;
    cbxActiveObjects: TComboEdit;
    procedure cbxActiveObjectsButtonClick(Sender: TObject);
  private
    FActiveObjects: TRegisteredIDObjects;
    FAllObjects: TRegisteredIDObjects;
    FObjectClass: TIDObjectClass;
    procedure SetActiveObjects(const Value: TRegisteredIDObjects);
    { Private declarations }
  public
    property    ActiveObjects: TRegisteredIDObjects read FActiveObjects write SetActiveObjects;
    property    AllObjects: TRegisteredIDObjects read FAllObjects write FAllObjects;
    // класс объектов
    property    ObjectClass: TIDObjectClass read FObjectClass write FObjectClass;

    procedure   Reload;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;  end;

implementation

uses CommonValueDictSelectChkBxForm, Well;

{$R *.dfm}

constructor TfrmFilterChkBx.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmFilterChkBx.Destroy;
begin

  inherited;
end;

procedure TfrmFilterChkBx.cbxActiveObjectsButtonClick(Sender: TObject);
var i: Integer;
    o : TRegisteredIDObject;
begin
  if Assigned (AllObjects) then
  begin
    frmValueDictSelectChkBx := TfrmValueDictSelectChkBx.Create(Self);
    frmValueDictSelectChkBx.AllObjects := AllObjects;

    if frmValueDictSelectChkBx.ShowModal = mrOk then
    begin
      if ObjectClass = TWellProperty then
      begin
        for i := 0 to frmValueDictSelectChkBx.lstObjects.Count - 1 do
        if frmValueDictSelectChkBx.lstObjects.Checked[i] then
          (ActiveObjects.Items[i] as TWellProperty).flShow := True
        else (ActiveObjects.Items[i] as TWellProperty).flShow := False;
      end
      else for i := 0 to frmValueDictSelectChkBx.lstObjects.Count - 1 do
           if frmValueDictSelectChkBx.lstObjects.Checked[i] then
           begin
             o := frmValueDictSelectChkBx.lstObjects.Items.Objects[i] as TRegisteredIDObject;
             ActiveObjects.Add(o);
           end;

      Reload;
    end;

    frmValueDictSelectChkBx.Free;
  end
  else MessageBox(0, 'Справочник для объекта не указан.' + #10#13 + 'Обратитесь к разработчику.', 'Сообщение', MB_OK + MB_APPLMODAL + MB_ICONWARNING)
end;

procedure TfrmFilterChkBx.Reload;
begin
  if Assigned (ActiveObjects) then
  begin
    if ObjectClass = TWellProperty then
      cbxActiveObjects.Text := (TWellProperties(ActiveObjects)).ObjectsToStr
    else cbxActiveObjects.Text := ActiveObjects.ObjectsToStr;

    cbxActiveObjects.Hint := cbxActiveObjects.Text;
  end
  else
  begin
    cbxActiveObjects.Text := '';
    cbxActiveObjects.Hint := '';
  end;
end;

procedure TfrmFilterChkBx.SetActiveObjects(
  const Value: TRegisteredIDObjects);
begin
  if FActiveObjects <> Value then
  begin
    FActiveObjects := Value;
    Reload;
  end;
end;

end.
