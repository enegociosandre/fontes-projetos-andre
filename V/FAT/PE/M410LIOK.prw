#INCLUDE "rwmake.ch"
#INCLUDE 'topconn.ch'

/*
============================================================================
M410LIOK, Function
============================================================================
Criação   : Mar 01, 2016 - André Zingra de Lima.
Nome      : M410LIOK
Tipo      : Function 
Descrição : PE que valida a linha do pedido de vendas.
Parâmetros: Nenhum.
Retorno   : Nenhum.
Observ.   : Ponto de Entrada
----------------------------------------------------------------------------*/
User Function M410LIOK()
	Local nPosPro	:= aScan(aHeader,{|X|upper(alltrim(x[2]))=="C6_PRODUTO"})
	Local nPosSerie	:= aScan(aHeader,{|X|upper(alltrim(x[2]))=="C6_NUMSERI"})
	Local nPosDel   := Len(aHeader)+1
	Local nI        := 0

	Private lRet 	:= .T. 					//Valida a Linha
	Private aArea	:= GetArea() 	     	//
	Private aAreaSC6:= SC6->(GetArea())  	//Selecciona la Tabla de SC6 - Item de PV
	Private aAreaSB1:= SB1->(GetArea())  	//Selecciona la Tabla de SB1 - Producto

	If alltrim(FunName()) == "MATA410" 
		If !GDDeleted() //Item nao esta marcado como apagado

			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+aCols[n, nPosPro])

			If Found() .AND. SB1->B1_ZZSERIE== "S" .AND. Empty(aCols[n, nPosSerie])
				Alert("Atenção!!! Tipo de produto necessita informar o número de série!")
				lRet := .F.
			endif
		EndIf

		GetdRefresh() 
		oMainWnd:Refresh()
		SYSREFRESH()
	EndIf

	RestArea(aArea)
	RestArea(aAreaSC6)
	RestArea(aAreaSB1)
Return lret 
