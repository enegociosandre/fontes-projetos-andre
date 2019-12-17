#include "protheus.ch"
#include "totvs.ch"

/**
 * Objeto para Envio de Email
 *
 * @author Victor Hugo
 * @since 19/07/2012
 */    
user function _SendMail(); return
class SendMail

	data cServer			hidden			// Servidor de Email SMTP
	data cAccount	    	hidden			// Conta de Usuario
	data cPassword			hidden			// Senha de Usuario
	data cError				hidden			// Mensagem de Erro
	data cFrom				hidden			// Remetente do Email	
	data lAuthenticate		hidden			// Indica se o Servidor requer Autenticação
	data lConnected			hidden			// Indica se o Objeto esta conectado ao Servidor de Email
	data lSSL				hidden			// Indica se o Servidor utiliza conexão SSL
	data lTLS				hidden			// Indica se o Servidor utiliza conexão TLS
	data nTimeOut			hidden			// Time-Out do Servidor SMTP	
	data oMailManager		hidden 			// Objeto para Manipulação de Servidores de Email
	data oMailMsg			hidden			// Objeto para Manipulação das Mensagens de Email
	data nLastError			hidden			// Armazena o ultimo Codigo de Erro do Servidor de Email
	
	method getServer()						// Coleta o Servidor de Email
	method setServer()						// Define o Servidor de Email
	method getAccount()						// Coleta a Conta de Usuario
	method setAccount()						// Define a Conta de Usuario
	method getPassword()					// Coleta a Senha de Usuario
	method setPassword()					// Define a Senha de Usuario
	method getError()						// Coleta a Mensagem de Erro
	method setError()						// Define a Mensagem de Erro
	method getFrom()						// Coleta o Remetente do Email
	method setFrom()						// Define o Remetente do Email
	method isAuthenticate()                 // Indica se o Servidor requer Autenticação
	method setAuthenticate()			    // Define se o Servidor requer Autenticação 
	method isConnected()	                // Indica se o Objeto esta conectado ao Servidor de Email
	method setConnected()				    // Define se o Objeto esta conectado ao Servidor de Email
	method isSSL()							// Indica se o Servidor utiliza conexão SSL
	method setSSL()							// Define se o Servidor utiliza conexão SSL
	method isTLS()							// Indica se o Servidor utiliza conexão TLS
	method setTLS()							// Define se o Servidor utiliza conexão TLS
	method getTimeOut()						// Coleta o Time-Out do Servidor SMTP
	method setTimeOut()						// Define o Time-Out do Servidor SMTP
	
	method newSendMail()	constructor		// Construtor
	method connect()						// Conecta ao Servidor SMTP
	method send()							// Envia o Email
	method disconnect()						// Desconecta do Servidor SMTP
	method attachFile()						// Anexa arquivos a Mensagem
	method setConfirmRead()					// Define se irá solicitar confirmação de Leitura da Mensagem			
	
endClass

/**
 * Coleta o Servidor
 */
method getServer() class SendMail
return ::cServer

/**
 * Define o Servidor
 */
method setServer(cServer) class SendMail
	::cServer := cServer
return 

/** 
 * Coleta a Conta de Usuario
 */
method getAccount() class SendMail
return ::cAccount

/**
 * Define a Conta de Usuario
 */
method setAccount(cAccount) class SendMail
	::cAccount := cAccount
return 

/**
 * Coleta a Senha de Usuario
 */
method getPassword() class SendMail
return ::cPassword

/**
 * Define a Senha de Usuario
 */
method setPassword(cPassword) class SendMail
	::cPassword := cPassword
return      

/**
 * Coleta a Mensagem de Erro
 */
method getError() class SendMail
return ::cError

/**
 * Define a Mensagem de Erro
 */
method setError(cError) class SendMail
	::cError := cError
return

/**
 * Coleta o Remetente do Email
 */
method getFrom() class SendMail
return ::cFrom

/**
 * Define o Remetente do Email
 */
method setFrom(cFrom) class SendMail
	::cFrom := cFrom
return
                        
/**
 * Indica se o Servidor requer Autenticação
 */
method isAuthenticate() class SendMail
return ::lAuthenticate

/**
 * Define se o Servidor requer Autenticação
 */
method setAuthenticate(lAuthenticate) class SendMail
	::lAuthenticate := lAuthenticate
return 

/**
 * Indica se o Objeto esta conectado ao Servidor de Email
 */
method isConnected() class SendMail
return ::lConnected

/**
 * Define se o Objeto esta conectado ao Servidor de Email
 */
method setConnected(lConnected) class SendMail
	::lConnected := lConnected
return

/**
 * Indica se o Servidor utiliza conexão SSL
 */
method isSSL() class SendMail
return ::lSSL

/**
 * Define se o Servidor utiliza conexão SSL
 */
method setSSL(lSSL) class SendMail
	::lSSL := lSSL
return

/**
 * Indica se o Servidor utiliza conexão TLS
 */
method isTLS() class SendMail
return ::lTLS

