#include "protheus.ch"
#include "totvs.ch"

/*
Nome       			: VMREIC08
Descri��o  			: Alerta de Item Anuente na confirma��o do PO
Ponto	   			: Executado do ponto de entrada EICDI400_RDM
Nota       			: -
Ambiente   			: IMPORTACAO
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Cria��o 		: 17/05/2016
Param. Pers 		: -
Campos Pers.		: -

N� Revis�o			: 001
Data Revis�o		: 10/06/2016
Revisor				: Andre Borin - TOTVS IP
Nota				: Inclu�do alerta para verificar se a NCM est� configurada como anuente e o produto n�o.

N� Revis�o			: -
Data Revis�o		: -
Revisor				: -
Nota				: -
*/

User Function VMREIC08

Local cFluxoYD := ""

	While WORK->(!EOF())
		dbSelectArea("SYD")
		SYD->(dbSetOrder(1))
		If SYD->(dbSeek(xFilial("SYD") + WORK->WK_TEC + WORK->WK_EX_NCM + WORK->WK_EX_NBM ))
			cFluxoYD := SYD->YD_ANUENTE
		EndIf

		If WORK->WKFLUXO == "1"
			MsgInfo("Produto Anuente: " + Alltrim(WORK->WKCOD_I) + " - " + Alltrim(WORK->WKDESCR),"ATEN��O")
		ElseIf cFluxoYD == "1"
			MsgInfo("NCM Anuente: " + Alltrim(WORK->WK_TEC) + " do Produto: " + Alltrim(WORK->WKCOD_I) + " - " + Alltrim(WORK->WKDESCR),"ATEN��O")
			MsgInfo("Para que o produto fique anuente, altere o item no PO para anuente e depois coloque no cadastro do produto como anuente tamb�m.","ATEN��O!!!")
		EndIf
		
		cFluxoYD := ""
		WORK->(DBSKIP())
	EndDo
Return