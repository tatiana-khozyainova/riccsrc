unit BasePosters;

interface

uses BaseObjects, SysUtils, ParentedObjects;

type
  TIDObjectDataPoster = class(TDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
  end;

  TParentedIDObjetcsPoster = class(TDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
  end;

implementation

uses Math;

{ TIDObjectDataPoster }

function TIDObjectDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;  
end;

function TIDObjectDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var i: integer;
    o: TIDObject;
begin
  // генерируем несколько случайных объектов
  Randomize;
  Result := RandomRange(50, 100);
  AObjects.Clear;
  for i := 0 to Result - 1 do
  begin
    o := AObjects.Add;
    o.ID := i;
    o.Name := o.ClassIDString + ' ' + IntToStr(i);
  end;
end;

function TIDObjectDataPoster.PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

{ TParentedIDObjetcsPoster }

function TParentedIDObjetcsPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TParentedIDObjetcsPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var i, iNum: integer;
    o: TParentedIDObject;
begin
  // генерируем несколько случайных объектов
  Randomize;
  Result := RandomRange(50, 100);
  AObjects.Clear;
  for i := 0 to Result - 1 do
  begin
    o := AObjects.Add as TParentedIDObject;
    o.ID := i;
    o.Name := o.ClassIDString + ' ' + IntToStr(i);

    if i > (Result div 3) then
    begin
      iNum := RandomRange(0, i);
      o.Parent := AObjects.Items[iNum] as TParentedIDObject;
    end;
  end;
end;

function TParentedIDObjetcsPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

end.
