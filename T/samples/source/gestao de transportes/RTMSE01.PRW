#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �  RTMSE01 � Autor � Eduardo de Souza      � Data � 10/06/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotinas utilizadas na validacao do Envio/Recebimento.      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI - ENVIO / RECEBIMENTO                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � EdiVdOc1 � Autor � Eduardo de Souza      � Data � 10/06/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida se existem ocorrencias para o Cliente De/Ate, Nota  ���
���          � Fiscal De/Ate e Agrupamento de CNPJ, conforme parametros.  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EdiVdOc1()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Envio / Recebimento (EDI)                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function EdiVdOc1()

Local lRet      := .F.
Local lContinua := .F.
Local aAreaDTC  := DTC->(GetArea())
Local aAreaDT6  := DT6->(GetArea())
Local aAreaDUD  := DUD->(GetArea())

If !Empty(DUA->DUA_FILDOC) .And. !Empty(DUA->DUA_DOC) .And. !Empty(DUA->DUA_SERIE)
	
	//�����������������������������������������������������Ŀ
	//� Verifica Cliente De / Ate.     				     	�
	//�������������������������������������������������������
	DbSelectArea("DT6")
	DbSetOrder(1)
	If MsSeek(xFilial("DT6")+DUA->DUA_FILDOC+DUA->DUA_DOC+DUA->DUA_SERIE)			


		If !(DT6->DT6_CLIREM + DT6->DT6_LOJREM == DEC->DEC_CODCLI + DEC->DEC_LOJCLI)

			If mv_par09 == 1 // Agrupamento de CNPJ

				DbSelectArea("SA1")
				DbSetOrder(1)
				If MsSeek(xFilial("SA1")+DEC->DEC_CODCLI+DEC->DEC_LOJCLI)
					
					DbSelectArea("DE4")
					DbSetOrder(1)
					If MsSeek(xFilial("DE4")+SA1->A1_CGC)
						While DE4->(!Eof()) .And. DE4->DE4_FILIAL + DE4->DE4_CNPJ == xFilial("DE4") + SA1->A1_CGC
						
							DbSelectArea("SA1")
							DbSetOrder(3)
							If MsSeek(xFilial("SA1")+DE4->DE4_CNPJ1)							
								If SA1->A1_COD + SA1->A1_LOJA == DT6->DT6_CLIREM + DT6->DT6_LOJREM
									lContinua := .t.
								EndIf							
							EndIf
							DbSelectArea("DE4")
							DbSkip()
						EndDo
					EndIf
				EndIf
			EndIf
        
        Else
   		
   			DbSelectArea("SA1")
			DbSetOrder(1)
			If MsSeek(xFilial("SA1")+DT6->DT6_CLIREM+DT6->DT6_LOJREM)
				lContinua := .T.
			EndIf
		
		EndIf
		
		If lContinua
						
			//�����������������������������������������������������Ŀ
			//� Verifica Nota Fiscal De / Ate.						�
			//�������������������������������������������������������
			DbSelectArea("DTC")
			DbSetOrder(3)
			If MsSeek(xFilial("DTC")+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE)
				While DTC->(!Eof()) .And. DTC->DTC_FILIAL + DTC->DTC_FILDOC + DTC->DTC_DOC + DTC->DTC_SERIE == ;
											xFilial("DTC") + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE
					If DTC->DTC_NUMNFC >= mv_par05 .And. DTC->DTC_NUMNFC <= mv_par06										
						lRet := .T.
						Exit
					EndIf

					DbSelectArea("DTC")
					DbSkip()
				EndDo
			EndIf
		EndIf
	EndIf

