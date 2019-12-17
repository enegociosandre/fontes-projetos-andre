#include "protheus.ch"
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC13800  บAutor  ณRafael Rodrigues    บ Data ณ  26/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta o cadastro de Notas x Alunos                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณImportacao de Bases, GE.                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC13800( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC13800'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local nDrv		:= 0
Local lOracle	:= "ORACLE"$Upper(TCGetDB())
Local cProcName
Local nThreads := 25
Local nCommit	:= 500	// A cada quantas gravacoes deve efetuar commit no banco

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JBS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBS_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JBS_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JBS_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JBS_CODAVA", "C", 002, 0 } )
aAdd( aStru, { "JDC_ATIVID", "C", 002, 0 } )
aAdd( aStru, { "JBS_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JBS_CONCEI", "C", 004, 0 } )
aAdd( aStru, { "JBS_NOTA"  , "N", 005, 2 } )
aAdd( aStru, { "JBS_COMPAR", "C", 001, 0 } )
aAdd( aStru, { "JBS_DTCHAM", "D", 008, 0 } )
aAdd( aStru, { "JBS_OUTRAT", "C", 001, 0 } )
aAdd( aStru, { "JBS_DTAPON", "D", 008, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Notas x Alunos', 'AC13800', aClone( aStru ), 'TRB138', .T., 'JBS_CODCUR, JBS_PERLET, JBS_HABILI, JBS_TURMA, JBS_CODDIS, JBS_CODAVA, JDC_ATIVID, JBS_NUMRA' } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a janela para selecao de arquivos e importacao dos temporariosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if nOpc == 2	// So processamento
	if File( "Abort.log" )
		AcaLog( cLogFile, "  O processo de notas nใo serแ iniciado em decorr๊ncia do cancelamento do processo de matrํculas." )
		Return
	endif
		
	U_xOpen( aTables, aFiles, aDriver, .T. )
else
	aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver, .T., nOpc == 1 )
	if nOpc == 1
		Return aTables
	endif
endif
	
if Empty( aTables )
	AcaLog( cLogFile, '  Nenhum arquivo p๔de ser importado para este processo.' )
	if nOpc == 0
		Aviso( 'Problema', 'Nenhum arquivo p๔de ser importado para este processo.', {'Ok'} )
	endif
else
	                
	nDrv := aScan( aDriver, aTables[1,3] )	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณverifica chaves unicasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() + '  .Iniciando valida็ใo do arquivo "'+aFiles[1,1]+'".' )	
	if nOpc == 0
		Processa( {|lEnd| lOK := xAC138Chk( aTables[1,2], cLogFile, aTables[1,4] ) }, 'Buscando chaves duplicadas' )
	else                               
		lOK := xAC138Chk( aTables[1,2], cLogFile, aTables[1,4] )
	endif
	AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() + '  .Fim da valida็ใo do arquivo "'+aFiles[1,1]+'".' )	

	if lOk
		if lOracle .and. nDrv == 3	// So utiliza procedure se for Oracle e tabela diretamente no banco
			// Cria as Stored Procedures
			cProcName := CreateSP( aTables[1,2] )
			
			if nOpc == 0
				Processa( {|| lOk := xAC138Wait( cProcName, aTables[1,4], nThreads, cLogFile, nCommit ) } )
			else
				lOk := xAC138Wait( cProcName, aTables[1,4], nThreads, cLogFile, nCommit )
			endif

			if !lOk
				AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '! Foram detectadas inconsist๊ncias. A grava็ใo nใo foi completa.' )
				if nOpc == 0 .and. Aviso( 'Problemas!', 'Foram detectadas inconsist๊ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'}, 2 ) == 2
					OurSpool( cNameFile )
				endif
			else
				AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '! Grava็ใo realizada com sucesso.' )
				if nOpc == 0
					Aviso( 'Sucesso!', 'Importa็ใo realizada com sucesso.', {'Ok'} )
				endif
			endif
		else
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณprepara as consistencias a serem feitas no arquivo temporarioณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAdd( aObrig, { '!Empty(JBS_CODCUR) ', 'C๓digo do curso vigente nใo informado.' } )
			aAdd( aObrig, { '!Empty(JBS_PERLET) ', 'Perํodo letivo nใo informado.' } )
			aAdd( aObrig, { '!Empty(JBS_TURMA)  ', 'Turma nใo informada.' } )
			aAdd( aObrig, { '!Empty(JBS_CODDIS) ', 'Disciplina nใo informada.' } )
			aAdd( aObrig, { '!Empty(JBS_CODAVA) ', 'Avalia็ใo nใo informada.' } )
			aAdd( aObrig, { '!Empty(JBS_NUMRA)  ', 'RA do aluno nใo informado.' } )
			aAdd( aObrig, { 'JBS_CODDIS == Posicione( "JAS", 2, xFilial("JAS")+JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_CODDIS, "JAS_CODDIS" )', 'Disciplina nใo cadastrada na tabela JAS.' } )
			aAdd( aObrig, { 'JBS_CODAVA == Posicione( "JBQ", 3, xFilial("JBQ")+JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_CODAVA, "JBQ_CODAVA" )', 'Avalia็ใo nใo cadastrada na tabela JBQ.' } )
			aAdd( aObrig, { 'JBS_NUMRA == Posicione( "JC7", if(JBS_OUTRAT=="1",8,1), xFilial("JC7")+JBS_NUMRA+JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS, "JC7_NUMRA" )', 'Matrํcula do aluno para esta disciplina nใo cadastrada na tabela JC7.' } )
			aAdd( aObrig, { 'Empty(JDC_ATIVID) .or. JDC_ATIVID == Posicione( "JDA", 1, xFilial("JDA")+JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JDC_ATIVID, "JDA_ATIVID" )', 'Atividade nใo cadastrada na tabela JDA.' } )
			aAdd( aObrig, { 'JBS_COMPAR$"12"      ', '"Compareceu?" deve ser 1 (sim) ou 2 (nใo).' } )
			aAdd( aObrig, { 'JBS_OUTRAT$"12"      ', '"Aluno de outra turma?" deve ser 1 (sim) ou 2 (nใo).' } )
			aAdd( aObrig, { '!Empty(JBS_DTAPON) ', 'Data de apontamento nใo informada.' } )
			aAdd( aObrig, { '!Empty(JBS_CONCEI) .or. Posicione( "JAR", 1, xFilial("JAR")+JBS_CODCUR+JBS_PERLET+JBS_HABILI, "JAR_CRIAVA" ) != "2" ', 'Conceito nใo informado. Este perํodo letivo avalia por conceito.' } )
			
			if nOpc == 0
				Processa( { |lEnd| lOk := U_xAC138Grv( aTables[1,2], aObrig, cLogFile, @lEnd, aTables[1,4] ) }, 'Grava็ao em andamento' )
			else                                   
				lOk := u_xAC138Grv( aTables[1,2], aObrig, cLogFile, @lEnd, aTables[1,4] )
			endif
			
			if !lOk
				AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() + '! Foram detectadas inconsist๊ncias. A grava็ใo nใo foi completa.' )
				if nOpc == 0 .and. Aviso( 'Problemas!', 'Foram detectadas inconsist๊ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'}, 2 ) == 2
					OurSpool( cNameFile )
				endif
			else
				AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() + '! Grava็ใo realizada com sucesso.' )
				if nOpc == 0
					Aviso( 'Sucesso!', 'Importa็ใo realizada com sucesso.', {'Ok'} )
				endif
			endif
		endif
	else
		AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() + '! Foram detectadas duplicidades de chave primแria. A grava็ใo nใo foi realizada.' )
		if nOpc == 0 .and. Aviso( 'Problemas!', 'Foram detectadas duplicidades de chave primแria. A grava็ใo nใo foi realizada. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'}, 2 ) == 2
			OurSpool( cNameFile )
		endif
	endif
