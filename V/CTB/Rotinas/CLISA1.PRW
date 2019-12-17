#INCLUDE "rwmake.ch"

/*/
Alimentar contas contabeis dos clientes ja existentes no SA1
criado por Marco Aurelio / Alexandre - 02/12/15
/*/
User Function CLISA1

// Declaração das Variáveis.
Local _xAreaSA1		:= {}
Local _xAreaCT1		:= {}
Local _cCod			:= ""
Local _cEst			:= ""
Local _cConta		:= ""
Local _A1_tipo		:= ""
Local _aIncCad  	:= {}
Local _lCria		:= .f. // Esta variável define se será criado ou não conta analítica. A alteração da mesma
Local _cCtaSint		:= ""
// é feita abaixo.
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

_filial := Xfilial("SA1")
Dbselectarea("SA1")
Dbsetorder(1)
Dbseek(Xfilial("SA1"))
While !Eof() .and. SA1->A1_FILIAL=_filial
	
	// Memoriza dados.
	_cCod		:= SA1->A1_COD+SA1->A1_LOJA
	_cEst		:= SA1->A1_EST
	_A1_tipo    := SA1->A1_TIPO
	_cConta  	:= ""
	_cCtaSint	:= ""
	
	If _cEst="EX" .and. _a1_tipo="X" //fornecedor estrangeiro devera constar com Estado = EX e TIPO = X
			_cCtaSint := "11201003"
			_lCria := .t.
	Else
			_cCtaSint := "11201001"
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
			CT1->CT1_DESC01	:= SA1->A1_NOME
			CT1->CT1_DESC02	:= SA1->A1_NOME
			CT1->CT1_DESC04	:= SA1->A1_NOME
			CT1->CT1_CLASSE := "2"
			CT1->CT1_NORMAL := "1"
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
			CT1->CT1_NTSPED := "01"
			CT1->CT1_PVARC	:= "1"
		Endif
		
		DbSelectArea("SA1")
		If Reclock("SA1", .F.)
			REPLACE SA1->A1_CONTA	with _cConta
			MsUnlock()
		EndIf      
		
	Endif
	
	DbSelectArea("SA1")
	Dbskip()
	
Enddo
Alert("Finalizado")
Return