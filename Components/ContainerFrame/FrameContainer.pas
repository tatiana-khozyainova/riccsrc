unit FrameContainer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ActnList, ComCtrls, ToolWin, BaseContainedFrame, Contnrs;

type


  TfrmContainer = class(TFrame)
    tlbrOperations: TToolBar;
    tlbtnAddContainer: TToolButton;
    tlbtnDeleteContainer: TToolButton;
    actnlst: TActionList;
    actnAdd: TAction;
    actnDelete: TAction;
    pnlAll: TPanel;
    procedure actnAddExecute(Sender: TObject);
    procedure actnDeleteExecute(Sender: TObject);
    procedure actnDeleteUpdate(Sender: TObject);
  private
    { Private declarations }
    FMultiselect: boolean;
    FFrameList: TObjectList;
    FDefaultContainedFrameClass: TContainedFrameClass;
    function GetItems(Index: Integer): TfrmContained;
    function GetFrameCount: integer;
    function GetFreeName(APrefix: string): string;
    function GetComponentByName(AName: string): TComponent;
    function GetSelectedCount: integer;
  public
    { Public declarations }
    property Items[Index: Integer]: TfrmContained read GetItems;
    property FrameCount: integer read GetFrameCount;
    property SelectedCount: integer read GetSelectedCount;

    property MultiSelect: boolean read FMultiselect write FMultiselect;
    function  AddFrame(FrameClass: TContainedFrameClass): TfrmContained; virtual;
    procedure DeleteFrames; virtual;
    procedure ClearFrames; virtual;

    property ContainedFrameClass: TContainedFrameClass read FDefaultContainedFrameClass write FDefaultContainedFrameClass;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.dfm}

procedure TfrmContainer.actnAddExecute(Sender: TObject);
begin
  AddFrame(ContainedFrameClass);
end;


function TfrmContainer.AddFrame(
  FrameClass: TContainedFrameClass): TfrmContained;
begin
  Result := FrameClass.Create(Self);
  Result.Top := pnlAll.Height;
  Result.Parent := pnlAll;

  FFrameList.Add(Result);
  Result.Name := GetFreeName(FrameClass.ClassName);
  Result.Selected := true;  
end;

constructor TfrmContainer.Create(AOwner: TComponent);
begin
  inherited;
  FFrameList := TObjectList.Create(False);
  FDefaultContainedFrameClass := TfrmContained;
end;

destructor TfrmContainer.Destroy;
begin
  FreeAndNil(FFrameList);
  inherited;
end;

function TfrmContainer.GetComponentByName(AName: string): TComponent;
var i: integer;
begin
  Result := nil;
  for i := 0 to ComponentCount - 1 do
  if Components[i].Name = AName then
  begin
    Result := Components[i];
    break;
  end;
end;

function TfrmContainer.GetFrameCount: integer;
begin
  Result := FFrameList.Count;
end;

function TfrmContainer.GetFreeName(APrefix: string): string;
var iLastIndex: integer;
begin
  iLastIndex := FFrameList.Count;
  Result := APrefix + IntToStr(iLastIndex);
  while Assigned(GetComponentByName(Result)) do
  begin
    Inc(iLastIndex);
    Result := APrefix + IntToStr(iLastIndex);
  end;
end;

function TfrmContainer.GetItems(Index: Integer): TfrmContained;
begin
  Result := FFrameList[index] as TfrmContained;
end;

procedure TfrmContainer.actnDeleteExecute(Sender: TObject);
begin
  DeleteFrames; 
end;

procedure TfrmContainer.actnDeleteUpdate(Sender: TObject);
begin
  actnDelete.Enabled := FrameCount > 0;
end;

function TfrmContainer.GetSelectedCount: integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to FrameCount - 1 do
    Result := Result + Ord(Items[i].Selected);
end;

procedure TfrmContainer.DeleteFrames;
var i: Integer;
begin
  for i := FrameCount - 1 downto 0 do
  if Items[i].Selected then
  begin
    FFrameList[i].Free;
    FFrameList.Delete(i);
  end;
end;

procedure TfrmContainer.ClearFrames;
var i: integer;
begin
  for i := FrameCount - 1 downto 0 do
    Items[i].Free;

  FFrameList.Clear;  
end;

end.
