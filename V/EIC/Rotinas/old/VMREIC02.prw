#include "protheus.ch"
#include "totvs.ch"

/*
Nome       			: VMREIC02
Descrição  			: Gravar informações de processo e invoice no contas a pagar
Ponto	   			: Executado do ponto de entrada EICDI500_RDM
Nota       			: -
Ambiente   			: IMPORTACAO
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Criação 		: 13/11/2015
Param. Pers 		: -
Campos Pers.		: -

Nº Revisão			: 001
Data Revisão		: 17/05/2016
Revisor				: Andre Borin - TOTVS IP        
Nota				: Posicionamento realizado na SWB e colocado a gravação do campo de TEM DI no SE2x
*/

User Function VMREIC02

Local aArea		:= GetArea()
Local aAreaSW6	:= SW6->(GetArea())
Local aAreaSWB	:= SWB->(GetArea())
Local aAreaSE2	:= SE2->(GetArea())
Local cPrefixo	:= ""
Local cNumDup	:= ""
Local cParcela	:= ""
Local cTipoTit	:= ""
Local Fornece	:= ""
Local Loja		:= ""
Local cHawb		:= ""
Local cInvoice	:= ""
Local cTemDI	:= ""

	cHawb  := SW6->W6_HAWB
	If Empty(SW6->W6_DI_NUM)
		cTemDI := "N"
	Else
		cTemDI := "S"
	EndIf

	dbSelectArea("SWB")
	SWB->(dbSetOrder(1))
	If SWB->(dbSeek(xFilial("SWB") + SW6->W6_HAWB ))
		While SWB->(!EOF()) .AND. ( SW6->W6_FILIAL + SW6->W6_HAWB == SWB->WB_FILIAL + SWB->WB_HAWB )
			
	        cPrefixo := SWB->WB_PREFIXO
	        cNumDup	 := SWB->WB_NUMDUP
	        cParcela := SWB->WB_PARCELA
	        cTipoTit := SWB->WB_TIPOTIT
	        cFornece := SWB->WB_FORN
	        cLoja	 := SWB->WB_LOJA
	        cInvoice := SWB->WB_INVOICE
	        
			dbSelectArea("SE2")
			SE2->(dbSetOrder(1))
			If SE2->(dbSeek( xFilial("SE2") + cPrefixo + cNumDup + cParcela + cTipotit + cFornece + cLoja ))
				
				If Empty(SE2->E2_ZZHAWB) .OR. Empty(SE2->E2_ZZINV) .OR. Empty(SE2->E2_ZZTEMDI)
					SE2->(RecLock("SE2",.F.))   
						SE2->E2_ZZHAWB	:= cHawb
						SE2->E2_ZZINV	:= cInvoice
						SE2->E2_ZZTEMDI := cTemDI
					SE2->(MsUnLock())
		  		EndIf
			EndIf
			SWB->(dbSkip())
		EndDo
	EndIf
	
RestArea(aAreaSE2)
RestArea(aAreaSWB)
RestArea(aAreaSW6)
RestArea(aArea)

Return