unit WellPassportClientCommon;

interface
  uses SysUtils, ClientCommon;
  
type
  TWellRecord = record
    iWellUIN,
      iAreaID: integer;
    iDistrictID,
      iPetrolRegionID,
      iTectonicStructID,
      iTopographicalListId,
      iLicenseZoneId: integer;
    iSearchingMinistryID,
      iSearchingTrustID,
      iSearchingExpeditionID,
      iExploitingMinistryID,
      iExploitingTrustID,
      iExploitingExpeditionID: integer;
    iCategoryID,
      iTargetAgeID,
      iTrueAgeID,
      iStatusID,
      iAbandonReasonID,
      iProfileID: integer;
    vTargetFluidIDArray,
      vTrueFluidIDArray,
      vFinanceSourceIDArray: variant;
    dtmEnteringDate,
      dtmDrillingStart,
      dtmDrillingFinish,
      dtmSuspendActionDate,
      dtmAbandonDate,
      dtmConstructionStarted,
      dtmConstructionFinished: TDateTime;
    fRotorAltitude,
      fTargetDepth,
      fTrueDepth,
      fTargetCost,
      fTrueCost: variant;
    sWellNum,
      sRegNum,
      sProductivity,
      sSuspendAction,
      sCommentText: shortstring;
    vDinamicsArray,
      vWellOrgStatusArray,
      vDocumentsArray: Variant;
{    vCoordTypeArray,
      vCoordXArray,
      vCoordYArray: Variant;}
end;

  function SwapOilGas(Value: variant): variant;
  function LoadWell(var wrCurrent: TWellRecord):smallint;
  procedure ClearWellRecord();

var wrCurrentWell: TWellRecord;
    
    vAreaDict, vWellCategoryDict, vFinanceSourceDict,
    vWellStateDict, vProfileDict, vSynonymDict,
    vTopoListDict, vLicenseZoneDict, vTectonicStructDict,
    vDistrictDict, vPetrolRegionDict, vTestResultDict,
    vFluidTypeDict, vStratigraphyDict, vAbandonReasonDict,
    vOrgStatusDict, vOrganizationDict, vDocTypeDict,
    vGeolFoundationDict, vTableDict: Variant;

    //Вид формы добавления скважины
    iAddWellFormKind: byte = 0; //0 - краткая (типа ТБД), 1 - новая

implementation

function SwapOilGas(Value: variant): variant;
begin
  Result:= Value;
  if (varType(Value) = varOleStr)
  or (varType(Value) = varStrArg) then
    if Value = 'ГН' then Result:='НГ'
    else if Value = 'ВН' then Result:='НВ'
    else if Value = 'ВГ' then Result:='ГВ'
    else if Value = 'ВГК' then Result:='ГКВ'
    else if Value = 'ВГКН' then Result:='НГКВ'
    else if Value = 'ВГН' then Result:='НГВ'
    else if Value = 'ГКН' then Result:='НГК';
end;

procedure ClearWellRecord();
begin
  with wrCurrentWell do
  begin
    iWellUIN:=0;
    iAreaID:=0;
    iDistrictID:=0;
    iPetrolRegionID:=0;
    iTectonicStructID:=0;
    iTopographicalListId:=0;
    iLicenseZoneId:=0;
    iSearchingMinistryID:=0;
    iSearchingTrustID:=0;
    iSearchingExpeditionID:=0;
    iExploitingMinistryID:=0;
    iExploitingTrustID:=0;
    iExploitingExpeditionID:=0;
    iCategoryID:=0;
    iTargetAgeID:=0;
    iTrueAgeID:=0;
    iStatusID:=0;
    iAbandonReasonID:=0;
    iProfileID:=0;
    varClear(vTargetFluidIDArray);
    varClear(vTrueFluidIDArray);
    varClear(vFinanceSourceIDArray);
    dtmEnteringDate:=0;
    dtmDrillingStart:=0;
    dtmDrillingFinish:=0;
    dtmSuspendActionDate:=0;
    dtmAbandonDate:=0;
    dtmConstructionStarted:=0;
    dtmConstructionFinished:=0;
    fRotorAltitude:=null;
    fTargetDepth:=null;
    fTrueDepth:=null;
    fTargetCost:=null;
    fTrueCost:=null;
    sWellNum:='';
    sRegNum:='';
    sProductivity:='';
    sSuspendAction:='';
    sCommentText:='';
    varClear(vDinamicsArray);
    varClear(vWellOrgStatusArray);
    varClear(vDocumentsArray);
{    varClear(vCoordTypeArray);
    varClear(vCoordXArray);
    varClear(vCoordYArray);}
  end;
end;

function LoadWell(var wrCurrent: TWellRecord):smallint;
var vQR: variant;
    i, iRes: smallint;
