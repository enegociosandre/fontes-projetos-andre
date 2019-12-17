
#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOPCONN.ch'

user function retornaValor(cProduto) 

local cQuery := "" 
local cAlias := getNextAlias() 
local aArea := getArea() 
local nQuantidade := 0
local nPrevisao := STOD("")

cQuery := "select QUANTIDADE, PREVISAO from ESTOQUE where CODIGO = '"+cProduto+"' and STATUS = 'TRANSITO' " + CRLF 

tcQuery cQuery NEW Alias &cAlias 

if (cAlias)->(!eof()) 
	nQuantidade := (cAlias)->QUANTIDADE 
endif

restArea(aArea) 
return nQuantidade,nPrevisao