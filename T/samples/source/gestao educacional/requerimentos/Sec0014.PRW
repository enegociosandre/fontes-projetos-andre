#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
#Include "TOPCONN.CH"
#Include "RWMAKE.CH"
#Include "MSOLE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � SEC0014	� Autor �  Regiane R. Barreira  � Data � 15/06/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emite o Curriculo do Curso    					       	  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � Especifico Academico 							          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SEC0014()

nLastKey  := 0
cArqTRBC  := ""
cArqTRBI  := ""
cOrder    := ""

cPRO := Space(6)
cSEC := Space(6)

If nLastKey == 27
	Set Filter To
	Return
EndIf

//Chamada da rotina de escolha de assinaturas....
Processa({||U_ASSREQ() })

// Chamada da rotina de armazenamento de dados...
Processa({||ACATRB0014() })

// Chamada da rotina de impressao do relat�rio...
Processa({||U_PREL0014() })

DbSelectArea("JA2")
RetIndex("JA2")
DbSelectArea("JAE")
RetIndex("JAE")
DbSelectArea("JAH")
RetIndex("JAH")
DbSelectArea("JAY")
RetIndex("JAY")
DbSelectArea("JBE")
RetIndex("JBE")
DbSelectArea("JBH")
RetIndex("JBH")

Return( .T. )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �ACATRB0014� Autor �  Regiane R. Barreira  � Data � 15/06/02 ���
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
STATIC FUNCTION ACATRB0014()

Local aCamposC   := {}
Local aCamposI   := {}
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
aRet    := ACScriptReq( cNumReq )

//��������������������������������������������������������������Ŀ
//� Cria Arquivos de Trabalho			       				     �
//����������������������������������������������������������������
Aadd(aCamposC,{"CURSO"  ,"C",030,0})
Aadd(aCamposC,{"NOME"   ,"C",060,0})
Aadd(aCamposC,{"PERLET" ,"C",002,0})
Aadd(aCamposC,{"HABILI" ,"C",006,0})
Aadd(aCamposC,{"DTSITU" ,"D",008,0})
Aadd(aCamposC,{"ATIVO"  ,"C",001,0})
Aadd(aCamposC,{"ANOLET" ,"C",004,0})
Aadd(aCamposC,{"PERIOD" ,"C",002,0})
Aadd(aCamposC,{"CODCUR" ,"C",006,0})
Aadd(aCamposC,{"DCOLAC" ,"D",008,0})

cArqTRBC := CriaTrab(aCamposC,.T.)
dbUseArea( .T.,, cArqTRBC, "TRBC", .F., .F. )

Aadd(aCamposI,{"SEMEST" ,"C",002,0})
Aadd(aCamposI,{"HABILI" ,"C",006,0})
Aadd(aCamposI,{"DISCIP" ,"C",030,0})
Aadd(aCamposI,{"CH"     ,"N",004,0})

cArqTRBI := CriaTrab(aCamposI,.T.)
dbUseArea( .T.,, cArqTRBI, "TRBI", .F., .F. )

