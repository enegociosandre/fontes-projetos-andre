#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M030INC  � Autor � J.DONIZETE R.SILVA � Data �  29/01/04    ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada p/ para geracao automatica da Conta Conta-���
���          � bil do Cliente conforme inclusao do mesmo.                 ���
�������������������������������������������������������������������������͹��
���Uso       � Cadastro de Clientes                                       ���
�������������������������������������������������������������������������ͼ��
���Data      � Altera��es                                                 ���
���23/12/2006� - Adaptado do modelo desenvolvido pelo Vitor L.Fattori     ���
���          �                                                             ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/*
============================================================================
M030INC, Function
============================================================================
Cria��o   : Jan 29, 2004 - J.DONIZETE R.SILVA.
Nome      : M030INC
Tipo      : Function 
Descri��o : Ponto de Entrada p/ para geracao automatica da Conta Contabil
            do Clientes conforme inclusao do mesmo.
Retorno   : Nenhum.
Observ.   : Nenhuma
----------------------------------------------------------------------------
Data      : Altera��es
23/12/2006: Adaptado do modelo desenvolvido pelo Vitor L.Fattori
----------------------------------------------------------------------------*/   


User Function M030INC()

// Declara��o das Vari�veis.
Local _xAreaSA1		:= {}
Local _xAreaCT1		:= {}
Local _cCod			:= ""
Local _cEst			:= ""
Local _cConta		:= ""
Local _cContAd		:= ""
Local _a1_tipo		:= ""
Local _aIncCad  	:= {}
Local _lCria		:= .f. // Esta vari�vel define se ser� criado ou n�o conta anal�tica. A altera��o da mesma
Local _cCtaSint		:= ""
// � feita abaixo.
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.


// Processa somente se o m�dulo for SIGACTB e a op��o for de Inclus�o.
If INCLUI .and. Upper(Alltrim(GetMv("MV_MCONTAB"))) == "CTB" .And. Empty(SA1->A1_CONTA)
	
	dbSelectArea("SA1")
	_xAreaSA1 := GetArea()
	
	// Memoriza dados.
	_cCod		:= SA1->A1_COD+SA1->A1_LOJA
	_cEst		:= SA1->A1_EST
	_a1_tipo 	:= SA1->A1_TIPO
	_cConta  	:= ""
	_cCtaSint	:= ""
	
	If _cEst="EX" .and. _a1_tipo="X"
			_cCtaSint := "11201003"
			_lCria := .t.
	Else
			_cCtaSint := "11201001"
			_lCria := .t.
			
	Endif	
	
	If _lCria
		_cContAd	:= "21110001"
		_cConta := _cCtaSint + _cCod
		
		dbSelectArea("CT1")
		_xAreaCT1 := GetArea()
		dbSetOrder(1)
		DbSeek(xFilial("CT1") + _cConta)
		
		If .not. Found()           
	
			While !Reclock("CT1",.T.);Enddo
			CT1->CT1_FILIAL	:= Xfilial("CT1")
			CT1->CT1_CONTA  := _cConta
			CT1->CT1_DESC01	:= SA1->A1_NOME
			CT1->CT1_CLASSE := "2"
			CT1->CT1_NORMAL := "1"
			CT1->CT1_RES	:= _cCod
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
	DbSelectArea("SA1")
	If Reclock("SA1", .F.)
		REPLACE SA1->A1_CONTA	with _cConta 
		REPLACE SA1->A1_ZZCTAAD	with _cContAd
		MsUnlock()
	EndIf
	
	// Restaura �reas de trabalho.
	DbSelectArea("CT1")
	RestArea(_xAreaCT1)
	DbSelectArea("SA1")
	RestArea(_xAreaSA1)
	
Endif

Return
