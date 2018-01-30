unit Comparers;


interface

function  WellNumAndAreaCompare(Item1, Item2: Pointer): Integer;
function  CompareSlottings(Item1, Item2: Pointer): integer;
function  CoreTransferTaskCompare(Item1, Item2: Pointer): integer;


implementation

uses Well, SysUtils, ClientCommon, Math, Slotting, CoreTransfer, Types;

function  CoreTransferTaskCompare(Item1, Item2: Pointer): integer;
var ctt1, ctt2: TCoreTransferTask;
begin
  ctt1 := TCoreTransferTask(Item1);
  ctt2 := TCoreTransferTask(Item2);

  Result := 0;
  // сначала по типу перемещения
  if Assigned(ctt1.TransferType) and Assigned(ctt2.TransferType) then
    Result := CompareValue(ctt1.TransferType.ID, ctt2.TransferType.ID);

  if Result = 0 then
  begin
    // потом по объекту (разрезы в конце)
    if Assigned(ctt1.Well) and Assigned(ctt2.GenSection) then
      Result := LessThanValue
    else if Assigned(ctt1.GenSection) and Assigned(ctt2.Well) then
      Result := GreaterThanValue
    else if Assigned(ctt1.Well) and Assigned(ctt2.Well) then
      Result := WellNumAndAreaCompare(ctt1.Well, ctt2.Well)
    else if Assigned(ctt1.GenSection) and Assigned(ctt2.GenSection) then
      Result := CompareStr(ctt1.GenSection.Name, ctt2.GenSection.Name);
  end;
end;


function  WellNumAndAreaCompare(Item1, Item2: Pointer): Integer;
var w1, w2: TSimpleWell;
    iNum1, iNum2: Integer;
begin
  w1 := TSimpleWell(Item1);
  w2 := TSimpleWell(Item2);

  Result := CompareStr(w1.Area.Name, w2.Area.Name);
  if (Result = 0) then 
  begin
    try
      iNum1 := ExtractInt(w1.NumberWell);
      iNum2 := ExtractInt(w2.NumberWell);
      Result := CompareValue(iNum1, iNum2);
      if Result = 0 then Result := CompareStr(w1.NumberWell, w2.NumberWell);
    except
      Result := CompareStr(w1.NumberWell, w2.NumberWell);
    end;
  end;
end;

function CompareSlottings(Item1, Item2: Pointer): integer;
var s1, s2: TSimpleSlotting;
begin
  s1 := TSimpleSlotting(Item1);
  s2 := TSimpleSlotting(Item2);

  if (s1.Owner <> s2.Owner) and (s1.Owner is TSimpleWell) and (s2.Owner is TSimpleWell) then
    Result := WellNumAndAreaCompare(s1.Owner, s2.Owner)
  else
    Result := 0;

  if Result <> 0 then exit;
  Result := CompareValue(s1.Top, s2.Top);
  if Result <> 0 then exit;
  Result := CompareValue(s1.Bottom, s2.Bottom);
end;


end.
