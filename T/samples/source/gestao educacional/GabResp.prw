#INCLUDE "GABRESP.CH"
#INCLUDE "RWMAKE.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � GABRESP  � Autor � Eduardo de Souza      � Data � 29/07/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gabarito de Respostas                                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GABRESP()                                                  ���
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
User Function GABRESP()

Local oPrint
Local cPerg:= "ACRGAB"

Private cStartPath:= " "
Private cArqTmp   := " "

cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetADV97())
cStartPath += If(Right(cStartPath,1) <> "\","\","")

If !File(cStartPath+"Circ.BMP")
	MsgAlert(OemToAnsi(STR0004),OemToAnsi(STR0005)) // "Bitmap nao encontrado, favor entrar em contato com o Suporte Microsiga." ### "Atencao !!!"
	Return .F.
EndIf

//��������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                 �
//����������������������������������������������������������������������
//��������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                               �
//� mv_par01	// Processo Seletivo De                                �
//� mv_par02	// Processo Seletivo Ate                               �
//� mv_par03	// Candidato De                                        �
//� mv_par04	// Candidato Ate                                       �
//� mv_par05	// Inicio Vertical                                     �
//� mv_par06	// Inicio Lateral                                      �
//� mv_par07	// Avanco Vertical                                     �
//� mv_par08	// Avanco Lateral                                      �
//� mv_par09	// Sala De                                             �
//� mv_par10	// Sala Ate                                            �
//����������������������������������������������������������������������
if !Pergunte(cPerg,.T.)
	Return
endif

oPrint:= TMSPrinter():New(OemToAnsi(STR0001)) //"GABARITO DE RESPOSTAS"

oPrint:SetPortrait()

//�����������������������������������������������Ŀ
//�Chamada da rotina de filtro dos dados...       �
//�������������������������������������������������
Processa({ ||ACATRBGAB() })

Processa({ ||GABRESPImp(oPrint), OemToAnsi(STR0002), OemToAnsi(STR0003)}) // "Aguarde..." ### "Selecionando Registros..."

//�������������������������������������������Ŀ
//�Visualiza�ao antes de imprimir o Gabarito. �
//���������������������������������������������
oPrint:Preview()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �GABRESPImp� Autor � Eduardo de Souza      � Data � 29/07/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Impressao do Gabarito de Respostas                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GABRESPImp(ExpO1)                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Objeto oPrint                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GABRESP                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function GABRESPImp(oPrint)

Local oFont12
Local oFont16
Local cFileLogo := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP"
Local cAlias    := Alias()
Local cCodIns	:= '000000'
Local i

JAX->( dbSetOrder(1) )

JAH->( dbSetOrder(1) )

If !File(cFileLogo)
	cFileLogo := "LGRL"+SM0->M0_CODIGO+".BMP"
EndIf

oFont12:= TFont():New("Arial" ,12,12,,.F.,,,,.T.,.F.)
oFont16:= TFont():New("Arial" ,16,16,,.F.,,,,.T.,.F.)

DbSelectArea(cAlias)
DbGotop()

ProcRegua(RecCount())

While (cAlias)->(!Eof())
	IncProc()

	cCodIns	:= Right((cAlias)->(JA1_CODINS),6)

	//���������������������������������Ŀ
	//�Inicializa a pagina             	�
	//�����������������������������������
	oPrint:StartPage()

	//���������������������������������Ŀ
	//�Logo da Empresa.               	�
	//�����������������������������������
	If File("Logo.bmp")
		oPrint:SayBitmap(0500,0300,cStartPath+"Logo.bmp",328,82)
	Else
		oPrint:SayBitmap(0500,0300,cFileLogo,328,82)
	EndIf
	
	//���������������������������������Ŀ
	//�Dados do Candidato             	�
	//�����������������������������������
	JAX->( dbSeek( xFilial("JAX")+(cAlias)->(JA1_CODINS) ) )
	JAH->( dbSeek( xFilial("JAH")+JAX->JAX_CODCUR ) )
	
	oPrint:Say(0900,0150,STR0006+(cAlias)->(JA1_NOME),oFont12) //"Nome: "
	oPrint:Say(0950,0150,STR0007+Alltrim(JAH->JAH_DESC)+" ("+Alltrim(Tabela("F5", JAH->JAH_TURNO))+")",oFont12) //"Curso: "
	oPrint:Say(1000,0150,STR0010+(cAlias)->(JA1_CODINS),oFont12) //"N�: "
	oPrint:Say(1000,0600,STR0009+(cAlias)->(JAV_CODPRE),oFont12) //"Predio: "
	oPrint:Say(1000,0950,STR0008+(cAlias)->(JAV_CODSAL),oFont12) //"Sala: "

	//���������������������������������Ŀ
	//�Numero da Inscricao do Candidato.�
	//�����������������������������������
	for i := 0 to 5
		oPrint:Say( mv_par05 - 120, mv_par06 + ( mv_par08 * i ) , Subs( cCodIns, i+1, 1), oFont16 )
	next i

	for i := 0 to 5
		oPrint:SayBitmap( mv_par05 + ( mv_par07 * Val( Subs( cCodIns, i+1, 1 ) ) ), mv_par06 + ( mv_par08 * i ) , cStartPath+"Circ.bmp", 040, 040 ) // Linha:0 Coluna:1
	next i		

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
���Fun��o	 �ACATRBGAB � Autor � Eduardo de Souza      � Data � 30/07/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Armazenamento e Tratamento dos dados 					        ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  � ACATRBGAB()                       				              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �	GABRESP                                            		  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function ACATRBGAB()

Local cQuery := ""

cQuery := "SELECT " 
cQuery += " JA1.JA1_PROSEL, JA1.JA1_CODINS, JA1.JA1_NOME, JA1.JA1_LOCAL, "
cQuery += " JAV.JAV_CODPRE, JAV.JAV_ANDAR, JAV.JAV_CODSAL, JA1.JA1_STATUS "
cQuery += "From  "+ RetSQLName("JA1")+ " JA1 , " + RetSQLName("JAV") + " JAV "
cQuery += " Where JA1.JA1_FILIAL  = '" + xFilial("JA1") +"' And "
cQuery += "JAV.JAV_FILIAL = '" + xFilial("JAV") + "' And "
cQuery += "JA1.JA1_PROSEL Between '" + mv_par01 + "' And '" + mv_par02 + "' And "
cQuery += "JA1.JA1_CODINS Between '" + mv_par03 + "' And '" + mv_par04 + "' And "
cQuery += "JA1.JA1_STATUS Between '03' And '04' And "
cQuery += "JAV.JAV_CODSAL Between '" + mv_par09 + "' And '" + mv_par10 + "' And "
cQuery += "JAV.JAV_CODCAN = JA1.JA1_CODINS And "
cQuery += "JAV.JAV_CODPRO = JA1.JA1_PROSEL And "
cQuery += "JAV.D_E_L_E_T_ <> '*' And "
cQuery += "JA1.D_E_L_E_T_ <> '*' "
cQuery += "	Order by JA1_LOCAL,JAV_CODPRE,JAV_CODSAL,JA1_NOME"
cQuery := ChangeQuery(cQuery)             	        

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

dbSelectArea ("TRB")

Return