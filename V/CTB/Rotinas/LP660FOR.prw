#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP660FOR  ºAutor  ³Renato Castro  º Data ³ 17/10/2014       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se existe titulos de PIS/COFINS/CSLL no contas a   º±±
±±º          ³Pagar                                                       º±±
±±º          ³Criar indice SE2 com NickName: ZZLP660                      º±±
±±º          ³E2_FORNECE + E2_PREFIXO + E2_NUM                            º±±
±±º          ³No Lp (CT5_VLR01 informar: U_LP660FOR("cImp") onde cImp são º±±
±±º          ³"PIS", "COF", "CSL" ou "PCC) - Verificar conteudo           º±±
±±º          ³parametros no cliente!!!!!!                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Lancamento Padrao 660                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LP660FOR(cImp) // Verifica se titulo principal gerou retencao de PIS/COFINS/CSLL e desconta do Credito no Fornecedor

Local _aArea := GetArea()
Local _nRet  := 0
Local cFornec:= Alltrim(GetMv("MV_UNIAO"))
Local cNatPis:= Alltrim(GetMv("MV_PISNAT"))
Local cNatCof:= Alltrim(GetMv("MV_COFINS"))
Local cNatCsl:= Alltrim(GetMv("MV_CSLL"))
Local _aAreaSE2 := SE2->(GetArea())

//Se for definido a retenção na baixa é ignorado o conteudo do fonte
If Alltrim(GetMv("MV_BX10925"))=="1"
	Return
EndIf

DbSelectArea("SE2")
//DbSetOrder(1)   // INDICE E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO
DbOrderNickname("ZZLP660")
DbGoTop()
DbSeek(xFilial("SE2") + Padr(cFornec,Len(SE2->E2_FORNECE)) + SF1->F1_SERIE + SF1->F1_DOC )


If cImp == "PIS"
	While !Eof() .And. ( Alltrim(SE2->E2_FORNECE+SE2->E2_LOJA)=Alltrim(cFornec) .And. SE2->E2_PREFIXO=SF1->F1_SERIE .And. SE2->E2_NUM=SF1->F1_DOC )
		If Alltrim(SE2->E2_NATUREZ)$cNatPis
			_nRet += SE2->E2_VALOR
		EndIf
		DBskip()
	EndDo
EndIf

If cImp == "COF"
	While !Eof() .And. ( ALLTRIM(SE2->E2_FORNECE+SE2->E2_LOJA)=cFornec .And. SE2->E2_PREFIXO=SF1->F1_SERIE .And. SE2->E2_NUM=SF1->F1_DOC )
		If Alltrim(SE2->E2_NATUREZ)$cNatCof
			_nRet += SE2->E2_VALOR
		EndIf
		DBskip()
	EndDo
EndIf

If cImp == "CSL"
	While !Eof() .And. ( ALLTRIM(SE2->E2_FORNECE+SE2->E2_LOJA)=cFornec .And. SE2->E2_PREFIXO=SF1->F1_SERIE .And. SE2->E2_NUM=SF1->F1_DOC )
		If Alltrim(SE2->E2_NATUREZ)$cNatCsl
			_nRet += SE2->E2_VALOR
		EndIf
		DBskip()
	EndDo
EndIf

If cImp == "PCC"
	While !Eof() .And. ( ALLTRIM(SE2->E2_FORNECE+SE2->E2_LOJA)=cFornec .And. SE2->E2_PREFIXO=SF1->F1_SERIE .And. SE2->E2_NUM=SF1->F1_DOC )
		If Alltrim(SE2->E2_NATUREZ)$cNatPis //+"/"+cNatCof+"/"+cNatCsl - Comentado em 03/12/14 por Alexandre Eugenio
			_nRet += SE2->E2_VALOR
		EndIf
		DBskip()
	EndDo
EndIf

RestArea(_aArea)
RestArea(_aAreaSE2)

Return(_nRet)