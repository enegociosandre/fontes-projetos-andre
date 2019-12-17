#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���RDMAKE    �SCRFIS    �Autor  �Microsiga Software S/A� Data �           ���
�������������������������������������������������������������������������͹��
���Desc.     � Faz a impressao do cupom fiscal                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGALOJA                                                   ���
�������������������������������������������������������������������������͹��
���  DATA    � BOPS �Program.� ALTERACAO                                  ���
���  MANUT.  � FNC  �        � 											  ���
�������������������������������������������������������������������������͹��
���18/10/2005�003272�Machima �Acrescentar o numero do PDV na numeracao do ���
���          �2005  �        �cupom fiscal(Argentina) quando utiliza ECF  ���
���          �		�        �Emulator									  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ScrFis()

Local cAcrescimo, aTotForm, sFormaPagto, aFormPag, acReceb

Local _nPosProd   := aPosicoes[ 9][2]
Local _nPosQuant  := aPosicoes[11][2]
Local _nPosValIpi := aPosicoes[ 7][2]
Local _nPosDesU   := aPosicoes[ 3][2]
Local _nPosTes	  := aPosicoes[ 5][2]
Local _nPosTotIt  := aPosicoes[ 2][2]
Local _cCodProd   := ""
Local _cDescProd  := ""
Local _cQuant	  := ""
Local _cUnit	  := ""
Local _cTotIt	  := "" 	
Local _cDesconto  := ""
Local _cElemen	  := ""
Local _nPerRet	  := 0
Local _nDescLoj   := ParamIxb[1]
Local _nTroco     := ParamIxb[10]
Local _nCredito   := ParamIxb[12]
Local _Vinculado  := ParamIxb[13]
Local _nDescFin   := ParamIxb[14]
Local _nI		  := 0
Local _lFound     := .F.
Local _nOldOrder  := _nOldRecno := 0
Local lLj220Reg	  := ExistBlock("LJ220REG")
Local iRetorno    := 0
Local cRetorno	  := ' '
Local nTrocoAux   := _nTroco
Local _nVlrTot    := 0
Local nVlrAcrDesc := 0
Local nLoopParc   := 0
Local nX          := 0
Local cFormRet    := GetPvProfString("Condicao de Pagamento", "Retencoes", "RETENCOES", GetClientDir()+"SIGALOJA.INI")
Local nRestDiv    := 0
Local lPCCRet     := FindFunction("LJPCCRet")
Local _cUnidMed   := " "
Local nValRet     := 0
Local nTamCupom   := TamSx3("L1_NUMCFIS")[1]      //Quantidade de digitos do numero do cupom 
Local lFirst      := .T.                          //Controla se eh a primeira chamada da impressao(Argentina)

//���������������������������������������������������������������������Ŀ
//� Verifica se a data do sistema eh a mesma data da impressora fiscal. �
//�����������������������������������������������������������������������
If ! CheckIFData()
	Return (.F.)
EndIf

If !File( GetClientDir()+"SIGALOJA.INI" )
	WritePProString("Condicao de Pagamento", "Retencoes", "RETENCOES", GetClientDir()+"SIGALOJA.INI")
EndIf

//����������������������������������������������������������������������Ŀ
//�Imprime o cupom fiscal apenas na primeira chamada da rotina(Argentina)�
//������������������������������������������������������������������������
If cPaisLoc == "ARG"
   lFirst  := (ParamIxb[15] == 1)
   If !lFirst
      Return (.T.)
   Endif
Endif

//��������������������������������������������������������������������Ŀ
//�se exitir cupom aberto, faz o cancelamento e abre um novo.          �
//����������������������������������������������������������������������
iRet := IFStatus( nHdlECF, '5', @cRetorno )
If iRet = 7
	iRet := IFCancCup( nHdlECF )
	If L010AskImp(.F.,iRet)
		Return (.F.)
	EndIf
	Inkey(8)   // d� um tempo para a impressora fazer a impressao do cancelamento
Else
	If L010AskImp(.F.,iRet)
		Return (.F.)
	EndIf
Endif

