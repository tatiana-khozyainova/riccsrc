unit StringUtils;

interface

uses
  Windows,
  Sysutils,
  StrUtils,
  Classes,
  Variants;

type
  TSetOfChar = set of char;

const
  NumberSet = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  RestrictedCharacters: string = '<>"/|?*';

function GetLastErrorMessage:String;

function FormatedWin32Error(const ObjName:String):String;

function CreateTempFileName(const Prefix:String):String;

// Проверяет наличие в строке не поддерживаемых файловой системой символов
function IsProperlyPath(const Path:string):Boolean;

function TrunkStringIfLonger(var S:string; MaxLength:Integer):string;

// Проверяет последний символ в строке и добавляет, если он не C
function AddLastCharIfNotExists(var S:string; C:Char):String;overload;
function AddLastCharIfNotExists(var S:WideString; C:WideChar):WideString;overload;

function ReplaceLatChar(const C:Char):Char;
function ReplaceCyrChar(const C: Char): Char;
function ReplaceLatSymbols(const S:string):string;
function ReplaceCyrSymbols(const S:string):string;


function IsLat(const S:string):Boolean;
function IsCyr(const S:string):Boolean;

// Принимает строку символов. Если в строке содержаться только
// латинские либо только кириллица, то возвращается исходная строка
// Если есть и кириллица и латиница, то возвращается  строка с заменнёнными
// на кириллицу латинские буквы похожего начертания.
function MakeLanguageProperlyString(const S:String):String;

function MetaphoneTransletter(const S: string; const ATruncStart: integer = -1; const ATruncCount: integer = -1): string;


function FormatNumber(const Value:Double):string;

function SubStrCount(const SrcString:string; const substr:string):integer;

function Split(S: string; Delimiter: char): Variant;  overload;
function Split(S: string; Delimiters: TSetOfChar): Variant; overload;
procedure Split(S: string; Delimiters: TSetOfChar; List: TStrings); overload;

function PadSymbolL(Src: string; ASymbol: Char; Lg: Integer): string;




implementation

function
PadSymbolL(Src: string; ASymbol: Char; Lg: Integer): string;
begin
  Result := Src;
  while Length(Result) < Lg do
    Result := ASymbol + Result;
end;


const
  MetaphoneStep1ForReplace: array[0 .. 10] of string = ('ЙО', 'ИО', 'ЙЕ', 'ИЕ', 'О', 'Ы', 'Я', 'Е', 'Ё', 'Э', 'Ю');
  MetaphoneStep1Replacements: array[0 .. 10] of string = ('И', 'И', 'И', 'И', 'А', 'А', 'А', 'И', 'И', 'И', 'И');

  MetaphoneStep2ForReplace: array[0 .. 4] of string = ('Б', 'З', 'Д', 'В', 'Г');
  MetaphoneStep2Replacements: array[0 .. 4] of string = ('П', 'С', 'Т', 'Ф', 'К');

  MetaphoneStep3ForReplace: array[0 .. 0] of string = ('ТС');
  MetaphoneStep3Replacements: array[0 .. 0] of string = ('Ц');

function MetaphoneTransletter(const S: string; const ATruncStart: integer = -1; const ATruncCount: integer = -1): string;
var i: integer;
begin
  Result := AnsiUpperCase(S);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
  
  for i := Low(MetaphoneStep1ForReplace) to High(MetaphoneStep1ForReplace) do
    Result := StringReplace(Result, MetaphoneStep1ForReplace[i], MetaphoneStep1Replacements[i], [rfReplaceAll]);

  for i := Low(MetaphoneStep2ForReplace) to High(MetaphoneStep2ForReplace) do
    Result := StringReplace(Result, MetaphoneStep2ForReplace[i], MetaphoneStep2Replacements[i], [rfReplaceAll]);

  for i := Low(MetaphoneStep3ForReplace) to High(MetaphoneStep3ForReplace) do
    Result := StringReplace(Result, MetaphoneStep3ForReplace[i], MetaphoneStep3Replacements[i], [rfReplaceAll]);

  if (ATruncStart > -1) and (ATruncCount > 0) then
    Result := copy(Result, ATruncStart, ATruncCount);
end;

function GetLastErrorMessage:String;
var
 Msg:array[0..255] of char;
 Num:DWORD;
begin
 Result:='';
 Num:=FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, GetLastError(), LANG_NEUTRAL,
                    Msg, 255, nil);

 if Num > 0 then
 begin
   SetLength(Result, Num);
   StrCopy(PChar(Result), Msg);
 end;
end;

function CreateTempFileName(const Prefix:String):String;
var
  sPath:array[0..MAX_PATH] of char;
  sBuff:array[0..MAX_PATH] of char;
  iLen :Integer;
begin
  Result:='';
  iLen:=GetTempPath(MAX_PATH, sPath);
  if iLen > 0 then
  begin
    GetTempFileName(sPath, PChar(Prefix), 0, sBuff);
    Setlength(Result, StrLen(sBuff));
    StrCopy(PChar(Result), sBuff);
  end;
end;

const
  Reserved = '<>:"/\|*?';

function IsProperlyPath(const Path:string):Boolean;
var
  i :Integer;
begin
  Result:=False;
  if Length(Path) > 0 then
     if Length(Path) <= MAX_PATH then
        begin
          Result:=True;
          for i:=0 to Length(Reserved) do
              Result:=Result and (Pos(Reserved[i], Path) = 0);
        end;
end;


type
  TCyrSet = 'А'..'я';
  TLatSet = 'A'..'z';

