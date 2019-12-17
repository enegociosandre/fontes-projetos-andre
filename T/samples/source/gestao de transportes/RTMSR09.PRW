#INCLUDE "RTMSR09.ch"
#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � RTMSR09  � Autor � Antonio C Ferreira    � Data �24.06.2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Impressao do Romaneio de Entrega                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RTMSR09                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Gestao de Transporte                                       ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RTMSR09()

Local titulo   := STR0001 //"Relacao de Coletas"
Local cString  := "DTQ"
Local wnrel    := "RTMSR09"
Local cDesc1   := STR0002 //"Este programa ira listar os Mapas de Coleta"
Local cDesc2   := ""
Local cDesc3   := ""
Local tamanho  := "G"

Private NomeProg := "RTMSR09"
Private aReturn  := {STR0003,1,STR0004,1, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private cPerg    := "RTMR09"
Private nLastKey := 0
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas                                        �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// Viagem Inicial	                     �
//� mv_par02        	// Viagem Final       	                 �
//����������������������������������������������������������������

//Chamada do relatorio padrao
If FindFunction("TRepInUse") .And. TRepInUse()
	TMSR560()
	Return
EndIf

pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR09Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RTMSR09Imp� Autor � Antonio C Ferreira    � Data �24.06.2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RTMSR09			                                            ���
�������������������������������������������������������������������������Ĵ��
���          �        �                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RTMSR09Imp(lEnd,wnRel,titulo,tamanho)
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local cDesc1, cDesc2
Local nTotPed:=nTotPeso:=nTotVol:=0
Local nCountVei:=nCountMot:=nCountAju:=0
Local cString := ""
//Local nBegin := 0
Local nTamMaxCol := 180
Local lImp := .F.
Local cViagem := ""
Local acabec := {}
//Local cabec1
Local nA     := 0
Local nX     := 0
// "FIL.ORIG.  SOLICIT.   CLIENTE                                   ENDERECO                                  BAIRRO                           VOLS.   PESO       OBSERVACAO "
//  xx         xxxxxx     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  123456  123456789   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//Local cabec2:= ""
//�����������������������������������������������������������������������Ŀ
//� Define variaveis utilizadas para Impressao do cabecalho e rodape.     �
//�������������������������������������������������������������������������
Private cbtxt  := Space(10)
Private cbcont := 0
Private m_pag  := 1
Private Li:=80
Private nTipo  := aReturn[4]

Inclui := .F.
SM0->(dbSeek(cEmpAnt+cFilAnt, .T.))


//-- Viagens
DTQ->(dbSetOrder(1))

//-- Rotas
DA8->(dbSetOrder(1))

//-- Clientes
SA1->(dbSetOrder(1))

//-- Nota Fiscal Cliente
DTC->(dbSetOrder(3))

//��������������������������������������������������������������Ŀ
//� Alimenta Arquivo de Trabalho                                 �
//����������������������������������������������������������������
dbSelectArea("DUD")
dbSetOrder(2)   // DUD_FILIAL+DUD_FILORI+DUD_VIAGEM+DUD_FILDOC+DUD_DOC+DUD_SERIE

dbSeek(xFilial("DUD") + cFilAnt + mv_par01, .T.)

SetRegua(LastRec())

Do While !Eof() .And. (DUD_FILIAL == xFilial("DUD")) .And. (DUD_FILORI == cFilAnt) .And. (DUD_VIAGEM <= mv_par02)

	cViagem := DUD_VIAGEM
	
	// DOCUMENTOS DE TRANSPORTE
	DT6->( MsSeek(xFilial("DT6") + DUD->(DUD_FILDOC + DUD_DOC + DUD_SERIE)) )
	
	If Empty(cViagem) .Or. !(DT6->DT6_DOCTMS $ "25")  // Somente 2-CTRC e 5-Nota Fiscal.
	    IncRegua()
	    If Interrupcao(@lEnd)
		   Exit
	    Endif

		dbSkip()
		Loop
	EndIf
	
	
	//�����������������������������������������������������������������������Ŀ
	//� Monta o array acabec (Informacoes iniciais do cabecalho)              �
	//�������������������������������������������������������������������������
	nCountVei:=nCountMot:=nCountAju:=0
	
	RTMSR09Cabec(@nCountVei,@nCountMot,@nCountAju,@acabec, cViagem, nTamMaxCol)
	
	cDesc1 := STR0013 + cFilAnt + " " + cViagem  // Viagem: ## ######
	cDesc2 := STR0014 + AllTrim(DA8->DA8_COD) + " - " + AllTrim(DA8->DA8_DESC)  // Rota: ### - #######
	
	nTotPed:=nTotPeso:=nTotVol:=0
	li   := 80
	nCol := 0		
	
	//�����������������������������������������������������������������������Ŀ
	//� Imprime o cabecalho                                                   �
	//�������������������������������������������������������������������������
	Do While !DUD->(Eof()) .And. DUD->DUD_FILIAL == xFilial("DUD") .And. DUD->DUD_FILORI == cFilAnt .And.;
		DUD->DUD_VIAGEM == cViagem
	    
	    IncRegua()
	    If Interrupcao(@lEnd)
		   Exit
	    Endif

		// DOCUMENTOS DE TRANSPORTE
		DT6->( MsSeek(xFilial("DT6") + DUD->(DUD_FILDOC + DUD_DOC + DUD_SERIE)) )
	
		If !(DT6->DT6_DOCTMS $ "25")  // Somente 2-CTRC e 5-Nota Fiscal.
			dbSkip()
			Loop
		EndIf
	
		If Li > 55
			Cabec(Titulo, cDesc1, cDesc2, NomeProg, Tamanho)
			For nA := 1 to len(aCabec)
				@ Li++, 0 PSay aCabec[nA,1]
			Next
			++Li                    
			@Li,000 PSay __PrtThinLine()
			++Li
 			@Li,000 PSay STR0005
			++Li                    
			@Li,000 PSay __PrtThinLine()
            Li += 2
		EndIf
		
		//-- Viagens
		DTQ->(dbSeek(xFilial("DTQ")+cViagem))
	
		//-- Rotas
		DA8->(dbSeek(xFilial("DA8")+DTQ->DTQ_ROTA))

		//-- Nota Fiscal Cliente
	    DTC->(MsSeek(xFilial("DTC")+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE))
	    
		//-- Clientes
		SA1->(dbSeek(xFilial("SA1")+DTC->( DTC_CLIDES + DTC_LOJDES )))
		
		@Li,000 PSAY DUD->DUD_FILDOC           		Picture "99"
		@Li,010 PSAY DUD->DUD_DOC+"/"+DUD->DUD_SERIE
		@Li,022 PSay SA1->A1_NOME        		Picture PesqPict("SA1","A1_NOME")
		@Li,064 PSay SA1->A1_END	      		Picture PesqPict("SA1","A1_END")
		@Li,106 PSay SA1->A1_BAIRRO      		Picture PesqPict("SA1","A1_BAIRRO")
		@Li,140 PSay DT6->DT6_QTDVOL     		Picture PesqPict("DT6","DT6_QTDVOL")
		@Li,148 PSay DT6->DT6_PESO       		Picture PesqPict("DT6","DT6_PESO")

        ++LI

		nTotPed ++
		
		//-- Totalizadores
		nTotVol   += DT6->DT6_QTDVOL
		nTotPeso  += DT6->DT6_PESO
		lImp := .T.

		dbSelectArea("DUD")
		dbSkip()
	EndDo
	
	If lEnd
	   Exit
	EndIf   
	
	If lImp
		Li+=2
		@Li,000 PSay __PrtThinLine()
		Li+=2
		@Li,000 PSay STR0006 //"TOTAIS -> "
		@Li,013 PSay STR0007 + AllTrim(STR(nTotPed)) //"PEDIDOS : "
		@Li,032 PSay STR0008 + TransForm(nTotPeso ,PesqPict("DT6","DT6_PESO"))  //"PESO : "
		@Li,057 PSay STR0009 + TransForm(nTotVol  ,PesqPict("DT6","DT6_QTDVOL")) //"VOLUME : "
		
		Li+=6
		//�����������������������������������������������������������������������Ŀ
		//� Imprime o cabecalho                                                   �
		//�������������������������������������������������������������������������
		If Li > 55
			Cabec(Titulo, cDesc1, cDesc2, NomeProg, Tamanho)
		EndIf
		
		nCol:=0
		Li++
		For nX:=1 to nCountMot+1
			ImpLin(Li,@nCol,nTamMaxCol)
		Next
		
		nCol:=0
		Li++
		For nX:=1 to Len(aCabec)
			If aCabec[nX,2] == "2"
				cString := Right(aCabec[nX,1],Len(DA4->DA4_NREDUZ)+2)  //STR0011 //" Assinatura Motorista "
				ImpAss(@Li,@nCol,cString,nX,nCountMot,nTamMaxCol,.F.)
			EndIf	
		Next
		
		nCol:=0
		Li+=3
		//�����������������������������������������������������������������������Ŀ
		//� Imprime o cabecalho                                                   �
		//�������������������������������������������������������������������������
		If Li > 55
			Cabec(Titulo, cDesc1, cDesc2, NomeProg, Tamanho)
		EndIf
		
		Li++
		For nX:=1 to nCountAju +1
			ImpLin(Li,@nCol,nTamMaxCol)
		Next
		
		nCol:=0
		Li++

		For nX:=1 to Len(aCabec)
			If aCabec[nX,2] == "3"
				cString := Right(aCabec[nX,1],Len(DAU->DAU_NREDUZ)+2) // STR0012 //" Assinatura Ajudante  "
				ImpAss(@Li,@nCol,cString,nX,nCountMot,nTamMaxCol,.F.)
			EndIf	
		Next   
	EndIf

EndDo

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RTMSR09Cab� Autor � Antonio C Ferreira    � Data �24.06.2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime Cabecalho com os Dados da Empresa                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RTMSR09Cabec(ExpN1,ExpN2,ExpN3,ExpN4,ExpN5)                ���
�������������������������������������������������������������������������Ĵ��
���Parametro � ExpN1 - No. Total de Veiculos a serem Impressos            ���
���Parametro � ExpN2 - No. Total de Motoristas a serem Impressos          ���
���Parametro � ExpN3 - No. Total de Ajudante a serem Impressos            ���
���Parametro � ExpA4 - Array contendo as informacoes iniciais do cabecalho��� 
���Parametro � ExpC5 - Codigo da Viagem.                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RTMSR09			                                            ���
�������������������������������������������������������������������������Ĵ��
���          �        �                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RTMSR09Cabec(nCountVei,nCountMot,nCountAju,acabec,cViagem,nTamMaxCol)
Local lOk
Local aAux   := {}
Local nA     := 0
Local nBegin := 0

nCountVei   :=0
nCountMot   :=0
nCountAju   :=0
acabec      := {}

//�����������������������������������������������������������������������Ŀ
//� Monta as linhas do cabecalho.                                         �
//�������������������������������������������������������������������������

//-- Lista Veiculos
lOk  := .F.
DTR->(dbSetOrder(1))
DTR->(dbSeek(xFilial("DTR") + cFilAnt + cViagem ))

Do While DTR->( !Eof() .And. ((DTR_FILORI + DTR_VIAGEM) == (cFilAnt + cViagem)))

	dbSelectArea("DA3")
	dbSetOrder(1)
	If MsSeek(xFilial("DA3") + DTR->DTR_CODVEI)
		//�����������������������������������������������������������������������Ŀ
		//� Monta uma linha para cada registro do mesmo tipo(Veiculos).           �
		//�������������������������������������������������������������������������
		Aadd(acabec,{if(nCountvei==0, STR0015+": ", space(len(STR0015+": "))) + AllTrim(Str(++nCountVei)) + "-" + DA3->DA3_COD + "  -  " + AllTrim(DA3->DA3_DESC)+ Space(05) +; //"VEICULO "
		STR0016 + DA3->DA3_PLACA + Space(05)+ STR0017 + Transform(DA3->DA3_CAPACM,PesqPict("DA3","DA3_CAPACM")) +  Space(05)+ STR0018  + AllTrim(Tabela("M2", DA3->DA3_TIPVEI, .F.))+; //"PLACA : "###"   CAPACIDADE : "###"TIPO VEIC.: "
		Space(05)+ STR0019 + Replicate("_",25) + STR0020 + Replicate("_",25),"1"}) //"KM SAIDA : "###"KM CHEGADA : "
		
		lOK := .T.
	EndIf				

	If !Empty(DTR->DTR_CODRB1) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB1)) 
		//�����������������������������������������������������������������������Ŀ	
		//� Monta uma linha com os dados do 1o. Reboque                           �
		//�������������������������������������������������������������������������
		Aadd(aCabec, {if(nCountvei==0, STR0015, space(len(STR0015) + 2)) + StrZero(++nCountvei, 1) + "-" + DA3->DA3_COD + " " + DA3->DA3_PLACA +; // Veiculo: ## - #### ###-####
						  " " + STR0018 + Substr(Tabela("M2", DA3->DA3_TIPVEI, .F.),1,25) +; // Tipo: ############ 
		                  " " + STR0017 + Alltrim(Transform(DA3->DA3_CAPACM, PesqPict("DA3","DA3_CAPACM"))),"1"} ) //Capac: 999999.99
	EndIf

	If !Empty(DTR->DTR_CODRB2) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB2)) 
		//�����������������������������������������������������������������������Ŀ	
		//�  Monta uma linha com os dados do 2o. Reboque                          �
		//�������������������������������������������������������������������������
		Aadd(aCabec, {if(nCountvei==0, STR0015, space(len(STR0015) + 2)) + StrZero(++nCountvei, 1) + "-" + DA3->DA3_COD + " " + DA3->DA3_PLACA +; // Veiculo: ## - #### ###-####
						  " " + STR0018 + Substr(Tabela("M2", DA3->DA3_TIPVEI, .F.),1,25) +; // Tipo: ############ 
		                  " " + STR0017 + Alltrim(Transform(DA3->DA3_CAPACM, PesqPict("DA3","DA3_CAPACM"))),"1"} ) //Capac: 999999.99
	EndIf
		
	// Ajudante
	DUQ->(MsSeek(xFilial("DUQ") + cFilAnt + cViagem + DTR->DTR_ITEM))
	While DUQ->(!Eof()) .And. DUQ->(DUQ_FILIAL + DUQ_FILORI + DUQ_VIAGEM + DUQ_ITEDTR) == xFilial("DUQ") + cFilAnt + cViagem + DTR->DTR_ITEM

		If DAU->(MsSeek(xFilial("DAU") + DUQ->DUQ_CODAJU))
			Aadd(aAux,if(nCountAju==0, STR0022+" : ", Space(Len(STR0022+" : "))) + AllTrim(Str(++nCountAju)) + "-" + DAU->DAU_NREDUZ) //"AJUDANTE "	
		EndIf			

		DUQ->(dbSkip())
	EndDo	
	dbSelectArea("DTR")
	dbSkip()
