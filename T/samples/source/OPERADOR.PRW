#INCLUDE 'RWMAKE.CH'
#INCLUDE "OPERADOR.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ApdlOper  � Autor �Equipe Materiais II    � Data �22/06/01  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � RAS - Programa de atualizacao de ambiente para operador    ���
���          � Logistico, configurando o SX2,SX3 e SX6.                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Implantacao APDL para operador logistico                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function APDLOper

Local nOpca:=0,nLoop:=0
Local aAreaSM0:=SM0->(GetArea()),aAreaSX2:=SX2->(GetArea()),aAreaSX3:=SX3->(GetArea())
Local aEmpresas:={},aBancos:={}
Local cEmpresas:="",cFilialOp:="",cMens:="",cBanco:=""
Local cArqSx2 := "SX2" + SM0->M0_CODIGO + "0",cIndSx2:=cArqSx2
Local cSugereExcl:="SA1,SA2,SB1,SB2,SB3,SB4,SB5,SB6,SB7,SB8,SB9,SBC,SBD,SBJ,SBM,SC0,SC1,SC2,SC3,SC4,SC5,SC6,SC7,SC8,SC9,SD1,SD2,SD3,SD4,SD5,SDC,SF1,SF2,SF4,SF5,SG1,SG2,SJ3"
Local lAll:=.F.,lCriaCampos:=.F.
Local oCbx,oBanco,oChk,oChk2
Local oOk := LoadBitmap( GetResources(), "LBOK")
Local oNo := LoadBitmap( GetResources(), "LBNO")

cMens := OemToAnsi(STR0001)+chr(13) //'Esta rotina so deve ser utilizada antes da utilizacao do sistema !!!'
cMens += OemToAnsi(STR0002)+chr(13) //'Esta  rotina  exige  que  os   arquivos associados a ela '
cMens += OemToAnsi(STR0003)+chr(13) //'nao estejam em uso por outras estacoes.'
cMens += OemToAnsi(STR0004)+chr(13) //'Fa�a com que os outros usuarios saiam do sistema.'
cMens += OemToAnsi(STR0005)+chr(13) //'Este programa deve rodar Exclusivo !!! '

