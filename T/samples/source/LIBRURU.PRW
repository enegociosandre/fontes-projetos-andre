#INCLUDE "PROTHEUS.CH"
#INCLUDE "LIBRURU.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³LIBRURU   ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 31.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Livro Diario de Vendas                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Uruguai                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function LibrUru()

Local oReport
Local cPerg		:= "LIBURU"

If FindFunction("TRepInUse") .And. TRepInUse()
	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	U_LibrUruR3()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 31.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatorio                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oSecao1
Local oSecao2
Local oSecao3
Local oSecao4
Local cReport	:= "LIBRURU"
Local cPerg		:= "LIBURU"
Local cTitulo	:= OemToAnsi(STR0091)	//"Emissão do Libro Diario de Vendas"
Local cDesc		:= OemToAnsi(STR0092)	//"Este programa tem como objetivo imprimir os Livros Fiscais de IVA Compras e Vendas."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New(cReport,cTitulo,cPerg,{|oReport| ReportPrint(oReport)},cDesc)
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)
Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSecao1:=TRSection():New(oReport,OemToAnsi(STR0110),{"SM0"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oSecao1,"M0_NOMECOM","SM0",OemToAnsi(STR0094),/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"M0_CGC","SM0",OemToAnsi(STR0102),/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)

oSecao2:=TRSection():New(oReport,OemToAnsi(STR0111),{"SF3","SF2","SA1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oSecao2,"F3_ENTRADA","SF3",OemToAnsi(STR0095),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"COMPROVANTE","",OemToAnsi(STR0096),/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"CLIENTE","",OemToAnsi(STR0101),/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"A1_NOME","SA1",OemToAnsi(STR0097),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F2_VALMERC","SF2",OemToAnsi(STR0098),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_VALIMP1","SF3",OemToAnsi(STR0099),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_VALIMP2","SF3",OemToAnsi(STR0100),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSecao3:=TRSection():New(oReport,OemToAnsi(STR0112),{},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oSecao3,"TITULO","","",/*Picture*/,60,/*lPixel*/,/*{|| code-block de impressao }*/)

oSecao4:=TRSection():New(oReport,OemToAnsi(STR0113),{},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oSecao4,"AGRUP","",OemToAnsi(STR0103),/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao4,"VLIQ" ,"",OemToAnsi(STR0104),"@E 999,999,999,999.99",18,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao4,"IVA14","",OemToAnsi(STR0099),"@E 999,999,999,999.99",18,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao4,"IVA23","",OemToAnsi(STR0100),"@E 999,999,999,999.99",18,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao4,"TOTAL","",OemToAnsi(STR0105),"@E 999,999,999,999.99",18,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao4,"VBRUT","",OemToAnsi(STR0106),"@E 999,999,999,999.99",18,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Sergio S. Fuzinaka     ³ Data ³04.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                            ³±±
±±³          ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local cCondicao	:= ""
Local cAliasSF3	:= "SF3"
Local cCabec	:= OemToAnsi(STR0093)+" - "+Upper(MesExtenso(Month(mv_par02)))+" / "+Str(Year(mv_par02),4)
Local cNomeCom	:= ""
Local cCGC		:= ""
Local cComp		:= ""
Local dEntrada	:= Ctod("")
Local cNome		:= ""
Local nSigno	:= 1
Local nValNeto	:= 0
Local cCliente	:= ""
Local nIVA14	:= 0
Local nIVA23	:= 0
Local cTitulo	:= ""
Local cAgrup	:= ""
Local nVLiq		:= 0
Local nTotal	:= 0
Local nVBrut	:= 0

Private aTotPesos	:=	{	{"Unica      ",0,0,0,0,0},; 
				  	   		{"Tasa Minima",0,0,0,0,0},;
				 	   		{"Exento     ",0,0,0,0,0},;
					   		{"TOTALES    ",0,0,0,0,0}}

Private aTotDolar	:=	{	{"Unica      ",0,0,0,0,0},;
					   		{"Tasa Minima",0,0,0,0,0},;
					   		{"Exento     ",0,0,0,0,0},;
					   		{"TOTALES    ",0,0,0,0,0}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 1 - Empresa                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):Cell("M0_NOMECOM"):SetBlock({|| cNomeCom})
oReport:Section(1):Cell("M0_CGC"):SetBlock({|| cCGC})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 2 - Detalhe                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(2):Cell("F3_ENTRADA"):SetBlock({|| dEntrada})
oReport:Section(2):Cell("COMPROVANTE"):SetBlock({|| cComp})
oReport:Section(2):Cell("CLIENTE"):SetBlock({|| cCliente})
oReport:Section(2):Cell("A1_NOME"):SetBlock({|| cNome})
oReport:Section(2):Cell("F2_VALMERC"):SetBlock({|| nValNeto})
oReport:Section(2):Cell("F3_VALIMP1"):SetBlock({|| nIVA14})
oReport:Section(2):Cell("F3_VALIMP2"):SetBlock({|| nIVA23})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 3 - SubTitulo                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(3):Cell("TITULO"):SetBlock({|| cTitulo})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 4 - Resumo                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(4):Cell("AGRUP"):SetBlock({|| cAgrup})
oReport:Section(4):Cell("VLIQ"):SetBlock({|| nVLiq})
oReport:Section(4):Cell("IVA14"):SetBlock({|| nIVA14})
oReport:Section(4):Cell("IVA23"):SetBlock({|| nIVA23})
oReport:Section(4):Cell("TOTAL"):SetBlock({|| nTotal})
oReport:Section(4):Cell("VBRUT"):SetBlock({|| nVBrut})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Altera o titulo para impressao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(cCabec)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatorio                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF3")
dbSetOrder(1)

#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(2):BeginQuery()	
	
	cAliasSF3 := GetNextAlias()

	BeginSql Alias cAliasSF3
		SELECT SF3.*
		FROM %table:SF3% SF3
		WHERE F3_FILIAL = %xFilial:SF3%		AND 
			F3_ENTRADA >= %Exp:mv_par01%	AND 
			F3_ENTRADA <= %Exp:mv_par02%	AND 
			F3_TIPOMOV  = 'V'				AND
			SF3.%NotDel% 
		ORDER BY %Order:SF3%
	EndSql 

	oReport:Section(2):EndQuery(/*Array com os parametros do tipo Range*/)
		
#ELSE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr(oReport:uParam)

	cCondicao := "F3_FILIAL == '"+xFilial("SF3")+"' .And. "
	cCondicao += "F3_TIPOMOV == 'V' .And. "
	cCondicao += "Dtos(F3_ENTRADA) >= '"+Dtos(mv_par01)+"' .And. "
	cCondicao += "Dtos(F3_ENTRADA) <= '"+Dtos(mv_par02)+"'"

	oReport:Section(2):SetFilter(cCondicao,IndexKey())
	
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomeCom	:= SM0->M0_NOMECOM
cCGC		:= SM0->M0_CGC
If mv_par03 < 3
	oReport:SetMeter(1)
	oReport:Section(1):Init()
	oReport:Section(1):PrintLine() 	
	oReport:Section(1):Finish()	
Endif

dbSelectArea((cAliasSF3))
dbGoTop()
nLastRec := (cAliasSF3)->(LastRec())
oReport:SetMeter(nLastRec)
If mv_par03 < 3
	oReport:Section(2):Init()
Endif

While !Eof()
	
	oReport:IncMeter()
	oReport:Section(2):Cell("F3_ENTRADA"):Show()
	
	dEntrada := (cAliasSF3)->F3_ENTRADA
	
	While !Eof() .And. (cAliasSF3)->F3_ENTRADA == dEntrada
		SF2->( dbSetOrder(1) )
		SF2->( dbSeek(xFilial("SF2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA) )	

		SA1->( dbSetOrder(1) )
		SA1->( dbSeek( xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA) )

		If (cAliasSF3)->F3_ESPECIE $ "NCC"
			nSigno	:=-1
		Else
			nSigno	:= 1
		EndIf	

		If mv_par03 == 1 .Or. mv_par03 == 2
			If SF2->F2_MOEDA > 1
				nValNeto := xMoeda(SF2->F2_VALMERC,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,,SF2->F2_TXMOEDA)
			Else
				nValNeto := SF2->F2_VALMERC
			EndIf
								
			cComp		:= IIf((cAliasSF3)->F3_ESPECIE=="NCC","NCC",IIf((cAliasSF3)->F3_TIPO=="D","NDC","FAC"))
			cComp		+= " "+Subs(AllTrim((cAliasSF3)->F3_SERIE),1,1)
			cComp		+= " "+(cAliasSF3)->F3_NFISCAL
			cCliente	:= (cAliasSF3)->F3_CLIEFOR+"-"+(cAliasSF3)->F3_LOJA
			cNome		:= SA1->A1_NOME
			nIVA14		:= ((cAliasSF3)->F3_VALIMP1 * nSigno)
			nIVA23		:= ((cAliasSF3)->F3_VALIMP2 * nSigno)
		EndIf
	
		If SF2->F2_MOEDA == 1
			If (cAliasSF3)->F3_VALIMP2 > 0
				aTotPesos[1][2] += SF2->F2_VALMERC
				aTotPesos[1][4] += ((cAliasSF3)->F3_VALIMP2 * nSigno)
			EndIf
			If (cAliasSF3)->F3_VALIMP1 > 0
				aTotPesos[2][2] += SF2->F2_VALMERC
				aTotPesos[2][3] += ((cAliasSF3)->F3_VALIMP1 * nSigno)
			EndIf
			If (cAliasSF3)->F3_EXENTAS > 0
				aTotPesos[3][2] += SF2->F2_VALMERC
			EndIf
		ElseIf SF2->F2_MOEDA == 2
			nValNeto := xMoeda(SF2->F2_VALMERC,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,,SF2->F2_TXMOEDA)
	
			If (cAliasSF3)->F3_VALIMP2 > 0
				aTotDolar[1][2] += (nValNeto * nSigno)
				aTotDolar[1][4] += ((cAliasSF3)->F3_VALIMP2 * nSigno)
			EndIf	            	
			If (cAliasSF3)->F3_VALIMP1 > 0
				aTotDolar[2][2] += (nValNeto * nSigno)
				aTotDolar[2][3] += ((cAliasSF3)->F3_VALIMP1 * nSigno)
			EndIf	         	
			If (cAliasSF3)->F3_EXENTAS > 0
				aTotDolar[3][2] += (nValNeto * nSigno)        	
			Endif		
		EndIf    	

		aTotPesos[1][5] := aTotPesos[1][4]
		aTotPesos[1][6] := aTotPesos[1][2] + aTotPesos[1][4]	
		aTotPesos[2][5] := aTotPesos[2][3]
		aTotPesos[2][6] := aTotPesos[2][2] + aTotPesos[2][3]
		
		aTotDolar[1][5] := aTotDolar[1][4]
		aTotDolar[1][6] := aTotDolar[1][2] + aTotDolar[1][4]	
		aTotDolar[2][5] := aTotDolar[2][3]
		aTotDolar[2][6] := aTotDolar[2][2] + aTotDolar[2][3]
		
		If mv_par03 < 3
			oReport:Section(2):PrintLine()
        Endif
        
		dbSelectArea(cAliasSF3)
		dbSkip()	
		If (cAliasSF3)->F3_ENTRADA == dEntrada
			oReport:Section(2):Cell("F3_ENTRADA"):Hide()
		Endif
	Enddo
	If mv_par03 < 3
		oReport:SkipLine()
	Endif
Enddo
If mv_par03 < 3
	oReport:Section(2):Finish()	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do Resumo                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par03 <> 2
	oReport:Section(1):SetPageBreak(.T.)	
	oReport:SetMeter(1)
	oReport:Section(1):Init()
	oReport:Section(1):PrintLine() 	
	oReport:Section(1):Finish()	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quadro de Vendas em Moeda Nacional (em R$)                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter(1)
	oReport:Section(3):Init()
	oReport:Section(3):Cell("TITULO"):SetTitle(OemToAnsi(STR0107))		//"Quadro de Vendas em Moeda Nacional (em R$)"
	oReport:Section(3):PrintLine() 	
	oReport:Section(3):Finish()	
	
	oReport:SetMeter(4)
	oReport:Section(4):Init()

	cAgrup	:= aTotPesos [1][1]		//Unica
	nVLiq	:= aTotPesos [1][2]		//Vendas Liquidas
	nIVA14	:= aTotPesos [1][3]		//IVA 14
	nIVA23	:= aTotPesos [1][4]		//IVA 23
	nTotal	:= aTotPesos [1][5]		//TOTAL
	nVBrut	:= aTotPesos [1][6]		//Vendas Brutas
	oReport:Section(4):PrintLine() 	
		
	cAgrup	:= aTotPesos [2][1]		//Taxa Minima
	nVLiq	:= aTotPesos [2][2]
	nIVA14	:= aTotPesos [2][3]
	nIVA23	:= aTotPesos [2][4]
	nTotal	:= aTotPesos [2][5]
	nVBrut	:= aTotPesos [2][6]
	oReport:Section(4):PrintLine() 	
	
	cAgrup	:= aTotPesos [3][1]		//Exento
	nVLiq	:= aTotPesos [3][2]
	nIVA14	:= aTotPesos [3][3]
	nIVA23	:= aTotPesos [3][4]
	nTotal	:= aTotPesos [3][5]
	nVBrut	:= aTotPesos [3][6]
	oReport:Section(4):PrintLine() 	
	
	aTotPesos[4][2] := aTotPesos[1][2] + aTotPesos[2][2] + aTotPesos[3][2]
	aTotPesos[4][3] := aTotPesos[1][3] + aTotPesos[2][3] + aTotPesos[3][3]
	aTotPesos[4][4] := aTotPesos[1][4] + aTotPesos[2][4] + aTotPesos[3][4]
	aTotPesos[4][5] := aTotPesos[1][5] + aTotPesos[2][5] + aTotPesos[3][5]
	aTotPesos[4][6] := aTotPesos[1][6] + aTotPesos[2][6] + aTotPesos[3][6]

	cAgrup	:= aTotPesos [4][1]		//Totais
	nVLiq	:= aTotPesos [4][2]
	nIVA14	:= aTotPesos [4][3]
	nIVA23	:= aTotPesos [4][4]
	nTotal	:= aTotPesos [4][5]
	nVBrut	:= aTotPesos [4][6]
	oReport:Section(4):PrintLine() 	
	oReport:Section(4):Finish()	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quadro de Vendas em Moeda Estrangeira (em R$)             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter(1)
	oReport:Section(3):Init()
	oReport:Section(3):Cell("TITULO"):SetTitle(OemToAnsi(STR0108))		//"Quadro de Vendas em Moeda Estrangeira (em R$)"
	oReport:Section(3):PrintLine() 	
	oReport:Section(3):Finish()	
	
	oReport:SetMeter(4)
	oReport:Section(4):Init()

	cAgrup	:= aTotDolar [1][1]
	nVLiq	:= aTotDolar [1][2]
	nIVA14	:= aTotDolar [1][3]
	nIVA23	:= aTotDolar [1][4]
	nTotal	:= aTotDolar [1][5]
	nVBrut	:= aTotDolar [1][6]
	oReport:Section(4):PrintLine() 	
	
	cAgrup	:= aTotDolar [2][1]
	nVLiq	:= aTotDolar [2][2]
	nIVA14	:= aTotDolar [2][3]
	nIVA23	:= aTotDolar [2][4]
	nTotal	:= aTotDolar [2][5]
	nVBrut	:= aTotDolar [2][6]
	oReport:Section(4):PrintLine() 	
	
	cAgrup	:= aTotDolar [3][1]
	nVLiq	:= aTotDolar [3][2]
	nIVA14	:= aTotDolar [3][3]
	nIVA23	:= aTotDolar [3][4]
	nTotal	:= aTotDolar [3][5]
	nVBrut	:= aTotDolar [3][6]
	oReport:Section(4):PrintLine() 	
	
	aTotDolar[4][2] := aTotDolar[1][2] + aTotDolar[2][2] + aTotDolar[3][2]
	aTotDolar[4][3] := aTotDolar[1][3] + aTotDolar[2][3] + aTotDolar[3][3]
	aTotDolar[4][4] := aTotDolar[1][4] + aTotDolar[2][4] + aTotDolar[3][4]
	aTotDolar[4][5] := aTotDolar[1][5] + aTotDolar[2][5] + aTotDolar[3][5]
	aTotDolar[4][6] := aTotDolar[1][6] + aTotDolar[2][6] + aTotDolar[3][6]
	cAgrup	:= aTotDolar [4][1]
	nVLiq	:= aTotDolar [4][2]
	nIVA14	:= aTotDolar [4][3]
	nIVA23	:= aTotDolar [4][4]
	nTotal	:= aTotDolar [4][5]
	nVBrut	:= aTotDolar [4][6]
	oReport:Section(4):PrintLine() 	
	oReport:Section(4):Finish()	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quadro de Vendas Acumulado (em R$)                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter(1)
	oReport:Section(3):Init()
	oReport:Section(3):Cell("TITULO"):SetTitle(OemToAnsi(STR0109))		//"Quadro de Vendas Acumulado (em R$)"
	oReport:Section(3):PrintLine() 	
	oReport:Section(3):Finish()	
	
	oReport:SetMeter(4)
	oReport:Section(4):Init()

	cAgrup	:= aTotPesos [1][1]
	nVLiq	:= aTotPesos [1][2] + aTotDolar [1][2]
	nIVA14	:= aTotPesos [1][3] + aTotDolar [1][3]
	nIVA23	:= aTotPesos [1][4] + aTotDolar [1][4]
	nTotal	:= aTotPesos [1][5] + aTotDolar [1][5]
	nVBrut	:= aTotPesos [1][6] + aTotDolar [1][6]
	oReport:Section(4):PrintLine() 	
	
	cAgrup	:= aTotPesos [2][1]
	nVLiq	:= aTotPesos [2][2] + aTotDolar [2][2]
	nIVA14	:= aTotPesos [2][3] + aTotDolar [2][3]
	nIVA23	:= aTotPesos [2][4] + aTotDolar [2][4]
	nTotal	:= aTotPesos [2][5] + aTotDolar [2][5]
	nVBrut	:= aTotPesos [2][6] + aTotDolar [2][6]
	oReport:Section(4):PrintLine() 	
	
	cAgrup	:= aTotPesos [3][1]
	nVLiq	:= aTotPesos [3][2] + aTotDolar [3][2]
	nIVA14	:= aTotPesos [3][3] + aTotDolar [3][3]
	nIVA23	:= aTotPesos [3][4] + aTotDolar [3][4]
	nTotal	:= aTotPesos [3][5] + aTotDolar [3][5]
	nVBrut	:= aTotPesos [3][6] + aTotDolar [3][6]
	oReport:Section(4):PrintLine() 	

	cAgrup	:= aTotPesos [4][1]
	nVLiq	:= aTotPesos [4][2] + aTotDolar [4][2]
	nIVA14	:= aTotPesos [4][3] + aTotDolar [4][3]
	nIVA23	:= aTotPesos [4][4] + aTotDolar [4][4]
	nTotal	:= aTotPesos [4][5] + aTotDolar [4][5]
	nVBrut	:= aTotPesos [4][6] + aTotDolar [4][6]
	oReport:Section(4):PrintLine() 	
	oReport:Section(4):Finish()	

Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LIBRURUR3 ºAutor  ³ Jose Aurélio/Lucas º Data ³  08/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Diario de Ventas para Uruguay.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Livros Fiscais                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LibruruR3()
Local nQ:=0 

Private CBTXT,CBCONT,NORDEM,ALFA,Z,M
Private ASER,TAMANHO,LIMITE,TITULO,CDESC1,CDESC2
Private CDESC3,CNATUREZA,NOMEPROG,CPERG,NLASTKEY
Private LCONTINUA,WNREL,LFINREL,CPICTVALS,ATIPOS,ATOTALES
Private LTIPOS,CSTRING,LCONTRANUL
Private CCONTNF,NCANTSERIES,CCHAVE,CFILTRO,CARQTMP,NMAXLEN
Private NSER,NDIFER,NA,NTIPO,AMESES,CEMPRESA
Private CINSCR,CCUIT,CTITULO,_NMES,NCNT1,ND
Private NLINRODA1,NLINRODA2,NLINRODA3,NLINRODA4,NLINRODA5,NLINRODA1B
Private NLINRODA2B,NLINRODA3B,NLININI,ADRIVER,NOPC,CCOR,NLINLIN := 0
Private _SALIAS,AREGS,I,J
Private tpass
Private nX
Private nMoedaSF2
Private aCampos := {}
Private aStrutTRB := {}
Private nNeto  := 0
Private nValNeto := 0
Private nIVA14 := 0
Private nIVA23 := 0
Private aTotPesos := { {"Unica      ",0,0,0,0,0},; 
				  	   {"Tasa Minima",0,0,0,0,0},;
				 	   {"Exento     ",0,0,0,0,0},;
					   {"TOTALES    ",0,0,0,0,0}}

Private aTotDolar := { {"Unica      ",0,0,0,0,0},;
					   {"Tasa Minima",0,0,0,0,0},;
					   {"Exento     ",0,0,0,0,0},;
					   {"TOTALES    ",0,0,0,0,0}}
Private lCabec := .t.	

AjustaSX1("LIBURU")

CbTxt  := ""
CbCont := ""
nOrdem := 0
Alfa   := 0
Z:=0
M:=0
aSer   := {}
tamanho := "G"
limite  := 220
titulo   := PADC(OemtoAnsi(STR0001),74)//PADC("Emisi¢n del Subdiario de IVA",74) // Nota de Debito/Credito en formulario pre-impreso.",74)
cDesc1   := PADC(OemtoAnsi(STR0002),74)//PADC("Ser n solicitadas la fecha inicial y la fecha final para la emisión ",74)
cDesc2   := PADC(OemtoAnsi(STR0003),74)//PADC("de los libros de IVA Ventas e IVA Compras",74)
cDesc3   :=""
cNatureza:=""
aReturn  := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1,"",1 }
nomeprog :="LIBRURU"
cPerg    :="LIBURU"
nLastKey := 0
lContinua:= .T.
wnrel    := "LIBRURU"
lFinRel  := .F.

SX3->(DbSetOrder(2))
SX3->(DbSeek("A1_CGC"))
If  SX3->(Found() )
	cPicCgc := Alltrim(SX3->X3_PICTURE)
EndIf
aTipos   := {}
aTotales := {}
lTipos	 := SX5->(DBSEEK(xFilial("SX5")+"SF"))
If lTipos
	While !SX5->(EOF()).And.SX5->X5_TABELA=="SF"
		Aadd(aTipos,{SX5->X5_CHAVE,Alltrim(SX5->X5_DESCRI)})
		SX5->(DbSkip())
	Enddo	
	Aadd(aTipos,{"  ",OemToAnsi(STR0006)})	
	For nQ	:=	1 To len(aTipos)
		Aadd(aTotales,{0.00,0.00,0.00,0.00,0.00})
	Next
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
cString := "SF3"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif
VerImp()
RptStatus({|| RptDetail()})
Return

Static Function RptDetail()
Local nI:=0

lContrAnul := mv_par04 ==1
cContNF := GetMv("MV_CONTNF")
dbSelectArea("SF3")
Retindex("SF3")
cFiltro := "F3_FILIAL=='"+xFilial("SF3")+"'.AND.DTOS(F3_ENTRADA)>='"+DTOS(mv_par01)+"'.AND.DTOS(F3_ENTRADA)<='"+DTOS(mv_par02)+"'"
cFiltro := cFiltro + ".And.F3_TIPOMOV == 'V'"
cChave := "F3_FILIAL+DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL+F3_CFO"
cArqIndxF3 := CriaTrab(NIL,.F.)
IndRegua("SF3",cArqIndxF3,cChave,,cFiltro,OemToAnsi(STR0007))
nindex := RetIndex("SF3")
#IFNDEF TOP	
	dbSetIndex(cArqIndxF3+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
nNroDoc := 0  
nLin    := 60
nCpos   := 0
nPagina := 0
dbSelectArea("SX3")
dbGoTop()
dbSetOrder(2)
aCampos := {"F2_MOEDA","F3_ENTRADA","F3_ALQIMP1","F3_ALQIMP2","F3_SERIE","F3_BASIMP1","F3_VALIMP1","F3_BASIMP2","F3_VALIMP2","F2_VALMERC","F3_TIPO","F3_NFISCAL","F3_CLIEFOR","F3_LOJA","F3_TIPOMOV","F3_EXENTAS","F3_ESPECIE"}
For nI := 1 To Len(aCampos)
	If dbSeek(aCampos[nI])		
		nCpos++
		AADD(aStrutTRB,{x3_campo,x3_tipo,x3_tamanho,x3_decimal} )
	EndIf
Next nI

dbSelectArea("SF3")
dbSetOrder(1)
dbSeek(xFilial("SF3")+DTOS(mv_par01),.T.)

SetRegua(LastRec())

While !Eof() .and. F3_ENTRADA <= mv_par02

	IncRegua()	
	If Lastkey() == 286
		@ 00,01 PSAY OemToAnsi(STR0008)
		Exit
	EndIf	
	If lAbortPrint
		@ 00,01 PSAY OemToAnsi(STR0008)
		lContinua := .F.
		Exit
	Endif
	nLinLim := 55		
	If nLin > nLinLim
		R020Cab()
	EndIf

	If mv_par03 == 1 .or. mv_par03 == 2
		@ nLin,001 PSAY F3_ENTRADA 				Picture PesqPict("SF3","F3_ENTRADA")
		nLin := nLin + 1
    EndIf
    
	dDataDia := F3_ENTRADA
	
	While !Eof() .and. F3_ENTRADA == dDataDia
	
		SF2->( dbSetOrder(1) )
		SF2->( dbSeek(xFilial("SF2")+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA) )	

		SA1->( dbSetOrder(1) )
		SA1->( dbSeek( xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA) )

		If F3_ESPECIE $ "NCC"
			nSigno	:=-1
		Else
			nSigno	:= 1
		EndIf	

		If mv_par03 == 1 .or. mv_par03 == 2
		
			If SF2->F2_MOEDA > 1
				nValNeto := xMoeda(SF2->F2_VALMERC,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,,SF2->F2_TXMOEDA)
			Else
				nValNeto := SF2->F2_VALMERC
			EndIf
								
			@ nLin,002 PSAY IIf(F3_ESPECIE=="NCC","NCC",IIF(F3_TIPO=="D","NDC","FAC"))
			@ nLin,006 PSAY Subs(AllTrim(F3_SERIE),1,1)
			@ nLin,008 PSAY F3_NFISCAL				Picture PesqPict("SF3","F3_NFISCAL")
			@ nLin,022 PSAY F3_CLIEFOR+"-"+F3_LOJA
			@ nLin,032 PSAY Subs(SA1->A1_NOME,1,30)	Picture "@!"
			@ nLin,070 PSAY nValNeto				Picture PesqPict("SF2","F2_VALMERC",14,1)
			@ nLin,091 PSAY (F3_VALIMP1 * nSigno)	Picture PesqPict("SF3","F3_VALIMP1",14,1)
			@ nLin,106 PSAY (F3_VALIMP2 * nSigno)	Picture PesqPict("SF3","F3_VALIMP2",14,1)
			nLin := nLin + 1
		EndIf
	
		If SF2->F2_MOEDA == 1
			If F3_VALIMP2 > 0
				aTotPesos[1][2] += SF2->F2_VALMERC
				aTotPesos[1][4] += (F3_VALIMP2 * nSigno)
			EndIf
			If F3_VALIMP1 > 0
				aTotPesos[2][2] += SF2->F2_VALMERC
				aTotPesos[2][3] += (F3_VALIMP1 * nSigno)
			EndIf
			If F3_EXENTAS > 0
				aTotPesos[3][2] += SF2->F2_VALMERC
			EndIf
		ElseIf SF2->F2_MOEDA == 2

			nValNeto := xMoeda(SF2->F2_VALMERC,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,,SF2->F2_TXMOEDA)
		
			If F3_VALIMP2 > 0
				aTotDolar[1][2] += (nValNeto * nSigno)
				aTotDolar[1][4] += (F3_VALIMP2 * nSigno)
			EndIf	            	
			If F3_VALIMP1 > 0
				aTotDolar[2][2] += (nValNeto * nSigno)
				aTotDolar[2][3] += (F3_VALIMP1 * nSigno)
			EndIf	         	
			If F3_EXENTAS > 0
				aTotDolar[3][2] += (nValNeto * nSigno)        	
			Endif		
		EndIf    	
		aTotPesos[1][5] := aTotPesos[1][4]
		aTotPesos[1][6] := aTotPesos[1][2] + aTotPesos[1][4]	
		aTotPesos[2][5] := aTotPesos[2][3]
		aTotPesos[2][6] := aTotPesos[2][2] + aTotPesos[2][3]
		
		aTotDolar[1][5] := aTotDolar[1][4]
		aTotDolar[1][6] := aTotDolar[1][2] + aTotDolar[1][4]	
		aTotDolar[2][5] := aTotDolar[2][3]
		aTotDolar[2][6] := aTotDolar[2][2] + aTotDolar[2][3]

		nNeto  := nNeto  += (nValNeto * nSigno)
		nIVA14 := nIVA14 += (F3_VALIMP2  * nSigno)
		nIVA23 := nIVA23 += (F3_VALIMP2  * nSigno)

		DbSelectArea("SF3")
		DbSkip()	
	EndDo	
EndDo
Roda(0,"","")

lFinRel := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprimir o Resumo...										            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
R020Rdp()

Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
#IFNDEF TOP
	Ferase(cArqIndxF3+OrdBagExt())
#ENDIF
DbSelectArea("SF3")
dbCloseArea ()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunçào	 ³R020Cab   ºAutor  ³ Jose Aurelio/Lucas º Data ³  08/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cabecalho do Libro de IVA ( Compras e Ventas ).            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBR020                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020Cab
Static Function R020Cab()

aMeses := {}
AADD(aMeses,OemToAnsi(STR0030))//"ENERO    "
AADD(aMeses,OemToAnsi(STR0031))//"FEBRERO  "
AADD(aMeses,OemToAnsi(STR0032))//"MARZO    "
AADD(aMeses,OemToAnsi(STR0033))//"ABRIL    "
AADD(aMeses,OemToAnsi(STR0034))//"MAYO     "
AADD(aMeses,OemToAnsi(STR0035))//"JUNIO    "
AADD(aMeses,OemToAnsi(STR0036))//"JULIO    "
AADD(aMeses,OemToAnsi(STR0037))//"AGOSTO   "
AADD(aMeses,OemToAnsi(STR0038))//"SETIEMBRE"
AADD(aMeses,OemToAnsi(STR0039))//"OCTUBRE  "
AADD(aMeses,OemToAnsi(STR0040))//"NOVIEMBRE"
AADD(aMeses,OemToAnsi(STR0041))//"DICIEMBRE"
cEmpresa := SM0->M0_NOMECOM
cInscr   := InscrEst()
cCUIT    := TRANSFORM(SM0->M0_CGC,cPicCgc)
cTitulo  := OemtoAnsi(STR0042) //"L I B R O   D E   "
cTitulo := cTitulo + OemtoAnsi(STR0044)//"V E N T A S"
nPagina := nPagina + 1
@ 02,000 PSAY OemToAnsi(STR0045) //"Empresa: "
@ 02,020 PSAY cEmpresa
@ 02,122 PSAY OemToAnsi(STR0046)//"Pagina Nro.: "
@ 02,136 PSAY StrZero(nPagina,6)
@ 03,000 PSAY OemToAnsi(STR0048)//"CUIT: "
@ 03,007 PSAY cCUIT
@ 05,000 PSAY cTitulo
_nMes := Month(mv_par02)
If _nMes > 0 .And. _nMes < 13
	@ 05,080 PSAY OemToAnsi(STR0049)//"Mes "
	@ 05,085 PSAY aMeses[_nMes]
	@ 05,095 PSAY OemToAnsi(STR0050)//"Ano"
	@ 05,100 PSAY StrZero(Year(mv_par02),4)
EndIf
If lCabec
	@ 07,000 PSAY OemToAnsi(STR0051)
Endif
nLin := 09
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunçào	 ³R020Rod   ºAutor  ³ Jose Aurelio/Lucas º Data ³  08/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rodape do Libro de IVA ( Compras e Ventas ).     	      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBR020                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function R020Rod()
nLin := nLin + 1
@ nLin,000 PSAY OemToAnsi(STR0053) //"Totales :"
@ nLin,080 PSAY nNeto                  Picture PesqPict("SF2","F2_VALMERC",14,1)
@ nLin,096 PSAY nIVA14                 Picture PesqPict("SF3","F3_VALIMP1",14,1)
@ nLin,111 PSAY nIVA23                 Picture PesqPict("SF3","F3_VALIMP2",14,1)
nLin := nLin +1
lFinRel := .F.
Return*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunçào	 ³R020Rdp   ºAutor  ³ Jose Aurelio/Lucas º Data ³  08/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rodape do Libro de IVA ( Compras e Ventas ).               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBR020                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
7ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R020Rdp()
Local nD:=0

nCnt1 :=	1
lCabec := .f.
If F3_TIPO
	For nD:=1 to len(aTotales)
		If aTotales[nD][1]<>0.00.Or.aTotales[nD][2]<>0.00 .Or. aTotales[nD][3] <> 0.00
			If nCnt1==1
				@nLin + 1 , 002 PSAY OemToAnsi(STR0068) + IIf(mv_par03==1,OemToAnsi(STR0069),OemToAnsi(STR0070))
				nCnt1 := nCnt1 + 2
			Endif
			@nLin	+ nCnt1, 055 PSAY aTipos[nD][2]
			@nLin	+ nCnt1, 128 PSAY Trans(aTotales[nD][1],cPictVals)
			@nLin	+ nCnt1, 143 PSAY Trans(aTotales[nD][2],cPictVals)
			@nLin	+ nCnt1, 158 PSAY Trans(aTotales[nD][3],cPictVals)
			@nLin	+ nCnt1, 173 PSAY Trans(aTotales[nD][4],cPictVals)
			@nLin	+ nCnt1, 188 PSAY Trans(aTotales[nD][5],"@E) 999,999,999,999.99")
			nCnt1	:=	nCnt1 + 1
		Endif
	Next
Endif
nLin	:=	nLin + nCnt1 + 1
If mv_par03 <> 2
	If nLin > nLinLin
		R020Cab()
	EndIf
	@ nLin, 050 PSAY OemToAnsi(STR0079)
	nLin := nLin + 3
	@ nLin, 002 PSAY OemToAnsi(STR0088)
	nLin := nLin + 3
	@ nlin, 050 PSAY OemToAnsi(STR0077)
 	nLin := nLin + 1
	@ nLin, 002 PSAY OemToAnsi(STR0071)
	@ nLin, 022 PSAY OemToAnsi(STR0076)
	@ nLin, 042 PSAY OemToAnsi(STR0078)
	@ nLin, 062 PSAY OemToAnsi(STR0085)
	@ nLin, 082 PSAY OemToAnsi(STR0086)
	@ nLin, 102 PSAY OemToAnsi(STR0087)
	nLin := nLin + 1	
	@ nLin, 002 PSAY aTotPesos [1][1]
	@ nLin, 022 PSAY aTotPesos [1][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [1][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [1][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [1][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [1][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [2][1]
	@ nLin, 022 PSAY aTotPesos [2][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [2][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [2][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [2][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [2][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [3][1]
	@ nLin, 022 PSAY aTotPesos [3][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [3][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [3][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [3][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [3][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	aTotPesos[4][2] := aTotPesos[1][2] + aTotPesos[2][2] + aTotPesos[3][2]
	aTotPesos[4][3] := aTotPesos[1][3] + aTotPesos[2][3] + aTotPesos[3][3]
	aTotPesos[4][4] := aTotPesos[1][4] + aTotPesos[2][4] + aTotPesos[3][4]
	aTotPesos[4][5] := aTotPesos[1][5] + aTotPesos[2][5] + aTotPesos[3][5]
	aTotPesos[4][6] := aTotPesos[1][6] + aTotPesos[2][6] + aTotPesos[3][6]
	@ nLin, 002 PSAY aTotPesos [4][1]
	@ nLin, 022 PSAY aTotPesos [4][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [4][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [4][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [4][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [4][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 3
	@ nLin, 002 PSAY OemToAnsi(STR0089)
	nLin := nLin + 3
	@ nlin, 050 PSAY OemToAnsi(STR0077)
	nLin := nLin + 1
	@ nLin, 002 PSAY OemToAnsi(STR0071)
	@ nLin, 022 PSAY OemToAnsi(STR0076)
	@ nLin, 042 PSAY OemToAnsi(STR0078)
	@ nLin, 062 PSAY OemToAnsi(STR0085)
	@ nLin, 082 PSAY OemToAnsi(STR0086)
	@ nLin, 102 PSAY OemToAnsi(STR0087)
	nLin := nLin + 1	
	@ nLin, 002 PSAY aTotDolar [1][1]
	@ nLin, 022 PSAY aTotDolar [1][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotDolar [1][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotDolar [1][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotDolar [1][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotDolar [1][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotDolar [2][1]
	@ nLin, 022 PSAY aTotDolar [2][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotDolar [2][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotDolar [2][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotDolar [2][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotDolar [2][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotDolar [3][1]
	@ nLin, 022 PSAY aTotDolar [3][2] Picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotDolar [3][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotDolar [3][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotDolar [3][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotDolar [3][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	aTotDolar[4][2] := aTotDolar[1][2] + aTotDolar[2][2] + aTotDolar[3][2]
	aTotDolar[4][3] := aTotDolar[1][3] + aTotDolar[2][3] + aTotDolar[3][3]
	aTotDolar[4][4] := aTotDolar[1][4] + aTotDolar[2][4] + aTotDolar[3][4]
	aTotDolar[4][5] := aTotDolar[1][5] + aTotDolar[2][5] + aTotDolar[3][5]
	aTotDolar[4][6] := aTotDolar[1][6] + aTotDolar[2][6] + aTotDolar[3][6]
	@ nLin, 002 PSAY aTotDolar [4][1]
	@ nLin, 022 PSAY aTotDolar [4][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotDolar [4][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotDolar [4][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotDolar [4][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotDolar [4][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 3
	@ nLin, 002 PSAY OemToAnsi(STR0090)
	nLin := nLin + 3
	@ nlin, 050 PSAY OemToAnsi(STR0077)
	nLin := nLin + 1
	@ nLin, 002 PSAY OemToAnsi(STR0071)
	@ nLin, 022 PSAY OemToAnsi(STR0076)
	@ nLin, 042 PSAY OemToAnsi(STR0078)
	@ nLin, 062 PSAY OemToAnsi(STR0085)
	@ nLin, 082 PSAY OemToAnsi(STR0086)
	@ nLin, 102 PSAY OemToAnsi(STR0087)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [1][1]
	@ nLin, 022 PSAY aTotPesos [1][2] + aTotDolar [1][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [1][3] + aTotDolar [1][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [1][4] + aTotDolar [1][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [1][5] + aTotDolar [1][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [1][6] + aTotDolar [1][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [2][1]
	@ nLin, 022 PSAY aTotPesos [2][2] + aTotDolar [2][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [2][3] + aTotDolar [2][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [2][4] + aTotDolar [2][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [2][5] + aTotDolar [2][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [2][6] + aTotDolar [2][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [3][1]
	@ nLin, 022 PSAY aTotPesos [3][2] + aTotDolar [3][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [3][3] + aTotDolar [3][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [3][4] + aTotDolar [3][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [3][5] + aTotDolar [3][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [3][6] + aTotDolar [3][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	nLin := nLin + 1
	@ nLin, 002 PSAY aTotPesos [4][1]
	@ nLin, 022 PSAY aTotPesos [4][2] + aTotDolar [4][2] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 042 PSAY aTotPesos [4][3] + aTotDolar [4][3] picture PesqPict("SF3","F3_VALIMP1",14,1)
	@ nLin, 062 PSAY aTotPesos [4][4] + aTotDolar [4][4] picture PesqPict("SF3","F3_VALIMP2",14,1)
	@ nLin, 082 PSAY aTotPesos [4][5] + aTotDolar [4][5] picture PesqPict("SF2","F2_VALMERC",14,1)
	@ nLin, 102 PSAY aTotPesos [4][6] + aTotDolar [4][6] picture PesqPict("SF2","F2_VALMERC",14,1)
	Roda(0,"","")
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunçào    ³ VerImp   ºAutor  ³Marcos Simidu       º Data ³  20/12/95   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica posicionamento de papel na Impressora             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerImp()

nLin:= 0                
nLinIni:=0
aDriver:=ReadDriver()
If aReturn[5]==2	
	nOpc       := 1
	While .T.		
		SetPrc(0,0)
		dbCommitAll()				
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."		
		If MsgYesNo(OemtoAnsi(STR0080))//"¨Fomulario esta posicionado ? "
			nOpc := 1
		ElseIF MsgYesNo(OemToAnsi(STR0081))//"¨Tenta Nuevamente ? "
			nOpc := 2
		Else
			nOpc := 3
		Endif	
		Do Case
		Case nOpc==1
			lContinua:=.T.
			Exit
		Case nOpc==2
			Loop
		Case nOpc==3
			lContinua:=.F.
			Return
		EndCase
	End
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor  ³ Sergio S. Fuzinaka º Data ³  31.05.06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ajusta o Grupo de Perguntas                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg)

PutSx1(cPerg,"01","Data Inicio","Fecha Inicio","From Date","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
PutSX1(cPerg,"02","Data Fim","Fecha Fin","To Date","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
PutSx1(cPerg,"03","Imprimir","Imprimir","Print","mv_ch3","N",1,0,0,"C","","","","","mv_par03","Tudo","Todo","All","","Relatorio","Informe","Report","Resumo","Resumen","Resume")
PutSx1(cPerg,"04","Considera Anuladas","Considera Anuladas","Consider Cancelled","mv_ch4","N",1,0,0,"C","","","","","mv_par04","Sim","Si","Yes","","Nao","No","No")

Return
