#INCLUDE "Eicpo558.ch"
#include "Average.ch"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 24/11/99
#include "AvPrint.ch"

#xtranslate :TIMES_NEW_ROMAN_12            => \[1\]
#xtranslate :TIMES_NEW_ROMAN_14_BOLD       => \[2\]

                         
/*/{Protheus.doc} RelComInv
// Emissao da Comercial Invoice Personalizada. EICPO558.

@author Thiago Meschiatti
@since 13/01/2016
@version undefined

@type Function
/*/
User Function RelComInv()

	Private nLinha 		:= 0
	Private nLinhaAux	:= 0
	Private oComboBo1	:= nil
	
	If ExistBlock("EICPO57S")
		ExecBlock("EICPO57S",.f.,.f.)
	EndIf

	WHILE .T.
		nPage := 0
		lpDop := .f.
		lpPag := .T.
		cHouse     := SPACE(LEN(SW6->W6_HAWB))
		cInc       := SPACE(15)
		aMsgs      := { Space(45), Space(45), Space(45), Space(45), Space(45) }
  
		cMsg:= Space(AVSX3("Y7_COD", AV_TAMANHO))  

		DEFINE MSDIALOG oDlg TITLE "Emissão da Commercial Invoice" FROM 8, 0 TO  30, 80 //"Emissão da Comercial Invoice"

		nLin   := 40.5
		nCol   := 10.0
		nOpcao := 0

		@ nLin , nCol       SAY "Processo" SIZE  35, 8
		@ nLin , nCol+40.0  GET cHouse  F3 "SW6" PICTURE "@!" VALID PO558Val() SIZE  70, 8 // - BHF
		
		nLin := nLin + 15
		@ nLin , nCol       SAY "Incoterm: " SIZE  35, 8
		@ nLin , nCol+40.0  GET cInc PICTURE "@!" VALID SIZE  70, 8 // - BHF
		
		nLin := nLin + 15
		@ nLin , nCol       SAY "Título Relatório: " SIZE  35, 8
		@ nLin , nCol+40.0  MSCOMBOBOX oComboTit VAR cComboBo1 ITEMS {"Commercial Invoice", "Proforma Invoice"} SIZE 70, 8 of oDlg PIXEL

		nLin := nLin + 25
		@ nLin , nCol       SAY STR0004          SIZE  35, 8 //"Observação"

		@ nLin , nCol+40.0 GET aMsgs[1]          SIZE 230,20
		nLin := nLin + 12
		@ nLin , nCol+40.0 GET aMsgs[2]          SIZE 230,20
		nLin := nLin + 12
		@ nLin , nCol+40.0 GET aMsgs[3]          SIZE 230,20
		nLin := nLin + 12
		@ nLin , nCol+40.0 GET aMsgs[4]          SIZE 230,20
		nLin := nLin + 12
		@ nLin , nCol+40.0 GET aMsgs[5]          SIZE 230,20
  

		nLin := nLin + 25

		DEFINE SBUTTON FROM 32,240 TYPE 6 ACTION (nOpcao:=1,oDlg:End()) ENABLE OF oDlg PIXEL

		bOk    := {||If( PO558Val(), (nOpcao:=1,oDlg:End()) , ) }
		bCancel:= {||nOpcao:=0,oDlg:End()}

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED

		If nOpcao == 1
			Processa({|| PO558Relatorio()},STR0005) //"Processando Relatorio..."
			LOOP
		EndIf
		EXIT
	EndDo

Return NIL


/*
**
*/
Static Function PO558Val()
	If Empty( cHouse )
		Help("", 1, "AVG0000117")
		Return .F.
	EndIf

	SW6->( DbSetOrder( 1 ) )
	If !SW6->( DbSeek( xFilial("SW6")+cHouse ) )
		Help("", 1, "AVG0000118")
		Return .F.
	EndIf

Return .T.


