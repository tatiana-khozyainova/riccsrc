unit CRPartPlacementsEditorFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonParentChildTreeFrame, ComCtrls, CommonObjectSelector, ImgList,
  BaseObjects, ExtCtrls, CommonFrame, CRPartPlacementEditorFrame;

type
  TfrmPartPlacements = class(TfrmParentChild)
    frmPartPlacement1: TfrmPartPlacement;
    spl1: TSplitter;
  private
    { Private declarations }

  public
    { Public declarations }

    constructor Create(AOwner: TComponent); override;
  end;

var
  frmPartPlacements: TfrmPartPlacements;

implementation

{$R *.dfm}

{ TfrmPartPlacements }


{ TfrmPartPlacements }

constructor TfrmPartPlacements.Create(AOwner: TComponent);
begin
  inherited;
  SelectableLayers := [1, 2];
end;

end.
