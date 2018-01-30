unit RRManagerLicenseConditionTreeFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Facade, 
  Dialogs, StdCtrls, ComCtrls, LicenseZone;

type
  TfrmLicenseConditionTree = class(TFrame)
    gbxSearch: TGroupBox;
    edtSearch: TEdit;
    trwConditions: TTreeView;
    btnNext: TButton;
    procedure btnNextClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
  private
    { Private declarations }
    FInitSearch: boolean;
    function FindItem(ACaption: string; FindFirst: boolean): TTreeNode;
    function GetActiveLicenseCondition: TLicenseCondition;
    function GetActiveLicenseKind: TLicenseConditionKind;
  public
    { Public declarations }
    property  ActiveLicenseKind: TLicenseConditionKind read GetActiveLicenseKind;
    property  ActiveLicenseCondition: TLicenseCondition read GetActiveLicenseCondition;
    procedure MakeTree;
  end;

implementation

{$R *.dfm}

{ TfrmLicenseConditionTree }

function TfrmLicenseConditionTree.GetActiveLicenseCondition: TLicenseCondition;
begin
  Result := nil;
  if Assigned(trwConditions.Selected) and (trwConditions.Selected.Level = 1) then
    Result := TLicenseCondition(trwConditions.Selected.Data);
end;

function TfrmLicenseConditionTree.GetActiveLicenseKind: TLicenseConditionKind;
begin
  Result := nil;
  if Assigned(trwConditions.Selected) then
  begin
    if trwConditions.Selected.Level = 0 then
      Result := TLicenseConditionKind(trwConditions.Selected.Data)
    else
      Result := TLicenseConditionKind(trwConditions.Selected.Parent.Data);
  end;
end;

procedure TfrmLicenseConditionTree.MakeTree;
var i, j: integer;
    Node: TTreeNode;
begin
  Node := nil;
  for i := 0 to (TMainFacade.GetInstance as TMainFacade).AllLicenseConditionKinds.Count - 1 do
  begin
    Node := trwConditions.Items.AddObject(Node, (TMainFacade.GetInstance as TMainFacade).AllLicenseConditionKinds.Items[i].List, (TMainFacade.GetInstance as TMainFacade).AllLicenseConditionKinds.Items[i]);
    for j := 0 to (TMainFacade.GetInstance as TMainFacade).AllLicenseConditions.Count - 1 do
    if (TMainFacade.GetInstance as TMainFacade).AllLicenseConditions.Items[j].LicenseConditionKind = (TMainFacade.GetInstance as TMainFacade).AllLicenseConditionKinds.Items[i] then
      trwConditions.Items.AddChildObject(Node, (TMainFacade.GetInstance as TMainFacade).AllLicenseConditions.Items[j].List, (TMainFacade.GetInstance as TMainFacade).AllLicenseConditions.Items[j]);
    Node.Expand(true);  
  end;
end;

procedure TfrmLicenseConditionTree.btnNextClick(Sender: TObject);
begin
  FindItem(edtSearch.Text, not FInitSearch);
  FInitSearch := true;
  btnNext.Caption := 'Далее';
end;

function TfrmLicenseConditionTree.FindItem(ACaption: string; FindFirst: boolean): TTreeNode;
var Node: TTreeNode;
begin
  if FindFirst then
    Node := trwConditions.Items.GetFirstNode
  else if Assigned(trwConditions.Selected) then
    Node := trwConditions.Selected.GetNext;

  while Assigned(Node) do
  begin
    if pos(AnsiUpperCase(ACaption), AnsiUpperCase(Node.Text)) > 0 then
    begin
      Node.Selected := true;
      Result := Node;
      break;
    end;
    Node := Node.GetNext;
  end;
end;

procedure TfrmLicenseConditionTree.edtSearchChange(Sender: TObject);
begin
  FInitSearch := false;
  btnNext.Caption := 'Найти';
end;

end.
