#include "Protheus.ch"
#include "Totvs.ch"

/*
Nome       			: EICDI154_RDM() -> Nil
Descrição  			: PE na geracao do documento de entrada do EIC para o Compras
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

User Function EICDI154

Local cParam := ""

	If ValType(ParamIXB) == "A"
		cParam := Alltrim(ParamIXB[1])
	Else
		cParam := Alltrim(ParamIXB)
	EndIf

	&& Parametro para gravacao de campos na tabela SF1 - Cabecalho Documento de Entrada
	If cParam == "GRAVACAO_SF1"
		U_VMREIC07()
	EndIf 
		
	&& Parametro para gravacao no array de campos na tabela SD1 - Itens Documento de Entrada
	If cParam == "GRAVACAO_SD1"
		U_VMREIC04()
	EndIf   
Return