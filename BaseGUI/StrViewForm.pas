unit StrViewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmStringView = class(TForm)
    mmoStr: TMemo;
  private
    procedure SetText(const Value: string);
    function GetText: string;
    { Private declarations }
  public
    { Public declarations }
    property Text: string read GetText write SetText;
  end;

var
  frmStringView: TfrmStringView;

implementation

{$R *.dfm}

{ TfrmStringView }

function TfrmStringView.GetText: string;
begin
  Result := mmoStr.Text;
end;

procedure TfrmStringView.SetText(const Value: string);
begin
  mmoStr.text := Value;
end;

end.
