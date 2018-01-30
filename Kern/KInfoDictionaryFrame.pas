unit KInfoDictionaryFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, KDictionaryFrame, BaseGUI,
  UniButtonsFrame, ExtCtrls, ActnList, Buttons, ImgList, ComCtrls,
  ToolWin, CoreDescription, Menus;

type
  TfrmInfoDictionary = class;

  TInfoDictGUIAdapter = class(TGUIAdapter)
  private
    function    GetActiveDict: TDictionary;
    function    GetFrameOwner: TfrmInfoDictionary;
  public
    property    FrameOwner: TfrmInfoDictionary read GetFrameOwner;
    property    ActiveDict: TDictionary read GetActiveDict;

    procedure   Clear; override;
    function    Save: integer; override;
    procedure   Reload; override;
    function    StartFind: integer; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TfrmInfoDictionary = class(TFrame, IGUIAdapter)
    GroupBox3: TGroupBox;
    frmBtns: TfrmButtons;
    GroupBox2: TGroupBox;
    fdlg: TFontDialog;
    actnList: TActionList;
    actnFont: TAction;
    actnColor: TAction;
    imgList: TImageList;
    cldlg: TColorDialog;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    GroupBox4: TGroupBox;
    edtName: TEdit;
    actnAddRoot: TAction;
    lstAllValues: TListView;
    pm: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    ActnLst: TActionList;
    actnSetTrueWord: TAction;
    lstAllWords: TListBox;
    procedure edtNameChange(Sender: TObject);
    procedure frmBtnsactnAddExecute(Sender: TObject);
    procedure frmBtnsactnDeleteExecute(Sender: TObject);
    procedure clbxChange(Sender: TObject);
    procedure actnFontExecute(Sender: TObject);
    procedure actnColorExecute(Sender: TObject);
    procedure frmBtnsactnEditExecute(Sender: TObject);
    procedure lstAllRootsClick(Sender: TObject);
    procedure lstAllRootsDblClick(Sender: TObject);
    procedure lstAllRootsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstAllValuesCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lstAllValuesDblClick(Sender: TObject);
    procedure actnSetTrueWordExecute(Sender: TObject);
  private
    FActiveDict: TDictionary;
    FActiveRoot: TRoot;
    FActiveWord: TDictionaryWord;

    FInfoDictGUIAdapter: TInfoDictGUIAdapter;

    procedure   SetActiveDict(const Value: TDictionary);
    function    GetActiveRoot: TRoot;
    function    GetActiveWord: TDictionaryWord;
  public
    property    ActiveDict: TDictionary read FActiveDict write SetActiveDict;
    property    ActiveRoot: TRoot read GetActiveRoot;
    property    ActiveWord: TDictionaryWord read GetActiveWord;

    property    GUIAdapter: TInfoDictGUIAdapter read FInfoDictGUIAdapter implements IGUIAdapter;

    procedure   AddWord(AObject: TDictionaryWord);

    procedure   SetActiveElements(AValue: boolean);

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses KAddWord, Facade, KCommonFunctions, BaseFacades, Math;

{$R *.dfm}

{ TfrmInfoDictionary }

constructor TfrmInfoDictionary.Create(AOwner: TComponent);
begin
  inherited;
  FInfoDictGUIAdapter := TInfoDictGUIAdapter.Create(Self);
  frmBtns.GUIAdapter := FInfoDictGUIAdapter;

  lstAllValues.Column[0].Width := 0;
  lstAllValues.Column[4].Width := 0;
end;

destructor TfrmInfoDictionary.Destroy;
begin
  FInfoDictGUIAdapter.Free;
  inherited;
end;

procedure TfrmInfoDictionary.SetActiveDict(const Value: TDictionary);
begin
  GUIAdapter.BeforeReload;
  if FActiveDict <> Value then
  begin
    FActiveDict := Value;
    GUIAdapter.Reload;
  end;
  if not Assigned(FActiveDict) then GUIAdapter.Clear;
end;

