unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonObjectSelectFilter, ComCtrls, ToolWin, ImgList, ActnList,
  Menus, StdCtrls, ShellAPI, TlHelp32,DateUtils;

type
  TfrmMain = class(TForm)
    actnLst: TActionList;
    actnTryConnect: TAction;
    actnCloseMainForm: TAction;
    actnHelp: TAction;
    actnEditSimpleDicts: TAction;
    imgLst: TImageList;
    btnRun: TButton;
    actRun: TAction;
    lvClient: TListView;
    pmtray: TPopupMenu;
    H1: TMenuItem;
    N1: TMenuItem;
    txtHello: TStaticText;
    procedure actnTryConnectExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure H1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    function GetFileVersion(const FileName: String): String;
  private
    { Private declarations }
    FIconData:TNotifyIconData;
    FClientList:OleVariant;
    function GetRunParam:string;
  protected
    procedure WndProc(var Msg: TMessage); Override;
    procedure ControlWindow(var Msg: TMessage); message WM_SYSCOMMAND;
  public
    { Public declarations }
    property ClientList:OleVariant read FClientList write FClientList;
    procedure   ReloadData(Sender: TObject);
    function FindTask(ExeFileName: string): integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
  end;

var
  frmMain: TfrmMain;

implementation

uses PasswordForm, Facade, ReadCommandLine;

{$R *.dfm}

procedure TfrmMain.actnTryConnectExecute(Sender: TObject);
const cnMaxUserNameLen = 254;
var sUserName: string;
dwUserNameLen: DWORD;
query_s:string;
i,j,picon,stepcl,buf:Integer;
AResult:OleVariant;
cIcon:TIcon;
n:DWORD;

var ListItem:TListItem;
begin

  if TMainFacade.GetInstance.Authorize then
  begin
    TMainFacade.GetInstance.DBGates.FetchPriorities(actnLst);
    txtHello.Caption:='   Здравствуйте '+TMainFacade.getinstance.DBGates.EmployeeName+'.';
    sUserName:=TMainFacade.getinstance.DBGates.EmployeeTabNumber;
    query_s:='SELECT Client_App_Type_ID, vch_Client_App_Type, vch_Employee_Full_Name,'+
    'NUM_PRIORITY_LEVEL, NUM_ACCESSIBLE_CLIENTS_COUNT, EMPLOYEE_ID, User_Group_ID,'+
    'VCH_DBLOGIN, VCH_DBPASSWORD, VCH_CLIENT_PATH FROM spd_Enum_Client_Types ('''+
    Trim(sUserName) +''','''')';
    lvClient.Clear;
    ListItem:=TListItem.Create(lvClient.Items);
    if (TMainFacade.GetInstance.DBGates.ExecuteQuery(query_s,AResult)>0) then
    begin
      cIcon:=TIcon.Create;
      ClientList:=AResult;
      stepcl:=0;
      for i:=VarArrayLowBound(ClientList,2) to VarArrayHighBound(ClientList,2)  do
      begin
        if  (VarToStr(ClientList[6,i])<>'') and (VarToStr(ClientList[0,i])<>'24') and (VarToStr(ClientList[9,i])<>'') then
        begin
        cIcon.Handle:=ExtractIcon(HInstance,PAnsiChar(Trim(ClientList[9,i])),0);
        ListItem:=lvClient.Items.Add;
        picon:=imgLst.AddIcon(cIcon);
        ListItem.ImageIndex:=picon;
        ListItem.Caption:=VarToStr(ClientList[1,i]);
        buf:=VarAsType(ClientList[0,i],varInt64);
        ListItem.Data:=TObject(buf);
        ListItem.SubItems.Text:=string(GetFileVersion(Trim(ClientList[9,i])))+' от '+DateToStr(FileDateToDateTime(FileGetDate(FileOpen(Trim(ClientList[9,i]),fmShareDenyNone))));
        end;
      end;
    end;
  end;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin

  inherited;

  with FIconData do
  begin
    cbSize:=SizeOf(FIconData);
    Wnd:=Handle;
    uID:=1;
    uFlags:=NIF_MESSAGE+NIF_ICON+NIF_TIP;
    uCallbackMessage:=WM_USER+1;
    hIcon:=frmMain.Icon.Handle;
    szTip:='Загрузчик';
  end;
  Application.Icon.Handle:=frmMain.Icon.Handle;

