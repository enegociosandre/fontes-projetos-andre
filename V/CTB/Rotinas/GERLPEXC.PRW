#Include "RWMAKE.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GERLPEXC  �Autor  �Donizete            � Data �  19/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este programa gera os LPs de exclus�o.                     ���
���          � Adaptado do RDMAKE disponibilizado pelo Martelli.          ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado padr�o do menu Miscel�nea.                         ���
�������������������������������������������������������������������������ͼ��
���Altera��es�06/10/04: - n�o estava gravando o hist�rico do cancelamento.���
���          �          - estava gravando arbitrariamente a origem e o    ���
���          �            sub-lote do lan�amento.                         ���
���          �          - altera��o de inicializadores padr�o do Alt.Orig.���
���          �            e SubLote para "S".                             ���
���          �26/05/05: - alterado para n�o excluir LPs especiais. Os Lps ���
���          �            especiais tem a descri��o iniciada por #.       ���
���          �                                                            ���
���          �01/06/06: - Dado tratamento para filial no CT5 dentro do    ���
���          �            while, pois o programa estava criando LPs sem   ���
���          �            checar a filial.                                ���
���          �                                                            ���
���          �29/12/06: - Dado tratamento para gerar LPs de exclus�o para ���
���          �            991, 992, 993.                                  ���
���          �                                                            ���
���          �11/08/07: - Altera��o para programa n�o criar LPs para LPs  ���
���          �            inativos.                                       ���
���          �                                                            ���
���          �31/08/07: - Acrescido tratamento para atualizar campo       ���
���          �ref.descri��o (CT5_ZZDESC).                                 ���
���          �          - Corre��o do c�digo do LP de exclus�o de apura-  ���
���          ���o de pis/cofins.                                          ���
���          �                                                            ���
���          �25/02/08: - corrigido erro ref. looping de tratamento do LP ���
���          �605;                                                        ���
���          �          - acrescentado tratamento para os LPs LPs citados ���
���          �pelo Wilton/SJC (640, 641, 642). Muito obrigado Wilton pela ���
���          �colabora��o.                                                ���
���          �          - para o tratamento acima o programa precisou ser ���
���          �reformulado e algumas perguntas foram exclu�das.            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function GERLPEXC()

// Defini��o das Vari�veis.
Private _cVersao	:= "4.01.27"
Private _cFilial	:= Space(2)
Private _cLPAtu		:= Space(TamSX3("CT5_LANPAD")[1])
Private _cSeqCT5	:= Space(TamSX3("CT5_SEQUEN")[1])
Private _cHist  	:= Space(TamSX3("CT5_HIST")[1])
Private _cDesc		:= Space(TamSX3("CT5_DESC")[1])
Private	_cDC		:= Space(TamSX3("CT5_DC")[1])
Private _cMoedas	:= Space(TamSX3("CT5_MOEDAS")[1])
Private _cCtaD		:= Space(TamSX3("CT5_DEBITO")[1])
Private _cCtaC		:= Space(TamSX3("CT5_CREDIT")[1])
Private _cCcD		:= Space(TamSX3("CT5_CCD")[1])
Private _cCcC		:= Space(TamSX3("CT5_CCC")[1])
Private _cItemD		:= Space(TamSX3("CT5_ITEMD")[1])
Private _cItemC		:= Space(TamSX3("CT5_ITEMC")[1])
Private _cClVrD		:= Space(TamSX3("CT5_CLVLDB")[1])
Private _cClVrC		:= Space(TamSX3("CT5_CLVLCR")[1])
Private _cVLR01		:= Space(TamSX3("CT5_VLR01")[1])
Private _cVLR02		:= Space(TamSX3("CT5_VLR02")[1])
Private _cVLR03		:= Space(TamSX3("CT5_VLR03")[1])
Private _cVLR04		:= Space(TamSX3("CT5_VLR04")[1])
Private _cVLR05		:= Space(TamSX3("CT5_VLR05")[1])
Private _cHAGLUT	:= Space(TamSX3("CT5_HIST")[1])
Private _cINTERC	:= Space(TamSX3("CT5_INTERC")[1])
Private _cATIVDE	:= Space(TamSX3("CT5_ATIVDE")[1])
Private _cATIVCR	:= Space(TamSX3("CT5_ATIVCR")[1])
Private _cTPSALD	:= Space(TamSX3("CT5_TPSALD")[1])
Private _cMOEDLC	:= Space(TamSX3("CT5_MOEDLC")[1])
Private _cSBLOTE	:= Space(TamSX3("CT5_SBLOTE")[1])
Private _cDTVENC	:= Space(TamSX3("CT5_DTVENC")[1])
Private _cSTATUS	:= Space(TamSX3("CT5_STATUS")[1])
Private _cExc		:= "EXCL.     "
Private _cCan		:= "CANC.     "
Private _cPad		:= Space(10)
Private _cMod		:= Alltrim(GetMV("MV_MCONTAB"))
Private _lAchou 	:= .F.
Private _nRecNo 	:= 0
Private _aCodExc	:= {}
Private _nPos		:= 0
Private _cAltOrig 	:= "S"
Private _cAltSbLote	:= "S"
Private _cSoRep 	:= "N"
Private _cCar		:= "0"
Private _nSeq655	:= 0
Private _nSeq665	:= 0

