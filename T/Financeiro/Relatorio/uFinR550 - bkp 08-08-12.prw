			#INCLUDE "PROTHEUS.CH"
#TRANSLATE INSIDE(<cTp>)  ;
	=> If(mv_par11 != 1, .T.,<cTp> $ cTipos)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ uFINR550 ³ Autor ³ Wagner Xavier         ³ Data ³ 25.02.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Razonete de Cliente/Fornecedores                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR550(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Ajustado por Marcos da Mata 02/06/2012                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function uFinR550()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1    := "Este relatorio ir  imprimir o razonete de Clientes ou"
LOCAL cDesc2    := "Fornecedores. Poder  ser emitida toda a movimenta‡„o "
LOCAL cDesc3    := "dos mesmos, ou somente os valores originais."
LOCAL wnrel     := "uFINR550"
LOCAL limite    := 132
LOCAL cString   := "SE1"
LOCAL Tamanho   := "M"

PRIVATE titulo  :=OemToAnsi("Razonete de Contas Correntes")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn := { OemToAnsi("Zebrado"), 1, OemToAnsi("Administracao") , 2, 2, 1, "",1 }  
PRIVATE nomeprog:= "uFINR550"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "UFN550"
cTipos          := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()

pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para Filtrar os tipos sem entrar na tela do ³
//³ FINRTIPOS(), localizacao Argentina.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF cPaisLoc <> "BRA"
	IF EXISTBLOCK("FARGTIP")
		cTipos	:=	EXECBLOCK("FARGTIP")
	ENDIF
ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01            // A partir de                          ³
//³ mv_par02            // Ate a data                           ³
//³ mv_par03            // Carteira (Receber ou Pagar)          ³
//³ mv_par04            // Do Codigo                            ³
//³ mv_par05            // Ate o Codigo                         ³
//³ mv_par06            // Imprime Valores Financeiros (Sim/Nao)³
//³ mv_par07            // Impime (Todos,Normais,Adiantamentos) ³
//³ mv_par08            // Do Prefixo                           ³
//³ mv_par09            // Ate o Prefixo                        ³
//³ mv_par10            // Lista Por 1 - Filial     2 -Empresa  ³
//³ mv_par11            // Seleciona Tipos                      ³
//³ mv_par12            // Natureza de  ?                       ³
//³ mv_par13            // Natureza ate ?                       ³
//³ mv_par14            // Anal¡tico/Sint‚tico                  ³
//³ mv_par15            // Filtra Prefixo para Saldo Anterior   ³
//³ mv_par16            // Folha De ?                           ³
//³ mv_par17            // Folha Ate ?                          ³
//³ mv_par18            // Filtra Contas Contabeis              ³
//³ mv_par19            // Conta Inicial                        ³
//³ mv_par20            // Conta Final                          ³
//³ mv_par21            // Impr. Saldo Contabil                 ³
//³ mv_par22            // Impr. Cli/Forn s/ Movim.?            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho,"",.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa550Imp(@lEnd,wnRel,cString)},titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA550Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 25.02.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Razonete de Cliente/Fornecedores                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA550Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FA550Imp(lEnd,wnRel,cString)

LOCAL CbCont,CbTxt
LOCAL tamanho       := "M"
LOCAL nQuebra       := 0,lImprAnt := .F.
LOCAL cNome,nTotDeb := 0,nTotCrd:=0,nSaldoAtu:=0,nTotDebG:=0,nTotCrdG:=0,nSalAtuG:=0,nSalAntG:=0
LOCAL aSaldos       := {},j,dEmissao:=CTOD(""),dVencto:=CTOD("")
LOCAL nRec,nPrim,cPrefixo,cNumero,cParcela,cTipo,cNaturez,nValliq
LOCAL nAnterior     := 0,cAnterior,cFornece,dDtDigit,cRecPag,nRec1,cSeq
LOCAL nTotAbat,  cCodigo, cLoja
LOCAL nRegistro
LOCAL lNoSkip       := .T.
LOCAL lFlag         := .F.
LOCAL nSaldoFinal   := 0
LOCAL aCampos       := {},aTam:={}
LOCAL aInd          := {}
LOCAL cCondE1       := cCondE2:=cCondE5:=" "
LOCAL cIndE1        := cIndE2 :=cIndE5 :=cIndA1 :=cIndA2 :=" "
LOCAL nRegAtu,lImprime
LOCAL nRegSe1Atu    := SE1->(RecNo())
LOCAL nOrdSe1Atu    := SE1->(IndexOrd())
LOCAL lBaixa        := .F.
LOCAL nRegSe2Atu    := SE2->(RecNo())
LOCAL nOrdSe2Atu    := SE2->(IndexOrd())
LOCAL cChaveSe1
LOCAL cChaveSe2
Local bBlockDC      := {| nNum | if(int(nNum*100)=0," ",if(nNum>0,"C","D")) }
Local aStru 	    := {}
Local aStruSE5      := {}
Local aDadosSe5     := {}
Local aSdoContabil
Local aErros 	    := {}
Local nTamNro		:= TamSx3("E1_NUM")[1]
Local nTamParc 		:= TamSx3("E1_PARCELA")[1]
Local nTamTitulo 	:= TamSx3("E1_PREFIXO")[1]+nTamNro+nTamParc
Local X             := 1
Local lOptSE5       := .F.      
Local aDadosAbat    := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Referencia para imprimir descricao dos tipos de cliente A1_TIPO ³
//ÀÄLocalizacoesÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc != "BRA"
	SX3->(dbSetOrder(2))
	SX3->(dbSeek("A1_TIPO"))
	If SX3->(Found())
		cTipoCli := AllTrim(SX3->(X3CBox()) )
		cTipoCli := '{"'+StrTran(cTipoCli,';','","')+'"}'
		aTipoCli := &(cTipoCli)
	Else            
		cTipoCli := ""
		aTipoCli := {}
	EndIf
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se seleciona tipos                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSx5()
If mv_par11 == 1
	finRTipos()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ For‡a ser por filial quando exista somente 1 filial,indepen- ³
//³ dente da resposta                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mv_par10 := Iif(SM0->(Reccount())==1,1,mv_par10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi("RAZONETE DE CONTAS CORRENTES DE ")+IIF(mv_par03==1,OemToAnsi("CLIENTES"), OemToAnsi("FORNECEDORES"))  
If mv_par14 == 1
	cabec1 := OemToAnsi("DATA     HISTORICO             PRF NUMERO       PC  EMISSAO   VENCTO    BAIXA             DEBITO          CREDITO     SALDO ATUAL")
Else
	If mv_par03 == 1	// Sintetico a Receber
		cabec1 := OEMTOANSI("CLIENTE                                                           SALDO ANTERIOR              DEBITO        CREDITO    SALDO ATUAL")
	Else					// Sintetico a Pagar
		cabec1 := OEMTOANSI("FORNECEDOR                                                        SALDO ANTERIOR              DEBITO        CREDITO    SALDO ATUAL"	)
	Endif
Endif
cabec2 := ""
m_pag  := Iif(mv_par16==0,1,mv_par16)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("E1_CLIENTE")
AADD(aCampos,{"CODIGO" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_LOJA")
AADD(aCampos,{"LOJA"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_EMIS1")
AADD(aCampos,{"DATAEM"   ,"D",aTam[1],aTam[2]})
AADD(aCampos,{"NUMERO" ,"C",nTamTitulo,0})
aTam:=TamSX3("E1_TIPO")
AADD(aCampos,{"TIPO"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_PORTADO")
AADD(aCampos,{"BANCO"  ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_EMIS1")
AADD(aCampos,{"EMISSAO","D",aTam[1],aTam[2]})
AADD(aCampos,{"BAIXA"  ,"D",aTam[1],aTam[2]})
aTam:=TamSX3("E1_VENCREA")
AADD(aCampos,{"VENCTO" ,"D",aTam[1],aTam[2]})
AADD(aCampos,{"VALOR"  ,"N",18,2})
AADD(aCampos,{"HISTOR" ,"C",40,0})
AADD(aCampos,{"DC"     ,"C", 1,0})
AADD(aCampos,{"MOEDA"  ,"N", TamSX3("E1_MOEDA")[1],0}) // Utilizada para saldo contabil
cNomeArq:=CriaTrab(aCampos)
dbUseArea( .T., __cRDDNTTS, cNomeArq, "cNomeArq", if(.F. .Or. .F., !.F., NIL), .F. )

IF mv_par03 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza e grava titulos a receber dentro dos parametros     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(2)
		If TcSrvType() != "AS/400"
			aStru:= SE1->(dbStruct())
			cCondE1:=".T."
			cQuery := "SELECT * FROM " + RetSqlName("SE1") + " WHERE"
			cIndE1	:=IndexKey()
			If mv_par10 = 1
				cQuery += " E1_FILIAL = '" + xFilial("SE1") + "' AND "
			else
				cQuery += " E1_FILIAL BETWEEN '  ' AND 'ZZ' AND"	  
				cIndE1 :=Right(cIndE1,Len(cIndE1)-10)
			endif
			cIndE1 := SqlOrder(cIndE1)
			
			dbSelectArea("SE1")
			dbCloseArea()
			dbSelectArea("SA1")
			
			cQuery += " E1_CLIENTE BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
			cQuery += " AND E1_EMIS1 <= '" + DTOS(dDataBase) + "'"
			cQuery += " AND E1_EMIS1 <= '" + DTOS(mv_par02) + "'"
			cQuery += " AND E1_TIPO NOT LIKE 'PR%'"
			If mv_par15 == 1
				cQuery += " AND E1_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
			Endif
			cQuery += " AND E1_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
			If mv_par11 == 1
				cQuery += " AND E1_TIPO IN " + FORMATIN(cTipos,"/")
			Endif
			cQuery += " AND D_E_L_E_T_ <> '*'"
			cQuery += " ORDER BY " + cIndE1
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
			
			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		else
			If mv_par10 = 1
				dbSeek(xFilial()+mv_par04,.T.)
				cCondE1:="xFilial()==SE1->E1_FILIAL .and. SE1->E1_CLIENTE >= mv_par04 .And. SE1->E1_CLIENTE <= mv_par05"
			Else
				cArqTrab :=CriaTrab(NIL,.F.)
				AADD(aInd,cArqTrab)
				cIndE1   :=IndexKey()
				cIndE1   :=Right(cIndE1,Len(cIndE1)-10)
				IndRegua("SE1",cArqTrab,cIndE1,,,OemToAnsi("Selecionando Registros..."))
				cCondE1:="SE1->E1_CLIENTE >= mv_par04 .And. SE1->E1_CLIENTE <= mv_par05"
				dbCommit()
				nIndex:=RetIndex("SE1")
				dbSelectArea("SE1")
				dbSetIndex(cArqTrab+OrdBagExt())
				dbSetOrder(nIndex+1)
				dbSeek(mv_par04,.T.)
			EndIf
		EndIf
	
	While !SE1->(Eof()) .and. &(cCondE1)
		
		If SE1->E1_NATUREZ < mv_par12 .Or. SE1->E1_NATUREZ > mv_par13
			SE1->(dbSkip())
			Loop
		EndIf
		If mv_par18 == 1		// Seleciona clientes por conta contabil
			dbSelectArea("SA1")
			MsSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
			If SA1->A1_CONTA < mv_par19 .or. SA1->A1_CONTA > mv_par20
				dbSelectArea("SE1")
				dbSkip()
				Loop
			Endif
		Endif
		dbSelectArea("SE1")

		IF SE1->E1_TIPO $ MVPROVIS
			SE1->(dbSkip())
			Loop
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. E1_TIPO $ MVRECANT  // So'Normais
			dbSkip( )
			Loop
		Endif
		
		If mv_par07 == 3 .and. !E1_TIPO $ MVRECANT // So'Adiantamentos
			dbSkip( )
			Loop
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le registros com data anterior a data inicial (para compor   ³
		//³ os saldos anteriores) ate a data final.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE1->E1_EMIS1 > mv_par02
			SE1->(dbSkip( ) )
			Loop
		End
		
		IF ! Inside(SE1->E1_TIPO)
			dbSkip()
			Loop
		End
		
		IF SE1->E1_EMIS1 >= mv_par01 .or. mv_par15 == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica prefixo caso a movimenta‡„o n„o seja interpretada   ³
			//³ para calculo do saldo anterior ou quando solicitado.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE1->E1_PREFIXO < mv_par08 .Or. SE1->E1_PREFIXO > mv_par09
				SE1->(dbSkip())
				Loop
			Endif    
		Endif

		If SE1->E1_TIPO $ MVABATIM
			AAdd( aDadosAbat, {SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_EMIS1,SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA,;
									 SE1->E1_PORTADO,SE1->E1_EMIS1,SE1->E1_VENCREA,SE1->E1_VLCRUZ,SE1->E1_BAIXA} )
		EndIf			
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava debito no arquivo de trabalho                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("cNomeArq")
		Reclock("cNomeArq",.t.)
		Replace CODIGO  With SE1->E1_CLIENTE
		Replace LOJA    With SE1->E1_LOJA
		Replace DATAEM  With SE1->E1_EMIS1
		Replace NUMERO  With SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
		Replace TIPO    With SE1->E1_TIPO
		Replace BANCO   With SE1->E1_PORTADO
		Replace EMISSAO With SE1->E1_EMIS1
		Replace VENCTO  With SE1->E1_VENCREA
		Replace VALOR   With SE1->E1_VLCRUZ
		Replace MOEDA   With SE1->E1_MOEDA
		If cPaisLoc <> "BRA"
			If SE1->E1_TIPO $ MV_CRNEG
				cHistor := OemToAnsi("NOTA DE CREDITO No. ")
			ElseIf SE1->E1_TIPO $ MV_CPNEG
				cHistor := OemToAnsi("NOTA DE DEBITO No. ")
			ElseIf ALLTRIM(SE1->E1_TIPO) $ "NF|FT"
				cHistor := OemToAnsi("FATURA No. ")
			ElseIf SE1->E1_TIPO == "RA "
				cHistor := OemToAnsi("ANTICIPO")
			ElseIf SE1->E1_TIPO == "NCI"
				cHistor := OemToAnsi("NOTA DE CRED. INTERNA")
			ElseIf SE1->E1_TIPO == "NDI"
				cHistor := OemToAnsi("NOTA DE DEB. INTERNA")
			Else
			    cHistor := SE1->E1_HIST	
			EndIf
			Replace HISTOR  With cHistor
		ElseIf SE1->E1_FATURA=="NOTFAT".and. cPaisLoc == "BRA"
			Replace HISTOR  With IIF(Empty(SE1->E1_HIST),OemToAnsi("Pela Emissao da Fatura"),SE1->E1_HIST)  
		Else
			Replace HISTOR  With IIF(Empty(SE1->E1_HIST),OemToAnsi("Pela Emissao do Titulo"),SE1->E1_HIST) 
		Endif
		If SE1->E1_TIPO $ MVRECANT+"/"+MVABATIM+"/"+MV_CRNEG
			Replace DC   With "C"
		Else
			Replace DC   With "D"
		Endif
		MsUnlock()

		dbSelectArea("SE1")
		dbSkip()
	Enddo
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			DBSelectArea("SE1")
			DbCloseArea()
			ChkFile("SE1")
		Endif
	#ENDIF
Endif

IF mv_par03 == 2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza e grava titulos a pagar dentro dos parametros       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder (6)
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			aStru:= SE2->(dbStruct())
			cCondE2:=".T."
			cQuery := "SELECT * FROM " + RetSqlName("SE2") + " WHERE"
			cIndE2	:=IndexKey()
			If mv_par10 = 1
				cQuery += " E2_FILIAL = '" + xFilial("SE2") + "' AND "
			else
				cQuery += " E2_FILIAL BETWEEN '  ' AND 'ZZ' AND"
				cIndE2 :=Right(cIndE2,Len(cIndE2)-10)
			endif
			cIndE2 := SqlOrder(cIndE2)
			
			dbSelectArea("SE2")
			dbCloseArea()
			dbSelectArea("SA1")
			cQuery += " E2_FORNECE BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
			cQuery += " AND E2_EMIS1 <= '" + DTOS(mv_par02)  + "'"
			cQuery += " AND E2_EMIS1 <= '" + DTOS(dDataBase) + "'"
			If mv_par15 == 1
				cQuery += " AND E2_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
			Endif
			cQuery += " AND E2_TIPO NOT LIKE '"+MVPROVIS+"'"
			cQuery += " AND E2_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
			If mv_par11 == 1
				cQuery += " AND E2_TIPO IN " + FORMATIN(cTipos,"/")
			Endif
			cQuery += " AND D_E_L_E_T_ <> '*'"
			cQuery += " ORDER BY " + cIndE2
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)
			
			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		Else
	#ENDIF
		dbSetOrder (6)
		If mv_par10 = 1
			dbSeek(xFilial()+mv_par04,.T.)
			cCondE2:="SE2->E2_FILIAL==xFilial() .and. SE2->E2_FORNECE >= mv_par04 .And. SE2->E2_FORNECE <= mv_par05"
		Else
			cArqTrab :=CriaTrab(NIL,.F.)
			AADD(aInd,cArqTrab)
			cIndE2   :=IndexKey()
			cIndE2   :=Right(cIndE2,Len(cIndE2)-10)
			IndRegua("SE2",cArqTrab,cIndE2,,,OemToAnsi("Selecionando Registros..."))
			cCondE2:="SE2->E2_FORNECE >= mv_par04 .And. SE2->E2_FORNECE <= mv_par05"
			dbCommit()
			nIndex:=RetIndex("SE2")
			dbSelectArea("SE2")
			#IFNDEF TOP
				dbSetIndex(cArqTrab+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndex+1)
			dbSeek(mv_par04,.T.)
		EndIf
		#IFDEF TOP
		EndIf
		#ENDIF
	
	While !SE2->(Eof()) .and. &(cCondE2)
		
		If ( SE2->E2_NATUREZ < mv_par12 .Or. SE2->E2_NATUREZ > mv_par13 )
			SE2->(dbSkip())
			Loop
		EndIf
		
		IF SE2->E2_TIPO $ MVPROVIS
			SE2->(dbSkip())
			Loop
		End
		If mv_par18 == 1		// Seleciona fornecedores por conta contabil
			dbSelectArea("SA2")
			MsSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
			If SA2->A2_CONTA < mv_par19 .or. SA2->A2_CONTA > mv_par20
				dbSelectArea("SE2")
				dbSkip()
				Loop
			Endif
		Endif
      dbSelectArea("SE2")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. SE2->E2_TIPO $ MVPAGANT // So'Normais
			dbSkip()
			Loop
		Endif
		
		If mv_par07 == 3 .and. !SE2->E2_TIPO $ MVPAGANT //So'Adiantamentos
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le registros com data anterior a data inicial (para compor   ³
		//³ os saldos anteriores) ate a data final.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE2->E2_EMIS1 > mv_par02
			SE2->(dbSkip())
			Loop
		End
		
		if ! Inside(SE2->E2_TIPO)
			dbSkip()
			Loop
		End
		
		IF SE2->E2_EMIS1 >= mv_par01 .or. mv_par15 == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica prefixo caso a movimenta‡„o n„o seja interpretada   ³
			//³ para calculo do saldo anterior ou quando solicitado.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE2->E2_PREFIXO < mv_par08 .Or. SE2->E2_PREFIXO > mv_par09
				SE2->(dbSkip())
				Loop
			EndIf
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava debito no arquivo de trabalho                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Reclock("cNomeArq",.t.)
		Replace CODIGO  With SE2->E2_FORNECE
		Replace LOJA    With SE2->E2_LOJA
		Replace DATAEM  With SE2->E2_EMIS1
		Replace NUMERO  With SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
		Replace TIPO    With SE2->E2_TIPO
		Replace BANCO   With SE2->E2_PORTADO
		Replace EMISSAO With SE2->E2_EMIS1
		Replace VENCTO  With SE2->E2_VENCREA
		Replace VALOR   With SE2->E2_VLCRUZ
		Replace MOEDA   With SE2->E2_MOEDA
		If cPaisLoc <> "BRA"
			cHistor := ""
			If SE2->E2_TIPO == "NCP"
				cHistor := OemToAnsi("NOTA DE CREDITO No. ")
			ElseIf SE2->E2_TIPO == "NDP"
				cHistor := OemToAnsi("NOTA DE DEBITO No. ")
			ElseIf ALLTRIM(SE2->E2_TIPO) $ "NF|FT"
				cHistor := OemToAnsi("FATURA No. ")
			ElseIf SE2->E2_TIPO == "NCE"
				cHistor := OemToAnsi("NOTA DE CRED. EXTERNA")
			ElseIf SE2->E2_TIPO == "NDE"
				cHistor := OemToAnsi("NOTA DE DEB. EXTERNA")
			EndIf
			Replace HISTOR  With IIF(Empty(SE2->E2_HIST),cHistor,SE2->E2_HIST)
		ElseIf SE2->E2_FATURA=="NOTFAT" .and. cPaisLoc == 'BRA'
			Replace HISTOR  With IIF(Empty(SE2->E2_HIST),OemToAnsi("Pela Emissao da Fatura"),SE2->E2_HIST)  
		Else
			Replace HISTOR  With IIF(Empty(SE2->E2_HIST),OemToAnsi("Pela Emissao do Titulo"),SE2->E2_HIST)  
		Endif
		IF SE2->E2_TIPO$ MVPAGANT+"/"+MVABATIM+"/"+MV_CPNEG
			Replace DC     With "D"
		Else
			Replace DC     With "C"     //Abatimentos
		Endif
		MsUnlock()
		//Abatimentos que fizeram parte da fatura
		IF SE2->E2_TIPO $ MVABATIM .and. !Empty(SE2->E2_FATURA) .and. ;
				SE2->E2_FATURA != "NOTFAT" .and. SE2->E2_DTFATUR <= mv_par02
			Reclock("cNomeArq",.t.)
			Replace CODIGO  With SE2->E2_FORNECE
			Replace LOJA    With SE2->E2_LOJA
			Replace DATAEM  With SE2->E2_EMIS1
			Replace NUMERO  With SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
			Replace TIPO    With SE2->E2_TIPO
			Replace BANCO   With SE2->E2_PORTADO
			Replace EMISSAO With SE2->E2_EMIS1
			Replace VENCTO  With SE2->E2_VENCREA
			Replace VALOR   With SE2->E2_VLCRUZ
			Replace BAIXA   With SE2->E2_DTFATUR
			Replace HISTOR  With OemToAnsi("BX EMIS FAT ")+SE2->E2_FATURA  
			Replace DC      With "C"     //Baixa de Abatimento por emissao de fatura
			MsUnlock()
		Endif

		dbSelectArea("SE2")
		dbSkip()
	Enddo
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			DBSelectArea("SE2")
			DbCloseArea()
			ChkFile("SE2")
		Endif
	#ENDIF
Endif

//Ordeno Array de abatimentos de C.Receber
If Len(aDadosAbat) > 0
	aSort(aDadosAbat,,,{|x,y| x[1]+x[2]+x[4] > y[1]+y[2]+y[4]})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza na movimentacao bancaria, os titulos do periodo     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE5")
dbSetOrder(7)
#IFDEF TOP
	If TcSrvType() != "AS/400"
		// Alterado por Alex Sandro Valario  em desenvolvimento 1Inicio
		aStru := SE5->(dbStruct())
		
		cCondE5:= ".T."
		cQuery := "SELECT * FROM " + RetSqlName("SE5") + " WHERE"
		cIndE5 := IndexKey()     
		cIndE5 += "+R_E_C_N_O_"
		If mv_par10 = 1
			cQuery += " E5_FILIAL = '" + xFilial("SE5") + "' AND "
		else
			cQuery += " E5_FILIAL BETWEEN '  ' AND 'ZZ' AND"
			cIndE5 :=Right(cIndE5,Len(cIndE5)-10)
		endif
		cIndE5 := SqlOrder(cIndE5)
		
		dbSelectArea("SE5")
		dbCloseArea()
		dbSelectArea("SA1")
		
		cQuery += " E5_DTDIGIT <= '" + DTOS(mv_par02) + "'"
		cQuery += " AND E5_NUMERO <> '" +space(6)+"'"
		cQuery += " AND E5_SITUACA    <> 'C'"
		cQuery += " AND E5_DTDIGIT    <= '"+DTOS(dDataBase)+ "'"
		If mv_par15 == 1
			cQuery += " AND E5_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
		Endif
		cQuery += " AND E5_CLIFOR BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
		cQuery += " AND E5_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
		If mv_par11 == 1
			cQuery += " AND E5_TIPO IN " + FORMATIN(cTipos,"/")
		Endif
		cQuery += " AND D_E_L_E_T_ <> '*'"
		If mv_par03 == 1
			cQuery += " AND ((E5_RECPAG = 'R' AND E5_TIPODOC <> 'ES')"
			cQuery += " OR (E5_TIPODOC = 'ES' AND E5_RECPAG = 'P')"
			cQuery += " OR (E5_TIPO IN ('"+MV_CRNEG+"','"+MVRECANT+"')))"
		Endif
		If mv_par03 == 2
			cQuery += " AND ((E5_RECPAG = 'P' AND E5_TIPODOC <> 'ES')"
			cQuery += " OR (E5_TIPODOC = 'ES' AND E5_RECPAG = 'R')"
			cQuery += " OR (E5_TIPO IN ('"+MV_CPNEG+"','"+MVPAGANT+"')))"
		Endif
		
		// Tratamento para restringir os registros da query do SE5 aos que possuam seus respectivos SE1 ou SE2

		If TcGetDb() $ "MSSQL/MSSQL7"
		
			cQuery += "AND EXISTS ("		
			
			cQuery += " SELECT SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("SE5")+" SE5 WHERE "
			cQuery += " SE1.E1_FILIAL = SE5.E5_FILIAL AND "
			cQuery += " SE1.E1_PREFIXO = SE5.E5_PREFIXO AND "
			cQuery += " SE1.E1_NUM = SE5.E5_NUMERO AND "
			cQuery += " SE1.E1_PARCELA = SE5.E5_PARCELA AND "
			cQuery += " SE1.E1_TIPO	= SE5.E5_TIPO AND "
			cQuery += " SE1.E1_CLIENTE = SE5.E5_CLIFOR AND "
			cQuery += " SE1.E1_LOJA = SE5.E5_LOJA "
			cQuery += " UNION "
			cQuery += " SELECT SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_LOJA FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SE5")+" SE5 WHERE "
			cQuery += " SE2.E2_FILIAL = SE5.E5_FILIAL AND "
			cQuery += " SE2.E2_PREFIXO = SE5.E5_PREFIXO AND "
			cQuery += " SE2.E2_NUM = SE5.E5_NUMERO AND "
			cQuery += " SE2.E2_PARCELA = SE5.E5_PARCELA AND "
			cQuery += " SE2.E2_TIPO	= SE5.E5_TIPO AND "
			cQuery += " SE2.E2_FORNECE = SE5.E5_CLIFOR AND "
			cQuery += " SE2.E2_LOJA	= SE5.E5_LOJA"
			
			cQuery += ") "
			
			lOptSE5 := .T.
			
		Endif

		cQuery += " ORDER BY " + cIndE5
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .F., .T.)
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	Else
#ENDIF
	If mv_par10 = 1
		dbSeek(xFilial(),.T.) // Com SoftSeek ON
		cCondE5:="xFilial('SE5') == SE5->E5_FILIAL"
	Else
		cArqTrab :=CriaTrab(NIL,.F.)
		AADD(aInd,cArqTrab)
		cIndE5   :=IndexKey()
		cIndE5   :=Right(cIndE5,Len(cIndE5)-10)
		IndRegua("SE5",cArqTrab,cIndE5,,,OemToAnsi("Selecionando Registros..."))
		cCondE5:=".T."
		dbCommit()
		nIndex:=RetIndex("SE5")
		dbSelectArea("SE5")
		#IFNDEF TOP
			dbSetIndex(cArqTrab+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndex+1)
		dbGoTop()
	EndIf
	#IFDEF TOP
	EndIf
	#ENDIF

dbSelectArea("SE1")
dbSetOrder(1)
cArqTrab :=CriaTrab(NIL,.F.)
AADD(aInd,cArqTrab)
cIndE1   :=IndexKey()
cIndE1   :=Right(cIndE1,Len(cIndE1)-10)
IndRegua("SE1",cArqTrab,cIndE1,,,OemToAnsi("Selecionando Registros..."))
dbCommit()
nIndexSE1:=RetIndex("SE1")
dbSelectArea("SE1")
#IFNDEF TOP
	dbSetIndex(cArqTrab+OrdBagExt())
#ENDIF
dbSetOrder(nIndexSE1+1)
dbGoTop()

dbSelectArea("SE2")
dbSetOrder(1)
cArqTrab :=CriaTrab(NIL,.F.)
AADD(aInd,cArqTrab)
cIndE2   :=IndexKey()
cIndE2   :=Right(cIndE2,Len(cIndE2)-10)
IndRegua("SE2",cArqTrab,cIndE2,,,OemToAnsi("Selecionando Registros..."))
dbCommit()
nIndexSE2:=RetIndex("SE2")
dbSelectArea("SE2")
#IFNDEF TOP
	dbSetIndex(cArqTrab+OrdBagExt())
#ENDIF
dbSetOrder(nIndexSE2+1)
dbGotop()

dbSelectArea("SE5")

While !SE5->(Eof()) .and. &(cCondE5)
	
	#IFNDEF TOP
		
		// Tratamento das consistencias dos registros do SE5 quando o mesmo
		// não for tratado por Query
		If !ValidSE5()
		SE5->(dbSkip())
			Loop
		Endif
	
	#ELSE
		If TcSrvType() == "AS/400"
	
			If !ValidSE5()
				SE5->(dbSkip())
				Loop
			Endif
	
		Endif
	#ENDIF
	
	dbSelectArea("SE5")
	
	If SE5->E5_RECPAG == "R" .and. mv_par03 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. E5_TIPO $ MVRECANT   // So'Normais
			dbSkip()
			Loop
		Endif
		
		If mv_par07 == 3 .and. !E5_TIPO $ MVRECANT  // So'Adiantamentos
			dbSkip()
			Loop
		Endif
	ElseIf SE5->E5_RECPAG == "P" .and. mv_par03 == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. E5_TIPO $ MVPAGANT  // So'Normais
			dbSkip( )
			Loop
		Endif
		
		If mv_par07 == 3 .and. !E5_TIPO $ MVPAGANT // So'Adiantamentos
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ignora PA's pagos com Junta de Cheque                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If E5_TIPO $ MVPAGANT .and. E5_TIPODOC == "BA" .and. !empty(E5_NUMCHEQ)
			DbSkip()
			Loop
		Endif
	Endif
	
	IF mv_par03 == 1 .and. SE5->E5_RECPAG != "R"
		If (!(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG ) .AND. SE5->E5_TIPODOC !="ES") .or. ; //Baixa de RA
			(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .AND. SE5->E5_TIPODOC =="ES") .or. ; //Estorno da Baixa de PA
			((SE5->E5_TIPO $ MVRECANT) .AND. MV_PAR07 == 2).or. ;
			(!(SE5->E5_TIPO $ MVRECANT) .AND. MV_PAR07 == 3)
			SE5->(dbSkip())
			Loop
		Endif
	EndIF
	IF mv_par03 == 2 .and. SE5->E5_RECPAG != "P"
		If (!( SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG ) .AND. SE5->E5_TIPODOC !="ES") .or.;   //Baixa de PA
			(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG .AND. SE5->E5_TIPODOC =="ES") .or. ; //Estorno da Baixa de RA
			(( SE5->E5_TIPO $ MVPAGANT) .AND. mv_par07 == 2).or. ;
			(!(SE5->E5_TIPO $ MVPAGANT) .AND. mv_par07 == 3)
			SE5->(dbSkip())
			Loop
		Endif
	Endif

	If mv_par03 == 1        // Se for baixa de adiantamentos
		If SE5->E5_RECPAG == "R" .and. E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .AND. SE5->E5_TIPODOC $ "VL/BA/DC/D2/MT/JR/J2/M2/CM/C2/CX"
			dbSkip()
			LOOP
		EndIf
	EndIf
	
	If mv_par03 == 2        // Se for baixa de adiantamentos
		If SE5->E5_RECPAG == "P" .and. E5_TIPO $ MVRECANT+"/"+MV_CRNEG .AND. SE5->E5_TIPODOC $ "VL/BA/DC/D2/MT/JR/J2/M2/CM/C2/CX"
			dbSkip()
			LOOP
		End
	End
	
	nRec := SE5 -> ( Recno () )
	nPrim:= 0
	cPrefixo := SE5->E5_PREFIXO
	cNumero  := SE5->E5_NUMERO
	cParcela := SE5->E5_PARCELA
	cTipo    := SE5->E5_TIPO
	cNaturez := SE5->E5_NATUREZ
	nValliq  := 0
	cFornece := SE5->E5_CLIFOR
	cLoja    := SE5->E5_LOJA
	dDtDigit := SE5->E5_DTDIGIT
	cRecPag  := SE5->E5_RECPAG
	cSeq     := SE5->E5_SEQ

	#IFNDEF TOP
		IF nAnterior = 0
			cAnterior := cPrefixo+cNumero+cParcela+cTipo+cFornece+Dtos(dDtDigit)+SE5->E5_RECPAG
			nAnterior := 1
			If mv_par10 = 1
				dbSeek(xFilial()+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja+cSeq)
			Else
				dbSeek(cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja+cSeq)
			EndIf
		EndIF
	#ELSE
		If TcSrvType() == "AS/400"
			IF nAnterior = 0
				cAnterior := cPrefixo+cNumero+cParcela+cTipo+cFornece+Dtos(dDtDigit)+SE5->E5_RECPAG
				nAnterior := 1
				If mv_par10 = 1
					dbSeek(xFilial()+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja+cSeq)
				Else
					dbSeek(cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja+cSeq)
				EndIf
			EndIF
		Endif
	#ENDIF
	While ! SE5->(Eof()) .and. SE5->E5_PREFIXO==cPrefixo .and. ;
		SE5->E5_NUMERO==cNumero   .and. ;
		SE5->E5_PARCELA==cParcela .and. ;
		SE5->E5_TIPO==cTipo       .and. ;
		SE5->E5_CLIFOR==cFornece  .and. ;
		SE5->E5_LOJA==cLoja       .and. ;
		SE5->E5_SEQ==cSeq
		
		If mv_par03 == 2 .and. SE5->E5_CLIFOR+E5_LOJA != cFornece+cLoja
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Devera' ser considerado o valor sem liquido da baixa         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		#IFNDEF TOP

			// Tratamento das consistencias dos registros do SE5 quando o mesmo
			// não for tratado por Query

			If !ValidSE5()
				SE5->(dbSkip())
				Loop
			Endif

		#ELSE
			If TcSrvType() == "AS/400"

				If !ValidSE5()
					SE5->(dbSkip())
					Loop
				Endif

			Endif
		#ENDIF
		
		If mv_par18 == 1		// Seleciona clientes por conta contabil
			If mv_par03 == 1
				dbSelectArea("SA1")
				dbSeek(xFilial()+SE5->E5_CLIFOR+SE5->E5_LOJA)
				dbSelectArea("SE5")
				If SA1->A1_CONTA < mv_par19 .or. SA1->A1_CONTA > mv_par20
					dbSkip()
					Loop
				Endif
			Else	
				dbSelectArea("SA2")
				dbSeek(xFilial()+SE5->E5_CLIFOR+SE5->E5_LOJA)
				dbSelectArea("SE5")
				If SA2->A2_CONTA < mv_par19 .or. SA2->A2_CONTA > mv_par20
					dbSkip()
					Loop
				Endif
			Endif
		Endif	

		If	SE5->E5_TIPO $ MVRECANT .and. SE5->E5_TIPODOC == "ES" .and. mv_par03 == 1
			dbSelectArea("SE1")
			If mv_par10 = 1
				SE1->(dbSetOrder(1))
				SE1->(MsSeek(xFilial()+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)))
			Else
				dbSetOrder(nIndexSE1+1)
				SE1->(MsSeek(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)))
			EndIf
			If !(Found())
				dbSelectArea("SE5")
				SE5->(dbSkip())
				Loop
			Endif
		EndIf

		If	SE5->E5_TIPO $ MVPAGANT .and. SE5->E5_TIPODOC == "ES" .and. mv_par03 == 2
			dbSelectArea("SE2")
			If mv_par10 = 1
				SE2->(dbSetOrder(1))
				SE2->(dbSeek(xFilial()+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
			Else
				dbSetOrder(nIndexSE2+1)
				SE2->(dbSeek(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
			EndIf
			If !(Found())
				dbSelectArea("SE5")
				SE5->(dbSkip())
				Loop
			Endif
		EndIf

		dbSelectArea("SE5")

		IF mv_par03 == 1 .and. SE5->E5_RECPAG != "R"
			If (!(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG ) .AND. SE5->E5_TIPODOC !="ES") .or. ; //Baixa de RA
				(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .AND. SE5->E5_TIPODOC =="ES") .or. ; //Estorno da Baixa de PA
				((SE5->E5_TIPO $ MVRECANT) .AND. MV_PAR07 == 2).or. ;
				(!(SE5->E5_TIPO $ MVRECANT) .AND. MV_PAR07 == 3)
				SE5->(dbSkip())
				Loop
			Endif
		EndIF
		IF mv_par03 == 2 .and. SE5->E5_RECPAG != "P"
			If (!( SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG ) .AND. SE5->E5_TIPODOC !="ES") .or.;   //Baixa de PA
				(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG .AND. SE5->E5_TIPODOC =="ES") .or. ; //Estorno da Baixa de RA
				(( SE5->E5_TIPO $ MVPAGANT) .AND. mv_par07 == 2).or. ;
				(!(SE5->E5_TIPO $ MVPAGANT) .AND. mv_par07 == 3)
				SE5->(dbSkip())
				Loop
			Endif
		Endif
			
		If mv_par03 == 1        // Se for baixa de adiantamentos
			If SE5->E5_RECPAG == "R" .and. E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .AND. SE5->E5_TIPODOC $ "VL/BA/DC/D2/MT/JR/J2/M2/CM/C2/CX"
				dbSkip()
				LOOP
			Endif
		Endif
	
		If mv_par03 == 2        // Se for baixa de adiantamentos
			If SE5->E5_RECPAG == "P" .and. E5_TIPO $ MVRECANT+"/"+MV_CRNEG .AND. SE5->E5_TIPODOC $ "VL/BA/DC/D2/MT/JR/J2/M2/CM/C2/CX"
				dbSkip()
				LOOP
			Endif
		Endif

		If nPrim == 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Localiza o cliente ou fornecedor                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCarteira := SE5->E5_RECPAG
			If SE5->E5_RECPAG == "R"
				If (SE5->E5_TIPO$MVPAGANT+"/"+MV_CPNEG).and.SE5->E5_TIPODOC $ "BAüVL" ;
					.OR. SE5->E5_TIPODOC =="ES"		
					cCarteira := "P"        //Baixa de adiantamento (inverte)
				Endif
			Endif
			
			If SE5->E5_RECPAG == "P"
				If (SE5->E5_TIPO$MVRECANT+"/"+MV_CRNEG).and.SE5->E5_TIPODOC $ "BAüVL" ;
					.OR. SE5->E5_TIPODOC =="ES"	
					cCarteira := "R"        //Baixa de adiantamento (inverte)
				Endif
			Endif


			IF cCarteira == "R"
				dbSelectArea("SE1")
				If mv_par10 = 1
					dbSetOrder(1)
					MsSeek(xFilial()+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
				Else
					dbSetOrder(nIndexSE1+1)
					MsSeek(SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
				EndIf
				//Caso nÆo ache o registro no SE1, nÆo considero os movimentos
				If !Found()
					dbSelectArea("SE5")
					DbSkip()
					Loop
				Endif				
			Else
				dbSelectArea("SE2")
				If mv_par10 = 1
					dbSetOrder(1)
					dbSeek(xFilial()+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
				Else
					dbSetOrder(nIndexSE2+1)
					dbSeek(SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
				EndIf
				//Caso nÆo ache o registro no SE2, nÆo considero os movimentos
				If !Found()
					dbSelectArea("SE5")
					DbSkip()
					Loop
				Endif				
			Endif

			dbSelectArea("SE5")
			IF cCarteira == "R"
				dEmissao := SE1->E1_EMIS1
				dVencto  := SE1->E1_VENCREA
			Else
				dEmissao := SE2->E2_EMIS1
				dVencto  := SE2->E2_VENCREA
			End
			nPrim++
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta Array com dados do titulo Pai. Usado apenas quando for       ³
		//³ TOP, nÆo AS/400, e NÆo imprimir valores financeiros (mv_par10 = 2) ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		#IFDEF TOP
		   If TcSrvType() != "AS/400" .and. mv_par06 == 2
				aDadosSe5 := TrabDados()
			Endif
		#ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ A fun‡Æo TRABDADOS() ‚ utilizada para montar array com os da-³
		//³ dos necessarios do SE5 para a grava‡Æo no arquivo de trabalho³
		//³ Isto se deve ao fato de no SQL, quando mv_par10 = 2 (nÆo im- ³
		//³ prime valores financeiros), a Query est  sempre um registro  ³
		//³ posterior a montagem dos valores e nÆo ser possivel reposi-  ³
		//³ cionar no registro devido                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If SE5->E5_TIPODOC $ "VLüBAüCPüV2üLJüES"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ O estorno (ES) deve ter tratamento diferenciado quando se im-³
			//³ prime ou nÆo valores financeiros. Quando se considerar valor ³
			//³ financeiro, deve ser somado,pois na fun‡Æo GravaTrab sera tra³
			//³ tado na coluna de Cred/Deb. Ao nÆo se imprimir valores finan-³
			//³ ceiros, deve ser subtraido, pois nÆo se d  tratamento deb/cre³
			//³ das colunas, apenas se reconstituindo os valores das baixas. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE5->E5_TIPODOC == "ES" .and. mv_par06 == 2
				nValliq-=E5_VALOR
			Else
				nValliq+=E5_VALOR
			Endif
			IIF(mv_par06==1,GravaTrab("B",dEmissao,dVencto,,TrabDados(),aDadosAbat,.T.),NIL)
		ElseIf SE5->E5_TIPODOC $ "DC/D2"
			nValliq+=E5_VALOR
			IIF(mv_par06==1,GravaTrab("D",dEmissao,dVencto,,TrabDados(),aDadosAbat),NIL)
		Elseif SE5->E5_TIPODOC $ "MT/JR/J2/M2"
			IIF(mv_par06==1,GravaTrab("M",dEmissao,dVencto,,TrabDados(),aDadosAbat),NIL)
			nValliq-=E5_VALOR
		Elseif SE5->E5_TIPODOC $ "CM/C2/CX/VM"
			IIF(mv_par06==1,GravaTrab("C",dEmissao,dVencto,,TrabDados(),aDadosAbat),NIL)
			nValLiq-=E5_VALOR
		Endif
		SE5->(dbSkip())
	End
	#IFNDEF TOP
		nRec1 := SE5->(Recno())
		dBGoto(nRec)
	#ENDIF
	IF mv_par06==2 .and. nValLiq != 0
		#IFDEF TOP
		   If TcSrvType() != "AS/400"
				GravaTrab("B",dEmissao,dVencto,nValLiq,aDadosSE5,aDadosAbat)
			Else
		#ENDIF
				GravaTrab("B",dEmissao,dVencto,nValLiq,TrabDados(),aDadosAbat)
		#IFDEF TOP
			Endif
		#ENDIF
	EndIf

	#IFNDEF TOP
		dbGoto(nRec1)
	#ENDIF
	nAnterior := 0
End
#IFDEF TOP
	If TcSrvType() != "AS/400"
		DBSelectArea("SE5")
		DbCloseArea()
		ChkFile("SE5")
	Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia rotina de impressao                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("cNomeArq")
IndRegua("cNomeArq",cNomeArq,"CODIGO+LOJA+Dtos(DATAEM)+Numero",,,OemToAnsi("Selecionando Registros..."))
dbGoTop()
nTotDebG := 0
nTotCrdG := 0
nSalAtuG := 0

SetRegua(RecCount())

While !Eof()
	
	IF lEnd
		@Prow()+1,0 PSAY OemToAnsi("***** Cancelado pelo Operador *****")
		Exit
	End
	
	cCodigo  := CODIGO
	cLoja    := LOJA
	nSaldoAtu:= 0
	nTotDeb  := 0
	nTotCrd  := 0
	
	If li>50
		IF m_pag > mv_par17
			m_pag := mv_par16
		Endif
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		li := 8
	Endif

	nRegAtu  := RecNo()
	lImprime := .F.
	
	While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And. ! Eof()
		
		If DATAEM >= mv_par01     // Procura titulos no intervalo e
			lImprime := .T.     // se houver, dever  imprimir
			Exit
		Endif
		dbSkip()
	Enddo
	dbGoto(nRegAtu)
	aSdoContabil := {} // Saldo da conta contabil do fornecedor
	aErros:={}//itens com divergencia
	cConta := ""
	While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And. ! Eof()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Loop para calculo do saldo anterior                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And.;
			cNomeArq->DATAEM < mv_par01 .And. ! Eof() .And. (mv_par22 == 1 .or. lImprime)
			If DC == "C"
				nSaldoAtu += ABS(cNomeArq->VALOR)
			Else
				nSaldoAtu -= ABS(cNomeArq->VALOR)
			EndIf
			
			IncRegua()
			
			dbSkip()
			If cNomearq->CODIGO != ccodigo .Or. cNomeArq->LOJA != cLoja
				lNoSkip := .T.
			Endif
		Enddo
		
		If lImprime .Or. nSaldoAtu != 0
			If li > 50
				IF m_pag>1
					li++
					@ li,092 PSAY OemToAnsi("A TRANSPORTAR : ")
					@ li,116 PSAY Abs(nSaldoAtu)    Picture tm(Abs(nSaldoAtu),14)
					@ li,131 PSAY Eval(bBlockDC,nSaldoAtu)
				Endif
			
				IF m_pag > mv_par17
					m_pag := mv_par16
				Endif
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
				li:=8
				
				If nQuebra == 1
					If mv_par03==1
						dbSelectArea("SA1")
						If mv_par10 = 1
							dbSeek(xFilial()+cCodigo+cLoja)
						Else
							If cIndA1 == " "
								cArqTrab :=CriaTrab(NIL,.F.)
								AADD(aInd,cArqTrab)
								cIndA1   :=IndexKey()
								cIndA1   :=Right(cIndA1,Len(cIndA1)-10)
								IndRegua("SA1",cArqTrab,cIndA1,,,OemToAnsi("Selecionando Registros..."))
								dbCommit()
								nIndex:=RetIndex("SA1")
								dbSelectArea("SA1")
								#IFNDEF TOP
									dbSetIndex(cArqTrab+OrdBagExt())
								#ENDIF
								dbSetOrder(nIndex+1)
							EndIf
							dbSeek(cCodigo+cLoja)
						EndIf
						If mv_par14 == 1  // Analitico
							cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+SA1->A1_CONTA
						Else
							cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,SA1->A1_CONTA,SA1->A1_CGC)
						Endif
						cConta := SA1->A1_CONTA
						If mv_par21 ==1 .And. Empty(aSdoContabil) .And. !Empty(SA1->A1_CONTA)
							// Obtem o saldo da conta do fornecedor
//							aSdoContabil := SdoContabil(SA1->A1_CONTA,MV_PAR02,"01","1")	
						   aSdoContabil :=SaldoCT4(SA1->A1_CONTA,,"C"+cCodigo+cLoja,MV_PAR02,"01","1")
						Endif	
					Else
						dbSelectArea("SA2")
						If mv_par10 = 1
							dbSeek(xFilial()+cCodigo+cLoja)
						Else
							If cIndA2 == " "
								cArqTrab :=CriaTrab(NIL,.F.)
								AADD(aInd,cArqTrab)
								cIndA2   :=IndexKey()
								cIndA2   :=Right(cIndA2,Len(cIndA2)-10)
								IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi("Selecionando Registros..."))
								dbCommit()
								nIndex:=RetIndex("SA2")
								dbSelectArea("SA2")
								#IFNDEF TOP
									dbSetIndex(cArqTrab+ordBagExt())
								#ENDIF
								dbSetOrder(nIndex+1)
							EndIf
							dbSeek(cCodigo+cLoja)
						EndIf
						If mv_par14 == 1  // Analitico
							cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+SA2->A2_CONTA
						Else
							cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,SA2->A2_CONTA,SA2->A2_CGC)
						Endif
						cConta := SA2->A2_CONTA
						If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA2->A2_CONTA)
							// Obtem o saldo da conta do fornecedor
//							aSdoContabil := SdoContabil(SA2->A2_CONTA,MV_PAR02,"01","1")	
						   aSdoContabil :=SaldoCT4(SA2->A2_CONTA,,"F"+cCodigo+cLoja,MV_PAR02,"01","1")
						Endif	
					EndIF
					
					If cPaisLoc == 'BRA'
						If mv_par14 == 1   // Analitico
							@li,000 PSAY cCodigo + "-" + cLoja + " " + cNome
							li++
							@li,092 PSAY OemToAnsi("DE TRANSPORTE : ")
							@li,116 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),14)
							@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
							li++
						Endif
					Else  //If cPaisLoc == "ARG"
						If mv_par03 == 1
							SA1->( dbSetOrder(1) )
							SA1->( dbSeek(xFilial("SA1")+cCodigo+cLoja) )
						Else
							SA2->( dbSetOrder(1) )
							SA2->( dbSeek(xFilial("SA2")+cCodigo+cLoja) )
						Endif
						
						@li,000 PSAY If(mv_par03==1,Subs(SA1->A1_NOME,1,40),Subs(SA2->A2_NOME,1,40) )
						@li,050 PSAY cCodigo + "-" + cLoja
						@li,092 PSAY OemToAnsi("TRANSPORTAR : ")
						@li,116 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),14)
						@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
						li+=1
						
						
						//cTipoCli := TABELA("SF",SA1->A1_TIPO,.T.)                                     
						cPosTp := aScan( aTipoCli, {|x| Subs(x,1,1) == If(mv_par03==1,SA1->A1_TIPO,SA2->A2_TIPO)  } )
						cTipoCli := Iif( cPosTp>0 , aTipoCli[cPosTp] , "" )
						
						SX5->( dbSetOrder(1) )
						SX5->( dbSeek(xFilial("SX5")+"12"+If(mv_par03==1,SA1->A1_EST,SA2->A2_EST)) )
						
						If mv_par03 == 1
							@li,000 PSAY SA1->A1_END
							@li,050 PSAY "Te: "+Subs(Alltrim(SA1->A1_TEL),1,36)
							@li,092 PSAY OemToAnsi("VENDEDOR: ")+SA1->A1_VEND  
							li+=1
							@li,000 PSAY SA1->A1_CEP+" - " + SA1->A1_MUN
							If SX5->( Found() ) .or. !Empty(X5Descri())
								@li,092 PSAY AllTrim(X5Descri())     // Diego
							EndIf
							li+=1
							@li,000 PSAY cTipoCli
							@li,050 PSAY Trans(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))
							li+=2
						Else
							@li,000 PSAY SA2->A2_END
							@li,050 PSAY "Te: "+ Subs(Alltrim(SA2->A2_TEL),1,36)
							@li,092 PSAY OemToAnsi("COMPRADOR: ")
							li+=1
							@li,000 PSAY SA2->A2_CEP+" - " +SA2->A2_MUN
							If SX5->( Found() ) .or. !Empty(X5Descri())
								@li,092 PSAY AllTrim(X5Descri())    // Diego
							Endif
							li+=1
							@li,000 PSAY cTipoCli
							@li,050 PSAY Trans(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))
							li+=2
						EndIf
					EndIf
				EndIf
			Endif
		EndIf
		
		If nQuebra == 0 .and. (lImprime .Or. nSaldoAtu != 0 )
			nQuebra  := 1
			lImprAnt := .F.
			IF mv_par03 == 1
				dbSelectArea("SA1")
				If mv_par10 = 1
					dbSeek(xFilial()+cCodigo+cLoja)
				Else
					If cIndA1 == " "
						cArqTrab :=CriaTrab(NIL,.F.)
						AADD(aInd,cArqTrab)
						cIndA1   :=IndexKey()
						cIndA1   :=Right(cIndA1,Len(cIndA1)-10)
						IndRegua("SA1",cArqTrab,cIndA1,,,"Selecionando Registros...")
						dbCommit()
						nIndex:=RetIndex("SA1")
						dbSelectArea("SA1")
						#IFNDEF TOP
							dbSetIndex(cArqTrab+OrdBagEXt())
						#ENDIF
						dbSetOrder(nIndex+1)
					EndIf
					dbSeek(cCodigo+cLoja)
				EndIf
				If mv_par14 == 1  // Analitico
					cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+SA1->A1_CONTA
				Else
					cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,SA1->A1_CONTA,SA1->A1_CGC)
				Endif
				cConta := SA1->A1_CONTA
				If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA1->A1_CONTA)
					// Obtem o saldo da conta do fornecedor
//					aSdoContabil := SdoContabil(SA1->A1_CONTA,MV_PAR02,"01","1")	
						   aSdoContabil :=SaldoCT4(SA1->A1_CONTA,,"C"+cCodigo+cLoja,MV_PAR02,"01","1")
				Endif	
			Else
				dbSelectArea("SA2")
				If mv_par10 = 1
					dbSeek(xFilial()+cCodigo+cLoja)
				Else
					If cIndA2 == " "
						cArqTrab :=CriaTrab(NIL,.F.)
						AADD(aInd,cArqTrab)
						cIndA2   :=IndexKey()
						cIndA2   :=Right(cIndA2,Len(cIndA2)-10)
						IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi("Selecionando Registros..."))
						dbCommit()
						nIndex:=RetIndex("SA2")
						dbSelectArea("SA2")
						#IFNDEF TOP
							dbSetIndex(cArqTrab+OrdBagExt())
						#ENDIF
						dbSetOrder(nIndex+1)
					EndIf
					dbSeek(cCodigo+cLoja)
				EndIf
				If mv_par14 == 1  // Analitico
					cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+SA2->A2_CONTA
				Else
					cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,SA2->A2_CONTA,SA2->A2_CGC)
				Endif
				cConta := SA2->A2_CONTA
				If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA2->A2_CONTA)
					// Obtem o saldo da conta do fornecedor
