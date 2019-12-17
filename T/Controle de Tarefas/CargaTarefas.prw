#Include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CARGATAREFASºAutor  ³DONIZETE            º Data ³  13/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este programa tem a finalidade de dar carga no controle    º±±
±±º          ³ de tarefas.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CargaTaref()

Public _cArqImp		:= "TAREFAS.DBF" + Space(50)

OkProc()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OKPROC     ºAutor  ³ Donizete          º Data ³  18/10/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de processamento.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Chamado pelo ImpCT1.                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function OkProc

Local _lYesNo := .F.

_lYesNo := MsgBox("Confirma carga das tarefas?","carga das Tarefas","YESNO")
If _lYesNo	== .F.
	Return
EndIf

// Cria o arquivo a ser descarregado o texto dos lançamentos.
Use "Tarefas" Alias TAR Exclusive New
dbGoTop()

// Inicaliza régua de processamento.
Processa({|| RunProc() },"Processando...")
Return

Static Function RunProc

// Ativa area de trabalho e define regua.
dbSelectArea("TAR")
dbGoTop()
ProcRegua(TAR->(RecCount()))

// Loop ref. a importacao dos dados.
While !Eof()
	
	IncProc()
	
	dbSelectArea("Z99")
	dbSetOrder(1)
	dbSeek(xFilial("Z99")+TAR->Z99_NUM)
	If !Found() .And. Alltrim(TAR->IMP)=="S"
		If RecLock("Z99",.T.)
			//Z99->Z99_FILIAL 	:= TAR->Z99_FILIAL
			Z99->Z99_NUM 		:= TAR->Z99_NUM
			Z99->Z99_AREA 		:= TAR->Z99_AREA
			//Z99->Z99_ROTINA 	:= TAR->Z99_ROTINA
			Z99->Z99_USRID1 	:= RETCODUSR()
			Z99->Z99_SOLIC 		:= UsrRetName(RETCODUSR())
			Z99->Z99_EMPR 		:= "M"
			Z99->Z99_DESCM 		:= FTAcento(TAR->Z99_DESCM)
			//Z99->Z99_DESCV 		:= TAR->Z99_DESCV
			Z99->Z99_USRID2 	:= RETCODUSR()
			Z99->Z99_RESP 		:= UsrRetName(RETCODUSR())
			Z99->Z99_EMPRES 	:= "M"
			Z99->Z99_PRIOR 		:= "2"
			Z99->Z99_STATUS 	:= "N"
			//Z99->Z99_NOTAM 		:= TAR->Z99_NOTAM
			//Z99->Z99_CHAM 		:= TAR->Z99_CHAM
			Z99->Z99_DTINCL 	:= dDatabase
			//Z99->Z99_DTPRV 		:= TAR->Z99_DTPRV
			//Z99->Z99_DTINI 		:= TAR->Z99_DTINI
			//Z99->Z99_DTCONC 	:= TAR->Z99_DTCONC
			//Z99->Z99_PERC 		:= TAR->Z99_PERC
			//Z99->Z99_DTFINS 	:= TAR->Z99_DTFINS
			//Z99->Z99_DTEM 		:= TAR->Z99_DTEM
			//Z99->Z99_DEPEN 		:= TAR->Z99_DEPEN
			Z99->Z99_FASE 		:= "2"
			//Z99->Z99_INT1 		:= TAR->Z99_INT1
			//Z99->Z99_INT2 		:= TAR->Z99_INT2
			//Z99->Z99_INT3 		:= TAR->Z99_INT3
			Z99->Z99_ENVSUP 	:= "N"
			msunlock()
		EndIf
	EndIf
	
	dbSelectArea("TAR")
	dbSkip()
EndDo
Alert("Carga das tarefas concluída!")
Return
