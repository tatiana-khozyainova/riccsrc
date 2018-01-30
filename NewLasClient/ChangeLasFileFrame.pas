unit ChangeLasFileFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, BaseObjects, Facade, LasFile, Well, ActnList, formReplacement;

type
  TfrmChangeLasFile = class(TFrame)
    gbx1: TGroupBox;
    pgcMain: TPageControl;
    tsJoin: TTabSheet;
    tsChange: TTabSheet;
    lstBoxArea: TListBox;
    lstBoxWell: TListBox;
    btnJoinToWell: TButton;
    actlstChangeLasFile: TActionList;
    actJoinToWell: TAction;
    gbxVersion: TGroupBox;
    gbxWell: TGroupBox;
    gbxCurve: TGroupBox;
    gbxAscii: TGroupBox;
    lstVersion: TListBox;
    lstWell: TListBox;
    lstCurve: TListBox;
    lstAscii: TListBox;
    actChangeLasFile: TAction;
    actLstClick: TAction;
    actLstRowDblClick: TAction;
    procedure lstBoxAreaClick(Sender: TObject);
    procedure actJoinToWellUpdate(Sender: TObject);
    procedure actJoinToWellExecute(Sender: TObject);
    procedure actLstRowDblClickExecute(Sender: TObject);
    procedure lstCurveDblClick(Sender: TObject);
  private
    { Private declarations }
    FOnSelectedWellChanged: TNotifyEvent;
    FLasFiles: TLasFiles;
    FLasFileContents: TLasFileContents;
    FSelectedLasFile: TLasFile;
    function GetSelectedWell: TWell;
    procedure SetLasFiles(const Value: TLasFiles);
    procedure SetSelectedLasFile(const Value: TLasFile);
    procedure CreateContents;
    function  GetCurrentContent: TLasFileContent;
  public
    { Public declarations }
    property OnWellSelected: TNotifyEvent read FOnSelectedWellChanged write FOnSelectedWellChanged;
    property SelectedWell: TWell read GetSelectedWell;
    property LasFiles: TLasFiles read FLasFiles write SetLasFiles;

    property SelectedLasFile: TLasFile read FSelectedLasFile write SetSelectedLasFile;
    property CurrentContent: TLasFileContent read GetCurrentContent;

    procedure ViewLasFileInLstBox(ALasFile : TLasFile); overload;
  //  procedure ViewLasFileInLstBox(ALasFileContent : TLasFileContent); overload;

    {procedure MakeReplac(AReplacements: TReplacementList;  ALasFile:TLasFile); }
    function RowReplac (inputString :string; repString:string) : string;
  //  procedure ReplaceWellBlock (AWell: TWell);
//    function GetLasFileContent(ALasFile :TLasFile) : TLasFileContent;
    //function FindStringInContent (ALasFileContent :TLasFileContent; inputString : string) : string;
  end;

implementation

{$R *.dfm}

function TfrmChangeLasFile.GetSelectedWell: TWell;
begin
  if lstBoxWell.ItemIndex > -1 then
    Result := (lstBoxWell.Items.Objects [lstBoxWell.ItemIndex]) as TWell
  else
    Result := nil;
end;



procedure TfrmChangeLasFile.lstBoxAreaClick(Sender: TObject);
var
 TmpArea : TIDObject;
begin
  TmpArea := (lstBoxArea.Items.Objects [lstBoxArea.ItemIndex]) as TIDObject;
  TMainFacade.GetInstance.LasFilter:= 'AREA_ID = ' + IntToStr(TmpArea.ID);
  TMainFacade.GetInstance.SkipLasWells;
  TMainFacade.GetInstance.AllLasWells.MakeList(lstBoxWell.Items);
end;





procedure TfrmChangeLasFile.actJoinToWellUpdate(Sender: TObject);
begin
  actJoinToWell.Enabled := Assigned(SelectedWell);
end;

