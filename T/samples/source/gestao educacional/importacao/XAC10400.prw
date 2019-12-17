#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC10400  ºAutor  ³Rafael Rodrigues    º Data ³  10/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Disciplinas                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC10400( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC10400'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local cIDX03	:= CriaTrab( nil, .F. )
Local cIDX04	:= CriaTrab( nil, .F. )
Local cIDX05	:= CriaTrab( nil, .F. )
Local cIDX06	:= CriaTrab( nil, .F. )
Local nPos		:= 0
Local lTRB10401	:= .F.
Local lTRB10402	:= .F.
Local lTRB10403	:= .F.
Local lTRB10404	:= .F.
Local lTRB10405	:= .F.
Local lTRB10406	:= .F.
Local nRecs		:= 0
Local nRec01	:= 0
Local nRec02	:= 0
Local nRec03	:= 0
Local nRec04	:= 0
Local nRec05	:= 0
Local nRec06	:= 0
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local nDrv01	:= 0
Local nDrv02	:= 0
Local nDrv03	:= 0
Local nDrv04	:= 0
Local nDrv05	:= 0
Local nDrv06	:= 0
Local cArq01	:= ""
Local i

Default nOpcX	:= 0
Default aTables := {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JAE_CODIGO", "C", 015, 0 } )
aAdd( aStru, { "JAE_DESC"  , "C", 100, 0 } )
aAdd( aStru, { "JAE_MEC"   , "C", 100, 0 } )
aAdd( aStru, { "JAE_TIPO"  , "C", 003, 0 } )
aAdd( aStru, { "JAE_PERLAB", "N", 003, 0 } )
aAdd( aStru, { "JAE_AREA"  , "C", 006, 0 } )
aAdd( aStru, { "JAE_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAE_APLICA", "C", 001, 0 } )
aAdd( aStru, { "JAE_DISPAI", "C", 015, 0 } )
aAdd( aStru, { "JAE_COREQ" , "C", 015, 0 } )
aAdd( aStru, { "JAE_MODALI", "C", 002, 0 } )
aAdd( aStru, { "JAE_NOTUNI", "C", 001, 0 } )
aAdd( aStru, { "JAE_CARGEX", "N", 004, 0 } )
aAdd( aStru, { "JAE_CONVAG", "C", 001, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Cadastro de Disciplinas', 'AC10401', aClone( aStru ), 'TRB10401', .F., "JAE_CODIGO" } )

aStru := {}

aAdd( aStru, { "JAE_CODIGO", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAE_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAE_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Conteúdos das Disciplinas', 'AC10402', aClone( aStru ), 'TRB10402', .F., "JAE_CODIGO, JAE_SEQ" } )

aStru := {}

aAdd( aStru, { "JAE_CODIGO", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAE_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAE_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Ementas das Disciplinas', 'AC10403', aClone( aStru ), 'TRB10403', .F., "JAE_CODIGO, JAE_SEQ" } )

aStru := {}

aAdd( aStru, { "JAE_CODIGO", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAE_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAE_MEMO3" , "C", 080, 0 } )

aAdd( aFiles, { 'Bibliografias das Disciplinas', 'AC10404', aClone( aStru ), 'TRB10404', .F., "JAE_CODIGO, JAE_SEQ" } )

aStru := {}

aAdd( aStru, { "JAE_CODIGO", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAE_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAE_MEMO4" , "C", 080, 0 } )

aAdd( aFiles, { 'Objetivos das Disciplinas', 'AC10405', aClone( aStru ), 'TRB10405', .F., "JAE_CODIGO, JAE_SEQ" } )

aStru := {}

aAdd( aStru, { "JAE_CODIGO", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAE_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAE_MEMO5" , "C", 080, 0 } )

aAdd( aFiles, { 'Metodologia das Disciplinas', 'AC10406', aClone( aStru ), 'TRB10406', .F., "JAE_CODIGO, JAE_SEQ" } )

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
	
	nPos := aScan( aTables, {|x| x[1] == "TRB10401"} )
	if nPos > 0
		lTRB10401	:= .T.
		nDrv01	:= aScan( aDriver, aTables[nPos, 3] )
		nRec01	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
		cArq01	:= aTables[nPos, 2]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB10402"} )
	if nPos > 0
		lTRB10402	:= .T.
		nDrv02	:= aScan( aDriver, aTables[nPos, 3] )
		nRec02	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB10403"} )
	if nPos > 0
		lTRB10403	:= .T.
		nDrv03	:= aScan( aDriver, aTables[nPos, 3] )
		nRec03	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB10404"} )
	if nPos > 0
		lTRB10404	:= .T.
		nDrv04	:= aScan( aDriver, aTables[nPos, 3] )
		nRec04	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB10405"} )
	if nPos > 0
		lTRB10405	:= .T.
		nDrv05	:= aScan( aDriver, aTables[nPos, 3] )
		nRec05	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB10406"} )
	if nPos > 0
		lTRB10406	:= .T.
		nDrv06	:= aScan( aDriver, aTables[nPos, 3] )
		nRec06	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lTRB10401 .and. nDrv01 <> 3
		TRB10401->( dbGoBottom() )
		if Empty( TRB10401->JAE_CODIGO )
			RecLock( "TRB10401", .F. )
			TRB10401->( dbDelete() )
			TRB10401->( msUnlock() )
		endif
	endif

	if lTRB10402 .and. nDrv02 <> 3
		TRB10402->( dbGoBottom() )
		if Empty( TRB10402->JAE_CODIGO )
			RecLock( "TRB10402", .F. )
			TRB10402->( dbDelete() )
			TRB10402->( msUnlock() )
		endif
	endif

	if lTRB10403 .and. nDrv03 <> 3
		TRB10403->( dbGoBottom() )
		if Empty( TRB10403->JAE_CODIGO )
			RecLock( "TRB10403", .F. )
			TRB10403->( dbDelete() )
			TRB10403->( msUnlock() )
		endif
	endif

	if lTRB10404 .and. nDrv04 <> 3
		TRB10404->( dbGoBottom() )
		if Empty( TRB10404->JAE_CODIGO )
			RecLock( "TRB10404", .F. )
			TRB10404->( dbDelete() )
			TRB10404->( msUnlock() )
		endif
	endif

	if lTRB10405 .and. nDrv05 <> 3
		TRB10405->( dbGoBottom() )
		if Empty( TRB10405->JAE_CODIGO )
			RecLock( "TRB10405", .F. )
			TRB10405->( dbDelete() )
			TRB10405->( msUnlock() )
		endif
	endif
	
	if lTRB10406 .and. nDrv06 <> 3
		TRB10406->( dbGoBottom() )
		if Empty( TRB10406->JAE_CODIGO )
			RecLock( "TRB10406", .F. )
			TRB10406->( dbDelete() )
			TRB10406->( msUnlock() )
		endif
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena os arquivos de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nOpc == 0
		MsgRun( 'Ordenando arquivos...',, {||	if( lTRB10401 .and. nDrv01 <> 3, TRB10401->( IndRegua( "TRB10401", cIDX01, "JAE_CODIGO" ) ), NIL ),;
												if( lTRB10402 .and. nDrv02 <> 3, TRB10402->( IndRegua( "TRB10402", cIDX02, "JAE_CODIGO+JAE_SEQ" ) ), NIL ),;
												if( lTRB10403 .and. nDrv03 <> 3, TRB10403->( IndRegua( "TRB10403", cIDX03, "JAE_CODIGO+JAE_SEQ" ) ), NIL ),;
												if( lTRB10404 .and. nDrv04 <> 3, TRB10404->( IndRegua( "TRB10404", cIDX04, "JAE_CODIGO+JAE_SEQ" ) ), NIL ),;
												if( lTRB10405 .and. nDrv05 <> 3, TRB10405->( IndRegua( "TRB10405", cIDX05, "JAE_CODIGO+JAE_SEQ" ) ), NIL ),;
												if( lTRB10406 .and. nDrv06 <> 3, TRB10406->( IndRegua( "TRB10406", cIDX06, "JAE_CODIGO+JAE_SEQ" ) ), NIL ) } )
	else
		Eval( {||	if( lTRB10401 .and. nDrv01 <> 3, TRB10401->( IndRegua( "TRB10401", cIDX01, "JAE_CODIGO" ) ), NIL ),;
					if( lTRB10402 .and. nDrv02 <> 3, TRB10402->( IndRegua( "TRB10402", cIDX02, "JAE_CODIGO+JAE_SEQ" ) ), NIL ),;
					if( lTRB10403 .and. nDrv03 <> 3, TRB10403->( IndRegua( "TRB10403", cIDX03, "JAE_CODIGO+JAE_SEQ" ) ), NIL ),;
					if( lTRB10404 .and. nDrv04 <> 3, TRB10404->( IndRegua( "TRB10404", cIDX04, "JAE_CODIGO+JAE_SEQ" ) ), NIL ),;
					if( lTRB10405 .and. nDrv05 <> 3, TRB10405->( IndRegua( "TRB10405", cIDX05, "JAE_CODIGO+JAE_SEQ" ) ), NIL ),;
					if( lTRB10406 .and. nDrv06 <> 3, TRB10406->( IndRegua( "TRB10406", cIDX06, "JAE_CODIGO+JAE_SEQ" ) ), NIL ) } )
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lTRB10401
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAE_CODIGO) '	, 'Código não informado.' } )
		aAdd( aObrig, { '!Empty(JAE_DESC)   '	, 'Descrição não informada.' } )
		aAdd( aObrig, { '!Empty(JAE_MEC)    '	, 'Descrição do MEC não informada.' } )
		aAdd( aObrig, { 'JAE_PERLAB <= 100  '	, 'Percentual de uso do laboratório não pode ultrapassar 100%.' } )
		aAdd( aObrig, { '!Empty(JAE_AREA)   '	, 'Área não informada.' } )
		//aAdd( aObrig, { '!Empty(JAE_CARGA)  '	, 'Carga Horária não informada.' } )
		aAdd( aObrig, { 'JAE_TIPO$"001^002^003"', 'Tipo da Disciplina deve ser 001 (Teórica), 002 (Laboratório) ou 003 (Estágio).' } )
		aAdd( aObrig, { 'JAE_APLICA$"123"'		, 'Aplicação deve ser 1 (Curso) ou 2 (Processo Seletivo) ou 3 (Concurso).' } )
		aAdd( aObrig, { 'JAE_NOTUNI$"123"'		, 'Tipo de Nota deve ser 1 (Nota Única), 2 (Por Avaliação) ou 3 (Por Atividade).' } )
		aAdd( aObrig, { 'JAE_CONVAG$"12"'		, 'Controle de Vagas por Disciplina deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAE_DISPAI <> JAE_CODIGO'	, 'A Disciplina não pode ser Disciplina Pai de si mesma.' } )
		aAdd( aObrig, { 'JAE_COREQ <> JAE_CODIGO'	, 'A Disciplina não pode ser Co-Requisito de si mesma.' } )
		aAdd( aObrig, { 'JAE_AREA == Posicione( "JAG", 1, xFilial("JAG")+JAE_AREA, "JAG_CODIGO" )'	, 'Área não cadastrada na tabela JAG.' } )
		aAdd( aObrig, { 'JAE_MODALI$"01^02"'	, 'Modalidade deve ser 01 (Presencial) ou 02 (Semi-Presencial).' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'Empty(JAE_DISPAI) .or. JAE_DISPAI == Posicione( "JAE", 1, xFilial("JAE")+JAE_DISPAI, "JAE_CODIGO" ) .or. Eval( {|_nPos, _lOk| _nPos := Recno(), _lOk := dbSeek(JAE_DISPAI, .F.), dbGoTo(_nPos), _lOk} )'	, 'Disciplina Pai não cadastrada na tabela JAE e inexistente no arquivo de importaçào.' } )
			aAdd( aObrig, { 'Empty(JAE_COREQ) .or. JAE_COREQ == Posicione( "JAE", 1, xFilial("JAE")+JAE_COREQ, "JAE_CODIGO" ) .or. Eval( {|_nPos, _lOk| _nPos := Recno(), _lOk := dbSeek(JAE_COREQ, .F.), dbGoTo(_nPos), _lOk} )'	, 'Co-requisito não cadastrado na tabela JAE e inexistente no arquivo de importaçào.' } )
		else
			aAdd( aObrig, { 'Empty(JAE_DISPAI) .or. JAE_DISPAI == Posicione( "JAE", 1, xFilial("JAE")+JAE_DISPAI, "JAE_CODIGO" ) .or. U_xAC104Qry( JAE_DISPAI, "'+cArq01+'" )'	, 'Disciplina Pai não cadastrada na tabela JAE e inexistente no arquivo de importaçào.' } )
			aAdd( aObrig, { 'Empty(JAE_COREQ) .or. JAE_COREQ == Posicione( "JAE", 1, xFilial("JAE")+JAE_COREQ, "JAE_CODIGO" ) .or. U_xAC104Qry( JAE_COREQ, "'+cArq01+'" )'	, 'Co-requisito não cadastrado na tabela JAE e inexistente no arquivo de importaçào.' } )
		endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB10401", "JAE_CODIGO", .F., aObrig, cLogFile, @lEnd, nRec01 ) .and. lOk  }, 'Validando '+aFiles[1,1] )
		else
			lOk := U_xACChkInt( "TRB10401", "JAE_CODIGO", .F., aObrig, cLogFile, @lEnd, nRec01 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[1,1]+'".' )
	endif	

	if lTRB10402 .and. lOk
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAE_CODIGO) '	, 'Código não informado.' } )
		aAdd( aObrig, { '!Empty(JAE_SEQ)    '	, 'Sequencial de linha não informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB10401") > 0 .and. TRB10401->( dbSeek( TRB10402->JAE_CODIGO, .F. ) ) )'	, 'Disciplina não cadastrada na tabela JAE e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB10401") > 0 .and. U_xAC104Qry( JAE_CODIGO, "'+cArq01+'" ) )'	, 'Disciplina não cadastrada na tabela JAE e não presente nos arquivos de importação.' } )
        endif
        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[2,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB10402", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLogFile, @lEnd, nRec02 ) .and. lOk }, 'Validando '+aFiles[2,1] )
		else
			lOk := U_xACChkInt( "TRB10402", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLogFile, @lEnd, nRec02 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[2,1]+'".' )
	endif	

	if lTRB10403 .and. lOk
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAE_CODIGO) '	, 'Código não informado.' } )
		aAdd( aObrig, { '!Empty(JAE_SEQ)    '	, 'Sequencial de linha não informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB10401") > 0 .and. TRB10401->( dbSeek( TRB10403->JAE_CODIGO, .F. ) ) )'	, 'Disciplina não cadastrada na tabela JAE e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB10401") > 0 .and. U_xAC104Qry( JAE_CODIGO, "'+cArq01+'" ) )'	, 'Disciplina não cadastrada na tabela JAE e não presente nos arquivos de importação.' } )
        endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[3,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB10403", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLogFile, @lEnd, nRec03 ) .and. lOk }, 'Validando '+aFiles[3,1] )
		else
			lOk := U_xACChkInt( "TRB10403", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLogFile, @lEnd, nRec03 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[3,1]+'".' )
	endif	

	if lTRB10404 .and. lOk
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAE_CODIGO) '	, 'Código não informado.' } )
		aAdd( aObrig, { '!Empty(JAE_SEQ)    '	, 'Sequencial de linha não informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB10401") > 0 .and. TRB10401->( dbSeek( TRB10404->JAE_CODIGO, .F. ) ) )'	, 'Disciplina não cadastrada na tabela JAE e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB10401") > 0 .and. U_xAC104Qry( JAE_CODIGO, "'+cArq01+'" ) )'	, 'Disciplina não cadastrada na tabela JAE e não presente nos arquivos de importação.' } )
        endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[4,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB10404", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLogFile, @lEnd, nRec04 ) .and. lOk }, 'Validando '+aFiles[4,1] )
		else
			lOk := U_xACChkInt( "TRB10404", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLogFile, @lEnd, nRec04 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[4,1]+'".' )
	endif	

	if lTRB10405 .and. lOk
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAE_CODIGO) '	, 'Código não informado.' } )
		aAdd( aObrig, { '!Empty(JAE_SEQ)    '	, 'Sequencial de linha não informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB10401") > 0 .and. TRB10401->( dbSeek( TRB10405->JAE_CODIGO, .F. ) ) )'	, 'Disciplina não cadastrada na tabela JAE e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB10401") > 0 .and. U_xAC104Qry( JAE_CODIGO, "'+cArq01+'" ) )'	, 'Disciplina não cadastrada na tabela JAE e não presente nos arquivos de importação.' } )
        endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[5,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB10405", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLogFile, @lEnd, nRec05 ) .and. lOk }, 'Validando '+aFiles[5,1] )
		else
			lOk := U_xACChkInt( "TRB10405", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLogFile, @lEnd, nRec05 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[5,1]+'".' )
	endif	

	if lTRB10406 .and. lOk
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAE_CODIGO) '	, 'Código não informado.' } )
		aAdd( aObrig, { '!Empty(JAE_SEQ)    '	, 'Sequencial de linha não informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB10401") > 0 .and. TRB10401->( dbSeek( TRB10406->JAE_CODIGO, .F. ) ) )'	, 'Disciplina não cadastrada na tabela JAE e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB10401") > 0 .and. U_xAC104Qry( JAE_CODIGO, "'+cArq01+'" ) )'	, 'Disciplina não cadastrada na tabela JAE e não presente nos arquivos de importação.' } )
        endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[6,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB10406", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLogFile, @lEnd, nRec06 ) .and. lOk }, 'Validando '+aFiles[6,1] )
		else
			lOk := U_xACChkInt( "TRB10406", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLogFile, @lEnd, nRec06 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[6,1]+'".' )
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
			Processa( { |lEnd| ProcRegua( nRecs ), lOk := xAC10401Grv( @lEnd, aFiles[1,1], nRec01 ) .and. xAC10402Grv( @lEnd, aFiles[2,1], nRec02 ) .and. xAC10403Grv( @lEnd, aFiles[3,1], nRec03 ) .and. xAC10404Grv( @lEnd, aFiles[4,1], nRec04 ) .and. xAC10405Grv( @lEnd, aFiles[5,1], nRec05 ) .and. xAC10406Grv( @lEnd, aFiles[6,1], nRec06 ) }, 'Gravação em andamento' )
		else
			lOk := xAC10401Grv( @lEnd, aFiles[1,1], nRec01 ) .and. xAC10402Grv( @lEnd, aFiles[2,1], nRec02 ) .and. xAC10403Grv( @lEnd, aFiles[3,1], nRec03 ) .and. xAC10404Grv( @lEnd, aFiles[4,1], nRec04 ) .and. xAC10405Grv( @lEnd, aFiles[5,1], nRec05 ) .and. xAC10406Grv( @lEnd, aFiles[6,1], nRec06 )
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

if lTRB10401 .and. nDrv01 <> 3
	FErase( cIDX01 + OrdBagExt() )
endif
if lTRB10402 .and. nDrv02 <> 3
	FErase( cIDX02 + OrdBagExt() )
endif
if lTRB10403 .and. nDrv03 <> 3
	FErase( cIDX03 + OrdBagExt() )
endif
if lTRB10404 .and. nDrv04 <> 3
	FErase( cIDX04 + OrdBagExt() )
endif
if lTRB10405 .and. nDrv05 <> 3
	FErase( cIDX05 + OrdBagExt() )
endif
if lTRB10405 .and. nDrv06 <> 3
	FErase( cIDX06 + OrdBagExt() )
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC10401GrvºAutor  ³Rafael Rodrigues   º Data ³  10/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados do arquivo principal na base.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC10400                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC10401Grv( lEnd, cTitulo, nRecs )
Local cFilJAE	:= xFilial("JAE")	// Criada para ganhar performance
Local i			:= 0
Local lSeek

if Select( "TRB10401" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB10401->( dbGoTop() )

JAE->( dbSetOrder(1) )

while TRB10401->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif
	
	begin transaction
	
	lSeek := JAE->( dbSeek( cFilJAE+TRB10401->JAE_CODIGO ) )
	if lOver .or. !lSeek
		RecLock( "JAE", !lSeek )
		JAE->JAE_FILIAL	:= cFilJAE
		JAE->JAE_CODIGO	:= TRB10401->JAE_CODIGO
		JAE->JAE_DESC	:= TRB10401->JAE_DESC
		JAE->JAE_MEC	:= TRB10401->JAE_MEC
		JAE->JAE_TIPO	:= TRB10401->JAE_TIPO
		JAE->JAE_PERLAB	:= TRB10401->JAE_PERLAB
		JAE->JAE_AREA	:= TRB10401->JAE_AREA
		JAE->JAE_CARGA	:= TRB10401->JAE_CARGA
		JAE->JAE_APLICA	:= TRB10401->JAE_APLICA
		JAE->JAE_DISPAI	:= TRB10401->JAE_DISPAI
		JAE->JAE_COREQ	:= TRB10401->JAE_COREQ
		JAE->JAE_MODALI	:= TRB10401->JAE_MODALI
		JAE->JAE_NOTUNI	:= TRB10401->JAE_NOTUNI
		JAE->JAE_CARGEX	:= TRB10401->JAE_CARGEX
		JAE->JAE_CONVAG	:= TRB10401->JAE_CONVAG
		JAE->( msUnlock() )
	endif
	
	end transaction

	TRB10401->( dbSkip() )
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC10402GrvºAutor  ³Rafael Rodrigues   º Data ³  10/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados dos Conteudos na base.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC10400                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC10402Grv( lEnd, cTitulo, nRecs )
Local cFilJAE	:= xFilial("JAE")	// Criada para ganhar performance
Local i			:= 0
Local cDiscip
Local cMemo

if Select( "TRB10402" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB10402->( dbGoTop() )

JAE->( dbSetOrder(1) )

while TRB10402->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cDiscip	:= TRB10402->JAE_CODIGO
	
	while cDiscip == TRB10402->JAE_CODIGO .and. TRB10402->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif

		cMemo += StrTran( TRB10402->JAE_MEMO1, '\13\10', CRLF )
		
		TRB10402->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAE->( dbSeek( cFilJAE+cDiscip ) ) .and. ( lOver .or. Empty( JAE->JAE_MEMO1 ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAE_CONTEU³
		//³e armazena o codigo do memo no campo JAE_MEMO1. Sobrescreve caso JAE_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JAE", .F. )
		MSMM( JAE->JAE_MEMO1, TamSX3("JAE_CONTEU")[1],, cMemo, 1,,, "JAE", "JAE_MEMO1" )
		JAE->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC10403GrvºAutor  ³Rafael Rodrigues   º Data ³  10/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados dos Conteudos na base.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC10400                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC10403Grv( lEnd, cTitulo, nRecs )
Local cFilJAE	:= xFilial("JAE")	// Criada para ganhar performance
Local i			:= 0
Local cDiscip
Local cMemo

if Select( "TRB10403" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB10403->( dbGoTop() )

JAE->( dbSetOrder(1) )

while TRB10403->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cDiscip	:= TRB10403->JAE_CODIGO
	
	while cDiscip == TRB10403->JAE_CODIGO .and. TRB10403->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif
		
		cMemo += StrTran( TRB10403->JAE_MEMO2, '\13\10', CRLF )
		
		TRB10403->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAE->( dbSeek( cFilJAE+cDiscip ) ) .and. ( lOver .or. Empty( JAE->JAE_MEMO2 ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAE_CONTEU³
		//³e armazena o codigo do memo no campo JAE_MEMO2. Sobrescreve caso JAE_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JAE", .F. )
		MSMM( JAE->JAE_MEMO2, TamSX3("JAE_FINALI")[1],, cMemo, 1,,, "JAE", "JAE_MEMO2" )
		JAE->( msUnlock() )

		end transaction
	endif

end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC10404GrvºAutor  ³Rafael Rodrigues   º Data ³  10/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados dos Conteudos na base.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC10400                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC10404Grv( lEnd, cTitulo, nRecs )
Local cFilJAE	:= xFilial("JAE")	// Criada para ganhar performance
Local i			:= 0
Local cDiscip
Local cMemo

if Select( "TRB10404" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB10404->( dbGoTop() )

JAE->( dbSetOrder(1) )

while TRB10404->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cDiscip	:= TRB10404->JAE_CODIGO
	
	while cDiscip == TRB10404->JAE_CODIGO .and. TRB10404->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif

		cMemo += StrTran( TRB10404->JAE_MEMO3, '\13\10', CRLF )
		
		TRB10404->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAE->( dbSeek( cFilJAE+cDiscip ) ) .and. ( lOver .or. Empty( JAE->JAE_MEMO3 ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAE_CONTEU³
		//³e armazena o codigo do memo no campo JAE_MEMO3. Sobrescreve caso JAE_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JAE", .F. )
		MSMM( JAE->JAE_MEMO3, TamSX3("JAE_BIBLIO")[1],, cMemo, 1,,, "JAE", "JAE_MEMO3" )
		JAE->( msUnlock() )

		end transaction
	endif

end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC10405GrvºAutor  ³Rafael Rodrigues   º Data ³  10/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados dos Conteudos na base.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC10400                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC10405Grv( lEnd, cTitulo, nRecs )
Local cFilJAE	:= xFilial("JAE")	// Criada para ganhar performance
Local i			:= 0
Local cDiscip
Local cMemo

if Select( "TRB10405" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB10405->( dbGoTop() )

JAE->( dbSetOrder(1) )

while TRB10405->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cDiscip	:= TRB10405->JAE_CODIGO
	
	while cDiscip == TRB10405->JAE_CODIGO .and. TRB10405->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif

		cMemo += StrTran( TRB10405->JAE_MEMO4, '\13\10', CRLF )
		
		TRB10405->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAE->( dbSeek( cFilJAE+cDiscip ) ) .and. ( lOver .or. Empty( JAE->JAE_MEMO4 ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAE_CONTEU³
		//³e armazena o codigo do memo no campo JAE_MEMO3. Sobrescreve caso JAE_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JAE", .F. )
		MSMM( JAE->JAE_MEMO4, TamSX3("JAE_OBJETI")[1],, cMemo, 1,,, "JAE", "JAE_MEMO4" )
		JAE->( msUnlock() )

		end transaction
	endif

end

Return !lEnd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC10406GrvºAutor  ³Rafael Rodrigues   º Data ³  10/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados das Metodologias na base       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC10400                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC10406Grv( lEnd, cTitulo, nRecs )
Local cFilJAE	:= xFilial("JAE")	// Criada para ganhar performance
Local i			:= 0
Local cDiscip
Local cMemo

if Select( "TRB10406" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB10406->( dbGoTop() )

JAE->( dbSetOrder(1) )

while TRB10406->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cDiscip	:= TRB10406->JAE_CODIGO
	
	while cDiscip == TRB10406->JAE_CODIGO .and. TRB10406->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif

		cMemo += StrTran( TRB10406->JAE_MEMO5, '\13\10', CRLF )
		
		TRB10405->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAE->( dbSeek( cFilJAE+cDiscip ) ) .and. ( lOver .or. Empty( JAE->JAE_MEMO5 ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAE_CONTEU³
		//³e armazena o codigo do memo no campo JAE_MEMO3. Sobrescreve caso JAE_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JAE", .F. )
		MSMM( JAE->JAE_MEMO5, TamSX3("JAE_OBJETI")[1],, cMemo, 1,,, "JAE", "JAE_MEMO5" )
		JAE->( msUnlock() )

		end transaction
	endif

end

Return !lEnd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC104Qry ºAutor  ³Rafael Rodrigues    º Data ³ 10/Fev/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se uma disciplina esta sendo importada no arquivo  º±±
±±º          ³de trabalho                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ xAC10400                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC104Qry( cDiscip, cTable )
Local lOk
Local cQuery := ""

cQuery := "select count(*) as QUANT "
cQuery += "  from "+cTable
cQuery += " where JAE_CODIGO = '"+cDiscip+"' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY04", .F., .F. )
TCSetField( "QRY04", "QUANT", "N", 1, 0 )

lOk := QRY04->QUANT > 0

QRY04->( dbCloseArea() )

Return lOk