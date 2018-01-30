unit ClientCommon;

interface

  uses Math, SysUtils, ActnList, Windows, Classes, ComCtrls
  {$IFDEF VER150}
  , Variants
  {$ENDIF}
  ;

  { TODO :
    ������ ����� ���� ����� ��������� ��������� - ����� ���� ��������� ����������
    ������� ��� �������� � ������������� � ��� ������������ �������� }
  {$DEFINE LIC}
  //{$DEFINE STRUCT}

type
  TOnTreeNodePass = procedure (Node: TTreeNode) of object;

  PHierarchyItemRecord = ^THierarchyItemRecord;
  THierarchyItemRecord = record
    ID: word;
    MainID: word;
  end;

  THierarchyDictRecord = record
    //��� �������� ��������� ��� �������� �����������
    sDictProc: shortstring;
    //��� ������������� ������� - �����������
    sDictTable: shortstring;
    //�������� �������� (ID �������� �����������)
    sItemIDAttr: shortstring;
    //���������� ����� �������� (ID �������� �����������) � _���������_
    iItemIDAttrID: smallint;
    //�������� �������� (������ ��� �������� �����������)
    sItemFullNameAttr: shortstring;
    //���������� ����� �������� (������ ��� �������� �����������) � _���������_
    iItemFullNameAttrID: smallint;
    //�������� �������� (��� �������� �����������)
    sItemCodeAttr: shortstring;
    //���������� ����� �������� (��� �������� �����������) � _���������_
    iItemCodeAttrID: smallint;
    //�������� �������� (������� �������� �����������)
    sItemTypeAttr: shortstring;
    //���������� ����� �������� (������� �������� �����������) � _���������_
    iItemTypeAttrID: smallint;
    //�������� �������� (ID ������������� �������� �����������)
    sMainItemIDAttr: shortstring;
    //���������� ����� �������� (ID ������������� �������� �����������) � _���������_
    iMainItemIDAttrID: smallint;
  end;



  THierarchyDictType = (dtDistrict, dtPetrolRegion, dtTectonicStruct);

  function VarFloatToStr(const Value: variant;
           const Precision:byte = 3): shortstring;
  function ReduceArrayDimCount(var vArray: variant;
           const iColumnIndex: smallint = 0): variant;
  function FloatToStrEx(F:real; Precision: byte = 3):string;
  function DateToStrEx(Adtm: TDateTime): string;
  function GetDictEx(const ATableName: shortstring;
           const AColumnList: string = '*';
           const AFilter: string = ''):variant;
  function GetSingleValue(var AQueryResult: variant;
           const AColumnIndex: smallint = 0; const ARowIndex: smallint = 0): variant;
  function GetComputerAndUserName(var AComputerName, AUserName: string): smallint;
  procedure FetchPriorities(const APriority: smallint; AActionList: TActionList);
  function StrToFloatEx(S: string; Precision: smallint = 3): single;
  function StrToFloatF(S: string; Precision: smallint = 3): single;
  function StrToDateEx(const S:string): TDateTime;
  function GetFirstSimilarName(var ADict: variant; const AName: shortstring;
             const AColIndex: byte = 1): variant; overload;
  function GetFirstSimilarName(var ADict: variant; const AName: shortstring;
             var AResultID: integer; const AColIndex: byte = 1): variant; overload;
  function GetObjectId(var ADict: variant;const AObjectName: shortstring;
           const AColIndex: byte = 1): integer;
  function GetObjectName(var ADict: variant; const AObjectId: single;
           const AColIndex: byte = 1): variant; overload;
  function GetObjectName(var ADict: variant; const AObjectId: single;
           const AColIndex: byte; const AKeyColIndex: integer): variant; overload;

  function StrToIntEx(const S: string): Integer;
  function GetSimilarNamesArray(var ADict: variant;const AName: shortstring;
                                const AColIndex: byte = 1): variant;
  function ReplaceComma(const Source, CommaToReplace, ReplacingComma: shortstring): string;
  function GetObject(var ADict: variant; const AObjectId: integer): variant;

  procedure DebugFileSave(AShitHappens: string);
  // �������� ��� ����� � ��������� �� �� �����
  function  ExtractFloat(AValue: string): single;
  // �������� �����, ������� ����������� �� ����������� � ��������� �� � ���
  function  ExtractInt(AValue: string): integer;

  procedure CheckChildState(ATree: TTreeView; AParent: TTreeNode; AOnCheckTreeNode: TOnTreeNodePass);
  procedure DeriveParentState(ATree: TTreeView; AParent: TTreeNode; AOnCheckTreeNode: TOnTreeNodePass);

  function  ImproveAreaName(AAreaName: string): string;