// Verifica se o m�dulo � o SIGACTB.
If _cMod <> "CTB"
	Alert("Este programa foi confecionado somente para SIGACTB!")
	Return
EndIf

// Solicita ao usu�rio nome do arquivo.
@ 150,  1 TO 400, 435 DIALOG oMyDlg TITLE OemToAnsi("Gera LP de Exc./Canc.- Vers�o "+_cVersao)
@   2, 10 TO 110, 210
@  10, 18 Say " Este programa gera os LPs de exclus�o."
@  30, 18 Say " Texto para cancelamento ?"
@  30,105 Get _cCan Picture "@!"
@  40, 18 Say " Texto para exclus�o ?"
@  40,105 Get _cExc Picture "@!"
@  50, 18 Say " Texto padr�o (textos anteriores s�o desconsiderados) ?"
@  50,160 Get _cPad Picture "@!"
@  60, 18 Say " * Origem=Cod./Seq (S/N) ?"
@  60,105 Get _cAltOrig Picture "@!" Valid Pertence("SN")
@  70, 18 Say " * Contabiliza por processo ?"
@  70,105 Get _cAltSbLote Picture "@!" Valid Pertence("SN")
@  80, 18 Say " Executar somente * ?"
@  80,105 Get _cSoRep Picture "@!" Valid Pertence("SN")
@ 110,150 BMPBUTTON TYPE 01 ACTION (Processa( {|| RunProc() } ), Close(oMyDlg))
@ 110,180 BMPBUTTON TYPE 02 ACTION Close(oMyDlg)
Activate Dialog oMyDlg Centered

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RUNPROC   �Autor  �Donizete            � Data �  19/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta os LPs de exclus�o com base nas informa��es forneci- ���
���          � das pelo usu�rio.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � GERLPEXC                                                  ���
�������������������������������������������������������������������������ͼ��
���          �                                                           ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunProc()

// Manuten��o de valores.
_cPad := Alltrim(_cPad)
_cExc := Alltrim(_cExc)
_cCan := Alltrim(_cCan)
_cAltOrig := Upper(_cAltOrig)
_cSbLote  := Upper(_cSbLote)
_cSoRep  := Upper(_cSoRep)

// Verifica se o sublote esta preenchido e apresenta mensagem ao usu�rio.
If !Empty(GetMv("MV_SUBLOTE")) .And. _cAltSbLote == "S"
	Alert("(GERLPEXC) Para contabilizar por processo o parametro MV_SUBLOTE deve estar em branco!")
EndIf

//Carrega tabela principal e define ordem.
dbSelectArea("CT5")
dbSetOrder(1)

//Define r�gua de processamento.
ProcRegua(LastRec())
dbGoTop()

