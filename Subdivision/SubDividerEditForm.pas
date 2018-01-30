unit SubDividerEditForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SubDividerComponentEditFrame;

type
  TfrmSubDivisionComponentEdit = class(TForm)
    frmSubComponentEdit1: TfrmSubComponentEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSubDivisionComponentEdit: TfrmSubDivisionComponentEdit;

implementation

{$R *.DFM}

procedure TfrmSubDivisionComponentEdit.FormCreate(Sender: TObject);
begin
  frmSubComponentEdit1.WithButtons := true;
end;

end.
