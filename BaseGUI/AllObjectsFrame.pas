unit AllObjectsFrame;

interface

uses
  Windows, BaseObjects, BaseGUI, Registrator, ExtCtrls, Buttons, UniButtonsFrame,
  StdCtrls, Forms, Controls, Classes;

type
  TfrmAllObjects = class;

  TAllObjectsGUIAdapter = class (TCollectionGUIAdapter)
  private
    function    GetFrameOwner: TfrmAllObjects;
  public
    property    FrameOwner: TfrmAllObjects read GetFrameOwner;

    procedure   Reload; override;
    function    Add: integer; override;
    function    Delete: integer; override;
    function    Save: integer; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TfrmAllObjects = class(TFrame, IGUIAdapter)
    GroupBox1: TGroupBox;
    lstAllObjects: TListBox;
    Panel1: TPanel;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    frmButtons: TfrmButtons;
    procedure frmButtonsactnAddExecute(Sender: TObject);
    procedure frmButtonsactnEditExecute(Sender: TObject);
    procedure lstAllObjectsDblClick(Sender: TObject);
    procedure frmButtonsactnDeleteExecute(Sender: TObject);
    procedure lstAllObjectsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private
    FAllObjects: TRegisteredIDObjects;
    FObjectGUIAdapter: TAllObjectsGUIAdapter;
    FObjectClass: TIDObjectClass;

    HintRowT : Integer; // Номер строки в списке, на которую указывает мышь
    HintStringT : string;

    function    GetActiveObject: TRegisteredIDObject;
  public
    // выбранный объект
    property    ActiveObject: TRegisteredIDObject read GetActiveObject;
    // коллекция всех объектов
    property    AllObjects: TRegisteredIDObjects read FAllObjects write FAllObjects;
    // класс объектов
    property    ObjectClass: TIDObjectClass read FObjectClass write FObjectClass;

    property    GUIAdapter: TAllObjectsGUIAdapter read FObjectGUIAdapter implements IGUIAdapter;

     // Обработчик подсказок
    procedure OnShowHint(var HintStr: string; var CanShow: Boolean;
      var HintInfo: THintInfo);

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade, AddUnits, AddObjectFrame;

{$R *.dfm}

{ TfrmAllObjects }

constructor TfrmAllObjects.Create(AOwner: TComponent);
begin
  inherited;

  FObjectGUIAdapter := TAllObjectsGUIAdapter.Create(Self);
  FObjectGUIAdapter.List := lstAllObjects;

  frmButtons.GUIAdapter := FObjectGUIAdapter;

  HintRowT := -1;
  Application.OnShowHint := OnShowHint; // Установка обработчика
end;

destructor TfrmAllObjects.Destroy;
begin
  FObjectGUIAdapter.Free;
  inherited;
end;

function TfrmAllObjects.GetActiveObject: TRegisteredIDObject;
begin
  Result := nil;

  if (lstAllObjects.Count > 0) and (lstAllObjects.ItemIndex > -1) then
    Result := lstAllObjects.Items.Objects[lstAllObjects.ItemIndex] as TRegisteredIDObject;
end;

procedure TfrmAllObjects.OnShowHint(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if not (HintInfo.HintControl is TListBox) then Exit;
  with HintInfo.HintControl as TListBox do begin
    HintInfo.HintPos := lstAllObjects.ClientToScreen(Point(21,
      lstAllObjects.ItemRect(HintRowT).Top + 1));
    HintStr := HintStringT;
  end;
end;

{ TAllObjectsGUIAdapter }

function TAllObjectsGUIAdapter.Add: integer;
begin
  Result := 0;
end;

constructor TAllObjectsGUIAdapter.Create(AOwner: TComponent);
begin
  inherited;
  Buttons := [abReload, abAdd, abEdit, abDelete, abSort];
  SortOrders.AddOrder('по названию', NameCompare, ReverseNameCompare);
end;

function TAllObjectsGUIAdapter.Delete: integer;
begin
  Result := 0;
end;

function TAllObjectsGUIAdapter.GetFrameOwner: TfrmAllObjects;
begin
  Result := Owner as TfrmAllObjects;
end;

procedure TAllObjectsGUIAdapter.Reload;
begin
  inherited;

end;

procedure TfrmAllObjects.frmButtonsactnAddExecute(Sender: TObject);
var o: TRegisteredIDObject;
begin
  // добавить новое значение
  frmEditor := TfrmEditor.Create(Self);

  if frmEditor.ShowModal = mrOk then
  if frmEditor.frmAddObject.Save then
  begin
    if not Assigned (AllObjects.GetItemByName(frmEditor.frmAddObject.Name)) then
    begin
      o := TRegisteredIDObject.Create(AllObjects);
      o.Name := frmEditor.frmAddObject.Name;
      AllObjects.Add(o, false, false);

      o.Update;

      AllObjects.MakeList(lstAllObjects.Items, true, true);
    end
    else MessageBox(0, 'Объект с таким названием уже существует.', 'Ошибка', MB_OK + MB_APPLMODAL + MB_ICONERROR)
  end;  

  frmEditor.Free;
end;

procedure TfrmAllObjects.frmButtonsactnEditExecute(Sender: TObject);
begin
  // редактировать значение
  if Assigned (ActiveObject) then
  begin
    frmEditor := TfrmEditor.Create(Self);

    frmEditor.frmAddObject.edtName.Text := ActiveObject.Name;

    if frmEditor.ShowModal = mrOk then
    if frmEditor.frmAddObject.Save then
    begin
      ActiveObject.Name := frmEditor.frmAddObject.Name;
      ActiveObject.Update;

      AllObjects.MakeList(lstAllObjects.Items, true, true);
    end;

    frmEditor.Free;
  end
  else MessageBox(0, 'Объект для редактирования не выбран.', 'Предупреждение', MB_YESNO	+ MB_ICONWARNING	+ MB_DEFBUTTON2	+ MB_APPLMODAL);
end;

function TAllObjectsGUIAdapter.Save: integer;
begin
  Result := 0;
end;

procedure TfrmAllObjects.lstAllObjectsDblClick(Sender: TObject);
begin
  if Assigned (ActiveObject) then
    frmButtons.actnEdit.Execute;
end;

procedure TfrmAllObjects.frmButtonsactnDeleteExecute(Sender: TObject);
begin
  if MessageBox(0, PChar('Вы уверены, что хотите удалить объект "' + ActiveObject.Name + '"?'),
                PChar('Предупреждение'), MB_YESNO	+ MB_ICONWARNING	+ MB_DEFBUTTON2	+ MB_APPLMODAL) = ID_YES then
  begin
    // потом для начала необходимо предусмотреть можно ли удалить значение
    AllObjects.Remove(ActiveObject);
    AllObjects.MakeList(lstAllObjects.Items, True, true);
  end;
end;

procedure TfrmAllObjects.lstAllObjectsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var ItemNum: Integer;
begin
  ItemNum := lstAllObjects.ItemAtPos(Point(X, Y), True);
  if (ItemNum <> HintRowT) then
  begin
    HintRowT := ItemNum;
    Application.CancelHint;
    if HintRowT > -1 then
    begin
      HintStringT := lstAllObjects.Items[ItemNum];
      if (lstAllObjects.Canvas.TextWidth(HintStringT) <= lstAllObjects.ClientWidth - 25) then
        HintStringT := '';
    end
    else
      HintStringT := '';
  end;
end;

end.
