#INCLUDE "GABRED.CH"
#INCLUDE "RWMAKE.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � GABRESP  � Autor �Regiane Rocha Barreira � Data � 07/11/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gabarito de Redacao                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GABRED()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAGAC                                                    ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function GABRED()

Local oPrint
Local cPerg:= "ACRRED"

Private cStartPath:= " "
Private cArqTmp   := " "

nLastKey    := 0

cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetADV97())
cStartPath += If(Right(cStartPath,1) <> "\","\","")

If !File(cStartPath+"Circ.BMP")
	MsgAlert(STR0004,STR0005) // "Bitmap nao encontrado, favor entrar em contato com o Suporte Microsiga." ### "Atencao !!!"
	Return .F.
EndIf

//��������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                 �
//����������������������������������������������������������������������
//��������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                               �
//� mv_par01	// Processo Seletivo De                                �
//� mv_par02	// Processo Seletivo Ate                               �
//� mv_par03	// Fase  		                                       �
//� mv_par04	// Candidato De                                        �
//� mv_par05	// Candidato Ate                                       �
//� mv_par06	// Inicio Vertical                                     �
//� mv_par07    // Inicio Lateral                                      �
//� mv_par08	// Avanco Lateral                                      �
//� mv_par09	// Sala De                                             �
//� mv_par10	// Sala Ate                                            �
//����������������������������������������������������������������������
If !Pergunte(cPerg,.T.)
	Set Filter To
	Return
EndIf

oPrint:= TMSPrinter():New(STR0001) //"GABARITO DE REDACAO"

If nLastKey == 27
	Set Filter To
	Return
EndIf

oPrint:SetPortrait()

//�����������������������������������������������Ŀ
//�Chamada da rotina de filtro dos dados...       �
//�������������������������������������������������
Processa({ || ACATRBRED() })

Processa({ || GABREDImp(oPrint), STR0002, STR0003}) // "Aguarde..." ### "Selecionando Registros..."

//�������������������������������������������Ŀ
//�Visualiza�ao antes de imprimir o Gabarito. �
//���������������������������������������������
oPrint:Preview()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �GABREDImp � Autor �Regiane Rocha Barreira � Data � 07/11/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Impressao do Gabarito de Redacao                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GABREDImp(ExpO1)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Objeto oPrint                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GABRED                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function GABREDImp(oPrint)

Local oFont12
Local cFileLogo := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP"
Local cBin	    := ""
Local nCol      := 331
Local cAlias    := Alias()
Local cDec      := ""
Local nDec      := 0
Local nTx       := 0

JAX->( DbSetOrder(1) )

JAH->( DbSetOrder(1) )

JA6->( dbSetOrder(1) )

If !File( cFileLogo )
	cFileLogo := "LGRL"+SM0->M0_CODIGO+".BMP"
EndIf

oFont12:= TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)

DbSelectArea(cAlias)
DbGotop()

ProcRegua(RecCount())

