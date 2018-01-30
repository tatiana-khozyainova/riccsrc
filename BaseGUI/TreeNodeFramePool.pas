  {#Author fmarakasov@ugtu.net}
unit TreeNodeFramePool;

interface

uses
  Forms, Classes, TreeNodeFrame, Contnrs, DBTV;

type

  ///  Класс, поддерживающий создание фреймов на основе их типа.
  ///  TFramesPool гарантирует, что будет создан только один экземпляр фрейма каждого из типов
  ///  Доступ к объектам осуществляется через свойство InstanceOf
  TTreeNodeFramesPool = class (TComponent)
  private
    FPool: TObjectList;
    function GetItems(Index: integer): TTreeNodeBaseFrame;
    function GetAppBaseFrame( KeyFrameClass : TTreeNodeBaseFrameClass ) : TTreeNodeBaseFrame;
    function GetAppBaseFrameOfNode(AppBaseFrameClass : TTreeNodeBaseFrameClass;
      ADBNodeObject: TDBNodeObject): TTreeNodeBaseFrame;
  public
    // Для получения экземпляра класса вспользуйтесь методом GetInstance
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetInstance: TTreeNodeFramesPool;
    procedure Clear(FreeItems: boolean);

    property Items[Index: integer]: TTreeNodeBaseFrame read GetItems;
    function FindInstance(AppBaseFrameClass : TTreeNodeBaseFrameClass ): TTreeNodeBaseFrame; overload;
    function FindInstance(ADBNodeObject: TDBNodeObject): TTreeNodeBaseFrame; overload;

    function FindInstance(AFrame: TFrame): integer; overload;
    procedure DeleteInstance(const AIndex: Integer);


    property InstanceOf[AppBaseFrameClass : TTreeNodeBaseFrameClass ] : TTreeNodeBaseFrame read GetAppBaseFrame;
    property InstanceOfNode[AppBaseFrameClass : TTreeNodeBaseFrameClass; ADBNodeObject: TDBNodeObject]: TTreeNodeBaseFrame read GetAppBaseFrameOfNode;
  end;

implementation

uses SysUtils, Controls;

{ TTreeNodeFramesPool }

destructor TTreeNodeFramesPool.Destroy;
begin
  inherited;
  FreeAndNil(FPool);
end;

function TTreeNodeFramesPool.FindInstance(
  AppBaseFrameClass: TTreeNodeBaseFrameClass): TTreeNodeBaseFrame;
var i: integer;
begin
  Result := nil;
  for i := 0 to FPool.Count - 1 do
  if Items[i].ClassType = AppBaseFrameClass then
  begin
    Result := Items[i];
    break;
  end;
end;

function TTreeNodeFramesPool.GetAppBaseFrame(KeyFrameClass: TTreeNodeBaseFrameClass): TTreeNodeBaseFrame;
begin
  Result := FindInstance(KeyFrameClass);

  if not Assigned(Result) then
  begin
    Result := KeyFrameClass.Create(Self);
    Result.Name := Result.ClassName + IntToStr(Random(10000));
    FPool.Add(Result);
  end; 
end;


constructor TTreeNodeFramesPool.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FPool := TObjectList.Create(false);

end;

class function TTreeNodeFramesPool.GetInstance: TTreeNodeFramesPool;
const FInstance: TTreeNodeFramesPool = nil;
begin
  If FInstance = nil Then
    FInstance := TTreeNodeFramesPool.Create(Application);
  Result := FInstance;
end;

function TTreeNodeFramesPool.GetItems(Index: integer): TTreeNodeBaseFrame;
begin
  Result := FPool.Items[Index] as TTreeNodeBaseFrame;
end;

procedure TTreeNodeFramesPool.Clear(FreeItems: boolean);
var i: integer;
begin
  if FreeItems then
  for i := 0 to FPool.Count - 1 do
    FPool.Items[i].Free;

  FPool.Clear;
end;

function TTreeNodeFramesPool.GetAppBaseFrameOfNode(AppBaseFrameClass : TTreeNodeBaseFrameClass;
  ADBNodeObject: TDBNodeObject): TTreeNodeBaseFrame;
begin
  Result := FindInstance(ADBNodeObject);

  if not Assigned(Result) then
  begin
    Result := AppBaseFrameClass.Create(Self);
    Result.Name := Result.ClassName + IntToStr(Random(10000));    
    FPool.Add(Result);
    Result.NodeObject := ADBNodeObject;
  end;
end;

function TTreeNodeFramesPool.FindInstance(
  ADBNodeObject: TDBNodeObject): TTreeNodeBaseFrame;
var i: integer;
begin
  Result := nil;
  for i := 0 to FPool.Count - 1 do
  if Items[i].NodeObject = ADBNodeObject then
  begin
    Result := Items[i];
    break;
  end;
end;

function TTreeNodeFramesPool.FindInstance(
  AFrame: TFrame): integer;
begin
  Result := FPool.IndexOf(AFrame);
end;

procedure TTreeNodeFramesPool.DeleteInstance(const AIndex: Integer);
begin
  FPool.Delete(AIndex);
end;

end.