/*
**
*/
Static Function Po558Relatorio()
	Local W:=0, I:=0, X:=0, Y:=0, Z:=0
	Local cDate		:= ""
	Local cForCapa	:= ""
	Local cLojCapa	:= ""
	Local cIncoterm	:= alltrim(cInc)
	Local cDischarge:= ""
	Local nUnit		:= 0
	Private nCifTot	:= 0 
	Private nFreight:= 0 
	Private nPacking:= 0 
	Private nInsuran:= 0 
	Private nTotOthe:= 0 
	Private nTotDisc:= 0
	
	mDescri		:=''
	nNetWeight 	:=0
	nPari_1		:= 0

	cTexto:=""
	cEndeImport:=""

	nLi_Ini  := 0
	nLi_Fim  := 0
	nLi_Fim2 := 0
	
	//---------> Invoices (Itens).
	SW9->(DbSetOrder(3))
	SW9->( DbSeek( xFilial("SW9")+SW6->W6_HAWB ) )  //Declaracao
	SW8->(DbSetOrder(1))
	SW8->( DbSeek( xFilial("SW8")+SW6->W6_HAWB ) )

	//---------> P.O. (Capa).
	SW2->(DbSetOrder(1))
	SW2->( DbSeek( xFilial("SW2")+SW8->W8_PO_NUM) ) //It_Declaracao

	//---------> Importador.
	SYT->(DbSetOrder(1))
	SYT->( DbSeek( xFilial("SYT")+SW2->W2_IMPORT ) ) //Pedidos
	
	//---------> País.
	SYA->(DbSetOrder(1))
	SYA->(Dbseek( xFilial("SYA")+SYT->YT_PAIS))  //TRP-03/09/07
	cEndeImport := cEndeImport + If( !Empty(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+" - ", "")
	cEndeImport := cEndeImport + If( !Empty(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO)+" - ", "")
	cEndeImport := cEndeImport + If( !Empty(SYT->YT_PAIS  ), ALLTRIM(SYA->YA_PAIS_I  ), "")
	cEndeImport := Left( cEndeImport, Len( cEndeImport ) )

	//---------> Condicao de pagamento.
	If ! EMPTY(ALLTRIM(SW2->W2_COND_EX))
		SY6->( DbSeek( xFilial("SY6")+SW2->W2_COND_EX+STR(SW2->W2_DIAS_EX,3,0) ) )
	Else
		SY6->( DbSeek( xFilial("SY6")+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0) ) )
	EndIf

	//---------> Textos.
	cTexto :=MSMM( SY6->Y6_DESC_I,AVSX3("Y6_VM_DESI",03) )
	STRTRAN( cTexto,CHR(13)+ CHR(10)," " )

	SA2->(DbSetOrder(1))
	SB1->(DbSetOrder(1))
	SA5->(DbSetOrder(3))
	SWP->(DbSetOrder(1))

	Begin Sequence

		SW9->( DbSetOrder(3) )
		If !SW9->( DbSeek( xFilial("SW9")+SW6->W6_HAWB ) )  //Declaracao
			MsgAlert("Não há Invoice(s) cadastrada(s) para este processo.","Atenção")
			Break
		EndIf

		AVPRINT oPrn NAME STR0009 //"Commercial Invoice"

		ProcRegua(countRegs())

		oFont1 := oSend(TFont(),"New","Times New Roman",0,10,,.F.,,,,,,,,,,,oPrn )
		oFont2 := oSend(TFont(),"New","Times New Roman",0,14,,.T.,,,,,,,,,,,oPrn )

		aFontes := { oFont1, oFont2}
   
		AVPAGE
    
		SW9->( DbSetOrder(3) )
		SW9->( DbSeek( xFilial("SW9")+SW6->W6_HAWB ) )  //Declaracao
		cDate := dToc(SW6->W6_DTRECDO) //dToc(SW6->W6_DT_HAWB)
		
		//---------> Exporter.
		SA2->(DbSetOrder(1))
		SA2->( DbSeek( xFilial("SW9") + SW9->(W9_FORN + W9_FORLOJ) )) //Pedidos
		
		cForCapa := SW9->W9_FORN
		cLojCapa := SW9->W9_FORLOJ
		
		SY9->(DBSETORDER(2))
		SY9->(DBSEEK(xFilial("SY9")+ SW2->W2_DEST))
		cDischarge := STR0011 + SY9->Y9_DESCR
		
		SY9->(DBSETORDER(1))
		
		PO558CAB_INI(cDate, cForCapa, cLojCapa, cIncoterm, cDischarge)
                
		Do while ! SW9->(EOF()) .AND. SW9->W9_FILIAL == xFilial("SW9") .AND. SW9->W9_HAWB == cHouse
			
			nLinha := nLinha - 90
			nLinha := nLinha + 90
			nLi_Ini := nLinha
			PO558_CAB2()
			nPari_1 := 0
               
			If SW8->(!DbSeek(xFilial("SW8")+cHouse+SW9->W9_INVOICE+SW9->W9_FORN))
				Exit
			EndIf
       
			Do while ! SW8->(EOF()) .AND. SW8->W8_FILIAL == xFilial("SW8") .AND. SW8->W8_INVOICE == SW9->W9_INVOICE .AND. SW8->W8_FORN == SW9->W9_FORN
			
				nPacking += SW9->W9_PACKING
				nTotDisc += SW9->W9_DESCONT
				
				IncProc( STR0010 ) //"Imprimindo..."
       
				nLi_Fim:=nLinha
				PO558VerFim(1)

				SW2->(DBSEEK(xFilial("SW2")+SW8->W8_PO_NUM ) )
				SB1->(DBSEEK(xFilial("SB1")+SW8->W8_COD_I))
				SA5->(DBSEEK(xFilial("SA5")+SW8->W8_COD_I+SW8->W8_FABR+SW8->W8_FORN))
				SYG->(DBSEEK(xFilial("SYG")+SW2->W2_IMPORT+SW8->W8_FABR+SW8->W8_COD_I))
				mDescri := ''
				If !empty(SB1->B1_DESC_I)
					mDescri := MSMM(SB1->B1_DESC_I,AVSX3("B1_VM_GI",03),,,,,,"SB1")
				EndIf
				STRTRAN(mDescri,CHR(13)+CHR(10)," ")

				nLinha := nLinha + 20
           
				nUnit := retDaDi()

				oPrn:Say( nLinha ,130  , AllTrim(SW8->W8_COD_I) ,aFontes:TIMES_NEW_ROMAN_12)
				oPrn:Say( nLinha ,480  , TRANS(SW8->W8_QTDE,"@E 999,999"),aFontes:TIMES_NEW_ROMAN_12,700,,,1)
				oPrn:Say( nLinha ,640  , MEMOLINE(mDescri,30,1),aFontes:TIMES_NEW_ROMAN_12)
				oPrn:Say( nLinha ,1360 , AllTrim(SW9->W9_INVOICE) ,aFontes:TIMES_NEW_ROMAN_12)
				oPrn:Say( nLinha ,1830 , trans(nUnit,"@E 99,999,999,999.9999"),aFontes:TIMES_NEW_ROMAN_12,2500,,,1)
				oPrn:Say( nLinha ,2170 , trans(SW8->W8_QTDE*nUnit,"@E 99,999,999,999.9999"),aFontes:TIMES_NEW_ROMAN_12,3000,,,1)
				
				
				If EMPTY(nPari_1)
					nPari_1:= SW2->W2_PARID_U
				EndIf
				nNetWeight := nNetWeight + (SW8->W8_QTDE*W5Peso() )

				FOR W:=2 TO MLCOUNT(mDescri,30)
					If ! EMPTY(memoline(mDescri,30,W))
						nLinha := nLinha + 50
						nLi_Fim:=nLinha
						PO558VerFim(1)
						oPrn:Say( nLinha,640  ,memoline(mDescri,30,W), aFontes:TIMES_NEW_ROMAN_12)
					EndIf
				NEXT

				If SW3->(FieldPos("W3_ZZNRSER")) # 0  
					SW3->(DbSetOrder(8))
					SW3->(DbSeek(xFilial("SW3") + SW8->W8_PO_NUM + SW8->W8_POSICAO))
					
					nLinha := nLinha + 50
					nLi_Fim:=nLinha
					
					PO558VerFim(1)
					If  !EMPTY(SW3->W3_ZZNRSER)
						oPrn:Say( nLinha ,640 ,"S/N: "+ ALLTRIM(SW3->W3_ZZNRSER), aFontes:TIMES_NEW_ROMAN_12)
