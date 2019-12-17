#INCLUDE "protheus.ch"

/**
 * Função:			IDI500MNU
 * Autor:			Ademar Pereira Junior
 * Data:			25/01/2016
 * Descrição:		Adicionar itens no menu 
**/

User Function IDI500MNU()
Local aArea		:= GetArea()
Local aAuxRet 	:= {}	// Define Array contendo as Rotinas a executar do programa     

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
	
	AADD(aAuxRet,{"Att.Oper.Fiscal","U_EICA0003()",0,1})
	AADD(aAuxRet,{"N.V.E do Produto","U_EICA0004()",0,1})

RestArea(aArea)
Return aAuxRet

