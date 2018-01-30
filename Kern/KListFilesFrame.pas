unit KListFilesFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, ActnList, Buttons, ImgList, CoreDescription,
  ComCtrls, ToolWin, OleServer, WordXP, ComObj, Material, Menus;

type
  TfrmLstFiles = class(TFrame)
    grp1: TGroupBox;
    pnl1: TPanel;
    grp2: TGroupBox;
    lstFiles: TListBox;
    edtPath: TEdit;
    btnSave: TBitBtn;
    actnLst: TActionList;
    actnSetPath: TAction;
    dlgOpen: TOpenDialog;
    actnApply: TAction;
    ilList: TImageList;
    tlb1: TToolBar;
    btnOpen: TToolButton;
    btnApply: TToolButton;
    btn5: TToolButton;
    btnApply1: TToolButton;
    actnOpen: TAction;
    actnDelete: TAction;
    btnOpen1: TToolButton;
    btn3: TToolButton;
    actnClear: TAction;
    btnSetPath: TSpeedButton;
    btnClear: TSpeedButton;
    btnClear1: TToolButton;
    actnSave: TAction;
    pnl2: TPanel;
    grp3: TGroupBox;
    lstAllFilesByWell: TListBox;
    spl1: TSplitter;
    spl2: TSplitter;
    pnlButtons: TPanel;
    btnAddAuthors: TSpeedButton;
    btnMoveLeftAuthors: TSpeedButton;
    actnLeft: TAction;
    actnRight: TAction;
    pm: TPopupMenu;
    N1: TMenuItem;
    btnCancel: TBitBtn;
    procedure actnSetPathExecute(Sender: TObject);
    procedure actnApplyExecute(Sender: TObject);
    procedure edtPathChange(Sender: TObject);
    procedure lstFilesClick(Sender: TObject);
    procedure btnSetPathClick(Sender: TObject);
    procedure actnDeleteExecute(Sender: TObject);
    procedure actnOpenExecute(Sender: TObject);
    procedure actnClearExecute(Sender: TObject);
    procedure actnSaveExecute(Sender: TObject);
    procedure actnLeftExecute(Sender: TObject);
    procedure actnRightExecute(Sender: TObject);
    procedure lstAllFilesByWellClick(Sender: TObject);
    procedure lstAllFilesByWellDblClick(Sender: TObject);
    procedure lstFilesDblClick(Sender: TObject);
  private
    FChanging: Boolean;
    FLstDFiles: TDescriptionFiles;
    FDocuments: TDescriptionDocuments;

    function GetActiveFile: TDescriptionFile;
    function GetDocuments: TDescriptionDocuments;
  public
    property    Changing: Boolean read FChanging write FChanging;

    property    ActiveFile: TDescriptionFile read GetActiveFile; 
    property    LstDFiles: TDescriptionFiles read FLstDFiles write FLstDFiles;

    property    Documents: TDescriptionDocuments read GetDocuments;

    procedure   Clear;
    procedure   Reload;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Math, BaseObjects, Facade;

{$R *.dfm}

procedure TfrmLstFiles.actnSetPathExecute(Sender: TObject);
begin
  if dlgOpen.Execute then
    edtPath.Text := Trim(dlgOpen.FileName);
end;

constructor TfrmLstFiles.Create(AOwner: TComponent);
begin
  inherited;
  FChanging := False;

  FLstDFiles := TDescriptionFiles.Create;
end;

destructor TfrmLstFiles.Destroy;
begin
  FLstDFiles.Free;
  
  inherited;
end;

procedure TfrmLstFiles.actnApplyExecute(Sender: TObject);
var o: TDescriptionFile;
begin
  if FileExists(trim(edtPath.Text)) then
  if not Assigned (FLstDFiles.GetItemByName(trim(edtPath.Text))) then
  begin
    if edtPath.Tag = 0 then
    begin
      o := TDescriptionFile.Create(FLstDFiles);
      o.ID := (TMainFacade.GetInstance as TMainFacade).ActiveSlotting.ID;
      FLstDFiles.Add(o, True, false);
    end;

    o.Name := IntToStr((lstAllFilesByWell.Items.Objects[lstAllFilesByWell.ItemIndex] as TDescriptionDocument).ID);
    Reload;
  end
  else MessageBox(0, '”казанный файл уже присутствует в списке', '»нформаци€', MB_OK + MB_ICONINFORMATION + MB_APPLMODAL)
  else MessageBox(0, '”казанный файл не существует', 'ќшибка', MB_OK + MB_ICONERROR + MB_APPLMODAL);
end;

procedure TfrmLstFiles.edtPathChange(Sender: TObject);
begin
  FChanging := True;  
end;

procedure TfrmLstFiles.Clear;
begin
  lstFiles.Clear;
  edtPath.Clear;
end;

procedure TfrmLstFiles.Reload;
var i: Integer;
begin
  Documents.MakeList(lstAllFilesByWell.Items, True, True);

  for i := 0 to LstDFiles.Count - 1 do
  if Assigned(Documents.ItemsByID[StrToInt(LstDFiles.Items[i].Name)]) then
  begin
    LstDFiles.Items[i].FullName := (Documents.ItemsByID[StrToInt(LstDFiles.Items[i].Name)] as TSimpleDocument).Name;
    LstDFiles.Items[i].LocationPath := (Documents.ItemsByID[StrToInt(LstDFiles.Items[i].Name)] as TSimpleDocument).LocationPath;

    lstAllFilesByWell.Selected[lstAllFilesByWell.Items.IndexOfObject(Documents.ItemsByID[StrToInt(LstDFiles.Items[i].Name)])] := True;
    lstAllFilesByWell.DeleteSelected;
  end;

  LstDFiles.MakeList(lstFiles.Items, True, True);
