#Include 'Protheus.ch'
/*/{Protheus.doc}	M410PVNF
Ponto de entrada que realiza valida��o na prepara��o de documentos de sa�da.

@author				Gerson Schiavo
@since				05/04/2016
/*/

User Function M410PVNF()
    
	Local aArea	:= GetArea()
	Local lRet	:= .T. 
	
	If SC5->C5_ZZSTAT = "B"
		MsgAlert("Pedido de Venda est� Bloqueado. Favor entrar em contato com o Respons�vel para Libera��o !","Aten��o")	
		lRet:= .f.
	endif

	RestArea(aArea)

Return lRet

