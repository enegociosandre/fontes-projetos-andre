#include "protheus.ch"
#include "totvs.ch"

/*
Nome       			: EICFI400_RDM() -> Nil
Descrição  			: PE na geracao do titulo financeiro das despesas de importacao
Ponto	   			:
Nota       			: -
Ambiente   			: EASY IMPORT CONTROL
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

User Function EICFI400

Local cParam := ""

	If ValType(ParamIXB) == "A"
		cParam := Alltrim(ParamIXB[1])
	Else
		cParam := Alltrim(ParamIXB)
	EndIf

	If cParam == "FI400INCTIT" 
		U_VMREIC01()
	
	ElseIf cParam == "DEP_GRAVACAO_TIT"
	
		aAdd(aTit,{"E2_ZZINV"   ,SW9->W9_INVOICE	,NIL})	
		aAdd(aTit,{"E2_ZZHAWB"  ,SW9->W9_HAWB		,NIL})	
	EndIf
Return