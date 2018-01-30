unit CommonValueDictSelectChkBxForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Registrator;

type
  TfrmValueDictSelectChkBx = class(TForm)
    lblCaption: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    edtSearch: TEdit;
    lstObjects: TCheckListBox;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FActiveObjects: TRegisteredIDObjects;
    FAllObjects: TRegisteredIDObjects;
  public
    property ActiveObjects: TRegisteredIDObjects read FActiveObjects write FActiveObjects;
    property AllObjects: TRegisteredIDObjects read FAllObjects write FAllObjects;



    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmValueDictSelectChkBx: TfrmValueDictSelectChkBx;

implementation

uses BaseObjects, Well;

{$R *.dfm}

constructor TfrmValueDictSelectChkBx.Create(AOwner: TComponent);
begin
  inherited;
  FActiveObjects := TRegisteredIDObjects.Create;

end;

destructor TfrmValueDictSelectChkBx.Destroy;
begin

  FActiveObjects.Free;
  inherited;
end;

procedure TfrmValueDictSelectChkBx.FormShow(Sender: TObject);
var i: Integer;
begin
  AllObjects.MakeList(lstObjects.Items);

  if AllObjects.ObjectClass = TWellProperty then
  for i := 0 to lstObjects.Count - 1 do
  begin
    if (lstObjects.Items.Objects[i] as TWellProperty).flShow then
      lstObjects.Checked[i] := True
    else lstObjects.Checked[i] := False;
  end
end;

procedure TfrmValueDictSelectChkBx.btnOKClick(Sender: TObject);
var i: Integer;
    o: TRegisteredIDObject;
begin
  for i := 0 to lstObjects.Count - 1 do
  if lstObjects.Checked[i] then
  begin
    o := lstObjects.Items.Objects[lstObjects.ItemIndex] as TRegisteredIDObject;
    FActiveObjects.Add(o, False, True);
  end;
end;

end.
