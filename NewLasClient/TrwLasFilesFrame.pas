unit TrwLasFilesFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Facade, LasFile, Well, BaseObjects, StdCtrls;

type
  TfrmTrwLasFiles = class(TFrame)
    trwLasFiles: TTreeView;
    gbx1: TGroupBox;
    procedure trwLasFilesChange(Sender: TObject; Node: TTreeNode);
  private
    FSelectedLasFiles: TLasFiles;
    FSelectedWell: TWell;
    FOnLasFileChanged: TNotifyEvent;
    FOnSelectedLasFileChanged: TNotifyEvent;
    function GetSelectedLasFiles: TLasFiles;
    function GetSelectedLasFile : TLasFile;
    procedure AssignSelectedFilesOwner;
    procedure SkipSelectedLasFiles;
    function  FindNodeByWell (Well:TIDObject) : TTreeNode;
    procedure SetSelectedWell(const Value: TWell);
    { Private declarations }
  public
    { Public declarations }
    property SelectedWell: TWell read FSelectedWell write SetSelectedWell;
    property SelectedLasFiles: TLasFiles read GetSelectedLasFiles;
    property SelectedLasFile : TLasFile read GetSelectedLasFile;
    procedure AddLasFiles;
    procedure DelSelectedLasFiles;

    property  OnLasFileChanged: TNotifyEvent read FOnLasFileChanged write FOnLasFileChanged;
    property  OnSelectedLasFileChanged: TNotifyEvent read FOnSelectedLasFileChanged write FOnSelectedLasFileChanged;
  end;

implementation

uses ChangeLasFileFrame;







{$R *.dfm}

function TfrmTrwLasFiles.GetSelectedLasFiles: TLasFiles;
var i: integer;
begin
  if not Assigned(FSelectedLasFiles) then
  begin
    FSelectedLasFiles := TLasFiles.Create;
    FSelectedLasFiles.OwnsObjects := false;
    for i := 0 to trwLasFiles.SelectionCount - 1  do
    FSelectedLasFiles.Add(TIDObject(trwLasFiles.Selections[i].Data), False, True);
  end;
  Result := FSelectedLasFiles;
end;


procedure TfrmTrwLasFiles.SkipSelectedLasFiles;
var
  i:Integer;
begin
   FreeAndNil(FSelectedLasFiles);
   for i:=trwLasFiles.SelectionCount-1 downto 0 do
   begin
   trwLasFiles.Selections[i].Delete;
   end;
end;

procedure TfrmTrwLasFiles.AssignSelectedFilesOwner;
var Node:TTreeNode;
    i:Integer;
    lf: TLasFile;
begin
  Node := FindNodeByWell(SelectedWell);
  if not Assigned(Node) then
  Node:=trwLasFiles.Items.AddObjectFirst(nil, SelectedWell.List(loBrief), SelectedWell);
  for i := 0 to SelectedLasFiles.Count - 1 do
  begin
    lf := SelectedWell.LasFiles.Add as TLasFile;
    lf.Assign(SelectedLasFiles.Items[i]);
    lf.IsChanged := True;
    trwLasFiles.Items.AddChildObject(Node, ExtractFileName(lf.OldFileName), lf);
  end;

 { FreeAndNil(FSelectedLasFiles);
  for i:=trwLasFiles.SelectionCount-1 downto 0 do
  begin
   trwLasFiles.Selections[i].Delete;
  end;

  Node := FindNodeByWell(SelectedWell);
  if Assigned(Node) then
    trwLasFiles.Select(Node.getFirstChild);     }

end;

function TfrmTrwLasFiles.FindNodeByWell(Well: TIDObject): TTreeNode;
var
  i:Integer;
  FindNode: TTreeNode;
begin
  FindNode:=nil;
  for i:=0 to trwLasFiles.Items.Count-1 do
    begin
    if trwLasFiles.Items[i].Level=0 then
      begin
        if (Well = (TObject (trwLasFiles.Items[i].Data)) as TIDObject) then
        FindNode := trwLasFiles.Items[i];
      end;
    end;
  Result:=FindNode;
end;

procedure TfrmTrwLasFiles.AddLasFiles;
begin
  if trwLasFiles.SelectionCount < 1 then ShowMessage('Выберите LAS-файлы!')
  else
  if not Assigned(SelectedWell) then ShowMessage('Укажите скважину!')
  else
  begin
    AssignSelectedFilesOwner;
    //SkipSelectedLasFiles;
    
    if Assigned(FOnLasFileChanged) then FOnLasFileChanged(SelectedLasFiles);
  end;
end;

procedure TfrmTrwLasFiles.SetSelectedWell(const Value: TWell);
begin
  FSelectedWell := Value;
  AddLasFiles;
end;

function TfrmTrwLasFiles.GetSelectedLasFile: TLasFile;
begin
  if (Assigned(trwLasFiles.Selected) and (TObject (trwLasFiles.Selected.Data) is TLasFile)) then
    Result:= TObject (trwLasFiles.Selected.Data) as TLasFile
  else
    Result:=nil;
end;

procedure TfrmTrwLasFiles.DelSelectedLasFiles;
begin
  SkipSelectedLasFiles;
  if Assigned(FOnLasFileChanged) then FOnLasFileChanged(SelectedLasFiles);
end;

procedure TfrmTrwLasFiles.trwLasFilesChange(Sender: TObject;
  Node: TTreeNode);
begin
  if Assigned(FOnSelectedLasFileChanged) then FOnSelectedLasFileChanged(SelectedLasFile);   
end;

end.
