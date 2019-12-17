#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/**
 * Função:			EICA0006
 * Autor:			Ademar Pereira Junior
 * Data:			25/01/2016
 * Descrição:		Gravar dados capa de solicitacao importacao
**/

User Function EICA0006()
	Local aArea		:= GetArea()
	Local cAuxNum	:= SW0->W0__NUM
	Local aPergs 	:= {}
	Local cTabPrc 	:= Space(3)
	Local cForAux	:= ""
	Local cLojAux	:= ""
	Local dDtEmb 	:= Date()
	Local dDtEnt 	:= Date()
	Local aRet 		:= {}
	Local lRet 		:= .T.

	Private cCadastro := "xParambox"

	If validPerg()

		AADD(aPergs,{1,"Tabela Preço :",cTabPrc,"","","EICAIA","",40,.T.})
		AADD(aPergs,{1,"Data Embarq. :",dDtEmb,"","","","",50,.T.})
		AADD(aPergs,{1,"Data Entrega :",dDtEnt,"","","","",50,.T.})
		
		If ParamBox(aPergs,"Parametros",@aRet)
			cTabPrc := aRet[1]
			dDtEmb	:= aRet[2]
			dDtEnt	:= aRet[3]
			
			lRet := .T.
		Else
			lRet := .F.
		Endif
	Else
		cTabPrc := SW0->W0_ZZCODTB
		dDtEmb	:= SW0->W0_ZZDTEMB
		dDtEnt	:= SW0->W0_ZZDTENT
	Endif
	
	If AllTrim(FunName()) == "MATA112"
		If SW1->W1_SI_NUM == cAuxNum
				
			If RecLock("SW1",.F.)
				If !Empty(AllTrim(SC1->C1_FORNECE)) .And. !Empty(AllTrim(SC1->C1_LOJA))
					cForAux	:= SC1->C1_FORNECE
					cLojAux	:= SC1->C1_LOJA
					SW1->W1_FORN	:= SC1->C1_FORNECE
					SW1->W1_FORLOJ	:= SC1->C1_LOJA
						
					DbSelectArea("SA5")
						// A5_FILIAL + A5_FORNECE + A5_LOJA + A5_PRODUTO + A5_FABR + A5_FALOJA
					SA5->(DbSetOrder(1))
					If SA5->(DbSeek(xFilial("SA5") + SC1->C1_FORNECE + SC1->C1_LOJA + SC1->C1_PRODUTO))
						SW1->W1_FABR	:= SA5->A5_FABR
						SW1->W1_FABLOJ 	:= SA5->A5_FALOJA
					EndIf
				Else
					DbSelectArea("SA5")
						// A5_FILIAL + A5_PRODUTO + A5_FORNECE + A5_LOJA
					SA5->(DbSetOrder(2))
					If SA5->(DbSeek(xFilial("SA5") + SC1->C1_PRODUTO))
						cForAux	:= SA5->A5_FORNECE
						cLojAux	:= SA5->A5_LOJA
						SW1->W1_FORN   	:= SA5->A5_FORNECE
						SW1->W1_FORLOJ 	:= SA5->A5_LOJA
						SW1->W1_FABR   	:= SA5->A5_FABR
						SW1->W1_FABLOJ	:= SA5->A5_FALOJA
					EndIf
				EndIf
		
				DbSelectArea("AIB")
				AIB->(DbSetOrder(2))
					// AIB_FILIAL + AIB_CODFOR + AIB_LOJFOR + AIB_CODTAB + AIB_CODPRO
				If AIB->(DbSeek(xFilial("AIB") + cForAux + cLojAux + cTabPrc + SC1->C1_PRODUTO))
					SW1->W1_PRECO := AIB->AIB_PRCCOM
				EndIf
					
				SW1->W1_DT_EMB 	:= dDtEmb
				SW1->W1_DTENTR_ := dDtEnt
					
				SW1->(MsUnlock())
			EndIf
			SW1->(DbSkip())
		Endif
		If RecLock("SW0", .F.)
			SW0->W0_ZZCODTB := cTabPrc
			SW0->W0_ZZDTEMB := dDtEmb
			SW0->W0_ZZDTENT := dDtEnt
			SW0->W0__DT		:= dDatabase
			SW0->(MsUnlock())
		Endif
			
	EndIf
	

	RestArea(aArea)
Return


/*
** Valida exeução apenas no primeiro item 
*/
static function validPerg()
	Local aAreaSW1	:= SW1->(GetArea())
	Local cItem		:= SW1->W1_POSIT
	local cAlias	:= getNextAlias()

	beginSql Alias cAlias
		SELECT W1_POSIT
		FROM %TABLE:SW1% SW1
		WHERE W1_FILIAL 	= %EXP:SW1->W1_FILIAL%
		AND W1_CC 		= %EXP:SW1->W1_CC%
		AND W1_SI_NUM 	= %EXP:SW1->W1_SI_NUM%
		AND SW1.%NOTDEL%
		ORDER BY 1
	endSql
	(cAlias)->(dbGoTop())
		
	If !(cAlias)->(eof())
		If cItem == (cAlias)->W1_POSIT
			lRet := .t.
		Else
			lRet := .f.
		Endif
	Endif
	
	(cAlias)->(DbCloseArea())
	
	RestArea(aAreaSW1)
return (lRet)