//�������������������������������������Ŀ
//� Abre o cupom fiscal                 �
//���������������������������������������
iRetorno := IFAbreCup(nHdlECF)
If L010AskImp(.F.,iRetorno)
	Return (.F.)
EndIf
If iRetorno <> 0
	Return (.F.)
Endif

//�������������������������������������Ŀ
//� Tenta pegar o n�mero do cupom       �
//���������������������������������������
cNumCupFis := Space(6)
iRetorno := IFPegCupom( nHdlECF, @cNumCupFis)
If L010AskImp(.F.,iRetorno)
	Return (.F.)
EndIf
cNumCupFis := StrZero(Val(cNumCupFis),nTamCupom,0)
cNumNota := cNumCupFis

//�������������������������������������Ŀ
//� Tenta pegar o n�mero do PDV         �
//���������������������������������������
cNumPdv  := Space(6)
iRetorno := IFPegPDV(nHdlECF, @cNumPdv)
If L010AskImp(.F.,iRetorno)
	Return (.F.)
EndIf

//����������������������������������������������������������������������������������������Ŀ
//�O numero do documento fiscal eh composto por Numero PDV + Numero Cupom Fiscal(Argentina)�
//������������������������������������������������������������������������������������������
If cPaisLoc == "ARG"
   cNumCupFis := cNumPdv + Substr( cNumCupFis,1+LEN(cNumPdv),LEN(cNumCupFis)-LEN(cNumPdv) )	   
   cNumNota   := cNumCupFis
Endif

//Para utilizar o conceito de cliente entrega
If !Empty( SL1->L1_CLIENT) .AND. !Empty( SL1->L1_LOJENT )
	SA1->(dbSetOrder( 1 ))
	SA1->(MsSeek( xFilial( "SA1" ) + SL1->L1_CLIENT + SL1->L1_LOJENT) )
EndIf


dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SB0")
dbSetOrder(1)

dbSelectArea("SF4")
dbSetOrder(1)

