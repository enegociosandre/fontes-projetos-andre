#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} CRMXCTRENT

CRMXCTRENT - Remove as tabelas do Controle de Privilégios do CRM
TDN: http://tdn.totvs.com/pages/releaseview.action?pageId=185730497  

Fonte padrão: CRMXFUNPERM.prw
Função padrão: CRMXCtrlEnt
Tabelas Controladas: AC6|ACB|ACD|ACH|AD1|AD5|ADY|AIN|AOC|AOD|AOF|AOH|SA1|SC5|SCT|SU4|SU5|SUO|SUS|SUZ|AOJ|

@author Tiago Quintana
@since 14/06/2016
/*/


User Function CRMXCTRENT()

	Local aEntCtrtPri := PARAMIXB[1]
	Local nX := 0
	Local aRetorno := {}
	Local cEntRemove := "SA1|SU5|SUS|SCT"

	For nX := 1 To Len(aEntCtrtPri)
		If !(aEntCtrtPri[nX] $ cEntRemove)
			aAdd(aRetorno,aEntCtrtPri[nX])
		EndIf
	Next nX
Return(aRetorno)