Else

	DbSelectArea("DUD")
	DbSetOrder(2)
	If MsSeek(xFilial("DUD")+DUA->DUA_FILORI+DUA->DUA_VIAGEM)
		While DUD->(!Eof()) .And. DUD->DUD_FILIAL + DUD->DUD_FILORI + DUD->DUD_VIAGEM == xFilial("DUD") + DUA->DUA_FILORI + DUA->DUA_VIAGEM
	
			//�����������������������������������������������������Ŀ
			//� Verifica Cliente De / Ate.     				     	�
			//�������������������������������������������������������
			DbSelectArea("DT6")
			DbSetOrder(1)
			If MsSeek(xFilial("DT6")+DUD->DUD_FILDOC+DUD->DUD_DOC+DUD->DUD_SERIE)
			
				If !(DT6->DT6_CLIREM + DT6->DT6_LOJREM == DEC->DEC_CODCLI + DEC->DEC_LOJCLI)
		
					If mv_par09 == 1 // Agrupamento de CNPJ
		
						DbSelectArea("SA1")
						DbSetOrder(1)
						If MsSeek(xFilial("SA1")+DEC->DEC_CODCLI+DEC->DEC_LOJCLI)
							
							DbSelectArea("DE4")
							DbSetOrder(1)
							If MsSeek(xFilial("DE4")+SA1->A1_CGC)
								While DE4->(!Eof()) .And. DE4->DE4_FILIAL + DE4->DE4_CNPJ == xFilial("DE4") + SA1->A1_CGC
								
									DbSelectArea("SA1")
									DbSetOrder(3)
									If MsSeek(xFilial("SA1")+DE4->DE4_CNPJ1)							
										If SA1->A1_COD + SA1->A1_LOJA == DT6->DT6_CLIREM + DT6->DT6_LOJREM
											lContinua := .t.
										EndIf							
									EndIf
									DbSelectArea("DE4")
									DbSkip()
								EndDo
							EndIf
						EndIf
					EndIf
		        
		        Else
		   		
		   			DbSelectArea("SA1")
					DbSetOrder(1)
					If MsSeek(xFilial("SA1")+DT6->DT6_CLIREM+DT6->DT6_LOJREM)
						lContinua := .T.
					EndIf
				
				EndIf
				
				If lContinua
								
					//�����������������������������������������������������Ŀ
					//� Verifica Nota Fiscal De / Ate.						�
					//�������������������������������������������������������
					DbSelectArea("DTC")
					DbSetOrder(3)
					If MsSeek(xFilial("DTC")+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE)
						While DTC->(!Eof()) .And. DTC->DTC_FILIAL + DTC->DTC_FILDOC + DTC->DTC_DOC + DTC->DTC_SERIE == ;
													xFilial("DTC") + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE
							If DTC->DTC_NUMNFC >= mv_par05 .And. DTC->DTC_NUMNFC <= mv_par06										
								lRet := .T.
								Exit
							EndIf
		
							DbSelectArea("DTC")
							DbSkip()
						EndDo
					EndIf
				EndIf
			EndIf
	        DbSelectArea("DUD")
	        DbSkip()
		EndDo
    EndIf
EndIf

RestArea ( aAreaDTC )
RestArea ( aAreaDT6 )
RestArea ( aAreaDUD )

Return lRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � EdiVdOc2 � Autor � Eduardo de Souza      � Data � 10/06/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida se existem ocorrencias para o Cliente De/Ate, Nota  ���
���          � Fiscal De/Ate e Agrupamento de CNPJ, conforme parametros.  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EdiVdOc2()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Envio / Recebimento (EDI)                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function EdiVdOc2()

Local lRet      := .F.
Local lContinua := .F.
Local aArea     := GetArea()
Local aAreaDT6  := DT6->(GetArea())
Local aAreaDTC  := DTC->(GetArea())

//�����������������������������������������������������Ŀ
//� Verifica Cliente De / Ate.     				     	�
//�������������������������������������������������������
DbSelectArea("DT6")
DbSetOrder(1)
If MsSeek(xFilial("DT6")+DUD->DUD_FILDOC+DUD->DUD_DOC+DUD->DUD_SERIE)

	If !(DT6->DT6_CLIREM + DT6->DT6_LOJREM == DEC->DEC_CODCLI + DEC->DEC_LOJCLI)

		If mv_par09 == 1 // Agrupamento de CNPJ

			DbSelectArea("SA1")
			DbSetOrder(1)
			If MsSeek(xFilial("SA1")+DEC->DEC_CODCLI+DEC->DEC_LOJCLI)
					
				DbSelectArea("DE4")
				DbSetOrder(1)
				If MsSeek(xFilial("DE4")+SA1->A1_CGC)
					While DE4->(!Eof()) .And. DE4->DE4_FILIAL + DE4->DE4_CNPJ == xFilial("DE4") + SA1->A1_CGC
						
						DbSelectArea("SA1")
						DbSetOrder(3)
						If MsSeek(xFilial("SA1")+DE4->DE4_CNPJ1)							
							If SA1->A1_COD + SA1->A1_LOJA == DT6->DT6_CLIREM + DT6->DT6_LOJREM
								lContinua := .t.
							EndIf							
						EndIf
						DbSelectArea("DE4")
						DbSkip()
					EndDo
				EndIf
			EndIf
        EndIf
        
	Else
   		
		DbSelectArea("SA1")
		DbSetOrder(1)
		If MsSeek(xFilial("SA1")+DT6->DT6_CLIREM+DT6->DT6_LOJREM)
			lContinua := .T.
		EndIf
	
	EndIf
		
	If lContinua
						
		//�����������������������������������������������������Ŀ
		//� Verifica Nota Fiscal De / Ate.						�
		//�������������������������������������������������������
		DbSelectArea("DTC")
		DbSetOrder(3)
		If MsSeek(xFilial("DTC")+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE)
			While DTC->(!Eof()) .And. DTC->DTC_FILIAL + DTC->DTC_FILDOC + DTC->DTC_DOC + DTC->DTC_SERIE == ;
										xFilial("DTC") + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE
				If DTC->DTC_NUMNFC >= mv_par05 .And. DTC->DTC_NUMNFC <= mv_par06										
					lRet := .T.
					Exit
				EndIf

				DbSelectArea("DTC")
				DbSkip()
			EndDo
		EndIf
	EndIf
