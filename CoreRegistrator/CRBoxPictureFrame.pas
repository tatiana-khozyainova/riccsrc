unit CRBoxPictureFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, ActnList, ComCtrls, ToolWin, ExtDlgs,
  SlottingPlacement, StdCtrls, Mask, ToolEdit, SlottingWell, Buttons, Contnrs,
  jpeg, OleCtrls, SHDocVw;


type
  TImageLink = class
  private
    FCdrImagePath: string;
    FJpgImagePath: string;
    FBox: TBox;
    function GetNoCDR: boolean;
    function GetJpgFIleName: string;
  public
    property JpgImagePath: string read FJpgImagePath write FJpgImagePath;
    property CdrImagePath: string read FCdrImagePath write FCDRImagePath;
    property Box: TBox read FBox write FBox;
    property NoCDR: boolean read GetNoCDR;
    property JpgFileName: string read GetJpgFIleName;
  end;

  TImageLinks = class(TObjectList)
  private
    FBoxes: TBoxes;
    function GetItems(const Index: Integer): TImageLink;
    function GetNoCDR: Boolean;
    function GetBoxes: TBoxes;
  public
    property Boxes: TBoxes read GetBoxes;
    property NoCDR: Boolean read GetNoCDR;
    property Items[const Index: Integer]: TImageLink read GetItems;
    function Add(AJpg, ACdr: string; ABox: TBox): TImageLink;
    constructor Create;
    destructor Destroy; override;
  end;

  TfrmBoxPicture = class(TFrame)
    actnLst: TActionList;
    actnOpenPicture: TAction;
    imgList: TImageList;
    grbx: TGroupBox;
    actnDelPicture: TAction;
    gbxFIle: TGroupBox;
    edtPath: TDirectoryEdit;
    edtCorelPath: TDirectoryEdit;
    lblFileName: TLabel;
    lblCorelPhoto: TLabel;
    lblName: TLabel;
    btnBack: TBitBtn;
    actnBack: TAction;
    actnForward: TAction;
    btnForward: TBitBtn;
    lblCdr: TLabel;
    btnReload: TBitBtn;
    lblCurrentFile: TLabel;
    prg: TProgressBar;
    pnl: TPanel;
    wbImage: TWebBrowser;
    procedure actnOpenPictureExecute(Sender: TObject);
    procedure actnDelPictureExecute(Sender: TObject);
    procedure edtPathAfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure actnBackExecute(Sender: TObject);
    procedure actnBackUpdate(Sender: TObject);
    procedure actnForwardExecute(Sender: TObject);
    procedure actnForwardUpdate(Sender: TObject);
    procedure edtCorelPathAfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure actnOpenPictureUpdate(Sender: TObject);
  private
    FBoxes: TBoxes;
    FSlottingWell: TSlottingWell;
    FImageLinks: TImageLinks;
    FCurrentImageIndex: integer;
    FViewOnly: boolean;
    procedure SetBoxes(const Value: TBoxes);
    procedure SetSlottingWell(const Value: TSlottingWell);
    function  GetImageLinks: TImageLinks;
    function  GetCdrPath: string;
    function  GetJpgPath: string;
    procedure SetViewOnly(const Value: boolean);
  public

    property    Boxes: TBoxes read FBoxes write SetBoxes;
    property    Well: TSlottingWell read FSlottingWell write SetSlottingWell;

    property    ImageLinks: TImageLinks read GetImageLinks;
    property    CurrentImageIndex: integer read FCurrentImageIndex write FCurrentImageIndex;
    procedure   LoadCurrentImage;

    property    JpgPath: string read GetJpgPath;
    property    CdrPath: string read GetCdrPath;

    property    ViewOnly: boolean read FViewOnly write SetViewOnly;

    function    Save: boolean;
    procedure   Clear;
    procedure   Reload;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade, BaseConsts;

{$R *.dfm}



{ TfrmBoxPicture }

constructor TfrmBoxPicture.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmBoxPicture.Destroy;
begin
  FImageLinks.Free;
  inherited;
