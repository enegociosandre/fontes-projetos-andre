#Include "rwmake.ch"
#Include "Topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � zzGatilho� Autor � Marcos da Mata        � Data � 17/02/12 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa de preenchimento de conta contabil conforme Centro���
���          �  de Custo 												  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������Ŀ��
���Alterado  � Marcos da Mata                           � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Gatilho no campo D1_CC                                     ���
���          � Iif(INCLUI,U_zzGatilho(),nil)							  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/

User Function zzGatilho(cCC,cProd)

&&Local cCC    := ""
&&Local cProd  := ""
Local cConta := ""
Local aArea  := GetArea()

&&cCC   := M->D1_CC
&&cProd := M->D1_COD

SD1->(dbSetOrder(1))                 
SB1->(dbSetOrder(1))
SM4->(dbSetOrder(1))


	If SB1->(dbSeek( xFilial("SB1") + cProd ))
		If SUBSTR(cCC,1,4)$	FORMULA("CCD")	&&"1100,1101"	&& DESPESAS
			cConta := SB1->B1_ZZDESP
		ElseIf SUBSTR(cCC,1,4)$ FORMULA("CCC")	&&"1105,1111"	&&CUSTO
			cConta := SB1->B1_ZZCUSTO
		ElseIf SUBSTR(cCC,1,4)$ FORMULA("CCE")	&&"2000"	&&ESTOQUE
			cConta := SB1->B1_CONTA
		EndIf
	EndIf	

SB1->(dbCloseArea())
SM4->(dbCloseArea())
   
If Empty(cConta)
	Alert("Verifique se as Contas Contabeis de Custo, Despesa e Estoque estao devidamente preenchidas")
	cConta := "CC NAO PREVISTO"
EndIf

RestArea(aArea)

Return cConta