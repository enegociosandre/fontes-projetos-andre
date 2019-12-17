#include "protheus.ch"
#include "totvs.ch"

/*
Nome       			: VMREIC09
Descrição  			: Gravar informações da nota fiscal no contas a pagar
Ponto	   			: Executado do ponto de entrada EICDI154_RDM
Nota       			: -
Ambiente   			: IMPORTACAO
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Criação 		: 07/03/2017
Param. Pers 		: -
Campos Pers.		: -

Nº Revisão			: -
Data Revisão		: -
Revisor				: -
Nota				: -
*/                     

User Function VMREIC09(nTipo)

	If nTipoNF == 1 .OR. nTipoNF == 5
		dbSelectArea("SE2")
		SE2->(dbOrderNickName("ZZHAWBEIC"))
		If SE2->(dbSeek(xFilial("SE2") + SW6->W6_HAWB ))
			While !SE2->(EOF()) .AND. xFilial("SE2") == SE2->E2_FILIAL .AND. SW6->W6_HAWB == SE2->E2_ZZHAWB
				
				If SE2->E2_PREFIXO == "EIC" .AND. SE2->E2_TIPO == "INV"
					
					SE2->(RecLock("SE2",.F.))
						If nTipo == 1
							SE2->E2_ZZNFEIC	:= SF1->F1_DOC
							SE2->E2_ZZSEEIC	:= SF1->F1_SERIE
							SE2->E2_ZZEMEIC	:= SF1->F1_EMISSAO
							If !Empty(SE2->E2_ZZDATAN)
								SE2->E2_ZZSTEIC	:= "Z"
							ElseIf !Empty(SE2->E2_ZZDATAA)
								SE2->E2_ZZSTEIC := "Y"
							EndIf
						ElseIf nTipo == 2
							SE2->E2_ZZNFEIC	:= SPACE(TamSX3("E2_ZZNFEIC")[1])
							SE2->E2_ZZSEEIC	:= SPACE(TamSX3("E2_ZZSEEIC")[1])
							SE2->E2_ZZEMEIC	:= cTod("  /  /  ")
							If !Empty(SE2->E2_ZZDATAN)
								SE2->E2_ZZSTEIC	:= "N"
							ElseIf !Empty(SE2->E2_ZZDATAA)
								SE2->E2_ZZSTEIC := "A"
							EndIf							
						EndIf						
					SE2->(MsUnLock())			
				
			    EndIf
				SE2->(dbSkip())
		    EndDo
	    EndIf
	EndIf
Return