#Include 'Protheus.ch'

/*/{Protheus.doc} VldCentCus
Validação de Centro Custo
@type function
@author Thiago Meschiatti
@since 10/02/2016
@version 1.0
/*/
User Function VldCentCus()
	local lRet := .t.
	
	if FunName() == "MATA240"
		if empty(M->D3_CC) .and. empty(M->D3_OP)
			lRet := .f.
			Alert("Centro de Custo ou OP não foram informados!")
		endif
	elseif FunName() == "MATA241"
		if empty(cCC)
			lRet := .f.
			Alert("Centro de Custo não foi informado!")
		endif
	endif

Return (lRet)

