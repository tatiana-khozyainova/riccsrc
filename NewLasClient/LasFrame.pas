unit LasFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, LasFile;

type
  TFrame1 = class(TFrame)
    trwLas: TTreeView;
    lst1: TListBox;
    pnl1: TPanel;
    spl1: TSplitter;
    pnl2: TPanel;
    procedure lst1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
  public
    posString: array [1..1000] of Integer ;
    posColor : TColor;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrame1.lst1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  sb : TStringInBlock;
begin

     if  Assigned((Control as TListBox).Items.Objects[Index]) then
      begin
        sb:=TStringInBlock((Control as TListBox).Items.Objects[Index]);
        if (sb.State=NotDetected) then
          begin
            (Control as TListBox).Canvas.Brush.Color := clRed;
            (Control as TListBox).Canvas.Font.Color:=clWhite;
          end
        else
        if  (sb.State=Detected) then
          begin
            (Control as TListBox).Canvas.Brush.Color := clWhite;
            (Control as TListBox).Canvas.Font.Color := clBlack;
          end
        else
          begin
            (Control as TListBox).Canvas.Brush.Color := clYellow;
            (Control as TListBox).Canvas.Font.Color := clBlack;
          end;
      end;
      (Control as TListBox).Canvas.FillRect(Rect);
      (Control as TListBox).Canvas.TextOut(Rect.Left + 2, Rect.Top, (Control as TListBox).Items[Index])

end;

end.