begin
  Result:=0;
  iRes:=IServer.SelectRows(
                     'spd_Get_Well_Info',
                     varArrayOf(['Area_Id', 'vch_Well_Num', 'vch_Passport_Num',
                                 'Well_Category_Id', 'Well_State_Id',
                                 'Profile_Id', 'num_Rotor_Altitude',
                                 'num_Target_Depth', 'num_True_Depth',
                                 'Target_Age_Id', 'True_Age_Id',
                                 'dtm_Construction_Started', 'dtm_Construction_Finished',
                                 'dtm_Drilling_Start', 'dtm_Drilling_Finish',
                                 'num_Target_Cost', 'num_True_Cost',
                                 'vch_Well_Productivity', 'Topographical_List_Id',
                                 'License_Zone_Id', 'Struct_Id', 'District_Id',
                                 'Petrol_Region_Id']),
                     '', wrCurrent.iWellUIN);
  if iRes<0 then
  begin
    Result:=-1;
    Exit;
  end;

  if iRes>0 then
  begin
    Result:=iRes;
    vQR:=IServer.QueryResult;

    with wrCurrent do
    try
      iAreaId:= GetSingleValue(vQR,0);
      sWellNum:= GetSingleValue(vQR,1);
      sRegNum:= GetSingleValue(vQR,2);
      iCategoryID:= GetSingleValue(vQR,3);
      iStatusId:= GetSingleValue(vQR,4);
      iProfileID:= GetSingleValue(vQR,5);
      fRotorAltitude:=GetSingleValue(vQR,6);
      fTargetDepth:=GetSingleValue(vQR,7);
      fTrueDepth:=GetSingleValue(vQR,8);
      iTargetAgeID:=GetSingleValue(vQR,9);
      iTrueAgeId:=GetSingleValue(vQR,10);
      dtmConstructionStarted:=GetSingleValue(vQR,11);
      dtmConstructionFinished:=GetSingleValue(vQR,12);
      dtmDrillingStart:=GetSingleValue(vQR,13);
      dtmDrillingFinish:=GetSingleValue(vQR,14);
      fTargetCost:=GetSingleValue(vQR,15);
      fTrueCost:=GetSingleValue(vQR,16);
      sProductivity:=GetSingleValue(vQR,17);
      iTopographicalListId:=GetSingleValue(vQR,18);
      iLicenseZoneId:=GetSingleValue(vQR,19);
      iTectonicStructId:=GetSingleValue(vQR,20);
      iDistrictId:=GetSingleValue(vQR,21);
      iPetrolRegionId:=GetSingleValue(vQR,22);

// IWPServer.GetWellCoords(AWellUIN, vCoordTypeArray, vCoordXArray, vCoordYArray);

      IServer.SelectRows('spd_Get_Well_Finance_Source', 'Finance_Source_ID', '', iWellUIN);
      vQR:=IServer.QueryResult;
      vFinanceSourceIDArray:= ReduceArrayDimCount(vQR);

      IServer.SelectRows('spd_Get_Well_Organization',
                         varArrayOf(['Org_Status_Id', 'Organization_Id']),
                         '', iWellUIN);
      vWellOrgStatusArray:= IServer.QueryResult;
      if not varIsEmpty(vWellOrgStatusArray) then
      begin
        for i:=0 to varArrayHighBound(vWellOrgStatusArray, 2) do
          case GetSingleValue(vWellOrgStatusArray, 0, i) of
            3: iSearchingMinistryID:= vWellOrgStatusArray[1, i];
            4: iExploitingMinistryID:= vWellOrgStatusArray[1, i];
             1, 5: iSearchingTrustID:= vWellOrgStatusArray[1, i];
            2, 6: iExploitingTrustID:= vWellOrgStatusArray[1, i];
            7: iSearchingExpeditionID:= vWellOrgStatusArray[1, i];
            8: iExploitingExpeditionID:= vWellOrgStatusArray[1, i];
          end;//case
      end;

      IServer.SelectRows('spd_Get_Well_True_Result', 'Fluid_Type_ID', '', iWellUIN);
      vQR:=IServer.QueryResult;
      vTrueFluidIdArray:= ReduceArrayDimCount(vQR);

      IServer.SelectRows('spd_Get_Well_Target_Result', 'Fluid_Type_ID', '', iWellUIN);
      vQR:=IServer.QueryResult;
      vTargetFluidIdArray:= ReduceArrayDimCount(vQR);

      IServer.SelectRows('spd_Get_Abandoned_Well_Info',
                         varArrayOf(['Abandon_Reason_ID', 'dtm_Abandon_Date']),
                         '', iWellUIN);
      vQR:=IServer.QueryResult;
      iAbandonReasonID:=GetSingleValue(vQR, 0);
      dtmAbandonDate:=GetSingleValue(vQR,1);

      IServer.SelectRows('spd_Get_Suspended_Well_Info',
                         varArrayOf(['vch_Action_Type', 'dtm_Action_Date']),
                         '', iWellUIN);
      vQR:=IServer.QueryResult;
      sSuspendAction:=GetSingleValue(vQR);
      dtmSuspendActionDate:=GetSingleValue(vQR,1);

      IServer.SelectRows('spd_Get_Comment',
                         'vch_Comment_Text', '',
                         varArrayOf([iWellUIN,1]));
      vQR:=IServer.QueryResult;
      sCommentText:=GetSingleValue(vQR);

      IServer.SelectRows('spd_Get_Well_Dinamics',
                         varArrayOf(['num_Charges_Def_Year',
                                     'num_Progress_Per_Year',
                                     'num_Annual_Charges']),
                         '', iWellUIN);
      vDinamicsArray:=IServer.QueryResult;

      IServer.SelectRows('spd_Get_Info_Sources',
                         varArrayOf(['Doc_Type_Id','vch_Doc_Num','Foundation_Id']),
                         '', varArrayOf([iWellUIN, 1]));
      vDocumentsArray:=IServer.QueryResult;

    except on Exception do Result:=-1;
    end; //try..except
  end; //if iRes>0
end;

end.
