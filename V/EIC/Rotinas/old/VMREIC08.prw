#include "protheus.ch"
#include "totvs.ch"

/*
Nome       			: VMREIC08
Descrição  			: Alerta de Item Anuente na confirmação do PO
Ponto	   			: Executado do ponto de entrada EICDI400_RDM
Nota       			: -
Ambiente   			: IMPORTACAO
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Criação 		: 17/05/2016
Param. Pers 		: -
Campos Pers.		: -

Nº Revisão			: -
Data Revisão		: -
Revisor				: -
Nota				: -
*/

User Function VMREIC08

	While WORK->(!EOF())
		If WORK->WKFLUXO == "1"
			MsgInfo("Produto Anuente: "+Alltrim(WORK->WKCOD_I)+" - "+Alltrim(WORK->WKDESCR),"ATENÇÃO")
		EndIf
		
		WORK->(DBSKIP())
	EndDo

Return