procedure TfrmChangeLasFile.actJoinToWellExecute(Sender: TObject);
begin
  // вот тут должна быть привязка, т.е вызов замены полей ласфайла которые содержать название площади, номер скв. и UWI
  if Assigned(SelectedLasFile) then
  if Assigned(FOnSelectedWellChanged) then
  begin
    if Assigned(FOnSelectedWellChanged) then FOnSelectedWellChanged(SelectedWell);
    //ReplaceWellBlock(SelectedWell);
  end;
end;



procedure TfrmChangeLasFile.SetLasFiles(const Value: TLasFiles);
begin
  if FLasFiles <> Value then
  begin
    FLasFiles := Value;
    FSelectedLasFile := nil;
    CreateContents;
  end;
end;

procedure TfrmChangeLasFile.SetSelectedLasFile(const Value: TLasFile);
begin
  FSelectedLasFile := Value;
  if Assigned(FSelectedLasFile) then  ViewLasFileInLstBox(FSelectedLasFile);
end;

procedure TfrmChangeLasFile.ViewLasFileInLstBox(ALasFile: TLasFile);
begin
 // ViewLasFileInLstBox(GetLasFileContent(ALasFile));
end;
 {
procedure TfrmChangeLasFile.MakeReplac(AReplacements: TReplacementList; ALasFile:TLasFile);
var
ALasFileContent :TLasFileContent;
begin
  ALasFileContent := TLasFileContent.Create(ALasFile);
  ALasFileContent.ReadFile;
  ALasFileContent.MakeReplacements(AReplacements);
  ALasFileContent.SaveFile();
  ViewLasFileInLstBox(ALasFile);
end;                                   }


function TfrmChangeLasFile.RowReplac(inputString,
  repString: string): string;
var
  lab1, lab2, i : Integer;
  part1, part2 : string;
begin
 lab1 := Pos(' ', inputString);
 lab2 := Pos(':', inputString);
 part1 := Copy(inputString, 1, lab1);
 part2 := Copy (inputString, lab2, Length(inputString)- lab2);
 Result:=part1;
 for i:=0 to lab2-lab1-Length(repString)-2 do
 Result:=Result+' ';
 Result:=Result+repString+part2;

end;
 {
procedure TfrmChangeLasFile.ReplaceWellBlock(AWell: TWell);
var
  i: Integer;
  AReplacements :TReplacementList;
  str1, str2 : string;
begin
 for i:=0 to AWell.LasFiles.Count-1 do
  if (AWell.LasFiles.Items[i].IsChanged) then
    begin
    AReplacements:= TReplacementList.Create();

    str1:= FindStringInContent(CurrentContent, 'WELL');
    str2:=RowReplac(str1, AWell.NumberWell);
    AReplacements.AddReplacement('~Well', 'WELL', str1, str2);

    str1:= FindStringInContent(CurrentContent, 'FLD');
    str2:=RowReplac(str1, AWell.Area.Name);
    AReplacements.AddReplacement('~Well', 'FLD', str1, str2);

    str1:= FindStringInContent(CurrentContent, 'UWI');
    str2:=RowReplac(str1, IntToStr(AWell.ID));
    AReplacements.AddReplacement('~Well', 'UWI', str1, str2);

    MakeReplac(AReplacements, AWell.LasFiles.Items[i]);
    end;

end;           }


  {
function TfrmChangeLasFile.GetLasFileContent(ALasFile: TLasFile): TLasFileContent;
  var ALasFileContent:TLasFileContent;
  s:string;
begin
  ALasFileContent := TLasFileContent.Create(ALasFile);
  ALasFileContent.ReadFile;
  s:=ALasFileContent.Blocks.ItemByName['~Well'].RealContent.Strings[5];
  Result:= ALasFileContent;
  Assert(Result <> nil, 'LasfileContent не создан');
end;        }
       {
function TfrmChangeLasFile.FindStringInContent(ALasFileContent: TLasFileContent;
  inputString: string): string;
var
  i,j : Integer;
begin
  Result:='';
  for i:=0 to ALasFileContent.Blocks.Count-1 do
    for j:=0 to ALasFileContent.Blocks.Items[i].RealContent.Count-1 do
      if (Pos(inputString, ALasFileContent.Blocks.Items[i].RealContent.Strings[j])>0) then
        Result:= ALasFileContent.Blocks.Items[i].RealContent.Strings[j];
end;            }