const
  Consultants = '������������: ������ ����';
  sDocPath = '\\srv2\doc$\docsbank\graph\';


var
  //��� ������� ����������
  iServerType: byte = 0; //0 - �������� ������, 1 - ��������

implementation

uses Facade, StringUtils;

function  ImproveAreaName(AAreaName: string): string;
var sAreaName: string;
begin
  sAreaName := AAreaName;
  sAreaName := trim(StringReplace(sAreaName, '(-��)', '', [rfReplaceAll, rfIgnoreCase]));
  sAreaName := StringUtils.ReplaceLatSymbols(sAreaName);

  sAreaName := StringReplace(sAreaName, '������-', '������', [rfReplaceAll]);
  sAreaName := StringReplace(sAreaName, '�����-', '�����', [rfReplaceAll]);
  sAreaName := StringReplace(sAreaName, '������-', '������', [rfReplaceAll]);

  if ((pos(UpperCase('��������-'), UpperCase(sAreaName)) > 0) or (pos(UpperCase('������-'), UpperCase(sAreaName)) > 0) or
      (pos(UpperCase('�������-'), UpperCase(sAreaName)) > 0) or (pos(UpperCase('����-'), UpperCase(sAreaName)) > 0) or
      (pos(UpperCase('���-'), UpperCase(sAreaName)) > 0)) then
    sAreaName := StringReplace(sAreaName, '-' + Chr(10), '-', [rfReplaceAll])
  else
    sAreaName := StringReplace(sAreaName, '-' + Chr(10), '', [rfReplaceAll]); // ������ ���������

  sAreaName := StringReplace(sAreaName, Chr(13), '', [rfReplaceAll]);
  sAreaName := StringReplace(sAreaName, Chr(10), '', [rfReplaceAll]);

  Result := sAreaName; 
end;


procedure DeriveParentState(ATree: TTreeView; AParent: TTreeNode; AOnCheckTreeNode: TOnTreeNodePass);
var Child: TTreeNode;
begin
  with ATree do
  begin
    Child := AParent.GetFirstChild;
    // ��� ���� �������� ���������
    while (Child <> nil) do
    begin
      if (Child <> nil) and (Child.SelectedIndex<3) then
      begin
        // ������������� ������ �������������
        Child.SelectedIndex := AParent.SelectedIndex;
        if Assigned(AOnCheckTreeNode) then AOnCheckTreeNode(Child);
        DeriveParentState(ATree,Child, AOnCheckTreeNode);
      end;
      Child := AParent.GetNextChild(Child);
    end;
    Repaint;
  end;
end;


procedure CheckChildState(ATree:TTreeView; AParent:TTreeNode; AOnCheckTreeNode: TOnTreeNodePass);
var Child: TTreeNode;
    iSelectedNumber:Integer;
    bChildGrayed:boolean;
begin
  iSelectedNumber:=0;
  bChildGrayed:=false;
  if (AParent<>nil) then
  begin
    Child:=AParent.getFirstChild;
    // �������� �������
    // ��� ���� �������� ���������
    if (Child<>nil) then
    repeat
      // ����������� ����������� ��������
      // ����� �������� ��������,
      // ��� ���� �������� ������������
      if (Child.SelectedIndex=2) then
      begin
        bChildGrayed:=true;
        break;
      end;
      // �������� �������� �������� ���������
      // � ����������� ��������� ����� � ������
      // ���������� ���������
      // ��������� �������� �������� �� ��� ��������
      iSelectedNumber:=iSelectedNumber+ord(Child.SelectedIndex<3)*Child.SelectedIndex;
      Child:=AParent.GetNextChild(Child);
    until(Child=nil);

    if not(bChildGrayed) then
      // ���� �� ���� �������� ������� �� �������,
      // �� ������������ ����� �� ������ ���� �������
      case iSelectedNumber of
        0: AParent.SelectedIndex:=0;
      else
        // ���� �������� �� ��� �������� ��������,
        // �� ������������ ������ ���� �������
        if (iSelectedNumber<AParent.Count) then AParent.SelectedIndex:=2
        else
          // ���� �������� ��� �������� ��������,
          // �� ������������ ������ ���� �������
          if (iSelectedNumber=AParent.Count) then AParent.SelectedIndex:=1
      end
    else
      // ���� ���� ���������� �������� ����� ��������,
      // �� �������� ������������
      AParent.SelectedIndex:=2
  end;

  if (AParent <> nil) then
  begin
    if Assigned(AOnCheckTreeNode) then
       AOnCheckTreeNode(AParent);
    CheckChildState(ATree,AParent.Parent, AOnCheckTreeNode);
  end;

  ATree.Repaint;