// Processa se Usu�rio escolheu somente exclus�o dos LPs.
If CT5->CT5_LANPAD $ "502,505,507,509,512,514,515,519,527,529,531,535,540,554,557," + ;
	"558,564,565,568,571,578,581,584,586,588,589,591,592," + ;
	"593,606,630,635,655,656,657,665,711,721,751,805,806,807," + ;
	"808,814,815,816,817,822,825,836,955"
	While !Eof()
		
		IncProc("Excluindo LPs...")
		
		If SubStr(CT5->CT5_DESC,1,1)=="#"
			dbSkip()
			Loop
		Else
			If RecLock("CT5",.F.)
				dbDelete()
				MsUnlock()
				dbSkip()
				Loop
			EndIf
		EndIf
	EndDo
	dbGoTop()
EndIf

//Cria matriz com os LPs originais e respectivos LPs de exclus�o.
CriaMatriz()

//Cria os LPs de exclus�o.
While !Eof()
	
	// Atualiza campo de descri��o.
	If CT5->(FieldPos("CT5_ZZDESC")) > 0
		If Empty(CT5->CT5_ZZDESC)
			If RecLock("CT5",.F.)
				CT5->CT5_ZZDESC := CT5->CT5_DESC
				msunlock()
			EndIf
		EndIf
	EndIf
	
	// Verifica a filial.
	If CT5->CT5_FILIAL <> xFilial("CT5")
		dbSkip()
		Loop
	EndIf
	
	// Guarda posi��o do registro original e LP atual.
	_nRecNo := RecNo()
	_cLPAtu := CT5->CT5_LANPAD
	
	// Incrementa r�gua.
	IncProc("Criando LPs de exclus�o/cancelamento...")
	
	// Altera Origem.
	AltOrig()
	
	// Altera sublote.
	AltSbLote()
	
	// Processa somente os replaces (Origem e Sub-Lote).
	If _cSoRep == "S"
		dbSkip()
		Loop
	EndIf
	
	// Verifica se existe LP de exclus�o (_nPos > 0) na matriz.
	_nPos := Ascan(_aCodExc, {|aVal|aVal[1] == CT5->CT5_LANPAD})
	
	// N�o encontrado na matriz de exclus�o.
	If _nPos = 0
		dbSkip()
		Loop
	EndIf
	
	// Salva valores atuais do LP.
	_cFilial	:= CT5->CT5_FILIAL
	_cSeqCT5	:= CT5->CT5_SEQUEN
	If CT5->(FieldPos("CT5_STATUS")) > 0
		_cStatus	:= CT5->CT5_STATUS
	EndIF
	_cCtaD		:= CT5->CT5_DEBITO
	_cCtaC		:= CT5->CT5_CREDIT
	_cCcD 		:= CT5->CT5_CCD
	_cCcC 		:= CT5->CT5_CCC
	_cItemD		:= CT5->CT5_ITEMD
	_cItemC		:= CT5->CT5_ITEMC
	_cClVrD		:= CT5->CT5_CLVLDB
	_cClVrC		:= CT5->CT5_CLVLCR
	_cHist		:= CT5->CT5_HIST
	_cDesc		:= CT5->CT5_DESC
	_cDC		:= CT5->CT5_DC
	_cMoedas	:= CT5->CT5_MOEDAS
	_cVLR01 	:= CT5->CT5_VLR01
	_cVLR02 	:= CT5->CT5_VLR02
	_cVLR03 	:= CT5->CT5_VLR03
	_cVLR04 	:= CT5->CT5_VLR04
	_cVLR05 	:= CT5->CT5_VLR05
	_cHAGLUT	:= CT5->CT5_HAGLUT
	_cINTERC	:= CT5->CT5_INTERC
	_cATIVDE	:= CT5->CT5_ATIVCR
	_cATIVCR	:= CT5->CT5_ATIVDE
	_cTPSALD	:= CT5->CT5_TPSALD
	_cMOEDLC	:= CT5->CT5_MOEDLC
	_cSBLOTE	:= CT5->CT5_SBLOTE
	_cDTVENC	:= CT5->CT5_DTVENC
	
	// Verifica se o LP � do tipo 1=d�bito, 2=cr�dito ou 3=partida dobrada
	If !_cDC $ "123" // Pula p/processar pr�ximo LP.
		dbSkip()
		Loop
	Else
		If _cDC $ "12" // Inverte o tipo de LP.
			_cDC := Iif(_cDC=="1","2","1")
		EndIf
	EndIf
	
	// Tratamento para baixas do contas a receber/transfer�ncias p/carteira,
	// pois o LP de exclus�o � o mesmo.

	//            Baixas do contas a Receber     || Transfer�ncia entre carteiras||Canc.Border�
	If _cLpAtu $ "520,521,522,523,524,525,526,528||541,542,543,544,545,546,555   ||547,548,549,550,551,552,553,556"
		//            Idem||Idem||Idem
		If _cLpAtu $ "528 ||555 ||556"
			_cCar := "7"
		ElseIf _cLpAtu == "541" .And. CT5->CT5_SEQUEN=="001
			_cCar := "1H"
		Else
			_cCar := StrZero(Val(SubStr(_cLpAtu,2,2))-47,1) // C�lculo para se chegar as carteiras.
		EndIf
	EndIf

	If _aCodExc[_nPos][2] $ "527,540,554" .And. _cLpAtu <> "520"
		_cSeqCT5 := SubStr(_cCar,1,1) + SubStr(_cSeqCT5,2,2)
		If _aCodExc[_nPos][2] == "527"
				_cVLR01 := 'IF(SE5->E5_SITCOB$"' + _cCar + '",' + Alltrim(CT5->CT5_VLR01) + ",0)"
		ElseIf _aCodExc[_nPos][2] == "540"
				_cVLR01 := 'IF(SEA->EA_SITUACA$"' + _cCar + '",' + Alltrim(CT5->CT5_VLR01) + ",0)"
		ElseIf _aCodExc[_nPos][2] == "554"
				_cVLR01 := 'IF(STRLCTPAD$"' + _cCar + '",' + Alltrim(CT5->CT5_VLR01) + ",0)"
		EndIf
	Else
		_cSeqCT5 := CT5->CT5_SEQUEN
	EndIf
                 
	// Tratamento para o LP 640
	If _cLPAtu $ "640,650"
		_nSeq655 += 1
		_cSeqCT5 := StrZero(_nSeq655,3)
	EndIf
	
	// Tratamento para o LP 642
	If _cLPAtu $ "642,660"
		_nSeq665 += 1
		_cSeqCT5 := StrZero(_nSeq665,3)
	EndIf
	
	// Verifica se o LP de exclus�o j� existe.
	dbSeek(xFilial("CT5") + _aCodExc[_nPos][2] + _cSeqCT5)
	If Found()
		// Apaga o LP existente...
		If SubStr(CT5->CT5_DESC,1,1)<>"#"
			If RecLock("CT5",.F.)
				dbDelete()
				MsUnlock()
			EndIf
		Else
			// ... mant�m o LP atual e processa o pr�ximo.
			Go _nRecNo
			dbSkip()
			_cLPAtu := CT5->CT5_LANPAD
			Loop
		EndIF
	EndIF

	// Cria o novo LP
	If _cStatus<>"2"
		// Defini��o necess�ria para o LP 527
		If RecLock("CT5",.T.)
			CT5->CT5_FILIAL	:= _cFilial
			CT5->CT5_STATUS := "1"
			CT5->CT5_LANPAD	:= _aCodExc[_nPos][2]
			CT5->CT5_SEQUEN	:= _cSeqCT5
			CT5->CT5_DESC	:= If(!Empty(_cPad),_cPad+" ",Alltrim(_aCodExc[_nPos][3])) + " " + _cDesc
			CT5->CT5_DC		:= _cDC
			CT5->CT5_DEBITO	:= _cCtaC
			CT5->CT5_CREDIT	:= _cCtaD
			CT5->CT5_MOEDAS	:= _cMoedas
			CT5->CT5_VLR01	:= _cVLR01
			CT5->CT5_VLR02	:= _cVLR02
			CT5->CT5_VLR03	:= _cVLR03
			CT5->CT5_VLR04	:= _cVLR04
			CT5->CT5_VLR05	:= _cVLR05
			If !Empty(_cHist)
				CT5->CT5_HIST	:= '"' + If(!Empty(_cPad),_cPad+" ",Alltrim(_aCodExc[_nPos][3])) +  ' "+' + _cHist
			EndIf
			If !Empty(_cHAGLUT)
				CT5->CT5_HAGLUT	:= '"' + If(!Empty(_cPad),_cPad+" ",Alltrim(_aCodExc[_nPos][3])) + ' "+' + _cHAGLUT
			EndIf
			CT5->CT5_CCD	:= _cCcC
			CT5->CT5_CCC	:= _cCcD
			CT5->CT5_ORIGEM	:= Iif(_cAltOrig=="S",'"' + CT5->CT5_LANPAD + "/" + CT5->CT5_SEQUEN + '"',"") + '+"-"+Upper(SubStr(cUsuario,7,15))'
			CT5->CT5_INTERC	:= _cINTERC
			CT5->CT5_ITEMD	:= _cItemC
			CT5->CT5_ITEMC	:= _cItemD
			CT5->CT5_CLVLDB	:= _cClVrC
			CT5->CT5_CLVLCR	:= _cClvrD
			CT5->CT5_ATIVDE	:= _cATIVCR
			CT5->CT5_ATIVCR	:= _cATIVDE
			CT5->CT5_TPSALD	:= _cTPSALD
			CT5->CT5_MOEDLC	:= _cMOEDLC
			CT5->CT5_SBLOTE	:= Iif(_cAltSbLote=="S",CT5->CT5_LANPAD,"")
			CT5->CT5_DTVENC	:= _cDTVENC
			MsUnlock()
			
			// Altera Origem e sublote
			AltOrig()
			AltSbLote()
			
			// Pr�ximo registro.
			Go _nRecNo
			dbSkip()
			_cLPAtu := CT5->CT5_LANPAD
			Loop
		EndIf
	Else
		// Pr�ximo registro.
		Go _nRecNo
		dbSkip()
		_cLPAtu := CT5->CT5_LANPAD
		Loop
	EndIf
