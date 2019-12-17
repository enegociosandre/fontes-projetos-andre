#Include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±± Programa  GP650CPO   º Autor ³ Carlos Eduardo     º Data ³  04/05/2016  ±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±± Descricao ³ PE utilizado para substituição do código do Fornecedor      ±±
±±           ³ de acordo com a definição do campo RA_ZZFORNE			   ±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±± Uso       ³ Especifico Vermeer                                          ±±
±±ÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GP650CPO()

Local aArea		:= GetArea()
Local aAreaSRA	:= SRA->(GetArea())
Local cFornec	:= ""
Local cLoja		:= ""
Local cHist		:= ""

If !Empty(RC1->RC1_MAT)
	
	dBSelectArea("SRA")
	SRA->(dBSetOrder(1))
	SRA->(dBSeek(xFilial("SRA") + RC1->RC1_MAT))
	
	cFornec := SRA->RA_ZZFORNE
	cLoja	:= SRA->RA_ZZLOJA
	cHist	:= SRA->RA_ZZDESCF
	
	If !Empty(cFornec)
		
		RC1->RC1_FORNEC	:= cFornec
		RC1->RC1_LOJA	:= cLoja
		RC1->RC1_ZZHIST	:= cHist
		
	EndIf
	
EndIf

RestArea(aAreaSRA)
RestArea(aArea)

Return()
