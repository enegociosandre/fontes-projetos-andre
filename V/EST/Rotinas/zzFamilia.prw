#INCLUDE "rwmake.ch"

/*
============================================================================
zzSubGrp, Function
============================================================================
Criação   : Oct 17, 2014 - André Zingra de Lima.
Nome      : zzFamilia
Tipo      : Function 
Descrição : Função para cadastro de tabelas personalizadas
Retorno   : Nenhum.
Observ.   : Nenhuma
----------------------------------------------------------------------------*/    
User Function zzFamilia
	Private cCadastro := "Familia"

	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
                           {"Visualizar","AxVisual",0,2} ,;
                           {"Incluir","AxInclui",0,3} ,;
                           {"Alterar","AxAltera",0,4} ,;
                           {"Excluir","AxDeleta",0,5} }

	Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
                
       	dbSelectArea("ZZB")
        dbSetOrder(1)
        mBrowse(6,1,22,75,"ZZB")
Return