EndDo

// Mensagem final.
Alert("(GERLPEXC) Rotina executada com sucesso!")
Alert("(GERLPEXC) Caro analista, ainda n�o esta dispon�vel na documenta��o, acesse o fonte verificando " + ;
"quais LPs n�o s�o tratadas pelo programa ou observa��es sobre quais LPs de exclus�o devem sofrer " + ;
"manuten��o manual. Veja a fun��o 'CriaMatriz' para maiores detalhes.")

Return


Static Function CriaMatriz()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRIAMATRIZ    �Autor  �Donizete        � Data �  22/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria matriz com os LPs de exclus�o.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado pela fun��o RUNPROC.                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//FINANCEIRO.
Aadd(_aCodExc,{"500","505",_cExc})
Aadd(_aCodExc,{"501","502",_cExc})
Aadd(_aCodExc,{"504","529",_cExc})
Aadd(_aCodExc,{"506","507",_cExc})
Aadd(_aCodExc,{"508","509",_cExc})
Aadd(_aCodExc,{"510","515",_cExc})
Aadd(_aCodExc,{"511","512",_cExc}) // Editar o LP 512, trocar a vari�vel DEBITO por CREDITO. Trocar CUSTOD por CUSTOC.
Aadd(_aCodExc,{"513","514",_cExc})
Aadd(_aCodExc,{"577","578",_cExc})
Aadd(_aCodExc,{"541","540",_cCan}) //26/02/08
Aadd(_aCodExc,{"542","540",_cCan})
Aadd(_aCodExc,{"543","540",_cCan})
Aadd(_aCodExc,{"544","540",_cCan}) 
Aadd(_aCodExc,{"545","540",_cCan})
Aadd(_aCodExc,{"546","540",_cCan})
Aadd(_aCodExc,{"555","540",_cCan})
Aadd(_aCodExc,{"547","554",_cCan}) //26/02/08
Aadd(_aCodExc,{"548","554",_cCan})
Aadd(_aCodExc,{"549","554",_cCan})
Aadd(_aCodExc,{"550","554",_cCan})
Aadd(_aCodExc,{"551","554",_cCan})
Aadd(_aCodExc,{"552","554",_cCan})
Aadd(_aCodExc,{"553","554",_cCan})
Aadd(_aCodExc,{"556","554",_cCan})
Aadd(_aCodExc,{"520","527",_cCan})
Aadd(_aCodExc,{"521","527",_cCan})
Aadd(_aCodExc,{"522","527",_cCan})
Aadd(_aCodExc,{"523","527",_cCan})
Aadd(_aCodExc,{"524","527",_cCan})
Aadd(_aCodExc,{"525","527",_cCan})
Aadd(_aCodExc,{"526","527",_cCan})
Aadd(_aCodExc,{"528","527",_cCan})
Aadd(_aCodExc,{"518","519",_cCan})
Aadd(_aCodExc,{"530","531",_cCan})
//Aadd(_aCodExc,{"532","   ",_cExc}) Mesmo tratamento que o LP 531.
Aadd(_aCodExc,{"516","557",_cExc})
Aadd(_aCodExc,{"517","558",_cExc})
//Aadd(_aCodExc,{"560","   ",_cExc}) O pr�prio SIGA faz a revers�o do lan�amento.
//Aadd(_aCodExc,{"561","   ",_cExc}) O pr�prio SIGA faz a revers�o do lan�amento.
Aadd(_aCodExc,{"562","564",_cExc})
Aadd(_aCodExc,{"563","565",_cExc})
Aadd(_aCodExc,{"580","581",_cExc})
Aadd(_aCodExc,{"582","584",_cExc})
Aadd(_aCodExc,{"585","586",_cCan})
Aadd(_aCodExc,{"590","591",_cCan})
Aadd(_aCodExc,{"566","571",_cExc})
Aadd(_aCodExc,{"567","568",_cExc})
Aadd(_aCodExc,{"595","592",_cCan})
Aadd(_aCodExc,{"587","593",_cCan})
Aadd(_aCodExc,{"596","588",_cExc})
Aadd(_aCodExc,{"597","589",_cCan})
Aadd(_aCodExc,{"594","535",_cCan})

