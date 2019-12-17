	#INCLUDE "rwmake.ch"

/*/
Alimentar contas contabeis dos fornecedores ja existentes no SA2  
criado por Marco Aurelio/Alexandre E. - 02/12/15
/*/
User Function FORSA2

// Declaração das Variáveis.
Local _xAreaSA2		:= {}
Local _xAreaCT1		:= {}
Local _cCod			:= ""
Local _cEst			:= ""
Local _cConta		:= ""
Local _a2_tipo		:= ""
Local _aIncCad  	:= {}
Local _lCria		:= .f. // Esta variável define se será criado ou não conta analítica. A alteração da mesma
Local _cCtaSint		:= ""
// é feita abaixo.
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

_filial := Xfilial("SA2")
Dbselectarea("SA2")
Dbsetorder(1)
Dbseek(Xfilial("SA2"))
While !Eof() .and. SA2->A2_FILIAL=_filial
	
	// Memoriza dados.
	_cCod		:= SA2->A2_COD+SA2->A2_LOJA
	_cEst		:= SA2->A2_EST
	_a2_tipo := SA2->A2_TIPO
	_cConta  	:= ""
	_cCtaSint	:= ""
	
	If _cEst="EX" .and. _a2_tipo="X" //fornecedor estrangeiro devera constar com Estado = EX e TIPO = X
		_cCtaSint := "21102003"
		_lCria := .t.
	Else
		_cCtaSint := "21102001"
		_lCria := .t.
	Endif
	
	If _lCria
		
		_cConta := _cCtaSint + _cCod
		
		dbSelectArea("CT1")
		_xAreaCT1 := GetArea()
		dbSetOrder(1)
		DbSeek(xFilial("CT1") + _cConta)
		
		If !Found()
			
			While !Reclock("CT1",.T.);Enddo
			CT1->CT1_FILIAL	:= Xfilial("CT1")
			CT1->CT1_CONTA    := _cConta
			CT1->CT1_DESC01	:= SA2->A2_NOME
			CT1->CT1_DESC02	:= SA2->A2_NOME
			CT1->CT1_DESC04	:= SA2->A2_NOME
			CT1->CT1_CLASSE := "2"
			CT1->CT1_NORMAL := "2"
			CT1->CT1_RES    := _cCod
			CT1->CT1_BLOQ	:= "2"
			CT1->CT1_CVD02	:= "1"
			CT1->CT1_CVD03	:= "1"
			CT1->CT1_CVD04	:= "1"
			CT1->CT1_CVD05	:= "1"
			CT1->CT1_CVC01	:= "1"
			CT1->CT1_CVC02	:= "1"
			CT1->CT1_CVC03	:= "1"
			CT1->CT1_CVC04	:= "1"
			CT1->CT1_CVC05	:= "1"
			CT1->CT1_CTASUP	:= _cCtaSint
			CT1->CT1_ACITEM	:= "2"
			CT1->CT1_ACCUST := "2"
			CT1->CT1_ACCLVL := "2"
			CT1->CT1_DTEXIS	:= Ctod("01/01/1980")
			CT1->CT1_CCOBRG := "2"
			CT1->CT1_ITOBRG := "2"
			CT1->CT1_CLOBRG := "2"
			CT1->CT1_NTSPED := "02"
			CT1->CT1_PVARC	:= "1"
		Endif
		
		DbSelectArea("SA2")
		If Reclock("SA2", .F.)
			REPLACE SA2->A2_CONTA	with _cConta
			MsUnlock()
		EndIf      
		
	Endif
	
	DbSelectArea("SA2")
	Dbskip()
	
Enddo
Alert("Finalizado")
Return