EndIf

RestArea ( aArea    )
RestArea ( aAreaDTC )
RestArea ( aAreaDT6 )

Return lRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �EDIConvDat � Autor �Eduardo de Souza      � Data � 29/08/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Converte Data para String conforme o Formato               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDIConvDat(ExpD1,ExpC1)                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpD1 - Data utilizada na conversao                        ���
���          � ExpC1 - Formato do retorno (Ex. DDMMAA / DDMMAAAA / AAMMDD)���
�������������������������������������������������������������������������Ĵ��
���Uso       � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function EDIConvDat(dDataConv,nDig,cSeparador)

Local   cRet       := ''
Default nDig       := 4
Default cSeparador := ''

cRet := StrZero(Day(dDataConv),2)+cSeparador+StrZero(Month(dDataConv),2)+cSeparador+Right(StrZero(Year(dDataConv),4),nDig)

Return cRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �EDIQtdNF  � Autor � Eduardo de Souza      � Data � 31/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna a Qdte de Notas Fiscais do CTRC                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDIQtdNF(ExpC1,ExpC2,ExpC3)                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 - Filial do Documento                                ���
���          � ExpC2 - Documento                                          ���
���          � ExpC3 - Serie do Documento                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function EDIQtdNF(cFilDoc,Docto,cSerie)

Local aAreaDTC := DTC->(GetArea())
Local nQtde    := 0

DTC->(DbSetOrder(3))
If DTC->(MsSeek(xFilial("DTC")+cFilDoc+Docto+cSerie))
	While DTC->(!Eof()) .And. DTC->DTC_FILIAL + DTC->DTC_FILDOC + DTC->DTC_DOC + DTC->DTC_SERIE == ;
		xFilial("DTC") + cFilDoc + Docto + cSerie
		nQtde++
		DTC->(DbSkip())
	EndDo
EndIf

RestArea(aAreaDTC)

Return nQtde

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �EDITotal  � Autor � Eduardo de Souza      � Data � 31/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza/Retorna o Totalizador do arquivo                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDITotal(ExpN1,ExpN2,ExpN3)                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 - Posicao p/ Atualizar                               ���
���          � ExpN2 - Valor para Atualizar                               ���
���          � ExpN3 - Tamanho do array                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function EDITotal(nPos,nValor,nTotArray)

Local nCnt := 0

If nPos > 0
	If nValor <> NIL
		If ValType(VAR_IXB) == "A"
			Var_Ixb[nPos]+= nValor
		Else
			Var_Ixb := {}
			For nCnt:= 1 To nTotArray
				aAdd(Var_Ixb,0)
			Next nCnt
			Var_Ixb[nPos]:= nValor
		EndIf
	EndIf
Else
	Var_Ixb:= NIL
EndIf

Return If(nPos>0,Var_Ixb[nPos],Nil)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �EdiListaNf� Autor � Eduardo de Souza      � Data � 31/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna as Notas do Conhecimento                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EdiListaNf(ExpC1,ExpC2,ExpC3,ExpC4)                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 - Filial do Documento                                ���
���          � ExpC2 - Documento                                          ���
���          � ExpC3 - Serie do Documento                                 ���
���          � ExpC4 - Separador                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function EdiListaNf(cFilDoc,cDocto,cSerie,cSeparador)

Local cNotas       := ""
Local aAreaDTC     := DTC->(GetArea())
Default cSeparador := ";"

