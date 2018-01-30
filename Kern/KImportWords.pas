unit KImportWords;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ImgList, ActnList, ComCtrls,
  ComObj, CoreDescription;

type
  TfrmImportWords = class(TForm)
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    actnLst: TActionList;
    actnToLeft: TAction;
    actnToRight: TAction;
    imgLst: TImageList;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    pnlButtons: TPanel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    GroupBox3: TGroupBox;
    cbxAllDicts: TComboBox;
    GroupBox4: TGroupBox;
    lstAllWords: TListBox;
    GroupBox5: TGroupBox;
    edtPath: TEdit;
    SpeedButton1: TSpeedButton;
    actnSetPath: TAction;
    dlg: TOpenDialog;
    edtText: TRichEdit;
    SpeedButton2: TSpeedButton;
    actnSave: TAction;
    GroupBox6: TGroupBox;
    lstWordsDict: TListBox;
    lstWords: TListView;
    procedure actnSetPathExecute(Sender: TObject);
    procedure lstAllWordsDblClick(Sender: TObject);
    procedure lstWordsDblClick(Sender: TObject);
    procedure actnToLeftExecute(Sender: TObject);
    procedure actnToRightExecute(Sender: TObject);
    procedure actnSaveExecute(Sender: TObject);
    procedure cbxAllDictsSelect(Sender: TObject);
    procedure lstWordsEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure lstWordsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lstWordsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FWords: TDictionaryWords;
    FAllWords: TDictionaryWords;
    FActiveWord: TDictionaryWord;

    function GetActiveDict: TDictionary;
  public
    property    Words: TDictionaryWords read FWords write FWords;
    property    AllWords: TDictionaryWords read FAllWords write FAllWords;

    property    ActiveDict: TDictionary read GetActiveDict;
    property    ActiveWord: TDictionaryWord read FActiveWord write FActiveWord;

    procedure   ReadFile;
    function    GetTheWord: string;

    procedure   Save;
    procedure   Clear;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmImportWords: TfrmImportWords;

implementation

uses Facade;

{$R *.dfm}

procedure TfrmImportWords.actnSetPathExecute(Sender: TObject);
var WrdApp: Variant;
    Document: Variant;         // исходный документ и новый
    Range: OLEVariant;         // область текста (начало области, конец области)
    j : integer;
    DocLength: integer;
    F :TFileStream;            // TFileStream позволяет создать поток для работы с файлами.
begin
  dlg.InitialDir := ExtractFilePath(Application.ExeName);
  dlg.Filter := '*.doc';
  dlg.Options := dlg.Options + [ofAllowMultiSelect, ofFileMustExist];

  if dlg.Execute then
  begin
    Clear;

    edtPath.Text := dlg.FileName;

    try
      // выбраный нами файл открывается для чтения  + открываем фаил с мусором
      F:= TFileStream.Create(ExtractFilePath(Application.ExeName) + 'list.rb', fmOpenRead);
    except
      F:=nil;
    end;

    try
      // активируем документ
      WrdApp := GetActiveOleObject('Word.Application');
    except
      try
        // Подключение  к серверу Word ("создание экземпляра сервера".)
        WrdApp := CreateOleObject('Word.Application');
        WrdApp.Visible := False;
      except
        Exception.Create('Error');
      end;
    end;

    // чтоб открыть несколько файлов сразу
    for j := 0 to dlg.Files.Count - 1 do
    begin
      // Открытие исходного документа
      Document := WrdApp.Documents.Open(dlg.Files[j]);
      Range := WrdApp.ActiveDocument.Range;
      DocLength := Length(Range.Text);

      edtText.Text := Document.Range(0, DocLength - 1).Text;

      GetTheWord;
  end;
  end;

  if WrdApp.Documents.Count = 0 then WrdApp.Quit;

  AllWords.MakeList(lstAllWords.Items);
end;

constructor TfrmImportWords.Create(AOwner: TComponent);
begin
  inherited;

  FAllWords := TDictionaryWords.Create;
  FWords := TDictionaryWords.Create();
  FActiveWord := TDictionaryWord.Create(FWords);

  (TMainFacade.GetInstance as TMainFacade).Dicts.MakeList(cbxAllDicts);
end;

destructor TfrmImportWords.Destroy;
begin

  inherited;
end;

function TfrmImportWords.GetTheWord: string;
var AWord: string;
    w: TDictionaryWord;
    i : integer;
