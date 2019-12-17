#include "protheus.ch"
#include "totvs.ch"

/*
Nome       			: EICPO400_RDM() -> Nil
Descri��o  			: PE na rotina de Purchase Order
Ponto	   			:
Nota       			: -
Ambiente   			: EASY IMPORT CONTROL
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Cria��o 		: 17/05/2016
Param. Pers 		: -
Campos Pers.		: -

N� Revis�o			: -
Data Revis�o		: -
Revisor				: -                 
Nota				: 
*/

User Function EICPO400

Local cParam := ""

	If ValType(ParamIXB) == "A"
		cParam := Alltrim(ParamIXB[1])
	Else
		cParam := Alltrim(ParamIXB)
	EndIf

	If cParam == "APOS_MARCA_ITEM"
		U_VMREIC08()
	EndIf
Return