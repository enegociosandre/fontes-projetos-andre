#Include 'Protheus.ch'
/*/{Protheus.doc}	M410PVNF
Ponto de entrada que realiza validação na preparação de documentos de saída.

@author				Gerson Schiavo
@since				05/04/2016
/*/

User Function M410PVNF()
    
	Local aArea	:= GetArea()
	Local lRet	:= .T. 
	
	If SC5->C5_ZZSTAT = "B"
		MsgAlert("Pedido de Venda está Bloqueado. Favor entrar em contato com o Responsável para Liberação !","Atenção")	
		lRet:= .f.
	endif

	RestArea(aArea)

Return lRet

