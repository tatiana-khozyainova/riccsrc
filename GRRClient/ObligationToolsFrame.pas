unit ObligationToolsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, ActnList, ToolWin, GRRObligation, Menus, Version;

type
  TfrmObligationTools = class(TFrame)
    tlbr1: TToolBar;
    actnLst: TActionList;
    actnAddObligation: TAction;
    actnDeleteObligation: TAction;
    imgLst: TImageList;
    btnAdd: TToolButton;
    btnDelete: TToolButton;
    actnDeleteAllObligations: TAction;
    btnCopyConditions: TToolButton;
    actnCopyConditions: TAction;
    btn1: TToolButton;
    pmnVersions: TPopupMenu;
    procedure actnAddObligationExecute(Sender: TObject);
    procedure actnDeleteObligationExecute(Sender: TObject);
    procedure actnDeleteObligationUpdate(Sender: TObject);
    procedure actnAddObligationUpdate(Sender: TObject);
    procedure actnDeleteAllObligationsExecute(Sender: TObject);
    procedure actnDeleteAllObligationsUpdate(Sender: TObject);
    procedure actnCopyConditionsExecute(Sender: TObject);
    procedure actnCopyConditionsUpdate(Sender: TObject);
    procedure pmnVersionsPopup(Sender: TObject);
  private
    { Private declarations }
    FObligations: TObligations;
    FOnObligationRemoved: TNotifyEvent;
    FOnObligationAdded: TNotifyEvent;
    FSelectedObligation: TObligation;
    procedure DeleteVersionFromPopup(AVersion: TVersion);
    procedure AddItemToPopup(AVersion: TVersion; const AItemName: string);
    procedure MakeConditionsCopy(Sender: TObject);
    procedure AnimateMenu;
  public
    { Public declarations }
    property Obligations: TObligations read FObligations write FObligations;
    property SelectedObligation: TObligation read FSelectedObligation write FSelectedObligation;
    property OnObligationAdded: TNotifyEvent read FOnObligationAdded write FOnObligationAdded;
    property OnObligationRemoved: TNotifyEvent read FOnObligationRemoved write FOnObligationRemoved;

  end;

implementation

{$R *.dfm}

uses Facade, Math;

procedure TfrmObligationTools.actnAddObligationExecute(Sender: TObject);
var o: TObligation;
begin
  o := Obligations.Add as TObligation;
  if Assigned(FOnObligationAdded) then FOnObligationAdded(o);
end;

procedure TfrmObligationTools.actnDeleteObligationExecute(Sender: TObject);
begin
  Obligations.MarkDeleted(SelectedObligation);
  if Assigned(FOnObligationRemoved) then FOnObligationRemoved(nil);
end;

procedure TfrmObligationTools.actnDeleteObligationUpdate(Sender: TObject);
begin
  actnDeleteObligation.Enabled := Assigned(Obligations) and Assigned(SelectedObligation);
end;

procedure TfrmObligationTools.actnAddObligationUpdate(Sender: TObject);
begin
  actnAddObligation.Enabled := Assigned(Obligations);
end;

procedure TfrmObligationTools.actnDeleteAllObligationsExecute(
  Sender: TObject);
begin
  Obligations.MarkAllDeleted;
  if Assigned(FOnObligationRemoved) then FOnObligationRemoved(nil);
end;

procedure TfrmObligationTools.actnDeleteAllObligationsUpdate(
  Sender: TObject);
begin
  actnDeleteAllObligations.Enabled := Assigned(Obligations);
end;

procedure TfrmObligationTools.actnCopyConditionsExecute(Sender: TObject);
begin
//
end;

procedure TfrmObligationTools.actnCopyConditionsUpdate(Sender: TObject);
begin
  actnCopyConditions.Enabled := Assigned(Obligations) and Assigned(TMainFacade.GetInstance.ActiveLicenseZone);
end;

procedure TfrmObligationTools.pmnVersionsPopup(Sender: TObject);
begin
  // подгружаем все версии из которых можно копировать
  TMainFacade.GetInstance.AllVersions.MakeList(pmnVersions.Items);
  // удаляем текущую
  DeleteVersionFromPopup(TMainFacade.GetInstance.ActiveVersion);
  // добавляем служебные - следующую, предыдущую,
  AddItemToPopup(nil, '-');
  if TMainFacade.GetInstance.ActiveVersion.Prev <> nil then AddItemToPopup(TMainFacade.GetInstance.ActiveVersion.Prev as TVersion, 'Следующая');
  if TMainFacade.GetInstance.ActiveVersion.Next <> nil then AddItemToPopup(TMainFacade.GetInstance.ActiveVersion.Next as TVersion, 'Предыдущая');

  AnimateMenu;
end;

procedure TfrmObligationTools.DeleteVersionFromPopup(AVersion: TVersion);
var i: integer;
begin
  for i := 0 to pmnVersions.Items.Count - 1 do
  if pmnVersions.Items[i].Tag = AVersion.ID then
  begin
    pmnVersions.Items.Delete(i);
    break;
  end;
end;

procedure TfrmObligationTools.AddItemToPopup(AVersion: TVersion; const AItemName: string);
var mi: TMenuItem;
begin
  mi := NewItem(AItemName, 0, false, true, nil, 0, pmnVersions.Name);
  if Assigned(AVersion) then
    mi.Tag := AVersion.ID
  else
    mi.Tag := -1;

  pmnVersions.Items.Insert(0, mi);
end;

procedure TfrmObligationTools.MakeConditionsCopy(Sender: TObject);
var v: TVersion;
    obs: TObligations;
begin
  if Sender is TMenuItem then
  begin
    v := TMainFacade.GetInstance.AllVersions.ItemsById[(Sender as TMenuItem).Tag] as TVersion;
    if not Assigned(v) then
    begin
      MessageBox(Handle, PChar('Версия-источник данных - не найдена'), PChar('Информация'), MB_ICONINFORMATION + MB_OK + MB_APPLMODAL);
      Exit;
    end;

    obs := TObligationsClass(Obligations.ClassType).Create;
    obs.Reload(Format('VERSION_ID = %s and LICENSE_ID = %s', [IntToStr(v.Id), IntToStr(TMainFacade.GetInstance.ActiveLicenseZone.License.ID)]), false);
    if obs.Count = 0 then
    begin
      MessageBox(Handle, PChar('В выбранной версии отсутствуют условия указанного типа для данного лицензионного участка'), PChar('Информация'), MB_ICONINFORMATION + MB_OK + MB_APPLMODAL);
      Exit;
    end;

    Obligations.Copy(obs);
    if Assigned(FOnObligationAdded) then FOnObligationAdded(Obligations);
  end;
end;

procedure TfrmObligationTools.AnimateMenu;
var i: integer;
begin
  for i := 0 to pmnVersions.Items.Count - 1 do
    pmnVersions.Items[i].OnClick := MakeConditionsCopy;
end;

end.
