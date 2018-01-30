unit KAddWord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ActnList, CoreDescription;

type
  TfrmAddWord = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    actnLst: TActionList;
    actnSave: TAction;
    GroupBox2: TGroupBox;
    cbxDicts: TComboBox;
    SpeedButton1: TSpeedButton;
    actnAddDict: TAction;
    GroupBox3: TGroupBox;
    mmComment: TMemo;
    GroupBox4: TGroupBox;
    SpeedButton2: TSpeedButton;
    cbxAllRoots: TComboBox;
    edtName: TEdit;
    pnl: TPanel;
    BitBtn3: TBitBtn;
    actnSaveAndNew: TAction;
    procedure actnSaveExecute(Sender: TObject);
    procedure cbxDictsChange(Sender: TObject);
    procedure actnAddDictExecute(Sender: TObject);
    procedure cbxAllRootsChange(Sender: TObject);
    procedure actnSaveAndNewExecute(Sender: TObject);
  private
    FActiveDict: TDictionary;
    FActiveWord: TDictionaryWord;
    FActiveRoot: TRoot;

  public
    property    ActiveDict: TDictionary read FActiveDict write FActiveDict;
    property    ActiveRoot: TRoot read FActiveRoot write FActiveRoot;
    property    ActiveWord: TDictionaryWord read FActiveWord write FActiveWord;

    procedure   Clear;
    procedure   Reload;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmAddWord: TfrmAddWord;

implementation

uses Facade, KDictDescriptions, BaseObjects;

{$R *.dfm}

{ TForm1 }

constructor TfrmAddWord.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmAddWord.Destroy;
begin

  inherited;
end;

procedure TfrmAddWord.actnSaveExecute(Sender: TObject);
var r: TRoot;
begin
  if (trim(edtName.Text) <> '') and (trim(edtName.Text) <> '<Введите значение>') then
  if (trim(cbxAllRoots.Text) <> '') then
  begin
    // добавляем новый корень
    ActiveRoot := ActiveDict.Roots.GetItemByName(trim(cbxAllRoots.Text)) as TRoot;
    if not Assigned(ActiveRoot) then
    begin
        r := TRoot.Create(ActiveDict.Roots);
        r.Name := AnsiLowerCase(trim(cbxAllRoots.Text));
        ActiveDict.Roots.Add(r, false, false);
        r.Update;
        FActiveRoot := r;
    end;

    if not Assigned(FActiveWord) then FActiveWord := TDictionaryWord.Create(FActiveRoot.Words);

    FActiveWord.Name := AnsiLowerCase(trim(edtName.Text));
    FActiveWord.Comment := trim (mmComment.Text);

    if not Assigned (FActiveRoot.Words.GetItemByName(AnsiLowerCase(trim(edtName.Text)))) then
    begin
      FActiveRoot.Words.Add(FActiveWord, false, false);
      FActiveWord.Update;
    end;
  end
  else MessageBox(0, 'Не указан корень слова.', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP)
  else MessageBox(0, 'Не указано значение слова.', 'Ошибка', MB_APPLMODAL + MB_OK + MB_ICONSTOP)
end;

procedure TfrmAddWord.cbxDictsChange(Sender: TObject);
begin
  if cbxDicts.ItemIndex > -1 then
  begin
    FActiveDict := cbxDicts.Items.Objects[cbxDicts.ItemIndex] as TDictionary;
    FActiveDict.Roots.MakeList(cbxAllRoots.Items);
  end;
end;

procedure TfrmAddWord.Clear;
begin
  cbxDicts.ItemIndex := 0;

  FActiveDict := cbxDicts.Items.Objects[cbxDicts.ItemIndex] as TDictionary;
  FActiveDict.Roots.MakeList(cbxAllRoots.Items);

  edtName.Text := '<Введите значение>';
  mmComment.Clear;
end;

procedure TfrmAddWord.actnAddDictExecute(Sender: TObject);
begin
  frmDicts := TfrmDicts.Create(Self);
  frmDicts.frmAllDicts.GUIAdapter.Add;
  frmDicts.ShowModal;

  (TMainFacade.GetInstance as TMainFacade).Dicts.MakeList(cbxDicts.Items);

  frmDicts.Free;
end;

procedure TfrmAddWord.Reload;
begin
  (TMainFacade.GetInstance as TMainFacade).Dicts.MakeList(cbxDicts);

  if Assigned (FActiveDict) then
  begin
    cbxDicts.ItemIndex := cbxDicts.Items.IndexOfObject(FActiveDict);
    FActiveDict.Roots.MakeList(cbxAllRoots.Items, true, true);
  end
  else cbxDicts.ItemIndex := -1;

  if Assigned (FActiveWord) then
  begin
    edtName.Text := FActiveWord.Name;
    mmComment.Text := trim(FActiveWord.Comment);
    cbxAllRoots.ItemIndex := cbxAllRoots.Items.IndexOfObject(FActiveWord.Owner);
  end
  else edtName.Text := '<Введите значение>';
end;

procedure TfrmAddWord.cbxAllRootsChange(Sender: TObject);
begin
  if cbxAllRoots.ItemIndex > -1 then
  begin
    FActiveRoot := cbxAllRoots.Items.Objects[cbxAllRoots.ItemIndex] as TRoot;

    if (trim(edtName.Text) = '') or (trim(edtName.Text) = '<Введите значение>') then
      edtName.Text := FActiveRoot.Name;
  end
  else FActiveRoot := nil;
end;

procedure TfrmAddWord.actnSaveAndNewExecute(Sender: TObject);
begin
  actnSave.Execute;
  ActiveWord := nil;
  frmAddWord.edtName.Text := ActiveRoot.Name;
end;

end.