cQuery := " SELECT "
cQuery += " JAH.JAH_CURSO, "
cQuery += " JAH.JAH_CODIGO CODCUR, "
cQuery += " JAH.JAH_DESC, "
cQuery += " JAH.JAH_CARGA, "
cQuery += " JAH.JAH_TURNO, "
cQuery += " JBE.JBE_NUMRA, "
cQuery += " JBE.JBE_PERLET PERLET, "
cQuery += " JBE.JBE_TURMA, "
cQuery += " JBE.JBE_ATIVO  ATIVO, "
cQuery += " JBE.JBE_NUMREQ, "
cQuery += " JBE.JBE_ANOLET ANOLET, "
cQuery += " JBE.JBE_HABILI HABILI, "
cQuery += " JBE.JBE_DTSITU DTSITU, "
cQuery += " JBE.JBE_PERIOD PERIOD, "
cQuery += " JA2.JA2_NOME   NOME, "
cQuery += " JAE.JAE_DESC, "
cQuery += " JAY.JAY_CARGA  CH, "
cQuery += " JAY.JAY_PERLET PERLET, "
cQuery += " JAY.JAY_HABILI HABILI, "
cQuery += " JBE.JBE_DCOLAC DCOLAC, "
cQuery += " JAE.JAE_DESC   DISCIP "
cQuery += " FROM " +  RetSQLName("JAH")+ " JAH, " +  RetSQLName("JBE")+ " JBE, " +  RetSQLName("JA2")+ " JA2, " +  RetSQLName("JC7")+ " JC7, " +  RetSQLName("JAE")+ " JAE, " +  RetSQLName("JAY")+ " JAY "
cQuery += " WHERE JAH.JAH_FILIAL='" + xFilial("JAH") +"' "
cQuery += " AND  JAH.D_E_L_E_T_<>'*' "
cQuery += " AND  JBE.JBE_FILIAL='" + xFilial("JBE") +"' "
cQuery += " AND  JBE.D_E_L_E_T_<>'*' "
cQuery += " AND  JA2.JA2_FILIAL='" + xFilial("JA2") +"' "
cQuery += " AND  JA2.D_E_L_E_T_<>'*' "
cQuery += " AND  JAE.JAE_FILIAL='" + xFilial("JAE") +"' "
cQuery += " AND  JAE.D_E_L_E_T_<>'*' "
cQuery += " AND  JC7.JC7_FILIAL='" + xFilial("JC7") +"' "
cQuery += " AND  JC7.D_E_L_E_T_<>'*' "
cQuery += " AND  JAY.JAY_FILIAL='" + xFilial("JAY") +"' "
cQuery += " AND  JAY.D_E_L_E_T_<>'*' "
cQuery += " AND  JAH.JAH_CODIGO = JBE.JBE_CODCUR "
cQuery += " AND  JBE.JBE_NUMRA  = JA2.JA2_NUMRA "
cQuery += " AND  JBE.JBE_NUMRA  = JC7.JC7_NUMRA "
cQuery += " AND  JBE.JBE_CODCUR = JC7.JC7_CODCUR "
cQuery += " AND  JBE.JBE_PERLET = JC7.JC7_PERLET "
cQuery += " AND  JBE.JBE_TURMA  = JC7.JC7_TURMA "
cQuery += " AND  JC7.JC7_DISCIP = JAE.JAE_CODIGO "
cQuery += " AND  JAY.JAY_CURSO  = JAH.JAH_CURSO "
cQuery += " AND  JAY.JAY_HABILI = JBE.JBE_HABILI "
cQuery += " AND  JAY.JAY_VERSAO = JAH.JAH_VERSAO "
cQuery += " AND  JAE.JAE_CODIGO = JAY.JAY_CODDIS "
cQuery += " AND  JAH.JAH_CODIGO='" + aRet[1] + "' "
cQuery += " AND  JBE.JBE_NUMRA ='" + cRA + "' "
cQuery += " GROUP BY "
cQuery += " JAH.JAH_CURSO, "
cQuery += " JAH.JAH_CODIGO, "
cQuery += " JAH.JAH_DESC, "
cQuery += " JAH.JAH_CARGA, "
cQuery += " JAH.JAH_TURNO, "
cQuery += " JBE.JBE_NUMRA, "
cQuery += " JBE.JBE_PERLET, "
cQuery += " JBE.JBE_TURMA, "
cQuery += " JBE.JBE_ATIVO, "
cQuery += " JBE.JBE_NUMREQ, "
cQuery += " JBE.JBE_ANOLET, "
cQuery += " JA2.JA2_NOME, "
cQuery += " JAE.JAE_DESC, "
cQuery += " JAY.JAY_CARGA, "
cQuery += " JAY.JAY_PERLET, "
cQuery += " JAY.JAY_HABILI, "
cQuery += " JBE.JBE_HABILI, "
cQuery += " JBE.JBE_DTSITU, "
cQuery += " JBE.JBE_DCOLAC, "
cQuery += " JBE.JBE_PERIOD, "
cQuery += " JAE.JAE_DESC "
cQuery += " ORDER BY "
cQuery += " JBE.JBE_ANOLET,  "
cQuery += " JBE.JBE_PERIOD, "
cQuery += " JAY.JAY_PERLET ,  "
cQuery += " JAY.JAY_HABILI "

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQJC", .F., .T.)
TcSetField("SQJC","DTSITU","D",8,0)
TcSetField("SQJC","DCOLAC","D",8,0)
TcSetField("SQJC","CH","N",4,0)         

DbSelectArea ("SQJC")
While !Eof()
	DbSelectArea( "TRBC" )
	RecLock( "TRBC",.T. )
	
	TRBC->CURSO  := aRet[2]
	TRBC->NOME   := SQJC->NOME
	TRBC->PERLET := SQJC->PERLET
	TRBC->HABILI := SQJC->HABILI
	TRBC->DTSITU := SQJC->DTSITU
	TRBC->ATIVO  := SQJC->ATIVO
	TRBC->ANOLET := SQJC->ANOLET
	TRBC->PERIOD := SQJC->PERIOD
	TRBC->CODCUR := SQJC->CODCUR
	TRBC->DCOLAC := SQJC->DCOLAC
	
	TRBC->( MsUnlock() )
		
	DbSelectArea( "TRBI" )
	RecLock( "TRBI",.T. )
	
	TRBI->SEMEST := SQJC->PERLET
	TRBI->HABILI := SQJC->HABILI
	TRBI->DISCIP := SQJC->DISCIP
	TRBI->CH     := SQJC->CH
	
	TRBI->( MsUnlock() )
	DbSelectArea("SQJC")
	
	Dbskip()