begin
  AWord := '';
  for i := 0 to Length(edtText.Text) - 1 do
  begin
    if (edtText.Text[i] in ['a'..'z', 'A'..'Z', 'а'..'я', 'А'..'Я' {,... и т.д, и т.п.}]) and
       (not (edtText.Text[i] in [#0, ',', '.'])) then
      AWord := AWord + edtText.Text[i]
    else
    begin
      if Assigned ((TMainFacade.GetInstance as TMainFacade).AllWords.GetItemByName(AnsiLowerCase(AWord))) then AWord := ''
      else
      begin
        if trim (AWord) <> ''then
        begin
          w := TDictionaryWord.Create(AllWords);
          w.Name := trim(AWord);
          AllWords.Add(w, false, false);

          AWord := '';
        end;
      end;  
    end;
  end;

  AllWords.MakeList(lstAllWords.Items);
end;

procedure TfrmImportWords.ReadFile;
begin

end;

procedure TfrmImportWords.lstAllWordsDblClick(Sender: TObject);
begin
  actnToRight.Execute;
end;

procedure TfrmImportWords.lstWordsDblClick(Sender: TObject);
begin
  actnToLeft.Execute;
end;

procedure TfrmImportWords.actnToLeftExecute(Sender: TObject);
var i: integer;
    w: TDictionaryWord;
begin
  for i := 0 to lstWords.Items.Count - 1 do
    if lstWords.Items[i].Selected then
    begin
      w := TDictionaryWord.Create(AllWords);
      w.Name := lstWords.Items.Item[i].Caption;
      AllWords.Add(w, false, false);

      Words.Remove(w);
    end;

  AllWords.MakeList(lstAllWords.Items);

  lstWords.DeleteSelected;
end;

procedure TfrmImportWords.actnToRightExecute(Sender: TObject);
var i: integer;
    w: TDictionaryWord;
begin
  for i := 0 to lstAllWords.Count - 1 do
    if lstAllWords.Selected[i] then
    begin
      //lstWords.AddItem((lstAllWords.Items.Objects[i] as TDictionaryWord).Name, lstAllWords.Items.Objects[i] as TDictionaryWord);

      w := TDictionaryWord.Create(Words);
      w := lstAllWords.Items.Objects[i] as TDictionaryWord;
      Words.Add(w, false, false);

      AllWords.Remove(w);
    end;

  Words.MakeList(lstWords.Items, true, true);

  lstAllWords.DeleteSelected;
end;

procedure TfrmImportWords.actnSaveExecute(Sender: TObject);
begin
  Save;
end;

procedure TfrmImportWords.Save;
var i: integer;
begin
  if cbxAllDicts.ItemIndex > -1 then
  if lstWords.Items.Count > 0 then
  begin
    for i := 0 to Words.Count - 1 do
    begin
      //Words.Items[i].Owner.Owner := ActiveDict;
      Words.Items[i].Update;

      cbxAllDictsSelect(cbxAllDicts);
    end;
  end
  else MessageBox(0, 'Не выбрано ни одно слово для импорта', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP)
  else MessageBox(0, 'Не указан справочник', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP);
end;

procedure TfrmImportWords.Clear;
begin
  FWords.Clear;
  FAllWords.Clear;

  edtPath.Text := '';
  edtText.Text := '';
  lstWords.Clear;
  lstAllWords.Clear;
end;

function TfrmImportWords.GetActiveDict: TDictionary;
begin
  Result := nil;

  if (cbxAllDicts.ItemIndex > -1) and (cbxAllDicts.Items.Count > 0) then
    Result := cbxAllDicts.Items.Objects[cbxAllDicts.ItemIndex] as TDictionary;
end;

procedure TfrmImportWords.cbxAllDictsSelect(Sender: TObject);
begin
  //ActiveDict.Words.Clear;
  (TMainFacade.GetInstance as TMainFacade).Filter := 'DESCRIPTION_KERN_ID = ' + IntToStr(ActiveDict.ID);
  //ActiveDict.Words.Reload;
  //ActiveDict.Words.MakeList(lstWordsDict.Items);
end;

procedure TfrmImportWords.lstWordsEdited(Sender: TObject; Item: TListItem;
  var S: String);
begin
  if Assigned (ActiveWord) then ActiveWord.Name := S;
end;

procedure TfrmImportWords.lstWordsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Item.Selected then FActiveWord := Words.GetItemByName(Item.Caption) as TDictionaryWord;
end;

procedure TfrmImportWords.lstWordsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Ord(Key) = VK_F2 then
    lstWords.Selected.EditCaption;
end;

end.

