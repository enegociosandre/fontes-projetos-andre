#Include 'Protheus.ch'
#include 'topconn.ch'           

/**
* Rotina  	: MT010BRW()
* Autor   	: André Rosa
* Data   	: 12/05/17
* Descricao : Legenda na rotina Cadastro de Produtos
**/

User Function MT010COR()

	Local aCores:={}

	aAdd(aCores,{"B1_ANUENTE == ' '","BR_LARANJA"	, "Revisar"		})
	aAdd(aCores,{"B1_ANUENTE == '1'","BR_VERMELHO"		, "Anuente"		})
	aAdd(aCores,{"B1_ANUENTE == '2'","BR_AZUL"	, "Não Anuente"	})

Return aCores
