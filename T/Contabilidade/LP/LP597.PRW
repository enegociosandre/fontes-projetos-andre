#Include "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP597     ºAutor  ³Donizete            º Data ³  10/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este LP retorna dados para o LP 597 (compensação contas a  º±±
±±º          ³ a pagar. Trata o posicionamento dos títulos.               º±±
±±º          ³ Adaptado do rdmake originalmente elaborado por Martelli.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Chamada no LP 597.                                         º±±
±±º          ³ Protheus 710/811                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAtualiz.  ³ Alterações                                                 º±±
±±º22/01/05  ³ - alterado lógica de memoriação dos alias (getarea).       º±±
±±º03/05/07  ³ - alterado posição do restearea do SE2.                    º±±
±±º19/05/07  ³ - alterado posição do restearea do SE5.                    º±±
±±º31/08/07  ³ - alterado para dar tratamento a compensação entre fornec. º±±
±±º          ³ diferentes. Usando campos padrões da 8.11 E5_FORNADT e     º±±
±±º          ³ E5_LOJAADT.                                                º±±
±±º25/02/08  ³ - correção de algumas campos, estavam chamado E1 ao invés  º±±
±±º          ³ SE2.                                                       º±±
±±º          ³                                                            º±±
±±º04/03/11  ³ - Criado por damata _cNumSE5NF e _cNumSE5PA                º±±
±±º          ³ - Tratamento na mascara do titulo para tamanho 6 ou 9      º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function LP597(_cPar1,_cPar2)

// Definição das variáveis.
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
Public _cNumSE5NF	:= Space(9)
Public _cNumSE5PA	:= Space(9)
_cPar1 := Upper(Alltrim(_cPar1)) // Tipo de Dado a ser retornado.
_cPar2 := Upper(Alltrim(_cPar2)) // Tipo de Dado a ser retornado.

dbSelectArea("SE5")
_aAreaSE5 := GetArea()
If Alltrim(SE5->E5_TIPO) $ "PA/NDF" // Usuário compensou posicionando na NF.
	_cChaveNF := SUBSTR(SE5->E5_DOCUMEN,1,12+TamSX3("E5_PARCELA")[1])+SE5->E5_FORNADT+SE5->E5_LOJAADT
	_cChavePA := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)

	_cNumSE5NF:= SUBSTR(SE5->E5_DOCUMEN,4,9) && Damata 04/03/2011
	_cNumSE5PA:= SE5->E5_NUMERO && Damata 04/03/2011
Else // Usuário compensou posicionando no PA/NDF
	_cChaveNF := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
	_cChavePA := SUBSTR(SE5->E5_DOCUMEN,1,12+TamSX3("E5_PARCELA")[1])+SE5->E5_FORNADT+SE5->E5_LOJAADT

	_cNumSE5NF:= SE5->E5_NUMERO && Damata 04/03/2011
	_cNumSE5PA:= SUBSTR(SE5->E5_DOCUMEN,4,9) && Damata 04/03/2011
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

// Verifica tipo de dado solicitado pelo usuário.
If _cPar2 == "NF"
	_cChave := _cChaveNF
Else
	_cChave := _cChavePA
EndIf

// Posiciona no título conforme tipo escolhido pelo usuário.
dbSeek(xFilial("SE2")+_cChave,.T.)

_cCod	:= SE2->E2_FORNECE
_cLoja	:= SE2->E2_LOJA
_cNat   := SE2->E2_NATUREZ
//_cContaSE2 := SE2->E2_STCONTA - Desativado Damata 24/08/2011
// Retorna dados conforme solicitado.
If _cPar1 == "SA2" // Retorna conta do fornecedor.
	dbSelectArea("SA2")
	_aAreaSA2 := GetArea()
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+_ccod+_cloja)
	
	If Found()
		If !Empty(SA1->A1_CONTA)
			_cRet := SA2->A2_CONTA
		Else
			_cRet := "21101101"
		EndIf		
		
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
//ElseIf _cPar1 == "SE2"     - Desativado Damata 24/08/2011
//	_cRet := _cContaSE2
ElseIf _cPar1 == "HIS" // Retorna histórico para o LP.
	If Alltrim(SE5->E5_TIPO) $ "PA/NDF" // Usuário compensou posicionando na NF.
		_cChaveNF := If(Len(Alltrim(_cNumSE5NF))>6,Transform(_cChaveNF,"@R XXX/XXXXXXXXX/X"),Transform(_cChaveNF,"@R XXX/XXXXXX/X"))
		_cChavePA := If(Len(Alltrim(_cNumSE5PA))>6,Transform(_cChavePA,"@R XXX/XXXXXXXXX/X/XXX"),Transform(_cChavePA,"@R XXX/XXXXXX/X/XXX"))
	Else
		_cChaveNF := If(Len(Alltrim(_cNumSE5NF))>6,Transform(_cChaveNF,"@R XXX/XXXXXXXXX/X/XXX"),Transform(_cChaveNF,"@R XXX/XXXXXX/X/XXX"))
		_cChavePA := If(Len(Alltrim(_cNumSE5PA))>6,Transform(_cChavePA,"@R XXX/XXXXXXXXX/X"),Transform(_cChavePA,"@R XXX/XXXXXX/X"))
	EndIf
	_cRet := "COMP.CP."+_cChaveNF + "-" + _cForNF + " C/ " + _cChavePA + "-" + _cForPA

ElseIf SubStr(_cPar1,1,3) == "E5_"
	_cRet := "SE5->(" + Alltrim(_cPar1) + ")"
	_cRet := &_cRet

ElseIf SubStr(_cPar1,1,3) == "E2_"
	_cRet := "SE2->(" + Alltrim(_cPar1) + ")"
	_cRet := &_cRet	
EndIf

// Restaura áreas de trabalho.
RestArea(_aAreaSE2)
RestArea(_aAreaSE5)
RestArea(_aArea)

// Retorna dado para o LP.
Return(_cRet)