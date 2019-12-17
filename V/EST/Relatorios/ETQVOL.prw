#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'

***************************************************************************************************************
/**
 * Rotina		:	ETQVOL() 
 * Autor		:	Gerson R. Schiavo - TOTVS IP
 * Data			:	09/05/2016
 * Descrição	:	Impressão de Etiqueta de Volume
 */  
***************************************************************************************************************
User Function ETQVOL()

Local aArea			:= GetArea()
Local cPerg 		:= 'ETQVOL'

ValidPerg(cPerg)

If !(Pergunte(cPerg,.T.))
	Return
Endif

Processa( {|| fImpressao() },"Imprimindo Etiqueta de Volume..." )   

Return


***************************************************************************************************************
/**
 * Rotina		:	fImpressao() 
 * Autor		:	Gerson R. Schiavo - TOTVS IP
 * Data			:	26/02/2016
 * Descrição	:	Impressão de Etiqueta de Volume para Expedição
 */  
***************************************************************************************************************
Static Function fImpressao()

Local cAlias		:= GetNextAlias()
Local cQuery		:= ""
Local nQtdVol		:= 0
Local nVolDe		:= 0
Local nVolAte		:= 0
Local cPorta   		:= "LPT1"

***************************************************************************************************************
//Verifica a Quantidade de Volume Total a ser impressa                                                      //
***************************************************************************************************************
if Select(cAlias) <> 0
	(cAlias)->(dbCloseArea())
endIf

cQuery  := " SELECT COUNT(*) QTDVOL "+CRLF
cQuery	+= " FROM " + RetSQLName("CB6")+CRLF
cQuery	+= " WHERE "+CRLF
cQuery	+= "     CB6_FILIAL	= 	'" + xFilial("CB6") + "'			AND "+CRLF
cQuery	+= "     CB6_NOTA	= 	'" + mv_par01 + "'	AND "+CRLF
cQuery	+= "     CB6_SERIE	=	'" + mv_par02 + "'	AND "+CRLF
cQuery	+= " 	 D_E_L_E_T_ = ' ' "+CRLF

TcQuery cQuery New Alias &cAlias   

nQtdVol:= (cAlias)->QTDVOL
*************************************************************************************************************** 


*************************************************************************************************************** 
//Seleciona a Nota informada para impressão do Volume                                                        //
***************************************************************************************************************
if Select(cAlias) <> 0
	(cAlias)->(dbCloseArea())
endif

cQuery := "SELECT CB6_NOTA, CB6_SERIE, CB6_PEDIDO, CB6_VOLUME, A4_NREDUZ, A1_NREDUZ "+CRLF 
cQuery += "FROM " + RetSQLName("CB6") + " CB6 "+CRLF
cQuery += "		INNER JOIN "+RetSQLName("SC5")+" C5 ON " +CRLF
cQuery += "			  C5_FILIAL = '"+xFilial("SC5")+"' AND " +CRLF
cQuery += "			  C5_NUM = CB6_PEDIDO AND" +CRLF
cQuery += "			  C5.D_E_L_E_T_ = ' ' " +CRLF             
cQuery += "		LEFT JOIN "+RetSQLName("SA4")+" A4 ON " +CRLF
cQuery += "			  A4_FILIAL = '"+xFilial("SA4")+"' AND " +CRLF
cQuery += "			  A4_COD = C5_TRANSP AND" +CRLF
cQuery += "			  A4.D_E_L_E_T_ = ' ' " +CRLF
cQuery += "		INNER JOIN "+RetSQLName("SA1")+" A1 ON " +CRLF
cQuery += "			  A1_FILIAL = '"+xFilial("SA1")+"' AND " +CRLF
cQuery += "			  A1_COD  = C5_CLIENTE AND" +CRLF
cQuery += "			  A1_LOJA = C5_LOJACLI AND" +CRLF
cQuery += "			  A1.D_E_L_E_T_ = ' ' " +CRLF
cQuery	+= "WHERE "+CRLF
cQuery	+= "  CB6_FILIAL  = '" + xFilial("CB6") + "' AND "+CRLF
cQuery  += "  CB6_NOTA    = '" + mv_par01 + "'   	AND "+CRLF
cQuery  += "  CB6_SERIE   = '" + mv_par02 + "'   	AND "+CRLF
cQuery	+= "  CB6.D_E_L_E_T_ = ' ' "+CRLF
TcQuery cQuery New Alias &cAlias

