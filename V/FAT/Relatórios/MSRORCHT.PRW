#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSRORCHT  ºAutor  ³Hermes Vieira Jr	 º Data ³  16/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Pedido de Venda / Orçamento / Despacho PV      º±±
±±           ³chamado via menu para envio via E-mail.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MP8 - TOP                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSRORCHT(lAuto,cNum)

Local 	lReg		:= .F. && Verifica a existencia de Registros
Local 	nLastKey	:= 0
Local 	titulo   	:= "Relatório de Orçamento"
Local 	cMens 		:= "Não há registros para os parametros informados !!"  
Local 	cEmail    	:= ""
Local 	cMailDig    := Space(255)  
Local 	oDL, oMail 

Local nCount		:= 0
Local nFrete
Local nTotal
Local cHtml
Local cOpt
Local cQuery  
Local cEMISSAO     

Local	cCond 		:=	""
Local	cDescri 	:= 	""
Local	cPedCli		:= 	""
Local	cDesc1		:=  ""
Local	cDesc2		:= 	""
Local	cDesc3		:= 	""
Local	cValid		:= 	""
Local	cTrans		:= 	""
Local	cNTrans		:= 	""
Local	cVend		:= 	""
Local	cNVend 		:= 	""
Local	cObs		:=  ""
Local 	cNomeCli	:=  ""
Local 	cEmailCli	:= 	""

Local cEmailCab		:= RetEmailUsr() //AllTrim(GetMV("ZZ_SCEMAIL")) //Ajuste Carlos Niemeyer - FSW - TOTVS RP - 23/11/2011
Local cEmail 		:= ""
Local cConta 		:= AllTrim(GETMV("MV_RELACNT"))
Local cEmailDe 		:= AllTrim(GETMV("MV_RELFROM"))
Local cPass 		:= AllTrim(GETMV("MV_RELPSW"))
Local cServ 		:= AllTrim(GETMV("MV_RELSERV"))
Local lAutent 		:= GETMV("MV_RELAUTH")
Local cLogoMail   	:= AllTrim(GETMV("ZZ_LOGOEXT"))

Local cPerg				:= "PERORC" 

Default lAuto := .F.
Default cNum  := ""

ValidPerg(cPerg)      

If lAuto
	mv_par01 := cNum
	mv_par02 := cNum
	mv_par03 := Ctod("01/01/1990")
	mv_par04 := Ctod("31/12/2060")
Else
	If !(Pergunte(cPerg,.T.))
		Return
	Endif  
Endif

If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
	return
