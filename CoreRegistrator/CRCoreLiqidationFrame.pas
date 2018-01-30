unit CRCoreLiqidationFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, StdCtrls, CheckLst, Well, BaseObjects;

type
  TfrmCoreLiquidaton = class(TfrmCommonFrame)
    gbxAll: TGroupBox;
    chklstSlottings: TCheckListBox;
    dtpLiqidationFrame: TDateTimePicker;
    lblLiquidationDate: TLabel;
    lblSlottings: TLabel;
  private

    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TIDObject); override;

  public

    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmCoreLiquidaton: TfrmCoreLiquidaton;

implementation

{$R *.dfm}

{ TfrmCoreLiquidaton }

constructor TfrmCoreLiquidaton.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TWell;
end;

procedure TfrmCoreLiquidaton.FillControls(ABaseObject: TIDObject);
begin
  inherited;
  if EditingObject is TWell then
  begin
    (EditingObject as TWell).Slottings.MakeList(chklstSlottings.Items);

  end;
end;

end.
