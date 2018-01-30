unit SubDividerComponentEditFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SubDividerCommonObjects, CheckLst, ComCtrls, ImgList;

type
  TfrmSubComponentEdit = class(TFrame)
    gbxProperties: TGroupBox;
    Label3: TLabel;
    edtDepth: TEdit;
    cmbxEdgeComment: TComboBox;
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    mmProperties: TMemo;
    imgLst: TImageList;
    pgctl: TPageControl;
    tshCommon: TTabSheet;
    tshPlus: TTabSheet;
    chlbxPlus: TCheckListBox;
    cmbxFilter: TComboBox;
    lblFilter: TLabel;
    chbxTemplateEdit: TCheckBox;
    Label5: TLabel;
    Label4: TLabel;
    cmbxComment: TComboBox;
    Label1: TLabel;
    cmbxStraton: TComboBox;
    Label2: TLabel;
    cmbxNextStraton: TComboBox;
    chbxChangeUndivided: TCheckBox;
    chbxVerified: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure cmbxFilterChange(Sender: TObject);
    procedure cmbxStratonChange(Sender: TObject);
    procedure edtDepthChange(Sender: TObject);
    procedure chlbxPlusClickCheck(Sender: TObject);
    procedure cmbxCommentChange(Sender: TObject);
    procedure edtDepthKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pgctlChange(Sender: TObject);
  private
    { Private declarations }
    FWithButtons: boolean;
    FEditingComponent: TSubDivisionComponent;
    FAddTo: TSubDivision;
    FSearchString: string;
    FNearestComponent: TSubdivisionComponent;
    FUndividedChanged: integer;
    procedure   SetSearchString(const Value: string);
    procedure   SetAdditionalStratons(Value: TStratons);
    procedure   ClearAll;
    procedure   SetEditingComponent(Value: TSubDivisionComponent);
    procedure   SetWithButtons(const Value: boolean);
    procedure   Init;
    property    SearchString: string read FSearchString write SetSearchString;
    function    CheckedCount: integer;
    procedure   EnableOK;
  public
    { Public declarations }
    property    AddTo: TSubDivision read FAddTo write FAddTo;
    property    AdditionalStratons: TStratons write SetAdditionalStratons;
    property    EditingComponent: TSubDivisionComponent read FEditingComponent write SetEditingComponent;
    property    NearestComponent: TSubdivisionComponent read FNearestComponent write FNearestComponent;
    property    WithButtons: boolean read FWithButtons write SetWithButtons;
    property    UndividedChanged: integer read FUndividedChanged;
    procedure   ShowChanges;
    constructor Create(AOwner: TComponent); override;

  end;

implementation

uses SubDividerCommon, ClientCommon;

{$R *.DFM}
procedure   TfrmSubComponentEdit.SetSearchString(const Value: string);
var i, iPos: integer;
    sSearch, sStraton: string;
    ValidRanges: set of byte;
begin
  if WithButtons or (pgctl.ActivePageIndex = 1) then
  begin
    iPos := DigitPos(Value);
    if (iPos > 1) and (iPos + 1= pos(' ', Value)) then Dec(iPos);

    sSearch := trim(copy(Value, 1, iPos));
    // выбираем фильтр из списка

    ValidRanges := [];

    if WithButtons then
    begin
      if Assigned(FEditingComponent) then
      begin
      with FEditingComponent do
      for i := 0 to Stratons.Count - 1 do
        ValidRanges := ValidRanges + [0 .. Stratons[i].TaxRange];
      end;
    end;
    //else sSearch := Value;



    if ValidRanges = [] then ValidRanges := [0 .. 255];

    if (sSearch <> FSearchString) and (pos(FSearchString, sSearch) = 0)  then
    begin
      if WithButtons then chlbxPlus.Items.Clear;
      with cmbxFilter do
      begin
        ItemIndex := -1;
        for i := 0 to Items.Count - 1 do
        if (sSearch = (Items.Objects[i] as TStraton).StratonIndex) then
        begin
          ItemIndex := i;
          break;
        end;
      end;
      
      FSearchString := sSearch;

      if sSearch = '' then
      begin
        with AllStratons do
        for i := 0 to Count - 1 do
        if Items[i].TaxRange in ValidRanges then
          chlbxPlus.Items.AddObject(Items[i].ListStraton(sloIndexName), Items[i]);
        exit;
      end
      else
      begin
        sSearch := RusTransLetter(AnsiUpperCase(sSearch));

        with AllStratons do
        for i := 0 to Count - 1 do
        begin
          sStraton := RusTransLetter(Items[i].StratonIndex);
          if  (pos(sSearch, sStraton) = 1)
          and (Items[i].TaxRange in ValidRanges) then
            chlbxPlus.Items.AddObject(Items[i].ListStraton(sloIndexName), Items[i]);
        end;
      end;
    end;
  end;
