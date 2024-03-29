#Include "TOPCONN.CH"    //PADRAO
#Include "RWMAKE.CH"    //PADRAO
#Include "MSOLE.CH"    //PADRAO

/*/
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � SEC0012	    � Autor �  ALAN S. R. OLIVEIRA  � Data � 19/06/02 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � DECLARACAO DE SEMESTRALIDADE              		       	      ���
�����������������������������������������������������������������������������Ĵ��
���Uso		 � Especifico Financeiro 							              ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
/*/
User Function SEC0012()

Local lRet 		:= .T.
Local nLastKey	:= 0

Private check		:= 0
Private _cArqTmp	:= ""

If nLastKey == 27
	Set Filter To
	Return
EndIf                                                                                

// Chamada da rotina de armazenamento de dados...
Processa({||ACATRB0012() })
      
if check > 0	//ESTA VERIFCACAO E FEITA, PARA QUE QUANDO NAO HOUVER TITULOS GERADOS PARA O ALUNO
				//EXIBA UMA MENSSAGEM PARA O ATENDENTE
	// Chamada da rotina de impressao do relat�rio...
	Processa({||U_PREL0012() })
	                                         
else
		
	MsgBox("N�o existem t�tulos gerados para este aluno.")
	lRet := .F.
		
endif 

//��������������������������������������������������������������Ŀ
//� Apaga arquivos tempor�rios				    	             |
//����������������������������������������������������������������
#IFDEF TOP
	DbSelectArea("SQJ")
	DbCloseArea()
#ENDIF
                                    
DbSelectarea("TRB")
DbCloseArea()

#IFNDEF TOP
	Ferase(_cArqTmp+".DBF")
	Ferase(_cArqTmp+OrdBagExt())
#ENDIF
      
DbSelectArea("JA2")	//CADASTRO DE ALUNOS
RetIndex("JA2")
DbSelectArea("JAH")	//CADASTRO DE CURSO
RetIndex("JAH")
DbSelectArea("JBH")	//HEADER DA SOLICITACAO DO REQUERIMENTO
RetIndex("JBH")
DbSelectArea("JC7")	//ITENS DA ALOCACAO DO ALUNO
RetIndex("JC7")
DbSelectArea("JBE")	//HEADER DA ALOCACAO DO ALUNO
RetIndex("JBE")
DbSelectArea("SE1") //DADOS TITULOS X ALUNOS
RetIndex("SE1")

Return( lRet )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �ACATRB0012| Autor � Alan S. R. Oliveira   � Data � 19/06/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Armazenamento e Tratamento dos dados 					  ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	 � Especifico Academico              				          ���
�������������������������������������������������������������������������Ĵ��
��� Revis�o  �								            � Data �  		  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC FUNCTION ACATRB0012()

Local _aCampos   := {}
Local cQuery     := ""
Local aTamRA     := TamSX3("JA2_NUMRA")

//�����������������������������������������������������������������Ŀ
//� Monta a variavel com o Numero do RA de acordo com o tamanho do  �
//� campo JA2_NUMRA (Numero do RA).				                    �
//�������������������������������������������������������������������
cRA := Left(JBH_CODIDE,aTamRA[1])

//�����������������������������������������������������������������Ŀ
//� Retorna um vetor com os conteudos dos campos do script          �
//�na ordem que foi configurada no tipo do requerimento.            �
//�������������������������������������������������������������������
cNumReq := JBH->JBH_NUM
aRet := ACScriptReq( cNumReq )

