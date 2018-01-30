unit CRPartPlacementEditorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, SlottingPlacement, StdCtrls, ExtCtrls, BaseObjects;

type
  TfrmPartPlacement = class(TfrmCommonFrame)
    gbxProperties: TGroupBox;
    edtName: TLabeledEdit;
    cmbxType: TComboBox;
    lblType: TLabel;
    lblPlacement: TLabel;
    cmbxPlacementType: TComboBox;
  private
    { Private declarations }
    function GetPlacement: TPartPlacement;
  protected
    procedure FillControls(ABaseObject: TIDObject); override; 
  public
    { Public declarations }
    property Placement: TPartPlacement read GetPlacement;
    destructor Destroy; override;
  end;

var
  frmPartPlacement: TfrmPartPlacement;

implementation

{$R *.dfm}

{ TfrmPartPlacement }

destructor TfrmPartPlacement.Destroy;
begin

  inherited;
end;

procedure TfrmPartPlacement.FillControls(ABaseObject: TIDObject);
begin
  inherited;

end;

function TfrmPartPlacement.GetPlacement: TPartPlacement;
begin
  Result := inherited EditingObject as TPartPlacement; 
end;

end.
