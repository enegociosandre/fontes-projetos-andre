#Include "Protheus.ch"   

User Function MSRORC01() 	
Local cOpt
Local lAuto := .F.
Local cNum  := ""

//If MsgYesNo("Deseja Enviar Relatório via E-Mail?","Envia E-Mail")
//	cOpt := "mail"
//else
	cOpt := "grafico"
//Endif

If FunName() == "MATA415"
	lAuto := .T.
	cNum  := SCJ->CJ_NUM
Endif

If cOpt == "mail"
	U_MSRORCHT(lAuto,cNum)
Else
	U_MSRORCGF(lAuto,cNum)
EndIf     

Return