//��������������������������������������������������������������Ŀ
//� Cria Arquivo de Trabalho			       				     �
//����������������������������������������������������������������
Aadd(_aCampos,{"NOMCURS"   	,"C",030,0})
Aadd(_aCampos,{"RA"        	,"C",030,0})
Aadd(_aCampos,{"SEXO"      	,"C",001,0})
Aadd(_aCampos,{"NOMEAL"    	,"C",060,0})
Aadd(_aCampos,{"BAIXA"    	,"D",008,0})
Aadd(_aCampos,{"DTMES"    	,"D",008,0})
Aadd(_aCampos,{"VALPGTO"   	,"N",008,0})
Aadd(_aCampos,{"SALDO"     	,"N",008,0})
Aadd(_aCampos,{"PAGTO1" 	,"N",008,0})
Aadd(_aCampos,{"PAGTO2" 	,"N",008,0})
Aadd(_aCampos,{"PAGTO3" 	,"N",008,0})   
Aadd(_aCampos,{"MES"	   	,"C",009,0})
Aadd(_aCampos,{"SEMPGTO"   	,"C",002,0})
Aadd(_aCampos,{"ANOPGTO"   	,"C ",004,0})
Aadd(_aCampos,{"DHABILI"    ,"C",100,0})

_cArqTmp := CriaTrab(_aCampos,.T.)
dbUseArea( .T.,, _cArqTmp, "TRB", .F., .F. )

cQuery := " SELECT "
cQuery += " SE1.E1_VENCTO DTMES , "
cQuery += " SE1.E1_BAIXA BAIXA , "
cQuery += " SE1.E1_VALOR VALOR, "
cQuery += " JA2.JA2_NOME NOME , "
cQuery += " SE1.E1_DESCON1 PERC1, "
cQuery += " SE1.E1_DESCON2 PERC2, "
cQuery += " SE1.E1_DESCON3 PERC3, "
cQuery += " JA2.JA2_SEXO SEXO , "
cQuery += " SE1.E1_SALDO SALDO , "
cQuery += " SE1.E1_VALLIQ VALLIQ "
cQuery += " FROM " + RetSQLName("JA2") + " JA2, " + RetSQLName("SE1") + " SE1, "+ RetSQLName("JBE") + " JBE "
cQuery += " WHERE JA2.JA2_FILIAL = '" + xFilial("JA2") + "' "
cQuery += " AND	JA2.D_E_L_E_T_ <> '*' "
cQuery += " AND  SE1.E1_FILIAL  	= '" + xFilial("SE1") + "' "
cQuery += " AND  SE1.D_E_L_E_T_ <> '*'"
cQuery += " AND  JBE.JBE_FILIAL 	= '" + xFilial("JBE") + "' "
cQuery += " AND  JBE.D_E_L_E_T_ <> '*' "
cQuery += " AND  JA2.JA2_NUMRA   = JBE.JBE_NUMRA "
cQuery += " AND  JA2.JA2_NUMRA   = SE1.E1_NUMRA "
cQuery += " AND  SE1.E1_CLIENTE 	= JA2.JA2_CLIENT "
cQuery += " AND  JA2.JA2_NUMRA  	= '" + cRA + "' "
cQuery += " AND  JBE.JBE_CODCUR 	= '" + aRet[1] + "' "
cQuery += " AND  SE1.E1_NRDOC    = '"+ Alltrim(aRet[1]) + Alltrim(aRet[8]) +"' "
cQuery += " AND  JBE.JBE_ATIVO  	= '1' "
cQuery += " AND  (SE1.E1_PREFIXO	= 'MAT' OR SE1.E1_PREFIXO = 'MES' OR SE1.E1_PREFIXO = 'DIS') "
cQuery += " GROUP BY "
cQuery += " SE1.E1_VENCTO , "
cQuery += " SE1.E1_BAIXA , "
cQuery += " SE1.E1_VALOR , "
cQuery += " JA2.JA2_NOME , "
cQuery += " JA2.JA2_SEXO , "
cQuery += " SE1.E1_DESCON1, "
cQuery += " SE1.E1_DESCON2, "
cQuery += " SE1.E1_DESCON3, "
cQuery += " SE1.E1_SALDO , "
cQuery += " SE1.E1_VALLIQ "
cQuery += " ORDER BY "
cQuery += " SE1.E1_SALDO , "
cQuery += " SE1.E1_VENCTO "

cQuery := ChangeQuery(cQuery)   

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQJ", .F., .T.)

