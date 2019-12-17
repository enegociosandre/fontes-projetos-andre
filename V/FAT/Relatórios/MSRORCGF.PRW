#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"

/**
 * Rotina		:	MSRORCGF
 * Autor		:	Winston Dellano de Castro
 * Data		    :	27/10/2006
 * Descrição	:	Rotina responsável pela impressão do Orçamento de Vendas
 * Modulo		:  	Faturamento
**/

User Function MSRORCGF(lAuto,cNumero)
	Local cTitulo      := "Relatório de Orçamento de Vendas"
	Local nCount       := 0  
	Local cPerg        := "PERORC" 
	
	Default lAuto      := .F.
	Default cNumero    := ""
	
	Private cOrcamento := ""    
	Private cEmissao   := ""
	Private nQtdPag    := 0
	Private aTotaIpi   := {0,0}                                      // Controle do Valor Total do IPI
	Private nTotaIcm   := 0
	Private nTotalIss  := 0
	Private nTotalOrc  := 0
	Private nTotDescIt := 0
	Private oFont1     := TFont():New("Arial",09,14,   ,.T.,,,,,.F.) // Parametros TFonte ("Tipo Fonte", ,Tamanho Fonte , , ,Italico (.T./.F.))
	Private oFont2     := TFont():New("Arial",07,08,   ,.F.,,,,,.F.) // Normal
	Private oFont3     := TFont():New("Arial",09,10,.T.,.T.,,,,,.F.) // Negrito
	Private oFont4     := TFont():New("Arial",09,14,.T.,.T.,,,,,.T.) // Negrito - Sublinhado
	Private oFont5     := TFont():New("Arial",09,10,   ,.F.,,,,,.F.) // Negrito
	Private oPrint     := Nil
	
	lAuto := upper(alltrim(funName())) == "MATA415"
	
	// Instânciação do Objeto OPrint
	oPrint := TMSPrinter():New()
	oPrint:SetPaperSize(9)
	
	ValidPerg(cPerg)
	
	If lAuto
		mv_par01 := SCJ->CJ_NUM
		mv_par02 := SCJ->CJ_NUM
		mv_par03 := Ctod("01/01/1990")
		mv_par04 := Ctod("31/12/2060")
	Else
		If !(Pergunte(cPerg,.T.))
			Return
		EndIf  
	EndIf
	     
	// Query que retorna os dados do orcamento e os dados dos itens.
	cQuery := "SELECT CJ_NUM,CJ_EMISSAO,CJ_CONDPAG,CJ_DESC1,CJ_DESC2,CJ_DESC3,CJ_FRETE, " + CRLF
	cQuery += " 	  CJ_FRETAUT, CJ_SEGURO,CJ_ZZVEND2, CJ_LOJAENT, CJ_ZZTPFRE, " + CRLF
	cQuery += "       CJ_DESPESA,CJ_DESC4,CJ_DATA1,CJ_DATA2,CJ_DATA3,CJ_DATA4,CJ_PARC1, " + CRLF
	cQuery += "       CJ_PARC2,CJ_COTCLI,CJ_PARC3,CJ_PARC4,CJ_CLIENTE,CJ_LOJA,CJ_VALIDA," + CRLF
	cQuery += "       CJ_ZZTRANS,CJ_ZZVEND1,CK_ITEM,CK_NUM,CK_PRODUTO,CK_DESCRI,CK_UM,  " + CRLF
	cQuery += "       CK_ENTREG,B1_POSIPI,B1_GARANT, B1_PERGART,B1.R_E_C_N_O_ AS RECNO1," + CRLF
	if "MSSQL" $ upper(alltrim(TCGetDB())) 
		cQuery += "       CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),CJ_ZZOBS)) CJ_ZZOBS, " + CRLF
		cQuery += "       CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),CJ_ZZOBS2)) CJ_ZZOBS2," + CRLF
	elseif "ORACLE" $ upper(alltrim(TCGetDB()))
		cQuery += "       CAST(CJ_ZZOBS as varchar2(2000)) CJ_ZZOBS,						" + CRLF
		cQuery += "       CAST(CJ_ZZOBS2 as varchar2(2000)) CJ_ZZOBS2,						" + CRLF
	endif
	cQuery += "       CK_TES,CK_QTDVEN,CK_PRCVEN,CK_VALOR,CK_OBS,B1_IPI,A1.A1_END,  	" + CRLF
	cQuery += "       A1.A1_NOME,A1.A1_EMAIL,A1.A1_MUN,A1.A1_EST,A1.A1_DDD,A1.A1_TEL,  	" + CRLF
	cQuery += "       A1.A1_FAX,A1.A1_CEP,A1.A1_CONTATO,A1.A1_BAIRRO,A1.A1_HPAGE,      	" + CRLF
	cQuery += "       A1.A1_COD,A1.A1_CGC,A1.A1_INSCR,A1.A1_GRPTRIB,A1.A1_TIPO,      	" + CRLF
	cQuery += "       A1.A1_ENDENT, A1.A1_BAIRROE, A1.A1_ESTE, A1.A1_MUNE ,  		" + CRLF
	cQuery += "       ISNULL(A3.A3_NOME,'')   A3_NOME,B1_GRTRIB,B1_PICM,                " + CRLF
	cQuery += "       ISNULL(A4_NOME,'')   A4_NOME,                                     " + CRLF
	cQuery += "       ISNULL(E4_DESCRI,'') E4_DESCRI, CJ_MOEDA,                         " + CRLF
	cQuery += "       ISNULL(A32.A3_NOME,'') NOMEVEND2 	                                " + CRLF
	cQuery += "FROM "       + RetSqlName("SCJ")+" CJ                                    " + CRLF
	cQuery += "INNER JOIN " + RetSqlName("SCK")+" CK                                    " + CRLF
	cQuery += "ON CK_FILIAL = '"+xFilial("SCK")+"' AND                                  " + CRLF
	cQuery += "   CK_NUM    = CJ_NUM AND                                                " + CRLF
	cQuery += "   CK.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "INNER JOIN "+  RetSqlName("SA1")+" A1                                    " + CRLF
	cQuery += "ON A1.A1_FILIAL = '"+xFilial("SA1")+"' AND                               " + CRLF
	cQuery += "   A1.A1_COD    = CJ_CLIENTE AND                                         " + CRLF
	cQuery += "   A1.A1_LOJA   = CJ_LOJA    AND                                         " + CRLF
	cQuery += "   A1.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "INNER JOIN " + RetSqlName("SB1")+" B1                                    " + CRLF
	cQuery += "ON B1_FILIAL = '"+xFilial("SB1")+"' AND                                  " + CRLF
	cQuery += "   B1_COD    = CK_PRODUTO AND                                            " + CRLF
	cQuery += "   B1.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "LEFT JOIN " +  RetSqlName("SE4")+" E4                                    " + CRLF
	cQuery += "ON E4_FILIAL = '"+xFilial("SE4")+"' AND                                  " + CRLF
	cQuery += "   E4_CODIGO = CJ_CONDPAG AND                                            " + CRLF
	cQuery += "   E4.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "LEFT JOIN " +  RetSqlName("SA3")+" A3                                    " + CRLF
	cQuery += "ON A3_FILIAL = '"+xFilial("SA3")+"' AND                                  " + CRLF
	cQuery += "   A3_COD    = CJ_ZZVEND1 AND                                            " + CRLF
	cQuery += "   A3.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "LEFT JOIN " +  RetSqlName("SA3")+" A32                                   " + CRLF
	cQuery += "ON A32.A3_FILIAL = '"+xFilial("SA3")+"' AND                              " + CRLF
	cQuery += "   A32.A3_COD    = CJ_ZZVEND2 AND                                        " + CRLF
	cQuery += "   A32.D_E_L_E_T_ = ' ' 													" + CRLF
	cQuery += "LEFT JOIN " +  RetSqlName("SA4")+" A4                                    " + CRLF
	cQuery += "ON A4_FILIAL = '"+xFilial("SA4")+"' AND                                  " + CRLF
	cQuery += "   A4_COD    = CJ_ZZTRANS AND                                            " + CRLF
	cQuery += "   A4.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "WHERE CJ_FILIAL = '"+xFilial("SCJ")+ "' AND                              " + CRLF
	cQuery += "     CJ_NUM     BETWEEN '"+ mv_par01     +"' AND '"+ mv_par02 +"'     AND" + CRLF
	If !Empty(mv_par03) .AND. !Empty(mv_par04)
		cQuery += " CJ_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' AND" + CRLF
	EndIf
	cQuery += "      CJ.D_E_L_E_T_ = ' '                                                " + CRLF
	cQuery += "ORDER BY CJ_NUM,CK_ENTREG, CK_ITEM                                                  " + CRLF
			
	TCQUERY changequery(cQuery) NEW ALIAS "QRY"
	
	Count to nCount
	
	QRY->(dbgotop())
	
	If QRY->(Eof())
		MsgSTOP("Não há registros para os parametros informados !!")
