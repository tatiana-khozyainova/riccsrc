unit KDescriptionKernFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Menus, ExtCtrls, KDictionary,
  ActnList, ImgList, ToolWin, Buttons, CoreDescription, Employee, Well, ClipBrd,
  Lithology, KAllObjectsList, BaseObjects, CommCtrl, KInfoRockSampleFrame, Slotting,
  Word2000, OleServer, ComObj, RichEdit, WordXP, ShellAPI;

 // Underline styles
const
  CFU_UNDERLINETHICK = 9;
  CFU_UNDERLINEWAVE = 8;
  CFU_UNDERLINEDASHDOTDOT = 7;
  CFU_UNDERLINEDASHDOT = 6;
  CFU_UNDERLINEDASH = 5;
  CFU_UNDERLINEDOTTED = 4;
  CFU_UNDERLINE = 1;
  CFU_UNDERLINENONE = 0;

type
  TfrmDescriptionKern = class(TFrame)
    edtDescription: TRichEdit;
    imgList: TImageList;
    actnLst: TActionList;
    actnAddWord: TAction;
    pm: TPopupMenu;
    mmAddWords: TMenuItem;
    GroupBox4: TGroupBox;
    actnGiveWords: TAction;
    edtBuffer: TRichEdit;
    N1: TMenuItem;
    actnGetWordsFromStr: TAction;
    actnCheckText: TAction;
    actnSetLithologies: TAction;
    actnSetAuthors: TAction;
    Panel4: TPanel;
    tbrAllDicts: TToolBar;
    pmE: TPopupMenu;
    N2: TMenuItem;
    actnRemoveEmp: TAction;
    pmL: TPopupMenu;
    MenuItem1: TMenuItem;
    actnRemoveLith: TAction;
    btnStructure: TToolButton;
    btnLithology: TToolButton;
    btnColor: TToolButton;
    btnTecsture: TToolButton;
    actnAddWords: TAction;
    GroupBox11: TGroupBox;
    Panel6: TPanel;
    GroupBox13: TGroupBox;
    SpeedButton2: TSpeedButton;
    edtEmployee: TEdit;
    GroupBox14: TGroupBox;
    btnSetLithologies: TSpeedButton;
    edtLithologies: TEdit;
    GroupBox15: TGroupBox;
    dtCreateDesc: TDateTimePicker;
    GroupBox12: TGroupBox;
    lstHeader: TListView;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    actnInsertText: TAction;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    WrdApp: TWordApplication;
    WordDoc: TWordDocument;
    grp1: TGroupBox;
    btnSetReferences: TSpeedButton;
    edtReferences: TEdit;
    actnSetReferences: TAction;
    btnOpenFile: TSpeedButton;
    actnOpenFile: TAction;
    procedure edtDescriptionKeyPress(Sender: TObject; var Key: Char);
    procedure edtDescriptionKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDescriptionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDescriptionChange(Sender: TObject);
    procedure dtCreateDesc1Change(Sender: TObject);
    procedure actnCheckTextExecute(Sender: TObject);
    procedure cbxEmployeeChange(Sender: TObject);
    procedure cbxLithologioesChange(Sender: TObject);
    procedure plnSetLithologiesClick(Sender: TObject);
    procedure plnSetAuthorsClick(Sender: TObject);
    procedure actnSetLithologiesExecute(Sender: TObject);
    procedure actnSetAuthorsExecute(Sender: TObject);
    procedure lstHeaderCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnLithologyClick(Sender: TObject);
    procedure btnStructureClick(Sender: TObject);
    procedure btnColorClick(Sender: TObject);
    procedure btnTecstureClick(Sender: TObject);
    procedure actnAddWordsExecute(Sender: TObject);
    procedure actnInsertTextExecute(Sender: TObject);
    procedure actnAddWordExecute(Sender: TObject);
    procedure edtLithologiesChange(Sender: TObject);
    procedure edtEmployeeChange(Sender: TObject);
    procedure actnSetReferencesExecute(Sender: TObject);
    procedure actnOpenFileExecute(Sender: TObject);
  private
    FfrmDictionary: TfrmListWords;
    FFilter: string;
    FLstSymbols: TDictionaryWords;
    FNewWords: TDictionaryWords;
    FChangeMade: boolean;
    FChangeKey: boolean;
    FIndexDict: integer;
    FSelIndex: integer;
    FActiveObject: TDescription;
    FSelStartWord: integer;
    FActiveWord: string;
    FWordApp: Variant;
    FLenReference: Integer;
    function    GetShiftState: TShiftState;
  public
    property    IndexDict: integer read FIndexDict write FIndexDict;
    property    SelIndex: integer read FSelIndex write FSelIndex;

    property    LenReference: Integer read FLenReference write FLenReference; 

    property    frmDictionary: TfrmListWords read FfrmDictionary write FfrmDictionary;
    property    Filter: string read FFilter write FFilter;

    property    ActiveObject: TDescription read FActiveObject write FActiveObject;

    property    NewWords: TDictionaryWords read FNewWords write FNewWords;
    property    LstSymbols: TDictionaryWords read FLstSymbols write FLstSymbols;

    property    ChangeMade: boolean read FChangeMade write FChangeMade;
    property    ChangeKey: boolean read FChangeKey write FChangeKey;

    // для проверки орфоргафии
    property    ActiveWord: string read FActiveWord write FActiveWord;
    property    SelStartWord: integer read FSelStartWord write FSelStartWord;
    property    WordApp: Variant read FWordApp write FWordApp;
    // проверка орфографии
    procedure   CheckWord;
    procedure   RE_SetCharFormat(ARichEdit: TRichEdit; AUnderlineType: Byte; AColor: Word);

    procedure   GetPosition(Sender: TRichEdit);

    function    GetTheBeginWord (iX, iY: integer): string;
    function    GetTheWord: string;

    // значение цвета слова по умолчанию
    procedure   SetFontOnDefault (AEdt: TRichEdit; ASelStart, ASelLength: integer);
    // значение цвета слова по значению для словаря
    procedure   SetFont (AFont: TFont);

    // расставить порядковые номера
    procedure   SetNumbers (AWord: string);
    // построение итогового списка слов
    procedure   MakeListWords (AWord: string);
    // проверить из всех словарей присутствуют слова или нет
    function    CheckText: boolean;

    procedure   DrawAllWords;
    procedure   DrawWord (iIndex: Integer; AWord: string; ADict: TDictionary);

    procedure   MakeFileList;

    procedure   Clear;
    procedure   Reload;
    procedure   Add (ASelStart: integer);
    function    Save: boolean;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade, KCommonFunctions, KAddWord, KDescription, Registrator, Math,
     KAllObjectsListFrame, KEditorFileReferences, Material;