endif

if Select( "TRB138" ) > 0
	TRB138->( dbCloseArea() )
endif	                            

if len(aTables) # 0 .And. nDrv <> 3
	FErase( cIDX + OrdBagExt() )
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC138Grv  บAutor  ณRafael Rodrigues   บ Data ณ  26/12/02   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a gravacao dos dados na base do AP6.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC13800                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC138Grv( cTable, aObrig, cLogFile, lEnd, nRecs )
Local cFilJBR	:= xFilial("JBR")	// Criada para ganhar performance
Local cFilJBS	:= xFilial("JBS")	// Criada para ganhar performance
Local cFilJDB	:= xFilial("JDB")	// Criada para ganhar performance
Local cFilJDC	:= xFilial("JDC")	// Criada para ganhar performance
Local i			:= 0
Local j			:= 0
Local cKeyJBR	:= ""
Local cKeyJBS	:= ""
Local cKeyJDB	:= ""
Local lLinOk	:= .T.
Local lOk		:= .T.
Local lSeek

if nOpc == 0
	ProcRegua( nRecs )
endif

TRB138->( dbGoTop() )

JBR->( dbSetOrder(1) )
JBS->( dbSetOrder(1) )
JDB->( dbSetOrder(1) )
JDC->( dbSetOrder(1) )

while TRB138->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( 'Gravando linha '+StrZero( ++i, 8 )+' de '+StrZero( nRecs, 8 )+'...' )
	endif

	lLinOk := .T.
	for j := 1 to len( aObrig )
		if TRB138->( !Eval( &("{ || "+aObrig[j, 1]+" }") ) )
			lLinOk := .F.
			AcaLog( cLogFile, '  Inconsist๊ncia no apontamento do curso '+TRB138->JBS_CODCUR+', perํodo '+TRB138->JBS_PERLET+', turma '+TRB138->JBS_TURMA+', disciplina '+TRB138->JBS_CODDIS+', avalia็ใo '+TRB138->JBS_CODAVA+', atividade '+TRB138->JDC_ATIVID+', aluno '+TRB138->JBS_NUMRA+': '+aObrig[j, 2] )
		endif
	next j

	if !lLinOk
		lOk := .F.
		TRB138->( dbSkip() )
		loop
	endif

	if cKeyJBR <> TRB138->( JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS+JBS_CODAVA )
		cKeyJBR := TRB138->( JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS+JBS_CODAVA )

		lSeek := JBR->( dbSeek( cFilJBR+TRB138->(JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS+JBS_CODAVA) ) )
		if lOver .or. !lSeek
			begin transaction
	
			RecLock( "JBR", !lSeek )
			JBR->JBR_FILIAL	:= cFilJBR
			JBR->JBR_CODCUR	:= TRB138->JBS_CODCUR
			JBR->JBR_PERLET	:= TRB138->JBS_PERLET
			JBR->JBR_HABILI	:= TRB138->JBS_HABILI
			JBR->JBR_TURMA	:= TRB138->JBS_TURMA
			JBR->JBR_CODDIS	:= TRB138->JBS_CODDIS
			JBR->JBR_CODAVA	:= TRB138->JBS_CODAVA
			JBR->JBR_MATPRF	:= Posicione( "JBL", 1, xFilial("JBL")+TRB138->( JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS ), "JBL_MATPRF" )
			JBR->( msUnlock() )
	
			end transaction
		endif
	endif
	
	if cKeyJBS <> TRB138->(JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_NUMRA)
		cKeyJBS := TRB138->(JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_NUMRA)

		lSeek := JBS->( dbSeek( cFilJBS+TRB138->(JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_NUMRA) ) )
		if lOver .or. !lSeek
			begin transaction
	
			RecLock( "JBS", !lSeek )
			JBS->JBS_FILIAL	:= cFilJBS
			JBS->JBS_NUMRA	:= TRB138->JBS_NUMRA
			JBS->JBS_CODCUR	:= TRB138->JBS_CODCUR
			JBS->JBS_PERLET	:= TRB138->JBS_PERLET
			JBS->JBS_HABILI	:= TRB138->JBS_HABILI
			JBS->JBS_TURMA	:= TRB138->JBS_TURMA
			JBS->JBS_CODAVA	:= TRB138->JBS_CODAVA
			JBS->JBS_CODDIS	:= TRB138->JBS_CODDIS
			JBS->JBS_CONCEI	:= TRB138->JBS_CONCEI
			JBS->JBS_NOTA	:= TRB138->JBS_NOTA
			JBS->JBS_COMPAR	:= TRB138->JBS_COMPAR
			JBS->JBS_DTCHAM	:= TRB138->JBS_DTCHAM
			JBS->JBS_OUTRAT	:= TRB138->JBS_OUTRAT
			JBS->JBS_DTAPON	:= TRB138->JBS_DTAPON
			JBS->( msUnlock() )
	
			end transaction
		endif
	endif

	if !Empty( TRB138->JDC_ATIVID )
		if cKeyJDB <> TRB138->( JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JDC_ATIVID+JBS_OUTRAT )
			cKeyJDB := TRB138->( JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JDC_ATIVID+JBS_OUTRAT )
			
			lSeek := JDB->( dbSeek( cFilJDB+TRB138->( JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JDC_ATIVID ) ) )
			if !lSeek
				begin transaction
		
				RecLock( "JDB", !lSeek )
				JDB->JDB_FILIAL	:= cFilJDB
				JDB->JDB_CODCUR	:= TRB138->JBS_CODCUR
				JDB->JDB_PERLET	:= TRB138->JBS_PERLET
				JDB->JDB_HABILI	:= TRB138->JBS_HABILI
				JDB->JDB_TURMA	:= TRB138->JBS_TURMA
				JDB->JDB_CODDIS	:= TRB138->JBS_CODDIS
				JDB->JDB_CODAVA	:= TRB138->JBS_CODAVA
				JDB->JDB_ATIVID	:= TRB138->JDC_ATIVID
				JDB->( msUnlock() )
		
				end transaction
			endif
		endif
		
		lSeek := JDC->( dbSeek( cFilJDC+TRB138->( JBS_CODCUR+JBS_PERLET+JBS_HABILI+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JDC_ATIVID+JBS_NUMRA ) ) )
		if lOver .or. !lSeek
			begin transaction
		
			RecLock( "JDC", !lSeek )
			JDC->JDC_FILIAL	:= cFilJDC
			JDC->JDC_CODCUR	:= TRB138->JBS_CODCUR
			JDC->JDC_PERLET	:= TRB138->JBS_PERLET
			JDC->JDC_HABILI	:= TRB138->JBS_HABILI
			JDC->JDC_TURMA	:= TRB138->JBS_TURMA
			JDC->JDC_CODDIS	:= TRB138->JBS_CODDIS
			JDC->JDC_CODAVA	:= TRB138->JBS_CODAVA
			JDC->JDC_ATIVID	:= TRB138->JDC_ATIVID
			JDC->JDC_NUMRA	:= TRB138->JBS_NUMRA
			JDC->JDC_OUTRAT	:= TRB138->JBS_OUTRAT
			JDC->JDC_CONCEI	:= TRB138->JBS_CONCEI
			JDC->JDC_NOTA	:= TRB138->JBS_NOTA
			JDC->JDC_COMPAR	:= TRB138->JBS_COMPAR
			JDC->JDC_DTCHAM	:= TRB138->JBS_DTCHAM
			JDC->( msUnlock() )
		
			end transaction
		endif
	endif

	TRB138->( dbSkip() )
