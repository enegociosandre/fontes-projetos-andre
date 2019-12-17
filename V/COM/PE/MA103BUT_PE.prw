#include 'protheus.ch'
#include 'parmtype.ch'
/*/{Protheus.doc} MA103BUT
Botão em ações relacionadas na edição da classificação de uma pre-nota de entrada

Preenchimento automático da TES 

@author  Cassiano Gonçalves Ribeiro
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