#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCtaSup() º Autor ³ Cassandra J. Silvaº Data ³  05/05/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Preenche a conta superior no alias informado.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10 - TopConnect - Específico Estação Engenharia.  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fCtaSup()

Local cPerg := "CTASUP"

ValidPerg(cPerg)
If Pergunte(cPerg,.T.)	
	Processa({|| RunCont() },"Processando...")
Endif

Return Nil

Static Function RunCont()

Local nCont        := 0
Local nTotal       := 0

If MV_PAR01 == 1	
	CT1->(dbGoTop())
	nTotal := CT1->(RecCount())
	ProcRegua(nTotal)
	
	CT1->(dbGoTop())
	Do While CT1->(!Eof())
		
		nCont++
		IncProc("Aguarde processando... "+StrZero(nCont,6)+" de "+StrZero(nTotal,6))
		
		RecLock("CT1",.F.)
		CT1->CT1_CTASUP := CtbCtaSup( CT1->CT1_CONTA )
		CT1->(MsUnLock())
		
		CT1->(dbSkip())
	Enddo
	
ElseIf MV_PAR01 == 2
	CTH->(dbGoTop())
	nTotal := CTH->(RecCount())
	ProcRegua(nTotal)
	
	CTH->(dbGoTop())
	Do While CTH->(!Eof())
		
		nCont++
		IncProc("Aguarde processando... "+StrZero(nCont,6)+" de "+StrZero(nTotal,6))
		
		RecLock("CTH",.F.)
		CTH->CTH_CLSUP := CtbCLVLSup( CTH->CTH_CLVL )
		CTH->(MsUnLock())
		
		CTH->(dbSkip())
	Enddo

ElseIf MV_PAR01 == 3
	CTT->(dbGoTop())
	nTotal := CTT->(RecCount())
	ProcRegua(nTotal)
	
	CTT->(dbGoTop())
	Do While CTT->(!Eof())
		
		nCont++
		IncProc("Aguarde processando... "+StrZero(nCont,6)+" de "+StrZero(nTotal,6))
		
		RecLock("CTT",.F.)
		CTT->CTT_CCSUP := CtbCCSup( CTT->CTT_CUSTO )
		CTT->(MsUnLock())
		
		CTT->(dbSkip())
	Enddo
	
ElseIf MV_PAR01 == 4
	CTD->(dbGoTop())
	nTotal := CTD->(RecCount())
	ProcRegua(nTotal)
	
	CTD->(dbGoTop())
	Do While CTD->(!Eof())
		
		nCont++
		IncProc("Aguarde processando... "+StrZero(nCont,6)+" de "+StrZero(nTotal,6))
		
		RecLock("CTD",.F.)
		CTD->CTD_ITSUP := CtbItemSup( CTD->CTD_ITEM )
		CTD->(MsUnLock())
		
		CTD->(dbSkip())
	Enddo
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidPerg º Autor ³ Cassandra J. Silva º Data ³ 05/05/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Verifica existência do grupo de perguntas/Faz a criação.   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg(cPerg)

Local i     := 	0
Local j     := 	0
Local aRegs := 	{}
Local a     := 	.F.

SX1->(dbSetOrder(1))

cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

Aadd(aRegs,{cPerg,"01","Alias?","Alias?","Alias?","mv_ch1","N",01,0,0,"C","","mv_par01","1=CT1","1=CT1","1-CT1","","","2=CTH","2=CTH","2=CTH","","","3=CTT","3=CTT","3=CTT","","","4=CTD","4=CTD","4=CTD","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	a := SX1->(dbSeek(cPerg+aRegs[i,2]))
	RecLock("SX1",!a)
	For j := 1 to FCount()
		If 	j <= Len(aRegs[i]) .and. !( a .and. j >= 15 )
			FieldPut(j,aRegs[i,j])
		Endif
	Next
	MsUnlock()
Next

Return Nil