For _nI := 1 To Len(aCols)		// Imprime os itens
	If !(aCols[_nI][nUsado+1] )

		SB1->( MsSeek( xFilial("SB1") + aCols[_nI][_nPosProd]) )
		SB0->( MsSeek( xFilial("SB0") + aCols[_nI][_nPosProd]) )
		SF4->( MsSeek( xFilial("SF4") + aCols[_nI][_nPosTes] ) )
		
		If lLj220Reg
			_cElemen := ExecBlock("LJ220REG",.F.,.F.)
			
		ElseIf SF4->F4_ISS == "S" .AND. ( ( ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) ) .OR. ( SA1->A1_RECISS <> "1" ) ) )
    		_cElemen := 'S' + AllTrim (Str( Iif(SB1->B1_ALIQISS>0,SB1->B1_ALIQISS,GetMv("MV_ALIQISS")),5,2 ))
			
		ElseIf (SB1->B1_PICMRET > 0 .OR. SB1->B1_PICMENT > 0) .AND. SA1->A1_TIPO $ GetNewPar("MV_TPSOLCF","S,F")
			_cElemen := "F"                   // Substituicao tributaria (Icms Solidario)
			
		ElseIf SF4->F4_BASEICM > 0 .AND. SF4->F4_BASEICM < 100
			_cElemen := 'T' + Alltrim(Str( SB0->B0_ALIQRED,5,2 ))		  // com reducao de Icms na Base
			
		ElseIf SF4->F4_LFICM == "I"
			_cElemen := "I"                   // Isento
			
		ElseIf SF4->F4_LFICM == "N"
			_cElemen := "N"                   // N�o sujeito a ICMS
			
		Else
			_nPerRet := lj010VerIcm(_nI) 	     // Com ICMS
			_cElemen	:= 'T' + Alltrim(Str(_nPerRet,5,2))
			
		EndIf
		If GetMV("MV_CODBAR") == "S"  .AND. !Empty(SB1->B1_CODBAR)
			_cCodProd  := Substr(SB1->B1_CODBAR,1,13)
		Else
        	_cCodProd  := aCols[_nI][_nPosProd]
		EndIF        	
		_cDescProd := SB1->B1_DESC
		_cQuant    := StrZero(aCols[_nI][_nPosQuant],TamSX3("L2_QUANT")[1],TamSX3("L2_QUANT")[2])
		_cUnidMed  := SB1->B1_UM
		If cPaisLoc == "BRA"
			_cUnit     := Str((aCols[_nI][_nPosTotIt]+ aCols[_nI][_nPosDesU]+aCols[_nI][_nPosValIpi])/aCols[_nI][_nPosQuant],TamSx3("L2_VRUNIT")[1],nDecimais)
			_cTotIt    := Str((aCols[_nI][_nPosTotIt]+ aCols[_nI][_nPosDesU]+ aCols[_nI][_nPosValIpi]),TamSx3("L2_VLRITEM")[1],nDecimais)			
		
		//������������������������������������������������������������������������Ŀ
		//�Segundo a legislacao o cliente quando estiver configurado como solidario�
		//�A1_TIPO = 'S' dever� sempre ser tributado, independente da configuracao �
		//�do TES.                                                                 �
		//��������������������������������������������������������������������������
		If (SA1->A1_TIPO $ GetMV("MV_TPSOLCF") .OR. ( SA1->A1_TIPO == "S" )) .AND. (SF4->F4_INCSOL <> "N")
				aIcmsSol := LjIcmsSol(Val(_cUnit)*aCols[_nI][_nPosQuant],aCols[_nI][_nPosQuant],Val(_cUnit))
				_cUnit   := Str(Val(_cUnit) + (aIcmsSol[2]/Val(_cQuant)),TamSx3("L2_VRUNIT")[1],TamSx3("L2_VRUNIT")[2])
				_cTotIt  := Str(Val(_cUnit) * Val(_cQuant),TamSx3("L2_VLRITEM")[1],nDecimais)
			EndIf
		Else
			_cUnit     := Str((aCols[_nI][_nPosTotIt]+ aCols[_nI][_nPosDesU])/aCols[_nI][_nPosQuant],TamSx3("L2_VRUNIT")[1],nDecimais)
			_cTotIt    := Str((aCols[_nI][_nPosTotIt]+ aCols[_nI][_nPosDesU]),TamSx3("L2_VLRITEM")[1],nDecimais)
			_nVlrTot   += aCols[_nI][_nPosTotIt]
			_cUnit     := Str(Val(_cUnit),TamSx3("L2_VRUNIT")[1],TamSx3("L2_VRUNIT")[2])			
		Endif					
		_cDesconto := Str(aCols[_nI][_nPosDesU],8,2)
		
		iRetorno := IFRegItem( nHdlECF,_cCodProd,_cDescProd,_cQuant,_cUnit,_cDesconto,_cElemen,_cTotIt, _cUnidMed)
		If L010AskImp(.F.,iRetorno)
			Return (.F.)
		EndIf
	EndIf
Next _nI

//Retorno da posicao do cliente
If !Empty( SL1->L1_CLIENT) .AND. !Empty( SL1->L1_LOJENT )
	SA1->(dbSetOrder( 1 ))
	SA1->(MsSeek( xFilial( "SA1" ) + SL1->L1_CLIENTE + SL1->L1_LOJA) )
EndIf

//�������������������������������������Ŀ
//� Verifica o Desconto e o Acrescimo   �
//���������������������������������������
nVlrAcrDesc := nVlrAcrs - (_nDescloj + _nDescFin)
If nVlrAcrDesc > 0
	cAcrescimo := Alltrim(Str(nVlrAcrDesc,14,2))
	iRetorno := IFAcresTot( nHdlECF, cAcrescimo )
	If L010AskImp(.F.,iRetorno)
		Return (.F.)
	EndIf
ElseIf nVlrAcrDesc < 0
    _cDescTotal := Alltrim(Str( Abs(nVlrAcrDesc), 14, 2 ))
	iRetorno := IFDescTot( nHdlECF,_cDescTotal )
	If L010AskImp(.F.,iRetorno)
		Return (.F.)
	EndIf
Endif