end;

procedure   TfrmSubComponentEdit.SetAdditionalStratons(Value: TStratons);
var i, iIndex: integer;
begin
  if Assigned(Value) then
  begin
    cmbxStraton.ItemIndex := cmbxStraton.Items.IndexOf(Value[0].ListStraton(sloIndexName));
    cmbxNextStraton.ItemIndex := -1;
    if Value.Count > 1 then
       cmbxNextStraton.ItemIndex := cmbxNextStraton.Items.IndexOf(Value[1].ListStraton(sloIndexName));

    chlbxPlus.Items.BeginUpdate;

    iIndex := 0;
    for i := 1 to Value.Count - 1 do
    if Value[i].TaxRange < Value[iIndex].TaxRange then iIndex := i;

    SearchString := Value[iIndex].ListStraton(sloIndexName);

    for i := 0 to Value.Count - 1 do
    begin
       iIndex := chlbxPlus.Items.IndexOf(Value[i].ListStraton(sloIndexName));
       if iIndex > -1 then
       begin
         chlbxPlus.Checked[iIndex] := true;
         chlbxPlus.ItemIndex := iIndex;
      end;
    end;
    chlbxPlus.Items.EndUpdate;
  end;
end;

procedure   TfrmSubComponentEdit.ClearAll;
begin
  cmbxStraton.ItemIndex := -1;
  cmbxNextStraton.ItemIndex := -1;
  edtDepth.Clear;
  edtDepth.Enabled := true;
  //cmbxComment.ItemIndex := -1;
  cmbxEdgeComment.ItemIndex := -1;
end;

{constructor TfrmSubComponentEdit.Create(AOwner: TComponent);
begin
  FWithButtons := false;
end;}

procedure   TfrmSubComponentEdit.SetEditingComponent(Value: TSubDivisionComponent);
var Well: TWell;
    sD: TSubDivision;
    i, iIndex: integer;
begin
  tshPlus.TabVisible := GatherComponents;
  chbxVerified.Checked := true;
  if FEditingComponent <> Value then
  begin
    FEditingComponent := Value;
    ClearAll;
    FSearchString := ' ';
    chlbxPlus.Clear;

    // загружаем стратоны чтобы показать плюсовик

    if Assigned(Value) then
    with FEditingComponent do
    begin
      chbxVerified.Checked := Verified;

      if GatherComponents then
      begin
        if  (FEditingComponent.Stratons.Count > 1)
        and (FEditingComponent.Divider = '+') then pgctl.ActivePageIndex := 1
        else pgctl.ActivePageIndex := 0;

        chlbxPlus.Items.BeginUpdate;
        iIndex := 0;
        for i := 1 to Stratons.Count - 1 do
        if Stratons[i].TaxRange < Stratons[iIndex].TaxRange then iIndex := i;
        SearchString := Stratons[iIndex].ListStraton(sloIndexName);

        for i := 0 to Stratons.Count - 1 do
        begin
          iIndex := chlbxPlus.Items.IndexOf(Stratons[i].ListStraton(sloIndexName));
          if iIndex > -1 then
          begin
            chlbxPlus.Checked[iIndex] := true;
            chlbxPlus.ItemIndex := iIndex;
          end;
        end;

        if not WithButtons then
        for i := chlbxPlus.Items.Count - 1 downto 0 do
        if not chlbxPlus.Checked[i] then chlbxPlus.Items.Delete(i);

        chlbxPlus.Items.EndUpdate;
      end;

      cmbxStraton.ItemIndex := cmbxStraton.Items.IndexOf(Stratons[0].ListStraton(sloIndexName));
      if Stratons.Count > 1 then
         cmbxNextStraton.ItemIndex := cmbxNextStraton.Items.IndexOf(Stratons[1].ListStraton(sloIndexName));

      if Depth > 0 then
         edtDepth.Text := trim(Format('%6.2f',[Depth]))
      else
         edtDepth.Text := '';


      cmbxComment.ItemIndex := cmbxComment.Items.IndexOfObject(TObject(SubdivisionCommentID));
      edtDepth.Enabled := (cmbxComment.ItemIndex <> 1);
      
      Well := ((Collection as TSubDivisionComponents).SubDivision.Collection as TSubdivisions).Well;
      mmProperties.Clear;
      mmProperties.Lines.Add('скв. ' + Well.WellNum + ' - ' + Well.AreaName);
      mmProperties.Lines.Add('альт. ' + trim(Format('%6.2f', [Well.Altitude])));
      mmProperties.Lines.Add('забой ' + trim(Format('%6.2f', [Well.Depth])));

      sD := (Collection as TSubDivisionComponents).SubDivision;
      if sD.TectonicBlock <> '' then
        mmProperties.Lines.Add('тект. блок. ' + sD.TectonicBlock);
    end
    else SearchString := '';
  end;
  EnableOk;