end;


function  ExtractInt(AValue: string): integer;
const chrs: set of Char = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
var i: integer;
    sValue: string;
begin
  for i := 1 to Length(AValue) do
  if AValue[i] in chrs then
  begin
    if (AValue[i] <> DecimalSeparator) then sValue := sValue + AValue[i]
    else break;
  end
  else break;

  Result := StrToInt(sValue);
end;


function  ExtractFloat(AValue: string): single;
const chrs: set of Char = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', ','];
var i: integer;
    sValue: string;
    bDecUsed: boolean;
begin
  AValue := StringReplace(AValue, '.', DecimalSeparator, [rfReplaceAll]);
  AValue := StringReplace(AValue, ',', DecimalSeparator, [rfReplaceAll]);

  bDecUsed := false;

  for i := 1 to Length(AValue) do
  if AValue[i] in chrs then
  begin
    if (AValue[i] <> DecimalSeparator) then
      sValue := sValue + AValue[i]
    else
    begin
      if not bDecUsed then
      begin
        bDecUsed := true;
        sValue := sValue + AValue[i];
      end;
    end;
  end;

  Result := StrToFloat(sValue);
end;



procedure DebugFileSave(AShitHappens: string);
var slst: TStringList;
begin
  slst := TStringList.Create;
  slst.LoadFromFile('debug.txt');
  slst.Add(AShitHappens);
  slst.SaveToFile('debug.txt');
  slst.Free;
end;



function VarFloatToStr(const Value: variant;
  const Precision:byte=3): shortstring;
begin
  case varType(Value) of
    varSingle, varDouble, varCurrency:
      Result:=FloatToStrEx(Value, Precision);
    else
      Result:='';
  end;//case
end;

{
<SUB NAME='ReduceArrayDimCount'>
<PARAMETERS>
<PARAMETER NAME='vArray' DATATYPE='variant' TYPE='var'>
����� � ��������� ������� </PARAMETER>
<PARAMETER NAME='iColumnIndex' DATATYPE='smallint' TYPE='in'>
�������� ���������� ������ ����� ������� </PARAMETER>
<PARAMETER NAME='������������ ��������' DATATYPE='variant' TYPE='out'>
������ </PARAMETER>
</PARAMETERS>
������� ��������������� ��������� �������
���������� ������� ���� [����������_��������, ����������_�����]
� ���������� ������
</SUB>
}
function ReduceArrayDimCount(var vArray: variant;
  const iColumnIndex: smallint=0): variant;
var i: word;
    iHB: word;
begin
  if not varIsEmpty(vArray) then
  begin
    if varArrayDimCount(vArray)=2 then
    begin
      iHB:= varArrayHighBound(vArray, 2);
      Result:= varArrayCreate([0, iHB], varVariant);
      for i:=0 to iHB do
        Result[i]:= vArray[iColumnIndex, i];
    end
    else Result:= vArray;
  end
  else Result:=UnAssigned;
end;

{
<SUB NAME='FloatToStrEx'>
<PARAMETERS>
<PARAMETER NAME='F' DATATYPE='real' TYPE='in'>
����� � ��������� ������� </PARAMETER>
<PARAMETER NAME='Precision' DATATYPE='byte' TYPE='in'>
�������� ���������� ������ ����� ������� </PARAMETER>
<PARAMETER NAME='������������ ��������' DATATYPE='string' TYPE='out'>
������ </PARAMETER>
</PARAMETERS>
������� �������� �������������� ����� � ������,
�������� �������� ���������� ������ ����� �������
</SUB>
}
function FloatToStrEx(F:real; Precision: byte=3):string;
var Temp: extended;
begin
  try
    Temp:=Power(10,Precision);
    F:=Round(F*Temp)/Temp;
    if F<>-1
    then Result:=StringReplace(FloatToStr(F), ',', '.', [rfReplaceAll])
    else Result:='NULL';
  except on EConvertError
    do Result:='NULL';
  end;//try
end;

function DateToStrEx(Adtm: TDateTime): string;
begin
  Result:= DateToStr(Adtm);
  if pos ('01.01.', Result)=1 then Delete(Result, 1, 6);
  if Adtm=0 then Result:='';
end;

function GetSingleValue(var AQueryResult: variant;
  const AColumnIndex:smallint=0; const ARowIndex:smallint=0):variant;
