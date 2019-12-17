#Include 'Protheus.ch'

/*/{Protheus.doc} IniBrwNve
Iniciado de campo, para inclusão de Nve. Necessário para rotina MVC.
@author Thiago Meschiatti
@since 10/02/2016
@version 1.0
/*/
User Function IniNveBrw()
	local oModel 	:= FwModelActive()
	local oModelPai	:= oModel:getModel("ZZ1MASTER")
	
	oModelPai:setValue("ZZ1_PRODUT", SB1->B1_COD)
Return SB1->B1_COD

