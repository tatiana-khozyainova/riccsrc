unit SubDividerStratonVerifyingForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls, Buttons, Variants, Straton;

type
  TfrmVerifyStratons = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    rgrpSearch: TRadioGroup;
    gbxSearch: TGroupBox;
    edtSearch: TEdit;
    sbtnSynonyms: TSpeedButton;
    gbxSynonyms: TGroupBox;
    pnlCommon: TPanel;
    lbxSynonyms: TListBox;
    pnlAll: TPanel;
    pnlStratons: TPanel;
    Label1: TLabel;
    edtStratons: TEdit;
    rgrpSplit: TRadioGroup;
    chlbxAllStratons: TCheckListBox;
    gbxService: TGroupBox;
    chlbxRegions: TCheckListBox;
    pnlPetrol: TPanel;
    Label2: TLabel;
    spdbtnDeselectAll: TSpeedButton;
    sbtnSelectAll: TSpeedButton;
    cmbxPetrolRegion: TComboBox;
    sbtnReload: TSpeedButton;
    procedure chlbxAllStratonsClickCheck(Sender: TObject);
    procedure rgrpSplitClick(Sender: TObject);
    procedure chlbxAllStratonsKeyPress(Sender: TObject; var Key: Char);
    procedure rgrpSearchClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure chlbxRegionsClickCheck(Sender: TObject);
    procedure sbtnReloadClick(Sender: TObject);
    procedure sbtnSynonymsClick(Sender: TObject);
    procedure lbxSynonymsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure spdbtnDeselectAllClick(Sender: TObject);
    procedure cmbxPetrolRegionChange(Sender: TObject);
    procedure cmbxPetrolRegionKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FFoundStratons: TSimpleStratons;
    FSplitter: char;
    FRegions:  TStratotypeRegions;
    procedure SetRegions(Value: TStratotypeRegions);
    procedure SetFoundStratons(Value: TSimpleStratons);
    procedure SetSplitter(Value:char);
    procedure SetNames;
    procedure LoadStratons;
  public
    { Public declarations }
    property  FilterRegions: TStratotypeRegions read FRegions write SetRegions;
    property  Splitter: char read FSplitter write SetSplitter;
    property  FoundStratons: TSimpleStratons read FFoundStratons write SetFoundStratons;
  end;

var
  frmVerifyStratons: TfrmVerifyStratons;

implementation

uses ClientCommon;

{$R *.DFM}

procedure TfrmVerifyStratons.SetRegions(Value: TStratotypeRegions);
var ValidRegions: set of byte;
    iRegionId, i: integer;
begin
  ValidRegions := [0 .. 3];
  if Assigned(Value) then
  begin
    FRegions := Value;
    for i := 0 to chlbxRegions.Items.Count - 1 do
    begin
      iRegionID := (chlbxRegions.Items.Objects[i] as TStratotypeRegion).ID;
      chlbxRegions.Checked[i] := Assigned(FRegions.RegionOfID(iRegionID));
      if chlbxRegions.Checked[i] then Validregions := ValidRegions + [iRegionID];
    end;
  end
  else
  for i := 0 to chlbxRegions.Items.Count - 1 do
    chlbxRegions.Checked[i] := false;

  // теперь эта штука служит для отбора синонимов
  lbxSynonyms.Items.BeginUpdate;
  lbxSynonyms.Clear;
  with AllSynonyms do
  for i := 0 to Count - 1 do
  if Items[i].RegionID in ValidRegions then
     lbxSynonyms.Items.AddObject(Items[i].ListStraton(sloIndexNameReplacement), Items[i]);
  lbxSynonyms.Items.EndUpdate;
end;

procedure TfrmVerifyStratons.SetNames;
var i: integer;
begin
  if (Splitter = '') or (Splitter = ',') then
  case rgrpSplit.ItemIndex of
  0: Splitter := '+';
  1: Splitter := '-';
  end;

  edtStratons.Clear;
  with chlbxAllStratons do
  for i := Items.Count - 1 downto 0 do
  if Checked[i] then
     edtStratons.Text := edtStratons.Text + FSplitter + (Items.Objects[i] as TSimpleStraton).StratonIndex;
  edtStratons.Text := copy(edtStratons.Text, 2, Length(edtStratons.Text));
