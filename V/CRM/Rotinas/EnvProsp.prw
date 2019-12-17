#Include "protheus.ch"
#Include "topconn.ch"

/*/{Protheus.doc} EnvProsp
Atribuir prospect
@type function
@author Ademar Jr
@since 04/05/2017
/*/

User Function EnvProsp()
Local aArea		:= GetArea()	// Salvar area
Local cQry 		:= ""			// Query
Local cAuxRet	:= ""			// Auxiliar retorno
Local nAuxCnt	:= 0			// Auxiliar contador

	// Query para contar quantidade de oportunidades de venda
	cQry :=	"SELECT " + CRLF
	cQry +=		"COUNT(*) CNT " + CRLF
	
	cQry +=	"FROM " + CRLF
	cQry +=		RetSQLName("AD1") + " AD1 " + CRLF

	cQry +=	"WHERE " + CRLF
	cQry +=		"AD1_FILIAL = '" + xFilial("AD1") + "' AND " + CRLF
	cQry +=		"AD1_PROSPE = '" + M->AD5_PROSPE + "' AND " + CRLF
	cQry +=		"AD1.D_E_L_E_T_ = ' '"

	TcQuery cQry Alias TCNT New
	
	If TCNT->(!EOF())
		nAuxCnt := TCNT->CNT
	EndIf
	
	TCNT->(DbCloseArea())

	// Caso a quantidade de oportunidades de venda seja igual a 1 não sugerir
	If nAuxCnt == 1
		cQry :=	"SELECT " + CRLF
		cQry +=		"AD1_NROPOR " + CRLF
		
		cQry +=	"FROM " + CRLF
		cQry +=		RetSQLName("AD1") + " AD1 " + CRLF
	
		cQry +=	"WHERE " + CRLF
		cQry +=		"AD1_FILIAL = '" + xFilial("AD1") + "' AND " + CRLF
		cQry +=		"AD1_PROSPE = '" + M->AD5_PROSPE + "' AND " + CRLF
		cQry +=		"AD1.D_E_L_E_T_ = ' ' " + CRLF
		
		cQry +=	"ORDER BY " + CRLF
		cQry +=		"AD1_NROPOR DESC"
	
		TcQuery cQry Alias TQRY New
		
		If TQRY->(!EOF())
			cAuxRet := TQRY->AD1_NROPOR
		EndIf
		
		TQRY->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cAuxRet