DTC->(DbSetOrder(3))
DTC->(MsSeek(xFilial("DTC")+cFilDoc+cDocto+cSerie))
While DTC->(!Eof()) .And. DTC->DTC_FILIAL + DTC->DTC_FILDOC + DTC->DTC_DOC + DTC->DTC_SERIE == ;
		xFilial("DTC") + cFilDoc + cDocto + cSerie
	If !Empty(cNotas)
		cNotas += cSeparador
	EndIf
	cNotas += DTC->DTC_NUMNFC
	DTC->(DbSkip())
EndDo

RestArea(aAreaDTC)

Return cNotas

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ChavePFis �Autor  �Anderson crepaldi   � Data �  14/04/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Criacao de digito verificador gerado no momento de digitacao���
���          �de CGC + Viagem no posto Fiscal. O sistema armazena CGC mais���
���			 �Viagem em uma unica String. Realiza Multiplicacao de cada   ���
���			 �digito da String por um sequencial comecando em 7 e termi-  ���
���			 �nando em 2. Multiplica o Resultado por 10 e divide por 11,  ���
���			 �se o resto da divisao for maior que 9 o primeiro digito     ���
���			 �sera 0. Para o calculo do segundo digito segue-se o mesmo   ���
���			 �procedimento comecando a multiplicar cada digito da string  ���
���			 �por 8 e terminando em 3. Multiplica o digito 1 por 2,       ���
���			 �divide o resultado por 10 e se ao dividir o resultado por   ���
���			 �11 o resto da divisao for maior que 9 digito 2 = 0  		  ���
�������������������������������������������������������������������������͹��
���Uso       � TMS - EDI POSTO FISCAL                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function EDIChvPF(cFilori,cViagem)

Local cString := (SM0->M0_CGC + cFilori + cViagem)
Local ni      := 0
Local nMult   := 7
Local nTot1   := 0
Local nTot2   := 0
Local nDig1   := 0
Local nDig2   := 0

For nI := 1 to Len(cString)
	nTot1 += nMult * Val(Substr(cString,nI,1))
	nMult := nMult - 1
	//Se o valor for 2 o multiplicador passa a ser 9
	If nMult == 2
		nMult := 9
	EndIf
Next

// Multiplica o total por 10
nTot1 := nTot1 * 10

// Guarda o resto da divisao de nTot1 
nDig1 := Mod(nTot1,11)

// Se o resto da divisao for maior que 9 o digito sera zero
If nDig1 > 9
	nDig1 := 0
EndIf

// Comeca o mesmo processo para calculo do segundo digito 
// O Multiplicador comeca valendo 8.
nMult := 8
for nI := 1 to Len(cString)
	nTot2 += nMult * Val(Substr(cString,nI,1))
	nMult := nMult - 1
  //Se o valor for 2 o multiplicador passa a ser 9
	If nMult == 2
		nMult := 9
	EndIf
Next

// nTot2 recebe o resultado da multiplicacao do primeiro digito por 2
nTot2 += nDig1 * 2                                                 

// Multiplica o total2 por 10
nTot2 := nTot2*10

// Guarda o resto da divisao em nDig2
nDig2 := Mod(nTot2,11)

// Se nDig for maior que 9 o digito sera zero.
If nDig2 > 9
	nDig2 := 0
EndIf

Return( Str(nDig1,1)+Str(nDig2,1) ) // Retorna a Uniao do digito 1 com o digito 2

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �EDISomaDTX� Autor � Eduardo de Souza      � Data � 31/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o valor total do manifesto por viagem              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDISomaDTX(ExpC1,ExpC2)                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 - Filial da Viagem                                   ���
���          � ExpC2 - Viagem                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function EDISomaDTX(cFilOri,cViagem)

Local aAreaDTX := DTX->(GetArea())
Local nTotDTX  := 0

DTX->(DbsetOrder(3))
DTX->(MsSeek(xFilial("DTX")+cFilOri+cViagem))
While DTX->(!Eof()) .And. DTX->DTX_FILIAL + DTX->DTX_FILORI + DTX->DTX_VIAGEM == xFilial("DTX") + cFilOri + cViagem
	nTotDTX ++
	DTX->(DbSkip())
EndDo

RestArea( aAreaDTX )

Return nTotDTX	

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �EDITipoMan� Autor � Eduardo de Souza      � Data � 31/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o valor total do manifesto por viagem              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDITipoMan(ExpC1,ExpC2)                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 - Filial da Viagem                                   ���
���          � ExpC2 - Viagem                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function EDITipoMan()