Endif
     
	// Query que retorna os dados do orcamento e os dados dos itens.
	cQuery := "SELECT "
	cQuery += "		SCJ.CJ_NUM, SCJ.CJ_EMISSAO, SCJ.CJ_CONDPAG, SCJ.CJ_DESC1, SCJ.CJ_DESC2, SCJ.CJ_DESC3, SCJ.CJ_FRETE, SCJ.CJ_DESPESA, "
	cQuery += "		SCJ.CJ_DESC4, SCJ.CJ_DATA1, SCJ.CJ_DATA2, SCJ.CJ_DATA3, SCJ.CJ_DATA4, SCJ.CJ_PARC1, SCJ.CJ_PARC2,SCJ.CJ_COTCLI, "
	cQuery += "		SCJ.CJ_PARC3, SCJ.CJ_PARC4, SCJ.CJ_CLIENTE, SCJ.CJ_LOJA, SCJ.CJ_VALIDA, SCJ.CJ_ZZTRANS,SCJ.CJ_ZZVEND1,CAST(CJ_ZZOBS as varchar2(2000)) AS CJ_ZZOBS,SE4.E4_DESCRI, "
	cQuery += "		SCK.CK_ITEM, SCK.CK_NUM, SCK.CK_PRODUTO, SCK.CK_DESCRI, SCK.CK_UM,SCK.CK_TES,CK_ENTREG, "
	cQuery += "		SCK.CK_QTDVEN, SCK.CK_PRCVEN, SCK.CK_VALOR,SCK.CK_OBS, SB1.B1_IPI, "
	cQuery += "		SA1.A1_COD,	SA1.A1_NOME, SA1.A1_NREDUZ, SA1.A1_EMAIL, SA1.A1_END, SA1.A1_MUN, SA1.A1_EST, SA1.A1_DDD, SA1.A1_TEL, SA1.A1_FAX, SA1.A1_CEP, SA1.A1_BAIRRO, SA1.A1_CONTATO, SA1.A1_HPAGE, SA1.A1_CGC, SA1.A1_INSCR, "
	cQuery += "		SA3.A3_NOME,"
	cQuery += "		SA4.A4_NOME "
	cQuery += "FROM " + RetSqlName("SCJ") + "   SCJ "
	cQuery += "		INNER JOIN " + RetSqlName("SCK") + "   SCK ON "
	cQuery += "			SCK.CK_FILIAL = '" + xFilial("SCK")+ "' AND SCJ.CJ_NUM = SCK.CK_NUM AND SCK.D_E_L_E_T_ = ' ' "
	cQuery += "		INNER JOIN " + RetSqlName("SA1") + "   SA1 ON "
	cQuery += "				SA1.A1_FILIAL = '" + xFilial("SA1")+ "' AND SCJ.CJ_CLIENTE = SA1.A1_COD AND SCJ.CJ_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SE4") + "   SE4 ON "
	cQuery += "				SE4.E4_FILIAL = '" + xFilial("SE4")+ "' AND SCJ.CJ_CONDPAG = SE4.E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SB1") + "   SB1 ON "
	cQuery += "				SB1.B1_FILIAL = '" + xFilial("SB1")+ "' AND SCK.CK_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA3") + "   SA3 ON "
	cQuery += "				SA3.A3_FILIAL = '" + xFilial("SA3")+ "' AND SA3.A3_COD = SCJ.CJ_ZZVEND1 AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA4") + "   SA4 ON "
	cQuery += "				SA4.A4_FILIAL = '" + xFilial("SA4")+ "' AND SA4.A4_COD = SCJ.CJ_ZZTRANS AND SA4.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE SCJ.CJ_FILIAL = '" + xFilial("SCJ")+ "' AND SCJ.D_E_L_E_T_ = ' ' AND SCJ.CJ_NUM >= '"+ mv_par01 +"' AND SCJ.CJ_NUM <= '"+ mv_par02 +"' "
	If !Empty(mv_par03) .AND. !Empty(mv_par04)
		cQuery += " AND CJ_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
	EndIf
	cQuery += "ORDER BY SCJ.CJ_NUM, SCK.CK_ITEM "
			
		TCQUERY cQuery NEW ALIAS "cAlias"
	
		Count to nCount      
	
		cAlias->(dbgotop())
		
If 	cAlias->(EOF())
	MsgSTOP(cMens)
	cAlias->(dbCloseArea())
