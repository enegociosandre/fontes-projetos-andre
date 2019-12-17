#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"

/*
Nome       			: VMREIC06
Descri��o  			: Verifica se o Pedido de Compra est� liberado pela Al�ada
Ponto	   			: Executado na valida��o de usu�rio do campo W6_PO_NUM
Nota       			: -
Ambiente   			: IMPORTACAO
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Cria��o 		: 09/03/2016
Param. Pers 		: -
Campos Pers.		: -

N� Revis�o			: -
Data Revis�o		: -
Revisor				: -                 
Nota				: 
*/

User Function VMREIC06

Local lRet		:= .T.
Local lSW2SCR	:= GetMv("ZZ_SW2SCR")
Local cNumPC	:= ""

	If lSW2SCR
		dbSelectArea("SW2")
		SW2->(dbSetOrder(1))
		IF SW2->(dbSeek(xFilial("SW2") + M->W6_PO_NUM ))
		
			cNumPC := SW2->W2_PO_SIGA
			
			dbSelectArea("SC7")
			SC7->(dbSetOrder(1))
			If SC7->(dbSeek(xFilial("SC7") + cNumPC ))
				
				While !SC7->(EOF()) .AND. (xFilial("SC7") + cNumPC) == (SC7->C7_FILIAL + SC7->C7_NUM)
				
					If SC7->C7_CONAPRO == "B"
					
						MsgInfo("Nem todos os itens do Pedido de Compra foram aprovados. Verifique no Pedido de Compra quais os itens necessitam de aprova��o.","AVISO!")
						lRet := .T.
						Return(lRet)
					EndIf
				
					SC7->(dbSkip())
			    EndDo
	        EndIf
		EndIf
	EndIf

Return(lRet)