procedure TfrmInfoDictionary.AddWord(AObject: TDictionaryWord);
begin
  frmAddWord := TfrmAddWord.Create(Self);

  frmAddWord.ActiveDict := ActiveDict;
  if Assigned (AObject) then frmAddWord.ActiveWord := AObject
  else if Assigned (frmAddWord.ActiveWord) then frmAddWord.ActiveWord := nil;
  frmAddWord.Reload;

  if frmAddWord.ShowModal = mrOk then
  begin
    FActiveDict.Roots.MakeList(lstAllWords.Items);
    FActiveDict.Roots.MakeList(lstAllValues.Items, true, true);

    FActiveWord := frmAddWord.ActiveWord;
    lstAllWords.Selected[lstAllWords.Count - 1] := true;
  end;

  GUIAdapter.Reload;

  frmAddWord.Free;
end;

procedure TfrmInfoDictionary.SetActiveElements(AValue: boolean);
begin
  edtName.ReadOnly := not AValue;
  frmBtns.Enabled := AValue;

  frmBtns.actnSave.Enabled := AValue;
  frmBtns.actnAdd.Enabled := AValue;
  frmBtns.actnEdit.Enabled := AValue;
  frmBtns.actnAutoSave.Enabled := AValue;
  frmBtns.actnDelete.Enabled := AValue;
  frmBtns.actnClear.Enabled := AValue;
  frmBtns.actnReload.Enabled := AValue;
  frmBtns.actnSelectAll.Enabled := AValue;
  frmBtns.actnAddGroup.Enabled := AValue;
end;

function TfrmInfoDictionary.GetActiveRoot: TRoot;
begin
  Result := nil;

  if ActiveDict.Name <> 'Литология (нередактируемый справочник)' then
    Result := ActiveDict.Roots.ItemsByID[StrToInt(lstAllValues.ItemFocused.SubItems[3])] as TRoot;
end;

function TfrmInfoDictionary.GetActiveWord: TDictionaryWord;
begin
  Result := nil;

  if ActiveDict.Name <> 'Литология (нередактируемый справочник)' then
  begin
  try
    Result := ActiveRoot.Words.ItemsByID[StrToInt(lstAllValues.ItemFocused.Caption)] as TDictionaryWord;
  except
  end
  end
  else Result := (TMainFacade.GetInstance as TMainFacade).AllWords.GetItemByName(lstAllValues.ItemFocused.SubItems[1]) as TDictionaryWord;

  {
  if Assigned(Result) then
  begin
    //FActiveRoot := FActiveWord.Owner as TRoot;
    if ActiveWord.Correct then pm.Items[0].Visible := false
    else pm.Items[0].Visible := true
  end
  else pm.Items[0].Visible := true;
  }
end;

{ TInfoDictGUIAdapter }

procedure TInfoDictGUIAdapter.Clear;
begin
  inherited;
  with FrameOwner do
  begin
    edtName.Clear;
    lstAllWords.Clear;
    lstAllValues.Clear;
  end;

  ChangeMade := false;
end;

constructor TInfoDictGUIAdapter.Create(AOwner: TComponent);
begin
  inherited;
  Buttons := [abAutoSave, abSave, abReload, abAdd, abEdit, abDelete, abClear];
  Self.SetAutoSave(false);
end;

function TInfoDictGUIAdapter.GetActiveDict: TDictionary;
begin
  Result := FrameOwner.FActiveDict;
end;

function TInfoDictGUIAdapter.GetFrameOwner: TfrmInfoDictionary;
begin
  Result := Owner as TfrmInfoDictionary;
end;

