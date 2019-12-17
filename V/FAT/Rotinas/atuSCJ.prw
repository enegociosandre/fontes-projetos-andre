#Include 'Protheus.ch'
/*/{Protheus.doc}	atuSCJ

@author				Cassiano Ribeiro
@since				21/06/2016
/*/
User Function atuSCJ()
	M->CJ_ZZTPORC := FwFldget("ADY_ZZTPOR")
	M->CJ_ZZTPFRE := FwFldget("ADY_ZZTPFR") 
	M->CJ_ZZVEND1 := FwFldget("ADY_VEND")
Return
