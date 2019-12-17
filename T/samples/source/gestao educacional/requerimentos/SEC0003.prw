#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC003a   �Autor  �Rafael Rodrigues    � Data �  14/jun/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Regra Final do Requerimento de Cartao Magnetico.            ���
���          �Rotina para incrementar o sequencial do cartao no cadastro  ���
���          �do aluno.                                                   ���
�������������������������������������������������������������������������͹��
���Param.    �ExpC1 : RA do aluno.                                        ���
���          �ExpC2 : Nome do arquivo .DOT com o protocolo de retirada.   ���
�������������������������������������������������������������������������͹��
���Retorno   �ExpL1 : Informando se a gravacao obteve sucesso             ���
�������������������������������������������������������������������������͹��
���Uso       �Gestao Educacional - Requerimentos                          ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SEC0003a(cNumRA, cDot)
local aArea		:= GetArea()
local lRet		:= .F.
local aDados	:= {}
cDot := if( cDot == nil, "", cDot)

JA2->(dbSetOrder(1))
if JA2->(dbSeek(xFilial("JA2")+PadR(cNumRA, TamSX3("JA2_NUMRA")[1])))
	RecLock("JA2", .F.)
	JA2->JA2_VERCAR	:= Soma1(JA2->JA2_VERCAR)
	msUnlock("JA2")
	
	lRet	:= .T.
endif


//���������������������������������������������������������Ŀ
//�Se receber o nome do arquivo .DOT como segundo parametro,�
//�exibe o .DOT para emiss�o do protocolo de retirada.      �
//�����������������������������������������������������������
if !Empty(cDot)

	// Atualizar estas informacoes conforme o layout do .DOT
	aAdd( aDados, { "RA"         , JBH->JBH_CODIDE } )
	aAdd( aDados, { "NOME"       , Posicione( "JA2", 1, xFilial( "JA2" ) + JBH->JBH_CODIDE, "JA2_NOME" ) } )
	aAdd( aDados, { "VIA"		 , Alltrim( Str( Val( JA2->JA2_VERCAR ), 3, 0 ) )+"� " } )	// 1a, 2a...
	aAdd( aDados, { "HOJE"       , dDataBase } )
	aAdd( aDados, { "FUNCIONARIO", cUserName } )

	ACImpDoc( cDot, aDados )

endif

RestArea(aArea)
Return lRet