end;

procedure TfrmBoxPicture.actnOpenPictureExecute(Sender: TObject);
var sNormalPostfix, sUVPostfix, sJpgExt, sCDRExt: string;
    i: Integer;
procedure LoadBox(ABox: TBox;  ABaseJpgPath, ABaseCDRPath: string; ABoxPattern: string);
var sJpgPath, sCdrPath: string;
    SR: TSearchRec;
begin
  // ищем файлы в каталогах jpg и cdr
  sJpgPath := ABaseJpgPath + ABoxPattern + sNormalPostfix + '.' + sJpgExt;
  sCdrPath := ABaseCDRPath + ABoxPattern + sNormalPostfix + '.' + sCDRExt;
  if FileExists(sJpgPath) and FileExists(sCdrPath) then
  begin
    if FindFirst(sJpgPath, faAnyFile, SR) = 0 then
    begin
      sJpgPath := ABaseJpgPath + SR.Name;
      FindClose(SR)
    end;

    if FindFirst(sCDRPath, faAnyFile, SR) = 0 then
    begin
      sCdrPath := ABaseCDRPath + SR.Name;
      FindClose(SR)
    end;

    ImageLinks.Add(sJpgPath, sCdrPath, ABox)
  end
  else if FileExists(sJpgPath) then
  begin
    if FindFirst(sJpgPath, faAnyFile, SR) = 0 then
    begin
      sJpgPath := ABaseJpgPath + SR.Name;
      FindClose(SR)
    end;

    ImageLinks.Add(sJpgPath, '', ABox);
  end;

  sJpgPath := ABaseJpgPath + ABoxPattern + sUVPostfix + '.' + sJpgExt;
  sCdrPath := ABaseCDRPath + ABoxPattern + sUVPostfix + '.' + sCDRExt;
  if FileExists(sJpgPath) and FileExists(sCdrPath) then
  begin
    if FindFirst(sJpgPath, faAnyFile, SR) = 0 then
    begin
      sJpgPath := ABaseJpgPath + SR.Name;
      FindClose(SR)
    end;

    if FindFirst(sCDRPath, faAnyFile, SR) = 0 then
    begin
      sCdrPath := ABaseCDRPath + SR.Name;
      FindClose(SR)
    end;

    ImageLinks.Add(sJpgPath, sCdrPath, ABox)
  end
  else if FileExists(sJpgPath) then
  begin
    if FindFirst(sJpgPath, faAnyFile, SR) = 0 then
    begin
      sJpgPath := ABaseJpgPath + SR.Name;
      FindClose(SR)
    end;

    ImageLinks.Add(sJpgPath, '', ABox);
  end;
end;

begin
  ImageLinks.Clear;
  sNormalPostfix := '_д';
  sUVPostfix := '_уф';
  sJpgExt := 'jpg';
  sCDRExt := 'cdr';
  ImageLinks.Clear;
  CurrentImageIndex := -1;
  prg.Position := 0;

  prg.Min := 0;
  prg.Max := Boxes.Count;
  if not ViewOnly then
  begin
    for i := 0 to Boxes.Count - 1 do
    begin
      LoadBox(Boxes.Items[i], JpgPath, CDRPath, 'ящик_'+ Boxes.Items[i].BoxNumber);
      prg.StepIt;
    end;
  end
  else
  begin
    for i := 0 to Boxes.Count - 1 do
    begin
      LoadBox(Boxes.Items[i], RemoteCoreFilesPath, RemoteCoreFilesPath, IntToStr(Boxes.Items[i].ID) + '*ящик_'+ Boxes.Items[i].BoxNumber);
      prg.StepIt;
    end;
  end;

  if ImageLinks.Count > 0 then
  begin
    CurrentImageIndex := 0;
    LoadCurrentImage;
  end
  else
  begin
    CurrentImageIndex := -1;
    LoadCurrentImage;
  end;
end;

