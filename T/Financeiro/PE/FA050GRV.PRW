#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA050GRV  �Autor  �TOTVS 	     � Data �  01/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para preencher o paramentro da numera��o  ���
���          � automaticamente do Contas a Pagar                          ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 - TECNOPAV                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050GRV()

	IF (M->E2_PREFIXO == "MAN")
		IF (M->E2_TIPO == "OP ")
			SETMV("MV_ZZPROP",STRZERO(VAL(M->E2_NUM)+1,9))
		ENDIF
		IF (M->E2_TIPO == "RD ")
			SETMV("MV_ZZPRRD",STRZERO(VAL(M->E2_NUM)+1,9))
		ENDIF
		IF (M->E2_TIPO == "PA ")
			SETMV("MV_ZZPRPA",STRZERO(VAL(M->E2_NUM)+1,9))
		ENDIF
	EndIF
	
	IF (M->E2_PREFIXO == "GPE")
		IF (M->E2_TIPO == "FOL")
			SETMV("MV_ZZPRFOL",STRZERO(VAL(M->E2_NUM)+1,9))
		ENDIF
	EndIF

Return (.T.)

