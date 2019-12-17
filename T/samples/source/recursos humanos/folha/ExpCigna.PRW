#INCLUDE "rwmake.ch"
//#INCLUDE "expcigna.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXPCIGNA  � Autor � Kleber D. Gomes    � Data �  26/06/00   ���
�������������������������������������������������������������������������͹��
���Descricao � Exportacao CIGNA.                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 IDE                                                    ���
�������������������������������������������������������������������������͹��
���Programador � Data	� BOPS �  Motivo da Alteracao 					  ���
�������������������������������������������������������������������������Ĵ��
���Pedro Eloy  �20/05/04�069438�Foi tratado o dbSelectArea(), pois quando ���
���            �        �      �esta abrindo com arquivo TMP ele esta sem ���
���            �        �      �ordem a ser aberta.                       ���
���            �22/09/04�Q02834�Inclusao da FGetPath (valid SX1 )         ���
���            �28/09/04�------�Trata FGetPath qdo chamado ImpCigna		  ���
���            �28/09/04�------�Retorna ao Menu principal final processo  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ExpCigna()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private _cString := "SRA"
Private _cPerg   := "EXPCIG"
Private _oGeraTxt

Pergunte(_cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,450 DIALOG _oGeraTxt TITLE OemToAnsi("Geracao de Arquivo Exportacao Cigna")
@ 02,10 TO 060,215
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parametros definidos "    SIZE 196,0
@ 18,018 Say " pelo usuario, com  os  registros  do  arquivo temporario,  criado  com  regis-" SIZE 196,0
@ 26,018 Say " tros do arquivo SRA."                                                           SIZE 196,0

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 01 ACTION OkGeraTrb(_oGeraTxt )
@ 70,188 BMPBUTTON TYPE 02 ACTION Close(_oGeraTxt)

Activate Dialog _oGeraTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATRB� Autor � AP5 IDE            � Data �  26/06/00   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkGeraTrb(_oGeraTxt ) 

Local 	_cEFilMat := ""
Local   _cChave	  := ""
Local   _cCc	  := ""
Local	_aRecTrf  := {}
Local 	_cFilialD := ""
Local	_cMatD	  := ""
Local	_cInicio  := ""
Local   _cFim	  := ""
Local   _cAlias   := ""

//������������������������������������������������������������������Ŀ
//� Variaveis utilizadas na pergunte                                 �
//� mv_par01	// Filial de                                         �
//� mv_par02	// Filial ate                                        �
//� mv_par03	// Data de referencia                                �
//� mv_par04	// Tipo de geracao(Carga Inicial\Atualizacao)        �
//� mv_par05	// Path destino geracao                              �
//��������������������������������������������������������������������
Local _cFilDe := mv_par01
Local _cFilAte:= mv_par02
Local _dDatRef:= mv_par03
Local _nTipGer:= mv_par04
Local _cPath  := Substr(mv_par05,1,Rat("\",mv_par05))
Local _byOrd  := 0

Private _cFile   := _cPath+"FURM"+Soma1(GetMV("MV_NUMFURM"),4)
Private _cFileDbf := RetArq(__LocalDriver,(_cFile+GetDBExtension()),.T.)

//���������������������������������������������������������������������Ŀ
//� Cria o arquivo texto                                                �
//�����������������������������������������������������������������������
Private _nHdl    := fCreate(_cFile+".TXT")

Private _cEOL    := "CHR(13)+CHR(10)"
If Empty(_cEOL)
	_cEOL := CHR(13)+CHR(10)
Else
	_cEOL := Trim(_cEOL)
	_cEOL := &_cEOL
Endif

If _nHdl == -1
	MsgAlert("O arquivo "+_cFile+".TXT"+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Else
	//��������������������������������������������������������������Ŀ
	//� Grava a Numero da sequencia do arquivo texto.                �
	//� Utilize sempre GetMv para posicionar o SX6. N�o use SEEK !!! �
	//����������������������������������������������������������������
	_cAlias := Alias()
	_byOrd	:= IndexOrd()
	dbSelectArea("SX6")
	GetMV("MV_NUMFURM")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := Soma1(GetMV("MV_NUMFURM"),4)
	MSUnlock()
	dbSelectArea(_cAlias)
	If _byOrd>0
		dbSetOrder(_byOrd)
	Endif
Endif

//���������������������������������������������������������������������Ŀ
//� Cria o arquivo dbf                                                  �
//�����������������������������������������������������������������������
Cria_TRB()

dbSelectArea("SRA")
dbSetOrder(1)
dbGoTop()
dbSeek(_cFilDe , .T.)
_cInicio := "SRA->RA_FILIAL"
_cFim    := _cFilAte

While !Eof() .And. &_cInicio <= _cFim
	If (SRA->RA_SITFOLH == "D" .And. SRA->RA_RESCRAI == "31") .Or.;
		(SRA->RA_SITFOLH == "D" .And. Mesano(SRA->RA_DEMISSA) < MesAno(CtoD("01"+"/"+StrZero(Month(_dDatRef)-1,2)+"/"+Str(Year(_dDatRef),4))))
		dbSkip()
		Loop
	Endif
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	If SRA->RA_SITFOLH == "D" .And. SRA->RA_RESCRAI # "31"
		Replace TRB->TIPODADO 	With  "DM"
	ElseIf SRA->RA_SITFOLH == "F"
		Replace TRB->TIPODADO 	With  "FE"
	Else
		Replace TRB->TIPODADO 	With  "FU"
	EndIf
	If _nTipGer # 1 .And. MesAno(SRA->RA_ADMISSA) >= MesAno(CtoD("01"+"/"+StrZero(Month(_dDatRef)-1,2)+"/"+Str(Year(_dDatRef),4)))
		Replace TRB->CODACAO  With  "UP"
	Else
		Replace TRB->CODACAO  With  "NW"
	EndIf
	Replace TRB->FILIAL		With  SRA->RA_FILIAL
	Replace TRB->MAT		With  SRA->RA_MAT
	Replace TRB->NOME		With  SRA->RA_NOME
	Replace TRB->CC			With  SRA->RA_CC
	Replace TRB->CODFUNC	With  SRA->RA_CODFUNC
	Replace TRB->SEXO		With  SRA->RA_SEXO
	Replace TRB->NASC		With  SRA->RA_NASC
	Replace TRB->CIC		With  SRA->RA_CIC
	Replace TRB->ADMISSA	With  SRA->RA_ADMISSA
	Replace TRB->ESTCIVI	With  SRA->RA_ESTCIVI
	Replace TRB->ENDEREC	With  SRA->RA_ENDEREC
	Replace TRB->COMPLEM	With  SRA->RA_COMPLEM
	Replace TRB->BAIRRO		With  SRA->RA_BAIRRO
	Replace TRB->MUNICIP	With  SRA->RA_MUNICIP
	Replace TRB->CEP		With  SRA->RA_CEP
	Replace TRB->UFCP  	    With  SRA->RA_UFCP
	Replace TRB->TELEFON	With  SRA->RA_TELEFON
	Replace TRB->EMAIL		With  SRA->RA_EMAIL
	If SRA->RA_SITFOLH == "D" .And. SRA->RA_RESCRAI # "31"
		Replace TRB->DEMISSA	With  SRA->RA_DEMISSA
		Replace TRB->AFASFGT	With  SRA->RA_AFASFGT

	ElseIf SRA->RA_SITFOLH == "F"
		dbSelectArea("SRH")
		dbSetOrder(1)
		If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
			Replace TRB->DATAINI	With  SRH->RH_DATAINI
			Replace TRB->DATAFIM	With  SRH->RH_DATAFIM
		EndIf
	EndIf
	dbSelectArea("TRB")
	If _nTipGer # 1
		_cChave := SRA->RA_FILIAL+SRA->RA_MAT
		//��������������������������������������������������������������Ŀ
		//� Seleciona o Arquivo de Transferencias                        �
		//����������������������������������������������������������������
		dbSelectArea("SRE")
		dbSetOrder(2)
		If dbSeek(cEmpAnt+_cChave)
			_cEFilMat := cEmpAnt+_cChave
			_cCc      := SRA->RA_CC
			While ! EOF() .And. SRE->RE_EMPP+SRE->RE_FILIALP+SRE->RE_MATP == _cEFilMat
				If SRE->RE_CCP == _cCc
					If Ascan(_aRecTrf,SRE->(RECNO())) > 0
						dbSkip()
						Loop
					Else
						Aadd(_aRecTrf,SRE->(RECNO()))
					Endif
				EndIf
				If(SRE->RE_EMPP+SRE->RE_FILIALP+SRE->RE_MATP+SRE->RE_CCP==_cEFilMat+_cCc)
					_cEFilMat := SRE->RE_EMPD + SRE->RE_FILIALD + SRE->RE_MATD
					_cCc      := SRE->RE_CCD
					If SRE->RE_EMPP + SRE->RE_FILIALP + SRE->RE_MATP # _cEFilMat
						If MesAno(SRE->RE_DATA) >= MesAno(CtoD("01"+"/"+StrZero(Month(_dDatRef)-1,2)+"/"+Str(Year(_dDatRef),4)))
							If SRE->RE_EMPD == SRE->RE_EMPP
								_cFilialD := SRE->RE_FILIALD
								_cMatD	  := SRE->RE_MATD
							EndIf
						EndIf
					EndIf
					dbSeek(_cEFilMat)
				Else
					dbSkip()
				EndIf
			EndDo
			If _cFilialD+_cMatD # "" .And. _cFilialD+_cMatD # SRA->RA_FILIAL+SRA->RA_MAT
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				Replace TRB->TIPODADO	With  "TR"
				Replace TRB->CODACAO	With  "NW"
				Replace TRB->FILIAL		With  SRA->RA_FILIAL
				Replace TRB->MAT		With  SRA->RA_MAT
				Replace TRB->CC			With  SRA->RA_CC
				Replace	TRB->CODFUNC	With  SRA->RA_CODFUNC
				Replace TRB->FILIALD	With  _cFilialD
				Replace TRB->MATD		With  _cMatD
				MsUnlock()
			EndIf
		EndIf
	EndIf
	dbSelectArea("SRA")
	dbSkip()
EndDo

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont(_dDatRef) },"Processando...")
Close(_oGeraTxt)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  26/06/00   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont(_dDatRef)

Local _nTamLin, _cLin, _cCpo
Local _cRazao := ""
Local _cFilialAnt := "!!"
Local _aInfo := {}

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� programa.  Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������

dbSelectArea("TRB")
dbGoTop()

ProcRegua(RecCount()) // Numero de registros a processar

_nTamLin := 23
_cLin    := Space(_nTamLin)+_cEOL // Variavel para criacao da linha do registros para gravacao

//���������������������������������������������������������������������Ŀ
//� Substitui nas respectivas posicioes na variavel cLin pelo conteudo  �
//� dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     �
//� string dentro de outra string.                                      �
//�����������������������������������������������������������������������
_cCpo := "H"+"00"+"      "+"LEN"+Transforma(_dDatRef)+"POS"
_cLin := Stuff(_cLin,01,23,_cCpo)

If fWrite(_nHdl,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif

While !EOF()
	
	If TRB->FILIAL # _cFilialAnt
		If !fInfo(@_aInfo,TRB->FILIAL)
			Exit
		Endif
		dbSelectArea( "TRB" )
		_cFilialAnt := TRB->FILIAL
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	
	IncProc()
	
	//�����������������������������������������������������������������ͻ
	//� Lay-Out do arquivo Texto gerado:                                �
	//�����������������������������������������������������������������͹
	//�Campo           � Inicio � Tamanho                               �
	//�����������������������������������������������������������������Ķ
	//� TIPOREG        � 01     � 01                                    �
	//� TIPODADO       � 02     � 02                                    �
	//� CODACAO        � 04     � 02                                    �
	//� FILIAL         � 06     � 05                                    �
	//� MAT            � 11     � 10                                    �
	//� NOME           � 21     � 40                                    �
	//� CC             � 61     � 30                                    �
	//� CODFUNC        � 91     � 30                                    �
	//� SEXO           � 121    � 01                                    �
	//� NASC           � 122    � 08                                    �
	//� CIC            � 130    � 11                                    �
	//� ADMISSA        � 141    � 08                                    �
	//� ESTCIVI        � 149    � 18                                    �
	//� ENDEREC        � 167    � 30                                    �
	//� COMPLEM        � 197    � 30                                    �
	//� BAIRRO         � 227    � 30                                    �
	//� MUNICIP        � 257    � 30                                    �
	//� CEP            � 287    � 08                                    �
	//� UFCP           � 295    � 02                                    �
	//� DDD            � 297    � 04                                    �
	//� TELEFON        � 301    � 10                                    �
	//� EMAIL          � 311    � 30                                    �
	//� FILIAL         � 341    � 30                                    �
	//�����������������������������������������������������������������ͼ
	
	If TRB->TIPODADO == "FU"
		_nTamLin := 370
		_clin    := Space(_nTamLin)+_cEOL // Variavel para criacao da linha do registros para gravacao
		
		//���������������������������������������������������������������������Ŀ
		//� Substitui nas respectivas posicioes na variavel _clin pelo conteudo  �
		//� dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     �
		//� string dentro de outra string.                                      �
		//�����������������������������������������������������������������������
		
		_cCpo := PADR("D",01)
		_clin := Stuff(_clin,01,01,_cCpo)
		_cCpo := PADR(TRB->TIPODADO,02)
		_clin := Stuff(_clin,02,02,_cCpo)
		_cCpo := PADR(TRB->CODACAO,02)
		_clin := Stuff(_clin,04,02,_cCpo)
		_cCpo := PADR(TRB->FILIAL,05)
		_clin := Stuff(_clin,06,05,_cCpo)
		_cCpo := PADR(TRB->MAT,10)
		_clin := Stuff(_clin,11,10,_cCpo)
		_cCpo := PADR(TRB->NOME,40)
		_clin := Stuff(_clin,21,40,_cCpo)
		_cCpo := PADR(TRB->CC,30)
		_clin := Stuff(_clin,61,30,_cCpo)
		_cCpo := PADR(DescFun(TRB->CODFUNC,TRB->FILIAL),30)
		_clin := Stuff(_clin,91,30,_cCpo)
		_cCpo := PADR(TRB->SEXO,01)
		_clin := Stuff(_clin,121,01,_cCpo)
		_cCpo := PADR(Transforma(TRB->NASC),08)
		_clin := Stuff(_clin,122,08,_cCpo)
		_cCpo := PADR(TRB->CIC,11)
		_clin := Stuff(_clin,130,11,_cCpo)
		_cCpo := PADR(Transforma(TRB->ADMISSA),08)
		_clin := Stuff(_clin,141,08,_cCpo)
		If TRB->ESTCIVI == "C"
			_cCpo := PADR("Casado(a)",18)
		ElseIf TRB->ESTCIVI == "D"
			_cCpo := PADR("Divorciado(a)",18)
		ElseIf TRB->ESTCIVI == "M"
			_cCpo := PADR("Marital",18)
		ElseIf TRB->ESTCIVI == "Q"
			_cCpo := PADR("Desquitado(a)",18)
		ElseIf TRB->ESTCIVI == "S"
			_cCpo := PADR("Solteiro(a)",18)
		ElseIf TRB->ESTCIVI == "V"
			_cCpo := PADR("Viuvo(a)",18)
		Else
			_cCpo := Space(18)
		EndIf
		_clin := Stuff(_clin,149,18,_cCpo)
		_cCpo := PADR(TRB->ENDEREC,30)
		_clin := Stuff(_clin,167,30,_cCpo)
		_cCpo := PADR(TRB->COMPLEM,30)
		_clin := Stuff(_clin,197,30,_cCpo)
		_cCpo := PADR(TRB->BAIRRO,30)
		_clin := Stuff(_clin,227,30,_cCpo)
		_cCpo := PADR(TRB->MUNICIP,30)
		_clin := Stuff(_clin,257,30,_cCpo)
		_cCpo := PADR(TRB->CEP,08)
		_clin := Stuff(_clin,287,08,_cCpo)
		_cCpo := PADR(TRB->UFCP,02)
		_clin := Stuff(_clin,295,02,_cCpo)
		_cCpo := Space(04)
		_clin := Stuff(_clin,297,04,_cCpo)
		_cCpo := PADR(TRB->TELEFON,10)
		_clin := Stuff(_clin,301,10,_cCpo)
		_cCpo := PADR(TRB->EMAIL,30)
		_clin := Stuff(_clin,311,30,_cCpo)
		_cCpo := PADR(_aInfo[1],30)
		_clin := Stuff(_clin,341,30,_cCpo)
		
	ElseIf TRB->TIPODADO == "DM"
		
		//�����������������������������������������������������������������ͻ
		//� Lay-Out do arquivo Texto gerado:                                �
		//�����������������������������������������������������������������͹
		//�Campo           � Inicio � Tamanho                               �
		//�����������������������������������������������������������������Ķ
		//� TIPOREG        � 01     � 01                                    �
		//� TIPODADO       � 02     � 02                                    �
		//� CODACAO        � 04     � 02                                    �
		//� FILIAL         � 06     � 05                                    �
		//� MAT            � 11     � 10                                    �
		//� DEMISSA        � 21     � 08                                    �
		//� AFASFGT        � 29     � 01                                    �
		//�����������������������������������������������������������������ͼ
		
		_nTamLin := 29
		_clin    := Space(_nTamLin)+_cEOL // Variavel para criacao da linha do registros para gravacao
		
		//���������������������������������������������������������������������Ŀ
		//� Substitui nas respectivas posicioes na variavel _clin pelo conteudo  �
		//� dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     �
		//� string dentro de outra string.                                      �
		//�����������������������������������������������������������������������
		
		_cCpo := PADR("D",01)
		_clin := Stuff(_clin,01,01,_cCpo)
		_cCpo := PADR(TRB->TIPODADO,02)
		_clin := Stuff(_clin,02,02,_cCpo)
		_cCpo := PADR(TRB->CODACAO,02)
		_clin := Stuff(_clin,04,02,_cCpo)
		_cCpo := PADR(TRB->FILIAL,05)
		_clin := Stuff(_clin,06,05,_cCpo)
		_cCpo := PADR(TRB->MAT,10)
		_clin := Stuff(_clin,11,10,_cCpo)
		_cCpo := PADR(Transforma(TRB->DEMISSA),08)
		_clin := Stuff(_clin,21,08,_cCpo)
		If Trim(TRB->AFASFGT) $ "H"
			_cRazao := "1"
		ElseIf Trim(TRB->AFASFGT) $ "I,L "
			_cRazao := "2"
		ElseIf Trim(TRB->AFASFGT) $ "J,K"
			_cRazao := "3"
		EndIf
		_cCpo := PADR(_cRazao,01)
		_clin := Stuff(_clin,29,01,_cCpo)
		
	ElseIf TRB->TIPODADO == "FE"
		
		//�����������������������������������������������������������������ͻ
		//� Lay-Out do arquivo Texto gerado:                                �
		//�����������������������������������������������������������������͹
		//�Campo           � Inicio � Tamanho                               �
		//�����������������������������������������������������������������Ķ
		//� TIPOREG        � 01     � 01                                    �
		//� TIPODADO       � 02     � 02                                    �
		//� CODACAO        � 04     � 02                                    �
		//� FILIAL         � 06     � 05                                    �
		//� MAT            � 11     � 10                                    �
		//� DATAINI        � 21     � 08                                    �
		//� DATAFIM        � 29     � 08                                    �
		//�����������������������������������������������������������������ͼ
		
		_nTamLin := 36
		_clin    := Space(_nTamLin)+_cEOL // Variavel para criacao da linha do registros para gravacao
		
		//���������������������������������������������������������������������Ŀ
		//� Substitui nas respectivas posicioes na variavel _clin pelo conteudo  �
		//� dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     �
		//� string dentro de outra string.                                      �
		//�����������������������������������������������������������������������
		
		_cCpo := PADR("D",01)
		_clin := Stuff(_clin,01,01,_cCpo)
		_cCpo := PADR(TRB->TIPODADO,02)
		_clin := Stuff(_clin,02,02,_cCpo)
		_cCpo := PADR(TRB->CODACAO,02)
		_clin := Stuff(_clin,04,02,_cCpo)
		_cCpo := PADR(TRB->FILIAL,05)
		_clin := Stuff(_clin,06,05,_cCpo)
		_cCpo := PADR(TRB->MAT,10)
		_clin := Stuff(_clin,11,10,_cCpo)
		_cCpo := PADR(Transforma(TRB->DATAINI),08)
		_clin := Stuff(_clin,21,08,_cCpo)
		_cCpo := PADR(Transforma(TRB->DATAFIM),08)
		_clin := Stuff(_clin,29,08,_cCpo)
		
	ElseIf TRB->TIPODADO == "TR"
		
		//�����������������������������������������������������������������ͻ
		//� Lay-Out do arquivo Texto gerado:                                �
		//�����������������������������������������������������������������͹
		//�Campo           � Inicio � Tamanho                               �
		//�����������������������������������������������������������������Ķ
		//� TIPOREG        � 01     � 01                                    �
		//� TIPODADO       � 02     � 02                                    �
		//� CODACAO        � 04     � 02                                    �
		//� FILIALD        � 06     � 05                                    �
		//� MATD           � 11     � 10                                    �
		//� FILIAL         � 21     � 05                                    �
		//� MAT            � 26     � 10                                    �
		//� CC             � 36     � 30                                    �
		//� CODFUNC        � 66     � 40                                    �
		//�����������������������������������������������������������������ͼ
		
		_nTamLin := 105
		_clin    := Space(_nTamLin)+_cEOL // Variavel para criacao da linha do registros para gravacao
		
		//���������������������������������������������������������������������Ŀ
		//� Substitui nas respectivas posicioes na variavel _clin pelo conteudo �
		//� dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     �
		//� string dentro de outra string.                                      �
		//�����������������������������������������������������������������������
		
		_cCpo := PADR("D",01)
		_clin := Stuff(_clin,01,01,_cCpo)
		_cCpo := PADR(TRB->TIPODADO,02)
		_clin := Stuff(_clin,02,02,_cCpo)
		_cCpo := PADR(TRB->CODACAO,02)
		_clin := Stuff(_clin,04,02,_cCpo)
		_cCpo := PADR(TRB->FILIALD,05)
		_clin := Stuff(_clin,06,05,_cCpo)
		_cCpo := PADR(TRB->MATD,10)
		_clin := Stuff(_clin,11,10,_cCpo)
		_cCpo := PADR(TRB->FILIAL,05)
		_clin := Stuff(_clin,21,05,_cCpo)
		_cCpo := PADR(TRB->MAT,10)
		_clin := Stuff(_clin,26,10,_cCpo)
		_cCpo := PADR(DescCc(TRB->CC,TRB->FILIAL),30)
		_clin := Stuff(_clin,36,30,_cCpo)
		_cCpo := PADR(DescFun(TRB->CODFUNC,TRB->FILIAL),40)
		_clin := Stuff(_clin,66,40,_cCpo)
		
	EndIf
	
	//���������������������������������������������������������������������Ŀ
	//� Gravacao no arquivo texto. Testa por erros durante a gravacao da    �
	//� linha montada.                                                      �
	//�����������������������������������������������������������������������
	
	If fWrite(_nHdl,_clin,Len(_clin)) != Len(_clin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif
	
	dbSkip()
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(_nHdl)
dbSelectArea("TRB")
dbCloseArea()
FErase(_cFileDbf)
FErase(FileNoExt(_cFileDbf)+OrdBagExt())

Return


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Cria_TRB   � Autor � Kleber Dias Gomes    � Data � 17/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria o arq para geracao do TXT para Exp. CIGNA             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Cria_TRB()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � ExpCigna                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function Cria_TRB()

Local _aStruc[26]
Local _cIndice  := "DESCEND(TIPODADO) + CODACAO + FILIAL + MAT"

If !MSFile(_cFileDbf,,__LocalDriver)
	_aStruc[01] := {"TIPODADO" ,"C",02,0}
	_aStruc[02] := {"CODACAO"  ,"C",02,0}
	_aStruc[03] := {"FILIAL"   ,"C",02,0}
	_aStruc[04] := {"MAT"      ,"C",06,0}
	_aStruc[05] := {"NOME"     ,"C",30,0}
	_aStruc[06] := {"CC"       ,"C",09,0}
	_aStruc[07] := {"CODFUNC"  ,"C",04,0}
	_aStruc[08] := {"SEXO"     ,"C",01,0}
	_aStruc[09] := {"NASC"     ,"D",08,2}
	_aStruc[10] := {"CIC"      ,"C",11,0}
	_aStruc[11] := {"ADMISSA"  ,"D",08,0}
	_aStruc[12] := {"ESTCIVI"  ,"C",01,0}
	_aStruc[13] := {"ENDEREC"  ,"C",30,0}
	_aStruc[14] := {"COMPLEM"  ,"C",15,0}
	_aStruc[15] := {"BAIRRO"   ,"C",15,0}
	_aStruc[16] := {"MUNICIP"  ,"C",20,0}
	_aStruc[17] := {"CEP"      ,"C",08,0}
	_aStruc[18] := {"UFCP"     ,"C",02,0}
	_aStruc[19] := {"TELEFON"  ,"C",20,0}
	_aStruc[20] := {"EMAIL"    ,"C",50,0}
	_aStruc[21] := {"DEMISSA"  ,"D",08,0}
	_aStruc[22] := {"AFASFGT"  ,"C",02,0}
	_aStruc[23] := {"DATAINI"  ,"D",08,0}
	_aStruc[24] := {"DATAFIM"  ,"D",08,0}
	_aStruc[25] := {"FILIALD"  ,"C",02,0}
	_aStruc[26] := {"MATD"     ,"C",06,0}
	
	dbCreate(_cFileDbf,_aStruc,__LocalDriver)
	dbUseArea( .T.,__LocalDriver, _cFileDbf, "TRB", If(.F. .OR. .T., !.T., NIL), .F. )
	IndRegua("TRB",FileNoExt(_cFileDbf),_cIndice,,,"Selecionando Registros...")
Else
	dbUseArea( .T.,__LocalDriver, _cFileDbf, "TRB", If(.F. .OR. .T., !.T., NIL), .F. )
	IndRegua("TRB",FileNoExt(_cFileDbf),_cIndice,,,"Selecionando Registros...")
EndIf

Return Nil

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Transforma � Autor � Kleber Dias Gomes    � Data � 17/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Transforma as datas no formato DDMMAAAA                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Transforma(ExpD1)                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpD1 = Data a ser convertido                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � ExpCigna                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function Transforma(dData)
Return(StrZero(Day(dData),2)+StrZero(Month(dData),2)+Right(Str(Year(dData)),4))
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FGETPATH � Autor � Kleber Dias Gomes     � Data � 26/06/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Permite que o usuario decida onde sera criado o arquivo    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � EXPCIGNA													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Function FGETPATH() 
Local _mvRet  	:=Alltrim(ReadVar())
Local _cPath 	:=&(Alltrim(ReadVar())) 

_oWnd := GetWndDefault()

While .T.
	If _mvRet == "MV_PAR01" 			//-- ExpCigna 
		If Empty(_cPath )
			_cPath  := cGetFile( "Arquivos de Importacao CIGNA (FFRM*.TXT) | FFRM*.TXT",OemToAnsi("Selecione o Arquivo"),,"",.F.,)
		EndIf
		
		If Empty(_cPath )
			Return .F.
		EndIf
	Else								//-- ImpCigna
		CursorWait()
		If Empty(_cPath)
			_cPath := cGetFile( "Arquivos de Exportacao CIGNA | ",OemToAnsi("Selecione Diretorio"), ,"" ,.F.,GETF_RETDIRECTORY)
		EndIf
		
		If Empty(_cPath)
			Return .F.
		EndIf
	
		If Right(alltrim(_cPath),1) <>"\"
			_cPath	:= alltrim(_cPath) + "\"
		Endif
		
		If ":" $ _cPath 
			_cPath:= substr(_cPath,rat(":",_cPath)+1  , len( alltrim(_cPath) ) )     
		Endif
	Endif	
	Exit
EndDo

&_mvRet := _cPath
	
If _oWnd != Nil
	GetdRefresh()
EndIf

Return .T.