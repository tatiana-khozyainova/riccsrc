unit CRRackSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, ToolEdit;

type
  TfrmRackSelectForm = class(TForm)
    gbxRackSelect: TGroupBox;
    pnlButtons: TPanel;
    lblRack: TLabel;
    cmbxRack: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    chbxBlank: TCheckBox;
    chbxSaveFiles: TCheckBox;
    edtReportPath: TDirectoryEdit;
    procedure chbxSaveFilesClick(Sender: TObject);
  private
    function GetSelectedRack: integer;
    function GetSelectedRackRomanNumber: string;
    function GetNeedsBlank: boolean;
    function GetSaveResult: boolean;
    function GetSavingPath: string;
    { Private declarations }
  public
    { Public declarations }
    property    NeedsBlank: boolean read GetNeedsBlank;
    property    SelectedRack: integer read GetSelectedRack;
    property    SelectedRackRomanNumber: string read GetSelectedRackRomanNumber;
    property    SaveResult: boolean read GetSaveResult;
    property    SavingPath: string read GetSavingPath;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmRackSelectForm: TfrmRackSelectForm;

implementation

{$R *.dfm}

{ TfrmRackSelectForm }

constructor TfrmRackSelectForm.Create(AOwner: TComponent);
begin
  inherited;
  cmbxRack.AddItem('I', TObject(1));
  cmbxRack.AddItem('II', TObject(2));
  cmbxRack.AddItem('III', TObject(3));
  cmbxRack.AddItem('IV', TObject(4));
  cmbxRack.AddItem('V', TObject(5));
  cmbxRack.AddItem('VI', TObject(6));
  cmbxRack.AddItem('VII', TObject(7));
  cmbxRack.AddItem('VIII', TObject(8));
  cmbxRack.AddItem('IX', TObject(9));
  cmbxRack.AddItem('X', TObject(10));
  cmbxRack.AddItem('XI', TObject(11));
  cmbxRack.AddItem('XII', TObject(12));
  cmbxRack.ItemIndex := 0;
end;

function TfrmRackSelectForm.GetNeedsBlank: boolean;
begin
  Result := chbxBlank.Checked;
end;

function TfrmRackSelectForm.GetSaveResult: boolean;
begin
  Result := chbxSaveFiles.Checked;
end;

function TfrmRackSelectForm.GetSavingPath: string;
begin
  Result := edtReportPath.Text;
end;

function TfrmRackSelectForm.GetSelectedRack: integer;
begin
  Result := Integer(cmbxRack.Items.Objects[cmbxRack.ItemIndex]);
end;

function TfrmRackSelectForm.GetSelectedRackRomanNumber: string;
begin
  Result := cmbxRack.Items[cmbxRack.ItemIndex];
end;

procedure TfrmRackSelectForm.chbxSaveFilesClick(Sender: TObject);
begin
  edtReportPath.Enabled := SaveResult;
end;

end.
