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
  FAtr[0,0]:=0;FAtr[1,0]:='Инвентарный номер';
  FAtr[0,1]:=1;FAtr[1,1]:='ТГФ номер';
  FAtr[0,2]:=2;FAtr[1,2]:='Название';
  FAtr[0,3]:=3;FAtr[1,3]:='Авторы';
  FAtr[0,4]:=4;FAtr[1,4]:='Привязки';
  FAtr[0,5]:=5;FAtr[1,5]:='Дата создания';
  FAtr[0,6]:=6;FAtr[1,6]:='Недропользователь';
  FAtr[0,7]:=7;FAtr[1,7]:='Место хранения';
  FAtr[0,8]:=8;FAtr[1,8]:='Тип работ';
  FAtr[0,9]:=9;FAtr[1,9]:='Метод работ';
  FAtr[0,10]:=10;FAtr[1,10]:='Сейсмопартия';
  FAtr[0,11]:=11;FAtr[1,11]:='Масштаб';
  FAtr[0,12]:=12;FAtr[1,12]:='Начало работ';
  FAtr[0,13]:=13;FAtr[1,13]:='Окончание работ';
  FAtr[0,14]:=14;FAtr[1,14]:='Карты ОГ';
  FAtr[0,15]:=15;FAtr[1,15]:='Разрезы';
  FAtr[0,16]:=16;FAtr[1,16]:='Состав отчета';
  FAtr[0,17]:=17;FAtr[1,17]:='Сейсмопрофили';

  FAtr[0,18]:=18;FAtr[1,18]:='Тип экземпляра';
  FAtr[0,19]:=19;FAtr[1,19]:='Кол. экземпляров';
  FAtr[0,20]:=20;FAtr[1,20]:='Место храниения';
  FAtr[0,21]:=21;FAtr[1,21]:='Тип элемента';
  FAtr[0,22]:=22;FAtr[1,22]:='Номер элемента';
  FAtr[0,23]:=23;FAtr[1,23]:='Описание элемента';
  FAtr[0,24]:=24;FAtr[1,24]:='Расположение';

  FAtr[0,25]:=25;FAtr[1,25]:='Номер сейсмопрофиля';
  FAtr[0,26]:=26;FAtr[1,26]:='Тип сейсмопрофиля';
  FAtr[0,27]:=27;FAtr[1,27]:='Пикеты';
  FAtr[0,28]:=28;FAtr[1,28]:='Длина сейсмопрофиля';
  FAtr[0,29]:=30;FAtr[1,29]:='Координата';






  end;

end.
