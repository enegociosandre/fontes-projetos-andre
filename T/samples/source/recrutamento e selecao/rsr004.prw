#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "RSR004.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � RSR004   � Autor � Eduardo Ju            � Data � 14/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Avaliacoes Realizadas Pelo Candidato          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RSR004                                                     ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���			   �		�	   �										  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function RSR004()

Local oReport
Local aArea := GetArea()

If FindFunction("TRepInUse") .And. TRepInUse()	//Verifica se relatorio personalizal esta disponivel
	//��������������������������������������������������������������Ŀ
	//� Verifica as perguntas selecionadas                           �
	//����������������������������������������������������������������
	RS04ARSX1()		//Criacao do Pergunte (SX1)
	Pergunte("RS04AR",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	
Else
	U_RSR004R3()	
EndIf  

RestArea( aArea )

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ReportDef() � Autor � Eduardo Ju          � Data � 14.07.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Definicao do Componente de Impressao do Relatorio           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function ReportDef()

Local oReport
Local oSection1	
Local oSection2

#IFNDEF TOP                 
	Local cAliasQry1 := ""
	Local cAliasQry := "SQR"
#ELSE	
	Local cAliasQry := GetNextAlias()
	Local cAliasQry1 := GetNextAlias()
#ENDIF 	         

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//��������������������������������������������������������������������������
oReport:=TReport():New("RSR004",STR0003,"RS04AR",{|oReport| PrintReport(oReport,cAliasQry,cAliasQry1)},STR0001+" "+STR0002)	//"Testes Realizados"#"Este programa tem como objetivo imprimir os testes realizados conforme parametros selecionados."
Pergunte("RS04AR",.F.) 
                                             
//����������������������������������������Ŀ
//� Criacao da Primeira Secao: Candidato   �
//������������������������������������������ 
oSection1 := TRSection():New(oReport,STR0009,{"SQR","SQG","SQQ"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection1:SetTotalInLine(.F.)  
oSection1:SetHeaderBreak(.T.)

TRCell():New(oSection1,"QR_FILIAL","SQR")				//Filial do Curriculo do Candidato
TRCell():New(oSection1,"QR_CURRIC","SQR",STR0010)		//Codigo do Curriculo do Candidato
TRCell():New(oSection1,"QG_NOME","SQG")					//Nome do Candidato
TRCell():New(oSection1,"QR_TESTE","SQR",STR0013)		//Codigo da Teste (Avaliacao)
TRCell():New(oSection1,"QQ_DESCRIC","SQQ","")			//Descricao da Avaliacao  

#IFNDEF TOP  
	TRPosition():New(oSection1,"SQG",1,{|| RhFilial("SQG",SQR->QR_FILIAL) + SQR->QR_CURRIC})
	TRPosition():New(oSection1,"SQQ",1,{|| RhFilial("SQQ",SQR->QR_FILIAL) + SQR->QR_TESTE})  
#ENDIF  

//���������������������������������������Ŀ
//� Criacao da Segunda Secao: Questoes    �
//����������������������������������������� 
oSection2:= TRSection():New(oSection1,STR0011,{"SQR"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection2:SetTotalInLine(.F.)  
oSection2:SetHeaderBreak(.T.)
oSection2:SetLeftMargin(2)	//Identacao da Secao
 
TRCell():New(oSection2,"QR_QUESTAO","SQR")				//Questao   
TRCell():New(oSection2,"QR_ALTERNA","SQR")				//Alternativa Selecionada   

#IFNDEF TOP
	TRCell():New(oSection2,"QO_PONTOS","SQO",STR0012,,,,{|| Rs004Pontos(cAliasQry) }) //Pontos de cada alternativa da questao
#ELSE
	TRCell():New(oSection2,"QO_PONTOS","SQO",STR0012) //Pontos de cada alternativa da questao
#ENDIF

#IFNDEF TOP 
	TRPosition():New(oSection2,"SQO",1,{|| RhFilial("SQO",SQR->QR_FILIAL) + SQR->QR_QUESTAO})   
#ENDIF 	

oSection2:SetTotalText({|| STR0014 })  //Nota
TRFunction():New(oSection2:Cell("QO_PONTOS"),/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)

Return oReport  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ReportDef() � Autor � Eduardo Ju          � Data � 07.07.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao do Relatorio                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function PrintReport(oReport,cAliasQry,cAliasQry1)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local cFiltro 	:= ""

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  Filial                                   � 
//� mv_par02        //  Curriculo                                � 
//� mv_par03        //  Teste                                    � 
//� mv_par04        //  Nota De                                  � 
//� mv_par05        //  Nota Ate                                 � 
//� mv_par06        //  Relatorio: Analitico ou Sintetico        � 
//����������������������������������������������������������������

#IFNDEF TOP
	//������������������������������������������������������Ŀ
	//� Transforma parametros Range em expressao (intervalo) �
	//��������������������������������������������������������
	MakeAdvplExpr("RS04AR")	                                  

If !Empty(mv_par08)
	cFiltroSRA += Iif(!Empty(cFiltroSRA)," .And. ","")
	cFiltroSRA += 'RA_CATFUNC $ "' + mv_par08 + '"'	//Categoria do Funcionario 
EndIf   
	
	If !Empty(mv_par01)	//QR_FILIAL
		cFiltro:= mv_par01
	EndIf  
		
	If !Empty(mv_par02)	//QR_CURRIC
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += mv_par02
	EndIf  
		
	If !Empty(mv_par03)	//QR_TESTE
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += mv_par03 
	EndIf  
			
	oSection1:SetFilter(cFiltro)
		       
	//���������������������������Ŀ
	//� Condicao para Impressao   �
	//�����������������������������
	oSection1:SetLineCondition({|| Rs004Nota(cAliasQry) })
	oSection2:SetParentFilter({|cParam| SQR->QR_CURRIC+SQR->QR_TESTE == cParam},{|| SQR->QR_CURRIC+SQR->QR_TESTE})
	               
	If mv_par06 = 2	//Sintetico Obs.: Apresenta apenas Nota  
		oSection2:Hide() 		
		oSection2:Cell("QR_QUESTAO"):HideHeader()
		oSection2:Cell("QR_ALTERNA"):HideHeader()
		oSection2:Cell("QO_PONTOS"):HideHeader()
	EndIf
	
	oReport:SetMeter(SQR->(LastRec()))	   
	
	oSection1:Print() //Imprimir   
#ELSE	
	//����������������������������������������������Ŀ
	//� Transforma parametros Range em expressao SQL �
	//������������������������������������������������
	MakeSqlExpr("RS04AR")    
	
	//-- Filtragem do relat�rio
	//-- Query do relat�rio da secao 1
	lQuery := .T.         
	cOrder := "%QR_FILIAL,QR_CURRIC,QR_TESTE%"	
		
	oReport:Section(1):BeginQuery()	

	BeginSql Alias cAliasQry
		
	SELECT DISTINCT	QR_FILIAL,QR_CURRIC,QG_NOME,QR_TESTE
				
		FROM 	%table:SQR% SQR 
		
		LEFT JOIN %table:SQG% SQG
			ON QG_FILIAL = %xFilial:SQG%
			AND QG_CURRIC = QR_CURRIC
			AND SQG.%NotDel%
		LEFT JOIN %table:SQQ% SQQ
			ON QQ_FILIAL = %xFilial:SQQ%
			AND QQ_TESTE = QR_TESTE
			AND SQQ.%NotDel%    
		
		WHERE QR_FILIAL = %xFilial:SQR% AND 
			SQR.%NotDel%
		ORDER BY %Exp:cOrder%                 		
		
	EndSql
	
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery({mv_par01,mv_par02,mv_par03})	/*Array com os parametros do tipo Range*/

	BEGIN REPORT QUERY oReport:Section(1):Section(1)

	BeginSql Alias cAliasQry1
		
	SELECT QR_QUESTAO,QR_ALTERNA,(QR_RESULTA*QO_PONTOS)/100 AS QO_PONTOS
				
		FROM 	%table:SQR% SQR, %table:SQO% SQO
		
		WHERE QR_FILIAL = %xFilial:SQR% AND QO_FILIAL = %xFilial:SQO% AND
			QR_CURRIC = %report_param:(cAliasQry)->QR_CURRIC% AND
			QR_TESTE = %report_param:(cAliasQry)->QR_TESTE% AND
			QO_FILIAL = QR_FILIAL AND
			QO_QUESTAO = QR_QUESTAO AND
			SQR.%NotDel% AND
			SQO.%NotDel%
		ORDER BY %Exp:cOrder%
		
	EndSql

	END REPORT QUERY oReport:Section(1):Section(1)

	//�������������������������������������������Ŀ         																																																																																
	//� Inicio da impressao do fluxo do relat�rio �
	//���������������������������������������������
 	oReport:SetMeter(SQR->(LastRec()))

	//���������������������������Ŀ
	//� Condicao para Impressao   �
	//�����������������������������
	oSection1:SetLineCondition({|| Rs004Nota(cAliasQry,oReport:Section(1):Section(1)) })
	               
	If mv_par06 = 2	//Sintetico Obs.: Apresenta apenas Nota
		oSection2:Hide()
		oSection2:Cell("QR_QUESTAO"):HideHeader()
		oSection2:Cell("QR_ALTERNA"):HideHeader()
		oSection2:Cell("QO_PONTOS"):HideHeader()
	EndIf
	
	oReport:SetMeter(SQR->(LastRec()))	   
	
	oSection1:Print() //Imprimir   
	
#ENDIF

Return Nil

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Rs004Pontos � Autor � Eduardo Ju          � Data � 29.08.06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Calculo da Nota                                             ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � APDR50                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function Rs004Pontos(cAliasQry)

Local nPontos 	:= 0
Local cSvAlias 	:= Alias()  

#IFNDEF TOP                 
	nPontos:= ( (SQO->QO_PONTOS * (cAliasQry)->QR_RESULTA) / 100 )
#ELSE	
	nPontos:= ( ((cAliasQry)->QO_PONTOS * (cAliasQry)->QR_RESULTA) / 100 )
#ENDIF 	 

DbSelectArea(cSvAlias)

Return nPontos  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Rs004Nota   � Autor � Eduardo Ju          � Data � 29.08.06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Impressao da Nota                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RSR004                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function Rs004Nota(cAliasQry,oPontos)

Local nNota 	:= 0
Local cSvAlias 	:= Alias()
Local lNota		:= .F.

#IFNDEF TOP
	Local cChave 	:= (cAliasQry)->QR_CURRIC + (cAliasQry)->QR_TESTE  
	Local nPontos 	:= 0  
	Local nRecno

	DbSelectArea(cAliasQry)
	DbSetOrder(1)
	nRecno := Recno()
	
	While !Eof() .And. ((cAliasQry)->QR_CURRIC + (cAliasQry)->QR_TESTE == cChave)
	  		
		// Buscar Valor das Alternativas selecionadas
		dbSelectArea("SQO")
		dbSetOrder(1)
		cFil := If(xFilial() == "  ",xFilial(),(cAliasQry)->QR_FILIAL)
		nPontos := 0
		If dbSeek( cFil + (cAliasQry)->QR_QUESTAO )		 
			nPontos:= ( (SQO->QO_PONTOS * (cAliasQry)->QR_RESULTA) / 100 )
		EndIf   
		nNota 	+= nPontos 
		cCurric := (cAliasQry)->QR_CURRIC
		cTeste  := (cAliasQry)->QR_TESTE
		
		dbSelectArea( (cAliasQry) )
		dbSetOrder(1)
		dbSkip()
	EndDo
#ELSE
	oPontos:ExecSql()
	While !Eof()
		nNota += (oPontos:cAlias)->QO_PONTOS
		DbSkip()
	End
#ENDIF

If nNota >= mv_par04 .And.  nNota <= mv_par05
	lNota	:= .T.
EndIf 

#IFNDEF TOP
	If lNota
		DbGoTo(nRecno)
	EndIf
#ENDIF
 
DbSelectArea(cSvAlias)

Return lNota    


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �RS04ARSX1 � Autor �Eduardo Ju             � Data � 28.08.06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Criacao do Pergunte RS04AR no Dicionario SX1                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       �RS04ARSX1                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/ 
Static Function RS04ARSX1()             

Local aRegs		:= {} 
Local cPerg		:= "RS04AR"  
Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}   
Local cHelp		:= ""

aHelp := {	"Informe intervalo de filiais que ",;
			"deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de sucursales que ",;
			"desea considerar para impresion del ",;
			"informe" }
aHelpI:= {	"Enter branch range to be considered ",;
			"to print report." }
cHelp := ".RHFILIAL."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
�����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo    Ordem   Pergunta Portugues      Pergunta Espanhol           Pergunta Ingles             Variavel    Tipo    Tamanho     Decimal Presel  GSC     Valid           Var01       Def01               DefSPA1             DefEng1             Cnt01               Var02   Def02               DefSpa2             DefEng2         Cnt02       Var03   Def03               DefSpa3             DefEng3         Cnt03   Var04   Def04       DefSpa4     DefEng4     Cnt04   Var05   Def05       DefSpa5     DefEng5     Cnt05   XF3   GrgSxg cPyme  aHelpPor    aHelpEng    aHelpSpa    cHelp  �
�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"01"	,"Filial?"	   			,"�Sucursal?"   			,"Branch?"				    ,"mv_ch1"  	,"C"	,99			,0		,0		,"R"	,""			    ,"mv_par01"	,""					,""					,""					,"QR_FILIAL"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"XM0",""    ,"S"	,{}			,{}			,{}			,cHelp})


aHelp := {	"Informe o intervalo de curriculo que ",;
			"deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de Curriculo que ",;
			"desea considerar para impresion del ",;
			"informe" }
aHelpI:= {	"Enter resume range to be considered ",;
			"to print report." }
cHelp := ".RS04AR02."
/*
������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"02"	,"Curriculo ?"				,"�Curriculo?"					,"Resume?"	 			,"mv_ch2"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par02"	,""			   		,""					,""					,"QR_CURRIC"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"SQG","","S"	,aHelp		,aHelpI			,aHelpE			,cHelp})

aHelp := {	"Informe o intervalo do teste que deseja considerar para impressao do relatorio."}

aHelp := {	"Informe o intervalo do teste que ",;
			"deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de prueba que ",;
			"desea considerar para impresion del ",;
			"informe" }
aHelpI:= {	"Enter test range to be considered ",;
			"to print report." }
cHelp := ".RS04AR03."
/*
������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"03"	,"Teste?"	   				,"�Prueba?"    				,"Test?"				,"mv_ch3"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par03"	,""					,""					,""					,"QR_TESTE"			,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"SQQ"	,"","S"	,aHelp		,aHelpI			,aHelpE			,cHelp})

aHelp := {	"Informe notas inicial que ",;
			"deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe notas inicial que ",;
			"desea considerar para impresion del ",;
			"informe" }
aHelpI:= {	"Enter note initial to be considered ",;
			"to print report." }
cHelp := ".RS04AR04."
/*
������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"04"	,"Nota De?"				,"�De Nota?"					,"From Note?"			,"mv_ch4"  	,"N"	,6			,2		,0		,"G"	,""			,"mv_par04"	,""					,""					,""					,""					,""		,""			   		,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""	    ,"","S"	,aHelp		,aHelpI			,aHelpE			,cHelp})

aHelp := {	"Informe nota final que ",;
			"deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe notas final que ",;
			"desea considerar para impresion del ",;
			"informe" }
aHelpI:= {	"Enter note final to be considered ",;
			"to print report." }
cHelp := ".RS04AR05."
/*
������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"05"	,"Nota Ate ?"				,"�A Nota?"					,"To Note?"			,"mv_ch5"  	,"N"	,6			,2		,0		,"G"	,""			,"mv_par05"	,""					,""					,""					,""					,""		,""			   		,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""	    ,"","S"	,aHelp		,aHelpI			,aHelpE			,cHelp})

/*
������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"06"	,"Relatorio  ?"	   			,"�Informe ?"     				,"Report ?"				,"mv_ch6"  	,"N"	,1			,0		,1		,"C"	,""			,"mv_par06"	,"Analitico"		,"Analitico"		,"Detailed"	   		,""					,""		,"Sintetico"   		,"Sintetico"		,"Summarized"	,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""	,"","S"	,{}			,{}			,{}			,'.RHTPREL.'})              


/*
������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/

ValidPerg(aRegs,cPerg)    

Return Nil

/*
PROGRAMA FONTE ORIGINAL ABAIXO
*/

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RSR004    � Autor �Emerson Grassi Rocha� Data �  31/10/00   ���
�������������������������������������������������������������������������͹��
���Descricao � Imprime Testes realizados pelos candidatos.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SigaRsp                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RSR004R3()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("AT_PRG,WCABEC0,WCABEC1,CCABEC1,CONTFL,LI,NPAG")
SetPrvt("NTAMANHO,CTIT,AREGS,TITULO,WNREL,NORDEM")
SetPrvt("CARQDBF,AFIELDS,CINDCOND,CARQNTX,CINICIO,CFIM")
SetPrvt("CFIL,NTOTGVL,NTOTGHR")
SetPrvt("CAUXCURSO,CAUXTURMA,LRET")
SetPrvt("LOK,CCENTRO,CCURSO,CCALEND,CTURMA,CDESCCUR,CDescCal,CAUXDET,DET")
SetPrvt("NNOTA,NPONTOS,CCHAVE,CFIL,CCURRIC,CTESTE,CQUESTAO,LFIRST,CALTERNA,NRECNO")

aOrd 	:= {}
cDesc1  := OemtoAnsi(STR0001) //"Este programa tem como objetivo imprimir relatorio "
cDesc2  := OemtoAnsi(STR0002) //"de acordo com os parametros informados pelo usuario."
cDesc3  := OemtoAnsi(STR0003) //"Testes realizados"
aRegs	:= {}
cPerg	:= "RSR04A"
cString := "SQD"
Titulo  := OemtoAnsi(STR0003) //"Testes realizados"
lEnd  	:= .F.
nTamanho:= "M"
nomeprog:= "RSR004" // Nome do programa para impressao no cabecalho
aReturn := { STR0005, 1, STR0006, 2, 2, 1, "", 1}	//"Zebrado"###"Administracao"
nLastKey:= 0
wnrel   := "RSR004" // Nome do arquivo usado para impressao em disco
cCabec  := ""
At_prg  := "RSR004"
WCabec0 := 1
Contfl  := 1
Li      := 0
Colunas := 132

dbSelectArea("SQD")
dbSetOrder(1)

// Forca a inclusao da pergunte
//�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
//�  			  Grupo   	Ordem		Pergunta               		PerSpa	PerEng	Variavel		Tipo	Tam.	Dec.	Presel	GSC	Valid				Var01			Def01				DefSpa	DefEng	Cnt01				Var02		Def02				DefSpa	DefEng	Cnt02	Var03	Def03	DefSpa	DefEng	Cnt03	Var04	Def04	DefSpa	DefEng	Cnt04	Var05	Def05	DefSpa	DefEng	Cnt05	XF3		GRPSXG �
//���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������



//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("RSR04A",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  Filial  De                               �
//� mv_par02        //  Filial  Ate                              �
//� mv_par03        //  Curriculo De                             �
//� mv_par04        //  Curriculo Ate                            �
//� mv_par05        //  Teste De                                 �
//� mv_par06        //  Teste Ate                                �
//� mv_par07        //  Nota De                                  �
//� mv_par08        //  Nota Ate                                 �
//� mv_par09        //  Relatorio: Analitico / Sintetico         �
//����������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel 	:= SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,nTamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus({|lEnd| Relato()},Titulo)
Return

//�����������������
//� Funcao Relato �
//�����������������
Static Function Relato()

mv_par01:= If(xFilial("SQR") == "  ","  ",mv_par01)

If mv_par09 == 2 // Sintetico 

	WCabec1 			:= STR0007 //"Filial Curriculo Nome                            Teste  Nota"
	
	dbSelectArea("SQR")
	dbSetOrder(1)
	dbSeek(mv_par01+mv_par03,.T.)
	cInicio	:= "SQR->QR_FILIAL + SQR->QR_CURRIC" 
	cFim	:= mv_par02 + mv_par04

	SetRegua(RecCount())

	While !Eof() .And. &cInicio <= cFim

		If SQR->QR_FILIAL < mv_par01 .Or. SQR->QR_FILIAL > mv_par02 .Or.;
			SQR->QR_CURRIC < mv_par03 .or. SQR->QR_CURRIC > mv_par04 .Or.;
			SQR->QR_TESTE < mv_par05 .Or. SQR->QR_TESTE > mv_par06
			dbSkip()
			Loop
		EndIf              
		nNota 	:= 0
	   	cChave 	:= SQR->QR_CURRIC + SQR->QR_TESTE
		While !Eof() .And. (SQR->QR_CURRIC + SQR->QR_TESTE == cChave)
  		
			// Buscar Valor das Alternativas selecionadas
			dbSelectArea("SQO")
			dbSetOrder(1)
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)
			nPontos := 0
			If dbSeek( cFil + SQR->QR_QUESTAO )
				 nPontos := ( SQO->QO_PONTOS * SQR->QR_RESULTA / 100 )
			EndIf   
			nNota 	+= nPontos 
			cCurric := SQR->QR_CURRIC
			cTeste  := SQR->QR_TESTE
			
			dbSelectArea("SQR")
			dbSetOrder(1)
			dbSkip()
		EndDo
		                                           
		If nNota >= mv_par07 .And. nNota  <= mv_par08
		                                       
			// Buscar Teste
			dbSelectArea("SQQ")
			dbSetOrder(1)
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)			
			dbSeek( cFil + cTeste )
			
			// Buscar Curriculo
			dbSelectArea("SQG")
			dbSetOrder(1)  
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)
			dbSeek( cFil + cCurric )

   		// Impressao de detalhe
			DET := "  "
			DET := DET + SQG->QG_FILIAL 	+ Space(05)
			DET := DET + SQG->QG_CURRIC 	+ Space(02)
			DET := DET + SQG->QG_NOME 	+ Space(01)
			DET := DET + cTeste +" - "+ SQQ->QQ_DESCRIC + Space(01)
			DET := DET + Str(nNota,6,2)

			IMPR(DET,"C")
    	EndIf
      
		dbSelectArea("SQR")
		dbSetOrder(1)
	Enddo
	
