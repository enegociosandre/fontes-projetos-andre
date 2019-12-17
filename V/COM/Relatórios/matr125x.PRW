#INCLUDE "matr125.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR125  ³ Autor ³ Eduardo Riera         ³ Data ³02.12.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do contrato de parceria                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/
User Function MATR125x()
Local oReport := NIL

If TRepInUse() 
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MTR125R3()
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ReportDef()
Definição das propriedades do relatório em TReport
@author Andre Anjos
@since 14/01/2014
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------
Static Function ReportDef()
Local oReport		:= NIL
Local oSection1	:= NIL
Local oSection2	:= NIL
Local oSection3	:= NIL
Local oSection4	:= NIL
Local oSection5	:= NIL
Local oSection6	:= NIL
Local oSection7	:= NIL
Local cField    	:= ''

Pergunte("xMTR125",.F.)

oReport := TReport():New("MATR125",STR0001,"MTR125",{|oReport| ReportPrin(oReport)},STR0002)

oSection1 := TRSection():New(oReport,STR0001,{"SC3"})
oSection1:lHeaderVisible := .T.
oSection1:SetLineStyle(.T.)
oSection1:nColSpace := 3

TRCell():New(oSection1,"C3_NUM","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C3_EMISSAO","SC3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2 := TRSection():New(oSection1,STR0025,{"SM0"})
oSection2:lHeaderVisible := .T.
oSection2:SetLineStyle(.T.)
oSection2:nColSpace := 3
oSection2:SetNoFilter("SM0")

TRCell():New(oSection2,"M0_NOMECOM","SM0",RetTitle("A2_NREDUZ"),PesqPict("SA2","A2_NREDUZ"),Len(SM0->M0_NOMECOM),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"M0_ENDENT","SM0",RetTitle("A2_END"),PesqPict("SA2","A2_END"),Len(SM0->M0_ENDENT),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"M0_CEPENT","SM0",RetTitle("A2_CEP"),PesqPict("SA2","A2_CEP"),Len(SM0->M0_CEPENT),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"M0_CIDENT","SM0",RetTitle("A2_MUN"),PesqPict("SA2","A2_MUN"),Len(SM0->M0_CIDENT),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"M0_ESTENT","SM0",RetTitle("A2_EST"),PesqPict("SA2","A2_EST"),Len(SM0->M0_ESTENT),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"M0_TEL","SM0",RetTitle("A2_TEL"),PesqPict("SA2","A2_TEL"),Len(SM0->M0_TEL),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"M0_FAX","SM0",RetTitle("A2_FAX"),PesqPict("SA2","A2_FAX"),Len(SM0->M0_FAX),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"M0_CGC","SM0",RetTitle("A2_CGC"),PesqPict("SA2","A2_CGC"),Len(SM0->M0_CGC),/*lPixel*/,/*{|| code-block de impressao }*/)

If !(cPaisLoc $ "ARG|POR|EUA") 
	TRCell():New(oSection2,"M0_INSC","SM0",RetTitle("A2_INSC"),PesqPict("SA2","A2_INSC"),Len(SM0->M0_INSC),/*lPixel*/,/*{|| code-block de impressao }*/)
EndIf

//-- Só adiciona SA2 no personalizável quando não compartilhado ou sem gestão de empresas
//-- Isto para habilitar o recurso de impressão em N filiais (botão Gestão de Empresas)
If FWModeAccess("SA2",1) == "E" .Or. (At("E",FWSM0Layout()) == 0 .And. At("U",FWSM0Layout()) == 0)
	oSection3 := TRSection():New(oSection1,STR0027,{"SA2"})
Else
	oSection3 := TRSection():New(oSection1,STR0027,{"SM0"})
	oSection3:SetNoFilter("SM0")
EndIf
oSection3:lHeaderVisible := .T.
oSection3:SetLineStyle(.T.)
oSection3:nColSpace := 3

TRCell():New(oSection3,"C3_FORNECE","SC3")
TRCell():New(oSection3,"C3_LOJA","SC3")
TRCell():New(oSection3,"A2_NOME","SA2")
TRCell():New(oSection3,"A2_END","SA2")
TRCell():New(oSection3,"A2_CEP","SA2")
TRCell():New(oSection3,"A2_MUN","SA2")
TRCell():New(oSection3,"A2_EST","SA2")
TRCell():New(oSection3,"A2_TEL","SA2")
TRCell():New(oSection3,"A2_FAX","SA2")
TRCell():New(oSection3,"A2_CGC","SA2")

If !(cPaisLoc $ "ARG|POR|EUA")
	TRCell():New(oSection3,"A2_INSCR","SA2")
EndIf

//-- Só adiciona SB1 no personalizável quando não compartilhado ou sem gestão de empresas
//-- Isto para habilitar o recurso de impressão em N filiais (botão Gestão de Empresas)
If FWModeAccess("SB1",1) == "E" .Or. (At("E",FWSM0Layout()) == 0 .And. At("U",FWSM0Layout()) == 0)
	oSection4 := TRSection():New(oSection1,STR0028,{"SC3","SB1"})
Else
	oSection4 := TRSection():New(oSection1,STR0028,{"SC3"})
EndIf
oSection4:lHeaderVisible := .T.

TRCell():New(oSection4,"C3_ITEM","SC3")
TRCell():New(oSection4,"C3_PRODUTO","SC3")

cField := Iif(Empty(mv_par03),'B1_DESC',Alltrim(mv_par03))

TRCell():New(oSection4,"DESCRI",,RetTitle(cField),PesqPict("S"+Left(cField,2),cField),TamSX3(cField)[1],/*lPixel*/,{|| &("S"+Left(cField,2)+"->"+cField)})

TRCell():New(oSection4,"B1_UM","SB1")
TRCell():New(oSection4,"C3_QUANT","SC3")
TRCell():New(oSection4,"C3_TOTAL","SC3")
TRCell():New(oSection4,"C3_OBS","SC3")
TRCell():New(oSection4,"C3_CC","SC3")

oSection5 := TRSection():New(oSection1,STR0029,{"SM0"})
oSection5:lHeaderVisible := .T.
oSection5:SetLineStyle(.T.)
oSection5:nColSpace := 3
oSection5:SetNoFilter("SM0")

TRCell():New(oSection5,"M0_ENDENT","SM0",RetTitle("A2_END"),PesqPict("SA2","A2_END"),Len(SM0->M0_ENDENT),,/*{|| code-block de impressao }*/)
TRCell():New(oSection5,"M0_CIDENT","SM0",RetTitle("A2_MUN"),PesqPict("SA2","A2_MUN"),Len(SM0->M0_CIDENT),,/*{|| code-block de impressao }*/)
TRCell():New(oSection5,"M0_ESTENT","SM0",RetTitle("A2_EST"),PesqPict("SA2","A2_EST"),Len(SM0->M0_ESTENT),,/*{|| code-block de impressao }*/)
TRCell():New(oSection5,"M0_CEPENT","SM0",RetTitle("A2_CEP"),PesqPict("SA2","A2_CEP"),Len(SM0->M0_CEPENT),,/*{|| code-block de impressao }*/)

oSection6 := TRSection():New(oSection1,STR0030,{"SM0"})
oSection6:lHeaderVisible := .T.
oSection6:SetLineStyle(.T.)
oSection6:nColSpace := 3
oSection6:SetNoFilter("SM0")

TRCell():New(oSection6,"M0_ENDCOB","SM0",RetTitle("A2_END"),PesqPict("SA2","A2_END"),Len(SM0->M0_ENDCOB),,/*{|| code-block de impressao }*/)
TRCell():New(oSection6,"M0_CIDCOB","SM0",RetTitle("A2_MUN"),PesqPict("SA2","A2_MUN"),Len(SM0->M0_CIDCOB),,/*{|| code-block de impressao }*/)
TRCell():New(oSection6,"M0_ESTCOB","SM0",RetTitle("A2_EST"),PesqPict("SA2","A2_EST"),Len(SM0->M0_ESTCOB),,/*{|| code-block de impressao }*/)
TRCell():New(oSection6,"M0_CEPCOB","SM0",RetTitle("A2_CEP"),PesqPict("SA2","A2_CEP"),Len(SM0->M0_CEPCOB),,/*{|| code-block de impressao }*/)

//-- Só adiciona SE4 no personalizável quando não compartilhado ou sem gestão de empresas
//-- Isto para habilitar o recurso de impressão em N filiais (botão Gestão de Empresas)
If FWModeAccess("SE4",1) == "E" .Or. (At("E",FWSM0Layout()) == 0 .And. At("U",FWSM0Layout()) == 0)
	oSection7 := TRSection():New(oSection1,STR0031,{"SC3,SE4"})
Else
	oSection7 := TRSection():New(oSection1,STR0031,{"SC3"})
EndIf
oSection7:lHeaderVisible := .T.
oSection7:SetLineStyle(.T.)
oSection7:nColSpace := 3

TRCell():New(oSection7,"TOTGER",,STR0032,"@E 9,999,999,999,999.99",16,,/*{|| code-block de impressao }*/)
TRCell():New(oSection7,"TOTMER",,STR0033,"@E 9,999,999,999,999.99",16,,/*{|| code-block de impressao }*/)
TRCell():New(oSection7,"TOTFRE",,STR0034,"@E 9,999,999,999,999.99",16,,/*{|| code-block de impressao }*/)
TRCell():New(oSection7,"C3_COND","SC3")
TRCell():New(oSection7,"E4_DESCRI","SE4")
TRCell():New(oSection7,"MSG","SC3",STR0035,,255,,{|| Formula(C3_MSG)})

Return oReport
 
//-------------------------------------------------------------------
/*/{Protheus.doc} ReportPrin()
Definição das propriedades do relatório em TReport
@author Andre Anjos
@since 14/01/2014
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------
Static Function ReportPrin(oReport)
Local cQuebra := ""
Local aTotais := {0,0,0}

TRPosition():New(oReport:Section(1):Section(1),"SM0",1,{|| cEmpAnt+cFilAnt})
TRPosition():New(oReport:Section(1):Section(2),"SA2",1,{|| xFilial("SA2")+SC3->(C3_FORNECE+C3_LOJA)})
TRPosition():New(oReport:Section(1):Section(3),"SB1",1,{|| xFilial("SB1")+SC3->C3_PRODUTO})
TRPosition():New(oReport:Section(1):Section(3),"SB5",1,{|| xFilial("SB1")+SC3->C3_PRODUTO})
TRPosition():New(oReport:Section(1):Section(4),"SM0",1,{|| cEmpAnt+SC3->C3_FILENT})
TRPosition():New(oReport:Section(1):Section(5),"SM0",1,{|| cEmpAnt+SC3->C3_FILENT})
TRPosition():New(oReport:Section(1):Section(6),"SE4",1,{|| xFilial("SE4")+SC3->C3_COND})

dbSelectArea("SC3")
dbSetOrder(1)
dbSeek(xFilial("SC3")+mv_par01,.T.)
//While !Eof() .And. C3_FILIAL == xFilial("SC3") .And. C3_NUM <= mv_par02
While !Eof() .And. C3_FILIAL == xFilial("SC3") .And. C3_NUM <= mv_par02 .And. C3_FORNECE >= mv_par04 .And. C3_FORNECE <= mv_par05
	oReport:Section(1):Init()
	oReport:Section(1):PrintLine()
	
	oReport:Section(1):Section(1):Init()
	oReport:Section(1):Section(1):PrintLine()
	oReport:Section(1):Section(1):Finish()
	oReport:Section(1):Section(2):Init()
	oReport:Section(1):Section(2):PrintLine()
	oReport:Section(1):Section(2):Finish()
	
	aTotais[1] := 0
	aTotais[2] := 0
	aTotais[3] := 0
	cQuebra := C3_NUM
	oReport:Section(1):Section(3):Init()
	While !Eof() .And. C3_FILIAL+C3_NUM == xFilial("SC3")+C3_NUM
		aTotais[1] += C3_TOTAL+C3_FRETE
		aTotais[2] += C3_TOTAL
		aTotais[3] += C3_FRETE
		oReport:Section(1):Section(3):PrintLine()

		dbSkip()
	End
	oReport:Section(1):Section(3):Finish()
	dbSkip(-1)
	
	oReport:Section(1):Section(4):Init()
	oReport:Section(1):Section(4):PrintLine()
	oReport:Section(1):Section(4):Finish()
	
	oReport:Section(1):Section(5):Init()
	oReport:Section(1):Section(5):PrintLine()
	oReport:Section(1):Section(5):Finish()
	
	oReport:Section(1):Section(6):Init()
	oReport:Section(1):Section(6):Cell("TOTGER"):SetValue(aTotais[1])
	oReport:Section(1):Section(6):Cell("TOTMER"):SetValue(aTotais[2])
	oReport:Section(1):Section(6):Cell("TOTFRE"):SetValue(aTotais[3])
	oReport:Section(1):Section(6):PrintLine()
	oReport:Section(1):Section(6):Finish()
	
	oReport:Section(1):Finish()
	
	dbSkip()
End

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MTR125R3()
Função de impressão sem TReport
@author Andre Anjos
@since 14/01/2014
@version 1.0
@return NIL
/*/
//-------------------------------------------------------------------
Static Function MTR125R3() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Titulo  := STR0001  // Titulo do Relatorio //"Contrato de Parceria"
Local cDesc1  := STR0002  // Descricao 1 //"Impressão do contrato de Parceria"
Local cDesc2  := ""  // Descricao 2
Local cDesc3  := ""  // Descricao 3
Local cString := "SC3"  // Alias utilizado na Filtragem
Local lDic    := .F. // Habilita/Desabilita Dicionario
Local lComp   := .T. // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .T. // Habilita/Desabilita o Filtro
Local wnrel   := "MATR125"  // Nome do Arquivo utilizado no Spool
Local nomeprog:= ""  // nome do programa
Local lRet	  := .T.

Private Tamanho := "G" // P/M/G
Private Limite  := 132 // 80/132/220
Private aOrdem  := {}  // Ordem do Relatorio
Private cPerg   := "xMTR125"  // Pergunta do Relatorio
Private aReturn := { STR0003, 1,STR0004, 1, 2, 1, "",1 } // //"Zebrado"###"Administracao"
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // Contrato de                                      ³
//³ mv_par02 // Contrato ate'                                	 ³
//³ mv_par03 // Descricao do produto                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,,lFiltro)
lRet := !( nLastKey==27 )
If lRet
	SetDefault(aReturn,cString)
	lRet := !( nLastKey==27 )
	If lRet
		RptStatus({|lEnd| ImpDet(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)
	EndIf
EndIf
If .Not. lRet
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
EndIf
Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ImpDet   ³ Autor ³ Eduardo Riera         ³ Data ³02.12.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle da chamada do Relatorio.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ImpDet(ExpL1,ExprC1,ExprC2,ExprC3,ExprC4)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExprL1 = Controle de cancelamento do relatorio		      ³±±
±±³          ³ExprC1 = Nome do Arquivo utilizado no Spool			 	  ³±±
±±³          ³ExprC2 = Alias utilizado na Filtragem					      ³±±
±±³          ³ExprC3 = nome do programa								      ³±±
±±³          ³ExprC4 = Titulo do Relatorio							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.	                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Matr125()	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpDet(lEnd,wnrel,cString,nomeprog,Titulo)

Local aArea     := GetArea()
Local aAreaSC3  := SC3->(GetArea())
Local aAreaSM0  := SM0->(GetArea())
Local aLay      := Array(57)
Local li        := 100 // Contador de Linhas
Local lImp      := .F. // Indica se algo foi impresso
Local cbCont    := 0   // Numero de Registros Processados
Local cAliasSC3 := "SC3"
Local cContrato := ""
Local cCondPag  := ""
Local cDescri	:= ""
Local cDescProd	:= ""
Local cFilEnt   := ""
Local nLinha	:= 0
Local nTamDesc	:= 30
Local nTotMerc  := 0
Local nTotImp   := 0
Local nTotGer   := 0
Local nZ        := 0
Local nValor    := 0
Local nDec      := 0
Local dEmissao  := cTod("")
Local lTamCod   := Len(SC3->C3_PRODUTO) > 15

aLay[01] := "+----------------------------------------------------------------------------------------------------------------------------------+"
aLay[02] := STR0005 //"| #################################################### | CONTRATO DE PARCERIA                                | ########## | ###### |"
aLay[03] := "| ##################################################   |---------------------------------------------------------------------------|"
aLay[04] := "| ##########                                           | ################################################## ###################### |"
aLay[05] := STR0006 //"| CEP: ######### ##################################### | ######################################################################### |"
aLay[06] := STR0007 //"| TEL: ############### FAX: ###############            | ######################### CEP: ########## #########: #################### |"
aLay[07] := STR0008 //"| #########: #################### #################### | TEL: ###############                                 FAX: ############### |"
aLay[08] := "+----------------------------------------------------------------------------------------------------------------------------------+"

// Ajusta layout caso exista o campo de centro de custos no SC3
If lTamCod
	aLay[09] := STR0023 //"|Item| Produto                      | Descrição     |UM|  Quantidade  |    Valor Total   | Observacoes         | Centro de Custos  |"
    aLay[10] :=           "+----+------------------------------+---------------+--+--------------+------------------+---------------------+-------------------+"
    aLay[11] :=           "|####|##############################|###############|##|##############|##################|#####################|###################|"
	aLay[12] :=           "|    |                              |               |  |              |                  |                     |                   |"
    aLay[37] :=           "+----+------------------------------+---------------+--+--------------+------------------+---------------------+-------------------+"
Else
	aLay[09] := STR0021 //"|Item|    Produto    |           Descricao          |UM|  Quantidade  |    Valor Total   | Observacoes         | Centro de Custos  |"
    aLay[10] :=           "+----+---------------+------------------------------+--+--------------+------------------+---------------------+-------------------+"
    aLay[11] :=           "|####|###############|##############################|##|##############|##################|#####################|###################|"
	aLay[12] :=           "|    |               |                              |  |              |                  |                     |                   |"
    aLay[37] :=           "+----+---------------+------------------------------+--+--------------+------------------+---------------------+-------------------+"
EndIf	

// Inclui linhas no layout ate a linha 36
For nZ := 13 to 36
	aLay[nZ]:=aLay[12]
Next nZ

aLay[38] := STR0010 //"| Local de Entrega : ############################################################################################## CEP :######### |"
aLay[39] := STR0011 //"| Local de Cobranca: ############################################################################################## CEP :######### |"
aLay[40] := "|----------------------------------------------------------------------------------------------------------------------------------|"
aLay[41] := STR0012 //"| Condicao de Pagto: ### ################################### | Total das Mercadorias:                            ##################|"
aLay[42] := STR0013 //"|                                                            | Despesas             :                            ##################|"
aLay[43] := "|----------------------------------------------------------------------------------------------------------------------------------|"
aLay[44] := STR0014 //"|                                                            | Total Geral          :                            ##################|"
aLay[45] := "|-----------------------+-----------------------+-----------------------+----------------------------------------------------------|"
aLay[46] := STR0015 //"|     Comprador         |     Gerencia          |     Diretoria         |                                                          |"
aLay[47] := "|                       |                       |                       |                                                          |"
aLay[48] := "|                       |                       |                       |                                                          |"
aLay[49] := "|                       |                       |                       |                                                          |"
aLay[50] := "|                       |                       |                       |                                                          |"
aLay[51] := "|                       |                       |                       |                                                          |"
aLay[52] := "|                       |                       |                       |                                                          |"
aLay[53] := "|                       |                       |                       |                                                          |"
aLay[54] := "|-----------------------+-----------------------+-----------------------+----------------------------------------------------------|"
aLay[55] := STR0016 //"| Nota: Favor informar o número do contrato em sua nota fiscal                                                                     |"
aLay[56] := "+----------------------------------------------------------------------------------------------------------------------------------+"
aLay[57] := STR0017 //"|                                                                                                                      CONTINUA....|"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSay AvalImp(Limite)

dbSelectArea(cAliasSC3)
SetRegua(LastRec())
dbSetOrder(1)
MsSeek(xFilial("SC3")+AllTrim(MV_PAR01))

While ( !Eof() .And. xFilial("SC3")==(cAliasSC3)->C3_FILIAL .And. (cAliasSC3)->C3_NUM <= MV_PAR02)
	cContrato := (cAliasSC3)->C3_NUM
	dEmissao  := (cAliasSC3)->C3_EMISSAO
	cFilEnt   := (cAliasSC3)->C3_FILENT
	While ( !Eof() .And. xFilial("SC3")==(cAliasSC3)->C3_FILIAL .And. (cAliasSC3)->C3_NUM == cContrato )
		cCondPag := (cAliasSC3)->C3_COND
		nDec := MsDecimais((cAliasSC3)->C3_MOEDA)
		lImp := .T.
		If lEnd
			@ Prow()+1,001 PSAY STR0018 //"CANCELADO PELO OPERADOR"
			Exit
		EndIf		
		If ( li > 58 )
			CabMatr125(cAliasSC3,aLay,@li)
		EndIf

		dbSelectArea("SB1")
		dbSetOrder(1)
		MsSeek(xFilial("SB1")+(cAliasSC3)->C3_PRODUTO)

		cDescri := ""
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o parametro para imprimir a descricao do produto    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(mv_par03)
			mv_par03 := "B1_DESC"
		ElseIf AllTrim(mv_par03) == "B5_CEME" // Impressao da descricao cientifica do Produto
			dbSelectArea("SB5")
			dbSetOrder(1)
			If dbSeek( xFilial("SB5")+(cAliasSC3)->C3_PRODUTO )
				cDescri := Alltrim(B5_CEME)
			EndIf
		EndIf
		If Empty(cDescri) .Or. AllTrim(mv_par03) == "B1_DESC" // Impressao da descricao generica do Produto
			cDescri := Alltrim(SB1->B1_DESC)
		EndIf
		nLinha		:= MLCount(cDescri,nTamDesc)
		cDescProd	:= MemoLine(cDescri,nTamDesc,1)
		
		If !Empty((cAliasSC3)->C3_QTIMP) .And. !Empty((cAliasSC3)->C3_VLIMP)
			
		    nValor:= IIf(cPaisLoc =="BRA", xMoeda((cAliasSC3)->C3_VLIMP,(cAliasSC3)->C3_MOEDA,1), (cAliasSC3)->C3_VLIMP)
		    			
		    FmtLin({(cAliasSC3)->C3_ITEM,;
			(cAliasSC3)->C3_PRODUTO,;
			IIf(lTamCod,SubStr(cDescProd,1,15),cDescProd),;
			SB1->B1_UM,;
			TransForm((cAliasSC3)->C3_QTIMP,Tm((cAliasSC3)->C3_QTIMP,12,2)),;
			TransForm(nValor,Tm(nValor,16,nDec)),;
			Substr((cAliasSC3)->C3_OBS,1,21),Substr(SC3->C3_CC,1,18)},aLay[11],,,@Li)

		Else
		    nValor:= IIf(cPaisLoc =="BRA", xMoeda((cAliasSC3)->C3_TOTAL,(cAliasSC3)->C3_MOEDA,1), (cAliasSC3)->C3_TOTAL)
		    	   		
		    FmtLin({(cAliasSC3)->C3_ITEM,;
			(cAliasSC3)->C3_PRODUTO,;
			IIf(lTamCod,SubStr(cDescProd,1,15),cDescProd),;
			SB1->B1_UM,;
			TransForm((cAliasSC3)->C3_QUANT,Tm((cAliasSC3)->C3_QUANT,12,2)),;
			TransForm(nValor,Tm(nValor,16,nDec)),;
			Substr((cAliasSC3)->C3_OBS,1,21),Substr(SC3->C3_CC,1,18)},aLay[11],,,@Li)

		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Impressao das linhas restantes da descricao do produto / B5  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nZ := 2 To nLinha
			If li > 53
				FmtLin({},aLay[54],,,@Li)
				FmtLin({},aLay[57],,,@Li)
				FmtLin({},aLay[56],,,@Li)
				CabMatr125(cAliasSC3,aLay,@li)
			Endif
			cDescProd := Memoline(cDescri,nTamDesc,nZ)
			FmtLin({"","",cDescProd,"","","",""},aLay[11],,,@Li)
		Next nZ
                
        If cPaisLoc =="BRA"
  			nTotMerc += xMoeda((cAliasSC3)->C3_TOTAL,(cAliasSC3)->C3_MOEDA,1)
			nTotImp  += xMoeda((cAliasSC3)->C3_FRETE,(cAliasSC3)->C3_MOEDA,1)
			nTotGer  += xMoeda((cAliasSC3)->C3_TOTAL,(cAliasSC3)->C3_MOEDA,1)+xMoeda((cAliasSC3)->C3_FRETE,(cAliasSC3)->C3_MOEDA,1)
		Else
			nTotMerc += (cAliasSC3)->C3_TOTAL
			nTotImp  += (cAliasSC3)->C3_FRETE
			nTotGer  += (cAliasSC3)->C3_TOTAL+(cAliasSC3)->C3_FRETE
		EndIf
		
		dbSelectArea(cAliasSC3)
		dbSkip()
		IncRegua()
		
		If Li > 53 .And. (!Eof() .And. xFilial("SC3")==(cAliasSC3)->C3_FILIAL .And. (cAliasSC3)->C3_NUM <= MV_PAR02)
			FmtLin({},aLay[54],,,@Li)
			FmtLin({},aLay[57],,,@Li)
			FmtLin({},aLay[56],,,@Li)
			Li:=100
		EndIf
		
	EndDo

	If Li > 37
	
		While Li < 53
			FmtLin({},aLay[12],,,@Li)
		EndDo

		FmtLin({},aLay[54],,,@Li)
		FmtLin({},aLay[57],,,@Li)
		FmtLin({},aLay[56],,,@Li)
		
		@ 0,0 PSay AvalImp(Limite)
		Li:=1
		FmtLin({},aLay[01],,,@Li)
		FmtLin({SM0->M0_NOMECOM,dEmissao,cContrato},aLay[02],,,@Li)
		FmtLin({SubStr(SM0->M0_ENDENT,1,50)},aLay[03],,,@Li)
		FmtLin({SubStr(SM0->M0_ENDENT,51,Len(SM0->M0_ENDENT)-50) ,SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME,If( cPaisLoc$"ARG|POR|EUA", Space(20) , STR0022 + ": " +SA2->A2_INSCR)},aLay[04],,,@Li)
		FmtLin({SM0->M0_CEPENT ,SM0->M0_CIDENT+"-"+SM0->M0_ESTENT,SA2->A2_END},aLay[05],,,@Li)
		FmtLin({SM0->M0_TEL,SM0->M0_FAX,SA2->A2_MUN+"-"+SA2->A2_EST,SA2->A2_CEP,Padr(RetTitle("A2_CGC"),9) ,Transform(SA2->A2_CGC,PicPesFJ(If(Len(alltrim(SA2->A2_CGC))<14,"F","J")))},aLay[06],,,@Li)
		FmtLin({Padr(RetTitle("A2_CGC"),9),SM0->M0_CGC,If( cPaisLoc$"ARG|POR|EUA", Space(20) , STR0022 + ": " +SM0->M0_INSC),AllTrim(SA2->A2_TEL),SA2->A2_FAX},aLay[07],,,@Li)		
		FmtLin({},aLay[08],,,@Li)
		FmtLin({},aLay[09],,,@Li)
		FmtLin({},aLay[10],,,@Li)
		FmtLin({},aLay[12],,,@Li)
					
	EndIf
	
	While Li < 37
		FmtLin({},aLay[Li],,,@Li)
	EndDo
		
	dbSelectArea("SM0")
	dbSetOrder(1)
	MsSeek(cEmpAnt+cFilEnt)
	
	FmtLin({},aLay[37],,,@Li)
	FmtLin({SM0->M0_ENDENT+" "+SM0->M0_CIDENT+"-"+SM0->M0_ESTENT,SM0->M0_CEPENT},aLay[38],,,@Li)
	FmtLin({SM0->M0_ENDCOB+" "+SM0->M0_CIDCOB+"-"+SM0->M0_ESTCOB,SM0->M0_CEPCOB},aLay[39],,,@Li)
	
	dbSelectArea("SE4")
	dbSetOrder(1)
	MsSeek(xFilial("SE4")+cCondPag)
	
	FmtLin({},aLay[40],,,@Li)
	FmtLin({cCondPag,SE4->E4_DESCRI,TransForm(nTotMerc,Tm(nTotMerc,16,nDec))},aLay[41],,,@Li)
	FmtLin({TransForm(nTotImp,Tm(nTotMerc,16,nDec))},aLay[42],,,@Li)
	FmtLin({},aLay[43],,,@Li)
	FmtLin({TransForm(nTotGer,Tm(nTotMerc,16,nDec))},aLay[44],,,@Li)
		
	FmtLin({},aLay[45],,,@Li)
	FmtLin({},aLay[46],,,@Li)
	FmtLin({},aLay[47],,,@Li)
	FmtLin({},aLay[48],,,@Li)
	FmtLin({},aLay[49],,,@Li)
	FmtLin({},aLay[50],,,@Li)
	FmtLin({},aLay[51],,,@Li)
	FmtLin({},aLay[52],,,@Li)
	FmtLin({},aLay[53],,,@Li)
	FmtLin({},aLay[54],,,@Li)
	FmtLin({},aLay[55],,,@Li)
	FmtLin({},aLay[56],,,@Li)
	Li := 100
	cbCont++
	
	//Zera variáveis //
	nTotMerc := 0
	nTotImp  := 0
	nTotGer  := 0
	
	dbSelectArea(cAliasSC3)
EndDo

Set Device To Screen
Set Printer To
If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

RestArea(aAreaSC3)
RestArea(aAreaSM0)
RestArea(aArea)

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CabMatr125³ Autor ³ Ricardo Berti         ³ Data ³08.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do cabecalho para o relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CabMatr125(ExprC1,ExprA1,ExprN1)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExprC1 = Alias do SC3                                       ³±±
±±³          ³ExprA1 = array contendo linhas formatadas do relatorio      ³±±
±±³          ³ExprN1 = numero da linha corrente                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Matr125()	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CabMatr125(cAliasSC3,aLay,li)

dbSelectArea("SA2")
dbSetOrder(1)
MsSeek(xFilial("SA2")+(cAliasSC3)->C3_FORNECE+(cAliasSC3)->C3_LOJA)
			
dbSelectArea("SM0")
dbSetOrder(1)
MsSeek(cEmpAnt+cFilAnt)
			
@ 0,0 PSay AvalImp(Limite)
Li:=1
FmtLin({},aLay[01],,,@Li)
FmtLin({SM0->M0_NOMECOM,DtoC((cAliasSC3)->C3_EMISSAO),(cAliasSC3)->C3_NUM},aLay[02],,,@Li)
FmtLin({SubStr(SM0->M0_ENDENT,1,50)},aLay[03],,,@Li)
FmtLin({SubStr(SM0->M0_ENDENT,51,Len(SM0->M0_ENDENT)-50),SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME,If( cPaisLoc$"ARG|POR|EUA", Space(20) , STR0022 + ": " +SA2->A2_INSCR)},aLay[04],,,@Li)
FmtLin({SM0->M0_CEPENT ,SM0->M0_CIDENT+"-"+SM0->M0_ESTENT,SA2->A2_END},aLay[05],,,@Li)
FmtLin({SM0->M0_TEL,SM0->M0_FAX,SA2->A2_MUN+"-"+SA2->A2_EST,SA2->A2_CEP,Padr(RetTitle("A2_CGC"),9),Transform(SA2->A2_CGC,PicPesFJ(If(Len(alltrim(SA2->A2_CGC))<14,"F","J")))},aLay[06],,,@Li)
FmtLin({Padr(RetTitle("A2_CGC"),9),SM0->M0_CGC,If( cPaisLoc$"ARG|POR|EUA", Space(20) , STR0022 + ": " +SM0->M0_INSC),AllTrim(SA2->A2_TEL),SA2->A2_FAX},aLay[07],,,@Li)
FmtLin({},aLay[08],,,@Li)
FmtLin({},aLay[09],,,@Li)
FmtLin({},aLay[10],,,@Li)

Return Nil
