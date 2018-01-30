unit CommonIDObjectComboFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, BaseObjects, CommonIDObjectListForm;

type
  TfrmIDObjectCombo = class(TFrame)
    cmbxName: TComboBox;
    btnShowAdditional: TButton;
    lblName: TStaticText;
    procedure cmbxNameChange(Sender: TObject);
    procedure btnShowAdditionalClick(Sender: TObject);
  private
    { Private declarations }
    FLoadedList: TIDObjects;
    FIsEditable: Boolean;
    FEditorForm: TfrmIDObjectList;
    FEditorFormClass: TfrmIDObjectListFormClass;
    FMultipleSelect: Boolean;
    FSelectedObjects: TIDObjects;
    procedure SetLoadedList(const Value: TIDObjects);
    procedure CreateForm;
    procedure SetMultipleSelect(const Value: Boolean);
    function  GetCaption: string;
    procedure SetCaption(const Value: string);
    function  GetSelectedObject: TIDObject;
    procedure SetSelectedObject(const Value: TIDObject);
    procedure SetSelectedObjects(const Value: TIDObjects);
  protected
    procedure ReloadList; virtual;
    procedure SetEnabled(Value: Boolean); override;

  public
    { Public declarations }
    property LoadedList: TIDObjects read FLoadedList write SetLoadedList;
    property IsEditable: Boolean read FIsEditable write FIsEditable;
    property Caption: string read GetCaption write SetCaption;

    property MultipleSelect: Boolean read FMultipleSelect write SetMultipleSelect;
    property SelectedObjects: TIDObjects read FSelectedObjects write SetSelectedObjects;
    property SelectedObject: TIDObject read GetSelectedObject write SetSelectedObject;
    procedure Clear;

    property EditorFormClass: TfrmIDObjectListFormClass read FEditorFormClass write FEditorFormClass;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.dfm}

{ TfrmIDObjectCombo }

constructor TfrmIDObjectCombo.Create(AOwner: TComponent);
begin
  inherited;
  FEditorFormClass := TfrmIDObjectList;

  FSelectedObjects := TIDObjects.Create;
  FSelectedObjects.OwnsObjects := False;
  IsEditable := true;
end;

procedure TfrmIDObjectCombo.CreateForm;
begin
  if not Assigned(FEditorForm) then
    FEditorForm := EditorFormClass.Create(Self);


  FEditorForm.IDObjects := LoadedList;
  FEditorForm.MultiSelect := MultipleSelect;
  FEditorForm.SelectedObjects := SelectedObjects;
  FEditorForm.IsEditable := IsEditable;
  FEditorForm.ModalResult := mrOk;
end;

destructor TfrmIDObjectCombo.Destroy;
begin
  FSelectedObjects.Free;
  inherited;
end;

function TfrmIDObjectCombo.GetCaption: string;
begin
  Result := lblName.Caption;
end;

function TfrmIDObjectCombo.GetSelectedObject: TIDObject;
begin
  if SelectedObjects.Count > 0 then
    Result := SelectedObjects.Items[0]
  else
    Result := nil;
end;

procedure TfrmIDObjectCombo.SetCaption(const Value: string);
begin
  lblName.Caption := Value;
end;

procedure TfrmIDObjectCombo.SetLoadedList(const Value: TIDObjects);
begin
  FLoadedList := Value;
  ReloadList;
end;

procedure TfrmIDObjectCombo.SetMultipleSelect(const Value: Boolean);
begin
  FMultipleSelect := Value;
  if FMultipleSelect then
    cmbxName.Style := csSimple
  else
    cmbxName.Style := csDropDownList;
end;


procedure TfrmIDObjectCombo.SetSelectedObject(const Value: TIDObject);
begin
  SelectedObjects.Clear;
  SelectedObjects.Add(Value, false, False);
  cmbxName.ItemIndex := cmbxName.Items.IndexOfObject(SelectedObjects.Items[0]);
end;

procedure TfrmIDObjectCombo.cmbxNameChange(Sender: TObject);
begin
  if cmbxName.ItemIndex > -1 then
    SelectedObject := TIDObject(cmbxName.Items.Objects[cmbxName.ItemIndex]);
end;

procedure TfrmIDObjectCombo.Clear;
begin
  cmbxName.ItemIndex := -1;
  SelectedObjects.Clear;
end;

procedure TfrmIDObjectCombo.btnShowAdditionalClick(Sender: TObject);
begin
  CreateForm;

  if FEditorForm.ShowModal <> mrNone then
  begin
    ReloadList;
    SelectedObjects := FEditorForm.SelectedObjects;
  end;
end;

procedure TfrmIDObjectCombo.ReloadList;
var i: integer;
begin
  cmbxName.Items.Clear; 
  for i := 0 to LoadedList.Count - 1 do
    cmbxName.AddItem(LoadedList.Items[i].List, LoadedList.Items[i]);
end;

procedure TfrmIDObjectCombo.SetSelectedObjects(const Value: TIDObjects);
begin
  FSelectedObjects.Clear;
  FSelectedObjects.AddObjects(Value, False, false);
  ReloadList;
  if MultipleSelect then
    cmbxName.Text := FSelectedObjects.List
  else
    cmbxName.ItemIndex := cmbxName.Items.IndexOfObject(SelectedObject);
end;

procedure TfrmIDObjectCombo.SetEnabled(Value: Boolean);
begin
  inherited;
  cmbxName.Enabled := Value;
  btnShowAdditional.Enabled := Value;
end;

end.