//					aSdoContabil := SdoContabil(SA2->A2_CONTA,MV_PAR02,"01","1")	
						   aSdoContabil :=SaldoCT4(SA2->A2_CONTA,,"F"+cCodigo+cLoja,MV_PAR02,"01","1")
				Endif	
			EndIF
			
			If cPaisLoc == "BRA"
				If mv_par14 == 1  // Analitico
					@li,000 PSAY cCodigo + "-" + cLoja + " " + cNome
					dbSelectArea("cNomeArq")
					li++
					@li, 92 PSAY OemToAnsi("SALDO ANTERIOR : ")
					@li,116 PSAY Abs(nSaldoAtu)     Picture tm(Abs(nSaldoAtu),14)
					@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
					nSalAntG += nSaldoAtu
					li++
				Else
					@li,000 PSAY Substr(cCodigo + "-" + cLoja + " " + cNome,1,64)
					@li,066 PSAY Abs(nSaldoAtu)     Picture tm(Abs(nSaldoAtu),14)
					@li,081 PSAY Eval(bBlockDC,nSaldoAtu)
					nSalAntG += nSaldoAtu
				Endif	
			Else  //If cPaisLoc == "ARG" // MariSol Argentina Jose Lucas 17/04/99
				
				If mv_par03 == 1
					SA1->( dbSetOrder(1) )
					SA1->( dbSeek(xFilial("SA1")+cCodigo+cLoja) )
				Else
					SA2->( dbSetOrder(1) )
					SA2->( dbSeek(xFilial("SA2")+cCodigo+cLoja) )
				Endif
				
				@li,000 PSAY If(mv_par03==1,Subs(SA1->A1_NOME,1,40),Subs(SA2->A2_NOME,1,40) )
				@li,050 PSAY cCodigo + "-" + cLoja
				@li,092 PSAY OemToAnsi("SALDO ANTERIOR : ")
				@li,116 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),14)
				@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
				nSalAntG += nSaldoAtu
				li+=2
				
				//cTipoCli := TABELA("SF",SA1->A1_TIPO,.T.)
				cPosTp := aScan( aTipoCli, {|x| Subs(x,1,1) == Iif(mv_par03==1,SA1->A1_TIPO,SA2->A2_TIPO)  } )
				cTipoCli := Iif( cPosTp>0 , aTipoCli[cPosTp] , "" )
				
				SX5->( dbSetOrder(1) )
				SX5->( dbSeek(xFilial("SX5")+"12"+If(mv_par03==1,SA1->A1_EST,SA2->A2_EST)) )
				
				If mv_par03 == 1
					@li,000 PSAY SA1->A1_END
					@li,050 PSAY "Te: "+Subs(Alltrim(SA1->A1_TEL),1,36)
					@li,092 PSAY OemToAnsi("VENDEDOR : ")+SA1->A1_VEND  
					li+=1
					@li,000 PSAY SA1->A1_CEP+" - " +SA1->A1_MUN
					If SX5->( Found() ) .or. !Empty(X5Descri())
						@li,092 PSAY AllTrim(X5Descri())   // Diego
					EndIf
					li+=1
					@li,000 PSAY cTipoCli
					@li,050 PSAY Trans(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))
					li+=2
				Else
					@li,000 PSAY SA2->A2_END
					@li,050 PSAY "Te: "+Subs(Alltrim(SA2->A2_TEL),1,36)
					@li,092 PSAY OemToAnsi("COMPRADOR: ")
					li+=1
					@li,000 PSAY SA2->A2_CEP+" - " +SA2->A2_MUN
					If SX5->( Found() ) .or. !Empty(X5Descri())
						@li,092 PSAY AllTrim(X5Descri())  // Diego
					EndIf
					li+=1
					@li,000 PSAY cTipoCli
					@li,050 PSAY Trans(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))
					li+=2
				EndIf
			EndIf
		End
		dbSelectArea("cNomeArq")
		
		If cNomeArq->DATAEM >= mv_par01 .And. !lNoSkip
			If DC == "D"
				nSaldoAtu -= ABS(cNomeArq->VALOR)
				nTotDeb   += ABS(cNomeArq->VALOR)
				nTotDebG  += ABS(cNomeArq->VALOR)
				nSalAtuG  -= ABS(cNomeArq->VALOR)
			Else
				nSaldoAtu += ABS(cNomeArq->VALOR)
				nTotCrd   += ABS(cNomeArq->VALOR)
				nTotCrdG  += ABS(cNomeArq->VALOR)
				nSalAtuG  += ABS(cNomeArq->VALOR)
			End
			If mv_par14 == 1  // Analitico
				li++
				@li,000 PSAY DATAEM
				If OemToAnsi("Recibo")$ HISTOR  
					@li,011 PSAY Substr(HISTOR, At(OemToAnsi("Recibo"),HISTOR),20)
				Else
					@li,011 PSAY SubStr(HISTOR,1,20)
				EndIf
				@li,033 PSAY SubStr(NUMERO, 1,3)
				@li,037 PSAY SubStr(NUMERO, 4,nTamNro)
				@li,051 PSAY SubStr(NUMERO,nTamNro+4,nTamParc)
				@li,055 PSAY EMISSAO
				@li,066 PSAY VENCTO
				IF !Empty(BAIXA)
					@li,077 PSAY BAIXA
				End
				@li,IIF(DC=="D",88,102) PSAY ABS(cNomeArq->VALOR) PicTure tm(cNomeArq->VALOR,13)
				@li,116 PSAY Abs(nSaldoAtu)      Picture tm(Abs(nSaldoAtu),14)
				@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
			Endif
		End
		lFlag := .T.
		If ! lNoSkip
			IncRegua()
			dbSkip( )
		End
		lNoSkip := .F.
	End
	If lImprime .Or. nSaldoAtu != 0
		If mv_par14 == 1		// Analitico		
			li+= 2
			@li,  0 PSAY OemToAnsi("T o t a i s  d o  ")+IIF(mv_par03==1,OemToAnsi(),OemToAnsi("F o r n e c e d o r"))
		Endif
		@li, 88 PSAY nTotDeb                Picture tm(nTotDeb,13)
		@li,102 PSAY nTotCrd                Picture tm(nTotCrd,13)
		@li,116 PSAY Abs(nSaldoAtu)     Picture tm(Abs(nSaldoAtu),14)
		@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
		If mv_par21 == 1 .And. !Empty(aSdoContabil)
			li+=2
			@li,0 PSAY "T o t a i s  d o  I t e m  "+IIF(mv_par03==1,OemToAnsi("C l i e n t e"),OemToAnsi("F o r n e c e d o r")) + If(!Empty(cConta)," ("+cConta+")","") 
			@li, 88 PSAY Abs(aSdoContabil[4])			Picture tm(aSdoContabil[4],13)
			@li,102 PSAY Abs(aSdoContabil[5])			Picture tm(aSdoContabil[5],13)
			@li,116 PSAY Abs(aSdoContabil[1]) 			Picture tm(aSdoContabil[1],14)
			@li,131 PSAY Eval(bBlockDC,aSdoContabil[1])
			IF EMPTY(aSdoContabil)
				nSdo:=0
			else
				nSdo:=aSdoContabil[1]
			endif
			if nSdo<>nSaldoAtu
				aAdd(aErros,{Substr(cCodigo + "-" + cLoja + " " + cNome,1,64),nSaldoAtu,nSdo})
			endif
		Endif	
		li++
		If mv_par14 == 1
			@li,  0  PSAY Repl("-",132)
			li++
		Endif
	Endif
	nQuebra:=0
