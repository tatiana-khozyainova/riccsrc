unit SubDividerComponentEditForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SubDividerEditFrame, Menus;

type
  TfrmEditAll = class(TForm)
    frmEditSubDivision1: TfrmEditSubDivision;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    //procedure ChangeSelection(var Message: TMessage); message WM_SELECTION_CHANGED;
  public
    { Public declarations }
    
  end;

var
  frmEditAll: TfrmEditAll;

implementation

{$R *.DFM}

{procedure TfrmEditAll.ChangeSelection(var Message: TMessage);
begin
  with frmEditSubDivision1.sgrSubDivision do
  begin
    if Message.WParam > -1 then
       Col := Message.WParam;
    if Message.LParam > -1 then
       Row := Message.LParam;
  end;
end;}

procedure TfrmEditAll.FormCreate(Sender: TObject);
begin
  frmEditSubDivision1.ReportFormat := false;
  frmEditSubDivision1.frmSubComponentEdit1.WithButtons := false;
  frmEditSubDivision1.DoubleBuffered := true;
end;

end.