procedure TInfoDictGUIAdapter.Reload;
var i: integer;
begin
  if Assigned(ActiveDict) then
  with FrameOwner do
  begin
    edtName.Text := trim(ActiveDict.Name);

    for i := 0 to (TMainFacade.GetInstance as TMainFacade).Dicts.Count - 1 do
    begin
      try
        if Trim(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['ID' + IntToStr(i)]) <> '' then
        if StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['ID' + IntToStr(i)]) = FActiveDict.ID then
        begin
          FActiveDict.Font.Name := TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Name' + IntToStr(i)];
          FActiveDict.Font.Charset := StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['CharSet' + IntToStr(i)]);
          FActiveDict.Font.Color := StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Color' + IntToStr(i)]);
          FActiveDict.Font.Size := StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Size' + IntToStr(i)]);
          FActiveDict.Font.Style := TFontStyles(Byte(StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Style' + IntToStr(i)])));

          lstAllWords.Font.Name := TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Name' + IntToStr(i)];
          lstAllWords.Font.Charset := StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['CharSet' + IntToStr(i)]);
          lstAllWords.Font.Color := StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Color' + IntToStr(i)]);
          lstAllWords.Font.Size := StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Size' + IntToStr(i)]);
          lstAllWords.Font.Style := TFontStyles(Byte(StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Style' + IntToStr(i)])));
        end;
      except
        FActiveDict.Font.Name := (TMainFacade.GetInstance as TMainFacade).Font.Name;
        FActiveDict.Font.Charset := (TMainFacade.GetInstance as TMainFacade).Font.Charset;
        FActiveDict.Font.Color := (TMainFacade.GetInstance as TMainFacade).Font.Color;
        FActiveDict.Font.Size := (TMainFacade.GetInstance as TMainFacade).Font.Size;
        FActiveDict.Font.Style := (TMainFacade.GetInstance as TMainFacade).Font.Style;

        lstAllWords.Font.Name := (TMainFacade.GetInstance as TMainFacade).Font.Name;
        lstAllWords.Font.Charset := (TMainFacade.GetInstance as TMainFacade).Font.Charset;
        lstAllWords.Font.Color := (TMainFacade.GetInstance as TMainFacade).Font.Color;
        lstAllWords.Font.Size := (TMainFacade.GetInstance as TMainFacade).Font.Size;
        lstAllWords.Font.Style := (TMainFacade.GetInstance as TMainFacade).Font.Style;
      end;
    end;

      // добавить значения из справочника по литологии
    if ActiveDict.Name = 'Литология (нередактируемый справочник)' then
      ActiveDict.Roots.GetAddWords((TMainFacade.GetInstance as TMainFacade).AllRoots, (TMainFacade.GetInstance as TMainFacade).AllLithologies);

    ActiveDict.Roots.MakeList(lstAllValues.Items, true, true);
  end;
  inherited;
end;

function TInfoDictGUIAdapter.Save: integer;
begin
  Result := 0;

  if Assigned(ActiveDict) then
  begin
    ActiveDict.Name := trim(FrameOwner.edtName.Text);
    ActiveDict.Font.Name := FrameOwner.lstAllWords.Font.Name;
    ActiveDict.Font.Charset := FrameOwner.lstAllWords.Font.Charset;
    ActiveDict.Font.Color := FrameOwner.lstAllWords.Font.Color;
    ActiveDict.Font.Size := FrameOwner.lstAllWords.Font.Size;
    ActiveDict.Font.Style := FrameOwner.lstAllWords.Font.Style;

    // коллекция со словами сохраняется сразу же, когда добавляется,
    // редактируется или удаляется слово

    Result := ActiveDict.Update;

    // сохранить настройки
    (TMainFacade.GetInstance as TMainFacade).Dicts.SaveFont((TMainFacade.GetInstance as TMainFacade).Dicts);
    //(TMainFacade.GetInstance as TMainFacade).SystemSettings.SaveToFile((TMainFacade.GetInstance as TMainFacade).SettingsFileName);

    ChangeMade := false;

    Reload;
  end
  else Clear;
end;

function TInfoDictGUIAdapter.StartFind: integer;
begin
  Result := 0;
end;

procedure TfrmInfoDictionary.edtNameChange(Sender: TObject);
begin
  GUIAdapter.ChangeMade := true;
end;

procedure TfrmInfoDictionary.frmBtnsactnAddExecute(Sender: TObject);
begin
  if ActiveDict.Name <> 'Литология (нередактируемый справочник)' then
  begin
    frmBtns.actnAddExecute(Sender);
    AddWord(nil);
  end;
end;

procedure TfrmInfoDictionary.frmBtnsactnDeleteExecute(Sender: TObject);
var ls: TListWords;
    Deleted: boolean;
    index: integer;
begin
  if ActiveDict.Name <> 'Литология (нередактируемый справочник)' then
  begin
    //frmBtns.actnDeleteExecute(Sender);

    Deleted := false;

    // проверяем есть ли такое слово в каком-либо описании керна
    try
      ls := TListWords.Create;
      ls.Poster.GetFromDB('kern_value_id = ' + IntToStr(ActiveWord.id), ls);

      // проверяем используется это слово где-нить или нет
      if ls.Count = 0 then Deleted := true
      else if MessageBox(0, PChar('Слово встречается в одном/нескольких из описании керна. Продолжить?'),
                  PChar('Предупреждение'), MB_YESNO	+ MB_ICONWARNING + MB_APPLMODAL) = ID_YES then Deleted := true;

      ls.Free;
    except
      Deleted := false;
    end;

    if Deleted then
    begin
      // по внешнему ключу все лишнее должно удалиться
      //index := (TMainFacade.GetInstance as TMainFacade).AllWords.IndexOf(ActiveWord);
      //(TMainFacade.GetInstance as TMainFacade).AllWords.OwnsObjects := false;
      //ActiveWord.Collection.OwnsObjects := false;
      //(TMainFacade.GetInstance as TMainFacade).AllWords.Delete(index);

      //ActiveRoot.Words.Free;

      //ActiveWord.Collection.OwnsObjects := true;
      //ActiveRoot.Words.Update(ActiveRoot.Words);
      ActiveRoot.Words.Remove(ActiveWord);

      GUIAdapter.Reload;
    end;
  end;
end;

procedure TfrmInfoDictionary.clbxChange(Sender: TObject);
begin
  GUIAdapter.ChangeMade := true;
end;

procedure TfrmInfoDictionary.actnFontExecute(Sender: TObject);
begin
  fdlg.Font := ActiveDict.Font;

  if fdlg.Execute then
  begin
    lstAllWords.Font := fdlg.Font;

    GUIAdapter.ChangeMade := true;
    GUIAdapter.Save;
  end;
end;

procedure TfrmInfoDictionary.actnColorExecute(Sender: TObject);
begin
  if cldlg.Execute then
    lstAllWords.Font.Color := cldlg.Color;
end;

procedure TfrmInfoDictionary.frmBtnsactnEditExecute(Sender: TObject);
begin
  if ActiveDict.Name <> 'Литология (нередактируемый справочник)' then
  begin
    frmBtns.actnEditExecute(Sender);
    AddWord(ActiveWord);
  end;
end;

procedure TfrmInfoDictionary.lstAllRootsClick(Sender: TObject);
begin
  if (lstAllWords.ItemIndex >= 0) and (lstAllWords.Count > 0) then
    FActiveWord := lstAllWords.Items.Objects[lstAllWords.ItemIndex] as TDictionaryWord;
end;

procedure TfrmInfoDictionary.lstAllRootsDblClick(Sender: TObject);
begin
  frmBtnsactnEditExecute(Sender);
end;

procedure TfrmInfoDictionary.lstAllRootsDrawItem(Control: TWinControl;
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

procedure TfrmInfoDictionary.lstAllValuesCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var r: TRect;
begin
  r := Item.DisplayRect(drBounds);

  if Item.Index mod 2 = 0 then
  begin
    lstAllValues.Canvas.Brush.Color := $00EFEFEF;
    lstAllValues.Canvas.FillRect(r);
  end
  else
  begin
    lstAllValues.Canvas.Brush.Color := $00FFFFFF;
    lstAllValues.Canvas.FillRect(r);
  end;

  //if Assigned(FActiveRoot.Words.ItemsByID[StrToInt(Item.Caption)] as TDictionaryWord) then
  //if not (FActiveRoot.Words.ItemsByID[StrToInt(Item.Caption)] as TDictionaryWord).Correct then
  //begin
  //  lstAllValues.Canvas.Brush.Color := clRed;
  //  lstAllValues.Canvas.FillRect(r);
  //end;

  lstAllValues.Canvas.Font.Color := FActiveDict.Font.Color;
  lstAllValues.Canvas.Font.Style := FActiveDict.Font.Style;
  lstAllValues.Canvas.TextOut(r.Left + 2, r.Top, Item.Caption);
end;

procedure TfrmInfoDictionary.lstAllValuesDblClick(Sender: TObject);
begin
  if (lstAllValues.ItemIndex > -1) and (ActiveDict.Name <> 'Литология (нередактируемый справочник)') then
    frmBtns.actnEdit.Execute;
end;

procedure TfrmInfoDictionary.actnSetTrueWordExecute(Sender: TObject);
begin
  ActiveWord.Correct := true;
end;

end.
