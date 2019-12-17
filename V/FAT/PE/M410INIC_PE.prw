#Include "Protheus.ch"

/*/{Protheus.doc}	M410INIC
ste ponto de entrada é chamado antes da abertura da tela de 
inclusão do pedido de vendas com o objetivo de 
permitir a validação do usuário.

@author				Julio Lisboa - TOTVS IP Campinas
@since					22/06/2015
@return				nil
/*/
User Function M410INIC()
	
	Local aAreaAtu	:= GetArea()	
	Local aAreaSA1	:= SA1->(GetArea())
	
	If FunName() == "MATA416"
		M->C5_TRANSP 	:= SCJ->CJ_ZZTRANS
		M->C5_TPFRETE 	:= SCJ->CJ_ZZTPFRE
		M->C5_VEND1		:= SCJ->CJ_ZZVEND1
//		M->C5_COMIS1	:= SCJ->CJ_ZZCOMI1   
		M->C5_COMIS1	:= RETFIELD("SA3",1,XFILIAL("SA3")+SCJ->CJ_ZZVEND1,"A3_COMIS")
		M->C5_VEND2		:= SCJ->CJ_ZZVEND2
//		M->C5_COMIS2	:= SCJ->CJ_ZZCOMI2                                                 
		M->C5_COMIS2	:= RETFIELD("SA3",1,XFILIAL("SA3")+SCJ->CJ_ZZVEND2,"A3_COMIS")
		M->C5_ZZDESC	:= alltrim(Posicione("SA1",1,xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,"A1_NOME"))       
		M->C5_MENNOTA	:= SCJ->CJ_ZZMENNF
		M->C5_ZZTPPED	:= SCJ->CJ_ZZTPORC
	EndIf
	
	RestArea(aAreaSA1)
	RestArea(aAreaAtu)
Return