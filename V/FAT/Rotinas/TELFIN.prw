#Include "rwmake.ch"
#Include "Topconn.ch"

/*
============================================================================
TELFIN, Function
============================================================================
Criação   : Jun 06, 2016 - André Luiz Rosa
Nome      : TELFIN
Tipo      : Function 
Descrição : Execblock para validar cadastro de clientes com telefone me branco
Parâmetros: Nenhum.
Retorno   : Nenhum.
Observ.   : Nenhum
----------------------------------------------------------------------------*/
User Function TELFIN()
	Local cCodigoCliente:=M->C5_CLIENTE
	Local cLojaCliente	:=M->C5_LOJACLI

	Local cTelfin:=POSICIONE("SA1",1,xFilial("SA1")+cCodigoCliente+cLojaCliente,"A1_ZZTELFI")

	If empty(cTelfin)   
    	ALERT('Para faturar com esse cliente é necessário cadastrar um telefone financeiro no cadastro desse cliente!')
        Return("      ")
     EndIf
                         
Return(cCodigoCliente)