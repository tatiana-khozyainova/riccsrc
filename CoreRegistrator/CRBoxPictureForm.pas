unit CRBoxPictureForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CRBoxPictureFrame, StdCtrls, ExtCtrls, SlottingPlacement, SlottingWell;

type
  TfrmBoxPictureForm = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lblBox: TLabel;
    frmBoxPicture1: TfrmBoxPicture;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FViewOnly: boolean;
    { Private declarations }
    function GetBoxes: TBoxes;
    procedure SetBoxes(const Value: TBoxes);
    procedure SetWell(const Value: TSlottingWell);
    procedure ReloadCaption;
    function  GetWell: TSlottingWell;
    procedure SetViewOnly(const Value: boolean);

  public
    { Public declarations }
    property  Well: TSlottingWell read GetWell write SetWell;
    property  Boxes: TBoxes read GetBoxes write SetBoxes;

    property  ViewOnly: boolean read FViewOnly write SetViewOnly;


    procedure Reload;
  end;

var
  frmBoxPictureForm: TfrmBoxPictureForm;
  frmBoxPictureViewForm: TfrmBoxPictureForm;
  
implementation

uses BaseObjects;

{$R *.dfm}

procedure TfrmBoxPictureForm.btnOKClick(Sender: TObject);
begin
  frmBoxPicture1.Save;
end;

function TfrmBoxPictureForm.GetBoxes: TBoxes;
begin
  Result := frmBoxPicture1.Boxes;
end;

procedure TfrmBoxPictureForm.Reload;
begin
  ReloadCaption;
  frmBoxPicture1.actnOpenPictureExecute(Self) 
end;

procedure TfrmBoxPictureForm.ReloadCaption;
var s: string;
begin
  if Assigned(Well) then s := Well.List(loBrief) + '; ';
  if (Boxes.Count > 0) then s := s + 'ящик є ' + Boxes.Items[0].List(loBrief);
  lblBox.Caption := s;
end;

procedure TfrmBoxPictureForm.SetBoxes(const Value: TBoxes);
begin
  frmBoxPicture1.Boxes := Value;
end;

procedure TfrmBoxPictureForm.SetWell(const Value: TSlottingWell);
begin
  frmBoxPicture1.Well := Value;
end;

procedure TfrmBoxPictureForm.btnCancelClick(Sender: TObject);
begin
  frmBoxPicture1.Reload;
end;

function TfrmBoxPictureForm.GetWell: TSlottingWell;
begin
  Result := frmBoxPicture1.Well;
end;

procedure TfrmBoxPictureForm.SetViewOnly(const Value: boolean);
begin
  if FViewOnly <> Value then
  begin
    FViewOnly := Value;
    frmBoxPicture1.ViewOnly := FViewOnly;
  end;
end;

end.