//					Else
//						oPrn:Say( nLinha ,640 ,ALLTRIM(SA5->A5_CODPRF), aFontes:TIMES_NEW_ROMAN_12)
					EndIf
				Else
					If ! EMPTY(ALLTRIM(SA5->A5_CODPRF))
						nLinha := nLinha + 50
						nLi_Fim:=nLinha
						
						PO558VerFim(1)
						oPrn:Say( nLinha ,640 ,ALLTRIM(SA5->A5_CODPRF), aFontes:TIMES_NEW_ROMAN_12)
					EndIf
				EndIf
				
				If ! EMPTY(ALLTRIM(SA5->A5_PARTOPC))
					nLinha := nLinha + 50
					nLi_Fim:=nLinha
					
					PO558VerFim(1)
					oPrn:Say( nLinha ,640 ,MEMOLINE(ALLTRIM(SA5->A5_PARTOPC),36,1), aFontes:TIMES_NEW_ROMAN_12)
					nLinha := nLinha + 50
					nLi_Fim:=nLinha
					
					PO558VerFim(1)
					oPrn:Say( nLinha ,640 ,MEMOLINE(ALLTRIM(SA5->A5_PARTOPC),36,2), aFontes:TIMES_NEW_ROMAN_12)
				EndIf
				If ! EMPTY(ALLTRIM(SYG->YG_REG_MIN))
					nLinha := nLinha + 50
					nLi_Fim:=nLinha
					
					PO558VerFim(1)
					oPrn:Say( nLinha ,640 ,ALLTRIM(SYG->YG_REG_MIN), aFontes:TIMES_NEW_ROMAN_12)
				EndIf

				nLinha := nLinha + 50
				nLi_Fim:= nLinha
				
				PO558VerFim(1)
				oPrn:Say( nLinha,640  ,STR0025+alltrim(trans(RetUnitWei(),AVSX3("W6_PESO_BR",6)+STR0013)), aFontes:TIMES_NEW_ROMAN_12) //"PESO LIQUIDO: "###" KGS" //FCD 04/07/01  //ASR 27/01/2006 - AVSX3("B1_PESO",6)
				nLinha := nLinha + 50
				
				oPrn:Say( nLinha,640  ,"NCM: " + alltrim(SW8->W8_TEC), aFontes:TIMES_NEW_ROMAN_12) //"PESO LIQUIDO: "###" KGS" //FCD 04/07/01  //ASR 27/01/2006 - AVSX3("B1_PESO",6)
				nLinha := nLinha + 50
				
				oPrn:Line( nLinha , 110, nLinha  , 2240 )
				oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )
				
				PO558VerFim(1)
				SW8->(DBSKIP())
       
			EndDo
       
			lpDop := .T.
			nLi_Fim2 := nLinha
			PO558FIM()
			
			PO558VerFim(0)
			nLinha := nLinha + 90
       
			SW9->(dbskip())
		EndDo
		
		oPrn:Box( nLinha-90, 110, nLinha, 2240)
		oPrn:Box( nLinha-89, 110, nLinha+1, 2241)
		oPrn:Box( nLinha-90 , 1880, nLinha   , 1881 )
		
		oPrn:Say( nLinha-50 , 130  ,STR0014, aFontes:TIMES_NEW_ROMAN_12) //"VALUE TOTAL"
		oPrn:Say( nLinha-50 , 2170 ,trans(nCifTot,AVSX3("W9_OUTDESP",6)), aFontes:TIMES_NEW_ROMAN_12,3000,,,1)
		
		nLi_Fim:=nLinha
		PO558VerFim(2)
		
		nLinhaAux	:= nLinha
		nLinha 		:= nLinha + 20
		PO558VerFim(3)
		
		PO558VerFim(2)
		nLinha := nLinha + 50
		
		oPrn:Say( nLinha   , 130  ,STR0016, aFontes:TIMES_NEW_ROMAN_12  ) //"FREIGHT"
		oPrn:Say( nLinha   , 2170 ,trans(nFreight,AVSX3("W9_FRETEIN",6)), aFontes:TIMES_NEW_ROMAN_12,3000,,,1) 
		
		PO558VerFim(2)
		nLinha := nLinha + 50
		
		oPrn:Say( nLinha , 130  ,STR0017, aFontes:TIMES_NEW_ROMAN_12  ) //"PACKING"
		oPrn:Say( nLinha ,2170 ,trans(nPacking,AVSX3("W9_INLAND",6)), aFontes:TIMES_NEW_ROMAN_12,3000,,,1) 
		
		PO558VerFim(2)
		nLinha := nLinha + 50
		
		oPrn:Say( nLinha , 130  ,"INSURANCE", aFontes:TIMES_NEW_ROMAN_12 ) 
		oPrn:Say( nLinha , 2170 ,trans(nInsuran,AVSX3("W9_PACKING",6)), aFontes:TIMES_NEW_ROMAN_12,3000,,,1) 
		
		PO558VerFim(2)
		nLinha := nLinha + 50
		
		oPrn:Say( nLinha , 130  ,"OTHER", aFontes:TIMES_NEW_ROMAN_12 ) 
		oPrn:Say( nLinha , 2170 ,trans(nTotOthe,AVSX3("W9_DESCONT",6)), aFontes:TIMES_NEW_ROMAN_12,3000,,,1)  
		
		PO558VerFim(2)
		nLinha := nLinha + 50
		
		oPrn:Say( nLinha , 130  ,STR0018, aFontes:TIMES_NEW_ROMAN_12) //"DISCOUNT"
		oPrn:Say( nLinha , 2170 ,trans(nTotDisc,AVSX3("W9_OUTDESP" ,6)), aFontes:TIMES_NEW_ROMAN_12,3000,,,1)
		
		nLi_Fim2:=(nLinha+50)
		PO558FIM(.t.)
		
		nLinha := nLinha + 100
		
		If ! EMPTY(aMsgs[1]+aMsgs[2]+aMsgs[3]+aMsgs[4]+aMsgs[5])
			nLinha := nLinha + 90
			oPrn:Say( nLinha, 110 , 'REMARKS:', aFontes:TIMES_NEW_ROMAN_12)
			FOR Y:=1 TO 5
				If ! EMPTY(aMsgs[Y])
					oPrn:Say( nLinha, 330, aMsgs[Y], aFontes:TIMES_NEW_ROMAN_12)
					nLinha := nLinha + 50
					PO558VerFim(0)
				EndIf
			NEXT
		EndIf
		
		nLinha := nLinha + 200
		oPrn:Say( nLinha , 800 ,"______________________________________________________", aFontes:TIMES_NEW_ROMAN_12)
		oPrn:Say( nLinha+40 , 900 ,Upper(GetNewPar("ZZ_ACOMINV", "VERMEER MANUFACTURING COMPANY")), aFontes:TIMES_NEW_ROMAN_12)
		
		nLinha := nLinha + 90
		PO558VerFim(0)
		
		AVENDPAGE
       
		AVENDPRINT

		oFont1:End()
		oFont2:End()

		cAlias:=ALIAS()

		DBSELECTAREA(cAlias)
		SA5->(DbSetOrder(1))

	End Sequence