if (cAlias)->(!eof())

	if nQtdVol > 0

		MSCBPRINTER("ZEBRA",cPorta,,,.f.,,,,,,.t.)
		MSCBCHKSTATUS(.f.)
		
		X:= 1		
		While !(cAlias)->(Eof())
				
//			For x:= 1 to nQtdVol
			
			MSCBBEGIN(1, 6)
			IncProc("Volume "+Alltrim(STR(x))+"/"+Alltrim(STR(nQtdVol)))           
		
			MSCBWrite("^XA")
			MSCBWrite("^MMT")
			MSCBWrite("^PW679")
			MSCBWrite("^LL0280")
			MSCBWrite("^LS0")
			MSCBWrite("^FT14,35^A0N,25,24^FH\^FDDestinat\A0rio^FS")
			MSCBWrite("^FT13,165^A0N,28,28^FH\^FD"+Alltrim((cAlias)->A4_NREDUZ)+"^FS")
			MSCBWrite("^FT14,73^A0N,28,28^FH\^FD"+Alltrim((cAlias)->A1_NREDUZ)+"^FS")
			MSCBWrite("^FT13,126^A0N,28,28^FH\^FDTransportadora^FS")
			MSCBWrite("^BY3,3,56^FT14,239^BCN,,Y,N")
			MSCBWrite("^FD>;"+Alltrim((cAlias)->CB6_VOLUME)+"^FS")
			MSCBWrite("^FT473,37^A0N,28,28^FH\^FDNota Fiscal^FS")
			MSCBWrite("^FT473,74^A0N,28,28^FH\^FD"+Alltrim((cAlias)->CB6_NOTA)+'/'+Alltrim((cAlias)->CB6_SERIE)+"^FS")
			MSCBWrite("^FT474,122^A0N,28,28^FH\^FDPedido Venda^FS")
			MSCBWrite("^FT474,161^A0N,28,28^FH\^FD"+Alltrim((cAlias)->CB6_PEDIDO)+"^FS")
			MSCBWrite("^FT474,209^A0N,28,28^FH\^FDVolume^FS")
			MSCBWrite("^FT474,248^A0N,28,28^FH\^FD"+Alltrim(STR(x))+"/"+Alltrim(STR(nQtdVol))+"^FS")
			MSCBWrite("^PQ1,0,1,Y^XZ")
			
			X++
				
//			Next x
			
			(cAlias)->(dbSkip())	
		enddo
		
		MSCBEND()
		MSCBCLOSEPRINTER()
	else
		MsgAlert("Não Existe Ordem de Separação para a Nota Fiscal Informada !","Atenção")
	endif
else
	MsgAlert("Nota Fiscal Informada não Encontrada !","Atenção")
endif	

Return	


******************************************************************************************************************
******************************************************************************************************************
&& Funcao: ValidPerg(cPerg)
&& Descricao: Verifica a existencia do grupo de perguntas, caso nao exista cria.
******************************************************************************************************************
******************************************************************************************************************
Static Function ValidPerg(cPerg)  

	Local sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Nota Fiscal "	,"" ,"" ,"mv_ch1", "C", 09, 0, 0, "G", "", "mv_par01",  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF2ETQ"}) 
	aAdd(aRegs, {cPerg, "02", "Série"			,"" ,"" ,"mv_ch2", "C", 03, 0, 0, "G", "", "mv_par02",  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""}) 
	
	For i:=1 to Len(aRegs)
		If !dbSeek (cPerg + aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(sAlias)
Return

