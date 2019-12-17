#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CONEMAIL บAutor  ณ Hermes Vieira Jr.  บ Data ณ  18/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Classe para envio do email.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen้rico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
CLASS CONEMAIL
  DATA cSERVER
  DATA cCTCONET
  DATA cSENHA
  DATA lCONECT
  DATA lAUTENTI                      
  Data cEmail         
  DATA cCodUser
  
  METHOD NEW(cSERVER, cCTCONET , cSENHA , lCONECT , lAUTENTI )
  METHOD CONECTAR()
  METHOD ENVIAR(cRemeten , cDestina , cAssunto , cTexto)
  METHOD DESCONEC()     
  Method PegaEmail()
ENDCLASS

METHOD NEW(cSERVER, cCTCONET , cSENHA , lCONECT , lAUTENTI ) CLASS CONEMAIL
  LOCAL aArea1 := GetArea()
  
  DEFAULT cSERVER  := ""
  DEFAULT cCTCONET := ""
  DEFAULT cSENHA   := ""
  DEFAULT lCONECT  := .F.
  DEFAULT lAUTENTI := GetMv("MV_RELAUTH")
  
  ::cEmail		:= AllTrim(GetMv("MV_RELFROM")) //""    
  ::cCodUser	:= RetCodUsr()

  ::cSERVER  := cSERVER
  ::cCTCONET := cCTCONET
  ::cSENHA   := cSENHA
  ::lCONECT  := lCONECT
  ::lAUTENTI := lAUTENTI

  RestArea(aArea1)
RETURN

METHOD CONECTAR() CLASS CONEMAIL
  LOCAL aArea2 := GetArea()
  LOCAL lRet
  
  CONNECT SMTP SERVER ::cSERVER ACCOUNT ::cCTCONET PASSWORD ::cSENHA RESULT lRet
  If lRet
    ::lCONECT := .T.
  Else
    ::lCONECT := .F.
    Alert("Erro ao conectar do servidor de email.")
    CONOUT("Erro ao conectar do servidor de email.")
  Endif
  
  RestArea(aArea2)
RETURN lRet

METHOD ENVIAR(cRemeten , cDestina , cAssunto , cTexto) CLASS CONEMAIL
  LOCAL aArea3 := GetArea()
  LOCAL lRet
  LOCAL cErroEm := ""
  LOCAL lAuten  := .T.
  
  DEFAULT cRemeten := ""
  DEFAULT cDestina := ""
  DEFAULT cAssunto := ""
  DEFAULT cTexto   := ""
  
  If ::lCONECT
  
    If ::lAUTENTI
      lAuten := MailAuth( ::cCTCONET , ::cSENHA )
    Endif   
      
    If lAuten 
      SEND MAIL FROM cRemeten TO cDestina SUBJECT cAssunto BODY cTexto RESULT lRet
      If !(lRet)
        GET MAIL ERROR cErroEm
        Alert("Erro no envio do email. Erro "+ cErroEm )
        Conout("Erro no envio do email. Erro "+ cErroEm)
      Endif
    Else
      Alert("Erro na autentica็ใo do email.")
      Conout("Erro na autentica็ใo do email.")
    Endif
  Else
    Alert("Servidor nใo contectado.")
    Conout("Servidor nใo contectado.")
    lRet := .F.
  Endif
  
  RestArea(aArea3)
RETURN lRet

METHOD DESCONEC() CLASS CONEMAIL
  Local aArea4 := GetArea()
  Local lRet
  
  If ::lCONECT
    DISCONNECT SMTP SERVER RESULT lRet
    If !(lRet)
      Alert("Erro ao desconectar do servidor de email.")
      Conout("Erro ao desconectar do servidor de email.")
    Endif
  Else
    Alert("Servidor nใo contectado.")
    Conout("Servidor nใo contectado.")
    lRet := .F.
  Endif
  
  RestArea(aArea4)
RETURN lRet                            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ PegaEmail  บ Autor ณ Hermes Vieira Jr. บ Data ณ 16/08/2007 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Metodo utilizado para descobrir o email do usuario do      บฑฑ
ฑฑบ          ณ sistema, fornecendo o id do usuario.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Method PegaEmail() Class CONEMAIL
	Local aDadUser	:= {}

	PswOrder(1)
	If PswSeek(::cCodUser, .T.)
		aDadUser	:= PswRet(1)
		::cEmail	:= Alltrim(aDadUser[1, 14])				// E-mail do Usuario Solicitado.
		If Empty(::cEmail)
			::cEmail := Alltrim(GetMV("MV_RELFROM"))
		Endif
	endif
Return 