function TfrmBoxPicture.Save: boolean;
var mdResult: integer;
procedure SavePictures;
var bp: TBoxPicture;
    i: integer;
begin
  if ImageLinks.Count > 0 then
  begin
    prg.Position := 0;
    prg.Min := 0;
    prg.Max := ImageLinks.Count;
    try
      // добавляем картинки (сразу все)
      // в одной транзакции
      TMainFacade.GetInstance.DBGates.Server.StartTrans;
      for i := 0 to ImageLinks.Count - 1 do
        ImageLinks.Items[i].Box.BoxPictures.Clear;

      for i := 0 to ImageLinks.Count - 1 do
      begin
        bp := ImageLinks.Items[i].Box.BoxPictures.Add  as TBoxPicture;
        bp.Name := ExtractFileName(ImageLinks.Items[i].JpgImagePath);
        bp.LocalPath := ExtractFilePath(ImageLinks.Items[i].JpgImagePath);

        if not ImageLinks.Items[i].NoCDR then
        begin
          bp := ImageLinks.Items[i].Box.BoxPictures.Add as TBoxPicture;
          bp.Name := ExtractFileName(ImageLinks.Items[i].CdrImagePath);
          bp.LocalPath := ExtractFilePath(ImageLinks.Items[i].CdrImagePath);
        end;

        ImageLinks.Items[i].Box.BoxPictures.Update(nil);
        TMainFacade.GetInstance.UploadBoxPictures(ImageLinks.Items[i].Box);
        prg.StepIt;
        prg.Update;
      end;
      TMainFacade.GetInstance.DBGates.Server.CommitTrans;
    except
      // откатываем всё назад
      TMainFacade.GetInstance.ClearBoxPictures(ImageLinks.Boxes);
      TMainFacade.GetInstance.DBGates.Server.RollbackTrans;
      raise;
    end;
  end;
end;

begin
  Result := true;
  if not ViewOnly then
  begin
    mdResult := mrOk;
    if ImageLinks.NoCDR then
      mdResult := MessageDlg('Не для всех фотографий приложены исходные Corel-файлы. Пожалуйста, подтвердите сохранение.', mtConfirmation, mbOKCancel,0);

    if (not ImageLinks.NoCDR) or (mdResult = mrOK) then
      SavePictures;
  end;
end;

procedure TfrmBoxPicture.actnDelPictureExecute(Sender: TObject);
begin
  if MessageBox(0, 'Вы уверены, что хотите удалить фото керна?', 'Вопрос', MB_YESNO + MB_ICONWARNING + MB_APPLMODAL + MB_DEFBUTTON2) = ID_YES then
    Clear;
end;

procedure TfrmBoxPicture.Clear;
begin
  edtPath.Text := '';
end;

procedure TfrmBoxPicture.Reload;
begin
end;


procedure TfrmBoxPicture.SetBoxes(const Value: TBoxes);
begin
  FBoxes := Value;
  // загрузить сюда картинку с сервера
end;



procedure TfrmBoxPicture.SetSlottingWell(const Value: TSlottingWell);
begin
  FSlottingWell := Value;
end;

function TfrmBoxPicture.GetImageLinks: TImageLinks;
begin
  if not Assigned(FImageLinks) then
    FImageLinks := TImageLinks.Create;

  Result := FImageLinks;
end;

function TfrmBoxPicture.GetCdrPath: string;
begin
  Result := edtCorelPath.Text + '\';
end;

function TfrmBoxPicture.GetJpgPath: string;
begin
  Result := edtPath.Text + '\';
end;

procedure TfrmBoxPicture.LoadCurrentImage;
var lZoomX, lZoomY: single;
    lPicture: TJPEGImage;
