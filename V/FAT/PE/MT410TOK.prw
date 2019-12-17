#Include 'Protheus.ch'
/*/{Protheus.doc}	MT410TOK
Ponto de entrada que realiza validação na TES. 

@author				Gerson Schiavo
@since				05/04/2016
/*/

User Function MT410TOK()

	Local lRet    	:= .T.
	Local nPosTES	:= aScan(aHeader,{|x|Alltrim(x[2])=="C6_TES"})
	Local nOpc		:= PARAMIXB[1] //1-Exclusão,2-Visualização,3-Inclusão,4-Alteração
	
	if Inclui
	
		For x:= 1 to len(aCols)
			dbSelectArea("SF4")
			if dbSeek(xFilial("SF4")+aCols[x,nPosTES])
				if SF4->F4_ZZNOTA = "N"
					M->C5_ZZSTAT:= "B"  //Pedido Bloqueado para Faturamento e fica aguardando a Liberação do Responsável.
					exit
				endif
			endif
		Next x			
		
		u_grvPropostaPV()
		
	endif
	
Return(lRet)