Return NIL


/*
**
*/
Static Function PO558VerFim(PARTE2, cDate, cForCapa, cLojCapa, cIncoterm, cDischarge)

	If nLinha >= 2900
		If PARTE2 > 0
			If PARTE2 == 1
				nLi_Fim2:=nLinha
			Else
				nLi_Fim2:=(nLinha+50)
			EndIf
			PO558FIM()
		EndIf

		AVNEWPAGE

		nPage := nPage + 1
		oPrn:Say( 3100 ,1900 , STR0042+STR(nPage), aFontes:TIMES_NEW_ROMAN_12 ) //"PAGE: "
		nLinha:=100	

		If PARTE2 > 0
			nLi_fim:=nLi_Ini:= 100

			If !lpDop

				PO558_CAB2()

			Else
				oPrn:Line( nLinha+20, 110, nLinha+20  , 2240 )
			EndIf

		EndIf
		Return .T.
	ElseIf nLinha >= 2700 .and. PARTE2 == 3
		AVNEWPAGE
		nPage := nPage + 1
		
		oPrn:Say( 3100 ,1900 , STR0042+STR(nPage), aFontes:TIMES_NEW_ROMAN_12 ) //"PAGE: "
		nLinha:=100	
		Return .T.
	EndIf

Return .F.


