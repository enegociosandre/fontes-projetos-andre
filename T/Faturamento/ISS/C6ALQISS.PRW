#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �C6ALQISS  � Autor � TOTVS            � Data �  14/06/2011   ���
�������������������������������������������������������������������������͹��
���Descricao � Busca a Aliquota de ISS no Cadastro do Fornecedor para o   ���
���          � Municipio do ISS quando preenchido no Pedido de Venda      ���
�������������������������������������������������������������������������͹��
���Uso       � Colocar na Validacao de Usuario do campo C5_FORNISS        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function C6ALQISS
Local nX
for nX:=1 to len(acols)
	If ( (!aCols[nX][len(aHeader)+1]))
		if !EMPTY(M->C5_FORNISS)
			acols[nX][AScan(aHeader,{|aItem| UPPER(AllTrim(aItem[2]))=="C6_ZZALISS"})]:=RETFIELD("SA2",1,XFILIAL("SA2")+M->C5_FORNISS+"00","A2_ZZALISS")
		ENDIF
	endif
next    
getdrefresh()
Return(.T.)
