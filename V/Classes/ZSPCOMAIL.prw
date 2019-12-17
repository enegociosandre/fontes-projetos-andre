#INCLUDE "PROTHEUS.CH"
#INCLUDE "totvs.ch"


/*
* Funcao		:	ZSPCOMAIL
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:	Classe responsável pelo recebimento e envio do e-mail
* Retorno		: 	
*/
User Function ZSPCOMAIL; Return
Class ZSPCOMAIL
    &&propriedades para se conectar ao servidor de envio
	Data cServer	as String	// servidor de envio de e-mail
	Data nPorta 	as Integer	// porta do servidor de SMTP (padrão 25)
	Data cConta 	as String	// conta de e-mail para autenticar
	Data cSenha 	as String	// senha de e-mail para autenticar
	Data lAutent 	as Boolean	// se o servidor requer autenticação (Padrão Falso)
	Data cTipoAut 	as String 	// se requer SSL ou TLS (Padrão Nenhuma)
	Data cCodUser 	as String 	//código do usuário para recuperar informações sobre e-mail
	Data oMail 		as Object	//armazena objeto TMailManager usado nessa classe
	Data oMessage	as Object	//armazena objeto TMailManager usado nessa classe
	Data oArqLog	as Object	//armazena objeto TMailManager usado nessa classe
	Data lUsaCript	as Boolean
	Data lUsaAtach	as Boolean
	Data cUserAut	as String
	Data cTexto		as String
	Data cEof 		as String
	Data aCabec		as Array
	Data aDados  	as Array
	Data aItem  	as Array
	Data aRet	  	as Array
	Data cRodape	as String
	Data cCabecalho	as String
	Data cFile		as String
	Data cDir		as String
  	
    &&Propriedades para ENVIAR()
	Data cRemet 	as String	// remetente retirado do cadastro de usuário do Protheus
	Data cDest 		as String	// destinatário principal
	Data cCC 		as String	// com cópia para?
	Data cCCO  		as String	// com cópia oculta para? usado em DEFAUT() quando informa e-mail para auditoria
	Data cAssunto 	as String	// assunto do e-mail
	Data cBody 		as String	// corpo do e-mail
	Data cExtensao  as String
	Data cAnexo		as String
	Data aAnexo 	as Array	// array para anexar aquivos
	Data cConnect   as String

	METHOD NEW()
	METHOD CONECTA()
	METHOD DEFAUT()
	METHOD CONFIG(cServer,nPorta,cConta,cSenha,lAutent,cTipoAut)
	METHOD ENVIAR(cDest,cCC,cCCO,cAssunto,cBody,aAnexo)
	METHOD DESCONECTA()
	METHOD EMAILFORM()
ENDCLASS


/*
* Funcao		:
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:
* Retorno		:
*/
METHOD NEW() CLASS ZSPCOMAIL
	Local aDadUser	:= {} // array com dados do usuário
	::cServer		:= ""
	::nPorta		:= 0
	::cConta		:= ""
	::cSenha		:= ""
	::lAutent		:= .F.
	::cTipoAut		:= ""
	::cCodUser		:= RetCodUsr()
	::oMail			:= TMailManager():New()
	::oMessage		:= TMailMessage():New()
	::cRemet		:= ""
	::cDest 		:= ""
	::cCC		    := ""
	::cCCO			:= ""
	::cAssunto		:= ""
	::cBody			:= ""
	::cUserAut		:= ""
	::aAnexo		:= {}
	::aCabec		:= {}
	::aDados		:= {}
	::aRet			:= {}
	::cRemet		:= ""
	::lUsaCript		:= .F.
	::cRodape		:= ""
	::cCabecalho	:= ""
	::lUsaAtach		:= .F.
	::cAnexo        := ''
	::cConnect		:= 'SMTP'
RETURN

/*
* Funcao		:
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:
* Retorno		:
*/
METHOD DEFAUT() CLASS ZSPCOMAIL
	Local cServer		:= Alltrim(SuperGetMv('MV_RELSERV',.F.,''))
	Local nPorta     	:= 587
	Local cConta    	:= Alltrim(SuperGetMv('MV_RELACNT',.F.,''))
	Local cSenha		:= Alltrim(SuperGetMv('MV_RELPSW',.F.,''))
	Local cCopia		:= Alltrim(SuperGetMv('MV_MAILADT',.F.,''))
	Local cUserAut		:= Alltrim(SuperGetMv('MV_RELAUSR',.F.,''))
	Local lAutentica	:= SuperGetMv('MV_RELAUTH',.F.,.F.)
	Local cTipoAut  	:= ""
	Local nI        	:= 0
	Local nJ			:= 0