end;

procedure TfrmVerifyStratons.LoadStratons;
var i, iIndex: integer;
begin
  edtStratons.Clear;

  for i := 0 to chlbxAllStratons.Items.Count - 1 do
    chlbxAllStratons.Checked[i] := false;

  if FSplitter = '' then FSplitter := ',';
  if Assigned(FFoundStratons) then
  begin
    for i := 0 to FFoundStratons.Count - 1 do
    begin

     //iIndex := chlbxAllStratons.Items.IndexOf(FFoundStratons[i].ListStraton(sloIndexNameAges));
     iIndex := chlbxAllStratons.Items.IndexOf(FFoundStratons[i].ListStraton(sloIndexName));

     if iIndex > -1 then
     begin
       chlbxAllStratons.Checked[iIndex] := true;
       chlbxAllStratons.ItemIndex := iIndex;
      end;
    end;
  end;
  SetNames;
end;

procedure TfrmVerifyStratons.SetSplitter(Value: char);
begin
  if FSplitter <> Value then
  begin
    edtStratons.Text := StringReplace(edtStratons.Text,FSplitter,Value, [rfReplaceAll]);
    FSplitter := Value;

    if FSplitter = '+' then
      rgrpSplit.ItemIndex := 0
    else
    if FSplitter = '-' then
      rgrpSplit.ItemIndex := 1
  end;
end;

procedure TfrmVerifyStratons.SetFoundStratons(Value: TSimpleStratons);
begin
  if FFoundStratons <> Value then
  begin
    FFoundStratons := Value;
    if Assigned(FFoundStratons) then
      LoadStratons;
  end;
end;

procedure TfrmVerifyStratons.chlbxAllStratonsClickCheck(Sender: TObject);
//var Obj: TSimpleStraton;
var i: integer;
begin
  with chlbxAllStratons do
  if not Checked[ItemIndex] then 
  for i := 0 to Items.Count - 1 do
    if Checked[i] then ItemIndex := i;
  SetNames;
  //then FoundStratons.AddStratonRef(TSimpleStraton(Items.Objects[ItemIndex]))
  //else
  //begin
    {Obj := FoundStratons.StratonOfID(TSimpleStraton(Items.Objects[ItemIndex]).StratonID);
    if Assigned(Obj) then
      FoundStratons.Delete(Obj.Index);}
  //end;
  //LoadStratons;
end;

procedure TfrmVerifyStratons.rgrpSplitClick(Sender: TObject);
begin
  Splitter := ',';
  case rgrpSplit.ItemIndex of
  0: Splitter := '+';
  1: Splitter := '-';
  end;
  SetNames;
end;

procedure TfrmVerifyStratons.chlbxAllStratonsKeyPress(Sender: TObject;
  var Key: Char);
var i: integer;
    sKey: string;
    sFilter: string;
begin
  sKey := AnsiUpperCase(Key);
  if sKey <> ' ' then
  begin
    with chlbxAllStratons do
    if sKey[1] in ['A'.. 'Z',  'А' .. 'Я', '1' ..'9', '0', '*', '-'] then
    begin
      sFilter := AnsiUpperCase(edtSearch.Text) + sKey;
      for i := 0 to Items.Count - 1 do
      if ((rgrpSearch.ItemIndex = 0)
           and (pos(sFilter, AnsiUpperCase(TSimpleStraton(Items.Objects[i]).StratonIndex)) = 1))
      or ((rgrpSearch.ItemIndex = 1)
           and (pos(sFilter, AnsiUpperCase(TSimpleStraton(Items.Objects[i]).StratonDef)) = 1))
      or ((rgrpSearch.ItemIndex = 2)         
           and (pos(sFilter, AnsiUpperCase(TSimpleStraton(Items.Objects[i]).Synonym)) = 1)) then
      begin
        chlbxAllStratons.ItemIndex := i;
        break;
      end;
      //rgrpSearch.Caption := 'Искать по (текущая строка поиска ' + sFilter + ')';
    end
    else
    begin
      if Items.Count > 0 then
        ItemIndex := 0
      else ItemIndex := -1;
      //edtSearch.Text := '';
      //rgrpSearch.Caption := 'Искать по ';
    end;
  end;
