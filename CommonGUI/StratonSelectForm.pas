unit StratonSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectListForm, CommonIDObjectListFrame, StdCtrls,
  ExtCtrls;

type
  TfrmStratonSelect = class(TfrmIDObjectList)
    gbxSearch: TGroupBox;
    edtSearch: TEdit;
    procedure frmIDObjectListFramelwObjectsDblClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmStratonSelect: TfrmStratonSelect;

implementation

uses Facade, SDFacade, ComCtrls;

{$R *.dfm}

{ TfrmStratonSelect }

constructor TfrmStratonSelect.Create(AOwner: TComponent);
begin
  inherited;
  IDObjects := TMainFacade.GetInstance.AllSimpleStratons;
  Caption := 'Стратиграфическое подразделение';
  frmIDObjectListFrame.lwObjects.HideSelection := false;
end;

procedure TfrmStratonSelect.frmIDObjectListFramelwObjectsDblClick(
  Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmStratonSelect.edtSearchChange(Sender: TObject);
var i, iPos, iMinPos, iIndex: integer;
begin
  inherited;
  iMinPos := 1000;

  with frmIDObjectListFrame.lwObjects do
  if Items.Count > 0 then 
  begin
    iIndex := 0;
    for i := 0 to Items.Count - 1 do
    begin
      iPos := pos(AnsiUpperCase(edtSearch.Text), AnsiUpperCase(Items[i].SubItems[0]));
      if iPos > 0 then
      begin
        if iPos <= iMinPos then
        begin
          iMinPos := iPos;
          iIndex := i;
        end;
      end;
    end;
    Selected := Items[iIndex];
    Selected.MakeVisible(false);
  end;
end;

end.