procedure TfrmChangeLasFile.actLstRowDblClickExecute(Sender: TObject);
var
  ListBox : TListBox;
  begin
  ListBox := Sender as TListBox;
  FreeAndNil(formReplac);
  formReplac := TformReplac.Create(Self);
  formReplac.FormType := rftSimple;
  //formReplac.InputString := FindStringInContent(CurrentContent, ListBox.Items[ListBox.ItemIndex]);
  if formReplac.ShowModal = mrOk then
    ///
end;
    {
procedure TfrmChangeLasFile.ViewLasFileInLstBox(
  ALasFileContent: TLasFileContent);
begin
  lstVersion.Items.BeginUpdate;
  lstVersion.Clear;
  lstVersion.Items.AddStrings(ALasFileContent.Blocks.ItemByName['~Version'].RealContent);
  lstVersion.Items.EndUpdate;  

  lstWell.Items.BeginUpdate;
  lstWell.Clear;
  lstWell.Items.AddStrings(ALasFileContent.Blocks.ItemByName['~Well'].RealContent);
  lstWell.Items.EndUpdate;

  lstCurve.Items.BeginUpdate;
  lstCurve.Clear;
  lstCurve.Items.AddStrings(ALasFileContent.Blocks.ItemByName['~Curve'].RealContent);
  lstCurve.Items.AddStrings(ALasFileContent.Blocks.ItemByName['~Parameter'].RealContent);
  lstCurve.Items.AddStrings(ALasFileContent.Blocks.ItemByName['~Parametr'].RealContent);
  lstCurve.Items.AddStrings(ALasFileContent.Blocks.ItemByName['~Other'].RealContent);
  lstCurve.Items.EndUpdate;

  lstAscii.Items.BeginUpdate;
  lstAscii.Clear;
  lstAscii.Items.AddStrings(ALasFileContent.Blocks.ItemByName['~A'].RealContent);
  lstAscii.Items.EndUpdate;
end;             }

procedure TfrmChangeLasFile.CreateContents;
var i: integer;
    lc: TLasFileContent;
begin
  { TODO : Спрашивать о сохранении изменений в файле }
  // или спрашивать или по тихому сохранять все контенты

  FreeAndNil(FLasFileContents);
  FLasFileContents := TLasFileContents.Create;

  for i := 0 to LasFiles.Count - 1 do
  begin
    lc := TLasFileContent.Create(LasFiles.Items[i]);
    FLasFileContents.Add(lc);
  end;
end;

function TfrmChangeLasFile.GetCurrentContent: TLasFileContent;
begin
  if Assigned(SelectedLasFile) then
  begin
    if not Assigned(FLasFileContents) then
      FLasFileContents:=TLasFileContents.Create;
    Result := FLasFileContents.GetContentByFile(SelectedLasFile)
  end

  else
    Result := nil;
end;

procedure TfrmChangeLasFile.lstCurveDblClick(Sender: TObject);
var
  ListBox : TListBox;
  tempStr :String;
  i, j : integer;
begin
  j:=0;
  ListBox := Sender as TListBox;

  tempStr:= Copy (ListBox.Items[ListBox.ItemIndex], pos('.',ListBox.Items[ListBox.ItemIndex]), Pos(':',ListBox.Items[ListBox.ItemIndex])-Pos('.',ListBox.Items[ListBox.ItemIndex]));
  for i:=1 to Length(tempStr) do
    if tempStr[i]=' ' then Inc(j);

  tempStr:= Copy(tempStr, j+2, Length(tempStr)-j);

  FreeAndNil(formReplac);
  formReplac := TformReplac.Create(Self);

  formReplac.FormType := rftCurves;
  formReplac.InputString := tempStr;
  if formReplac.ShowModal = mrOk then
end;

end.