//		QRY->(dbCloseArea())
	EndIf
		
	While QRY->(!Eof())
	
		TcSetField("QRY","CJ_EMISSAO","D") 
		TcSetField("QRY","CJ_VALIDA","D")
		TcSetField("QRY","CK_ENTREG","D")
	
		cOrcamento := QRY->CJ_NUM
		cEmissao   := QRY->CJ_EMISSAO
		aTotaIpi   := {0,0}
		nTotaIcm   := 0
		nTotalIss  := 0
		nTotal	   := 0
				
		// Query que retorna a Quantidade Total de itens em um orcamento
		cQuery := "SELECT COUNT(CK_ITEM) AS TOTAL "
		cQuery += "FROM " + RetSqlName("SCK") + " "
		cQuery += "WHERE CK_NUM = '" + QRY->CJ_NUM + "' AND D_E_L_E_T_ = ' ' "
		
		TCQUERY cQuery NEW ALIAS "cCount"
		
		// Atribui a Quantidade Total de itens na Variavel nCount
		nCount := cCount->TOTAL 
		
		// Controla a Quantidade de Paginas no Relatorio
//		nQtdPag := Str((cCount->TOTAL / 30)+ 1) 
//		nQtdPag := Left(nQtdPag, At(".",nQtdPag)-1)
		
		cCount->(dbCloseArea())
		
		// Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()
		
		// Define o modo de Impressao como Retrato
		oPrint:SetLandscape()  // SetLandscape -> Para definir como modo Paisagem
		
		PrintHeader(cOrcamento,cEmissao)       // Funcao para impressao do Cabecalho
	    PrintCustomer()	                       // Funcao para impressao dos dados do Cliente
	   	PrintDetail(cOrcamento,nCount) // Funcao para impressao dos Detalhes do Produto
	   	oPrint:EndPage()
				
	EndDo
	
	QRY->(dbCloseArea())
	
	/* COMENTADO POR CASSIANO EM 28-03-17
	Define MsDialog oDlg Title "Orçamento de Vendas" From 0, 0 To 090, 430 Pixel
	Define Font oBold Name "Arial" Size 0, -13 Bold
	@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30, 120 NoBorder When .f. Pixel
	@ 003, 040 Say cTitulo Font oBold Pixel
	@ 014, 030 To 016, 400 Label '' Of oDlg  Pixel
	@ 020, 040 Button "Configurar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Setup()
	@ 020, 082 Button "Imprimir"   	Size 40, 13 Pixel Of oDlg Action oPrint:Print()
	@ 020, 124 Button "Visualizar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Preview()
	@ 020, 166 Button "Sair"       	Size 40, 13 Pixel Of oDlg Action oDlg:End()
	Activate MsDialog oDlg Centered*/
	oPrint:Preview()

Return

/*
Impressao do cabecalho do relatorio.
Informacao: Cabecalho - Dados da Empresa
*/
Static Function PrintHeader(cOrcamento,cEmissao)

	Local nTopo    := 0  // Controle de Linhas
	Local nInicio  := 0  // Indica a posição da primeira coluna  
	Local cEmail   := AllTrim(GetMV("MV_RELFROM"))
	Local cLogo    := AllTrim(GetMV("ZZ_LOGO"))
	Local cAddress := ""
	Local cCnpj    := ""
	
	// Retorna o tamanho Horizontal e Vertical da pagina.
	nVertSize := oPrint:nVertSize()
	nHorzSize := oPrint:nHorzSize()
	
	// Impressao do cabeçalho do Relatorio.
	// Obs.: O Logo pode ser colocado na pasta System do Protheus, no caso só referencia o nome.
	
	// oPrint:SayBitmap(Coluna, Linha, Caminho, Largura, Altura) 
	oPrint:SayBitmap(nTopo + 50,nInicio + 40,cLogo,510,145)
	dbSelectArea("SM0")
	SM0->(dbseek(cEmPant + cFilant))
	
	cAddress := AllTrim(SM0->M0_ENDENT)+" "+AllTrim(SM0->M0_CIDENT)+"/"+AllTrim(SM0->M0_ESTENT)+" "+Left(AllTrim(SM0->M0_CEPENT),5) + "-" + Right(AllTrim(SM0->M0_CEPENT),3)
	cCnpj    := "CNPJ: " + AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + " - IE: " +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999"))
	
	// oPrint:Say(Coluna, Linha, Texto, Fonte, Num de Caracteres, , ,Alinhamento - 0=Left, 1=Right e 2=Center)
	oPrint:Say(nTopo + 0050,nInicio + (3090),AllTrim(SM0->M0_NOMECOM)       ,oFont1,100,,,1)
	oPrint:Say(nTopo + 0100,nInicio + (3090),cAddress                       ,oFont5,100,,,1)
	oPrint:Say(nTopo + 0150,nInicio + (3090),"E-mail: " + AllTrim(cEmail)   ,oFont3,100,,,1)
	oPrint:Say(nTopo + 0200,nInicio + (3090),"Fone: " + AllTrim(SM0->M0_TEL),oFont5,100,,,1)
	oPrint:Say(nTopo + 0250,nInicio + (3090),cCnpj                          ,oFont5,100,,,1)
	
	// oPrint:Line(Coluna, Linha, Coluna, Linha)
	oPrint:Line(nTopo + 0310,nInicio + 0040,nTopo + 0310,(3090)) 
	oPrint:Line(nTopo + 0313,nInicio + 0040,nTopo + 0313,(3090)) 
	oPrint:Line(nTopo + 0410,nInicio + 0040,nTopo + 0410,(3090)) 
	oPrint:Line(nTopo + 0413,nInicio + 0040,nTopo + 0413,(3090)) 
	
	oPrint:Say(nTopo + 0335,nInicio + 0040,"Orçamento N° " + cOrcamento,oFont1,100,,,0)
	oPrint:Say(nTopo + 0335,nInicio + (3090),"Data: " + Dtoc(cEmissao)   ,oFont1,100,,,1)
	
Return
	
/*
Impressao dos Dados do Cliente.
Informacoes: Nome, E-mail, Endereco, Cidade, CEP, Tel, FAX,Contato e Bairro.
*/
Static Function PrintCustomer()

	Local nTopo        := 0  // Controle de Linhas
	Local nInicio      := 0  // Indica a posicao da primeira coluna
	Local cPhoneNumber := ""
	Local cZipCode     := ""
	Local cFaxNumber   := ""
	
	// Impressão da Estrutura dos Dados do Cliente
	
	// Texto a Esquerda
	oPrint:Say(nTopo + 0430,nInicio + 0040,"Cliente" ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0480,nInicio + 0040,"E-mail"  ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530,nInicio + 0040,"Endereço",oFont3,100,,,0)
	oPrint:Say(nTopo + 0580,nInicio + 0040,"Cidade"  ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630,nInicio + 0040,"TEL"     ,oFont3,100,,,0)
	If Len(AllTrim(QRY->A1_CGC)) > 11 
		oPrint:Say(nTopo + 0680,nInicio + 0040,"CNPJ",oFont3,100,,,0)
	Else
		oPrint:Say(nTopo + 0680,nInicio + 0040,"CPF" ,oFont3,100,,,0)
	EndIf
	
	// Texto Centralizado
	oPrint:Say(nTopo + 0430	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Site"    ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Contato" ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Bairro"  ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"CEP"     ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"FAX"     ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"I.E."    ,oFont3,100,,,0)
	  
    // Texto a Esquerda
    cPhoneNumber := ": (" + QRY->A1_DDD + ") " + Left(QRY->A1_TEL,4) + "-" + Substr(QRY->A1_TEL,5,8)
    
	oPrint:Say(nTopo + 0430,nInicio + 0190,": " + QRY->A1_COD + " - " + QRY->A1_NOME  ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480,nInicio + 0190,": " + QRY->A1_EMAIL                       ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530,nInicio + 0190,": " + QRY->A1_END                         ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580,nInicio + 0190,": " + AllTrim(QRY->A1_MUN)+"/"+QRY->A1_EST,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630,nInicio + 0190,cPhoneNumber                               ,oFont5,100,,,0)

	If Len(AllTrim(QRY->A1_CGC)) > 11  
		oPrint:Say(nTopo + 0680,nInicio + 0190,": " + AllTrim(Transform(QRY->A1_CGC,"@R 99.999.999/9999-99")),oFont5,100,,,0)
	Else	
		oPrint:Say(nTopo + 0680,nInicio + 0190,": " + AllTrim(Transform(QRY->A1_CGC,"@R 999.999.999-99"))    ,oFont5,100,,,0)
	EndIf
	
	// Texto Centralizado
	cZipCode   := ": " + Left(QRY->A1_CEP,5) + "-" + Right(QRY->A1_CEP,3)
	cFaxNumber := ": (" + QRY->A1_DDD + ") " + Left(QRY->A1_FAX,4) + "-" + Substr(QRY->A1_FAX,5,8)
	
	oPrint:Say(nTopo + 0430	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + QRY->A1_HPAGE  ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + QRY->A1_CONTATO,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + QRY->A1_BAIRRO ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,cZipCode              ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,cFaxNumber            ,oFont5,100,,,0)

	If Len(AllTrim(QRY->A1_INSCR)) > 6
		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + AllTrim(Transform(QRY->A1_INSCR,"@R 999.999.999.999")),oFont5,100,,,0)
	Else
		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + AllTrim(QRY->A1_INSCR),oFont5,100,,,0)
	EndIf
	
