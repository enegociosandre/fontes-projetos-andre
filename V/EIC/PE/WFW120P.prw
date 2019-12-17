#INCLUDE "protheus.ch"

/**
 * Função:			WFW120P
 * Autor:			Ademar Pereira Junior
 * Data:			25/01/2016
 * Descrição:		Manipulação dos dados gravados na tabela SC7 
**/

User Function WFW120P()
Local aArea 	:= GetArea()

	If AllTrim(FunName()) == "EICPO400"
		// Gravar dados pedido de compra
		U_EICA0005()
	EndIf

	RestArea(aArea)	
Return