end

Return !lEnd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC138Chk บAutor  ณRafael Rodrigues    บ Data ณ 11/Fev/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca duplicidades de chaves no arquivo de importacao       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMigracao de bases                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC138Chk( cTable, cLogFile, nRecs )
Local cQuery
Local lOk := .T.
Local i   := 0

if nOpc == 0
	ProcRegua( nRecs )
endif

cQuery := "select JBS_CODCUR, JBS_PERLET, JBS_HABILI, JBS_TURMA, JBS_CODDIS, JBS_CODAVA, JDC_ATIVID, JBS_NUMRA "
cQuery += "  from "+cTable
cQuery += " group by JBS_CODCUR, JBS_PERLET, JBS_HABILI, JBS_TURMA, JBS_CODDIS, JBS_CODAVA, JDC_ATIVID, JBS_NUMRA "
cQuery += "having count(*) > 1 "
	
cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )

lOk := lOk .and. QRY->( eof() )
while QRY->( !eof() )
	if nOpc == 0
		IncProc( 'Validando linha '+StrZero( ++i, 8 )+' de '+StrZero( nRecs, 8 )+'...' )
	endif
	AcaLog( cLogFile, '  Inconsist๊ncia na tabela. Chave duplicada para o curso '+QRY->JBS_CODCUR+', perํodo '+QRY->JBS_PERLET+', turma '+QRY->JBS_TURMA+', disciplina '+QRY->JBS_CODDIS+', avalia็ใo '+QRY->JBS_CODAVA+', atividade '+QRY->JDC_ATIVID+', aluno '+QRY->JBS_NUMRA+'.' )
	QRY->( dbSkip() )
end

QRY->( dbCloseArea() )
Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCreateSP  บAutor  ณRafael Rodrigues    บ Data ณ  11/16/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณStored Procedures desenvolvidas por Emerson Tobar           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMigracao de Dados - GE                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CreateSP( cTabela )
Local cProcName
Local cProced

cProcName := CriaTrab(,.F.)

TCSQLExec( "truncate table IMP_LOG38" )
TCSQLExec( "delete from IMP_STATUS where TIPO = '38'" )

cProced := "create or replace procedure "+cProcName+" "
cProced += Chr(10) + "( "
cProced += Chr(10) + " IN_OVER    in  integer, "
cProced += Chr(10) + " IN_MIN     in  integer, "
cProced += Chr(10) + " IN_MAX     in  integer, "
cProced += Chr(10) + " IN_THRD    in  integer, "
cProced += Chr(10) + " IN_COMMIT  in  integer, "
cProced += Chr(10) + " OUT_TOTAL  out integer, "
cProced += Chr(10) + " OUT_REJECT out integer "
cProced += Chr(10) + ") is "

cProced += Chr(10) + "nLoop   integer; "
cProced += Chr(10) + "nErro1  exception; "
cProced += Chr(10) + "cMsgFix varchar2( 500 ); "
cProced += Chr(10) + "cMsgErr varchar2( 500 ); "
cProced += Chr(10) + "cKeyJBR varchar2( 500 ); "
cProced += Chr(10) + "cKeyJBS varchar2( 500 ); "
cProced += Chr(10) + "cKeyJDB varchar2( 500 ); "
cProced += Chr(10) + "nRecno  integer; "
cProced += Chr(10) + "cJBL_MATPRF "+RetSQLName("JBL")+".JBL_MATPRF%Type; "
cProced += Chr(10) + "nCommit integer; "

cProced += Chr(10) + "cursor cur01 is  "
cProced += Chr(10) + "select /*+ FIRST_ROWS */ JBS_CODCUR, JBS_PERLET, JBS_HABILI, JBS_TURMA,  JBS_CODDIS, JBS_CODAVA, JDC_ATIVID, JBS_NUMRA, "
cProced += Chr(10) + "       JBS_CONCEI, JBS_NOTA,   JBS_COMPAR, JBS_DTCHAM, JBS_OUTRAT, JBS_DTAPON, R_E_C_N_O_ "
cProced += Chr(10) + "  from "+cTabela
cProced += Chr(10) + " where R_E_C_N_O_ between IN_MIN and IN_MAX; "

cProced += Chr(10) + "begin "
cProced += Chr(10) + "   insert into IMP_STATUS ( TIPO, THRD, MINREC, MAXREC, LASTREC, HORA ) values ( '38', IN_THRD, IN_MIN, IN_MAX, 0, sysdate ); "
cProced += Chr(10) + "   commit; "
cProced += Chr(10) + "   OUT_TOTAL  := 0; "
cProced += Chr(10) + "   OUT_REJECT := 0; "
cProced += Chr(10) + "   cKeyJBR := ' '; "
cProced += Chr(10) + "   cKeyJBS := ' '; "
cProced += Chr(10) + "   cKeyJDB := ' '; "
cProced += Chr(10) + "   for x in cur01 loop "
cProced += Chr(10) + "   begin "
cProced += Chr(10) + "      OUT_TOTAL := OUT_TOTAL + 1; "
cProced += Chr(10) + "      cMsgFix   := '  Inconsist๊ncia no apontamento do curso ' || x.JBS_CODCUR || ', perํodo ' || x.JBS_PERLET || ', turma ' || x.JBS_TURMA || ', disciplina ' || x.JBS_CODDIS || ', avalia็ใo ' || x.JBS_CODAVA || ', atividade ' || x.JDC_ATIVID || ', aluno ' || x.JBS_NUMRA || ': '; "
cProced += Chr(10) + "      cMsgErr   := null; "

