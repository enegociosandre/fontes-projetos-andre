#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12300  ºAutor  ³Rafael Rodrigues    º Data ³  16/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Avaliacoes dos Cursos Vigentes        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC12300( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC12300'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local nDrv		:= 0

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JBQ_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBQ_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBQ_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JBQ_CODAVA", "C", 002, 0 } )
aAdd( aStru, { "JBQ_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JBQ_DATA"  , "D", 008, 0 } )
aAdd( aStru, { "JBQ_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JBQ_PESO"  , "N", 002, 0 } )
aAdd( aStru, { "JBQ_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JBQ_CHAMAD", "C", 001, 0 } )
aAdd( aStru, { "JBQ_DTAPON", "D", 008, 0 } )
aAdd( aStru, { "JBQ_EXASUB", "C", 001, 0 } )
aAdd( aStru, { "JBQ_ATIVID", "C", 001, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Avaliações dos Cursos Vigentes', 'AC12300', aClone( aStru ), 'TRB123', .T., 'JBQ_CODCUR, JBQ_PERLET, JBQ_HABILI, JBQ_CODAVA', {|| "JBQ_CODCUR in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JBQ_CODCUR and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDrv := aScan( aDriver, aTables[1,3] ) 
	if nDrv # 3
		TRB123->( dbGoBottom() )
		if Empty( TRB123->JBQ_CODCUR )
			RecLock( "TRB123", .F. )
			TRB123->( dbDelete() )
			TRB123->( msUnlock() )
		endif
	endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd( aObrig, { '!Empty(JBQ_CODCUR) ', 'Código do curso vigente não informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_PERLET) ', 'Período letivo não informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_CODAVA) ', 'Código da avaliação não informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_DESC)   ', 'Descrição não informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_DATA)   ', 'Data inicial não informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_DATA2)  ', 'Data final não informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_PESO)   ', 'Peso não informado.' } )
	aAdd( aObrig, { 'JBQ_TIPO$"1234"    ', 'Tipo deve ser 1 (Regular), 2 (Exame), 3 (Integrada) ou 4 (Nota Única).' } )
	aAdd( aObrig, { 'JBQ_CHAMAD$"12"    ', 'Segunda chamada deve ser 1 (Sim) ou 2 (Não).' } )
	aAdd( aObrig, { 'JBQ_EXASUB$"12"    ', 'JBQ_EXASUB deve ser 1 (Sim) ou 2 (Não).' } )
	aAdd( aObrig, { 'JBQ_ATIVID$"12"    ', 'JBQ_ATIVID deve ser 1 (Sim) ou 2 (Não).' } )
	aAdd( aObrig, { '!Empty(JBQ_DTAPON) ', 'Data limite para apontamento não informado.' } )
	aAdd( aObrig, { 'JBQ_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI, "JAR_PERLET" )', 'Período letivo não cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JBQ_DATA >= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI, "JAR_DATA1" ) .and. JBQ_DATA <= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI, "JAR_DATA2" )', 'Data inicial fora do limite de datas do período letivo.' } )
	aAdd( aObrig, { 'JBQ_DATA2 >= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI, "JAR_DATA1" ) .and. JBQ_DATA2 <= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI, "JAR_DATA2" )', 'Data final fora do limite de datas do período letivo.' } )
	aAdd( aObrig, { 'JBQ_DATA <= JBQ_DATA2', 'Data inicial deve ser menor ou igual à data final.' } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena o arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nDrv # 3
		if nOpc == 0
			MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB123", cIDX, "JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI+JBQ_CODAVA" ) } )
		else
			Eval( {|| IndRegua( "TRB123", cIDX, "JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI+JBQ_CODAVA" ) } )
		endif
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica chaves unicas e consistencias pre-definidas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )
	if nOpc == 0
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB123", "JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI+JBQ_CODAVA", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Validação do Arquivo' )
	else
		lOk := U_xACChkInt( "TRB123", "JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI+JBQ_CODAVA", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk
	endif
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[1,1]+'".' )
	
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
			Processa( { |lEnd| lOk := xAC12300Grv( @lEnd, aTables[1,4] ) }, 'Gravação em andamento' )
		else
			lOk := xAC12300Grv( @lEnd, aTables[1,4] )
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Elimina os arquivos de trabalho criados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	( aTables[1,1] )->( dbCloseArea() )
	if nDrv # 3
		FErase( aTables[1,2]+GetDBExtension() )
		FErase( cIDX+OrdBagExt() )
	endif	
	
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12300GrvºAutor  ³Rafael Rodrigues   º Data ³  16/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados na base do AP6.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12300                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC12300Grv( lEnd, nRecs )
Local cFilJBQ	:= xFilial("JBQ")	// Criada para ganhar performance
Local i			:= 0
Local cChave	:= ""
Local nItem		:= 0
Local lSeek

if nOpc == 0
	ProcRegua( TRB123->( RecCount() ) )
endif

TRB123->( dbGoTop() )

JBQ->( dbSetOrder(3) )

while TRB123->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif

	if cChave <> TRB123->( JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI )
		cChave := TRB123->( JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI )
		nItem  := 0
	endif
		
	begin transaction
	
	lSeek := JBQ->( dbSeek( cFilJBQ+TRB123->JBQ_CODCUR+TRB123->JBQ_PERLET+TRB123->JBQ_HABILI+TRB123->JBQ_CODAVA ) )
	if lOver .or. !lSeek
		RecLock( "JBQ", !lSeek )
		JBQ->JBQ_FILIAL	:= cFilJBQ
		JBQ->JBQ_CODCUR	:= TRB123->JBQ_CODCUR
		JBQ->JBQ_PERLET	:= TRB123->JBQ_PERLET
		JBQ->JBQ_HABILI	:= TRB123->JBQ_HABILI
		JBQ->JBQ_ITEM	:= StrZero( ++nItem, 2 )
		JBQ->JBQ_DATA	:= TRB123->JBQ_DATA
		JBQ->JBQ_DATA2	:= TRB123->JBQ_DATA2
		JBQ->JBQ_CODAVA	:= TRB123->JBQ_CODAVA
		JBQ->JBQ_DESC	:= TRB123->JBQ_DESC
		JBQ->JBQ_PESO	:= TRB123->JBQ_PESO
		JBQ->JBQ_TIPO	:= TRB123->JBQ_TIPO
		JBQ->JBQ_CHAMAD	:= TRB123->JBQ_CHAMAD
		JBQ->JBQ_DTAPON	:= TRB123->JBQ_DTAPON
		JBQ->JBQ_EXASUB	:= TRB123->JBQ_EXASUB
		JBQ->JBQ_ATIVID	:= TRB123->JBQ_ATIVID
		JBQ->( msUnlock() )
	endif
	
	end transaction

	TRB123->( dbSkip() )
end

Return !lEnd