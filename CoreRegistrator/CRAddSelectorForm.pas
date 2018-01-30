unit CRAddSelectorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TAddSelection = (asCollection, asExponate, asNone);

  TfrmAddSelector = class(TForm)
    rgrpSelector: TRadioGroup;
    pnlBottom: TPanel;
    btnClose: TButton;
    chbxSaveSelection: TCheckBox;
    procedure chbxSaveSelectionClick(Sender: TObject);
    procedure rgrpSelectorClick(Sender: TObject);
  private
    { Private declarations }
    FSaveSelection: boolean;
    FAddSelection: TAddSelection;
  public
    { Public declarations }
    property Selection: TAddSelection read FAddSelection write FAddSelection;
    property SaveSelection: boolean read FSaveSelection write FSaveSelection;
  end;

var
  frmAddSelector: TfrmAddSelector;

implementation

{$R *.dfm}

procedure TfrmAddSelector.chbxSaveSelectionClick(Sender: TObject);
begin
  SaveSelection := chbxSaveSelection.Checked;
end;

procedure TfrmAddSelector.rgrpSelectorClick(Sender: TObject);
begin
  Selection := TAddSelection(rgrpSelector.ItemIndex);
end;

end.
