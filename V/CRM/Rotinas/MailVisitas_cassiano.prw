#Include 'Protheus.ch'
#Include 'TOTVS.ch'

#DEFINE NOME_VENDEDOR	1
#DEFINE MAIL_VENDEDOR	2
#DEFINE DATA_VISITA		3
#DEFINE DESC_VISITA		4
#DEFINE REGISTRO_VISITA	5

#DEFINE CABEC_MAIL	1
#DEFINE CORPO_MAIL	2
#DEFINE RODAPE_MAIL	3

/*/{Protheus.doc}	MailVisitas
Rotina de JOB para envio de e-mail diários aos vendedores, alertando sobre visitas pendentes e/ou expiradas

@author				Cassiano G. Ribeiro - Totvs IP Campinas
@since				30/03/2017
@return				nil
/*/
user function MailVisitas()
	
	private aNotiAviso	:= {}
	private aNotiExpira	:= {}
	
	abreEmpresa()
		notAvisoVisita()
		notExpiraVisita()
	fechaEmpresa()
	
return

static function notAvisoVisita()
	cargaNotAviso()
	envNotificacao("VISITA À EXPIRAR")
return

static function notExpiraVisita()
	cargaNotExpira()
	envNotificacao("VISITA EXPIRADA")
return

static function cargaNotAviso()
	
	local cAlias 	:= getNextAlias()
	local aAreaSD5	:= AD5->(GetArea())
	
	beginSql Alias cAlias
		SELECT AD5.R_E_C_N_O_ AS REG, A3_EMAIL, A3_NOME
	      FROM %TABLE:AD5% AD5
	      	   INNER JOIN %TABLE:AC5% AC5
	      	   		   ON %XFILIAL:AC5% = AC5_FILIAL
	      	   		  AND AC5_EVENTO = AD5_EVENTO
	      	   		  AND AC5_ZZENCE <> 'S'
				      AND AC5.%NOTDEL%
			   INNER JOIN %TABLE:SA3% A3
	      	   		   ON %XFILIAL:SA3% = A3_FILIAL
	      	   		  AND A3_COD = AD5_VEND
				      AND A3.%NOTDEL%
	    WHERE %XFILIAL:AD5% = AD5_FILIAL
	      AND AD5_ZZDTPV >= %EXP:dtos(dDataBase)%
	      AND AD5.%NOTDEL%		
	endSql
		
	(cAlias)->(dbGoTop())
		
	do while ( (cAlias)->(!Eof()) )
			
			AD5->(dbGoTo( (cAlias)->REG ))
			
			aadd(aNotiAviso, {alltrim((cAlias)->A3_NOME), alltrim((cAlias)->A3_EMAIL), dToc(AD5->AD5_ZZDTPV), alltrim(AD5->AD5_ZZPRVI), (cAlias)->REG } )
			
		(cAlias)->(dbSkip())
	EndDo
		
	(cAlias)->(dbCloseArea())
	restArea(aAreaSD5)
	
return

static function cargaNotExpira()
	
	local cAlias 	:= getNextAlias()
	local aAreaSD5	:= AD5->(GetArea())
	
	beginSql Alias cAlias
		SELECT AD5.R_E_C_N_O_ AS REG, A3_EMAIL, A3_NOME
	      FROM %TABLE:AD5% AD5
	      	   INNER JOIN %TABLE:AC5% AC5
	      	   		   ON %XFILIAL:AC5% = AC5_FILIAL
	      	   		  AND AC5_EVENTO = AD5_EVENTO
	      	   		  AND AC5_ZZENCE <> 'S'
				      AND AC5.%NOTDEL%
			   INNER JOIN %TABLE:SA3% A3
	      	   		   ON %XFILIAL:SA3% = A3_FILIAL
	      	   		  AND A3_COD = AD5_VEND
				      AND A3.%NOTDEL%
	     WHERE %XFILIAL:AD5% = AD5_FILIAL
	       AND AD5_ZZDTPV < %EXP:dtos(dDataBase)%
	       AND AD5.%NOTDEL%
	endSql
	
	(cAlias)->(dbGoTop())
	
	do while ( (cAlias)->(!Eof()) )
			
			AD5->(dbGoTo( (cAlias)->REG ))
			
			if AD5->AD5_ZZQNOT < SuperGetMv('ZZ_NUMTENT',.F.,1)
				aadd(aNotiExpira, {alltrim((cAlias)->A3_NOME), alltrim((cAlias)->A3_EMAIL), dToc(AD5->AD5_ZZDTPV), alltrim(AD5->AD5_ZZPRVI), (cAlias)->REG } )
			endIf
			
		(cAlias)->(dbSkip())
	endDo
	
	(cAlias)->(dbCloseArea())
	restArea(aAreaSD5)
	
return

