#include "Protheus.ch"
#include "Totvs.ch"

/*
Nome       			: EICAP100_RDM() -> Nil
Descrição  			: PE na geracao da rotina de controle de câmbio do EIC
Ponto	   			:
Nota       			: -
Ambiente   			: EASY IMPORT CONTROL
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Criação 		: 07/03/2017
Param. Pers 		: -
Campos Pers.		: -

Nº Revisão			: -
Data Revisão		: -
Revisor				: -                 
Nota				: 
*/

User Function EICAP100

Local cParam := ""

	If ValType(ParamIXB) == "A"
		cParam := Alltrim(ParamIXB[1])
	Else
		cParam := Alltrim(ParamIXB)
	EndIf               
	
	If cParam == "APOS_GRAVA"
		U_VMREIC02()
	EndIf
	
Return