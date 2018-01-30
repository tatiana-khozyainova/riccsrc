unit WellPanelFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, Well, StdCtrls, BaseObjects;

type
  TfrmWellPanel = class(TfrmCommonFrame)
    redtWell: TRichEdit;
  private
    { Private declarations }
    function GetWell: TWell;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;    
  public
    { Public declarations }
    property    Well: TWell read GetWell;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmWellPanel: TfrmWellPanel;

implementation

{$R *.dfm}

{ TfrmWellPanel }

procedure TfrmWellPanel.ClearControls;
begin
  redtWell.Clear;
end;

constructor TfrmWellPanel.Create(AOwner: TComponent);
begin
  inherited;
  StatusBar.Visible := false;
  EditingClass := TSimpleWell;
end;

procedure TfrmWellPanel.FillControls(ABaseObject: TIDObject);
begin
  inherited;
  redtWell.Lines.Clear;
  redtWell.Lines.Add(Well.List + '. ' + Well.Category.Name + '. ' +
                     DateTimeToStr(Well.DtDrillingStart) + ' - ' +
                     DateTimeToStr(Well.DtDrillingFinish));
  redtWell.Lines.Add('Альтитуда: ' + Format('%.2f', [Well.Altitude]));
  redtWell.Lines.Add('Забой: ' + Format('%.2f', [Well.Depth]));  
end;

function TfrmWellPanel.GetWell: TWell;
begin
  Result := EditingObject as TWell;
end;

end.
