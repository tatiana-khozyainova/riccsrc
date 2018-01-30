unit SubDividerTectonicBlockForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, SubDividerCommonObjects, Variants;

type
  TfrmTectBlock = class(TForm)
    gbxTectBlock: TGroupBox;
    pnlButtons: TPanel;
    cmbxTectBlock: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure cmbxTectBlockChange(Sender: TObject);
  private
    { Private declarations }
    FWell: TWell;
    FSubDivision: TSubDivision;
    procedure SetWell(Value: TWell);
    procedure SetSubDivision(Value: TSubDivision);
  public
    { Public declarations }
    property Well: TWell read FWell write SetWell;
    property SubDivision: TSubDivision read FSubDivision write SetSubDivision;
  end;

var
  frmTectBlock: TfrmTectBlock;

implementation

uses SubDividerCommon;

{$R *.DFM}

procedure TfrmTectBlock.SetSubDivision(Value: TSubDivision);
begin
  FSubDivision := Value;
  with cmbxTectBlock do ItemIndex := Items.Add(Value.TectonicBlock);
  cmbxTectBlock.Sorted := true;
  btnOk.Enabled := cmbxTectBlock.ItemIndex > -1;  
end;

procedure TfrmTectBlock.SetWell(Value: TWell);
var i, j: integer;
    Found: boolean;
begin
  FWell := Value;
  cmbxTectBlock.Clear;
  for i := 0 to varArrayHighBound(AllDicts.TectBlockDict, 2) do
  begin
    cmbxTectBlock.Items.Add(AllDicts.TectBlockDict[1, i]);
  end;
  cmbxTectBlock.Sorted := true;
  btnOk.Enabled := cmbxTectBlock.ItemIndex > -1;  
end;

procedure TfrmTectBlock.cmbxTectBlockChange(Sender: TObject);
begin
  btnOk.Enabled := cmbxTectBlock.ItemIndex > -1;
end;

end.
