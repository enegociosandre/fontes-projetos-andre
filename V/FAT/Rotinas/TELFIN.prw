#Include "rwmake.ch"
#Include "Topconn.ch"

/*
============================================================================
TELFIN, Function
============================================================================
Cria��o   : Jun 06, 2016 - Andr� Luiz Rosa
Nome      : TELFIN
Tipo      : Function 
Descri��o : Execblock para validar cadastro de clientes com telefone me branco
Par�metros: Nenhum.
Retorno   : Nenhum.
Observ.   : Nenhum
----------------------------------------------------------------------------*/
User Function TELFIN()
	Local cCodigoCliente:=M->C5_CLIENTE
	Local cLojaCliente	:=M->C5_LOJACLI

	Local cTelfin:=POSICIONE("SA1",1,xFilial("SA1")+cCodigoCliente+cLojaCliente,"A1_ZZTELFI")

	If empty(cTelfin)   
    	ALERT('Para faturar com esse cliente � necess�rio cadastrar um telefone financeiro no cadastro desse cliente!')
        Return("      ")
     EndIf
                         
Return(cCodigoCliente)