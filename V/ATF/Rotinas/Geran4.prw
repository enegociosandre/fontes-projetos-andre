#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³Geran4    ºAutor  ³Totvs IP            º Data ³  01/01/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºProjeto   ³       - Mztele -                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION GERAN4()
	Local 	cFils		:=	''
	Local	cAux		:=	''
	Local	nAux		:=	0
	Local	aSelFils	:=	{}                     
	Local	nTamFil		:=	TamSX3("N3_FILIAL")[1]	
	Local	lFilSN1		:=	IIf(Empty(xFilial('SN1')),.F.,.T.)
	Local	lFilSN3		:= 	IIf(Empty(xFilial('SN3')),.F.,.T.)
	Local	lFilSN4		:= 	IIf(Empty(xFilial('SN4')),.F.,.T.)

	cFils := fSelFil()
	If Empty(cFils)
		Aviso('Seleção de Filiais','Você não selecionou nenhum filial. Processo finalizado!',{'OK'}) 
		RETURN(.F.)
	Else 
		aSelFils := {}
		nAux := 1
		While nAux != Len(cFils)+1
			cAux := SubStr(cFils,nAux,nTamFil)
			If !('*' $ cAux) && Filial não selecionada
				aAdd(aSelFils,cAux)
			EndIf
			nAux := nAux + nTamFil	
		EndDo 
	EndIf		

    For nAux := 1 to Len(aSelFils)
		dbselectarea("SN3")
		dbsetorder(1)
		dbgotop()
		dbSeek(IIf(lFilSN3,aSelFils[nAux],xFilial('SN3')))
                                                         
		cFil := IIf(lFilSN3,aSelFils[nAux],xFilial('SN3'))
		While cFil == SN3->N3_FILIAL .and. !(SN3->(EOF()))
	
			dbselectarea("SN1")
			dbsetorder(1)
			dbseek(IIf(lFilSN1,aSelFils[nAux],xFilial('SN1'))+SN3->N3_CBASE+SN3->N3_ITEM)

			If !found()
				msgStop("NAO ENCONTRADO NO SN1 "+SN3->N3_CBASE)
			Else
		
				If (reclock("SN4",.T.))			
					SN4->N4_FILIAL:=SN3->N3_FILIAL
					SN4->N4_CBASE:=SN3->N3_CBASE
					SN4->N4_ITEM:=SN3->N3_ITEM
					SN4->N4_TIPO:=SN3->N3_TIPO
					SN4->N4_OCORR:="05"
					SN4->N4_TIPOCNT:="1"
					SN4->N4_CONTA:=SN3->N3_CCONTAB
					SN4->N4_DATA:=SN3->N3_AQUISIC
					SN4->N4_QUANTD:=SN1->N1_QUANTD
					SN4->N4_VLROC1:=SN3->N3_VORIG1
					SN4->N4_VLROC2:=SN3->N3_VORIG2
					SN4->N4_VLROC3:=SN3->N3_VORIG3
					SN4->N4_VLROC4:=SN3->N3_VORIG4
					SN4->N4_VLROC5:=SN3->N3_VORIG5
					SN4->N4_SERIE:=SN1->N1_NSERIE
					SN4->N4_NOTA:=SN1->N1_NFISCAL
					SN4->N4_SEQ:="001"
					msUnlock()
				EndIf
		
				If (SN3->N3_VRDACM1 >0 .and. reclock("SN4",.T.))			
					SN4->N4_FILIAL:=SN3->N3_FILIAL
					SN4->N4_CBASE:=SN3->N3_CBASE
					SN4->N4_ITEM:=SN3->N3_ITEM
					SN4->N4_TIPO:=SN3->N3_TIPO
					SN4->N4_OCORR:="06"
					SN4->N4_TIPOCNT:="4"
					SN4->N4_CONTA:=SN3->N3_CCDEPR
					SN4->N4_DATA:=SN3->N3_AQUISIC
					SN4->N4_VLROC1:=SN3->N3_VRDACM1
					SN4->N4_VLROC2:=SN3->N3_VRDACM2
					SN4->N4_VLROC3:=SN3->N3_VRDACM3
					SN4->N4_VLROC4:=SN3->N3_VRDACM4
					SN4->N4_VLROC5:=SN3->N3_VRDACM5
					SN4->N4_TXMEDIA:=SN3->N3_VRDACM1/SN3->N3_VRDACM3
					SN4->N4_TXDEPR:=SN3->N3_TXDEPR1
					SN4->N4_SEQ:="001"
					msUnlock()
				EndIf
		
				If (SN3->N3_BAIXA == "1" .and. reclock("SN4",.T.)) && BAIXA BEM
					SN4->N4_FILIAL:=SN3->N3_FILIAL
					SN4->N4_CBASE:=SN3->N3_CBASE
					SN4->N4_ITEM:=SN3->N3_ITEM
					SN4->N4_TIPO:=SN3->N3_TIPO
					SN4->N4_OCORR:="01"
					SN4->N4_TIPOCNT:="1"
					SN4->N4_CONTA:=SN3->N3_CCONTAB
					SN4->N4_DATA:=SN3->N3_DTBAIXA
					SN4->N4_VLROC1:=SN3->N3_VORIG1
					SN4->N4_VLROC2:=SN3->N3_VORIG2
					SN4->N4_VLROC3:=SN3->N3_VORIG3
					SN4->N4_VLROC4:=SN3->N3_VORIG4
					SN4->N4_VLROC5:=SN3->N3_VORIG5
					SN4->N4_TXMEDIA:=SN3->N3_VRDACM1/SN3->N3_VRDACM3
					SN4->N4_TXDEPR:=SN3->N3_TXDEPR1
					SN4->N4_SEQ:="001"
					msUnlock()
				EndIf

				If (SN3->N3_BAIXA == "1" .and. reclock("SN4",.T.)) && BAIXA BEM ACUMULADO
					SN4->N4_FILIAL:=SN3->N3_FILIAL
					SN4->N4_CBASE:=SN3->N3_CBASE
					SN4->N4_ITEM:=SN3->N3_ITEM
					SN4->N4_TIPO:=SN3->N3_TIPO
					SN4->N4_OCORR:="01"
					SN4->N4_TIPOCNT:="4"
					SN4->N4_CONTA:=SN3->N3_CCDEPR
					SN4->N4_DATA:=SN3->N3_DTBAIXA
					SN4->N4_VLROC1:=SN3->N3_VRDACM1
					SN4->N4_VLROC2:=SN3->N3_VRDACM2
					SN4->N4_VLROC3:=SN3->N3_VRDACM3
					SN4->N4_VLROC4:=SN3->N3_VRDACM4
					SN4->N4_VLROC5:=SN3->N3_VRDACM5
					SN4->N4_TXMEDIA:=SN3->N3_VRDACM1/SN3->N3_VRDACM3
					SN4->N4_TXDEPR:=SN3->N3_TXDEPR1
					SN4->N4_SEQ:="001"
					msUnlock()
				EndIf		
			EndIf	
			dbSelectArea("SN3")
			dbSkip()
		EndDo
	Next nAux

	msgStop("Gera N4 Finalizado!")

