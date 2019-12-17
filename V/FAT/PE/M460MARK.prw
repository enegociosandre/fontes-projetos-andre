#Include 'Protheus.ch'
/*/{Protheus.doc}	M460MARK
Ponto de entrada que realiza validação na preparação de documentos de saída.

@author				Gerson Schiavo
@since				05/04/2016
/*/

User Function M460MARK()
    
	Local aArea	:= GetArea()
	Local lRet	:= .T.
	
    DbSelectArea("SC9")
	SC9->(DbSetOrder(1))
	SC9->(DbGoTop())
	While SC9->(!Eof()) .And. SC9->C9_FILIAL == xFilial("SC9")

		If IsMark("C9_OK",ThisMark(),ThisInv())
		
			SC5->(DbSetOrder(1))
			SC5->(DbSeek(xFilial("SC5")+SC9->C9_PEDIDO))
			
			If SC5->C5_ZZSTAT = "B"
				lRet:= .f.
			endif
        endif
		SC9->(dbSkip())	
	enddo			               
    
	if !lRet
		MsgAlert("Pedido de Venda está Bloqueado. Favor entrar em contato com o Responsável para Liberação !","Atenção")	
	endif	

	RestArea(aArea)

Return lRet

