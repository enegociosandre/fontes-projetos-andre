#include "Protheus.ch"
#include "Totvs.ch"

/*
Nome       			: VMREIC10
Descrição  			: Alterar Número de Série do Item do PO
Ponto	   			: Executado via rotina de menu
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
Nota				: 
*/

************************
User Function VMREIC10   && Função para abertura de tela com o campo a ser alterado
************************

Local cTitulo		:= "Informe o pedido e item a ser alterado."
Private cPedido		:= SPACE(15)
Private cItem		:= SPACE(15)
Private cPosicao	:= SPACE(4)
Private cNrSerie	:= SPACE(20)
Private nLin		:= 004
Private _oJanela
Private lRet		:= .T.

	DEFINE MSDIALOG _oJanela  TITLE cTitulo FROM 000,000 to 170,530 PIXEL 
	 
	nLin+=5
	
	@ nLin,012 Say "Pedido:" SIZE 140,20 OF _oJanela PIXEL
	@ nLin,060 MSGET cPedido F3 "SW2" WHEN .T. SIZE 60,07 OF _oJanela PIXEL

	nLin+=15

	@ nLin,012 Say "Item do Pedido:" SIZE 140,20 OF _oJanela PIXEL
	@ nLin,060 MSGET cItem F3 "ZZSW3" WHEN .T. SIZE 60,07 OF _oJanela PIXEL

	@ nLin,150 Say "Posição Item:" SIZE 140,20 OF _oJanela PIXEL
	@ nLin,190 MSGET cPosicao WHEN .F. SIZE 60,07 OF _oJanela PIXEL

	nLin+=15

	@ nLin,012 Say "Nr de Serie:" SIZE 140,20 OF _oJanela PIXEL
	@ nLin,060 MSGET cNrSerie WHEN .T. SIZE 60,07 OF _oJanela PIXEL

	@ 60,130 BUTTON "Gravar" SIZE 50,12 ACTION(GravaSW3()) OF _oJanela PIXEL
	@ 60,200 BUTTON "Cancelar" SIZE 50,12 ACTION(_oJanela:End()) OF _oJanela PIXEL
	
	Activate Dialog _oJanela Centered
                          
Return(lRet)


***************************
Static Function GravaSW3()
***************************
		
	dbSelectArea("SW3")
	SW3->(dbSetOrder(8))
	If SW3->(dbSeek(xFilial("SW3") + cPedido + cPosicao ))
		While !SW3->(EOF()) .AND. (SW3->W3_FILIAL + SW3->W3_PO_NUM + SW3->W3_POSICAO) == (xFilial("SW3") + cPedido + cPosicao)
			
			SW3->(RecLock("SW3",.F.))
					SW3->W3_ZZNRSER := cNrSerie
			SW3->(MsUnLock())
			
			SW3->(dbSkip())
	    EndDo
	    SW3->(dbCloseArea())
	EndIf

	MsgInfo("Número de Série gravado!!!","Informação!")
	_oJanela:End()
	
Return(lRet)