#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'   

/*
============================================================================
A010TOK, Function
============================================================================
Cria��o   : Jun 16, 2016 - Andr� Zingra de Lima.
Nome      : A010TOK
Tipo      : Function (PE:Ponto de Entrada)
Descri��o : Na confirma��o da grava��o do cadastro de produtos
Par�metros: Nenhum.
Retorno   : .T. para continuar a grava��o e .F. para cancelar a grava��o
Observ.   : Utilizada para gerar o B1_CODBAR sequencial a partir do ultimo 
		  : existente no banco de dados.
----------------------------------------------------------------------------*/    
User Function A010TOK()
	Local cAliasSB1	:= GetNextAlias()
	Local cQuery	:= ""
	Local cNewCode	:= ""
	Local cMensagem	:= ""
	
	if (ALLTRIM(M->B1_CODBAR)=="" .or. ALLTRIM(M->B1_CODBAR)=="0") .and. M->B1_TIPO=="ME"
	
		cQuery := "SELECT CONCAT(REPLICATE('0',13-DATALENGTH(MAX(LTRIM(RTRIM(B1_CODBAR)))+1)), MAX(LTRIM(RTRIM(B1_CODBAR)))+1) as NewCode "
		cQuery += "  FROM " + RetSQLName("SB1") + " B1 "
		cQuery += "WHERE "
		cQuery += "  B1_FILIAL  = '" + xFilial("SB1") + "' AND "
		cQuery += "  B1_TIPO = 'ME' AND "
		cQuery += "  B1.D_E_L_E_T_ = ' ' "
		
		TcQuery cQuery New Alias &cAliasSB1
		
		(cAliasSB1)->(dbGoTop())
		if Len(Alltrim((cAliasSB1)->NewCode)) = 13
			M->B1_CODBAR :=alltrim((cAliasSB1)->NewCode)
			cMensagem := "C�digo de Barras Gerado com Sucesso: " + Alltrim(M->B1_CODBAR) + "  !!"
		else
			M->B1_CODBAR :=""
			cMensagem := "C�digo de Barras inv�lido: " + Alltrim((cAliasSB1)->NewCode) + " !! Favor verificar o cadastro!!!"
		endif
		(cAliasSB1)->(dbCloseArea())		
		msgAlert(cMensagem, "C�digo de Barras")
	endif
    
	U_VMRESS01() && inclu�do para unificar o PE desenvolvido pelo Andr� Borin
	
Return(.T.)