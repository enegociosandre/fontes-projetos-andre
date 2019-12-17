#Include "protheus.ch"
#Include "fwmvcdef.ch"

/**
 * Função:			EICA0002
 * Autor:			Ademar Pereira Junior
 * Data:			25/01/2016
 * Descrição:		Atributos N.V.E. do Produto - Cadastro de produtos 
**/


User Function EICA0002()
Local aArea			:= GetArea()
Local aAreaSB1		:= SB1->(GetArea())
Local cProd			:= SB1->B1_COD

Local nOperation 	:= MODEL_OPERATION_INSERT

Local lIncluiOri	:= INCLUI
Local lAlteraOri	:= ALTERA

	DbSelectArea("ZZ1")
	ZZ1->(DbSetOrder(1))
	if ZZ1->(DbSeek(xFilial("ZZ1") + SB1->B1_COD))
		nOperation := MODEL_OPERATION_UPDATE
	Endif
		
	FWExecView("Atributos N.V.E. do Produto","EICA0001",nOperation,,{|| .T.})

	RestArea(aAreaSB1)
	RestArea(aArea)

	INCLUI := lIncluiOri
	ALTERA := lAlteraOri
Return