end;

procedure TfrmVerifyStratons.rgrpSearchClick(Sender: TObject);
begin
  rgrpSearch.Caption := 'Искать по ';
end;

procedure TfrmVerifyStratons.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  edtSearch.Clear;
  //FoundStratons := nil;
  {for i := 0 to chlbxAllStratons.Items.Count - 1 do
      chlbxAllStratons.Checked[i] := false;}
end;

procedure TfrmVerifyStratons.FormCreate(Sender: TObject);
var i: integer;
begin
  //FFilteredStratons := TSimpleStratons.Create(false);
  with AllRegions do
  for i := 0 to Count - 1 do
  if not (Items[i].RegionID in [0 .. 4]) then
    chlbxRegions.Items.AddObject(Items[i].ListRegion, Items[i]);

  // загружаем отсортированные по возрасту стратоны
  chlbxAllStratons.Items.BeginUpdate;
  chlbxAllStratons.Clear;
  with AllStratons do
  for i := 0 to Count - 1 do
  {if  (Items[i].RegionID in ValidRegions)
  and (Items[i].Replacement.Count = 0) then}
//      chlbxAllStratons.Items.AddObject(Items[i].ListStraton(sloIndexNameAges),
//                                       Items[i]);
      chlbxAllStratons.Items.AddObject(Items[i].ListStraton(sloIndexName),
                                       Items[i]);

  LoadStratons;
  chlbxAllStratons.Items.EndUpdate;


  with AllSynonyms do
  for i := 0 to Count - 1 do
  // вначале грузятся все кроме местных
  if (Items[i].RegionID < 4) then
    lbxSynonyms.Items.AddObject(Items[i].ListStraton(sloIndexNameReplacement), Items[i]);

  with cmbxPetrolRegion do
  begin
    for i := 0 to VarArrayHighBound(AllDicts.PetrolRegions, 2) do
      Items.Add(AllDicts.PetrolRegions[1, i]);
    Sorted := true;  
  end;
end;

procedure TfrmVerifyStratons.chlbxRegionsClickCheck(Sender: TObject);
var i: integer;
begin
  if not Assigned(FRegions) then FRegions := TRegions.Create(false);
  FRegions.Clear;
  for i := 0 to chlbxRegions.Items.Count - 1 do
  if chlbxRegions.Checked[i] then
    FRegions.AddRegionRef(TRegion(chlbxRegions.Items.Objects[i]));
  FilterRegions := FRegions; 
end;

procedure TfrmVerifyStratons.sbtnReloadClick(Sender: TObject);
var i: integer;
begin
  //gbxService.Visible := sbtnFilter.Down;
  AllDicts.ReloadStratons;
  AllStratons.Clear;
  AllStratons := TSimpleStratons.Create(true);

  chlbxAllStratons.Items.BeginUpdate;
  chlbxAllStratons.Clear;
  with AllStratons do
  for i := 0 to Count - 1 do
    chlbxAllStratons.Items.AddObject(Items[i].ListStraton(sloIndexName),
                                     Items[i]);
{     chlbxAllStratons.Items.AddObject(Items[i].ListStraton(sloIndexNameAges),
                                      Items[i]);}
  LoadStratons;
  chlbxAllStratons.Items.EndUpdate;
  sbtnReload.Down := not sbtnReload.Down;  
end;

procedure TfrmVerifyStratons.sbtnSynonymsClick(Sender: TObject);
begin
  //sbtnSynonyms.Down := not sbtnSynonyms.Down;
  gbxSynonyms.Visible := sbtnSynonyms.Down;
end;

procedure TfrmVerifyStratons.lbxSynonymsClick(Sender: TObject);
var S: TSimpleStraton;
    j: integer;