//COMPRAS.
Aadd(_aCodExc,{"640","655",_cExc}) //25/02/08
Aadd(_aCodExc,{"641","656",_cExc}) //25/02/08
Aadd(_aCodExc,{"642","665",_cExc}) //25/02/08
Aadd(_aCodExc,{"650","655",_cExc})
Aadd(_aCodExc,{"651","656",_cExc})
Aadd(_aCodExc,{"652","657",_cExc})
Aadd(_aCodExc,{"660","665",_cExc})
Aadd(_aCodExc,{"950","955",_cExc})

//FATURAMENTO.
Aadd(_aCodExc,{"610","630",_cExc})
Aadd(_aCodExc,{"620","635",_cExc})

//ATIVO FIXO.
Aadd(_aCodExc,{"801","805",_cExc})
Aadd(_aCodExc,{"802","806",_cExc})
Aadd(_aCodExc,{"803","807",_cExc})
Aadd(_aCodExc,{"804","808",_cExc})
Aadd(_aCodExc,{"810","814",_cExc})
Aadd(_aCodExc,{"811","815",_cExc})
Aadd(_aCodExc,{"812","816",_cExc})
Aadd(_aCodExc,{"813","817",_cExc})
Aadd(_aCodExc,{"821","822",_cExc})
Aadd(_aCodExc,{"820","825",_cCan})
Aadd(_aCodExc,{"835","836",_cCan})