TcSetField("SQJ","BAIXA"	,"D",8,0) 
TcSetField("SQJ","DTMES"	,"D",8,0)
TcSetField("SQJ","VALOR"	,"N",8,0) 
TcSetField("SQJ","VALLIQ"	,"N",8,0) 
TcSetField("SQJ","SALDO"	,"N",8,0)  
TcSetField("SQJ","PERC1"	,"N",8,0)  
TcSetField("SQJ","PERC2"	,"N",8,0)  
TcSetField("SQJ","PERC3"	,"N",8,0)    
  
DbSelectArea("SQJ") 
DbGoTop()
While !Eof()
	check += 1
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
			
	TRB->NOMCURS		:= aRet[2] 
	TRB->RA				:= cRA
	TRB->SEXO			:= IF(SQJ->SEXO = "1","o","a")
	TRB->NOMEAL			:= SQJ->NOME
	TRB->BAIXA			:= SQJ->BAIXA
	TRB->VALPGTO		:= SQJ->VALLIQ
	TRB->SALDO			:= SQJ->SALDO
	TRB->PAGTO1			:= SQJ->VALOR - ((SQJ->VALOR * SQJ->PERC1) / 100)
	TRB->PAGTO2			:= SQJ->VALOR - ((SQJ->VALOR * SQJ->PERC2) / 100)
	TRB->PAGTO3 		:= SQJ->VALOR - ((SQJ->VALOR * SQJ->PERC3) / 100)
	TRB->DTMES			:= SQJ->DTMES
	TRB->SEMPGTO		:= aRet[8]
	TRB->ANOPGTO		:= aRet[7]
	TRB->DHABILI        := Iif(Empty(aRet[4]), " ", ", Habilita��o " + AllTrim(aRet[5]))

	MsUnlock() 
	DbSelectArea("SQJ")
	Dbskip()
ENDDO    
  
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �  PREL0012� Autor �  Alan S. R. Oliveira  � Data � 19/06/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do WORD  �����������������������������������������Ĵ��
��� Revis�o  �		                                    � Data �  		  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/
User Function PREL0012()      

Private nCntFor
Private nCntFor1

nCntFor 	:= 0
nCntFor1 	:= 0                                              

			
//�����������������������������������������������������������������������Ŀ
//� Criando link de comunicacao com o word                                �
//�������������������������������������������������������������������������

hWord := OLE_CreateLink()
OLE_SetProperty ( hWord, oleWdVisible, .T.) //VISUALIZAR O DOT

//�����������������������������������������������������������������������Ŀ
//� Seu Documento Criado no Word                                          �
//� A extensao do documento tem que ser .DOT                              �
//�������������������������������������������������������������������������

cArqDot  := "SEC0012.DOT" // Nome do Arquivo MODELO do Word
cPathDot := Alltrim(GetMv("MV_DIRACA")) + cArqDot // PATH DO ARQUIVO MODELO WORD

//Local HandleWord
Private cPathEst:= Alltrim(GetMv("MV_DIREST")) // PATH DO ARQUIVO A SER ARMAZENADO NA ESTACAO DE TRABALHO
MontaDir(cPathEst)

If !File(cPathDot) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
	MsgBox("Atencao... SEC0012.DOT nao encontrado no Servidor")
	Return NIL
EndIf

// Caso encontre arquivo ja gerado na estacao
//com o mesmo nome apaga primeiramente antes de gerar a nova impressao
If File( cPathEst + cArqDot )
	Ferase( cPathEst + cArqDot )
EndIf

CpyS2T(cPathDot,cPathEst,.T.) // Copia do Server para o Remote, eh necessario
//para que o wordview e o proprio word possam preparar o arquivo para impressao e
// ou visualizacao .... copia o DOT que esta no ROOTPATH Protheus para o PATH da
// estacao , por exemplo C:\WORDTMP


//�����������������������������������������������������������������������Ŀ
//� Gerando novo documento do Word na estacao                             �
//�������������������������������������������������������������������������
OLE_NewFile( hWord, cPathEst + cArqDot)