Local cFilOri := DTX->DTX_FILORI
Local cViagem := DTX->DTX_VIAGEM
Local cFilDes := ""
Local cFilDca := ""
Local cReturn := "N"

DbselectArea("DTQ")
DbSetOrder(2)
If MsSeek(xFilial("DTQ")+cFilOri+cViagem)
	
	DbSelectArea("DUN")
	DbSetOrder(1)
	If MsSeek(xFilial("DUN")+DTQ->DTQ_ROTA)
		While !Eof() .And. DUN->DUN_FILIAL + DUN->DUN_ROTEIR == xFilial("DUN") + DTQ->DTQ_ROTA
			
			cFilDes:= Posicione("DUY",1,xFilial("DUY")+DUN->DUN_CDRDES,"DUY_FILDES")
			cFilDca:= Posicione("DUY",1,xFilial("DUY")+DUN->DUN_CDRDCA,"DUY_FILDES")
			
			If cFilDes <> cFilDca
				cReturn := "T"
			EndIf			

			DUN->(DbSkip())
		EndDo
	EndIf
EndIf

Return cReturn

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �EDIVldFat � Autor � Eduardo de Souza      � Data � 31/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se o documento faz parte da fatura atual          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDIVldFat()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function EDIVldFat()

Local aAreaSE1 := SE1->(GetArea())
Local cFatura  := SE1->E1_NUM
Local lRet     := .F.

If cFatura == Posicione("SE1",2,DT6->DT6_FILDOC+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV+DT6->DT6_SERIE+DT6->DT6_DOC,"E1_FATURA")
	lRet := .T.
EndIf

RestArea( aAreaSE1 )

Return lRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � EDICgc   � Autor � Eduardo de Souza      � Data � 20/11/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o CGC sem a mascara.                               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDICgc()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function EDICgc( cCgc )

Local cRet := cCgc

cRet := StrTran( cRet, ".", "" )
cRet := StrTran( cRet, "/", "" )
cRet := StrTran( cRet, "-", "" )

Return( cRet )

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � EDIGRHER � Autor � Eduardo de Souza      � Data � 25/11/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o Grupo da Fstura da Hering                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDIGrHer()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function EDIGrHer(cCodCli,cLojCli)

Local cRet    := ""
Local cCgcRem := ""

//Posicione(Alias do Arquivo, Ordem da Chave, Chave, Campo retorno)
cCgcRem := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLojCli,"A1_CGC")

If cCgcRem == "78876950000171"
	cRet := "01"
ElseIf cCgcRem == "78876950003197"
	cRet := "02"
ElseIf cCgcRem == "82640699000704"
	cRet := "05"
ElseIf cCgcRem == "78876950004320"
	cRet := "06"
ElseIf cCgcRem == "78876950000252"
	cRet := "20"
ElseIf cCgcRem == "78876950000503"
	cRet := "24"
ElseIf cCgcRem == "78876950005300"
	cRet := "18"
EndIf

Return cRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � EDIComp  � Autor � Eduardo de Souza      � Data � 25/11/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o valor do componente.                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDIComp()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function EDIComp(cFilDoc,cDoc,cSerie,cComp)

nValPas:= Posicione("DT8",2,xFilial("DT8")+cFilDoc+cDoc+cSerie+cComp,"DT8_VALPAS")

If Empty(nValPas)
	nValPas := 0
EndIf

Return nValPas

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TMSME0101 � Autor � Eduardo de Souza      � Data � 25/11/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Para o Cliente natura:                                     ���
���          � Caso existe redespacho o destinatario da carga e o redesp. ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � TMSME1001()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function TMSME1001()

Local nPosAtu  := ParamIxb[1]
Local cCampo   := ParamIxb[2]
Local lRet     := .T.

If DE0->DE0_IDTREG == "136"
	If DE1->DE1_CAMPO == "DE5_CGCDES"
		If DEC->DEC_CODCLI + DEC->DEC_LOJCLI == "001903730001" .Or. ;
			DEC->DEC_CODCLI + DEC->DEC_LOJCLI == "716739900001" .Or. ;
			DEC->DEC_CODCLI + DEC->DEC_LOJCLI == "716739900012"
			aGrvPrinc[nPosAtu,3]:= cCampo
			lRet := .F.
		EndIf
	EndIf
EndIf

Return lRet


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TMSME0501 � Autor � Eduardo de Souza      � Data � 25/11/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza Sequencial de Arquivos da GM / Honda              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � TMSME0501()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function TMSME0501()