//aAdd( aObrig, { '!Empty(JBS_CODCUR) ', 'C๓digo do curso vigente nใo informado.' } ) "
cProced += Chr(10) + "      if x.JBS_CODCUR = ' ' then "
cProced += Chr(10) + "         cMsgErr := 'C๓digo do curso vigente nใo informado.'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//aAdd( aObrig, { '!Empty(JBS_PERLET) ', 'Perํodo letivo nใo informado.' } ) "
cProced += Chr(10) + "      if x.JBS_PERLET = ' ' then "
cProced += Chr(10) + "         cMsgErr := 'Perํodo letivo nใo informado.'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { '!Empty(JBS_TURMA)  ', 'Turma nใo informada.' } ) "
cProced += Chr(10) + "      if x.JBS_TURMA = ' ' then  "
cProced += Chr(10) + "         cMsgErr := 'Turma nใo informada.'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { '!Empty(JBS_CODDIS) ', 'Disciplina nใo informada.' } ) "
cProced += Chr(10) + "      if x.JBS_CODDIS = ' ' then  "
cProced += Chr(10) + "         cMsgErr := 'Disciplina nใo informada.'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { '!Empty(JBS_CODAVA) ', 'Avalia็ใo nใo informada.' } ) "
cProced += Chr(10) + "      if x.JBS_CODAVA = ' ' then  "
cProced += Chr(10) + "         cMsgErr := 'Avalia็ใo nใo informada.'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { '!Empty(JBS_NUMRA)  ', 'RA do aluno nใo informado.' } ) "
cProced += Chr(10) + "      if x.JBS_NUMRA = ' ' then  "
cProced += Chr(10) + "         cMsgErr := 'RA do aluno nใo informado.'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { 'JBS_CODDIS == Posicione( "JAS", 2, xFilial("JAS")+JBS_CODCUR+JBS_PERLET+JBS_CODDIS, "JAS_CODDIS" )', 'Disciplina nใo cadastrada na tabela JAS.' } ) "
cProced += Chr(10) + "      select Min(R_E_C_N_O_) into nRecno "
cProced += Chr(10) + "        from "+RetSQLName("JAS")
cProced += Chr(10) + "       where JAS_FILIAL = '"+xFilial("JAS")+"' "
cProced += Chr(10) + "         and JAS_CODCUR = x.JBS_CODCUR "
cProced += Chr(10) + "         and JAS_PERLET = x.JBS_PERLET "
cProced += Chr(10) + "         and JAS_HABILI = x.JBS_HABILI "
cProced += Chr(10) + "         and JAS_CODDIS = x.JBS_CODDIS "
cProced += Chr(10) + "         and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "      if nRecno is null then "
cProced += Chr(10) + "         cMsgErr := 'Disciplina nใo cadastrada na tabela JAS.'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { 'JBS_CODAVA == Posicione( "JBQ", 3, xFilial("JBQ")+JBS_CODCUR+JBS_PERLET+JBS_CODAVA, "JBQ_CODAVA" )', 'Avalia็ใo nใo cadastrada na tabela JBQ.' } )
cProced += Chr(10) + "      select Min(R_E_C_N_O_) into nRecno "
cProced += Chr(10) + "        from "+RetSQLName("JBQ")
cProced += Chr(10) + "       where JBQ_FILIAL = '"+xFilial("JBQ")+"' "
cProced += Chr(10) + "         and JBQ_CODCUR = x.JBS_CODCUR "
cProced += Chr(10) + "         and JBQ_PERLET = x.JBS_PERLET "
cProced += Chr(10) + "         and JBQ_HABILI = x.JBS_HABILI "
cProced += Chr(10) + "         and JBQ_CODAVA = x.JBS_CODAVA "
cProced += Chr(10) + "         and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "      if nRecno is null then "
cProced += Chr(10) + "         cMsgErr := 'Avalia็ใo nใo cadastrada na tabela JBQ.'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { 'JBS_NUMRA == Posicione( "JC7", if(JBS_OUTRAT=="1",8,1), xFilial("JC7")+JBS_NUMRA+JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS, "JC7_NUMRA" )', 'Matrํcula do aluno para esta disciplina nใo cadastrada na tabela JC7.' } )
cProced += Chr(10) + "      select Min(R_E_C_N_O_) into nRecno "
cProced += Chr(10) + "        from "+RetSQLName("JC7")
cProced += Chr(10) + "       where JC7_FILIAL = '"+xFilial("JC7")+"' "
cProced += Chr(10) + "         and JC7_NUMRA  = x.JBS_NUMRA "
cProced += Chr(10) + "         and ( ( JC7_CODCUR = x.JBS_CODCUR "
cProced += Chr(10) + "             and JC7_PERLET = x.JBS_PERLET "
cProced += Chr(10) + "             and JC7_HABILI = x.JBS_HABILI "
cProced += Chr(10) + "             and JC7_TURMA  = x.JBS_TURMA "
cProced += Chr(10) + "             and JC7_OUTCUR = ' ' ) "
cProced += Chr(10) + "            or ( JC7_OUTCUR = x.JBS_CODCUR "
cProced += Chr(10) + "             and JC7_OUTPER = x.JBS_PERLET "
cProced += Chr(10) + "             and JC7_OUTHAB = x.JBS_HABILI "
cProced += Chr(10) + "             and JC7_OUTTUR = x.JBS_TURMA ) )"
cProced += Chr(10) + "             and JC7_DISCIP = x.JBS_CODDIS "
cProced += Chr(10) + "         and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "      if nRecno is null then "
cProced += Chr(10) + "         cMsgErr := 'Matrํcula do aluno para esta disciplina nใo cadastrada na tabela JC7.'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { 'Empty(JDC_ATIVID) .or. JDC_ATIVID == Posicione( "JDA", 1, xFilial("JDA")+JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JDC_ATIVID, "JDA_ATIVID" )', 'Atividade nใo cadastrada na tabela JDA.' } )
cProced += Chr(10) + "      if x.JDC_ATIVID <> ' ' then "
cProced += Chr(10) + "         select Min(R_E_C_N_O_) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("JDA")
cProced += Chr(10) + "          where JDA_FILIAL = '"+xFilial("JDA")+"' "
cProced += Chr(10) + "            and JDA_CODCUR = x.JBS_CODCUR "
cProced += Chr(10) + "            and JDA_PERLET = x.JBS_PERLET "
cProced += Chr(10) + "            and JDA_HABILI = x.JBS_HABILI "
cProced += Chr(10) + "            and JDA_TURMA  = x.JBS_TURMA "
cProced += Chr(10) + "            and JDA_CODDIS = x.JBS_CODDIS "
cProced += Chr(10) + "            and JDA_CODAVA = x.JBS_CODAVA "
cProced += Chr(10) + "            and JDA_ATIVID = x.JDC_ATIVID "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            cMsgErr := 'Atividade nใo cadastrada na tabela JDA.'; "
cProced += Chr(10) + "            Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { 'JBS_COMPAR$"12"      ', '"Compareceu?" deve ser 1 (sim) ou 2 (nใo).' } )
cProced += Chr(10) + "      if x.JBS_COMPAR < '1' or x.JBS_COMPAR > '2' then  "
cProced += Chr(10) + "         cMsgErr := 'Compareceu? deve ser 1 (sim) ou 2 (nใo).'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { 'JBS_OUTRAT$"12"      ', '"Aluno de outra turma?" deve ser 1 (sim) ou 2 (nใo).' } )
cProced += Chr(10) + "      if x.JBS_OUTRAT < '1' or x.JBS_OUTRAT > '2' then  "
cProced += Chr(10) + "         cMsgErr := 'Aluno de outra turma? deve ser 1 (sim) ou 2 (nใo).'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { '!Empty(JBS_DTAPON) ', 'Data de apontamento nใo informada.' } )
cProced += Chr(10) + "      if x.JBS_DTAPON = ' ' then "
cProced += Chr(10) + "         cMsgErr := 'Data de apontamento nใo informada.'; "
cProced += Chr(10) + "         Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

