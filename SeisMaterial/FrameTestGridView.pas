unit FrameTestGridView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ActnList, StdCtrls, Ex_Grid, Ex_DBGrid, Ex_Inspector,SeisMaterial,
  SeisExemple,SeisProfile,Material, Structure, Table, Employee, Organization;

type
  TFrame1 = class(TFrame)
    btn1: TButton;
    actn1: TActionList;
    actn2: TAction;
    procedure actn2Execute(Sender: TObject);
    procedure grd1GetCellText(Sender: TObject; Cell: TGridCell;
      var Value: String);

  private
    { Private declarations }
  public
    { Public declarations }

  end;

implementation

uses Facade,SeisMaterialPoster,SeisExemplePoster,SeisProfilePoster,MaterialPoster, StructurePoster, TablePoster, EmployeePoster, OrganizationPoster;
{$R *.dfm}




procedure TFrame1.actn2Execute(Sender: TObject);
var i:Integer;
ob:TExempleLocation;ob2:TExempleSeismicMaterial;ob3:TElementExemple;
ob4:TSeismicMaterial;ob5:TSeismicProfile;ob6:TSeismicProfileCoordinate;
ob7:TObjectBindType;ob8:TMaterialBinding;ob9:TSimpleDocument;
Cell1:TGridCell;Value:string;
begin
//  Value:='123';
//  Cell1.Col:=1;Cell1.Row:=1;
 // grd1.OnGetEditText(Self,Cell1,Value);
//if ((Cell.Col=1) and (Cell.Row=1)) then Value := IntToStr(TMainFacade.GetInstance.AllMaterialLocations.Items[1].ID);
//grd1.Cell.Value := IntToStr(TMainFacade.GetInstance.AllMaterialLocations.Items[1].ID);
//ShowMessage(IntToStr(TMainFacade.GetInstance.AllExempleLocations.Items[1].ID)+TMainFacade.GetInstance.AllExempleLocations.Items[1].Name+TMainFacade.GetInstance.AllExempleLocations.Items[1].MaterialLocation.Name);
//ShowMessage(IntToStr(TMainFacade.GetInstance.AllStructures.ItemsByIdStruct[4,15].ID));

{ob:=TExempleLocation.Create(TMainFacade.GetInstance.AllExempleLocations) as TExempleLocation;
ob.ID:=1;
ob.Name:='Стеллаж №101';
ob.MaterialLocation:=TMainFacade.GetInstance.AllMaterialLocations.ItemsByID[2] as TMaterialLocation;
ob.Update();
ob.Free;}

{ob4:=TSeismicMaterial.Create(TMainFacade.GetInstance.AllSeismicMaterials) as TSeismicMaterial;
ob4.ID:=3;
ob4.BeginWorksDate:=Now;
ob4.EndWorksDate:=Now;
ob4.ReferenceComposition:='2 knigi i 2 papki';
ob4.SeisWorkType:=TMainFacade.GetInstance.AllSeisWorkTypes.ItemsByID[10] as TSeisWorkType;
ob4.SeisWorkMethod:=TMainFacade.GetInstance.AllSeisWorkMethods.ItemsByID[2] as TSeisWorkMethod;
ob4.SeisCrew:=TMainFacade.GetInstance.AllSeisCrews.ItemsByID[2] as TSeisCrew;
ob4.SimpleDocument:=TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[8] as TSimpleDocument;
ob4.Structure:=TMainFacade.GetInstance.AllStructures.ItemsByIdStruct[4,15] as TStructure;
ob4.Update();
ob4.Free; }

{ob2:=TExempleSeismicMaterial.Create(TMainFacade.GetInstance.AllExempleSeismicMaterials) as TExempleSeismicMaterial;
ob2.ID:=1;
ob2.ExempleSum:=223;
ob2.ExempleComment:='comment2';
ob2.SeismicMaterial:=TMainFacade.GetInstance.AllSeismicMaterials.ItemsByID[3] as TSeismicMaterial;
ob2.ExempleType:=TMainFacade.GetInstance.AllExempleTypes.ItemsByID[2] as TExempleType;
ob2.ExempleLocation:=TMainFacade.GetInstance.AllExempleLocations.ItemsByID[1] as TExempleLocation;
ob2.Update();
ob2.Free;}

