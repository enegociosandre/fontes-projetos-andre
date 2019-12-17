#include "Totvs.ch"  

/**
 * Rotina		:	XCadSB1
 * Autor		:	Mathias - Totvs Campinas
 * Data			:
 * Descricao	:	Fonte exemplo de da Função AxCadastro
 *
 * Observacoes	:	Exemplo utilizado no Curso de ADVPL Avançado
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


