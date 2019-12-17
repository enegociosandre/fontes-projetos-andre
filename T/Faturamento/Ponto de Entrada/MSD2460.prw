#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MSD2460  �Autor  �Marcos Wey da Mata  � Data � 11/11/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para gravar o centro de custo no SD2 com base no    ���
���          � centro de custo do pedido de venda                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ponto de Entrada na grava��o dos itens da Nota Fiscal de   ���
���          � Venda.                                                     ��� 
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MSD2460()
Local _AreaAtu	:= GetArea()
Local _AreaSD2	:= SD2->(GetArea())
Local _AreaSC6	:= SC6->(GetArea())

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
If Found()
	SD2->D2_CCUSTO := SC6->C6_CCUSTO
EndIf

RestArea(_AreaSC6)
RestArea(_AreaSD2)
RestArea(_AreaAtu)
Return
