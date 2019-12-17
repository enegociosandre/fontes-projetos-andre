#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOLE.CH"

/*/{Protheus.doc} FT600IMP
RDMAKE para Impressão Customizada da Proposta Comercial 

@author  Cassiano G. Ribeiro
@version P12
@since 	 20/09/2016
@return  Nil
/*/
user function FT600IMP()
	
	Processa( {|| U_RELPVM() })
	
return .T.