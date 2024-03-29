#Include "rwmake.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP596     �Autor  �Donizete            � Data �  10/07/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este LP retorna dados para o LP 596 (compensa��o contas a  ���
���          � a receber. Trata o posicionamento dos t�tulos.             ���
���          � Adaptado do rdmake originalmente elaborado por Martelli.   ���
�������������������������������������������������������������������������͹��
���Uso       � Chamada no LP 596.                                         ���
���          � Protheus 710/811                                           ���
�������������������������������������������������������������������������͹��
���Atualiz.  � Altera��es                                                 ���
���22/01/05  � - alterado l�gica de memoria��o dos alias (getarea).       ���
���03/05/07  � - alterado posi��o do restearea do SE1.                    ���
���19/05/07  � - alterado posi��o do restearea do SE5.                    ���
���31/08/07  � - alterado para dar tratamento a compensa��o entre fornec. ���
���          �diferentes. Usando campos padr�es da 8.11 E5_FORNADT e      ���
���          �E5_LOJAADT.                                                 ���
���          �Implantado por DAMATA em 10/09/2010                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function LP596(_cPar1,_cPar2)

// Defini��o das vari�veis.
Public _aArea   	:= GetArea()
Public _aAreaSE1	:= {}
Public _aAreaSE5	:= {}
Public _aAreaSA1	:= {}
Public _aAreaSED	:= {}
Public _cRet		:= Space(20)
Public _cCod		:= Space(TamSX3("A1_COD")[1])
Public _cLoja		:= Space(TamSX3("A1_LOJA")[1])
Public _cConta		:= Space(TamSX3("CT1_CONTA")[1])
Public _cNat		:= Space(TamSX3("ED_CODIGO")[1])
Public _cChavePA	:= Space(23)
Public _cChaveNF	:= Space(23)
Public _cChave		:= Space(23)
Public _cCliRA		:= Space(15)
Public _cCliNF		:= Space(15)
_cPar1 := Upper(Alltrim(_cPar1)) // Tipo de Dado a ser retornado.
_cPar2 := Upper(Alltrim(_cPar2)) // Tipo de Dado a ser retornado.

dbSelectArea("SE5")
_aAreaSE5 := GetArea()

If Alltrim(SE5->E5_TIPO) $ "RA/NCC" // Usu�rio compensou posicionando na NF.
	_cChaveNF := SUBSTR(SE5->E5_DOCUMEN,1,15+TamSX3("E5_PARCELA")[1])+SE5->E5_FORNADT+SE5->E5_LOJAADT
	_cChaveRA := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
Else // Usu�rio compensou posicionando no RA/NCC
	_cChaveNF := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
	_cChaveRA := SUBSTR(SE5->E5_DOCUMEN,1,15+TamSX3("E5_PARCELA")[1])+SE5->E5_FORNADT+SE5->E5_LOJAADT
EndIf

dbSelectArea("SE1")
_aAreaSE1 := GetArea()
dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

// Obtem nome do cliente da NF.
dbSeek(xFilial("SE1")+_cChaveNF,.T.)
If Found()
	_cCliNF	  := Alltrim(SE1->E1_NOMCLI)
EndIf

// Obtem nome do cliente do RA.
dbSeek(xFilial("SE1")+_cChaveRA,.T.)
If Found()
	_cCliRA	  := Alltrim(SE1->E1_NOMCLI)
EndIf

// Verifica tipo de dado solicitado pelo usu�rio.
If _cPar2 == "NF"
	_cChave := _cChaveNF
Else
	_cChave := _cChaveRA
EndIf

// Posiciona no t�tulo conforme tipo escolhido pelo usu�rio.
dbSeek(xFilial("SE1")+_cChave,.T.)

_cCod	:= SE1->E1_CLIENTE
_cLoja	:= SE1->E1_LOJA
_cNat   := SE1->E1_NATUREZ

// Retorna dados conforme solicitado.
If _cPar1 == "SA1" // Retorna conta do cliente.
	dbSelectArea("SA1")
	_aAreaSA1 := GetArea()
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+_ccod+_cloja)
	If Found()
		_cRet := SA1->A1_CONTA
	EndIf
	RestArea(_aAreaSA1)
	
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
	_cChaveRA := Transform(_cChaveRA,"@R XXX/XXXXXXXXX/XX/XXX")
	_cRet := "COMP.CR."+_cChaveNF + "-" + _cCliNF + " C/ " + _cChaveRA + "-" + _cCliRA

ElseIf SubStr(_cPar1,1,3) == "E5_"
	_cRet := "SE5->(" + Alltrim(_cPar1) + ")"
	_cRet := &_cRet

ElseIf SubStr(_cPar1,1,3) == "E1_"
	_cRet := "SE1->(" + Alltrim(_cPar1) + ")"
	_cRet := &_cRet	

EndIf

// Restaura �reas de trabalho.
RestArea(_aAreaSE1)
RestArea(_aAreaSE5)
RestArea(_aArea)

// Retorna dado para o LP.
Return(_cRet)