//��������������������������������������������������������������Ŀ
//� So continua se conseguir abrir o SX2 como exclusivo          �
//����������������������������������������������������������������
If MsgYesNo(cMens,STR0006) .And. OpenSX2Excl(cArqSx2,cIndSx2) //'ATENCAO'
	//��������������������������������������������������������������Ŀ
	//� Monta array de bancos e tabela de campos                     �
	//����������������������������������������������������������������
	dbSelectArea("SX2")
	dbClearFilter()
	dbSetOrder(1)
	dbGoTop()
	While !EOF()
		If !(Upper(AllTrim(X2_CHAVE)) == "SX5") .and. !(Upper(AllTrim(X2_CHAVE)) == "SR5") .and. ;
			!(Upper(AllTrim(X2_CHAVE)) == "SYN") .and. !(Upper(AllTrim(X2_CHAVE)) == "SYO")
			AADD(aBancos,{.F.,x2_chave+"   "+Capital( X2Nome() ),x2_chave})
			//��������������������������������������������������������������Ŀ
			//� Marca arquivos sugeridos como exclusivos                     �
			//����������������������������������������������������������������
			If X2_CHAVE $ cSugereExcl
				aBancos[Len(aBancos),1]:=.T.
			EndIf
		EndIf
		DbSkip()
	End
	//��������������������������������������������������������������Ŀ
	//� Monta array com as filiais possiveis                         �
	//����������������������������������������������������������������
	DbSelectArea("SM0")
	dbGoTop()
	While !SM0->(Eof())
		If SM0->M0_CODIGO == cEmpAnt
			AADD(aEmpresas,SM0->M0_CODFIL+" "+SM0->M0_FILIAL+" "+SM0->M0_NOME)
		EndIf
		dbSkip()
	End
	RestArea(aAreaSM0)
	//��������������������������������������������������������������Ŀ
	//� Seta variaveis para selacao das filiais                      �
	//����������������������������������������������������������������
	cEmpresas:=aEmpresas[1]
	cFilialOp:=Substr(cEmpresas,1,2)
	//��������������������������������������������������������������Ŀ
	//� Monta janela para selecao dos parametros                     �
	//����������������������������������������������������������������
	DEFINE MSDIALOG oDlg FROM 96,9 TO 310,592 TITLE OemToAnsi(STR0007) PIXEL //"Parametros"
	@ 08,06 TO 032,200 LABEL "" OF oDlg  PIXEL
	@ 07,12 SAY STR0008 SIZE 158,8 OF oDlg PIXEL //"Selecione a filial utilizada para administrar o Operador Logistico"
	@ 15,12 MSCOMBOBOX oCbx VAR cEmpresas ITEMS aEmpresas SIZE 111, 43 OF oDlg PIXEL ON CHANGE ( cFilialOp:=Substr(cEmpresas,1,2))
	@ 34,06 TO 090,200 LABEL "" OF oDlg  PIXEL
	@ 33,12 SAY STR0009 SIZE 178,8 OF oDlg PIXEL //"Selecione os arquivos que devem ser exclusivos no Operador Logistico"
	@ 42,12 LISTBOX oBanco VAR cBanco Fields HEADER "",STR0010  SIZE 150,45 ON DBLCLICK (aBancos:=AOperTroca(oBanco:nAt,aBancos),oBanco:Refresh()) OF oDlg PIXEL //"Arquivos"
	oBanco:SetArray(aBancos)
	oBanco:bLine := { || {If(aBancos[oBanco:nAt,1],oOk,oNo),aBancos[oBanco:nAt,2]}}
	@ 34,205 TO 090,285 LABEL "" OF oDlg  PIXEL
	@ 45,210 CHECKBOX oChk VAR lAll PROMPT STR0011 SIZE 67,10 OF oDlg PIXEL ON CLICK (AEval(aBancos, {|nLoop| nLoop[1] := lAll}), oBanco:Refresh(.F.)) //"Marca/Desmarca Todos"
	@ 65,210 CHECKBOX oChk2 VAR lCriaCampos PROMPT STR0012 SIZE 65,10 OF oDlg PIXEL //"Cria campos no SX3"
	DEFINE SBUTTON FROM 16, 224 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 16, 251 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg
	//��������������������������������������������������������������Ŀ
	//� Processa atualizacao necessaria dos arquivos envolvidos      �
	//����������������������������������������������������������������
	If nOpca == 1
		Processa({|lEnd| OperProc(cFilialOP,aBancos,lCriaCampos,@lEnd)},STR0013,STR0014,.F.) //"Processando"###"Aguarde , processando preparacao dos arquivos"
	EndIf
EndIf
DeleteObject(oOk)
DeleteObject(oNo)
RestArea(aAreaSX2)
RestArea(aAreaSX3)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �OperProc  � Autor �Equipe Materiais II    � Data �26/06/01  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de processamento da gravacao dos arquivos           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Implantacao APDL para operador logistico                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function OperProc(cFilialOP,aBancos,lCriaCampos,lEnd)
Local aLogs:={{}},aCpoFilial:={}
Local cCampoFil:=""
Local nLoop,nAchou,i
Local lContinua:=.T.
//����������������������������������������������������������������������Ŀ
//� Le estrutura do campo filial para criar campos com a mesma estrutura �
//������������������������������������������������������������������������
If lCriaCampos
	cMens := OemToAnsi(STR0015)+chr(13) //'Voce habilitou a opcao de criacao de campos. Esses campos serao '
	cMens += OemToAnsi(STR0016)+chr(13) //'criados no dicionario de dados mas nao serao criados nos arquivos do sistema.'
	cMens += OemToAnsi(STR0017)+chr(13) //'Esta opcao so deve ser utilizada quando os arquivos ainda nao foram criados.'
	cMens += OemToAnsi(STR0018)+chr(13) //'Tem certeza de que os campos devem ser criados no dicionario de dados ?'
	//��������������������������������������������������������������Ŀ
	//� So continua se usuario autorizar criacao no SX3              �
	//����������������������������������������������������������������
	lContinua:=MsgYesNo(cMens,STR0006) //'ATENCAO'
	dbSelectArea("SX3")
	dbSetOrder(2)
	If dbSeek("A1_FILIAL")
		For i:=1 to FCount()
			AADD(aCpoFilial,FieldGet(i))
		Next i
	EndIf
