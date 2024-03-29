#Include 'Protheus.ch'
#include 'topconn.ch'

/**
* Rotina  	: MT010BRW()
* Autor   	: Andr� Rosa
* Data   	: 12/05/17
* Descricao : Adiciona mais op��es de menu na Mbrowse
**/

User Function MT010BRW ()

	Local aArea		:= GetArea()
	Local aAuxRet 	:= {}	// Define Array contendo as Rotinas a executar do programa     
	Local aRotUser:={}

	aAdd(aRotUser,{"Legenda","U_MT010LEG", 0, 3, 0, Nil })     

	// ----------- Elementos contidos por dimensao ------------    
	// 1. Nome a aparecer no cabecalho                             
	// 2. Nome da Rotina associada                                 
	// 3. Usado pela rotina                                        
	// 4. Tipo de Transacao a ser efetuada                         
	//    1 - Pesquisa e Posiciona em um Banco de Dados            
	//    2 - Simplesmente Mostra os Campos                        
	//    3 - Inclui registros no Bancos de Dados                  
	//    4 - Altera o registro corrente                           
	//    5 - Remove o registro corrente do Banco de Dados         
	//    6 - Altera determinados campos sem incluir novos Regs     
	
	AADD(aAuxRet,{"Inclus�o N.V.E.","U_EICA0002()",0,5})
	//cassiano em 28-03-17
	AADD(aAuxRet,{"Exclus�o N.V.E.","U_EXCNVE()",0,6})
	//fim cassiano

RestArea(aArea)

Return aAuxRet

/**
* Rotina  	: MT010BRW()
* Autor   	: Andr� Rosa
* Data   	: 12/05/17
* Descricao : Legenda Produtos Anuentes
**/

User Function MT010LEG()

	Local aLegenda := {}

	aAdd(aLegenda,{'BR_LARANJA' ,"Revisar"		})
	aAdd(aLegenda,{'BR_VERMELHO' 	,"Anuente"		})
	aAdd(aLegenda,{'BR_AZUL',"N�o Anuente"	})

	BrwLegenda("Legenda","Legenda Produtos Anuentes", aLegenda ) 

Return 