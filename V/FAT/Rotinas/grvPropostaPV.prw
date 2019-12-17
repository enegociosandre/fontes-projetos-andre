#Include 'Protheus.ch'
/*/{Protheus.doc}	grvPropostaPV

@author				Cassiano Ribeiro
@since				21/06/2016
/*/
user function grvPropostaPV()
	
	local nOpc		:= PARAMIXB[1] //1-Exclus�o,2-Visualiza��o,3-Inclus�o,4-Altera��o
	
	if alltrim(FunName()) == "FATA300" .or. alltrim(FunName()) == "CRMA110"
		if nOpc == 3
			M->C5_TPFRETE	:= ADY->ADY_ZZTPFR
			M->C5_NATUREZ 	:= ADY->ADY_ZZNATU
			M->C5_ZZTPPED 	:= "M"
		endIf
	endIf
	
return

