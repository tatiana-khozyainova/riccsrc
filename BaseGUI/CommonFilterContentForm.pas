unit CommonFilterContentForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFilter, StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmFilterContent = class(TForm)
    mmFilterContent: TRichEdit;
    pnlTop: TPanel;
    Label1: TLabel;
    procedure FormClick(Sender: TObject);
    procedure mmFilterContentMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FWellFilters: TWellFilters;
    procedure SetWellFilters(const Value: TWellFilters);
    { Private declarations }
  public
    { Public declarations }
    property WellFilters: TWellFilters read FWellFilters write SetWellFilters;
  end;

var
  frmFilterContent: TfrmFilterContent;

implementation

{$R *.dfm}

procedure TfrmFilterContent.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFilterContent.SetWellFilters(const Value: TWellFilters);
var i: integer;
begin
  FWellFilters := Value;

  mmFilterContent.Clear;
  for i := 0 to FWellFilters.WellFilterCount - 1 do
  if FWellFilters.WellFilters[i].LastFilter <> '' then 
  begin
    mmFilterContent.Lines.Add(FWellFilters.WellFilters[i].RusTableName);
    mmFilterContent.Lines.Add('  ' + FWellFilters.WellFilters[i].FilterTextValues);
    mmFilterContent.Lines.Add('');
  end;
end;

procedure TfrmFilterContent.mmFilterContentMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then Close;
end;

end.
