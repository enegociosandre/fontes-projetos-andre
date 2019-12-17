#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12800  ºAutor  ³Rafael Rodrigues    º Data ³  17/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Horarios de Aula                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC12800()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cNameFile := 'AC12800'
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

aAdd( aStru, { "JBC_CODIGO", "C", 006, 0 } )
aAdd( aStru, { "JBC_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JBC_TURNO" , "C", 003, 0 } )
aAdd( aStru, { "JBD_HORA1" , "C", 005, 0 } )
aAdd( aStru, { "JBD_HORA2" , "C", 005, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Horários de Aula', 'AC12800', aClone( aStru ), 'TRB128', .T., 'JBC_CODIGO, JBD_HORA1, JBD_HORA2' } )

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
		TRB128->( dbGoBottom() )
		if Empty( TRB128->JBC_CODIGO )
			RecLock( "TRB128", .F. )
			TRB128->( dbDelete() )
			TRB128->( msUnlock() )
		endif
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd( aObrig, { '!Empty(JBC_CODIGO) ', 'Código não informado.' } )
	aAdd( aObrig, { '!Empty(JBC_DESC)   ', 'Descução não informada.' } )
	aAdd( aObrig, { '!Empty(JBC_TURNO)  ', 'Turno não informado.' } )
	aAdd( aObrig, { 'U_xACIsHora(JBD_HORA1, .F.)', 'Horário inicial não informado ou inválido.' } )
	aAdd( aObrig, { 'U_xACIsHora(JBD_HORA2, .F.)', 'Horário final não informado ou inválido.' } )
	aAdd( aObrig, { '!U_xACIsHora(JBD_HORA1, .F.) .or. !U_xACIsHora(JBD_HORA2, .F.) .or. JBD_HORA1 <= JBD_HORA2', 'Horário inicial maior que o horário final.' } )
	aAdd( aObrig, { 'JBC_TURNO == Left( Posicione( "SX5", 1, xFilial("SX5")+"F5"+JBC_TURNO, "X5_CHAVE" ), 3 )', 'Turno não cadastrado na sub-tabela F5 da tabela SX5.' } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena o arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nDrv <> 3
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB128", cIDX, "JBC_CODIGO+JBD_HORA1+JBD_HORA2" ) } )
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica chaves unicas e consistencias pre-definidas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB128", "JBC_CODIGO+JBD_HORA1+JBD_HORA2", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk, lOk := U_xAC128SP( @lEnd, cLogFile, aTables[1,4] ) .and. lOk }, 'Validação do Arquivo' )
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
		Processa( { |lEnd| lOk := xAC12800Grv( @lEnd, aTables[1,4] ) }, 'Gravação em andamento' )
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Processo de gravação interrompido pelo usuário. Será necessário reiniciar o processo de importação.' )
			Aviso( 'Operação Cancelada!', 'O processo de gravação foi interrompido pelo usuário. Será necessário reiniciar o processo de importação.', {'Ok'} )
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Gravação realizada com sucesso.' )
			Aviso( 'Sucesso!', 'Importação realizada com sucesso.', {'Ok'} )
		endif
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Elimina os arquivos de trabalho criados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	for i := 1 to len( aTables )
		( aTables[i,1] )->( dbCloseArea() )
		if nDrv # 3
			FErase( aTables[i][2]+GetDBExtension() )
		endif	
	next i
	
	if nDrv # 3
		FErase( cIDX + OrdBagExt() )
	endif	

endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12800GrvºAutor  ³Rafael Rodrigues   º Data ³  17/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados na base do AP6.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12800                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC12800Grv( lEnd, nRecs )
Local cFilJBC	:= xFilial("JBC")	// Criada para ganhar performance
Local cFilJBD	:= xFilial("JBD")	// Criada para ganhar performance
Local cChave	:= ""
Local i			:= 0
Local nItem		:= 0
Local lSeek

ProcRegua( nRecs )

TRB128->( dbGoTop() )

JBC->( dbSetOrder(1) )
JBD->( dbSetOrder(2) )

while TRB128->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	
	if cChave <> TRB128->JBC_CODIGO
		lSeek := JBC->( dbSeek( cFilJBC+TRB128->JBC_CODIGO ) )
		if lOver .or. !lSeek
			begin transaction
		
			RecLock( "JBC", !lSeek )
			JBC->JBC_FILIAL	:= cFilJBC
			JBC->JBC_CODIGO	:= TRB128->JBC_CODIGO
			JBC->JBC_DESC	:= TRB128->JBC_DESC
			JBC->JBC_TURNO	:= TRB128->JBC_TURNO
			JBC->( msUnlock() )
			
			end transaction
		endif
		cChave := TRB128->JBC_CODIGO
		nItem  := 0
	endif

	lSeek := JBD->( dbSeek( cFilJBD+TRB128->JBC_CODIGO+TRB128->JBD_HORA1+TRB128->JBD_HORA2 ) )
	if lOver .or. !lSeek
		begin transaction
		
		RecLock( "JBD", !lSeek )
		JBD->JBD_FILIAL	:= cFilJBD
		JBD->JBD_CODIGO	:= TRB128->JBC_CODIGO
		JBD->JBD_TURNO	:= TRB128->JBC_TURNO
		JBD->JBD_ITEM	:= StrZero( ++nItem, 2 )
		JBD->JBD_HORA1	:= TRB128->JBD_HORA1
		JBD->JBD_HORA2	:= TRB128->JBD_HORA2
		JBD->( msUnlock() )
		
		end transaction
	endif
	
	TRB128->( dbSkip() )
end

Return !lEnd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC128SP  ºAutor  ³Rafael Rodrigues    º Data ³  17/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica sobreposicao de horarios.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12800                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC128SP( lEnd, cLogFile, nRecs )
Local lRet		:= .T.
Local cChave
Local cHora

TRB128->( dbGoTop() )

ProcRegua( nRecs )

while TRB128->( !eof() ) .and. !lEnd
	cChave	:= TRB128->JBC_CODIGO
	aAvas	:= {}
	cHora	:= ""
	
	while cChave == TRB128->JBC_CODIGO .and. TRB128->( !eof() ) .and. !lEnd
		IncProc( 'Verificando sobreposição de horários...' )

		if TRB128->JBD_HORA1 < cHora .And. ! Empty( cHora )
			AcaLog( cLogFile, '  Inconsistência no horário '+TRB128->JBC_CODIGO+': O hora inicial '+TRB128->JBD_HORA1+' conflita com o hora final ' + cHora + ' do item anterior.' )
		endif
		
		cHora := TRB128->JBD_HORA2
		TRB128->( dbSkip() )
	end
end

lRet := lRet .and. !lEnd

Return lRet