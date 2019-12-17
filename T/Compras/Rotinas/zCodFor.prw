#Include "rwmake.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ zCodFor  ³ Autor ³ Marcos da Mata        ³ Data ³ 12/11/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa de Codigo Inteligente para o Fornecedor           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Alterado  ³ Marcos da Mata                           ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gatilho no campo A2_ZZTIPO                                 ³±±
±±³          ³ Iif(INCLUI,U_zCodFor(),nil)								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

User Function zCodFor(cCod)

Local cTipo   := ""
Local cCod    := ""
Local cCodA   := ""
Local cCodB   := ""
Local aArea	  := GetArea()

cTipo := M->A2_ZZTIPO

dbSelectArea("SA2")
_cCmdSA2 := " SELECT A2_COD FROM " + RetSqlName("SA2")
_cCmdSA2 += " WHERE "
_cCmdSA2 += " D_E_L_E_T_ = ' ' AND "
_cCmdSA2 += " A2_COD LIKE '"+cTipo+"%' "
_cCmdSA2 += " ORDER BY A2_COD DESC"

TcQuery _cCmdSA2 New Alias "CSA2"

dbSelectArea("CSA2")
CSA2->(dbGoTop())

While CSA2->(!EOF())
	
	cCodA := Val(substr(CSA2->A2_COD,2,5))
	cCodA++
	cCodB := cTipo+Strzero(cCodA,5)
	
	dbSelectarea("SA2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SA2")+cCodB)
		cCod := cCodB
		CSA2->(dbCloseArea())
		Return cCod
	Endif
	
	CSA2->(dbSkip())
	
Enddo

CSA2->(dbCloseArea())

If cCod == ""
	cCod := cTipo+"00001"
Endif

RestArea(aArea)

Return cCod