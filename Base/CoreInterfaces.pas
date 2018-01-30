  {#Author fmarakasov@ugtu.net}
unit CoreInterfaces;

interface
uses
  Classes, ActnList;
type
  // Объекты, которые поддерживают режим просмотра
  // Вызов Preview должен регистрировать объект как "просмативаемый"
  // Вызов CloasePreview должен перевести статус объекта в начальное состояние
  IViewableObject = interface
  ['{F1D638A8-D95C-4742-A037-06F71D10B57B}']
    procedure Preview;
    procedure ClosePreview;
  end;

  // Объекты, которые поддерживают транзакционное редактирование
  // Вызов Open должен зарегистрировать объект как "находится на редактировании"
  // Вызов Save должен принять все изменения объекта и перевести статус объекта в начальное состояние
  // Вызов Cancel должен перевести статус объекта в начальное состояние
  // Вызов Reload должен обновить состояние объекта
  IEditableObject = interface
  ['{D6D4A26F-B06C-4fa6-9842-8792C037B581}']
    procedure Open;
    procedure Save;
    procedure Cancel;
    procedure Reload;
    procedure Delete;
  end;

  // Интерфейс описания промежутка времени
  ITimeSpan = interface (IInterface)
  ['{F3895D71-7D2A-4587-9FF8-A622E79ACF1A}']
    function GetTotalHours : Double;
    function GetTotalDays : Double;
    function GetWholeDays : Integer;
    function GetWholeYears : Integer;
    function GetWholeMonthes : Integer;
    function GetWholeWeeks : Integer;

    property TotalHours : Double read GetTotalHours;
    property TotalDays : Double read GetTotalDays;
    property WholeDays : Integer read GetWholeDays;
    property WholeYears : Integer read GetWholeYears;
    property WholeMonthes : Integer read GetWholeMonthes;
    property WholeWeeks : Integer read GetWholeWeeks;
  end;

  // Интерфейс даты и времени
  IDateTime = interface (IInterface)
  ['{C1B846A1-549E-4f71-B336-A75B5960B0C2}']
    function GetValue : TDateTime;
    function GetYear : Word;
    function GetMonth : Word;
    function GetDay : Word;
    function GetDayOfWeek : Word;
    function GetHour : Word;
    function GetMinute : Word;
    function GetSecond : Word;
    function GetMillisecond : Word;
    function GetYearLength : Word;
    function GetMonthLength : Word;

    function AddDays(Days : Double) : IDateTime;
    function AddMonthes(Monthes : Integer) : IDateTime;
    function AddWeeks(Weeks : Integer) : IDateTime;
    function AddYears (Years : Integer) : IDateTime;
    function Parse(const DateTimeString : string) : IDateTime;
    function EncodeDate(Year, Month, Day : Word) : IDateTime;
    function EncodeDateTime(Year, Month, Day, Hour, Minute, Second, MSecond : Word) : IDateTime;
    function Substract(const firstDateTime : IDateTime; const secondDateTime : IDateTime) : ITimeSpan;
    function Now : IDateTime;
    function Today : IDateTime;
    function IsLeapYear : Boolean;
    function GetLongDateString : String;
    function GetShortDateString : String;
    function GetLongTimeString : String;
    function GetFormatedDateTimeString ( const FormatString : String ) : String;
    function Between(DateTime1, DateTime2 : IDateTime): Boolean;
    function StrictBetween(DateTime1, DateTime2 : IDateTime): Boolean;


    property Year : Word read GetYear;
    property Month : Word read GetMonth;
    property Day : Word read GetDay;
    property DayOfWeek : Word read GetDayOfWeek;
    property Hour : Word read GetHour;
    property Minute : Word read GetMinute;
    property Second : Word read GetSecond;
    property Millisecond : Word read GetMillisecond;
    property Value : TDateTime read GetValue;
    property YearLength : Word read GetYearLength;
    property MonthLength : Word read GetMonthLength;
  end;

  INull = interface (IInterface)
  ['{17998808-10E3-4B54-9ACB-349B10C58167}']
    function IsNull : Boolean;
  end;

  ILogger = interface
  ['{19EE60DB-C03B-4f5f-BA53-7A6A64C97F2C}']
    procedure LogMessage(const Message : String);
  end;

  IUIComponent = interface (IInterface)
  ['{C80293FE-32D0-413a-8D3F-3E91BD672755}']
    function GetUICaption : String;
    property UICaption : String read GetUICaption;
  end;


  ///
  ///  Интерфейс для отправки сообщений через шлюз электронной почты
  ///
  IMail = interface
  ['{37AD942A-1729-441b-BF72-39B38B74F366}']
     procedure SendMail(Subject : String; Body : String; FromAddress : String; ToAddress : String);
  end;

  ///
  ///  Интерфейс провайдера подключения
  ///
  ILoginProvider = interface
  ['{101FEFE0-8F45-4056-ACD9-7C4F89C6D592}']
    function Connect(const Login, Password : String) : Boolean;
  end;

  ///
  ///  Интерфейс запроса имени пользователя и пароля
  ///
  ILoginQuery = interface
  ['{4D53AA63-2D54-4c75-BC15-7A223E5E08D7}']
    ///
    ///  Вызывает запрос параметров подключения, передавая в качестве
    ///  аргумента объект интерфейса, который будет обеспечивать
    ///  проверку аргументов подключения
    ///  Возвращает истина, если подключение прошло успешно.
    ///  Во всех остальных ситуациях возвращается ложь.
    function QueryCredentails(LoginProvider : ILoginProvider) : Boolean;
  end;
  ///
  ///  Интерфейс запроса строки подключения
  ///
  ISIDProvider = interface
  ['{0AC49413-1495-446c-9A53-CCFA33E26D94}']
    function GetSID:String;
  end;
  ///
  ///
  ///  Интерфейс конфигурации OPC сервера
  ///
  IOPCServerConfig = interface
  ['{E428802A-F13F-47d5-AFE9-958ACEE856BB}']
    function GetOPCHostName:String;
    function GetOPCServerName:String;
    procedure SetOPCServerName(Value : String);
    procedure SetOPCHostName(Value : String);
    ///
    ///  Получает или устанавливает имя хоста, где размещается OPC сервер
    ///
    property OPCHostName:String read GetOPCHostName write SetOPCHostName;
    ///
    ///  Получает или устанавливает имя  OPC сервера к которому производится подключение
    ///
    property OPCServerName:String read GetOPCServerName write SetOPCServerName;
  end;


  POPCRecordData = ^TOPCRecordData;
  ///
  ///  Запись OPC HDA
  ///
  TOPCRecordData = record
    ///
    ///  Значение элемента
    ///
    Value : Variant;
    ///
    ///  Метка времени
    ///
    TimeStamp : TDateTime;
    ///
    ///  Маска качества сигнала
    ///
    Quality : Integer;
    ///
    ///  Индекс элемента
    ///
    RecordIndex : Integer;
    ///
    /// Истина, если сигнал качественный
    ///
    IsQualityRaw : Boolean;
  end;

  IOPCTagInfo = interface
  ['{DE3CEE05-F30F-4DFC-BE26-037B4502BBB8}']
    function  GetTagName : String;
    procedure SetTagName(const Value : String);
    function  GetTagDescription : String;
    function  GetPCU: string;
    function  GetRealTagName: string;

    ///
    ///  Получить имя PCU
    ///
    property PCU: string read GetPCU;
    ///
    ///  Получить имя реального тэга OPC
    ///
    property RealTag: string read GetRealTagName;
    ///
    ///  Получить или установить имя тэга, которое используется в
    ///  качестве ключа в интерфейса IOPCHDAHistoryProvider
    ///
    property TagName:String read GetTagName write SetTagName;
    ///
    ///  Описание тэга
    ///
    property Description:String read GetTagDescription;
  end;

  ///
  ///  Интерфейс поддержки графического интерфейса выбора OPC HDA тега
  ///
  IOPCHDABrowserUI = interface
    ['{7BC36481-E90B-4062-BD37-4AABBBDB39B2}']
    ///
    ///  Устанавливает в графическом интерфейсе текущий элемент
    ///
    procedure SetSelected(const Value : String);
    /// Открывает графическое представление для навигации по тэгам.
    ///  возвращает интерфейс описания тега, выбранного пользователем или
    ///  nil в случае  отказа от выбора
    function Select : IOPCTagInfo;
  end;

  ///
  ///  Провайдер получения доступных имён тэгов OPC HDA
  ///
  IOPCHDATagsProvider = interface
  ['{8DF99812-1465-44C2-BAA9-1DBA9CFBE91D}']
    ///
    ///  Возвращает список тэгов OPC HDA
    ///
    function GetOPCHDATags : TStrings;

    property OPCHDATags : TStrings read GetOPCHDATags;
  end;
  ///
  ///
  ///  Провайдер действий. Обеспечивает информацией компоненты типа TActionPanel
  ///  о поддерживаемом классом списке действий и категориях действий
  ///
  IActionsProvider = interface
  ['{EA49C564-6E1B-45cf-A2A6-61EE78C77C23}']
     function GetMyActions : TActionList;
     function GetMyCategories : TStrings;
     ///
     ///  Список поддерживаемых объектом действий
     ///
     property MyActions : TActionList read GetMyActions;
     ///
     ///  Список поддерживаемых объектом категорий
     ///  Если список категорий пуст или nil, то считается, что поддерживаются
     ///  все категории
     ///
     property MyCategories : TStrings read GetMyCategories;
  end;


implementation


end.