begin
  Splitter := '+';
  with lbxSynonyms do
   S := Items.Objects[ItemIndex] as TSimpleStraton;

  for j := 0 to chlbxAllStratons.Items.Count - 1 do
  if Assigned(S.Replacement.StratonOfID(
             (chlbxAllStratons.Items.Objects[j] as TSimpleStraton).StratonID))
  then
  begin
    chlbxAllStratons.Checked[j] := true;
    chlbxAllStratons.ItemIndex := j;
  end;
  SetNames;
end;

procedure TfrmVerifyStratons.FormDestroy(Sender: TObject);
begin
  //FFilteredStratons.Free;
  if Assigned(FRegions) then
  begin
    FRegions.Free;
    FRegions := nil;
  end;
end;

procedure TfrmVerifyStratons.spdbtnDeselectAllClick(Sender: TObject);
var i: integer;
    bChecked: boolean;
begin
  bChecked := pos('все', (Sender as TSpeedButton).Caption) > 0;
  for i := 0 to chlbxRegions.Items.Count - 1 do
    chlbxRegions.Checked[i] := bChecked;
  chlbxRegionsClickCheck(Sender);  
end;

procedure TfrmVerifyStratons.cmbxPetrolRegionChange(Sender: TObject);
var j, i, iResult, iRegionID: integer;
    vResult: variant;
begin
  with cmbxPetrolRegion do
  if ItemIndex > - 1 then
  begin
    iRegionID := GetObjectID(AllDicts.PetrolRegions, cmbxPetrolRegion.Text);
    iResult := IServer.ExecuteQuery('select distinct m.Region_ID from tbl_Well_Position p, ' +
                                    'tbl_stratotype_region_member m ' +
                                    'where p.petrol_region_id = ' + IntToStr(iRegionID) +
                                    ' and m.struct_id = p.struct_id');
    if iResult > 0 then
    begin
      vResult := IServer.QueryResult;
      with chlbxRegions do
      for i := 0 to varArrayHighBound(vResult, 2) do
      for j := 0 to Items.Count - 1 do
      if (Items.Objects[j] as TRegion).RegionID = vResult [0, i] then
         Checked[j] := true;
    end;
    chlbxRegionsClickCheck(Sender);
  end;
end;

procedure TfrmVerifyStratons.cmbxPetrolRegionKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var i, iSelStart: integer;
    S: string;
begin
  // ищем подходящий по названию стратон
  if (Key in [ord('A') .. ord('Z'), ord('a') .. ord('z'),
             ord('А') .. ord('Я'), ord('а') .. ord('я')])
      and (Key <> VK_DELETE) then
  with cmbxPetrolRegion do
  begin
    if SelLength > 0  then iSelStart := SelStart
    else iSelStart := Length(Text);

    S := AnsiUpperCase(copy(Text, 1, iSelStart));
    ItemIndex := -1;
    for i := 0 to Items.Count - 1 do
    if pos(S, AnsiUpperCase(Items[i])) = 1 then
    begin
      ItemIndex := i;
      Text := Items[i];
      SelStart := iSelStart;
      SelLength := Length(Text) - SelStart;
      cmbxPetrolRegionChange(Sender);
      break;
    end;
  end;
end;

procedure TfrmVerifyStratons.btnOKClick(Sender: TObject);
var iIndex,i: integer;
begin
  with chlbxAllStratons do
  begin
    for i := 0 to Items.Count - 1 do
    if Checked[i] then FoundStratons.AddStratonRef(TSimpleStraton(Items.Objects[i]));

    // удаляем все из найденных стратонов, чего нет в отфильтрованных
    for i := FFoundStratons.Count - 1 downto 0 do
    begin
      //iIndex := Items.IndexOf(FFoundStratons[i].ListStraton(sloIndexNameAges));
      iIndex := Items.IndexOf(FFoundStratons[i].ListStraton(sloIndexName));      
      if (iIndex = -1) or not Checked[iIndex] then
         FFoundStratons.Delete(i);
    end;
  end;
end;

end.