/**
 * Define se o Servidor utiliza conexão TLS
 */
method setTLS(lTLS) class SendMail
	::lTLS := lTLS
return

/**
 * Coleta o Time-Out do Servidor SMTP
 */
method getTimeOut() class SendMail
return ::nTimeOut

/**
 * Define o Time-Out do Servidor SMTP
 */
method setTimeOut(nTimeOut) class SendMail
	::nTimeOut := nTimeOut
return

/**
 * Construtor
 */
method newSendMail(cServer, cAccount, cPassword, cFrom, lAuthenticate, lSSL, lTLS, nTimeOut) class SendMail
	
	local nPort 	:= 25
	local cStrPort  := ""
	
	default cServer 		:= GetMV("MV_RELSERV")
	default cAccount    	:= GetMV("MV_RELACNT") 
	default cPassword		:= GetMV("MV_RELPSW")
	default cFrom			:= GetMV("MV_RELFROM") 
	default lAuthenticate   := GetMV("MV_RELAUTH")
	default lSSL			:= GetMV("MV_RELSSL")
	default lTLS			:= GetMV("MV_RELTLS") 
	default nTimeOut		:= GetMV("MV_RELTIME") 
	
	if (":" $ cServer)
		cStrPort:= SubStr(cServer, At(":", cServer))
		cServer := StrTran(cServer, cStrPort, "")
		nPort 	:= Val(StrTran(cStrPort, ":", ""))
	endIf
	
	::setServer(cServer) 
	::setAccount(cAccount)
	::setPassword(cPassword)
	::setFrom(cFrom)
	::setAuthenticate(lAuthenticate)
	::setSSL(lSSL)
	::setTLS(lTLS)
	::setTimeOut(nTimeOut)
	::setConnected(.F.)	
	::setError("")
	
	::oMailManager := TMailManager():new()
	::oMailManager:setUseSSL(::isSSL())
	::oMailManager:setUseTLS(::isTLS())
	::oMailManager:setSmtpTimeOut(::getTimeOut())
	::oMailManager:init("", ::getServer(), ::getAccount(), ::getPassword(), 0, nPort)
	
	::oMailMsg := TMailMessage():new()
	::oMailMsg:clear() 
					             	
return

/**
 * Conecta ao Servidor de Email
 */
method connect() class SendMail
	
	::nLastError := ::oMailManager:smtpConnect()
	if (::nLastError == 0)
		::setConnected(.T.)	
	else
		setErrorMessage(self, "Falha ao conectar ao Servidor de Email")
	endIf
	                     	
return ::isConnected()

/**
 * Envia o Email
 */
method send(cTo, cSubject, cBody, cAttachment) class SendMail
	                                                                                 
	local lSendOk 		:= .F.
	local lAuthOk		:= .T.
	
	local cError		:= ""	
	local cFrom			:= ::getFrom()	
	
	default cAttachment	:= ""
	
	if !::isConnected()
		if !::connect()
			return .F.		
		endIf	
	endIf
	
	if ::isAuthenticate()
		::nLastError := ::oMailManager:smtpAuth(::getAccount(), ::getPassword())
		lAuthOk := (::nLastError == 0)
	endIf	
	
	if lAuthOk
		::oMailMsg:cFrom 	:= ::getFrom()	
		::oMailMsg:cTo 		:= cTo		
		::oMailMsg:cSubject := cSubject	
		::oMailMsg:cBody 	:= cBody		
		::attachFile(cAttachment)
		::nLastError := ::oMailMsg:send(::oMailManager)
		lSendOk := (::nLastError == 0)
	endIf
	
	if !lSendOk
		setErrorMessage(self, "Falha ao Enviar o Email") 
	endIf     
	
	if ::isConnected()
		::disconnect()	
	endIf
			
return lSendOk

/**
 * Desconecta do Servidor de Email
 */
method disconnect() class SendMail
	
	local cError		:= ""
	local lDisconnectOk := .F.
    
    if ::isConnected()				
    	::nLastError := ::oMailManager:smtpDisconnect() 
		if !(lDisconnectOk := (::nLastError == 0))
			setErrorMessage(self, "Falha ao desconectar do Servidor de Email")
		endIf		
	endIf
			
return lDisconnectOk

/**
 * Define as Mensagens de Erro
 */
static function setErrorMessage(oSendMail, cActionMessage) 
	
	local cErrorMsg := oSendMail:oMailManager:getErrorString(oSendMail:nLastError)
			
	oSendMail:setError(cActionMessage+CRLF+CRLF+cErrorMsg)
		
return

/**
 * Anexa arquivos a Mensagem
 */
method attachFile(cFile) class SendMail
	
	local lOk := .F.
	
	if File(cFile)
		lOk := !(::oMailMsg:attachFile(cFile) < 0) 
	endIf
	
return lOk

/**
 * Anexa arquivos a Mensagem
 */
method setConfirmRead(lConfirm) class SendMail
	
	::oMailMsg:setConfirmRead(lConfirm)
	
return