end;

procedure TfrmLstFiles.lstFilesClick(Sender: TObject);
begin
  if Assigned (lstFiles.Items.Objects[lstFiles.ItemIndex]) then
  begin
    edtPath.Text := (lstFiles.Items.Objects[lstFiles.ItemIndex] as TDescriptionDocument).LocationPath;
    edtPath.Tag := (lstFiles.Items.Objects[lstFiles.ItemIndex] as TDescriptionDocument).ID;
  end
  else edtPath.Text := lstFiles.Items[lstFiles.ItemIndex];
end;

procedure TfrmLstFiles.btnSetPathClick(Sender: TObject);
begin
  actnSetPath.Execute;
end;

procedure TfrmLstFiles.actnDeleteExecute(Sender: TObject);
begin
  actnRight.Execute;
end;

procedure TfrmLstFiles.actnOpenExecute(Sender: TObject);
var MsWord: Variant;
begin
  if trim(edtPath.Text) <> '' then
  begin
    If FileExists(trim(edtPath.Text)) then
    begin
      try
        MsWord := GetActiveOleObject('Word.Application');
        MsWord.Visible := True;
      except
        try
          MsWord := CreateOleObject('Word.Application');
          MsWord.Visible := True;
        except
          Exception.Create('Error');
        end;
      end;

      MSWord.Documents.Open(trim(edtPath.Text));
    end
    else MessageBox(0, '”казанный файл не существует', 'ќшибка', MB_OK + MB_ICONERROR + MB_APPLMODAL);
  end;
end;

procedure TfrmLstFiles.actnClearExecute(Sender: TObject);
begin
  edtPath.Clear;
end;

procedure TfrmLstFiles.actnSaveExecute(Sender: TObject);
var i: Integer;
    o: TDescriptionFile;
begin
  for i := 0 to lstFiles.Count - 1 do
  begin
    if not Assigned (FLstDFiles.GetItemByName((lstFiles.Items.Objects[i] as TSimpleDocument).Name)) then
    begin
      o := TDescriptionFile.Create(FLstDFiles);
      o.ID := (TMainFacade.GetInstance as TMainFacade).ActiveSlotting.ID;
      o.Name := (lstFiles.Items.Objects[i] as TSimpleDocument).Name;
      o.LocationPath := (lstFiles.Items.Objects[i] as TSimpleDocument).LocationPath;

      FLstDFiles.Add(o, True, false);

      Reload;
    end;
  end
end;

function TfrmLstFiles.GetActiveFile: TDescriptionFile;
begin
  Result := nil;

  if lstFiles.Count > 0 then
  if (lstFiles.ItemIndex >= 0) then
    Result := (lstFiles.Items.Objects[lstFiles.ItemIndex] as TDescriptionFile);
end;

procedure TfrmLstFiles.actnLeftExecute(Sender: TObject);
var i, iIndex: Integer;
begin
  iIndex := -1;

  for i := 0 to lstFiles.Count - 1 do
  if lstFiles.Items[i] = lstAllFilesByWell.Items[lstAllFilesByWell.ItemIndex] then
  begin
    iIndex := i;
    Break;
  end;

  if iIndex < 0 then
    lstFiles.AddItem(lstAllFilesByWell.Items[lstAllFilesByWell.ItemIndex], lstAllFilesByWell.Items.Objects[lstAllFilesByWell.ItemIndex])
  else MessageBox(0, '”казанный файл уже присутствует в списке', 'ќшибка', MB_OK + MB_ICONERROR + MB_APPLMODAL);

  lstAllFilesByWell.DeleteSelected;
end;

procedure TfrmLstFiles.actnRightExecute(Sender: TObject);
var i, iIndex: Integer;
begin
  iIndex := -1;

  for i := 0 to lstAllFilesByWell.Count - 1 do
  if lstAllFilesByWell.Items[i] = lstFiles.Items[lstFiles.ItemIndex] then
  begin
    iIndex := i;
    Break;
  end;

  if iIndex < 0 then
    lstAllFilesByWell.AddItem(lstFiles.Items[lstFiles.ItemIndex], lstFiles.Items.Objects[lstFiles.ItemIndex]);

  lstFiles.DeleteSelected;
end;

function TfrmLstFiles.GetDocuments: TDescriptionDocuments;
begin
  if not Assigned (FDocuments) then
  begin
    FDocuments := TDescriptionDocuments.Create;
    FDocuments.Reload('material_type_id = 19 and material_id in ' +
                      '(select mb.material_id from tbl_material_binding mb ' +
                      'where mb.object_bind_type_id = 1 and mb.object_bind_id = ' + IntToStr((TMainFacade.GetInstance as TMainFacade).ActiveWell.ID) + ')');
  end;

  Result := FDocuments;
end;

procedure TfrmLstFiles.lstAllFilesByWellClick(Sender: TObject);
begin
  if Assigned (lstAllFilesByWell.Items.Objects[lstAllFilesByWell.ItemIndex]) then
  begin
    edtPath.Text := (lstAllFilesByWell.Items.Objects[lstAllFilesByWell.ItemIndex] as TDescriptionDocument).LocationPath;
    edtPath.Tag := (lstAllFilesByWell.Items.Objects[lstAllFilesByWell.ItemIndex] as TDescriptionDocument).ID;
  end
end;

procedure TfrmLstFiles.lstAllFilesByWellDblClick(Sender: TObject);
begin
  actnLeft.Execute;
end;

procedure TfrmLstFiles.lstFilesDblClick(Sender: TObject);
begin
  actnRight.Execute;
end;

end.
