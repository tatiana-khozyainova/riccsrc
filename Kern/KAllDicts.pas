unit KAllDicts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UniButtonsFrame, BaseGUI, CoreDescription;

type
  TfrmAllDicts = class;

  TAllDictsGUIAdapter = class (TCollectionGUIAdapter)
  private
    function GetFrameOwner: TfrmAllDicts;
  public
    property    FrameOwner: TfrmAllDicts read GetFrameOwner;

    procedure   Reload; override;
    function    Add: integer; override;
    function    Delete: integer; override;
    function    StartFind: integer; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TfrmAllDicts = class(TFrame, IGUIAdapter)
    GroupBox1: TGroupBox;
    lstAllDicts: TListBox;
    frmButtons: TfrmButtons;
  private
    FDictGUIAdapter: TAllDictsGUIAdapter;

    function    GetActiveDict: TDictionary;
  public
    property    ActiveDict: TDictionary read GetActiveDict;

    property    GUIAdapter: TAllDictsGUIAdapter read FDictGUIAdapter implements IGUIAdapter;

    destructor  Destroy; override;
    constructor Create(AOnwer: TComponent); override;
  end;

implementation

uses Facade;

{$R *.dfm}

{ TAllDictsGUIAdapter }

function TAllDictsGUIAdapter.Add: integer;
var o: TDictionary;
begin
  Result := 0;

  try
    o := (TMainFacade.GetInstance as TMainFacade).Dicts.Add as TDictionary;
  except
    Result := -1;
  end;

  if Result >= 0 then inherited Add;
end;

constructor TAllDictsGUIAdapter.Create(AOwner: TComponent);
begin
  inherited;
  Buttons := [abReload, abAdd, abDelete, abSort];
end;

function TAllDictsGUIAdapter.Delete: integer;
begin
  Result := 0;

  if FrameOwner.ActiveDict.Roots.Count = 0 then
  begin
    (TMainFacade.GetInstance as TMainFacade).Dicts.Remove(FrameOwner.ActiveDict);

    inherited Delete;
  end
  else MessageBox(0, 'Нельзя удалить словарь, т.к. существуют связанные с ним элементы.', 'Сообщение', MB_OK + MB_ICONINFORMATION + MB_APPLMODAL);
end;

function TAllDictsGUIAdapter.GetFrameOwner: TfrmAllDicts;
begin
  Result := Owner as TfrmAllDicts;
end;

procedure TAllDictsGUIAdapter.Reload;
begin
  if StraightOrder then (TMainFacade.GetInstance as TMainFacade).Dicts.Sort(SortOrders.Items[OrderBY].Compare)
  else (TMainFacade.GetInstance as TMainFacade).Dicts.Sort(SortOrders.Items[OrderBY].ReverseCompare);

  (TMainFacade.GetInstance as TMainFacade).Dicts.MakeList(FrameOwner.lstAllDicts.Items);

  inherited;
end;

function TAllDictsGUIAdapter.StartFind: integer;
begin
  Result := 0;
end;

{ TfrmAllDicts }

constructor TfrmAllDicts.Create(AOnwer: TComponent);
begin
  inherited;

  (TMainFacade.GetInstance as TMainFacade).Dicts.MakeList(lstAllDicts.Items);

  FDictGUIAdapter := TAllDictsGUIAdapter.Create(Self);
  FDictGUIAdapter.List := lstAllDicts;

  frmButtons.GUIAdapter := FDictGUIAdapter;
end;

destructor TfrmAllDicts.Destroy;
begin
  FDictGUIAdapter.Free;
  inherited;
end;

function TfrmAllDicts.GetActiveDict: TDictionary;
begin
  Result := nil;
  if (lstAllDicts.ItemIndex > -1) and (lstAllDicts.Count > 0) then
    Result := lstAllDicts.Items.Objects[lstAllDicts.ItemIndex] as TDictionary;
end;

end.
