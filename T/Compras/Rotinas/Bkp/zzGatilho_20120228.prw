#Include "rwmake.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ zzGatilho³ Autor ³ Marcos da Mata        ³ Data ³ 17/02/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa de preenchimento de conta contabil conforme Centro³±±
±±³          ³  de Custo 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Alterado  ³ Marcos da Mata                           ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gatilho no campo D1_CC                                     ³±±
±±³          ³ Iif(INCLUI,U_zzGatilho(),nil)							  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

User Function zzGatilho(cCC,cProd)

&&Local cCC    := ""
&&Local cProd  := ""
Local cConta := ""
Local aArea  := GetArea()

&&cCC   := M->D1_CC
&&cProd := M->D1_COD

SD1->(dbSetOrder(1))                 
SB1->(dbSetOrder(1))
SM4->(dbSetOrder(1))


	If SB1->(dbSeek( xFilial("SB1") + cProd ))
		If SUBSTR(cCC,1,4)$	FORMULA("CCD")	&&"1100,1101"	&& DESPESAS
			cConta := SB1->B1_ZZDESP
		ElseIf SUBSTR(cCC,1,4)$ FORMULA("CCC")	&&"1105,1111"	&&CUSTO
			cConta := SB1->B1_ZZCUSTO
		ElseIf SUBSTR(cCC,1,4)$ FORMULA("CCE")	&&"2000"	&&ESTOQUE
			cConta := SB1->B1_CONTA
		EndIf
	EndIf	

SB1->(dbCloseArea())
SM4->(dbCloseArea())
   
If Empty(cConta)
	Alert("Verifique se as Contas Contabeis de Custo, Despesa e Estoque estao devidamente preenchidas")
	cConta := "CC NAO PREVISTO"
EndIf

RestArea(aArea)

Return cConta