End

If nQuebra # 0 .and.(lImprime .Or. nSaldoAtu != 0)
	If mv_par14 == 1		// Analitico		
		li+= 2
		@li,  0 PSAY OemToAnsi("T o t a i s  d o  ")+IIF(mv_par03==1,OemToAnsi("C l i e n t e"),OemToAnsi("F o r n e c e d o r")) 
	Endif
	@li, 88  PSAY nTotDeb                    Picture tm(nTotDeb,13)
	@li,102  PSAY nTotCrd                    Picture tm(nTotCrd,13)
	@li,116  PSAY Abs(nSaldoAtu)     Picture tm(Abs(nSaldoAtu),14)
	@li,131  PSAY Eval(bBlockDC,nSaldoAtu)
End
If lFlag
	li++
	IF li>50
	
		IF m_pag > mv_par17
			m_pag := mv_par16
		Endif
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		li:=8
	End
	If mv_par14 == 1 		// Analitico
		@li,  0  PSAY Repl("-",132)
		li++
		@li,  0  PSAY OemToAnsi("T o t a l   G e r a l  d o s  ")+IIF(mv_par03==1,OemToAnsi("C l i e n t e s"),OemToAnsi("F o r n e c e d o r e s"))  
		@li, 88  PSAY nTotDebG               Picture tm(nTotDebG,13)
		@li,102  PSAY nTotCrdG               Picture tm(nTotCrdG,13)
		@li,116  PSAY Abs(nSalAtuG)      Picture tm(Abs(nSalAtuG),14)
		@li,131  PSAY Eval(bBlockDC,nSalAtuG)
		li+=2
		@li, 0   PSAY Repl("-",132)
		li++
		@li,  0  PSAY OemToAnsi("S a l d o   F i n a l   d o   R e l a t o r i o : ")
		nSaldoFinal := (nSalAntG-nTotDebG+nTotCrdG)
		@li, 116 PSAY Abs(nSaldoFinal)  Picture tm(Abs(nSaldoFinal),14)
		@li ,131 PSAY Eval(bBlockDC,nSaldoFinal)
	Else
		@li, 0   PSAY Repl("-",132)
		nSaldoFinal := (nSalAntG-nTotDebG+nTotCrdG)
		li++
		@li, 000 PSAY OemToAnsi("S a l d o   F i n a l   d o   R e l a t o r i o : ")
		@li, 066 PSAY nSalAntG 				Picture tm(nSalAntG,14)
		@li, 081 PSAY Eval(bBlockDC,nSalAntG)
		@li, 088 PSAY nTotDebG				Picture tm(nTotDebG,13)
		@li, 102 PSAY nTotCrdG				Picture tm(nTotCrdG,13)
		@li, 116 PSAY Abs(nSaldoFinal)  Picture tm(Abs(nSaldoFinal),14)
		@li ,131 PSAY Eval(bBlockDC,nSaldoFinal)
		li+=2
		@li, 0   PSAY Repl("-",132)
		li++
		@li,  0  PSAY OemToAnsi("T o t a l   G e r a l  d o s  ")+IIF(mv_par03==1,OemToAnsi("C l i e n t e s"),OemToAnsi("F o r n e c e d o r e s"))
		@li, 88  PSAY nTotDebG				Picture tm(nTotDebG,13)
		@li,102  PSAY nTotCrdG				Picture tm(nTotCrdG,13)
		@li,116  PSAY Abs(nSalAtuG)		Picture tm(Abs(nSalAtuG),14)
		@li,131  PSAY Eval(bBlockDC,nSalAtuG)
	Endif
	li++
	@li, 0 PSAY Repl("-",132)
