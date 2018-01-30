unit CRSampleSizeTypeEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectEditForm;

type
  TfrmSampleSizeTypeEditor = class(TfrmIDObjectEdit)
  private
    { Private declarations }
  protected
    function GetEditingObjectName: string; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmSampleSizeTypeEditor: TfrmSampleSizeTypeEditor;

implementation

uses CRRockSampleSizeTypeEditFrame;

{$R *.dfm}

{ TfrmSampleSizeTypeEditor }

constructor TfrmSampleSizeTypeEditor.Create(AOwner: TComponent);
begin
  inherited;
  dlg.Clear;
  dlg.AddFrame(TfrmRockSampleSizeTypeEditFrame);

  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := 0;
  Caption := 'Типоразмер образца';
end;

function TfrmSampleSizeTypeEditor.GetEditingObjectName: string;
begin
  Result := 'Типоразмер образца';
end;

end.
