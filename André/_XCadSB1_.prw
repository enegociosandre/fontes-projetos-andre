#include "Totvs.ch"  

/**
 * Rotina		:	XCadSB1
 * Autor		:	Mathias - Totvs Campinas
 * Data			:
 * Descricao	:	Fonte exemplo de da Fun��o AxCadastro
 *
 * Observacoes	:	Exemplo utilizado no Curso de ADVPL Avan�ado
 */                                          

User Function XCadSb1()
	Local cAlias 	:= "SB1"
	Local cTitulo 	:= "Cadastro de Produtos"
	Local cVldExc 	:= ".T."
	Local cVldAlt 	:= ".T."
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	AxCadastro(cAlias,cTitulo,cVldExc,cVldAlt)        
Return                                       


