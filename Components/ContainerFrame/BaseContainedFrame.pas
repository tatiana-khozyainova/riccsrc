unit BaseContainedFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TfrmContained = class(TFrame)
    pnlMain: TPanel;
    procedure pnlMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FSelected: boolean;
    FLastSelected: boolean;
    procedure SetSelected(const Value: boolean);
    procedure SetLastSelected(const Value: boolean);
  public
    { Public declarations }
    // выделенный
    property Selected: boolean read FSelected write SetSelected;
    // выделенный последним - в фокусе
    property LastSelected: boolean read FLastSelected write SetLastSelected;
  end;

  TContainedFrameClass = class of TfrmContained;

implementation

uses FrameContainer;

{$R *.dfm}

{ TfrmContained }



procedure TfrmContained.SetSelected(const Value: boolean);
var i: integer;
begin
  if FSelected <> Value then
  begin
    FSelected := Value;
    if FSelected then
    begin
      pnlMain.BevelInner := bvNone;
      pnlMain.BevelOuter := bvLowered;
    end
    else
    begin
      pnlMain.BevelInner := bvRaised;
      pnlMain.BevelOuter := bvLowered;
    end;

    with Owner as TfrmContainer do
    begin
      if (not MultiSelect) and Selected then
      begin
        for i := 0 to FrameCount - 1 do
        if Items[i] <> Self then
          Items[i].Selected := false;
      end;
    end;
  end;

  if Selected then
    LastSelected := Selected;
end;

procedure TfrmContained.pnlMainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if (not (Owner as TfrmContainer).MultiSelect)
    or ((Owner as TfrmContainer).MultiSelect and (ssCtrl in Shift)) then
      Selected := not Selected;
  end;
end;

procedure TfrmContained.SetLastSelected(const Value: boolean);
var i: integer;
begin
  if FLastSelected <> Value then
  begin
    FLastSelected := Value;
    with Owner as TfrmContainer do
    begin
      if LastSelected then
      begin
        for i := 0 to FrameCount - 1 do
        if Items[i] <> Self then
          Items[i].LastSelected := false;
        pnlMain.BevelInner := bvLowered;
      end
      else
      begin
        if MultiSelect and Selected then
          pnlMain.BevelInner := bvNone
        else
          pnlMain.BevelInner := bvRaised;
      end;
    end;
  end;
end;

end.
