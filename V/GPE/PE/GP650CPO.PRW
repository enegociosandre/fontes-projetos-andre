#Include "protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������ͱ�
�� Programa  GP650CPO   � Autor � Carlos Eduardo     � Data �  04/05/2016  ��
��������������������������������������������������������������������������ͱ�
�� Descricao � PE utilizado para substitui��o do c�digo do Fornecedor      ��
��           � de acordo com a defini��o do campo RA_ZZFORNE			   ��
��������������������������������������������������������������������������ͱ�
�� Uso       � Especifico Vermeer                                          ��
��������������������������������������������������������������������������ͱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function GP650CPO()

Local aArea		:= GetArea()
Local aAreaSRA	:= SRA->(GetArea())
Local cFornec	:= ""
Local cLoja		:= ""
Local cHist		:= ""

If !Empty(RC1->RC1_MAT)
	
	dBSelectArea("SRA")
	SRA->(dBSetOrder(1))
	SRA->(dBSeek(xFilial("SRA") + RC1->RC1_MAT))
	
	cFornec := SRA->RA_ZZFORNE
	cLoja	:= SRA->RA_ZZLOJA
	cHist	:= SRA->RA_ZZDESCF
	
	If !Empty(cFornec)
		
		RC1->RC1_FORNEC	:= cFornec
		RC1->RC1_LOJA	:= cLoja
		RC1->RC1_ZZHIST	:= cHist
		
	EndIf
	
EndIf

RestArea(aAreaSRA)
RestArea(aArea)

Return()