begin
  Result:=UnAssigned;
  if (not varIsEmpty(AQueryResult))
  and (not varIsNull(AQueryResult))
  then
    if (not varIsNull(AQueryResult[AColumnIndex,ARowIndex]))
    and (not varIsEmpty(AQueryResult[AColumnIndex,ARowIndex]))
    then Result:=AQueryResult[AColumnIndex,ARowIndex]
end;

function GetComputerAndUserName(var AComputerName, AUserName: string):smallint;
var pC, pU:pointer;
    iC, iU:cardinal;
    p:PWideChar;
begin
  Result:=0;
  try
    iC:=MAX_COMPUTERNAME_LENGTH + 1;
    iU:=MAX_COMPUTERNAME_LENGTH + 1;
    GetMem(pC,iC);
    GetMem(pU,iU);
    try
      if (Windows.GetComputerNameW(pC, iC))
      and (Windows.GetUserNameW(pU, iU)) then
      begin
        p:=pC;
        AComputerName:=p;
        p:=pU;
        AUserName:=p;
      end;
    finally
      FreeMem(pC);
      FreeMem(pU);
    end;//try...finally
  except on Exception do Result:=-1;
  end;//try...except
end;

procedure FetchPriorities(const APriority: smallint; AActionList:TActionList);
var iRemnant: integer; // �������
    iPart: integer;    // ����� �����
    iPriority: integer; // ��������� ������� ��������
    i,j: integer;
begin
  iPart:=APriority;
  i:=0;

  repeat
    iRemnant:= iPart mod 2;
    iPart:=iPart div 2;
    // ��� ���� math �� ����������
    iPriority:=iRemnant*round(exp(i*ln(2)));
    if (iPriority>0) then
    for j:=0 to AActionList.ActionCount-1 do
    begin
      if (AActionList.Actions[j].Tag=iPriority) then
      begin
        (AActionList.Actions[j] as TAction).Visible:=true;
        (AActionList.Actions[j] as TAction).Enabled:=true;
      end;
    end;
    inc(i);
  until (iPart=0);
end;

function StrToFloatF(S: string; Precision:smallint=3): single;
var Separator: string;
begin
  if (DecimalSeparator=',') then
    Separator:='.'
  else
    Separator:=',';
  if (pos(Separator,S)>0) then
    S:=StringReplace(S, Separator, DecimalSeparator, [rfReplaceAll]);
  Result:=(Int(StrToFloat(S)*Power(10, Precision)))/Power(10, Precision);
end;


function StrToFloatEx(S: string; Precision:smallint=3): single;
var Separator: string;
begin
  if (DecimalSeparator=',') then
    Separator:='.'
  else
    Separator:=',';
  if (pos(Separator,S)>0) then
    S:=StringReplace(S, Separator, DecimalSeparator, [rfReplaceAll]);
  try
    Result:=(Int(StrToFloat(S)*Power(10, Precision)))/Power(10, Precision);
  except on EConvertError do Result:=-1;
  end;//try
end;

function StrToDateEx(const S:string):TDateTime;
begin
  try
    Result:=StrToDate(S);
  except on EConvertError do
    Result:=0;
  end;//try
end;

//������� �������� � �������� ������
//�������� ������ (��� ���������) CommaToReplace
//�� ������ �������� ������ (��� ���������) ReplacingComma
function ReplaceComma(const Source,CommaToReplace,ReplacingComma:shortstring):string;
var s:shortstring;
    i:integer;
begin
  s:=Source;
  i:=Pos(CommaToReplace,s);
  if i>0 then
  begin
    Delete(s,i,Length(CommaToReplace));
    Insert(ReplacingComma,s,i);
  end;
  Result:=s;
end;

function StrToIntEx(const S:string):integer;
var E:integer;
begin
  Val(S, Result, E);
  if E<>0 then Result:=-1;
end;

function GetDictEx(const ATableName: shortstring;
         const AColumnList: string = '*';
         const AFilter: string = ''):variant;
var sSQL: string;
begin
  sSQL := 'select ' + AColumnList + ' from ' + ATableName;
  if trim(AFilter) <> '' then
    sSQL := sSQL + ' where ' + AFilter;
    
  if TMainFacade.GetInstance.DBGates.Server.ExecuteQuery(sSQL) >= 0 then
     Result := TMainFacade.GetInstance.DBGates.Server.QueryResult;
end;

function GetObjectId(var ADict:variant;const AObjectName:shortstring;
         const AColIndex:byte=1):integer;
