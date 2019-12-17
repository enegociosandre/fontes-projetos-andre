#INCLUDE "PROTHEUS.CH"
#INCLUDE "LIBRVE1.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �LIBRVE1   � Autor �Sergio S. Fuzinaka     � Data � 01.06.06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Livros Fiscais de IVA Compras e Vendas                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Venezuela                                                   ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function LibrVe1()

Local oReport
Local cPerg		:= "LIBVE1"

If FindFunction("TRepInUse") .And. TRepInUse()
	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	U_LibrVe1R3()
EndIf

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef  � Autor �Sergio S. Fuzinaka     � Data � 01.06.06 ���
��������������������������������������������������������������������������Ĵ��
���Descricao �A funcao estatica ReportDef devera ser criada para todos os  ���
���          �relatorios que poderao ser agendados pelo usuario.           ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relatorio                                   ���
��������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                          ���
��������������������������������������������������������������������������Ĵ��
���          �               �                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport
Local oSecao1, oSecao2, oBreak

Local cReport	:= "LIBRVE1"
Local cPerg		:= "LIBVE1"
Local cTitulo	:= OemToAnsi(STR0039)	//"Emiss�o dos Livros Fiscais IVA"
Local cDesc		:= OemToAnsi(STR0040)	//"Este programa tem como objetivo imprimir os Livros Fiscais IVA de Compras e Vendas."

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New(cReport,cTitulo,cPerg,{|oReport| ReportPrint(oReport)},cDesc)
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)
Pergunte(oReport:uParam,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSecao1:=TRSection():New(oReport,OemToAnsi(STR0041),{"SM0"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oSecao1,"M0_NOMECOM","SM0",OemToAnsi(STR0041),/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"M0_CGC","SM0",OemToAnsi(STR0042),/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)

oSecao2:=TRSection():New(oReport,OemToAnsi(STR0056),{"SF3","SA1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oSecao2,"MES","","",/*Picture*/,2,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_ENTRADA","SF3",OemToAnsi(STR0054),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_SERIE","SF3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_NFISCAL","SF3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"A1_NOME","SA1",OemToAnsi(STR0055),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"A1_CGC","SA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TOTAL","",OemToAnsi(STR0051),"@E) 9,999,999,999,999.99",20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"BASEIMP","",OemToAnsi(STR0052),"@E) 9,999,999,999,999.99",20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"ALIQ","","%","@E) 999.99",6,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"IVA","","I.V.A","@E) 9,999,999,999,999.99",20,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New(oSecao2,oSecao2:Cell("MES"),OemToAnsi(STR0053),.F.) //"Totais"

TRFunction():New(oSecao2:Cell("TOTAL"),NIL,"SUM",oBreak,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
TRFunction():New(oSecao2:Cell("BASEIMP"),NIL,"SUM",oBreak,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
TRFunction():New(oSecao2:Cell("IVA"),NIL,"SUM",oBreak,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)

Return(oReport)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor �Sergio S. Fuzinaka     � Data � 01.06.06 ���
��������������������������������������������������������������������������Ĵ��
���Descricao �A funcao estatica ReportDef devera ser criada para todos os  ���
���          �relatorios que poderao ser agendados pelo usuario.           ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                            ���
���          �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local cCondicao		:= ""
Local cAliasSF3		:= "SF3"
Local cCabec		:= ""
Local cNomeCom		:= ""
Local cCGC			:= ""
Local nLastRec		:= 0
Local nAliq			:= 0
Local nAliqIVA		:= 0
Local cCpoValImp	:= ""
Local cCpoBasImp	:= ""
Local lVenda		:= ( mv_par03 <  3 )	// Venda
Local lCLocal		:= ( mv_par03 == 3 )	// Compra Locale
Local lVIsenta		:= ( mv_par03 == 2 )	// Venta Exenta
Local nBasImp 		:= 0
Local nValImp 		:= 0
Local nMes			:= ""
Local nMesAnt		:= ""
Local dEntrada		:= Ctod("")
Local cSerie		:= ""
Local cNFiscal		:= ""
Local cRazSoc		:= ""
Local cCNPJ			:= ""
Local nTotal		:= 0
Local nBaseImp		:= 0
Local nIVA			:= 0

//�������������������������������������������������������Ŀ
//�Secao 1 - Empresa                                      �
//���������������������������������������������������������
oReport:Section(1):Cell("M0_NOMECOM"):SetBlock({|| cNomeCom})
oReport:Section(1):Cell("M0_CGC"):SetBlock({|| cCGC})

//�������������������������������������������������������Ŀ
//�Secao 2 - Detalhe                                      �
//���������������������������������������������������������
oReport:Section(2):Cell("MES"):SetBlock({|| nMes})
oReport:Section(2):Cell("F3_ENTRADA"):SetBlock({|| dEntrada})
oReport:Section(2):Cell("F3_SERIE"):SetBlock({|| cSerie})
oReport:Section(2):Cell("F3_NFISCAL"):SetBlock({|| cNFiscal})
oReport:Section(2):Cell("A1_NOME"):SetBlock({|| cRazSoc})
oReport:Section(2):Cell("A1_CGC"):SetBlock({|| cCNPJ})
oReport:Section(2):Cell("TOTAL"):SetBlock({|| nTotal})
oReport:Section(2):Cell("BASEIMP"):SetBlock({|| nBaseImp})
oReport:Section(2):Cell("ALIQ"):SetBlock({|| nAliq})
oReport:Section(2):Cell("IVA"):SetBlock({|| nIVA})

//�������������������������������������������������������Ŀ
//�Tratamento das Colunas para impressao                  �
//���������������������������������������������������������
oReport:Section(2):Cell("MES"):Disable()
If lVIsenta
	oReport:Section(2):Cell("BASEIMP"):Disable()
	oReport:Section(2):Cell("ALIQ"):Disable()
	oReport:Section(2):Cell("IVA"):Disable()		
Endif

//�������������������������������������������������������Ŀ
//�Altera o titulo para impressao                         �
//���������������������������������������������������������
Do Case
	Case mv_par03 == 1	//Vendas Contrib.
		cCabec := OemToAnsi(STR0043)+OemToAnsi(STR0045)+OemToAnsi(STR0049)
	Case mv_par03 == 2	//Vendas Isentas
		cCabec := OemToAnsi(STR0043)+OemToAnsi(STR0045)+OemToAnsi(STR0048)
	Case mv_par03 == 3	//Compras Locais
		cCabec := OemToAnsi(STR0043)+OemToAnsi(STR0044)+OemToAnsi(STR0047)
	Case mv_par03 == 4	//Compras Import.
		cCabec := OemToAnsi(STR0043)+OemToAnsi(STR0044)+OemToAnsi(STR0046)
EndCase
cCabec += " - "+Upper(MesExtenso(Month(mv_par02)))+" / "+Str(Year(mv_par02),4)

oReport:SetTitle(cCabec)

//��������������������   �����������������������������������Ŀ
//�Busca aliquota e campos de gravacao do imposto IVA     �
//���������������������������������������������������������
dbSelectArea("SFB")
dbSetOrder(1)
cCpoValImp  := "F3_VALIMP1"
cCpoBasImp  := "F3_BASIMP1"
If dbSeek(xFilial("SFB")+"IVA")
	nAliq 		:= SFB->FB_ALIQ					//Aliquota IVA
	nAliqIVA	:= SFB->FB_ALIQ					//Aliquota IVA	
	cCpoValImp	:= "F3_VALIMP"+SFB->FB_CPOLVRO	//Campo de gravacao do valor do imposto no arq. de Livros Fiscais
	cCpoBasImp	:= "F3_BASIMP"+SFB->FB_CPOLVRO	//Campo de gravacao da base do imposto no arq. de Livros Fiscais  
EndIf

//������������������������������������������������������������������������Ŀ
//�Filtragem do relatorio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SF3")
dbSetOrder(1)

#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)

	cCondicao := "%"
	If lVenda
		cCondicao += "F3_TIPOMOV = 'V'"
		If lVIsenta
			cCondicao += "AND F3_EXENTAS > 0"
		Else
			cCondicao += "AND F3_EXENTAS = 0"
		Endif
	Else
		cCondicao += "F3_TIPOMOV = 'C'"	
	Endif
	cCondicao += "%"

	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
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

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeAdvplExpr(oReport:uParam)

	cCondicao := "F3_FILIAL == '"+xFilial("SF3")+"' .And. "
	
	If lVenda
		cCondicao += "F3_TIPOMOV == 'V' .And. "
		If lVIsenta
			cCondicao += "F3_EXENTAS > 0 .And. "
		Else
			cCondicao += "F3_EXENTAS == 0 .And. "
		Endif
	Else
		cCondicao += "F3_TIPOMOV == 'C' .And. "	
	Endif
	
	cCondicao += "Dtos(F3_ENTRADA) >= '"+Dtos(mv_par01)+"' .And. "
	cCondicao += "Dtos(F3_ENTRADA) <= '"+Dtos(mv_par02)+"'"

	oReport:Section(2):SetFilter(cCondicao,IndexKey())
	
#ENDIF		

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relatorio                               �
//��������������������������������������������������������������������������
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
oReport:Section(2):Init()
nMesAnt:=Month((cAliasSF3)->F3_ENTRADA)

While !Eof()

	oReport:IncMeter()
	
	If !lVenda // Compra
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek( xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ) )
		cRazSoc	:= SA2->A2_NOME
		cCNPJ  	:= SA2->A2_CGC
		If ( lCLocal .And. SA2->A2_TIPO <> "3" ) .Or. ( !lCLocal .And. SA2->A2_TIPO <> "4" )
			(cAliasSF3)->( dbSkip() )
			Loop
		Endif					
	Else
		SA1->( dbSetOrder(1) )
		SA1->( dbSeek( xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ) )
		cRazSoc	:= SA1->A1_NOME
		cCNPJ	:= SA1->A1_CGC
	Endif

	nSigno := IIf((lVenda .And. (cAliasSF3)->F3_ESPECIE == "NCC") .Or. (!lVenda .And. (cAliasSF3)->F3_ESPECIE == "NDP"),-1,1)

	nMes		:= Month((cAliasSF3)->F3_ENTRADA)
	dEntrada	:= (cAliasSF3)->F3_ENTRADA		
	cSerie		:= (cAliasSF3)->F3_SERIE
	cNFiscal	:= (cAliasSF3)->F3_NFISCAL	

	If Empty( (cAliasSF3)->F3_DTCANC )

		nBasImp := (cAliasSF3)->&cCpoBasImp
		nValImp := (cAliasSF3)->&cCpoValImp
		nTotal	:= ((cAliasSF3)->F3_VALCONT * nSigno)
		
		If !lVIsenta
		   nBaseImp	:= (nBasImp * nSigno)
		   nAliq	:= nAliqIVA
		   nIVA		:= (nValImp * nSigno)
		Endif
		
	Else

		cRazSoc	:= OemToAnsi(STR0050) //"*** CANCELADA ***"
		nBasImp := 0
		nValImp := 0
		nTotal	:= 0
		nBaseImp:= 0
		nAliq	:= 0
		nIVA	:= 0

	Endif

	oReport:Section(2):PrintLine() 	
	
	(cAliasSF3)->(dbSkip())
	
	If !Eof() .And. Month((cAliasSF3)->F3_ENTRADA) <> nMesAnt
		nMesAnt := Month((cAliasSF3)->F3_ENTRADA)		
	Endif

Enddo
oReport:Section(2):Finish()	

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa  � LibrvE1R3  � Autor �      Nava       � Data �  07/06/01   ���
�������������������������������������������������������������������������͹��
��� Descricao � Livro de IVA Compras y Ventas (Localizacao Venezuela)     ���
�������������������������������������������������������������������������͹��
��� Sintaxe   � LibrvE1()                                                 ���
�������������������������������������������������������������������������͹��
��� Parametro � NIL                                    			          ���
�������������������������������������������������������������������������͹��
��� Retorno   � NIL                                                       ���
�������������������������������������������������������������������������͹��
��� Uso       � SigaLoja - Localizacoes 								  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LibrVE1R3()        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������


#DEFINE CPICTVAL0 	"@E)    99,999,999,999.99"
#DEFINE CPICTVAL1 	"@E)   999,999,999,999.99"
#DEFINE	CPICTVAL2	"@E) 9,999,999,999,999.99"
#DEFINE NLINESPAGE  55

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("ASER,TAMANHO,LIMITE,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY")
SetPrvt("LCONTINUA,WNREL,LFINREL")
SetPrvt("LTIPOS,NQ,CSTRING")
SetPrvt("CCHAVE,CFILTRO,CARQINDXF3")
SetPrvt("NLIN,NPAGINA")
SetPrvt("DENTANT")
SetPrvt("NA,NTIPO,AMESES,CEMPRESA")
SetPrvt("CINSCR,CRIF,CTITULO,_NMES,NCNT1,ND")
SetPrvt("ADRIVER,NOPC,CCOR")
SetPrvt("J")

Private lVenda
Private lCLocal
Private lVIsenta
Private nTotalVal
Private nTotalBas
Private nTotalImp

// ----------  Pergunte
//�������������������������������������������������������������Ŀ
//�Variaveis utilizadas para parametros                         �
//�mv_par01             // Fecha desde                          �
//�mv_par02             // Fecha hasta                          �
//�mv_par03             // Ventas o compras                     �
//���������������������������������������������������������������

cPerg := "LIBVE1"
AjustaSX1(cPerg)
Pergunte(cPerg,.F.)

CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
aSer	:=	{}
tamanho:="M"
limite :=132
titulo   := PADC(OemtoAnsi(STR0001),74)   //"Emision del Subdiario de IVA"
cDesc1   := PADC(OemtoAnsi(STR0002),74)   //"Seran solicitadas la fecha inicial y la fecha final para la emision "
cDesc2   := PADC(OemtoAnsi(STR0003),74)   //"de los libros de IVA Ventas e IVA Compras"
cDesc3	 :=""
cNatureza:=""
aReturn  := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1,"",1 }  //"Especial"  "Administracion"
nomeprog :="LIBRVE1"
cPerg    :="LIBVE1"
nLastKey := 0
lContinua:= .T.
wnrel    := "LIBRVE1"
lFinRel  := .F.
nQtdFt   := 0

//Busca aliquota e campos de gravacao do imposto IVA
dbSelectArea("SFB")
DbSetOrder(1)
nAliq 		:= 0
cCpoValImp  := "SF3->F3_VALIMP1"
cCpoBasImp  := "SF3->F3_BASIMP1"
If dbSeek(xFilial()+"IVA")
	nAliq := SFB->FB_ALIQ
	cCpoValImp := "SF3->F3_VALIMP"+SFB->FB_CPOLVRO  //Campo de gravacao do valor do imposto no arq. de Livros Fiscais
	cCpoBasImp := "SF3->F3_BASIMP"+SFB->FB_CPOLVRO  //Campo de gravacao da base do imposto no arq. de Livros Fiscais  
EndIf

DbSelectArea("SF3")

cString:="SF3"

//�������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT           �
//���������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

//����������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora       �
//������������������������������������������������������

VerImp()

//�������������������������������������������������������������Ŀ
//�Variaveis utilizadas para parametros                         �
//�mv_par01             // Fecha desde                          �
//�mv_par02             // Fecha hasta                          �
//�mv_par03             // Ventas o compras                     �
//���������������������������������������������������������������
lVenda	:= ( mv_par03 <  3 )	// Venda
lCLocal	:= ( mv_par03 == 3 )	// Compra Locale
lVIsenta	:= ( mv_par03 == 2 )	// Venta Exenta


//���������������������������������������������Ŀ
//� Inicio do Processamento do Relatorio.       �
//�����������������������������������������������

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> 	RptStatus({|| Execute(RptDetail)})
RptStatus({|| RptDetail()})
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �RptDetail �Autor  �Nava                � Data �  07/06/01   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina de processamento do relatorio                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LibrVE1                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> 	Function RptDetail
Static Function RptDetail()

LOCAL cRazaoSoc
LOCAL cCgc
LOCAL cPictCgc
LOCAL nBasImp
LOCAL nValImp

//��������������������������������������������������Ŀ
//� Prepara o SF3 para extracao dos dados            �
//����������������������������������������������������

dbSelectArea("SF3")
Retindex("SF3")
//dbSelectArea("SF3")
cFiltro := "F3_FILIAL=='"+xFilial("SF3")+"'.AND.DTOS(F3_ENTRADA)>='"+DTOS(mv_par01)+;
				"'.AND.DTOS(F3_ENTRADA)<='"+DTOS(mv_par02)+"' .And.F3_TIPOMOV == "+ IF( lVenda, "'V'", "'C'" ) 
IF lVenda 
	IF lVIsenta
		cFiltro += " .AND. F3_EXENTAS > 0 "
	ELSE
		cFiltro += " .AND. F3_EXENTAS = 0 "
	ENDIF				
ENDIF

cChave := "F3_FILIAL+DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL+F3_CFO"

cArqIndxF3 := CriaTrab(NIL,.F.)

IndRegua("SF3",cArqIndxF3,cChave,,cFiltro,OemToAnsi(STR0006))  //"Filtrando registros..."
nindex := RetIndex("SF3")

#IFNDEF TOP
	//dbClearIndex()
	dbSetIndex(cArqIndxF3+OrdBagExt())
#ENDIF

dbSetOrder(nIndex+1)
nNroDoc := 0  // Fernando Dourado 03/12/99 Numero de documentos impressos

nTotalVlr := 0
nTotalBas := 0
nTotalImp := 0
nLin	:= 60
nPagina := 0

SetRegua(LastRec())

dbSelectArea("SF3")
dbGoTop()
dEntAnt	:= CTOD("")
DO WHILE !SF3->( Eof() )
	IncRegua()
	If LastKey() == 286
		@ 00,01 PSAY OemToAnsi(STR0007)  //"** CANCELADO PELO OPERADOR **"  
		Exit
	EndIf
	
	IF lAbortPrint
		@ 00,01 PSAY OemToAnsi(STR0007)  //"** CANCELADO PELO OPERADOR **"  
		lContinua := .F.
		Exit
	Endif

	If nLin > NLINESPAGE
		//�������������������������������������������������������Ŀ
		//�Dispara a funcao para impressao do Rodape.             �
		//���������������������������������������������������������
		R020Cab()
	EndIf
	If !lVenda // Compra
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek( xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA ) )
		cRazaoSoc:= SA2->A2_NOME
		cCgc	  	:=SA2->A2_CGC
		cPictCgc := PesqPict( "SA2", "A2_CGC" )
		IF ( lClocal 	.AND. SA2->A2_TIPO <> "3" ) .OR. ;
			( !lClocal 	.AND. SA2->A2_TIPO <> "4" )
			SF3->( DbSKip() )
			LOOP
		ENDIf						
	Else
		SA1->( dbSetOrder(1) )
		SA1->( dbSeek( xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA ) )
		cRazaoSoc:= SA1->A1_NOME
		cCgc		:= SA1->A1_CGC
		cPictCgc := PesqPict( "SA1", "A1_CGC" )
	EndIf

	nSigno := IF( ( lVenda .AND. F3_ESPECIE = "NCC") .OR. ( !lVenda .AND. F3_ESPECIE = "NDP" ) , -1, 1 )
	If ( Month(F3_ENTRADA)<>Month(dEntAnt).AND.Month(dEntAnt)<>0 )
		nPagina := 0
		lFinRel := .T.
		R020Rod()
		R020Cab()
		nTotalVlr := 0
		nTotalBas := 0
		nTotalImp := 0
	EndIf                      
	If ( F3_ENTRADA<>dEntAnt )
		dEntAnt := F3_ENTRADA
	EndIf
	@ nLin, 000 PSAY F3_ENTRADA		
	@ nLin,009 PSAY F3_SERIE+F3_NFISCAL	
	IF ! Empty( F3_DTCANC )
		@ nLin, 024 PSAY OemToAnsi( STR0034 ) // "** ANULADA **"
		SF3->( DbSkip())
		LOOP
	ENDIF		

//             0         1         2         3         4         5         6         7         8         9        10         11       12        13        14        15        16        17        18        19        20        21       220
//             01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//             ------  FACTURA ------- -------- RAZON SOCIAL -------- -- RIF. No. -- ------ TOTAL ------- ---- BASE IMP.---   %  ------ IVA ------
//					99/99/99 xxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxx 9,999,999,999,999.99 99,999,999,999.99 99,9 99,999,999,999.99 
	nBasImp := &cCpoBasImp
	nValImp := &cCpoValImp

	@ nLin,024 PSAY Left(cRazaoSoc,30)	Picture '@!'
	@ nLin,055 PSAY cCgc						Picture cPictCgc
   @ nLin,070 PSAY F3_VALCONT	* nSigno	Picture CPICTVAL2
	IF !lVIsenta
	   @ nLin,091 PSAY nBasImp * nSigno		Picture CPICTVAL0
	   @ nLin,110 PSAY nAliq						Picture "99.9"
	   @ nLin,114 PSAY nValImp * nSigno		Picture CPICTVAL0
	ENDIF	
	nTotalVlr += F3_VALCONT	* nSigno
	nTotalBas += nBasImp * nSigno
	nTotalImp += nValImp * nSigno
	nLin := nLin + 1
	
	//����������������������������������������������������������Ŀ
	//� Dispara a funcao para impressao do Rodape.               �
	//������������������������������������������������������������
	
	If nLin > NLINESPAGE
		R020Rod()
	EndIf
	SF3->( dbSkip() )
EndDo

lFinRel := .T.

//������������������������������������������������������Ŀ
//� Dispara a funcao para impressao do Rodape.           �
//��������������������������������������������������������

If ( nPagina == 1 .and. nLin < NLINESPAGE )
	R020Rod()
EndIf
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
DbSetOrder(1)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �R020Cab   �Autor  �Jose Lucas          � Data �  06/07/98   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cabecalho do Libro de IVA ( Compras e Ventas ).             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LibrVE1                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020Cab
Static Function R020Cab()

//��������������������������������������������Ŀ
//� Variaveis utilizadas no cabecalho          �
//����������������������������������������������

aMeses:={}
AADD(aMeses,OemToAnsi(STR0008))//"ENERO    "
AADD(aMeses,OemToAnsi(STR0009))//"FEBRERO  "
AADD(aMeses,OemToAnsi(STR0010))//"MARZO    "
AADD(aMeses,OemToAnsi(STR0011))//"ABRIL    "
AADD(aMeses,OemToAnsi(STR0012))//"MAYO     "
AADD(aMeses,OemToAnsi(STR0013))//"JUNIO    "
AADD(aMeses,OemToAnsi(STR0014))//"JULIO    "
AADD(aMeses,OemToAnsi(STR0015))//"AGOSTO   "
AADD(aMeses,OemToAnsi(STR0016))//"SETIEMBRE"
AADD(aMeses,OemToAnsi(STR0017))//"OCTUBRE  "
AADD(aMeses,OemToAnsi(STR0018))//"NOVIEMBRE"
AADD(aMeses,OemToAnsi(STR0019))//"DICIEMBRE"

cEmpresa	:= SM0->M0_NOMECOM
cInscr   := InscrEst()
cRif	   := TRANSFORM(SM0->M0_CGC,PesqPict("SA1", "A1_CGC"))
cTitulo  := OemtoAnsi(STR0020) //"L I B R O   D E   "
If lVenda
	cTitulo += OemtoAnsi(STR0022)//"V E N T A S"
	IF lVIsenta
		cTitulo += OemtoAnsi(STR0037)  //" E X E N T A S "
	ELSE
		cTitulo += OemtoAnsi(STR0038)  //" C O N T R I B U Y E N T E S "
	ENDIF	
Else
	cTitulo := cTitulo + OemtoAnsi(STR0021)//"C O M P R A S"
	IF lCLocal
		cTitulo += OemtoAnsi(STR0036) //" L O C A L E S "
	ELSE
		cTitulo += OemtoAnsi(STR0035) //" I M P O R T A C I O N "
	ENDIF	
EndIf

nPagina := nPagina + 1
@ 02,000 PSAY OemToAnsi(STR0023) //"Empresa:"
@ 02,010 PSAY cEmpresa
@ 02,112 PSAY OemToAnsi(STR0024)//"Pagina Nro.:"
@ 02,125 PSAY StrZero(nPagina,6)

@ 03,000 PSAY OemToAnsi(STR0025)//"Rif:"
@ 03,010 PSAY cRif

_nMes := Month(mv_par02)

If _nMes > 0 .And. _nMes < 13
	@ 04,000 PSAY OemToAnsi(STR0026)//"Mes: "
	@ 04,010 PSAY aMeses[_nMes]
	@ 05,000 PSAY OemToAnsi(STR0027)//"Ano:"
	@ 05,010 PSAY StrZero(Year(mv_par02),4)
EndIf

@ 06,050 PSAY cTitulo
//�����������������������������������������������Ŀ
//� Cabecalho para o Relatorio.                   �
//�������������������������������������������������
//             0         1         2         3         4         5         6         7         8         9        10         11       12        13        14        15        16        17        18        19        20        21       220
//             01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//             ------  FACTURA ------- -------- RAZON SOCIAL -------- -- RIF. No. -- ------ TOTAL ------- ---- BASE IMP.---   %  ------ IVA ------
//					99/99/99 xxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxx 9,999,999,999,999.99 99,999,999,999.99 99,9 99,999,999,999.99 
IF !lVIsenta
	@ 08,000 PSAY OemToAnsi(STR0028) //------  FACTURA ------- -------- RAZON SOCIAL -------- -- RIF. No. -- ------ TOTAL ------- ---- BASE IMP.---   %  ------ IVA ------"
ELSE
	@ 08,000 PSAY OemToAnsi(STR0029) //------  FACTURA ------- -------- RAZON SOCIAL -------- -- RIF. No. -- ------ TOTAL -------"
ENDIF

nLin := 10

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � R020Rod  �Autor  �Jose Lucas          � Data �  06/07/98   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rodape do Libro de IVA ( Compras e Ventas ).               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LibrVE1                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function R020Rod
Static Function R020Rod()

//������������������������������������������������������Ŀ
//� Dispara a funcao para impressao do Rodape.           �
//��������������������������������������������������������

nLin := nLin + 1
//                  8         9        10         11       12        13        14        15        16        17        18        19        20        21       220
//            456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//        Totales :         999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999,999.99
@ nLin,000 PSAY OemToAnsi(STR0030) //"Totales :"
@ nLin,070 PSAY nTotalVlr	Picture CPICTVAL2
IF !lVIsenta
	@ nLin,090 PSAY nTotalBas	Picture CPICTVAL1
	@ nLin,113 PSAY nTotalImp	Picture CPICTVAL1
ENDIF
nLin := nLin +1

If  !(lFinRel)
	R020Cab()
	@ nLin,000 PSAY OemToAnsi(STR0031) //"Transporte :"
	@ nLin,071 PSAY nTotalVlr	Picture CPICTVAL2
	IF !lVIsenta
		@ nLin,090 PSAY nTotalBas	Picture CPICTVAL1
		@ nLin,113 PSAY nTotalImp	Picture CPICTVAL1
	ENDIF
	nLin:= nlin+1
EndIf
lFinRel := .F.

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � VerImp   �Autor  �Marcos Simidu       � Data �  20/12/95   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica posicionamento de papel na Impressora             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LibrVE1                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Substituido pelo assistente de conversao do AP5 IDE em 09/09/99 ==> Function VerImp
Static Function VerImp()

nLin:= 0                // Contador de Linhas
aDriver:=ReadDriver()
If aReturn[5]==2
	
	nOpc       := 1
	DO WHILE .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ 00   ,000	PSAY &aDriver[5]
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		
		If MsgYesNo(OemtoAnsi(STR0032))//"�Fomulario esta posicionado ? "
			nOpc := 1
		ElseIF MsgYesNo(OemToAnsi(STR0033))//"�Tenta Nuevamente ? "
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa  � AjustaSX1  � Autor �      Nava       � Data �  07/06/01   ���
�������������������������������������������������������������������������͹��
��� Descricao � Verifica as perguntas, inclu�ndo-as caso n�o existam	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1(cPerg)

PutSx1(cPerg,"01","Data Inicio","Fecha Inicio","Fecha Inicio","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
PutSx1(cPerg,"02","Data Fim","Fecha Fin","Fecha Fin"         ,"mv_ch2","D",8,0,0,"G","","","","","mv_par02")
PutSx1(cPerg,"03","Livro de","Libro de","Libro de","mv_ch3","N",1,0,2,"C","","","","","mv_par03","Vendas Contrib.","Ventas Contrib.","Ventas Contrib.","","Vendas Isentas ","Ventas Exentas","Ventas Exentas","Compras Locais","Compras Locales","Compras Locales","Compras Import.","Compras Import.","Compras Import.")

RETURN NIL