/*
**
*/
Static Function PO558_CAB2()

	oPrn:Line( nLinha , 110, nLinha  , 2240 )
	oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )
	
	oPrn:Box( nLinha     , 110 , nLinha+60 , 111 )
	oPrn:Box( nLinha     , 400 , nLinha+60 , 401  )
	oPrn:Box( nLinha     , 630 , nLinha+60 , 631  )
	oPrn:Box( nLinha     , 1300, nLinha+60 , 1300 )
	oPrn:Box( nLinha     , 1600, nLinha+60 , 1601 )
	oPrn:Box( nLinha     , 1880, nLinha+60 , 1881 )
	oPrn:Box( nLinha     , 2240, nLinha+60 , 2241 )
	
	nLinha := nLinha + 10
	oPrn:Say( nLinha     , 140 ,"IT. NUMBER",aFontes:TIMES_NEW_ROMAN_12 )
	oPrn:Say( nLinha     , 430 ,STR0033,aFontes:TIMES_NEW_ROMAN_12 ) //"QTD."
	oPrn:Say( nLinha     , 660 ,STR0034 ,aFontes:TIMES_NEW_ROMAN_12) //"DESCRIPTION"
	oPrn:Say( nLinha     , 1360,"REF.",aFontes:TIMES_NEW_ROMAN_12 )
	oPrn:Say( nLinha     , 1630,STR0035+" "+SW9->W9_MOE_FOB ,aFontes:TIMES_NEW_ROMAN_12) //"UNIT" + Moeda
	oPrn:Say( nLinha     , 1910,STR0036+" "+SW9->W9_MOE_FOB ,aFontes:TIMES_NEW_ROMAN_12) //"TOTAL" + Moeda
	
	nLinha := nLinha + 50
	oPrn:Line( nLinha    , 110, nLinha  , 2240 )
	oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )

Return NIL