Enddo

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � PREL0014 � Autor �  Regiane R. Barreira  � Data � 15/06/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do WORD                       			    	  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Academico              				          ���
�������������������������������������������������������������������������Ĵ��
��� Revis�o  �		                                    � Data �  		  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PREL0014()

Local cPerLet  := ""
Local cHabili  := ""
Local cAnoSem  := ""
Local cFinal   := ""
Local cDecret  := ""
Local cSepara  := Replicate(".",115)   
Local lLimTran := .T.
Local aSer_cur := Array( 10 )
Local aAss     := {}
Local nDias    := 360

Private nCntFor
Private nCntFo1

nCntFor := 0

aSer_cur[1]  := {"01","primeiro"}
aSer_cur[2]  := {"02","segundo"}
aSer_cur[3]  := {"03","terceiro"}
aSer_cur[4]  := {"04","quarto"}
aSer_cur[5]  := {"05","quinto"}
aSer_cur[6]  := {"06","sexto"}
aSer_cur[7]  := {"07","s�timo"}
aSer_cur[8]  := {"08","oitavo"}
aSer_cur[9]  := {"09","nono"}
aSer_cur[10] := {"10","d�cimo"}

//�����������������������������������������������������������������������Ŀ
//� Criando link de comunicacao com o word                                �
//�������������������������������������������������������������������������

hWord := OLE_CreateLink()
OLE_SetProperty ( hWord, oleWdVisible, .T.) //VISUALIZAR O DOT

//�����������������������������������������������������������������������Ŀ
//� Seu Documento Criado no Word                                          �
//� A extensao do documento tem que ser .DOT                              �
//�������������������������������������������������������������������������

cArqDot  := "SEC0014.DOT" // Nome do Arquivo MODELO do Word
cPathDot := Alltrim(GetMv("MV_DIRACA")) + cArqDot // PATH DO ARQUIVO MODELO WORD

//Local HandleWord
Private cPathEst:= Alltrim(GetMv("MV_DIREST")) // PATH DO ARQUIVO A SER ARMAZENADO NA ESTACAO DE TRABALHO
MontaDir(cPathEst)

If !File(cPathDot) // Verifica a existencia do DOT no ROOTPATH Protheus / Servidor
	MsgBox("Atencao... SEC0014.DOT nao encontrado no Servidor")
	
