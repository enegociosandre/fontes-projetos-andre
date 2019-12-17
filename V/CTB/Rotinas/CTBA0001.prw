#Include "totvs.ch"

/*/{Protheus.doc} CTBA0001
Função para criar conta contábil para cliente
@type function
@author Ademar Jr
@since 22/11/2016
/*/

User Function CTBA0001()
Local aArea		:= GetArea()
Local cAuxCnt	:= ""
Local cAuxCtAd	:= ""
Local lAuxCria	:= .T.
Local cAuxCtSt	:= ""

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

	DbSelectArea("SA1")

	If Upper(Alltrim(GetMv("MV_MCONTAB"))) == "CTB" .And. Empty(SA1->A1_CONTA)
		
		cAuxCnt  	:= ""
		cAuxCtSt	:= ""
		
		If SA1->A1_EST = "EX" .And. SA1->A1_TIPO = "X"
			cAuxCtSt := "11201003"
			lAuxCria := .T.
		Else
			cAuxCtSt := "11201001"
			lAuxCria := .T.
		EndIf	
		
		If lAuxCria
			cAuxCtAd	:= "21110001"
			cAuxCnt		:= cAuxCtSt + (SA1->A1_COD + SA1->A1_LOJA)
			
			DbSelectArea("CT1")
			CT1->(DbSetOrder(1))
			
			If !CT1->(DbSeek(xFilial("CT1") + cAuxCnt))            
		
				If Reclock("CT1",.T.)
					CT1->CT1_FILIAL	:= xFilial("CT1")
					CT1->CT1_CONTA 	:= cAuxCnt
					CT1->CT1_DESC01	:= SA1->A1_NOME
					CT1->CT1_CLASSE	:= "2"
					CT1->CT1_NORMAL	:= "1"
					CT1->CT1_RES	:= SA1->A1_COD + SA1->A1_LOJA
					CT1->CT1_CTASUP	:= cAuxCtSt
					CT1->CT1_ACITEM	:= "2"           
					CT1->CT1_ACCUST	:= "2"
					CT1->CT1_ACCLVL	:= "2"
					CT1->CT1_CCOBRG	:= "2"
					CT1->CT1_ITOBRG	:= "2"
					CT1->CT1_CLOBRG	:= "2"
					CT1->CT1_BLOQ	:= "2"
					CT1->CT1_BOOK	:= "001/002/003/004/005"
					CT1->CT1_CVD02	:= "1"
					CT1->CT1_CVD03	:= "1"
					CT1->CT1_CVD04	:= "1"
					CT1->CT1_CVD05	:= "1"
					CT1->CT1_CVC02	:= "1"
					CT1->CT1_CVC03	:= "1"
					CT1->CT1_CVC04	:= "1"
					CT1->CT1_CVC05	:= "1"
					CT1->CT1_DTEXIS	:= Ctod("01/01/1980")
					
					CT1->(MsUnlock())
				EndIf
			EndIf   
		EndIf
		
		// Atualiza a conta no cadastro do Cliente.
		DbSelectArea("SA1")
		If Reclock("SA1",.F.)
			SA1->A1_CONTA	:= cAuxCnt 
			SA1->A1_ZZCTAAD	:= cAuxCtAd
			
			SA1->(MsUnlock())
		EndIf
	EndIf
	
	RestArea(aArea)
Return