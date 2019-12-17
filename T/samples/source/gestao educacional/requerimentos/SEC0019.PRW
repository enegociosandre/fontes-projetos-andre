#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

#Include "TOPCONN.CH"
#Include "RWMAKE.CH"
#Include "MSOLE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SEC0019	³ Autor ³  Regiane R. Barreira  ³ Data ³ 04/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emite Criterio de Avaliacao						       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Especifico Academico 							          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SEC0019()

//Declaração de Variáveis e Valores
Local nPeriodos := 0
Local cRa		:= ""
Local cAtivo	:= ""
Local cSituacao := ""
Local aSer_cur  := Array( 10, 2 )
Local aDiaSem   := {}
Local aHora1    := {}
Local aHora2    := {}
Local aDados    := {}
Local aAss		:= {}
Local Mes 		:= ""
Local Escre_Mes := " "
Local Ano		:= ""
Local cCodCur 	:= ""
Local cPerLet 	:= ""
Local cHabili 	:= ""
Local cTurma  	:= "" 
Local aRet		:= ACScriptReq( JBH->JBH_NUM )
Local nSerie	:= 0
Local cFilJc7   :=""

cPRO := Space(6)
cSEC := Space(6)

aSer_cur[1] :={"01","primeiro"}
aSer_cur[2] :={"02","segundo"}
aSer_cur[3] :={"03","terceiro"}
aSer_cur[4] :={"04","quarto"}
aSer_cur[5] :={"05","quinto"}
aSer_cur[6] :={"06","sexto"}
aSer_cur[7] :={"07","sétimo"}
aSer_cur[8] :={"08","oitavo"}
aSer_cur[9] :={"09","nono"}
aSer_cur[10]:={"10","décimo"}

//Chamada da rotina de escolha de assinaturas....
Processa({||U_ASSREQ() })

JBE->( dbSetOrder( 1 ) )
if JBE->( dbSeek( xFilial( "JBE" ) + Left( JBH->JBH_CODIDE, TamSx3("JBE_NUMRA")[1]) + aRet[1] ) )
    // localiza o registro com situacao ativo
    do while Left( JBH->JBH_CODIDE, TamSx3("JBE_NUMRA")[1]) == JBE->JBE_NUMRA .AND. JBE->JBE_ATIVO != "1"
	   JBE->(dbSkip())
    enddo
    // Verifica se passou
    if Left( JBH->JBH_CODIDE, TamSx3("JBE_NUMRA")[1]) != JBE->JBE_NUMRA
       JBE->(dbSkip(-1))   // Deixa o JBE posicionado no ultimo registro nao ativo
    endif
	// Verifica se o Aluno Está Ativo	
	if JBE->JBE_ATIVO == "1"
		cSituacao := "é"
	Else
		cSituacao := "foi"
	EndIf     
	//Carrega as variáveis para preenchimento	
	cFilJc7 := JBE->JBE_FILIAL
	cRA 	:= JBE->JBE_NUMRA	
	cCodCur := JBE->JBE_CODCUR
	cPerLet := JBE->JBE_PERLET
	cHabili := JBE->JBE_HABILI
	cTurma  := JBE->JBE_TURMA
else
	MsgStop("Aluno sem alocação. Impossível emitir o requerimento.")
	Return(.F.)
endif

//Procura Ato Legal do Curso
cAtoLegal := msmm( AcDecret(Posicione( "JAH", 1, xFilial( "JAH" ) + JBE->JBE_CODCUR, "JAH_CURSO"),JBE->JBE_DCOLAC, Posicione( "JAH", 1, xFilial( "JAH" ) + JBE->JBE_CODCUR, "JAH_UNIDAD")))
if  cAtoLegal==""
	cAtoLegal:="Não Encontrado"
endif
//Fim da Procura 

// Verifica grade de aulas por disciplina
JC7->( dbSetOrder( 1 ) )
JC7->( dbSeek( xFilial( "JC7" ) + cFilJc7 + cRA + cCodCur + cPerLet + cHabili + cTurma ) )

Do While JC7->( ! EoF() .and. JC7_FILIAL + JC7_NUMRA + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA == cFilJc7 + cRA + cCodCur + cPerLet + cHabili + cTurma)
	
	// Se a situacao da disciplina for Normal, gera vetores com os dias da semana que o aluno tem aulas e
	// com as horas iniciais e finais
	If JC7->JC7_SITDIS == "010"		// Situacao: "Normal"
		
		AAdd( aDiaSem, JC7->JC7_DIASEM )	// Dias da semana. 1=Domingo, 2=Segunda, 3=Terca ...
		AAdd( aHora1 , JC7->JC7_HORA1  )	// Hora inicial da disciplina
		AAdd( aHora2 , JC7->JC7_HORA2  )	// Hora final da disciplina
		
	EndIf
	
	cChave := JC7->( JC7_NUMRA + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA )
	
	JC7->( dbSkip() )
	
	If cChave # JC7->( JC7_NUMRA + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA )
		Exit
	EndIf
	
