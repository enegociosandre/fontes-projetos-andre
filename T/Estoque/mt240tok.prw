#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT240TOK()�Autor  �Tiago Quintana      � Data �  31/08/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao para preenchimento do campo item contabil para   ���
���          � requisicoes do centro de custo 1105 - Custo Direto com     ���
���          � Manutencao. E Valida��o na baixa por usuario.              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function  MT240TOK()
Local lRet := .T.
If SubStr(M->D3_CC,1,4)=="1105" .AND. empty (M->D3_ITEMCTA)
	MsgAlert("Preencha o campo Item Contabil")
	lRet := .F.
EndIf

// Valida��o para baixa do estoque conforme departamento do usuario.
 
Do Case
	Case __cUserId=="000005" .And. M->D3_LOCAL<>"03" //Hudson
		MsgAlert ("Voce s� tem permiss�o para baixar do armaz�m 03 - Obra")
		lRet := .F.
	Case __cUserId=="000008" .And. M->D3_LOCAL<>"03" //Bruna
		MsgAlert ("Voce s� tem permiss�o para baixar do armaz�m 03 - Obra")
		lRet := .F.
	Case __cUserId=="000015" .And. M->D3_LOCAL<>"03" //Leonardo
		MsgAlert ("Voce s� tem permiss�o para baixar do armaz�m 03 - Obra")
		lRet := .F.
	Case __cUserId=="000010" .And. M->D3_LOCAL<>"02" //Wolney
		MsgAlert ("Voce s� tem permiss�o para baixar do armaz�m 02 - Manuten��o")
		lRet := .F.
	Case __cUserId=="000017" .And. M->D3_LOCAL<>"02" //Renario
		MsgAlert ("Voce s� tem permiss�o para baixar do armaz�m 02 - Manuten��o")
		lRet := .F.
EndCase
Return (lRet)