EndIf
If lContinua
	//����������������������������������������������������������������������Ŀ
	//� Verifica a existencia dos parametros no SX6                          �
	//������������������������������������������������������������������������
	If GETMV("MV_APDLOPE",.T.)
		// Altera parametros do SX6
		PutMV("MV_APDLOPE",.T.)
	Else
		For i:=1 to Len(aLogs)
			nAchou:=ASCAN(aLogs[i],{|x| x[1] == "PARAMETRO" .And. x[2] == "MV_APDLOPE"})
			If nAchou > 0
				Exit
			EndIf
		Next i
		If nAchou == 0
			If Len(aLogs[Len(aLogs)]) > 4095
				AADD(aLogs,{})
			EndIf
			AADD(aLogs[Len(aLogs)],{"PARAMETRO","MV_APDLOPE"})
		EndIf
	EndIf
	//����������������������������������������������������������������������Ŀ
	//� Verifica a existencia dos parametros no SX6                          �
	//������������������������������������������������������������������������
	If GETMV("MV_APDLFOP",.T.)
		// Altera parametros do SX6
		PutMV("MV_APDLFOP",cFilialOp)
	Else
		For i:=1 to Len(aLogs)
			nAchou:=ASCAN(aLogs[i],{|x| x[1] == "PARAMETRO" .And. x[2] == "MV_APDLFOP"})
			If nAchou > 0
				Exit
			EndIf
		Next i
		If nAchou == 0
			If Len(aLogs[Len(aLogs)]) > 4095
				AADD(aLogs,{})
			EndIf
			AADD(aLogs[Len(aLogs)],{"PARAMETRO","MV_APDLFOP"})
		EndIf
	EndIf
	// Grava arquivos que devem ser exclusivos no SX2
	dbSelectArea("SX2")
	ProcRegua(Len(aBancos))
	For nLoop:=1 to Len(aBancos)
		IncProc()
		// Verifica se o arquivo deve ser compartilhado ou exclusivo
		If dbSeek(aBancos[nLoop,3])
			// Exclusivos
			If aBancos[nLoop,1]
				Reclock("SX2",.F.)
				Replace X2_MODO With "E"
				MsUnlock()
				// Compartilhados
			Else
				Reclock("SX2",.F.)
				Replace X2_MODO With "C"
				MsUnlock()
				//����������������������������������������������������������������������Ŀ
				//� Verifica a existencia do campo "_FILANT" no SX3                      �
				//������������������������������������������������������������������������
				SX3->(dbSetOrder(2))
				cCampoFil:=If ( Subs(SX2->X2_CHAVE, 1, 1) == "S", Subs(SX2->X2_CHAVE, 2, 2) + "_MSFIL", Subs(SX2->X2_CHAVE, 1, 3) + "_MSFIL" )
				If !(SX3->(dbSeek(cCampoFil)))
					//����������������������������������������������������������������������Ŀ
					//� Caso crie os campos no SX3, pesquisa a Ordem dos campos              �
					//������������������������������������������������������������������������
					If lCriaCampos
						SX2->(dbSkip())
						If SX2->(Eof())
							SX3->(dbSetOrder(1))
							SX3->(dbgoBottom())
							cNewOrdem:=Soma1(SX3->X3_ORDEM)
						Else
							SX3->(dbSetOrder(1))
							If SX3->(dbSeek(SX2->X2_CHAVE+"01"))
								SX3->(dbSkip(-1))
								cNewOrdem:=Soma1(SX3->X3_ORDEM)
							Else
								cNewOrdem:="99"
							EndIf
						EndIf
						SX2->(dbSkip(-1))
						//����������������������������������������������������������������������Ŀ
						//� Inclui o registro referente ao campo no SX3                          �
						//������������������������������������������������������������������������
						Reclock("SX3",.T.)
						For i:=1 to FCount()
							FieldPut(i,aCpoFilial[i])
						Next i
						Replace X3_ARQUIVO With SX2->X2_CHAVE
						Replace X3_CAMPO   With cCampoFil
						Replace X3_ORDEM   With cNewOrdem
						MsUnlock()
						//����������������������������������������������������������������������Ŀ
						//� Caso NAO crie os campos no SX3, inclui a ocorrencia no LOG           �
						//������������������������������������������������������������������������
					Else
						For i:=1 to Len(aLogs)
							nAchou:=ASCAN(aLogs[i],{|x| x[1] == "CAMPO" .And. x[2] == cCampoFil })
							If nAchou > 0
								Exit
							EndIf
						Next i
						If nAchou == 0
							If Len(aLogs[Len(aLogs)]) > 4095
								AADD(aLogs,{})
							EndIf
							AADD(aLogs[Len(aLogs)],{"CAMPO",cCampoFil})
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Next nLoop
	// Imprime Logs de inconsistencias
	If Len(aLogs[1]) > 0
		OperadLLog(aLogs)
	EndIf
