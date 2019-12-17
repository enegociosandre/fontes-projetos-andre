#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC14400  ºAutor  ³Rafael Rodrigues    º Data ³  17/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa os Aproveitamentos de Estudos dos Alunos            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC14400()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cNameFile := 'AC14400'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local nRecs		:= 0
Local nDrv		:= 0

Private lOver	:= .T.

aAdd( aStru, { "JCO_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JCO_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JCO_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JCO_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JCO_DISCIP", "C", 015, 0 } )
aAdd( aStru, { "JCO_MEDFIM", "N", 005, 2 } )
aAdd( aStru, { "JCO_MEDCON", "C", 004, 0 } )
aAdd( aStru, { "JCO_CODINS", "C", 006, 0 } )
aAdd( aStru, { "JCO_ANOINS", "C", 020, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Aproveitamentos de Estudos', 'AC14400', aClone( aStru ), 'TRB144', .F., 'JCO_NUMRA, JCO_CODCUR, JCO_PERLET, JCO_HABILI, JCO_DISCIP' } )

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
		TRB144->( dbGoBottom() )
		if Empty( TRB144->JCO_NUMRA )
			RecLock( "TRB144", .F. )
			TRB144->( dbDelete() )
			TRB144->( msUnlock() )
		endif
	endif
	
	aObrig := {}
	aAdd( aObrig, { 'JCO_NUMRA == Posicione("JA2", 1, xFilial("JA2")+JCO_NUMRA, "JA2_NUMRA")', 'Aluno não cadastrado na tabela JA2.' } )
	aAdd( aObrig, { 'JCO_CODCUR == Posicione("JBE", 1, xFilial("JBE")+JCO_NUMRA+JCO_CODCUR, "JBE_CODCUR")', 'Não existe matrócula do aluno para o curso especificado.' } )
	aAdd( aObrig, { 'JCO_PERLET == Posicione("JAR", 1, xFilial("JAR")+JCO_CODCUR+JCO_PERLET+JCO_HABILI, "JAR_PERLET")', 'Período letivo não existe no curso especificado.' } )
	aAdd( aObrig, { 'JCO_DISCIP == Posicione("JAS", 2, xFilial("JAS")+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP, "JAS_CODDIS")', 'Disciplina não cadastrada na grade curricular do período letivo/curso especificado.' } )
	aAdd( aObrig, { 'JCO_MEDFIM <= 10 '	, 'Nota não pode ser maior que 10.' } )
	aAdd( aObrig, { 'JCO_CODINS == Posicione("JCL",1,xFilial("JCL")+JCO_CODINS,"JCL_CODIGO")'	, 'Instituição não cadastrada na tabela JCL.' } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena os arquivos de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nDrv # 3
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB144", cIDX, "JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP" ) } )
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica chaves unicas e consistencias pre-definidas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB144", "JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Validando '+aFiles[1,1] )
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[1,1]+'".' )	
	
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsistências. Impossível prosseguir.' )
		if Aviso( 'Impossível Prosseguir!', 'Foram detectadas inconsistências. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a gravacao dos dados nas tabelas do sistema³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( { |lEnd| lOk := xAC14400Grv( @lEnd, aFiles[1,1], aTables[1,4] ) }, 'Gravação em andamento' )
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Processo de gravação interrompido pelo usuário. Será necessário reiniciar o processo de importação.' )
			Aviso( 'Operação Cancelada!', 'O processo de gravação foi interrompido pelo usuário. Será necessário reiniciar o processo de importação.', {'Ok'} )
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Gravação realizada com sucesso.' )
			Aviso( 'Sucesso!', 'Importação realizada com sucesso.', {'Ok'} )
		endif
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Elimina os arquivos de trabalho criados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TRB144->( dbCloseArea() )
	if nDrv # 3
		FErase( cIDX + OrdBagExt() )
	endif

endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC14400GrvºAutor  ³Rafael Rodrigues   º Data ³  17/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados na base.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC14400                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC14400Grv( lEnd, cTitulo, nRecs )
Local cFilJCO	:= xFilial("JCO")	// Criada para ganhar performance
Local i			:= 0
Local lSeek

ProcRegua( nRecs )

if Select( "TRB144" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB144->( dbGoTop() )

JCO->( dbSetOrder(1) )

while TRB144->( !eof() ) .and. !lEnd

	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	
	lSeek := JCO->( dbSeek( cFilJCO+TRB144->(JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP ) ) )
	if lOver .or. !lSeek
		begin transaction
	
		RecLock( "JCO", !lSeek )
		
		JCO->JCO_FILIAL	:= cFilJCO
		JCO->JCO_NUMRA	:= TRB144->JCO_NUMRA
		JCO->JCO_CODCUR	:= TRB144->JCO_CODCUR
		JCO->JCO_PERLET	:= TRB144->JCO_PERLET
		JCO->JCO_HABILI	:= TRB144->JCO_HABILI
		JCO->JCO_DISCIP	:= TRB144->JCO_DISCIP
		JCO->JCO_MEDFIM	:= TRB144->JCO_MEDFIM
		JCO->JCO_MEDCON	:= TRB144->JCO_MEDCON
		JCO->JCO_CODINS	:= TRB144->JCO_CODINS
		JCO->JCO_ANOINS	:= TRB144->JCO_ANOINS
	
		JCO->( msUnlock() )
	
		end transaction
	endif
	
	TRB144->( dbSkip() )	
end

Return !lEnd