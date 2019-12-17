#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12400  ºAutor  ³Rafael Rodrigues    º Data ³  17/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa o cadastro de Turmas (Cursos Vigentes x Salas)      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC12400( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC12400'
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

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JBO_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBO_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBO_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JBO_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JBO_CODLOC", "C", 006, 0 } )
aAdd( aStru, { "JBO_CODPRE", "C", 006, 0 } )
aAdd( aStru, { "JBO_ANDAR" , "C", 003, 0 } )
aAdd( aStru, { "JBO_CODSAL", "C", 006, 0 } )
aAdd( aStru, { "JBO_LUGAR" , "N", 004, 0 } )
aAdd( aStru, { "JBO_OCUPAD", "N", 004, 0 } )
aAdd( aStru, { "JBO_LIVRE" , "N", 004, 0 } )
aAdd( aStru, { "JBO_QTDRES", "N", 004, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Turmas (Cursos Vigentes x Salas)', 'AC12400', aClone( aStru ), 'TRB124', .T., 'JBO_CODCUR, JBO_PERLET, JBO_HABILI, JBO_TURMA', {|| "JBO_CODCUR in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JBO_CODCUR and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

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
		TRB124->( dbGoBottom() )
		if Empty( TRB124->JBO_CODCUR )
			RecLock( "TRB124", .F. )
			TRB124->( dbDelete() )
			TRB124->( msUnlock() )
		endif
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³prepara as consistencias a serem feitas no arquivo temporario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd( aObrig, { '!Empty(JBO_CODCUR) ', 'Código do curso vigente não informado.' } )
	aAdd( aObrig, { '!Empty(JBO_PERLET) ', 'Período letivo não informado.' } )
	aAdd( aObrig, { '!Empty(JBO_TURMA)  ', 'Turma não informada.' } )
	aAdd( aObrig, { '!Empty(JBO_CODLOC) ', 'Código do local não informado.' } )
	aAdd( aObrig, { '!Empty(JBO_CODPRE) ', 'Código do prédio não informado.' } )
	aAdd( aObrig, { '!Empty(JBO_ANDAR)  ', 'Andar não informado.' } )
	aAdd( aObrig, { '!Empty(JBO_CODSAL) ', 'Código da sala não informado.' } )
	aAdd( aObrig, { '!Empty(JBO_LUGAR)  ', 'Capacidade da sala não informada.' } )
	aAdd( aObrig, { 'JBO_OCUPAD + JBO_LIVRE + JBO_QTDRES == JBO_LUGAR', 'Total de lugares ocupados, livres e reservados não coincide com a capacidade da sala.' } )
	aAdd( aObrig, { 'JBO_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JBO_CODCUR+JBO_PERLET+JBO_HABILI, "JAR_PERLET" )', 'Período letivo não cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JBO_CODSAL == Posicione( "JA5", 1, xFilial("JA5")+JBO_CODLOC+JBO_CODPRE+JBO_ANDAR+JBO_CODSAL, "JA5_CODSAL" )', 'Andar/Sala não cadastrados na tabela JA5.' } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena o arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nDrv <> 3
		if nOpc == 0
			MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB124", cIDX, "JBO_CODCUR+JBO_PERLET+JBO_HABILI+JBO_TURMA" ) } )
		else
			Eval( {|| IndRegua( "TRB124", cIDX, "JBO_CODCUR+JBO_PERLET+JBO_HABILI+JBO_TURMA" ) } )
		endif
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica chaves unicas e consistencias pre-definidas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )
	if nOpc == 0
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB124", "JBO_CODCUR+JBO_PERLET+JBO_HABILI+JBO_TURMA", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Validação do Arquivo' )
	else
		lOk := U_xACChkInt( "TRB124", "JBO_CODCUR+JBO_PERLET+JBO_HABILI+JBO_TURMA", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk
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
			Processa( { |lEnd| lOk := xAC12400Grv( @lEnd, aTables[1,4] ) }, 'Gravação em andamento' )
		else
			lOk := xAC12400Grv( @lEnd, aTables[1,4] )
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
	( aTables[i][1] )->( dbCloseArea() )
	FErase( aTables[i][2]+GetDBExtension() )
next i
FErase( cIDX + OrdBagExt() )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC12400GrvºAutor  ³Rafael Rodrigues   º Data ³  17/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados na base do AP6.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC12400                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC12400Grv( lEnd, nRecs )
Local cFilJBN	:= xFilial("JBN")	// Criada para ganhar performance
Local cFilJBO	:= xFilial("JBO")	// Criada para ganhar performance
Local cChave	:= ""
Local i			:= 0
Local lSeek

if nOpc == 0
	ProcRegua( nRecs )
endif

TRB124->( dbGoTop() )

JBN->( dbSetOrder(1) )
JBO->( dbSetOrder(1) )

while TRB124->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif

	if cChave <> TRB124->JBO_CODCUR+TRB124->JBO_PERLET+TRB124->JBO_HABILI
		cChave := TRB124->JBO_CODCUR+TRB124->JBO_PERLET+TRB124->JBO_HABILI
		
		begin transaction
		
		lSeek := JBN->( dbSeek( cFilJBN+TRB124->JBO_CODCUR+TRB124->JBO_PERLET+TRB124->JBO_HABILI ) )
		if lOver .or. !lSeek
			RecLock( "JBN", !lSeek )
			JBN->JBN_FILIAL	:= cFilJBN
			JBN->JBN_CODCUR := TRB124->JBO_CODCUR
			JBN->JBN_PERLET	:= TRB124->JBO_PERLET
			JBN->JBN_HABILI	:= TRB124->JBO_HABILI
			JBN->( msUnlock() )
		endif
		
		end transaction

	endif
	
	begin transaction
	
	lSeek := JBO->( dbSeek( cFilJBO+TRB124->JBO_CODCUR+TRB124->JBO_PERLET+TRB124->JBO_HABILI+TRB124->JBO_TURMA ) )
	if lOver .or. !lSeek
		RecLock( "JBO", !lSeek )
		JBO->JBO_FILIAL	:= cFilJBO
		JBO->JBO_CODCUR	:= TRB124->JBO_CODCUR
		JBO->JBO_PERLET	:= TRB124->JBO_PERLET
		JBO->JBO_HABILI	:= TRB124->JBO_HABILI
		JBO->JBO_TURMA	:= TRB124->JBO_TURMA
		JBO->JBO_CODLOC	:= TRB124->JBO_CODLOC
		JBO->JBO_CODPRE	:= TRB124->JBO_CODPRE
		JBO->JBO_ANDAR	:= TRB124->JBO_ANDAR
		JBO->JBO_CODSAL	:= TRB124->JBO_CODSAL
		JBO->JBO_LUGAR	:= TRB124->JBO_LUGAR
		JBO->JBO_OCUPAD	:= TRB124->JBO_OCUPAD
		JBO->JBO_LIVRE	:= TRB124->JBO_LIVRE
		JBO->JBO_QTDRES	:= TRB124->JBO_QTDRES
		JBO->( msUnlock() )
	endif
	
	end transaction

	TRB124->( dbSkip() )
end

Return !lEnd