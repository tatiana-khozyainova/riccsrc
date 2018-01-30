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
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{ TfrmReportsAtrtribute }

constructor TfrmReportsAtrtribute.Create(AOwner: TComponent);
var i: integer;
begin
  inherited;
  FAtr:=varArrayCreate([0,1,0,18],varVariant);
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
  for i:=0 to VarArrayHighBound(FAtr,2)-1 do lstAllAttribute.Items.AddObject(FAtr[1,i],TObject(Integer(FAtr[0,i])));
end;

end.
