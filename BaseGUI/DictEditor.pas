unit DictEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CommonComplexList, BaseDicts;

type
  TfrmDictEditor = class(TForm)
    cmplxDicts: TfrmComplexList;
    gbxSelectDict: TGroupBox;
    cmbxDict: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure cmbxDictChange(Sender: TObject);
    procedure cmplxDictsbtnInsertClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDictEditor: TfrmDictEditor;

implementation

uses Facade;

{$R *.DFM}

procedure TfrmDictEditor.FormCreate(Sender: TObject);
begin
  TMainFacade.GetInstance.AllDicts.MakeDictList(cmbxDict.Items, true);
  cmbxDict.Sorted := true;
end;

procedure TfrmDictEditor.cmbxDictChange(Sender: TObject);
begin
  if cmbxDict.ItemIndex > -1 then
    cmplxDicts.DictName := TDict(cmbxDict.Items.Objects[cmbxDict.ItemIndex]).Name;
end;

procedure TfrmDictEditor.cmplxDictsbtnInsertClick(Sender: TObject);
begin
  cmplxDicts.btnInsertClick(Sender);

end;

end.
