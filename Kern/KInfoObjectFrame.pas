unit KInfoObjectFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, KDescriptionKernFrame, ExtCtrls, ComCtrls, ActnList, Buttons,
  ToolWin, StdCtrls, ImgList, KDescription, Well, Slotting, CoreDescription,
  KInfoSlottingsFrame, KInfoPropertiesFrame;

type
  TfrmInfoObject = class(TFrame)
    Splitter1: TSplitter;
    frmInfoProperties: TfrmInfoProperties;
    frmInfoSlottings: TfrmInfoSlottings;
    procedure frmInfoSlottingstvwWellsGetImageIndex(Sender: TObject;
      Node: TTreeNode);
    procedure frmInfoSlottingstvwWellsClick(Sender: TObject);
    procedure frmInfoSlottingsToolButton2Click(Sender: TObject);
    procedure frmInfoSlottingsToolButton5Click(Sender: TObject);
  private
    function    GetActiveWell: TDescriptedWell;
  public
    property    ActiveWell: TDescriptedWell read GetActiveWell;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade;

{$R *.dfm}

{ TfrmInfoObject }

constructor TfrmInfoObject.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmInfoObject.Destroy;
begin

  inherited;
end;

procedure TfrmInfoObject.frmInfoSlottingstvwWellsGetImageIndex(
  Sender: TObject; Node: TTreeNode);
begin
  frmInfoSlottings.tvwWellsGetImageIndex(Sender, Node);
end;

function TfrmInfoObject.GetActiveWell: TDescriptedWell;
begin
  Result := nil;

  case frmInfoSlottings.tvwWells.Selected.Level of
    0 : Result := TDescriptedWell(frmInfoSlottings.tvwWells.Selected.Data);
    1 : Result := TDescriptedWell(frmInfoSlottings.tvwWells.Selected.Parent.Data);
    2 : Result := TDescriptedWell(frmInfoSlottings.tvwWells.Selected.Parent.Parent.Data);
  end;
end;

procedure TfrmInfoObject.frmInfoSlottingstvwWellsClick(Sender: TObject);
begin
  if frmInfoSlottings.tvwWells.Items.Count > 0 then
  begin
    frmInfoSlottings.tvwWellsClick(Sender);
    
    (TMainFacade.GetInstance as TMainFacade).ActiveWell := ActiveWell;

    frmInfoProperties.lstInfoPropertiesWell.Items.BeginUpdate;
    frmInfoProperties.ActiveWell := ActiveWell;
    ActiveWell.MakeList(frmInfoProperties.lstInfoPropertiesWell.Items, true);

    case frmInfoSlottings.tvwWells.Selected.Level of
      1 : frmInfoSlottings.ActiveSlotting.MakeList(frmInfoProperties.lstInfoPropertiesWell.Items);
      2 : begin
            frmInfoSlottings.ActiveSlotting.MakeList(frmInfoProperties.lstInfoPropertiesWell.Items);
            frmInfoSlottings.ActiveLayer.MakeList(frmInfoProperties.lstInfoPropertiesWell.Items);
          end;
    end;

    frmInfoProperties.lstInfoPropertiesWell.Items.EndUpdate;
  end;
end;

procedure TfrmInfoObject.frmInfoSlottingsToolButton2Click(Sender: TObject);
begin
  frmInfoSlottings.actnEditDescriptionExecute(Sender);

end;

procedure TfrmInfoObject.frmInfoSlottingsToolButton5Click(Sender: TObject);
begin
  frmInfoSlottings.actnAddLayerExecute(Sender);

end;

end.

