#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � ValF1DOC � Autor �Marcos Wey da Mata  � Data � 28/07/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna campo acrescido com zeros - N.documento entrada    ���
�������������������������������������������������������������������������͹��
���Para que esta rotina funcione ser� necessario colocar na validacao de  ���
���campo do F1_ESPECIE = U_VALFIDOC()									  ���
���																		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ValF1DOC()                                               
	If AllTrim(cEspecie) == "SPED"
		cNFiscal := Replicate("0",9 - LEN(ALLTRIM(cNFiscal))) + AllTrim(cNFiscal)
	Else 
		cNFiscal := Replicate("0",6 - LEN(ALLTRIM(cNFiscal))) + AllTrim(cNFiscal)
	EndIF
Return .T.