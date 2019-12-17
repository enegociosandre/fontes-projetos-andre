#Include 'Protheus.ch'
#Include "fwmvcdef.ch"

/**
 * Fun��o:			ExcNve
 * Autor:			Cassiano Gon�alves Ribeiro
 * Data:			28/03/2017
 * Descri��o:		Atributos N.V.E. do Produto - Cadastro de produtos 
**/

user function ExcNve()
	
	local aArea			:= GetArea()
	local aAreaSB1		:= SB1->(GetArea())
	local cProd			:= SB1->B1_COD
	local nOperation 	:= MODEL_OPERATION_DELETE
	local lIncluiOri	:= INCLUI
	local lAlteraOri	:= ALTERA

	DbSelectArea("ZZ1")
	ZZ1->(DbSetOrder(1))
	if ZZ1->(DbSeek(xFilial("ZZ1") + SB1->B1_COD))
		FWExecView("Atributos N.V.E. do Produto","EICA0001",nOperation,,{|| .T.})
	endIf
	
	RestArea(aAreaSB1)
	RestArea(aArea)

	INCLUI := lIncluiOri
	ALTERA := lAlteraOri
	
return