#include "Protheus.ch"
#include "Totvs.ch"

/*
Nome       			: EICAP100_RDM() -> Nil
Descri��o  			: PE na geracao da rotina de controle de c�mbio do EIC
Ponto	   			:
Nota       			: -
Ambiente   			: EASY IMPORT CONTROL
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Cria��o 		: 07/03/2017
Param. Pers 		: -
Campos Pers.		: -

N� Revis�o			: -
Data Revis�o		: -
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