{#Author fmarakasov@ugtu.net}
unit TreeNodeFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBTV, CoreInterfaces, ActnList, ExtCtrls, StdCtrls, ImgList;
type

  TTreeNodeBaseFrameClass = class of TTreeNodeBaseFrame;


  TTreeNodeBaseFrame = class(TFrame, IActionsProvider)
    pnlPlanName: TPanel;
    lbFrameCaption: TLabel;
    FrameImage: TPaintBox;
    procedure FrameImagePaint(Sender: TObject);
  private
    FFrameCategories : TStrings;
    FNodeObjectChangedEvent : TNotifyEvent;
    FNodeObject : TDBNodeObject;
    FDataChanged: boolean;
    procedure SetNodeObject(Value : TDBNodeObject);
    procedure SetFrameImage(DrawCanvas : TCanvas);
    { Private declarations }
  protected

    ///  Переопределите в производных классах, что бы иметь дополнительную обработку
    ///  события изменения значения свойства NodeObject
    ///  В базовой реализации метод вызывает событие NodeObjectChanged
    procedure OnNodeObjectChanged; virtual;

    { Переопределите в производных классах, что бы поддерживать нужный список действий и категорий }
    function GetFrameActions : TActionList; virtual;

    {IActionsProvider implementation}
    function GetMyActions : TActionList;
    function GetMyCategories : TStrings;

    ///
    ///  Получает коллецию категорий действий, которые поддерживает фрейм
    ///  Производный класс может модифицировать этот список. Лучшим местом
    ///  для этого является конструктор класса
    property ActionFrameCategories : TStrings read GetMyCategories;

    function GetDataChanged: boolean; virtual;
    procedure SetDataChanged(const Value: boolean); virtual;

  public
    { Public declarations }
    //   действия связанные с обновлением фрейма
    procedure RefreshContent; virtual;
    // состояние фрейма  - завершены в нем все действия или нет
    procedure Finish; virtual;
    procedure Cancel; virtual;

    constructor Create(AOwner : TComponent);override;
    destructor Destroy;override;
    // были произведены изменения
    property  DataChanged: boolean read GetDataChanged write SetDataChanged;

    ///
    ///  Узел дерева с которым сопоставлен фрейм
    ///
    property NodeObject : TDBNodeObject read FNodeObject write SetNodeObject;

    procedure GetState(AState: TObject); virtual;
    procedure SetState(AState: TObject); virtual;
  published

    ///
    ///  Событие, вызываемое изменением значения свойства NodeObject
    ///
    property NodeObjectChanged : TNotifyEvent read FNodeObjectChangedEvent write FNodeObjectChangedEvent;
  end;

implementation

  {$R *.dfm}

{ TAppBaseFrame }

procedure TTreeNodeBaseFrame.Cancel;
begin
  DataChanged := false;
end;

constructor TTreeNodeBaseFrame.Create(AOwner: TComponent);
begin
  inherited;
  FFrameCategories := TStringList.Create;
  DataChanged := false;
end;

destructor TTreeNodeBaseFrame.Destroy;
begin
  FFrameCategories.Free;
  inherited;
end;

procedure TTreeNodeBaseFrame.Finish;
begin
  DataChanged := false;
end;

procedure TTreeNodeBaseFrame.FrameImagePaint(Sender: TObject);
begin
  SetFrameImage(FrameImage.Canvas);
end;

function TTreeNodeBaseFrame.GetDataChanged: boolean;
begin
  Result := FDataChanged;
end;

function TTreeNodeBaseFrame.GetFrameActions: TActionList;
begin
  Result := nil;
end;


function TTreeNodeBaseFrame.GetMyActions: TActionList;
begin
  Result := GetFrameActions;
end;

function TTreeNodeBaseFrame.GetMyCategories: TStrings;
begin
  Result := FFrameCategories;
end;

procedure TTreeNodeBaseFrame.GetState(AState: TObject);
begin

end;

procedure TTreeNodeBaseFrame.OnNodeObjectChanged;
var sCaption: string;
    prnt: TDBNodeObject;
begin
  sCaption := '';
  prnt := NodeObject.Parent;
  while Assigned(prnt) do
  begin
    sCaption := sCaption + prnt.Node.Text + '\';
    prnt := prnt.Parent;
  end;

  lbFrameCaption.Caption :=  sCaption + NodeObject.Node.Text;

  RefreshContent;

  if Assigned(FNodeObjectChangedEvent) then
    FNodeObjectChangedEvent(Self);
end;

procedure TTreeNodeBaseFrame.RefreshContent;
begin

end;

procedure TTreeNodeBaseFrame.SetDataChanged(const Value: boolean);
begin
  FDataChanged := Value;
end;

procedure TTreeNodeBaseFrame.SetFrameImage(DrawCanvas : TCanvas);
var
  Images : TCustomImageList;
begin
  if FNodeObject = nil then Exit;
  if FNodeObject.Node.ImageIndex = -1 then Exit;
  Images := FNodeObject.TreeView.Images;
  if Images = nil then Exit;
  Images.Draw(DrawCanvas, 0, 0, FNodeObject.Node.ImageIndex);
end;

procedure TTreeNodeBaseFrame.SetNodeObject(Value: TDBNodeObject);
var
  NodeInterface : IInterface;
begin
  if Value = FNodeObject then Exit;
  FNodeObject := nil;
  FNodeObject := Value;
  if FNodeObject <> nil then
  begin
    FrameImage.Invalidate;
    NodeInterface := Value;
    NodeInterface._AddRef;
  end;

  OnNodeObjectChanged;
end;


procedure TTreeNodeBaseFrame.SetState(AState: TObject);
begin

end;

end.