{$R *.dfm}

procedure TfrmDescriptionKern.GetPosition(Sender: TRichEdit);
var iX, iY: integer;
    txtLeft: AnsiString;
begin
  iY := 0; iX := 0;
  iY := SendMessage(edtDescription.Handle, EM_LINEFROMCHAR, edtDescription.SelStart, 0);
  iX := edtDescription.SelStart - SendMessage(edtDescription.Handle, EM_LINEINDEX, iY, 0);

  // получение left
  txtLeft := edtDescription.Lines[iY];
  Delete(txtLeft, 1, Length(txtLeft) - iX);
  frmListWords.Left := Parent.Parent.Parent.Left + 20 + (TMainFacade.GetInstance.Owner as TForm).Canvas.TextWidth(txtLeft);
  if frmListWords.Left >= Parent.Parent.Parent.Width then
    frmListWords.Left := frmListWords.Left - frmListWords.Width;

  // получение top (60)
  frmListWords.Top := Parent.Parent.Parent.Top + Top + iY * ((TMainFacade.GetInstance.Owner as TForm).Canvas.TextHeight(edtDescription.Text) + 3) + 315 + iY;
  if frmListWords.Top >= Parent.Parent.Parent.Top then
    frmListWords.Top := frmListWords.Top - frmListWords.Height;

  frmListWords.frmDictionary.Filter := GetTheBeginWord (iX, iY);
  ShowWindow(frmListWords.Handle, SW_SHOWNOACTIVATE);
  frmListWords.Visible := true;

  edtDescription.SetFocus;
end;

procedure TfrmDescriptionKern.edtDescriptionKeyPress(Sender: TObject;
  var Key: Char);
