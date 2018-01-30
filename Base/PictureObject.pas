unit PictureObject;

interface

uses Graphics;

type

  IPictureObject = interface
    function GetPicture: TPicture;
    function GetPictureFileName: string;
    procedure SetPictureFileName(const Value: string);

    property Picture: TPicture read GetPicture;
    property PictureFileName: string read GetPictureFileName write SetPictureFileName;
  end;

implementation

end.