end;

function TfrmMain.FindTask(ExeFileName: string): integer;
 var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
 begin
  result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
   begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName))
     or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName)))
    then Result := 1;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
   end;
  CloseHandle(FSnapshotHandle);
 end;

function TfrmMain.GetFileVersion(const FileName: String): String;
var
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := '';
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          Result := IntToStr(FI.dwFileVersionMS shr 16) + '.' +
          IntToStr(FI.dwFileVersionMS and $FFFF) + '.'+
          IntToStr(FI.dwFileVersionLS shr 16) + '.'+
          IntToStr(FI.dwFileVersionLS and $FFFF);
     finally
        FreeMem(VerBuf);
     end;
  end;
end;

procedure TfrmMain.actRunExecute(Sender: TObject);
var ListItem:TListItem;
si: TStartupInfo;
pi: TProcessInformation;
i,j:Integer;
exefile:string;
begin
if lvClient.ItemIndex<>-1 then
begin
ListItem:=TListItem.Create(lvClient.Items);
for i:=VarArrayLowBound(ClientList,2) to VarArrayHighBound(ClientList,2)  do
if VarAsType(ClientList[0,i],varInt64)=Integer(lvClient.Selected.Data) then
begin
Break;
end;

exefile:=Trim(ClientList[9,i]);
while Pos('\',exefile)<>0 do
begin
  Delete(exefile,1,Pos('\',exefile));
end;

if FindTask(Trim(exefile))>0 then
Application.MessageBox('Приложение уже запущено!','Внимание',MB_OK+MB_ICONINFORMATION)
else
begin

ShellExecute(frmMain.Handle, nil, PAnsiChar(Trim(ClientList[9,i])), PAnsiChar(GetRunParam), nil, SW_SHOWNORMAL);


if FindTask(Trim(exefile))>0 then
begin
Shell_NotifyIcon(NIM_ADD, @FIconData);
ShowWindow(frmMain.Handle, SW_HIDE);
end;
end;
end
else
Application.MessageBox('Выберите запускаемое приложение!','Внимание',MB_OK+MB_ICONINFORMATION);
end;

destructor TfrmMain.Destroy;
begin
  Shell_NotifyIcon(NIM_DELETE, @FIconData);
  inherited Destroy;
end;

procedure TfrmMain.WndProc(var Msg: TMessage);
var
  P: TPoint;
begin
  if Msg.Msg=WM_USER+1 then begin
    case Msg.LParam of
      WM_LBUTTONDOWN:
        begin
        end;
      WM_RBUTTONDOWN:
        begin
          SetForegroundWindow(Handle);
          GetCursorPos(P);
          pmtray.Popup(P.X,P.Y);
          PostMessage(Handle,WM_NULL,0,0);
        end;
      WM_LBUTTONDBLCLK:
        begin
          ShowWindow(frmMain.Handle, SW_SHOW);
        end;
    end;
  end;
  inherited;
end;


procedure TfrmMain.ReloadData(Sender: TObject);
begin
  // здесь перезагружаем куда следует, что следует
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  if not TMainFacade.GetInstance.DBGates.Autorized then actnTryConnect.Execute;
end;

procedure TfrmMain.H1Click(Sender: TObject);
begin
ShowWindow(frmMain.Handle, SW_SHOW);
end;

procedure TfrmMain.N1Click(Sender: TObject);
begin
Close;
end;

procedure TfrmMain.ControlWindow(var Msg: TMessage);
begin
  case Msg.WParam of
    SC_MINIMIZE:
    begin
      ShowWindow(frmMain.Handle, SW_HIDE);
      Shell_NotifyIcon(NIM_ADD, @FIconData);
    end;
    SC_CLOSE:
    begin
      ShowWindow(frmMain.Handle, SW_HIDE);
      frmMain.Hide;Shell_NotifyIcon(NIM_ADD, @FIconData);
    end;
    else
      inherited;
  end;
end;

function TfrmMain.GetRunParam:string;
begin
Result:='';
if Assigned(TCommandLineParams.GetInstance.FindParam('-u')) then Result:='-u '+TCommandLineParams.GetInstance.ParamValues['-u'];
if Assigned(TCommandLineParams.GetInstance.FindParam('-test')) then Result:=Result+' -test';
end;

end.


