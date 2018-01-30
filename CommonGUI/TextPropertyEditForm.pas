unit TextPropertyEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmTextEdit = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    gbxAll: TGroupBox;
    mmText: TRichEdit;
  private
    function GetText: string;
    procedure SetText(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property Text: string read GetText write SetText;
  end;

var
  frmTextEdit: TfrmTextEdit;

implementation

{$R *.dfm}

{ TfrmTextEdit }

function TfrmTextEdit.GetText: string;
begin
  Result := Trim(mmText.Lines.Text);
end;

procedure TfrmTextEdit.SetText(const Value: string);
begin
  mmText.Lines.Text := Trim(Value);
end;

end.
