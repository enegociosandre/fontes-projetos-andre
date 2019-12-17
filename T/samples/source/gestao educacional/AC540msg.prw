
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AC540MSG  �Autor  �Juliano Saggiomo    � Data �  25/08/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia email de notifica��o ao respons�vel quando acontece  ���
���          � uma ocorr�ncia                                             ���
�������������������������������������������������������������������������͹��
���Par�metros� ExpC1 - Nome do Respons�vel                                ���
���          � ExpC2 - Email do Respons�vel                               ���
���          � ExpC3 - Tipo Responsavel                                   ���
���          � ExpC4 - Nome do Aluno                                      ���
���          � ExpC5 - Tipo da Ocorrencia                                 ���
���          � ExpC6 - Motivo da Ocorr�ncia                               ���
���          � ExpC7 - A��o da Ocorr�ncia                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP7 - GESTAO EDUCACIONAL                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function Ac540MSG()
Local lRetorno      := .f.
Local cMsg          := ""
Local cResp       	:= PARAMIXB[1]
Local cEmail 		:= PARAMIXB[2]
Local cTipo 		:= PARAMIXB[3]
Local cAluno 		:= PARAMIXB[4]
Local cAdvert		:= PARAMIXB[5]
Local cMemo			:= PARAMIXB[6]
Local cMemo1		:= PARAMIXB[7]

cAssunto := "Ocorrencia" //Alteracao no local do processo seltivo

cMsg := "Prezado(a)" + "&nbsp" + "respons�vel" + "&nbsp"
If cTipo == '1'
	cMsg += "Academico" + "&nbsp"
ElseIf cTipo == '2'
	cMsg += "Financeiro" + "&nbsp"
ElseIf cTipo == '3'
	cMsg += "Academico/Financeiro" + "&nbsp"
EndIf

cMsg += cResp + "," + "<br>" + "<br>"
cMsg += "informamos que o aluno" + "&nbsp" + "<b>" + cAluno + "</b>" + "&nbsp" + "recebeu uma" + "&nbsp"
cMsg += "<b>" + Tabela( "FA",  cAdvert, .F. ) + "</b>" + "." + "<br>" + "<br>"
// motivo
If MSMM(cMemo) <> ""
	cMsg += "<b>" + "Motivo:" + "</b>" + "<br>" + MSMM(cMemo) + "." + "<br>"
EndIf

// acao
If MSMM(cMemo1) <> ""
	cMsg += "<br>" + "<b>" + "Acao:" + "</b>" + "<br>" + MSMM(cMemo1) + "." + "<br>"
EndIf

cMsg += "<br>" + "Atenciosamente," + "<br>"
cMsg += "Secretaria"

lRetorno := ACSendMail( ,,,, cEmail + Chr(59), cAssunto, cMsg )

Return lRetorno