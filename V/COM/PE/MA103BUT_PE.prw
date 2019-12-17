#include 'protheus.ch'
#include 'parmtype.ch'
/*/{Protheus.doc} MA103BUT
Bot�o em a��es relacionadas na edi��o da classifica��o de uma pre-nota de entrada

Preenchimento autom�tico da TES 

@author  Cassiano Gon�alves Ribeiro
@version P12
@since 	 29/05/2017
@return  aButtons
/*/
user function MA103BUT()
 
	local aArea := GetArea()
	local aButtons := {}
	
	aadd(aButtons, {"BUDGET", { || U_repliTES() }, "Preenche TES", "Preenche TES"})
	
	RestArea(aArea)
	
return (aButtons)