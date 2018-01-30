unit KAllWordsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UniButtonsFrame, BaseGUI, CoreDescription;

type
  TfrmAllWords = class;

  TAllWordsGUIAdapter = class (TCollectionGUIAdapter)
  private
    function GetActiveDict: TDictionary;
    function GetFrameOwner: TfrmAllWords;
  public
    property    FrameOwner: TfrmAllWords read GetFrameOwner;
    property    ActiveWord: TDictionary read GetActiveDict;

    procedure   Reload; override;
    function    Add: integer; override;
    function    Delete: integer; override;
    function    StartFind: integer; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TfrmAllWords = class(TFrame, IGUIAdapter)
    frmButtons: TfrmButtons;
    GroupBox1: TGroupBox;
    lstAllWords: TListBox;
    procedure frmButtonsactnAddExecute(Sender: TObject);
    procedure lstAllWordsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    FWordGUIAdapter: TAllWordsGUIAdapter;
    FActiveDict: TDictionary;
    function GetActiveWord: TDictionaryWord;
    function GetActiveWords: TDictionaryWords;
    { Private declarations }
  public
    property ActiveWord: TDictionaryWord read GetActiveWord;
    property ActiveWords: TDictionaryWords read GetActiveWords;

    property ActiveDict: TDictionary read FActiveDict write FActiveDict;

    property GUIAdapter: TAllWordsGUIAdapter read FWordGUIAdapter implements IGUIAdapter;

    destructor  Destroy; override;
    constructor Create(AOnwer: TComponent); override;
  end;

implementation

uses Facade, KAddWord;

{$R *.dfm}

{ TAllWordsGUIAdapter }

function TAllWordsGUIAdapter.Add: integer;
begin
  Result := 0;
end;

constructor TAllWordsGUIAdapter.Create(AOwner: TComponent);
begin
  inherited;

end;

function TAllWordsGUIAdapter.Delete: integer;
var os: TDictionaryWords;
    i: integer;
begin
  Result := 0;

  os := FrameOwner.ActiveWords;
  for i := os.Count - 1 downto 0 do
    (TMainFacade.GetInstance as TMainFacade).AllWords.Remove(os.Items[i]);

  inherited Delete;
end;

function TAllWordsGUIAdapter.GetActiveDict: TDictionary;
begin
  Result := nil;
end;

function TAllWordsGUIAdapter.GetFrameOwner: TfrmAllWords;
begin
  Result := Owner as TfrmAllWords;
end;

procedure TAllWordsGUIAdapter.Reload;
begin
  if StraightOrder then (TMainFacade.GetInstance as TMainFacade).AllWords.Sort(SortOrders.Items[OrderBY].Compare)
  else (TMainFacade.GetInstance as TMainFacade).AllWords.Sort(SortOrders.Items[OrderBY].ReverseCompare);

  (TMainFacade.GetInstance as TMainFacade).AllWords.MakeList(FrameOwner.lstAllWords.Items, true, true);

  inherited;
end;

function TAllWordsGUIAdapter.StartFind: integer;
begin
  Result := 0;
end;

{ TfrmAllWords }

constructor TfrmAllWords.Create(AOnwer: TComponent);
begin
  inherited;

  FActiveDict := TDictionary.Create((TMainFacade.GetInstance as TMainFacade).Dicts);
end;

destructor TfrmAllWords.Destroy;
begin

  inherited;
end;

function TfrmAllWords.GetActiveWord: TDictionaryWord;
begin
  Result := nil;
end;

function TfrmAllWords.GetActiveWords: TDictionaryWords;
begin
  Result := nil;
end;

procedure TfrmAllWords.frmButtonsactnAddExecute(Sender: TObject);
begin
  frmButtons.actnAddExecute(Sender);

  frmAddWord := TfrmAddWord.Create(Self);
  frmAddWord.ActiveDict := FActiveDict;

  if frmAddWord.ShowModal = mrOk then
    (TMainFacade.GetInstance as TMainFacade).Filter := 'DESCRIPTION_KERN_ID = ' + IntToStr(ActiveDict.ID);

  frmAddWord.Free;
end;

procedure TfrmAllWords.lstAllWordsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var Color: TColor;
    ABrush: TBrush;
begin
  ABrush := TBrush.Create;
  with (Control as TListBox).Canvas do
  begin
    Color := ActiveDict.Font.Color;

    ABrush.Style := TBrushStyle(ActiveDict.Font.Style);
    ABrush.Color := Color;

    Windows.FillRect(handle, Rect, ABrush.Handle);
    Brush.Style := bsClear;

    TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
    ABrush.Free;
  end;
end;

end.