// FISCAL
Aadd(_aCodExc,{"605","607",_cExc})
Aadd(_aCodExc,{"606","608",_cExc})
Aadd(_aCodExc,{"710","711",_cExc})
Aadd(_aCodExc,{"720","721",_cExc})
Aadd(_aCodExc,{"750","751",_cExc})

// EIC
Aadd(_aCodExc,{"991","995",_cExc})
Aadd(_aCodExc,{"992","996",_cExc})
Aadd(_aCodExc,{"993","997",_cExc})

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ALTORIG   �Autor  �Donizete            � Data �  29/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este programa tem a fun��o de alterar o campo CT5_ORIGEM   ���
���          � retornando para o campo o C�digo do LP + "/" + Seq��ncia.  ���
�������������������������������������������������������������������������͹��
���Uso       � RUNPROC                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AltOrig()

If RecLock("CT5",.F.)
	If _cAltOrig == "S"
		CT5->CT5_ORIGEM := '"' + CT5->CT5_LANPAD + "/" + CT5->CT5_SEQUEN + '"' + '+"-"+Upper(SubStr(cUsuario,7,15))'
	Else
		CT5->CT5_ORIGEM := ""
	EndIf
	Msunlock()
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ALTSBLOTE �Autor  �Donizete            � Data �  14/01/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este programa tem a fun��o de alterar o campo CT5_SBLOTE   ���
���          � com o conte�do do campo CT5_LANPAD.                        ���
�������������������������������������������������������������������������͹��
���Uso       � RUNPROC                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AltSbLote()