function IsLat(const S:string):Boolean;
var
  i:Integer;
begin
  Result:=True;
  for i:=1 to Length(S) do
  begin
    Result:=Result and ((S[i] < Low(TCyrSet)) or (S[i] > High(TCyrSet))) ;
    if not Result then Exit;
  end;
end;

function IsCyr(const S:string):Boolean;
var
  i:Integer;
begin
  Result:=True;
  for i:=1 to Length(S) do
  begin
    Result:=Result and ((S[i] < Low(TLatSet)) or (S[i] > High(TLatSet))) ;
    if not Result then Exit;
  end;
end;



const
  SourceCyr:array[0..15] of char =  ('а', 'А', 'с', 'С', 'м',
                                     'М', 'Т', 'о', 'О', 'р',
                                     'Р', 'В', 'у', 'К', 'Е',
                                     'Н');

  AccordLat:array[0..15] of char =  ('a', 'A', 'c', 'C', 'm',
                                     'M', 'T', 'o', 'O', 'p',
                                     'P', 'B', 'y', 'K', 'E',
                                     'H');

function ReplaceLatChar(const C:Char):Char;
var
  i:Integer;
begin
  Result:=C;
  for i:=Low(AccordLat) to High(AccordLat) do
     if C = AccordLat[i] then
     begin
       Result:=SourceCyr[i];
       Exit;
     end;
end;

function ReplaceCyrChar(const C: Char): Char;
var
  i:Integer;
begin
  Result:=C;
  for i:=Low(SourceCyr) to High(SourceCyr) do
     if C = SourceCyr[i] then
     begin
       Result:=AccordLat[i];
       Exit;
     end;
end;

function ReplaceLatSymbols(const S:string):string;
var
  i:Integer;
begin
  SetLength(Result, Length(S));
  for i:=1 to Length(S) do
     Result[i]:=ReplaceLatChar(S[i]);
end;

function ReplaceCyrSymbols(const S:string):string;
var
  i:Integer;
begin
  SetLength(Result, Length(S));
  for i:=1 to Length(S) do
     Result[i]:=ReplaceCyrChar(S[i]);
end;

function MakeLanguageProperlyString(const S:String):String;
begin
  if (IsLat(S)) then Result:=S //Строка не содержит русских символов.
  else
     if (IsCyr(S)) then Result:=S // Строка не содержит латинских символов.
     else
        // Строка содержит и русские и латинские символы.
        // Будем заменять. Латинские на русские.
        Result:= ReplaceLatSymbols(S);
end;


function TrunkStringIfLonger(var S:string; MaxLength:Integer):string;
begin
  if Length(S) > MaxLength then SetLength(S, MaxLength);
  Result:=S;
end;


function FormatNumber(const Value:Double):string;
begin
  Result:=Format('%n', [Value]);
end;


function FormatedWin32Error(const ObjName:String):String;
begin
  Result:=Format('Ошибка исполнения: %s Объект: %s', [GetLastErrorMessage, ObjName]);
end;

function AddLastCharIfNotExists(var S:string; C:Char):String;
begin
  if Length(S) > 0 then
    if S[Length(S)-1] <> C then S:=S+C;
  Result:=S;
end;

function AddLastCharIfNotExists(var S:WideString; C:WideChar):WideString;
begin
  if Length(S) > 0 then
    if S[Length(S)-1] <> C then S:=S+C;
  Result:=S;
end;


function SubStrCount(const SrcString:string; const substr:string):integer;
var
  ip:Integer; // Позиция
begin
  Result:=0;
  ip := 0;
  if SrcString <> '' then
  begin
    repeat
      ip := PosEx(substr, SrcString, ip + 1);
      if ip > 0 then begin  inc(Result); inc(ip); end;
    until (ip = 0);
  end;
end;

procedure Split(S: string; Delimiters: TSetOfChar; List: TStrings);
var i, iLast: integer;
begin
  Assert(List <> nil, 'Список для выгрузки набора строк не задан');

  iLast := 1;
  for i := 1 to Length(S) do
  if (S[i] in Delimiters) or (i = Length(S)) then
  begin
    List.Add(trim(copy(S, iLast, i - iLast + Ord((i = Length(S)) and (not(S[i] in Delimiters))))));
    iLast := i + 1;
  end;
end;

function Split(S: string; Delimiters: TSetOfChar): Variant; overload;
var i, iLast: integer;
begin
  iLast := 1;
  Result := varArrayCreate([0, -1], varOleStr);
  for i := 1 to Length(S) do
  if (S[i] in Delimiters) or (i = Length(S)) then
  begin
    VarArrayRedim(Result, varArrayHighBound(Result, 1) + 1);
    Result[varArrayHighBound(Result, 1)] := trim(copy(S, iLast, i - iLast + Ord((i = Length(S)) and (not(S[i] in Delimiters)))));
    iLast := i + 1;
  end;
end;

function Split(S: string; Delimiter: char): Variant;
var i, iLast: integer;
begin
  iLast := 1;
  Result := varArrayCreate([0, -1], varOleStr);
  for i := 1 to Length(S) do
  if (S[i] = Delimiter) or (i = Length(S)) then
  begin
    VarArrayRedim(Result, varArrayHighBound(Result, 1) + 1);
    Result[varArrayHighBound(Result, 1)] := trim(copy(S, iLast, i - iLast + Ord((i = Length(S)) and (S[i] <> Delimiter))));
    iLast := i + 1;
  end;
end;



end.
