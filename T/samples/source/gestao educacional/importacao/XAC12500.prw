#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12500  ºAutor  ³Rafael Rodrigues    º Data ³  08/01/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa os Calendários Financeiros.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC12500()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cNameFile := 'AC12500'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local nDrv		:= 0
Local i

Private lOver	:= .T.

aAdd( aStru, { "JCB_CODFIN", "C", 010, 0 } )
aAdd( aStru, { "JCB_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JCB_ANOLET", "C", 004, 0 } )
aAdd( aStru, { "JCB_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JCB_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JCB_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JCC_PARCEL", "C", 002, 0 } )
aAdd( aStru, { "JCC_PERC"  , "N", 006, 2 } )
aAdd( aStru, { "JCC_DATA"  , "D", 008, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Calendários Financeiros', '\Import\AC12500.TXT', aClone( aStru ), 'TRB125', .T., 'JCB_CODFIN, JCC_PARCEL, JCC_DATA' } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a janela para selecao de arquivos e importacao dos temporarios³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver )

if Empty( aTables )	//Nenhum arquivo importado.
	AcaLog( cLogFile, '  Nenhum arquivo pôde ser importado para este processo.' )
	Aviso( 'Problema', 'Nenhum arquivo pôde ser importado para este processo.', {'Ok'} )
else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDrv := aScan( aDriver, aTables[1,3] )
	if nDrv # 3
		TRB125->( dbGoBottom() )
		if Empty( TRB125->JCB_CODFIN )
			RecLock( "TRB125", .F. )
			TRB125->( dbDelete() )
			TRB125->( msUnlock() )
		endif
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd( aObrig, { '!Empty(JCB_CODFIN) ', 'Código não informado.' } )
	aAdd( aObrig, { '!Empty(JCB_DESC)   ', 'Descrição não informada.' } )
	aAdd( aObrig, { '!Empty(JCB_ANOLET) ', 'Ano de Vigência não informado.' } )
	aAdd( aObrig, { '!Empty(JCB_PERLET) ', 'Período não informado.' } )
	aAdd( aObrig, { 'JCB_TIPO$"1234"    ', 'Tipo deve ser 1=Mensalidade, 2=Substitutiva, 3=Dependência ou 4=Tutoria.' } )
	aAdd( aObrig, { '!Empty(JCC_PARCEL) ', 'Parcela não informada.' } )
	aAdd( aObrig, { 'JCC_PARCEL == StrZero( Val( JCC_PARCEL ), 2 )', 'Parcela deve ser informada com dois dígitos.' } )
	aAdd( aObrig, { '!Empty(JCC_PERC)   ', 'Percentual do valor não informado.' } )
	aAdd( aObrig, { '!Empty(JCC_DATA)   ', 'Data de vencimento não informada.' } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena o arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nDrv <> 3
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB125", cIDX, "JCB_CODFIN+JCB_PARCEL+dtos(JCC_DATA)" ) } )
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica chaves unicas e consistencias pre-definidas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB125", "JCB_CODFIN+JCB_PARCEL+dtos(JCC_DATA)", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Validação do Arquivo' )
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[1,1]+'".' )
		
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Foram detectadas inconsistências. Impossível prosseguir.' )
		if Aviso( 'Impossível Prosseguir!', 'Foram detectadas inconsistências. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a gravacao dos dados nas tabelas do sistema³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( { |lEnd| lOk := xAC12500Grv( @lEnd, aTables[1,4] ) }, 'Gravação em andamento' )
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Processo de gravação interrompido pelo usuário. Será necessário reiniciar o processo de importação.' )
			Aviso( 'Operação Cancelada!', 'O processo de gravação foi interrompido pelo usuário. Será necessário reiniciar o processo de importação.', {'Ok'} )
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Gravação realizada com sucesso.' )
			Aviso( 'Sucesso!', 'Importação realizada com sucesso.', {'Ok'} )
		endif
	endif
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Elimina os arquivos de trabalho criados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
for i := 1 to len( aTables )
	dbSelectArea( aTables[i][1] )
	dbCloseArea()
	FErase( aTables[i][2]+GetDBExtension() )
next i

FErase( cIDX + OrdBagExt() )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12500GrvºAutor  ³Rafael Rodrigues   º Data ³  08/01/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados na base do AP6.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12500                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC12500Grv( lEnd, nRecs )
Local cFilJCB	:= xFilial("JCB")	// Criada para ganhar performance
Local cFilJCC	:= xFilial("JCC")	// Criada para ganhar performance
Local cChave	:= ""
Local nItem		:= 1
Local i			:= 0
Local lSeek

ProcRegua( nRecs )

TRB125->( dbGoTop() )

JCB->( dbSetOrder(2) )
JCC->( dbSetOrder(2) )

while TRB125->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )

	if TRB125->JCB_CODFIN <> cChave
		cChave	:= TRB125->JCB_CODFIN
		nItem	:= 1
		
		lSeek := JCB->( dbSeek( cFilJCB+TRB125->JCB_CODFIN ) )
		if lOver .or. !lSeek
			begin transaction

			RecLock( "JCB", !lSeek )
			JCB->JCB_FILIAL	:= cFilJCB
			JCB->JCB_CODFIN	:= TRB125->JCB_CODFIN
			JCB->JCB_DESC	:= TRB125->JCB_DESC
			JCB->JCB_ANOLET	:= TRB125->JCB_ANOLET
			JCB->JCB_PERLET	:= TRB125->JCB_PERLET
			JCB->JCB_TIPO	:= TRB125->JCB_TIPO
			JCB->( msUnlock() )
			
			end transaction
		endif
	endif

	lSeek := JCC->( !dbSeek( cFilJCC+TRB125->JCB_CODFIN+TRB125->JCB_ANOLET+TRB125->JCB_PERLET+TRB125->JCB_TIPO+TRB125->JCC_PARCEL ) )
	if lOver .or. !lSeek
		begin transaction

		RecLock( "JCC", !lSeek )
		JCC->JCC_FILIAL	:= cFilJCC
		JCC->JCC_CODFIN	:= TRB125->JCB_CODFIN
		JCC->JCC_ANOLET	:= TRB125->JCB_ANOLET
		JCC->JCC_PERLET	:= TRB125->JCB_PERLET
		JCC->JCC_TIPO	:= TRB125->JCB_TIPO
		JCC->JCC_ITEM	:= StrZero( nItem++, 2 )
		JCC->JCC_PARCEL	:= TRB125->JCC_PARCEL
		JCC->JCC_PERC	:= TRB125->JCC_PERC
		JCC->JCC_DATA	:= TRB125->JCC_DATA
		JCC->( msUnlock() )

		end transaction
	endif
	
	TRB125->( dbSkip() )
end

Return !lEnd