// aAdd( aObrig, { '!Empty(JBS_CONCEI) .or. Posicione( "JAR", 1, xFilial("JAR")+JBS_CODCUR+JBS_PERLET, "JAR_CRIAVA" ) != "2" ', 'Conceito nใo informado. Este perํodo letivo avalia por conceito.' } )
cProced += Chr(10) + "      if x.JBS_CONCEI = ' ' then "
cProced += Chr(10) + "         select Min(R_E_C_N_O_) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("JAR")
cProced += Chr(10) + "          where JAR_FILIAL = '"+xFilial("JAR")+"' "
cProced += Chr(10) + "            and JAR_CODCUR = x.JBS_CODCUR "
cProced += Chr(10) + "            and JAR_PERLET = x.JBS_PERLET "
cProced += Chr(10) + "            and JAR_HABILI = x.JBS_HABILI "
cProced += Chr(10) + "            and JAR_CRIAVA = '2' " 
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "

cProced += Chr(10) + "         if nRecno is not null then "
cProced += Chr(10) + "            cMsgErr := 'Conceito nใo informado. Este perํodo letivo avalia por conceito.'; "
cProced += Chr(10) + "            Grava_Log( '38', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

cProced += Chr(10) + "      if cMsgErr is not null then "
cProced += Chr(10) + "         raise nErro1; "
cProced += Chr(10) + "      end if; "

// Insert na tabela JBR
cProced += Chr(10) + "      if x.JDC_ATIVID = ' ' then "
cProced += Chr(10) + "      if cKeyJBR <> x.JBS_CODCUR || x.JBS_PERLET || x.JBS_HABILI || x.JBS_TURMA || x.JBS_CODDIS || x.JBS_CODAVA then "
cProced += Chr(10) + "         cKeyJBR := x.JBS_CODCUR || x.JBS_PERLET || x.JBS_HABILI || x.JBS_TURMA || x.JBS_CODDIS || x.JBS_CODAVA; "

// JBR->JBR_MATPRF	:= Posicione( "JBL", 1, xFilial("JBL")+TRB138->( JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS ), "JBL_MATPRF" )
cProced += Chr(10) + "         select Nvl( Min( JBL_MATPRF ), ' ' ) into cJBL_MATPRF "
cProced += Chr(10) + "           from "+RetSQLName("JBL")
cProced += Chr(10) + "          where JBL_FILIAL = '"+xFilial("JBL")+"' "
cProced += Chr(10) + "            and JBL_CODCUR = x.JBS_CODCUR "
cProced += Chr(10) + "            and JBL_PERLET = x.JBS_PERLET "
cProced += Chr(10) + "            and JBL_HABILI = x.JBS_HABILI "
cProced += Chr(10) + "            and JBL_TURMA  = x.JBS_TURMA "
cProced += Chr(10) + "            and JBL_CODDIS = x.JBS_CODDIS "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "

cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno  "
cProced += Chr(10) + "           from "+RetSQLName("JBR")
cProced += Chr(10) + "          where JBR_FILIAL = '"+xFilial("JBR")+"' "
cProced += Chr(10) + "            and JBR_CODCUR = x.JBS_CODCUR "
cProced += Chr(10) + "            and JBR_PERLET = x.JBS_PERLET "
cProced += Chr(10) + "            and JBR_HABILI = x.JBS_HABILI "
cProced += Chr(10) + "            and JBR_TURMA  = x.JBS_TURMA "
cProced += Chr(10) + "            and JBR_CODDIS = x.JBS_CODDIS "
cProced += Chr(10) + "            and JBR_CODAVA = x.JBS_CODAVA "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "

cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            nLoop := 0;"
cProced += Chr(10) + "            while nLoop = 0 loop "
cProced += Chr(10) + "            begin "
cProced += Chr(10) + "               insert into "+RetSQLName("JBR")
cProced += Chr(10) + "                  (JBR_FILIAL,           JBR_CODCUR,   JBR_PERLET,   JBR_HABILI, JBR_TURMA,   JBR_CODDIS,   JBR_CODAVA,   JBR_MATPRF, R_E_C_N_O_) "
cProced += Chr(10) + "               values   "
cProced += Chr(10) + "                  ('"+xFilial("JBR")+"', x.JBS_CODCUR, x.JBS_PERLET, x.JBS_HABILI, x.JBS_TURMA, x.JBS_CODDIS, x.JBS_CODAVA, cJBL_MATPRF, "+RetSQLName("JBR")+"_RECNO.NextVal ); "
cProced += Chr(10) + "	             nLoop := 1; "
cProced += Chr(10) + "            exception "
cProced += Chr(10) + "               when DUP_VAL_ON_INDEX then "
cProced += Chr(10) + "                        nLoop := 0; "
cProced += Chr(10) + "            end; "
cProced += Chr(10) + "            end loop; "
cProced += Chr(10) + "         elsif IN_OVER = 1 then "
cProced += Chr(10) + "            update "+RetSQLName("JBR")+" set JBR_MATPRF = cJBL_MATPRF "
cProced += Chr(10) + "             where R_E_C_N_O_ = nRecno; "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

// Insert na tabela JBS ---
cProced += Chr(10) + "      if cKeyJBS <> x.JBS_CODCUR || x.JBS_PERLET || x.JBS_HABILI || x.JBS_TURMA || x.JBS_CODDIS || x.JBS_CODAVA || x.JBS_NUMRA then "
cProced += Chr(10) + "         cKeyJBS := x.JBS_CODCUR || x.JBS_PERLET || x.JBS_HABILI ||x.JBS_TURMA || x.JBS_CODDIS || x.JBS_CODAVA || x.JBS_NUMRA; "

cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("JBS")
cProced += Chr(10) + "          where JBS_FILIAL = '"+xFilial("JBS")+"'"
cProced += Chr(10) + "            and JBS_CODCUR = x.JBS_CODCUR  "
cProced += Chr(10) + "            and JBS_PERLET = x.JBS_PERLET  "
cProced += Chr(10) + "            and JBS_HABILI = x.JBS_HABILI  "
cProced += Chr(10) + "            and JBS_TURMA  = x.JBS_TURMA   "
cProced += Chr(10) + "            and JBS_CODDIS = x.JBS_CODDIS  "
cProced += Chr(10) + "            and JBS_CODAVA = x.JBS_CODAVA  "
cProced += Chr(10) + "            and JBS_NUMRA  = x.JBS_NUMRA   "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "

cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            nLoop := 0;"
cProced += Chr(10) + "            while nLoop = 0 loop "
cProced += Chr(10) + "            begin "
cProced += Chr(10) + "               insert into "+RetSQLName("JBS")
cProced += Chr(10) + "                  (JBS_FILIAL,   JBS_NUMRA,   JBS_CODCUR,   JBS_PERLET,   JBS_HABILI,   JBS_TURMA,    JBS_CODAVA,   JBS_CODDIS, "
cProced += Chr(10) + "                   JBS_CONCEI,   JBS_NOTA,    JBS_COMPAR,   JBS_DTCHAM,   JBS_OUTRAT,   JBS_DTAPON,   R_E_C_N_O_) "
cProced += Chr(10) + "               values   "
cProced += Chr(10) + "                  ('"+xFilial("JBS")+"', x.JBS_NUMRA, x.JBS_CODCUR, x.JBS_PERLET, x.JBS_HABILI, x.JBS_TURMA,  x.JBS_CODAVA, x.JBS_CODDIS,  "
cProced += Chr(10) + "                   x.JBS_CONCEI, x.JBS_NOTA,  x.JBS_COMPAR, x.JBS_DTCHAM, x.JBS_OUTRAT, x.JBS_DTAPON, "+RetSQLName("JBS")+"_RECNO.NextVal ); "
cProced += Chr(10) + "	             nLoop := 1; "
cProced += Chr(10) + "            exception "
cProced += Chr(10) + "               when DUP_VAL_ON_INDEX then "
cProced += Chr(10) + "                        nLoop := 0; "
cProced += Chr(10) + "            end; "
cProced += Chr(10) + "            end loop; "
cProced += Chr(10) + "         elsif IN_OVER = 1 then "
cProced += Chr(10) + "            update "+RetSQLName("JBS")+" set  "
cProced += Chr(10) + "               JBS_CONCEI = x.JBS_CONCEI, JBS_NOTA   = x.JBS_NOTA,   JBS_COMPAR = x.JBS_COMPAR, "
cProced += Chr(10) + "               JBS_DTCHAM = x.JBS_DTCHAM, JBS_OUTRAT = x.JBS_OUTRAT, JBS_DTAPON = x.JBS_DTAPON "
cProced += Chr(10) + "             where R_E_C_N_O_ = nRecno; "
cProced += Chr(10) + "            end if; "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

// Insert na tabela JDB e JDC ---
cProced += Chr(10) + "      if x.JDC_ATIVID <> ' ' then "
cProced += Chr(10) + "         if cKeyJDB <> x.JBS_CODCUR || x.JBS_PERLET || x.JBS_HABILI || x.JBS_TURMA || x.JBS_CODDIS || x.JBS_CODAVA || x.JDC_ATIVID || x.JBS_OUTRAT then "
cProced += Chr(10) + "            cKeyJDB := x.JBS_CODCUR || x.JBS_PERLET || x.JBS_HABILI || x.JBS_TURMA || x.JBS_CODDIS || x.JBS_CODAVA || x.JDC_ATIVID || x.JBS_OUTRAT; "

cProced += Chr(10) + "            select Min( R_E_C_N_O_ ) into nRecno  "
cProced += Chr(10) + "              from "+RetSQLName("JDB")
cProced += Chr(10) + "             where JDB_FILIAL = '"+xFilial("JDB")+"' "
cProced += Chr(10) + "               and JDB_CODCUR = x.JBS_CODCUR "
cProced += Chr(10) + "               and JDB_PERLET = x.JBS_PERLET "
cProced += Chr(10) + "               and JDB_HABILI = x.JBS_HABILI "
cProced += Chr(10) + "               and JDB_TURMA  = x.JBS_TURMA "
cProced += Chr(10) + "               and JDB_CODDIS = x.JBS_CODDIS "
cProced += Chr(10) + "               and JDB_CODAVA = x.JBS_CODAVA "
cProced += Chr(10) + "               and JDB_ATIVID = x.JDC_ATIVID "
cProced += Chr(10) + "               and D_E_L_E_T_ = ' '; "

cProced += Chr(10) + "            if nRecno is null then "
cProced += Chr(10) + "               nLoop := 0;"
cProced += Chr(10) + "               while nLoop = 0 loop "
cProced += Chr(10) + "               begin "
cProced += Chr(10) + "                  insert into "+RetSQLName("JDB")
cProced += Chr(10) + "                     (JDB_FILIAL, JDB_CODCUR,   JDB_PERLET,   JDB_HABILI,   JDB_TURMA,   JDB_CODDIS,   JDB_CODAVA,   JDB_ATIVID,   R_E_C_N_O_) "
cProced += Chr(10) + "                  values   "
cProced += Chr(10) + "                     ('"+xFilial("JDB")+"',        x.JBS_CODCUR, x.JBS_PERLET, x.JBS_HABILI, x.JBS_TURMA, x.JBS_CODDIS, x.JBS_CODAVA, x.JDC_ATIVID, "+RetSQLName("JDB")+"_RECNO.NextVal); "
cProced += Chr(10) + "   	             nLoop := 1; "
cProced += Chr(10) + "               exception "
cProced += Chr(10) + "                  when DUP_VAL_ON_INDEX then "
cProced += Chr(10) + "                        nLoop := 0; "
cProced += Chr(10) + "               end; "
cProced += Chr(10) + "               end loop; "
cProced += Chr(10) + "            end if; "
cProced += Chr(10) + "         end if; "

cProced += Chr(10) + "            select Min( R_E_C_N_O_ ) into nRecno  "
cProced += Chr(10) + "              from "+RetSQLName("JDC")
cProced += Chr(10) + "             where JDC_FILIAL = '"+xFilial("JDC")+"' "
cProced += Chr(10) + "               and JDC_CODCUR = x.JBS_CODCUR "
cProced += Chr(10) + "               and JDC_PERLET = x.JBS_PERLET "
cProced += Chr(10) + "               and JDC_HABILI = x.JBS_HABILI "
cProced += Chr(10) + "               and JDC_TURMA  = x.JBS_TURMA "
cProced += Chr(10) + "               and JDC_CODDIS = x.JBS_CODDIS "
cProced += Chr(10) + "               and JDC_CODAVA = x.JBS_CODAVA "
cProced += Chr(10) + "               and JDC_ATIVID = x.JDC_ATIVID "
cProced += Chr(10) + "               and JDC_NUMRA  = x.JBS_NUMRA "
cProced += Chr(10) + "               and D_E_L_E_T_ = ' '; "

