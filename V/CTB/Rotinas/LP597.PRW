#Include "rwmake.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP597     �Autor  �Donizete            � Data �  10/07/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este LP retorna dados para o LP 597 (compensa��o contas a  ���
���          � a pagar. Trata o posicionamento dos t�tulos.               ���
���          � Adaptado do rdmake originalmente elaborado por Martelli.   ���
�������������������������������������������������������������������������͹��
���Uso       � Chamada no LP 597.                                         ���
���          � Protheus 710/811                                           ���
�������������������������������������������������������������������������ͼ��
���Atualiz.  � Altera��es                                                 ���
���22/01/05  � - alterado l�gica de memoria��o dos alias (getarea).       ���
���03/05/07  � - alterado posi��o do restearea do SE2.                    ���
���19/05/07  � - alterado posi��o do restearea do SE5.                    ���
���31/08/07  � - alterado para dar tratamento a compensa��o entre fornec. ���
���          � diferentes. Usando campos padr�es da 8.11 E5_FORNADT e     ���
���          � E5_LOJAADT.                                                ���
���25/02/08  � - corre��o de algumas campos, estavam chamado E1 ao inv�s  ���
���          � SE2.                                                       ���
���          � Implantado por DAMATA em 10/09/2010                        ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function LP597(_cPar1,_cPar2)

// Defini��o das vari�veis.
Public _aArea   	:= GetArea()
Public _aAreaSE2	:= {}
Public _aAreaSE5	:= {}
Public _aAreaSA1	:= {}
Public _aAreaSED	:= {}
Public _cRet		:= Space(20)
Public _cCod		:= Space(TamSX3("A2_COD")[1])
Public _cLoja		:= Space(TamSX3("A2_LOJA")[1])
Public _cConta		:= Space(TamSX3("CT1_CONTA")[1])
Public _cNat		:= Space(TamSX3("ED_CODIGO")[1])
Public _cChavePA	:= Space(23)
Public _cChaveNF	:= Space(23)
Public _cChave		:= Space(23)
Public _cForPA		:= Space(15)
Public _cForNF		:= Space(15)
_cPar1 := Upper(Alltrim(_cPar1)) // Tipo de Dado a ser retornado.
_cPar2 := Upper(Alltrim(_cPar2)) // Tipo de Dado a ser retornado.

dbSelectArea("SE5")
_aAreaSE5 := GetArea()
If Alltrim(SE5->E5_TIPO) $ "PA/NDF" // Usu�rio compensou posicionando na NF.
	_cChaveNF := SUBSTR(SE5->E5_DOCUMEN,1,15+TamSX3("E5_PARCELA")[1])+SE5->E5_FORNADT+SE5->E5_LOJAADT
	_cChavePA := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
Else // Usu�rio compensou posicionando no PA/NDF
	_cChaveNF := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
	_cChavePA := SUBSTR(SE5->E5_DOCUMEN,1,15+TamSX3("E5_PARCELA")[1])+SE5->E5_FORNADT+SE5->E5_LOJAADT
EndIf

dbSelectArea("SE2")
_aAreaSE2 := GetArea()
dbSetOrder(1) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

// Obtem nome do fornecedor da NF.
dbSeek(xFilial("SE2")+_cChaveNF,.T.)
If Found()
	_cForNF	  := Alltrim(SE2->E2_NOMFOR)
EndIf

// Obtem nome do fornecedor do PA.
dbSeek(xFilial("SE2")+_cChavePA,.T.)
If Found()
	_cForPA	  := Alltrim(SE2->E2_NOMFOR)
EndIf

// Verifica tipo de dado solicitado pelo usu�rio.
If _cPar2 == "NF"
	_cChave := _cChaveNF
Else
	_cChave := _cChavePA
EndIf

// Posiciona no t�tulo conforme tipo escolhido pelo usu�rio.
dbSeek(xFilial("SE2")+_cChave,.T.)

_cCod	:= SE2->E2_FORNECE
_cLoja	:= SE2->E2_LOJA
_cNat   := SE2->E2_NATUREZ

// Retorna dados conforme solicitado.
If _cPar1 == "SA2" // Retorna conta do fornecedor.
	dbSelectArea("SA2")
	_aAreaSA2 := GetArea()
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+_ccod+_cloja)
	
	If Found()
		_cRet := SA2->A2_CONTA
	EndIf
	RestArea(_aAreaSA2)
	
ElseIf _cPar1 == "SED" // Retorna dados da natureza financeira, pode ser a conta por exemplo.
	dbSelectArea("SED")
	_aAreaSED := GetArea()
	dbSetOrder(1)
	dbSeek(xFilial("SED")+_cNat)
	If Found()
		_cRet := SED->ED_CONTA
	EndIf
	RestArea(_aAreaSED)

ElseIf _cPar1 == "HIS" // Retorna hist�rico para o LP.
	_cChaveNF := Transform(_cChaveNF,"@R XXX/XXXXXXXXX/XX/XXX")
	_cChavePA := Transform(_cChavePA,"@R XXX/XXXXXXXXX/XX/XXX")
	_cRet := "COMP.CP."+_cChaveNF + "-" + _cForNF + " C/ " + _cChavePA + "-" + _cForPA

ElseIf SubStr(_cPar1,1,3) == "E5_"
	_cRet := "SE5->(" + Alltrim(_cPar1) + ")"
	_cRet := &_cRet

ElseIf SubStr(_cPar1,1,3) == "E2_"
	_cRet := "SE2->(" + Alltrim(_cPar1) + ")"
	_cRet := &_cRet	
EndIf

// Restaura �reas de trabalho.
RestArea(_aAreaSE2)
RestArea(_aAreaSE5)
RestArea(_aArea)

// Retorna dado para o LP.
Return(_cRet)