begin
  if CurrentImageIndex > -1 then
  begin
    lPicture := nil;
    try
      lPicture:= TJPEGImage.create;
      lPicture.LoadFromFile(ImageLinks.Items[CurrentImageIndex].JpgImagePath);

      wbImage.Navigate(ImageLinks.Items[CurrentImageIndex].JpgImagePath);
      while wbImage.ReadyState < READYSTATE_INTERACTIVE do
        Application.ProcessMessages;

      lZoomX:=wbImage.Width/lPicture.Width;
      lZoomY:=wbImage.Height/lPicture.Height;

      if lZoomX<lZoomY then wbImage.OleObject.Document.Body.Style.Zoom := lZoomX
      else wbImage.OleObject.Document.Body.Style.Zoom := lZoomY;
    finally
      FreeAndNil(lPicture);
    end;

    lblCdr.Visible := ImageLinks.Items[CurrentImageIndex].NoCDR;
    lblCurrentFile.Caption := ImageLinks.Items[CurrentImageIndex].JpgFileName;
  end
  else
  begin
    wbImage.Navigate('about:blank');

    lblCdr.Visible := false;
    lblCurrentFile.Caption := '';
  end;
end;

procedure TfrmBoxPicture.SetViewOnly(const Value: boolean);
begin
  if FViewOnly <> Value then
  begin
    FViewOnly := Value;
    gbxFIle.Visible := not FViewOnly;
    lblCurrentFile.Visible := not FViewOnly;
  end;
end;

{ TImageLinks }

function TImageLinks.Add(AJpg, ACdr: string; ABox: TBox): TImageLink;
begin
  Result := TImageLink.Create;
  Result.JpgImagePath := AJpg;
  Result.CdrImagePath := ACdr;
  Result.Box := ABox;
  inherited Add(Result);
end;

constructor TImageLinks.Create;
begin
  inherited Create(True);
end;

destructor TImageLinks.Destroy;
begin
  FreeAndNil(FBoxes);
  inherited;
end;

function TImageLinks.GetBoxes: TBoxes;
var i: integer;
begin
  if not Assigned(FBoxes) then
  begin
    FBoxes := TBoxes.Create;
    FBoxes.OwnsObjects := false;
  end;

  for i := 0 to Count - 1 do
    FBoxes.Add(Items[i].Box, false, False);

  Result := FBoxes;
end;

function TImageLinks.GetItems(const Index: Integer): TImageLink;
begin
  Result := inherited Items[Index] as TImageLink;
end;

procedure TfrmBoxPicture.edtPathAfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  if Action then
  begin
    edtPath.Text := Name;
    edtCorelPath.Text := Name + '\' + 'Corel';
    actnOpenPictureExecute(Sender);
  end;
end;

procedure TfrmBoxPicture.actnBackExecute(Sender: TObject);
begin
  CurrentImageIndex := CurrentImageIndex - 1;
  LoadCurrentImage;
end;

procedure TfrmBoxPicture.actnBackUpdate(Sender: TObject);
begin
  actnBack.Enabled := CurrentImageIndex > 0;
end;

procedure TfrmBoxPicture.actnForwardExecute(Sender: TObject);
begin
  CurrentImageIndex := CurrentImageIndex + 1;
  LoadCurrentImage;
end;

procedure TfrmBoxPicture.actnForwardUpdate(Sender: TObject);
begin
  actnForward.Enabled := (CurrentImageIndex > -1) and (CurrentImageIndex < ImageLinks.Count - 1);
end;

function TImageLinks.GetNoCDR: Boolean;
var i: integer;
begin
  Result := false;
  
  for i := 0 to Count - 1 do
  if Items[i].NoCDR then
  begin
    Result := true;
    Break;
  end;
end;

{ TImageLink }

function TImageLink.GetJpgFIleName: string;
begin
  Result := ExtractFileName(JpgImagePath); 
end;

function TImageLink.GetNoCDR: boolean;
begin
  Result := Trim(CdrImagePath) = '';
end;

procedure TfrmBoxPicture.edtCorelPathAfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  if Action then
    actnOpenPictureExecute(Sender);
end;

procedure TfrmBoxPicture.actnOpenPictureUpdate(Sender: TObject);
begin
  actnOpenPicture.Enabled := (Trim(JpgPath) <> '') and (Trim(JpgPath) <> '\');
end;

end.
