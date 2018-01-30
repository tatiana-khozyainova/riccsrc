unit CommonValueDictFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit, BaseObjects, Registrator;

type
  TfrmFilter = class(TFrame)
    gbx: TGroupBox;
    cbxActiveObject: TComboEdit;
    procedure cbxActiveObjectButtonClick(Sender: TObject);
  private
    FActiveObject: TIDObject;
    FAllObjects: TRegisteredIDObjects;
    procedure SetActiveObject(const Value: TIDObject);
    { Private declarations }
  public
    property    ActiveObject: TIDObject read FActiveObject write SetActiveObject;
    property    AllObjects: TRegisteredIDObjects read FAllObjects write FAllObjects;

    procedure   Reload;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses CommonValueDictSelectForm;

{$R *.dfm}

procedure TfrmFilter.cbxActiveObjectButtonClick(Sender: TObject);
begin
  if Assigned (AllObjects) then
  begin
    frmValueDictSelect := TfrmValueDictSelect.Create(Self);
    frmValueDictSelect.AllObjects := AllObjects;

    if Assigned (ActiveObject) then
      frmValueDictSelect.ActiveObject := ActiveObject;

    if frmValueDictSelect.ShowModal = mrOk then
    begin
      ActiveObject := frmValueDictSelect.ActiveObject;
      Reload;
    end;

    frmValueDictSelect.Free;
  end
  else MessageBox(0, 'Справочник для объекта не указан.' + #10#13 + 'Обратитесь к разработчику.', 'Сообщение', MB_OK + MB_APPLMODAL + MB_ICONWARNING)
end;

constructor TfrmFilter.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmFilter.Destroy;
begin

  inherited;
end;

procedure TfrmFilter.Reload;
begin
  if Assigned (ActiveObject) then
  begin
    cbxActiveObject.Text := trim(ActiveObject.List);
    cbxActiveObject.Hint := trim(ActiveObject.List);
  end
  else
  begin
    cbxActiveObject.Text := '';
    cbxActiveObject.Hint := '';
  end;
end;

procedure TfrmFilter.SetActiveObject(const Value: TIDObject);
begin
  if FActiveObject <> Value then
  begin
    FActiveObject := Value;
    Reload;
  end;  
end;

end.