End

if mv_par23 == 1 .and. !Empty(aErros)//len(Alltrim(aErros)) > 0

		if !Empty(aErros) //len(Alltrim(aErros)) > 0 
			cabec1:="ITEM CONTABIL        SLD FINANCEIRO   SLD CONTABIL   DIFERENCA"
			cabec2:=""
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
			li:=9
			for x:=1 to len(aErros)
				@li, 0 PSAY aErros[x][1]  
				@li, 60 PSAY aErros[x][2] Picture tm(aSdoContabil[5],13)
				@li, 80 PSAY aErros[x][3] Picture tm(aSdoContabil[5],13)
				@li, 100 PSAY abs(aErros[x][2]-aErros[x][3]) Picture tm(aSdoContabil[5],13)
				li++
				If li > 50
					IF m_pag > mv_par17
						m_pag := mv_par16   
					Endif
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
					li:=8
				endif
			next
		else
			cabec1:="ITEM CONTABIL        SLD FINANCEIRO   SLD CONTABIL"
			cabec2:=""
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
			li:=9
			@li, 0 PSAY "Sem divergencias!"
		endif
endif

dbSelectArea("cNomeArq")
Use
Ferase(cNomeArq+GetDBExtension())         // Elimina arquivos de Trabalho
Ferase(cNomeArq+OrdBagExt())    // Elimina arquivos de Trabalho