end;


procedure   TfrmSubComponentEdit.ShowChanges;
var C: TSubDivisionComponent;
begin
  C := FEditingComponent;
  FEditingComponent := nil;
  EditingComponent := C;
end;

function    TfrmSubComponentEdit.CheckedCount: integer;
var i: integer;
begin
  Result := 0;
  with chlbxPlus do
  for i := 0 to Items.Count - 1 do
    inc(Result, ord(Checked[i]));
end;

procedure   TfrmSubComponentEdit.EnableOK;
var S: String;
procedure DecorateEdit(AColor: TColor);
begin
  edtDepth.Font.Color := AColor;
  case AColor of
  clRed: edtDepth.Font.Style := [fsBold];
  clBlack: edtDepth.Font.Style := [];
  end;
end;
begin
  if WithButtons then
  begin
    S := StringReplace(edtDepth.Text, '.', DecimalSeparator, [rfReplaceAll]);
    S := StringReplace(S, ',', DecimalSeparator, [rfReplaceAll]);

    try
      DecorateEdit(clBlack);
      btnOK.Enabled := true;
      StrToFloat(S)
    except
      if S <> '' then
      begin
        DecorateEdit(clRed);
        btnOK.Enabled := false
      end
      else
      if cmbxComment.ItemIndex > 1 then
        btnOK.Enabled := true
      else btnOk.Enabled := false;
    end;

    if btnOK.Enabled then
    case pgctl.ActivePageIndex of
    0: btnOK.Enabled := cmbxStraton.ItemIndex > -1;
    1: btnOK.Enabled := CheckedCount > 0;
    end;
  end;
end;


procedure   TfrmSubComponentEdit.Init;
var strlst: TStringList;
    i: integer;
begin
  if Assigned(AllStratons) then
  begin
    strlst := TStringList.Create;


    strlst.Clear;
    AllDicts.MakeList(strlst, AllDicts.CommentDict);
    //cmbxComment.Items.AddStrings(strlst);

    {strlst.Clear;
    AllDicts.MakeList(strlst, AllDicts.EdgesDict);
    cmbxEdgeComment.Items.AddStrings(strlst);}
    cmbxNextStraton.Items.AddObject('<нет>', nil);
    if Assigned(AllStratons) then
    with AllStratons do
    for i := 0 to Count - 1 do
    begin
      cmbxStraton.Items.AddObject(Items[i].ListStraton(sloIndexName), Items[i]);
      cmbxNextStraton.Items.AddObject(Items[i].ListStraton(sloIndexName), Items[i]);

      if Items[i].TaxRange < 6 then
         cmbxFilter.Items.AddObject(Items[i].ListStraton(sloIndexName), Items[i]);
    end;

    strlst.Free;
  end;
  EnableOK;
end;

