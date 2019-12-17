	#include "protheus.ch"
#include "totvs.ch"

/*
Nome       			: VMREIC04
Descrição  			: Informações adicionais no array do SD1 na geração da nota fiscal pelo EIC
Ponto	   			: Executado do ponto de entrada EICDI154_RDM
Nota       			: -
Ambiente   			: IMPORTACAO
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Criação 		: 13/11/2015
Param. Pers 		: -
Campos Pers.		: -

Nº Revisão			: -
Data Revisão		: -
Revisor				: -                 
Nota				: 
*/

User Function VMREIC04

Local nTxSisc	:= 0
Local cNrSerie	:= ""
Local cCobCamb	:= ""  
Local cTipoDes	:= ""

	nTxSisc := Work1->WKDESPICM - Work1->WKAFRMM
	
	dbSelectArea("SW3")
	SW3->(dbSetOrder(1))
	If SW3->(dbSeek(xFilial("SW3") + Work1->WKPO_NUM + Work1->WK_CC + Work1->WKSI_NUM + Work1->WKCOD_I ))
		While !SW3->(EOF()) .AND. (xFilial("SW3")+Work1->WKPO_NUM+Work1->WK_CC+Work1->WKSI_NUM+Work1->WKCOD_I) == (SW3->W3_FILIAL+SW3->W3_PO_NUM+SW3->W3_CC+SW3->W3_SI_NUM+SW3->W3_COD_I) 
			
			If Empty(SW3->W3_PGI_NUM)
				cNrSerie := SW3->W3_ZZNRSER
			EndIf
			SW3->(dbSkip())
		EndDo
	EndIf
	
	dbSelectArea("SW9")
	SW9->(dbSetOrder(1))
	If SW9->(dbSeek(xFilial("SW9") + Work1->WKINVOICE + Work1->WKFORN + Work1->WKLOJA + SW6->W6_HAWB ))
		dbSelectArea("SY6")
		SY6->(dbSetOrder(1))
		If SY6->(dbSeek(xFilial("SY6") + SW9->W9_COND_PA ))
			If SY6->Y6_TIPOCOB != "4"
				cCobCamb := "C"
			ElseIf SY6->Y6_TIPOCOB == "4"
				cCobCamb := "S"
			EndIf
		EndIf
	EndIf     
	
	dbSelectArea("SW2")
	SW2->(dbSetOrder(1))
	If SW2->(dbSeek(xFilial("SW2") + Work1->WKPO_NUM ))    
		aItem[20][2]:= SW2->W2_ZZLOCAL
	endif
	
	If SW6->W6_TIPODES == "14"
		cTipoDes := "E"
	Else
		cTipoDes := "N"
	EndIf

	aAdd(aItem,{"D1_ZZFOB_R"	,Work1->WKFOB_R		,Nil }) && Valor FOB em Reais
	aAdd(aItem,{"D1_ZZFRETE"	,Work1->WKFRETE		,Nil }) && Valor Frete em Reais
	aAdd(aItem,{"D1_ZZSEGUR"	,Work1->WKSEGURO	,Nil }) && Valor Seguro em Reais
	aAdd(aItem,{"D1_ZZVALII"	,Work1->WKIIVAL		,Nil }) && Valor II em Reais
	aAdd(aItem,{"D1_ZZCIF_R"	,Work1->WKCIF		,Nil }) && Valor CIF em Reais
	aAdd(aItem,{"D1_ZZDPADU"	,Work1->WKDESPCIF	,Nil }) && Valor Despesa Aduaneira em Reais
	aAdd(aItem,{"D1_ZZDPICM"	,nTxSisc			,Nil }) && Valor Taxa Siscomex em Reais
	aAdd(aItem,{"D1_ZZAFRMM"	,Work1->WKAFRMM		,Nil }) && Valor AFRMM em Reais
	aAdd(aItem,{"D1_ZZINV"		,Work1->WKINVOICE	,Nil }) && Numero da Invoice
	aAdd(aItem,{"D1_ZZCAMBI"	,cCobCamb			,Nil }) && Cobertura Cambial
	aAdd(aItem,{"D1_ZZDESPA"	,SW6->W6_DESP		,Nil }) && Código Despachante
	aAdd(aItem,{"D1_ZZTIPO"		,cTipoDes			,Nil }) && Tipo da declaração (entreposto)
	If !Empty(cNrSerie)
		aAdd(aItem,{"D1_ZZNRSER"	,cNrSerie			,Nil }) && Numero de Série
	EndIf
	
Return