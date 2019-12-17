#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT240TOK()ºAutor  ³Tiago Quintana      º Data ³  31/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao para preenchimento do campo item contabil para   º±±
±±º          ³ requisicoes do centro de custo 1105 - Custo Direto com     º±±
±±º          ³ Manutencao. E Validação na baixa por usuario.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function  MT240TOK()
Local lRet := .T.
If SubStr(M->D3_CC,1,4)=="1105" .AND. empty (M->D3_ITEMCTA)
	MsgAlert("Preencha o campo Item Contabil")
	lRet := .F.
EndIf

// Validação para baixa do estoque conforme departamento do usuario.
 
Do Case
	Case __cUserId=="000005" .And. M->D3_LOCAL<>"03" //Hudson
		MsgAlert ("Voce só tem permissão para baixar do armazém 03 - Obra")
		lRet := .F.
	Case __cUserId=="000008" .And. M->D3_LOCAL<>"03" //Bruna
		MsgAlert ("Voce só tem permissão para baixar do armazém 03 - Obra")
		lRet := .F.
	Case __cUserId=="000015" .And. M->D3_LOCAL<>"03" //Leonardo
		MsgAlert ("Voce só tem permissão para baixar do armazém 03 - Obra")
		lRet := .F.
	Case __cUserId=="000010" .And. M->D3_LOCAL<>"02" //Wolney
		MsgAlert ("Voce só tem permissão para baixar do armazém 02 - Manutenção")
		lRet := .F.
	Case __cUserId=="000017" .And. M->D3_LOCAL<>"02" //Renario
		MsgAlert ("Voce só tem permissão para baixar do armazém 02 - Manutenção")
		lRet := .F.
EndCase
Return (lRet)
