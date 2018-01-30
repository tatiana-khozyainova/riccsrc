unit LasForm;

//ece9d8

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, LasFrame, ActnList, Buttons, LasFile, Well,
  StdCtrls, Facade, BaseObjects, DBGate, ImgList, Area, Organization, Encoder;

type
  TForm3 = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    frmLas: TFrame1;
    actlst1: TActionList;
    actOpenFiles: TAction;
    dlgOpen: TOpenDialog;
    cmbxArea: TComboBox;
    cmbxWell: TComboBox;
    actAreaSelect: TAction;
    il1: TImageList;
    acttrwDblClick: TAction;
    btnOpen: TSpeedButton;
    actMakeWellList: TAction;
    btnAssign: TSpeedButton;
    lblArea: TLabel;
    lblWell: TLabel;
    actAddToFormWells: TAction;
    ts3: TTabSheet;
    edtEdit: TEdit;
    btnEdit: TSpeedButton;
    actLineDblClick: TAction;
    actLineDblClickEdit: TAction;
    btnSaveOne: TSpeedButton;
    btnSaveAll: TSpeedButton;
    actSaveCurrentLasFile: TAction;
    actSaveAllLasFiles: TAction;
    ts4: TTabSheet;
    cmbxOrg: TComboBox;
    lblOrg: TLabel;
    btnAssignOrg: TSpeedButton;
    actAssignOrg: TAction;
    ts5: TTabSheet;
    cmbxCurvCategory: TComboBox;
    lbl1: TLabel;
    lbl2: TLabel;
    cmbxCurve: TComboBox;
    btnAddCurve: TSpeedButton;
    actCurveCategoryChange: TAction;
    actAssignCurve: TAction;
    btnPostToDB: TSpeedButton;
    actPostToDb: TAction;
    btnSaveAsPrepared: TSpeedButton;
    actSaveAsPrepare: TAction;
    pbReadLas: TProgressBar;
    btnIsRight: TSpeedButton;
    actStringIsRight: TAction;
    btnAssignOrgForAll: TSpeedButton;
    actAssignOrgForAll: TAction;
    edt2: TEdit;
    edt3: TEdit;
    lblMnem: TLabel;
    lblValue: TLabel;
    lblComment: TLabel;
    btnCurveDB: TSpeedButton;
    actAddCurvesToDB: TAction;
    ts6: TTabSheet;
    rbAnsi: TRadioButton;
    rbOem: TRadioButton;
    btnChangeAllCoding: TSpeedButton;
    btnChangeOneCosing: TSpeedButton;
    actChangeOneCosing: TAction;
    actChangeAllCoding: TAction;
    procedure actOpenFilesExecute(Sender: TObject);
    procedure actAreaSelectExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acttrwDblClickExecute(Sender: TObject);
    procedure actAd(Sender: TObject);
    procedure cmbxAreaChange(Sender: TObject);
    procedure actLineDblClickExecute(Sender: TObject);
    procedure actLineDblClickEditExecute(Sender: TObject);
    procedure actSaveCurrentLasFileExecute(Sender: TObject);
    procedure actSaveAllLasFilesExecute(Sender: TObject);
    procedure actAssignOrgExecute(Sender: TObject);
    procedure actCurveCategoryChangeExecute(Sender: TObject);
    procedure actAssignCurveExecute(Sender: TObject);
    procedure actPostToDbExecute(Sender: TObject);
    procedure actSaveAsPrepareExecute(Sender: TObject);
    procedure actStringIsRightExecute(Sender: TObject);
    procedure cmbxWellSelect(Sender: TObject);
    procedure cmbxCurveSelect(Sender: TObject);
    procedure cmbxOrgSelect(Sender: TObject);
    procedure actAssignOrgForAllExecute(Sender: TObject);
    procedure actAddCurvesToDBExecute(Sender: TObject);
    procedure actChangeOneCosingExecute(Sender: TObject);
    procedure actChangeAllCodingExecute(Sender: TObject);

  private
    { Private declarations }
    FLasFiles : TLasFiles;
    FLasFilesContents : TLasFileContents;
    FCurrentLasFile : TLasFile;
    FAreaID :Integer;
    FWellID : Integer;
    FOrgID : Integer;
    FSelectedLasFiles : TLasFiles;
    FSelectedLasFilesWellID :Integer;
    FBindingWells: TWells;
    FCurves : TCurves;




    function GetCurrentLasFile : TLasFile;
    function GetSelectedLasFiles : TLasFiles;
    function GetWell: TWell;
    function GetLasFile: TLasFile;
    function GetArea: TArea;
    function GetBindingWell: TWell;
    function GetCurveForAdd: TCurve;
    function GetCurveCategoryForAdd : TCurveCategory;
    function GetOrgForAdd: TOrganization;
    function GetStringInLb : TStringInBlock;
    function GetCurrentCoding : TEncoding;
  public
    { Public declarations }
    procedure GetLasFileContent (ALasFile: TLasFile; AEncoding : TEncoding);
   // function GetStringFromBlock(ALasFileContent:TLasFileContent; BlockName:string; StrName:string) : string;
    property CurrentLasFile : TLasFile read GetCurrentLasFile;
    procedure ViewLasInListBox(ALasFile:TLasFile);
    procedure MakeTree;
    //procedure MakeAreasList;

    property AreaID : Integer read FAreaID write FAreaID;
    property WellID : Integer read FWellID write FWellID;
    property OrgID : Integer read FOrgID write FOrgID;

    // то что выбрано в дереве //
    property SelectedWell: TWell read GetWell;
    property SelectedLasFile: TLasFile read GetLasFile;
    property SelectedLasFiles : TLasFiles read GetSelectedLasFiles;

    // скважины для привязки //
    property BindingWells: TWells read FBindingWells;
    property BindingArea: TArea read GetArea;
    property BindingWell: TWell read GetBindingWell;

    //кривая для привязки//
    property CategoryCurveForAdd : TCurveCategory read GetcurveCategoryForAdd;
    property CurveForAdd : TCurve read GetCurveForAdd;
    property Curves: TCurves read FCurves;

    //организация для привзяки//
    property OrgForAdd : TOrganization read GetOrgForAdd;

    //поле в lstbx1
    property StringInLb : TStringInBlock read GetStringInLb;

    //выбранная кодировка
    property CurrentCoding : TEncoding read GetCurrentCoding;

    procedure SkipSelectedLasFiles;

    procedure CheckButtons;


    destructor Destroy; override;


  end;