cProced += Chr(10) + "            if nRecno is null then "
cProced += Chr(10) + "               nLoop := 0;"
cProced += Chr(10) + "               while nLoop = 0 loop "
cProced += Chr(10) + "               begin "
cProced += Chr(10) + "                  insert into "+RetSQLName("JDC")
cProced += Chr(10) + "                     (JDC_FILIAL,  JDC_CODCUR,   JDC_PERLET,   JDC_HABILI, JDC_TURMA,   JDC_CODDIS,   JDC_CODAVA,   JDC_ATIVID,  "
cProced += Chr(10) + "                      JDC_NUMRA,   JDC_OUTRAT,   JDC_CONCEI,   JDC_NOTA,    JDC_COMPAR,   JDC_DTCHAM,   R_E_C_N_O_) "
cProced += Chr(10) + "                  values "
cProced += Chr(10) + "                     ('"+xFilial("JDC")+"',         x.JBS_CODCUR, x.JBS_PERLET, x.JBS_HABILI, x.JBS_TURMA, x.JBS_CODDIS, x.JBS_CODAVA, x.JDC_ATIVID,  "
cProced += Chr(10) + "                      x.JBS_NUMRA, x.JBS_OUTRAT, x.JBS_CONCEI, x.JBS_NOTA,  x.JBS_COMPAR, x.JBS_DTCHAM, "+RetSQLName("JDC")+"_RECNO.NextVal); "
cProced += Chr(10) + "   	             nLoop := 1; "
cProced += Chr(10) + "               exception "
cProced += Chr(10) + "                  when DUP_VAL_ON_INDEX then "
cProced += Chr(10) + "                     nLoop := 0; "
cProced += Chr(10) + "               end; "
cProced += Chr(10) + "               end loop; "
cProced += Chr(10) + "            elsif IN_OVER = 1 then "
cProced += Chr(10) + "               update "+RetSQLName("JDC")+" set  "
cProced += Chr(10) + "               JDC_OUTRAT = x.JBS_OUTRAT, JDC_CONCEI = x.JBS_CONCEI, JDC_NOTA = x.JBS_NOTA,  "
cProced += Chr(10) + "                  JDC_COMPAR = x.JBS_COMPAR, JDC_DTCHAM = x.JBS_DTCHAM "
cProced += Chr(10) + "                where R_E_C_N_O_ = nRecno; "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "
cProced += Chr(10) + "   exception "
cProced += Chr(10) + "      when nErro1 then "
cProced += Chr(10) + "         OUT_REJECT := OUT_REJECT + 1;"
cProced += Chr(10) + "   end; "
cProced += Chr(10) + "   update IMP_STATUS set LASTREC = x.R_E_C_N_O_, HORA = sysdate where TIPO = '38' and THRD = IN_THRD; "
cProced += Chr(10) + "   nCommit := nCommit + 1; "
cProced += Chr(10) + "   if nCommit = IN_COMMIT or IN_COMMIT = 0 then "
cProced += Chr(10) + "      commit; "
cProced += Chr(10) + "      nCommit := 0; "
cProced += Chr(10) + "   end if; "
cProced += Chr(10) + "end loop; "
cProced += Chr(10) + "update IMP_STATUS set LASTREC = IN_MAX, HORA = sysdate where TIPO = '38' and THRD = IN_THRD; "
cProced += Chr(10) + "commit; "
cProced += Chr(10) + "end "+cProcName+"; "

if TCSQLExec( cProced ) <> 0
	UserException("Falha na cria็ใo da procedure - " + TCSQLError() )
endif

Return cProcName

                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC138SP  บAutor  ณRafael Rodrigues    บ Data ณ  11/17/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณThread para executar Stored Procedure no banco.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC138SP( aDados )
Local aResult := {}

prepare environment empresa aDados[1] filial aDados[2] tables "JA2"

aResult := TCSPExec( aDados[3], if(aDados[6], 1, 2), aDados[4], aDados[5], aDados[9], aDados[10] )

if type( 'aResult' ) <> 'A'
	AcaLog( aDados[8], "Thread "+Right(aDados[7],3)+" --> Nใo retornou totais." )
else
	AcaLog( aDados[8], "Thread "+Right(aDados[7],3)+" --> Total Processado: " + Str( aResult[1], 7 ) + " - Total Rejeitado: " + Str( aResult[2], 7 ) )
endif

RPCClearEnv()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC138WaitบAutor  ณRafael Rodrigues    บ Data ณ  11/16/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC138Wait( cProcName, nRecs, nThreads, cLogFile, nCommit )
Local i := 0
Local j := 0
Local lOk
Local nThrdSize := NoRound( nRecs / nThreads, 0 ) + 1
Local cQryOff, cQryTot, cQuery, cQryStat
Local nTot := 0
Local aThrdOff := {}
Local nTimeOut := 0
Local nTickCount	:= 0
Local cNotIn

// Antes de iniciar as threads, cria as sequencias no banco
CreateSeq("JBR")
CreateSeq("JBS")
CreateSeq("JDB")
CreateSeq("JDC")

for i := 1 to nThreads
	if (i*nThrdSize)-nThrdSize+1 <= nRecs
		//if File( "xAC138SP."+StrZero(i,3) )
		//	FErase( "xAC138SP."+StrZero(i,3) )
		//endif
		//AcaLog( "xAC138SP."+StrZero(i,3), "Thread de importacao iniciada" )
		//U_xAC138SP( { SM0->M0_CODIGO, SM0->M0_CODFIL, cProcName, (i*nThrdSize)-nThrdSize+1 ,i*nThrdSize, lOver, "xAC138SP."+StrZero(i,3), cLogFile, i } )
		StartJob( "U_xAC138SP", GetEnvServer(), .F., { SM0->M0_CODIGO, SM0->M0_CODFIL, cProcName, (i*nThrdSize)-nThrdSize+1 ,i*nThrdSize, lOver, "xAC138SP."+StrZero(i,3), cLogFile, i, nCommit } )
		j++
	endif
next i

// Deixa i com o numero da proxima thread, se necessario
i := j + 1

if nOpc == 0
	ProcRegua( nRecs )
endif

// So inicia a checagem da IMP_STATUS quando todas as threads estiverem em operacao
cQuery := "select count(*) QUANT from IMP_STATUS where TIPO = '38'"
while !KillApp()
	for j := 1 to 10
		if nOpc == 0
			IncProc( "Aguardando inicializa็ใo dos processos.."+Repl(".",mod(j,2)) )
		endif
		sleep(1000)
		nTimeOut++
	next j
	dbUseArea( .T., "TopConn", TCGenQry(,, ChangeQuery( cQuery )), "QRY", .F., .F. )
	TCSetField( "QRY", "QUANT", "N", 3, 0 )
	if QRY->QUANT == i-1
		QRY->( dbCloseArea() )
		exit
	endif
	QRY->( dbCloseArea() )
	if nTimeOut > 600	// 10 minutos
		AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '  Ap๓s 10 minutos as threads nใo foram todas iniciadas. O processo serแ abortado.' )
		Return .F.
	endif
