#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13100  ºAutor  ³Rafael Rodrigues    º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Alunos                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC13100( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC13100'
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
Local lTRB13101	:= .F.
Local lTRB13102	:= .F.
Local lTRB13103	:= .F.
Local lTRB13104	:= .F.
Local nRec01	:= 0
Local nRec02	:= 0
Local nRec03	:= 0
Local nRec04	:= 0
Local nRecs		:= 0
Local nPos
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local i

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JA2_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JA2_CODINS", "C", 010, 0 } )
aAdd( aStru, { "JA2_PROSEL", "C", 006, 0 } )
aAdd( aStru, { "JA2_NOME"  , "C", 060, 0 } )
aAdd( aStru, { "JA2_CEP"   , "C", 008, 0 } )
aAdd( aStru, { "JA2_END"   , "C", 040, 0 } )
aAdd( aStru, { "JA2_NUMEND", "C", 005, 0 } )
aAdd( aStru, { "JA2_COMPLE", "C", 050, 0 } )
aAdd( aStru, { "JA2_BAIRRO", "C", 020, 0 } )
aAdd( aStru, { "JA2_CIDADE", "C", 020, 0 } )
aAdd( aStru, { "JA2_EST"   , "C", 002, 0 } )
aAdd( aStru, { "JA2_FRESID", "C", 015, 0 } )
aAdd( aStru, { "JA2_FCELUL", "C", 015, 0 } )
aAdd( aStru, { "JA2_FCONTA", "C", 015, 0 } )
aAdd( aStru, { "JA2_NOMCON", "C", 030, 0 } )
aAdd( aStru, { "JA2_EMAIL" , "C", 040, 0 } )
aAdd( aStru, { "JA2_DTNASC", "D", 008, 0 } )
aAdd( aStru, { "JA2_NATURA", "C", 002, 0 } )
aAdd( aStru, { "JA2_NACION", "C", 002, 0 } )
aAdd( aStru, { "JA2_ECIVIL", "C", 001, 0 } )
aAdd( aStru, { "JA2_PAI"   , "C", 060, 0 } )
aAdd( aStru, { "JA2_MAE"   , "C", 060, 0 } )
aAdd( aStru, { "JA2_SEXO"  , "C", 001, 0 } )
aAdd( aStru, { "JA2_DATA"  , "D", 008, 0 } )
aAdd( aStru, { "JA2_CPF"   , "C", 014, 0 } )
aAdd( aStru, { "JA2_TIPCPF", "C", 001, 0 } )
aAdd( aStru, { "JA2_RG"    , "C", 010, 0 } )
aAdd( aStru, { "JA2_DTRG"  , "D", 008, 0 } )
aAdd( aStru, { "JA2_ESTRG" , "C", 002, 0 } )
aAdd( aStru, { "JA2_TITULO", "C", 015, 0 } )
aAdd( aStru, { "JA2_CIDTIT", "C", 020, 0 } )
aAdd( aStru, { "JA2_ESTTIT", "C", 002, 0 } )
aAdd( aStru, { "JA2_ZONA"  , "C", 010, 0 } )
aAdd( aStru, { "JA2_CMILIT", "C", 014, 0 } )
aAdd( aStru, { "JA2_ENDCOB", "C", 060, 0 } )
aAdd( aStru, { "JA2_NUMCOB", "C", 005, 0 } )
aAdd( aStru, { "JA2_BAICOB", "C", 020, 0 } )
aAdd( aStru, { "JA2_COMCOB", "C", 050, 0 } )
aAdd( aStru, { "JA2_ESTCOB", "C", 002, 0 } )
aAdd( aStru, { "JA2_CIDCOB", "C", 020, 0 } )
aAdd( aStru, { "JA2_CEPCOB", "C", 008, 0 } )
aAdd( aStru, { "JA2_STATUS", "C", 001, 0 } )
aAdd( aStru, { "JA2_CLIENT", "C", 006, 0 } )
aAdd( aStru, { "JA2_LOJA"  , "C", 002, 0 } )
aAdd( aStru, { "JA2_PROCES", "C", 006, 0 } )
aAdd( aStru, { "JA2_INSTIT", "C", 006, 0 } )
aAdd( aStru, { "JA2_DATAPR", "C", 050, 0 } )
aAdd( aStru, { "JA2_CLASSF", "C", 006, 0 } )
aAdd( aStru, { "JA2_PONTUA", "N", 008, 2 } )
aAdd( aStru, { "JA2_FORING", "C", 001, 0 } )
aAdd( aStru, { "JA2_DATADI", "D", 008, 0 } )
aAdd( aStru, { "JA2_WPSS"  , "C", 006, 0 } )
aAdd( aStru, { "JA2_PROFIS", "C", 040, 0 } )
aAdd( aStru, { "JA2_CEPPRF", "C", 008, 0 } )
aAdd( aStru, { "JA2_ENDPRF", "C", 040, 0 } )
aAdd( aStru, { "JA2_NUMPRF", "C", 005, 0 } )
aAdd( aStru, { "JA2_BAIPRF", "C", 020, 0 } )
aAdd( aStru, { "JA2_COMPRF", "C", 050, 0 } )
aAdd( aStru, { "JA2_CIDPRF", "C", 020, 0 } )
aAdd( aStru, { "JA2_ESTPRF", "C", 002, 0 } )
aAdd( aStru, { "JA2_FCOML" , "C", 015, 0 } )
aAdd( aStru, { "JA2_RAMAL" , "C", 005, 0 } )
aAdd( aStru, { "JA2_ENTIDA", "C", 006, 0 } )
aAdd( aStru, { "JA2_CONCLU", "C", 004, 0 } )
aAdd( aStru, { "JA2_ACAOJU", "C", 001, 0 } )
aAdd( aStru, { "JA2_VERCAR", "C", 003, 0 } )
aAdd( aStru, { "JA2_PRONTU", "C", 015, 0 } )
aAdd( aStru, { "JA2_PASTA" , "C", 015, 0 } )
aAdd( aStru, { "JA2_ARQMOR", "C", 015, 0 } )
aAdd( aStru, { "JA2_DIARIO", "C", 015, 0 } )
aAdd( aStru, { "JA2_PUBLIC", "C", 015, 0 } )
aAdd( aStru, { "JA2_DATAPU", "D", 008, 0 } )
aAdd( aStru, { "JA2_ALUNOV", "C", 001, 0 } )
aAdd( aStru, { "JA2_TIPENS", "C", 001, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Cadastro de Alunos', 'AC13101', aClone( aStru ), 'TRB13101', .F., 'JA2_NUMRA' } )

aStru := {}

aAdd( aStru, { "JA2_NUMRA" , "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JA2_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JA2_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Observações', 'AC13102', aClone( aStru ), 'TRB13102', .F., 'JA2_NUMRA, JA2_SEQ' } )

aStru := {}

aAdd( aStru, { "JA2_NUMRA" , "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JA2_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JA2_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Disciplinas do Processo Seletivo', 'AC13103', aClone( aStru ), 'TRB13103', .F., 'JA2_NUMRA, JA2_SEQ' } )

aStru := {}

aAdd( aStru, { "JC1_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JC1_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JC1_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JC1_NOME"  , "C", 030, 0 } )
aAdd( aStru, { "JC1_EMAIL" , "C", 040, 0 } )
aAdd( aStru, { "JC1_PERC"  , "N", 006, 2 } )
aAdd( aStru, { "JC1_RG"    , "C", 010, 0 } )
aAdd( aStru, { "JC1_CPF"   , "C", 014, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Responsáveis pelos Alunos', 'AC13104', aClone( aStru ), 'TRB13104', .F., 'JC1_NUMRA, JC1_ITEM' } )

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
	
	nPos := aScan( aTables, {|x| x[1] == "TRB13101"} )
	if nPos > 0
		lTRB13101	:= .T.
		nDrv01	:= aScan( aDriver, aTables[nPos, 3] )
		nRec01	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
		cArq01	:= aTables[nPos, 2]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB13102"} )
	if nPos > 0
		lTRB13102	:= .T.
		nDrv02	:= aScan( aDriver, aTables[nPos, 3] )
		nRec02	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB13103"} )
	if nPos > 0
		lTRB13103	:= .T.
		nDrv03	:= aScan( aDriver, aTables[nPos, 3] )
		nRec03	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB13104"} )
	if nPos > 0
		lTRB13104	:= .T.
		nDrv04	:= aScan( aDriver, aTables[nPos, 3] )
		nRec04	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lTRB13101 .and. nDrv01 <> 3
		TRB13101->( dbGoBottom() )
		if Empty( TRB13101->JA2_NUMRA )
			RecLock( "TRB13101", .F. )
			TRB13101->( dbDelete() )
			TRB13101->( msUnlock() )
		endif
	endif

	if lTRB13102 .and. nDrv02 <> 3
		TRB13102->( dbGoBottom() )
		if Empty( TRB13102->JA2_NUMRA )
			RecLock( "TRB13102", .F. )
			TRB13102->( dbDelete() )
			TRB13102->( msUnlock() )
		endif
	endif

	if lTRB13103 .and. nDrv03 <> 3
		TRB13103->( dbGoBottom() )
		if Empty( TRB13103->JA2_NUMRA )
			RecLock( "TRB13103", .F. )
			TRB13103->( dbDelete() )
			TRB13103->( msUnlock() )
		endif
	endif

	if lTRB13104 .and. nDrv04 <> 3
		TRB13104->( dbGoBottom() )
		if Empty( TRB13104->JC1_NUMRA )
			RecLock( "TRB13104", .F. )
			TRB13104->( dbDelete() )
			TRB13104->( msUnlock() )
		endif
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena os arquivos de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nOpc == 0
		MsgRun( 'Ordenando arquivos...',, {||	if( lTRB13101 .and. nDrv01 <> 3, TRB13101->( IndRegua( "TRB13101", cIDX01, "JA2_NUMRA" ) ), NIL ),;
												if( lTRB13102 .and. nDrv02 <> 3, TRB13102->( IndRegua( "TRB13102", cIDX02, "JA2_NUMRA+JA2_SEQ" ) ), NIL ),;
												if( lTRB13103 .and. nDrv03 <> 3, TRB13103->( IndRegua( "TRB13103", cIDX03, "JA2_NUMRA+JA2_SEQ" ) ), NIL ),;
												if( lTRB13104 .and. nDrv04 <> 3, TRB13104->( IndRegua( "TRB13104", cIDX04, "JC1_NUMRA+JC1_ITEM" ) ), NIL ) } )
	else
		Eval( {||	if( lTRB13101 .and. nDrv01 <> 3, TRB13101->( IndRegua( "TRB13101", cIDX01, "JA2_NUMRA" ) ), NIL ),;
					if( lTRB13102 .and. nDrv02 <> 3, TRB13102->( IndRegua( "TRB13102", cIDX02, "JA2_NUMRA+JA2_SEQ" ) ), NIL ),;
					if( lTRB13103 .and. nDrv03 <> 3, TRB13103->( IndRegua( "TRB13103", cIDX03, "JA2_NUMRA+JA2_SEQ" ) ), NIL ),;
					if( lTRB13104 .and. nDrv04 <> 3, TRB13104->( IndRegua( "TRB13104", cIDX04, "JC1_NUMRA+JC1_ITEM" ) ), NIL ) } )
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lTRB13101
		aObrig := {}
		aAdd( aObrig, { '!Empty(JA2_NUMRA) '	, 'RA não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_NOME)  '	, 'Nome não informado.' } )
		aAdd( aObrig, { 'Posicione("JC2",1,xFilial("JC2")+JA2_CEP,"JC2_CEP") == JA2_CEP'	, 'CEP inválido.' } )
		aAdd( aObrig, { '!Empty(JA2_END)   '	, 'Endereço não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_NUMEND)'	, 'Número do logradouro não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_BAIRRO)'	, 'Bairro não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_CIDADE)'	, 'Cidade não informada.' } )
		aAdd( aObrig, { 'Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA2_EST,"X5_CHAVE"),2) == JA2_EST'	, 'Estado inválido.' } )
		aAdd( aObrig, { '!Empty(JA2_DTNASC)'	, 'Data de nascimento não informada.' } )
		aAdd( aObrig, { '!Empty(JA2_NATURA)'	, 'Naturalidade não informada.' } )
		aAdd( aObrig, { 'Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA2_NATURA,"X5_CHAVE"),2) == JA2_NATURA'	, 'Naturalidalidade inválida.' } )
		aAdd( aObrig, { '!Empty(JA2_NACION)'	, 'Nacionalidade não informada.' } )
		aAdd( aObrig, { 'Left(Posicione("SX5",1,xFilial("SX5")+"34"+JA2_NACION,"X5_CHAVE"),2) == JA2_NACION'	, 'Nacionalidade inválida.' } )
		aAdd( aObrig, { 'JA2_ECIVIL$"CDMQSV"'	, 'Estado Civil deve ser C=Casado, D=Divorciado, M=Marital, Q=Desquitado, S=Solteiro ou V=Viúvo.' } )
		aAdd( aObrig, { '!Empty(JA2_PAI)   '	, 'Nome do pai não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_MAE)   '	, 'Nome da mãe não informado.' } )
		aAdd( aObrig, { 'JA2_SEXO$"12"'			, 'Sexo deve ser 1 (Masculino) ou 2 (Feminino).' } )
		aAdd( aObrig, { '!Empty(JA2_CPF)   '	, 'CPF não informado.' } )
		aAdd( aObrig, { 'U_xACChkCGC(JA2_CPF)'	, 'CPF inválido.' } )
		aAdd( aObrig, { 'JA2_TIPCPF$"12"'		, 'Tipo do CPF deve ser 1(Próprio) ou 2(Responsável).' } )
		aAdd( aObrig, { 'Empty(JA2_ESTRG) .or. Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA2_ESTRG,"X5_CHAVE"),2) == JA2_ESTRG'	, 'Estado de expedição do RG inválido.' } )
		aAdd( aObrig, { 'Empty(JA2_ESTCOB) .or. Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA2_ESTCOB,"X5_CHAVE"),2) == JA2_ESTCOB'	, 'Estado do endereço de cobrança inválido.' } )
		aAdd( aObrig, { 'Empty(JA2_CEPCOB) .or. Posicione("JC2",1,xFilial("JC2")+JA2_CEPCOB,"JC2_CEP") == JA2_CEPCOB'	, 'CEP do endereço de cobrança inválido.' } )
		aAdd( aObrig, { 'Empty(JA2_INSTIT) .or. Posicione("JCL",1,xFilial("JCL")+JA2_INSTIT,"JCL_CODIGO") == JA2_INSTIT'	, 'Instituição anterior não cadastrada na tabela JCL.' } )
		aAdd( aObrig, { '!Empty(JA2_PROFIS)'	, 'Profissão não informada.' } )
		aAdd( aObrig, { 'Empty(JA2_CEPPRF) .or. Posicione("JC2",1,xFilial("JC2")+JA2_CEPPRF,"JC2_CEP") == JA2_CEPPRF'	, 'CEP do endereço comercial inválido.' } )
		aAdd( aObrig, { 'Empty(JA2_ENTIDA) .or. Posicione("JCL",1,xFilial("JCL")+JA2_ENTIDA,"JCL_CODIGO") == JA2_ENTIDA'	, 'Entidade anterior não cadastrada na tabela JCL.' } )
		aAdd( aObrig, { 'Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA2_ESTPRF,"X5_CHAVE"),2) == JA2_ESTPRF'	, 'Estado do endereço comercial inválido.' } )
		aAdd( aObrig, { 'Empty(JA2_CONCLU) .or. Len(Alltrim(JA2_CONCLU)) == 4'	, 'Ano de conclusão deve ser informado com 4 dígitos.' } )
		aAdd( aObrig, { 'JA2_STATUS$"12"'		, 'Status deve ser 1 (Efetivo) ou 2 (Provisório).' } )
		aAdd( aObrig, { 'JA2_FORING$" 12345"'	, 'Forma de ingresso deve ser 1 (Processo Seletivo), 2 (ENEM), 3 (Entrevista), 4 (Vestibular Externo) ou 5 (Sem Processo Adm.).' } )
		aAdd( aObrig, { 'JA2_ACAOJU$" 12"'		, '"Tem ação judicial?" deve ser 1 (Sim) ou 2 (Não).' } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB13101", "JA2_NUMRA", .F., aObrig, cLogFile, @lEnd, nRec01 ) .and. lOk  }, 'Validando '+aFiles[1,1] )
		else
			lOk := U_xACChkInt( "TRB13101", "JA2_NUMRA", .F., aObrig, cLogFile, @lEnd, nRec01 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[1,1]+'".' )
	endif	

	if lTRB13102
		aObrig := {}
		aAdd( aObrig, { '!Empty(JA2_NUMRA) '	, 'RA não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_SEQ)    '	, 'Sequencial de linha não informado.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JA2_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JA2_NUMRA, "JA2_NUMRA" ) .or. ( Select("TRB13101") > 0 .and. TRB13101->( dbSeek( TRB13102->JA2_NUMRA, .F. ) ) )'	, 'Aluno não cadastrado na tabela JA2 e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JA2_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JA2_NUMRA, "JA2_NUMRA" ) .or. ( Select("TRB13101") > 0 .and. U_xAC131Qry( JA2_NUMRA, "'+cArq01+'" ) )'	, 'Aluno não cadastrado na tabela JA2 e não presente nos arquivos de importação.' } )
		endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[2,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB13102", "JA2_NUMRA+JA2_SEQ", .F., aObrig, cLogFile, @lEnd, nRec02 ) .and. lOk }, 'Validando '+aFiles[2,1] )
		else
			lOk := U_xACChkInt( "TRB13102", "JA2_NUMRA+JA2_SEQ", .F., aObrig, cLogFile, @lEnd, nRec02 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[2,1]+'".' )
	endif	

	if lTRB13103
		aObrig := {}
		aAdd( aObrig, { '!Empty(JA2_NUMRA) '	, 'RA não informado.' } )
		aAdd( aObrig, { '!Empty(JA2_SEQ)    '	, 'Sequencial de linha não informado.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JA2_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JA2_NUMRA, "JA2_NUMRA" ) .or. ( Select("TRB13101") > 0 .and. TRB13101->( dbSeek( TRB13103->JA2_NUMRA, .F. ) ) )'	, 'Aluno não cadastrado na tabela JA2 e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JA2_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JA2_NUMRA, "JA2_NUMRA" ) .or. ( Select("TRB13101") > 0 .and. U_xAC131Qry( JA2_NUMRA, "'+cArq01+'" ) )'	, 'Aluno não cadastrado na tabela JA2 e não presente nos arquivos de importação.' } )
		endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[3,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB13103", "JA2_NUMRA+JA2_SEQ", .F., aObrig, cLogFile, @lEnd, nRec03 ) .and. lOk }, 'Validando '+aFiles[3,1] )
		else
			lOk := U_xACChkInt( "TRB13103", "JA2_NUMRA+JA2_SEQ", .F., aObrig, cLogFile, @lEnd, nRec03 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[3,1]+'".' )
	endif	

	if lTRB13104
		aObrig := {}
		aAdd( aObrig, { '!Empty(JC1_NUMRA)   '	, 'RA não informado.' } )
		aAdd( aObrig, { '!Empty(JC1_ITEM)    '	, 'Item não informado.' } )
		aAdd( aObrig, { 'JC1_ITEM <> StrZero(Val(JC1_ITEM),2) '	, 'Item deve ser informado com zeros à esquerda.' } )
		aAdd( aObrig, { '!Empty(JC1_NOME)    '	, 'Nome não informado.' } )
		aAdd( aObrig, { '!Empty(JC1_PERC)    '	, 'Percentual de responsabilidade não informado.' } )
		aAdd( aObrig, { '!Empty(JC1_RG)      '	, 'RG do responsável não informado.' } )
		aAdd( aObrig, { '!Empty(JC1_CPF)     '	, 'CPF do responsável não informado.' } )
		aAdd( aObrig, { 'U_xACChkCGC(JC1_CPF)'	, 'CPF do responsável inválido.' } )
		aAdd( aObrig, { 'JC1_TIPO$"123"      '	, 'Tipo de responsável deve ser 1(Academico) 2(Financeiro)ou 3(Ambos).' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JA2_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JC1_NUMRA, "JA2_NUMRA" ) .or. ( Select("TRB13101") > 0 .and. TRB13101->( dbSeek( TRB13104->JC1_NUMRA, .F. ) ) )'	, 'Aluno não cadastrado na tabela JA2 e não presente nos arquivos de importação.' } )
		else
			aAdd( aObrig, { 'JA2_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JC1_NUMRA, "JA2_NUMRA" ) .or. ( Select("TRB13101") > 0 .and. U_xAC131Qry( JC1_NUMRA, "'+cArq01+'" ) )'	, 'Aluno não cadastrado na tabela JA2 e não presente nos arquivos de importação.' } )
		endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³verifica chaves unicas e consistencias pre-definidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[4,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB13104", "JC1_NUMRA+JC1_ITEM", .F., aObrig, cLogFile, @lEnd, nRec04 ) .and. lOk }, 'Validando '+aFiles[4,1] )
		else
			lOk := U_xACChkInt( "TRB13104", "JC1_NUMRA+JC1_ITEM", .F., aObrig, cLogFile, @lEnd, nRec04 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[4,1]+'".' )
	endif	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Realiza a gravacao dos dados nas tabelas do sistema³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nOpc == 0
		Processa( { |lEnd| ProcRegua( nRecs ), lEnd := xAC13101Grv( @lEnd, aFiles[1,1], nRec01 ) .and. xAC13102Grv( @lEnd, aFiles[2,1], nRec02 ) .and. xAC13103Grv( @lEnd, aFiles[3,1], nRec03 ) .and. xAC13104Grv( @lEnd, aFiles[4,1], nRec04 ) }, 'Gravação em andamento' )
	else
		lEnd := xAC13101Grv( @lEnd, aFiles[1,1], nRec01 ) .and. xAC13102Grv( @lEnd, aFiles[2,1], nRec02 ) .and. xAC13103Grv( @lEnd, aFiles[3,1], nRec03 ) .and. xAC13104Grv( @lEnd, aFiles[4,1], nRec04 )
	endif
	
	if lEnd
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

	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Foram detectadas inconsistências. Verifique arquivo de log.' )
		if nOpc == 0 .and. Aviso( 'Inconsistências!', 'Foram detectadas inconsistências. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
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

if lTRB13101 .and. nDrv01 <> 3
	FErase( cIDX01 + OrdBagExt() )
endif
if lTRB13102 .and. nDrv02 <> 3
	FErase( cIDX02 + OrdBagExt() )
endif
if lTRB13103 .and. nDrv03 <> 3
	FErase( cIDX03 + OrdBagExt() )
endif
if lTRB13104 .and. nDrv04 <> 3
	FErase( cIDX04 + OrdBagExt() )
endif


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13101GrvºAutor  ³Rafael Rodrigues   º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados do arquivo principal na base.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13101Grv( lEnd, cTitulo, nRecs )
Local cFilJA2	:= xFilial("JA2")	// Criada para ganhar performance
Local cFilSA1	:= xFilial("SA1")	// Criada para ganhar performance
Local cCodCli	:= ""
Local cLojCli	:= ""
Local i			:= 0
Local lSeek

if Select( "TRB13101" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB13101->( dbGoTop() )

JA2->( dbSetOrder(1) )
SA1->( dbSetOrder(1) )

while TRB13101->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif

	lSeek := JA2->( dbSeek( cFilJA2+TRB13101->JA2_NUMRA ) )
	if lOver .or. !lSeek
		begin transaction
	
		if !lSeek .or. Empty( JA2->JA2_CLIENT )
			if Empty( TRB13101->JA2_CLIENT )
				cCodCli  := GetSXENum("SA1","A1_COD")
				cLojCli := "01"
				ConfirmSX8()
			else
				cCodCli := TRB13101->JA2_CLIENT
				cLojCli := if( !Empty(TRB13101->JA2_LOJA), TRB13101->JA2_LOJA, "01" )
			endif
		elseif !Empty( TRB13101->JA2_CLIENT )
			cCodCli := TRB13101->JA2_CLIENT
			cLojCli := if( !Empty(TRB13101->JA2_LOJA), TRB13101->JA2_LOJA, "01" )
		elseif !Empty( JA2->JA2_CLIENT )
			cCodCli := JA2->JA2_CLIENT
			cLojCli := if( !Empty(JA2->JA2_LOJA), JA2->JA2_LOJA, "01" )
		else
			cCodCli  := GetSXENum("SA1","A1_COD")
			cLojCli := "01"
			ConfirmSX8()
		endif
		
		RecLock( "JA2", !lSeek )
		JA2->JA2_FILIAL	:= cFilJA2
		JA2->JA2_NUMRA	:= TRB13101->JA2_NUMRA
		JA2->JA2_CODINS	:= TRB13101->JA2_CODINS
		JA2->JA2_PROSEL	:= TRB13101->JA2_PROSEL
		JA2->JA2_NOME  	:= TRB13101->JA2_NOME
		JA2->JA2_CEP   	:= TRB13101->JA2_CEP
		JA2->JA2_END   	:= TRB13101->JA2_END
		JA2->JA2_NUMEND	:= TRB13101->JA2_NUMEND
		JA2->JA2_COMPLE	:= TRB13101->JA2_COMPLE
		JA2->JA2_BAIRRO	:= TRB13101->JA2_BAIRRO
		JA2->JA2_CIDADE	:= TRB13101->JA2_CIDADE
		JA2->JA2_EST   	:= TRB13101->JA2_EST
		JA2->JA2_FRESID	:= TRB13101->JA2_FRESID
		JA2->JA2_FCELUL	:= TRB13101->JA2_FCELUL
		JA2->JA2_FCONTA	:= TRB13101->JA2_FCONTA
		JA2->JA2_NOMCON	:= TRB13101->JA2_NOMCON
		JA2->JA2_EMAIL 	:= TRB13101->JA2_EMAIL
		JA2->JA2_DTNASC	:= TRB13101->JA2_DTNASC
		JA2->JA2_NATURA	:= TRB13101->JA2_NATURA
		JA2->JA2_NACION	:= TRB13101->JA2_NACION
		JA2->JA2_ECIVIL	:= TRB13101->JA2_ECIVIL
		JA2->JA2_PAI   	:= TRB13101->JA2_PAI
		JA2->JA2_MAE   	:= TRB13101->JA2_MAE
		JA2->JA2_SEXO  	:= TRB13101->JA2_SEXO
		JA2->JA2_DATA  	:= TRB13101->JA2_DATA
		JA2->JA2_CPF   	:= TRB13101->JA2_CPF
		JA2->JA2_TIPCPF	:= TRB13101->JA2_TIPCPF
		JA2->JA2_RG    	:= TRB13101->JA2_RG
		JA2->JA2_DTRG  	:= TRB13101->JA2_DTRG
		JA2->JA2_ESTRG 	:= TRB13101->JA2_ESTRG
		JA2->JA2_TITULO	:= TRB13101->JA2_TITULO
		JA2->JA2_CIDTIT	:= TRB13101->JA2_CIDTIT
		JA2->JA2_ESTTIT	:= TRB13101->JA2_ESTTIT
		JA2->JA2_ZONA  	:= TRB13101->JA2_ZONA
		JA2->JA2_CMILIT	:= TRB13101->JA2_CMILIT
		JA2->JA2_ENDCOB	:= TRB13101->JA2_ENDCOB
		JA2->JA2_NUMCOB	:= TRB13101->JA2_NUMCOB
		JA2->JA2_BAICOB	:= TRB13101->JA2_BAICOB
		JA2->JA2_COMCOB	:= TRB13101->JA2_COMCOB
		JA2->JA2_ESTCOB	:= TRB13101->JA2_ESTCOB
		JA2->JA2_CIDCOB	:= TRB13101->JA2_CIDCOB
		JA2->JA2_CEPCOB	:= TRB13101->JA2_CEPCOB
		JA2->JA2_STATUS	:= TRB13101->JA2_STATUS
		JA2->JA2_CLIENT	:= cCodCli
		JA2->JA2_LOJA  	:= cLojCli
		JA2->JA2_PROCES	:= TRB13101->JA2_PROCES
		JA2->JA2_INSTIT	:= TRB13101->JA2_INSTIT
		JA2->JA2_DATAPR	:= TRB13101->JA2_DATAPR
		JA2->JA2_CLASSF	:= TRB13101->JA2_CLASSF
		JA2->JA2_PONTUA	:= TRB13101->JA2_PONTUA
		JA2->JA2_FORING	:= TRB13101->JA2_FORING
		JA2->JA2_DATADI	:= TRB13101->JA2_DATADI
		JA2->JA2_WPSS  	:= Embaralha( if( Empty(TRB13101->JA2_WPSS), dtos(TRB13101->JA2_DTNASC), TRB13101->JA2_WPSS ), 0 )
		JA2->JA2_PROFIS	:= TRB13101->JA2_PROFIS
		JA2->JA2_CEPPRF	:= TRB13101->JA2_CEPPRF
		JA2->JA2_ENDPRF	:= TRB13101->JA2_ENDPRF
		JA2->JA2_NUMPRF	:= TRB13101->JA2_NUMPRF
		JA2->JA2_BAIPRF	:= TRB13101->JA2_BAIPRF
		JA2->JA2_COMPRF	:= TRB13101->JA2_COMPRF
		JA2->JA2_CIDPRF	:= TRB13101->JA2_CIDPRF
		JA2->JA2_ESTPRF	:= TRB13101->JA2_ESTPRF
		JA2->JA2_FCOML 	:= TRB13101->JA2_FCOML
		JA2->JA2_RAMAL 	:= TRB13101->JA2_RAMAL
		JA2->JA2_ENTIDA	:= TRB13101->JA2_ENTIDA
		JA2->JA2_CONCLU	:= TRB13101->JA2_CONCLU
		JA2->JA2_ACAOJU	:= TRB13101->JA2_ACAOJU
		JA2->JA2_VERCAR	:= TRB13101->JA2_VERCAR
		JA2->JA2_PRONTU	:= TRB13101->JA2_PRONTU
		JA2->JA2_PASTA 	:= TRB13101->JA2_PASTA
		JA2->JA2_ARQMOR	:= TRB13101->JA2_ARQMOR
		JA2->JA2_DIARIO	:= TRB13101->JA2_DIARIO
		JA2->JA2_PUBLIC	:= TRB13101->JA2_PUBLIC
		JA2->JA2_DATAPU	:= TRB13101->JA2_DATAPU
		JA2->JA2_ALUNOV	:= TRB13101->JA2_ALUNOV
		JA2->JA2_TIPENS	:= TRB13101->JA2_TIPENS
	
		JA2->( msUnlock() )
		
		end transaction
	
		begin transaction
	
		RecLock( "SA1", SA1->( !dbSeek( cFilSA1+cCodCli+cLojCli ) ) )
		SA1->A1_FILIAL	:= cFilSA1
		SA1->A1_COD		:= cCodCli
		SA1->A1_LOJA	:= cLojCli
		SA1->A1_NOME	:= JA2->JA2_NOME
		SA1->A1_NREDUZ	:= JA2->JA2_NOME
		SA1->A1_PESSOA	:= "F"
		SA1->A1_TIPO	:= "F"
		SA1->A1_END		:= Alltrim( JA2->JA2_END )+", "+Alltrim( JA2->JA2_NUMEND )
		SA1->A1_MUN		:= JA2->JA2_CIDADE
		SA1->A1_EST		:= JA2->JA2_EST
		SA1->A1_BAIRRO	:= JA2->JA2_BAIRRO
		SA1->A1_CEP		:= JA2->JA2_CEP
		SA1->A1_TEL		:= JA2->JA2_FRESID
		SA1->A1_ENDCOB	:= Alltrim( JA2->JA2_ENDCOB )+", "+Alltrim( JA2->JA2_NUMCOB )
		SA1->A1_CGC		:= JA2->JA2_CPF
		SA1->A1_EMAIL	:= JA2->JA2_EMAIL
		SA1->A1_RG		:= JA2->JA2_RG
		SA1->A1_DTNASC	:= JA2->JA2_DTNASC
		SA1->A1_BAIRROC	:= JA2->JA2_BAICOB
		SA1->A1_CEPC	:= JA2->JA2_CEPCOB
		SA1->A1_MUNC	:= JA2->JA2_CIDCOB
		SA1->A1_ESTC	:= JA2->JA2_ESTCOB
		SA1->A1_NATUREZ	:= &(GetMv("MV_ACNATMT"))
		SA1->A1_NUMRA	:= JA2->JA2_NUMRA
	
		end transaction
	endif
	
	TRB13101->( dbSkip() )
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13102GrvºAutor  ³Rafael Rodrigues   º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados das Observacoes na base.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13102Grv( lEnd, cTitulo, nRecs )
Local cFilJA2		:= xFilial("JA2")	// Criada para ganhar performance
Local i				:= 0
Local cNumRA
Local cMemo

if Select( "TRB13102" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB13102->( dbGoTop() )

JA2->( dbSetOrder(1) )

while TRB13102->( !eof() ) .and. !lEnd

	cMemo		:= ""
	cNumRA		:= TRB13102->JA2_NUMRA
	
	while cNumRA == TRB13102->JA2_NUMRA .and. TRB13102->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif

		cMemo += StrTran( TRB13102->JA2_MEMO1, '\13\10', CRLF )
		
		TRB13102->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JA2->( dbSeek( cFilJA2+cNumRA ) ) .and. ( lOver .or. Empty( JA2->JA2_MEMO1 ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JA2_OBSERV³
		//³e armazena o codigo do memo no campo JA2_MEMO1. Sobrescreve caso JA2_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JA2", .F. )
		MSMM( JA2->JA2_MEMO1, TamSX3("JA2_OBSERV")[1],, cMemo, 1,,, "JA2", "JA2_MEMO1" )
		JA2->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13103GrvºAutor  ³Rafael Rodrigues   º Data ³  23/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados das Disciplinas na base.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13103Grv( lEnd, cTitulo, nRecs )
Local cFilJA2	:= xFilial("JA2")	// Criada para ganhar performance
Local i			:= 0
Local cNumRA
Local cMemo

if Select( "TRB13103" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB13103->( dbGoTop() )

JA2->( dbSetOrder(1) )

while TRB13103->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cNumRA	:= TRB13103->JA2_NUMRA
	
	while cNumRA == TRB13103->JA2_NUMRA .and. TRB13103->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif

		cMemo += StrTran( TRB13103->JA2_MEMO2, '\13\10', CRLF )
		
		TRB13103->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JA2->( dbSeek( cFilJA2+cNumRA ) ) .and. ( lOver .or. Empty( JA2->JA2_MEMO2 ) )
		begin transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JA2_DISPRO³
		//³e armazena o codigo do memo no campo JA2_MEMO2. Sobrescreve caso JA2_MEMO1 esteja preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock( "JA2", .F. )
		MSMM( JA2->JA2_MEMO2, TamSX3("JA2_DISPRO")[1],, cMemo, 1,,, "JA2", "JA2_MEMO2" )
		JA2->( msUnlock() )

		end transaction
	endif

end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC13104GrvºAutor  ³Rafael Rodrigues   º Data ³  26/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos responsaveis pelo aluno.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC13100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC13104Grv( lEnd, cTitulo, nRecs )
Local cFilJC1	:= xFilial("JC1")	// Criada para ganhar performance
Local i			:= 0
Local lSeek

if Select( "TRB13104" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB13104->( dbGoTop() )

JC1->( dbSetOrder(1) )

while TRB13104->( !eof() ) .and. !lEnd

	if nOpc == 0
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif

	lSeek := JC1->( dbSeek( cFilJC1+TRB13104->JC1_NUMRA+TRB13104->JC1_ITEM ) )
	if lOver .or. !lSeek
		begin transaction
		
		RecLock( "JC1", !lSeek )
		JC1->JC1_FILIAL	:= cFilJC1
		JC1->JC1_NUMRA	:= TRB13104->JC1_NUMRA
		JC1->JC1_ITEM	:= TRB13104->JC1_ITEM
		JC1->JC1_TIPO	:= TRB13104->JC1_TIPO
		JC1->JC1_NOME	:= TRB13104->JC1_NOME
		JC1->JC1_EMAIL	:= TRB13104->JC1_EMAIL
		JC1->JC1_PERC	:= TRB13104->JC1_PERC
		JC1->JC1_RG		:= TRB13104->JC1_RG
		JC1->JC1_CPF	:= TRB13104->JC1_CPF
		JC1->( msUnlock() )
    	
		end transaction
    endif
    
	TRB13104->( dbSkip() )
end

Return !lEnd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC131Qry ºAutor  ³Rafael Rodrigues    º Data ³ 11/Fev/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica de determinado aluno esta sendo importado no       º±±
±±º          ³arquivo de alunos                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Migracao de Dados                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC131Qry( cNumRA, cTable )
Local lRet
Local cQuery
Local cArqTRB131 := CriaTrab(, .F.)

cQuery := "select count(*) as QUANT "
cQuery += "  from "+cTable
cQuery += " where JA2_NUMRA = '"+cNumRA+"' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTRB131, .F., .F. )
TCSetField( cArqTRB131, "QUANT", "N", 1, 0 )

lRet := (cArqTRB131)->QUANT > 0

(cArqTRB131)->( dbCloseArea() )

Return lRet