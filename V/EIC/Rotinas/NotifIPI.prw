#Include 'Protheus.ch'

User Function NotifIPI()
	local cQuery := ""

	cQuery 	:= 	" UPDATE " + RetSQLName("SB1")
	cQuery	+=	" SET   B1_IPI = "+str(SYD->YD_PER_IPI)+""
	cQuery	+=	" WHERE B1_FILIAL  = '" + xFilial("SB1") 	+ "' AND "
	cQuery	+=		"   B1_POSIPI = '" + SYD->YD_TEC		+ "' AND "
	cQuery	+=		"   D_E_L_E_T_ = ' ' "
	
	if TcSQLExec(cQuery) == 0
		TcSqlExec("Commit")
		TesteEmail()
	endif

Return


static function TesteEmail()
	
	local nOpcao		:= 0
	local nTimeOut		:= 10
	
	local cAviso		:= ""
	local cSmtp			:= GetNewPar("MV_RELSERV","")
	local cConta		:= GetNewPar("MV_RELACNT","")
	local cSenhaMail	:= GetMV("MV_RELPSW")
	local cRemetente	:= GetNewPar("MV_RELACNT","")
	local cDestinat		:= GetNewPar("ZZ_MAILIPI","")
	//local cAssunto		:= "Alteração na Alíquota de IPI"
	//local cMensagem		:= "A alíquota de IPI para o N.C.M. " + SYD->YD_TEC + " foi alterada para "+ alltrim(Transform( SYD->YD_PER_IPI, "@E 9,999,999,999,999.99")) + "."
	local cAssunto		:= "Alteração de dados do NCM"
	local cMensagem		:= "O cadastro do  N.C.M. " + SYD->YD_TEC + " foi alterado!!!"
	local cAnexo		:=  ""
	
	local lAutent	 	:= .T.
	local lEnvioOk		:= .F.
	local lSSL			:= .T.
	local lTLS			:= .T.
	
	local oSendMail		:= SendMail():newSendMail(cSmtp, cConta, cSenhaMail, cRemetente, lAutent, lSSL, lTLS, nTimeOut)
	
	MsAguarde({|| lEnvioOk := oSendMail:send(cDestinat, cAssunto, cMensagem, cAnexo) }, "Aguarde", "Enviando Email ...")
				
	if lEnvioOk
		Aviso("Aviso", "Email enviado com sucesso para " + cDestinat,  {"OK"})
	else
		Aviso("Atenção", oSendMail:getError(),  {"OK"})
	endIf
			
return