procedure   TfrmSubComponentEdit.SetWithButtons(const Value: boolean);
begin
  FWithButtons := Value;
  pnlButtons.Visible := FWithButtons;
  chbxTemplateEdit.Visible := FWithButtons;
  chbxChangeUndivided.Visible := FWithButtons;  
  Height := Height - ord(not FWithButtons)* pnlButtons.Height
                   + ord(FWithButtons)* pnlButtons.Height;
  Init;
  if not WithButtons then gbxProperties.Enabled := false;
  cmbxFilter.Visible := WithButtons;
  lblFilter.Visible := WithButtons;  
end;



procedure TfrmSubComponentEdit.btnOKClick(Sender: TObject);
var iCommentID, i: integer;
    Strs{, Strs2}: TStratons;
    sDivider: char;
    C, unDiv: TSubDivisionComponent;

    fDepth, fLastDepth: single;
begin
  FUndividedChanged := 0;
//  C := EditingComponent;
  C := nil;
  //Strs2 := nil;
  Strs := TStratons.Create(false);
  if pgctl.ActivePageIndex = 0 then
  begin
    Strs.AddStratonRef(TStraton(cmbxStraton.Items.Objects[cmbxStraton.ItemIndex]));
    if cmbxNextStraton.ItemIndex > 0 then
       Strs.AddStratonRef(TStraton(cmbxNextStraton.Items.Objects[cmbxNextStraton.ItemIndex]));
    sDivider := '-';
    C := EditingComponent;
    if not Assigned(C) then
    begin
      C := AddTo.Content.ComponentByID(Strs[0].StratonID);
      // если не удалось найти  - добавляем
      if not Assigned(C) then
      if not Assigned(EditingComponent) then
        C := AddTo.Content.Add as TSubDivisionComponent
      else
        C := AddTo.Content.Insert(EditingComponent.Index + 1) as TSubDivisionComponent;

      C.Stratons.Assign(Strs);
    end
    else C.Stratons.Assign(Strs);

    if cmbxComment.ItemIndex > -1 then
      C.SubDivisionCommentID := Integer(cmbxComment.Items.Objects[cmbxComment.ItemIndex])
    else
      C.SubDivisionCommentID := 0;

    C.Divider := '-';
  end
  else
  begin
    for i := 0 to chlbxPlus.Items.Count - 1 do
    if chlbxPlus.Checked[i] then
      Strs.AddStratonRef(chlbxPlus.Items.Objects[i] as TStraton);

    {if (not chbxTemplateEdit.Checked) and
            not (Assigned(EditingComponent)
            and (Strs.Count = 1)
            and ((EditingComponent.Index > 0)
            and (Addto.Content[EditingComponent.Index - 1].SubDivisionCommentID = 0))) then
    begin
      Strs2 := TStratons.Create(false);
      Strs2.AddStratonRef(Strs[Strs.Count - 1]);
      Strs.Exclude(Strs2);
    end
    else Strs2 := nil;}

    sDivider := '+';
    if not Assigned(C) then
    begin
      //if not Assigned(strs2) then
        C := EditingComponent;
      //else C := AddTo.Content.ComponentByStratons(Strs, '+');

      // если не удалось найти  - добавляем
      if not Assigned(C) then
      begin
        if not Assigned(EditingComponent) then
          C := AddTo.Content.Add as TSubDivisionComponent
        else
          C := AddTo.Content.Insert(EditingComponent.Index + 1) as TSubDivisionComponent;
      end;

      C.Stratons.Assign(Strs);
      C.SubDivisionCommentID := 1;
      C.Divider := '+';

     { if Assigned(strs2) then
      begin
        C := EditingComponent;
        if not Assigned(C) then
        begin
          C := AddTo.Content.ComponentByID(Strs2[0].StratonID);
          if not Assigned(C) then
            C := AddTo.Content.Add as TSubDivisionComponent;
        end;

        C.Stratons.Assign(Strs2);
        C.SubDivisionCommentID := 0;
        C.Divider := '-';
        chbxChangeUndivided.Checked := true;
      end;}
    end
  end;


  if Assigned(C) then
  with C do
  begin
    fLastDepth := Depth;
    if edtDepth.Text <> '' then
      Depth := StrToFloat(edtDepth.Text)
    else Depth := -2;
    //SubDivisionComment := cmbxComment.Text;
    Divider := sDivider;
    //if not Strs.EqualTo(Stratons) then

    C.Verified := chbxVerified.Checked;

    C.PostToDB;

    EditingComponent := C;
    // это потом
{    if chbxChangeUndivided.Checked then
    begin
      i := C.Index + 1;
      try
        unDiv := (C.Collection as TSubDivisionComponents).Items[i];
      except
        undiv := nil;
      end;
      // пытаемся заменить все нерасчленненные, если меняется нижняя глубина
      while ((i < C.Collection.Count)
        and Assigned(unDiv)
//        and (unDiv.Depth = fLastDepth)
        and (unDiv.SubDivisionCommentID = 1)) do
      begin
        unDiv.Depth := C.Depth;
        unDiv.PostToDB;
        inc(FUndividedChanged);
        inc(i);
        try
          unDiv := (C.Collection as TSubDivisionComponents).Items[i];
        except
          undiv := nil;
        end;


      end;
    end;}
  end
  else
  begin
    iCommentID := 0;
    if cmbxComment.ItemIndex > 0 then
      iCommentID := Integer(cmbxComment.Items.Objects[cmbxComment.ItemIndex]);
    if edtDepth.Text <> '' then
      fDepth := StrToFloat(edtDepth.Text)
    else fDepth := -2;

    //iCommentID := GetObjectID(AllDicts.CommentDict, cmbxComment.Text);
    EditingComponent := AddTo.AddComponent(Strs, sDivider, iCommentID, fDepth, chbxVerified.Checked);
    EditingComponent.PostToDB;
  end;
  Strs.Free;