end

// Seleciona todas que nao possuem atualizacao a mais de 3 minutos
cQryStat := "select THRD, MINREC, MAXREC, LASTREC as LAST, ( ( LASTREC - MINREC ) + 1 ) AS PROCESSADO, ROUND( ( ( LASTREC - MINREC ) + 1 )/ ( ( MAXREC - MINREC ) - 1 ) * 100, 2) AS PERCENTUAL, To_Char( HORA, 'dd/mm/yyyy hh:mi:ss' ) as HORA from imp_status where TIPO = '38' order by HORA, THRD"
cQryOff  := "select THRD, MINREC, MAXREC, LASTREC as LAST from IMP_STATUS where TIPO = '38' and MAXREC > LASTREC and sysdate > ( HORA+(10/1440) )"
cQryTot  := "select sum( ( LASTREC - MINREC ) + 1 ) as TOTAL from IMP_STATUS where TIPO = '38'"

while !KillApp() .and. nTot < nRecs
	dbUseArea( .T., "TopConn", TCGenQry(,, ChangeQuery( cQryOff )), "QRY", .F., .F. )

	while QRY->( !eof() )
		if aScan( aThrdOff, QRY->THRD ) == 0 .and. len( aThrdOff ) < 50
			aAdd(  aThrdOff, QRY->THRD )
		
			AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '  Thread '+StrZero(QRY->THRD,3)+' nใo processa hแ mais de 10 minutos e pode ter sido terminada inesperadamente. Analise log do TopConnect para maiores detalhes. A thread '+StrZero(i,3)+' foi iniciada em substitui็ใo.' )
			StartJob( "U_xAC138SP", GetEnvServer(), .F., { SM0->M0_CODIGO, SM0->M0_CODFIL, cProcName, QRY->LAST+1 , QRY->MAXREC, lOver, "xAC138SP."+StrZero(i,3), cLogFile, i, nCommit } )
			i++
		elseif len( aThrdOff ) >= 50
			AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '  O n๚mero de threads terminadas inesperadamente atingiu 50. O processo serแ abortado. Analise o log do TopConnect para maiores informa็๕es.' )
			QRY->( dbCloseArea() )
			Return .F.
		endif
		QRY->( dbSkip() )
	end
	QRY->( dbCloseArea() )
    
	if Len( aThrdOff ) > 0
		cNotIn := " and THRD not in ("
		aEval( aThrdOff, {|x| cNotIn += "'"+x+"', " } )
		cNotIn := Left( cNotIn, len(cNotIn)-2 )+")"
	else
		cNotIn := " "
	endif
	
	// Controla o status da grava็ใo
	dbUseArea( .T., "TopConn", TCGenQry(,, ChangeQuery( cQryTot )), "QRY", .F., .F. )
	nTot := QRY->TOTAL
	QRY->( dbCloseArea() )

	// Atualiza relatorio de status das threads.
	//cQryStat := "select THRD, MINREC, MAXREC, LASTREC as LAST, ( LASTREC - MINREC ) AS PROCESSADO, ROUND( ( LASTREC - MINREC ) / ( MAXREC - MINREC ) * 100, 2) AS PERCENTUAL, To_Char( HORA, 'dd/mm/yyyy hh:mi:ss' ) as HORA from imp_status where TIPO = '38' order by HORA, THRD"
	
	dbUseArea( .T., "TopConn", TCGenQry(,, ChangeQuery( cQryStat )), "QRY", .F., .F. )
	AcaLog( "xRelat138.log", Repl("=",75) )
	AcaLog( "xRelat138.log", " " )
	AcaLog( "xRelat138.log", "Status das threads as "+Time()+" de "+dtoc(date()) )
	AcaLog( "xRelat138.log", " " )
	AcaLog( "xRelat138.log", "Thrd  MinRec    MaxRec    LastRec   Process.  Percent.  dd/mm/aaaa hh:mi:ss" )
	AcaLog( "xRelat138.log", "----  --------  --------  --------  --------  --------  -------------------" )
	while QRY->( !eof() )
		QRY->( AcaLog( "xRelat138.log", PadR( THRD, 4 ) + "  " + Transform( MINREC, "@E 99999999" ) + "  " + Transform( MAXREC, "@E 99999999" ) + "  " + Transform( LAST, "@E 99999999" ) + "  " + Transform( PROCESSADO, "@E 99999999" ) + "  " + Transform( PERCENTUAL, "@E 99999.99" ) + "  " + HORA ) )
		QRY->( dbSkip() )
	end
	AcaLog( "xRelat138.log", " " )
	QRY->( dbCloseArea() )

	if nTot < nRecs
		// Aguarda 30 segundos at้ fazer nova verifica็ใo.
		nTickCount++
		for j := 1 to 30
			if nOpc == 0
				IncProc( Alltrim(Str((nTot/nRecs)*100,6,2))+"% concluํdo.."+Repl(".",mod(j,2)) )
			endif
			sleep(1000)	// 1 segundo
		next j
	endif

	// DEBUG
	AcaLog( 'xDebug38.log', dtoc(date())+" "+Time()+" - "+Alltrim(Str((nTot/nRecs)*100,6,2))+"% concluํdo..." )
	
	if nTickCount == 60	// 30 minutos
		nTickCount := 0
	endif
end

AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '  Todas as threads finalizadas.' )
// Elimina as sequencias do banco
DropSeq("JBR")
DropSeq("JBS")
DropSeq("JDB")
DropSeq("JDC")


// Grava log's de rejeicao
i := 0
dbUseArea( .T., "TopConn", TCGenQry(,,ChangeQuery("Select * from IMP_LOG38")), "QRYLOG", .F., .F. )
while QRYLOG->( !eof() )
	i++
	AcaLog( cLogFile, RTrim( QRYLOG->MSG_LOG ) )
	QRYLOG->( dbSkip() )
end
QRYLOG->( dbCloseArea() )

Return i == 0


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXAC13800  บAutor  ณMicrosiga           บ Data ณ  12/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CreateSeq( cAlias )
Local nRecno	:= 0
Local cQuery	:= "SELECT Max(R_E_C_N_O_) REC from "+RetSQLName(cAlias)

dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRBGETREC", .F., .F. )
nRecno := TRBGETREC->REC + 1

TRBGETREC->( dbCloseArea() )


if TCSQLExec( "Create sequence "+RetSQLName(cAlias)+"_RECNO start with "+Alltrim(Str(nRecno))+" increment by 1" ) <> 0
	UserException("Falha na cria็ใo da sequence para o alias "+cAlias+": " + TCSQLError() )
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXAC13800  บAutor  ณMicrosiga           บ Data ณ  12/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DropSeq( cAlias )

TCSQLExec( "Drop sequence "+RetSQLName(cAlias)+"_RECNO " )

Return