EndDo

If lOk
   Aadd(acabec, {" ", ""})
EndIf

lOk := .F.

//Motirista
DUP->(dbSetOrder(1))
DUP->(dbSeek(xFilial("DUP") + cFilAnt + cViagem))
Do While !DUP->(Eof()) .And. DUP->DUP_FILIAL + DUP->DUP_FILORI + DUP->DUP_VIAGEM == xFilial('DUP') + cFilAnt + cViagem

	If DA4->(dbSeek(xFilial("DA4")+DUP->DUP_CODMOT))
		Aadd(aCabec,{if(nCountMot==0, STR0021+" : ", space(len(STR0021+" : "))) + AllTrim(Str(++nCountMot)) + "-" + DA4->DA4_NREDUZ,"2"}) //"MOTORISTA "
		
		lOk := .T.
	EndIf

	DUP->(dbSkip())
EndDo

If lOk
   Aadd(acabec, {" ", ""})
EndIf   
lOk := .F.

//-- Lista Ajudantes
For nA := 1 To Len(aAux)
	lOk := .T.
	Aadd(aCabec, {aAux[nA], "3"})
Next nA

//-- Imprime Campo memo
If !Empty(DTQ->DTQ_CODOBS)
    If lOk
       Aadd(acabec, {" ", ""})
    EndIf   

	cDescri := E_MsMM(DTQ->DTQ_CODOBS,80)
	nLinha:= MLCount(cDescri,nTamMaxCol)
	Aadd(acabec, {STR0010 + MemoLine(cDescri,nTamMaxCol,1), "4"})
	For nBegin := 2 To nLinha
		Aadd(acabec, {space(len(STR0010)) + Memoline(cDescri,nTamMaxCol,nBegin),"4"})
	Next nBegin
