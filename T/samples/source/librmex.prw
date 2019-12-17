#INCLUDE "PROTHEUS.CH"
#INCLUDE "LIBRMEX.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³LIBRMEX   ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 26.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Livro de Apuracao de IVA                                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Mexico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function LibrMex()

Local oReport
Local cPerg		:= "LIBMEX"

If FindFunction("TRepInUse") .And. TRepInUse()
	AjustaSX1()
	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	U_LibrMexR3()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³10.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                   ³±±
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
Local oTotaliz
Local oTotal
Local cReport	:= "LIBRMEX"
Local cPerg		:= "LIBMEX"
Local cTitulo	:= OemToAnsi(STR0001)	//"Livro de Apuração IVA"
Local cDesc		:= OemToAnsi(STR0002)	//"Este programa tem como objetivo imprimir os Livros Fiscais de IVA Compras e Vendas."

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
oSecao1:=TRSection():New(oReport,OemToAnsi(STR0025),{"SM0"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oSecao1,"M0_NOMECOM","SM0",OemToAnsi(STR0003),/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"M0_CGC","SM0",OemToAnsi(STR0004),/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)

oSecao2:=TRSection():New(oReport,OemToAnsi(STR0026),{"SF3","SA2"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSecao2:SetTotalInLine(.F.)
oSecao2:SetTotalText(Upper(OemToAnsi(STR0024)))
TRCell():New(oSecao2,"F3_NFISCAL","SF3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"ESPECIE","","","@!",2,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_ENTRADA","SF3",OemToAnsi(STR0005),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"A1_NOME","SA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"A1_CGC","SA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TOTAL","",OemToAnsi(STR0006),PesqPict("SF3","F3_VALCONT"),TamSx3("F3_VALCONT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"GRAVADA","",OemToAnsi(STR0007),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"ISENTA","",OemToAnsi(STR0008),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"IVA","",OemToAnsi(STR0009),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"RETENC","",OemToAnsi(STR0010),PesqPict("SF3","F3_VALIMP1"),TamSx3("F3_VALIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oSecao2:Cell("TOTAL"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSecao2:Cell("GRAVADA"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSecao2:Cell("ISENTA"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSecao2:Cell("IVA"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSecao2:Cell("RETENC"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)

oSecao3:=TRSection():New(oReport,OemToAnsi(STR0016),/*{Tabelas da secao}*/,/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSecao3:SetPageBreak()
oSecao3:SetTotalInLine(.F.)
oSecao3:SetTotalText(Upper(OemToAnsi(STR0024)))
TRCell():New(oSecao3,"IMPOSTO","",OemToAnsi(STR0016),PesqPict("SFB","FB_DESCR"),TamSx3("FB_DESCR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao3,"VALOR","",OemToAnsi(STR0020),PesqPict("SF3","F3_BASIMP1"),TamSx3("F3_BASIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oSecao3:Cell("VALOR"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)

oSecao4:=TRSection():New(oReport,OemToAnsi(STR0024),/*{Tabelas da secao}*/,/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oSecao4:SetTotalInLine(.F.)
oSecao4:SetTotalText(Upper(OemToAnsi(STR0024)))
TRCell():New(oSecao4,"IMPOSTO","",OemToAnsi(STR0016),PesqPict("SFB","FB_DESCR"),TamSx3("FB_DESCR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao4,"VENDA","",OemToAnsi(STR0017),PesqPict("SF3","F3_BASIMP1"),TamSx3("F3_BASIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao4,"COMPRA","",OemToAnsi(STR0018),PesqPict("SF3","F3_BASIMP1"),TamSx3("F3_BASIMP1")[1],/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oSecao4:Cell("VENDA"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSecao4:Cell("COMPRA"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)

//-- Totalizador
oTotaliz := TRFunction():New(oSecao4:Cell("VENDA"),"VENDA_T","SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
oTotaliz := TRFunction():New(oSecao4:Cell("COMPRA"),"COMPRA_T","SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)

//-- Secao Totalizadora
oTotal := TRSection():New(oReport,Alltrim(OemToAnsi(STR0028)),{},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/) 
oTotal:SetHeaderSection()
TRCell():New(oTotal,"TEXTO1","","",/*cPicture*/,27,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTotal,"SALDO","","","@E 999,999,999,999.99",18,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTotal,"TEXTO2","","",/*cPicture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)

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
Local cCabec	:= ""
Local cNomeCom	:= ""
Local cCGC		:= ""
Local cNFiscal	:= ""
Local cEspecie	:= ""
Local dEntrada	:= Ctod("")
Local cNome		:= ""
Local nTotal	:= 0
Local nGravada	:= 0
Local nIsenta	:= 0
Local nIVA		:= 0
Local nRetenc	:= 0
Local nLastRec	:= 0
Local cImposto	:= ""
Local nVenda	:= 0
Local nCompra	:= 0
Local nG		:= 0
Local nGG		:= 0
Local aTES		:= {}
Local aImpSaida	:= {}
Local aImpEntr	:= {}
Local nPos		:= 0
Local aResumo	:= {}
Local nPrinc	:= 0
Local nSecun	:= 0
Local cImp2		:= ""
Local nValor	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 1 - Empresa                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):Cell("M0_NOMECOM"):SetBlock({|| cNomeCom})
oReport:Section(1):Cell("M0_CGC"):SetBlock({|| cCGC})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 2                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(2):Cell("F3_NFISCAL"):SetBlock({|| cNFiscal})
oReport:Section(2):Cell("ESPECIE"):SetBlock({|| cEspecie})
oReport:Section(2):Cell("F3_ENTRADA"):SetBlock({|| dEntrada})
oReport:Section(2):Cell("A1_NOME"):SetBlock({|| cNome})
oReport:Section(2):Cell("A1_CGC"):SetBlock({|| cCGC})
oReport:Section(2):Cell("TOTAL"):SetBlock({|| nTotal})
oReport:Section(2):Cell("GRAVADA"):SetBlock({|| nGravada})
oReport:Section(2):Cell("ISENTA"):SetBlock({|| nIsenta})
oReport:Section(2):Cell("IVA"):SetBlock({|| nIVA})
oReport:Section(2):Cell("RETENC"):SetBlock({|| nRetenc})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 3                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(3):Cell("IMPOSTO"):SetBlock({|| cImp2})
oReport:Section(3):Cell("VALOR"):SetBlock({|| nValor})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Secao 4 - Resumo                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(4):Cell("IMPOSTO"):SetBlock({|| cImposto})
oReport:Section(4):Cell("VENDA"):SetBlock({|| nVenda})
oReport:Section(4):Cell("COMPRA"):SetBlock({|| nCompra})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Altera o titulo para impressao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par03 == 1	//Vendas
		cCabec := OemToAnsi(STR0011)+OemToAnsi(STR0014)+DtoC(mv_par01)+OemToAnsi(STR0015)+DtoC(mv_par02)
	Case mv_par03 == 2	//Compras
		cCabec := OemToAnsi(STR0012)+OemToAnsi(STR0014)+DtoC(mv_par01)+OemToAnsi(STR0015)+DtoC(mv_par02)	
	Otherwise
		cCabec := OemToAnsi(STR0013)+OemToAnsi(STR0014)+DtoC(mv_par01)+OemToAnsi(STR0015)+DtoC(mv_par02)		
EndCase

oReport:SetTitle(cCabec)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posicionamento das Tabelas                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA1->(dbsetorder(1))
SA2->(dbsetorder(1))

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

	cCondicao	:= "%"
	If mv_par03 == 1
		cCondicao += "F3_TIPOMOV = 'V' "
	ElseIf mv_par03 == 2		
		cCondicao += "F3_TIPOMOV = 'C' "	
	Else
		cCondicao += "F3_TIPOMOV <> ' ' "	
	Endif
	If mv_par04 == 2	//Nao considera canceladas
		cCondicao += "AND F3_DTCANC = ' '"
	Endif	
	cCondicao	+= "%"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(2):BeginQuery()	
	
	cAliasSF3 := GetNextAlias()

	BeginSql Alias cAliasSF3
		SELECT SF3.*
		FROM %table:SF3% SF3
		WHERE F3_FILIAL = %xFilial:SF3%		AND 
			F3_ENTRADA	>=	%Exp:mv_par01%	AND 
			F3_ENTRADA	<=	%Exp:mv_par02%	AND 
			%Exp:cCondicao%					AND
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
	
	If mv_par03 == 1
		cCondicao += "F3_TIPOMOV == 'V' .And. "
	ElseIf mv_par03 == 2		
		cCondicao += "F3_TIPOMOV == 'C' .And. "	
	Endif
	If mv_par04 == 2	//Nao considera canceladas
		cCondicao += "Empty(F3_DTCANC) .And. "
	Endif	
	
	cCondicao += "Dtos(F3_ENTRADA) >= '"+Dtos(mv_par01)+"' .And. "
	cCondicao += "Dtos(F3_ENTRADA) <= '"+Dtos(mv_par02)+"'"

	oReport:Section(2):SetFilter(cCondicao,IndexKey())
	
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomeCom	:= SM0->M0_NOMECOM
cCGC		:= SM0->M0_CGC
oReport:SetMeter(1)
oReport:Section(1):Init()
oReport:Section(1):PrintLine() 	
oReport:Section(1):Finish()	

dbSelectArea((cAliasSF3))
dbGoTop()
nLastRec := (cAliasSF3)->(LastRec())
oReport:SetMeter(nLastRec)

If mv_par03 < 3
	oReport:Section(2):Init()
Endif

While !Eof()
	
	oReport:IncMeter()
	
	cNF		:= (cAliasSF3)->F3_NFISCAL
	cCLie	:= (cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
	dEnt	:= (cAliasSF3)->F3_ENTRADA
	nTot	:= (nBas:=(nRet:=(nImp:=(nIse:=0))))
	cEsp	:= Left(Upper(Trim((cAliasSF3)->F3_ESPECIE)),2)
	cTipMov	:= (cAliasSF3)->F3_TIPOMOV         
            
	If (lCancelada:=(!Empty((cAliasSF3)->F3_DTCANC)))
		dbSkip()
	Else   
		While (cAliasSF3)->F3_ENTRADA==dEnt .And. ((cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA)==cClie .And. (cAliasSF3)->F3_NFISCAL==cNF
            nTot += (cAliasSF3)->F3_VALCONT
                      
            If (cAliasSF3)->F3_BASIMP1 == 0
            	nIse += (cAliasSF3)->F3_VALCONT
         	Else
            	nBas += (cAliasSF3)->F3_BASIMP1
             	nImp += (cAliasSF3)->F3_VALIMP1
        		nRet += (cAliasSF3)->F3_VALIMP2
         	Endif                       
            
            PosImpIVA(@aTES, (cAliasSF3)->F3_TES)  // Posiciona o SFB respectivo 
            
         	If (cAliasSF3)->F3_TIPOMOV == "C"
            	If (nPos:=Ascan(aImpEntr,{|x| x[1]==SFB->FB_CODIGO})) > 0
                	If (nPosAliq:=Ascan(aImpEntr[nPos,2],{|x| (x[2]==(cAliasSF3)->F3_ALQIMP1)})) == 0
                    	AADD(aImpEntr[nPos,2],{(cAliasSF3)->F3_BASIMP1,(cAliasSF3)->F3_ALQIMP1,(cAliasSF3)->F3_VALIMP1,(cAliasSF3)->F3_VALIMP2})     
                   	Else
             			If cEsp == "NC"  
                        	aImpEntr[nPos,2,nPosAliq,1] -= (cAliasSF3)->F3_BASIMP1
                        	aImpEntr[nPos,2,nPosAliq,3] -= (cAliasSF3)->F3_VALIMP1
                      		aImpEntr[nPos,2,nPosAliq,4] -= (cAliasSF3)->F3_VALIMP2
                     	Else
                        	aImpEntr[nPos,2,nPosAliq,1] += (cAliasSF3)->F3_BASIMP1
                        	aImpEntr[nPos,2,nPosAliq,3] += (cAliasSF3)->F3_VALIMP1
                       		aImpEntr[nPos,2,nPosAliq,4] += (cAliasSF3)->F3_VALIMP2
                     	Endif    
                 	Endif 
            	Else
                 	AADD(aImpEntr,{SFB->FB_CODIGO,{{(cAliasSF3)->F3_BASIMP1,(cAliasSF3)->F3_ALQIMP1,(cAliasSF3)->F3_VALIMP1,(cAliasSF3)->F3_VALIMP2}}}) 
    			Endif
   			Else
            	If (nPos:=Ascan(aImpSaida,{|x| x[1]==SFB->FB_CODIGO})) > 0
                	If (nPosAliq:=Ascan(aImpSaida[nPos,2],{|x| (x[2]==(cAliasSF3)->F3_ALQIMP1)})) == 0
                    	AADD(aImpSaida[nPos,2],{(cAliasSF3)->F3_BASIMP1,(cAliasSF3)->F3_ALQIMP1,(cAliasSF3)->F3_VALIMP1,(cAliasSF3)->F3_VALIMP2})
                  	Else
                    	If cEsp == "NC"  
                     		aImpSaida[nPos,2,nPosAliq,1] -= (cAliasSF3)->F3_BASIMP1
                      		aImpSaida[nPos,2,nPosAliq,3] -= (cAliasSF3)->F3_VALIMP1
                     		aImpSaida[nPos,2,nPosAliq,4] -= (cAliasSF3)->F3_VALIMP2
                  		Else
                        	aImpSaida[nPos,2,nPosAliq,1] += (cAliasSF3)->F3_BASIMP1
                         	aImpSaida[nPos,2,nPosAliq,3] += (cAliasSF3)->F3_VALIMP1
                       		aImpSaida[nPos,2,nPosAliq,4] += (cAliasSF3)->F3_VALIMP2
                    	Endif    
                	Endif 
             	Else
                	If cEsp == "NC"
                   		AADD(aImpSaida,{SFB->FB_CODIGO,{{-(cAliasSF3)->F3_BASIMP1,-(cAliasSF3)->F3_ALQIMP1,-(cAliasSF3)->F3_VALIMP1,-(cAliasSF3)->F3_VALIMP2}}})     
                	Else   
                    	AADD(aImpSaida,{SFB->FB_CODIGO,{{(cAliasSF3)->F3_BASIMP1,(cAliasSF3)->F3_ALQIMP1,(cAliasSF3)->F3_VALIMP1,(cAliasSF3)->F3_VALIMP2}}})     
                 	Endif    
            	Endif           
      		Endif   
            dbSkip()
		Enddo    
	Endif
            
	If mv_par03 < 3
       	If mv_par03 == 1
           	SA1->(dbSeek(xFilial("SA1")+cCLie))
       	Else   
           	SA2->(dbSeek(xFilial("SA2")+cCLie))
       	Endif
                  
   		cNFiscal	:= cNF
       	cEspecie	:= IIf(cEsp=="NC","CR",IIf(cEsp=="ND","DB","FA"))
      	dEntrada	:= dEnt
      	cNome		:= IIf(mv_par03==1,SA1->A1_NOME,SA2->A2_NOME)    

		If lCancelada
			nTotal		:= nTot
	   		nGravada	:= nBas
			nIsenta		:= nIse
	   		nIVA		:= nImp
	   		nRetenc		:= nRet		
			cCGC 		:= "CANCELADA"
		Else
			cCGC := IIf(mv_par03==1,SA1->A1_CGC,SA2->A2_CGC)
           	If cEsp == "NC"
          		nTotal		:= (nTot *-1)
   				nGravada	:= (nBas *-1)
				nIsenta		:= (nIse *-1)
   				nIVA		:= (nImp *-1)
   				nRetenc		:= (nRet *-1)
   			Else
          		nTotal		:= nTot
   				nGravada	:= nBas
				nIsenta		:= nIse
   				nIVA		:= nImp
   				nRetenc		:= nRet   			
           	Endif   
       	Endif
		oReport:Section(2):PrintLine() 	
   	Endif        
Enddo 
If mv_par03 < 3
	oReport:Section(2):Finish()	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Resumo                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par03 == 3

	oReport:Section(4):Init()

    For nG:=1 To Len(aImpSaida)
    	aadd(aResumo,{aImpSaida[nG][1],{}})
        For nGG:=1 to len(aImpSaida[nG][2])
        	aadd(aResumo[len(aResumo)][2],{aImpSaida[nG][2][nGG][2],aImpSaida[nG][2][nGG][1],aImpSaida[nG][2][nGG][3],0,0})
        next    
	next
    for nG:=1 to len(aImpEntr)
    	if (nPos:=ascan(aResumo,{|x| x[1]==aImpEntr[nG][1]}))==0
        	aadd(aResumo,{aImpEntr[nG][1],{}})
            nPos:=len(aResumo)
        endif
        for nGG:=1 to len(aImpEntr[nG][2])
        	if (nPosAliq:=ascan(aResumo[nPos,2],{|x| (x[1]==aImpEntr[nG][2][nGG][2])}))==0
            	aadd(aResumo[nPos][2],{aImpEntr[nG][2][nGG][2],0,0,aImpEntr[nG][2][nGG][1],aImpEntr[nG][2][nGG][3]})
            else
            	aResumo[nPos][2][nPosAliq][4]+=aImpEntr[nG][2][nGG][1]
            	aResumo[nPos][2][nPosAliq][5]+=aImpEntr[nG][2][nGG][3]
          	endif    
       	next    
 	next
    for nG:=1 to len(aResumo)
    	SFB->(dbseek(xfilial("SFB")+aResumo[nG][1]))
    	
    	oReport:SetTitle(OemToAnsi(STR0019))
    	
        for nGG:=1 to len(aResumo[nG][2])
        	if (aResumo[nG][2][nGG][2]+aResumo[nG][2][nGG][4])<>0 
        		cImposto	:= Trim(SFB->FB_DESCR)+" ("+str(aResumo[nG][2][nGG][1],6,2)+"% )"
				nVenda		:= aResumo[nG][2][nGG][3]
              	nCompra		:= aResumo[nG][2][nGG][5]

				oReport:Section(4):PrintLine()
           	endif    
    	next
	next   
	oReport:Section(4):Finish()	 	
	
	//-- Impressao dos totalizadores
	oReport:SkipLine()	
	oReport:Section(5):Init()
	oReport:Section(5):Cell("TEXTO1"):SetValue(OemToAnsi(STR0021))
	oReport:Section(5):Cell("SALDO"):SetValue(oReport:Section(4):GetFunction("COMPRA_T"):ReportValue()-oReport:Section(4):GetFunction("VENDA_T"):ReportValue())
	oReport:Section(5):Cell("TEXTO2"):SetValue(OemToAnsi(STR0022))
	oReport:Section(5):PrintLine()
	oReport:Section(5):Finish()	 		
	
Else

	oReport:Section(3):Init()
	
	If mv_par03 == 1	//Vendas
	   	oReport:SetTitle(OemToAnsi(STR0011)+OemToAnsi(STR0023))	
	Else
	   	oReport:SetTitle(OemToAnsi(STR0012)+OemToAnsi(STR0023))	
	Endif
	
	nPrinc:=if(mv_par03==1,len(aImpSaida),len(aImpEntr))
    for nG:=1 to nPrinc
    	SFB->(dbseek(xfilial("SFB")+if(mv_par03==1,aImpSaida[nG][1],aImpEntr[nG][1])))
        nSecun:=len(if(mv_par03==1,aImpSaida[nG][2],aImpEntr[nG][2]))
        for nGG:=1 to nSecun
           	if mv_par03==1
           		if aImpSaida[nG][2][nGG][1]<>0
              		cImp2	:= Trim(SFB->FB_DESCR)+" ("+str(aImpSaida[nG][2][nGG][2],6,2)+"% )"
                	nValor	:= aImpSaida[nG][2][nGG][3]
                endif   
          	elseif mv_par03==2   
            	if aImpEntr[nG][2][nGG][1]<>0
                	cImp2	:= Trim(SFB->FB_DESCR)+" ("+str(aImpEntr[nG][2][nGG][2],6,2)+"% )"
                 	nValor	:= aImpEntr[nG][2][nGG][3]
              	endif   
         	endif       
			oReport:Section(3):PrintLine()         	
   		next
	next   
	oReport:Section(3):Finish()	

Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ FUNCAO   ³LIBRMEXR3 ³ AUTOR ³ Marcello Gabriel      ³ DATA ³ 04.05.00   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ DESCRICAO³ Livro de apuracao de IVA  (Mexico)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ USO      ³ Generico - Localizacoes                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LIBRMEXR3()
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Fecha desde                          ¦
//¦ mv_par02             // Fecha hasta                          ¦
//¦ mv_par03             // Ventas o compras                     ¦
//+--------------------------------------------------------------+
SA1->(dbsetorder(1))
SA2->(dbsetorder(1))
dbselectarea("SF3")
dbsetorder(1)
aReturn:={ OemToAnsi("Especial"), 1,OemToAnsi("Administracion"), 1, 2, 1,"",1 }
nomeprog:="LIBRMEX"
cPerg:="LIBMEX"
cPrn:="LIBMEX"    

aTES := {}

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+
AjustaSX1()

Pergunte(cPerg,.F.)
//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
cPrn:=SetPrint("SF3",cPrn,cPerg,"Libro I.V.A","","","",.F.,"",.T.,"M")
If nLastKey!=27
   nLin:=(nPg:=0)
   SetDefault(aReturn,"SF3")
   RptStatus({|lCanc| Impressao(@lCanc)})
Endif
return

Static Procedure cabec_iva(tipo)
nPg++
@001,000 psay trim(SM0->M0_NOMECOM)
@001,pcol()+2 psay "R.F.C. "+transf(SM0->M0_CGC,pesqpict("SA1","A1_CGC"))
if tipo==3
   @002,059 psay "Resumen I.V.A."
else
    @002,058 psay "Libro de "+if(mv_par03==1,"Ventas","Compras")+" (I.V.A.)"
    if tipo>0
       @002,pcol()+1 psay " - Resumen"
    endif   
endif    
@003,000 psay date()
@003,124 psay "Pag "+strzero(nPg,4)
@004,000 psay replicate("-",132)
if tipo==0
   @005,000 psay "Factura"
   @005,011 psay "Emission"
   @005,021 psay if(mv_par03==1,"Cliente","Proveedor")
   @005,043 psay "R.F.C."
   @005,059 psay "Total Factura"
   @005,079 psay "Gravadas"
   @005,095 psay "Exentas"
   @005,111 psay "I.V.A."
   @005,123 psay "Retencion"
elseif tipo==3
       @005,000 psay "Impuesto"
       @005,054 psay "Venta"
       @005,072 psay "Compra"
else
    @005,000 psay "Impuesto"
    @005,054 psay "Valor"
endif
@006,000 psay replicate("=",132)
nLin:=7
return

Static Procedure Impressao(lCanc)
local aImpEntr:={},aImpSaida:={},aResumo
local nTotTot:=0,nTotBas:=0,nTotImp:=0,nTotRet:=0,nTotIse:=0,;
      nTot:=0,nBas:=0,nImp:=0,nRet:=0,nIse:=0,nG,nGG,nPrinc,nSecun,;
      nPosAliq,nPos
local cEsp:="",cCond,cNF,cClie,cTipMov
local dEnt
local lCancelada

SFC->(dbsetorder(2))
dbselectarea("SF3")
dbgotop()
cCond:="!eof() .and. SF3->F3_FILIAL=='"+xfilial("SF3")+"'"
if !empty(mv_par01) 
   cCond+=" .and. SF3->F3_ENTRADA>=mv_par01"
   dbseek(xfilial("SF3")+dtos(mv_par01),.t.)
endif
if !empty(mv_par02) 
   cCond+=" .and. SF3->F3_ENTRADA<=mv_par02"
endif
SetRegua(RecCount())
while &(cCond) 
      if mv_par03<3
         cabec_iva(0)
      endif   
      while nLin<60 .and. &(cCond) 
            cConc:=if(lCanc,".F.",cCond)
            cNF:=F3_NFISCAL
            cCLie:=F3_CLIEFOR+F3_LOJA
            dEnt:=F3_ENTRADA
            nTot:=(nBas:=(nRet:=(nImp:=(nIse:=0))))
            cEsp:=left(upper(trim(F3_ESPECIE)),2)
            cTipMov:=F3_TIPOMOV         
            if (lCancelada:=(!empty(SF3->F3_DTCANC)))
               dbskip()
               incregua()
            else   
                while &(cCond) .and. F3_ENTRADA==dEnt .and. (F3_CLIEFOR+F3_LOJA)==cClie .and. F3_NFISCAL==cNF
                      cConc:=if(lCanc,".F.",cCond)
                      nTot+=F3_VALCONT
                      if F3_BASIMP1==0
                         nIse+=F3_VALCONT
                      else
                          nBas+=F3_BASIMP1
                          nImp+=F3_VALIMP1
                          nRet+=F3_VALIMP2
                      endif                       
                      PosImpIVA( @aTES, SF3->F3_TES)  // Posiciona o SFB respectivo 
                      if SF3->F3_TIPOMOV=="C"
                         if (nPos:=ascan(aImpEntr,{|x| x[1]==SFB->FB_CODIGO}))>0
                            if (nPosAliq:=ascan(aImpEntr[nPos,2],{|x| (x[2]==SF3->F3_ALQIMP1)}))==0
                               aadd(aImpEntr[nPos,2],{SF3->F3_BASIMP1,SF3->F3_ALQIMP1,SF3->F3_VALIMP1,SF3->F3_VALIMP2})     
                            else
                                if cEsp=="NC"  
                                   aImpEntr[nPos,2,nPosAliq,1]-=SF3->F3_BASIMP1
                                   aImpEntr[nPos,2,nPosAliq,3]-=SF3->F3_VALIMP1
                                   aImpEntr[nPos,2,nPosAliq,4]-=SF3->F3_VALIMP2
                                else
                                    aImpEntr[nPos,2,nPosAliq,1]+=SF3->F3_BASIMP1
                                    aImpEntr[nPos,2,nPosAliq,3]+=SF3->F3_VALIMP1
                                    aImpEntr[nPos,2,nPosAliq,4]+=SF3->F3_VALIMP2
                                 endif    
                            endif 
                         else
                             aadd(aImpEntr,{SFB->FB_CODIGO,{{SF3->F3_BASIMP1,SF3->F3_ALQIMP1,SF3->F3_VALIMP1,SF3->F3_VALIMP2}}})     
                         endif
                      else
                          if (nPos:=ascan(aImpSaida,{|x| x[1]==SFB->FB_CODIGO}))>0
                             if (nPosAliq:=ascan(aImpSaida[nPos,2],{|x| (x[2]==SF3->F3_ALQIMP1)}))==0
                                aadd(aImpSaida[nPos,2],{SF3->F3_BASIMP1,SF3->F3_ALQIMP1,SF3->F3_VALIMP1,SF3->F3_VALIMP2})     
                             else
                                 if cEsp=="NC"  
                                    aImpSaida[nPos,2,nPosAliq,1]-=SF3->F3_BASIMP1
                                    aImpSaida[nPos,2,nPosAliq,3]-=SF3->F3_VALIMP1
                                    aImpSaida[nPos,2,nPosAliq,4]-=SF3->F3_VALIMP2
                                 else
                                     aImpSaida[nPos,2,nPosAliq,1]+=SF3->F3_BASIMP1
                                     aImpSaida[nPos,2,nPosAliq,3]+=SF3->F3_VALIMP1
                                     aImpSaida[nPos,2,nPosAliq,4]+=SF3->F3_VALIMP2
                                 endif    
                             endif 
                          else
                              if cEsp=="NC"
                                 aadd(aImpSaida,{SFB->FB_CODIGO,{{-SF3->F3_BASIMP1,-SF3->F3_ALQIMP1,-SF3->F3_VALIMP1,-SF3->F3_VALIMP2}}})     
                              else   
                                  aadd(aImpSaida,{SFB->FB_CODIGO,{{SF3->F3_BASIMP1,SF3->F3_ALQIMP1,SF3->F3_VALIMP1,SF3->F3_VALIMP2}}})     
                              endif    
                          endif           
                      endif   
                      dbskip()
                      incregua()
                enddo    
            endif
            if !lCanc
               if if(mv_par03==3,.f.,cTipMov==if(mv_par03==1,"V","C"))
                  if mv_par03==1
                     SA1->(dbseek(xfilial("SA1")+cCLie))
                  else   
                      SA2->(dbseek(xfilial("SA2")+cCLie))
                  endif
                  @nLin,000 psay cNF picture pesqpict("SF3","F3_NFISCAL")
                  @nLin,007 psay if(cEsp=="NC","CR",if(cEsp=="ND","DB","FA"))
                  @nLin,010 psay dEnt
                  @nLin,021 psay if(mv_par03==1,left(SA1->A1_NOME,21),left(SA2->A2_NOME,21))    
                  @nLin,043 psay if(mv_par03==1,transf(SA1->A1_CGC,pesqpict("SA1","A1_CGC")),transf(SA2->A2_CGC,pesqpict("SA2","A2_CGC")))
                  if lCancelada
                     @nLin++,59 psay "C A N C E L A D A"
                  else   
                     if cEsp=="NC"
                        nTot=-nTot
                        nBas=-nBas
                        nImp=-nImp
                        nIse=-nIse
                        nRet=-nRet
                     endif   
                     @nLin,058 psay nTot picture pesqpict("SF3","F3_VALCONT",14,1)
                     @nLIn,073 psay nBas picture pesqpict("SF3","F3_BASIMP1",14,1)
                     @nLin,088 psay nIse picture pesqpict("SF3","F3_BASIMP1",14,1)  
                     @nLin,103 psay nImp picture pesqpict("SF3","F3_VALIMP1",14,1)
                     @nLin++,118 psay nRet picture pesqpict("SF3","F3_VALIMP2",14,1)
                     nTotTot+=nTot
                     nTotBas+=nBas
                     nTotImp+=nImp
                     nTotIse+=nIse
                     nTotRet+=nRet
                  endif
               endif        
            endif
      enddo
enddo
if lCanc
   @++nLin,000 psay "<<<<<< Cancelado por el operador. >>>>>>"
else   
    if (nTotTot+nTotBAS+nTotImp+nTotRet)<>0
       @++nLin,038 psay "TOTAL"
       @nLin,058 psay nTotTot picture pesqpict("SF3","F3_VALCONT",14,1)
       @nLin,073 psay nTotBas picture pesqpict("SF3","F3_BASIMP1",14,1)
       @nLin,088 psay nTotIse picture pesqpict("SF3","F3_BASIMP1",14,1)
       @nLin,103 psay nTotImp picture pesqpict("SF3","F3_VALIMP1",14,1)
       @nLin,118 psay nTotRet picture pesqpict("SF3","F3_VALIMP2",14,1)   
    endif 
    //Impressao do resumo------------------------------------------
    nTotImp:=0
    nTotTot:=0
    nLin:=61
    aResumo:={}
    if mv_par03==3
       for nG:=1 to len(aImpSaida)
           aadd(aResumo,{aImpSaida[nG][1],{}})
           for nGG:=1 to len(aImpSaida[nG][2])
               aadd(aResumo[len(aResumo)][2],{aImpSaida[nG][2][nGG][2],aImpSaida[nG][2][nGG][1],aImpSaida[nG][2][nGG][3],0,0})
           next    
       next
       for nG:=1 to len(aImpEntr)
           if (nPos:=ascan(aResumo,{|x| x[1]==aImpEntr[nG][1]}))==0
              aadd(aResumo,{aImpEntr[nG][1],{}})
              nPos:=len(aResumo)
           endif
           for nGG:=1 to len(aImpEntr[nG][2])
               if (nPosAliq:=ascan(aResumo[nPos,2],{|x| (x[1]==aImpEntr[nG][2][nGG][2])}))==0
                  aadd(aResumo[nPos][2],{aImpEntr[nG][2][nGG][2],0,0,aImpEntr[nG][2][nGG][1],aImpEntr[nG][2][nGG][3]})
               else
                   aResumo[nPos][2][nPosAliq][4]+=aImpEntr[nG][2][nGG][1]
                   aResumo[nPos][2][nPosAliq][5]+=aImpEntr[nG][2][nGG][3]
               endif    
           next    
       next
       for nG:=1 to len(aResumo)
           SFB->(dbseek(xfilial("SFB")+aResumo[nG][1]))
           for nGG:=1 to len(aResumo[nG][2])
               if nLin>60 
                  cabec_iva(3)
               endif
               if (aResumo[nG][2][nGG][2]+aResumo[nG][2][nGG][4])<>0 
                  @nLin,000 psay trim(SFB->FB_DESCR)+" ("+str(aResumo[nG][2][nGG][1],6,2)+"%)"
                  @nLin,042 psay aResumo[nG][2][nGG][3] picture pesqpict("SF3","F3_BASIMP1",17,1)
                  @nLin++,061 psay aResumo[nG][2][nGG][5] picture pesqpict("SF3","F3_BASIMP1",17,1)
                  nTotImp+=aResumo[nG][2][nGG][3]
                  nTotTot+=aResumo[nG][2][nGG][5]
               endif    
           next
       next   
       if (nTotImp+nTotTot)<>0
          @++nLin,027 psay "TOTAL"
          @nLin,042 psay nTotImp picture pesqpict("SF3","F3_BASIMP1",17,1)
          @nLin,061 psay nTotTot picture pesqpict("SF3","F3_BASIMP1",17,1)
          nLin:=nLin+2
          @nLin,016 psay "(FAVOR O CONTRA)"
          @nLin,042 psay nTotTot-nTotImp picture pesqpict("SF3","F3_BASIMP1",17,1)
          @nLin,062 psay "(COMPRA - VENDA)"
       endif   
    else
        nPrinc:=if(mv_par03==1,len(aImpSaida),len(aImpEntr))
        for nG:=1 to nPrinc
            SFB->(dbseek(xfilial("SFB")+if(mv_par03==1,aImpSaida[nG][1],aImpEntr[nG][1])))
            nSecun:=len(if(mv_par03==1,aImpSaida[nG][2],aImpEntr[nG][2]))
            for nGG:=1 to nSecun
                if nLin>60 
                   cabec_iva(mv_par03)
                endif
                if mv_par03==1
                   if aImpSaida[nG][2][nGG][1]<>0
                      @nLin,000 psay trim(SFB->FB_DESCR)+" ("+str(aImpSaida[nG][2][nGG][2],6,2)+"%)"
                      @nLin++,042 psay aImpSaida[nG][2][nGG][3] picture pesqpict("SF3","F3_BASIMP1",17,1)
                      nTotImp+=aImpSaida[nG][2][nGG][3]
                   endif   
                elseif mv_par03==2   
                       if aImpEntr[nG][2][nGG][1]<>0
                          @nLin,000 psay trim(SFB->FB_DESCR)+" ("+str(aImpEntr[nG][2][nGG][2],6,2)+"%)"
                          @nLin++,042 psay aImpEntr[nG][2][nGG][3] picture pesqpict("SF3","F3_BASIMP1",17,1)
                          nTotImp+=aImpEntr[nG][2][nGG][3]
                       endif   
                endif       
            next
        next   
        if nTotImp<>0
           @++nLin,035 psay "TOTAL"
           @nLin,042 psay nTotImp picture pesqpict("SF3","F3_BASIMP1",17,1)
        endif   
    endif
endif    
Set Device To Screen
If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(cPrn)
Endif
MS_FLUSH()
return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor  ³ Sergio S. Fuzinaka º Data ³  26.05.06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ajusta o Grupo de Perguntas                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()

Local cPerg := "LIBMEX"

PutSx1(cPerg,"01","Da Data","Fecha Inicio","From Date","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
PutSX1(cPerg,"02","Ate Data","Fecha Fin","To Date","mv_ch2","D",8,0,0,    "G","","","","","mv_par02")
PutSx1(cPerg,"03","Do Livro","Libro de","From Fiscal Books","mv_ch3","N",1,0,0,"C","","","","","mv_par03","IVA Vendas","IVA Ventas","IVA Sales","","IVA Compras","IVA Compras","IVA Purchase","Resumen","Resumo","Summary")
PutSx1(cPerg,"04","Considera Anuladas","Considera Anuladas","Consider Deleted","mv_ch4","N",1,0,0,"C","","","","","mv_par04","Sim","Si","Yes","","Nao","No","No")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PosImpIVA ºAutor  ³Microsiga           º Data ³  07/24/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Posiciona no registro do SFB respectivo ao imposto1 - IVA  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PosImpIVA(aTES, cTES)
Local nPosTES := 0
nPosTES := aScan( aTES, {|x| x[1]==cTES} )
If nPosTES = 0
	SFC->(dbSeek(xFilial("SFC")+cTES))
	While !(SFC->(Eof())) .And. SFC->FC_TES==cTES
		SFB->(dbSeek(xfilial("SFB")+SFC->FC_IMPOSTO))
	 	If SFB->FB_CPOLVRO=="1"
			SFC->(dbGoBottom())
		EndIf
		SFC->(dbSkip())
	EndDo    
	Aadd( aTES, {cTES, SFB->(Recno()) } )
Else
	SFB->(dbGoTo(aTES[nPosTES][2]))
EndIf	
Return