Return()

****************************************************************************

STATIC FUNCTION fSelFil()
	Local 	cTitulo		:=	'Selecione as Filiais'
	Local	cParDef		:=	''
	Local	cRet		:=	'' 
	Local	nAux		:=	0                   
	Local	nTamFil		:=	TamSX3("CT2_FILIAL")[1]
	Local	aAreaSM0	:=	SM0->(GetArea())
	
	Private aFils:={}
	
	SM0->(dbGoTop())
	While !SM0->(EOF())
		If SM0->M0_CODIGO == cEmpAnt
			aAdd(aFils,SM0->M0_CODFIL + ' - ' + UPPER(SM0->M0_FILIAL))
		EndIf
		SM0->(dbSkip())
	EndDo	
	
	ASort(aFils)
	
	For nAux := 1 to Len(aFils)
		cParDef +=	Substr(aFils[nAux],1,nTamFil)
	Next nAux
/*
f_Opcoes
01 -> Variavel de Retorno
02 -> Titulo da Coluna com as opcoes
03 -> Opcoes de Escolha (Array de Opcoes)
04 -> String de Opcoes para Retorno
05 -> Nao Utilizado
06 -> Nao Utilizado
07 -> Se a Selecao sera de apenas 1 Elemento por vez
08 -> Tamanho da Chave
09 -> No maximo de elementos na variavel de retorno	
10 -> Inclui Botoes para Selecao de Multiplos Itens
11 -> Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
12 -> Qual o Campo para a Montagem do aOpcoes
13 -> Nao Permite a Ordenacao
14 -> Nao Permite a Pesquisa	
15 -> Forca o Retorno Como Array
16 -> Consulta F3
*/			 
	If !f_Opcoes(@cRet,cTitulo,aFils,cParDef,12,49,.F.,2,Len(aFils))  // Chama funcao f_Opcoes
		cRet:=''
	EndIF                                  
	
	RestArea(aAreaSM0)
	
RETURN(cRet)
