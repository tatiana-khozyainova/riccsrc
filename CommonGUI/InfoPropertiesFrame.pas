unit InfoPropertiesFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, Well;

type
  TfrmInfoProperties = class(TFrame)
    lstInfoPropertiesWell: TListView;
    procedure lstInfoPropertiesWellResize(Sender: TObject);
    procedure lstInfoPropertiesWellInfoTip(Sender: TObject;
      Item: TListItem; var InfoTip: String);
    procedure lstInfoPropertiesWellCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    FActiveWell: TWell;
  public
    property    ActiveWell: TWell read FActiveWell write FActiveWell;

    procedure   Reload;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.dfm}

{ TfrmInfoWells }

constructor TfrmInfoProperties.Create(AOwner: TComponent);
begin
  inherited;
  lstInfoPropertiesWell.Width := Self.Width;
end;

destructor TfrmInfoProperties.Destroy;
begin

  inherited;
end;

procedure TfrmInfoProperties.Reload;
begin

end;

procedure TfrmInfoProperties.lstInfoPropertiesWellResize(Sender: TObject);
begin
  lstInfoPropertiesWell.Columns[0].Width := lstInfoPropertiesWell.Width - 3;
end;

procedure TfrmInfoProperties.lstInfoPropertiesWellInfoTip(Sender: TObject;
  Item: TListItem; var InfoTip: String);
begin
  if Assigned(Item) then
    InfoTip := Item.Caption;
end;

procedure TfrmInfoProperties.lstInfoPropertiesWellCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var r: TRect;
    dx : integer;
begin
  r := Item.DisplayRect(drBounds);

  if Item.Index = lstInfoPropertiesWell.Items.Count - 1 then
  begin
    lstInfoPropertiesWell.Canvas.Pen.Color := $00ACB9AF;
    lstInfoPropertiesWell.Canvas.MoveTo(r.Left, r.Bottom);
    lstInfoPropertiesWell.Canvas.LineTo(r.Right, r.Bottom);
    lstInfoPropertiesWell.Canvas.FillRect(r);
    lstInfoPropertiesWell.Canvas.Font.Style := [fsBold];
    lstInfoPropertiesWell.Canvas.TextOut(r.Left + 2, r.Top, Item.Caption);
  end;

  if Item.Data <> TObject then
  begin
    if Assigned(Item.Data) then
    begin
      lstInfoPropertiesWell.Canvas.Brush.Color := clWhite;
      lstInfoPropertiesWell.Canvas.Font.Color := clNavy;
    end
    else
    begin
      lstInfoPropertiesWell.Canvas.Brush.Color := $00EFEFEF;
      lstInfoPropertiesWell.Canvas.Font.Color := clGreen;
    end;
    lstInfoPropertiesWell.Canvas.FillRect(r);
    lstInfoPropertiesWell.Canvas.Font.Style := [fsBold];
    lstInfoPropertiesWell.Canvas.TextOut(r.Left + 2, r.Top, Item.Caption);
  end
  else
  begin
    lstInfoPropertiesWell.Canvas.Brush.Color := $00E4EAD7;
    lstInfoPropertiesWell.Canvas.FillRect(r);
    lstInfoPropertiesWell.Canvas.Font.Color := $002B009E;//clMaroon;
    lstInfoPropertiesWell.Canvas.Font.Style := [fsBold];
    dx := lstInfoPropertiesWell.Canvas.TextWidth(Item.Caption) + 2;
    lstInfoPropertiesWell.Canvas.TextOut(r.Right - dx, r.Top, Item.Caption);
  end;
end;

end.
