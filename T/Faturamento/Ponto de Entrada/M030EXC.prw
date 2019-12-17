#include "topconn.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � M030EXC  � Autor �Marcos Wey da Mata  � Data � 28/07/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada apos Exclusao de Cliente                  ���
�������������������������������������������������������������������������͹��
���																		  ���
���																		  ���
���																		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M030EXC()

Local cQuery	:=	""
Local aArea 	:= 	GetArea()

if	!Empty(SA1->A1_ZZITEM)
	cQuery	:=	"UPDATE " + RetSQLName("CTD") + " "
	cQuery	+=	"SET D_E_L_E_T_ = '*' "
	cQuery	+=	"WHERE CTD_ITEM = '" + SA1->A1_ZZITEM 		+ "' AND CTD_FILIAL = '" + xFilial("CTD") + "' "

 	TcSqlExec(cQuery)
endif

RestArea(aArea)

Return