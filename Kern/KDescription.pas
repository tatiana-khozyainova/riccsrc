unit KDescription;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, StdCtrls, Buttons, ExtCtrls, Menus,
  KDescriptionKernFrame, KInfoRockSampleFrame, ComCtrls, CoreDescription,
  Master, Classes, KInfoLayerSlottingFrame, Slotting;

type
  TfrmDescription = class(TForm)
    pctrl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Panel2: TPanel;
    BitBtn2: TBitBtn;
    BitBtn4: TBitBtn;
    actnNext: TAction;
    actnBack: TAction;
    actnSave: TAction;
    actnClose: TAction;
    actnLst: TActionList;
    BitBtn5: TBitBtn;
    frmDescriptionKern: TfrmDescriptionKern;
    frmInfoLayerSlotting: TfrmInfoLayerSlotting;
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actnCloseExecute(Sender: TObject);
    procedure actnNextExecute(Sender: TObject);
    procedure actnBackExecute(Sender: TObject);
    procedure actnSaveExecute(Sender: TObject);
  private
    FMaster: TMasterCreate;
    FBackupDescription: TDescription;
    FActiveLayer: TDescriptedLayer;
  public
    function    Save: Boolean;
    procedure   Clear;
    procedure   Reload;

    property    ActiveLayer: TDescriptedLayer read FActiveLayer write FActiveLayer;
    property    BackupDescription: TDescription read FBackupDescription write FBackupDescription;

    property    Master: TMasterCreate read FMaster write FMaster;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmDescription: TfrmDescription;

implementation

uses KDictionary, facade, RockSample, LayerSlotting, Math, BaseObjects, Well;

{$R *.dfm}

{ TfrmDescription }

constructor TfrmDescription.Create(AOwner: TComponent);
begin
  inherited;
  FMaster := TMasterCreate.Create(nil);
  FMaster.Steps := pctrl;
  FMaster.Name := 'Добавление описания керна';
  FMaster.SetOptions(1);

  BackupDescription := TDescription.Create(nil);
end;

destructor TfrmDescription.Destroy;
begin
  Screen.OnActiveControlChange := nil;

  BackupDescription.Free;
  inherited;
end;

procedure TfrmDescription.FormActivate(Sender: TObject);
begin
  if (frmListWords.frmDictionary.Closing) and (frmListWords.frmDictionary.Entering) then frmDescriptionKern.GetTheWord;
end;

procedure TfrmDescription.Reload;
begin
  if Assigned (ActiveLayer.Description) then
  begin
    {
    if ActiveLayer.Description.ID = 0 then
    begin
      ActiveLayer.ClearDescription;
      ActiveLayer.Description.Reload;
    end;
    }
    frmDescriptionKern.ActiveObject := ActiveLayer.Description;
    BackupDescription.Assign(ActiveLayer.Description);
  end;

  if ActiveLayer.ID > 0 then
    Caption := 'Описание керна по скважине: ' + (TMainFacade.GetInstance as TMainFacade).ActiveWell.NumberWell + ' - ' + (TMainFacade.GetInstance as TMainFacade).ActiveWell.Area.Name + ', долбление ' + (TMainFacade.GetInstance as TMainFacade).ActiveSlotting.Name + ', слой ' + ActiveLayer.Name
  else Caption := 'Описание керна по скважине: ' + (TMainFacade.GetInstance as TMainFacade).ActiveWell.NumberWell + ' - ' + (TMainFacade.GetInstance as TMainFacade).ActiveWell.Area.Name + ', долбление ' + (TMainFacade.GetInstance as TMainFacade).ActiveSlotting.Name;

  frmInfoLayerSlotting.Slotting := (TMainFacade.GetInstance as TMainFacade).ActiveSlotting;
  frmInfoLayerSlotting.Layer := FActiveLayer;

  frmInfoLayerSlotting.Reload;
  frmDescriptionKern.Reload;
end;

function TfrmDescription.Save: boolean;
var i: integer;
    Saving: boolean;
begin
  Result := false;

  {
  Saving := false;
  if frmDescriptionKern.ActiveObject.Words.Checking(TMainFacade.GetInstance.Dicts.Count) then
    Saving := true
  else if MessageBox(0, 'Описание должно содержать слова из каждого справочника.' + #10#13 +
                        'В данном описании отсутствуют слова из одного или нескольких справочников.' + #10#13 +
                        'Все равно сохранить ?', 'Вопрос', MB_YESNO + MB_ICONWARNING + MB_APPLMODAL + MB_DEFBUTTON2) = ID_YES then
  }
    Saving := true;

  if Saving then
  begin
    ActiveLayer.Update;
    ActiveLayer.Description.Update;
    ActiveLayer.Description.Files.Update(ActiveLayer.Description.Files);

    with frmInfoLayerSlotting.frmRockSample.ActiveLayer do
    begin
      //RockSamples.Poster.PostToDB(ActiveLayer.RockSamples, ActiveLayer.Collection.Owner);
      RockSamples.Update(RockSamples);

      // слои и виды исследований
      for i := 0 to RockSamples.Count - 1 do
      begin
        RockSamples.Items[i].Researchs.Update(RockSamples.Items[i].Researchs);//.PostToDB(RockSamples.Items[i].Researchs, RockSamples.Items[i]);

        RockSamples.Items[i].Owner.ID := ActiveLayer.ID;
        (RockSamples.Items[i].Owner as TLayerRockSample).RockSample := RockSamples.Items[i];
        (RockSamples.Items[i].Owner as TLayerRockSample).Update;
      end;
    end;

    ShowMessage('Описание удачно сохранено.');

    actnClose.Caption := 'Закрыть';
  end
end;

procedure TfrmDescription.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if frmDescriptionKern.ChangeMade then
  begin
    if MessageBox(0, 'Сохранить изменения ?', 'Вопрос', MB_ICONQUESTION + MB_APPLMODAL + MB_YESNO) = ID_YES then actnSave.Execute
    else if Assigned (ActiveLayer.Description) then ActiveLayer.Description.Assign(BackupDescription)
  end
end;

procedure TfrmDescription.actnCloseExecute(Sender: TObject);
begin
  if Assigned (ActiveLayer.Description) then
    ActiveLayer.Description.Assign(BackupDescription);
  Self.Close;
end;

procedure TfrmDescription.actnNextExecute(Sender: TObject);
begin
  if frmInfoLayerSlotting.Save then
  begin
    FMaster.SetOptions(2);
    if (frmInfoLayerSlotting.frmRockSample.ChangeMade) and (Trim(frmDescriptionKern.edtDescription.Text) = '') then
      frmDescriptionKern.edtDescription.Text := frmDescriptionKern.edtDescription.Text + #10#13 + frmInfoLayerSlotting.frmRockSample.GetRockSampleText;
  end
end;

procedure TfrmDescription.actnBackExecute(Sender: TObject);
begin
  FMaster.SetOptions(1);
end;

procedure TfrmDescription.actnSaveExecute(Sender: TObject);
begin
  //if frmDescriptionKern.Save then
  if Save then
    ShowMessage('Все данные успешно сохранены.')
end;

procedure TfrmDescription.Clear;
begin
  frmInfoLayerSlotting.Clear;
  frmDescriptionKern.Clear;

  FMaster.SetOptions(1);
end;

end.