// se o servidor de SMTP tiver uma porta diferente da padrão (25) busca a informação do configurador
	nI:= at(":",cServer)
	If nI>0
		nJ:= Len(cServer)
		cServerPort:= Val(SubStr(cServer,nI+1,nJ-nI))
		cServer:= SubStr(cServer,1,nI-1)
	EndIf

// Busca tipo de criptografia quando autentica
	If lAutentica
		If ::lUsaCript
			cTipoAut := Alltrim(SuperGetMv('ZZ_RELCRIP',.F.,''))
			If cTipoAut==NIL
				cTipoAut:=""
			EndIf
		EndIf
	EndIf

	::cServer		:= cServer
	::nPorta		:= nPorta
	::cConta		:= cConta
	::cSenha		:= cSenha
	::lAutent		:= lAutentica
	::cTipoAut		:= cTipoAut
	::cCCO			:= cCopia
	::cUserAut		:= cUserAut
RETURN

/*
* Funcao		:
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:
* Retorno		:
*/
METHOD CONFIG(cServer,nPorta,cConta,cSenha,lAutent,cTipoAut) CLASS ZSPCOMAIL
	::cServer		:= cServer
	::nPorta		:= nPorta
	::cConta		:= cConta
	::cSenha		:= cSenha
	::lAutent		:= lAutent
	::cTipoAut		:= cTipoAut  // "SSL" ou "TLS" ou ""

	If ::cTipoAut==NIL
		::cTipoAut:=""
	EndIf

Return


/*
* Funcao		:
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:
* Retorno		:
*/
METHOD CONECTA() CLASS ZSPCOMAIL
	Local nRet 	:= 0 //variável de retorno das funções

	If (::cTipoAut == "SSL")
		::oMail:SetUseSSL(.T.)
	ElseIf (::cTipoAut == "TLS")
		::oMail:SetUseTLS(.T.)
	EndIf
		 
	If ::cConnect == 'SMTP'
	
		::oMail:Init("",::cServer,::cConta,::cSenha,0,::nPorta)
	
		nTimeOut := ::oMail:GetSMTPTimeOut()
		nRet := ::oMail:SetSMTPTimeout(nTimeOut) //2 min
		If nRet == 0
			conout("[ZSPCOMAIL].[SMTPTimeout] Set Sucess")
		Else
			conout(nRet)
			conout("[ZSPCOMAIL].[SMTPTimeout] Set Error:"+::oMail:GetErrorString(nret))
		Endif
	
		nRet := ::oMail:SMTPConnect()
	
		If nRet == 0
			conout("[ZSPCOMAIL].[SMTPConnect] Sucess")
		Else
			conout(nRet)
			conout("[ZSPCOMAIL].[SMTPConnect] Error"+::oMail:GetErrorString(nret))
		Endif
	
		If ::lAutent
			conout("[ZSPCOMAIL].[SMTPAuth] Enable")
			nRet := ::oMail:SMTPAuth(If(Empty(::cUserAut),::cConta,::cUserAut), ::cSenha)
			If nRet != 0
				conout("[ZSPCOMAIL].[SMTPAuth] Error:" + str(nRet,6) , ::oMail:GetErrorString(nRet))
			else
				conout("[ZSPCOMAIL].[SMTPAuth] Sucess")
			Endif
		Else
			conout("[ZSPCOMAIL].[SMTPAuth] Disable")
		Endif
	ElseIf ::cConnect == 'POP'
		
		::oMail:Init(::cServer,"",::cConta,::cSenha,::nPorta,0)
	
		nTimeOut := ::oMail:GetPOPTimeOut()
		nRet := ::oMail:SetPOPTimeOut(nTimeOut)
	
		If nRet == 0
			conout("[ZNFEMAIL].[POPTimeout] Set Sucess")
		Else
			conout(nRet)
			conout("[ZNFEMAIL].[POPTimeout] Set Error:"+::oMail:GetErrorString(nret))
		Endif
	
		nRet := ::oMail:PopConnect()
	
		If nRet == 0
			conout("[ZNFEMAIL].[PopConnect] Sucess")
		Else
			conout(nRet)
			conout("[ZNFEMAIL].[PopConnect] Error"+::oMail:GetErrorString(nret))
		Endif
	ElseIf ::cConnect == 'IMAP'
	
		::oMail:Init( ::cServer,"", ::cConta,::cSenha, ::nPorta)
	
		nRet := ::oMail:IMAPConnect()
	
		If nRet == 0
			conout("[ZNFEMAIL].[IMAPConnect] Sucess")
		Else
			conout(nRet)
			conout("[ZNFEMAIL].[IMAPConnect] Error"+::oMail:GetErrorString(nret))
		Endif
	EndIf