{ob3:=TElementExemple.Create(TMainFacade.GetInstance.AllElementExemples) as TElementExemple;
ob3.ID:=1;
ob3.ElementNumber:=1;
ob3.ElementComment:='comment41';
ob3.ElementType:=TMainFacade.GetInstance.AllElementTypes.ItemsByID[2] as TElementType;
ob3.ExempleSeismicMaterial:=TMainFacade.GetInstance.AllExempleSeismicMaterials.ItemsByID[1] as TExempleSeismicMaterial;
ob3.Update();
ob3.Free;}

{ob5:=TSeismicProfile.Create(TMainFacade.GetInstance.AllSeismicProfiles) as TSeismicProfile;
ob5.ID:=1;
ob5.SeismicMaterial:=TMainFacade.GetInstance.AllSeismicMaterials.ItemsByID[3] as TSeismicMaterial;
ob5.SeismicProfileType:=TMainFacade.GetInstance.AllSeismicProfileTypes.ItemsByID[2] as TSeismicProfileType;
ob5.SeisProfileNumber:=1102;
ob5.PiketBegin:=0;
ob5.PiketEnd:=100;
ob5.SeisProfileLenght:=10000.12531;
ob5.DateEntry:=Now;
ob5.SeisProfileComment:='123456789';
ob5.Update();
ob5.Free; }

{ob6:=TSeismicProfileCoordinate.Create(TMainFacade.GetInstance.AllSeismicProfileCoordinates) as TSeismicProfileCoordinate;
ob6.SeismicProfile:=TMainFacade.GetInstance.AllSeismicProfiles.ItemsByID[1] as TSeismicProfile;
ob6.CoordNumber:=5;
ob6.CoordX:=105.25;
ob6.CoordY:=30.21;
ob6.Update();
ob6.Free;  }

{ob7:=TObjectBindType.Create(TMainFacade.GetInstance.AllObjectBindTypes) as TObjectBindType;
//ob7.ID:=1;
ob7.Name:='Тип сейс работ';
ob7.RiccTable:=TMainFacade.GetInstance.AllRiccTables.ItemsByID[852] as TRiccTable;
ob7.RiccAttribute:=TMainFacade.GetInstance.AllRiccAttributes.ItemsByID[2979] as TRiccAttribute;
ob7.Update();
ob7.Free; }

{ob8:=TMaterialBinding.Create(TMainFacade.GetInstance.AllMaterialBindings) as TMaterialBinding;
ob8.SimpleDocument:=TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[8] as TSimpleDocument ;
ob8.ObjectBindType:=TMainFacade.GetInstance.AllObjectBindTypes.ItemsByID[1] as TObjectBindType;
ob8.ObjectBindID:=1;
ob8.Update();
ob8.Free; }
 //grd1GetCellText(Self.grd1,grd1.VisOrigin,NullAsStringValue);

ob9:=TSimpleDocument.Create(TMainFacade.GetInstance.AllSimpleDocuments) as TSimpleDocument;
//ob9.ID:=3;
ob9.Name:='Пробный отчет сейс 3';
ob9.InventNumber:=11007;
ob9.TGFNumber:=11006;
ob9.MaterialComment:='kommentary';
ob9.CreationDate:=Now;
ob9.EnteringDate:=Now;
ob9.MaterialLocation:=TMainFacade.GetInstance.AllMaterialLocations.ItemsByID[2] as TMaterialLocation;
ob9.DocType:=TMainFacade.GetInstance.DocumentTypes.ItemsByID[70] as TDocumentType;
ob9.Organization:=TMainFacade.GetInstance.AllOrganizations.ItemsByID[9] as TOrganization;
ob9.Employee:=TMainFacade.GetInstance.AllEmployees.ItemsByID[148] as TEmployee;
ob9.Update();
ob9.Free;
end;

procedure TFrame1.grd1GetCellText(Sender: TObject; Cell: TGridCell;
  var Value: String);
  var str:string; ob:TSeisWorkMethod;
begin
//ob:=(TMainFacade.getinstance.AllSeisWorkMethods.ItemsByID[1]) as TSeisWorkMethod;
//ShowMessage(IntToStr(Cell.Col));
//grd1.Rows.Count:=4;
//Value:='123';
//Value :=ob.Name;
end;

end.
