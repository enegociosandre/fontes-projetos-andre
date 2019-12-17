#INCLUDE "RTMSR16.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RTMSR16  � Autor �Vitor Raspa            � Data � 19.Dez.06���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Comprovante para Retirada de Reboque          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RTMSR16                                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Gestao de Transporte                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function RTMSR16()

Local titulo   := STR0001 //"Retirada de Reboque"
Local cString  := "DF7"
Local wnrel    := "RTMSR16"
Local cDesc1   := STR0002 //"Este programa ira listar os comprovantes de retirada de reboque selecionados "
Local cDesc2   := ""
Local cDesc3   := ""
Local tamanho  := "P"
Local nLimite  := 80

Private NomeProg := "RTMSR16"
Private aReturn  := {STR0003,1,STR0004,2, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private cPerg    := "RTMR16"
Private nLastKey := 0

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas                                        �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// Do Reboque                            �
//� mv_par02        	// Ate o Reboque      	                 �
//� mv_par03        	// Status                                �
//����������������������������������������������������������������
AjustaSX1()
pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR16Imp(@lEnd,wnRel,titulo,tamanho,nLimite)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RTMSR16Imp� Autor �Vitor Raspa            � Data � 19.Dez.06���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RTMSR16			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function RTMSR16Imp(lEnd,wnRel,cTitulo,nTamanho,nLimite)
Local nLin     := 80
Local cDesc1   := ''
Local cDesc2   := ''

Private m_pag  := 1

DF7->(DbSetOrder(1))
DF7->(MsSeek(xFilial('DF7') + MV_PAR01,.T.))
While !DF7->(EoF()) .And. DF7->DF7_CODRB1 <= MV_PAR02

	If Interrupcao(@lEnd)
		Exit
	Endif
	
	If MV_PAR03 == 1 .And. DF7->DF7_STATUS <> StrZero(1,Len(DF7->DF7_STATUS))
		DF7->(DbSkip())
		Loop
	ElseIf MV_PAR03 == 2 .And. DF7->DF7_STATUS <> StrZero(2,Len(DF7->DF7_STATUS))
		DF7->(DbSkip())
		Loop
	EndIf
	
	If nLin > 60
		nLin := Cabec( cTitulo, cDesc1, cDesc2, NomeProg, nTamanho ) + 1
	EndIf
	
	VerLin(@nLin,2)
	
    @ nLin, 000 PSay PadC('-------------------', 80)
	VerLin(@nLin,1)
    @ nLin, 000 PSay PadC('RETIRADA DE REBOQUE', 80)
	VerLin(@nLin,1)
    @ nLin, 000 PSay PadC('-------------------', 80)

	VerLin(@nLin,2)
	@ nLin, 000 PSay 'Emissao: ' + DtoC(dDataBase) + ' - ' + Time()
	
	VerLin(@nLin,1)
	@ nLin, 000 PSay 'Viagem : ' + DF7->(DF7_FILORI + ' / ' + DF7_VIAGEM)

	VerLin(@nLin,1)
	DTQ->(DbSetOrder(2))
	DTQ->(MsSeek(xFilial('DTQ') + DF7->(DF7_FILORI + DF7_VIAGEM)))
	@ nLin, 000 PSay 'Rota ..: ' + DTQ->DTQ_ROTA + ' - ' + Posicione('DA8',1,xFilial('DA8') + DTQ->DTQ_ROTA, 'DA8_DESC')
	
	VerLin(@nLin,2)
	@ nLin,000 PSay Replicate('-',80)
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Dados do Veiculo'
	VerLin(@nLin,1)
	@ nLin,000 PSay Replicate('-',80)
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Veiculo : ' + DF7->DF7_CODVEI
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Modelo .: ' + Posicione('DA3',1,xFilial('DA3') + DF7->DF7_CODVEI, 'DA3_DESC')
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Placa ..: ' + DA3->DA3_PLACA

	VerLin(@nLin,1)
	@ nLin,000 PSay Replicate('-',10)
	VerLin(@nLin,1)
	@ nLin,000 PSay 'MOTORISTAS'
	VerLin(@nLin,1)
	@ nLin,000 PSay Replicate('-',10)
	DUP->(DbSetOrder(1))
	If DUP->(MsSeek(xFilial('DUP') + DF7->(DF7_FILORI+DF7_VIAGEM+DF7_ITEDTR)))
		While !DUP->(EoF()) .And. DUP->(DUP_FILIAL+DUP_FILORI+DUP_VIAGEM+DUP_ITEDTR) == xFilial('DUP') + DF7->(DF7_FILORI+DF7_VIAGEM+DF7_ITEDTR)
			VerLin(@nLin,1)
			@ nLin,000 PSay DUP->DUP_CODMOT + ' - ' + Posicione('DA4',1,xFilial('DA4') + DUP->DUP_CODMOT, 'DA4_NOME')
			DUP->(DbSkip())
		EndDo
	EndIf

	VerLin(@nLin,1)
	@ nLin,000 PSay Replicate('-',09)
	VerLin(@nLin,1)
	@ nLin,000 PSay 'AJUDANTES'
	VerLin(@nLin,1)
	@ nLin,000 PSay Replicate('-',09)
	DUQ->(DbSetOrder(1))
	If DUQ->(MsSeek(xFilial('DUQ') + DF7->(DF7_FILORI+DF7_VIAGEM+DF7_ITEDTR)))
		While !DUQ->(EoF()) .And. DUQ->(DUQ_FILIAL+DUQ_FILORI+DUQ_VIAGEM+DUQ_ITEDTR) == xFilial('DUQ') + DF7->(DF7_FILORI+DF7_VIAGEM+DF7_ITEDTR)
			VerLin(@nLin,1)
			@ nLin,000 PSay DUQ->DUQ_CODAJU + ' - ' + Posicione('DAU',1,xFilial('DAU') + DUQ->DUQ_CODAJU, 'DAU_NOME')
			DUQ->(DbSkip())
		EndDo
	EndIf

	VerLin(@nLin,2)
	@ nLin,000 PSay Replicate('-',80)
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Dados do 1.o Reboque'
	VerLin(@nLin,1)
	@ nLin,000 PSay Replicate('-',80)
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Reboque : ' + DF7->DF7_CODRB1
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Modelo .: ' + Posicione('DA3',1,xFilial('DA3') + DF7->DF7_CODRB1, 'DA3_DESC')
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Placa ..: ' + DA3->DA3_PLACA

	VerLin(@nLin,2)
	@ nLin,000 PSay Replicate('-',80)
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Dados do 2.o Reboque'
	VerLin(@nLin,1)
	@ nLin,000 PSay Replicate('-',80)
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Reboque : ' + If(!Empty(DF7->DF7_CODRB2), DF7->DF7_CODRB2, '-')
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Modelo .: ' + If(!Empty(DF7->DF7_CODRB2), Posicione('DA3',1,xFilial('DA3') + DF7->DF7_CODRB1, 'DA3_DESC'), '-')
	VerLin(@nLin,1)
	@ nLin,000 PSay 'Placa ..: ' + If(!Empty(DF7->DF7_CODRB2), DA3->DA3_PLACA, '-')

	nLin := 80
	DF7->(DbSkip())
EndDo

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VerLin    � Autor �Patricia A. Salomao    � Data �27.02.2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Soma Linha                                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � VerLin(ExpN1,ExpN2)                                        ���
�������������������������������������������������������������������������Ĵ��
���Parametro � ExpN1 - No. da Linha atual                                 ���
���          � ExpN2 - No. de Linhas que devera ser somado                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RTMSR06			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function VerLin(Li,nSoma)
Li+=nSoma
If Li > 70
	Li:=1
EndIf
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1  � Autor �Vitor Raspa         � Data � 21.Ago.06  ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Inclui Perguntas no SX1                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �.T.                                                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       �RTMSR15                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()
Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}

aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
Aadd( aHelpPor, 'Informe o reboque inicial')
Aadd( aHelpPor, 'para o processamento')
Aadd( aHelpSpa, '')
Aadd( aHelpEng, '')
PutSx1(	"RTMR16","01","Do Reboque ?"	,"","","mv_ch0","C",8,0,0,"G","U_RTMSR16Vld(1)","DA3","","",;
		"mv_par01",,,,,,,,,,,,,,,,,aHelpPor,aHelpEng,aHelpSpa)

//
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
Aadd( aHelpPor, 'informe o reboque final')
Aadd( aHelpPor, 'para o processamento')
Aadd( aHelpSpa, '')
Aadd( aHelpEng, '')
PutSx1(	"RTMR16","02","Ate o Reboque ?"	,"","","mv_ch1","C",8,0,0,"G","U_RTMSR16Vld(2)","DA3","","",;
		"mv_par02",,,,,,,,,,,,,,,,,aHelpPor,aHelpEng,aHelpSpa)

//
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
Aadd(aHelpPor, 'Informe quais retiradas deverao ser') 
Aadd(aHelpPor, 'consideradas no processamento')
Aadd( aHelpSpa, '')
Aadd( aHelpEng, '')
PutSx1("RTMR16","03","Status ?","","","mv_ch2","N",1,0,1,"C","","","","",;
       "mv_par03","Em Aberto","","","","Encerrado","","","Ambos",;
       "","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �RTMSR16Vld � Autor �Vitor Raspa         � Data � 19.Dez.06  ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Valida os parametros informados pelo usuario                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�nExpN1: Parametro digitado, sendo: 1-MV_PAR01 e 2-MV_PAR02  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Logico                                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       �RTMSR16                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RTMSR16Vld( cCampo )
Local lRet     := .T.
Local aArea    := GetArea()
Local aAreaDA3 := DA3->(GetArea())
Local aAreaDUT := DUT->(GetArea())

cCampo := &('MV_PAR' + StrZero(cCampo,2))

DA3->(DbSetOrder(1))
If DA3->(MsSeek(xFilial('DA3') + cCampo))
	DUT->(dbSetOrder(1))
	DUT->(MsSeek(xFilial('DUT')+DA3->DA3_TIPVEI))
	If !DUT->(EoF()) .And. DUT->DUT_CATVEI <> '3'
			Help('',1,'TMSA24010')	//--Os veiculos do reboque deverao ser de categoria igual "3" (Carreta).
			lRet := .F.
	EndIf
EndIf
Return(lRet)