RETURN nRet

/*
* Funcao		:
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:
* Retorno		:
*/
METHOD ENVIAR(cDest,cCC,cCCO,cAssunto,cBody,aAnexo) CLASS ZSPCOMAIL
	Local nRet 	:= 0 //variável de retorno das funções
	Local nX    := 0
	 
	::aAnexo	:= aAnexo
	::cDest 	:=cDest
	::cCC 		:=cCC
	::cCCO 		:=if(::cCCO<>"",::cCCO + ';'+cCCO,cCCO)
	::cAssunto 	:=cAssunto
	::cBody 	:=cBody

	::oMessage:Clear()
	::oMessage:cFrom           := ::cRemet
	::oMessage:cTo             := cDest
	::oMessage:cCc             := ""
	::oMessage:cBcc            := ""
	::oMessage:cSubject        := cAssunto
	::oMessage:cBody           := cBody
	::oMessage:MsgBodyType( "text/html" )


	// Adiciona um anexo, nesse caso a imagem esta no root
	For nX := 1 To Len(::aAnexo)
		::oMessage:AttachFile( ::aAnexo[nX] )
	Next
	

	// Essa tag, é a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
	::oMessage:AddAttHTag( 'Content-ID: &lt;ID_siga.jpg&gt;' )

	nRet := ::oMessage:Send( ::oMail )

	If nRet == 0
		conout("[ZSPCOMAIL].[SEND] Sucess")
	Else
		conout(nret)
		conout("[ZSPCOMAIL].[SEND] Error:"+::oMail:GetErrorString(nret))
	Endif
Return nRet

/*
* Funcao		:
* Autor			:	João Zabotto
* Data			: 	05/05/2014
* Descricao		:
* Retorno		:
*/
METHOD DESCONECTA() CLASS ZSPCOMAIL
	Local nRet 	:= 0 

	If ::cConnect == 'SMTP'
		nRet := ::oMail:SmtpDisconnect()
		If nRet == 0
			conout("[ZSPCOMAIL].[SMTPDisconnect] Sucess")
		Else
			conout(nret)
			conout("[ZSPCOMAIL].[DISCONNECT] Error:" + ::oMail:GetErrorString(nret))
		Endif
	ElseIf ::cConnect == 'POP'
		nRet := ::oMail:PopDisconnect()
		If nRet == 0
			conout("[ZSPCOMAIL].[SMTPDisconnect] Sucess")
		Else
			conout(nret)
			conout("[ZSPCOMAIL].[DISCONNECT] Error:" + ::oMail:GetErrorString(nret))
		Endif
	ElseIf ::cConnect == 'IMAP'
		nRet := ::oMail:IMAPDisconnect()
		If nRet == 0
			conout("[ZSPCOMAIL].[SMTPDisconnect] Sucess")
		Else
			conout(nret)
			conout("[ZSPCOMAIL].[DISCONNECT] Error:" + ::oMail:GetErrorString(nret))
		Endif 
	EndIf
	
Return nRet

