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

N� Revis�o			: -
Data Revis�o		: -
Revisor				: -
Nota				: -
*/

User Function VMREIC08

	While WORK->(!EOF())
		If WORK->WKFLUXO == "1"
			MsgInfo("Produto Anuente: "+Alltrim(WORK->WKCOD_I)+" - "+Alltrim(WORK->WKDESCR),"ATEN��O")
		EndIf
		
		WORK->(DBSKIP())
	EndDo

Return