EndIf

RETURN Nil

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � AOperTroca                                                 ���
��������������������������������������������������������������������������Ĵ��
��� Autor     � Equipe Materiais II                      � Data � 25.06.01 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Troca marcador entre x e branco                            ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function AOperTroca(nIt,aArray)

aArray[nIt,1] := !aArray[nIt,1]

Return aArray

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �OperadLLog� Autor �Equipe Materiais II    � Data � 25/06/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de inconsistencia na implantacao para Operador   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � APDL                                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function OperadlLog(aLogs)
//��������������������������������������������������������������Ŀ
//� Variaveis obrigatorias dos programas de relatorio            �
//����������������������������������������������������������������
LOCAL titulo   := STR0019 //"Inconsistencias Impl. Operador Logistico"
LOCAL cDesc1   := STR0020 //"O operador logistico exige uma configuracao especifica em determinados"
LOCAL cDesc2   := STR0021 //"parametros e arquivos do sistema. Este programa avisa aos responsaveis"
LOCAL cDesc3   := STR0022 //"sobre as nao conformidades encontradas no processo de implantacao."
LOCAL cString  := "  "
LOCAL wnrel    := "OPERLOG"

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private padrao de todos os relatorios         �
//����������������������������������������������������������������
PRIVATE aReturn:= {STR0023,1,STR0024, 2, 2, 1, "",1 } //"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0,cPerg:="      "

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel:=	SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,.F.)
If nLastKey = 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| OperImp(@lEnd,wnRel,titulo,aLogs)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � OperImp  � Autor �Equipe Materiais II    � Data � 25/06/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � OPERADOR                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function OperImp(lEnd,WnRel,titulo,aLogs)
//��������������������������������������������������������������Ŀ
//� Variaveis locais exclusivas deste programa                   �
//����������������������������������������������������������������
LOCAL Tamanho  := "P"
LOCAL nTipo    := 0
LOCAL cRodaTxt := STR0025,cDescr:="",cSolucao:="" //"REGISTRO(S)"
LOCAL nCntImpr := 0
LOCAL i,z

//��������������������������������������������������������������Ŀ
//� Inicializa variaveis para controlar cursor de progressao     �
//����������������������������������������������������������������
SetRegua(Len(aLogs))

//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//���������������������������������������������������������������������
nTipo  := IIF(aReturn[4]==1,15,18)

//��������������������������������������������������������������Ŀ
//� Contadores de linha e pagina                                 �
//����������������������������������������������������������������
PRIVATE li := 80 ,m_pag := 1

//����������������������������������������������������������Ŀ
//� Cria o cabecalho.                                        �
//������������������������������������������������������������
cabec1 := STR0026 //"DESCRICAO OCORRENCIA"
cabec2 := STR0027 //"SOLUCAO SUGERIDA"
//         0         1         2         3         4         5         6         7         8
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890

For i:=1 to Len(aLogs)
	IncRegua()
	For z:=1 to Len(aLogs[i])
		If li > 58
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		If aLogs[i,z,1] == "PARAMETRO"
			cDescr:=STR0028+aLogs[i,z,2]+STR0029 //"O PARAMETRO "###" NAO FOI ENCONTRADO NO SX6"
			cSolucao:=STR0030 //"FAVOR CRIAR O PARAMETRO COM O TIPO CORRETO"
		ElseIf aLogs[i,z,1] == "CAMPO"
			cDescr:=STR0031+aLogs[i,z,2]+STR0032 //"O CAMPO "###" NAO FOI ENCONTRADO NO SX3"
			cSolucao:=STR0033 //"FAVOR CRIAR O CAMPO COM O TIPO E TAMANHO CORRETO"
		EndIf
		@ li,000 PSay cDescr
		li++
		@ li,000 PSay cSolucao
		li+=2
	Next z
Next i
IF li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF
Set Device to Screen
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return Nil