DbSelectArea("TRB")
DbGoTop()

	OLE_SetDocumentVar(hWord, "cNOME"       , Alltrim(TRB->NOMEAL))
	OLE_SetDocumentVar(hWord, "nRA"         , Alltrim(TRB->RA))
	OLE_SetDocumentVar(hWord, "cSEXO"		, Alltrim(TRB->SEXO ))
	OLE_SetDocumentVar(hWord, "cNOMCURS"	, Alltrim(TRB->NOMCURS))
	OLE_SetDocumentVar(hWord, "nDIA"     	, Day(dDataBase))
	OLE_SetDocumentVar(hWord, "cANO"     	, Year(dDataBase))
	OLE_SetDocumentVar(hWord, "cMESATU"    	, Alltrim(MesExtenso(Month(dDataBase))))
	OLE_SetDocumentVar(hWord, "cSEMPGTO"  	, TRB->SEMPGTO)
	OLE_SetDocumentVar(hWord, "cANOPGTO"  	, TRB->ANOPGTO)   
	OLE_SetDocumentVar(hWord, "cNOMHABILI"  , Iif(Empty(TRB->DHABILI), " ", Alltrim(TRB->DHABILI)))
	
While !Eof()
	

	//�����������������������������������������������������������������������Ŀ
	//� Gerando variaveis do documento                                        �
	//�������������������������������������������������������������������������
		OLE_SetDocumentVar(hWord, "cMESPGTO1" , "  ")
		OLE_SetDocumentVar(hWord, "cPG1" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA1" , "  ")
		OLE_SetDocumentVar(hWord, "cMESPGTO2" , "  ")
		OLE_SetDocumentVar(hWord, "cPG2" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA2" , "  ")
		OLE_SetDocumentVar(hWord, "cMESPGTO3" , "  ")
		OLE_SetDocumentVar(hWord, "cPG3" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA3" , "  ")
		OLE_SetDocumentVar(hWord, "cMESPGTO4" , "  ")
		OLE_SetDocumentVar(hWord, "cPG4" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA4" , "  ")
		OLE_SetDocumentVar(hWord, "cMESPGTO5" , "  ")
		OLE_SetDocumentVar(hWord, "cPG5" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA5" , "  ")
		OLE_SetDocumentVar(hWord, "cMESPGTO6" , "  ")
		OLE_SetDocumentVar(hWord, "cPG6" , "  ")
		OLE_SetDocumentVar(hWord, "dBAIXA6" , "  ")  
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR11", "  ")
		OLE_SetDocumentVar(hWord, "cPGTO11" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO12" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO13" , "  ")
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR22", "  ")
		OLE_SetDocumentVar(hWord, "cPGTO21" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO22" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO23" , "  ")
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR33", "  ")
		OLE_SetDocumentVar(hWord, "cPGTO31" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO32" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO33" , "  ")
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR44", "  ")
		OLE_SetDocumentVar(hWord, "cPGTO41" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO42" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO43" , "  ")
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR55", "  ")
		OLE_SetDocumentVar(hWord, "cPGTO51" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO52" , "  ")
		OLE_SetDocumentVar(hWord, "cPGTO53" , "  ")
		
	While !Eof() .AND. TRB->SALDO = 0
	
	
		
		//�����������������������������������������������������������������������Ŀ
		//� Gerando variaveis do documento                                        �
		//�������������������������������������������������������������������������
		
		nCntFor += 1
	
							
		IF nCntFor == 1
		
		OLE_SetDocumentVar(hWord, "cMESPGTO1" ,AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG1" , "R$" + STR(TRB->VALPGTO,8,2))
		OLE_SetDocumentVar(hWord, "dBAIXA1" , TRB->BAIXA)
			   
		ELSEIF nCntFor == 2
		
		OLE_SetDocumentVar(hWord, "cMESPGTO2" ,AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG2" , "R$" + STR(TRB->VALPGTO,8,2))
		OLE_SetDocumentVar(hWord, "dBAIXA2" , TRB->BAIXA)
					
		ELSEIF nCntFor == 3
		                                                     
		OLE_SetDocumentVar(hWord, "cMESPGTO3"   ,AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG3" , "R$" + STR(TRB->VALPGTO,8,2))
		OLE_SetDocumentVar(hWord, "dBAIXA3"	, TRB->BAIXA)
					
		ELSEIF nCntFor == 4
		                                                     
		OLE_SetDocumentVar(hWord, "cMESPGTO4"   ,AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG4" , "R$" + STR(TRB->VALPGTO,8,2))
		OLE_SetDocumentVar(hWord, "dBAIXA4" , TRB->BAIXA)
		
		ELSEIF nCntFor == 5
					                                                                     
		OLE_SetDocumentVar(hWord, "cMESPGTO5",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG5",  "R$" + STR(TRB->VALPGTO,8,2))
		OLE_SetDocumentVar(hWord, "dBAIXA5"	, TRB->BAIXA)
		
		ELSEIF nCntFor == 6
		
		OLE_SetDocumentVar(hWord, "cMESPGTO6",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPG6"	, "R$" + STR(TRB->VALPGTO,8,2))
		OLE_SetDocumentVar(hWord, "dBAIXA6" , TRB->BAIXA)
		
		ENDIF
		
	
		DbSkip()
		
	ENDDO
	
	
	While !Eof() .AND. TRB->SALDO > 0
		
		//�����������������������������������������������������������������������Ŀ
		//� Gerando variaveis do documento tabela dos nao pagos                   �
		//�������������������������������������������������������������������������
		
		nCntFor1 += 1
		
		IF nCntFor1 == 1
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR11",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPGTO11" , "R$" + STR(TRB->PAGTO1,8,2))
		OLE_SetDocumentVar(hWord, "cPGTO12" , "R$" + STR(TRB->PAGTO2,8,2))
		OLE_SetDocumentVar(hWord, "cPGTO13" , "R$" + STR(TRB->PAGTO3,8,2))
		
		ELSEIF nCntFor1 == 2
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR22",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPGTO21" , "R$" + STR(TRB->PAGTO1,8,2))
		OLE_SetDocumentVar(hWord, "cPGTO22" , "R$" + STR(TRB->PAGTO2,8,2))
		OLE_SetDocumentVar(hWord, "cPGTO23" , "R$" + STR(TRB->PAGTO3,8,2))
		
		ELSEIF nCntFor1 == 3
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR33",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPGTO31" , "R$" + STR(TRB->PAGTO1,8,2))
		OLE_SetDocumentVar(hWord, "cPGTO32" , "R$" + STR(TRB->PAGTO2,8,2))
		OLE_SetDocumentVar(hWord, "cPGTO33" , "R$" + STR(TRB->PAGTO3,8,2))
		
		ELSEIF nCntFor1 == 4
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR44",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPGTO41" , "R$" + STR(TRB->PAGTO1,8,2))
		OLE_SetDocumentVar(hWord, "cPGTO42" , "R$" + STR(TRB->PAGTO2,8,2))
		OLE_SetDocumentVar(hWord, "cPGTO43" , "R$" + STR(TRB->PAGTO3,8,2))
		
		ELSEIF nCntFor1 == 5
		
		OLE_SetDocumentVar(hWord, "cMAPAGAR55",AllTrim(MesExtenso(Month(TRB->DTMES))) + " / " + TRB->ANOPGTO)
		OLE_SetDocumentVar(hWord, "cPGTO51" , "R$" + STR(TRB->PAGTO1,8,2))
		OLE_SetDocumentVar(hWord, "cPGTO52" , "R$" + STR(TRB->PAGTO2,8,2))
		OLE_SetDocumentVar(hWord, "cPGTO53" , "R$" + STR(TRB->PAGTO3,8,2))
		
		ENDIF
							
		DbSkip()
	ENDDO
	
ENDDO	   
			
OLE_UpdateFields(hWord)

If MsgYesNo( "Deseja Finalizar o Word" )

	OLE_CloseFile( hWord )
    OLE_CloseLink( hWord )
Endif

//OLE_CloseLink( hWord, .F. )

Return
