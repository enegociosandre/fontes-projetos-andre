#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP620CLI  ºAutor  ³Marcos Wey da Mata  º Data ³ 20/10/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se existe titulos de PIS/COFINS/CSLL no contas a   º±±
±±º          ³Receber                                                     º±±
±±º          ³                                                            º±±
±±ºObs.:     ³Necessario criar o indice abaixo com NickName: ZZLP620      º±±
±±º          ³Prefixo+No. Titulo+Tipo                                     º±±
±±º          ³E1_FILIAL+E1_PREFIXO+E1_NUM+E1_TIPO                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Lançamento padrao 620                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LP620CLI(cImp)

Local _aArea := GetArea()
Local _nRet  := 0

//Se for definido a retenção na baixa é ignorado o conteudo do fonte - alterado por Alexandre Eugenio
If Alltrim(GetMv("MV_BR10925"))=="1"
	Return
EndIf

DbSelectArea("SE1")
//DbSetOrder(27)
DbOrderNickname("ZZLP620") //alterado por Alexandre Eugenio
DbGoTop()

If cImp == "PIS"
	DbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC+"PI-")
	While !eof() .And. (SE1->E1_PREFIXO == SF2->F2_SERIE .And. SE1->E1_NUM == SF2->F2_DOC .And. SE1->E1_TIPO == "PI-")
	    	_nRet += SE1->E1_VALOR
	DBskip()
	EndDo
EndIf
     

If cImp == "COF"
	DbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC+"CF-")
	While !eof() .And. (SE1->E1_PREFIXO == SF2->F2_SERIE .And. SE1->E1_NUM == SF2->F2_DOC .And. SE1->E1_TIPO == "CF-")
	    	_nRet += SE1->E1_VALOR
	DBskip()
	EndDo
EndIf


If cImp == "CSL"
	DbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC+"CS-")
	While !eof() .And. (SE1->E1_PREFIXO == SF2->F2_SERIE .And. SE1->E1_NUM == SF2->F2_DOC .And. SE1->E1_TIPO == "CS-")
	    	_nRet += SE1->E1_VALOR
	DBskip()
	EndDo
EndIf
  
If cImp == "PCC"
	DbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC+"CF-")
	While !eof() .And. (SE1->E1_PREFIXO == SF2->F2_SERIE .And. SE1->E1_NUM == SF2->F2_DOC .And. (SE1->E1_TIPO == "PI-" .Or. SE1->E1_TIPO == "CF-" .Or. SE1->E1_TIPO == "CS-"))
	    	_nRet += SE1->E1_VALOR
	DBskip()
	EndDo
EndIf

RestArea(_aArea)

Return(_nRet)