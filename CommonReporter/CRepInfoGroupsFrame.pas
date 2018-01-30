unit CRepInfoGroupsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvExComCtrls, JvListView, StdCtrls, ResearchGroup;

type
  TfrmInfoGroup = class(TFrame)
    gbxInfoGroup: TGroupBox;
    lvInfoGroup: TJvListView;
  private
    { Private declarations }
    FSelectedInfoGroups: TInfoGroups;
    function GetSelectedInfoGroup: TInfoGroup;
    function GetSelectedInfoGroups: TInfoGroups;
  public
    { Public declarations }
    procedure RefreshInfoGroups;
    property  SelectedInfoGroup: TInfoGroup read GetSelectedInfoGroup;
    property  SelectedInfoGroups: TInfoGroups read GetSelectedInfoGroups; 
  end;

implementation

uses Facade;

{$R *.dfm}

{ TfrmInfoGroup }

function TfrmInfoGroup.GetSelectedInfoGroup: TInfoGroup;
begin
  Result := TInfoGroup(lvInfoGroup.Selected.Data);
end;

function TfrmInfoGroup.GetSelectedInfoGroups: TInfoGroups;
var i: integer;
begin
  if not Assigned(FSelectedInfoGroups) then
  begin
    FSelectedInfoGroups := TInfoGroups.Create;
    FSelectedInfoGroups.OwnsObjects := False;
  end
  else FSelectedInfoGroups.Clear;


  for i := 0 to lvInfoGroup.Items.Count - 1 do
  if lvInfoGroup.Items[i].Selected then
    FSelectedInfoGroups.Add(TInfoGroup(lvInfoGroup.Items[i].Data), false, False);


  Result := FSelectedInfoGroups;  
end;

procedure TfrmInfoGroup.RefreshInfoGroups;
var i: Integer;
    li: TListItem;
begin
  lvInfoGroup.Items.Clear;
  with TMainFacade.GetInstance.InfoGroups do
  for i := 0 to Count - 1 do
  begin
    li := lvInfoGroup.Items.Add;
    li.Caption := Items[i].Name;
    li.SubItems.Add(Items[i].Tag);
    li.SubItems.Add(Items[i].Place);
    li.Data := Items[i];
  end;
end;

end.
