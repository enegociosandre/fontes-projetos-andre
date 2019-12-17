#include "protheus.ch"
#include "totvs.ch"

/*
Nome       			: VMREIC07
Descrição  			: Informações adicionais no array do SF1 na geração da nota fiscal pelo EIC
Ponto	   			: Executado do ponto de entrada EICDI154_RDM
Nota       			: -
Ambiente   			: IMPORTACAO
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Criação 		: 23/03/2016
Param. Pers 		: -
Campos Pers.		: -

Nº Revisão			: -
Data Revisão		: -
Revisor				: -                 
Nota				: 
*/

User Function VMREIC07

Local cEspecie		:= Alltrim(GetMV("ZZ_ESPENFC"))
Private cHawb		:= SW6->W6_HAWB
Private cFornArm	:= ""
Private cLojaArm	:= ""
Private cFornFre	:= ""
Private cLojaFre	:= ""
Private cFornDes	:= ""
Private cLojaDes	:= ""
Private nVlArmaz 	:= 0
Private nVlFrete	:= 0
Private nVlDesp		:= 0
Private nVlOther	:= 0
	
	VLRARMAZ()
	
	If nTipoNF = 2
		&& Adiciona as variaveis no array do cabecalho da nota fiscal de entrada
		aAdd(aCab,{"F1_ESPECIE"  , cEspecie  , Nil}) && Especie do documento
		aAdd(aCab,{"F1_ZZARMAZ"  , nVlArmaz  , Nil}) && Valor Armazenagem Entreposto
		aAdd(aCab,{"F1_ZZFRETE"  , nVlFrete  , Nil}) && Valor Frete Entreposto
		aAdd(aCab,{"F1_ZZDESP"   , nVlDesp   , Nil}) && Valor Despesas Entreposto
		aAdd(aCab,{"F1_ZZFARM"   , cFornArm  , Nil}) && Fornecedor Armazenagem Entreposto
		aAdd(aCab,{"F1_ZZLARM"   , cLojaArm  , Nil}) && Loja Armazenagem Entreposto
		aAdd(aCab,{"F1_ZZFFRET"  , cFornFre  , Nil}) && Fornecedor Frete Entreposto
		aAdd(aCab,{"F1_ZZLFRET"  , cLojaFre  , Nil}) && Loja Frete Entreposto
		aAdd(aCab,{"F1_ZZFDESP"  , cFornDes  , Nil}) && Fornecedor Despesas Entreposto
		aAdd(aCab,{"F1_ZZLDESP"  , cLojaDes  , Nil}) && Loja Despesas Entreposto
	
	ElseIf nTipoNF == 1 .OR. nTipoNF == 5
		aAdd(aCab,{"F1_ZZOTHER"  , nVlOther  , Nil}) && Valor Despesas Other
	EndIf
Return

**************************************************************
&& Encontra o valor da armazenagem, frete e despesas em entreposto do processo.
Static Function VLRARMAZ

	dbSelectArea("SWD")
	SWD->(dbSetOrder(1))
	If SWD->(dbSeek(xFilial("SWD") + cHawb ))
		While !SWD->(EOF()) .AND. (xFilial("SWD") + cHawb) == (SWD->WD_FILIAL + SWD->WD_HAWB)
		    
			If Empty(SWD->WD_NF_COMP)
				dbSelectArea("SYB")
				SYB->(dbSetOrder(1))
				If SYB->(dbSeek(xFilial("SYB") + SWD->WD_DESPESA ))
					If SYB->YB_BASEIMP <> "1" .AND. SYB->YB_BASEICM <> "1"
						If SYB->YB_ZZARMAZ == "A"
							nVlArmaz += SWD->WD_VALOR_R
							cFornArm := SWD->WD_FORN
							cLojaArm := SWD->WD_LOJA
							
						ElseIf SYB->YB_ZZARMAZ == "F"
							nVlFrete += SWD->WD_VALOR_R
							cFornFre := SWD->WD_FORN
							cLojaFre := SWD->WD_LOJA
							
						ElseIf SYB->YB_ZZARMAZ == "D"
							nVlDesp  += SWD->WD_VALOR_R
							cFornDes := SWD->WD_FORN
							cLojaDes := SWD->WD_LOJA
						EndIf
					
					ElseIf SYB->YB_ZZARMAZ == "O"
						nVlOther += SWD->WD_VALOR_R
					EndIf
				EndIf
			EndIf
				
			SWD->(dbSkip())
	    EndDo
	EndIf
Return