/*
* Metodo		:	EMAILFORM
* Autor			:	João Zabotto
* Data			: 	24/06/2014
* Descricao		:	Monta o HTML para envio do e-mail no final do processamento.
* Retorno		:
*/
Method EMAILFORM(uDados, cTexto) Class ZSPCOMAIL
	Local cHeader 	:= ""
	Local cBody 	:= ""
	Local cFooter	:= ""
	Local aAux		:= uDados
	Local nB		:= 0
	Local nX		:= 0

	cHeader := "<html>"
	cHeader += CRLF
	cHeader += "<head>"
	cHeader += CRLF
	cHeader += "<style type='text/css'>"
	cHeader += CRLF
	cHeader += "a:hover { text-decoration: underline"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += "a:link { text-decoration: none"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += "a:active {"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".texto { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #333333; text-decoration: none; font-weight: normal;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".Scroll { SCROLLBAR-FACE-COLOR: #DEDEDE; SCROLLBAR-HIGHLIGHT-COLOR: #DEDEDE; SCROLLBAR-SHADOW-COLOR: #ffffff; SCROLLBAR-3DLIGHT-COLOR: #ffffff; SCROLLBAR-ARROW-COLOR: #ffffff; SCROLLBAR-TRACK-COLOR: #ffffff; SCROLLBAR-DARKSHADOW-COLOR: #DEDEDE;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".combo { font-family: Arial, Helvetica, sans-serif; font-size: 11px; margin: 1px; padding: 1px; border: 1px solid #000000;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".comboselect { font-family: Arial, Helvetica, sans-serif; color: #666666; font-size: 11px; border: 1px #CCCCCC double;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".links { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #CC0000; text-decoration: none; font-weight: bold;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".links-clientes { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #003366; text-decoration: none"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".textobold { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #003366; text-decoration: none; font-weight: bold;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".textoItalico { font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: 7F7F7F; text-decoration: none; font-style: italic; font-weight: bold;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".titulo { font-family: Arial, Helvetica, sans-serif; font-size: 16px; color: #19167D; text-decoration: none; font-weight: bold;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".links-detalhes { font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: FF0000; text-decoration: none"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".TituloMenor { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #19167D; text-decoration: none; font-weight: bold;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".Botoes { font-family: Arial, Helvetica, sans-serif; font-size: 10px; font-weight: normal; text-decoration: none; margin: 2px; padding: 2px; cursor: hand; border: 1px outset #000000;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".Botoes2 { BACKGROUND-COLOR: lightgrey; COLOR: #000000; FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 11px; VERTICAL-ALIGN: top ; FONT-WEIGHT: bold"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".TableRowGreyMin1 { BACKGROUND-COLOR: lightgrey; COLOR: #000000; FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 11px; VERTICAL-ALIGN: top ; FONT-WEIGHT: bold"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".TableRowGreyMin2 {COLOR: #000000; FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 11px; VERTICAL-ALIGN: top ; FONT-WEIGHT: bold"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".TarjaTopoMenu { text-decoration: none; height: 6px; background-image: url('http://localhost/apmenu-right.jpg');"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".FundoMenu { text-decoration: none; background-image: url('http://localhost/apmenu-right.jpg');"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".FonteMenu { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #19167D; text-decoration: none; font-weight: bold;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".FonteSubMenu { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #19167D; text-decoration: none;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".FundoSubMenu { text-decoration: none; background-image: url('http://localhost/apmenu-right.jpg');"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".DivisoriaOpçõesMenu { text-decoration: none; background-color: #6680A6; background-image: url('http://localhost/apmenu-right.jpg');"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".TarjaTopoLogin { text-decoration: none; background-color: #426285; height: 6px;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".FundoLogin { text-decoration: none; background-color: #F7F7F7;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".FundoClaro { text-decoration: none; background-color: #fbfbfb;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".TituloDestaques { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; color: #19167D; text-decoration: none; font-weight: bold;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".TextoDestaques { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; color: #777777; text-decoration: none; font-weight: normal;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".FundoDestaques { text-decoration: none; background-color: #E5E5E5;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".FundoPontilhado { text-decoration: none; background-image: url('http://localhost/pontilhado.gif'); height: 5px"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".FundoPontilhadoVertical { text-decoration: none; background-image: url('http://localhost/pontilhado_vertical.gif'); height: 5px"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".TituloTabelas { font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #FFFFFF; text-decoration: none; font-weight: bold;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".FundoTituloTabela { text-decoration: none; background-color: #495E73;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".TarjaTopoCor { text-decoration: none; height: 6px; background-image: url('http://localhost/pontilhado.gif'); background-color: #6699CC"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".FundoTabelaDestaques { text-decoration: none; background-color: #495E73;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".comboselect-pequeno { font-family: Arial, Helvetica, sans-serif; color: #666666; font-size: 11px; border: 1px solid #CCCCCC;"
	cHeader += CRLF
	cHeader += "width: 132px; clear: none; float: none; text-decoration: none; left: 1px; top: 1px;"
	cHeader += CRLF
	cHeader += "right: 1px; bottom: 1px; clip: rect(1px 1px 1px 1px);"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".comboselect-grande { font-family: Arial, Helvetica, sans-serif; color: #666666; font-size: 11px; border: 1px #CCCCCC double; width: 415px;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".texto-layer { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #000000; text-decoration: none"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += ".tituloAvaliacao { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #19167D;"
	cHeader += CRLF
	cHeader += "text-decoration: none; font-weight: bold; vertical-align: middle; text-align: center; line-height: 12px;"
	cHeader += CRLF
	cHeader += "}"
	cHeader += CRLF
	cHeader += "</style>"
	cHeader += CRLF
	cHeader += "<title>Integração x PROTHEUS</title>"
	cHeader += CRLF
	cHeader += "</head>"
	cHeader += CRLF
	cHeader += "<body onLoad='loadval();'>"
	cHeader += CRLF
	cHeader += "<br>"
	cHeader += CRLF
	cHeader += "<table style='border-collapse: collapse;' id='AutoNumber2' align='center' border='0' bordercolor='#111111' cellpadding='0'"
	cHeader += CRLF
	cHeader += "cellspacing='0' height='32' width='100%'>"
	cHeader += CRLF
	cHeader += "<tbody>"
	cHeader += CRLF
	cHeader += "<tr>"
	cHeader += CRLF
	cHeader += "<td height='32' width='14%'>&nbsp;<img src='" + Alltrim(GetMv('ZZ_WFLOGO')) + "' border='0'></td>"
	cHeader += CRLF
	cHeader += "<td height='32' width='59%'>"
	cHeader += CRLF
	cHeader += "<p align='center'><strong><font color='#000000' face='Verdana, Arial, Helvetica, sans-serif' size='2'>"
	cHeader += Alltrim(SM0->M0_NOMECOM)+" - CNPJ : "+Alltrim(SM0->M0_CGC)+"<br>"
	cHeader += Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" / "+Alltrim(SM0->M0_ESTCOB)+"<br>"
	cHeader += "Fone : "+Alltrim(SM0->M0_TEL)+" - Fax : "+Alltrim(SM0->M0_FAX)+"</font></strong></p>"
	cHeader += "</td>"
	cHeader += CRLF
	cHeader += "<td height='32' width='27%'>"
	cHeader += CRLF
	cHeader += "</td>"
	cHeader += CRLF
	cHeader += "</tr>"
	cHeader += CRLF
	cHeader += "</tbody>"
	cHeader += CRLF
	cHeader += "</table>"
	cHeader += CRLF
	cHeader += "<br>"
	cHeader += CRLF
	cHeader += "<table align='center' border='0' cellpadding='0' cellspacing='0' width='100%'>"
	cHeader += CRLF
	cHeader += "<tbody>"
	cHeader += CRLF
	cHeader += "<tr background='http://localhost/pontilhado.gif'>"
	cHeader += CRLF
	cHeader += "<td class='TarjaTopoCor' height='5'> <img src='http://localhost/transparente.gif' height='1' width='1'></td>"
	cHeader += CRLF
	cHeader += "</tr>"
	cHeader += CRLF
	cHeader += "</tbody>"
	cHeader += CRLF
	cHeader += "</table>"
	cHeader += CRLF
	cHeader += "<br>"
	cHeader += CRLF
	cHeader += "<table style='border-collapse: collapse;' id='AutoNumber2' align='center' border='0' bordercolor='#111111'"
	cHeader += CRLF
	cHeader += "cellpadding='0' cellspacing='0' height='32' width='100%'>"
	cHeader += CRLF
	cHeader += "<tbody>"
	cHeader += CRLF
	cHeader += "<tr>"
	cHeader += CRLF
	cHeader += "<td height='32' width='59%'>"
	cHeader += CRLF
	
	If !Empty(cTexto)
		cHeader += CRLF
		cHeader += "<p align='Left'><font face='Arial' size='2'>" + cTexto + "</font></p>"			
		cHeader += CRLF
		cHeader += CRLF
	Endif

	cHeader += "<p align='center'><font face='Arial' size='5'>" + ::cCabecalho + "</font></p>"
	cHeader += CRLF

	cHeader += "</td>"
	cHeader += CRLF
	cHeader += "</tr>"
	cHeader += CRLF
	cHeader += "</tbody>"
	cHeader += CRLF
	cHeader += "</table>"
	cHeader += CRLF
	cHeader += "<br>"
	cHeader += CRLF
	cHeader += "<table align='center' bgcolor='#f7f7f7' border='1' bordercolor='#e5e5e5'"
	cHeader += CRLF
	cHeader += "cellpadding='6' cellspacing='0' width='99%'>"
	cHeader += CRLF
	cHeader += "<tbody>"
	cHeader += CRLF
	cHeader += "<tr>"
	cHeader += CRLF
	cHeader += "<td bordercolor='#FFFFFF' class='titulo' width='100%'>"
	cHeader += CRLF
	cHeader += "<table border='0' cellpadding='2' cellspacing='1' height='36' width='1024'>"
	cHeader += CRLF
	cHeader += "<tbody>"
	cHeader += CRLF
	cHeader += "<tr>"
	cHeader += CRLF
	cHeader += "</tr>"
	cHeader += CRLF
	cHeader += "</tbody>"
	cHeader += CRLF
	cHeader += "</table>"
	cHeader += CRLF
	cHeader += "<table border='0' cellspacing='2' height='41' width='100%'>"
	cHeader += CRLF
	cHeader += "<tbody>"
	cHeader += CRLF

	cHeader += " <tr class='texto-layer' bgcolor='#CCCCCC' align='Left'  >"
	cHeader += CRLF

	nB := 0
	For nB := 1 to Len(::aCabec)
		cHeader += "	<td align='left' height='19' width='6%' colspan='7'>"+::aCabec[nB]+"</TD>"
		cHeader += CRLF
	Next nB


	cHeader += "</TR>"
	cHeader += CRLF

	nB := 0
	For nB := 1 to Len(aAux)
	
		cBody += "<tr class='texto-layer' bgcolor='"+iif(Empty(aAux[nB][1][2]),"#cccccc","#ffffff")+"' align='Left'>"
		cBody += CRLF
	
		aItem := {}
		aItem := aAux[nB,1]
	
		nX := 0
		For nX := 1 To Len(aItem)
			cBody += "	<td align='left' height='19' width='6%' colspan='7'>"+aItem[nX]+"</TD>"
			cBody += CRLF
		Next nX
	
		cBody += "</tr>"
		cBody += CRLF
	
	
	Next nB

	cFooter += "</tbody>"
	cFooter += CRLF
	cFooter += "</table>"
	cFooter += CRLF
	cFooter += "&nbsp;&nbsp;"
	cFooter += CRLF
	cFooter += "</div>"
	cFooter += CRLF
	cFooter += "</td>"
	cFooter += CRLF
	cFooter += "</tr>"
	cFooter += CRLF
	cFooter += "</tbody>"
	cFooter += CRLF
	cFooter += "</table>"
	cFooter += CRLF
	cFooter += "</span>"
	cFooter += CRLF
	cFooter += "<br>"
	cFooter += CRLF
	cFooter += "<br>"
	cFooter += CRLF
	cFooter += "<table align='center' bgcolor='#f7f7f7' border='1' bordercolor='#e5e5e5'"
	cFooter += CRLF
	cFooter += "cellpadding='0' cellspacing='0' width='100%'>"
	cFooter += CRLF
	cFooter += "<tbody>"
	cFooter += CRLF
	cFooter += "<tr>"
	cFooter += CRLF
	cFooter += "<td bordercolor='#FFFFFF' width='100%'>"
	cFooter += CRLF

	If !Empty(::cRodape)
		cFooter += "<p align='center'><font face='Arial' size='2'>" + ::cRodape + "</font></p>"
		cFooter += CRLF
	EndIf

	cFooter += "</td>"
	cFooter += CRLF
	cFooter += "</tr>"
	cFooter += CRLF
	cFooter += "</tbody>"
	cFooter += CRLF
	cFooter += "</table>"
	cFooter += CRLF
	cFooter += "</body>"
	cFooter += CRLF
	cFooter += "</html>"

Return {cHeader,cBody,cFooter}