EndIf


Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ImpLin    � Autor �Antonio C Ferreira     � Data �18.02.2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime Linha para as Assinaturas dos Motoristas / Ajudantes���
���          �(de 1 a n ...)                                              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpLin(ExpN1,ExpN2,ExpN3)                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametro � ExpN1 - No. da Linha                                       ���
���          � ExpN2 - No. da Coluna                                      ���
���Parametro � ExpN3 - Tam. Max da Coluna; Controla a Impressao dos dados ���
���          �         na proxima linha.                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RTMSR09			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpLin(Li,nCol,nTamMaxCol)
If nCol <= nTamMaxCol
	@Li,nCol PSay "______________________________"
	nCol+=35
EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ImpAss    � Autor �Antonio C Ferreira     � Data �18.02.2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime Linha para as Assinaturas dos Motoristas / Ajudantes���
���          �(de 1 a n ...)                                              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpAss(ExpN1,ExpN2,ExpC1,ExpN3,ExpN4,ExpN5)                ���
�������������������������������������������������������������������������Ĵ��
���Parametro � ExpN1 - No. da Linha                                       ���
���          � ExpN2 - No. da Coluna                                      ���
���          � ExpC1 - Descricao da Assinatura (Motorista / Ajudante)     ���
���          � ExpN3 - No. para controlar se imprime ou nao na outra linha���
���          � ExpN4 - No. Total de Motoristas/Ajudantes a serem Impressos���
���Parametro � ExpN5 - Tam. Max da Coluna; Controla a Impressao dos dados ���
���          �         na proxima linha.                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RTMSR09			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpAss(Li,nCol,cString,nNumDe,nNumAte,nTamMaxCol, lSequen)

Local nY  := 0
// Imprime numero sequencial.
Default lSequen := .T.

If nCol >= nTamMaxCol
	nCol:=0
	Li+=2
	For nY := nNumDe To nNumAte+1
		ImpLin(@Li,@nCol)
	Next
	nCol:=0
	Li++
EndIf
If nCol == 0
	@Li,nCol PSay STR0023 //"Data"
	nCol+=35
EndIf
@Li,nCol PSay cString + Iif(lSequen, AllTrim(Str(nX)), "")
nCol+=35

Return