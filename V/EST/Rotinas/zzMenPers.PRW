#INCLUDE "rwmake.ch"

/*
============================================================================
zzMenPers, Function
============================================================================
Cria��o   : Oct 17, 2014 - Andr� Zingra de Lima.
Nome      : zzMenPers
Tipo      : Function 
Descri��o : Fun��o para cadastro de tabelas de Mensagens Personalizadas
Retorno   : Nenhum.
Observ.   : Nenhuma
----------------------------------------------------------------------------*/    
User Function zzMenPers
	Private cCadastro := "Mensagens Personalizadas"

	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
                           {"Visualizar","AxVisual",0,2} ,;
                           {"Incluir","AxInclui",0,3} ,;
                           {"Alterar","AxAltera",0,4} ,;
                           {"Excluir","AxDeleta",0,5} }

	Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
                
       	dbSelectArea("ZZ2")
        dbSetOrder(1)
        mBrowse(6,1,22,75,"ZZ2")
Return

