#INCLUDE "PROTHEUS.CH"  
#include "rwmake.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050INC  �Autor  �Marcos Wey da Mata  � Data �  11/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este ponto de entrada valida informacoes na inclusao manual���
���          �de titulos do contas a pagar.                               ���
�������������������������������������������������������������������������͹��
���Uso       � Ponto de Entrada Incl.Tit.Ctas.Pagar                       ���
�������������������������������������������������������������������������͹��
���Data      � Altera��es                                                 ���
�������������������������������������������������������������������������͹��
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050INC()

Local _lRet 	:= .t.                                               
Local _xArea	:= GetArea()
                      
// Fausto 26/01/12
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
// Fim 26/01/12


&& Valida��o: Obrigao preenchimento do Centro de Custo quando nao utilizado o Rateio
If M->E2_RATEIO<>"S" .And. Empty(M->E2_CCD) .And. M->E2_PREFIXO<>"GPE"  // Fausto 26/01/12 If M->E2_RATEIO<>"S" .And. Empty(M->E2_CCD)
	MsgStop("Aten��o: O centro de custo deve ser informado.")
	_lRet := .f.
EndIf
		
RestArea(_xArea)
Return _lRet