Return
	
/*
Impressao dos Dados de Detalhes dos Produtos.
Parametros: cOrcamento - Numero do Orçamento de Venda Corrente.
            nCount     - Quantidade Total de Itens.
*/
Static Function PrintDetail(cOrcamento,nCount)

	Local nTopo    := 750 // Controle de Linhas
	Local nInicio  := 0   // Indica a posição da primeira coluna
	Local nTotal   := 0   // Controle do Valor Total do Orçamento 
	Local nTotal2  := 0   // Controle do Valor Total do Orçamento
	Local nTotProp := 0   // Total da Proposta 
	Local nFrete   := 0   // Controle do Valor Total do Orçamento 
	Local nDespesa := 0   // Controle do Valor Total do Orçamento
	Local nPage    := 1
	Local nCon	   := 0
	Local nCont    := 1 
	Local nContP   := 0 
	Local nTamDes  := 0
	Local nTamStr  := 0
	Local nIPI	   := ""
    Local nICMS	   := ""
    Local nISS	   := ""
    Local nICMValue:= ""
    Local nIPIValue:= ""
    Local nISSValue:= ""
    Local cICMValue:= ""
    Local cIPIValue:= ""
    Local cISSValue:= ""
    Local cPrcVen  := ""
    Local cValor   := ""  
   	
	
	Private nTpag  := 0

	// Box, Linhas Verticais e Dados do Cabecalho de Orçamento.
	// Box
	oPrint:Box(nTopo,nInicio + 0040, nTopo + 0050, nInicio + (3091)) //nInicio + 2360
	
	// Linhas Verticais 
	oPrint:Line(nTopo,nInicio + 0040,nTopo + 0050,nInicio + 0040)
	oPrint:Line(nTopo,nInicio + 0122,nTopo + 0050,nInicio + 0122) //Item
	oPrint:Line(nTopo,nInicio + 0410,nTopo + 0050,nInicio + 0410) //Produto
	oPrint:Line(nTopo,nInicio + 1090,nTopo + 0050,nInicio + 1090) //Descrição
	oPrint:Line(nTopo,nInicio + 1340,nTopo + 0050,nInicio + 1340) //Prev.EnT.
	oPrint:Line(nTopo,nInicio + 1540,nTopo + 0050,nInicio + 1540) //NCM
	oPrint:Line(nTopo,nInicio + 1640,nTopo + 0050,nInicio + 1640) //UM
	oPrint:Line(nTopo,nInicio + 1760,nTopo + 0050,nInicio + 1760) //Qtd.
	oPrint:Line(nTopo,nInicio + 1980,nTopo + 0050,nInicio + 1980) //Preço
	oPrint:Line(nTopo,nInicio + 2280,nTopo + 0050,nInicio + 2280) //Total
	oPrint:Line(nTopo,nInicio + 2480,nTopo + 0050,nInicio + 2480) //%ICMS
	oPrint:Line(nTopo,nInicio + 2730,nTopo + 0050,nInicio + 2730) //ICM
	oPrint:Line(nTopo,nInicio + 2880,nTopo + 0050,nInicio + 2880) //Icms 
	oPrint:Line(nTopo,nInicio + 3091,nTopo + 0050,nInicio + 3091)//IPI	
	
	// Texto
	oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"     ,oFont3,100,,,0) //60
	oPrint:Say(nTopo + 0007,nInicio + 0140,"Produto"  ,oFont3,100,,,0) //200
	oPrint:Say(nTopo + 0007,nInicio + 0420,"Descrição",oFont3,100,,,0) //600
	oPrint:Say(nTopo + 0007,nInicio + 1100,"Prev. Entrega"	  ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1350,"NCM"	  ,oFont3,100,,,0) //600
	oPrint:Say(nTopo + 0007,nInicio + 1550,"UM"       ,oFont3,100,,,0) //1610
	oPrint:Say(nTopo + 0007,nInicio + 1650,"Qtd."     ,oFont3,100,,,0) //1460
	oPrint:Say(nTopo + 0007,nInicio + 1770,"Vl.c/ICMS " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0) //1620
	oPrint:Say(nTopo + 0007,nInicio + 1990,"Total c/ICMS " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0) //1920	
	oPrint:Say(nTopo + 0007,nInicio + 2290,"% ICMS/ISS"   ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 2490,"ICMS/ISS "  + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0)  
	oPrint:Say(nTopo + 0007,nInicio + 2740,"% IPI"    ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 2890,"IPI " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0)  
	
	retTotOrc(QRY->CJ_NUM)
			
	While QRY->(!Eof()) .AND. QRY->CJ_NUM == cOrcamento
	
		// Testa se o limite da pagina para a impressao dos produtos.
		// Caso ultrapasse o limite gera uma Nova Pagina
		If (nTopo + 0130) >= 1670
			
			// Linhas Horizontais  -  FIM Orçamento
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + (3091))
		
			PrintTrailer(nPage,nTotal,nTopo)
			
			// Inicia uma Nova Pagina para Impressao
			oPrint:StartPage()
			
			// Define o modo de Impressão como Retrato
			oPrint:SetLandscape()   // SetLandscape -> Para definir como modo Paisagem
			
			// Funcao para impressao do Cabecalho
			PrintHeader(cOrcamento,cEmissao)
			
			// Incrementa o contador de Paginas
			nPage := nPage + 1
			nTopo := 450
			
   			// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			// ³ Box, Linhas Verticais e Dados do Cabecalho de Orçamento.                                        ³
			// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Box
			oPrint:Box(nTopo,nInicio + 0040, nTopo + 0050,nInicio + (3091))
			
			// Linhas Verticais                                  
			oPrint:Line(nTopo,nInicio + 0040,nTopo + 0050,nInicio + 0040)
			oPrint:Line(nTopo,nInicio + 0122,nTopo + 0050,nInicio + 0122) //Item
			oPrint:Line(nTopo,nInicio + 0410,nTopo + 0050,nInicio + 0410) //Produto
			oPrint:Line(nTopo,nInicio + 1090,nTopo + 0050,nInicio + 1090) //Descrição
			oPrint:Line(nTopo,nInicio + 1340,nTopo + 0050,nInicio + 1340) //Prev.EnT.
			oPrint:Line(nTopo,nInicio + 1540,nTopo + 0050,nInicio + 1540) //NCM
			oPrint:Line(nTopo,nInicio + 1640,nTopo + 0050,nInicio + 1640) //UM
			oPrint:Line(nTopo,nInicio + 1760,nTopo + 0050,nInicio + 1760) //Qtd.
			oPrint:Line(nTopo,nInicio + 1980,nTopo + 0050,nInicio + 1980) //Preço
			oPrint:Line(nTopo,nInicio + 2280,nTopo + 0050,nInicio + 2280) //Total
			oPrint:Line(nTopo,nInicio + 2480,nTopo + 0050,nInicio + 2480) //%ICMS
			oPrint:Line(nTopo,nInicio + 2730,nTopo + 0050,nInicio + 2730) //ICM
			oPrint:Line(nTopo,nInicio + 2880,nTopo + 0050,nInicio + 2880) //Icms 
			oPrint:Line(nTopo,nInicio + 3091,nTopo + 0050,nInicio + 3091)//IPI	
									
			// Texto
			oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"     ,oFont3,100,,,0) //60
			oPrint:Say(nTopo + 0007,nInicio + 0140,"Produto"  ,oFont3,100,,,0) //200
			oPrint:Say(nTopo + 0007,nInicio + 0420,"Descrição",oFont3,100,,,0) //600
			oPrint:Say(nTopo + 0007,nInicio + 1100,"Prev. Entrega"	  ,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1350,"NCM"	  ,oFont3,100,,,0) //600
			oPrint:Say(nTopo + 0007,nInicio + 1550,"UM"       ,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1650,"Qtd."     ,oFont3,100,,,0) //1460
			oPrint:Say(nTopo + 0007,nInicio + 1770,"Vl.c/ICMS " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0) //1620
			oPrint:Say(nTopo + 0007,nInicio + 1990,"Total c/ICMS " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0) //1920	
			oPrint:Say(nTopo + 0007,nInicio + 2290,"% ICMS/ISS"   ,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 2490,"ICMS/ISS "  + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0)  
			oPrint:Say(nTopo + 0007,nInicio + 2740,"% IPI"    ,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 2890,"IPI " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0)  
							
		EndIf

		// Box, Linhas Verticais, Linhas Horizontais e Dados do Orçamento.
		
		nTamDes := Len(AllTrim(QRY->CK_DESCRI)) / 30
		
		If nTamDes > 2                
			// Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 30,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 30,nInicio + 0122,nTopo + 0090,nInicio + 0122) //Item
			oPrint:Line(nTopo + 30,nInicio + 0410,nTopo + 0090,nInicio + 0410) //Produto
			oPrint:Line(nTopo + 30,nInicio + 1090,nTopo + 0090,nInicio + 1090) //Descrição
			oPrint:Line(nTopo + 30,nInicio + 1340,nTopo + 0090,nInicio + 1340) //Prev.EnT.
			oPrint:Line(nTopo + 30,nInicio + 1540,nTopo + 0090,nInicio + 1540) //NCM
			oPrint:Line(nTopo + 30,nInicio + 1640,nTopo + 0090,nInicio + 1640) //UM
			oPrint:Line(nTopo + 30,nInicio + 1760,nTopo + 0090,nInicio + 1760) //Qtd.
			oPrint:Line(nTopo + 30,nInicio + 1980,nTopo + 0090,nInicio + 1980) //Preço
			oPrint:Line(nTopo + 30,nInicio + 2280,nTopo + 0090,nInicio + 2280) //Total
			oPrint:Line(nTopo + 30,nInicio + 2480,nTopo + 0090,nInicio + 2480) //%ICMS
			oPrint:Line(nTopo + 30,nInicio + 2730,nTopo + 0090,nInicio + 2730) //ICM
			oPrint:Line(nTopo + 30,nInicio + 2880,nTopo + 0090,nInicio + 2880) //Icms 
			oPrint:Line(nTopo + 30,nInicio + 3091,nTopo + 0090,nInicio + 3091)//IPI	
												
			// Impressao dos Campos dos Detalhes dos Produtos
			nIPI		:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'IT_ALIQIPI')
			nICMS		:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'IT_ALIQICM')
			nISS		:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'IT_ALIQISS')
			nICMValue	:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'NF_VALICM', QRY->CJ_FRETE, QRY->CJ_SEGURO, QRY->CJ_DESPESA, nTotalOrc)
			nIPIValue	:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'IT_VALIPI', QRY->CJ_FRETE, QRY->CJ_SEGURO, QRY->CJ_DESPESA, nTotalOrc)
			nISSValue	:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'NF_VALISS')
			cICMValue	:= AllTrim(Transform(nIcmValue,PesqPict("SD2","D2_VALICM")))
			cIPIValue	:= AllTrim(Transform(nIpiValue,PesqPict("SD2","D2_VALIPI")))
			cISSValue	:= AllTrim(Transform(nISSValue,PesqPict("SD2","D2_VALISS")))
			cPrcVen 	:= AllTrim(Transform(QRY->CK_PRCVEN,PesqPict("SCK","CK_PRCVEN")))
			cValor  	:= AllTrim(Transform(QRY->CK_VALOR ,PesqPict("SCK","CK_VALOR")))
			
			nTotaIcm += nIcmValue
			aTotaIpi[1] += nIpiValue
			aTotaIpi[2] += nIpiValue + QRY->CK_VALOR
			nTotalIss += nISSValue
			
			oPrint:Say(nTopo + 0057,nInicio + 0050,AllTrim(QRY->CK_ITEM)               	,oFont2,100,,,0) //60
			oPrint:Say(nTopo + 0057,nInicio + 0140,AllTrim(QRY->CK_PRODUTO)            	,oFont2,100,,,0) //200
			oPrint:Say(nTopo + 0057,nInicio + 0430,Substr(AllTrim(QRY->CK_DESCRI),1,30)	,oFont2,100,,,0) //600
			oPrint:Say(nTopo + 0057,nInicio + 1160,Dtoc(QRY->CK_ENTREG)     		   	,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057,nInicio + 1390,AllTrim(QRY->B1_POSIPI)     			,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057,nInicio + 1585,AllTrim(QRY->CK_UM)                 	,oFont2,100,,,0) //1610
			oPrint:Say(nTopo + 0057,nInicio + 1715,AllTrim(Str(QRY->CK_QTDVEN))        	,oFont2,100,,,1) //1580
			oPrint:Say(nTopo + 0057,nInicio + 1970,cPrcVen                     			,oFont2,100,,,1) //-100
			oPrint:Say(nTopo + 0057,nInicio + 2200,cValor                      			,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2390,AllTrim(Str(nICMS))         			,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2660,AllTrim(Transform(nICMValue + nISSValue,PesqPict("SD2","D2_VALICM")))      			,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2810,AllTrim(Str(nIPI))         			,oFont2,100,,,1) 			
			oPrint:Say(nTopo + 0057,nInicio + 3010,cIPIValue                   			,oFont2,100,,,1)

			nTamStr := 31
				
			For nCon := 2 to Int(nTamDes) + 1			
				nTopo := nTopo + 50 
				
				// Testa se o limite da pagina para a impressao dos produtos.
				// Caso ultrapasse o limite gera uma Nova Pagina
				If (nTopo + 0130) >= 1670
					
					// Linhas Horizontais  -  FIM Orçamento
					oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + (3091))
				
					PrintTrailer(nPage,nTotal,nTopo)
					
					// Inicia uma Nova Pagina para Impressao
					oPrint:StartPage()
					
					// Define o modo de Impressão como Retrato
					oPrint:SetLandscape()   // SetLandscape -> Para definir como modo Paisagem
					
					// Funcao para impressao do Cabecalho
					PrintHeader(cOrcamento,cEmissao)
					
					// Incrementa o contador de Paginas
					nPage := nPage + 1										
					nTopo := 450
					
					// Box, Linhas Verticais e Dados do Cabecalho de Orçamento.
					// Box
					oPrint:Box(nTopo,nInicio + 0040, nTopo + 0050,nInicio + (3091))
					
					// Linhas Verticais
					oPrint:Line(nTopo,nInicio + 0040,nTopo + 0050,nInicio + 0040)
					oPrint:Line(nTopo,nInicio + 0122,nTopo + 0050,nInicio + 0122) //Item
					oPrint:Line(nTopo,nInicio + 0410,nTopo + 0050,nInicio + 0410) //Produto
					oPrint:Line(nTopo,nInicio + 1090,nTopo + 0050,nInicio + 1090) //Descrição
					oPrint:Line(nTopo,nInicio + 1340,nTopo + 0050,nInicio + 1340) //Prev.EnT.
					oPrint:Line(nTopo,nInicio + 1540,nTopo + 0050,nInicio + 1540) //NCM
					oPrint:Line(nTopo,nInicio + 1640,nTopo + 0050,nInicio + 1640) //UM
					oPrint:Line(nTopo,nInicio + 1760,nTopo + 0050,nInicio + 1760) //Qtd.
					oPrint:Line(nTopo,nInicio + 1980,nTopo + 0050,nInicio + 1980) //Preço
					oPrint:Line(nTopo,nInicio + 2280,nTopo + 0050,nInicio + 2280) //Total
					oPrint:Line(nTopo,nInicio + 2480,nTopo + 0050,nInicio + 2480) //%ICMS
					oPrint:Line(nTopo,nInicio + 2730,nTopo + 0050,nInicio + 2730) //ICM
					oPrint:Line(nTopo,nInicio + 2880,nTopo + 0050,nInicio + 2880) //Icms 
					oPrint:Line(nTopo,nInicio + 3091,nTopo + 0050,nInicio + 3091)//IPI	
																					
					// Texto
					oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"     ,oFont3,100,,,0) //60
					oPrint:Say(nTopo + 0007,nInicio + 0140,"Produto"  ,oFont3,100,,,0) //200
					oPrint:Say(nTopo + 0007,nInicio + 0420,"Descrição",oFont3,100,,,0) //600
					oPrint:Say(nTopo + 0007,nInicio + 1100,"Prev. Entrega"	  ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1350,"NCM"	  ,oFont3,100,,,0) //600
					oPrint:Say(nTopo + 0007,nInicio + 1550,"UM"       ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1650,"Qtd."     ,oFont3,100,,,0) //1460
					oPrint:Say(nTopo + 0007,nInicio + 1770,"Vl.c/ICMS " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0) //1620
					oPrint:Say(nTopo + 0007,nInicio + 1990,"Total c/ICMS " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0) //1920	
					oPrint:Say(nTopo + 0007,nInicio + 2290,"% ICMS/ISS"   ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2490,"ICMS/ISS "  + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0)  
					oPrint:Say(nTopo + 0007,nInicio + 2740,"% IPI"    ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2890,"IPI " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0)  
				EndIf      
				
				// Linhas Verticais - Divisao Colunas
				oPrint:Line(nTopo + 30,nInicio + 0040,nTopo + 0090,nInicio + 0040)
				oPrint:Line(nTopo + 30,nInicio + 0122,nTopo + 0090,nInicio + 0122) //Item
				oPrint:Line(nTopo + 30,nInicio + 0410,nTopo + 0090,nInicio + 0410) //Produto
				oPrint:Line(nTopo + 30,nInicio + 1090,nTopo + 0090,nInicio + 1090) //Descrição
				oPrint:Line(nTopo + 30,nInicio + 1340,nTopo + 0090,nInicio + 1340) //Prev.EnT.
				oPrint:Line(nTopo + 30,nInicio + 1540,nTopo + 0090,nInicio + 1540) //NCM
				oPrint:Line(nTopo + 30,nInicio + 1640,nTopo + 0090,nInicio + 1640) //UM
				oPrint:Line(nTopo + 30,nInicio + 1760,nTopo + 0090,nInicio + 1760) //Qtd.
				oPrint:Line(nTopo + 30,nInicio + 1980,nTopo + 0090,nInicio + 1980) //Preço
				oPrint:Line(nTopo + 30,nInicio + 2280,nTopo + 0090,nInicio + 2280) //Total
				oPrint:Line(nTopo + 30,nInicio + 2480,nTopo + 0090,nInicio + 2480) //%ICMS
				oPrint:Line(nTopo + 30,nInicio + 2730,nTopo + 0090,nInicio + 2730) //ICM
				oPrint:Line(nTopo + 30,nInicio + 2880,nTopo + 0090,nInicio + 2880) //Icms 
				oPrint:Line(nTopo + 30,nInicio + 3091,nTopo + 0090,nInicio + 3091)//IPI	
																	
				oPrint:Say(nTopo + 0057,nInicio + 0460, Substr(AllTrim(QRY->CK_DESCRI),nTamStr,30),oFont2,100,,,0) //600
			    
			 	nTamStr := nTamStr + 30				
			Next 			
		Else		
			// Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 30,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 30,nInicio + 0122,nTopo + 0090,nInicio + 0122) //Item
			oPrint:Line(nTopo + 30,nInicio + 0410,nTopo + 0090,nInicio + 0410) //Produto
			oPrint:Line(nTopo + 30,nInicio + 1090,nTopo + 0090,nInicio + 1090) //Descrição
			oPrint:Line(nTopo + 30,nInicio + 1340,nTopo + 0090,nInicio + 1340) //Prev.EnT.
			oPrint:Line(nTopo + 30,nInicio + 1540,nTopo + 0090,nInicio + 1540) //NCM
			oPrint:Line(nTopo + 30,nInicio + 1640,nTopo + 0090,nInicio + 1640) //UM
			oPrint:Line(nTopo + 30,nInicio + 1760,nTopo + 0090,nInicio + 1760) //Qtd.
			oPrint:Line(nTopo + 30,nInicio + 1980,nTopo + 0090,nInicio + 1980) //Preço
			oPrint:Line(nTopo + 30,nInicio + 2280,nTopo + 0090,nInicio + 2280) //Total
			oPrint:Line(nTopo + 30,nInicio + 2480,nTopo + 0090,nInicio + 2480) //%ICMS
			oPrint:Line(nTopo + 30,nInicio + 2730,nTopo + 0090,nInicio + 2730) //ICM
			oPrint:Line(nTopo + 30,nInicio + 2880,nTopo + 0090,nInicio + 2880) //Icms 
			oPrint:Line(nTopo + 30,nInicio + 3091,nTopo + 0090,nInicio + 3091)//IPI	
											
			// Impressao dos Campos dos Detalhes dos Produtos
			nIPI		:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'IT_ALIQIPI')
			nICMS		:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'IT_ALIQICM')
			nISS		:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'IT_ALIQISS')
			nICMValue	:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'NF_VALICM', QRY->CJ_FRETE, QRY->CJ_SEGURO, QRY->CJ_DESPESA, nTotalOrc)
			nIPIValue	:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'IT_VALIPI', QRY->CJ_FRETE, QRY->CJ_SEGURO, QRY->CJ_DESPESA, nTotalOrc)
			nISSValue	:= U_ValImposto(QRY->CJ_CLIENTE,QRY->CJ_LOJA,QRY->A1_TIPO,QRY->CK_PRODUTO,QRY->CK_TES,QRY->CK_QTDVEN,QRY->CK_PRCVEN,QRY->CK_VALOR,QRY->RECNO1,'NF_VALISS')
			cICMValue	:= AllTrim(Transform(nIcmValue,PesqPict("SD2","D2_VALICM")))
			cIPIValue	:= AllTrim(Transform(nIpiValue,PesqPict("SD2","D2_VALIPI")))
			cISSValue	:= AllTrim(Transform(nISSValue,PesqPict("SD2","D2_VALISS")))
			cPrcVen 	:= AllTrim(Transform(QRY->CK_PRCVEN,PesqPict("SCK","CK_PRCVEN")))
			cValor  	:= AllTrim(Transform(QRY->CK_VALOR ,PesqPict("SCK","CK_VALOR")))
