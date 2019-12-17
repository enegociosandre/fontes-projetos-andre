#include "Protheus.ch"
#include "Rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO6     บ Autor ณ AP6 IDE            บ Data ณ  23/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function DADOSWEB(cEmp,cFil)

Private oEXPORT
Private lDrop      := .f.
Private lTudo      := .T.
Private cTimeStart := Time()
Private cTimeEnd	 := Time()
Private lSched		:= .F.

//VERIFICA SE ESTA SENDO EXECUTADO VIA MENU OU SCHEDULE
If Select("SX6") == 0
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil
	lSched		:= .T.
	RunCont()
Else
	@ 200,001 TO 380,400 DIALOG oEXPORT TITLE OemToAnsi("Copia Dados")
	@ 002,010 TO 080,190
	@ 010,018 Say " Este programa ira copiar os dados   "
	@ 018,018 Say " do ambiente selecionado para web.                             "
	
	@ 70,128 BMPBUTTON TYPE 01 ACTION (OkEXPORT(),oEXPORT:End())
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oEXPORT)
	
	Activate Dialog oEXPORT Centered
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXPORTDTC บAutor  ณMicrosiga           บ Data ณ  10/26/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OkEXPORT()

Processa({|| RunCont() },"Processando...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSINCRO    บAutor  ณMicrosiga           บ Data ณ  05/23/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunCont()


cQuery := " SELECT * FROM "+RetSqlName("SX5")
cQuery += " WHERE X5_TABELA = 'WB' AND D_E_L_E_T_ <> '*'"

MEMOWRITE("DADOSWEB.SQL",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB1", .F., .T.)
Count To nRec
//caso nao tenha dados sai da rotina
If nRec == 0
	TRB1->(dbCloseArea())
	Return
EndIf
dbSelectArea("TRB1")
dbGoTop()
If !lSched
	ProcRegua(nRec)
EndIf

While !eof()
	If !lSched
		IncProc(OemToAnsi("Tabela ")+TRB1->X5_CHAVE  )
		ProcessMessages()
	EndIf
	
	cNome := RetSqlName(TRB1->X5_CHAVE)
	If TCCanOpen(cNome)
		cChave := AllTrim(TRB1->X5_CHAVE)
		If SubStr(cChave,1,1) == "S"
			cSincD		:= SubStr(cChave,2,2) + "_SINCDT"
			cSincH		:= SubStr(cChave,2,2) + "_SINCHR"
		Else
			cSincD		:= cChave + "_SINCDT"
			cSincH		:= cChave + "_SINCHR"
		EndIf
		//COPIA OS DADOS PARA A WEB
		cQuery := "INSERT INTO   "
		cQuery += " OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=DESKTOP-C6DUM7E\SQLEXPRESS; USER ID=sa;PASSWORD =sa').database.dbo."+RetSqlName(cChave)+""
		cQuery += " OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=DESKTOP-C6DUM7E\SQLEXPRESS; USER ID=sa;PASSWORD=sa').database.dbo."+RetSqlName(cChave)+""
		cQuery += " SELECT * FROM "+RetSqlName(cChave)+" WHERE D_E_L_E_T_ <> '*' AND "+cSincD+" = '' AND "+cSincH+" = '' "
		MemoWrite("DADOSWEBa.SQL",cQuery)
		TcSqlExec(cQuery)
		//ATUALIZA CAMPOS DE SINCRONIZACAO NA BASE OFICIAL
		cQuery := " UPDATE  "+RetSqlName(cChave)+""
		cQuery += " SET "+cSincD+" = '"+dTos(Date())+"' , "+cSincH+" = '"+SubStr(Time(),1,5)+"' WHERE "+cSincH+" = '' AND  "+cSincD+" = ''"
		cQuery += " AND D_E_L_E_T_ <> '*'"
		MemoWrite("DADOSWEBb.SQL",cQuery)
		TcSqlExec(cQuery)
		
		
	EndIf
	dbSelectArea("TRB1")
	dbSkip()
End

TRB1->(dbCloseArea())

If !lSched
	Final("Finalizado com sucesso!")
Else
	Conout("Finalizado com sucesso!")
	RESET ENVIRONMENT
EndIf
Return
