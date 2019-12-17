#Include 'Protheus.ch'

/*/{Protheus.doc} GatMsg
Gatilho para Mensagem de Orçamento
@author Thiago Meschiatti
@since 10/02/2016
@version 1.0
/*/
User Function GatMsg()
	local cMsg := ""
	
	if(M->CJ_ZZTPORC $ "M")
		cRet := GetNewPar("ZZ_MSGMAQ", "")
	elseif(M->CJ_ZZTPORC $ "P")
		cRet := GetNewPar("ZZ_MSGPECA", "")
	else
		cRet := GetNewPar("ZZ_MSGSERV", "")
	endif

Return alltrim(cRet)