dbSelectArea("SA1")
RetIndex("SA1")
dbSetOrder(1)
Set Filter To

dbSelectArea("SA2")
RetIndex("SA2")
dbSetOrder(1)
Set Filter To

#IFDEF TOP
	If TcSrvType() != "AS/400"
		dbSelectArea("SE1")
		dbCloseArea()
		ChKFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
		
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSelectArea("SE2")
		dbSetOrder(1)
		
		dbSelectArea("SE5")
		dbCloseArea()
		ChKFile("SE5")
		dbSelectArea("SE5")
		dbSetOrder(1)
	Else
#ENDIF
	dbSelectArea("SE1")
	RetIndex("SE1")
	dbSetOrder(1)
	Set Filter To
	
	dbSelectArea("SE2")
	RetIndex("SE2")
	dbSetOrder(1)
	Set Filter To
	
	dbSelectArea("SE5")
	RetIndex("SE5")
	dbSetOrder(1)
	Set Filter To
	#IFDEF TOP
	EndIF
	#ENDIF

For nI:=1 to Len(aInd)
	if File(aInd[nI]+OrdBagExt())
		Ferase(aInd[nI]+OrdBagExt())
	Endif
Next

Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	dbCommitall()
	Ourspool(wnrel)
Endif
MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravaTrab ³ Autor ³ Wagner Xavier         ³ Data ³ 25.02.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava um registro no arquivo de trabalho para impressao     ³±±
±±³          ³do Razonete.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³GravaTrab( ExpC1, ExpD1, ExpD2)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaTrab( cTipo,dEmissao,dVencto,nValor,aDados,aDadosAbat,lPrincipal)
Local cHist,cDCR,cDCP,cVarDC,cAlias:=Alias()
Local nX   := {}
Local nY   := {}
Local nPos := 0               
                                                                          
