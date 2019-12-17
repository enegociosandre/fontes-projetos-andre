#Include "protheus.ch"

/**
 * Fun��o:			EICA0003
 * Autor:			Ademar Pereira Junior
 * Data:			25/01/2016
 * Descri��o:		Atribui��o opera��o fiscal 
**/

User Function EICA0003()
Local aArea := GetArea()

	If Aviso("Aten��o","Confirma a execu��o da rotina de atribui��o de opera��o fiscal?",{"Sim","N�o"}) == 1
		DbSelectArea("SW8")
		// W8_FILIAL + W8_HAWB + W8_INVOICE + W8_FORN + W8_FORLOJ
		SW8->(DbSetOrder(1))
		If SW8->(DbSeek(xFilial("SW8") + SW6->W6_HAWB))
			While SW8->(!EOF()) .And. SW8->W8_HAWB == SW6->W6_HAWB
				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1") +  SW8->W8_COD_I))
				//COMENTADO por Cassiano em 26-07-16
//					If !Empty(SB1->B1_ZZOPERA)
						RecLock("SW8",.F.)
							SW8->W8_OPERACA := SB1->B1_ZZOPERA
						SW8->(MsUnlock())
//					EndIf
				//Fim Cassiano
				EndIf
				SW8->(DbSkip())
			EndDo
		EndIf
		
		Aviso("Aten��o","Rotina executada com sucesso!",{"Ok"})
	EndIf
	
RestArea(aArea)
Return