//			cValor  	:= AllTrim(Transform(QRY->CK_VALOR + nICMValue + nIPIValue ,PesqPict("SCK","CK_VALOR")))
			
			nTotaIcm += nIcmValue
			aTotaIpi[1] += nIpiValue
			aTotaIpi[2] += nIpiValue + QRY->CK_VALOR
			nTotalIss += nISSValue

			oPrint:Say(nTopo + 0057,nInicio + 0050,AllTrim(QRY->CK_ITEM)               	,oFont2,100,,,0) //60
			oPrint:Say(nTopo + 0057,nInicio + 0140,AllTrim(QRY->CK_PRODUTO)            	,oFont2,100,,,0) //200
			oPrint:Say(nTopo + 0057,nInicio + 0430,Substr(AllTrim(QRY->CK_DESCRI),1,30)	,oFont2,100,,,0) //600
			oPrint:Say(nTopo + 0057,nInicio + 1160,Dtoc(QRY->CK_ENTREG)     		   	,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057,nInicio + 1390,AllTrim(QRY->B1_POSIPI)     			,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057,nInicio + 1585,AllTrim(QRY->CK_UM)                 	,oFont2,100,,,0) //1610
			oPrint:Say(nTopo + 0057,nInicio + 1715,AllTrim(Str(QRY->CK_QTDVEN))        	,oFont2,100,,,1) //1580
			oPrint:Say(nTopo + 0057,nInicio + 1970,cPrcVen                     			,oFont2,100,,,1) //-100
			oPrint:Say(nTopo + 0057,nInicio + 2200,cValor                      			,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2390,AllTrim(Str(nICMS))         			,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2660,AllTrim(Transform(nICMValue + nISSValue,PesqPict("SD2","D2_VALICM")))	,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2810,AllTrim(Str(nIPI))         			,oFont2,100,,,1) 			
			oPrint:Say(nTopo + 0057,nInicio + 3010,cIPIValue                   			,oFont2,100,,,1)

		
		EndIf
		
		// Calculo do Valor Total do Orçamento de Venda
		nTotal += QRY->CK_VALOR 				
		nTopo  := nTopo + 0050
		
		// Impressão da Observação do Orçamento		
		nTamDes := Len(AllTrim(QRY->CK_OBS)) / 30
		
		If nTamDes > 2  
			// Testa se o limite da pagina para a impressao dos produtos.
			// Caso ultrapasse o limite gera uma Nova Pagina
			If (nTopo + 0130) >= 1670
						
				// Linhas Horizontais  -  FIM Orçamento
				oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + (3091))
				
				PrintTrailer(nPage,nTotal,nTopo)
				
				// Inicia uma Nova Pagina para Impressao
				oPrint:StartPage()
				
				// Define o modo de Impressão como Retrato
				oPrint:SetLandscape()   // SetLandscape -> Para definir como modo Paisagem
				
				// Funcao para impressao do Cabecalho
				PrintHeader(cOrcamento,cEmissao)
				
				// Incrementa o contador de Paginas
				nPage := nPage + 1									
				nTopo := 450

				// ³ Box, Linhas Verticais e Dados do Cabecalho de Orçamento.
				// Box
				oPrint:Box(nTopo,nInicio + 0040, nTopo + 0050,nInicio + (3091))
				
				// Linhas Verticais
				oPrint:Line(nTopo,nInicio + 0040,nTopo + 0050,nInicio + 0040)
				oPrint:Line(nTopo,nInicio + 0122,nTopo + 0050,nInicio + 0122) //Item
				oPrint:Line(nTopo,nInicio + 0410,nTopo + 0050,nInicio + 0410) //Produto
				oPrint:Line(nTopo,nInicio + 1090,nTopo + 0050,nInicio + 1090) //Descrição
				oPrint:Line(nTopo,nInicio + 1340,nTopo + 0050,nInicio + 1340) //Prev.EnT.
				oPrint:Line(nTopo,nInicio + 1540,nTopo + 0050,nInicio + 1540) //NCM
				oPrint:Line(nTopo,nInicio + 1640,nTopo + 0050,nInicio + 1640) //UM
				oPrint:Line(nTopo,nInicio + 1760,nTopo + 0050,nInicio + 1760) //Qtd.
				oPrint:Line(nTopo,nInicio + 1980,nTopo + 0050,nInicio + 1980) //Preço
				oPrint:Line(nTopo,nInicio + 2280,nTopo + 0050,nInicio + 2280) //Total
				oPrint:Line(nTopo,nInicio + 2480,nTopo + 0050,nInicio + 2480) //%ICMS
				oPrint:Line(nTopo,nInicio + 2730,nTopo + 0050,nInicio + 2730) //ICM
				oPrint:Line(nTopo,nInicio + 2880,nTopo + 0050,nInicio + 2880) //Icms 
				oPrint:Line(nTopo,nInicio + 3091,nTopo + 0050,nInicio + 3091)//IPI	
																
				// Texto
				oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"     ,oFont3,100,,,0) //60
				oPrint:Say(nTopo + 0007,nInicio + 0140,"Produto"  ,oFont3,100,,,0) //200
				oPrint:Say(nTopo + 0007,nInicio + 0420,"Descrição",oFont3,100,,,0) //600
				oPrint:Say(nTopo + 0007,nInicio + 1100,"Prev. Entrega"	  ,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1350,"NCM"	  ,oFont3,100,,,0) //600
				oPrint:Say(nTopo + 0007,nInicio + 1550,"UM"       ,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1650,"Qtd."     ,oFont3,100,,,0) //1460
				oPrint:Say(nTopo + 0007,nInicio + 1770,"Vl.c/ICMS " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0) //1620
				oPrint:Say(nTopo + 0007,nInicio + 1990,"Total c/ICMS " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0) //1920	
				oPrint:Say(nTopo + 0007,nInicio + 2290,"% ICMS/ISS"   ,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 2490,"ICMS/ISS "  + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0)  
				oPrint:Say(nTopo + 0007,nInicio + 2740,"% IPI"    ,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 2890,"IPI " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0)  
			EndIf   
			// Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 30,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 30,nInicio + 0122,nTopo + 0090,nInicio + 0122) //Item
			oPrint:Line(nTopo + 30,nInicio + 0410,nTopo + 0090,nInicio + 0410) //Produto
			oPrint:Line(nTopo + 30,nInicio + 1090,nTopo + 0090,nInicio + 1090) //Descrição
			oPrint:Line(nTopo + 30,nInicio + 1340,nTopo + 0090,nInicio + 1340) //Prev.EnT.
			oPrint:Line(nTopo + 30,nInicio + 1540,nTopo + 0090,nInicio + 1540) //NCM
			oPrint:Line(nTopo + 30,nInicio + 1640,nTopo + 0090,nInicio + 1640) //UM
			oPrint:Line(nTopo + 30,nInicio + 1760,nTopo + 0090,nInicio + 1760) //Qtd.
			oPrint:Line(nTopo + 30,nInicio + 1980,nTopo + 0090,nInicio + 1980) //Preço
			oPrint:Line(nTopo + 30,nInicio + 2280,nTopo + 0090,nInicio + 2280) //Total
			oPrint:Line(nTopo + 30,nInicio + 2480,nTopo + 0090,nInicio + 2480) //%ICMS
			oPrint:Line(nTopo + 30,nInicio + 2730,nTopo + 0090,nInicio + 2730) //ICM
			oPrint:Line(nTopo + 30,nInicio + 2880,nTopo + 0090,nInicio + 2880) //Icms 
			oPrint:Line(nTopo + 30,nInicio + 3091,nTopo + 0090,nInicio + 3091)//IPI	
													
			// Impressao dos Campos dos Detalhes dos Produtos
			oPrint:Say(nTopo + 0057,nInicio + 0500, Substr(AllTrim(QRY->CK_OBS),1,30),oFont2,100,,,0)
				
			nTamStr := 31
			
			For nCon := 2 to Int(nTamDes) + 1  
			
				nTopo := nTopo + 0050 

				// Testa se o limite da pagina para a impressao dos produtos.
				// Caso ultrapasse o limite gera uma Nova Pagina
				If (nTopo + 0130) >= 1670
					
					// Linhas Horizontais  -  FIM Orçamento
					oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + (3091))
				
					PrintTrailer(nPage,nTotal,nTopo)
					
					// Inicia uma Nova Pagina para Impressao
					oPrint:StartPage()
					
					// Define o modo de Impressão como Retrato
					oPrint:SetLandscape()   // SetLandscape -> Para definir como modo Paisagem
					
					// Funcao para impressao do Cabecalho
					PrintHeader(cOrcamento,cEmissao)
					
					// Incrementa o contador de Paginas
					nPage := nPage + 1										
					nTopo := 450
					
					// Box, Linhas Verticais e Dados do Cabecalho de Orçamento.
					// Box
					oPrint:Box(nTopo,nInicio + 0040, nTopo + 0050,nInicio + (3091))
					
					// Linhas Verticais
					oPrint:Line(nTopo,nInicio + 0040,nTopo + 0050,nInicio + 0040)
					oPrint:Line(nTopo,nInicio + 0122,nTopo + 0050,nInicio + 0122) //Item
					oPrint:Line(nTopo,nInicio + 0410,nTopo + 0050,nInicio + 0410) //Produto
					oPrint:Line(nTopo,nInicio + 1090,nTopo + 0050,nInicio + 1090) //Descrição
					oPrint:Line(nTopo,nInicio + 1340,nTopo + 0050,nInicio + 1340) //Prev.EnT.
					oPrint:Line(nTopo,nInicio + 1540,nTopo + 0050,nInicio + 1540) //NCM
					oPrint:Line(nTopo,nInicio + 1640,nTopo + 0050,nInicio + 1640) //UM
					oPrint:Line(nTopo,nInicio + 1760,nTopo + 0050,nInicio + 1760) //Qtd.
					oPrint:Line(nTopo,nInicio + 1980,nTopo + 0050,nInicio + 1980) //Preço
					oPrint:Line(nTopo,nInicio + 2280,nTopo + 0050,nInicio + 2280) //Total
					oPrint:Line(nTopo,nInicio + 2480,nTopo + 0050,nInicio + 2480) //%ICMS
					oPrint:Line(nTopo,nInicio + 2730,nTopo + 0050,nInicio + 2730) //ICM
					oPrint:Line(nTopo,nInicio + 2880,nTopo + 0050,nInicio + 2880) //Icms 
					oPrint:Line(nTopo,nInicio + 3091,nTopo + 0050,nInicio + 3091)//IPI	
																						
					// Texto
					oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"     ,oFont3,100,,,0) //60
					oPrint:Say(nTopo + 0007,nInicio + 0140,"Produto"  ,oFont3,100,,,0) //200
					oPrint:Say(nTopo + 0007,nInicio + 0420,"Descrição",oFont3,100,,,0) //600
					oPrint:Say(nTopo + 0007,nInicio + 1100,"Prev. Entrega"	  ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1350,"NCM"	  ,oFont3,100,,,0) //600
					oPrint:Say(nTopo + 0007,nInicio + 1550,"UM"       ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1650,"Qtd."     ,oFont3,100,,,0) //1460
					oPrint:Say(nTopo + 0007,nInicio + 1770,"Vl.c/ICMS " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0) //1620
					oPrint:Say(nTopo + 0007,nInicio + 1990,"Total c/ICMS " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0) //1920	
					oPrint:Say(nTopo + 0007,nInicio + 2290,"% ICMS/ISS"   ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2490,"ICMS/ISS "  + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0)  
					oPrint:Say(nTopo + 0007,nInicio + 2740,"% IPI"    ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2890,"IPI " + iif(QRY->CJ_MOEDA == 1, "R$", iif(QRY->CJ_MOEDA == 2, "USD", "" )) ,oFont3,100,,,0)  
				EndIf
				
				// Linhas Verticais - Divisao Colunas
				oPrint:Line(nTopo,nInicio + 0040,nTopo + 0050,nInicio + 0040)
				oPrint:Line(nTopo,nInicio + 0122,nTopo + 0050,nInicio + 0122) //Item
				oPrint:Line(nTopo,nInicio + 0410,nTopo + 0050,nInicio + 0410) //Produto
				oPrint:Line(nTopo,nInicio + 1090,nTopo + 0050,nInicio + 1090) //Descrição
				oPrint:Line(nTopo,nInicio + 1340,nTopo + 0050,nInicio + 1340) //Prev.EnT.
				oPrint:Line(nTopo,nInicio + 1540,nTopo + 0050,nInicio + 1540) //NCM
				oPrint:Line(nTopo,nInicio + 1640,nTopo + 0050,nInicio + 1640) //UM
				oPrint:Line(nTopo,nInicio + 1760,nTopo + 0050,nInicio + 1760) //Qtd.
				oPrint:Line(nTopo,nInicio + 1980,nTopo + 0050,nInicio + 1980) //Preço
				oPrint:Line(nTopo,nInicio + 2280,nTopo + 0050,nInicio + 2280) //Total
				oPrint:Line(nTopo,nInicio + 2480,nTopo + 0050,nInicio + 2480) //%ICMS
				oPrint:Line(nTopo,nInicio + 2730,nTopo + 0050,nInicio + 2730) //ICM
				oPrint:Line(nTopo,nInicio + 2880,nTopo + 0050,nInicio + 2880) //Icms 
				oPrint:Line(nTopo,nInicio + 3091,nTopo + 0050,nInicio + 3091)//IPI	
													
				
				oPrint:Say(nTopo + 0057,nInicio + 0500, Substr(AllTrim(QRY->CK_OBS),nTamStr,30)		,oFont2,100,,,0)
			    
			 	nTamStr := nTamStr + 30				
			Next			
			nTopo := nTopo + 0050			
		EndIf 		
		
		// Incrementa Contador da Quantidade de Itens no Orçamento de Venda
		nCont ++
		
		// Se o arquivo chegou ao fim, imprime rodape.
		If nCont > nCount
		
			nTotal 	:= nTotal + QRY->CJ_FRETE + QRY->CJ_DESPESA + QRY->CJ_FRETAUT + QRY->CJ_SEGURO  
			nTotProp:= nTotal + nTotalIss

			

			// Box e Dados - Valor Frete       
			oPrint:Box(nTopo  + 0060,nInicio + 2300,nTopo + 0110,nInicio + 3100)
			oPrint:Line(nTopo + 0060,nInicio + 2750,nTopo + 0110,nInicio + 2750)
			
			oPrint:Say(nTopo + 0060,nInicio + 2315,"Valor Frete",oFont3,100,,,0)
			oPrint:Say(nTopo + 0060,nInicio + 3090," " + AllTrim(Transform(QRY->CJ_FRETE + QRY->CJ_DESPESA + QRY->CJ_FRETAUT + QRY->CJ_SEGURO,PesqPict("SCJ","CJ_FRETE"))),oFont3,100,,,1)
                                        

			// Box e Dados - Valor Produtos
			oPrint:Box(nTopo  + 0060,nInicio + 2300,nTopo + 0160,nInicio + 3100)
			oPrint:Line(nTopo + 0060,nInicio + 2750,nTopo + 0160,nInicio + 2750) 
			
			oPrint:Say(nTopo + 0120,nInicio + 2315,"Valor Produtos",oFont3,100,,,0)
			oPrint:Say(nTopo + 0120,nInicio + 3090," " + AllTrim(Transform(nTotal,PesqPict("SCK","CK_VALOR"))),oFont3,100,,,1)

			
			// Box e Dados - Valor Total
			oPrint:Box(nTopo  + 0060,nInicio + 2300,nTopo + 0220,nInicio + 3100)
			oPrint:Line(nTopo + 0060,nInicio + 2750,nTopo + 0220,nInicio + 2750) 

			oPrint:Say(nTopo + 0180,nInicio + 2315,"Valor Total",oFont3,100,,,0)
			oPrint:Say(nTopo + 0180,nInicio + 3090," " + AllTrim(Transform(aTotaIpi[2]+QRY->CJ_FRETE + QRY->CJ_DESPESA + QRY->CJ_FRETAUT + QRY->CJ_SEGURO,"@E 999,999,999.99")),oFont3,100,,,1)
			
		
			// Linhas Horizontais  -  FIM Orçamento
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + (3091))
			
			
			// Imprime o Numero de Paginas
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0100,nInicio + (3091),"Página: " + Str(nPage),oFont3,100,,,1)
			
			// Funcao de Impressao do Rodape. Parametro: Numero da linha atual
		   	PrintTrailer(nPage,nTotal,nTopo)
		EndIf  
				
		QRY->(dbskip())		
		
	EndDo
	
