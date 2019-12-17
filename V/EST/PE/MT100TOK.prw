#Include 'Protheus.ch'
#include"topconn.ch"

***********************************************************************************************************************
***********************************************************************************************************************
//Função: MT100TOK() - Ponto de Entrada no Documento de Entrada para Notas de Complemento do EIC para mostrar na     //
//                     tela os Produtos que possuem TES que controlam Estoque e que não tem Saldo                    //
***********************************************************************************************************************
***********************************************************************************************************************
User Function MT100TOK()

Local lRet		:= .T.
Local aArea		:= GetArea()
Local nPosCod	:= GdFieldPos("D1_COD")
Local nPosTes	:= GdFieldPos("D1_TES")
Local nPosArm	:= GdFieldPos("D1_LOCAL")
Local aSaldo	:= {}    
Local aProdutos := {}


if SF1->F1_TIPO_NF = "2"

	For x := 1 to Len(aCols)
		
		if !GdDeleted(x)
				
			dbSelectArea("SF4")
			dbSetOrder(1)
			if dbSeek(xFilial("SF4")+aCols[x,nPosTes])

				if SF4->F4_ESTOQUE = 'S'  

					aSaldo:= CalcEst(aCols[x,nPosCod],aCols[x,nPosArm],dDataBase+1)				
					
					if aSaldo[2] <= 0
						aAdd (aProdutos, { aCols[x,nPosCod] })     
					endif
				endif
			endif		
		endif		
					
	Next x
	
	if Len(aProdutos) > 0
		lRet:= .f.
		cMens:= "Nota Fiscal com Produto Sem Saldo ! " + CRLF
		cMens+= "" + CRLF
		For i:= 1 to len(aProdutos)
			cMens+=  Alltrim(aProdutos[i,1]) + CRLF
		Next i
		MsgInfo(cMens,"ATENÇÃO")
	endif
	
endif

RestArea(aArea)

Return(lRet)
