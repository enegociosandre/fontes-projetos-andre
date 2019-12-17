#INCLUDE "protheus.ch"

/**
 * Função:			EICA0004
 * Autor:			Ademar Pereira Junior
 * Data:			25/01/2016
 * Descrição:		Gravar N.V.E. dos produtos 
**/

User Function EICA0004()
	Local aArea 	:= GetArea()
	Local cAuxTab	:= ""
	Local lLocaliz	:= .F.			// Localizou tabela?
	local cAliasZZ1	:= getNextAlias()
	local cAliasEIM	:= getNextAlias()
	local cAliasDet := getNextAlias()
	local nRegsZZ1	:= 0
	local nRegsDet	:= 0
	local lDif		:= .f.
	Local n 		:= 0
	Local k 		:= 0

	If Aviso("Atenção","Confirma a execução da rotina para gravar N.V.E. dos produtos?",{"Sim","Não"}) == 1
		DbSelectArea("SW8")
		// W8_FILIAL + W8_HAWB + W8_INVOICE + W8_FORN + W8_FORLOJ
		SW8->(DbSetOrder(1))
		If SW8->(DbSeek(xFilial("SW8") + SW6->W6_HAWB))
			While SW8->(!EOF()) .And. SW8->W8_HAWB == SW6->W6_HAWB
				lLocaliz	:= .F.
				cAuxTab		:= ""
			
				retZZ1(@cAliasZZ1, @nRegsZZ1)
				retEIM(@cAliasEIM, SW8->W8_TEC)
				
				if nRegsZZ1 > 0
					if (cAliasEIM)->(!eof())
						while (cAliasEIM)->(!eof())
							lDif		:= .f.
							(cAliasZZ1)->(dbGoTop())
							
							retDetEIM(@cAliasDet, @nRegsDet, (cAliasEIM)->EIM_CODIGO)
							
							if nRegsZZ1 == nRegsDet
								while (cAliasZZ1)->(!eof())
									if (cAliasZZ1)->(ZZ1_ATRIB + ZZ1_ESPECI ) != (cAliasDet)->(EIM_ATRIB + EIM_ESPECI)
										lDIf := .t.
										exit
									else
										(cAliasZZ1)->(dbSkip())
										(cAliasDet)->(dbSkip())
									endif
								enddo
							else
								lDIf := .t.
							endif
							(cAliasDet)->(dbClosearea())
							
							if !lDif
								//Pega codigo EIM E GRAVA SW8
								cAuxTab := (cAliasEIM)->EIM_CODIGO
								exit
							endif
							(cAliasEIM)->(dbSkip())
						enddo
						
						If lDif
							lLocaliz := .t.//cria EIM E GRAVA SW8
							cAuxTab := retNumTab()
						endif
					else
						lLocaliz := .t.//cria EIM E GRAVA SW8
						cAuxTab := retNumTab()
					endif
					
				endif
				(cAliasEIM)->(dbclosearea())
				(cAliasZZ1)->(dbclosearea())
				
				
				/*
					01 - Nivel	
					02 - Atributo
					03 - Especificação
					04 - NCM
					05 - Tabela
				*/

				
				If lLocaliz
					DbSelectArea("ZZ1")
					ZZ1->(DbSetOrder(1))
					If ZZ1->(DbSeek(xFilial("ZZ1") + SW8->W8_COD_I))
						While ZZ1->ZZ1_PRODUT == SW8->W8_COD_I
							RecLock("EIM",.T.)
							EIM->EIM_FILIAL := xFilial("EIM")
							EIM->EIM_HAWB	:= SW6->W6_HAWB
							EIM->EIM_NIVEL	:= ZZ1->ZZ1_NIVEL
							EIM->EIM_ATRIB	:= ZZ1->ZZ1_ATRIB
							EIM->EIM_DES_AT	:= ZZ1->ZZ1_DES_AT
							EIM->EIM_ESPECI	:= ZZ1->ZZ1_ESPECI
							EIM->EIM_DES_ES	:= ZZ1->ZZ1_DES_ES
							EIM->EIM_CODIGO	:= cAuxTab
							EIM->(MsUnlock())
								
							ZZ1->(DbSkip())
						EndDo
					EndIf
				EndIf

				RecLock("SW8",.F.)
				SW8->W8_NVE := cAuxTab
				SW8->(MsUnlock())
				
				SW8->(DbSkip())
			EndDo
		EndIf
		
		Aviso("Atenção","Rotina executada com sucesso!",{"Ok"})
	EndIf
	
	RestArea(aArea)
