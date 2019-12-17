#INCLUDE "PROTHEUS.CH"
#INCLUDE "LIBRPER.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �LIBRPER   � Autor �Sergio S. Fuzinaka     � Data � 30.05.06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Livro de IGV Compras e Vendas                               ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Peru                                                        ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function LibrPer()

Local oReport
Local cPerg		:= "LIBPER"

If FindFunction("TRepInUse") .And. TRepInUse()
	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	U_LibrPerR3()
EndIf

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef  � Autor �Sergio S. Fuzinaka     � Data �10.05.2006���
��������������������������������������������������������������������������Ĵ��
���Descricao �A funcao estatica ReportDef devera ser criada para todos os  ���
���          �relatorios que poderao ser agendados pelo usuario.           ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                   ���
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

Local cReport	:= "LIBRPER"
Local cPerg		:= "LIBPER"
Local cTitulo	:= OemToAnsi(STR0035)	//"Emiss�o do Livro de IGV"
Local cDesc		:= OemToAnsi(STR0036)	//"Este programa tem como objetivo imprimir os Livros de IGV Vendas e IGV Compras."

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
oSecao1:=TRSection():New(oReport,"Empresa",{"SM0"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oSecao1,"M0_NOMECOM","SM0",OemToAnsi(STR0045),/*Picture*/,40,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"M0_CGC","SM0",OemToAnsi(STR0046),/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/)

oSecao2:=TRSection():New(oReport,"Detalhe",{"SF3","SA2"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oSecao2,"MES","","",/*Picture*/,2,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_ENTRADA","SF3",OemToAnsi(STR0041),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_TPDOC","SF3","TD",/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_NFISCAL","SF3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F3_SERIE","SF3",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"F1_NFORI","SF1",OemToAnsi(STR0042),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"A1_NOME","SA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"A1_CGC","SA1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"BASEIMP","",OemToAnsi(STR0043),"@E) 9,999,999,999,999.99",20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"IGV","","IGV","@E) 9,999,999,999,999.99",20,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSecao2,"TOTAL","",OemToAnsi(STR0044),"@E) 9,999,999,999,999.99",20,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New(oSecao2,oSecao2:Cell("MES"),OemToAnsi(STR0047),.F.) //"Total por Mes"