var i:integer;
begin
  Result:=0;
  if not varIsEmpty(ADict)then
    case varArrayDimCount(ADict) of
    2:begin
        for i:=0 to varArrayHighBound(ADict,2) do
        if AnsiUpperCase(Trim(ADict[AColIndex,i])) = AnsiUpperCase(Trim(AObjectName)) then
        begin
          Result:=ADict[0,i];
          break;
        end;
      end;
    1:begin
        for i:=0 to varArrayHighBound(ADict,1) do
        if AnsiUpperCase(Trim(ADict[i])) = AnsiUpperCase(Trim(AObjectName)) then
        begin
          Result:=ADict[i];
          break;
        end;
      end;
    end;//case
end;

function GetObjectName(var ADict:variant;const AObjectId:single;
         const AColIndex:byte=1):variant;
var i:integer;
begin
  try
    Result:=Unassigned;//Null;
    if not varIsEmpty(ADict)then
    case varArrayDimCount(ADict) of
    2:begin
      for i:=0 to varArrayHighBound(ADict,2) do
        if ADict[0,i]=AObjectId then
        begin
          Result:=ADict[AColIndex,i];
          break;
        end;
      end;
    1:begin
      for i:=0 to varArrayHighBound(ADict,1) do
        if ADict[i]=AObjectId then
        begin
          Result:=ADict[i];
          break;
        end;
      end;
    end;//case
  except on Exception do Result:=Unassigned;
  end;//try
end;

function GetObjectName(var ADict: variant; const AObjectId: single;
         const AColIndex: byte; const AKeyColIndex: integer): variant; overload;
var i:integer;
begin
  try
    Result:=Unassigned;//Null;
    if not varIsEmpty(ADict)then
    case varArrayDimCount(ADict) of
    2:begin
      for i:=0 to varArrayHighBound(ADict,2) do
        if ADict[AKeyColIndex,i]=AObjectId then
        begin
          Result:=ADict[AColIndex,i];
          break;
        end;
      end;
    1:begin
      for i:=0 to varArrayHighBound(ADict,1) do
        if ADict[i]=AObjectId then
        begin
          Result:=ADict[i];
          break;
        end;
      end;
    end;//case
  except on Exception do Result:=Unassigned;
  end;//try
end;


function GetFirstSimilarName(var ADict:variant; const AName:shortstring;
  const AColIndex: byte = 1): variant;
var i:integer;
begin
  Result:=ANSIUpperCase(AName);
  if not varIsEmpty(ADict) then
  if AColIndex <= varArrayHighBound(ADict, 1) then
  for i:=0 to varArrayHighBound(ADict, 2) do
    if pos(Result,ANSIUpperCase(ADict[AColIndex, i]))=1 then
    begin
      Result:=ADict[AColIndex,i];
      break;
    end;
end;

function GetFirstSimilarName(var ADict:variant; const AName:shortstring;
  var AResultID: integer; const AColIndex: byte = 1): variant;
var i:integer;
begin
  Result:=ANSIUpperCase(AName);
  if not varIsEmpty(ADict) then
  if AColIndex <= varArrayHighBound(ADict, 1) then
  for i:=0 to varArrayHighBound(ADict, 2) do
    if pos(Result,ANSIUpperCase(ADict[AColIndex, i]))=1 then
    begin
      Result:=ADict[AColIndex,i];
      AResultID:= ADict[0, i];
      break;
    end;
end;

function GetSimilarNamesArray(var ADict:variant;const AName:shortstring;
  const AColIndex:byte=1): variant;
var i,j,k:integer;
    s:shortstring;
begin
  k:=0;
  for i:=0 to varArrayHighBound(ADict,2) do
  begin
    s:=ADict[AColIndex,i];
    if AnsiUpperCase(Copy(s,1,Length(AName)))=AnsiUpperCase(AName)
    then
//    if pos(AName,)<>0 then
    begin
      if varIsEmpty(Result)then Result:=varArrayCreate([0,varArrayHighBound(ADict,1),0,0],varOleStr);
      varArrayRedim(Result,k);
      for j:=0 to varArrayHighBound(ADict,1)do
        Result[j,k]:=ADict[j,i];
      inc(k);
    end;
  end;
end;

function GetObject(var ADict: variant; const AObjectId:integer): variant;
var i,iHB,j: integer;
begin
  iHB:=varArrayHighBound(ADict,1);
  Result:=varArrayCreate([0,iHB],varVariant);
  for i := 0 to varArrayHighBound(ADict,2) do
    if ADict[0,i]=AObjectId then
    begin
      for j:=0 to iHB do
       Result[j]:=ADict[j,i];
      break;
    end;
end;


end.