Local cCodCli  := DEC->DEC_CODCLI
Local cLojCli  := DEC->DEC_LOJCLI
Local aAreaDEC := DEC->(GetArea())
Local aCliGM   := {}
Local nCnt     := 0

If cCodCli+cLojCli == "592757920089" .Or. cCodCli+cLojCli == "592757920097" // GM
	aCliGM   := {{"59275792","0089"},{"59275792","0097"}}
ElseIf cCodCli+cLojCli == "043371680001" // Honda
	aCliGM   := {{"04337168","0001"}}
EndIf

DEC->(DbSetOrder(1))
For nCnt:= 1 to Len(aCliGM)
	If DEC->(MsSeek(xFilial("DEC")+aCliGM[nCnt,1]+aCliGM[nCnt,2]))
		While DEC->(!Eof()) .And. DEC->DEC_FILIAL + DEC->DEC_CODCLI + DEC->DEC_LOJCLI == ;
			xFilial("DEC") + aCliGM[nCnt,1] + aCliGM[nCnt,2]

			//-- Atualiza a Sequencia
			If DEC->(FieldPos("DEC_SEQARQ")) > 0
				RecLock("DEC",.F.)
				DEC->DEC_SEQARQ := __cEDISeqArq
				MsUnlock()
			EndIf
			DEC->(DbSkip())
		EndDo
	EndIf
Next nCnt
RestArea( aAreaDEC )

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � EDIOCOGM � Autor � Eduardo de Souza      � Data � 26/11/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o Status Code ou Shipment Delay Code               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDIOCOGM(ExpN1)                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 - 1=Status Code / 2=Shipment Delay Code              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function EDIOCOGM(nOpcao)

Local cRet    := ""
Local cCidExc := "TANGARA DA SERRA,PRIMAVERA DO LESTE,BARRA DO GARCA,SINOP"

If nOpcao == 1 //-- Status Code

	If Empty(DUA->DUA_DATOCO)
		cRet := "TR"
	ElseIf DUA->DUA_DATOCO <= DE5->DE5_DATA
		cRet := "10"
	Else
		//-- Se a data de entrega menor ou igual a 2		
		If (DUA->DUA_DATOCO - DE5->DE5_DATA) <= 2
			//-- Verifica se a cidade de calculo eh excessao
			If Upper(Alltrim(Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLICAL+DT6->DT6_LOJCAL,"A1_MUN"))) $ Upper(cCidExc)
				cRet := "10"
				If AllTrim(DUA->DUA_CODOCO) $ "045,047"
					cRet := "PF"
				ElseIf AllTrim(DUA->DUA_CODOCO) $ "003,004,008,009"
					cRet := Posicione("DE6",1,xFilial("DE6")+DEC->DEC_CODCLI+DEC->DEC_LOJCLI+DUA->DUA_CODOCO,"DE6_OCOEMB")
				ElseIf AllTrim(DUA->DUA_CODOCO) $ "006"
					cRet := Posicione("DE6",1,xFilial("DE6")+DEC->DEC_CODCLI+DEC->DEC_LOJCLI+DUA->DUA_CODOCO,"DE6_OCOEMB")
				EndIf
			Else		
				cRet := Posicione("DE6",1,xFilial("DE6")+DEC->DEC_CODCLI+DEC->DEC_LOJCLI+DUA->DUA_CODOCO,"DE6_OCOEMB")
			EndIf
		Else
			cRet := Posicione("DE6",1,xFilial("DE6")+DEC->DEC_CODCLI+DEC->DEC_LOJCLI+DUA->DUA_CODOCO,"DE6_OCOEMB")
		EndIf
		If Empty(cRet)
			cRet:= Right(Alltrim(DUA->DUA_CODOCO),2)
		EndIf
	EndIf

ElseIf nOpcao == 2 .And. DUA->DUA_DATOCO > DE5->DE5_DATA //-- Shipment Delay Code	

	//-- Justificativa da ocorrencia
	cRet:= Posicione("DE6",1,xFilial("DE6")+DEC->DEC_CODCLI+DEC->DEC_LOJCLI+DUA->DUA_CODOCO,"DE6_JUSTIF")
	
	//-- Se nao encontrou a justificativa, verifica quem foi o culpado
	If Empty(cRet)
		If Posicione("DT2",1,xFilial("DT2")+DUA->DUA_CODOCO,"DT2_RESOCO") == "1"
			cRet := "AO"
		ElseIf DT2->DT2_RESOCO == "2"
			cRet := "AE"
		EndIf
	EndIf
	
	//-- Se a data de entrega menor ou igual a 2		
	If (DUA->DUA_DATOCO - DE5->DE5_DATA) <= 2
		//-- Verifica se a cidade de calculo eh excessao
		If Upper(Alltrim(Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLICAL+DT6->DT6_LOJCAL,"A1_MUN"))) $ Upper(cCidExc)
			cRet := ""
		EndIf
	EndIf