/*
**
*/
Static Function PO558FIM(lTotal)

	default lTotal := .f.

	If lTotal
		Return
	EndIf

	oPrn:Box( nLi_Fim2, 110, nLi_Fim2+1, 2240)
	oPrn:Box( nLi_Ini , 110, nLi_Fim2  , 111 )
	
	oPrn:Box( nLi_Ini , 400 , nLi_Fim2 , 401  )
	oPrn:Box( nLi_Ini , 630 , nLi_Fim2 , 631  )
	oPrn:Box( nLi_Ini , 1300, nLi_Fim2 , 1301 )
	oPrn:Box( nLi_Ini , 1600, nLi_Fim2 , 1601 )
	

	oPrn:Box( nLi_Ini , 1880, nLi_Fim2   , 1881 )
	oPrn:Box( nLi_Ini , 2240, nLi_Fim2   , 2241 )
	
Return NIL


/*
**
*/
Static Function PO558CAB_INI(cDate, cForCapa, cLojCapa, cIncoterm, cDischarge)
	Local aArea		:= GetArea()
	Local aAreaSA2	:= SA2->(GetArea())
	Local W:=0
	Local cEndExport	:= ""
		
	nLinTexto	:=0
	nPage 		:= nPage + 1
	nLinha		:=100
	
	SA2->(DBSEEK(xFilial("SA2")+ cForCapa + cLojCapa))
	cEndExport := cEndExport + If( !Empty(SA2->A2_MUN), ALLTRIM(SA2->A2_MUN)+" - ", "")
	cEndExport := cEndExport + If( !Empty(SA2->A2_ESTADO), ALLTRIM(SA2->A2_ESTADO)+" - ", "")
	cEndExport := cEndExport + If( !Empty(SA2->A2_PAIS ), ALLTRIM(E_Field("A2_PAIS","YA_DESCR",,,1)  ), "")
	cEndExport := Left( cEndExport, Len( cEndExport ) )
	
	oPrn:SayBitmap(nLinha,0130,"logo_invoice.png",0900,0350)
	nLinha := nLinha + 90
	oPrn:Say( nLinha, 	 1450, cComboBo1, aFontes:TIMES_NEW_ROMAN_14_BOLD ) //"COMMERCIAL INVOICE"
	oPrn:Say( nLinha+50, 1500, "Nº.: " + alltrim(cHouse), aFontes:TIMES_NEW_ROMAN_14_BOLD ) //"COMMERCIAL INVOICE"
	
	nLinha := nLinha + 220
	
	oPrn:Say( nLinha , 1140 , STR0038 + cDate, aFontes:TIMES_NEW_ROMAN_14_BOLD ) //"DATE: "
	nLinha := nLinha + 50
	
	oPrn:Box( nLinha     , 110  , nLinha+500, 1030 )
	oPrn:Box( nLinha     , 1100 , nLinha+500, 2020 )

	nLinha := nLinha + 30
	oPrn:Say( nLinha , 130  , "EXPORTER", aFontes:TIMES_NEW_ROMAN_12 ) //EXPORTER
	oPrn:Say( nLinha , 1140 , "IMPORTER", aFontes:TIMES_NEW_ROMAN_12 ) //EXPORTER
	nLinha := nLinha + 60
	oPrn:Say( nLinha , 130  , memoline(SA2->A2_NOME,35,1), aFontes:TIMES_NEW_ROMAN_12 ) //EXPORTER
	oPrn:Say( nLinha , 1140  , memoline(SYT->YT_NOME,35,1), aFontes:TIMES_NEW_ROMAN_12 ) //IMPORTER
	nLinha := nLinha + 40
	oPrn:Say( nLinha , 130  , memoline(SA2->A2_NOME,35,2), aFontes:TIMES_NEW_ROMAN_12 ) //EXPORTER
	oPrn:Say( nLinha , 1140  , memoline(SYT->YT_NOME,35,2), aFontes:TIMES_NEW_ROMAN_12 ) //IMPORTER

	oPrn:Say( nLinha+50 , 130  , memoline(SA2->A2_END,30,1), aFontes:TIMES_NEW_ROMAN_12 ) //EXPORTER

	oPrn:Say( nLinha+100 , 130  , memoline(SA2->A2_END,30,2), aFontes:TIMES_NEW_ROMAN_12 ) //EXPORTER
	oPrn:Say( nLinha+150 , 130  , ALLTRIM( cEndExport ), aFontes:TIMES_NEW_ROMAN_12 ) //EXPORTER
	if !empty(SA2->A2_CEP)
		oPrn:Say( nLinha+200 , 130  , TRANS(SA2->A2_CEP,'@R 99999-999' ), aFontes:TIMES_NEW_ROMAN_12 ) //EXPORTER
	endif
	if !empty(SA2->A2_CGC)
		oPrn:Say( nLinha+250 , 130  , AVSX3("A2_CGC",5) +": " + Trans(SA2->A2_CGC,AVSX3("A2_CGC",6)), aFontes:TIMES_NEW_ROMAN_12 ) //"CNPJ: " //EXPORTER
	endif
	
	oPrn:Say( nLinha+50 , 1140  , memoline(SYT->YT_ENDE,30,1), aFontes:TIMES_NEW_ROMAN_12 ) //IMPORTER

	oPrn:Say( nLinha+100 , 1140  , memoline(SYT->YT_ENDE,30,2), aFontes:TIMES_NEW_ROMAN_12 ) //IMPORTER
	oPrn:Say( nLinha+150 , 1140  , ALLTRIM( cEndeImport ), aFontes:TIMES_NEW_ROMAN_12 ) //IMPORTER
	if !empty(SYT->YT_CEP)
		oPrn:Say( nLinha+200 , 1140  , TRANS(SYT->YT_CEP,'@R 99999-999' ), aFontes:TIMES_NEW_ROMAN_12 ) //IMPORTER
	endif
	if !empty(SYT->YT_CGC)
		oPrn:Say( nLinha+250 , 1140  , AVSX3("YT_CGC",5) +": " + Trans(SYT->YT_CGC,AVSX3("YT_CGC",6)), aFontes:TIMES_NEW_ROMAN_12 ) //"CNPJ: " //IMPORTER
	endif

	nLinha := nLinha + 400
	
	oPrn:Say( nLinha+20 , 130 , STR0040, aFontes:TIMES_NEW_ROMAN_12 ) //"PAYMENT:"
	oPrn:Say( nLinha := nLinha+20 , 1250 , "DISCHARGE PORT/AIRPORT.: " + SY9->Y9_DESCR,aFontes:TIMES_NEW_ROMAN_12  ) //"DISCHARGE PORT.: "
	W:=1
	
	Do While nLinTexto <= 6 .AND. W <= MLCOUNT(cTexto,40)

		If !EMPTY(memoline(cTexto,40,W))
			oPrn:Say( nLinha, 300 , memoline(cTexto,40,W), aFontes:TIMES_NEW_ROMAN_12 )
			
			nLinTexto := nLinTexto + 1
			nLinha := nLinha + 50
		EndIf
		W := W + 1

	EndDo
	nLinha := nLinha + 30
	oPrn:Say( nLinha , 130  , "INCOTERMS:  " + cIncoterm, aFontes:TIMES_NEW_ROMAN_12 )
	oPrn:Say( nLinha , 1250 , "TOTAL NET WEIGHT:  " + alltrim(trans(retTotWei(),AVSX3("W6_PESO_BR",6))), aFontes:TIMES_NEW_ROMAN_12 )
	
	nLinha := nLinha + 80
	
	oPrn:Say( nLinha, 1250 , "TOTAL GROSS WEIGHT: " + alltrim(trans(SW6->W6_PESO_BR,AVSX3("W6_PESO_BR",6))), aFontes:TIMES_NEW_ROMAN_12 ) //"SHIPPING DATE: "
	
	nLinha := nLinha + 60
	
	oPrn:Line( nLinha, 110, nLinha  , 2240 )
	oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )

	nLinha := nLinha + 90
	oPrn:Say( 3100 ,1900 , STR0042+STR(nPage), aFontes:TIMES_NEW_ROMAN_12 ) //"PAGE: "
	
	RestArea(aAreaSA2)
	RestArea(aArea)

