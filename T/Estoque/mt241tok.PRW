#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT241TOK()บAutor  ณTiago Quintana      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao para preenchimento do campo item contabil para   บฑฑ
ฑฑบ          ณ requisicoes do centro de custo 1105 - Custo Direto com     บฑฑ
ฑฑบ          ณ Manutencao. E Valida็ใo na baixa por usuario.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function  MT241TOK()
Local lRet := .T.  

Local nI     := 0 
for nI := 1 To Len(aCols)
	
	If SubStr(aCols[nI,gdFieldPos("D3_CC")],1,4)=="1105" .AND. empty (aCols[nI,gdFieldPos("D3_ITEMCTA")])
		MsgAlert("Preencha o campo Item Contabil")
		lRet := .F.
	EndIf
	
	// Valida็ใo para baixa do estoque conforme departamento do usuario.
	 
	Do Case
		Case __cUserId=="000005" .And. aCols[nI,gdFieldPos("D3_LOCAL")]<>"03" //Hudson
			MsgAlert ("Voce s๓ tem permissใo para baixar do armaz้m 03 - Obra")
			lRet := .F.
		Case __cUserId=="000008" .And. aCols[nI,gdFieldPos("D3_LOCAL")]<>"03" //Bruna
			MsgAlert ("Voce s๓ tem permissใo para baixar do armaz้m 03 - Obra")
			lRet := .F.
		Case __cUserId=="000015" .And. aCols[nI,gdFieldPos("D3_LOCAL")]<>"03" //Leonardo
			MsgAlert ("Voce s๓ tem permissใo para baixar do armaz้m 03 - Obra")
			lRet := .F.
		Case __cUserId=="000010" .And. aCols[nI,gdFieldPos("D3_LOCAL")]<>"02" //Wolney
			MsgAlert ("Voce s๓ tem permissใo para baixar do armaz้m 02 - Manuten็ใo")
			lRet := .F.
		Case __cUserId=="000017" .And. aCols[nI,gdFieldPos("D3_LOCAL")]<>"02" //Renario
			MsgAlert ("Voce s๓ tem permissใo para baixar do armaz้m 02 - Manuten็ใo")
			lRet := .F.
	EndCase
next nI

Return (lRet)
