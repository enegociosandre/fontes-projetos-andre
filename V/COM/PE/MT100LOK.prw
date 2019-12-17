
#INCLUDE 'Protheus.ch'     
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
============================================================================
MT100LOK, Function
============================================================================
Cria��o   : Mar 01, 2016 - Andr� Zingra de Lima.
Nome      : MT100LOK
Tipo      : Function 
Descri��o : PE que valida a linha do documento de entrada.
Par�metros: Nenhum.
Retorno   : Nenhum.
Observ.   : Ponto de Entrada
----------------------------------------------------------------------------*/    
User Function MT100LOK()
	Local lRet 		:= .t.
	Local aArea		:= GetArea()
	Local nPosProd	:= GDFieldPos("D1_COD")
	Local nPosSerie	:= GDFieldPos("D1_ZZNRSER")           
	
	
	if (cTipo == "D" .or. cTipo == "B" )
		aCols[n, nPosSerie] := SD2->D2_NUMSERI
	endIf
	
    dbSelectArea("SB1")
    dbSetOrder(1)
    dbSeek(xFilial("SB1")+aCols[n, nPosProd])
    If Found() .AND. SB1->B1_ZZSERIE== "S" .and. empty(aCols[n, nPosSerie])
		Alert("Aten��o!!! Tipo de produto necessita o n�mero de s�rie, favor informar!")
		lRet := .F.
	endif

	RestArea(aArea)	
Return lRet