#include "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MT103IPC � Autor � Daniel                � Data � 15/09/11 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada na amarracao do pedido de compra na       ���
���          � nota fiscal de entrada                                     ���
���          � Finalidade: atualizar campo D1_ZZDESCI (Descricao do Prod) ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
/*/
User Function MT103IPC()

Local nItem		:= PARAMIXB[1]
Local cDescr	:= SC7->C7_DESCRI
Local nPosDesc	:= GDFIELDPOS("D1_ZZDESC") 
	
	If nPosDesc > 0 .and. nItem > 0
		aCols[ nItem , nPosDesc ] := cDescr		
	Endif
    
Return