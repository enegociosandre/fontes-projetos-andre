#Include 'Protheus.ch'
#include 'parmtype.ch'
#Include "FWMVCDEF.CH"

/*/{Protheus.doc} CRMA620

PE DO MODEL CRMA620 
	
@author Cassiano Gonçalves Ribeiro
@since 21/06/2016
/*/
User Function CRMA620()
	
	local oObj      	:= PARAMIXB[1]
	local cPontoId 		:= PARAMIXB[2]
	Local cIdModel   	:= oObj:GetId()
	local cClasse    	:= oObj:ClassName()
	local nOperation 	:= oObj:GetOperation()
	local lRet 			:= .T.
	local oMdlAOVPri 	:= oObj:getModel("AOVMASTER")
	local oMdlAOVAll 	:= oObj:getModel("AOVDETAIL")
	local nX 			:= 0
	
	public __aAOVVermeer := {}
	
	if cPontoId == "MODELPOS"
		for nX := 1 to oMdlAOVAll:Length()
			oMdlAOVAll:GoLine( nX )
			if oMdlAOVAll:GetValue( "AOV_MARK" ) 
				aAdd( __aAOVVermeer ,{oMdlAOVAll:GetValue( "AOV_MARK" ), oMdlAOVAll:GetValue( "AOV_CODSEG" ) ,oMdlAOVAll:GetValue( "AOV_MRKDEL" ) ,oMdlAOVPri:GetValue( "AOV_CODSEG" ) } )
			endIf
		next nX
	endIf
	
Return lRet