//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
				 
DEFAULT aDadosAbat := {}
DEFAULT lPrincipal := .F.

If aDados[3] >= mv_par01 .or. mv_par15 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica prefixo caso a movimenta‡„o n„o seja interpretada   ³
	//³ para calculo do saldo anterior ou quando solicitado.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Substr(aDados[4],1,3) < mv_par08 .Or. Substr(aDados[4],1,3) > mv_par09
		Return NIL
	EndIf     
Endif

nValor := Iif( nValor=Nil,aDados[11],nValor )

Do Case
Case cTipo == "B"
	cHist := Iif(Empty(aDados[7]),OemToAnsi("Ref. a Baixa do Titulo"),SE5->E5_HISTOR)  
	cDCR="C"
	cDCP="D"
Case cTipo == "D"
	cHist := OemToAnsi("Desconto sobre o titulo")
	cDCR="C"
	cDCP="D"
Case cTipo == "M"
	cHist := OemToAnsi("Multa/Juros s/ o Titulo")
	cDCR="D"
	cDCP="C"
OtherWise
	cHist := OemToAnsi("Corr.Monetaria s/ o Titulo")
	cDCR="D"
	cDCP="C"
EndCase
If nValor < 0
	cDCR="D"
	cDCP="C"
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava registro no arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reclock("cNomeArq",.t.)
Replace CODIGO  With aDados[1]	//CLIFOR
Replace LOJA    With aDados[2]	//LOJA
Replace DATAEM  With aDados[3]	//DTDIGIT
Replace NUMERO  With aDados[4]	//PREFIXO+NUMERO+PARCELA
Replace BANCO   With aDados[5]	//BANCO
Replace BAIXA   With aDados[6]	//DATA
Replace VALOR   With nValor
Replace HISTOR  With aDados[7]	//HISTOR	
Replace EMISSAO With dEmissao
Replace VENCTO  With dVencto

