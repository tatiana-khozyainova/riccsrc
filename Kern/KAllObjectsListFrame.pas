unit KAllObjectsListFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, CheckLst, BaseObjects, Buttons, ImgList,
  ActnList, CoreDescription, Lithology, Registrator;

type
  TfrmAllObjects = class(TFrame)
    lstObjects: TCheckListBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    imgLst: TImageList;
    actnList: TActionList;
    actnOK: TAction;
    actnAddEmp: TAction;
    BitBtn3: TBitBtn;
    gbxFilter: TGroupBox;
    rbtnAllEmployee: TRadioButton;
    rbtnAllOurEmployee: TRadioButton;
    rbtnAllOutsideEmployee: TRadioButton;
    pnlFilter: TPanel;
    actnAllEmps: TAction;
    actnInEmps: TAction;
    actnOutEmps: TAction;
    lblFilter: TLabel;
    procedure actnAddEmpExecute(Sender: TObject);
    procedure actnAllEmpsExecute(Sender: TObject);
    procedure actnInEmpsExecute(Sender: TObject);
    procedure actnOutEmpsExecute(Sender: TObject);
    procedure lstObjectsKeyPress(Sender: TObject; var Key: Char);
  private
    FActiveAuthors: TAuthors;
    FActiveLithologies: TLithologiesDescr;

    FCollectionClass: TIDObjectsClass;
    FObjectClass: TIDObjectClass;

    FPrefix:    array[0..255] of char;

    procedure   SetCollectionClass(const Value: TIDObjectsClass);
    procedure   SetObjectClass(const Value: TIDObjectClass);
  public
    property    ObjectClass: TIDObjectClass read FObjectClass write SetObjectClass;
    property    CollectionClass: TIDObjectsClass read FCollectionClass write SetCollectionClass;

    function    GetActiveAuthors: TAuthors;
    function    GetActiveLithologies: TLithologiesDescr;

    property    ActiveAuthors: TAuthors read GetActiveAuthors;
    property    ActiveLithologies: TLithologiesDescr read GetActiveLithologies;

    procedure   ReloadList(AObjects: TIDObjects);
    procedure   SetOptions(ASet: boolean);

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses AddUnits, Employee, Facade;

{$R *.dfm}

{ TfrmAllObjects }

constructor TfrmAllObjects.Create(AOwner: TComponent);
begin
  inherited;

  FActiveAuthors := TAuthors.Create;
  FActiveLithologies := TLithologiesDescr.Create;
end;

destructor TfrmAllObjects.Destroy;
begin

  inherited;
end;

function TfrmAllObjects.GetActiveAuthors: TAuthors;
var i: integer;
begin
  FActiveAuthors.Clear;

  for i := 0 to lstObjects.Count - 1 do
  if lstObjects.Checked[i] then
    FActiveAuthors.Add(lstObjects.Items.Objects[i]);

  Result := FActiveAuthors;
end;

function TfrmAllObjects.GetActiveLithologies: TLithologiesDescr;
var i: integer;
begin
  FActiveLithologies.Clear;

  for i := 0 to lstObjects.Count - 1 do
  if lstObjects.Checked[i] then
    FActiveLithologies.Add(lstObjects.Items.Objects[i]);

  Result := FActiveLithologies;
end;

procedure TfrmAllObjects.ReloadList(AObjects: TIDObjects);
var i, j: integer;
begin
  for j := 0 to AObjects.Count - 1 do
  for i := 0 to lstObjects.Count - 1 do
  if lstObjects.Items.Strings[i] = AObjects.Items[j].Name then
  begin
    lstObjects.Checked[i] := True;
    break;
  end;
end;

procedure TfrmAllObjects.SetCollectionClass(const Value: TIDObjectsClass);
begin
  //FCollectionClass := Value;
  //if Assigned(FActiveObjects) then FActiveObjects.Free;
  //FActiveObjects := FCollectionClass.Create();
  //FActiveObjects.ObjectClass := FObjectClass;
end;

procedure TfrmAllObjects.SetObjectClass(const Value: TIDObjectClass);
begin
  FObjectClass := Value;
end;

procedure TfrmAllObjects.actnAddEmpExecute(Sender: TObject);
var e: TEmployeeOutside;
begin
  MessageBox(0, '¬ы имеете право добавл€ть только сторонних сотрудников.', 'ѕредупреждение', MB_OK + MB_APPLMODAL + MB_ICONWARNING);

  frmEditor := TfrmEditor.Create(Self);

  if frmEditor.ShowModal = mrOk then
  if frmEditor.frmAddObject.Save then
  begin
    e := TEmployeeOutside.Create((TMainFacade.GetInstance as TMainFacade).AllEmployeeOuts);
    e.Name := frmEditor.frmAddObject.Name;
    (TMainFacade.GetInstance as TMainFacade).AllEmployeeOuts.Add(e);
    e.Update;
  end;

  frmEditor.Free;
end;

procedure TfrmAllObjects.SetOptions(ASet: boolean);
begin
  actnAddEmp.Visible := ASet;
  gbxFilter.Visible := ASet;
  pnlFilter.Visible := ASet;
end;

procedure TfrmAllObjects.actnAllEmpsExecute(Sender: TObject);
begin
  (TMainFacade.GetInstance as TMainFacade).AllEmployees.MakeList(lstObjects.Items);
  (TMainFacade.GetInstance as TMainFacade).AllEmployeeOuts.MakeList(lstObjects.Items, false, false);
end;

procedure TfrmAllObjects.actnInEmpsExecute(Sender: TObject);
begin
  (TMainFacade.GetInstance as TMainFacade).AllEmployees.MakeList(lstObjects.Items);
end;

procedure TfrmAllObjects.actnOutEmpsExecute(Sender: TObject);
begin
  (TMainFacade.GetInstance as TMainFacade).AllEmployeeOuts.MakeList(lstObjects.Items);
end;

procedure TfrmAllObjects.lstObjectsKeyPress(Sender: TObject;
  var Key: Char);
var curKey: array[0..1] of char;
    ndx: integer;
begin
  lstObjects.ClearSelection;

  if key = #8 {Backspace (клавиша возврата)} then
  begin
    if FPrefix[0] <> #0 then
    begin
      FPrefix[StrLen(FPrefix) - 1] := #0;
    end
  end
  else
  begin
    curKey[0] := Key;
    curKey[1] := #0;
    StrCat(FPrefix, curKey);
    ndx := SendMessage(lstObjects.Handle, LB_FINDSTRING, -1, longint(@FPrefix));
    if ndx <> LB_ERR then
    begin
      lstObjects.ItemIndex := ndx;
      lstObjects.Selected[ndx] := true;
    end
  end;

  lblFilter.Caption := StrPas(FPrefix);
  Key := #0;
end;

end.
