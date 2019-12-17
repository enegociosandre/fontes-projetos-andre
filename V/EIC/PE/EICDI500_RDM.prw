#include "Protheus.ch"
#include "Totvs.ch"
#include "rwmake.ch"

/*
Nome       			: EICDI500_RDM() -> Nil
Descrição  			: PE na rotina de embarque/desembaraço do EIC
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

User Function EICDI500()

Local cParam := ""

	If ValType(ParamIXB) == "A"
		cParam := Alltrim(ParamIXB[1])
	Else
		cParam := Alltrim(ParamIXB)
	EndIf

	If Alltrim(ParamIXB) == "FIM_GRAVA_CAPA" .OR. Alltrim(ParamIXB) == "POS_GRAVA_TUDO"
		U_VMREIC02()
	Endif 
Return