While (cAlias)->(!Eof())
	IncProc()
	cDescSala:= " "
	cDescCur := " "
	cDec     := (cAlias)->(JA1_CODINS)
	nDec     := Val(cDec)
	//�����������������������������������������������������������������������������Ŀ
	//�Chamada da rotina que transforma a incricao do candidato em binario...       �
	//�������������������������������������������������������������������������������
	cBin := DecToBin(nDec)

	//���������������������������������Ŀ
	//�Inicializa a pagina             	�
	//�����������������������������������
	oPrint:StartPage()

	//���������������������������Ŀ
	//�Preenchimento Inscricao.   �
	//�����������������������������   
	nCol := mv_par07	// mv_par07 = 340
	For ntx = 1 to Len(cBin)
		If SubStr(cBin,ntx,1) == "1"
			oPrint:SayBitmap(mv_par06,nCol,cStartPath+"Circ.bmp",040,040) // mv_par06 = 160
		EndIf
		nCol := nCol + mv_par08	// mv_par08 = 50
	Next

	//���������������������������������Ŀ
	//�Logo da Empresa.               	�
	//�����������������������������������
	If File("Logo.bmp")
		oPrint:SayBitmap(0300,0300,cStartPath+"Logo.bmp",328,82)
	Else
		oPrint:SayBitmap(0300,0300,cFileLogo,328,82)
	EndIf

	//���������������������������������Ŀ
	//�Dados do Candidato             	�
	//�����������������������������������
	JA6->( dbSeek( xFilial("JA6")+(cAlias)->(JA1_PROSEL) ) )
	JAX->( dbSeek( xFilial("JAX")+(cAlias)->(JA1_CODINS) ) )
	JAH->( dbSeek( xFilial("JAH")+JAX->JAX_CODCUR ) )
	
	oPrint:Say(0480,0300,Alltrim(JA6->JA6_DESC)+" - "+Alltrim(Str(Val(mv_par03),1,0))+STR0011+" - "+JA6->JA6_ANOLET,oFont12)	//"� FASE"
	oPrint:Say(0530,0300,STR0006+(cAlias)->(JA1_NOME),oFont12) //"Nome: "
	oPrint:Say(0580,0300,STR0007+Alltrim(JAH->JAH_DESC)+" ("+Alltrim(Tabela("F5", JAH->JAH_TURNO))+")",oFont12) //"Curso: "
	oPrint:Say(0630,0300,STR0010+(cAlias)->(JA1_CODINS),oFont12) //"N�: "
	oPrint:Say(0630,0750,STR0009+(cAlias)->(JAV_CODPRE),oFont12) //"Predio: "
	oPrint:Say(0630,1100,STR0008+(cAlias)->(JAV_CODSAL),oFont12) //"Sala: "
	
	//���������������������������������Ŀ
	//�Finaliza a pagina                �
	//�����������������������������������
	oPrint:EndPage()
	DbSelectArea(cAlias)
	DbSkip()
EndDo

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �ACATRBRED � Autor �Regiane Rocha Barreira � Data � 07/11/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Armazenamento e Tratamento dos dados 			          ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � ACATRBRED()                       				          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �	GABRED                                            		  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function ACATRBRED()

Local cQuery  := ""

cQuery := "SELECT "
cQuery += " JA1.JA1_PROSEL, JA1.JA1_CODINS, JA1.JA1_NOME, JA1.JA1_LOCAL, "
cQuery += " JAV.JAV_CODPRE, JAV.JAV_ANDAR , JAV.JAV_CODSAL, JA1.JA1_STATUS "
cQuery += "From  "+ RetSQLName("JA1")+ " JA1 , " + RetSQLName("JAV") + " JAV "
cQuery += " Where JA1.JA1_FILIAL  = '" + xFilial("JA1") +"' And " 
cQuery += "JAV.JAV_FILIAL = '" + xFilial("JAV") + "' And "
cQuery += "JA1.JA1_PROSEL Between '" + mv_par01 + "' And '" + mv_par02 + "' And "
cQuery += "JA1.JA1_CODINS Between '" + mv_par04 + "' And '" + mv_par05 + "' And "
cQuery += "JA1.JA1_STATUS Between '03' And '04' And "
cQuery += "JAV.JAV_CODSAL Between '" + mv_par09 + "' And '" + mv_par10 + "' And "
cQuery += "JAV.JAV_CODCAN = JA1.JA1_CODINS And "
cQuery += "JAV.JAV_CODPRO = JA1.JA1_PROSEL And "
cQuery += "JAV.D_E_L_E_T_ <> '*' And "
cQuery += "JA1.D_E_L_E_T_ <> '*' "
cQuery += "	Order by JA1_LOCAL, JAV_CODPRE, JAV_CODSAL, JA1_NOME"

cQuery := ChangeQuery(cQuery)             	        

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

dbSelectArea ("TRB")

Return                                                            


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � DecToBin � Autor � Fabio F. Pessoa       � Data � 19/11/98 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Transforma um n�mero Decimal em uma string Binaria.        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � DecToBin(ExpN1)              						      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 := N�mero decimal          						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SigaTer   									              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function DecToBin(nDec)
LOCAL nDividendo := nDec
LOCAL nResto     := 0
Local sBin       := ""
 
While nDividendo >= 2
 
 nResto     := Mod(nDividendo,2)
 nDividendo := Int(nDividendo / 2)
 sBin       := ALLTRIM(Str(nResto)) + sBin
 
EndDo
 
sBin := ALLTRIM(Str(nDividendo)) + sBin
 
Return(sBin)