EndIf

Return cRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �EDIVldImp � Autor � Eduardo de Souza      � Data � 02/12/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Vaida a nota referente a ocorr. foi importada              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDIVldImp()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function EDIVldImp()

Local lRet    := .F.
Local cCgcRem := Posicione("SA1",1,xFilial("SA1")+DEC->DEC_CODCLI+DEC->DEC_LOJCLI,"A1_CGC")

DE5->(DbSetOrder(1))
If DE5->(MsSeek(xFilial("DE5")+cCgcRem+DTC->DTC_NUMNFC+DTC->DTC_SERNFC))
	lRet := .T.
EndIf

Return lRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �EDIAtuPre � Autor � Eduardo de Souza      � Data � 17/12/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava o numero da pre-fatura no SE1                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDIAtuPre()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function EDIAtuPre(cNumNfc,cSerNfc,cCgcRem,cNumPre)

Local aAreaDTC := DTC->(GetArea())
Local aAreaSA1 := SA1->(GetArea())
Local cCliRem  := Posicione("SA1",3,xFilial("SA1")+cCgcRem,"A1_COD")
Local cLojRem  := SA1->A1_LOJA
Local cFilDoc  := Posicione("DTC",2,xFilial("DTC")+cNumNfc+cSerNfc+cCliRem+cLojRem,"DTC_FILDOC")
Local cDocto   := DTC->DTC_DOC
Local cSerie   := DTC->DTC_SERIE

SE1->(DbSetOrder(1))
If SE1->(MsSeek(cFilDoc+cSerie+cDocto))
	RecLock("SE1",.F.)
	SE1->E1_PFATURA := cNumPre
	MsUnlock()
EndIf

RestArea( aAreaDTC )
RestArea( aAreaSA1 )

Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �EDIBscPre � Autor � Eduardo de Souza      � Data � 17/12/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Busca o numero da pre-fatura no DEB (Pre-Fatura EDI)       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDIBscPre()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function EDIBscPre(cNumFat,cRet)

Local aAreaSE1 := SE1->(GetArea())
Local aAreaDT6 := DT6->(GetArea())
Local aAreaDTC := DTC->(GetArea())
Local cCgcRem  := ""
Local cRetorno := ""
Local cIndex   := CriaTrab(Nil,.F.)
Local cKey     := SE1->(IndexKey())
Local cFiltro  := ""

cFiltro := 'SE1->E1_FILIAL == "' + xFilial("SE1") + '" .And. '
cFiltro += 'SE1->E1_FATURA == "' + cNumFat + '"'

IndRegua("SE1",cIndex,cKey,,cFiltro)

If SE1->(!Eof())
	While SE1->(!Eof()) .And. SE1->E1_FILIAL + SE1->E1_FATURA == xFilial("SE1") + cNumFat
		cCliRem  := Posicione("DT6",1,xFilial("DT6")+SE1->E1_FILIAL+SE1->E1_NUM+SE1->E1_PREFIXO,"DT6_CLIREM")
		cLojRem  := DT6->DT6_LOJREM
		cCgcRem  := Posicione("SA1",3,xFilial("SA1")+cCliRem+cLojRem,"A1_CGC")
		cRetorno := Posicione("DEB",2,xFilial("DEB")+cCgcRem+SE1->E1_PFATURA,cRet)
		If !Empty(cRetorno)
			Exit
		EndIf
		SE1->(DbSkip())
	EndDo
EndIf

RetIndex("SE1")
cIndex += OrdBagExt()
FErase(cIndex)

RestArea( aAreaSE1 )
RestArea( aAreaDTC )
RestArea( aAreaDT6 )

Return cRetorno

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �EDIDtPIN  � Autor � Richard Anderson      � Data � 14/01/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza a data do PIN                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EDIDtPIN()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EDI                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function EDIDtPIN(cAlias)

Local cAlias2 := If(Left(cAlias,1) == "S",Substr(cAlias,2),cAlias)
Local cCampo  := ''

