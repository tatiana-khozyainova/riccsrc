unit KDictionary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, KDictionaryFrame;

type
  TfrmListWords = class(TForm)
    frmDictionary: TfrmDictionary;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmListWords: TfrmListWords;

implementation

{$R *.dfm}

constructor TfrmListWords.Create(AOwner: TComponent);
begin
  inherited;
  frmDictionary.Parent := Self;
end;

destructor TfrmListWords.Destroy;
begin

  inherited;
end;

procedure TfrmListWords.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not frmDictionary.Escaping then
    frmDictionary.Closing := true
  else frmDictionary.Escaping := false;
end;

procedure TfrmListWords.FormShow(Sender: TObject);
begin
  frmDictionary.MakeListWords;
  frmDictionary.Escaping := false; 
  frmDictionary.Closing := false;
  frmDictionary.Entering := false;
end;

end.
