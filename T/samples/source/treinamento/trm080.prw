#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TRM080.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � TRM080   � Autor � Eduardo Ju            � Data � 07/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Avaliacoes Realizadas                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � TRM080                                                     ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���			   �		�	   �										  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function TRM080()

Local oReport
Local aArea := GetArea()

If FindFunction("TRepInUse") .And. TRepInUse()	//Verifica se relatorio personalizal esta disponivel
	//��������������������������������������������������������������Ŀ
	//� Verifica as perguntas selecionadas                           �
	//����������������������������������������������������������������
	TR080RSX1()		//Criacao do Pergunte (SX1)
	Pergunte("TR080R",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	
Else
	U_TRM080R3()	
EndIf  

RestArea( aArea )

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ReportDef() � Autor � Eduardo Ju          � Data � 07.07.06 ���
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
Local oSection3
Local oSection4
Local oSection5
Local oSection6
Local oSection7
Local oSection8
Local oSection9
Local oSection10

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//��������������������������������������������������������������������������
oReport:=TReport():New("TRM080",STR0003,"TR080R",{|oReport| PrintReport(oReport)},STR0001+" "+STR0002)	//"Avaliacoes Realizadas"#"Este programa tem como objetivo imprimir os testes realizados conforme parametros selecionados."
Pergunte("TR080R",.F.) 
                                             
//���������������������������������������Ŀ
//� Criacao da Primeira Secao: Calendario � 
//����������������������������������������� 
oSection1 := TRSection():New(oReport,STR0009 + " (" + STR0024 + ")",{"RAI"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Calendario"	
oSection1:SetTotalInLine(.F.)    
oSection1:SetHeaderBreak(.T.)

TRCell():New(oSection1,"RAI_CALEND","RAI")				//Calendario de Treinamento
TRCell():New(oSection1,"RA2_DESC","RA2","")			//Descricado do Calendario
TRCell():New(oSection1,"RAI_CURSO","RAI")				//Curso
TRCell():New(oSection1,"RA1_DESC","RA1","")			//Descricao do Curso  
TRCell():New(oSection1,"RA2_SINON","RA2",STR0018)		//Sinonimo do Curso
TRCell():New(oSection1,"RA9_DESCR","RA9","")			//Descricao do Sinonimo do Curso
TRCell():New(oSection1,"RAI_TURMA","RAI")				//Turma   

TRPosition():New(oSection1,"RA2",1,{|| RhFilial("RA2",RAI->RAI_FILIAL)+ RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA})
TRPosition():New(oSection1,"RA1",1,{|| RhFilial("RA1",RAI->RAI_FILIAL)+ RAI->RAI_CURSO})
TRPosition():New(oSection1,"RA9",2,{|| RhFilial("RA9",RAI->RAI_FILIAL)+ RAI->RAI_CURSO})

//����������������������������������������Ŀ
//� Criacao da Segunda Secao: Funcionario  �
//������������������������������������������ 
oSection2 := TRSection():New(oSection1,STR0020,{"RAI"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)		//Funcionario	
oSection2:SetTotalInLine(.F.)
oSection2:SetHeaderBreak(.T.)
oSection2:SetLeftMargin(1)	//Identacao da Secao  
  
TRCell():New(oSection2,"RAI_FILIAL","RAI")				//Filial do Funcionario    
TRCell():New(oSection2,"RAI_MAT","RAI")					//Matricula do Funcionario
TRCell():New(oSection2,"RA_NOME","SRA")					//Nome do Funcionario
TRCell():New(oSection2,"RAI_TESTE","RAI")				//Codigo da Avaliacao
TRCell():New(oSection2,"QQ_DESCRIC","SQQ","")			//Descricao da Avaliacao  

TRPosition():New(oSection2,"SRA",1,{|| RhFilial("SRA",RAI->RAI_FILIAL)+ RAI->RAI_MAT})
TRPosition():New(oSection2,"SQQ",1,{|| RhFilial("SQQ",RAI->RAI_FILIAL)+ Alltrim(RAI->RAI_TESTE)})

//����������������������������������������Ŀ
//� Criacao da Terceira Secao: Questoes    �
//������������������������������������������ 
oSection3:= TRSection():New(oSection2,STR0021,{"RAI"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//Questoes	
oSection3:SetTotalInLine(.F.)   
oSection3:SetHeaderBreak(.T.)
oSection3:SetLeftMargin(2)	//Identacao da Secao  

TRCell():New(oSection3,"RAI_QUESTA","RAI")				//Questao   
TRCell():New(oSection3,"RAI_ALTERN","RAI",,,,,{|| CHR(Val(RAI->RAI_ALTERN)+96)})	//Alternativa Selecionada   
TRCell():New(oSection3,"QO_PONTOS","SQO",STR0015,"@E 999.99",,,{|| SQO->QO_PONTOS * RAI->RAI_RESULTA / 100 }) //Pontos de cada alternativa da questao

TRPosition():New(oSection3,"SQO",1,{|| RhFilial("SQO",RAI->RAI_FILIAL)+ RAI->RAI_QUESTA})

oSection3:SetTotalText({|| STR0012 }) //Total de Pontos 
TRFunction():New(oSection3:Cell("QO_PONTOS"),/*cId*/,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
 
//*** ANALITICO ***
//��������������������������������������Ŀ
//� Criacao da Quarta Secao: Calendario  � 
//���������������������������������������� 
oSection4 := TRSection():New(oReport,STR0009 + " (" + STR0025 + ")",{"RAI","RA2","RA1","RA9"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection4:SetTotalInLine(.F.) 
oSection4:SetHeaderBreak(.T.)

TRCell():New(oSection4,"RAI_CALEND","RAI")				//Calendario de Treinamento
TRCell():New(oSection4,"RA2_DESC","RA2","")			//Descricado do Calendario
TRCell():New(oSection4,"RAI_CURSO","RAI")				//Curso
TRCell():New(oSection4,"RA1_DESC","RA1","")			//Descricao do Curso  
TRCell():New(oSection4,"RA2_SINON","RA2",STR0018) 		//Sinonimo do Curso
TRCell():New(oSection4,"RA9_DESCR","RA9","")			//Descricao do Sinonimo do Curso
TRCell():New(oSection4,"RAI_TURMA","RAI")				//Turma        
TRPosition():New(oSection4,"RA2",1,{|| RhFilial("RA2",RAI->RAI_FILIAL)+ RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA})
TRPosition():New(oSection4,"RA1",1,{|| RhFilial("RA1",RAI->RAI_FILIAL)+ RAI->RAI_CURSO})
TRPosition():New(oSection4,"RA9",2,{|| RhFilial("RA9",RAI->RAI_FILIAL)+ RAI->RAI_CURSO})

//���������������������������������������Ŀ
//� Criacao da Quinta Secao: Funcionario  �
//����������������������������������������� 
oSection5 := TRSection():New(oSection4,STR0020,{"RAI","SRA","SQQ"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	
oSection5:SetTotalInLine(.F.)  
oSection5:SetHeaderBreak(.T.)
oSection5:SetLeftMargin(1)	//Identacao da Secao  
oSection5:OnPrintLine({|| oReport:GetFunction("TOTAL1"):ResetSection(),oReport:GetFunction("TOTAL2"):ResetSection(),oReport:GetFunction("TOTAL3"):ResetSection(),.T.})

TRCell():New(oSection5,"RAI_FILIAL","RAI")				//Filial do Funcionario    
TRCell():New(oSection5,"RAI_MAT","RAI")					//Matricula do Funcionario
TRCell():New(oSection5,"RA_NOME","SRA")					//Nome do Funcionario
TRCell():New(oSection5,"RAI_TESTE","RAI")				//Codigo da Avaliacao
TRCell():New(oSection5,"QQ_DESCRIC","SQQ","")			//Descricao da Avaliacao  

TRPosition():New(oSection5,"SRA",1,{|| RhFilial("SRA",RAI->RAI_FILIAL)+ RAI->RAI_MAT})
TRPosition():New(oSection5,"SQQ",1,{|| RhFilial("SQQ",RAI->RAI_FILIAL)+ Alltrim(RAI->RAI_TESTE)})

//�������������������������������������Ŀ
//� Criacao da Sexta Secao: Questoes    �
//��������������������������������������� 
oSection6:= TRSection():New(oSection5,STR0021,{"RAI","SQO"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//Questoes	
oSection6:SetTotalInLine(.F.)   
oSection6:SetHeaderBreak(.T.)
oSection6:SetLeftMargin(2)	//Identacao da Secao  

TRCell():New(oSection6,"RAI_QUESTA","RAI")			//Questao     
TRCell():New(oSection6,"QO_QUEST","SQO","",,110)	//Descricao da Questao
TRCell():New(oSection6,"QO_DMEMO","SQO","",,,,{|| MSMM(SQO->QO_QUEST,,,,3)})		//Descricao da Questao (Memo)

TRPosition():New(oSection6,"SQO",1,{|| RhFilial("SQO",RAI->RAI_FILIAL)+ RAI->RAI_QUESTA})

//������������������������������������������������������Ŀ
//� Criacao da Setima Secao: Resposta das Questoes (Pai) �
//�������������������������������������������������������� 
oSection7 := TRSection():New(oSection6,STR0022,{"RAI"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)		//Respostas
oSection7:SetTotalInLine(.F.)
oSection7:SetHeaderBreak(.T.)
oSection7:SetLeftMargin(3)	//Identacao da Secao    

//����������������������������������������������������������Ŀ
//� Criacao da Oitava Secao: Resposta Dissertativa (Filha 1) �
//������������������������������������������������������������
oSection8 := TRSection():New(oSection7,STR0023,{"RAI","SQO"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Resposta Dissertativa"	
oSection8:SetHeaderBreak(.T.)
oSection8:SetLeftMargin(3)	//Identacao da Secao  

TRCell():New(oSection8,"RAI_ALTERN","RAI",,,,,{|| CHR(Val(RAI->RAI_ALTERN)+96)})	//Alternativa Selecionada   
TRCell():New(oSection8,"RAI_MRESPO","RAI")	//Resposta da Questao
TRCell():New(oSection8,"RAI_MEMO1","RAI",Alltrim(STR0016),,150,,{|| MSMM(RAI->RAI_MRESPO,,,,3)})		//Descricao Resposta da Questao (Memo)
TRCell():New(oSection8,"QO_PONTOS","SQO",STR0015,"@E 999.99",6,,{|| SQO->QO_PONTOS * RAI->RAI_RESULTA / 100 }) //Pontos de cada alternativa da questao

oObj := TRFunction():New(oSection8:Cell("QO_PONTOS"),"TOTAL1", "SUM",,,,,.F.,	.T.,.F.,,)
oObj:Disable()     

TRPosition():New(oSection8,"SQO",1,{|| RhFilial("SQO",RAI->RAI_FILIAL)+ RAI->RAI_QUESTA})

//Nao imprime cod campo memo
oSection8:Cell("RAI_ALTERN"):Disable()  
oSection8:Cell("RAI_MRESPO"):Disable() 

//���������������������������������������������������������������Ŀ
//� Criacao da Nona Secao: Resposta por Selecao (Filha 2A) - RBL  �
//�����������������������������������������������������������������
oSection9 := TRSection():New(oSection7,STR0014 + " - " + STR0026,{"RBL", "SQO"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//Alternativas
oSection9:SetHeaderBreak(.T.)
oSection9:SetLeftMargin(3)	//Identacao da Secao  
	
TRCell():New(oSection9,"ALTSEL","   ","",,3,,{|| If ( RAI->RAI_ALTERN == RBL->RBL_ITEM,"(X)","( )" ) }) //Alternativa respondida
TRCell():New(oSection9,"RBL_ITEM","RBL",,,,,{|| CHR(Val(RBL->RBL_ITEM)+96)})	//Alternativa Selecionada 
TRCell():New(oSection9,"RBL_DESCRI","RBL",STR0014,,141)	//Alternativas
TRCell():New(oSection9,"QO_PONTOS","SQO",STR0015,"@E 999.99",6,,{|| SQO->QO_PONTOS * RAI->RAI_RESULTA / 100 }) //Pontos de cada alternativa da questao

oObj := TRFunction():New(oSection9:Cell("QO_PONTOS"),"TOTAL2", "SUM",,,,,.F.,.T.,.F.,,)
oObj:Disable()

TRPosition():New(oSection9,"SQO",1,{|| RhFilial("SQO",RAI->RAI_FILIAL)+ RAI->RAI_QUESTA})

//����������������������������������������������������������������Ŀ
//� Criacao da Decima Secao: Resposta por Selecao (Filha 2B) - SQP �
//������������������������������������������������������������������
oSection10 := TRSection():New(oSection7,STR0014,{"SQP", "SQO"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)		//Alternativas
oSection10:SetHeaderBreak(.T.)
oSection10:SetLeftMargin(3)	//Identacao da Secao  

TRCell():New(oSection10,"ALTSEL","   ","",,3,,{|| If ( RAI->RAI_ALTERN == SQP->QP_ALTERNA,"(X)","( )" ) }) //Alternativa respondida		
TRCell():New(oSection10,"QP_ALTERNA","SQP","",,,,{|| CHR(Val(SQP->QP_ALTERNA)+96)})	//Alternativa Selecionada 
TRCell():New(oSection10,"QP_DESCRIC","SQP",STR0014,,141)	//Alternativas
TRCell():New(oSection10,"QO_PONTOS","SQO",STR0015,"@E 999.99",6,,{|| If ( RAI->RAI_ALTERN == SQP->QP_ALTERNA, SQO->QO_PONTOS * RAI->RAI_RESULTA / 100,0) }) //Pontos de cada alternativa da questao

oObj := TRFunction():New(oSection10:Cell("QO_PONTOS"),"TOTAL3","SUM",,,,,.F.,.F.,.F.,,)
oObj:Disable()

oSection5:SetTotalText({|| STR0012 })  //"Total de Pontos"
TRFunction():New(oSection10:Cell("QO_PONTOS"),"TOTAL3","ONPRINT",,,,{|| oReport:GetFunction("TOTAL1"):SectionValue()+oReport:GetFunction("TOTAL2"):SectionValue()+oReport:GetFunction("TOTAL3"):SectionValue()},.T.,.F.,.F.,oSection5,)

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
Static Function PrintReport(oReport)

Local oSection1 := If ( mv_par10 = 1,(If(mv_par11 = 1, oReport:Section(2), oReport:Section(1))),oReport:Section(1) )
Local oSection2 := oSection1:Section(1) 
Local oSection3 := oSection2:Section(1)
Local oSection4 := oSection3:Section(1)
Local cFiltro 	:= ""

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  Filial                                   � 
//� mv_par02        //  Calendario                               � 
//� mv_par03        //  Curso                                    � 
//� mv_par04        //  Turma                                    � 
//� mv_par05        //  Matricula                                � 
//� mv_par06        //  Teste               					 � 
//� mv_par07        //  Nota De                                  � 
//� mv_par08        //  Nota Ate                                 � 
//� mv_par09        //  Tipo Avaliacao                           � 
//� mv_par10        //  Relatorio: Analitico / Sintetico         �
//� mv_par11        //  Imp.Todas Alternat.: Sim / Nao           �
//����������������������������������������������������������������
//������������������������������������������������������Ŀ
//� Transforma parametros Range em expressao (intervalo) �
//��������������������������������������������������������
MakeAdvplExpr("TR080R")	                                  

If !Empty(mv_par01)
	cFiltro:= mv_par01 
EndIf  
	
If !Empty(mv_par02)
	cFiltro += IIF(!Empty(cFiltro)," .And. ","")
	cFiltro += mv_par02 
EndIf  
	
If !Empty(mv_par03)
	cFiltro += IIF(!Empty(cFiltro)," .And. ","")
	cFiltro += mv_par03
EndIf  
	
If !Empty(mv_par04)
	cFiltro += IIF(!Empty(cFiltro)," .And. ","")
	cFiltro += mv_par04 
EndIf  	       
	
If !Empty(mv_par05)
	cFiltro += IIF(!Empty(cFiltro)," .And. ","") 
	cFiltro += mv_par05
EndIf   

If !Empty(mv_par06)
	cFiltro += IIF(!Empty(cFiltro)," .And. ","") 
	cFiltro += mv_par06 
EndIf  

If !Empty(mv_par09)
	cFiltro += IIF(!Empty(cFiltro)," .And. ","")
	cFiltro += mv_par09
EndIf  
	
oSection1:SetFilter(cFiltro)
	       
//���������������������������Ŀ
//� Condicao para Impressao   �
//�����������������������������
oSection2:SetParentFilter({|cParam| RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA == cParam},{|| RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA})
oSection3:SetParentFilter({|cParam| RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA+RAI->RAI_MAT+RAI->RAI_TESTE == cParam},{|| RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA+RAI->RAI_MAT+RAI->RAI_TESTE})

If mv_par10 == 1 .And. mv_par11 == 1	//Imprime Analitico e Todas as alternativas

	oSection4:SetParentFilter({|cParam| RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA+RAI->RAI_MAT+RAI->RAI_TESTE+RAI->RAI_QUESTA == cParam},{|| RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA+RAI->RAI_MAT+RAI->RAI_TESTE+RAI->RAI_QUESTA})
	oSection4:SetLineCondition({|| fCondResp(oSection3, oSection4) })	
EndIf 
             
If mv_par10 = 2 
	oSection3:Hide()
EndIf

oReport:SetMeter(RAI->(LastRec()))	
oSection1:Print() //Imprimir 

Return Nil

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �fCondResp() � Autor � Eduardo Ju          � Data � 07.07.06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Impressao da Resposta                                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fCondResp(oSection3, oSection4)

//Tipo de Resposta
If RAI->RAI_ALTERN == "00"	//Dissertativa 
	oSection4:Section(1):Enable()
	oSection4:Section(2):Disable()	//RBL
	oSection4:Section(3):Disable() //SQP
		
	oSection3:Cell("QO_QUEST"):SetLineBreak() //Impressao de campo Memo
	oSection3:Cell("QO_DMEMO"):SetLineBreak() //Impressao de campo Memo

	oSection4:Section(1):Cell("RAI_MEMO1"):SetLineBreak() //Impressao de campo Memo   	
	oSection4:Section(1):SetParentFilter({|cParam| RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA+RAI->RAI_MAT+RAI->RAI_TESTE+RAI->RAI_QUESTA == cParam},{|| RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA+RAI->RAI_MAT+RAI->RAI_TESTE+RAI->RAI_QUESTA})

Else //Alternativa	
	oSection4:Section(1):Disable()	//Dissertativa

	If RBL->( dbSeek( If(xFilial("RBL") == Space(2),Space(2),RAI->RAI_FILIAL) + SQO->QO_ESCALA ) )
		
		oSection4:Section(2):Enable()
		oSection4:Section(3):Disable()
		oSection4:Section(2):SetRelation({|| If(xFilial("RBL") == Space(2),Space(2),RAI->RAI_FILIAL) + SQO->QO_ESCALA }, "RBL",1,.T.)
		oSection4:Section(2):SetParentFilter({|cParam| RBL->RBL_FILIAL + RBL->RBL_ESCALA == cParam},{|| If(xFilial("RBL") == Space(2),Space(2),RAI->RAI_FILIAL) + SQO->QO_ESCALA})
	
	ElseIf SQP->( dbSeek( If(xFilial("SQP") == Space(2),Space(2),RAI->RAI_FILIAL) + RAI->RAI_QUESTAO ) )
		
		oSection4:Section(2):Disable()
		oSection4:Section(3):Enable()
		oSection4:Section(3):SetRelation({|| If(xFilial("SQP") == Space(2),Space(2),RAI->RAI_FILIAL) + RAI->RAI_QUESTAO }, "SQP",1,.T.)
		oSection4:Section(3):SetParentFilter({|cParam| SQP->QP_FILIAL + SQP->QP_QUESTAO == cParam},{|| If(xFilial("SQP") == Space(2),Space(2),RAI->RAI_FILIAL) + RAI->RAI_QUESTAO})
	
	EndIf
	
EndIf	

Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �TR080RSX1 � Autor �Eduardo Ju             � Data � 28.08.06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Criacao do Pergunte TR080R no Dicionario SX1                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       �TR080RSX1                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/ 
Static Function TR080RSX1()             

Local aRegs		:= {} 
Local cPerg		:= "TR080R" 
Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}   
Local cHelp		:= "" 

aHelp := {	"Informe intervalo de filiais que ",;
			"deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de sucursales que ",;
			"desea considerar para impresion ",;
			"del informe" }
aHelpI:= {	"Enter branch range to be considered ",;
			"to print report." }
cHelp := ".RHFILIAL."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*	������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
	�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
	��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"01"	,"Filial  ?"	   				,"�Sucursal ?"     				,"Branch ?"				,"mv_ch1"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par01"	,""					,""					,""					,"RAI_FILIAL"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"XM0"	,"","S"	,{}			,{}			,{}			,cHelp})

aHelp := {	"Informe intervalo de calendarios que ",;
			"deseja considerar para impressao do ",;
			"relatorio." }
aHelpE:= {	"Informe intervalo de calendarios que ",;
			"desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter Calendar range to be ",;
			"considered for printing the report." }
cHelp := ".RHCALEND."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*	������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
	�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
	��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"02"	,"Calendario  ?"				,"�Calendario ?"				,"Calendar ?"	 		,"mv_ch2"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par02"	,""			   		,""					,""					,"RAI_CALEND"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RA2"	,"","S"	,{}			,{}			,{}			,cHelp})

aHelp := {	"Informe intervalo de cursos que deseja ",;
			"considerar para impressao do relatorio. " }
aHelpE:= {	"Informe intervalo de cursos que desea ",;
			"considerar para impresion del informe. " }
aHelpI:= {	"Enter range of courses to be considered ",;
			"for printing the report." }
cHelp := ".RHCURSO."  
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)
/*	������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
	�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
	��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"03"	,"Curso  ?"	   				,"�Curso ?"     				,"Course ?"				,"mv_ch3"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par03"	,""					,""					,""					,"RAI_CURSO"		,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RA1"	,"","S"	,{}   ,{}   ,{}  ,cHelp})              

aHelp := {	"Informe intervalo da turma que ",;
			"deseja considerar para impressao do ",;
			"relatorio." }
aHelpE:= {	"Informe intervalo de grupos que ",;
			"desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter range of Class to be ",;
			"considered for printing the report." }
cHelp := ".RHTURMA."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*	������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
	�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
	��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"04"	,"Turma  ?"					,"�Grupo ?" 					,"Class ?"				,"mv_ch4"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par04"	,""					,""					,""					,"RAI_TURMA"		,""		,""			   		,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""		,"","S"	,{}			,{}			,{}			,cHelp})              

aHelp := {	"Informe intervalo de matriculas que ",;
			"deseja considerar para impressao do ",;
			"relatorio." }
aHelpE:= {	"Informe intervalo de matriculas que ",;
			"desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter registration range to be ",;
			"considered for printing the report." }
cHelp := ".RHMATRIC."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*	������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
	�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
	��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"05"	,"Matr�cula  ?"	   			,"�Matricula ?"					,"Registration ?"		,"mv_ch5"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par05"	,""					,""					,""					,"RAI_MAT" 			,""		,""					,""					,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"SRA"	,"","S"	,{}			,{}			,{}			,cHelp})              

aHelp := {	"Informe intervalo de testes que ",;
			"deseja considerar para impressao do ",;
			"relatorio." }
aHelpE:= {	"Informe intervalo de pruebas que ",;
			"desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter range of test to be ",;
			"considered for printing the report." }
cHelp := ".RHTESTE."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*	������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
	�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
	��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"06"	,"Teste  ?"   				,"�Test ?"    					,"Test ?"				,"mv_ch6"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par06"	,""					,""					,""					,"RAI_TESTE"		,""		,""					,""					,""				,""			,""		,""		   			,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"SQQ"	,"","S"	,{}			,{}			,{}			,cHelp})              

Aadd(aRegs,{cPerg	,"07"	,"Nota De ?"   				,"�A Nota ?"   					,"To Note ?"			,"mv_ch7"  	,"N"	,6			,2		,0		,"G"	,""			,"mv_par07"	,""					,""					,""					,""	   				,""		,""					,""					,""				,""			,""		,""		   			,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""		,"","S"	,{}			,{}			,{}			,'.TRM08013.'})              
Aadd(aRegs,{cPerg	,"08"	,"Nota Ate ?"   				,"�De Nota ?"   				,"From Note ?"			,"mv_ch8"  	,"N"	,6			,2		,0		,"G"	,""			,"mv_par08"	,""					,""					,""					,""	   				,""		,""					,""					,""				,""			,""		,""		   			,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""		,"","S"	,{}			,{}			,{}			,'.TRM08014.'})              

aHelp := {	"Informe intervalo do tipo da avaliacao  ",;
			"que deseja considerar para impressao    ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de Tipo de Evaluacion ",;
			"que desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter range of Evaluation Type to be ",;
			"considered for printing the report." }
cHelp := ".RHTIPAVA."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*	������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
	�           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel  GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01           Var02  	Def02    		DefSpa2         DefEng2	   	Cnt02  		Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  	GrgSxg  cPyme	aHelpPor	aHelpEng	aHelpSpa    cHelp            �
	��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
Aadd(aRegs,{cPerg	,"09"	,"Tipo Avaliacao  ?"			,"�Tipo de Evaluacion ?"		,"Evaluation Type ?"	,"mv_ch9"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par09"	,""					,""					,""					,"RAI_TIPO"			,""		,""					,""					,""				,""			,""		,""		   			,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,"RJ"	,"","S"	,{}			,{}			,{}			,cHelp})              

Aadd(aRegs,{cPerg	,"10"	,"Relatorio  ?"	   			,"�Informe ?"     				,"Report ?"				,"mv_cha"  	,"N"	,1			,0		,1		,"C"	,""			,"mv_par10"	,"Analitico"		,"Analitico"		,"Detailed"	   		,""					,""		,"Sintetico"   		,"Sintetico"		,"Summarized"	,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""		,"","S"	,{}			,{}			,{}			,'.RHTPREL.'})              
Aadd(aRegs,{cPerg	,"11"	,"Imp. Todas Alternativas  ?","�Impr. Todas Alternativas ?" 	,"Print All Choices ?"	,"mv_chb"  	,"N"	,1			,0		,1		,"C"	,""			,"mv_par11"	,"Sim"				,"Si"				,"Yes"	   			,""					,""		,"Nao"   			,"No"				,"No"			,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""		,"","S"	,{}			,{}			,{}			,'.TRM08018.'})              

ValidPerg(aRegs,cPerg)    

Return Nil

/*
PROGRAMA FONTE ORIGINAL ABAIXO
*/

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � TRM080R3 � Autor � Equipe R.H.			� Data � 23/08/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime Resultados Avaliacoes conf.parametros selecionados.���
�������������������������������������������������������������������������Ĵ��
���Uso       � RdMake                                                     ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���			   �	    �	   �										  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function TRM080R3()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("AT_PRG,WCABEC0,WCABEC1,CCABEC1,CONTFL,LI,NPAG")
SetPrvt("NTAMANHO,CTIT,TITULO,WNREL,NORDEM")
SetPrvt("CINICIO,CFIM,CFIL,CFIL2,LFIRST,LFIRST2")
SetPrvt("CCURSO,CCALEND,CTURMA,CDESCCUR,CDescCal,CAUXDET,DET")
SetPrvt("NNOTA,NPONTOS,CCHAVE,CCHAVE2,CMAT,CTESTE,CQUESTAO,CALTERNA,NRECNO")
SetPrvt("NITEM,I,CDESCR,NLINHA,CTIPO,CQUESTANT,CSINON,CDESCSI,NPOSITEM,ATOTAL") 

aOrd 	:= {}
cDesc1  := OemtoAnsi(STR0001) //"Este programa tem como objetivo imprimir relatorio "
cDesc2  := OemtoAnsi(STR0002) //"de acordo com os parametros informados pelo usuario."
cDesc3  := OemtoAnsi(STR0003) //"Avaliacoes realizadas"
cPerg	:= "TRM080"
cString := "RAI"
Titulo  := OemtoAnsi(STR0003) //"Avaliacoes realizadas"
lEnd  	:= .F.
nTamanho:= "M"
nomeprog:= "TRM080" // Nome do programa para impressao no cabecalho
aReturn := { STR0005, 1, STR0006, 2, 2, 1, "", 1}	//"Zebrado"###"Administracao"
nLastKey:= 0
wnrel   := "TRM080" // Nome do arquivo usado para impressao em disco
cCabec  := ""
At_prg  := "TRM080"
WCabec0 := 1
Contfl  := 1
Li      := 0
Colunas := 132

dbSelectArea("RAI")
dbSetOrder(1)

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("TRM080",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  Filial  De                               �
//� mv_par02        //  Filial  Ate                              �
//� mv_par03        //  Calendario De                            �
//� mv_par04        //  Calendario Ate                           �
//� mv_par05        //  Curso De                                 �
//� mv_par06        //  Curso Ate                                �
//� mv_par07        //  Turma De                                 �
//� mv_par08        //  Turma Ate                                �
//� mv_par09        //  Matricula De                             �
//� mv_par10        //  Matricula Ate                            �
//� mv_par11        //  Teste De                                 �
//� mv_par12        //  Teste Ate                                �
//� mv_par13        //  Nota De                                  �
//� mv_par14        //  Nota Ate                                 �
//� mv_par15        //  Tipo Avaliacao De                        �
//� mv_par16        //  Tipo Avaliacao Ate                       �
//� mv_par17        //  Relatorio: Analitico / Sintetico         �
//� mv_par18        //  Imp.Todas Alternat.: Sim / Nao           �
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

mv_par01:= If(xFilial("RAI") == Space(2),Space(2),mv_par01)

If mv_par17 == 2 // Sintetico 

	WCabec1	:= STR0007 //"Filial Matricula Nome                          Avaliacao                               Nota"

	dbSelectArea("RAI")
	dbSetOrder(1)
	dbSeek(mv_par01+mv_par03,.T.)
	cInicio	:= "RAI->RAI_FILIAL + RAI->RAI_CALEND" 
	cFim	:= mv_par02 + mv_par04 

	SetRegua(RecCount())

	While !Eof() .And. &cInicio <= cFim

		If 	RAI->RAI_FILIAL	< mv_par01 .Or. RAI->RAI_FILIAL 	> mv_par02 .Or.;
			RAI->RAI_CALEND	< mv_par03 .Or. RAI->RAI_CALEND 	> mv_par04 .Or.;
			RAI->RAI_CURSO 	< mv_par05 .Or. RAI->RAI_CURSO		> mv_par06 .Or.;
			RAI->RAI_TURMA 	< mv_par07 .Or. RAI->RAI_TURMA 		> mv_par08 .Or.;
			RAI->RAI_MAT 	< mv_par09 .Or. RAI->RAI_MAT 		> mv_par10 .Or.;
			RAI->RAI_TESTE 	< mv_par11 .Or. RAI->RAI_TESTE 		> mv_par12 .Or.;
			RAI->RAI_TIPO 	< mv_par15 .Or. RAI->RAI_TIPO	 	> mv_par16
			dbSkip()
			Loop
		EndIf              
		
		cChave2 	:= 	RAI->RAI_FILIAL + RAI->RAI_CALEND + ;
						RAI->RAI_CURSO + RAI->RAI_TURMA
		lFirst2 	:= .T.   
		aTotal		:= {}				
		While !Eof() .And. RAI->RAI_FILIAL + RAI->RAI_CALEND + ;
					RAI->RAI_CURSO + RAI->RAI_TURMA == cChave2

			nNota 		:= 0
			nItem 		:= 0
			cQuestAnt	:= ""
		   	cChave 	:= 	RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
	   					RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE 
					   	
			While !Eof() .And.(RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
							RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE == cChave)
	
				// Buscar Valor das Alternativas selecionadas
				dbSelectArea("SQO")
				dbSetOrder(1)
				cFil := If(xFilial("SQO") == Space(2),Space(2),RAI->RAI_FILIAL)
				nPontos := 0
				If dbSeek( cFil + RAI->RAI_QUESTAO )
					 nPontos := ( SQO->QO_PONTOS * RAI->RAI_RESULTA / 100 )
				EndIf   
				nNota 	+= nPontos 

				If RAI->RAI_QUESTAO != cQuestAnt
					cQuestAnt := RAI->RAI_QUESTAO
					nItem ++
				EndIf				                     
				
				cMat	:= RAI->RAI_MAT
				cTeste  := RAI->RAI_TESTE 
				cTipo 	:= RAI->RAI_TIPO 
				
				cCalend := RAI->RAI_CALEND
				cCurso	:= RAI->RAI_CURSO
				cTurma	:= RAI->RAI_TURMA
				 
				dbSelectArea("RA2")
				dbSetOrder(1)
				dbSeek(xFilial("RA2")+RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA)
				cSinon	:= RA2->RA2_SINON
				cDescSi	:= FDesc("RA9",cSinon,"RA9->RA9_DESCR",27)
				
				cDescCal:= FDesc("RA2",cCalend,"RA2_DESC")
				cDescCur:= FDesc("RA1",cCurso,"RA1_DESC",27)
				
				//----- Alimenta array com media do Treinamento
				cTipo 	:= RAI->RAI_TIPO 
		   		If cTipo == "AVA" .Or. cTipo == "EFI"
	        		nPosItem := Ascan(aTotal,{|x| x[1] == RAI->RAI_QUESTAO})
					If nPosItem == 0
						Aadd(aTotal, {RAI->RAI_QUESTAO, nPontos, 1})
					Else 
						aTotal[nPosItem][2] += nPontos
						aTotal[nPosItem][3] += 1
					EndIf
				EndIf
				//-----   			
				
				dbSelectArea("RAI")
				dbSetOrder(1)
				dbSkip()
			EndDo
				               
			If cTipo == "AVA" .Or. cTipo == "EFI"
				nNota := nNota / nItem
			EndIf
							                                           
			If nNota >= mv_par13 .And. nNota  <= mv_par14
		                                       
				// Buscar Avaliacao      
				If Len(Alltrim(cTeste)) == 3
					dbSelectArea("SQQ")
					cFil := If(xFilial("SQQ") == Space(2),Space(2),RAI->RAI_FILIAL)	
				Else 
					dbSelectArea("SQW") 
					cFil := If(xFilial("SQW") == Space(2),Space(2),RAI->RAI_FILIAL)						
				EndIf
				dbSetOrder(1)
						
				dbSeek( cFil + Alltrim(cTeste) )
			
				// Buscar Funcionario
				dbSelectArea("SRA")
				dbSetOrder(1)  
				cFil := If(xFilial("SRA") == Space(2),Space(2),SRA->RA_FILIAL)
				dbSeek( cFil + cMat )
	
	   			// Impressao de detalhe
	   			If lFirst2                          
					IMPR(Repl("-",Colunas),"C")
		   			DET	:= STR0009 +": "+cCalend+"-"+cDescCal +Space(01)+ STR0010+cCurso+"-"+cDescCur +Space(01)+ STR0018+": "+cSinon+"-"+cDescSi+Space(01)+ STR0011+cTurma //"Calendario: "#"Curso: "#"Sinonimo: "#"Turma: "
		   			IMPR(DET,"C")
					IMPR(Repl("-",Colunas),"C")
		   			lFirst2 := .F.
		   		EndIf

	   			DET := "  "
				DET += SRA->RA_FILIAL + Space(05)
				DET += SRA->RA_MAT + Space(02)
				DET += SRA->RA_NOME + Space(01)     
				If Len(Alltrim(cTeste)) == 3
					DET += cTeste +" - "+ Padr(SQQ->QQ_DESCRIC,30) + Space(01)
				Else
					DET += cTeste +" - "+ Padr(SQW->QW_DESCRIC,30) + Space(01)					
				EndIf
				DET += Str(nNota,6,2)
				IMPR(DET,"C")                
				
				If cCalend != RAI->RAI_CALEND
					IMPR("","C")	
				EndIf
	    	EndIf
      
			dbSelectArea("RAI")
			dbSetOrder(1)
		EndDo

		If cTipo == "AVA" .Or. cTipo == "EFI"
			Tr080Media()
		EndIf
	Enddo
	
Else // Analitico
 	
 	If mv_par18 == 2 // Nao imprimir todas alternativas
 		WCabec1	:= STR0008 // "Filial Matricula Nome                          Avaliacao                              Questao Alternativa  Pontos"
    Else
		WCabec1	:= STR0013 // "Filial Matricula Nome                          Avaliacao"    
    EndIf
    
	dbSelectArea("RAI")
	dbSetOrder(1)
	dbSeek(mv_par01+mv_par03,.T.)
	cInicio	:= "RAI->RAI_FILIAL + RAI->RAI_CALEND" 
	cFim	:= mv_par02 + mv_par04

	SetRegua(RecCount())

	While !Eof() .And. &cInicio <= cFim

		If 	RAI->RAI_FILIAL	< mv_par01 .Or. RAI->RAI_FILIAL 	> mv_par02 .Or.;
			RAI->RAI_CALEND	< mv_par03 .Or. RAI->RAI_CALEND 	> mv_par04 .Or.;
			RAI->RAI_CURSO 	< mv_par05 .Or. RAI->RAI_CURSO		> mv_par06 .Or.;
			RAI->RAI_TURMA 	< mv_par07 .Or. RAI->RAI_TURMA 		> mv_par08 .Or.;
			RAI->RAI_MAT 	< mv_par09 .Or. RAI->RAI_MAT 		> mv_par10 .Or.;
			RAI->RAI_TESTE 	< mv_par11 .Or. RAI->RAI_TESTE 		> mv_par12 .Or.;
			RAI->RAI_TIPO 	< mv_par15 .Or. RAI->RAI_TIPO	 	> mv_par16			
			dbSkip()
			Loop
		EndIf              

		cChave2 	:= 	RAI->RAI_FILIAL + RAI->RAI_CALEND + ;
						RAI->RAI_CURSO + RAI->RAI_TURMA
		lFirst2 	:= .T.   					   				
		aTotal		:= {}
		While !Eof() .And. RAI->RAI_FILIAL + RAI->RAI_CALEND + ;
							RAI->RAI_CURSO + RAI->RAI_TURMA == cChave2
		
			// Verificar a Nota do Candidato
			nRecno 	:= Recno()      
			nNota	:= 0                   
		   	cChave 	:= 	RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
	   					RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE 
		   	
			While !Eof() .And.(RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
								RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE == cChave)
  		
				// Buscar Valor das Alternativas selecionadas
				dbSelectArea("SQO")
				dbSetOrder(1)
				cFil := If(xFilial("SQO") == Space(2),Space(2),RAI->RAI_FILIAL)
				nPontos := 0
				If dbSeek( cFil + RAI->RAI_QUESTAO )
					 nPontos := ( SQO->QO_PONTOS * RAI->RAI_RESULTA / 100 )
				EndIf   
				nNota 	+= nPontos 
                   
				//----- Alimenta array com media do Treinamento
				cTipo 	:= RAI->RAI_TIPO 
		   		If cTipo == "AVA" .Or. cTipo == "EFI"
	        		nPosItem := Ascan(aTotal,{|x| x[1] == RAI->RAI_QUESTAO})
					If nPosItem == 0
						Aadd(aTotal, {RAI->RAI_QUESTAO, nPontos, 1})
					Else 
						aTotal[nPosItem][2] += nPontos
						aTotal[nPosItem][3] += 1
					EndIf
				EndIf
				//-----   
				
				dbSelectArea("RAI")
				dbSetOrder(1)
				dbSkip()
			EndDo    
			If ( nNota >= mv_par13 .And. nNota  <= mv_par14 ) .Or. ( cTipo == "AVA" .Or. cTipo == "EFI" )
				RAI->( dbGoto(nRecno) )
			Else
				Loop	
			EndIf	
		   
	     	If mv_par18 == 2 				// Nao imprimir todas alternativas
				Tr080Resum() 	                              
	     	
	     	Else 							// imprimir todas alternativas
				Tr080Detal()     	
	     	EndIf

		Enddo       

		If cTipo == "AVA" .Or. cTipo == "EFI"
			Tr080Media()
		EndIf
		
	EndDo
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


//��������������������������������������������Ŀ
//� Imprime apenas as alternativas escolhidas. �
//����������������������������������������������
Static Function Tr080Resum()

dbSelectArea("RAI")
dbSetOrder(1)
nNota 	:= 0                         
nItem	:= 0
cChave 	:= 	RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
			RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE

lFirst		:= .T.                                     
cQuestAnt	:= ""
While !Eof() .And.(RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
	RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE == cChave)
	
	// Buscar Valor das Alternativas selecionadas
	dbSelectArea("SQO")
	dbSetOrder(1)
	cFil := If(xFilial("SQO") == Space(2),Space(2),RAI->RAI_FILIAL)
	nPontos := 0
	If dbSeek( cFil + RAI->RAI_QUESTAO )
		nPontos := ( SQO->QO_PONTOS * RAI->RAI_RESULTA / 100 )
	EndIf
	nNota		+= nPontos
	
	If RAI->RAI_QUESTAO != cQuestAnt
		cQuestAnt := RAI->RAI_QUESTAO
		nItem ++
	EndIf
	
	cMat	 	:= RAI->RAI_MAT
	cTeste  	:= RAI->RAI_TESTE
	cQuestao 	:= RAI->RAI_QUESTAO
	cAlterna	:= RAI->RAI_ALTERNA
	cTipo 		:= RAI->RAI_TIPO 
	
	cCalend 	:= RAI->RAI_CALEND
	cCurso		:= RAI->RAI_CURSO
	cTurma		:= RAI->RAI_TURMA
	cDescCal	:= FDesc("RA2",cCalend,"RA2_DESC")
	cDescCur	:= FDesc("RA1",cCurso,"RA1_DESC",27)
	                   
	dbSelectArea("RA2")
	dbSetOrder(1)
	dbSeek(xFilial("RA2")+RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA)
	cSinon	:= RA2->RA2_SINON
	cDescSi	:= FDesc("RA9",cSinon,"RA9->RA9_DESCR",27)
	
	// Buscar Avaliacao
	If Len(Alltrim(cTeste)) == 3
		dbSelectArea("SQQ")
		cFil := If(xFilial("SQQ") == Space(2),Space(2),RAI->RAI_FILIAL)
	Else
		dbSelectArea("SQW")
		cFil := If(xFilial("SQW") == Space(2),Space(2),RAI->RAI_FILIAL)
	EndIf
	
	dbSetOrder(1)
	
	dbSeek( cFil + Alltrim(cTeste) )
	
	// Buscar Funcionario
	dbSelectArea("SRA")
	dbSetOrder(1)
	cFil := If(xFilial("SRA") == Space(2),Space(2),SRA->RA_FILIAL)
	dbSeek( cFil + cMat )
	
	// Impressao de detalhe
	If lFirst
		If lFirst2
			IMPR(Repl("-",Colunas),"C")
			DET	:= STR0009+": "+cCalend+"-"+cDescCal +Space(01)+ STR0010+cCurso+"-"+cDescCur +Space(01)+ STR0018+": "+cSinon+"-"+cDescSi+Space(01)+ STR0011+cTurma //"Calendario: "#"Curso: "#"Sinonimo: "#"Turma: "
			IMPR(DET,"C")
			IMPR(Repl("-",Colunas),"C")
			lFirst2 := .F.
		EndIf
		
		DET := "  "
		DET += SRA->RA_FILIAL + Space(05)
		DET += SRA->RA_MAT 	+ Space(02)
		DET += SRA->RA_NOME 	+ Space(01)
		If Len(Alltrim(cTeste)) == 3
			DET += cTeste +" - "+ Padr(SQQ->QQ_DESCRIC,30) + Space(04)
		Else
			DET += cTeste +" - "+ Padr(SQW->QW_DESCRIC,30) + Space(04)
		EndIf
	Else
		DET := Space(89)
	EndIf
	DET += cQuestao	+ Space(08)
	DET += cAlterna	+ Space(05)
	DET += Str(nPontos,6,2)
	
	IMPR(DET,"C")
	lFirst := .F.
	
	dbSelectArea("RAI")
	dbSetOrder(1)
	dbSkip()
EndDo
IMPR("","C")          

If cTipo == "AVA" .Or. cTipo == "EFI"
	cDet := Space(02)+STR0012+": "+Str(nNota,6,2) 				//"Total de Pontos: "
	cDet += Space(73)+STR0017+" "+Str(( nNota / nItem ),6,2)	//"Media: "
	IMPR(cDet,"C")
Else
	IMPR(Space(02)+STR0012+Space(88)+Str(nNota,6,2),"C")		//"Total de Pontos: "
EndIf

If cCalend == RAI->RAI_CALEND .Or. Empty(RAI->RAI_CALEND)
	IMPR(Repl("-",Colunas-2),"C",,,02)
Else
	IMPR("","C")
EndIf
			
Return Nil


//������������������������������������������������Ŀ
//� Imprime todas as alternativas de cada questao. �
//��������������������������������������������������
Static Function Tr080Detal()
Local i		:= 0
Local nBegin:= 0

dbSelectArea("RAI")
dbSetOrder(1)
nNota 	:= 0
cChave 	:= 	RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
	  				RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE
nItem 	:= 0
lFirst	:= .T.
cDescr	:= ""

While !Eof() .And.(RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
				RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE == cChave)

	cMat	 	:= RAI->RAI_MAT
	cTeste  	:= RAI->RAI_TESTE
	cQuestao 	:= RAI->RAI_QUESTAO
	cAlterna	:= RAI->RAI_ALTERNA
	cCalend 	:= RAI->RAI_CALEND
	cCurso		:= RAI->RAI_CURSO
	cTurma		:= RAI->RAI_TURMA   
	cTipo 		:= RAI->RAI_TIPO 
	cDescCal	:= FDesc("RA2",cCalend,"RA2_DESC")
	cDescCur	:= FDesc("RA1",cCurso,"RA1_DESC",27)	
           
	dbSelectArea("RA2")
	dbSetOrder(1)
	dbSeek(xFilial("RA2")+RAI->RAI_CALEND+RAI->RAI_CURSO+RAI->RAI_TURMA)
	cSinon	:= RA2->RA2_SINON
	cDescSi	:= FDesc("RA9",cSinon,"RA9->RA9_DESCR",27)
	
	// Buscar Avaliacao
	If Len(Alltrim(cTeste)) == 3
		dbSelectArea("SQQ")
		cFil := If(xFilial("SQQ") == Space(2),Space(2),RAI->RAI_FILIAL)
	Else
		dbSelectArea("SQW")
		cFil := If(xFilial("SQW") == Space(2),Space(2),RAI->RAI_FILIAL)
	EndIf
	dbSetOrder(1)
	dbSeek( cFil + Alltrim(cTeste) )
	
	// Buscar Funcionario
	dbSelectArea("SRA")
	dbSetOrder(1)
	cFil := If(xFilial("SRA") == Space(2),Space(2),RAI->RAI_FILIAL)
	dbSeek( cFil + cMat )
	
	// Impressao de detalhe
	If lFirst
		If lFirst2
			IMPR(Repl("-",Colunas),"C")
			DET	:= STR0009+": "+cCalend+"-"+cDescCal +Space(01)+ STR0010+cCurso+"-"+cDescCur +Space(01)+ STR0018+": "+cSinon+"-"+cDescSi+Space(01)+ STR0011+cTurma //"Calendario: "#"Curso: "#"Sinonimo: "#"Turma: "
			IMPR(DET,"C")
			IMPR(Repl("-",Colunas),"C")
			lFirst2 := .F.
		EndIf
		
		DET := "  "
		DET += SRA->RA_FILIAL 	+ Space(05)
		DET += SRA->RA_MAT		+ Space(02)
		DET += SRA->RA_NOME 	+ Space(01)
		If Len(Alltrim(cTeste)) == 3
			DET += cTeste +" - "+ Padr(SQQ->QQ_DESCRIC,30) + Space(04)
		Else
			DET += cTeste +" - "+ Padr(SQW->QW_DESCRIC,30) + Space(04)
		EndIf 
		
		IMPR(DET,"C")
		IMPR("","C") 
	EndIf
	
	// Buscar Valor das Alternativas selecionadas
	dbSelectArea("SQO")
	dbSetOrder(1)
	cFil := If(xFilial("SQO") == Space(2),Space(2),RAI->RAI_FILIAL)
	nPontos := 0
	If dbSeek( cFil + RAI->RAI_QUESTAO )
		nPontos := ( SQO->QO_PONTOS )
	EndIf                           

	// Imprimir Questao	 
	nItem ++	 
	cDescr:= Alltrim(SQO->QO_QUEST) //+ " ("+RAI->RAI_QUESTAO+")"
	nLinha:= MLCount(cDescr,115)                         
	For i := 1 to nLinha
		DET := Space(05)+IIF(i==1,StrZero(nItem,3)+"- ",Space(Len(StrZero(nItem,3)))+"  ")+MemoLine(cDescr,115,i,,.T.)
		Impr(DET,"C")
	Next i	
	Impr("","C") 
	   
	// Verifica se Questao eh Dissertativa
	If RAI->RAI_ALTERN == "00"	// Dissertativa	 
		DET := Space(11)+STR0016+Space(84)+STR0015	//"Resposta    "###"Pontos"
		Impr(DET,"C")   

		nPtos := ( SQO->QO_PONTOS * RAI->RAI_RESULTA / 100 )
		nNota += nPtos
					   
		cAuxDet := MSMM(RAI->RAI_MRESPO,,,,3)	// Leitura do campo memo da descricao detalhada
		nLinha	:= MLCount(cAuxDet,99)		// Verifica numero de linhas.
		If nLinha > 0
			For nBegin := 1 To nLinha
				If nBegin == nLinha
					DET := Space(07)+Memoline(cAuxDet,99,nBegin,,.t.)+" "+Str(nPtos,6,2)   
				Else 
					DET := Space(07)+Memoline(cAuxDet,99,nBegin,,.t.)+" "
				EndIf
				Impr(DET,"C")   
			Next nBegin
		EndIf
	Else  		// Imprime Cabecalho das alternativas.
		DET := Space(11)+STR0014+Space(84)+STR0015	//"Alternativas"###"Pontos"
		Impr(DET,"C")   
        
		dbSelectArea("RAI")
		dbSetOrder(1)       
	
		aSaveRAI := GetArea()
		
		If Empty(SQO->QO_ESCALA)
		
			dbSelectArea("SQP")
			dbSetOrder(1)
			cFil := If(xFilial("SQP") == Space(2),Space(2),RAI->RAI_FILIAL)
			If dbSeek(cFil + RAI->RAI_QUESTAO )
				While !Eof() .And. ( SQP->QP_FILIAL + SQP->QP_QUESTAO  ) ==;
									( cFil + cQuestao )
	             
					dbSelectArea("RAI")
					dbSetOrder(1) 
					nPtos := 0
					cFil2 := If(xFilial("RAI") == Space(2),Space(2),SRA->RA_FILIAL)			
					If dbSeek( cFil2 + cCalend + cCurso + cTurma + cMat + cTeste + SQP->QP_QUESTAO + SQP->QP_ALTERNA )
				
						nPtos := ( nPontos * RAI->RAI_RESULTA / 100 )
						nNota += nPtos
						DET := Space(07)+"(X) "+SQP->QP_ALTERNA+" - "+Left(SQP->QP_DESCRIC,90)+" "+Str(nPtos,6,2)
					Else
						DET := Space(07)+"( ) "+SQP->QP_ALTERNA+" - "+Left(SQP->QP_DESCRIC,90)+" "+Str(nPtos,6,2)
					EndIf		 
					IMPR(DET,"C")	
					
					dbSelectArea("SQP")
					dbSetOrder(1)
					dbSkip()
				EndDo
			EndIf
		
		Else
		
			dbSelectArea("RBL") 
			dbSetOrder(1)
			cFil := If(xFilial("RBL") == Space(2),Space(2),RAI->RAI_FILIAL)
			If dbSeek(cFil + SQO->QO_ESCALA )
				While !Eof() .And. ( RBL->RBL_FILIAL + RBL->RBL_ESCALA  ) ==;
									( cFil + SQO->QO_ESCALA )
	             
					dbSelectArea("RAI")
					dbSetOrder(1) 
					nPtos := 0
					cFil2 := If(xFilial("RAI") == Space(2),Space(2),SRA->RA_FILIAL)			
					If dbSeek( cFil2 + cCalend + cCurso + cTurma + cMat + cTeste + SQO->QO_QUESTAO + RBL->RBL_ITEM )
				
						nPtos := ( nPontos * RAI->RAI_RESULTA / 100 )
						nNota += nPtos
						DET := Space(07)+"(X) "+RBL->RBL_ITEM+" - "+Left(RBL->RBL_DESCRI,90)+" "+Str(nPtos,6,2)
					Else
						DET := Space(07)+"( ) "+RBL->RBL_ITEM+" - "+Left(RBL->RBL_DESCRI,90)+" "+Str(nPtos,6,2)
					EndIf		 
					IMPR(DET,"C")	
					
					dbSelectArea("RBL") 
					dbSetOrder(1)
					dbSkip()
				EndDo
			EndIf
					
		EndIf
		RestArea(aSaveRAI)
		
	EndIf

	Impr("","C")	    
	lFirst := .F.             

	dbSelectArea("RAI")
	dbSetOrder(1)
	While !Eof() .And.(RAI->RAI_FILIAL + RAI->RAI_CALEND + RAI->RAI_CURSO + ;
			RAI->RAI_TURMA + RAI->RAI_MAT + RAI->RAI_TESTE + RAI->RAI_QUESTAO ) == ;
			( RAI->RAI_FILIAL + cCalend + cCurso + cTurma + cMat + cTeste + cQuestao)

		dbSkip()
	EndDo		
EndDo

IMPR("","C") 

If cTipo == "AVA" .Or. cTipo == "EFI"
	cDet := Space(02)+STR0012+" "+Str(nNota,6,2) 				//"Total de Pontos: "
	cDet += Space(73)+STR0017+" "+Str(( nNota / nItem ),6,2)	//"Media: "
	IMPR(cDet,"C")
Else
	IMPR(Space(02)+STR0012+Space(88)+Str(nNota,6,2),"C")		//"Total de Pontos: "
EndIf

If cCalend == RAI->RAI_CALEND .Or. Empty(RAI->RAI_CALEND)
	IMPR(Repl("-",Colunas-2),"C",,,02)
Else
	IMPR("","C")
EndIf

Return Nil
  

//������������������������������������������������Ŀ
//� Imprime a Media da Turma.					   �
//��������������������������������������������������
Static Function Tr080Media() 

Local nx		:= 0 
Local nTotal	:= 0
Local aSaveArea	:= GetArea()

IMPR("","C")

Aeval(aTotal,{|x| nTotal += x[2] / x[3]})
nTotal := nTotal / Len(aTotal)
     
If mv_par17 != 2	//Analitico
	For nx := 1 To Len(aTotal)
		 
		SQO->( dbSetOrder(1) )
		SQO->( dbSeek(xFilial("SQO")+aTotal[nx][1]) )
		cQuest := Left(MemoLine(SQO->QO_QUEST), 30)
		If nx == 1 
			DET := Space(02)+STR0019+aTotal[nx][1]+" - "+ cQuest + Space(51)+Transform(aTotal[nx][2]/aTotal[nx][3],"99999.99")	//"Media da Turma: "
		Else
			DET := Space(18)+aTotal[nx][1]+" - "+ cQuest + Space(51)+Transform(aTotal[nx][2]/aTotal[nx][3],"99999.99")
		EndIf		
		IMPR(DET,"C")
	Next nx                                                 

	IMPR("","C")	
	DET := Space(100)+STR0017+Str(nTotal,6,2)	//	"MEDIA:"

Else	//Sintetico

	DET := Space(079)+STR0017+Str(nTotal,6,2)	//	"MEDIA:"
	
EndIf          

IMPR(DET,"C")

RestArea(aSaveArea)

Return Nil
