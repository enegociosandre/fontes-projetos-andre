#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410LIOK  �Autor  �Marcos Wey da Mata  � Data �  16/09/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para validar o preenchimento do Centro de  ���
���          �custo quando for MEDICAO                                    ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT - Especifico TECNOPAV                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M410LIOK()

Local aArea     := GetArea() 
Local lRet 		:= .T.

If cEmpAnt <> "03"
	_cCCUSTO      	:=aCols[n, Ascan(aHeader, {|X|Upper(Alltrim(X[2])) == "C6_CCUSTO"})] 
	
	If M->C5_ZZMEDIC == "S"
	
		If Empty(_cCCUSTO)
			MsgStop("Informe um Centro de Custo.",FunDesc())
			lRet := .F.
		EndIf
			
	EndIf
EndIf	
	
Restarea(aArea)
	
Return lRet