//�����������������������������������������������������������������Ŀ
//�Verifica se existe o ponto de entrada para montar a string com   �
//�as formas de pagamento.                                          �
//�O sistema vai verificar o parametro MV_LJPAGTO para verificar    �
//�qual a forma de pagamento sera registrada no ECF. O cliente      �
//�podera utilizar a descricao da tabela 24 do SX5 ou a descricao   �
//�cadastrada no arquivo de administradoras (SAE).                  �
//�������������������������������������������������������������������
If ExistBlock('LJ220PAG')
	sFormaPagto := ExecBlock('LJ220PAG')
Else
	
	//�����������������������������������������������������������������Ŀ
	//�Verifica quais as formas de pagamento est�o registradas no ECF   �
	//�������������������������������������������������������������������
	MonFormPag( @aFormPag )
	//Caso o pais seja diferente de Brasil � necess�rio incluir todas as moedas      
	If cPaisLoc <> "BRA"
		For _nI := 2 To MoedFin()
			SX5->(MsSeek(xFilial()+"24"+GetMv("MV_SIMB"+Str(_nI,1))))
			AAdd(aFormPag, {AllTrim(X5Descri()), GetMv("MV_SIMB"+Str(_nI,1)), AllTrim(X5Descri()) })
		Next _nI
	EndIf                    
	aTotForm := Array(Len(aFormPag))
	AFill(aTotForm, 0)

	acReceb:= aClone(aReceb)
	nLoopParc := Len(acReceb)
	
	//Reajuste dos valores de Pis/COFInS nas parcelas
	If lPCCRet .AND. ( LJPCCRet() + iIf( ! lpTPAbISS, 0, npValISS ) ) > 0 .AND. ;
	   ( nLoopParc <> 1 .OR. ( nLoopParc == 1 .AND. acReceb[1][2] > 0 ) )
		
		For nX := 1 to nLoopParc
			acReceb[nX][2] -= NoRound((( LJPCCRet() + iIf( ! lpTPAbISS, 0, npValISS ) ) / nLoopParc ),nDecimais)
			nRestDiv += NoRound((( LJPCCRet() + iIf( ! lpTPAbISS, 0, npValISS ) ) / nLoopParc ),nDecimais)
		Next nX
		           
		If nRestDiv < ( LJPCCRet() + iIf( ! lpTPAbISS, 0, npValISS ) )
			acReceb[nLoopParc][2] -= ( LJPCCRet() + iIf( ! lpTPAbISS, 0, npValISS ) ) - nRestDiv
		EndIf
	EndIf
	
	If _nCredito > 0
		AADD(acReceb,{dDataBase,_nCredito,"CR",,,,,,,.F.,1})
	Endif
	
	For _nI := 1 To Len(acReceb)
		//���������������������������������������������������������������Ŀ
		//�O parametro MV_LJPAGTO retorna um valor inteiro. Pode ser      �
		//�1 que ir� indicar que a descri��o da forma de pagto ser� a da  �
		//�tabela 24 do SX5 ou 2, que ser� do cadastro de administradoras �
		//�(SAE).                                                         �
		//�����������������������������������������������������������������
		If IsMoney(acReceb[_nI][3]) .OR. (Alltrim(acReceb[_nI][3]) $ 'CH,CR') .OR. GetMV("MV_LJPAGTO")==1
			nPos := AScan(aFormPag, {|x| Upper(x[2])==Upper(Alltrim(acReceb[_nI][3]))})
		Else
			nPos := AScan(aFormPag, {|x| Upper(x[1])==Upper(Alltrim(Subst(acReceb[_nI][4],7,30)))})
		Endif
		
		if Alltrim(acReceb[_nI][3]) $ GetMv('MV_SIMB1')+',VA'
			aTotForm[nPos] += acReceb[_nI][2] + nTrocoAux
			nTrocoAux := 0
		else
			aTotForm[nPos] += acReceb[_nI][2]
		Endif
		
	Next _nI
	//�������������������������������������������������������Ŀ
	//�Registra o pagamento da venda                          �
	//���������������������������������������������������������
	sFormaPagto := ''
	For _nI := 1 to Len(aFormPag)
		If aTotForm[_nI] > 0
			sFormaPagto := sFormaPagto + aFormPag[_nI][IIF(GetMV("MV_LJPAGTO")==1,3,1)] + '|' + Alltrim(Str(aTotForm[_nI],14,nDecimais)) + '|'
		Endif
	Next _nI
	
	nValRet := 0
	
	If lPCCRet .AND. LJPCCRet() > 0
		nValRet += LJPCCRet()
	EndIf

	If npValISS > 0
		nValRet += npValISS
	EndIf
	
	If nValRet > 0
		sFormaPagto := sFormaPagto + cFormRet + '|' + ;
		               Alltrim(Str(nValRet, 14, nDecimais)) + '|'
	EndIf
	