Return NIL


/*
** Total Net Weight
*/
Static Function retTotWei()
	Local cAlias	:= getNextAlias()
	Local nRet		:= 0

	beginSql Alias cAlias
		SELECT SUM(W7_PESO * W7_QTDE) WEIGHT
		FROM %TABLE:SW7% SW7
		WHERE W7_FILIAL = %EXP:SW6->W6_FILIAL%
		AND W7_HAWB = %EXP:SW6->W6_HAWB%
		AND SW7.%NOTDEL%
	endSql
	(cAlias)->(dbGoTop())
	
	If !(cAlias)->(eof())
		nRet := (cAlias)->WEIGHT
	EndIf
	
	(cAlias)->(dbCloseArea())
	
Return (nRet)


/*
** Retorna o Peso
*/
Static Function retUnitWei()
	Local aArea 	:= GetArea()
	Local aAreaSW7	:= SW7->(GetArea())
	Local nRet		:= 0
	
	dbSelectArea("SW7")
	SW7->(dbSetOrder(4))
	If SW7->(dbseek(SW8->(W8_FILIAL + W8_HAWB + W8_PO_NUM + W8_POSICAO + W8_PGI_NUM)))
		nRet := SW7->W7_PESO
	EndIf
	
	RestArea(aAreaSW7)
	RestArea(aArea)
Return (nRet)


