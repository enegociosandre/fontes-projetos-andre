#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOPCONN.ch'
/*/{Protheus.doc} repliTES

Preenchimento automático da TES 

@author  Cassiano Gonçalves Ribeiro
@version P12
@since 	 29/05/2017
/*/
user function repliTES()
		
	if notaComplementoEIC()
		Processa( {|| preencheTES() })		
	else
		msgAlert("Operação não permitida. Aplica-se somente para notas de complemento de importação!")
	endIf
	
return

static function notaComplementoEIC()
return ( ! (empty(SF1->F1_HAWB)) .AND. (SF1->F1_TIPO == 'C') .AND. (SF1->F1_EST == 'EX') )

static function preencheTES()
	
	local nI 	:= 0
	local nOri 	:= 0
	local cTES	:= ""
	
	if l103Class
		
		if type("n") <> "U"
			nOri := n
		endIf
		
		for nI := 1 to Len(aCols)
			
			if !(GdDeleted(nI))
				if retTES(nI)
					MaFisLoad("IT_TES","",nI)
					MaFisAlt("IT_TES",GDFieldGet("D1_TES",nI),nI)
					MaFisToCols(aHeader,aCols,nI,"MT100")
					if ExistTrigger("D1_TES")
						RunTrigger(2,nI,,"D1_TES")
					endIf
				endIf
			endIf
			
		next nI
		
		if type("n") <> "U"
			n := nOri
		endIf
	else
		msgAlert("Operação inválida. Permitido somente para a operação de 'Classificação de pré-nota'")
	endIf
	
return

static function retTES(nI)
	
	local cQry 		:= ""
	local cTES 		:= ""
	local cAlias	:= GetNextAlias()
	local lRet		:= .F.
	local aAreaSF4	:= SF4->(getArea())
	local aSaldo	:= {}
	
	cQry :=	" SELECT W2_PO_NUM, W2_ZZTIPO, NOTA_PRIMEIRA.F1_DOC AS NOTA_PRIMEIRA , " + CRLF
	cQry +=	"		IT_NPRIMEIRA.D1_PEDIDO AS PEDIDO_NF_PRIMEIRA, " + CRLF
	cQry +=	"		IT_NPRIMEIRA.D1_DOC, IT_NPRIMEIRA.D1_SERIE, " + CRLF
	cQry +=	"		IT_NPRIMEIRA.D1_ITEM, TES_FINALIDADE.X5_DESCRI AS TES_FINALIDADE " + CRLF
	cQry +=	" FROM " + RetSQLName("SF1") + " NOTA_PRIMEIRA " + CRLF  
	cQry +=	"	INNER JOIN " + RetSQLName("SD1") + " IT_NPRIMEIRA " + CRLF
	cQry +=	"			ON IT_NPRIMEIRA.D1_FILIAL = NOTA_PRIMEIRA.F1_FILIAL " + CRLF
	cQry +=	"			AND IT_NPRIMEIRA.D1_DOC = NOTA_PRIMEIRA.F1_DOC " + CRLF
	cQry +=	"			AND IT_NPRIMEIRA.D1_SERIE = NOTA_PRIMEIRA.F1_SERIE " + CRLF
	cQry +=	"			AND IT_NPRIMEIRA.D1_ITEM = '" + GDFieldGet("D1_ITEMORI",nI) +"' " + CRLF
	cQry +=	"			AND IT_NPRIMEIRA.D_E_L_E_T_  = ' ' " + CRLF
	cQry +=	"	INNER JOIN " + RetSQLName("SW2") + " W2 " + CRLF 
	cQry +=	"			ON W2_PO_NUM = IT_NPRIMEIRA.D1_PEDIDO " + CRLF 
	cQry +=	"			AND W2.D_E_L_E_T_  = ' ' " + CRLF
	cQry +=	"	INNER JOIN " + RetSQLName("SX5") + " TES_FINALIDADE " + CRLF 
	cQry +=	"			ON TES_FINALIDADE.X5_TABELA = 'ZZ' " + CRLF 
	cQry +=	"			AND TES_FINALIDADE.X5_CHAVE = W2_ZZTIPO " + CRLF 
	cQry +=	"			AND TES_FINALIDADE.D_E_L_E_T_  = ' ' " + CRLF
	cQry +=	" WHERE NOTA_PRIMEIRA.F1_HAWB = '"+ SF1->F1_HAWB +"' " + CRLF
	cQry +=	" AND NOTA_PRIMEIRA.F1_TIPO = 'N' " + CRLF
	cQry +=	" AND NOTA_PRIMEIRA.F1_DOC = '" + GDFieldGet("D1_NFORI",nI) +"' " + CRLF
	cQry +=	" AND NOTA_PRIMEIRA.F1_SERIE = '" + GDFieldGet("D1_SERIORI",nI) +"' " + CRLF
	cQry +=	" AND NOTA_PRIMEIRA.D_E_L_E_T_ = ' '
	
	TcQuery cQry New Alias &cAlias
	
	if ! (cAlias)->(EOF())
		
		GdFieldPut("D1_TES", (cAlias)->TES_FINALIDADE, nI)
		
		if alltrim((cAlias)->W2_ZZTIPO) == 'R'
//			dbSelectArea("SF4")
//			dbSetOrder(1)
//			if SF4->(MsSeek(xFilial("SF4") + alltrim((cAlias)->TES_FINALIDADE)))
//				if SF4->F4_ESTOQUE == 'S'
					aSaldo := CalcEst(GDFieldGet("D1_COD",nI),GDFieldGet("D1_LOCAL",nI),dDataBase + 1)				
					
					if aSaldo[2] <= 0
						GdFieldPut("D1_TES", Alltrim(Tabela("ZZ","X",.T.)), nI)
					endif
//				endIf
//			endIf
		endIf
		lRet := .T.
	endIf
	
	(cAlias)->(DbCloseArea())	
	
//	restArea(aAreaSF4)
	
return lRet