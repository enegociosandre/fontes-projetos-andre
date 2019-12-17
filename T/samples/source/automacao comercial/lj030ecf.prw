/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj030ECF  �Autor  �Andre Alves Veiga   � Data �  26/09/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao do resumo de caixa na impressora fiscal           ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Lj030ECF()

Local aCaixa := {}
Local cString := ''
Local nTroco
Local nTotCredito
Local nTotDebito
Local nRet := 0
Local lAberto
Local cCaixa := MV_PAR03
Local dDataMovto := MV_PAR01
Local nI := 0

//���������������������������������������������������������������Ŀ
//�Carrega array com valores totais do caixa em uma data          �
//�����������������������������������������������������������������
aCaixa := MovimCaixa(cCaixa,dDataMovto)
Lj030Dados(aCaixa,;	// Alimenta Totalizadores / Arrays aDados...
				@nTroco,@nTotCredito,@nTotDebito,;
				@nSaldFinal)

//�������������������������������������������������������Ŀ
//�Monta o relat�rio gerencial                            �
//���������������������������������������������������������
cString := chr(10) + chr(10) + Repl('-',40) + chr(10)
cString += Space((40-Len("RESUMO DE CAIXA"))/2) + "RESUMO DE CAIXA" + chr(10)
cString += Repl('-',40) + chr(10)
cString += "Codigo do Caixa: " + SA6->A6_COD+"-"+SA6->A6_NOME + chr(10) 
cString += "Data Movimento: " + Dtoc(dDataMovto)	+ chr(10)
cString += Repl('-',40) + chr(10)
cString += Subst("Saldo Inicial: " + Space(26),1,26) + Trans(nTroco,'@E 999,999,999.99') + chr(10)
cString += Repl('-',40) + chr(10)

cString += Subst("Credito/Vendas" + Space(26),1,26) + Trans(nTotCredito,'@E 999,999,999.99')	+ chr(10)
For nI :=1 to len(aDadosVen)
	lAberto := (Left(aDadosVen[nI][1],1)=="-" .and. aDadosVen[nI][2] # 0)
	cString += padr(aDadosVen[nI][1]+" ",26,IIf(lAberto,"",".")) +;
	IIf(lAberto,"",Trans(aDadosVen[nI][2],'@E 999,999,999.99')) + Chr(10)
Next
cString += Repl('-',40) + chr(10) + chr(10)

cString += Subst("Debitos/Sangrias" + Space(26),1,26) + Trans(nTotDebito,'@E 999,999,999.99') + chr(10)
For nI :=1 to len(aDadosSan)
	cString += padr(aDadosSan[nI][1]+" ",26,".") + Trans(aDadosSan[nI][2],'@E 999,999,999.99') + chr(10)
Next
cString += Repl('-',40) + chr(10) + chr(10)
cString += Subst("SALDO FINAL" + Space(26),1,26) + Trans(nSaldFinal,'@E 999,999,999.99') + chr(10)
cString += Repl('-',40) + chr(10)

//�������������������������������������������������������Ŀ
//�Envia o relat�rio para a impressora                    �
//���������������������������������������������������������

nRet := IFRelGer(nHdlECF,cString,1)
If nRet <> 0
	MsgStop("Problemas com a Impressora Fiscal")
Endif

Return