EndDo
//Fim da Verificação de Grades por Disciplina 

//Envia variáveis para Documento Word                              
JAH->( dbSetOrder( 1 ) )
JAH->( dbSeek( xFilial("JAH") + JBE->JBE_CODCUR ) )

nSerie := aScan(aSer_cur, { |x| x[1] == cPerLet } )

AAdd( aDados, { "CURSO"  	,ALLTRIM(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC"))} )
AAdd( aDados, { "ATOLEGAL"  ,cAtoLegal} )
AAdd( aDados, { "RA"        ,ALLTRIM( JBH->JBH_CODIDE )} )
AAdd( aDados, { "NOME"      ,ALLTRIM(Posicione( "JA2", 1, xFilial( "JA2" ) + JBH->JBH_CODIDE, "JA2_NOME" )) } )
AAdd( aDados, { "SITUACAO"	,cSituacao} )
AAdd( aDados, { "TURNO"		,Lower(AllTrim(Tabela('F5',Posicione( "JAH", 1, xFilial( "JAH" ) + cCodCur, "JAH_TURNO" ),.F.)))} )
AAdd( aDados, { "SERIE"		,StrZero(Val(cPerLet),1)} )                                                                                       
AAdd( aDados, { "NOME_SERIE",If(nSerie>0 .And. nSerie<11, aSer_Cur[nSerie,2], "Não Encontrada") } )
AAdd( aDados, { "DATA"		,AllTrim(SM0->M0_CIDCOB)+", " + SubStr(DtoC(dDataBase),1,2) + " de " + MesExtenso(Val(SubStr(DtoC(dDataBase),4,2))) + " de " + AllTrim(Str(Year(dDataBase))) })
AAdd( aDados, { "DT_ANO"	,AllTrim(Str(Year(dDataBase))) })
Aadd( aDados, { "DHABILI"	,Iif(Empty(cHabili), " ", ", na Habilitação " + AllTrim(Posicione("JDK",1,xFilial("JDK") + cHabili,"JDK_DESC"))) })
//Fim do envio das Variáveis
 
//Verifica Sexo do Aluno para escrever no documento
aSexo:= ALLTRIM(Posicione( "JA2", 1, xFilial( "JA2" ) + JBH->JBH_CODIDE, "JA2_SEXO" ))

If aSexo=="1" 
   aSexo:="o" 
ElseIF aSexo=="2"
   aSexo:="a"
EndIf

AAdd( aDados, { "SEXO" ,aSexo } )

//Fim da Verificação

//Verificação para escrever o periodo do Semestre do Aluno na Avaliação de Rendimento Escolar   
Ano:=AllTrim(Str(Year(dDataBase)))
Mes:= SubStr(DtoC(dDataBase),4,2)

If (Mes>="01" .AND. Mes<="06")
	Escre_Mes:="fevereiro a junho de"  //  + Ano   Eliminado conf Bops 112677 por inserir no req. por crit. de aval. duplamente através do campo DT_ANO
ElseIf (Mes>="08" .AND. Mes<="12")
	Escre_Mes:="agosto a dezembro de"  // + Ano   Eliminado conf Bops 112677 por inserir no req. por crit. de aval. duplamente através do campo DT_ANO
EndIf

AAdd(aDados,{"PER_M", Escre_Mes})

// Verifica a Assinatura do Documento
aAss := U_ACRetAss( cPRO )

AAdd( aDados, { "cASS1"  , aAss[1] } )
AAdd( aDados, { "cCARGO1", aAss[2] } )
AAdd( aDados, { "cRG1"   , aAss[3] } )

aAss := U_ACRetAss( cSEC )

AAdd( aDados, { "cASS2"  , aAss[1] } )
AAdd( aDados, { "cCARGO2", aAss[2] } )
AAdd( aDados, { "cRG2"   , aAss[3] } )

// Verifica quantos semestres tem o curso.
nPeriodos := 0

JAR->( dbSetOrder( 1 ) )
JAR->( dbSeek( xFilial( "JAR" ) + cCodCur ) )

Do While JAR->( ! EoF() .and. JAR_FILIAL + JAR_CODCUR == xFilial( "JAR" ) + cCodCur )
	nPeriodos ++
	JAR->( dbSkip() )
EndDo

AAdd( aDados, { "DURACAO", nPeriodos } )
AAdd( aDados, { "NOME_DURACAO", Lower(Extenso( nPeriodos, .T., 1 )) } )
//Fim da Verificação

//Função de Envio das variáveis para o documento Word
ACImpDoc( JBG->JBG_DOCUM, aDados )

Return( .T. )
