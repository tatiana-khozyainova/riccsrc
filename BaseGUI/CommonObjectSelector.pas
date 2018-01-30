unit CommonObjectSelector;

interface

uses BaseObjects;

type
  IObjectSelector = interface
    function  GetSelectedObject: TIDObject;
    procedure SetSelectedObject(AValue: TIDObject);
    property  SelectedObject: TIDObject read GetSelectedObject write SetSelectedObject;

    procedure SetMultiSelect(const Value: boolean);
    function  GetMultiSelect: boolean;
    
    property  MultiSelect: boolean read GetMultiSelect write SetMultiSelect;
    function  GetSelectedObjects: TIDObjects;
    procedure SetSelectedObjects(AValue: TIDObjects);
    property  SelectedObjects: TIDObjects read GetSelectedObjects write SetSelectedObjects;
    procedure ReadSelectedObjects; 

  end;

implementation

end.