//  Strs2.Free;
end;

procedure TfrmSubComponentEdit.cmbxFilterChange(Sender: TObject);
begin
  FSearchString := ' ';
  with cmbxFilter do
    SearchString := (Items.Objects[ItemIndex] as TStraton).StratonIndex;
end;

procedure TfrmSubComponentEdit.cmbxStratonChange(Sender: TObject);
begin
  EnableOK;
end;

procedure TfrmSubComponentEdit.edtDepthChange(Sender: TObject);
begin
  EnableOK;
  if (cmbxComment.ItemIndex <> 1) then  cmbxComment.ItemIndex := 0;
end;

procedure TfrmSubComponentEdit.chlbxPlusClickCheck(Sender: TObject);
begin
  EnableOK;
end;

constructor TfrmSubComponentEdit.Create(AOwner: TComponent);
var strlst: TStringList;
begin
  inherited;
  if Assigned(AllDicts) then
  begin
    strlst := TStringList.Create;
    AllDicts.MakeList(strlst, AllDicts.CommentDict);
    strlst.InsertObject(0, '<нет>', TObject(0));    
    cmbxComment.Items.AddStrings(strlst);
    strlst.Free;
  end;
end;

procedure TfrmSubComponentEdit.cmbxCommentChange(Sender: TObject);
var i: integer;
    unDiv: TSubDivisionComponent; 
begin
  EnableOk;
  // если не расчленено, то не можем редактировать глубину
  edtDepth.Enabled := (cmbxComment.ItemIndex <> 1);

  if cmbxComment.ItemIndex = 1 then
  begin
    unDiv := nil;
    for i := EditingComponent.Index - 1 downto 0 do
    if (EditingComponent.Collection as TSubDivisionComponents).Items[i].Depth > 0 then
    begin
      unDiv := (FEditingComponent.Collection as TSubDivisionComponents).Items[i];
      break;
    end;

    try
      edtDepth.Text := trim(Format('%6.2f',[unDiv.Depth]));
    except
      try
        edtDepth.Text := trim(Format('%6.2f',[NearestComponent.Depth]));
      except
        // автоматически проставляется забой
        edtDepth.Text := trim(Format('%6.2f',[((FEditingComponent.Collection as TSubDivisionComponents).SubDivision.Collection as TSubDivisions).Well.Depth]));
      end;
    end;
  end;
end;

procedure TfrmSubComponentEdit.edtDepthKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  cmbxComment.ItemIndex := 0;
end;

procedure TfrmSubComponentEdit.pgctlChange(Sender: TObject);
begin
//  chbxTemplateEdit.Checked := pgctl.ActivePageIndex = 0;
end;

end.
