#INCLUDE "rwmake.ch"

/*
============================================================================
M020INC, Function
============================================================================
Criação   : Jan 29, 2004 - J.DONIZETE R.SILVA.
Nome      : M020INC
Tipo      : Function 
Descrição : Ponto de Entrada p/ para geracao automatica da Conta Contabil
            do Fornecedor conforme inclusao do mesmo.
Retorno   : Nenhum.
Observ.   : Nenhuma
----------------------------------------------------------------------------
Data      : Alterações
23/12/2006: Adaptado do modelo desenvolvido pelo Vitor L.Fattori
31/08/2007: Efetuado melhorias na rotina p/melhor tratamento quanto
            a criação/atualização da conta no cadastro do fornecedor.
----------------------------------------------------------------------------*/   

User Function M020INC()

// Declaração das Variáveis.
Local _xAreaSA2		:= {}
Local _xAreaCT1		:= {}
Local _cCod			:= ""
Local _cEst			:= ""
Local _cConta		:= ""
Local _cContAd		:= ""
Local _a2_tipo		:= ""
Local _aIncCad  	:= {}
Local _lCria		:= .f. // Esta variável define se será criado ou não conta analítica. A alteração da mesma
Local _cCtaSint		:= ""  // é feita abaixo.
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.


// Processa somente se o módulo for SIGACTB e a opção for de Inclusão.
If INCLUI .and. Upper(Alltrim(GetMv("MV_MCONTAB"))) == "CTB" .And. Empty(SA2->A2_CONTA)
	
	dbSelectArea("SA2")
	_xAreaSA2 := GetArea()
	
	// Memoriza dados.
	_cCod		:= SA2->A2_COD+SA2->A2_LOJA
	_cEst		:= SA2->A2_EST
	_a2_tipo 	:= SA2->A2_TIPO
	_cTpEmp		:= SA2->A2_ZZINTC
	_cConta  	:= ""
	_cCtaSint	:= ""
	
	If _cEst="EX" .and. _a2_tipo="X"

		if _cTpEmp=="S"
			_cCtaSint := "21102002"
		else

			_cCtaSint := "21102003"
		endif
		_lCria := .t.
	Else
		_cCtaSint := "21102001"
		_lCria := .t.
	Endif	
	
	If _lCria
		_cContAd	:= "11208001"
		_cConta 	:= _cCtaSint + _cCod
		
		dbSelectArea("CT1")
		_xAreaCT1 := GetArea()
		dbSetOrder(1)
		DbSeek(xFilial("CT1") + _cConta)
		
		If .not. Found()           
	
			While !Reclock("CT1",.T.);Enddo
			CT1->CT1_FILIAL	:= Xfilial("CT1")
			CT1->CT1_CONTA   := _cConta
			CT1->CT1_DESC01	:= SA2->A2_NOME
			CT1->CT1_CLASSE   := "2"
			CT1->CT1_NORMAL   := "2"
			CT1->CT1_RES		:= _cCod
			CT1->CT1_CTASUP	:= _cCtaSint
			CT1->CT1_ACITEM	:= "2"           
			CT1->CT1_ACCUST   := "2"
			CT1->CT1_ACCLVL   := "2"
			CT1->CT1_CCOBRG   := "2"
			CT1->CT1_ITOBRG   := "2"
			CT1->CT1_CLOBRG   := "2"
			CT1->CT1_BLOQ		:= "2"
			CT1->CT1_BOOK		:= "001/002/003/004/005"
			CT1->CT1_CVD02		:= "1"
			CT1->CT1_CVD03		:= "1"
			CT1->CT1_CVD04		:= "1"
			CT1->CT1_CVD05		:= "1"
			CT1->CT1_CVC02		:= "1"
			CT1->CT1_CVC03		:= "1"
			CT1->CT1_CVC04		:= "1"
			CT1->CT1_CVC05		:= "1"
			CT1->CT1_DTEXIS	:= Ctod("01/01/1980")
		Endif
	EndIf
	
	// Atualiza a conta no cadastro do Cliente.
	DbSelectArea("SA2")
	If Reclock("SA2", .F.)
		REPLACE SA2->A2_CONTA	with _cConta
		REPLACE SA2->A2_ZZCTAAD with _cContAd	
		MsUnlock()
	EndIf
	
	// Restaura áreas de trabalho.
	DbSelectArea("CT1")
	RestArea(_xAreaCT1)
	DbSelectArea("SA2")
	RestArea(_xAreaSA2)
	
Endif

Return
