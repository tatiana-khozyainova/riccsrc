unit KDictionaryFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, BaseGUI, UniButtonsFrame, CoreDescription;

type
  TfrmDictionary = class;

  TAllWordsGUIAdapter = class (TCollectionGUIAdapter)
  private
    function GetFrameOwner: TfrmDictionary;
    function GetActiveWord: TDictionaryWord;
  public
    property    FrameOwner: TfrmDictionary read GetFrameOwner;
    property    ActiveWord: TDictionaryWord read GetActiveWord;

    procedure   Reload; override;
    function    Add: integer; override;
    function    Delete: integer; override;
    function    StartFind: integer; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TfrmDictionary = class(TFrame, IGUIAdapter)
    lstAllWords: TListBox;
    frmButtons: TfrmButtons;
    procedure lstAllWordsDblClick(Sender: TObject);
    procedure lstAllWordsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstAllWordsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstAllWordsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstAllWordsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FFilter:      string;
    FActiveWord:  TDictionaryWord;
    FActiveWords: TDictionaryWords;
    FClosing:     boolean;
    FEscaping:    boolean;
    FAllWordGUIAdapter: TAllWordsGUIAdapter;
    FActiveDict: TDictionary;
    FEntering: boolean;
    function      GetActiveWord: TDictionaryWord;
    procedure     SetActiveDict(const Value: TDictionary);
  public
    property      ActiveWord: TDictionaryWord read GetActiveWord;
    property      ActiveWords: TDictionaryWords read FActiveWords write FActiveWords;

    property      Filter: string read FFilter write FFilter;

    property      Closing: boolean read FClosing write FClosing;
    property      Escaping: boolean read FEscaping write FEscaping;
    property      Entering: boolean read FEntering write FEntering;

    property      GUIAdapter: TAllWordsGUIAdapter read FAllWordGUIAdapter implements IGUIAdapter;

    function      GetActiveWords: TDictionaryWords;

    procedure     MakeListWords;

    constructor   Create(AOwner: TComponent); override;
    destructor    Destroy; override;
  end;

implementation

uses Facade;

{$R *.dfm}

{ TfrmDictionary }

constructor TfrmDictionary.Create(AOwner: TComponent);
begin
  inherited;

  FActiveWords := TDictionaryWords.Create;

  FAllWordGUIAdapter := TAllWordsGUIAdapter.Create(Self);
  FAllWordGUIAdapter.List := lstAllWords;

  frmButtons.GUIAdapter := FAllWordGUIAdapter;

  FFilter := '';
  FClosing := false;
  FEscaping := false;
  FEntering := false;
end;

destructor TfrmDictionary.Destroy;
begin

  inherited;
end;

function TfrmDictionary.GetActiveWord: TDictionaryWord;
begin
  Result := nil;
  if (lstAllWords.ItemIndex > -1) and (lstAllWords.Count > 0) then
    Result := lstAllWords.Items.Objects[lstAllWords.ItemIndex] as TDictionaryWord;
end;

function TfrmDictionary.GetActiveWords: TDictionaryWords;
var i: integer;
    temp: string;
    o: TDictionaryWord;
begin
  FActiveWords.Clear;

  for i := 0 to (TMainFacade.GetInstance as TMainFacade).AllWords.Count - 1 do
  begin
    temp := (TMainFacade.GetInstance as TMainFacade).AllWords.Items[i].Name;
    delete (temp, Length (FFilter)  + 1, Length(temp) - Length (FFilter));
    if (AnsiUpperCase(temp) = AnsiUpperCase(FFilter)) or ((FFilter = #9) or (FFilter = #10) or (FFilter = #13)) then
    begin
      o := (TMainFacade.GetInstance as TMainFacade).AllWords.Items[i];
      FActiveWords.Add(o, false, false);
    end;
  end;

  Result := FActiveWords;
end;

procedure TfrmDictionary.lstAllWordsDblClick(Sender: TObject);
begin
  (Parent as TForm).Close;
end;

procedure TfrmDictionary.MakeListWords;
begin
  GetActiveWords;
  ActiveWords.MakeList(lstAllWords.Items);
  if lstAllWords.Count > 0 then lstAllWords.ItemIndex := 0;
end;

procedure TfrmDictionary.lstAllWordsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 13) or (Key = 27) then
    (Parent as TForm).Close;

  if Key = 27 then FEscaping := true;
  if Key = 13 then FEntering := true
  else FEntering := false;
end;

procedure TfrmDictionary.SetActiveDict(const Value: TDictionary);
begin
  GUIAdapter.BeforeReload;
  if FActiveDict <> Value then
  begin
    FActiveDict := Value;
    GUIAdapter.Reload;
  end;
  if not Assigned(FActiveDict) then GUIAdapter.Clear;
end;

{ TAllWordsGUIAdapter }

function TAllWordsGUIAdapter.Add: integer;
var o: TDictionaryWord;
begin
  Result := 0;

  try
    o := (TMainFacade.GetInstance as TMainFacade).AllWords.Add as TDictionaryWord;
  except
    Result := -1;
  end;

  if Result >= 0 then inherited Add;
end;

constructor TAllWordsGUIAdapter.Create(AOwner: TComponent);
begin
  inherited;
  Buttons := [abReload, abAdd, abDelete, abSort];
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

function TAllWordsGUIAdapter.GetActiveWord: TDictionaryWord;
begin
  Result := FrameOwner.FActiveWord;
end;

function TAllWordsGUIAdapter.GetFrameOwner: TfrmDictionary;
begin
  Result := Owner as TfrmDictionary;
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

procedure TfrmDictionary.lstAllWordsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do
  begin
    try
      Font.Name := (((lstAllWords.Items.Objects[Index] as TDictionaryWord).Owner as TRoot).Owner as TDictionary).Font.Name;
      Font.Color := (((lstAllWords.Items.Objects[Index] as TDictionaryWord).Owner as TRoot).Owner as TDictionary).Font.Color;
      Font.Style := (((lstAllWords.Items.Objects[Index] as TDictionaryWord).Owner as TRoot).Owner as TDictionary).Font.Style;
      Brush.Color := clWhite;
    except

    end;
    FillRect(Rect);
    TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;

procedure TfrmDictionary.lstAllWordsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then FEntering := true
end;

procedure TfrmDictionary.lstAllWordsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FEntering := true
  else FEntering := false;
end;

end.
