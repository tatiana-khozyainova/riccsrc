unit DNRClientAboutForm;

interface

uses
  Classes, Forms, Controls, ExtCtrls, StdCtrls, ShellAPI, Graphics;

type
  TfrmAbout = class(TForm)
    btnOK: TButton;
    lblName: TLabel;
    StaticText1: TStaticText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    imgPassportIcon: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}

procedure TfrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caHide;
end;

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmAbout.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
{  if ((X>=Label2.Left)and(X<=Label2.Left+Label2.Width)
   and(Y>=Label2.Top)and(Y<=Label2.Top+Label2.Height))then
  begin
    Label2.Font.Color:=clBlue;
    Label2.Font.Style:=[fsUnderline];
  end
  else begin
    Label2.Font.Color:=clWindowText;
    Label2.Font.Style:=[];
  end;}
end;

procedure TfrmAbout.Label2Click(Sender: TObject);
begin
  ShellExecute(0,'Open','mailto:1190@server','','',1);
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  Self.imgPassportIcon.Picture.Icon:= Application.Icon;
end;

end.
