#INCLUDE "protheus.ch"

/**
 * Fun��o:			MT112IT
 * Autor:			Ademar Pereira Junior
 * Data:			25/01/2016
 * Descri��o:		PE itens solicitacao importacao
**/


User Function MT112IT()
Local aArea 	:= GetArea()
	
	// Gravar dados capa de solicitacao importacao
	U_EICA0006()
	
	RestArea(aArea)	
Return