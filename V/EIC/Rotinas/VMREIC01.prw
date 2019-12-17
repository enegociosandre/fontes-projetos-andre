#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"

/*
Nome       			: VMREIC01
Descrição  			: Preencher informacoes do titulo a pagar na inclusao via despesas do desembaraco e prestacao de contas
Ponto	   			: Executado do ponto de entrada EICFI400_RDM
Nota       			: -
Ambiente   			: IMPORTACAO
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Criação 		: 13/11/2015
Param. Pers 		: -
Campos Pers.		: -

Nº Revisão			: -
Data Revisão		: -
Revisor				: -                 
Nota				: 
*/

User Function VMREIC01

Local cDespesa 	:= ""
Local cTipoTit	:= "  "
Local cNaturez	:= "          "
Local cFornece	:= "      "
Local cLojaFor	:= "  "
Local nAuxParc	:= 0     
Local cCodDesp	:= ""

Public cZZParc
	
	dbSelectArea("SYB")
	SYB->(dbSetOrder(1))
	If SYB->(dbSeek(xFilial("SYB") + M->WD_DESPESA ))
		cCodDesp	:= M->WD_DESPESA
		cDespesa 	:= Alltrim(SYB->YB_DESCR)
		cTipoTit	:= SYB->YB_ZZTIPOT
		cNaturez	:= SYB->YB_ZZNATUR
		cFornece	:= SYB->YB_ZZFORN
		cLojaFor	:= SYB->YB_ZZLOJAF
	EndIf
	
	If M->WD_GERFIN == "1" && Via Inclusao Manual da Despesa

		If !Empty(cTipoTit)
			M->E2_TIPO		:= cTipoTit
		EndIf
		If !Empty(cNaturez)
			M->E2_NATUREZ	:= cNaturez
		EndIf
		If !Empty(cFornece)
			M->E2_FORNECE 	:= cFornece
			M->E2_LOJA    	:= cLojaFor
			M->E2_NOMFOR	:= Posicione("SA2",1,xFilial("SA2") + cFornece + cLojaFor,"A2_NREDUZ")
		EndIf
	 	M->E2_HIST := "P: " + Alltrim(SW6->W6_HAWB) + " - " + cDespesa
	 		
	ElseIf M->WD_GERFIN != "1" && Via Prestacao de Contas
        
		M->E2_NUM := Alltrim(SW6->W6_HAWB)
		
		If !Empty(cZZParc)
			cZZParc := cZZParc
		Else
			cZZParc := "00"
		EndIf
		
		nAuxParc := Val(cZZParc) + 1
		cZZParc  := StrZero(nAuxParc,2)
		
		M->E2_PARCELA := cZZParc
		M->E2_NATUREZ := cNaturez
		If !Empty(cTipoTit)
			M->E2_TIPO := cTipoTit
		EndIf
	EndIf
		 
	M->E2_ZZHAWB 	:= Alltrim(SW6->W6_HAWB)
	M->E2_ZZCDESP 	:= cCodDesp
	
	If FA050Natur() .AND. FinVldNat(.F.,M->E2_NATUREZ,2)
		M->E2_NATUREZ := M->E2_NATUREZ
	Else
		M->E2_NATUREZ := "          "
	EndIf
Return