If cPaisLoc == "BRA"
	If aDados[8] == "R"				// SE5->E5_RECPAG
		cVarDC := Iif((!(aDados[9] $ MVRECANT+"/"+MV_CRNEG) .or.;      //TIPO
				aDados[10]=="ES" ) .and. (!(aDados[9] $ MVPAGANT+"/"+MV_CPNEG .and. SE5->E5_MOTBX = "CMP" .and. aDados[10]=="ES")) ;  //Estorno de compensacao do adiantamento
				.and. aDados[11] >= 0 ,cDCR,cDCP)      //TIPODOC  VALOR
		Replace DC With cVarDC
	Else               
		cVarDC := Iif((!( aDados[9] $ MVPAGANT+"/"+MV_CPNEG) .or. ;
				aDados[10]=="ES" ) .and. (!( aDados[9] $ MVRECANT+"/"+MV_CRNEG .and. SE5->E5_MOTBX = "CMP" .and. aDados[10]=="ES")) ;   //Estorno de compensacao do adiantamento
				.and. aDados[11] >= 0 ,cDCP,cDCR) 	
		Replace DC With cVarDC
	EndIf
	MsUnlock()
Else  //If cPaisLoc == "ARG" // Microsiga Argentina 20/03/99 JLUCAS
	If aDados[8] == "R"
		Replace DC With Iif( !(aDados[9] $ "RA /"+MV_CRNEG),cDCR,cDCP)
		Replace BAIXA   With SE1->E1_EMIS1
	Else
		Replace DC With Iif( !(aDados[9] $"PA /"+MV_CPNEG),cDCP,cDCR)
		Replace BAIXA   With aDados[6]     //SE5->E5_DATA
	EndIf
	MsUnlock()
EndIf                  
           
// Em situacoes que houver compensacao, e que em
// um dos titulos possuir decrescimo ou acrescimo,
// incluo linha no razonete para representar esse valor.
If (SE5->E5_MOTBX == "CMP")
	If SE5->E5_VLDESCO > 0
		Reclock("cNomeArq",.t.)
		Replace CODIGO  With aDados[1]
		Replace LOJA    With aDados[2]
		Replace DATAEM  With aDados[3]
		Replace NUMERO  With aDados[4]
		Replace BANCO   With aDados[5]
		Replace EMISSAO With dEmissao
		Replace VENCTO  With dVencto
		Replace VALOR   With SE5->E5_VLDESCO
		Replace BAIXA   With aDados[6]
		Replace HISTOR  With OemToAnsi("Desconto sobre o titulo")
		Replace DC      With cVarDC
		MsUnlock()
	ElseIf SE5->E5_VLJUROS > 0
		Reclock("cNomeArq",.t.)
		Replace CODIGO  With aDados[1]
		Replace LOJA    With aDados[2]
		Replace DATAEM  With aDados[3]
		Replace NUMERO  With aDados[4]
		Replace BANCO   With aDados[5]
		Replace EMISSAO With dEmissao
		Replace VENCTO  With dVencto
		Replace VALOR   With SE5->E5_VLJUROS
		Replace BAIXA   With aDados[6]
		Replace HISTOR  With OemToAnsi("Multa/Juros s/ o Titulo")
		Replace DC      With If(cVarDC == "C","D","C")
		MsUnlock()
	Endif   

	//Verificar se eh a baixa principal do titulo
	If mv_par03 == 1 .And. lPrincipal .and. !(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVRECANT+"/"+MV_CRNEG) .And. SE5->E5_TIPODOC == "CP"
		//Verificar se o valor da baixa eh igual ao valor do titulo.
		IF STR(SE5->E5_VALOR,17,2) == STR(SE1->E1_VALOR,17,2)
			nPos := Ascan(aDadosAbat, { |x| x[1] + x[2] + x[4] == SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA })
			If nPos > 0                                         
				For nY:=nPos to Len(aDadosAbat) 
					If aDadosAbat[nY][1]+aDadosAbat[nY][2]+aDadosAbat[nY][4] == SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
						Reclock("cNomeArq",.t.)
						Replace CODIGO  With aDadosAbat[nY][1]
						Replace LOJA    With aDadosAbat[nY][2]
						Replace DATAEM  With aDadosAbat[nY][3]
						Replace NUMERO  With aDadosAbat[nY][4]
						Replace BANCO   With aDadosAbat[nY][5]
						Replace EMISSAO With aDadosAbat[nY][6]
						Replace VENCTO  With aDadosAbat[nY][7]
						Replace VALOR   With aDadosAbat[nY][8]
						Replace BAIXA   With aDadosAbat[nY][9]
						Replace HISTOR  With "Baixa por Compensaca"
						Replace DC      With "D"
						MsUnlock()                      
					Else
						Exit					
					Endif
				Next
			Endif
		Endif
	Endif
Endif
   
If lPCCBaixa
	//Gera movimentos de histórico em casos de retenção de pis, cofins e csll
	For nX := 1 To 3
		If Empty(aDados[11+nX]) 
			If aDados[14+nX] > 0
				Reclock("cNomeArq",.t.)
				Replace CODIGO  With aDados[1]
				Replace LOJA    With aDados[2]
				Replace DATAEM  With aDados[3]
				Replace NUMERO  With aDados[4]
				Replace BANCO   With aDados[5]
				Replace EMISSAO With dEmissao
				Replace VENCTO  With dVencto
				Replace VALOR   With aDados[14+nX]
				Replace BAIXA   With aDados[6]
				Replace HISTOR  With "Desc.Imposto" + " - " + If(nX=1,"Pis",If(nX=2,"Cofins","Csll")) 
				Replace DC      With IIf(aDados[8]=="R","C","D") //Verifico se o titulo eh a pagar ou a receber
				MsUnlock()
			Endif
		Endif
	Next
Endif

dbSelectArea(cAlias)
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ TrabDados³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 22.03.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta array com dados do titulo para grava‡Æo do TRB  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ TrabDados()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TrabDados()
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
Local aDados := Array(If(lPccBaixa,17,11))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava registro no array de trabalho 							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDados[1] := E5_CLIFOR
aDados[2] := E5_LOJA
aDados[3] := E5_DTDIGIT
aDados[4] := E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA
aDados[5] := E5_BANCO
aDados[6] := E5_DATA
aDados[7] := E5_HISTOR
aDados[8] := E5_RECPAG
aDados[9] := E5_TIPO
aDados[10]:= E5_TIPODOC
aDados[11]:= E5_VALOR