Else
	
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

	OLE_SetProperty( hWord, oleWdVisible, .F. )
	OLE_SetProperty( hWord, oleWdPrintBack, .F. )
	
	dbSelectArea("TRBC")

	// Busca o primeiro ano/semestre
	dbGoTop()    
	cAnoSem := TRBC->( ANOLET + "/" + PERIOD )
                
	// Posiciona na ultima situacao do aluno
	dbGoBottom()
	
	JAH->( dbSetOrder( 1 ) )
	JAH->( dbSeek( xFilial( "JAH" ) + TRBC->CODCUR ) )
        
 	JAF->( dbSetOrder( 1 ) )
 	JAF->( dbSeek( xFilial( "JAF" ) + JAH->JAH_CURSO + JAH->JAH_VERSAO ) )

	cDecret := MSMM(AcDecret(JAH->JAH_CURSO, TRBC->DCOLAC, JAH->JAH_UNIDAD))

	If JAF->JAF_REGIME == "001"
		nDias := 720
	ElseIf JAF->JAF_REGIME == "002"	
		nDias := 360
	ElseIf JAF->JAF_REGIME == "003"
		nDias := 180
	ElseIf JAF->JAF_REGIME == "004"
		nDias := 120
	EndIf
	
	lLimTran := ( TRBC->DTSITU + nDias >= dDataBase )
	
	If TRBC->ATIVO == "1"
		cFinal := "."
	ElseIf TRBC->ATIVO == "4" .and. lLimTran
		cFinal := ", tendo efetuado o trancamento de matricula em " + DtoC( TRBC->DTSITU )
	Else
		cFinal := ", no per�odo de " + cAnoSem + " � " + TRBC->( ANOLET + "/" + PERIOD )
	EndIf
	                                                
	OLE_SetDocumentVar(hWord, "cAtivo"    , Iif( TRBC->ATIVO == "1" .or.  (TRBC->ATIVO == "4" .and. lLimTran), "� ", "Foi " ) )
	OLE_SetDocumentVar(hWord, "cFinal"	  , cFinal)
	OLE_SetDocumentVar(hWord, "mDecret"   , If( Empty( cDecret ), " ", cDecret ) )
	OLE_SetDocumentVar(hWord, "cCurso"    , RTrim(TRBC->CURSO))
	OLE_SetDocumentVar(hWord, "cNome"     , TRBC->NOME)
	OLE_SetDocumentVar(hWord, "nPerLet"   , Right(TRBC->PERLET,1))
	OLE_SetDocumentVar(hWord, "cPerLet"   , aSer_Cur[VAL(Right(TRBC->PERLET,1)),2])
	OLE_SetDocumentVar(hWord, "cDataExtenso", Capital(Alltrim(SM0->M0_CIDENT))+", "+Alltrim(Str(Day(dDatabase)))+" de "+lower(MesExtenso(month(dDatabase)))+" de "+Alltrim(Str(Year(dDatabase)))+"." )
	
	DbSelectArea("TRBI")
	DbGoTop()
	
	nCntFor  := 0
	cPerLet  := ""
	cHabili  := ""
	
	While !Eof()
			
		//�����������������������������������������������������������������������Ŀ
		//� Gerando variaveis do documento                                        �
		//�������������������������������������������������������������������������
		nCntFor += 1
		nCntFo1 := 1
		
		If cPerLet <> TRBI->SEMEST .Or. cHabili <> TRBI->HABILI
			cPerLet := TRBI->SEMEST
			cHabili := TRBI->HABILI
			OLE_SetDocumentVar(hWord,'Adv_titulo'+alltrim(str(ncntfor)),"1")
			OLE_SetDocumentVar(hWord, "cDiscip"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), Alltrim(Str(Val(TRBI->SEMEST)))+ "o. Periodo Letivo")
			nCntFo1 += 1

			If Empty(TRBI->HABILI)
				OLE_SetDocumentVar(hWord, "cSepara"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), " ")
			Else
				OLE_SetDocumentVar(hWord, "cSepara"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), "Habilita��o: " + AllTrim(Posicione("JDK",1,xFilial("JDK") + TRBI->HABILI,"JDK_DESC")))
			EndIf

			nCntFo1 += 1
			OLE_SetDocumentVar(hWord, "nCH"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), space(10))
			nCntFo1 += 1
		Else
			OLE_SetDocumentVar(hWord,'Adv_titulo'+alltrim(str(ncntfor)),"0")
			OLE_SetDocumentVar(hWord, "cDiscip"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), TRBI->DISCIP)
			nCntFo1 += 1	
			OLE_SetDocumentVar(hWord, "cSepara"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), cSepara)
			nCntFo1 += 1
			OLE_SetDocumentVar(hWord, "nCH"+AllTrim(Str(nCntFor))+AllTrim(Str(nCntFo1)), TRBI->CH)
			nCntFo1 += 1
			DbSkip()
		Endif
		
	Enddo
	
	If nCntFor > 0
		
		//�����������������������������������������������������������������������Ŀ
		//� Nr. de linhas da Tabela a ser utilizada na matriz do Word             �
		//�������������������������������������������������������������������������
		OLE_SetDocumentVar(hWord,'Adv_Disciplinas',Str(nCntFor))
		
		//�����������������������������������������������������������������������Ŀ
		//� Executa macro do Word                                                 �
		//�������������������������������������������������������������������������
		OLE_ExecuteMacro(hWord,"disciplinas")
		
	EndIf

	//�����������������������������������������������������������������������Ŀ
	//� Gerando variaveis para assinaturas 	                	              �
	//�������������������������������������������������������������������������
	aAss := U_ACRetAss( cPRO )

	OLE_SetDocumentVar(hWord, "cAss1"   , aAss[1] )	
	OLE_SetDocumentVar(hWord, "cCargo1" , aAss[2] )	    

	aAss := U_ACRetAss( cSEC )

	OLE_SetDocumentVar(hWord, "cAss2"   , aAss[1] )
	OLE_SetDocumentVar(hWord, "cCargo2" , aAss[2] )	
	
	//�����������������������������������������������������������������������Ŀ
	//� Atualizando variaveis do documento                                    �
	//�������������������������������������������������������������������������
	OLE_UpdateFields(hWord)
	
	OLE_ExecuteMacro( hWord, "Proteger" )

	OLE_SetProperty( hWord, oleWdVisible, .T. )
	OLE_SetProperty( hWord, oleWdWindowState, "MAX" )
	
EndIf

//OLE_CloseLink( hWord, .F. )

//��������������������������������������������������������������Ŀ
//� Apaga arquivos tempor�rios		                             �
//����������������������������������������������������������������

DbSelectArea("SQJC")
DbCloseArea()

DbSelectarea("TRBC")
DbCloseArea()

DbSelectarea("TRBI")
DbCloseArea()

Return
