unit KFindProperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, KFindPropertiesFrame;

type
  TfrmFind = class(TForm)
    frmFindProperties: TfrmFindProperties;
    procedure frmFindProperties1btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmFind: TfrmFind;

implementation

uses Facade;

{$R *.dfm}

{ TfrmFind }

constructor TfrmFind.Create(AOwner: TComponent);
begin
  inherited;
  // форма должна появляться в правом нижнем углу
  Left := Screen.Width - Width - 3 - 260;
  Top := Screen.Height - Height - 30 - 60;
end;

destructor TfrmFind.Destroy;
begin

  inherited;
end;

procedure TfrmFind.frmFindProperties1btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