//
If lPccBaixa
	aDados[12]:= E5_PRETPIS
	aDados[13]:= E5_PRETCOF
	aDados[14]:= E5_PRETCSL
	
	aDados[15]:= E5_VRETPIS
	aDados[16]:= E5_VRETCOF
	aDados[17]:= E5_VRETCSL
Endif	
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  necess rio for‡ar o historico quando for TOP, nÆo AS/400, e NÆo  ³
//³imprimir valores financeiros (mv_par10 = 2) pois os dados guardados ³
//³no array, caso o titulo sofreu desconto (por ex.), ‚ o do registro  ³
//³do desconto no SE5, o que causaria informa‡Æo de hist¢rico errado   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	If TcSrvType() != "AS/400" .and. mv_par06 == 2 .and. ;
		 (Empty(aDados[7]) .or. !(adados[10] $ "VL/BA/CP/PA/RA/ES"))
		aDados[7] := OemToAnsi("Baixa de Titulo")
	Endif
#ENDIF
If cPaisLoc != "BRA"
	If SE5->E5_TIPO $ MVDUPLIC+"/"+MVNOTAFIS+"/"+MVFATURA
		aDados[7] := Iif(SE5->E5_RECPAG=="R",OemToAnsi("Recibo"),OemToAnsi("O.Pago")) + SE5->E5_ORDREC    
	Else
		aDados[7] := SE5->E5_TIPO+"-"+Trans(SE5->E5_NUMERO,"@R 9999-99999999")
	Endif
Endif

Return aDados
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ SdoContab³ Autor ³ Claudio D. de Souza   ³ Data ³ 25.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcular o saldo contabil CTB ou SIGACON              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SdoContabil(cConta,dData,cMoeda,cTpSald) 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SdoContabil(cConta,dData,cMoeda,cTpSald)
Local aRet := {0,0,0,0,0,0,0,0}
Local aSavArea := GetArea()

DEFAULT cMoeda  := "01"
DEFAULT cTpSald := "1"

If Val(cMoeda) == 0
	cMoeda := "01"
EndIf

If CtbInUse()
	aRet := SaldoCt7(cConta,dData,cMoeda,cTpSald)
Else
	aRet[1] := Saldo(cConta,Month(dData),Val(cMoeda),Year(dData))
Endif	
RestArea(aSavArea)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                             ³
//³ [1] Saldo Atual (com sinal)                          ³
//³ [2] Debito na Data                                   ³
//³ [3] Credito na Data                                  ³
//³ [4] Saldo Atual Devedor                              ³
//³ [5] Saldo Atual Credor                               ³
//³ [6] Saldo Anterior (com sinal)                       ³
//³ [7] Saldo Anterior Devedor                           ³
//³ [8] Saldo Anterior Credor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return aRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ AjustaSx5³ Autor ³Mauricio Pequim Jr     ³ Data ³23/11/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta tabela 05 do SX5 para incluir o tipo R$	          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³         													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx5()

Local aArea := GetArea()

dbSelectArea("SX5")
If !(dbSeek(xFilial("SX5")+"05"+"R$ "))
	RecLock("SX5",.T.)
	X5_FILIAL 	:=	xFilial("SX5")
	X5_TABELA	:=	"05"
	X5_CHAVE		:=	"R$ "
	X5_DESCRI	:=	"DINHEIRO"
	X5_DESCSPA	:=	"DINERO"
	X5_DESCENG	:=	"CASH"
	MsUnlock()
Endif
RestArea(aArea)

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidSE5 ³ Autor ³ ********************* ³ Data ³ 25.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validar o conteudo do SE5 nao tratados pela Query     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ValidSE5() - Retorno .F. / .T.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico FINR550					  					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidSE5()

Local lRet := .T.

If	Empty(SE5->E5_NUMERO) .Or. SE5->E5_SITUACA = "C"
	Return .F.
EndIf

IF	SE5->E5_DTDIGIT > mv_par02
	Return .F.
Endif
	
IF	SE5->E5_CLIFOR < mv_par04 .Or. SE5->E5_CLIFOR > mv_par05
	Return .F.
EndIF

If	!SE5->E5_TIPODOC $ "VLüBAüCPüV2üLJüESüVMüDC/D2/MT/JR/J2/M2/CM/C2/CX"
	Return .F.
EndIf

If	SE5->E5_TIPO $ MVRECANT .and. SE5->E5_TIPODOC == "ES" .and. SE5->E5_RECPAG == "P" .and. mv_par03 == 1 
	Return .F.
EndIf

If	SE5->E5_TIPO $ MVPAGANT .and. SE5->E5_TIPODOC == "ES" .and. SE5->E5_RECPAG == "R" .and. mv_par03 == 2
	Return .F.
EndIf

If	( SE5->E5_NATUREZ < mv_par12 .Or. SE5->E5_NATUREZ > mv_par13 )
	Return .F.
EndIf
  
If	mv_par03 == 1 .and. SE5->E5_RECPAG == "R" .and. SE5->E5_TIPODOC =="ES" .and. !(SE5->E5_TIPO $ MVRECANT)
	Return .F.
Elseif	mv_par03 == 2 .and. SE5->E5_RECPAG == "P" .and. SE5->E5_TIPODOC =="ES" .and. !(SE5->E5_TIPO $ MVPAGANT)
	Return .F.
Endif
  
If	!Inside(SE5->E5_TIPO)
	Return .F.
Endif

Return lRet

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j
Local aPergs	:= {}
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
Aadd( aHelpPor, 'Selecione "Sim" para que sejam         ')
Aadd( aHelpPor, 'considerados no relatorio, os clientes/')
Aadd( aHelpPor, 'fornecedores que possuem saldo anterior')
Aadd( aHelpPor, 'mas nao possuem movimentacao financeira') 
Aadd( aHelpPor, 'no periodo informado, ou "Nao" em caso ')  
Aadd( aHelpPor, 'contrario.  ')
                                                             
Aadd( aHelpSpa, 'Seleccione "Si" para considerar en el  ')
Aadd( aHelpSpa, 'informe a los clientes/provedores que  ')
Aadd( aHelpSpa, 'tienen saldo anterior pero no tienen   ')
Aadd( aHelpSpa, 'movimientos financieros en el periodo  ') 
Aadd( aHelpSpa, 'informado, o "No" en caso contrario.   ')  

Aadd( aHelpEng, 'Select "Yes" to include in the report  ')
Aadd( aHelpEng, 'the customers/suppliers with previous  ')
Aadd( aHelpEng, 'balance but without financial movement ')
Aadd( aHelpEng, 'in the period entered, otherwise select')
Aadd( aHelpEng, '"No". ')                                                                 


dbSelectArea("SX1")                          	
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","A partir de ?"             ,"+De Fecha ?"               ,"From Date ?"                  ,"mv_ch1","D",8,0,0 ,"G","","mv_data_de","","","","'  /  /  '","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"02","Ate a Data ?"              ,"+A  Fecha ?"               ,"To Date ?"                    ,"mv_ch2","D",8,0,0 ,"G","","mv_data_ate","","","","'04/11/05'","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"03","Da Carteira ?"             ,"+De Cartera ?"             ,"From Porftolio ?"             ,"mv_ch3","N",1,0,2 ,"C","","","Receber","Cobrar","Receive","","","Pagar","Pagar","Pay","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"04","Do Codigo ?"               ,"+De Codigo ?"              ,"From Code ?"                  ,"mv_ch4","C",6,0,0 ,"G","","mv_cod_de","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"05","Ate o Codigo ?"            ,"+A  Codigo ?"              ,"To Code ?"                    ,"mv_ch5","C",6,0,0 ,"G","","mv_cod_ate","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"06","Impr.Vlr.Financeiro ?"     ,"+Imprime Vlr.Finan. ?"     ,"Financial Amount ?"           ,"mv_ch6","N",1,0,1 ,"C","","","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"07","Imprime ?"                 ,"+Imprime ?"                ,"Print ?"                      ,"mv_ch7","N",1,0,1 ,"C","","","Todos","Todos","All","","","Normais","Normales","Normal","","","Adiantamentos","Anticipo","Advances","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"08","Do Prefixo ?"              ,"+De Prefijo ?"             ,"From Prefix ?"                ,"mv_ch8","C",3,0,0 ,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"09","Ate o Prefixo ?"           ,"+A  Prefijo ?"             ,"To Prefix ?"                  ,"mv_ch9","C",3,0,0 ,"G","","mv_par09","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"10","Lista por: ?"              ,"+Listar por ?"             ,"List by: ?"                   ,"mv_cha","N",1,0,1 ,"C","","mv_par10","Filial","Sucursal","Branch","","","Empresa","Empresa","Company","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"11","Seleciona Tipos ?"         ,"+Selecciona Tipos ?"       ,"Select Types ?"               ,"mv_chb","N",1,0,2 ,"C","","mv_par11","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"12","Natureza de ?"             ,"+De Modalidad ?"           ,"From Nature ?"                ,"mv_chc","C",10,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"13","Natureza ate ?"            ,"+A  Modalidad ?"           ,"To Nature ?"                  ,"mv_chd","C",10,0,0,"G","","mv_par13","","","","ZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"14","Imprime Relatorio ?"       ,"+Imprimir Informe ?"       ,"Print Report ?"               ,"mv_che","N",1,0,0 ,"C","","mv_par14","Analitico","Analitico","Detailed","","","Sintetico","Sintetico","Summarized","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"15","Filt.Pref.p/Sal.Ant ?"     ,"+Fil.Pref.p/Pag.Ant ?"     ,"Filt.Pref.Prev.Bal. ?"        ,"mv_chf","N",1,0,0 ,"C","","mv_par15","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"16","Folha De ?"                ,"+De Pagina ?"              ,"From Page ?"                  ,"mv_chg","N",3,0,0 ,"G","","mv_par16","","","","  0","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"17","Folha Ate ?"               ,"+A  Pagina ?"              ,"To Page ?"                    ,"mv_chh","N",3,0,0 ,"G","","mv_par17","","","","999","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"18","Filtra Contas Contab ?"    ,"+Filtra Cuentas Contab ?"  ,"Filter Ledger Accounts ?"     ,"mv_chi","N",1,0,0 ,"C","","mv_par18","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"19","Conta Inicial ?"           ,"+De Cuenta ?"              ,"Initial Account ?"            ,"mv_chj","C",20,0,1,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"20","Conta Final ?"             ,"+A  Cuenta ?"              ,"Final Account ?"              ,"mv_chl","C",20,0,1,"G","","mv_par20","","","","ZZZZZZZ","","","","","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"21","Impr.Saldo Contabil ?"     ,"+Impr.Saldo Contable ?"    ,"Print Account. Balance ?"     ,"mv_chm","N",1,0,2 ,"C","","mv_par21","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"22","Impr. Cli/Forn s/ Movim.?" ,"Impr. Cli/Forn s/ Movim.?" ,"Print cust/supplier w/o mov?" ,"mv_chn","N",1,0,1 ,"C","","mv_par22","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","",""})
aAdd(aRegs,{cPerg,"23","Impr. Itens c/Dif.?"       ,"Impr. Itens c/Dif."        ,"Impr. Itens c/Dif.?"          ,"mv_cho","N",1,0,1 ,"C","","mv_par23","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","",""})
  
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

Return