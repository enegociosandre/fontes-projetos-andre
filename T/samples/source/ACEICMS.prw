/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M460NUM  � Autor � Valdir                � Data � 28/09/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada p/ alterar o estado do cliente p/         ���
���          � MV_ESTADO																  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Gestao de Concessionarias                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M460NUM()
Local aArea:=GetArea()
Local aAreaSC5:=GetArea("SC5")
Local cEstAlt
If Type("ParamIXB") == "U" 
   ParamIXB := Nil
Endif

If ParamIXB # Nil   
	DbSelectArea("SC5")
	DbSetOrder(1)
	DbSeek(xFilial("SC5")+ParamIxb[1,1])
	If FieldPos("C5_CLIENT") > 0 .and. !Empty(C5_CLIENT)
		DbSelectArea("SA1")
		DbSetOrder(1)

      //Seleciona o Cliente p/ entrega
		DbSeek(xFilial("SA1")+SC5->C5_CLIENT+SC5->C5_LOJAENT)
		cEstAlt:=A1_EST

		//Seleciona o cliente do pedido e salva o estado
		DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		VAR_IXB := {SA1->A1_COD,SA1->A1_LOJA,SA1->A1_EST,"OFI/VEI/PEC"}
		RecLock("SA1",.F.)
		SA1->A1_EST := cEstAlt
		MsUnlock()
	EndIf
EndIf

SC5->(RestArea(aAreaSC5))
RestArea(aArea)
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M460FIM  � Autor � Valdir                � Data � 28/09/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada p/ alterar o estado do cliente p/         ���
���          � estado original do cliente											  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Gestao de Concessionarias                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M460FIM()
Local aArea:=GetArea()

If VAR_IXB # Nil .and. 	ValType(VAR_IXB) == "A" .and. Len(VAR_IXB) >= 4 .and. VAR_IXB[4] == "OFI/VEI/PEC"
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+VAR_IXB[1]+VAR_IXB[2])
	RecLock("SA1",.F.)
	SA1->A1_EST := VAR_IXB[3]
	MsUnlock()
EndIf	

RestArea(aArea)
Return .T.