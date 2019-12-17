/**
* Programa		:	SIAFAT05
* Autor			:	Ademar Pereira da Silva Junior
* Data			:	08/07/11
* Descricao		:	Retornar nome do cliente / fornecedor
*
* Parametros	:	Nao utilizado.
* Retorno		:	Nome
*
* Observacoes	:	Obs
**/

User Function SIAFAT05(nTp)
Local cRet 	:= ""
Local aArea	:= GetArea()

	If nTp == 1
		If SF1->F1_TIPO == "D"   .or. SF1->F1_TIPO == "B"
			cRet := Posicione("SA1",1,xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA,"A1_NOME")
		Else
			cRet := Posicione("SA2",1,xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA,"A2_NOME")
		EndIf
	ElseIf nTp == 2
		If SF1->F1_TIPO == "D"
			cRet := Posicione("SA1",1,xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA,"A1_NREDUZ")
		Else
			cRet := Posicione("SA2",1,xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA,"A2_NREDUZ")
		EndIf         
	ElseIf nTp == 3
		If SF2->F2_TIPO == "B" .Or. SF2->F2_TIPO == "D"
			cRet := Posicione("SA2",1,xFilial("SA2") + SF2->F2_CLIENTE + SF2->F2_LOJA,"A2_NOME")
		Else
			cRet := Posicione("SA1",1,xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA,"A1_NOME")
		EndIf         
	ElseIf nTp == 4
		If SF2->F2_TIPO == "B" .Or. SF2->F2_TIPO == "D"
			cRet := Posicione("SA2",1,xFilial("SA2") + SF2->F2_CLIENTE + SF2->F2_LOJA,"A2_NREDUZ")
		Else
			cRet := Posicione("SA1",1,xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA,"A1_NREDUZ")
		EndIf         
	ElseIf nTp == 5
		If SC5->C5_TIPO == "B" .Or. SC5->C5_TIPO == "D"
			cRet := Posicione("SA2",1,xFilial("SA2") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A2_NOME")
		Else
			cRet := Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_NOME")
		EndIf         
	ElseIf nTp == 6
		If SC5->C5_TIPO == "B" .Or. SC5->C5_TIPO == "D"
			cRet := Posicione("SA2",1,xFilial("SA2") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A2_NREDUZ")
		Else
			cRet := Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_NREDUZ")
		EndIf         
	EndIf
                        
RestArea(aArea)
Return cRet