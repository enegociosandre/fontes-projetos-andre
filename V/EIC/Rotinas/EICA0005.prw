#INCLUDE "protheus.ch"

/**
 * Função:			EICA0005
 * Autor:			Ademar Pereira Junior
 * Data:			25/01/2016
 * Descrição:		Gravar dados pedido de compra 
**/

User Function EICA0005()
Local aArea 	:= GetArea()
Local cAuxNum	:= SC7->C7_NUM
Local cTesPad	:= ""

	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))
	If SC7->(DbSeek(xFilial("SC7") + cAuxNum))
		While SC7->C7_NUM == cAuxNum
			If RecLock("SC7",.F.)
				SC7->C7_CODTAB 	:= SW2->W2_ZZCODTB
				SC7->C7_CONTA	:= SW2->W2_ZZCONTA
				SC7->C7_LOCAL	:= SW2->W2_ZZLOCAL

				// Borin - 21/03/16 - Olhar o TES do Produto, pois não estava posicionando no SB1 antes.
				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				If SB1->(dbSeek(xFilial("SB1") + SC7->C7_PRODUTO ))
					
					cTesPad := SB1->B1_TE
					
					//Cassiano em 26-07-16
					if empty(SC7->C7_CONTA)
						SC7->C7_CONTA	:= SB1->B1_CONTA
					endIf
					//Fim Cassiano
				EndIf
				//Alterado por Cassiano em 26-07-16
//				SC7->C7_TES		:= If(!Empty(cTesPad),cTesPad,SW2->W2_ZZTES)
				SC7->C7_TES		:= If(!Empty(SW2->W2_ZZTES),SW2->W2_ZZTES,cTesPad)
				//Fim Cassiano
 				// Fim da Alteração
 							
				// Borin - 14/03/16 - Trazer OBS da SC para o PC
				dbSelectArea("SC1")
				SC1->(dbSetOrder(1))
				If SC1->(dbSeek(xFilial("SC1") + SC7->C7_NUMSC + SC7->C7_ITEMSC))
					SC7->C7_OBS := SC1->C1_OBS
				EndIf
				// Fim da Alteração
				
				SC7->(MsUnlock())
			EndIf
			
			SC7->(DbSkip())
		EndDo
	EndIf
	
	RestArea(aArea)
Return

