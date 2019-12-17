#INCLUDE "rwmake.ch"

/*
============================================================================
zzSubGrp, Function
============================================================================
Criação   : Oct 17, 2014 - André Zingra de Lima.
Nome      : zzSubGrp
Tipo      : Function 
Descrição : Função para cadastro de tabelas personalizadas
Retorno   : Nenhum.
Observ.   : Nenhuma
----------------------------------------------------------------------------*/    
User Function zzSubGrp
	Private cCadastro := "SubGrupo"

	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
                           {"Visualizar","AxVisual",0,2} ,;
                           {"Incluir","AxInclui",0,3} ,;
                           {"Alterar","AxAltera",0,4} ,;
                           {"Excluir","AxDeleta",0,5} }

	Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
                
       	dbSelectArea("ZZA")
        dbSetOrder(1)
        mBrowse(6,1,22,75,"ZZA")
Return