Return


// Funcao para impressao do Rodape.
Static Function PrintTrailer(nPage,nTotal,nTopo)
	
	Local nInicio    := 0  // Indica a posicao da primeira coluna
	Local cDescontos := ""
	
	If QRY->CJ_DESC1 > 0
		cDescontos += AllTrim(Str(QRY->CJ_DESC1, 10, 2))
	EndIf
	
	If QRY->CJ_DESC2 > 0
		If !Empty(cDescontos)
			cDescontos += " + "
		Endif
		cDescontos += AllTrim(Str(QRY->CJ_DESC2, 10, 2))
	EndIf
	
	If QRY->CJ_DESC3 > 0
		If !Empty(cDescontos)
			cDescontos += " + "
		Endif
		cDescontos += AllTrim(Str(QRY->CJ_DESC3, 10, 2))
	EndIf
	
	If QRY->CJ_DESC4 > 0
		If !Empty(cDescontos)
			cDescontos += " + "
		Endif
		cDescontos += AllTrim(Str(QRY->CJ_DESC4, 10, 2))
	EndIf
		         
	if nTotDescIt > 0 
		If !Empty(cDescontos)
			cDescontos += " + "
		Endif
		cDescontos += AllTrim(Str(nTotDescIt, 10, 2))
	EndIf
		
	If nTopo <= (Mm2Pix(oPrint, oPrint:nVertSize()) - 0900)
	
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0670,nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0460  ,nInicio + (3090))
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0660,nInicio + 0060,"Obs"                                       ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0660,nInicio + 0200,".: " + Substr(QRY->CJ_ZZOBS,1,155)      ,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0610,nInicio + 0200,Space(03) + Substr(QRY->CJ_ZZOBS,156,100),oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0560,nInicio + 0200,Space(03) + Substr(QRY->CJ_ZZOBS2,1,155),oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0510,nInicio + 0200,Space(03) + Substr(QRY->CJ_ZZOBS2,156,100),oFont5,100,,,0)
		
		// Box Condicoes Gerais
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450,nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0100,nInicio + (3090))
		
		// Titulo Centralizado
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0430, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informações Gerais",oFont1,100,,,2)
			
		// Textos Posicionados à Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350,nInicio + 0060,"Forma de Pagamento"  									,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350,nInicio + 0450,": " + QRY->CJ_CONDPAG + " - " + QRY->E4_DESCRI	,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0300,nInicio + 0060,"Transportadora" 				 			   			,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0300,nInicio + 0450,": (" + QRY->CJ_ZZTRANS + ") " + QRY->A4_NOME		,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0250,nInicio + 0060,"Nº Orçamento Cliente" 				 				,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0250,nInicio + 0450,": " + QRY->CJ_COTCLI								,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0200,nInicio + 0060,"Local de Entrega" 				 				 ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0200,nInicio + 0450,": " + fEndEntreg(1, QRY->CJ_ZZTPFRE)			 ,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150,nInicio + 0060,"" + fEndEntreg(,QRY->CJ_ZZTPFRE)				 ,oFont5,100,,,0)
		
		If !Empty(cDescontos)
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Descontos "   ,oFont3,100,,,0)
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 250,": " + cDescontos	,oFont5,100,,,0)
		EndIf
				
		// Textos Posicionados à Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 				 		  	,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": " + Dtoc(QRY->CJ_VALIDA)		,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0300, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Tipo Frete" 		   						,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0300, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": "+ fTipoFrete(QRY->CJ_ZZTPFRE)			,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0250, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Vendedor" 					 	  	,oFont3,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0250, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": (" + QRY->CJ_ZZVEND1 + ") " + QRY->A3_NOME,oFont5,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0200, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Vendedor 2" 					 	  	,oFont3,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0200, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": (" + QRY->CJ_ZZVEND2 + ") " + QRY->NOMEVEND2,oFont5,100)
				
		// Box para a Mensagem da Nota