/*
**
*/
Static Function retDaDi()
	Local aArea 	:= GetArea()
	Local aAreaSW7	:= SW7->(GetArea())
	Local aAreaSW6	:= SW6->(GetArea())
	Local nFrete	:= 0
	Local nSeguro	:= 0
	Local nOther	:= 0
	Local nLiqUnit	:= 0
	Local nLiqTot	:= 0
	Local nCifUnit	:= 0
	Local cAlias	:= getNextAlias()
	Local cNumProc	:= ""
	
	posicSW6()
	
	nFrete	:= SW6->W6_VLFRECC
	nSeguro := SW6->W6_VL_USSE
	nOther 	:= SW6->W6_ZZOTHER
	cNumProc:= SW6->W6_HAWB
	
	beginSql Alias cAlias
		SELECT SUM(W7_PESO * W7_QTDE) WEIGHT
		FROM %TABLE:SW7% SW7
		WHERE W7_FILIAL = %EXP:SW6->W6_FILIAL%
		AND W7_HAWB 	= %EXP:cNumProc%
		AND SW7.%NOTDEL%
	endSql
	(cAlias)->(dbGoTop())
	
	If !(cAlias)->(eof())
		nLiqTot := (cAlias)->WEIGHT
	EndIf
	
	nLiqUnit := retLiqUnit(cNumProc)
	
	nPercent 	:= nLiqUnit / nLiqTot
	nPropFret	:= nPercent * nFrete
	nPropSeg	:= nPercent * nSeguro
	nPropOth	:= nPercent * nOther
	
	nFreight	+= SW8->W8_QTDE * nPropFret
	nInsuran	+= SW8->W8_QTDE * nPropSeg
	nTotOthe	+= SW8->W8_QTDE * nPropOth
	
	nCifUnit	:= SW8->W8_PRECO + (nPropFret + nPropSeg + nPropOth)
	nCifTot		+= SW8->W8_QTDE * nCifUnit
	
	(cAlias)->(dbCloseArea())
	
	RestArea(aAreaSW6)
	RestArea(aAreaSW7)
	RestArea(aArea)
Return (nCifUnit)


/*
** Peso Liquido Unitário
*/
Static Function retLiqUnit(cNumProc)
	Local cAlias	:= getNextAlias()
	Local nRet		:= 0

	beginSql Alias cAlias
		SELECT W7_PESO
		FROM %TABLE:SW7% SW7
		WHERE W7_FILIAL	= %EXP:SW8->W8_FILIAL%
		AND W7_HAWB 	= %EXP:SW8->W8_HAWB%
		AND W7_PO_NUM	= %EXP:SW8->W8_PO_NUM%
		AND W7_POSICAO 	= %EXP:SW8->W8_POSICAO%
		AND W7_PGI_NUM 	= %EXP:SW8->W8_PGI_NUM%
		AND SW7.%NOTDEL%
	endSql
	(cAlias)->(dbGoTop())
	
	If !(cAlias)->(eof())
		nRet := (cAlias)->W7_PESO
	EndIf
	
	(cAlias)->(dbCloseArea())
Return (nRet)


/*
**Posicionar DA
*/
Static Function posicSW6()
	Local cAlias	:= getNextAlias()
	Local aAreaSW6	:= SW6->(GetArea())
	Local nRet		:= 0

	beginSql Alias cAlias
		SELECT W6_FILIAL, W6_HAWB
		FROM %TABLE:SW6% SW6
		WHERE W6_FILIAL	= %EXP:SW8->W8_FILIAL%
		AND W6_DI_NUM		= %EXP:SUBSTR(SW8->W8_PO_NUM,3,10)%
		AND SW6.%NOTDEL%
	endSql
	(cAlias)->(dbGoTop())
	
	If !(cAlias)->(eof())
		SW6->(dbSetOrder(1))
		If !SW6->(dbSeek((cAlias)->(W6_FILIAL + W6_HAWB)))
			RestArea(aAreaSW6)
		EndIf
	EndIf
	
	(cAlias)->(dbCloseArea())
	
Return


/*
** Conta registros na tabela SW8 para processamento da régua.
*/
Static Function countRegs()
	Local cAlias	:= getNextAlias()
	Local nRet		:= 0

	beginSql Alias cAlias
		SELECT COUNT(W8_FILIAL) REGS
		FROM %TABLE:SW8% SW8
		WHERE W8_FILIAL	= %xfilial:SW8%
		AND W8_HAWB 	= %EXP:cHouse%
		AND SW8.%NOTDEL%
	endSql
	(cAlias)->(dbGoTop())
	
	If !(cAlias)->(eof())
		nRet := (cAlias)->REGS
	EndIf
	
	(cAlias)->(dbCloseArea())

Return (nRet)