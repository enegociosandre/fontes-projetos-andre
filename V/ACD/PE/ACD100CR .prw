#Include 'Protheus.ch'
/*/{Protheus.doc}	ACD100CR
Ponto de entrada ultilizado para inclusao de nova condição da legenda

@author				Gerson Schiavo
@since				12/05/2016
@version			1.0
@return				aCores
/*/
User Function ACD100CR()

	Local aAux := {}

	aADD(aAux,{"CB7->CB7_STATUS == '4'",'BR_VIOLETA'})
 
	For nI := 1 To Len(aCores)
		aADD(aAux,aCores[nI])
	Next nI

Return aAux