If RecLock("CT5",.F.)
	If _cAltSbLote=="S" .And. Empty(GETMV("MV_SUBLOTE"))
		CT5->CT5_SBLOTE := CT5->CT5_LANPAD
	Else
		CT5->CT5_SBLOTE := ""
	EndIf
	Msunlock()
EndIf

Return


/*
Function fA070Pad()
Local cPadrao:="520"
IF SE1->E1_SITUACA $ "0FG" .Or. Empty(SE1->E1_SITUACA)     //Carteira
	cPadrao := "520"
ELSEIF SE1->E1_SITUACA $ "1H"     //Simples
	cPadrao := "521"
ELSEIF SE1->E1_SITUACA = "2"     //Descontada
	cPadrao := "522"
ELSEIF SE1->E1_SITUACA = "3"     //Caucionada
	cPadrao := "523"
ELSEIF SE1->E1_SITUACA = "4"     //Vinculada
	cPadrao := "524"
ELSEIF SE1->E1_SITUACA = "5"     //Advogado
	cPadrao := "525"
ELSEIF SE1->E1_SITUACA = "6"     //Judicial
	cPadrao := "526"
ELSEIF SE1->E1_SITUACA = "7"     //Caucao Descontada
	cPadrao := "528"
EndIF
Return cPadrao


TRANSF.

TRANSF.TODOS PARA CARTEIRA
If cSituant != SE1->E1_SITUACA .and. mv_par03 == 1 // contabiliza transferencias
		IF cSituacao $ "0FG" 		//Carteira, Carteira Protesto e Carteira Acordo
			cPadrao:="540"
		ElseIf cSituacao $ "1H"		//Simples e Cartorio
			cPadrao:="541"
		ElseIf cSituacao == "2"		//Descontada
			cPadrao:="542"
		ElseIf cSituacao == "3"		//Caucionada
			cPadrao:="543"
		ElseIf cSituacao == "4"		//Vinculada
			cPadrao:="544"
		ElseIf cSituacao == "5"		//Advogado
			cPadrao:="545"
		ElseIf cSituacao == "6"		//Judicial
			cPadrao:="546"
		ElseIf cSituacao == "7"		//Caucionada Descontada
			cPadrao:="555"

BORDERO??
Function fA060Pad(cSituacao)

Local cPadrao := Space(3)

BORDER�S
IF cSituacao $ "0FG"         //Carteira, Carteira Protesto e Carteira Acordo
	cPadrao := "547"
ELSEIF cSituacao $ "1H"     //Simples, Cartorio
	cPadrao := "548"
ELSEIF cSituacao = "2"     //Descontada
	cPadrao := "549"
ELSEIF cSituacao = "3"     //Caucionada
	cPadrao := "550"
ELSEIF cSituacao = "4"     //Vinculada
	cPadrao := "551"
ELSEIF cSituacao = "5"     //Advogado
	cPadrao := "552"
ELSEIF cSituacao = "6"     //Judicial
	cPadrao := "553"
ELSEIF cSituacao = "7"     //Caucionada Descontada
	cPadrao := "556"
EndIF

Return cPadrao

*/