var ShSt: TShiftState;
begin
  ShSt := GetShiftState;
  if ssCtrl in ShSt then
  if Key = ' ' then
  begin
    GetPosition(edtDescription);
    Key := chr (8);
  end;

  if (Key = chr(13)) and (frmListWords.Showing) then
  begin
    GetTheWord;
    frmListWords.Close;
    Key := chr (8);
  end;

  if Key = chr(27) then frmListWords.Close;

  if Key in [' ', ',', '.', '''', '"', ')', '(', '!', '@', '#','%', '^',
                       '&', '*', '`', '~', '-', '_', '=', '+', '[', ']', '{', '}', ':',
                       ';', '\', '|', '<', '>', '&', '/', '?', #10, #13, #9] then
  begin
    FSelStartWord := edtDescription.SelStart - Length (FActiveWord);
    CheckWord;
    FActiveWord := '';
  end
  else FActiveWord := FActiveWord + Key;
end;

constructor TfrmDescriptionKern.Create(AOwner: TComponent);
begin
  inherited;
  frmListWords := TfrmListWords.Create(Self);

  FLstSymbols := TDictionaryWords.Create;

  FChangeMade := false;
  FChangeKey := false;

  FIndexDict := -1;
  FSelIndex := 0;

  try
    WordApp := CreateOleObject('Word.Application');
    WordApp.Visible := false;
  except
    Exception.Create('Error');
  end;
end;

destructor TfrmDescriptionKern.Destroy;
begin
  frmListWords.Free;
  FLstSymbols.Free;
  WrdApp.Free;

  inherited;
end;

function TfrmDescriptionKern.GetShiftState: TShiftState;
begin
  Result := [];
  if GetKeyState(VK_CONTROL) < 0 then Include(Result, ssCtrl);
  if GetKeyState(VK_SHIFT) < 0 then Include(Result, ssShift);
  if GetKeyState(VK_LBUTTON) < 0 then Include(Result, ssLeft);
  if GetKeyState(VK_RBUTTON) < 0 then Include(Result, ssRight);
  if GetKeyState(VK_MBUTTON) < 0 then Include(Result, ssMiddle);
  if GetKeyState(VK_MENU) < 0 then Include(Result, ssAlt);
end;

function TfrmDescriptionKern.GetTheBeginWord(iX, iY: integer): string;
var txtWord : AnsiString;
    i, lengthWord: integer;
begin
  Result := '';

  txtWord := edtDescription.Lines[iY];
  lengthWord := length(txtWord);

  if length(txtWord) <> 0 then
  begin
    i := iX;
    while (i > 0) and (txtWord[i] <> ' ') do Dec(i);

    Delete(txtWord, 1, i);
    Delete(txtWord, iX + 1 - i, lengthWord - iX);
    Result := txtWord;
  end;
end;

procedure TfrmDescriptionKern.edtDescriptionKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var iX, iY: integer;
begin
  if (Key = 40) and (frmListWords.Showing) then frmListWords.SetFocus
  else
  if Key in [8, 65 .. 90, 97 .. 122, 192 .. 255] then
  begin
    iY := SendMessage(edtDescription.Handle, EM_LINEFROMCHAR, edtDescription.SelStart, 0);
    iX := edtDescription.SelStart - SendMessage(edtDescription.Handle, EM_LINEINDEX, iY, 0);
    frmListWords.frmDictionary.Filter := GetTheBeginWord (iX, iY);

    frmListWords.frmDictionary.MakeListWords;

    FChangeKey := true;
  end;
end;

function TfrmDescriptionKern.GetTheWord: string;
var txtWord, txtBegin: string;
    tX, tY, i, j, lengthBegin: integer;
begin
  Result := '';

  tY := 0; tX := 0;

  tY := SendMessage(edtDescription.Handle, EM_LINEFROMCHAR, edtDescription.SelStart, 0);
  tX := edtDescription.SelStart - SendMessage(edtDescription.Handle, EM_LINEINDEX, tY - 1, 0);

  if tX = Length(edtDescription.Lines[tY - 1]) then
  begin
    tX := 0;
    tX := edtDescription.SelStart - SendMessage(edtDescription.Handle, EM_LINEINDEX, tY, 0);
    if tX <> 0 then tX := tX + 2;
  end;

  // получение строки до курсора
  {берем -2 т.к. нумерация идет с нуля, а строку, где располагется курсор добавляем как + iX}
  lengthBegin := 0;
  for i := 0 to tY - 2 do
    lengthBegin := lengthBegin + Length(edtDescription.Lines[i]);
  lengthBegin := lengthBegin + tX;

  txtBegin := edtDescription.Text;
  Delete(txtBegin, lengthBegin + 1, Length(edtDescription.Text) - lengthBegin);

  txtWord := edtDescription.Lines[tY - 1];

  i := 0; j := 0;

  if (length(trim(txtWord)) <> 0) and (tX <> 0) then
  begin
    if (txtWord[tX] <> #9) then
    begin
      // Search the beginning of the word
      i := tX + 1;
      while (i > 0) and (txtWord[i] <> ' ') do Dec(i);
      // Search the end of the word
      j := tX;
      while (j <= Length(txtWord)) and (txtWord[j] <> ' ') do Inc(j);

      if i <> j then Delete(txtWord, i + 1, j - i - 1);
    end;
  end
  else i := tX;

  if Assigned (frmListWords.frmDictionary.ActiveWord) then
    Insert(frmListWords.frmDictionary.ActiveWord.Name, txtWord, i + 1);

  edtDescription.Lines[tY - 1] := txtWord;
  Delete(txtBegin, lengthBegin - (tX - i) + 1, tX - i);

  Add(length(txtBegin));

  actnCheckText.Execute;
  SetFontOnDefault(edtDescription, FSelIndex + Length(frmListWords.frmDictionary.ActiveWord.Name), 0);

  edtDescription.SelStart := lengthBegin + Length(frmListWords.frmDictionary.ActiveWord.Name);
end;

procedure TfrmDescriptionKern.Clear;
begin
  edtDescription.Clear;
  lstHeader.Clear;
  edtEmployee.Text := '';
  edtLithologies.Text := '';
  dtCreateDesc.DateTime := Date;

  FIndexDict := -1;

  if Assigned (ActiveObject) then
  begin
    if Assigned (ActiveObject.Authors) then ActiveObject.Authors.Clear;
    if Assigned (ActiveObject.Lithologies) then ActiveObject.Lithologies.Clear;
  end;

  FChangeMade := false;

  SetFontOnDefault(edtDescription, 0, Length(edtDescription.Text));
end;

procedure TfrmDescriptionKern.Reload;
var i: integer;
    lst : TStringList;
    o : TListItem;
begin
  with ActiveObject do
  begin
    if Assigned (ActiveObject) then
    begin
      edtLithologies.Text := Lithologies.ObjectsToStr;
      edtEmployee.Text := Authors.ObjectsToStr;
      edtDescription.Text := AllText;
      dtCreateDesc.DateTime := DateCreate;
      MakeFileList;

      for i := 0 to 3 do
      begin
        o := TListItem.Create(lstHeader.Items);
        o := lstHeader.Items.Add;
        o.Data := Self;
      end;

      MakeListWords(AllText);
    end;

    Header := GetModelDescription;

    lst := TStringList.Create;
    lst.Clear;
    lst.Text := trim(Header);
    for i := 0 to lst.Count - 1 do
    if trim(lst.Strings[i]) <> '' then
      lstHeader.Items[i].Caption := '     ' + lst.Strings[i];
    lst.Free;

    FChangeMade := false;
  end;
end;

procedure TfrmDescriptionKern.Add (ASelStart: integer);
var i: integer;
    w:  TListWord;
begin
  // найти среди элементов номер
  for i := ActiveObject.Words.Count - 1 downto 0 do
  if ActiveObject.Words.Items[i].SelStart = ASelStart then
  begin
    ActiveObject.Words.Remove(ActiveObject.Words.Items[i]);
    break;
  end;

  w := TListWord.Create(ActiveObject.Words);
  w.Assign(frmListWords.frmDictionary.ActiveWord);
  w.SelStart := ASelStart;

  ActiveObject.Words.Add(w, false, false);
end;

procedure TfrmDescriptionKern.SetNumbers(AWord: string);
var i, index: integer;
    ww: TListWords;
    s: TDictionaryWord;
    l, w: TListWord;
    strWord, strSymbol: string;
begin
  ww := TListWords.Create;
  ww.Assign(ActiveObject.Words);

  ActiveObject.Words.Clear;

  strWord := '';
  strSymbol := '';
  LstSymbols.Clear;

  // добавить массив символов
  if FChangeKey then
  begin
    AWord := edtDescription.Text;
    FChangeKey := false;
  end;

  index := 0;
  for i := 1 to Length(AWord) do
  if (not (AWord[i] in [' ', ',', '.', '''', '"', ')', '(', '!', '@', '#','%', '^',
                        '&', '*', '`', '~', '-', '_', '=', '+', '[', ']', '{', '}', ':',
                        ';', '\', '|', '<', '>', '&', '/', '?', #10, #13, #9])) and (not (AWord[i] in ['0'..'9'])) then
  begin
    strWord := strWord + AWord[i];

    if strSymbol <> '' then
    begin
      s := TDictionaryWord.Create(LstSymbols);
      s.Name := strSymbol;
      s.SelStart := index;
      LstSymbols.Add(s, false, false);

      inc (index);
      strSymbol := '';
    end;
  end
  else
  begin
    // надо проверить тире или дефис
    if ((i <> 1) or (i <> Length(AWord))) and (AWord[i] = '-') then
    begin
      if (AWord[i + 1] <> ' ') and (AWord[i - 1] <> ' ') then
        strWord := strWord + AWord[i]
      else strSymbol := strSymbol + AWord[i];
    end
    else
    begin
      strSymbol := strSymbol + AWord[i];

      w := ww.GetItemByName(AnsiLowerCase(strWord)) as TListWord;

      if Assigned (w) then
      begin
        l := TListWord.Create(ActiveObject.Words);
        l.Assign(w);
        l.SelStart := index;
        inc(index);
        strWord := '';
        ActiveObject.Words.Add(l, false, false);
        ww.Remove(w);
      end
      else
      begin
        s := TDictionaryWord.Create(LstSymbols);
        s.Name := strWord;
        s.SelStart := index;
        LstSymbols.Add(s, false, false);

        inc (index);
        strWord := '';
      end;
    end;
  end;

  if Length (AWord) <> 0 then
  begin
    w := ww.GetItemByName(AnsiLowerCase(strWord)) as TListWord;

    if Assigned (w) then
    begin
      l := TListWord.Create(ActiveObject.Words);
      l.Assign(w);
      l.SelStart := index;
      ActiveObject.Words.Add(l, false, false);
      ww.Remove(w);
    end
    else
    begin
      s := TDictionaryWord.Create(LstSymbols);
      s.Name := strWord;
      s.SelStart := index;
      LstSymbols.Add(s, false, false);
    end;
  end;

  ww.Free;
end;

procedure TfrmDescriptionKern.SetFontOnDefault (AEdt: TRichEdit; ASelStart, ASelLength: integer);
begin
  AEdt.SelStart := ASelStart;
  AEdt.SelLength := ASelLength;
  AEdt.SelAttributes.Charset := DEFAULT_CHARSET;
  AEdt.SelAttributes.Color := clWindowText;
  AEdt.SelAttributes.Height := -11;
  AEdt.SelAttributes.Name := 'Arial';
  AEdt.SelAttributes.Pitch := fpDefault;
  AEdt.SelAttributes.Size := 10;
  AEdt.SelAttributes.Style := [];
end;

procedure TfrmDescriptionKern.DrawAllWords;
var i, StartIndex, j : integer;
    text: string;
begin
  SetFontOnDefault(edtDescription, 0, Length(edtDescription.Text));

  StartIndex := 0;
  FSelIndex := 0;
  j := 0;
  text := '';
  for i := 0 to ActiveObject.Words.Count - 1 do
  begin
    if i <= ActiveObject.Words.Count then
    while j <> LstSymbols.Count do
    begin
      if (LstSymbols.Items[j].SelStart < ActiveObject.Words.Items[i].SelStart) then
      begin
        SetFontOnDefault (edtDescription, StartIndex, Length(LstSymbols.Items[j].Name));
        StartIndex := StartIndex + Length (LstSymbols.Items[j].Name);
        text := text + LstSymbols.Items[j].Name;
      end
      else break;

      inc (j);
    end
    else
    begin

    end;

    // просто проверка
    if Length(text) > StartIndex then StartIndex := Length(text);

    edtDescription.SelStart := StartIndex;
    edtDescription.SelLength := length(ActiveObject.Words.Items[i].Name);
    edtDescription.SelAttributes.Color := (ActiveObject.Words.Items[i].Root.Owner as TDictionary).Font.Color;
    edtDescription.SelAttributes.Style := (ActiveObject.Words.Items[i].Root.Owner as TDictionary).Font.Style;
    edtDescription.SelAttributes.Name := (ActiveObject.Words.Items[i].Root.Owner as TDictionary).Font.Name;

    if i <> (ActiveObject.Words.Count - 1) then
    begin
      StartIndex := StartIndex + Length (ActiveObject.Words.Items[i].Name);
      text := text + ActiveObject.Words.Items[i].Name
    end
    else FSelIndex := StartIndex + Length(ActiveObject.Words.Items[i].Name);
  end;
end;

procedure TfrmDescriptionKern.SetFont(AFont: TFont);
begin
  edtDescription.SelAttributes.Color := AFont.Color;
  edtDescription.SelAttributes.Style := AFont.Style;
  edtDescription.SelAttributes.Name := AFont.Name;
end;

procedure TfrmDescriptionKern.edtDescriptionKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var i: integer;
    Buffer: AnsiString;
    NewWord, TempStr, NewStr: string;
    w : TDictionaryWord;
    t: TListWord;
begin
  if ((Key = ord('V')) and (ssCtrl in Shift)) or ((Key = VK_INSERT) and (ssShift in Shift)) then
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    // добавить табуляцию

    edtBuffer.Clear;
    edtBuffer.PasteFromClipboard;
    TempStr := edtBuffer.Text;

    NewStr := #9;
    for i := 1 to Length(TempStr) do
      if TempStr[i] = #10 then NewStr := NewStr + TempStr[i] + #9
      else NewStr := NewStr + TempStr[i];

    Clipboard.AsText := NewStr;

    edtBuffer.PasteFromClipboard;
    edtDescription.PasteFromClipboard;

    Clipboard.Clear;

    ActiveObject.Words.Clear;
    Buffer := edtDescription.Text;

    NewWord := '';

    for i := 1 to Length(Buffer) do
    begin
      if (Buffer[i] in ['a'..'z', 'A'..'Z', 'а'..'я', 'А'..'Я']) then NewWord := NewWord + Buffer[i]
      else
      begin
        if (Buffer[i] = ' ') or (i = Length(Buffer)) then
        begin
          w := (TMainFacade.GetInstance as TMainFacade).AllWords.GetItemByName(AnsiLowerCase(trim(NewWord))) as TDictionaryWord;
          if Assigned (w) then
          begin
            t := TListWord.Create(ActiveObject.Words);
            t.Assign(w);

            if Assigned (w.Owner) then t.Root := w.Owner as TRoot
            else t.Root := (TMainFacade.GetInstance as TMainFacade).AllRoots.GetItemByName('<не указан>') as TRoot;

            ActiveObject.Words.Add(t, false, false);
          end;
          NewWord := '';
        end
      end;
    end;

    edtDescription.Text := ActiveObject.CheckAllText(edtDescription.Text);
    MakeListWords(edtDescription.Text);
  end
end;

procedure TfrmDescriptionKern.edtDescriptionChange(Sender: TObject);
begin
  FChangeMade := true;
end;

procedure TfrmDescriptionKern.dtCreateDesc1Change(Sender: TObject);
begin
  FChangeMade := true;
end;

procedure TfrmDescriptionKern.MakeListWords(AWord: string);
var i, j, maxLength: integer;
    Buffer: AnsiString;
    NewWord: string;
    w: TDictionaryWord;
    t : TListWord;
    r: TRoot;
begin
  Buffer := AWord;
  NewWord := '';

  ActiveObject.Words.Clear;

  for i := 1 to Length(Buffer) do
  begin
    if (Buffer[i] in ['a'..'z', 'A'..'Z', 'а'..'я', 'А'..'Я']) and (Buffer[i] <> #13) then NewWord := NewWord + Buffer[i]
    else
    begin
      // проверить тире или дефис
      if ((i <> 1) or (i <> Length(Buffer))) and (Buffer[i] = '-') then
      begin
        if (Buffer[i + 1] <> ' ') and (Buffer[i - 1] <> ' ') then
          NewWord := NewWord + Buffer[i]
      end
      else
      begin
        if (Buffer[i] = ' ') or (i = Length(Buffer)) or (Buffer[i] = #13) then
        begin
          // найти слово в словарях
          // сначала ищем слово
          w := (TMainFacade.GetInstance as TMainFacade).AllWords.GetItemByName(AnsiLowerCase(trim(NewWord))) as TDictionaryWord;

          if Assigned (w) then
          begin
            t := TListWord.Create(ActiveObject.Words);
            t.Assign(w);

            if Assigned (w.Owner) then t.Root := w.Owner as TRoot
            else t.Root := (TMainFacade.GetInstance as TMainFacade).AllRoots.GetItemByName('<не указан>') as TRoot;

            t.SelStart := i - length(t.Name) - 1;

            ActiveObject.Words.Add(t, false, false);

            // определить цвет для слова
            DrawWord(i, w.Name, t.root.owner as TDictionary);
          end
          else
          begin
            // Шаг 1 - ищем под какие значения корней подходит новое слово
            maxLength := 0;
            for j := 0 to (TMainFacade.GetInstance as TMainFacade).AllRoots.Count - 1 do
            begin
              if pos((TMainFacade.GetInstance as TMainFacade).AllRoots.Items[j].Name, NewWord) = 1 then
              if maxLength < Length((TMainFacade.GetInstance as TMainFacade).AllRoots.Items[j].Name) then
              begin
                maxLength := Length((TMainFacade.GetInstance as TMainFacade).AllRoots.Items[j].Name);
                r := (TMainFacade.GetInstance as TMainFacade).AllRoots.Items[j];
              end;
            end;

            // Шаг 2 - добавляем новое слово в словарь
            if (Assigned (r)) and (maxLength > 0) then
            begin
              w := TDictionaryWord.Create(r.Words);
              w.AllWords := (TMainFacade.GetInstance as TMainFacade).AllWords;
              w.Name := NewWord;
              r.Words.Add(w, false, false);
              w.Update;

              t := TListWord.Create(ActiveObject.Words);
              t.Assign(w);
              t.Root := w.Owner as TRoot;
              ActiveObject.Words.Add(t, false, false);

              //wD := TDictionaryWord.Create(TMainFacade.GetInstance.AllWords);
              //wD := w;
              //TMainFacade.GetInstance.AllWords.Add(wD);

              {
              TMainFacade.GetInstance.AllWords.ChangeMade := true;

              if not Assigned (ws) then ws := TDictionaryWords.Create;
              ws.Add(w, false, false);

              TMainFacade.GetInstance.AllWords.SetCorrectWords(ws);
              }
            end;
          end;
          NewWord := '';
        end
      end
    end;
  end;

  //SetNumbers(AWord);
  //DrawAllWords;
end;

procedure TfrmDescriptionKern.actnCheckTextExecute(Sender: TObject);
begin
  edtDescription.Text := ActiveObject.CheckAllText(edtDescription.Text);
  MakeListWords(edtDescription.Text);
end;

procedure TfrmDescriptionKern.cbxEmployeeChange(Sender: TObject);
begin
  FChangeMade := true;
end;

procedure TfrmDescriptionKern.cbxLithologioesChange(Sender: TObject);
begin
  FChangeMade := true;
end;

procedure TfrmDescriptionKern.plnSetLithologiesClick(Sender: TObject);
begin
  actnSetLithologies.Execute;
end;

procedure TfrmDescriptionKern.plnSetAuthorsClick(Sender: TObject);
begin
  actnSetAuthors.Execute;
end;

procedure TfrmDescriptionKern.actnSetLithologiesExecute(Sender: TObject);
begin
  frmAllListObjects := TfrmAllListObjects.Create(Self);

  (TMainFacade.GetInstance as TMainFacade).AllLithologies.MakeList(frmAllListObjects.frmAllObjects.lstObjects.Items, true, true);

  frmAllListObjects.frmAllObjects.ActiveLithologies.Assign(ActiveObject.Lithologies);
  frmAllListObjects.frmAllObjects.ReloadList(ActiveObject.Lithologies);

  frmAllListObjects.frmAllObjects.SetOptions(false);

  frmAllListObjects.ShowModal;

  if frmAllListObjects.ModalResult = mrOk then
  begin
    ActiveObject.Lithologies.Assign(frmAllListObjects.frmAllObjects.GetActiveLithologies);
    edtLithologies.Text := ActiveObject.Lithologies.ObjectsToStr;
    edtLithologies.Hint := edtLithologies.Text;
    ChangeMade := true;
  end;

  frmAllListObjects.Free;
end;

procedure TfrmDescriptionKern.actnSetAuthorsExecute(Sender: TObject);
begin
  frmAllListObjects := TfrmAllListObjects.Create(Self);

  TMainFacade.GetInstance.AllEmployees.MakeList(frmAllListObjects.frmAllObjects.lstObjects.Items);
  TMainFacade.GetInstance.AllEmployeeOuts.MakeList(frmAllListObjects.frmAllObjects.lstObjects.Items, false, false);

  frmAllListObjects.frmAllObjects.ActiveAuthors.Assign(ActiveObject.Authors);
  frmAllListObjects.frmAllObjects.ReloadList(ActiveObject.Authors);
  frmAllListObjects.ShowModal;

  if frmAllListObjects.ModalResult = mrOk then
  begin
    ActiveObject.Authors.Assign(frmAllListObjects.frmAllObjects.GetActiveAuthors);
    edtEmployee.Text := ActiveObject.Authors.ObjectsToStr;
    edtEmployee.Hint := edtEmployee.Text;
    ChangeMade := true;
  end;

  frmAllListObjects.Free;
end;

procedure TfrmDescriptionKern.lstHeaderCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var r: TRect;
begin
  r := Item.DisplayRect(drBounds);

  if Item.Index mod 2 = 0 then
  begin
    lstHeader.Canvas.Brush.Color := clCream;
    lstHeader.Canvas.FillRect(r);
    lstHeader.Canvas.Font.Color := clMaroon;
    lstHeader.Canvas.Font.Style := [fsBold];
    lstHeader.Canvas.TextOut(r.Left + 2, r.Top, Item.Caption);
  end
  else
  begin
    lstHeader.Canvas.Brush.Color := $F5F5F5;
    lstHeader.Canvas.FillRect(r);
    lstHeader.Canvas.Font.Color := clMaroon;
    lstHeader.Canvas.Font.Style := [fsBold];
    lstHeader.Canvas.TextOut(r.Left + r.Right - lstHeader.Canvas.TextWidth(Item.Caption), r.Top, Item.Caption);
  end;
end;

procedure TfrmDescriptionKern.btnLithologyClick(Sender: TObject);
begin
  FIndexDict := 1;
  actnAddWords.Execute;
end;

procedure TfrmDescriptionKern.btnStructureClick(Sender: TObject);
begin
  FIndexDict := 2;
  actnAddWords.Execute;
end;

procedure TfrmDescriptionKern.btnColorClick(Sender: TObject);
begin
  FIndexDict := 3;
  actnAddWords.Execute;
end;

procedure TfrmDescriptionKern.btnTecstureClick(Sender: TObject);
begin
  FIndexDict := 4;
  actnAddWords.Execute;
end;

procedure TfrmDescriptionKern.actnAddWordsExecute(Sender: TObject);
var w: TListWord;
begin
  frmAddWord := TfrmAddWord.Create(Self);

  case FIndexDict of
    0 : frmAddWord.ActiveDict := (TMainFacade.GetInstance as TMainFacade).Dicts.GetItemByName('Общий') as TDictionary;
    1 : frmAddWord.ActiveDict := (TMainFacade.GetInstance as TMainFacade).Dicts.GetItemByName('Литология') as TDictionary;
    2 : frmAddWord.ActiveDict := (TMainFacade.GetInstance as TMainFacade).Dicts.GetItemByName('Структура') as TDictionary;
    3 : frmAddWord.ActiveDict := (TMainFacade.GetInstance as TMainFacade).Dicts.GetItemByName('Цвет') as TDictionary;
    4 : frmAddWord.ActiveDict := (TMainFacade.GetInstance as TMainFacade).Dicts.GetItemByName('Текстура') as TDictionary;
  else frmAddWord.ActiveDict := nil;
  end;

  frmAddWord.ActiveWord := nil;
  frmAddWord.Reload;

  if trim(edtDescription.SelText) <> '' then
  begin
    frmAddWord.edtName.Text := trim(edtDescription.SelText);
    frmAddWord.cbxAllRoots.Text := trim(edtDescription.SelText);
  end
  else
  begin
    frmAddWord.edtName.Text := '';
    frmAddWord.cbxAllRoots.Text := '';
  end;

  frmAddWord.ShowModal;

  if frmAddWord.ModalResult = mrOk then
  begin
    with edtDescription.SelAttributes do
    begin
      Color := frmAddWord.ActiveDict.Font.Color;
      Style := frmAddWord.ActiveDict.Font.Style;
      Name := frmAddWord.ActiveDict.Font.Name;
    end;

    w := TListWord.Create(ActiveObject.Words);
    w.Assign(frmAddWord.ActiveWord);
    w.Root := frmAddWord.ActiveWord.Owner as TRoot;
    ActiveObject.Words.Add(w, false, false);
  end;

  frmAddWord.Free;
end;

function TfrmDescriptionKern.Save: boolean;
begin
  Result := false;

  with ActiveObject do
  begin
    if Authors.Count > 0 then
    if Lithologies.Count > 0 then
    if trim(edtDescription.Text) <> '' then
    begin
      AllText := edtDescription.Text;
      DateCreate := dtCreateDesc.Date;

      // еще раз проверить все слова
      MakeListWords(AllText);

      // найти двойные слова
      CheckDoubleWords;

      FChangeMade := false;
      Result := true;
    end
    else MessageBox(0, 'Не заполено поле с описанием керна.', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP)
    else MessageBox(0, 'Не указана литология.', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP)
    else MessageBox(0, 'Не указан ни один сотрудник.', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP);
  end;
end;

procedure TfrmDescriptionKern.actnInsertTextExecute(Sender: TObject);
var OrdWord: Word;
begin
  OrdWord := ord ('V');
  edtDescriptionKeyDown(Sender, OrdWord, [ssCtrl]);
end;

function TfrmDescriptionKern.CheckText: boolean;
var i, index: integer;
    Dicts: TDictionaries;
begin
  Result := false;

  Dicts := TDictionaries.Create;
  Dicts.Poster := nil;
  Dicts.Assign((TMainFacade.GetInstance as TMainFacade).Dicts);

  for i := 0 to ActiveObject.Words.Count - 1 do
  begin
    index := Dicts.IndexOf(((TMainFacade.GetInstance as TMainFacade).AllWords.ItemsByID[ActiveObject.Words.Items[i].ID] as TDictionaryWord).Owner.Owner);
    if index > -1 then Dicts.Delete(index);
  end;

  if Dicts.Count = 0 then Result := true;

  Dicts.Free;
end;

procedure TfrmDescriptionKern.actnAddWordExecute(Sender: TObject);
begin
  FIndexDict := 0;
  actnAddWords.Execute;
end;

procedure TfrmDescriptionKern.edtLithologiesChange(Sender: TObject);
begin
  ChangeMade := true;
end;

procedure TfrmDescriptionKern.edtEmployeeChange(Sender: TObject);
begin
  ChangeMade := true;
end;

procedure TfrmDescriptionKern.CheckWord;
var colSpellErrors : ProofreadingErrors;
    SaveChanges: olevariant;
begin
  WordApp.Documents.Add;
  WordDoc.ConnectTo(WrdApp.ActiveDocument);

  WordDoc.Range.Delete(EmptyParam, EmptyParam);
  WordDoc.Range.Set_Text(ActiveWord);

  colSpellErrors := WordDoc.SpellingErrors;

  if colSpellErrors.Count > 0 then
  begin
    edtDescription.SelStart := FSelStartWord;
    edtDescription.SelLength := Length (FActiveWord);

    RE_SetCharFormat(edtDescription, CFU_UNDERLINEWAVE, $50);
    edtDescription.SelText := ActiveWord;
    RE_SetCharFormat(edtDescription, CFU_UNDERLINENONE, $50);
  end;

  SaveChanges := false;
  WordDoc.Disconnect;
  WordDoc.Close(SaveChanges, EmptyParam, EmptyParam);
end;

procedure TfrmDescriptionKern.RE_SetCharFormat(ARichEdit: TRichEdit;
  AUnderlineType: Byte; AColor: Word);
var Format: CHARFORMAT2;
begin
  // The CHARFORMAT2 structure contains information about
  // character formatting in a rich edit control.
   FillChar(Format, SizeOf(Format), 0);
   with Format do
   begin
     cbSize := SizeOf(Format);
     dwMask := CFM_UNDERLINETYPE;
     bUnderlineType := AUnderlineType or AColor;
     ARichEdit.Perform(EM_SETCHARFORMAT, SCF_SELECTION, Longint(@Format));
   end;
end;

procedure TfrmDescriptionKern.actnSetReferencesExecute(Sender: TObject);
begin
  frmEditorReferences := TfrmEditorReferences.Create(Self);
  frmEditorReferences.frmLstFiles.LstDFiles.Assign(ActiveObject.Files);
  frmEditorReferences.frmLstFiles.Reload;

  if frmEditorReferences.ShowModal = mrOk then
  if frmEditorReferences.frmLstFiles.Changing then
    ActiveObject.Files.Assign(frmEditorReferences.frmLstFiles.LstDFiles);

  MakeFileList;

  frmEditorReferences.Free;
end;

procedure TfrmDescriptionKern.MakeFileList;
var i: Integer;
begin
  if ActiveObject.Files.Count > 0 then
  begin
    if ActiveObject.Files.Count = 1 then
    begin
      edtReferences.Text := ActiveObject.Files.Items[0].Document.LocationPath;
      edtReferences.Hint := ActiveObject.Files.Items[0].Document.LocationPath;
    end
    else
    begin
      edtReferences.Text := ActiveObject.Files.Items[0].Document.LocationPath + '; ...';

      for i := 0 to ActiveObject.Files.Count - 2 do
        edtReferences.Hint := edtReferences.Hint + ActiveObject.Files.Items[i].Document.LocationPath + ';' + #10#13;

      edtReferences.Hint := edtReferences.Hint + ActiveObject.Files.Items[ActiveObject.Files.Count - 1].Document.LocationPath;
    end;
  end;
end;

procedure TfrmDescriptionKern.DrawWord (iIndex: Integer; AWord: string; ADict: TDictionary);
begin
  edtDescription.SelStart := iIndex - length(AWord) - 1;
  edtDescription.SelLength := length(AWord);
  edtDescription.SelAttributes.Color := ADict.Font.Color;
  edtDescription.SelAttributes.Style := ADict.Font.Style;
  edtDescription.SelAttributes.Name := ADict.Font.Name;
end;

procedure TfrmDescriptionKern.actnOpenFileExecute(Sender: TObject);
begin
  if ActiveObject.Files.Count > 0 then
  begin
    if FileExists(ActiveObject.Files.Items[0].Document.LocationPath) then
    if ShellExecute(0, nil, PChar(ActiveObject.Files.Items[0].Document.LocationPath), nil, nil, SW_RESTORE) <= 32 then
      MessageBox(0, 'Ошибка чтения файла.', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONERROR);
  end;
end;

end.

