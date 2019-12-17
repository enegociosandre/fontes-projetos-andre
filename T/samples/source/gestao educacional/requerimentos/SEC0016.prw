#include "rwmake.ch"                                                                                                             
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSEC0016a  บAutor  ณRafael Rodrigues    บ Data ณ  28/jun/02  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRegra para gravacao da Grade Curricular do Aluno para       บฑฑ
ฑฑบ          ณanalise.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณNenhum.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณExpL1 : Informando se obteve sucesso                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional - Requerimentos                          บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEC0016a()
local lRet		:= .F.
local cNumRA	:= PadR( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local aScript	:= ACScriptReq( JBH->JBH_NUM )
local cCurVer	:= Iif(Len(aScript) > 6, aScript[7]+aScript[9], aScript[3]+aScript[5])

JCT->( dbSetOrder(1) )	// JCT_FILIAL+JCT_NUMREQ+JCT_PERLET+JCT_HABILI+JCT_DISCIP

JC7->( dbSetOrder(3) )	// JC7_FILIAL+JC7_NUMRA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL

JAY->( dbSetOrder(1) )	// JAY_FILIAL+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS
JAY->( dbSeek( xFilial("JAY")+cCurVer, .T. ) )

while !JAY->( eof() ) .and. JAY->JAY_FILIAL+JAY->JAY_CURSO+JAY->JAY_VERSAO == xFilial("JAY")+cCurVer
	
	if JCT->( dbSeek( xFilial("JCT") + JBH->JBH_NUM + JAY->JAY_PERLET + JAY->JAY_HABILI + JAY->JAY_CODDIS ) )
		JAY->( dbSkip() )
		loop
	endif
	
	RecLock("JCT", .T.)
	JCT->JCT_FILIAL	:= xFilial("JCT")
	JCT->JCT_NUMREQ	:= JBH->JBH_NUM
	JCT->JCT_PERLET	:= JAY->JAY_PERLET
	JCT->JCT_HABILI := JAY->JAY_HABILI
	JCT->JCT_DISCIP	:= JAY->JAY_CODDIS
	
	if JC7->( dbSeek( xFilial("JC7") + cNumRA + JAY->JAY_CODDIS ) ) .and. JC7->JC7_SITUAC $ "82"
		JCT->JCT_SITUAC	:= "003"
	else
		JCT->JCT_SITUAC	:= "010"
	endif
	
	JCT->(msUnlock())
	
	JAY->( dbSkip() )
	
end

if JCT->( dbSeek( xFilial("JCT") + JBH->JBH_NUM ) )
	RecLock("JCS", .T.)
	JCS->JCS_FILIAL	:= xFilial("JCS")
	JCS->JCS_NUMREQ	:= JBH->JBH_NUM
	JCS->JCS_CURPAD	:= Iif(Len(aScript) > 6, aScript[7], aScript[3])
	JCS->JCS_VERSAO	:= Iif(Len(aScript) > 6, aScript[9], aScript[5])
	JCS->(msUnlock())
	
	lRet := .T.
else
	MsgStop("Nใo foi possํvel preparar a grade curricular para este aluno.")
endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSEC0016b  บAutor  ณRafael Rodrigues    บ Data ณ  28/jun/02  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSe o aluno tiver a grade curricular avaliada e aprovar a    บฑฑ
ฑฑบ          ณmatricula, esta regra sera utilizada para reservar a vaga   บฑฑ
ฑฑบ          ณdo mesmo.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณNenhum.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณExpL1 : Informando se obteve sucesso                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional - Requerimentos                          บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR  ณ DATA   ณ BOPS ณ  MOTIVO DA ALTERACAO                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณIcaro Queiroz ณ06/10/06ณ103072ณSe o parametro MV_ACDPMX nao existir ou ณฑฑ
ฑฑณ              ณ        ณ106146ณestiver como .F., continuara sendo feitoณฑฑ
ฑฑณ              ณ        ณ      ณo retorno do aluno normalmente, mas casoณฑฑ
ฑฑณ              ณ        ณ      ณcontrario nao sera atribuido a nota as  ณฑฑ
ฑฑณ              ณ        ณ      ณdisciplinas na JCT, visto que a nota ja ณฑฑ
ฑฑณ              ณ        ณ      ณfoi atribuiada na analise de grade.     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SEC0016b()
local cNumRA	:= PadR( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local lVaga		:= .F.
local aRet      := ACScriptReq( JBH->JBH_NUM )
Local nA		:= 0
Local cTipo		:= ""
Local cSerie    := ""
Local cSituacao := ""
Local cKitMat	:= ""
Local nRecno	:= 0 
Local nRecJBE	:= 0
Local cQuery	:= ""
Local cArqTrb   := CriaTrab(,.F.) 
Local cPerAtu   := ""
Local cMemo1	:= ""                                                                      
Local lJCTJust		:= If(Posicione("SX3",2,"JCT_JUSTIF","X3_CAMPO" )=="JCT_JUSTIF",.T.,.F.)
Local lJCOJust		:= If(Posicione("SX3",2,"JCO_JUSTIF","X3_CAMPO" )=="JCO_JUSTIF",.T.,.F.)

JA2->( dbSetOrder(1) )
JA2->( dbSeek(xFilial("JA2")+cNumRA) )

JCS->( dbSetOrder(1) )	// JCS_FILIAL+JCS_NUMREQ
JCS->( dbSeek(xFilial("JCS")+JBH->JBH_NUM) )

JAR->( dbSetOrder(1) )
JAR->( dbSeek(xFilial("JAR")+JCS->JCS_CURSO+JCS->JCS_SERIE+JCS->JCS_HABILI) )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se existe vaga disponํvel no curso desejadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if !AcaVerJAR(JCS->JCS_CURSO, JCS->JCS_SERIE, JCS->JCS_HABILI, 4)
	MsgStop("Nใo existe vaga disponํvel neste curso.")
	Return .F.
endif

JBO->( dbSetOrder(1) )
JBO->( dbSeek(xFilial("JBO") + JCS->JCS_CURSO + JCS->JCS_SERIE + JCS->JCS_HABILI ) )

while !JBO->( eof() ) .and. JBO->JBO_FILIAL+JBO->JBO_CODCUR+JBO->JBO_PERLET+JBO->JBO_HABILI== xFilial("JBO")+JCS->JCS_CURSO+JCS->JCS_SERIE+JCS->JCS_HABILI
	
	if AcaVerJBO(JAR->JAR_CODCUR, JAR->JAR_PERLET, JAR->JAR_HABILI, JBO->JBO_TURMA, 4)
		lVaga := .T.
		exit
	endif
	
	JBO->( dbSkip() )
end

if !lVaga
	MsgStop("Nใo existe vaga disponํvel em nenhuma turma deste curso.")
	Return .F.
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Procura o ultimo tipo de curso (1=Regula;2=Somente dependencia;3=Regular-Acao Judicial,  ณ
//ณ antes de trancar/desistir da matricula                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
JBE->( dbSetOrder( 1 ) )
JBE->( dbSeek( xFilial( "JBE" ) + cNumRA + aRet[1] ) )

while JBE->( ! EoF() .and. JBE_FILIAL + JBE_NUMRA + JBE_CODCUR == xFilial("JBE") + cNumRA + aRet[1] )
	if JBE->JBE_ATIVO $ "125"	// 1=Sim;2=Nao;5=Formado
		cTipo   := JBE->JBE_TIPO
		cKitMat := JBE->JBE_KITMAT
		Exit
	endif
	JBE->( dbSkip() )
end

if Empty( cTipo ) .or. cTipo $ "25"
	cTipo := "1"
endif

if Empty( cKitMat )
	cKitMat := "2"
endif

begin transaction

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณReserva a vagaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ACFazReserva( JCS->JCS_CURSO, JCS->JCS_SERIE, JCS->JCS_HABILI, JCS->JCS_TURMA, "", .F. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o aluno no JBEณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

JBE->( dbSetOrder(1) )

For nA := 1 To Val(JCS->JCS_SERIE)
	
	cSerie := StrZero(nA,TamSX3("JBE_PERLET")[1])
	
	if JBE->( dbSeek( xFilial("JBE")+cNumRA+JCS->JCS_CURSO+cSerie+JCS->JCS_HABILI ) ) .and.	Val(JCS->JCS_SERIE) > nA
		loop
	elseif !JBE->( dbSeek( xFilial("JBE")+cNumRA+JCS->JCS_CURSO+cSerie+JCS->JCS_HABILI ) )
		
		JAR->( dbSetOrder(1) )
		JAR->( dbSeek(xFilial("JAR")+JCS->JCS_CURSO+cSerie+JCS->JCS_HABILI ) )
		
		RecLock("JBE", .T.)
		JBE->JBE_FILIAL := xFilial("JBE")
		JBE->JBE_NUMRA  := cNumRA
		JBE->JBE_CODCUR := JCS->JCS_CURSO
		JBE->JBE_PERLET := cSerie
		JBE->JBE_HABILI := JCS->JCS_HABILI
		JBE->JBE_TURMA  := JBO->JBO_TURMA
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Tratamento para SubTurmas													       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		If JBE->( FieldPos( "JBE_SUBTUR" ) ) > 0
			JBE->JBE_SUBTUR := JCS->JCS_SUBTUR		
		Endif
		JBE->JBE_TIPO   := iif( cTipo # "1", cTipo, "1" )  // Periodo Letivo Normal
		If cSerie == JCS->JCS_SERIE
			JBE->JBE_SITUAC := if( Posicione("JB5",1,xFilial("JB5")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI+"01", "JB5_MATPAG") == "1" .and. Posicione("JAH",1,xFilial("JAH")+JCS->JCS_CURSO,"JAH_VALOR") == "1", "1", "2" )	// 1=PreMatricula; 2=Matricula
			JBE->JBE_ATIVO  := if( JBE->JBE_SITUAC == "1", "2", "1" )   // 1=Sim; 2=Nao
			nRecJBE := JBE->( Recno() )
		Else
			JBE->JBE_SITUAC := "2"  // 1=Pre-Matricula; 2=Matricula
			JBE->JBE_ATIVO  := "2"  // 1=Sim; 2=Nao
		EndIf
		JBE->JBE_DTMATR := dDataBase
		JBE->JBE_ANOLET := JAR->JAR_ANOLET
		JBE->JBE_PERIOD := JAR->JAR_PERIOD
		JBE->JBE_TPTRAN := "006"
		JBE->JBE_KITMAT := cKitMat
		JBE->(MsUnLock())
	endif
	
	JCT->( dbSetOrder(1) )	// JCT_FILIAL+JCT_NUMREQ+JCT_PERLET+JCT_HABILI+JCT_DISCIP
	JCT->( dbSeek(xFilial("JCT")+JBH->JBH_NUM + cSerie + JCS->JCS_HABILI) )
	While !JCT->( eof() ) .and. JCT->JCT_NUMREQ == JCS->JCS_NUMREQ .and. JCT->JCT_PERLET == cSerie .and. JCT->JCT_HABILI == JCS->JCS_HABILI
		
		cSituacao := If( JCT->JCT_SITUAC == "003", "8", iif( JCT->JCT_SITUAC == "001", "A", "1" ) )
		nRecno := 0
		
		If JCT->JCT_SITUAC $ "010;002;006" .and. Val( JCT->JCT_PERLET ) < Val( JCS->JCS_SERIE )
			JC7->( dbSetOrder( 3 ) )
			JC7->( dbSeek( xFilial( "JC7" ) + cNumRA + JCT->JCT_DISCIP ) )
			Do While JC7->( ! EoF() .and. JC7_NUMRA + JC7_DISCIP == cNumRA + JCT->JCT_DISCIP )
				If JC7->JC7_SITDIS $ "001;010;002;006" .and. JC7->JC7_SITUAC $ "345"
					nRecno := JCT->(Recno())
					cSituacao := JC7->JC7_SITUAC
				EndIf
				JC7->( dbSkip() )
			EndDo
		EndIF
		
		If nRecno > 0 .And. GetNewPar( "MV_ACDPMX", .F. ) == .F.
			JCT->( dbGoto(nRecno) )
			JCT->(RecLock("JCT",.F.))
			JCT->JCT_MEDFIM := JC7->JC7_MEDFIM
			JCT->JCT_MEDCON := JC7->JC7_MEDCON
			JCT->(MsUnlock())
		EndIF
		
		JC7->( dbSetOrder(1) )
		JCO->( dbSetOrder(1) )
		JBL->( dbSetOrder(1) )	// JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS
		JBL->( dbSeek(xFilial("JBL")+JCS->JCS_CURSO+JCT->JCT_PERLET+JCT->JCT_HABILI+JBE->JBE_TURMA+JCT->JCT_DISCIP) )
		
		While JBL->( !eof() .and. JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS == xFilial("JBL")+JCS->JCS_CURSO+JCT->JCT_PERLET+JCT->JCT_HABILI+JBE->JBE_TURMA+JCT->JCT_DISCIP )
			if JC7->( !dbSeek( xFilial("JC7")+cNumRA+JBE->( JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA )+JCT->JCT_DISCIP ) )
				RecLock("JC7", .T.)
			Else
				RecLock("JC7",.F.)
			Endif
			
			JC7->JC7_FILIAL := xFilial("JC7")
			JC7->JC7_NUMRA  := cNumRA
			JC7->JC7_CODCUR := JBE->JBE_CODCUR
			JC7->JC7_PERLET := JBE->JBE_PERLET
			JC7->JC7_HABILI := JBE->JBE_HABILI
			JC7->JC7_TURMA  := JBE->JBE_TURMA
			JC7->JC7_DISCIP := JCT->JCT_DISCIP
			JC7->JC7_SITDIS := JCT->JCT_SITUAC
			JC7->JC7_DIASEM := JBL->JBL_DIASEM
			JC7->JC7_CODHOR := JBL->JBL_CODHOR
			JC7->JC7_HORA1  := JBL->JBL_HORA1
			JC7->JC7_HORA2  := JBL->JBL_HORA2
			JC7->JC7_CODPRF := JBL->JBL_MATPRF
			JC7->JC7_CODPR2 := JBL->JBL_MATPR2
			JC7->JC7_CODPR3 := JBL->JBL_MATPR3
			JC7->JC7_CODPR4 := JBL->JBL_MATPR4
			JC7->JC7_CODPR5 := JBL->JBL_MATPR5
			JC7->JC7_CODPR6 := JBL->JBL_MATPR6
			JC7->JC7_CODPR7 := JBL->JBL_MATPR7
			JC7->JC7_CODPR8 := JBL->JBL_MATPR8
			JC7->JC7_CODLOC := JBL->JBL_CODLOC
			JC7->JC7_CODPRE := JBL->JBL_CODPRE
			JC7->JC7_ANDAR  := JBL->JBL_ANDAR
			JC7->JC7_CODSAL := JBL->JBL_CODSAL
			JC7->JC7_SITUAC := cSituacao
			JC7->JC7_MEDFIM := JCT->JCT_MEDFIM
			JC7->JC7_MEDCON := JCT->JCT_MEDCON
			JC7->JC7_CODINS := JCT->JCT_CODINS
			JC7->JC7_ANOINS := JCT->JCT_ANOINS
			if JC7->( FieldPos( "JC7_TIPCUR" ) ) > 0 .and. JCT->( FieldPos( "JCT_TIPCUR" ) ) > 0
				JC7->JC7_TIPCUR := JCT->JCT_TIPCUR
			endif     
			JC7->( MsUnLock() )
			
			if JC7->JC7_SITUAC == "8" .and. JCO->( !dbSeek( xFilial("JCO")+JC7->(JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_HABILI+JC7_DISCIP) ) )
				RecLock("JCO", .T.)
				JCO->JCO_FILIAL := xFilial("JCO")
				JCO->JCO_NUMRA  := JC7->JC7_NUMRA
				JCO->JCO_CODCUR := JC7->JC7_CODCUR
				JCO->JCO_PERLET := JC7->JC7_PERLET
				JCO->JCO_HABILI := JC7->JC7_HABILI
				JCO->JCO_DISCIP := JC7->JC7_DISCIP
				JCO->JCO_MEDFIM := JC7->JC7_MEDFIM
				JCO->JCO_MEDCON := JC7->JC7_MEDCON
				JCO->JCO_CODINS := JC7->JC7_CODINS
				JCO->JCO_ANOINS := JC7->JC7_ANOINS
				if JCO->( FieldPos( "JCO_TIPCUR" ) ) > 0 .and. JC7->( FieldPos( "JC7_TIPCUR" ) ) > 0
					JCO->JCO_TIPCUR := JC7->JC7_TIPCUR
				endif                                                                      

				if lJCOJust .and. lJCTJust
					cMemo1 := JCT->( MSMM( JCT_MEMO1 ) )
					JCO->( MSMM(,TamSx3("JCO_JUSTIF")[1],,cMemo1,1,,,"JCO","JCO_MEMO1") )		// Justificativa de dispensa
				endif
				JCO->( MsUnLock() )
			endif
			JBL->( dbSkip() )
		end
		JCT->( dbSkip() )
	end
Next nA


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera aproveitamentos na JCO para periodos futuros, que ainda nao estarao na JC7 do aluno.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "select JCT_DISCIP, "
cQuery += "       JCT_SITUAC, "
cQuery += "       JCT_MEDFIM, "
cQuery += "       JCT_MEDCON, "
cQuery += "       JCT_CODINS, "
cQuery += "       JCT_ANOINS, "                 

if JCT->( FieldPos("JCT_TIPCUR") ) > 0
	cQuery += "   JCT_TIPCUR, "
endif
cQuery += "       JCT_HABILI, "
cQuery += "       JCT_PERLET "
cQuery += "  from "
cQuery +=         RetSQLName("JCT")+" JCT "
cQuery += " where JCT_FILIAL = '"+xFilial("JCT")+"' "
cQuery += "   and JCT_NUMREQ = '"+JCS->JCS_NUMREQ+"' "
cQuery += "   and JCT_SITUAC in ('003','011') "
cQuery += "   and JCT_DISCIP not in ( select JCO_DISCIP "
cQuery += "                             from "
cQuery +=                                    RetSQLName("JCO")+" JCO "
cQuery += "                            where JCO_FILIAL = '"+xFilial("JCO")+"' "
cQuery += "                              and JCO_NUMRA  = '"+cNumRA+"' "
cQuery += "                              and JCO_CODCUR = '"+JCS->JCS_CURSO+"' "
cQuery += "                              and JCO_PERLET = '"+JCS->JCS_SERIE+"' "
cQuery += "                              and JCO_HABILI = '"+JCS->JCS_HABILI+"' "
cQuery += "                              and JCO_DISCIP = JCT_DISCIP "
cQuery += "                              and D_E_L_E_T_ <> '*' ) "
cQuery += "   and D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb, .F., .F. )

JCO->( dbSetOrder(1) )	//JCO_FILIAL+JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_DISCIP
while (cArqTrb)->( !eof() )
	if JCO->( !dbSeek( xFilial("JCO")+cNumRA+JCS->JCS_CURSO+(cArqTrb)->( JCT_PERLET+JCT_HABILI+JCT_DISCIP ) ) )
		RecLock("JCO", .T.)
		JCO->JCO_NUMRA  := cNumRA
		JCO->JCO_CODCUR := JCS->JCS_CURSO
		JCO->JCO_PERLET := (cArqTrb)->JCT_PERLET
		JCO->JCO_DISCIP := (cArqTrb)->JCT_DISCIP
		JCO->JCO_HABILI := (cArqTrb)->JCT_HABILI
		JCO->JCO_MEDFIM := (cArqTrb)->JCT_MEDFIM
		JCO->JCO_MEDCON := (cArqTrb)->JCT_MEDCON
		JCO->JCO_CODINS := (cArqTrb)->JCT_CODINS
		JCO->JCO_ANOINS := (cArqTrb)->JCT_ANOINS
		if JCO->( FieldPos( "JCO_TIPCUR" ) ) > 0 .and. JCT->( FieldPos( "JCT_TIPCUR" ) ) > 0
			JCO->JCO_TIPCUR := (cArqTrb)->JCT_TIPCUR
		endif
		if lJCOJust .and. lJCTJust
			cMemo1 := (cArqTrb)->( MSMM( JCT_MEMO1 ) )
			JCO->( MSMM(,TamSx3("JCO_JUSTIF")[1],,cMemo1,1,,,"JCO","JCO_MEMO1") )		// Justificativa de dispensa
		endif
		JCO->( msUnlock() )
	endif
	(cArqTrb)->( dbSkip() )
end

If aRet[1] # JCS->JCS_CURSO
	JBE->( dbSetOrder( 1 ) )
	JBE->( dbSeek( xFilial( "JBE" ) + cNumRA + aRet[1] ) )
	While JBE->( !EoF() .And. JBE_FILIAL + JBE_NUMRA + JBE_CODCUR == xFilial( "JBE" ) + cNumRA + aRet[1] )
	     
		If JBE->JBE_ATIVO == "1"
			If ExistBlock("ACAtAlu1")
				U_ACAtAlu1("JBE")
			EndIf
			
			RecLock( "JBE", .F. )
			JBE->JBE_NUMREQ := JBH->JBH_NUM
			JBE->JBE_ATIVO  := "2"
			JBE->(MsUnlock())
			
			If ExistBlock("ACAtAlu2")
				U_ACAtAlu2("JBE")
			EndIf
		EndIf	     
		JBE->( dbSkip() )
	EndDo
	
Else
	
	JBE->( dbSetOrder( 1 ) )
	if JBE->( dbSeek( xFilial( "JBE" ) + cNumRA + aRet[1] ) )
		While JBE->( !EoF() .And. JBE_FILIAL + JBE_NUMRA + JBE_CODCUR == xFilial( "JBE" ) + cNumRA + aRet[1] )
			cPerAtu := JBE->JBE_PERLET
			JBE->( dbSkip() )
		EndDo
		
		if JBE->( dbSeek( xFilial( "JBE" ) + cNumRA + aRet[1] + cPerAtu ) )
			RecLock( "JBE", .F. )    
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Tratamento para SubTurmas													       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
			If JBE->( FieldPos( "JBE_SUBTUR" ) ) > 0
				JBE->JBE_SUBTUR := JCS->JCS_SUBTUR		
			Endif
			JBE->JBE_ATIVO  := "1"
			JBE->(MsUnlock())
		endif
		
	Endif
	
EndIf

if nRecJBE == 0
	cQuery := "Select R_E_C_N_O_ as REC "
	cQuery += "  from " + RetSQLName("JBE")
	cQuery += " where JBE_FILIAL = '"+xFilial("JBE")+"' "
	cQuery += "   and JBE_NUMRA  = '"+cNumRa+"' "
	cQuery += "   and JBE_CODCUR = '"+JCS->JCS_CURSO+"' "
	cQuery += "   and JBE_PERLET = '"+JCS->JCS_SERIE+"' "
	cQuery += "   and JBE_HABILI = '"+JCS->JCS_HABILI+"' "
	cQuery += "   and D_E_L_E_T_ <> '*' "
	cQuery += " order by JBE_DTMATR desc "
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .t., "TopConn", TCGenQry(,,cQuery),"QRYJBE", .F., .F. )
	TCSetField( "QRYJBE", "REC" , "N", 10, 0 )
	if QRYJBE->( !eof() )
		nRecJBE := QRYJBE->REC
	endif
	QRYJBE->( dbCloseArea() )
	dbSelectArea("JBH")
endif

dbSelectArea("JBE")
JBE->( dbGoTo( nRecJBE ) )
if ! (JBE->JBE_TIPO $ "36")		// Regular-Acao Judicial
	if JBE->( AcBloq( JBE_NUMRA, JBE_CODCUR, StrZero(Val(JBE_PERLET)-1,2), JBE_HABILI, Posicione("JAR",1, xFilial("JAR")+JBE_CODCUR+StrZero(Val(JBE_PERLET)-1,2),"JAR_DPMAX") ) )
		RecLock("JBE",.F.)
		JBE->JBE_TIPO := iif( JBE->JBE_TIPO == "1", "2", iif( JBE->JBE_TIPO == "4", "5", JBE->JBE_TIPO ) ) // 1=Regular;2=Dependencia
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Tratamento para SubTurmas													       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		If JBE->( FieldPos( "JBE_SUBTUR" ) ) > 0
			JBE->JBE_SUBTUR := JCS->JCS_SUBTUR		
		Endif
		JBE->( msUnlock() )
		
		JC7->( dbSetOrder(1) ) // JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1
		JC7->( dbSeek( xFilial("JC7")+ JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA ) ) )
		while JC7->( !eof() .and. JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JBE->JBE_HABILI+JC7_TURMA == xFilial("JC7")+ JBE->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA ) )
			If JC7->JC7_SITUAC $ "123456A"				
				RecLock("JC7",.F.)
				JC7->JC7_SITUAC := if( JC7->JC7_SITDIS $ "010", "A", if( JC7->JC7_SITDIS $ "003/011", "8", if( JC7->JC7_SITUAC == "A", "1", JC7->JC7_SITUAC ) ) )
				JC7->( msUnlock() )      

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Tratamento para SubTurmas													       ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
				If JBE->( FieldPos( "JBE_SUBTUR" ) ) > 0			 				
					JBL->( dbSetOrder(1) )	// JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS  
					JBL->( dbSeek(xFilial("JBL")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI+JBE->JBE_TURMA+JC7->JC7_DISCIP) )
				
					While JBL->( !eof() .and. JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS == xFilial("JBL")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI+JBE->JBE_TURMA+JC7->JC7_DISCIP )
						If JBL->JBL_SUBTUR == JBE->JBE_SUBTUR
							RecLock("JC7",.F.)
							JC7->JC7_SUBTUR := JBE->JBE_SUBTUR
							JC7->( msUnlock() )	
						Endif   
						JBL->( dbSkip() )		
					End    
				Endif
								
			endif
			JC7->( dbSkip() )
		end
	else
		JBE->( AcDesbloq( JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA ) ) 
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Tratamento para SubTurmas													       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		If JBE->( FieldPos( "JBE_SUBTUR" ) ) > 0			 
			JBL->( dbSetOrder(1) )	// JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA+JBL_CODDIS    
			JC7->( dbSetOrder(1) ) // JC7_FILIAL+JC7_NUMRA+JC7_CODCUR+JC7_PERLET+JC7_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1
			JBL->( dbSeek(xFilial("JBL")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI+JBE->JBE_TURMA) )
			
			While JBL->( !eof() .and. JBL_FILIAL+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA == xFilial("JBL")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI+JBE->JBE_TURMA )
				if JC7->( dbSeek( xFilial("JC7")+cNumRA+JBE->( JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA )+JBL->JBL_CODDIS ) )
					If JBL->JBL_SUBTUR == JBE->JBE_SUBTUR
						RecLock("JC7",.F.)
						JC7->JC7_SUBTUR := JBE->JBE_SUBTUR
						JC7->( msUnlock() )						
					Endif						
				Endif
				JBL->( dbSkip() )
			end

		Endif
	endif
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ So atualiza documentos se houve mudan็a de curso vigenteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if aRet[1] <> JBE->JBE_CODCUR
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava os documentos do novo curso, aproveitando os ja entregues no curso de origem.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AcGeraDoc(JBE->JBE_NUMRA, JBE->JBE_CODCUR, aRet[1])
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Exclui os documentos do curso antigo.                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	JC6->( dbSetOrder(2) )  // Curso Vigente + RA + Documento
	JC6->( dbSeek(xFilial("JC6")+aRet[1]+JBE->JBE_NUMRA) )
	
	While JC6->( !eof() .and. JC6_FILIAL+JC6_CODCUR+JC6_NUMRA == xFilial("JC6")+aRet[1]+JBE->JBE_NUMRA )
		RecLock("JC6", .F.)
		JC6->( dbDelete() )
		JC6->( msUnLock() )
		
		JC6->( dbSkip() )
	End
endif

AC680BOLET(JA2->JA2_PROSEL,"010",JA2->JA2_NUMRA,JA2->JA2_NUMRA,JCS->JCS_CURSO,JCS->JCS_CURSO,1,JCS->JCS_SERIE,JBO->JBO_TURMA,,,,,,,JCS->JCS_HABILI)

end transaction

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSEC0016c  บAutor  ณRafael Rodrigues    บ Data ณ  28/jun/02  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da tela de script.                                บฑฑ
ฑฑบ          ณVerifica se o status do aluno eh cancelado ou desistencia.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณNenhum.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณExpL1 : Informando se pode incluir o requerimento           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional - Requerimentos                          บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEC0016c(lweb)
local lRet		:= .F.
Local aRet      := {}
local cNumRA	:= Padr( M->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )

lWeb := IIf(lWeb == NIL, .F., lWeb)

JBE->( dbSetOrder(3) )	// Filial + Ativo + RA + Curso
lRet := lRet .or. JBE->( dbSeek(xFilial("JBE")+"4"+cNumRA+M->JBH_SCP01) ) .or.;
                  JBE->( dbSeek(xFilial("JBE")+"7"+cNumRA+M->JBH_SCP01) ) .or.;
                  JBE->( dbSeek(xFilial("JBE")+"9"+cNumRA+M->JBH_SCP01) )           
If ! lRet
	If lWeb
		aadd(aRet,{.F.,"Este curso nใo encontra-se com TRANCAMENTO, DESISTสNCIA ou DษBITOS FINANCEIROS para este aluno."})
		aadd(aRet,{.F.,"O retorno do aluno s๓ ้ possํvel nessas situa็๕es."})
		Return aRet
	Else
		MsgStop("Este curso nใo encontra-se com TRANCAMENTO, DESISTสNCIA ou DษBITOS FINANCEIROS para este aluno."+Chr(13)+Chr(10)+;
		"O retorno do aluno s๓ ้ possํvel nessas situa็๕es.")
	Endif
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SEC0016d บAutor  ณ Gustavo Henrique   บ Data ณ  05/08/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verifica se o aluno estah tentando retornar para um curso  บฑฑ
ฑฑบ          ณ em um ano/periodo anterior ao que ele cursou.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Requerimento de Retorno do Aluno                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEC0016d()
                          
local lRet    := .T.
local aRet    := ACScriptReq( JBH->JBH_NUM )
local cNumRA  := Padr( M->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local cAnoOri := ""
local cPerOri := ""

JCS->( dbSetOrder( 1 ) )	// JCS_FILIAL + JCS_NUMREQ
JCS->( dbSeek( xFilial("JCS") + JBH->JBH_NUM ) )

JBE->( dbSetOrder( 1 ) )
JBE->( dbSeek( xFilial( "JBE" ) + cNumRA + aRet[1] ) )
         
cAnoOri := JBE->JBE_ANOLET
cPerOri := JBE->JBE_PERIOD

do while JBE->( ! EoF() .and. JBE_FILIAL + JBE_NUMRA + JBE_CODCUR == xFilial( "JBE" ) + cNumRA + aRet[1] )
                     
	if cAnoOri + cPerOri < JBE->( JBE_ANOLET + JBE_PERIOD )
		cAnoOri := JBE->JBE_ANOLET
		cPerOri := JBE->JBE_PERIOD
	endif
     
	JBE->( dbSkip() )

enddo                

JAR->( dbSeek( xFilial( "JAR" ) + JCS->( JCS_CURSO + JCS_SERIE + JCS_HABILI ) ) )

if cAnoOri + cPerOri > JAR->( JAR_ANOLET + JAR_PERIOD )
	MsgStop( 	"O aluno nใo pode retornar em um ano/perํodo anterior ao que ele cursou." + Chr(13) + Chr(10) +; 
				"Verifique o curso selecionado na rotina de Anแlise da Grade." )
	lRet := .F.			
endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SEC0016e บ Autor ณ Gustavo Henrique   บ Data ณ  05/08/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida o curso anterior informado no script                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Requerimento de Retorno de Aluno                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEC0016e( cCodIde, cCurOri, lWeb )
              
local lRet    := .T.                                    
local aRet    := {}
local cNumRA  := Padr( cCodIde, TamSX3("JA2_NUMRA")[1] )
                                              
lWeb := iif( lWeb == NIL, .F., .T. )

JBE->( dbSetOrder( 1 ) )

lRet := JBE->( dbSeek( xFilial( "JBE" ) + cNumRA + cCurOri ) )

if ! lRet

	if ! lWeb
		MsgInfo( "Nใo existe registro do aluno no curso anterior informado. Selecione outro curso vigente." )
	else	                     
		aadd(aRet, { .F., "Nใo existe registro do aluno no curso anterior informado. Selecione outro curso vigente."} )
	endif

else

	if ! lWeb
		M->JBH_SCP02 := Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+cCurOri,"JAH_CURSO")+JAH->JAH_VERSAO,"JAF_DESMEC")
	endif

endif

Return( iif( lWeb, aRet, lRet ) )

                                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SEC0016f บ Autor ณ Gustavo Henrique   บ Data ณ  05/08/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida o curso padrao de destino informado no script       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Requerimento de Retorno de Aluno                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEC0016f( cCurDes, lWeb )
        
local lRet := .T.
local aRet := {}

lWeb := iif( lWeb == NIL, .F., .T. )

JAF->( dbSetOrder( 1 ) )
lRet := JAF->( dbSeek( xFilial( "JAF" ) + cCurDes ) )

if ! lRet

	if ! lWeb
		MsgInfo( "Curso invแlido." )
	else	                     
		aadd( aRet, { .F., "Curso invแlido." } )
	endif
	     
else

	if ! lWeb
		M->JBH_SCP08 := JAF->JAF_DESMEC
	endif	
	
endif    

Return( iif( lWeb, aRet, lRet ) )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSEC0016g  บAutor  ณKaren Honda         บ Data ณ  15/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacoes do script para verificar se aluno pertenceu      บฑฑ
ฑฑ a um curso/periodo/turma e esta trancado/desistencia/debito financeiro  .
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณlScript:.T. - chamado pelo script                           บฑฑ
ฑฑ			  cKey: chave de busca na JBE								   ฑฑ
ฑฑ            lWeb: .T. - chamado pela Web		
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณExpL1 : Indicador de validacao.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional - Requerimentos                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑณKaren Honda ณ 16/03/07 ณ 115851 ณ  Permitir retorno para alunos com    ณฑฑ
ฑฑณultimo status de cancelamento\transferencia de externo e Dependencia   ณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEC0016g( lScript, cKey, lWeb )
local lRet	:= .T.                     
Local aRet  := {}
local cNumRA	:= PadR( M->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )

lScript	:= if( lScript == nil, .F., lScript )
cKey	:= if( cKey == nil, "", cKey ) 
lWeb	:= if( lWeb == nil, .F., lWeb )
                                        
if lScript
	lRet	:= ExistCpo("JBE",Padr(M->JBH_CODIDE,TAMSX3("JA2_NUMRA")[1])+cKey, 1)

	if lRet

		JBE->( dbSetOrder(3) ) //JBE_FILIAL, JBE_ATIVO, JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA, R_E_C_N_O_, D_E_L_E_T_

		lRet :=   JBE->( dbSeek(xFilial("JBE")+"4"+cNumRA+cKey) ) .or.; //trancado
                  JBE->( dbSeek(xFilial("JBE")+"7"+cNumRA+cKey) ) .or.; //DESISTENCIA
                  JBE->( dbSeek(xFilial("JBE")+"9"+cNumRA+cKey) ) .or.;	//DEBITOS FINANCEIROS	
                  JBE->( dbSeek(xFilial("JBE")+"6"+cNumRA+cKey) ) .or.;	//CANCELADO	
                  JBE->( dbSeek(xFilial("JBE")+"B"+cNumRA+cKey) )  //TRANSFERENCIA EXTERNO

		If !lRet
			//faz outra valida็ใo, se aluno estแ em dependencia
			JBE->( dbSetOrder(1) ) //JBE_FILIAL, JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA, JBE_SEQ, R_E_C_N_O_, D_E_L_E_T_
            If JBE->( dbSeek(xFilial("JBE")+cNumRA+cKey) ) 
            	If JBE->JBE_TIPO == "2" .and. JBE->JBE_ATIVO == "1" .and. JBE->JBE_SITUAC == "2"
					lRet := .T.
				EndIf	
		    EndIf
		EndIf                                   
	
		if !lRet                      
			If lWeb
				aadd(aRet,{.F.,"Este curso nใo encontra-se com CANCELAMENTO, TRANSFERสNCIA DE EXTERNO, TRANCAMENTO, DESISTสNCIA, DษBITOS FINANCEIROS ou DEPENDสNCIA para este aluno."})
				aadd(aRet,{.F.,"O retorno do aluno s๓ ้ possํvel nessas situa็๕es."})
			Else
				MsgStop("Este curso nใo encontra-se com CANCELAMENTO, TRANSFERสNCIA DE EXTERNO, TRANCAMENTO, DESISTสNCIA, DษBITOS FINANCEIROS ou DEPENDสNCIA para este aluno."+Chr(13)+Chr(10)+;
						"O retorno do aluno s๓ ้ possํvel nessas situa็๕es.")
			Endif			
			
		else
			M->JBH_SCP03	:= JBE->JBE_PERLET
			M->JBH_SCP04    := JBE->JBE_HABILI
			M->JBH_SCP05    := Posicione("JDK",1,xFilial("JDK")+JBE->JBE_HABILI,"JDK_DESC")                                                                    
			M->JBH_SCP06	:= JBE->JBE_TURMA
		endif
	endif
endif

Return( iif( lWeb, aRet, lRet ) )