//		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0270,nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0170  ,nInicio + 3300)
//		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0260,nInicio + 0060,"Obs"                                       ,oFont3,100,,,0)
//		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0260,nInicio + 0200,".: " + Substr(QRY->CJ_ZZOBS,1,155)      ,oFont5,100,,,0)
//		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0210,nInicio + 0200,Space(03) + Substr(QRY->CJ_ZZOBS,155,100),oFont5,100,,,0)
		           
		// Imprime o Numero de Paginas
//		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0100,nInicio + 3300,"Página: " + Str(nPage),oFont3,100,,,1)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0100,nInicio + (3091),"Página: " + Str(nPage),oFont3,100,,,1)
		
		oPrint:EndPage()
		
	Else
		
		// Encerra a Pagina Atual
		oPrint:EndPage()
		
		// Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()
		
		// Define o modo de Impressão como Retrato
		oPrint:SetLandscape()  // SetLandscape -> Para definir como modo Paisagem
		
		// Funcao para impressao do Cabecalho
		PrintHeader(cOrcamento,cEmissao)
		nTopo := 0320
		
		nPage += 1
		
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0670,nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0460  ,nInicio + (3090))
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0660,nInicio + 0060,"Obs"                                       ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0660,nInicio + 0200,".: " + Substr(QRY->CJ_ZZOBS,1,155)      ,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0610,nInicio + 0200,Space(03) + Substr(QRY->CJ_ZZOBS,156,100),oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0560,nInicio + 0200,Space(03) + Substr(QRY->CJ_ZZOBS2,1,155),oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0510,nInicio + 0200,Space(03) + Substr(QRY->CJ_ZZOBS2,156,100),oFont5,100,,,0)
	
		// Box Condicoes Gerais
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450,nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0100,nInicio + (3090))
		
		// Titulo Centralizado
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0430, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informações Gerais"		,oFont1,100,,,2)
			
		// Textos Posicionados à Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350,nInicio + 0060,"Forma de Pagamento"  								 ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350,nInicio + 0450,": " + QRY->CJ_CONDPAG + " - " + QRY->E4_DESCRI,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0300,nInicio + 0060,"Transportadora" 				 			   		 ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0300,nInicio + 0450,": (" + QRY->CJ_ZZTRANS + ") " + QRY->A4_NOME	 ,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0250,nInicio + 0060,"Nº Orçamento Cliente" 				 				 ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0250,nInicio + 0450,": " + QRY->CJ_COTCLI							 ,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0200,nInicio + 0060,"Local de Entrega" 				 				 ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0200,nInicio + 0450,": " + fEndEntreg(1,QRY->CJ_ZZTPFRE)							 ,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150,nInicio + 0060,"" + fEndEntreg(,QRY->CJ_ZZTPFRE)							 	 ,oFont5,100,,,0)
				
		If !Empty(cDescontos)
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Descontos "   ,oFont3,100,,,0)
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 250,": " + cDescontos,oFont5,100,,,0)
		EndIf
				
		// Textos Posicionados à Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 				 		  ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0350, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": " + Dtoc(QRY->CJ_VALIDA),oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0300, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Tipo Frete" 		   						,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0300, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": "+ fTipoFrete(QRY->CJ_ZZTPFRE)			,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0250, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Vendedor" 					 	  ,oFont3,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0250, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": (" + QRY->CJ_ZZVEND1 + ") " + QRY->A3_NOME,oFont5,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0200, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Vendedor 2" 					 	  ,oFont3,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0200, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": (" + QRY->CJ_ZZVEND2 + ") " + QRY->NOMEVEND2,oFont5,100)
				
		// Box para a Mensagem da Nota
