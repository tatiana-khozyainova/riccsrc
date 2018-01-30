unit FrameReportsAttribute;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, ToolWin;

type
  TfrmReportsAtrtribute = class(TFrame)
    lstAllAttribute: TListBox;
    lstCurrentAttribute: TListBox;
    btn1: TButton;
    tlbManipulAttribute: TToolBar;
    btn2: TToolButton;
    btn4: TToolButton;
    btn7: TButton;
    btn8: TButton;
    btn9: TButton;
  private
    { Private declarations }
    FAtr:variant;
    FFlag:Integer;
  public
    { Public declarations }
    property Flag:Integer read FFlag write FFlag;
    procedure AddList();
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{ TfrmReportsAtrtribute }

procedure TfrmReportsAtrtribute.AddList();
var i:integer;
begin
  case Flag of
  1:for i:=0 to 29 do lstAllAttribute.Items.AddObject(FAtr[1,i],TObject(Integer(FAtr[0,i])));
  2:for i:=18 to 24 do lstAllAttribute.Items.AddObject(FAtr[1,i],TObject(Integer(FAtr[0,i])));
  3:for i:=25 to 30 do lstAllAttribute.Items.AddObject(FAtr[1,i],TObject(Integer(FAtr[0,i])));
  end;
end;

constructor TfrmReportsAtrtribute.Create(AOwner: TComponent);
var i: integer;
begin
  inherited;
  FAtr:=varArrayCreate([0,1,0,29],varVariant);
  FAtr[0,0]:=0;FAtr[1,0]:='����������� �����';
  FAtr[0,1]:=1;FAtr[1,1]:='��� �����';
  FAtr[0,2]:=2;FAtr[1,2]:='��������';
  FAtr[0,3]:=3;FAtr[1,3]:='������';
  FAtr[0,4]:=4;FAtr[1,4]:='��������';
  FAtr[0,5]:=5;FAtr[1,5]:='���� ��������';
  FAtr[0,6]:=6;FAtr[1,6]:='�����������������';
  FAtr[0,7]:=7;FAtr[1,7]:='����� ��������';
  FAtr[0,8]:=8;FAtr[1,8]:='��� �����';
  FAtr[0,9]:=9;FAtr[1,9]:='����� �����';
  FAtr[0,10]:=10;FAtr[1,10]:='������������';
  FAtr[0,11]:=11;FAtr[1,11]:='�������';
  FAtr[0,12]:=12;FAtr[1,12]:='������ �����';
  FAtr[0,13]:=13;FAtr[1,13]:='��������� �����';
  FAtr[0,14]:=14;FAtr[1,14]:='����� ��';
  FAtr[0,15]:=15;FAtr[1,15]:='�������';
  FAtr[0,16]:=16;FAtr[1,16]:='������ ������';
  FAtr[0,17]:=17;FAtr[1,17]:='�������������';

  FAtr[0,18]:=18;FAtr[1,18]:='��� ����������';
  FAtr[0,19]:=19;FAtr[1,19]:='���. �����������';
  FAtr[0,20]:=20;FAtr[1,20]:='����� ���������';
  FAtr[0,21]:=21;FAtr[1,21]:='��� ��������';
  FAtr[0,22]:=22;FAtr[1,22]:='����� ��������';
  FAtr[0,23]:=23;FAtr[1,23]:='�������� ��������';
  FAtr[0,24]:=24;FAtr[1,24]:='������������';

  FAtr[0,25]:=25;FAtr[1,25]:='����� �������������';
  FAtr[0,26]:=26;FAtr[1,26]:='��� �������������';
  FAtr[0,27]:=27;FAtr[1,27]:='������';
  FAtr[0,28]:=28;FAtr[1,28]:='����� �������������';
  FAtr[0,29]:=30;FAtr[1,29]:='����������';






  end;

end.