Return


/*
** Retorna Informações ZZ1 - NVE
*/
static function retZZ1(cAliasZZ1, nRegsZZ1)
	
	beginSql Alias cAliasZZ1
		SELECT W8_TEC, ZZ1_ATRIB, ZZ1_ESPECI
		FROM %TABLE:ZZ1% ZZ1
		INNER JOIN %TABLE:SW8% SW8 ON
		W8_FILIAL	= %EXP:xFilial("SW8")%
		AND W8_COD_I 	= ZZ1.ZZ1_PRODUT
		AND SW8.%NOTDEL%
		WHERE
		ZZ1_FILIAL	= %EXP:xFilial("ZZ1")%
		AND ZZ1_PRODUT = %EXP:SW8->W8_COD_I%
		AND ZZ1.%NOTDEL%
		GROUP BY W8_TEC, ZZ1_ATRIB, ZZ1_ESPECI
		ORDER BY 1,2
	endSql
	
	Count to nRegsZZ1
	(cAliasZZ1)->(dbGoTop())
		
return


/*
** Retorna Informações EIM
*/
static function retEIM(cAliasEIM, cNCM)
	
	beginSql Alias cAliasEIM
		SELECT EIM_CODIGO
		FROM %TABLE:SW8% SW8
		INNER JOIN %TABLE:EIM% EIM ON
		EIM_FILIAL	= %EXP:xFilial("EIM")%
		AND EIM_CODIGO 		= W8_NVE
		AND EIM_HAWB 	= W8_HAWB
		AND EIM.%NOTDEL%
		WHERE
		W8_FILIAL   = %EXP:xFilial("SW8")%
		AND W8_HAWB = %EXP:SW6->W6_HAWB%
		AND W8_TEC  = %EXP:cNCM%
		AND SW8.%NOTDEL%
		GROUP BY EIM_CODIGO
		ORDER BY 1
	endSql
	
	(cAliasEIM)->(dbGoTop())
		
return


/*
** Retorna Informações EIM
*/
static function retDetEIM(cAliasDet, nRegsDet, cCodigo)
	
	beginSql Alias cAliasDet
		SELECT EIM_ATRIB, EIM_ESPECI, EIM_CODIGO
		FROM %TABLE:EIM% EIM
		WHERE
		EIM_FILIAL		= %EXP:xFilial("EIM")%
		AND EIM_CODIGO 	= %EXP:cCodigo%
		AND EIM_HAWB	= %EXP:SW6->W6_HAWB%
		AND EIM.%NOTDEL%
		GROUP BY EIM_ATRIB, EIM_ESPECI, EIM_CODIGO
		ORDER BY 3,1
	endSql
	Count to nRegsDet
	(cAliasDet)->(dbGoTop())
		
return


/*
**
*/
static function retNumTab()
	local cAlias := getNextAlias()
	local cNum	 := "000"
	
	beginSql Alias cAlias
		SELECT MAX(EIM_CODIGO) CODIGO
		FROM %TABLE:EIM% EIM
		WHERE
		EIM_FILIAL		= %EXP:xFilial("EIM")%
		AND EIM_HAWB	= %EXP:SW6->W6_HAWB%
		AND EIM.%NOTDEL%
		ORDER BY 1
	endSql
	(cAlias)->(dbGoTop())
	if (cAlias)->(!eof())
		cNum := (cAlias)->CODIGO
	endif
	(cAlias)->(dbclosearea())
	
return soma1(cNum)