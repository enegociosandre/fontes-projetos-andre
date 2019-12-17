#Include 'Protheus.ch'
#include 'topconn.ch'

/**
* Rotina  	: MT010BRW()
* Autor   	: André Rosa
* Data   	: 12/05/17
* Descricao : Adiciona mais opções de menu na Mbrowse
**/

User Function MT010BRW ()

	Local aArea		:= GetArea()
	Local aAuxRet 	:= {}	// Define Array contendo as Rotinas a executar do programa     
	Local aRotUser:={}
	SetKey(VK_F5, {|| u_SeuPro(SB1->B1_COD) })  
	
	aAdd(aRotUser,{"Legenda","U_MT010LEG", 0, 3, 0, Nil })     
  	AADD(aAuxRet,{"Inclusão N.V.E.","U_EICA0002()",0,5})
	AADD(aAuxRet,{"Exclusão N.V.E.","U_EXCNVE()",0,6})

RestArea(aArea)

Return aAuxRet   

                      
User Function SeuPro(cProduto)
		Static oMainWnd
		Private nLin		:= 004
		Private _oJanela
	
	DEFINE MSDIALOG _oJanela  TITLE "Titulo" FROM 000,000 to 170,530 PIXEL 
	
	@ nLin,012 Say cProduto SIZE 140,20 OF _oJanela PIXEL

    ACTIVATE MSDIALOG _oJanela  CENTERED                
       
Return 

/**
* Rotina  	: MT010BRW()
* Autor   	: André Rosa
* Data   	: 12/05/17
* Descricao : Legenda Produtos Anuentes
**/

User Function MT010LEG()

	Local aLegenda := {}

	aAdd(aLegenda,{'BR_LARANJA' ,"Revisar"		})
	aAdd(aLegenda,{'BR_VERMELHO' 	,"Anuente"		})
	aAdd(aLegenda,{'BR_AZUL',"Não Anuente"	})

	BrwLegenda("Legenda","Legenda Produtos Anuentes", aLegenda ) 

Return 