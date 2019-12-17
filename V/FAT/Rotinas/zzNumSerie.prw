#Include "PROTHEUS.CH"
#Include "TopConn.ch"

User Function zzNumSerie()

	Private cCadastro    := "Pesquisa No. de Série"
	Private cAliasMB     := "SD2"
	Private aRotina      := {}
	Private aCampos		 := {}
	
	
	Aadd( aCampos, { Posicione('SX3', 2,'D2_DOC' 	,'X3Titulo()'), 'D2_DOC'  	} ) 
	Aadd( aCampos, { Posicione('SX3', 2,'D2_SERIE' 	,'X3Titulo()'), 'D2_SERIE'  } ) 
	Aadd( aCampos, { Posicione('SX3', 2,'D2_EMISSAO','X3Titulo()'), 'D2_EMISSAO'} ) 
	Aadd( aCampos, { Posicione('SX3', 2,'D2_PEDIDO'	,'X3Titulo()'), 'D2_PEDIDO' } ) 
	Aadd( aCampos, { Posicione('SX3', 2,'D2_COD'	,'X3Titulo()'), 'D2_COD' 	} )  
	Aadd( aCampos, { Posicione('SX3', 2,'D2_UM'		,'X3Titulo()'), 'D2_UM' 	} ) 
 	Aadd( aCampos, { Posicione('SX3', 2,'D2_NUMSERI','X3Titulo()'), 'D2_NUMSERI'} ) 
	                                                                       
	aAdd(aRotina,{"Pesquisar"  ,"AxPesqui",0,1})                                  
	aAdd(aRotina,{"Visualizar" ,"AxVisual",0,2})                                  
                                                     
	// Abre a Tabela e posiciona no primeiro registro                              
	dbSelectArea(cAliasMB)                                                         
	dbSetOrder(1)                                                                  
	dbGoTop() 
	Set Filter To !Empty(SD2->D2_NUMSERI)
	                                                                                 
	//mBrowse(6,1,22,75,cAliasMB,,,,,,aCores) 
	mBrowse(6,1,22,75,cAliasMB,aCampos,,,,,)	
Return