var
  Form3: TForm3;

implementation

uses Math, DateUtils;

{$R *.dfm}

procedure TForm3.actOpenFilesExecute(Sender: TObject);
var
  i:Integer;
  lf:TLasFile;
  N:TTreeNode;
begin
  MessageBeep(MB_OK);
  frmLas.trwLas.Items.Clear;
  FreeAndNil(FLasFiles);
  FLasFiles:=TLasFiles.Create;
  FLasFilesContents:= TLasFileContents.Create;

  dlgOpen := TOpenDialog.Create(self);
  dlgOpen.InitialDir := GetCurrentDir;
  dlgOpen.Filter :='Все файлы|*.*|Las-файлы|*.las';
  dlgOpen.FilterIndex := 2;

  if (not (ofAllowMultiSelect in dlgOpen.Options)) then
  dlgOpen.Options := dlgOpen.Options + [ofAllowMultiSelect];

  if dlgOpen.Execute then
  begin
    if not DirectoryExists(ExtractFileDir(dlgOpen.Files.Strings[0])+'\temp') then
    ForceDirectories(ExtractFileDir(dlgOpen.Files.Strings[0])+'\temp');

    for i:=0 to dlgOpen.Files.Count-1 do
      begin
        if FileExists(ExtractFileDir(dlgOpen.Files.Strings[i])+'\temp\'+ExtractFileName(dlgOpen.Files.Strings[i])) then
          DeleteFile(ExtractFileDir(dlgOpen.Files.Strings[i])+'\temp\'+ExtractFileName(dlgOpen.Files.Strings[i]));
        CopyFile(Pchar(dlgOpen.Files.Strings[i]), Pchar(ExtractFileDir(dlgOpen.Files.Strings[i])+'\temp\'+ExtractFileName(dlgOpen.Files.Strings[i])), true);
        dlgOpen.Files.Strings[i]:=ExtractFileDir(dlgOpen.Files.Strings[i])+'\temp\'+ExtractFileName(dlgOpen.Files.Strings[i]);
      end;

      dlgOpen.InitialDir:=ExtractFileDir(dlgOpen.Files.Strings[0]);
      frmLas.trwLas.Items.BeginUpdate;
      pbReadLas.Max:=dlgOpen.Files.Count;
      pbReadLas.Position:=0;

      for i :=0 to dlgOpen.Files.Count -1 do
      begin
        lf := FLasFiles.Add as TLasFile;
        lf.OldFileName := dlgOpen.Files.Strings[i];
        GetLasFileContent(lf, CurrentCoding);
        pbReadLas.Position:=pbReadLas.Position+1;
      end;

      frmLas.trwLas.Items.EndUpdate;
      //TMainFacade.GetInstance.SkipFormWells;
      //TMainFacade.GetInstance.CreateFormWells(FLasFilesContents);
      MakeTree;

      pgc1.ActivePageIndex:=1;
      pgc1.Pages[1].Enabled:=True;
      cmbxArea.Text:='Площадь';
      cmbxWell.Text:='Скважина';
      CheckButtons;
  end;
end;

procedure TForm3.actAreaSelectExecute(Sender: TObject);
var
  TmpArea : TIDObject;
begin
  TmpArea := (cmbxArea.Items.Objects [cmbxArea.ItemIndex]) as TIDObject;
  TMainFacade.GetInstance.LasFilter:= 'AREA_ID = ' + IntToStr(TmpArea.ID);
  TMainFacade.GetInstance.SkipLasWells;
  cmbxWell.Text:='';
  TMainFacade.GetInstance.AllLasWells.MakeList(cmbxWell.Items);
  cmbxWell.Enabled:=True;
  cmbxWell.Text:=cmbxWell.Items[0];
  CheckButtons;
end;

procedure TForm3.FormCreate(Sender: TObject);
  var
    i:integer;
    SurrogateCurveCategory:TCurveCategory;
begin
  //pgc1.Pages[1].Enabled:=False;
  cmbxWell.Enabled:=False;
  pgc1.ActivePageIndex:=0;

  TMainFacade.GetInstance.AllAreas.MakeList(cmbxArea.Items, False, false);

  //
  TMainFacade.GetInstance.AllLasOrg.MakeList(cmbxOrg.Items, False, false);
  cmbxOrg.Sorted:=True;
  //

  FBindingWells := TWells.Create;


    //Категории кривых
  FCurves := TCurves.Create;
  TMainFacade.GetInstance.AllCurveCategories.MakeList(cmbxCurvCategory.Items);
  SurrogateCurveCategory:=TCurveCategory.Create(nil);
  SurrogateCurveCategory.Name:='Все методы';  //Суррогатная категория методов, чтобы упростить поиск пр необходимости
  SurrogateCurveCategory.ID:=-1;
  cmbxCurvCategory.Sorted:=True;
  cmbxCurve.Sorted:=True;
  cmbxCurvCategory.Items.InsertObject(0,SurrogateCurveCategory.Name, SurrogateCurveCategory);
  //

 { btnAssign.Enabled     :=  False;
  btnAddCurve.Enabled   :=  False;
  btnAssignOrg.Enabled  :=  False;                                                ex
  btnAssignOrgForAll.Enabled    :=  False;       }

  CheckButtons;
end;

procedure TForm3.GetLasFileContent(ALasFile: TLasFile; AEncoding : TEncoding);
var
  ALasFileContent:TLasFileContent;
  i,j,k:Integer;
  area,well,temp:string;
  AResult: OleVariant;
  curve: TLasCurve;
begin
  ALasFileContent := TLasFileContent.Create(ALasFile);
  ALasFileContent.Encoding :=CurrentCoding;
  ALasFileContent.ReadFile;

  ALasFile.IsChanged:=True;
  ALasFile.Name:='';
  ALasFile.WellID:=0;
  well:='';
  area:='';
  well:=ALasFileContent.StringsInBock.GetStringByName('WELL').Value;
  area:=copy(ALasFileContent.StringsInBock.GetStringByName('FLD').Value,1, length(ALasFileContent.StringsInBock.GetStringByName('FLD').Value)-3);
  ALasFileContent.StringsInBock.GetStringByName('FLD').State:=NotDetected;
  ALasFileContent.StringsInBock.GetStringByName('WELL').State:=NotDetected;
  if Assigned (ALasFileContent.StringsInBock.GetStringByName('UWI')) then
    begin
      ALasFileContent.StringsInBock.GetStringByName('UWI').State:=NotDetected;
      ALasFileContent.StringsInBock.GetStringByName('UWI').Value:='000'
    end
  else
    begin
      ALasFileContent.StringsInBock.AddToPos('UWI . 000: Unique Well ID', '~Well Information', False);
      ALasFileContent.StringsInBock.GetStringByName('UWI').State:=NotDetected;
      ALasFileContent.StringsInBock.GetStringByName('UWI').Value:='000';
    end;
  for i:=0 to TMainFacade.GetInstance.AllAreas.Count-1 do
    begin
      if ( (Pos(UpperCase(area),UpperCase(TMainFacade.GetInstance.AllAreas.Items[i].Name))>0) and (UpperCase(Area[1])=UpperCase(TMainFacade.GetInstance.AllAreas.Items[i].Name[1])) )
      then
        begin
          k:=0;
          ALasFileContent.StringsInBock.GetStringByName('FLD').Value:=TMainFacade.GetInstance.AllAreas.Items[i].Name;
          ALasFileContent.StringsInBock.GetStringByName('FLD').State:=Detected;
          for j:=0 to TMainFacade.GetInstance.AllAreas.Items[i].Wells.Count-1 do
                if (TMainFacade.GetInstance.AllAreas.Items[i].Wells.Items[j].NumberWell=well)
                then
                  begin
                    ALasFileContent.StringsInBock.GetStringByName('UWI').State:=Detected;
                    ALasFileContent.StringsInBock.GetStringByName('UWI').Value:=IntToStr(TMainFacade.GetInstance.AllAreas.Items[i].Wells.Items[j].ID);
                    ALasFileContent.StringsInBock.GetStringByName('WELL').State:=Detected;
                    ALasFile.WellID:=TMainFacade.GetInstance.AllAreas.Items[i].Wells.Items[j].ID;

                    {temp:=TMainFacade.GetInstance.FormFilter;
                    if (temp[Length(temp)-1]='(')
                      then
                        Insert(IntToStr(TMainFacade.GetInstance.AllAreas.Items[i].Wells.Items[j].ID),temp, length(temp))
                      else
                        Insert(', '+IntToStr(TMainFacade.GetInstance.AllAreas.Items[i].Wells.Items[j].ID),temp, length(temp));
                    TMainFacade.GetInstance.FormFilter:=temp; }
                  end;
          Break;
        end;
    end;


  if Assigned(ALasFileContent.StringsInBock.GetStringByName('STRT')) then
    if (Length(ALasFileContent.StringsInBock.GetStringByName('STRT').Value)>0) then
      ALasFile.Start:=ALasFileContent.StringsInBock.GetStringByName('STRT').ConvertToFloat;

  if Assigned(ALasFileContent.StringsInBock.GetStringByName('STOP')) then
    if (Length(ALasFileContent.StringsInBock.GetStringByName('STOP').Value)>0) then
      ALasFile.Stop:=ALasFileContent.StringsInBock.GetStringByName('STOP').ConvertToFloat;

  if Assigned(ALasFileContent.StringsInBock.GetStringByName('STEP')) then
    if (Length(ALasFileContent.StringsInBock.GetStringByName('STEP').Value)>0) then
      ALasFile.Step:=ALasFileContent.StringsInBock.GetStringByName('STEP').ConvertToFloat;
  
  if Assigned(ALasFileContent.StringsInBock.GetStringByName('DATE')) then
    ALasFile.FileDate:=ALasFileContent.StringsInBock.GetStringByName('DATE').Value;

  if Assigned(ALasFileContent.StringsInBock.GetStringByName('COMP')) then
    begin
      ALasFileContent.StringsInBock.GetStringByName('COMP').State:=NotDetected;
    end;


  with ALasFileContent.StringsInBock do
    for i:=0 to Count-1 do
    begin
      if ((Items[i].BlockName='~Curve Information') and (Items[i].IsCommentString=false)) then
        begin
          Items[i].State:=NotDetected;
          for k:=0 to TMainFacade.GetInstance.AllCurves.Count-1 do
            if (TMainFacade.GetInstance.AllCurves.Items[k].ShortName=Items[i].GetCurve) then
              begin
                curve:=ALasFile.LasCurves.Add as TLasCurve;
                curve.Curve := TMainFacade.GetInstance.AllCurves.Items[k];
                Items[i].Name:=TMainFacade.GetInstance.AllCurves.Items[k].shortname+'.';
                Items[i].Value:=TMainFacade.GetInstance.AllCurves.Items[k].CurveUnit;
                Items[i].State:=Detected;
                Break;
              end;
        end;
    end;

  FLasFilesContents.Add(ALasFileContent);
end;





function TForm3.GetCurrentLasFile: TLasFile;
begin
  if not Assigned(FCurrentLasFile) then
  begin
     if ((TObject (frmLas.trwLas.Selected.Data) is TLasFile) and (frmLas.trwLas.Selected.Level>0)) then
        FCurrentLasFile:= TObject (frmLas.trwLas.Selected.Data) as TLasFile;
  end;
  Result:= FCurrentLasFile;
end;

procedure TForm3.acttrwDblClickExecute(Sender: TObject);
begin
  FCurrentLasFile:=nil;
  if Assigned(CurrentLasFile) then
    ViewLasInListBox(CurrentLasFile);
end;

procedure TForm3.ViewLasInListBox(ALasFile:TLasFile);
var
  i,k:Integer;
begin
  frmLas.lst1.Items.Clear;
   for i:=0 to FLasFilesContents.Count-1 do
   if (FLasFilesContents.Items[i].LasFile=ALasFile) then
    begin
      frmLas.lst1.Items.Clear;
      frmLas.lst1.Items.BeginUpdate;
      FLasFilesContents.Items[i].StringsInBock.MakeFullStrings;
      for k:=0 to FLasFilesContents.Items[i].StringsInBock.Count-1 do
        frmLas.lst1.Items.AddObject( AnsiString(PChar(FLasFilesContents.Items[i].StringsInBock.Items[k].FullString)),FLasFilesContents.Items[i].StringsInBock.Items[k]);
      frmLas.lst1.Items.EndUpdate;
      frmLas.lst1.Invalidate;
    end;
end;



procedure TForm3.MakeTree;
var
  i,j,max,id,k:Integer;
  Node,Node2:TTreeNode;
  temp,query:string;
  AResult : OleVariant;
begin
  max:=0;
  frmLas.trwLas.Items.Clear;
  for i:=0 to FLasFiles.Count-1 do
    begin
      if (FLasFiles.Items[i].WellID<>0) then
        begin
          temp:=FLasFilesContents.GetContentByFile(FLasFiles.Items[i]).StringsInBock.GetStringByName('WELL').Value;
          temp:=temp+'-';
          temp:=temp+FLasFilesContents.GetContentByFile(FLasFiles.Items[i]).StringsInBock.GetStringByName('FLD').Value;
          k:=0;
          with frmLas.trwLas do
            for j := 0 to pred(Items.Count) do
              if Items[j].Parent =nil then
                begin
                  if (temp=Items[j].Text) then
                    begin
                      if (Length(FLasFiles.Items[i].OldFileName)>max) then max:= Length(FLasFiles.Items[i].OldFileName);
                      Node2:=frmLas.trwLas.Items.AddChildObject(items[j], FLasFiles.Items[i].OldFileName, FLasFiles.Items[i]);
                      Node2.ImageIndex:=4;
                      Node2.SelectedIndex:=4;
                      k:=1;
                      break;
                    end;
                end;
          if (k=0) then
            begin
              Node:=frmLas.trwLas.Items.AddObject(nil, temp, nil);
              Node.ImageIndex:=3;
              Node.SelectedIndex:=3;
              if (Length(FLasFiles.Items[i].OldFileName)>max) then max:= Length(FLasFiles.Items[i].OldFileName);
              Node2:=frmLas.trwLas.Items.AddChildObject(Node, FLasFiles.Items[i].OldFileName, FLasFiles.Items[i]);
              Node2.ImageIndex:=4;
              Node2.SelectedIndex:=4;
            end;
        end;
    end;
  Node:=frmLas.trwLas.Items.AddObject(nil,'Непривязаны', nil);
  Node.ImageIndex:=3;
  Node.SelectedIndex:=3;
  for i:=0 to FLasFiles.Count-1 do
    if (FLasFiles.Items[i].WellID=0) then
      begin
        if (Length(FLasFiles.Items[i].OldFileName)>max) then max:= Length(FLasFiles.Items[i].OldFileName);
        Node2:=frmLas.trwLas.Items.AddChildObject(Node, FLasFiles.Items[i].OldFileName, FLasFiles.Items[i]);
        Node2.ImageIndex:=4;
        Node2.SelectedIndex:=4;
      end;
  If (Node.Count=0) then
    frmLas.trwLas.Items.Delete(Node);
      frmLas.pnl1.Width:=Round(max*5.5+60);
      pbReadLas.Width:=Round(max*5.5+60);
end;


procedure TForm3.actAd(Sender: TObject);
var
  temp,query:string;
  AResult :OleVariant;
  ParentID, i,j : Integer;
  AWell : TWell;
  ALasFile: TLasFile;
begin
  SkipSelectedLasFiles;
      begin
        for i:=0 to SelectedLasFiles.Count-1 do
          begin
            for j:=0 to FLasFiles.Count-1 do
              if (SelectedLasFiles.Items[i].OldFileName=FLasFiles.Items[j].OldFileName) then
                begin
                  FLasFilesContents.GetContentByFile(FLasFiles.Items[j]).StringsInBock.GetStringByName('UWI').Value:=IntToStr(BindingWell.ID);
                  FLasFilesContents.GetContentByFile(FLasFiles.Items[j]).StringsInBock.GetStringByName('WELL').Value:=BindingWell.NumberWell;
                  FLasFilesContents.GetContentByFile(FLasFiles.Items[j]).StringsInBock.GetStringByName('FLD').Value:=BindingWell.Area.Name;
                  FLasFiles.Items[j].WellID:=BindingWell.ID;
                  FLasFilesContents.GetContentByFile(FLasFiles.Items[j]).StringsInBock.GetStringByName('UWI').State:=Detected;
                  FLasFilesContents.GetContentByFile(FLasFiles.Items[j]).StringsInBock.GetStringByName('WELL').State:=Detected;
                  FLasFilesContents.GetContentByFile(FLasFiles.Items[j]).StringsInBock.GetStringByName('FLD').State:=Detected;
                  FLasFilesContents.GetContentByFile(FLasFiles.Items[j]).MakeStrings;
                end;

          end;
      end;

  MakeTree;
end;

function TForm3.GetSelectedLasFiles: TLasFiles;
var
  i:Integer;
  AWell:TWell;
begin
  if not Assigned(FSelectedLasFiles) then
  begin
    FSelectedLasFiles := TLasFiles.Create;
    FSelectedLasFiles.OwnsObjects := false;
    for i := 0 to frmLas.trwLas.SelectionCount - 1  do
      if (frmLas.trwLas.Selections[i].Level>0) then
        begin
          FSelectedLasFiles.Add(TIDObject(frmLas.trwLas.Selections[i].Data), False, False);
        end;
  end;
  Result := FSelectedLasFiles;
end;

procedure TForm3.SkipSelectedLasFiles;
begin
  FreeAndNil(FSelectedLasFiles);
end;

function TForm3.GetWell: TWell;
begin
  if Assigned(frmLas.trwLas.Selected) then
  begin
    case frmLas.trwLas.Selected.Level of
    0: Result := TWell(frmLas.trwLas.Selected.Data);
    1: Result := TWell(frmLas.trwLas.Selected.Parent.Data);
    end;
  end
  else Result := nil;
end;

function TForm3.GetLasFile: TLasFile;
begin
  if Assigned(frmLas.trwLas.Selected) and (frmLas.trwLas.Selected.Level = 1) then
    Result := TLasFile(frmLas.trwLas.Selected.Data)
  else Result := nil;
end;

destructor TForm3.Destroy;
begin
  FreeAndNil(FBindingWells);
  inherited;
end;

procedure TForm3.cmbxAreaChange(Sender: TObject);
begin
  cmbxWell.Enabled := True;
  BindingWells.Clear;
  if Assigned(BindingArea)then
    BindingWells.Reload('Area_ID = ' + IntToStr(BindingArea.ID));
  BindingWells.MakeList(cmbxWell.Items, false, true);
end;

function TForm3.GetArea: TArea;
begin
  if cmbxArea.ItemIndex > -1 then
    Result := TArea(cmbxArea.Items.Objects[cmbxArea.ItemIndex])
  else
    Result := nil;
end;

function TForm3.GetBindingWell: TWell;
begin
  if cmbxWell.ItemIndex > -1 then
    Result := TWell(cmbxWell.Items.Objects[cmbxWell.ItemIndex])
  else
    Result := nil;
end;

procedure TForm3.actLineDblClickExecute(Sender: TObject);
  var
  AStringInBlock:TStringInBlock;
  i:Integer;
begin
  if Assigned (frmLas.lst1.Items.Objects[frmLas.lst1.itemindex]) then
    begin
      AStringInBlock:=TStringInBlock(frmLas.lst1.Items.Objects[frmLas.lst1.itemindex]);
      if ((AStringInBlock.BlockName='~Curve Information') and (AStringInBlock.IsCommentString=false))  then
            begin
              pgc1.ActivePageIndex:=4;
            end;
      if ((AStringInBlock.Name='SRVC.') or (AStringInBlock.Name='COMP.'))  then
            begin
              pgc1.ActivePageIndex:=3;
            end;
      if (AStringInBlock.IsCommentString=False) then
        begin
          if (AStringInBlock.BlockName='~Curve Information')  then
            begin
              //pgc1.ActivePageIndex:=4;
            end;
          //pgc1.ActivePageIndex:=2;
          edtEdit.Text:=AStringInBlock.Name;
          edt2.Text:=AStringInBlock.Value;
          edt3.Text:=AStringInBlock.Comment;
        end
      else
        begin
          edtEdit.Text:='';
          edt2.Text:='';
          edt3.Text:='';
        end;
      CheckButtons;
    end;
end;

procedure TForm3.actLineDblClickEditExecute(Sender: TObject);
  var
  AStringInBlock:TStringInBlock;
  index:integer;
begin
  if Assigned (frmLas.lst1.Items.Objects[frmLas.lst1.itemindex]) then
    begin
      AStringInBlock:=TStringInBlock(frmLas.lst1.Items.Objects[frmLas.lst1.itemindex]);
      if (AStringInBlock.IsCommentString=False) then
        begin
          AStringInBlock.Name:=Trim(edtEdit.Text);
          AStringInBlock.Value:=Trim(edt2.Text);
          AStringInBlock.Comment:=Trim(edt3.Text);
          if (AStringInBlock.BlockName<>'~Curve Information') then
          AStringInBlock.State:=Detected;
          if (Pos('START', AStringInBlock.Name)>0) then
            CurrentLasFile.Start:=AStringInBlock.ConvertToFloat;
          if (Pos('STOP', AStringInBlock.Name)>0) then
          CurrentLasFile.Stop:=AStringInBlock.ConvertToFloat;
          if (Pos('STEP', AStringInBlock.Name)>0) then
            CurrentLasFile.Step:=AStringInBlock.ConvertToFloat;
          index:=frmLas.lst1.itemindex;
        end;
    end;
  ViewLasInListBox(CurrentLasFile);
  frmLas.lst1.Selected[index]:=True;

end;

procedure TForm3.actSaveCurrentLasFileExecute(Sender: TObject);
var
  i:integer;
begin
 for i:=0 to FLasFilesContents.Count-1 do
   if (FLasFilesContents.Items[i].LasFile=CurrentLasFile) then
    begin
      FLasFilesContents.Items[i].SaveFile2(CurrentLasFile.OldFileName);
    end;
end;

procedure TForm3.actSaveAllLasFilesExecute(Sender: TObject);
var
  i:integer;
begin
 for i:=0 to FLasFilesContents.Count-1 do
  FLasFilesContents.Items[i].SaveFile2(FLasFilesContents.Items[i].LasFile.OldFileName);
end;

procedure TForm3.actAssignOrgExecute(Sender: TObject);
 var
  AStringInBlock:TStringInBlock;
begin
  if Assigned (frmLas.lst1.Items.Objects[frmLas.lst1.itemindex]) then
    begin
      AStringInBlock:=TStringInBlock(frmLas.lst1.Items.Objects[frmLas.lst1.itemindex]);
      if ((Pos('COMP',AStringInBlock.Name)>0) or (Pos('SRVC',AStringInBlock.Name)>0) ) then
        begin
          if Assigned(OrgForAdd) then
            begin
              CurrentLasFile.Organization:=OrgForAdd;
              AStringInBlock.Value:=OrgForAdd.Name;
              AStringInBlock.State:=Detected;
              ViewLasInListBox(CurrentLasFile);
            end
          else
            ShowMessage('Выберите органиазцию.');
        end
      else
        ShowMessage('Выберите поле COMP. или SRVC.');
    end;
end;

function TForm3.GetCurveForAdd: TCurve;
begin
  if cmbxCurve.ItemIndex > -1 then
    Result := TCurve(cmbxCurve.Items.Objects[cmbxCurve.ItemIndex])
  else
    Result := nil;
end;

function TForm3.GetOrgForAdd: TOrganization;
begin
  if cmbxOrg.ItemIndex > -1 then
    Result := TOrganization(cmbxorg.Items.Objects[cmbxOrg.ItemIndex])
  else
    Result := nil;
end;

procedure TForm3.actCurveCategoryChangeExecute(Sender: TObject);
var
  i:integer;
begin
  cmbxCurve.Enabled := True;
  Curves.Clear;
  if Assigned(CategoryCurveForAdd)then
  if (CategoryCurveForAdd.ID=-1) then
    Curves.Reload('',true)
  else
    Curves.Reload('Curve_category_ID = ' + IntToStr(CategoryCurveForAdd.ID));

  cmbxCurve.Items.Clear;

  for i:=0 to Curves.Count-1 do
    begin
      cmbxCurve.Items.AddObject(Curves.Items[i].ShortName+'   ['+Curves.Items[i].CurveUnit+']   '+Curves.Items[i].Name,Curves.Items[i]);
    end;

  //Curves.MakeList(cmbxCurve.Items, false, true);
end;

function TForm3.GetCurveCategoryForAdd: TCurveCategory;
begin
  if cmbxCurvCategory.ItemIndex > -1 then
    Result := TCurveCategory(cmbxCurvCategory.Items.Objects[cmbxCurvCategory.ItemIndex])
  else
    Result := nil;
end;

procedure TForm3.actAssignCurveExecute(Sender: TObject);
var
  curve:TLasCurve;
begin
  if (Assigned(CurveForAdd)) then
    begin
      if Assigned(StringInLb) then
        begin
          StringInLb.Name:=CurveForAdd.shortname+'.';
          StringInLb.Value:=CurveForAdd.CurveUnit;
          StringInLb.State:=Detected;
          curve:=CurrentLasFile.LasCurves.Add as TLasCurve;
          curve.Curve := CurveForAdd;
          ViewLasInListBox(CurrentLasFile);
        end
      else ShowMessage('Выберите поле из блока ~Curve Information');
    end
  else ShowMessage('Выберите метод.');

end;

function TForm3.GetStringInLb: TStringInBlock;
begin
  if (frmLas.lst1.ItemIndex > -1)  then
    begin
      //if (TStringInBlock(frmLas.lst1.Items.Objects[frmLas.lst1.ItemIndex]).IsCommentString=false) then
        Result := TStringInBlock(frmLas.lst1.Items.Objects[frmLas.lst1.ItemIndex]);
    end
  else
    Result := nil;
end;

procedure TForm3.actPostToDbExecute(Sender: TObject);
var
  i,k : integer;
  path,query:String;
  AResult:OleVariant;
  well:TWell;
begin
  pbReadLas.Position:=0;
  pbReadLas.Max:=FLasFiles.Count-1;
  for k:=0 to FLasFiles.Count-1 do
    if (FLasFilesContents.GetContentByFile(FLasFiles.Items[k]).IsTrue) then
      begin
        FLasFilesContents.GetContentByFile(FLasFiles.Items[k]).SaveFile2;
        FLasFiles.Items[k].Update();
        query:='select area_id from tbl_well where well_uin='+inttostr(FLasFiles.Items[k].WellID);
        if (TMainFacade.GetInstance.DBGates.ExecuteQuery(query, AResult)>0) then
          i:=AResult[0,0];
        //для тестовой базы
        //path:='\\srvsrvc\ricctest\LasBank\'+IntToStr(i)+'\'+IntToStr(FLasFiles.Items[k].WellID)+'\';
        //для действующей базы
        path:='\'+IntToStr(i)+'\'+IntToStr(FLasFiles.Items[k].WellID)+'\';
        if not DirectoryExists(path) then
          ForceDirectories(path);
          CopyFile(PChar(FLasFiles.Items[k].OldFileName), PChar('\\srvdb\LasBank\LasBank'+path+IntToStr(FLasFiles.Items[k].ID)+'.las'), True);
          FLasFiles.Items[k].FileName:=path+IntToStr(FLasFiles.Items[k].ID)+'.las';
        FLasFiles.Items[k].Update();
        pbReadLas.Position:=pbReadLas.Position+1;
      end;
end;

procedure TForm3.actSaveAsPrepareExecute(Sender: TObject);
var
  query:string;
begin
 if Assigned (SelectedLasFile) then
  begin
    if (FLasFilesContents.GetContentByFile(SelectedLasFile).IsTrue) then
      begin
         FLasFilesContents.GetContentByFile(SelectedLasFile).SaveFile2;
         query:='select * from tbl_well_research_information where well_uin='+inttostr(SelectedLasFile.WellID)+' and research_information_id=127';
         if (TMainFacade.GetInstance.DBGates.ExecuteQuery(query)>0) then
          begin
            query:=FLasFilesContents.GetContentByFile(SelectedLasFile).StringsInBock.GetStringByName('WELL').Value;
            query:=query+'-'+FLasFilesContents.GetContentByFile(SelectedLasFile).StringsInBock.GetStringByName('FLD').Value;
            MessageDlg('в БД уже есть информация о наличии подготовленных LAS-файлах по скважине '+query, mtInformation, [mbOK],0);
          end
         else
          begin
            query:='insert into tbl_well_research_information  values ('+inttostr(SelectedLasFile.WellID)+',127)';
            if (TMainFacade.GetInstance.DBGates.ExecuteQuery(query)>0) then
              begin
                MessageDlg('Добавлена информация о наличии подготовленных LAS-файлов', mtInformation, [mbOK],0);
              end
            else   MessageDlg('Информация успешно добавлена', mtInformation
            , [mbOK],0);
          end;
      end
    else MessageDlg('LAS-файл не отредактирован.', mtInformation, [mbOK],0);
end;
end;

procedure TForm3.actStringIsRightExecute(Sender: TObject);
  var
  AStringInBlock:TStringInBlock;
begin
  if Assigned (frmLas.lst1.Items.Objects[frmLas.lst1.itemindex]) then
    begin
      AStringInBlock:=TStringInBlock(frmLas.lst1.Items.Objects[frmLas.lst1.itemindex]);
      AStringInBlock.Value:=Trim(edtEdit.Text);
      AStringInBlock.State:=Detected;
    end;
  ViewLasInListBox(CurrentLasFile);
end;

procedure TForm3.cmbxWellSelect(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm3.cmbxCurveSelect(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm3.CheckButtons;
var
  i,k:integer;
begin
  {if not Assigned (FLasFiles) then
    begin
      pgc1.Pages[1].Enabled:=false;
      pgc1.Pages[2].Enabled:=false;
      pgc1.Pages[3].Enabled:=false;
      pgc1.Pages[4].Enabled:=false;
      pgc1.Pages[5].Enabled:=false;
    end
  else
    begin
      pgc1.Pages[1].Enabled:=true;
      pgc1.Pages[2].Enabled:=true;
      pgc1.Pages[3].Enabled:=true;
      pgc1.Pages[4].Enabled:=true;
      pgc1.Pages[5].Enabled:=true;
    end;
  btnAssign.Enabled     :=(Assigned(BindingWell)  and (SelectedLasFiles.Count>0));
  btnAddCurve.Enabled   :=(Assigned(CurveForAdd)  and Assigned(StringInLb) and (StringInLb.BlockName='~Curve Information') and (StringInLb.IsCommentString=false));
  btnAssignOrg.Enabled  :=(Assigned(OrgForAdd)    and Assigned(StringInLb) and ((StringInLb.Name='SRVC.') or (StringInLb.Name='COMP.')));
  btnAssignOrgForAll.Enabled  := (Assigned(OrgForAdd) and (FLasFiles.Count>0));
  btnChangeOneCosing.Enabled:=Assigned(SelectedLasFile);
  btnSaveAsPrepared.Enabled := (Assigned(SelectedLasFile) );
  btnSaveOne.Enabled := (Assigned(SelectedLasFile));
  btnSaveAll.Enabled := (Assigned(FLasFiles));
  i:=0;
  if Assigned(FLasFiles) then
    begin
      for k:=0 to FLasFiles.Count-1 do
        if (FLasFilesContents.GetContentByFile(FLasFiles.Items[k]).IsTrue) then i:=i+1;
    end;
  btnPostToDB.Enabled := (i>0);
  btnEdit.Enabled :=(frmLas.lst1.Count>0) and (Assigned(frmLas.lst1.Items.Objects[frmLas.lst1.itemindex]));
  btnIsRight.Enabled := (frmLas.lst1.Count>0) and (Assigned(frmLas.lst1.Items.Objects[frmLas.lst1.itemindex]));;

  k:=0; }
  {if Assigned(FLasFiles) then
  if Assigned (CurrentLasFile) then
  with FLasFilesContents.GetContentByFile(CurrentLasFile).StringsInBock do
  for i:=0 to Count-1 do
      if ((Items[i].BlockName='~Curve Information') and (Items[i].State=NotDetected)) then inc(k);
  btnCurveDB.Enabled:=k>0;}
end;



procedure TForm3.cmbxOrgSelect(Sender: TObject);
begin
  CheckButtons;
end;

procedure TForm3.actAssignOrgForAllExecute(Sender: TObject);
  var
    i:integer;
begin
  for i:=0 to FLasFiles.Count-1 do
    if Assigned(FLasFilesContents.GetContentByFile(FLasFiles.Items[i]).StringsInBock.GetStringByName('COMP')) then
      begin
        FLasFilesContents.GetContentByFile(FLasFiles.Items[i]).StringsInBock.GetStringByName('COMP').Value:=OrgForAdd.Name;
        FLasFilesContents.GetContentByFile(FLasFiles.Items[i]).StringsInBock.GetStringByName('COMP').State:=Detected;
        FLasFiles.Items[i].Organization:=OrgForAdd;
      end;
  ViewLasInListBox(CurrentLasFile);
end;

procedure TForm3.actAddCurvesToDBExecute(Sender: TObject);
var
  i:integer;
  Curve: TCurve;
  curve1:TLasCurve;
begin
if Assigned (CurrentLasFile) then
  with FLasFilesContents.GetContentByFile(CurrentLasFile).StringsInBock do
  for i:=0 to Count-1 do
    begin
      if ((Items[i].BlockName='~Curve Information') and (Items[i].State=NotDetected)) then
        begin
          Curve:=TCurve.Create(nil);
          Curve.ShortName:=Copy(Items[i].Name,1,Pos('.',Items[i].Name)-1);
          Curve.CurveUnit:=Copy(Items[i].Name, Pos('.',Items[i].Name)+1, Length(Items[i].Name)-Pos('.',Items[i].Name));
          Curve.Name:=Items[i].Comment;
          Curve.ID:=TMainFacade.GetInstance.AllCurves.Items[TMainFacade.GetInstance.AllCurves.Count-1].ID+1;
          TMainFacade.GetInstance.AllCurves.Add(Curve);
          TMainFacade.GetInstance.AllCurves.ItemsByID[Curve.ID].Update();
          Curve1:=TLasCurve.Create(nil);
          Curve1.Curve:=TMainFacade.GetInstance.AllCurves.ItemsByID[Curve.ID] as TCurve;
          CurrentLasFile.LasCurves.Add(Curve1);
          //curvel:=CurrentLasFile.LasCurves.Add as TLasCurve;
          //curvel.Curve :=TMainFacade.GetInstance.AllCurves.GetItemByName(Curve.Name) as TCurve;
          Items[i].State:=Detected;
          Curve.Free;
          Curve1.Free;
        end;
    end;
ViewLasInListBox(CurrentLasFile);
TMainFacade.GetInstance.AllCurves.Reload;
end;

procedure TForm3.actChangeOneCosingExecute(Sender: TObject);
var
  LasFile : TLasFile;
  i:integer;
  lfname : string;
begin
if Assigned (SelectedLasFile) then
  begin
    lfname:=SelectedLasFile.OldFileName;
    for i:=0 to FLasFilesContents.Count-1 do
      if FLasFilesContents.Items[i].LasFileName=lfname then
        begin
          FLasFilesContents.Remove(FLasFilesContents.Items[i]);
          break;
        end;
    //FLasFilesContents.Remove(FLasFilesContents.Items[FLasFilesContents.IndexOf()])

    //FLasFilesContents.Delete(FLasFilesContents.IndexOf(FLasFilesContents.GetContentByFile(CurrentLasFile)));
    //FLasFiles.GetItemByName()
    for i:=0 to FLasFiles.Count-1 do
    if FLasFiles.Items[i].OldFileName=lfname then
      begin
        GetLasFileContent(FLasFiles.Items[i], CurrentCoding);
        break;
      end;

    MakeTree;
  end;
end;

function TForm3.GetCurrentCoding: TEncoding;
begin
  if (rbOem.Checked) then Result:= encAscii else Result:= encAnsi;
end;

procedure TForm3.actChangeAllCodingExecute(Sender: TObject);
var
  LasFile : TLasFile;
  i,k:integer;
  lfname : string;
begin
  FreeAndNil(FLasFilesContents);
  FLasFilesContents:= TLasFileContents.Create;
  for i:=0 to FLasFiles.Count-1 do
  GetLasFileContent(FLasFiles.Items[i], CurrentCoding);
  MakeTree;
end;




end.