TRFunction():New(oSecao2:Cell("BASEIMP"),NIL,"SUM",oBreak,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
TRFunction():New(oSecao2:Cell("IGV"),NIL,"SUM",oBreak,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
TRFunction():New(oSecao2:Cell("TOTAL"),NIL,"SUM",oBreak,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)

TRFunction():New(oSecao2:Cell("BASEIMP"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oSecao2:Cell("IGV"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)
TRFunction():New(oSecao2:Cell("TOTAL"),NIL,"SUM",/*oBreak*/,/*cTitulo*/,/*cPicture*/,/*uFormula*/,.F.,.T.)

Return(oReport)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor �Sergio S. Fuzinaka     � Data �04.05.2006���
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
Local cCpoValImp	:= ""
Local cCpoBasImp	:= ""
Local lVenda		:= (mv_par03==1)
Local nSigno		:= 0
Local nBasImp 		:= 0
Local nValImp 		:= 0

Local REFDOC		:= ""
Local RAZSOC		:= ""
Local CNPJ			:= ""
Local ENTRADA		:= Ctod("")
Local NFISCAL		:= ""
Local SERIE			:= ""
Local BASEIMP		:= 0
Local IGV			:= 0
Local TOTAL 		:= 0
Local MES			:= 0
Local TPDOC			:= ""

//�������������������������������������������������������Ŀ
//�Secao 1 - Empresa                                      �
//���������������������������������������������������������
oReport:Section(1):Cell("M0_NOMECOM"):SetBlock({|| cNomeCom})
oReport:Section(1):Cell("M0_CGC"):SetBlock({|| cCGC})

//�������������������������������������������������������Ŀ
//�Secao 2 - Detalhe                                      �
//���������������������������������������������������������
oReport:Section(2):Cell("MES"):SetBlock({|| MES})
oReport:Section(2):Cell("F3_ENTRADA"):SetBlock({|| ENTRADA})
oReport:Section(2):Cell("F3_TPDOC"):SetBlock({|| TPDOC})
oReport:Section(2):Cell("F3_NFISCAL"):SetBlock({|| NFISCAL})
oReport:Section(2):Cell("F3_SERIE"):SetBlock({|| SERIE})
oReport:Section(2):Cell("F1_NFORI"):SetBlock({|| REFDOC})
oReport:Section(2):Cell("A1_NOME"):SetBlock({|| RAZSOC})
oReport:Section(2):Cell("A1_CGC"):SetBlock({|| CNPJ})
oReport:Section(2):Cell("BASEIMP"):SetBlock({|| BASEIMP})
oReport:Section(2):Cell("IGV"):SetBlock({|| IGV})
oReport:Section(2):Cell("TOTAL"):SetBlock({|| TOTAL})

//�������������������������������������������������������Ŀ
//�Tratamento das Colunas para impressao                  �
//���������������������������������������������������������
oReport:Section(2):Cell("MES"):Disable()
If !lVenda
	oReport:Section(2):Cell("F1_NFORI"):Disable()
Endif

//�������������������������������������������������������Ŀ
//�Altera o titulo para impressao                         �
//���������������������������������������������������������
If mv_par03 == 1	//Vendas
	cCabec := OemToAnsi(STR0037)+OemToAnsi(STR0038)
Else				//Compras
	cCabec := OemToAnsi(STR0037)+OemToAnsi(STR0039)
Endif
cCabec += " - "+Upper(MesExtenso(Month(mv_par02)))+" / "+Str(Year(mv_par02),4)

oReport:SetTitle(cCabec)

//�������������������������������������������������������Ŀ
//�Busca aliquota e campos de gravacao do imposto IGV     �
//���������������������������������������������������������
dbSelectArea("SFB")
dbSetOrder(1)
nAliq 		:= 0
cCpoValImp  := "F3_VALIMP1"
cCpoBasImp  := "F3_BASIMP1"
If dbSeek(xFilial("SFB")+"IGV")
	nAliq 		:= SFB->FB_ALIQ
	cCpoValImp	:= "F3_VALIMP"+SFB->FB_CPOLVRO  //Campo de gravacao do valor do imposto no arq. de Livros Fiscais
	cCpoBasImp	:= "F3_BASIMP"+SFB->FB_CPOLVRO  //Campo de gravacao da base do imposto no arq. de Livros Fiscais  
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
		SELECT *
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
	Else
		cCondicao += "F3_TIPOMOV == 'C' .And. "	
	Endif
	
	cCondicao += "Dtos(F3_ENTRADA) >= '"+Dtos(mv_par01)+"' .And. "
	cCondicao += "Dtos(F3_ENTRADA) <= '"+Dtos(mv_par02)+"'"

	oReport:Section(2):SetFilter(cCondicao,IndexKey())
	
#ENDIF		

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
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

While !Eof()

	oReport:IncMeter()
	
	If Empty( (cAliasSF3)->F3_DTCANC )		//NF Nao Cancelada
	
		If lVenda
			IF (cAliasSF3)->F3_ESPECIE = "NCC"
				SF1->( dbSetOrder(1) )
				SF1->( dbSeek( xFilial("SF1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ) )
				REFDOC := SF1->F1_NFORI  
			ELSE
				REFDOC := ""
			ENDIF		
			
			SA1->( dbSetOrder(1) )
			SA1->( dbSeek( xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ) )
			RAZSOC	:= SA1->A1_NOME
			CNPJ	:= SA1->A1_CGC
		Else
			SA2->( dbSetOrder(1) )
			SA2->( dbSeek( xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ) )
			RAZSOC	:= SA2->A2_NOME
			CNPJ  	:= SA2->A2_CGC
		EndIf
	
		nSigno := IIf((lVenda .And. (cAliasSF3)->F3_ESPECIE=="NCC") .Or. (!lVenda .And. (cAliasSF3)->F3_ESPECIE=="NDP" ),-1,1)
		
		MES		:= Month((cAliasSF3)->F3_ENTRADA)
		ENTRADA	:= (cAliasSF3)->F3_ENTRADA		
		TPDOC	:= (cAliasSF3)->F3_TPDOC
		
		nBasImp := (cAliasSF3)->&cCpoBasImp
		nValImp := (cAliasSF3)->&cCpoValImp
	
		If !lVenda	//Compra
			SERIE	:= (cAliasSF3)->F3_SERIE
			NFISCAL	:= (cAliasSF3)->F3_NFISCAL	
			
			BASEIMP	:= (nBasImp * nSigno)
			IGV		:= (nValImp * nSigno)
			TOTAL	:= ( (cAliasSF3)->F3_VALCONT * nSigno)
		Else
			SERIE	:= (cAliasSF3)->F3_SERIE
			NFISCAL	:= (cAliasSF3)->F3_NFISCAL	
			
			BASEIMP	:= (nBasImp * nSigno)
			IGV		:= (nValImp * nSigno)
			TOTAL	:= ( (cAliasSF3)->F3_VALCONT * nSigno)
		Endif
	
	Else

		MES		:= Month((cAliasSF3)->F3_ENTRADA)
		REFDOC 	:= ""		
		TPDOC	:= (cAliasSF3)->F3_TPDOC
		ENTRADA	:= (cAliasSF3)->F3_ENTRADA		
		SERIE	:= (cAliasSF3)->F3_SERIE
		NFISCAL	:= (cAliasSF3)->F3_NFISCAL			
		RAZSOC	:= OemToAnsi( STR0040 ) 	// "*** CANCELADA ***"
		BASEIMP	:= 0
		IGV		:= 0
		TOTAL	:= 0
	
	Endif
	
	oReport:Section(2):PrintLine() 	

	(cAliasSF3)->(dbSkip())

Enddo
oReport:Section(2):Finish()	

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa  � LibrPerR3  � Autor �      Nava       � Data �  07/06/01   ���
�������������������������������������������������������������������������͹��
��� Descricao � Livro de IGV Compras y Ventas (Localizacao Peru )         ���
�������������������������������������������������������������������������͹��
��� Sintaxe   � LibrPer()                                                 ���
�������������������������������������������������������������������������͹��
��� Parametro � NIL                                 		              ���
�������������������������������������������������������������������������͹��
��� Retorno   � NIL                                                       ���
�������������������������������������������������������������������������͹��
��� Uso       � SigaLoja - Localizacoes 								  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LIBRPERR3()        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99

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
SetPrvt("CINSCR,CRUCEMP,CTITULO,_NMES,NCNT1,ND")
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

cPerg := "LIBPER"
AjustaSX1(cPerg)
Pergunte(cPerg,.F.)

CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
aSer	:=	{}
tamanho:="G"
limite :=220
titulo   := PADC(OemtoAnsi(STR0001),74)   //"Emision del Subdiario de IGV"
cDesc1   := PADC(OemtoAnsi(STR0002),74)   //"Seran solicitadas la fecha inicial y la fecha final para la emision "
cDesc2   := PADC(OemtoAnsi(STR0003),74)   //"de los libros de IGV Ventas e IGV Compras"
cDesc3	 :=""
cNatureza:=""
aReturn  := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1,"",1 }  //"Especial"  "Administracion"
nomeprog :="LibrPer"
nLastKey := 0
lContinua:= .T.
wnrel    := "LibrPer"
lFinRel  := .F.
nQtdFt   := 0

//Busca aliquota e campos de gravacao do imposto IGV
dbSelectArea("SFB")
DbSetOrder(1)
nAliq 		:= 0
cCpoValImp  := "SF3->F3_VALIMP1"
cCpoBasImp  := "SF3->F3_BASIMP1"
If dbSeek(xFilial()+"IGV")
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
lVenda	:= ( mv_par03 == 1 )	// Venda
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
���Funcao    �RptDetail �Autor  �Nava                � Data �  27/06/01   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina de processamento do relatorio                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LibrPer                                                    ���
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

LOCAL nVentaNoGravada:= 0
LOCAL nExonerado 		:= 0
LOCAL cPoliza 			:= Space( 16 )
LOCAL cRefDoc			:= Space( 08 )
LOCAL cComp 			:= Space( 05 )

//��������������������������������������������������Ŀ
//� Prepara o SF3 para extracao dos dados            �
//����������������������������������������������������

dbSelectArea("SF3")
Retindex("SF3")
//dbSelectArea("SF3")
cFiltro := "F3_FILIAL=='"+xFilial("SF3")+"'.AND.DTOS(F3_ENTRADA)>='"+DTOS(mv_par01)+;
				"'.AND.DTOS(F3_ENTRADA)<='"+DTOS(mv_par02)+"' .And.F3_TIPOMOV == "+ IF( lVenda, "'V'", "'C'" ) 

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
		SA2->( DbSetOrder(1) )
		SA2->( DbSeek( xFilial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA ) )
		cRazaoSoc:= SA2->A2_NOME
		cCgc	  	:=SA2->A2_CGC
		cPictCgc := PesqPict( "SA2", "A2_CGC" )
	Else
		IF SF3->F3_ESPECIE = "NCC"
			SF1->( DbSetOrder(1) )
			SF1->( DbSeek( xFilial("SF1")+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA ) )
			cRefDoc := SF1->F1_NFORI  
		ELSE
			cRefDoc := Space( 8 )
		ENDIF		
		
		SA1->( DbSetOrder(1) )
		SA1->( DbSeek( xFilial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA ) )
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
	@ nLin,000 PSAY F3_ENTRADA		
	@ nLin,009 PSAY F3_TPDOC
	IF ! Empty( F3_DTCANC )
		@ nLin, IF( !lVenda, 81, 11 ) PSAY F3_SERIE+' '+F3_NFISCAL	
		@ nLin, 100 PSAY OemToAnsi( STR0034 ) // "** ANULADA **"
		SF3->( DbSkip())
		LOOP
	ENDIF		

	nBasImp := &cCpoBasImp
	nValImp := &cCpoValImp

	IF !lVenda
		@ nLin,012 PSAY cComp
		@ nLin,018 PSAY cPoliza
		@ nLin,035 PSAY cCgc						Picture cPictCgc
		@ nLin,050 PSAY Left(cRazaoSoc,30)	Picture '@!'
		@ nLin,081 PSAY F3_SERIE+' '+F3_NFISCAL	
		@ nLin,097 PSAY nExonerado				Picture CPICTVAL0
		@ nLin,115 PSAY nBasImp * nSigno		Picture CPICTVAL0
		@ nLin,133 PSAY nValImp * nSigno		Picture CPICTVAL0
		@ nLin,151 PSAY F3_VALCONT	* nSigno	Picture CPICTVAL2
	ELSE
		@ nLin,012 PSAY F3_SERIE+F3_NFISCAL	
		@ nLin,027 PSAY cRefDoc
		@ nLin,036 PSAY Left(cRazaoSoc,30)	Picture '@!'
		@ nLin,067 PSAY cCgc						Picture cPictCgc
		@ nLin,082 PSAY nBasImp * nSigno		Picture CPICTVAL0
		@ nLin,100 PSAY nVentaNoGravada		Picture CPICTVAL0
		@ nLin,119 PSAY nValImp * nSigno		Picture CPICTVAL0
		@ nLin,137 PSAY F3_VALCONT	* nSigno	Picture CPICTVAL2
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
���Desc.     �Cabecalho do Libro de IGV ( Compras e Ventas ).             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LibrPer                                                    ���
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
cRucEmp	:= TRANSFORM(SM0->M0_CGC,PesqPict("SA1", "A1_CGC"))
cTitulo  := OemtoAnsi(STR0020) //"R E G I S T R O    D E   "
If lVenda
	cTitulo += OemtoAnsi(STR0022)//"V E N T A S"
Else
	cTitulo := cTitulo + OemtoAnsi(STR0021)//"C O M P R A S"
EndIf

nPagina := nPagina + 1
@ 02,000 PSAY OemToAnsi(STR0023) //"Empresa:"
@ 02,010 PSAY cEmpresa
@ 02,112 PSAY OemToAnsi(STR0024)//"Pagina Nro.:"
@ 02,125 PSAY StrZero(nPagina,6)

@ 03,000 PSAY OemToAnsi(STR0025)//"Ruc:"
@ 03,010 PSAY cRucEmp

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
// COMPRAS
//             0         1         2         3         4         5         6         7         8         9        10         11       12        13        14        15        16        17
//             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//					 FECHA - TD -COMP ---- POLIZA ---  ---- RUC ----- --------- PROVEEDOR ---------- SER - FACTURA - -- EXONERADOS --- ---- BASE IMP.--- ------ IGV ------ ------ TOTAL -------
//					99/99/99 xx xxxxx xxxxxxxxxxxxxxxx xxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxx xxxxxxxxxxx 99,999,999,999.99 99,999,999,999.99 99,999,999,999.99 9,999,999,999,999.99 

// VENDAS
//             0         1         2         3         4         5         6         7         8         9        10         11       12        13        14        15        16        17
//             012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//					 FECHA - TD -- DOCUMENTO - REF.DOC. ---------- CLIENTE ----------- ---- RUC ----- ---- BASE IMP.---  VENTA NO GRAVADA ------ IGV ------- -- IMPORTE TOTAL ---
//					99/99/99 xx xxxxxxxxxxxxxx XXXXXXXX xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxx 99,999,999,999.99 99,999,999,999.99 999,999,999,999.99 9,999,999,999,999.99 

IF lVenda
	@ 08,000 PSAY OemToAnsi(STR0028) // FECHA - TD -- DOCUMENTO - REF.DOC. ---------- CLIENTE ----------- ---- RUC ----- ---- BASE IMP.---  VENTAS NO GRAVADA ----- IGV ------- -- IMPORTE TOTAL ---
ELSE
	@ 08,000 PSAY OemToAnsi(STR0029) // FECHA - TD -COMP ---- POLIZA ---  ---- RUC ----- --------- PROVEEDOR ---------- SER - FACTURA - -- EXONERADOS --- ---- BASE IMP.--- ------ IGV ------ ------ TOTAL -------
ENDIF

nLin := 10

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � R020Rod  �Autor  �Jose Lucas          � Data �  06/07/98   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rodape do Libro de IGV ( Compras e Ventas ).               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LibrPer                                                    ���
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

IF !lVenda
	@ nLin,114 PSAY nTotalBas	Picture CPICTVAL1
	@ nLin,132 PSAY nTotalImp	Picture CPICTVAL1
	@ nLin,151 PSAY nTotalVlr	Picture CPICTVAL2
ELSE
	@ nLin,081 PSAY nTotalBas	Picture CPICTVAL1
	@ nLin,118 PSAY nTotalImp	Picture CPICTVAL1
	@ nLin,137 PSAY nTotalVlr	Picture CPICTVAL2
ENDIF

nLin := nLin +1

If  !(lFinRel)
	R020Cab()
	@ nLin,000 PSAY OemToAnsi(STR0031) //"Transporte :"
	IF !lVenda
		@ nLin,114 PSAY nTotalBas	Picture CPICTVAL1
		@ nLin,132 PSAY nTotalImp	Picture CPICTVAL1
		@ nLin,151 PSAY nTotalVlr	Picture CPICTVAL2
	ELSE
		@ nLin,081 PSAY nTotalBas	Picture CPICTVAL1
		@ nLin,118 PSAY nTotalImp	Picture CPICTVAL1
		@ nLin,137 PSAY nTotalVlr	Picture CPICTVAL2
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
���Uso       � LibrPer                                                    ���
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
		
		@ 00   ,000	PSAY aDriver[5]
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

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �AjustaSX1 �Autor  � Sergio S. Fuzinaka � Data �  30.05.06   ���
�������������������������������������������������������������������������͹��
���Descricao �Ajusta o Grupo de Perguntas                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSX1(cPerg)

PutSx1(cPerg,"01","Data Inicio","Fecha Inicio","From Date","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
PutSX1(cPerg,"02","Data Fim","Fecha Fin","To Date","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
PutSx1(cPerg,"03","Do Livro","Libro de","From Fiscal Books","mv_ch3","N",1,0,0,"C","","","","","mv_par03","Vendas","Ventas","Sales","","Compras","Compras","Purchase")

Return
