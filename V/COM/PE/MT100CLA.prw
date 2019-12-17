/*
============================================================================
MT100CLA, Function
============================================================================
Criação   : Jun 06, 2016 - André Zingra de Lima.
Nome      : MT100CLA
Tipo      : Function 
Descrição : PE para exibir os parametros da tecla F12.
Parâmetros: Nenhum.
Retorno   : Nenhum.
Observ.   : Ponto de Entrada
----------------------------------------------------------------------------*/  
User Function MT100CLA()            
	Local _cUsu := GetMv("MV_ZZF12COM")   && Usuario(s) com permissao para alteracao dos parametros.

	aAreaSF1 := SF1->(GetArea())
	aAreaSD1 := SD1->(GetArea())     
	
	// Verifica se o usuário é autorizado.
	If Alltrim(UsrRetName(RetCodUsr())) $ _cUsu
    	Pergunte("MTA103", .T.)
    EndIf

	RestArea(aAreaSF1)
	RestArea(aAreaSD1)

	GetDRefresh()
Return .T.