static function envNotificacao(cAssunto)
	
	local nConexao	:= 1
	local cTexto	:= ""
	local oEmail	:= Nil
	local aDados	:= {}
	local cDestino	:= ""
	local nI 		:= 0
	local nK 		:= 0
	
	oEmail:= ZSPCOMAIL():New()
	oEmail:cServer 	:= AllTrim(GetMV("MV_RELSERV")) //--- Nome do Servidor de Envio de E-Mail.
	oEmail:cConta	:= AllTrim(GetMV("MV_RELACNT"))	//--- Conta a ser utilizada no envio de E-Mail.
	oEmail:cUserAut	:= ""//AllTrim(GetMV("MV_RELAUSR")) //--- Usuario para Autenticacao no Servidor de E-Mail.
	oEmail:cSenha 	:= AllTrim(GetMV("MV_RELPSW"))	//--- Senha da Conta de E-Mail.
	oEmail:cRemet	:= AllTrim(GetMV("MV_RELFROM"))	//--- Conta a ser utilizada no envio de E-Mail.
	oEmail:lAutent	:= GetMV("MV_RELAUTH")			//--- Servidor de E-Mail necessita de Autenticacão?
	oEmail:cConnect	:= 'SMTP'
	oEmail:aCabec 	:= {}
	nConexao 		:= oEmail:Conecta()
	
	if nConexao == 0
		
		aAdd(oEmail:aCabec,('Data Visita'  		))
		aAdd(oEmail:aCabec,('Descrição Visita'	))
		
		if cAssunto == "VISITA À EXPIRAR"
			
			for nI := 1 to Len(aNotiAviso)
				
				cAssunto		:= "[ CRM - Protheus ] VOCÊ TEM UMA VISITA PROGRAMADA EM: " + aNotiAviso[nI,DATA_VISITA] 
				oEmail:cRodape	:= "[ CRM - Protheus ]"				
				cDestino		:= aNotiAviso[nI,MAIL_VENDEDOR]
				cTexto 			:= aNotiAviso[nI,NOME_VENDEDOR]
				oEmail:aDados	:= {}
				aDados			:= {}
	
				aAdd(aDados,{	aNotiAviso[nI,DATA_VISITA],;
								aNotiAviso[nI,DESC_VISITA] })
				
				aAdd(oEmail:aDados,aDados)
				
				oEmail:aRet := oEmail:EmailForm(oEmail:aDados,cTexto)
				oEmail:cDest:= "cassiano.ribeiro@totvs.com.br;abracalenti@vermeer.com"//cDestino
				oEmail:Enviar(oEmail:cDest,"","",cAssunto,oEmail:aRet[CABEC_MAIL]+oEmail:aRet[CORPO_MAIL]+oEmail:aRet[RODAPE_MAIL],{})
				
			next nI
							
		elseif cAssunto == "VISITA EXPIRADA"
			
			for nK := 1 to Len(aNotiExpira)
				
				cAssunto		:= "[ CRM - Protheus ] SUA VISITA PROGRAMA EXPIROU EM: " + aNotiExpira[nK,DATA_VISITA]
				oEmail:cRodape	:= "[ CRM - Protheus ]"
				cDestino		:= aNotiExpira[nK,MAIL_VENDEDOR]
				cTexto 			:= aNotiExpira[nK,NOME_VENDEDOR]
				oEmail:aDados	:= {}
				aDados			:= {}
	
				aAdd(aDados,{	aNotiExpira[nK,DATA_VISITA],;
								aNotiExpira[nK,DESC_VISITA] })
								
				aAdd(oEmail:aDados,aDados)
									
				oEmail:aRet := oEmail:EmailForm(oEmail:aDados,cTexto)
				oEmail:cDest:= "cassiano.ribeiro@totvs.com.br;abracalenti@vermeer.com"//cDestino
				oEmail:Enviar(oEmail:cDest,"","",cAssunto,oEmail:aRet[CABEC_MAIL]+oEmail:aRet[CORPO_MAIL]+oEmail:aRet[RODAPE_MAIL],{})
				
				atuNotifExpira(aNotiExpira[nK,REGISTRO_VISITA])
				
			next nK
			
		endIf
		
		oEmail:Desconecta()
		
	endIf
	
return

static function atuNotifExpira(nRegistro)
	
	local aArea := AD5->(GetArea())
	
	if nRegistro <> 0
		dbSelectArea("AD5")
		AD5->(dbGoTo( nRegistro ))
		RecLock("AD5",.F.)
			AD5->AD5_ZZQNOT := AD5->AD5_ZZQNOT + 1
		AD5->(MsUnLock())
	endIf
	
	restArea(aArea)
	
return

static function abreEmpresa()
	
	RpcSetType(3)
    RpcSetEnv("01","01", ,,"FAT")
    
return

static function fechaEmpresa()
	
	RpcClearEnv() 
    
return