//		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0270,nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0170  ,nInicio + 3300)
//		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0260,nInicio + 0060,"Obs" 			   						    ,oFont3,100,,,0)
//		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0260,nInicio + 0200,".: " + Transform(QRY->CJ_ZZOBS,'@!S100'),oFont5,100,,,0)
		           
		// Imprime o Numero de Paginas
//		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150,nInicio + 3300,"Página: " + Str(nPage),oFont3,100,,,1)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0100,nInicio + (3091),"Página: " + Str(nPage),oFont3,100,,,1)
				
		oPrint:EndPage()
			
	EndIf
		
Return
	
/*
Retorna a Largura da Pagina em Pixel.
*/
/*
Retirado metodo oPrint:nLogPixelX(), pois estava ocorrendo casos em clientes 
em que a linha impressa que utliza a funcao MM2PIX saia desconfigurada

Local nValor := (nMm * oPrint:nLogPixelX()) / 25.4
*/
Static Function Mm2Pix(oPrint,nMm)

	Local nValor := (nMm * 300) / 25.4
	
Return nValor

	
/*
Valida se existe um grupo de perguntas caso contrario o grupo de perguntas é criado.
*/
Static Function ValidPerg(cPerg)
	
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	
	dbSelectArea("SX1")
	dbSetOrder(1)

	cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))
		
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Orçamento de " ,"","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SCJ"})
	aAdd(aRegs,{cPerg,"02","Orçamento até ","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SCJ"})
	aAdd(aRegs,{cPerg,"03","Data de "      ,"","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Data até "     ,"","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
		EndIf
	Next
	
	dbSelectArea(_sAlias)
  
Return .T.


//Função para Cálculo dos Impostos.
User Function ValImposto(cCodCli,cLoja,cTipoCli,cProduto,cTes,nQuant,nVlUnit,nVlrTotItem,nB1Recno,nImp,nFrete,nSeguro,nDespesa,nTotal)
	local nAux	:= 0

	default nFrete		:= 0
	default nSeguro		:= 0
	default nDespesa	:= 0
	default nIpi		:= 0
	default nTotal		:= 0
	
	if nTotal > 0
		nVal		:= ((nQuant*nVlUnit)*100)/nTotal
		nFrete 		:= (nFrete*nVal) / 100
		nSeguro		:= (nSeguro*nVal) / 100
		nDespesa	:= (nDespesa*nVal) / 100
	endif
    
    // Inicializa a função fiscal para poder simular os valores dos impostos
    MaFisIni(cCodCli, cLoja, "C", "N", cTipoCli,,, .F., "SB1")
    
    	MaFisAlt("NF_FRETE",nFrete)
		MaFisAlt("NF_SEGURO",nSeguro)
		MaFisAlt("NF_DESPESA",nDespesa)
		 

	    MaFisAdd(cProduto, cTes, nQuant, nVlUnit, 0, "", "",, nFrete, nDespesa, nSeguro, 0, nVlrTotItem, 0, nB1Recno)
	 
    // Calcula os Valores do IPI
    nVal := MaFisRet(1,nImp)
	 
    // Encerra a funcao fiscal
    MaFisEnd()    

Return nVal   

/* 
** Retorna tipo de frete
*/ 
static function fTipoFrete(cFrete)
	local cRet := ""
	
	if cFrete $ "C"
		cRet := "CIF"
	elseif cFrete $ "F"
		cRet := "FOB"	
	endif                                                                                   
return (cRet)


/* 
** Local de entrega
*/
static function fEndEntreg(nEnd, cTpFrete)
	local cRet 		:= ""
	local cMun		:= ""
	Local cZipCode  := ""
	
	if upper(alltrim(cTpFrete)) $ "C"
		if nEnd == 1
			cRet += ALLTRIM(QRY->A1_NOME)
		else
			if empty(QRY->A1_ENDENT)
				cZipCode := TRANS(QRY->A1_CEP,'@R 99999-999' )
				cRet 	 += alltrim(QRY->A1_END) + " - " + alltrim(QRY->A1_BAIRRO) + ", " + alltrim(QRY->A1_MUN) + "/" + alltrim(QRY->A1_EST) + " - " + cZipCode
			else
//				cMun := alltrim(Posicione("CC2", 1, xFilial("CC2") + QRY->(A1_ESTE + A1_CODMUNE), "CC2_MUN"))
				cRet += alltrim(QRY->A1_ENDENT) + " - " + alltrim(QRY->A1_BAIRROE) + ", " + alltrim(QRY->A1_MUNE) + "/" + alltrim(QRY->A1_ESTE) 
			endif
		endIf
	elseif upper(alltrim(cTpFrete)) $ "F"
		if nEnd == 1
			cRet += ALLTRIM(SM0->M0_NOMECOM)
		else
			cZipCode := TRANS(SM0->M0_CEPENT,'@R 99999-999' )
			cRet 	 += alltrim(SM0->M0_ENDENT) +" - "+ alltrim(SM0->M0_BAIRENT)+", "+ alltrim(SM0->M0_CIDENT) +"/"+alltrim(SM0->M0_ESTENT) +" - " + cZipCode
		endif		   
	else 
		cRet := ""
	endif
	
return (cRet)


/*
**
*/
static function retTotOrc(cOrcNUm)
	local cQuery := ""
	
	cQuery := "SELECT SUM(CK_VALOR) AS TOTAL, SUM(CK_VALDESC) as DescIt "
	cQuery += "FROM " + RetSqlName("SCK") + " "
	cQuery += "WHERE CK_NUM = '" + cOrcNUm + "' AND D_E_L_E_T_ = ' ' "
	
	TCQUERY changequery(cQuery) NEW ALIAS "QRYTOT"
	
	while QRYTOT->(!eof())
		nTotalOrc := QRYTOT->TOTAL
		nTotDescIt:= QRYTOT->DescIt
		QRYTOT->(dbSkip())
	end
	
	QRYTOT->(dbCloseArea())
return