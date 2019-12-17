#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"

/*
Nome       			: VMREIC05
Descrição  			: Trazer o nome do fornecedor no browse da solicitação de importação
Ponto	   			: Executado no campo W0_ZZNOMEF
Nota       			: -
Ambiente   			: IMPORTACAO
Cliente				: VERMEER
Autor      			: Andre Borin - TOTVS IP
Data Criação 		: 08/03/2016
Param. Pers 		: -
Campos Pers.		: -

Nº Revisão			: -
Data Revisão		: -
Revisor				: -                 
Nota				: 
*/

User Function VMREIC05

Local cNomeFor := ""

	dbSelectArea("SW1")
	SW1->(dbSetOrder(1))
	If SW1->(dbSeek(xFilial("SW1") + SW0->W0__CC + SW0->W0__NUM ))
		
		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		If SA2->(dbSeek(xFilial("SA2") + SW1->W1_FORN + SW1->W1_FORLOJ ))
			
			cNomeFor := SA2->A2_NOME
		EndIf
	EndIf

Return(cNomeFor)