unit CommonComplexIDCombo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonComplexCombo, StdCtrls, BaseObjects, Registrator;

type
  TfrmIDObjectListCombo = class(TfrmComplexCombo)
    procedure btnShowAdditionalClick(Sender: TObject);
    procedure cmbxNameChange(Sender: TObject);
  private
    { Private declarations }
    FLoadedList: TIDObjects;
    FSelectedObject: TIDObject;
    procedure SetSelectedObject(const Value: TIDObject);
    procedure SetLoadedList(const Value: TIDObjects);
  protected
    procedure InternalShowAdditional; override;
  public
    { Public declarations }
    // добавляем элемент, а если такой есть - то выбираем
    procedure Clear; override;    
    property LoadedList: TIDObjects read FLoadedList write SetLoadedList;
    property SelectedObject: TIDObject read FSelectedObject write SetSelectedObject;
    function AddItem(const AID: integer; const AName: string): integer; override;
  end;

var
  frmIDObjectListCombo: TfrmIDObjectListCombo;

implementation

uses BaseDicts;

{$R *.dfm}

{ TComplexIDObjectListCombo }

function TfrmIDObjectListCombo.AddItem(const AID: integer;
  const AName: string): integer;
var b: TIDObject;
begin
  //Result := inherited AddItem(AID, AName);

  b := FLoadedList.ItemsByID[AID];
  if Assigned(b) then
  begin
    b.ID := AID;
    b.Name := AName
  end
  else b := FLoadedList.Add(AID, AName);

  FSelectedObject := b;
  Result := cmbxName.Items.IndexOfObject(b);
  cmbxName.ItemIndex := Result;  
end;


procedure TfrmIDObjectListCombo.SetLoadedList(const Value: TIDObjects);
begin
  if FLoadedList <> Value then
  begin
    FLoadedList := Value;
    (FLoadedList as TRegisteredIDObjects).MakeList(cmbxName.Items, true, true);
  end;
end;

procedure TfrmIDObjectListCombo.SetSelectedObject(const Value: TIDObject);
begin
  if FSelectedObject <> Value then
  begin
    FSelectedObject := Value;
    if Assigned(FSelectedObject) then
      AddItem(FSelectedObject.ID, FSelectedObject.Name);
  end;
end;

procedure TfrmIDObjectListCombo.btnShowAdditionalClick(Sender: TObject);
begin
  inherited;
  if cmbxName.ItemIndex > -1 then SelectedObject := cmbxName.Items.Objects[cmbxName.ItemIndex] as TIDObject
  else SelectedObject := nil;
end;

procedure TfrmIDObjectListCombo.InternalShowAdditional;
begin
  CmplxList.IDObjects := LoadedList;
end;

procedure TfrmIDObjectListCombo.cmbxNameChange(Sender: TObject);
begin
  inherited;
  if cmbxName.ItemIndex > -1 then SelectedObject := TIDObject(cmbxName.Items.Objects[cmbxName.ItemIndex])
  else SelectedObject := nil;
end;

procedure TfrmIDObjectListCombo.Clear;
begin
  inherited;
  FSelectedObject := nil;
end;

end.