If (cAlias)->(FieldPos(cAlias2+"_DATPIN")) > 0
	cCampo := cAlias+"->"+cAlias2+"_DATPIN"
	If Empty(&(cCampo))
		RecLock(cAlias,.F.)
		&(cCampo) := dDataBase
		MsUnlock()
	EndIf
EndIf

Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o   � EDIRtIns  � Autor � Valdemar Roberto      � Data � 22/12/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o� Retorna a Insc Estadual caso exista mais de uma.            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe  � EDIRtIns()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Params.  � ExpC1 - "N" Nota-Fiscal ou Cliente / "D" Documento          ���
���			� ExpC2,ExpC3,ExpC4,ExpC5 - Campo do alias corrente de acordo ���
���			�com o ExpC1																  ���
���			� Expc6 - Remetente ou Destinatario ("R"/"D"/"C"/"P")         ���
���			� Expc7 - Retorno da Funcao, Inscricao Estadual do Cliente    ���
�������������������������������������������������������������������������Ĵ��
��� Uso     � SIGATMS                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function EDIRtIns(cNivel,cSeg1,cSeg2,cSeg3,cSeg4,cTipo,cRetInsc)
Local cCodCli    := ''
Local cLojCli    := ''
Local cSeqCli    := ''

If cNivel == "D" //--Se for documento
  DbSelectArea("DTC")
  DbSetOrder(3)
  If MsSeek(xFilial("DTC") + cSeg1 + cSeg2 + cSeg3)
    If cTipo == "R" //--Se for remetente
  		cCodCli := DTC->DTC_CLIREM
  		cLojCli := DTC->DTC_LOJREM 
  		cSeqCli := DTC->DTC_SQIREM
  	 ElseIf cTipo == "D"   //--Se for destinatario
  		cCodCli := DTC->DTC_CLIDES
  		cLojCli := DTC->DTC_LOJDES 
  		cSeqCli := DTC->DTC_SQIDES
  	 ElseIf cTipo == "C" .And. DTC->(FieldPos("DTC_SQICON")) > 0  //--Se for consignatario
  		cCodCli := DTC->DTC_CLICON
  		cLojCli := DTC->DTC_LOJCON 
  		cSeqCli := DTC->DTC_SQICON
  	 ElseIf cTipo == "P" .And. DTC->(FieldPos("DTC_SQIDPC")) > 0  //--Se for despachante
  		cCodCli := DTC->DTC_CLIDPC
  		cLojCli := DTC->DTC_LOJDPC 
  		cSeqCli := DTC->DTC_SQIDPC
  	 Endif	
  Endif	 
ElseIf cNivel == "N" //--Se for Notas-Fiscais ou Cliente
  DbSelectArea("DTC")
  DbSetOrder(5)
  If MsSeek(xFilial("DTC") + cSeg1 + cSeg2 + cSeg3 + cSeg4,.F.)
    If cTipo == "R"
  		cCodCli := DTC->DTC_CLIREM
  		cLojCli := DTC->DTC_LOJREM 
  		cSeqCli := DTC->DTC_SQIREM
  	 ElseIf cTipo == "D"
  		cCodCli := DTC->DTC_CLIDES
  		cLojCli := DTC->DTC_LOJDES 
  		cSeqCli := DTC->DTC_SQIDES
  	 ElseIf cTipo == "C" .And. DTC->(FieldPos("DTC_SQICON")) > 0
  		cCodCli := DTC->DTC_CLICON
  		cLojCli := DTC->DTC_LOJCON 
  		cSeqCli := DTC->DTC_SQICON
  	 ElseIf cTipo == "P" .And. DTC->(FieldPos("DTC_SQIDPC")) > 0
  		cCodCli := DTC->DTC_CLIDPC
  		cLojCli := DTC->DTC_LOJDPC 
  		cSeqCli := DTC->DTC_SQIDPC
  	 Endif	
  Endif
Endif

If Empty(cSeqCli) //Se existir apenas uma inscricao
	DbSelectArea("SA1")
   DbSetOrder(1)
	If MsSeek(xFilial("SA1") + cCodCli + cLojCli)
		cRetInsc := SA1->A1_INSCR
	Endif	
Else
	DbSelectArea("DV3")
	DbSetOrder(1)
	If MsSeek(xFilial("DV3") + cCodCli + cLojCli + cSeqCli)
		cRetInsc := DV3->DV3_INSCR
	Endif   
Endif   

Return cRetInsc
