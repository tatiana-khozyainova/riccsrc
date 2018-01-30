unit DateTimeCore;
    {#Author fmarakasov@ugtu.net}
interface
uses
  CoreInterfaces;
type
  TDateTimeBase = class (TInterfacedObject, IDateTime)
  private
    FDOW : Word;
    FValue : TDateTime;
    FYear : Word;
    FMonth : Word;
    FDay : Word;
    FMinute : Word;
    FHour : Word;
    FSecond : Word;
    FMillisecond : Word;
    FLeapYear : Boolean;
    procedure InitVars;
    function AddYearsInternal(Years : Word) : TDateTime;
  protected
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
  public
    constructor Create(DateTimeValue : TDateTime);
    class function CreateNow:IDateTime;
    class function CreateToday:IDateTime;
    class function CreateParse( const DateTimeString : string) : IDateTime;
    class function TestIsLeapYear(Year : Word) : Boolean;
    class function CreateEncodeDate(Year, Month, Day : Word) : IDateTime;
    class function CreateEncodeDateTime(Year, Month, Day, Hour, Minute, Second, MSecond : Word) : IDateTime;
    class function GetLengthOfTheMonth(Year : Word; Month : Integer): Word;
    class function GetLengthOfTheYear(Year : Word): Word;
  end;
implementation
uses
  SysUtils;


{ TDateTime }

function TDateTimeBase.AddDays(Days: Double): IDateTime;
begin
  Result := TDateTimeBase.Create(FValue + Days);
end;

function TDateTimeBase.AddMonthes(Monthes: Integer): IDateTime;
var
  ResultDateTime : TDateTime;
  Rest : Word;
  I: Integer;
  CurrentYear : Word;
  CurrentMonth : Word;
begin
  if Monthes > 11 then
  begin
    ResultDateTime := AddYearsInternal(Monthes div 12);
    Rest := Monthes mod 12;
  end
  else
  begin
    ResultDateTime := FValue;
    Rest := Monthes;
  end;

  CurrentYear := Self.Year;
  CurrentMonth := Self.Month;

  I := 1;
  while I <= Rest  do
  begin
    ResultDateTime := ResultDateTime + GetLengthOfTheMonth(CurrentYear, CurrentMonth);
    Inc(CurrentMonth);
    if (CurrentMonth > 12) then
    begin
      CurrentMonth := 1;
      Inc(CurrentYear);
    end;
    Inc(I);
  end;
  Result := TDateTimeBase.Create(ResultDateTime);
end;

function TDateTimeBase.AddWeeks(Weeks: Integer): IDateTime;
begin
  Result := AddDays(7 * Weeks);
end;

function TDateTimeBase.AddYears(Years: Integer): IDateTime;
begin
  Result := TDateTimeBase.Create(AddYearsInternal(Years));
end;

function TDateTimeBase.AddYearsInternal(Years: Word): TDateTime;
var
  I: Integer;
begin
  Result := Self.Value;
  for I := 0 to Years - 1 do
  begin
    Result := Result + GetLengthOfTheYear(Self.Year + I);
  end;
end;

function TDateTimeBase.Between(DateTime1, DateTime2: IDateTime): Boolean;
begin
  Assert((DateTime1<>nil) and (DateTime2 <> nil));
  Result := (Self.Value >= DateTime1.Value) and (Self.Value <=DateTime2.Value);
end;

constructor TDateTimeBase.Create(DateTimeValue: TDateTime);
begin
  Self.FValue := DateTimeValue;
  InitVars;
end;

class function TDateTimeBase.CreateEncodeDate(Year, Month,
  Day: Word): IDateTime;
begin
  Result := TDateTimeBase.Create(SysUtils.EncodeDate(Year, Month, Day));
end;

class function TDateTimeBase.CreateEncodeDateTime(Year, Month, Day, Hour,
  Minute, Second, MSecond: Word): IDateTime;
begin
  Result := TDateTimeBase.Create(SysUtils.EncodeDate(Year, Month, Day) + SysUtils.EncodeTime(Hour, Minute, Second, MSecond));
end;

class function TDateTimeBase.CreateNow: IDateTime;
begin
  Result := TDateTimeBase.Create(SysUtils.Now);
end;

class function TDateTimeBase.CreateParse(
  const DateTimeString: string): IDateTime;
begin
  Result := TDateTimeBase.Create(StrToDateTime(DateTimeString));
end;

class function TDateTimeBase.CreateToday: IDateTime;
begin
  Result := TDateTimeBase.Create(SysUtils.Date);
end;

function TDateTimeBase.EncodeDate(Year, Month, Day: Word): IDateTime;
begin
  Result := CreateEncodeDate(Year, Month, Day);
end;

function TDateTimeBase.EncodeDateTime(Year, Month, Day, Hour, Minute, Second,
  MSecond: Word): IDateTime;
begin
  Result := CreateEncodeDateTime(Year, Month, Day, Hour, Minute, Second, MSecond);
end;

function TDateTimeBase.GetValue: TDateTime;
begin
  Result := FValue;
end;

function TDateTimeBase.GetDay: Word;
begin
  Result := FDay;
end;

function TDateTimeBase.GetDayOfWeek: Word;
begin
  Result := FDOW;
end;

function TDateTimeBase.GetFormatedDateTimeString(
  const FormatString: String): String;
begin
  Result := FormatDateTime(FormatString, FValue);
end;

function TDateTimeBase.GetHour: Word;
begin
  Result := FHour;
end;

function TDateTimeBase.GetLongDateString: String;
begin
  Result := '';
end;

function TDateTimeBase.GetLongTimeString: String;
begin
  Result := '';
end;

function TDateTimeBase.GetMillisecond: Word;
begin
  Result :=FMillisecond;
end;

function TDateTimeBase.GetMinute: Word;
begin
  Result := FMinute;
end;

function TDateTimeBase.GetMonth: Word;
begin
  Result := FMonth;
end;

class function TDateTimeBase.GetLengthOfTheMonth(Year: Word; Month: Integer): Word;
const
  MonthLength : array[1..12] of Word = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := MonthLength[Month];
  if (Month = 2) and (TestIsLeapYear(Year)) then Inc(Result);
end;

class function TDateTimeBase.GetLengthOfTheYear(Year: Word): Word;
begin
  if TestIsLeapYear(Year) then
    Result := 366
  else
    Result := 365;
end;

function TDateTimeBase.GetMonthLength: Word;
begin
  Result := GetLengthOfTheMonth(Self.Year, Self.Month);
end;

function TDateTimeBase.GetSecond: Word;
begin
  Result := FSecond;
end;

function TDateTimeBase.GetShortDateString: String;
begin
  Result := '';
end;

function TDateTimeBase.GetYear: Word;
begin
  Result := FYear;
end;

function TDateTimeBase.GetYearLength: Word;
begin
  Result := GetLengthOfTheYear(Self.Year);
end;

procedure TDateTimeBase.InitVars;
begin
  FLeapYear := DecodeDateFully(FValue, FYear, FMonth, FDay, FDOW);
  DecodeTime(FValue, FHour, FMinute, FSecond, FMillisecond);
end;

function TDateTimeBase.IsLeapYear: Boolean;
begin
  Result := FLeapYear;
end;

function TDateTimeBase.Now: IDateTime;
begin
  Result := TDateTimeBase.CreateNow;
end;

function TDateTimeBase.Parse(const DateTimeString: string): IDateTime;
begin
  Result := TDateTimeBase.CreateParse(DateTimeString);
end;

function TDateTimeBase.StrictBetween(DateTime1, DateTime2: IDateTime): Boolean;
begin
  Assert((DateTime1 <> nil) and (DateTime2 <> nil));
  Result := (Self.Value > DateTime1.Value) and (Self.Value < DateTime2.Value);
end;

function TDateTimeBase.Substract(const firstDateTime,
  secondDateTime: IDateTime): ITimeSpan;
begin
  Result := nil;
end;

class function TDateTimeBase.TestIsLeapYear(Year: Word): Boolean;
begin
  Result := SysUtils.IsLeapYear(Year);
end;

function TDateTimeBase.Today: IDateTime;
begin
  Result := TDateTimeBase.CreateToday;
end;

end.
