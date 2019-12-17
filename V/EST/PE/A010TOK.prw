#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'   

/*
============================================================================
A010TOK, Function
============================================================================
Criação   : Jun 16, 2016 - André Zingra de Lima.
Nome      : A010TOK
Tipo      : Function (PE:Ponto de Entrada)
Descrição : Na confirmação da gravação do cadastro de produtos
Parâmetros: Nenhum.
Retorno   : .T. para continuar a gravação e .F. para cancelar a gravação
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
			cMensagem := "Código de Barras Gerado com Sucesso: " + Alltrim(M->B1_CODBAR) + "  !!"
		else
			M->B1_CODBAR :=""
			cMensagem := "Código de Barras inválido: " + Alltrim((cAliasSB1)->NewCode) + " !! Favor verificar o cadastro!!!"
		endif
		(cAliasSB1)->(dbCloseArea())		
		msgAlert(cMensagem, "Código de Barras")
	endif
    
	U_VMRESS01() && incluído para unificar o PE desenvolvido pelo André Borin
	
Return(.T.)