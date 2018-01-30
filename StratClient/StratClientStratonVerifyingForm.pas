unit StratClientStratonVerifyingForm;

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
    pnlCommon: TPanel;
    pnlAll: TPanel;
    pnlStratons: TPanel;
    Label1: TLabel;
    edtStratons: TEdit;
    rgrpSplit: TRadioGroup;
    chlbxAllStratons: TCheckListBox;
    sbtnReload: TSpeedButton;
    procedure chlbxAllStratonsClickCheck(Sender: TObject);
    procedure rgrpSplitClick(Sender: TObject);
    procedure chlbxAllStratonsKeyPress(Sender: TObject; var Key: Char);
    procedure rgrpSearchClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sbtnReloadClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FFoundStratons, FCheckedStratons: TSimpleStratons;
    FSplitter: char;
    procedure SetSplitter(Value:char);
    procedure SetNames;
    function  GetCheckedStratons: TSimpleStratons;

  public
    { Public declarations }
    property  Splitter: char read FSplitter write SetSplitter;
    property  FoundStratons: TSimpleStratons read FFoundStratons;
    property  CheckedStratons: TSimpleStratons read GetCheckedStratons;
    procedure ReloadStratons;
    procedure LoadFoundStratons;    
  end;

var
  frmVerifyStratons: TfrmVerifyStratons;

implementation

uses ClientCommon, Facade, BaseObjects;

{$R *.DFM}


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
     edtStratons.Text := edtStratons.Text + FSplitter + (Items.Objects[i] as TSimpleStraton).Name;
  edtStratons.Text := copy(edtStratons.Text, 2, Length(edtStratons.Text));
end;

procedure TfrmVerifyStratons.LoadFoundStratons;
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
     iIndex := chlbxAllStratons.Items.IndexOfObject(FFoundStratons.Items[i]);
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


procedure TfrmVerifyStratons.chlbxAllStratonsClickCheck(Sender: TObject);
//var Obj: TSimpleStraton;
var i: integer;
begin
  with chlbxAllStratons do
  if not Checked[ItemIndex] then
  for i := 0 to Items.Count - 1 do
    if Checked[i] then ItemIndex := i;
  SetNames;
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
           and (pos(sFilter, AnsiUpperCase(TSimpleStraton(Items.Objects[i]).Name)) = 1))
      or ((rgrpSearch.ItemIndex = 1)
           and (pos(sFilter, AnsiUpperCase(TSimpleStraton(Items.Objects[i]).Definition)) = 1)) then
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
begin
  FFoundStratons := TSimpleStratons.Create;
  FFoundStratons.OwnsObjects := false;
  
  ReloadStratons;
end;

procedure TfrmVerifyStratons.sbtnReloadClick(Sender: TObject);
begin
  ReloadStratons;
  sbtnReload.Down := not sbtnReload.Down;
end;

procedure TfrmVerifyStratons.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FFoundStratons);
  FreeAndNil(FCheckedStratons);
end;

procedure TfrmVerifyStratons.ReloadStratons;
var i: integer;
begin
  chlbxAllStratons.Items.BeginUpdate;

  with TMainFacade.GetInstance.AllSimpleStratons do
  for i := 0 to Count - 1 do
    chlbxAllStratons.Items.AddObject(Items[i].List(loFull), Items[i]);

  LoadFoundStratons;
  chlbxAllStratons.Items.EndUpdate;
end;


function TfrmVerifyStratons.GetCheckedStratons: TSimpleStratons;
var i: integer;
begin
  if not Assigned(FCheckedStratons) then
  begin
    FCheckedStratons := TSimpleStratons.Create;
    FCheckedStratons.OwnsObjects := false;
  end;

  FCheckedStratons.Clear;
  for i := 0 to chlbxAllStratons.Count - 1 do
  if chlbxAllStratons.Checked[i] then
    FCheckedStratons.Add(chlbxAllStratons.Items.Objects[i], false, false);

  Result := FCheckedStratons;
end;

end.