Else // Analitico

	WCabec1 			:= STR0008 //"Filial Curriculo Nome                            Teste  Questao Alternativa Pontos"

	dbSelectArea("SQR")
	dbSetOrder(1)
	dbSeek(mv_par01+mv_par03,.T.)
	cInicio	:= "SQR->QR_FILIAL + SQR->QR_CURRIC" 
	cFim	:= mv_par02 + mv_par04

	SetRegua(RecCount())

	While !Eof() .And. &cInicio <= cFim

		If SQR->QR_FILIAL < mv_par01 .Or. SQR->QR_FILIAL > mv_par02 .Or.;
			SQR->QR_CURRIC < mv_par03 .or. SQR->QR_CURRIC > mv_par04 .Or.;
			SQR->QR_TESTE < mv_par05 .Or. SQR->QR_TESTE > mv_par06
			dbSkip()
			Loop
		EndIf   
		
		// Verificar a Nota do Candidato
		nRecno 	:= Recno()      
		nNota		:= 0                   
		cChave 	:= SQR->QR_CURRIC + SQR->QR_TESTE
		While !Eof() .And. (SQR->QR_CURRIC + SQR->QR_TESTE == cChave)
  		
			// Buscar Valor das Alternativas selecionadas
			dbSelectArea("SQO")
			dbSetOrder(1)
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)
			nPontos := 0
			If dbSeek( cFil + SQR->QR_QUESTAO )
				 nPontos := ( SQO->QO_PONTOS * SQR->QR_RESULTA / 100 )
			EndIf   
			nNota 	+= nPontos 

			dbSelectArea("SQR")
			dbSetOrder(1)
			dbSkip()
		EndDo    
		If nNota >= mv_par07 .And. nNota  <= mv_par08
			dbGoto(nRecno)
		Else
			Loop	
		EndIf	
		//------------		
		
		nNota 	:= 0           
	   	cChave 	:= SQR->QR_CURRIC + SQR->QR_TESTE
	   	lFirst	:= .T.
		While !Eof() .And. (SQR->QR_CURRIC + SQR->QR_TESTE == cChave)
		
			// Buscar Valor das Alternativas selecionadas
			dbSelectArea("SQO")
			dbSetOrder(1)
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)
			nPontos := 0
			If dbSeek( cFil + SQR->QR_QUESTAO )
				nPontos := ( SQO->QO_PONTOS * SQR->QR_RESULTA / 100 )
			EndIf     
			nNota		+= nPontos
			cCurric 	:= SQR->QR_CURRIC
			cTeste  	:= SQR->QR_TESTE
			cQuestao 	:= SQR->QR_QUESTAO
			cAlterna	:= SQR->QR_ALTERNA

			// Buscar Teste
			dbSelectArea("SQQ")
			dbSetOrder(1)
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)			
			dbSeek( cFil + cTeste )

			// Buscar Curriculo
			dbSelectArea("SQG")
			dbSetOrder(1)  
			cFil := If(xFilial() == "  ",xFilial(),SQR->QR_FILIAL)
			dbSeek( cFil + cCurric )
	
   			// Impressao de detalhe
	   		If lFirst
				DET := "  "
				DET := DET + SQG->QG_FILIAL 	+ Space(05)
				DET := DET + SQG->QG_CURRIC 	+ Space(02)
				DET := DET + SQG->QG_NOME 	+ Space(01)
				DET := DET + cTeste +" - "+ SQQ->QQ_DESCRIC + Space(04)
			Else 
				DET := Space(88)
			EndIf	
			DET := DET + cQuestao 			+ Space(08)
			DET := DET + cAlterna			+ Space(05)			
			DET := DET + Str(nPontos,6,2)

			IMPR(DET,"C")
         	lFirst := .F.
         
			dbSelectArea("SQR")
			dbSetOrder(1)
			dbSkip()
		EndDo    
		IMPR("","C")
		IMPR("Total de Pontos: "+Space(89)+Str(nNota,6,2),"C")
		IMPR(Repl("-",Colunas),"C")
	Enddo

EndIf

// Fim do Relatorio
IMPR("","F")

Set Device To Screen

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil
