unit FrameFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, CheckLst, StdCtrls;

type
  TFrame9 = class(TFrame)
    lstTypeFilter: TListBox;
    lstValueFilter: TListBox;
    edtValueFilter: TEdit;
    btn1: TButton;
    btn2: TButton;
    chklstCurrentFilter: TCheckListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