Else
	
	oEmail:= CONEMAIL():New(cServ, cConta , cPass ,, lAutent)
		
	oEmail:PegaEmail()
	cEmailDe := AllTrim(oEmail:cEmail)	
	
	Do While  cAlias->(!Eof())
		
		TCSETFIELD("cAlias","CJ_EMISSAO","D",08,00)   
		TCSETFIELD("cAlias","CJ_VALIDA","D") 

		cOrc 	:= cAlias->CJ_NUM
		cEmissao:= cAlias->CJ_EMISSAO
		
		
		cHtml   := '<body>'  
		
		cHtml   += '<table width="100%" border="0">'
  		cHtml   += '<tr>    
    	cHtml   += '	<td width="53%" height="99"><div align="left"><img src="'+cLogoMail+'" width="252" height="88"></div></td>'
    	cHtml   += '	<td width="47%"><div align="left"><p><font size="2" face="Arial, Helvetica, sans-serif"><strong>'+ RTrim(SM0->M0_NOMECOM)+ '<br>'
        
        cHtml   +=  AllTrim(SM0->M0_ENDENT) + ' ' + AllTrim(SM0->M0_CIDENT) + '/' + AllTrim(SM0->M0_ESTENT) + ' ' + LEFT(AllTrim(SM0->M0_CEPENT),5) + '-' + RIGHT(AllTrim(SM0->M0_CEPENT),3) + '<br>'
		cHtml   += '	E-mail: ' + Alltrim(cEmailCab) + '<br>'
        cHtml   += '	Fone: '+AllTrim(SM0->M0_TEL) + ' FAX: ' + AllTrim(SM0->M0_FAX)+'<br>'
       	cHtml   += ' 	CNPJ: '+ AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + ' - IE: ' +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999"))+ '</p>'
      	cHtml   += '	</strong></font></div></td>'
  		cHtml   += '</tr>'
		cHtml   += '</table>'         
		
		cHtml   += '<hr> '
		cHtml   += '<table width="100%" border="0">'
   		cHtml   += ' <tr>'
   		cHtml   += '   <td><font size="3" face="Arial, Helvetica, sans-serif"><strong>Orçamento N° '+cOrc+'</strong></font></td>'
 		cHtml   += '   <td><div align="right"><font size="3" face="Arial, Helvetica, sans-serif"><strong>Data: ' + DTOC(cEMISSAO)+ '</strong></font></div></td>'
 		cHtml   += ' </tr>'
		cHtml   += '</table>'
		cHtml   += '<hr>'                  
	
	cHtml   += '<table width="100%" border="0"> '
	cHtml   += '  <tr>' 
	cHtml   += '    <td width="12%"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cliente:</strong></font></td>'
	cHtml   += '    <td width="39%"><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_NOME+'</font></td>'
	cHtml   += '    <td width="9%"><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>'
	cHtml   += '    <td width="40%">&nbsp;</td>'
	cHtml   += '  </tr>'
	cHtml   += '  <tr>' 
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>E-Mail:</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_EMAIL+'</font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Contato:</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_CONTATO+'</font></td>'
	cHtml   += '  </tr>'
	cHtml   += '  <tr>' 
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Endereço:</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_END+'</font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Bairro:</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_BAIRRO+'</font></td>'
	cHtml   += '  </tr>'
	cHtml   += '  <tr>' 
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cidade:</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(cAlias->A1_MUN)+"/"+cAlias->A1_EST+'</font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cep:</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+LEFT(cAlias->A1_CEP,5) + "-" + RIGHT(cAlias->A1_CEP,3)+'</font></td>'
	cHtml   += '  </tr>'
	cHtml   += '  <tr>' 
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Tel:</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cAlias->A1_DDD + ') ' + LEFT(cAlias->A1_TEL,4) + '-' + SUBSTR(cAlias->A1_TEL,5,8) + '</font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>FAX:</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cAlias->A1_DDD + ') ' + LEFT(cAlias->A1_FAX,4) + '-' + SUBSTR(cAlias->A1_FAX,5,8) + '</font></td>'
	cHtml   += '  </tr>'
	cHtml   += '</table>'
	cHtml   += '	<table width="100%" border="1">'
	cHtml   += '<tr>' 
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Item</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Produto</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Descrição</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>UM</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Qtde.</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Unit.</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>%IPI</strong></font></td>'
	cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Entrega</strong></font></td>'
	cHtml   += '  </tr>'
    
	nTotal:=0
	
	nFrete   := cAlias->CJ_FRETE
	
	nDespesa := cAlias->CJ_DESPESA
	
	cCond 		:=	cAlias->CJ_CONDPAG
	cDescri 	:= 	cAlias->E4_DESCRI
	cPedCli		:= 	cAlias->CJ_COTCLI
	cDesc1		:=  cAlias->CJ_DESC1
	cDesc2		:= 	cAlias->CJ_DESC2
	cDesc3		:= 	cAlias->CJ_DESC3
	cValid		:= 	cAlias->CJ_VALIDA
	cTrans		:= 	cAlias->CJ_ZZTRANS
	cNTrans		:= 	cAlias->A4_NOME
	cVend		:= 	cAlias->CJ_ZZVEND1
	cNVend 		:= 	cAlias->A3_NOME
	cObs		:=  cAlias->CJ_ZZOBS
	cNomeCli	:= cAlias->A1_NREDUZ
	cEmailCli 	:= cAlias->A1_EMAIL
		
		While cOrc == cAlias->CJ_NUM   
		
			TCSETFIELD("cAlias","CK_ENTREG","D") 
		
			cHtml   += '  <tr>' 
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->CK_ITEM)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->CK_PRODUTO)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->CK_DESCRI)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+LTrim(cAlias->CK_UM)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(cAlias->CK_QTDVEN))+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(cAlias->CK_PRCVEN, PesqPict('SCK', 'CK_PRCVEN')))+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(cAlias->CK_VALOR, PesqPict('SCK', 'CK_VALOR')))+'</font></td>'
			
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") + cAlias->CK_TES)
			If SF4->F4_IPI == "S"
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(cAlias->B1_IPI,4,1))+'</font></td>'
			Else
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">0.0</font></td>'
			EndIf
			SF4->(dbCloseArea()) 

			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+DtoC(cAlias->CK_ENTREG)+'</font></td>'
			cHtml   += '  </tr>'      
			
			nTotal 	:= cAlias->CK_VALOR + nTotal
			
			cOrc 	:= cAlias->CK_NUM
			
			cAlias->(dbskip())
			
		EndDo  
				
		nTotal := nTotal + nFrete + nDespesa 
		
		cHtml   += '</table>'
		cHtml   += '<br>'
		
		cHtml   += '<table width="100%" border="0">'     
		
		cHtml   += '<tr>' 
    	cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Frete: </strong></font></div></td>'
    	cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nFrete, PesqPict('SCJ', 'CJ_FRETE'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
    	cHtml   += '<td width="8%">&nbsp;</td>'
    	cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor da Despesa:</strong></font></div></td>'
    	cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nDespesa, PesqPict('SCJ', 'CJ_DESPESA'))) + '</font></div></td>'
		cHtml   += '</tr><tr> '
    	cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>&nbsp;&nbsp;</strong></font></div></td>'
    	cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;&nbsp;</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
    	cHtml   += '<td width="8%">&nbsp;</td>'
    	cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total:</strong></font></div></td>' 
    	cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nTotal, PesqPict('SCK', 'CK_VALOR'))) + '</font></div></td>'
    	cHtml   += "</tr>"
		
		cHtml   += '</table>' 
	
		cHtml   += '<hr>  '
		cHtml   += '<table width="100%" border="0">'
		cHtml   += '  <tr> '
		cHtml   += '    <td colspan="2"><div align="center"><strong><font size="3" face="Arial, Helvetica, sans-serif">Informações Gerais</font></strong></div></td> '
		cHtml   += '  </tr>'
		cHtml   += '  <tr>' 
		cHtml   += '    <td> <p><strong><font size="2" face="Arial, Helvetica, sans-serif">Forma de Pagamento:</font></strong></p></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+ cCond + ' - ' + cDescri +'</font></td>'
		cHtml   += '  </tr>' 
		cHtml   += '  <tr> '
		cHtml   += '    <td width="23%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Nº Orçamento Cliente:</font></strong></td>'
		cHtml   += '    <td width="77%"><font size="2" face="Arial, Helvetica, sans-serif">'+ cPedCli +'</font></td>'
		cHtml   += '  </tr>'  
		cHtml   += '  <tr> '
		cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Descontos %:</font></strong></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(TRANSFORM(cDesc1, PesqPict('SCJ', 'CJ_DESC1'))) + ' + ' + AllTrim(TRANSFORM(cDesc2, PesqPict('SCJ', 'CJ_DESC2'))) + ' + ' + AllTrim(TRANSFORM(cDesc3, PesqPict('SCJ', 'CJ_DESC3')))+'</font></td> '
		cHtml   += '  </tr>' 
		cHtml   += '  <tr> '
		cHtml   += '    <td width="23%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Validade:</font></strong></td>'
		cHtml   += '    <td width="77%"><font size="2" face="Arial, Helvetica, sans-serif">'+ DTOC(cValid) +'</font></td>'
		cHtml   += '  </tr>'  
		cHtml   += '  <tr> '
		cHtml   += '    <td width="23%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Transportadora:</font></strong></td>'
		cHtml   += '    <td width="77%"><font size="2" face="Arial, Helvetica, sans-serif">('+ cTrans + ') ' + cNTrans + '</font></td>'
		cHtml   += '  </tr>'
		cHtml   += '  <tr> '
		cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Vendedor:</font></strong></td> '
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cVend + ') ' +cNVend  + '</font></td>'
		cHtml   += '  </tr> '      
		cHtml   += '  <tr> '
		cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Obs.:</font></strong></td> '
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+SubStr(cObs,1,100)+'</font></td>'
		cHtml   += '  </tr>'  
		cHtml   += '  <tr> '
		cHtml   += '    <td colspan="2"><font size="2" face="Arial, Helvetica, sans-serif">'+SubStr(cObs,101,100)+'</font></td>'
		cHtml   += '  </tr>'
		cHtml   += '  <tr> '
		cHtml   += '    <td colspan="2"><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td> '
		cHtml   += '  </tr>'
		cHtml   += '</table>' 
		cHtml   += '<hr>'
		
		oEmail:CONECTAR()
		
		cEmail := U_SU5Orc(cOrc)   
		If Empty(cEmail)
			cEmail := Alltrim(cEmailCli)
		Endif

		cMailDig := PADR(cEmail,255)                                    
	
		Define MsDialog oDL Title "E-mail do Cliente " + cNomeCli From 0, 0 To 70, 330 Pixel Style 128
		oDL:lEscClose := .f.
		Define Font oBold Name "Arial" Size 0, -13 Bold
		@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDL Size 30, 120 NoBorder When .f. Pixel
		@ 003,040 Say "E-Mail: " Font oBold Pixel
		@ 014, 030 To 016, 400 Label '' Of oDL  Pixel                
		@ 003,070 MsGet oEndMa  		Var cMailDig  					Size 090,008 Pixel //	Valid cMailDig <> Space(60) .AND. "@" $ cMailDig 
		@ 020, 120 Button "Confirmar" 		Size 40, 13 Pixel Of oDL Action oDL:End()
		Activate MsDialog oDL Centered 
			     
       	//cEmail := IIF(!Empty(cMailDig), cEmail + ";" + cMailDig, cEmail) //Corrigido por Carlos Niemeyer - FSW - Totvs RP - 23/11/2011
       	cEmail := AllTrim(cMailDig)
			
		If oEmail:ENVIAR(cEmailDe,alltrim(cEmail),"Relatório de Orçamento",cHtml)
			MsgInfo("Relatório do Orçamento " + cOrc + " Enviado com Sucesso para '" + cEmail + "'.","Envio de E-mail")
			//MsgInfo("Relatório Enviado com Sucesso!!!","Envio de E-mail")
		EndIF
		
	EndDo 
	cAlias->(dbCloseArea())
EndIF	

Return .T.       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Hermes Vieira Jr.   º Data ³  15/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se existe um grupo de perguntas caso contrario o    º±±
±±º          ³ o grupo de perguntas e criado.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 - DB2                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))


// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs, {cPerg, "01", "Orçamento de "        		,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SCJ"})
aAdd(aRegs, {cPerg, "02", "Orçamento até "        		,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SCJ"})
aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "04", "Data até "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
//aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
//aAdd(aRegs, {cPerg, "06", "Produto até "     			,"" ,"" ,"mv_ch6", "C", 06, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
//aAdd(aRegs, {cPerg, "03", "Onde Criar?"  			,"" ,"" ,"mv_ch3", "C", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)
  
Return .T.

//Retorna o Email do Usuário Logado ou informado
Static Function  RetEmailUsr(cCodUser)
Local aDadUser	:= {}
Local cEmail	:= ""

	Default cCodUser := RetCodUsr()

	PswOrder(1)
	If PswSeek(cCodUser, .T.)
		aDadUser:= PswRet(1)
		cEmail	:= Alltrim(aDadUser[1, 14])	// E-mail do Usuario
	Endif
	
Return (cEmail)