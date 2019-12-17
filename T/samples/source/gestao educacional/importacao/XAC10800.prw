#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC10800  ºAutor  ³Rafael Rodrigues    º Data ³  11/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Curso Padrao                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC10800( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC10800'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local nPos		:= 0
Local lTRB10801	:= .F.
Local lTRB10802	:= .F.
Local nDrv01	:= 0
Local nDrv02	:= 0
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local nRecs		:= 0
Local nRec01	:= 0
Local nRec02	:= 0
Local cArq01	:= ""
Local i

Default nOpcX	:= 0
Default aTables := {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JAF_COD"   , "C", 006, 0 } )
aAdd( aStru, { "JAF_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAF_DESC"  , "C", 060, 0 } )
aAdd( aStru, { "JAF_DESMEC", "C", 200, 0 } )
aAdd( aStru, { "JAF_AREA"  , "C", 006, 0 } )
aAdd( aStru, { "JAF_CLASFI", "C", 015, 0 } )
aAdd( aStru, { "JAF_CCUSTO", "C", 009, 0 } )
aAdd( aStru, { "JAF_ATIVO" , "C", 001, 0 } )
aAdd( aStru, { "JAF_CARGA" , "N", 005, 0 } )
aAdd( aStru, { "JAF_CARMIN", "N", 005, 0 } )
aAdd( aStru, { "JAF_TIPHOR", "C", 001, 0 } )
aAdd( aStru, { "JAF_PROVAO", "C", 001, 0 } )
aAdd( aStru, { "JAF_CONCEI", "C", 004, 0 } )
aAdd( aStru, { "JAF_REGIME", "C", 003, 0 } )
aAdd( aStru, { "JAF_CRIAVA", "C", 001, 0 } )
aAdd( aStru, { "JAF_EQVCON", "C", 006, 0 } )
aAdd( aStru, { "JAF_QTDATV", "N", 002, 0 } )
aAdd( aStru, { "JAF_CCONTB", "C", 020, 0 } )
aAdd( aStru, { "JAF_PROCUR", "C", 001, 0 } )
aAdd( aStru, { "JAW_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAW_DPERLE", "C", 030, 0 } )
aAdd( aStru, { "JAW_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JAW_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAW_QTDOPT", "N", 002, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Cursos Padrão', 'AC10801', aClone( aStru ), 'TRB10801', .F., "JAF_COD, JAF_VERSAO, JAW_PERLET, JAW_HABILI", {|| "JAF_COD between '"+mv_par01+"' and '"+mv_par02+"'" } } )

aStru := {}

aAdd( aStru, { "JAF_COD"   , "C", 006, 0 } )
aAdd( aStru, { "JAF_VERSAO", "C", 003, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAF_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAF_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Dispositivos legais dos Cursos Padrão', 'AC10802', aClone( aStru ), 'TRB10802', .F., "JAF_COD, JAF_VERSAO, JAF_SEQ", {|| "JAF_COD between '"+mv_par01+"' and '"+mv_par02+"'" } } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a janela para selecao de arquivos e importacao dos temporarios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpc == 2	// So processamento
	U_xOpen( aTables, aFiles, aDriver, .F. )
else
	aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver )
	
	if nOpc == 1	// So montagem
		Return aTables
	endif
endif

if Empty( aTables )	//Nenhum arquivo importado.
	if nOpc == 0
		Aviso( 'Problema', 'Nenhum arquivo pôde ser importado para este processo.', {'Ok'} )
	endif
else

	nPos := aScan( aTables, {|x| x[1] == "TRB10801"} )
	if nPos > 0
		lTRB10801	:= .T.
		nDrv01	:= aScan( aDriver, aTables[nPos, 3] )
		nRec01	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
		cArq01	:= aTables[nPos, 2]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB10802"} )
	if nPos > 0
		lTRB10802	:= .T.
		nDrv02	:= aScan( aDriver, aTables[nPos, 3] )
		nRec02	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lTRB10801 .and. nDrv01 <> 3
		TRB10801->( dbGoBottom() )
		if Empty( TRB10801->JAF_COD )
			RecLock( "TRB10801", .F. )
			TRB10801->( dbDelete() )
			TRB10801->( msUnlock() )
		endif
	endif

	if lTRB10802 .and. nDrv02 <> 3
		TRB10802->( dbGoBottom() )
		if Empty( TRB10802->JAF_COD )
			RecLock( "TRB10802", .F. )
			TRB10802->( dbDelete() )
			TRB10802->( msUnlock() )
		endif
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena os arquivos de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nOpc == 0
		MsgRun( 'Ordenando arquivos...',, {||	if( lTRB10801 .and. nDrv01 <> 3, TRB10801->( IndRegua( "TRB10801", cIDX01, "JAF_COD+JAF_VERSAO+JAW_PERLET+JAW_HABILI" ) ), NIL ),;
												if( lTRB10802 .and. nDrv02 <> 3, TRB10802->( IndRegua( "TRB10802", cIDX02, "JAF_COD+JAF_VERSAO+JAF_SEQ" ) ), NIL ) } )
	else
		Eval( {||	if( lTRB10801 .and. nDrv01 <> 3, TRB10801->( IndRegua( "TRB10801", cIDX01, "JAF_COD+JAF_VERSAO+JAW_PERLET+JAW_HABILI" ) ), NIL ),;
					if( lTRB10802 .and. nDrv02 <> 3, TRB10802->( IndRegua( "TRB10802", cIDX02, "JAF_COD+JAF_VERSAO+JAF_SEQ" ) ), NIL ) } )
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lTRB10801
		if nDrv01 <> 3
			aObrig := {}
			aAdd( aObrig, { '!Empty(JAF_COD)    '	, 'JAF_COD não informado.' } )
			aAdd( aObrig, { '!Empty(JAF_VERSAO) '	, 'JAF_VERSAO não informado.' } )
			aAdd( aObrig, { '!Empty(JAF_DESC)   '	, 'JAF_DESC não informado.' } )
			aAdd( aObrig, { '!Empty(JAF_AREA)   '	, 'JAF_AREA não informado.' } )
			aAdd( aObrig, { 'JAF_ATIVO$"12"'		, 'JAF_ATIVO deve ser 1 (Sim) ou 2 (Não).' } )
			aAdd( aObrig, { '!Empty(JAF_CARGA)  '	, 'JAF_CARGA não informado.' } )
			aAdd( aObrig, { 'JAF_TIPHOR$"12"'		, 'JAF_TIPHOR deve ser 1 (Hora Aula) ou 2 (Hora Relógio).' } )
			aAdd( aObrig, { 'JAF_PROVAO$"12"'		, 'JAF_PROVAO deve ser 1 (Sim) ou 2 (Não).' } )
			aAdd( aObrig, { 'JAF_CRIAVA$"12"'		, 'JAF_CRIAVA deve ser 1 (Nota) ou 2 (Conceito).' } )
			aAdd( aObrig, { 'JAF_REGIME$"001^002^003^004"'	, 'JAF_REGIME deve ser 001 (Anual), 002 (Semestral), 003 (Trimestral) ou 004 (Bimestral).' } )
			aAdd( aObrig, { '!Empty(JAW_PERLET) '	, 'JAW_PERLET não informado.' } )
			aAdd( aObrig, { '!Empty(JAW_DPERLE) '	, 'JAW_DPERLE não informado.' } )
			aAdd( aObrig, { '!Empty(JAW_CARGA)  '	, 'JAW_CARGA não informado.' } )
			aAdd( aObrig, { 'JAF_AREA == Posicione( "JAG", 1, xFilial("JAG")+JAF_AREA, "JAG_CODIGO" )'	, 'JAF_AREA não cadastrado na tabela JAG.' } )
			aAdd( aObrig, { 'Empty(JAF_CLASFI) .or. JAF_CLASFI == Posicione( "JBX", 1, xFilial("JBX")+JAF_CLASFI, "JBX_COD" )'	, 'JAF_CLASFI não cadastrado na tabela JBX.' } )
			aAdd( aObrig, { 'Empty(JAF_CCUSTO) .or. JAF_CCUSTO == Posicione( "SI3", 1, xFilial("SI3")+JAF_CCUSTO, "I3_CUSTO" )'	, 'JAF_CCUSTO não cadastrado na tabela SI3.' } )
			aAdd( aObrig, { 'JAF_CRIAVA != "2" .or. JAF_EQVCON == Posicione( "JDE", 1, xFilial("JDE")+JAF_EQVCON, "JDE_CODIGO" )'	, 'JAF_EQVCON deve ser informado e existir na tabela JDE quando critério de avaliação for conceito.' } )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³verifica chaves unicas e consistencias pre-definidas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )
			if nOpc == 0
				Processa( { |lEnd| lOk := U_xACChkInt( "TRB10801", "JAF_COD+JAF_VERSAO+JAW_PERLET+JAW_HABILI", .F., aObrig, cLogFile, @lEnd ) .and. lOk, lOk := U_xAC108CH( @lEnd, cLogFile ) .and. lOk }, 'Validando '+aFiles[1,1] )
			else
				lOk := U_xACChkInt( "TRB10801", "JAF_COD+JAF_VERSAO+JAW_PERLET+JAW_HABILI", .F., aObrig, cLogFile, @lEnd ) .and. U_xAC108CH( @lEnd, cLogFile )
			endif
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[1,1]+'".' )
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )
			if nOpc == 0
				Processa( { |lEnd| lOk := xAC10801Chk( @lEnd, aTables, cLogFile ) }, 'Validando '+aFiles[1,1] )
			else
				lOk := xAC10801Chk( @lEnd, aTables, cLogFile )
			endif
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[1,1]+'".' )
		endif
	endif	

	if lTRB10802
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAF_COD)    '	, 'Código não informado.' } )
		aAdd( aObrig, { '!Empty(JAF_VERSAO) '	, 'Versão não informada.' } )
		aAdd( aObrig, { '!Empty(JAF_SEQ)    '	, 'Sequencial de linha não informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAF_COD == Posicione( "JAF", 1, xFilial("JAF")+JAF_COD+JAF_VERSAO, "JAF_COD" ) .or. ( Select("TRB10801") > 0 .and. TRB10801->( dbSeek( TRB10802->JAF_COD+TRB10802->JAF_VERSAO, .F. ) ) )'	, 'Curso Padrão não cadastrado na tabela JAF e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JAF_COD == Posicione( "JAF", 1, xFilial("JAF")+JAF_COD+JAF_VERSAO, "JAF_COD" ) .or. ( Select("TRB10801") > 0 .and. U_xAC108Qry( JAF_COD, JAF_VERSAO, "'+cArq01+'" ) )'	, 'Curso Padrão não cadastrado na tabela JAF e não presente nos arquivos de importação.' } )
		endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[2,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB10802", "JAF_COD+JAF_VERSAO+JAF_SEQ", .F., aObrig, cLogFile, @lEnd ) .and. lOk }, 'Validando '+aFiles[2,1] )
		else
			lOk := U_xACChkInt( "TRB10802", "JAF_COD+JAF_VERSAO+JAF_SEQ", .F., aObrig, cLogFile, @lEnd ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[2,1]+'".' )
	endif	
	
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Foram detectadas inconsistências. Impossível prosseguir.' )
		if nOpc == 0 .and. Aviso( 'Impossível Prosseguir!', 'Foram detectadas inconsistências. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a gravacao dos dados nas tabelas do sistema³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if nOpc == 0
			Processa( { |lEnd| ProcRegua( nRecs ), lOk := xAC10801Grv( @lEnd, aFiles[1,1], nRec01 ) .and. xAC10802Grv( @lEnd, aFiles[2,1], nRec02 ) }, 'Gravação em andamento' )
		else
			lOk := xAC10801Grv( @lEnd, aFiles[1,1], nRec01 ) .and. xAC10802Grv( @lEnd, aFiles[2,1], nRec02 )
		endif
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Processo de gravação interrompido pelo usuário. Será necessário reiniciar o processo de importação.' )
			if nOpc == 0
				Aviso( 'Operação Cancelada!', 'O processo de gravação foi interrompido pelo usuário. Será necessário reiniciar o processo de importação.', {'Ok'} )
			endif
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Gravação realizada com sucesso.' )
			if nOpc == 0
				Aviso( 'Sucesso!', 'Importação realizada com sucesso.', {'Ok'} )
			endif
		endif
	endif
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Elimina os arquivos de trabalho criados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
for i := 1 to len( aTables )
	(aTables[i][1])->( dbCloseArea() )
	if aTables[i][3] == aDriver[1]
		FErase( aTables[i][2]+GetDBExtension() )
	endif
next i

if lTRB10801 .and. nDrv01 <> 3
	FErase( cIDX01 + OrdBagExt() )
endif
if lTRB10802 .and. nDrv02 <> 3
	FErase( cIDX02 + OrdBagExt() )
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC10801GrvºAutor  ³Rafael Rodrigues   º Data ³  11/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados do arquivo principal na base.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC10800                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC10801Grv( lEnd, cTitulo, nRecs )
Local cFilJAF	:= xFilial("JAF")	// Criada para ganhar performance
Local cFilJAW	:= xFilial("JAW")	// Criada para ganhar performance
Local cCurso	:= ""
Local i			:= 0
Local lSeek

if Select( "TRB10801" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB10801->( dbGoTop() )

JAF->( dbSetOrder(1) )

while TRB10801->( !eof() ) .and. !lEnd
	if nOpc == 0	
		IncProc( cTitulo+', linha '+StrZero( ++i, 8 )+' de '+StrZero( nRecs, 8 )+'...' )
	endif
	
	begin transaction
	
	if cCurso <> TRB10801->JAF_COD+TRB10801->JAF_VERSAO
		lSeek := JAF->( dbSeek( cFilJAF+TRB10801->JAF_COD+TRB10801->JAF_VERSAO ) )
		if lOver .or. !lSeek
			RecLock( "JAF", !lSeek )
			JAF->JAF_FILIAL	:= cFilJAF
			JAF->JAF_COD	:= TRB10801->JAF_COD
			JAF->JAF_VERSAO	:= TRB10801->JAF_VERSAO
			JAF->JAF_DESC	:= TRB10801->JAF_DESC
			JAF->JAF_DESMEC	:= TRB10801->JAF_DESMEC
			JAF->JAF_AREA	:= TRB10801->JAF_AREA
			JAF->JAF_CLASFI	:= TRB10801->JAF_CLASFI
			JAF->JAF_CCUSTO	:= TRB10801->JAF_CCUSTO
			JAF->JAF_ATIVO	:= TRB10801->JAF_ATIVO
			JAF->JAF_CARGA	:= TRB10801->JAF_CARGA
			JAF->JAF_CARMIN	:= TRB10801->JAF_CARMIN
			JAF->JAF_TIPHOR	:= TRB10801->JAF_TIPHOR
			JAF->JAF_PROVAO	:= TRB10801->JAF_PROVAO
			JAF->JAF_REGIME	:= TRB10801->JAF_REGIME
			JAF->JAF_CONCEI	:= TRB10801->JAF_CONCEI
			JAF->JAF_CRIAVA	:= TRB10801->JAF_CRIAVA
			JAF->JAF_EQVCON	:= TRB10801->JAF_EQVCON
			JAF->( msUnlock() )
		endif
		cCurso := TRB10801->JAF_COD+TRB10801->JAF_VERSAO
	endif

	lSeek := JAW->( dbSeek( cFilJAW+TRB10801->JAF_COD+TRB10801->JAF_VERSAO+TRB10801->JAW_PERLET+TRB10801->JAW_HABILI ) )
	if lOver .or. !lSeek
		RecLock( "JAW", !lSeek )
		JAW->JAW_FILIAL	:= cFilJAW
		JAW->JAW_CURSO	:= TRB10801->JAF_COD
		JAW->JAW_VERSAO	:= TRB10801->JAF_VERSAO
		JAW->JAW_PERLET	:= TRB10801->JAW_PERLET
		JAW->JAW_DPERLE	:= TRB10801->JAW_DPERLE
		JAW->JAW_HABILI	:= TRB10801->JAW_HABILI
		JAW->JAW_CARGA	:= TRB10801->JAW_CARGA
		JAW->JAW_QTDOPT	:= TRB10801->JAW_QTDOPT
		JAW->( msUnlock() )
	endif
	
	end transaction

	TRB10801->( dbSkip() )
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC10802GrvºAutor  ³Rafael Rodrigues   º Data ³  11/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados dos Conteudos na base.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC10800                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC10802Grv( lEnd, cTitulo, nRecs )
Local cFilJAF	:= xFilial("JAF")	// Criada para ganhar performance
Local i			:= 0
Local cCurso
Local cMemo

if Select( "TRB10802" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB10802->( dbGoTop() )

JAF->( dbSetOrder(1) )

while TRB10802->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cCurso	:= TRB10802->JAF_COD+TRB10802->JAF_VERSAO
	
	while cCurso == TRB10802->JAF_COD+TRB10802->JAF_VERSAO .and. TRB10802->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB10802->( nRecs ), 6 )+'...' )
		endif

		cMemo += StrTran( TRB10802->JAF_MEMO1, '\13\10', CRLF )
		
		TRB10802->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAF->( dbSeek( cFilJAF+cCurso ) ) .and. ( lOver .or. Empty( JAF->JAF_MEMO1 ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAF_DISLEG³
		//³e armazena o codigo do memo no campo JAF_MEMO1. Sobrescreve caso JAF_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JAF", .F. )
		MSMM( JAF->JAF_MEMO1, TamSX3("JAF_DISLEG")[1],, cMemo, 1,,, "JAF", "JAF_MEMO1" )
		JAF->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC108CH  ºAutor  ³Rafael Rodrigues    º Data ³  11/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida se a carga horaria dos periodos eh igual aa carga    º±±
±±º          ³horaria do curso.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC10800                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC108CH( lEnd, cLogFile )
Local lRet		:= .T.
Local nCHCur	:= 0
Local nCHPer	:= 0
Local cCurso	:= ""
Local cVersao	:= ""
Local nLinCu	:= 0
Local nLinVe	:= 0
Local aAtivo	:= {}

// Tabela no Top recebe tratamento via Select
TRB10801->( dbGoTop() )
	
cCurso	:= TRB10801->JAF_COD
cVersao	:= TRB10801->JAF_VERSAO
nCHCur	:= TRB10801->JAF_CARGA
while TRB10801->( !eof() ) .and. !lEnd

	cCurso	:= TRB10801->JAF_COD
	nLinCu	:= TRB10801->( Recno() )
	aAtivo	:= {}
	while TRB10801->( !eof() ) .and. !lEnd .and. TRB10801->JAF_COD == cCurso

		if TRB10801->JAF_ATIVO == "1" .and. aScan( aAtivo, TRB10801->JAF_VERSAO ) == 0
			aAdd( aAtivo, TRB10801->JAF_VERSAO )
		endif
		
		cVersao	:= TRB10801->JAF_VERSAO
		nCHCur	:= TRB10801->JAF_CARGA
		nLinVe	:= TRB10801->( Recno() )
		nCHPer	:= 0
		while TRB10801->( !eof() ) .and. !lEnd .and. TRB10801->JAF_COD+TRB10801->JAF_VERSAO == cCurso+cVersao
			nCHPer += TRB10801->JAW_CARGA
			TRB10801->( dbSkip() )
		end
		
		if nCHCur > nCHPer
			lRet := .F.
			AcaLog( cLogFile, '  Inconsistência no curso '+cCurso+', versão '+cVersao+': A soma das cargas horárias dos períodos ('+StrZero( nCHPer, 5 )+') deve ser igual ou superior à carga horária total do curso ('+StrZero( nCHCur, 5 )+').' )
		endif
	end
	if len( aAtivo ) > 1
		AcaLog( cLogFile, '  Inconsistência no curso '+cCurso+': Não pode existir mais de uma versão ativa para o mesmo curso.' )
	endif
end

lRet := lRet .and. !lEnd

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC108Chk ºAutor  ³Rafael Rodrigues    º Data ³ 04/FEV/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida os dados a serem importados quando o driver escolhidoº±±
±±º          ³eh TopConnect                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases - GE                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC10801Chk( lEnd, aTables, cLogFile )
Local lOk := .T.
Local cQuery

ProcRegua(8)

if lEnd
	Return .F.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida campos chave em branco     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpc == 0
	IncProc( 'Procurando campos-chave em branco...' )
endif

cQuery := "select count(*) as QUANT "
cQuery += "  from "+aTables[1,2]
cQuery += " where JAF_COD    is null or JAF_COD    = '' "
cQuery += "    or JAF_VERSAO is null or JAF_VERSAO = '' "
cQuery += "    or JAW_PERLET is null or JAW_PERLET = '' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRB108VLD", .F., .F. )
TCSetField( "TRB108VLD", "QUANT", "N", 10, 0 )

lOk := lOk .and. TRB108VLD->QUANT == 0

if TRB108VLD->QUANT > 0
	AcaLog( cLogFile, '  Existem '+Alltrim( Str( TRB108VLD->QUANT ) )+' registros com campos-chave em branco ou nulos na tabela.' )
	TRB108VLD->( dbSkip() )
end
TRB108VLD->( dbCloseArea() )

if lEnd
	Return .F.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida chaves duplicadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpc == 0
	IncProc( 'Procurando chaves duplicadas...' )
endif

cQuery := "select JAF_COD, JAF_VERSAO, JAW_PERLET, JAW_HABILI "
cQuery += "  from "+aTables[1,2]
cQuery += " where JAF_COD    is not null and JAF_COD    != '' "
cQuery += "   and JAF_VERSAO is not null and JAF_VERSAO != '' "
cQuery += "   and JAW_PERLET is not null and JAW_PERLET != '' "
cQuery += " group by JAF_COD, JAF_VERSAO, JAW_PERLET, JAW_HABILI "
cQuery += "having count(*) > 1 "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRB108VLD", .F., .F. )

lOk := lOk .and. TRB108VLD->( eof() )

while !lEnd .and. TRB108VLD->( !eof() )
	AcaLog( cLogFile, '  Duplicidade de chave JAF_COD+JAF_VERSAO+JAW_PERLET+JAW_HABILI no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+', período letivo '+Alltrim( TRB108VLD->JAW_PERLET )+', habilitação '+Alltrim( TRB108VLD->JAW_HABILI )+'.' )
	TRB108VLD->( dbSkip() )
end
TRB108VLD->( dbCloseArea() )

if lEnd
	Return .F.
endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida diferencas de carga horaria³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpc == 0
	IncProc( 'Procurando diferenças em cargas horárias...' )
endif

cQuery := "select JAF_COD, JAF_VERSAO, JAF_CARGA, sum(JAW_CARGA) as JAW_CARGA "
cQuery += "  from "+aTables[1,2]
cQuery += " where JAF_COD    is not null and JAF_COD    != '' "
cQuery += "   and JAF_VERSAO is not null and JAF_VERSAO != '' "
cQuery += "   and JAW_PERLET is not null and JAW_PERLET != '' "
cQuery += " group by JAF_COD, JAF_VERSAO, JAF_CARGA "
cQuery += "having sum(JAW_CARGA) < JAF_CARGA "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRB108VLD", .F., .F. )
TCSetField( "TRB108VLD", "JAF_CARGA", "N", 5, 0 )
TCSetField( "TRB108VLD", "JAW_CARGA", "N", 5, 0 )

lOk := lOk .and. TRB108VLD->( eof() )

while !lEnd .and. TRB108VLD->( !eof() )
	AcaLog( cLogFile, '  Inconsistência no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+': A soma das cargas horárias dos períodos ('+StrZero( TRB108VLD->JAW_CARGA, 5 )+') deve ser igual ou superior à carga horária total do curso ('+StrZero( TRB108VLD->JAF_CARGA, 5 )+').' )
	TRB108VLD->( dbSkip() )
end
TRB108VLD->( dbCloseArea() )

if lEnd
	Return .F.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida campos obrigatorios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpc == 0
	IncProc( 'Procurando campos obrigatórios não preenchidos...' )
endif

cQuery := "select distinct JAF_COD, JAF_VERSAO, JAW_PERLET "
cQuery += "  from "+aTables[1,2]
cQuery += " where JAF_COD    is not null and JAF_COD    != '' "
cQuery += "   and JAF_VERSAO is not null and JAF_VERSAO != '' "
cQuery += "   and JAW_PERLET is not null and JAW_PERLET != '' "
cQuery += "   and ( JAF_DESC   is null or JAF_DESC   = '' "
cQuery += "      or JAF_AREA   is null or JAF_AREA   = '' "
cQuery += "      or JAF_CARGA  is null or JAF_CARGA  = 0 "
cQuery += "      or JAW_DPERLE is null or JAW_DPERLE = '' "
cQuery += "      or JAW_CARGA  is null or JAW_CARGA  = 0 ) "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRB108VLD", .F., .F. )

lOk := lOk .and. TRB108VLD->( eof() )

while !lEnd .and. TRB108VLD->( !eof() )
	AcaLog( cLogFile, '  Inconsistência no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+', período letivo '+Alltrim( TRB108VLD->JAW_PERLET )+', habilitação '+Alltrim( TRB108VLD->JAW_HABILI )+': Existe, campos obrigatórios em branco ou nulos.' )
	TRB108VLD->( dbSkip() )
end
TRB108VLD->( dbCloseArea() )

if lEnd
	Return .F.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida campos com opcoes fixas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpc == 0
	IncProc( 'Procurando campos com preenchimento inválido...' )
endif

cQuery := "select * "
cQuery += "  from "+aTables[1,2]
cQuery += " where JAF_COD    is not null and JAF_COD    != '' "
cQuery += "   and JAF_VERSAO is not null and JAF_VERSAO != '' "
cQuery += "   and JAW_PERLET is not null and JAW_PERLET != '' "
cQuery += "   and ( JAF_ATIVO  not in ('1', '2') "
cQuery += "      or JAF_TIPHOR not in ('1', '2') "
cQuery += "      or JAF_PROVAO not in ('1', '2') "
cQuery += "      or JAF_CRIAVA not in ('1', '2') "
cQuery += "      or JAF_REGIME not in ('001', '002', '003', '004' ) "
cQuery += "      or ( JAF_CRIAVA != '1' and ( JAF_EQVCON is null or JAF_EQVCON = '' ) ) )"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRB108VLD", .F., .F. )

lOk := lOk .and. TRB108VLD->( eof() )

while !lEnd .and. TRB108VLD->( !eof() )
	if !TRB108VLD->JAF_ATIVO$"12"
		AcaLog( cLogFile, '  Inconsistência no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+', período letivo '+Alltrim( TRB108VLD->JAW_PERLET )+': JAF_ATIVO deve ser 1 (Sim) ou 2 (Não).' )
	endif
	if !TRB108VLD->JAF_TIPHOR$"12"
		AcaLog( cLogFile, '  Inconsistência no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+', período letivo '+Alltrim( TRB108VLD->JAW_PERLET )+': JAF_TIPHOR deve ser 1 (Hora Aula) ou 2 (Hora Relógio).' )
	endif
	if !TRB108VLD->JAF_PROVAO$"12"
		AcaLog( cLogFile, '  Inconsistência no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+', período letivo '+Alltrim( TRB108VLD->JAW_PERLET )+': JAF_PROVAO deve ser 1 (Sim) ou 2 (Não).' )
	endif
	if !TRB108VLD->JAF_CRIAVA$"12"
		AcaLog( cLogFile, '  Inconsistência no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+', período letivo '+Alltrim( TRB108VLD->JAW_PERLET )+': JAF_CRIAVA deve ser 1 (Nota) ou 2 (Conceito).' )
	endif
	if !TRB108VLD->JAF_REGIME$"001^002^003^004"
		AcaLog( cLogFile, '  Inconsistência no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+', período letivo '+Alltrim( TRB108VLD->JAW_PERLET )+': JAF_REGIME deve ser 001 (Anual), 002 (Semestral), 003 (Trimestral) ou 004 (Bimestral).' )
	endif
	if TRB108VLD->JAF_CRIAVA != "1" .and. !Empty(TRB108VLD->JAF_EQVCON)
		AcaLog( cLogFile, '  Inconsistência no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+', período letivo '+Alltrim( TRB108VLD->JAW_PERLET )+': JAF_QEVCON deve ser informado quando JAF_CRIAVA for 2.' )
	endif
	TRB108VLD->( dbSkip() )
end
TRB108VLD->( dbCloseArea() )

if lEnd
	Return .F.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³JAF_AREA deve estar na JAG³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpc == 0
	IncProc( 'Validando relacionamento do campo JAF_AREA...' )
endif

cQuery := "select distinct JAF_COD, JAF_VERSAO, JAW_PERLET "
cQuery += "  from "+aTables[1,2]
cQuery += " where JAF_COD    is not null and JAF_COD    != '' "
cQuery += "   and JAF_VERSAO is not null and JAF_VERSAO != '' "
cQuery += "   and JAW_PERLET is not null and JAW_PERLET != '' "
cQuery += "   and JAF_AREA not in ( "
cQuery += "       select JAG_CODIGO "
cQuery += "         from "+RetSQLName("JAG")+" JAG "
cQuery += "        where JAG_FILIAL = '"+xFilial("JAG")+"' "
cQuery += "          and JAG_CODIGO = JAF_AREA "
cQuery += "          and D_E_L_E_T_ != '*' ) "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRB108VLD", .F., .F. )

lOk := lOk .and. TRB108VLD->( eof() )

while !lEnd .and. TRB108VLD->( !eof() )
	AcaLog( cLogFile, '  Inconsistência no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+', período letivo '+Alltrim( TRB108VLD->JAW_PERLET )+': JAF_AREA deve estar cadastrado na tabela JAG.' )
	TRB108VLD->(dbSkip())
end
TRB108VLD->( dbCloseArea() )

if lEnd
	Return .F.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³JAF_CLASFI deve ser branco ou estar na JBX³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpc == 0
	IncProc( 'Validando relacionamento do campo JAF_CLASFI...' )
endif

cQuery := "select distinct JAF_COD, JAF_VERSAO, JAW_PERLET "
cQuery += "  from "+aTables[1,2]
cQuery += " where JAF_COD    is not null and JAF_COD    != '' "
cQuery += "   and JAF_VERSAO is not null and JAF_VERSAO != '' "
cQuery += "   and JAW_PERLET is not null and JAW_PERLET != '' "
cQuery += "   and JAF_CLASFI is not null and JAF_CLASFI != '' "
cQuery += "   and JAF_CLASFI not in ( "
cQuery += "       select JBX_COD "
cQuery += "         from "+RetSQLName("JBX")+" JBX "
cQuery += "        where JBX_FILIAL = '"+xFilial("JBX")+"' "
cQuery += "          and JBX_COD = JAF_CLASFI "
cQuery += "          and D_E_L_E_T_ != '*' ) "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRB108VLD", .F., .F. )

lOk := lOk .and. TRB108VLD->( eof() )

while !lEnd .and. TRB108VLD->( !eof() )
	AcaLog( cLogFile, '  Inconsistência no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+', período letivo '+Alltrim( TRB108VLD->JAW_PERLET )+': JAF_CLASFI deve ser branco ou estar cadastrado na tabela JBX.' )
	TRB108VLD->(dbSkip())
end
TRB108VLD->( dbCloseArea() )

if lEnd
	Return .F.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³JAF_CCUSTO deve ser branco ou estar na SI3³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpc == 0
	IncProc( 'Validando relacionamento do campo JAF_CCUSTO...' )
endif

cQuery := "select distinct JAF_COD, JAF_VERSAO, JAW_PERLET "
cQuery += "  from "+aTables[1,2]
cQuery += " where JAF_COD    is not null and JAF_COD    != '' "
cQuery += "   and JAF_VERSAO is not null and JAF_VERSAO != '' "
cQuery += "   and JAW_PERLET is not null and JAW_PERLET != '' "
cQuery += "   and JAF_CLASFI is not null and JAF_CLASFI != '' "
cQuery += "   and JAF_CCUSTO is not null and JAF_CCUSTO != '' "
cQuery += "   and JAF_CCUSTO not in ( "
cQuery += "       select I3_CUSTO "
cQuery += "         from "+RetSQLName("SI3")+" SI3 "
cQuery += "        where I3_FILIAL  = '"+xFilial("SI3")+"' "
cQuery += "          and I3_CUSTO   = JAF_CCUSTO "
cQuery += "          and D_E_L_E_T_ != '*' ) "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRB108VLD", .F., .F. )

lOk := lOk .and. TRB108VLD->( eof() )

while !lEnd .and. TRB108VLD->( !eof() )
	AcaLog( cLogFile, '  Inconsistência no curso '+Alltrim( TRB108VLD->JAF_COD )+', versão '+Alltrim( TRB108VLD->JAF_VERSAO )+', período letivo '+Alltrim( TRB108VLD->JAW_PERLET )+': JAF_CCUSTO deve ser branco ou estar cadastrado na tabela SI3.' )
	TRB108VLD->(dbSkip())
end
TRB108VLD->( dbCloseArea() )

Return lOk .and. !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC108Qry ºAutor  ³Rafael Rodrigues    º Data ³ 10/Fev/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se um curso esta sendo importada no arquivo        º±±
±±º          ³de trabalho                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ xAC10800                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC108Qry( cCurso, cVersao, cTable )
Local lOk
Local cQuery := ""

cQuery := "select count(*) as QUANT "
cQuery += "  from "+cTable
cQuery += " where JAF_COD    = '"+cCurso+"' "
cQuery += "   and JAF_VERSAO = '"+cVersao+"' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY08", .F., .F. )
TCSetField( "QRY08", "QUANT", "N", 1, 0 )

lOk := QRY08->QUANT > 0

QRY08->( dbCloseArea() )

Return lOk