Endif

If cPaisLoc <> "BRA"
	_nVlrTot += nValTotIV
Endif

iRet := IFPagto( nHdlECF, sFormaPagto, _Vinculado, _nVlrTot ) //	Efetua a impressao do Item
If L010AskImp(.F.,iRet)
	Return (.F.)
EndIf

cOrcam	 := "Orcamento: " + SL1->L1_NUM + " "
cMensagem := AllTrim(GetMV("MV_LJFISMS"))
If Empty(cMensagem)
   If SLG->(FieldPos("LG_MSGCUP"))>0
      cMensagem := Rtrim(SLG->LG_MSGCUP)
   EndIf   
EndIf 

cString:= cOrcam + cMensagem

// Guarda o n�mero do cupom que foi aberto
cOldCupFis := cNumCupFis
//�������������������������������������������������Ŀ
//� Fecha o cupom e imprime a mensagem promocional  �
//���������������������������������������������������
iRetorno := IFFechaCup( nHdlECF,cString )	//	Fecha Cupom
If L010AskImp(.F.,iRetorno)
	Return (.F.)
EndIf

//�������������������������������������������������Ŀ
//� Pega o numero do proximo cupom 				    �
//���������������������������������������������������
iRetorno := 0
cNumCupFis := Replicate("0",nTamCupom)
While (Val(cNumCupFis) = 0) .AND. (iRetorno <> 1)
	iRetorno := IFPegCupom(nHdlECF, @cNumCupFis)
	If L010AskImp(.F.,iRetorno)
		If Aviso("Problemas com a impressora fiscal", "O cupom fiscal foi impresso/finalizado corretamente?", {"Sim","N�o"}) == 1
			IFCancCup(nHdlECF)
			Aviso("Efetuado o cancelamento do cupom", "O cupom fiscal foi cancelado pois houve erro no processo.", {"Ok"})
		EndIf
		Return (.F.)
	EndIf
	cNumCupFis := StrZero(Val(cNumCupFis),TamSx3("L1_NUMCFIS")[1],0)
End

//����������������������������������������������������������������������������������������Ŀ
//�O numero do documento fiscal eh composto por Numero PDV + Numero Cupom Fiscal(Argentina)�
//������������������������������������������������������������������������������������������
If cPaisLoc == "ARG"
   cNumCupFis := cNumPdv + Substr( cNumCupFis,1+LEN(cNumPdv),LEN(cNumCupFis)-LEN(cNumPdv) )	   
Endif

// Procura o cupom a ser gravado na base
_nOldOrder := SL1->(IndexOrd())
_nOldRecno := SL1->(Recno())
SL1->(DbSetOrder(2))

_lFound := SL1->(MsSeek(xFilial("SL1")+cSerie+cNumCupFis+cNumPdv))
SL1->(DbSetOrder(_nOldOrder)) 
SL1->(DbGoto(_nOldRecno))

// Faz Consist�ncia do cupom
If !(cOldCupFis == cNumCupFis) .OR. _lFound
	If Aviso("Problemas com a impressora fiscal", "O cupom fiscal foi impresso/finalizado corretamente?", {"Sim","N�o"}) == 1
		IFCancCup(nHdlECF)
		Aviso("Efetuado o cancelamento do cupom", "O cupom fiscal foi cancelado pois houve erro no processo.", {"Ok"})
	EndIf
	Return(.F.)
Else
	Return(.T.)
Endif

Return
