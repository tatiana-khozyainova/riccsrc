unit LoggerImpl;
    {#Author fmarakasov@ugtu.net}
interface

uses
  Forms, Windows, CoreInterfaces, Classes, DateTimeCore, SysUtils, StdCtrls;
type

  ///
  ///  Класс журналирования без журналирования
  ///
  TNullLogger = class (TInterfacedObject, ILogger)
  protected
    procedure LogMessage(const Message : String);
  private
    constructor Create;
  public
    class function GetInstance: TNullLogger;
  end;

  ///
  ///  Класс журналирования в список строк в памяти
  TMemoryLogger = class (TInterfacedObject, ILogger)
  private
    FStrings : TStrings;
    function FormatMessage(const Value : String) : String;
  protected
    procedure LogMessage(const Message : String);
  private
    constructor Create;
  public
    class function GetInstance: TMemoryLogger;
    property Log : TStrings read FStrings;
  end;

  ///
  ///  Класс журналирования без журналирования с выводом на экран
  ///
  TScreenLogger = class (TInterfacedObject, ILogger)
  protected
    procedure LogMessage(const Message : String);
  private
    constructor Create;
  public
    class function GetInstance: TScreenLogger;
  end;

  ///
  ///  Класс журналирования в текстовый файл
  ///
  TFileLogger = class (TInterfacedObject, ILogger)
  private
    FTextFile : TextFile;
    function GetSessionFileName : String;
  protected
    procedure LogMessage(const Message : String);
  private
    constructor Create;
  public
    class function GetInstance: TFileLogger;
  end;

  ///
  ///  Класс журналирования в список немодального окна
  ///
  TMemoLogger = class (TInterfacedObject, ILogger)
  protected
    procedure LogMessage(const Message : String);
  private
    FForm : TForm;
    FMemo : TMemo;
    FNumber : Integer;
    constructor Create;
    procedure Init;
  public
    destructor Destroy;override;
    class function GetInstance: TMemoLogger;
  end;



  TLoggerSupportComponent = class (TComponent)
  private
    FLogger : ILogger;
    function GetLogger : ILogger;
  protected
    procedure LogMessage(const Message : String);virtual;
  public
    constructor Create(AOwner : TComponent);override;
    property Logger: ILogger read GetLogger write FLogger;
  end;

implementation
uses
  ShellAPI, ShlObj, Controls, ExceptionExt;

{ TNullLogger }

procedure TNullLogger.LogMessage(const Message: String);
begin
  // Foo Implementation!
end;

constructor TNullLogger.Create;
begin
  inherited;
end;

class function TNullLogger.GetInstance: TNullLogger;
const FInstance:TNullLogger = nil;
begin
  If FInstance = nil Then
    FInstance := LoggerImpl.TNullLogger.Create();

  FInstance._AddRef;
  Result := FInstance;
end;

constructor TMemoryLogger.Create;
begin
  inherited;
  FStrings := TStringList.Create;
end;

function TMemoryLogger.FormatMessage(const Value: String): String;
var
  DateTime : IDateTime;
begin
  DateTime := TDateTimeBase.CreateNow;
  Result := Format('[%s] %s', [DateTime.GetFormatedDateTimeString('dd/mm/yyyy hh:nn:ss'), Value]);
end;

class function TMemoryLogger.GetInstance: TMemoryLogger;
const FInstance:TMemoryLogger = nil;
begin
  If FInstance = nil Then
  begin
    FInstance := LoggerImpl.TMemoryLogger.Create();
  end;
  FInstance._AddRef;
  Result := FInstance;
end;

procedure TMemoryLogger.LogMessage(const Message: String);
begin
  FStrings.Add(FormatMessage(Message));
end;

constructor TScreenLogger.Create;
begin
  inherited;
end;

class function TScreenLogger.GetInstance: TScreenLogger;
const FInstance:TScreenLogger = nil;
begin
  If FInstance = nil Then
    FInstance := LoggerImpl.TScreenLogger.Create();
  FInstance._AddRef;
  Result := FInstance;
end;

procedure TScreenLogger.LogMessage(const Message: String);
begin
  MessageBox(0, PChar(Message), PChar(Application.Title), MB_OK or MB_ICONINFORMATION);
end;

{ TFileLogger }

procedure TFileLogger.LogMessage(const Message: String);
begin
   // TODO: Реализовать!
  TExceptionsFactory.RaiseNotImplemented;
end;

constructor TFileLogger.Create;
begin
  inherited;
  AssignFile(FTextFile, GetSessionFileName);
  Rewrite(FTextFile);
end;

class function TFileLogger.GetInstance: TFileLogger;
const FInstance:TFileLogger = nil;
begin
  If FInstance = nil Then
  begin
    FInstance := LoggerImpl.TFileLogger.Create();
  end;
  FInstance._AddRef;
  Result := FInstance;
end;

function TFileLogger.GetSessionFileName: String;
var
  SpecialFolerPath : PAnsiChar;
begin
  SpecialFolerPath := ''; 
  Assert(SHGetSpecialFolderPath(0, SpecialFolerPath, CSIDL_APPDATA, TRUE), 'Failed retreive special folder path!');
end;

constructor TMemoLogger.Create;
begin
  inherited;
  FForm := nil;
  FNumber := 1;
end;

destructor TMemoLogger.Destroy;
begin
  //FreeAndNil(FForm);
  //FInstance := nil;
  inherited;
end;

class function TMemoLogger.GetInstance: TMemoLogger;
const FInstance:TMemoLogger = nil;
begin
  If FInstance = nil Then
  begin
    FInstance := LoggerImpl.TMemoLogger.Create();
  end;
  FInstance._AddRef;
  Result := FInstance;
end;

procedure TMemoLogger.Init;
begin
  if FForm = nil then
  begin
    FForm := TForm.Create(nil);
    FForm.Caption := 'Окно протокола ' + Application.Title;
    FMemo := TMemo.Create(FForm);
    FMemo.Parent := FForm;
    FMemo.Align := alClient;
    FForm.FormStyle := fsStayOnTop;
    FMemo.ScrollBars := ssBoth;
  end;
end;

procedure TMemoLogger.LogMessage(const Message: String);
begin
  if (Application.Terminated) then Exit;
  Init;
  FForm.Show;
  FMemo.Lines.Add(Format('[%d][%s] %s', [FNumber, FormatDateTime('hh:nn:ss:zzz', Time), Message]));
  Inc(FNumber);
  FMemo.Update;
end;

{ TLoggerSupportComponent }

constructor TLoggerSupportComponent.Create(AOwner: TComponent);
begin
  inherited;
  FLogger := nil;
end;

function TLoggerSupportComponent.GetLogger: ILogger;
begin
  if FLogger = nil then FLogger := TNullLogger.GetInstance;
  Result := FLogger;
end;

procedure TLoggerSupportComponent.LogMessage(const Message: String);
begin
  Logger.LogMessage('The message form ' + Self.ClassName + ' is:' + Message);
end;


end.
