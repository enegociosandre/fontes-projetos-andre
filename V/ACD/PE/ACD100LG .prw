#Include 'Protheus.ch'

/*/{Protheus.doc}	ACD100LG
Ponto de entrada ultilizado para inclusao de nova cor da legenda

@author				Gerson Schiavo
@since				122/05/2016
@version			1.0
@return				aLegenda
/*/
User Function ACD100LG()


	Local aLegenda := aClone(PARAMIXB[1])

	aAdd(aLegenda,{"BR_VIOLETA"," - Conferidas"})


Return aLegenda

