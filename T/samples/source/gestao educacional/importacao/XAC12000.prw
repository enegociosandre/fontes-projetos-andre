#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12000  ºAutor  ³Rafael Rodrigues    º Data ³  13/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Cursos Vigentes                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC12000( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC12000'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local cIDX03	:= CriaTrab( nil, .F. )
Local cIDX04	:= CriaTrab( nil, .F. )
Local lTRB12001	:= .F.
Local lTRB12002	:= .F.
Local lTRB12003	:= .F.
Local lTRB12004	:= .F.
Local nDrv01	:= 0
Local nDrv02	:= 0
Local nDrv03	:= 0
Local nDrv04	:= 0
Local cArq01	:= ""
Local nPos		:= 0
Local nRecs		:= 0
Local nRec01	:= 0
Local nRec02	:= 0
Local nRec03	:= 0
Local nRec04	:= 0
Local i

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JAH_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAH_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAH_CODIGO", "C", 006, 0 } )
aAdd( aStru, { "JAH_DESC"  , "C", 050, 0 } )
aAdd( aStru, { "JAH_CARGA" , "N", 005, 0 } )
aAdd( aStru, { "JAH_TURNO" , "C", 003, 0 } )
aAdd( aStru, { "JAH_GRPDOC", "C", 006, 0 } )
aAdd( aStru, { "JAH_TIPO"  , "C", 003, 0 } )
aAdd( aStru, { "JAH_TEMPOJ", "N", 006, 3 } )
aAdd( aStru, { "JAH_QTDTRA", "N", 002, 0 } )
aAdd( aStru, { "JAH_STATUS", "C", 001, 0 } )
aAdd( aStru, { "JAH_GRUPO" , "C", 003, 0 } )
aAdd( aStru, { "JAH_UNIDAD", "C", 006, 0 } )
aAdd( aStru, { "JAH_VALOR" , "C", 001, 0 } )
aAdd( aStru, { "JAH_PRCSEL", "C", 001, 0 } )
aAdd( aStru, { "JAH_MATSEQ", "C", 001, 0 } )
aAdd( aStru, { "JAH_MAXDIS", "N", 002, 0 } )
aAdd( aStru, { "JAH_AMG_"  , "C", 001, 0 } )
aAdd( aStru, { "JAH_CCOMIT", "C", 001, 0 } )
aAdd( aStru, { "JAR_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAR_DPERLE", "C", 030, 0 } )
aAdd( aStru, { "JAR_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JAR_DATA1" , "D", 008, 0 } )
aAdd( aStru, { "JAR_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JAR_ANOLET", "C", 004, 0 } )
aAdd( aStru, { "JAR_PERIOD", "C", 002, 0 } )
aAdd( aStru, { "JAR_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAR_DPMAX" , "N", 002, 0 } )
aAdd( aStru, { "JAR_ALTGRA", "C", 001, 0 } )
aAdd( aStru, { "JAR_DTMAT1", "D", 008, 0 } )
aAdd( aStru, { "JAR_DTMAT2", "D", 008, 0 } )
aAdd( aStru, { "JAR_MEDAPR", "N", 005, 2 } )
aAdd( aStru, { "JAR_EXAME" , "C", 001, 0 } )
aAdd( aStru, { "JAR_MEDEXA", "N", 005, 2 } )
aAdd( aStru, { "JAR_DEPREP", "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA1" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA2" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA3" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA4" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA5" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA6" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA7" , "C", 001, 0 } )
aAdd( aStru, { "JAR_QTDVAG", "N", 004, 0 } )
aAdd( aStru, { "JAR_QTDRES", "N", 004, 0 } )
aAdd( aStru, { "JAR_QTDMAT", "N", 004, 0 } )
aAdd( aStru, { "JAR_QTDLIV", "N", 004, 0 } )
aAdd( aStru, { "JAR_TRANSF", "N", 004, 0 } )
aAdd( aStru, { "JAR_CALACA", "C", 010, 0 } )
aAdd( aStru, { "JAR_PERPRE", "C", 001, 0 } )
aAdd( aStru, { "JAR_APFALT", "C", 001, 0 } )
aAdd( aStru, { "JAR_FALTAS", "C", 001, 0 } )
aAdd( aStru, { "JAR_FRQMIN", "N", 003, 0 } )
aAdd( aStru, { "JAR_MAXDIS", "N", 002, 0 } )
aAdd( aStru, { "JAR_NOTMIN", "N", 005, 2 } )
aAdd( aStru, { "JAR_CRIAVA", "C", 001, 0 } )
aAdd( aStru, { "JAR_EQVCON", "C", 006, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Cursos Vigentes', 'AC12001', aClone( aStru ), 'TRB12001', .F., 'JAH_CODIGO, JAR_PERLET', {|| "JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"'" } } )

aStru := {}

aAdd( aStru, { "JAH_CODIGO", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAH_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAH_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Escopos', 'AC12002', aClone( aStru ), 'TRB12002', .F., 'JAH_CODIGO, JAH_SEQ', {|| "JAH_CODIGO in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JAH_CODIGO and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

aStru := {}

aAdd( aStru, { "JAH_CODIGO", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAH_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAH_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Observações', 'AC12003', aClone( aStru ), 'TRB12003', .F., 'JAH_CODIGO, JAH_SEQ', {|| "JAH_CODIGO in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JAH_CODIGO and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

aStru := {}

aAdd( aStru, { "JAH_CODIGO", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAH_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAH_MEMO3" , "C", 080, 0 } )

aAdd( aFiles, { 'Atos legais', 'AC12004', aClone( aStru ), 'TRB12004', .F., 'JAH_CODIGO, JAH_SEQ', {|| "JAH_CODIGO in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JAH_CODIGO and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a janela para selecao de arquivos e importacao dos temporarios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpc == 2	// So processamento
	U_xOpen( aTables, aFiles, aDriver, .F. )
else
	aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver )
	if nOpc == 1
		Return aTables
	endif
endif

if Empty( aTables )	//Nenhum arquivo importado.
	AcaLog( cLogFile, '  Nenhum arquivo pôde ser importado para este processo.' )
	if nOpc == 0
		Aviso( 'Problema', 'Nenhum arquivo pôde ser importado para este processo.', {'Ok'} )
	endif
else
	
	nPos := aScan( aTables, {|x| x[1] == "TRB12001"} )
	if nPos > 0
		lTRB12001	:= .T.
		nDrv01	:= aScan( aDriver, aTables[nPos, 3] )
		nRec01	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
		cArq01	:= aTables[nPos, 2]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB12002"} )
	if nPos > 0
		lTRB12002	:= .T.
		nDrv02	:= aScan( aDriver, aTables[nPos, 3] )
		nRec02	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB12003"} )
	if nPos > 0
		lTRB12003	:= .T.
		nDrv03	:= aScan( aDriver, aTables[nPos, 3] )
		nRec03	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB12004"} )
	if nPos > 0
		lTRB12004	:= .T.
		nDrv04	:= aScan( aDriver, aTables[nPos, 3] )
		nRec04	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lTRB12001 .and. nDrv01 <> 3
		TRB12001->( dbGoBottom() )
		if Empty( TRB12001->JAH_CODIGO )
			RecLock( "TRB12001", .F. )
			TRB12001->( dbDelete() )
			TRB12001->( msUnlock() )
		endif
	endif

	if lTRB12002 .and. nDrv02 <> 3
		TRB12002->( dbGoBottom() )
		if Empty( TRB12002->JAH_CODIGO )
			RecLock( "TRB12002", .F. )
			TRB12002->( dbDelete() )
			TRB12002->( msUnlock() )
		endif
	endif

	if lTRB12003 .and. nDrv03 <> 3
		TRB12003->( dbGoBottom() )
		if Empty( TRB12003->JAH_CODIGO )
			RecLock( "TRB12003", .F. )
			TRB12003->( dbDelete() )
			TRB12003->( msUnlock() )
		endif
	endif

	if lTRB12004 .and. nDrv04 <> 3
		TRB12004->( dbGoBottom() )
		if Empty( TRB12004->JAH_CODIGO )
			RecLock( "TRB12004", .F. )
			TRB12004->( dbDelete() )
			TRB12004->( msUnlock() )
		endif
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena os arquivos de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nOpc == 0
		MsgRun( 'Ordenando arquivos...',, {||	if( lTRB12001 .and. nDrv01 <> 3, TRB12001->( IndRegua( "TRB12001", cIDX01, "JAH_CODIGO+JAR_PERLET+JAR_HABILI+JAH_CURSO+JAH_VERSAO" ) ), NIL ),;
												if( lTRB12002 .and. nDrv02 <> 3, TRB12002->( IndRegua( "TRB12002", cIDX02, "JAH_CODIGO+JAH_SEQ" ) ), NIL ),;
												if( lTRB12003 .and. nDrv03 <> 3, TRB12003->( IndRegua( "TRB12003", cIDX03, "JAH_CODIGO+JAH_SEQ" ) ), NIL ),;
												if( lTRB12004 .and. nDrv04 <> 3, TRB12004->( IndRegua( "TRB12004", cIDX04, "JAH_CODIGO+JAH_SEQ" ) ), NIL ) } )
	else
		Eval( {||	if( lTRB12001 .and. nDrv01 <> 3, TRB12001->( IndRegua( "TRB12001", cIDX01, "JAH_CODIGO+JAR_PERLET+JAR_HABILI+JAH_CURSO+JAH_VERSAO" ) ), NIL ),;
					if( lTRB12002 .and. nDrv02 <> 3, TRB12002->( IndRegua( "TRB12002", cIDX02, "JAH_CODIGO+JAH_SEQ" ) ), NIL ),;
					if( lTRB12003 .and. nDrv03 <> 3, TRB12003->( IndRegua( "TRB12003", cIDX03, "JAH_CODIGO+JAH_SEQ" ) ), NIL ),;
					if( lTRB12004 .and. nDrv04 <> 3, TRB12004->( IndRegua( "TRB12004", cIDX04, "JAH_CODIGO+JAH_SEQ" ) ), NIL ) } )
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lTRB12001
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAH_CURSO)  '	, 'Código do curso padrão não informado.' } )
		aAdd( aObrig, { '!Empty(JAH_VERSAO) '	, 'Versão do curso padrão não informada.' } )
		aAdd( aObrig, { '!Empty(JAH_CODIGO) '	, 'Código do curso vigente não informado.' } )
		aAdd( aObrig, { '!Empty(JAH_DESC)   '	, 'Descrição não informada.' } )
		aAdd( aObrig, { '!Empty(JAH_CARGA)  '	, 'Carga Horária não informada.' } )
		aAdd( aObrig, { '!Empty(JAH_TURNO)  '	, 'Carga Horária não informada.' } )
		aAdd( aObrig, { '!Empty(JAH_GRUPO)  '	, 'Grupo de cursos não informado.' } )
		aAdd( aObrig, { '!Empty(JAH_UNIDAD) '	, 'Unidade não informada.' } )
		aAdd( aObrig, { '!Empty(JAR_PERLET) '	, 'Período letivo não informado.' } )
		aAdd( aObrig, { '!Empty(JAR_DPERLE) '	, 'Descrição do período letivo não informada.' } )
		aAdd( aObrig, { '!Empty(JAR_DATA1)  '	, 'Data inícial do período letivo não informada.' } )
		aAdd( aObrig, { '!Empty(JAR_DATA2)  '	, 'Data final do período letivo não informada.' } )
		aAdd( aObrig, { '!Empty(JAR_CARGA)  '	, 'Carga horária do período letivo não informada.' } )
		aAdd( aObrig, { '!Empty(JAR_DTMAT1) '	, 'Data de matrícula inícial do período letivo não informada.' } )
		aAdd( aObrig, { '!Empty(JAR_DTMAT2) '	, 'Data de matrícula final do período letivo não informada.' } )
		aAdd( aObrig, { '!Empty(JAR_QTDVAG) '	, 'Quantidade de vagas do período letivo não informada.' } )
		aAdd( aObrig, { '!Empty(JAR_CALACA) '	, 'Calendário acadêmico não informada.' } )
		aAdd( aObrig, { 'JAH_TIPO$"001^002^003" '	, 'Tipo deve ser 001 (Normal), 002 (Dependência) ou 003 (Tutoria).' } )
		aAdd( aObrig, { 'JAH_STATUS$"12"'		, 'Status deve ser 1 (Em Aberto) ou 2 (Encerrado).' } )
		aAdd( aObrig, { 'JAH_VALOR$"12"'		, '"Possui valor?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAH_PRCSEL$"12"'		, '"Requer processo seletivo?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAH_MATSEQ$"12"'		, '"Matrícula sequencial?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAH_AMG_$"12"'			, 'AMG deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAH_CCOMIT$"12"'		, 'Concomitancia deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAR_ALTGRA$"12"'		, '"Altera grade?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAR_EXAME$"12"'		, '"Possui exame?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAR_DEPREP$"12"'		, '"DP ou Reprova?" deve ser 1 (DP) ou 2 (Reprova).' } )
		aAdd( aObrig, { 'JAR_AULA1$"12"'		, '"Aula Domingo?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAR_AULA2$"12"'		, '"Aula Segunda?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAR_AULA3$"12"'		, '"Aula Terça?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAR_AULA4$"12"'		, '"Aula Quarta?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAR_AULA5$"12"'		, '"Aula Quinta?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAR_AULA6$"12"'		, '"Aula Sexta?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAR_AULA7$"12"'		, '"Aula Sábado?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAR_PERPRE$"12"'		, '"Período previsto?" deve ser 1 (Sim) ou 2 (Não).' } )
		aAdd( aObrig, { 'JAR_APFALT$"123"'		, 'Tipo de apontamento de faltas deve ser 1 (Diário), 2 (Mensal) ou 3 (Período Letivo).' } )
		aAdd( aObrig, { 'JAR_FALTAS$"12"'		, 'Tipo de faltas deve ser 1 (Disciplina) ou 2 (Curso).' } )
		aAdd( aObrig, { 'JAR_CRIAVA$"12"'		, 'Critério de avaliação deve ser 1 (Nota) ou 2 (Conceito).' } )
		aAdd( aObrig, { 'Len(Alltrim(JAR_ANOLET)) == 4'	, 'Ano civil do período letivo deve ser informado com 4 dígitos.' } )
		aAdd( aObrig, { 'Len(Alltrim(JAR_PERIOD)) == 2'	, 'Período do ano civil deve ser informado com 2 dígitos.' } )
		aAdd( aObrig, { 'JAH_TURNO == Left( Posicione( "SX5", 1, xFilial("SX5")+"F5"+JAH_TURNO, "X5_CHAVE" ), Len( JAH_TURNO ) )', 'Turno não cadastrado na sub-tabela F5 da tabela SX5.' } )
		aAdd( aObrig, { 'JAH_GRPDOC == Posicione( "JAK", 1, xFilial("JAK")+JAH_GRPDOC, "JAK_CODIGO" )', 'Grupo de documentos não cadastrado na tabela JAK.' } )
		aAdd( aObrig, { 'JAH_GRUPO == Left( Posicione( "SX5", 1, xFilial("SX5")+"FC"+JAH_GRUPO, "X5_CHAVE" ), Len( JAH_GRUPO ) )', 'Grupo não cadastrado na sub-tabela FC da tabela SX5.' } )
		aAdd( aObrig, { 'JAH_UNIDAD == Posicione( "JA3", 1, xFilial("JA3")+JAH_UNIDAD, "JA3_CODLOC" )', 'Unidade não cadastrada na tabela JA3.' } )
		aAdd( aObrig, { 'JAR_CRIAVA == "1" .or. !Empty(JAR_EQVCON)'	, 'Tabela de equivalência de conceitos deve ser informado quando critério de avaliação for conceito.' } )
		aAdd( aObrig, { 'JAR_PERLET == Posicione( "JAW", 1, xFilial("JAW")+JAH_CURSO+JAH_VERSAO+JAR_PERLET+JAR_HABILI, "JAW_PERLET" )', 'Período letivo não cadastrado na tabela JAW.' } )
		aAdd( aObrig, { 'JAR_DATA1 <= JAR_DATA2', 'Data inicial do período letivo deve ser menor ou igual à data final.' } )
		aAdd( aObrig, { 'JAR_DTMAT1 <= JAR_DTMAT2', 'Data inicial de matrícula do período letivo deve ser menor ou igual à data final.' } )
		aAdd( aObrig, { 'JAR_QTDVAG == JAR_QTDRES + JAR_QTDMAT + JAR_QTDLIV', 'A somatoria de vagas Livres, Ocupadas e Reservadas deve totalizar a quantidade de Vagas do periodo letivo.' } )
		aAdd( aObrig, { 'Len(Alltrim(Str(JAR_QTDVAG))) <= TamSX3("JAR_QTDVAG")[1]', 'A quantidade total de vagas ultrapassa a capacidade de armazenamento do campo.' } )
		aAdd( aObrig, { 'Len(Alltrim(Str(JAR_QTDRES))) <= TamSX3("JAR_QTDRES")[1]', 'A quantidade de reservas ultrapassa a capacidade de armazenamento do campo.' } )
		aAdd( aObrig, { 'Len(Alltrim(Str(JAR_QTDMAT))) <= TamSX3("JAR_QTDMAT")[1]', 'A quantidade de matriculados ultrapassa a capacidade de armazenamento do campo.' } )
		aAdd( aObrig, { 'Len(Alltrim(Str(JAR_QTDLIV))) <= TamSX3("JAR_QTDLIV")[1]', 'A quantidade de vagas livres ultrapassa a capacidade de armazenamento do campo.' } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB12001", "JAH_CODIGO+JAR_PERLET+JAR_HABILI", .F., aObrig, cLogFile, @lEnd, nRec01 ) .and. lOk }, 'Validando '+aFiles[1,1] )
		else
			lOk := U_xACChkInt( "TRB12001", "JAH_CODIGO+JAR_PERLET+JAR_HABILI", .F., aObrig, cLogFile, @lEnd, nRec01 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Fim da validação do arquivo "'+aFiles[1,1]+'".' )
	endif	

	if lTRB12002
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAH_CODIGO) '	, 'Código do curso vigente não informado.' } )
		aAdd( aObrig, { '!Empty(JAH_SEQ)    '	, 'Sequencial de linha não informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAH_CODIGO == Posicione( "JAH", 1, xFilial("JAH")+JAH_CODIGO, "JAH_CODIGO" ) .or. ( Select("TRB12001") > 0 .and. TRB12001->( dbSeek( TRB12002->JAH_CODIGO, .F. ) ) )'	, 'Curso vigente não cadastrado na tabela JAH e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JAH_CODIGO == Posicione( "JAH", 1, xFilial("JAH")+JAH_CODIGO, "JAH_CODIGO" ) .or. ( Select("TRB12001") > 0 .and. U_xAC20Qry( JAH_CODIGO, "'+cArq01+'" ) ) )'	, 'Curso vigente não cadastrado na tabela JAH e não presente nos arquivos de importação.' } )
		endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Iniciando validação do arquivo "'+aFiles[2,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB12002", "JAH_CODIGO+JAH_SEQ", .F., aObrig, cLogFile, @lEnd, nRec02 ) .and. lOk }, 'Validando '+aFiles[2,1] )
		else
			lOk := U_xACChkInt( "TRB12002", "JAH_CODIGO+JAH_SEQ", .F., aObrig, cLogFile, @lEnd, nRec02 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Fim da validação do arquivo "'+aFiles[2,1]+'".' )
	endif	

	if lTRB12003
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAH_CODIGO) '	, 'Código do curso vigente não informado.' } )
		aAdd( aObrig, { '!Empty(JAH_SEQ)    '	, 'Sequencial de linha não informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAH_CODIGO == Posicione( "JAH", 1, xFilial("JAH")+JAH_CODIGO, "JAH_CODIGO" ) .or. ( Select("TRB12001") > 0 .and. TRB12001->( dbSeek( TRB12003->JAH_CODIGO, .F. ) ) )'	, 'Curso vigente não cadastrado na tabela JAH e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JAH_CODIGO == Posicione( "JAH", 1, xFilial("JAH")+JAH_CODIGO, "JAH_CODIGO" ) .or. ( Select("TRB12001") > 0 .and. U_xAC20Qry( JAH_CODIGO, "'+cArq01+'" ) ) )'	, 'Curso vigente não cadastrado na tabela JAH e não presente nos arquivos de importação.' } )
		endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Iniciando validação do arquivo "'+aFiles[3,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB12003", "JAH_CODIGO+JAH_SEQ", .F., aObrig, cLogFile, @lEnd, nRec03 ) .and. lOk }, 'Validando '+aFiles[3,1] )
		else
			lOk := U_xACChkInt( "TRB12003", "JAH_CODIGO+JAH_SEQ", .F., aObrig, cLogFile, @lEnd, nRec03 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Fim da validação do arquivo "'+aFiles[3,1]+'".' )
	endif	
	
	if lTRB12004
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAH_CODIGO) '	, 'Código do curso vigente não informado.' } )
		aAdd( aObrig, { '!Empty(JAH_SEQ)    '	, 'Sequencial de linha não informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAH_CODIGO == Posicione( "JAH", 1, xFilial("JAH")+JAH_CODIGO, "JAH_CODIGO" ) .or. ( Select("TRB12001") > 0 .and. TRB12001->( dbSeek( TRB12004->JAH_CODIGO, .F. ) ) )'	, 'Curso vigente não cadastrado na tabela JAH e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JAH_CODIGO == Posicione( "JAH", 1, xFilial("JAH")+JAH_CODIGO, "JAH_CODIGO" ) .or. ( Select("TRB12001") > 0 .and. U_xAC20Qry( JAH_CODIGO, "'+cArq01+'" ) ) )'	, 'Curso vigente não cadastrado na tabela JAH e não presente nos arquivos de importação.' } )
		endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Iniciando validação do arquivo "'+aFiles[4,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB12004", "JAH_CODIGO+JAH_SEQ", .F., aObrig, cLogFile, @lEnd, nRec04 ) .and. lOk }, 'Validando '+aFiles[4,1] )
		else
			lOk := U_xACChkInt( "TRB12004", "JAH_CODIGO+JAH_SEQ", .F., aObrig, cLogFile, @lEnd, nRec04 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Fim da validação do arquivo "'+aFiles[4,1]+'".' )
	endif	
	
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsistências. Impossível prosseguir.' )
		if nOpc == 0 .and. Aviso( 'Impossível Prosseguir!', 'Foram detectadas inconsistências. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a gravacao dos dados nas tabelas do sistema³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if nOpc == 0
			Processa( { |lEnd| ProcRegua( nRecs ), lOk := xAC12001Grv( @lEnd, aFiles[1,1], nRec01 ) .and. xAC12002Grv( @lEnd, aFiles[2,1], nRec02 ) .and. xAC12003Grv( @lEnd, aFiles[3,1], nRec03 ) .and. xAC12004Grv( @lEnd, aFiles[4,1], nRec04 ) }, 'Gravação em andamento' )
		else
			lOk := xAC12001Grv( @lEnd, aFiles[1,1], nRec01 ) .and. xAC12002Grv( @lEnd, aFiles[2,1], nRec02 ) .and. xAC12003Grv( @lEnd, aFiles[3,1], nRec03 ) .and. xAC12004Grv( @lEnd, aFiles[4,1], nRec04 )
		endif
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Processo de gravação interrompido pelo usuário. Será necessário reiniciar o processo de importação.' )
			Aviso( 'Operação Cancelada!', 'O processo de gravação foi interrompido pelo usuário. Será necessário reiniciar o processo de importação.', {'Ok'} )
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Gravação realizada com sucesso.' )
			Aviso( 'Sucesso!', 'Importação realizada com sucesso.', {'Ok'} )
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

if lTRB12001 .and. nDrv01 <> 3
	FErase( cIDX01 + OrdBagExt() )
endif
if lTRB12002 .and. nDrv02 <> 3
	FErase( cIDX02 + OrdBagExt() )
endif
if lTRB12003 .and. nDrv03 <> 3
	FErase( cIDX03 + OrdBagExt() )
endif
if lTRB12004 .and. nDrv04 <> 3
	FErase( cIDX04 + OrdBagExt() )
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12001GrvºAutor  ³Rafael Rodrigues   º Data ³  13/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados do arquivo principal na base.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12000                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC12001Grv( lEnd, cTitulo, nRecs )
Local cFilJAH	:= xFilial("JAH")	// Criada para ganhar performance
Local cFilJAR	:= xFilial("JAR")	// Criada para ganhar performance
Local cCurso	:= ""
Local i			:= 0
Local lSeek

if Select( "TRB12001" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB12001->( dbGoTop() )

JAH->( dbSetOrder(1) )
JAR->( dbSetOrder(1) )

while TRB12001->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif
	
	begin transaction
	
	lSeek := JAH->( dbSeek( cFilJAH+TRB12001->JAH_CODIGO ) )
	if cCurso <> TRB12001->JAH_CODIGO
		if lOver .or. !lSeek
			RecLock( "JAH", !lSeek )
			JAH->JAH_FILIAL	:= cFilJAH
			JAH->JAH_CURSO	:= TRB12001->JAH_CURSO
			JAH->JAH_VERSAO	:= TRB12001->JAH_VERSAO
			JAH->JAH_CODIGO	:= TRB12001->JAH_CODIGO
			JAH->JAH_DESC	:= TRB12001->JAH_DESC
			JAH->JAH_CARGA	:= TRB12001->JAH_CARGA
			JAH->JAH_TURNO	:= TRB12001->JAH_TURNO
			JAH->JAH_GRPDOC	:= TRB12001->JAH_GRPDOC
			JAH->JAH_TIPO	:= TRB12001->JAH_TIPO
			JAH->JAH_TEMPOJ	:= TRB12001->JAH_TEMPOJ
			JAH->JAH_QTDTRA	:= TRB12001->JAH_QTDTRA
			JAH->JAH_STATUS	:= TRB12001->JAH_STATUS
			JAH->JAH_GRUPO	:= TRB12001->JAH_GRUPO
			JAH->JAH_UNIDAD	:= TRB12001->JAH_UNIDAD
			JAH->JAH_VALOR	:= TRB12001->JAH_VALOR
			JAH->JAH_PRCSEL	:= TRB12001->JAH_PRCSEL
			JAH->JAH_MATSEQ	:= TRB12001->JAH_MATSEQ
			JAH->JAH_MAXDIS	:= TRB12001->JAH_MAXDIS
			JAH->JAH_AMG_	:= TRB12001->JAH_AMG_
			JAH->JAH_CCOMIT	:= TRB12001->JAH_CCOMIT
			JAH->( msUnlock() )
		endif
		cCurso := TRB12001->JAH_CODIGO
	endif
	
	lSeek := JAR->( dbSeek( cFilJAR+TRB12001->JAH_CODIGO+TRB12001->JAR_PERLET ) )
	if lOver .or. !lSeek
		RecLock( "JAR", !lSeek )
		JAR->JAR_FILIAL	:= cFilJAR
		JAR->JAR_CODCUR	:= TRB12001->JAH_CODIGO
		JAR->JAR_PERLET	:= TRB12001->JAR_PERLET
		JAR->JAR_DPERLE	:= TRB12001->JAR_DPERLE
		JAR->JAR_HABILI	:= TRB12001->JAR_HABILI
		JAR->JAR_DATA1	:= TRB12001->JAR_DATA1
		JAR->JAR_DATA2	:= TRB12001->JAR_DATA2
		JAR->JAR_ANOLET	:= TRB12001->JAR_ANOLET
		JAR->JAR_PERIOD	:= TRB12001->JAR_PERIOD
		JAR->JAR_CARGA	:= TRB12001->JAR_CARGA
		JAR->JAR_DPMAX	:= TRB12001->JAR_DPMAX
		JAR->JAR_ALTGRA	:= TRB12001->JAR_ALTGRA
		JAR->JAR_DTMAT1	:= TRB12001->JAR_DTMAT1
		JAR->JAR_DTMAT2	:= TRB12001->JAR_DTMAT2
		JAR->JAR_MEDAPR	:= TRB12001->JAR_MEDAPR
		JAR->JAR_EXAME	:= TRB12001->JAR_EXAME
		JAR->JAR_DEPREP	:= TRB12001->JAR_DEPREP
		JAR->JAR_AULA1	:= TRB12001->JAR_AULA1
		JAR->JAR_AULA2	:= TRB12001->JAR_AULA2
		JAR->JAR_AULA3	:= TRB12001->JAR_AULA3
		JAR->JAR_AULA4	:= TRB12001->JAR_AULA4
		JAR->JAR_AULA5	:= TRB12001->JAR_AULA5
		JAR->JAR_AULA6	:= TRB12001->JAR_AULA6
		JAR->JAR_AULA7	:= TRB12001->JAR_AULA7
		JAR->JAR_QTDVAG	:= TRB12001->JAR_QTDVAG
		JAR->JAR_QTDRES	:= TRB12001->JAR_QTDRES
		JAR->JAR_QTDMAT	:= TRB12001->JAR_QTDMAT
		JAR->JAR_QTDLIV	:= TRB12001->JAR_QTDLIV
		JAR->JAR_TRANSF	:= TRB12001->JAR_TRANSF
		JAR->JAR_CALACA	:= TRB12001->JAR_CALACA
		JAR->JAR_PERPRE	:= TRB12001->JAR_PERPRE
		JAR->JAR_APFALT	:= TRB12001->JAR_APFALT
		JAR->JAR_FALTAS	:= TRB12001->JAR_FALTAS
		JAR->JAR_FRQMIN	:= TRB12001->JAR_FRQMIN
		JAR->JAR_MAXDIS	:= TRB12001->JAR_MAXDIS
		JAR->JAR_NOTMIN	:= TRB12001->JAR_NOTMIN
		JAR->JAR_CRIAVA	:= TRB12001->JAR_CRIAVA
		JAR->JAR_EQVCON	:= TRB12001->JAR_EQVCON
		JAR->( msUnlock() )
	endif
	
	end transaction

	TRB12001->( dbSkip() )
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12002GrvºAutor  ³Rafael Rodrigues   º Data ³  13/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados dos Conteudos na base.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12000                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC12002Grv( lEnd, cTitulo, nRecs )
Local cFilJAH	:= xFilial("JAH")	// Criada para ganhar performance
Local i			:= 0
Local cCurso
Local cMemo

if Select( "TRB12002" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB12002->( dbGoTop() )

JAH->( dbSetOrder(1) )

while TRB12002->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cCurso	:= TRB12002->JAH_CODIGO
	
	while cCurso == TRB12002->JAH_CODIGO .and. TRB12002->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif
		
		cMemo += StrTran( TRB12002->JAH_MEMO1, '\13\10', CRLF )
		
		TRB12002->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAH->( dbSeek( cFilJAH+cCurso ) ) .and. ( lOver .or. Empty( JAH->JAH_MEMO1 ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAH_ESCOPO³
		//³e armazena o codigo do memo no campo JAH_MEMO1. Sobrescreve caso JAH_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JAH", .F. )
		MSMM( JAH->JAH_MEMO1, TamSX3("JAH_ESCOPO")[1],, cMemo, 1,,, "JAH", "JAH_MEMO1" )
		JAH->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12003GrvºAutor  ³Rafael Rodrigues   º Data ³  13/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados dos Conteudos na base.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12000                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC12003Grv( lEnd, cTitulo, nRecs )
Local cFilJAH	:= xFilial("JAH")	// Criada para ganhar performance
Local i			:= 0
Local cCurso
Local cMemo

if Select( "TRB12003" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB12003->( dbGoTop() )

JAH->( dbSetOrder(1) )

while TRB12003->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cCurso	:= TRB12003->JAH_CODIGO
	
	while cCurso == TRB12003->JAH_CODIGO .and. TRB12003->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif

		cMemo += StrTran( TRB12003->JAH_MEMO2, '\13\10', CRLF )
		
		TRB12003->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAH->( dbSeek( cFilJAH+cCurso ) ) .and. ( lOver .or. Empty( JAH->JAH_MEMO2 ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAH_PREREQ³
		//³e armazena o codigo do memo no campo JAH_MEMO2. Sobrescreve caso JAH_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JAH", .F. )
		MSMM( JAH->JAH_MEMO2, TamSX3("JAH_PREREQ")[1],, cMemo, 1,,, "JAH", "JAH_MEMO2" )
		JAH->( msUnlock() )

		end transaction
	endif

end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12004GrvºAutor  ³Rafael Rodrigues   º Data ³  13/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados dos Conteudos na base.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12000                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC12004Grv( lEnd, cTitulo, nRecs )
Local cFilJAH	:= xFilial("JAH")	// Criada para ganhar performance
Local i			:= 0
Local cCurso
Local cMemo

if Select( "TRB12004" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB12004->( dbGoTop() )

JAH->( dbSetOrder(1) )

while TRB12004->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cCurso	:= TRB12004->JAH_CODIGO
	
	while cCurso == TRB12004->JAH_CODIGO .and. TRB12004->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif

		cMemo += StrTran( TRB12004->JAH_MEMO3, '\13\10', CRLF )
		
		TRB12004->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAH->( dbSeek( cFilJAH+cCurso ) ) .and. ( lOver .or. Empty( JAH->JAH_MEMO3 ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAH_DECRET³
		//³e armazena o codigo do memo no campo JAH_MEMO3. Sobrescreve caso JAH_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JAH", .F. )
		MSMM( JAH->JAH_MEMO3, TamSX3("JAH_DECRET")[1],, cMemo, 1,,, "JAH", "JAH_MEMO3" )
		JAH->( msUnlock() )

		end transaction
	endif

end

Return !lEnd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC120Qry ºAutor  ³Rafael Rodrigues    º Data ³ 10/Fev/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se um curso esta sendo importada no arquivo        º±±
±±º          ³de trabalho                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ xAC12000                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC120Qry( cCurso, cTable )
Local lOk
Local cQuery := ""

cQuery := "select count(*) as QUANT "
cQuery += "  from "+cTable
cQuery += " where JAH_CODIGO = '"+cCurso+"' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY20", .F., .F. )
TCSetField( "QRY20", "QUANT", "N", 1, 0 )

lOk := QRY20->QUANT > 0

QRY20->( dbCloseArea() )

Return lOk