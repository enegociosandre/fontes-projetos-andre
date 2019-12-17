#Include 'Protheus.ch'

/*/{Protheus.doc} GatDesc
Gatilho para descrição do Cliente/Fornecedor no Pedido de Vendas
@author Thiago Meschiatti
@since 10/02/2016
@version 1.0
/*/
User Function GatDesc(cTabela)
	local aAreaSA1		:= SA1->(GetArea())
	local aAreaSA2		:= SA2->(GetArea())
	local cRet 	:= ""
	
//	default lBrowse := .f.

	if cTabela $ "SC5"
		if INCLUI .or. ALTERA
			if M->C5_TIPO $ "DB"
				cRet := Posicione("SA2", 1, xFilial("SA2") + M->(C5_CLIENTE + C5_LOJACLI), "A2_NOME")
			else
				cRet := Posicione("SA1", 1, xFilial("SA1") + M->(C5_CLIENTE + C5_LOJACLI), "A1_NOME")
			endif
		endif
	else
		if INCLUI .or. ALTERA
		endif
	endif
	
	RestArea(aAreaSA2)
	RestArea(aAreaSA1)

Return (cRet)

