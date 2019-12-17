#Include "rwmake.ch"
#Include "Topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � zCodFor  � Autor � Marcos da Mata        � Data � 12/11/08 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa de Codigo Inteligente para o Fornecedor           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������Ŀ��
���Alterado  � Marcos da Mata                           � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Gatilho no campo A2_ZZTIPO                                 ���
���          � Iif(INCLUI,U_zCodFor(),nil)								  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/

User Function zCodFor(cCod)

Local cTipo   := ""
Local cCod    := ""
Local cCodA   := ""
Local cCodB   := ""
Local aArea	  := GetArea()

cTipo := M->A2_ZZTIPO

dbSelectArea("SA2")
_cCmdSA2 := " SELECT A2_COD FROM " + RetSqlName("SA2")
_cCmdSA2 += " WHERE "
_cCmdSA2 += " D_E_L_E_T_ = ' ' AND "
_cCmdSA2 += " A2_COD LIKE '"+cTipo+"%' "
_cCmdSA2 += " ORDER BY A2_COD DESC"

TcQuery _cCmdSA2 New Alias "CSA2"

dbSelectArea("CSA2")
CSA2->(dbGoTop())

While CSA2->(!EOF())
	
	cCodA := Val(substr(CSA2->A2_COD,2,5))
	cCodA++
	cCodB := cTipo+Strzero(cCodA,5)
	
	dbSelectarea("SA2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SA2")+cCodB)
		cCod := cCodB
		CSA2->(dbCloseArea())
		Return cCod
	Endif
	
	CSA2->(dbSkip())
	
Enddo

CSA2->(dbCloseArea())

If cCod == ""
	cCod := cTipo+"00001"
Endif

RestArea(aArea)

Return cCod