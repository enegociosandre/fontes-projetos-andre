#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC14500  ºAutor  ³Rafael Rodrigues    º Data ³  17/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa as equivalencias de disciplinas                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Importacao de Bases, GE.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xAC14500()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cNameFile := 'AC14500'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local nRecs		:= 0

Private lOver	:= .T.

aAdd( aStru, { "JC8_DISC1" , "C", 015, 0 } )
aAdd( aStru, { "JC8_DISC2" , "C", 015, 0 } )
aAdd( aStru, { "JC8_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JC8_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JC8_TIPO"  , "C", 001, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Disciplinas Equivalentes', 'AC14500', aClone( aStru ), 'TRB145', .F., 'JC8_DISC1, JC8_DISC2, JC8_CURSO, JC8_VERSAO' } )

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
		TRB145->( dbGoBottom() )
		if Empty( TRB145->JC8_DISC1 )
			RecLock( "TRB145", .F. )
			TRB145->( dbDelete() )
			TRB145->( msUnlock() )
		endif
	endif
		
	aObrig := {}
	aAdd( aObrig, { '!Empty(JC8_DISC1)', 'Disciplina 1 não informada.' } )
	aAdd( aObrig, { 'JC8_DISC1 == Posicione("JAE", 1, xFilial("JAE")+JC8_DISC1, "JAE_CODIGO")', 'Disciplina 1 não existe na tabela JAE.' } )
	aAdd( aObrig, { '!Empty(JC8_DISC2)', 'Disciplina 2 não informada.' } )
	aAdd( aObrig, { 'JC8_DISC2 == Posicione("JAE", 1, xFilial("JAE")+JC8_DISC2, "JAE_CODIGO")', 'Disciplina 2 não existe na tabela JAE.' } )
	aAdd( aObrig, { 'JC8_DISC1 <> JC8_DISC2', 'Disciplinas 1 e 2 não podem ser a mesma.' } )
	aAdd( aObrig, { 'Empty(JC8_CURSO) .or. JC8_CURSO == Posicione("JAF", 1, xFilial("JAF")+JC8_CURSO, "JAF_COD")', 'Curso informado não existe na tabela JAF.' } )
	aAdd( aObrig, { 'Empty(JC8_VERSAO) == Empty(JC8_CURSO)', 'A versão deve ser informada quando o curso for informado.' } )
	aAdd( aObrig, { 'Empty(JC8_VERSAO) .or. JC8_VERSAO == Posicione("JAF", 1, xFilial("JAF")+JC8_CURSO+JC8_VERSAO, "JAF_VERSAO")', 'Versão informada não existe para o curso informado.' } )
	aAdd( aObrig, { 'JC8_TIPO$"123"', 'Tipo de Equivalência deve ser 1, 2 ou 3.' } )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ordena os arquivos de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nDrv # 3
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB145", cIDX, "JC8_DISC1+JC8_DISC2+JC8_CURSO+JC8_VERSAO" ) } )	
	endif	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica chaves unicas e consistencias pre-definidas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando validação do arquivo "'+aFiles[1,1]+'".' )
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB145", "JC8_DISC1+JC8_DISC2+JC8_CURSO+JC8_VERSAO", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Validando '+aFiles[1,1] )
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da validação do arquivo "'+aFiles[1,1]+'".' )
	
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsistências. Impossível prosseguir.' )
		if Aviso( 'Impossível Prosseguir!', 'Foram detectadas inconsistências. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else

		nRecs := TRB145->( RecCount() )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza a gravacao dos dados nas tabelas do sistema³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( { |lEnd| lOk := xAC14500Grv( @lEnd, aTables[1,4] ) }, 'Gravação em andamento' )
		
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
	TRB145->( dbCloseArea() )
	if nDrv # 3
		FErase( cIDX + OrdBagExt() )
	endif

endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAC14500GrvºAutor  ³Rafael Rodrigues   º Data ³  17/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a gravacao dos dados na base.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³xAC14500                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xAC14500Grv( lEnd, nRecs )
Local cFilJC8	:= xFilial("JC8")	// Criada para ganhar performance
Local i			:= 0
Local lSeek

ProcRegua( nRecs )

if Select( "TRB145" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB145->( dbGoTop() )

JC8->( dbSetOrder(1) )

while TRB145->( !eof() ) .and. !lEnd

	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	
	lSeek := JC8->( dbSeek( cFilJC8+TRB145->JC8_DISC1+TRB145->JC8_DISC2+TRB145->JC8_CURSO+TRB145->JC8_VERSAO ) )
	if lOver .or. !lSeek
		begin transaction
	
		RecLock( "JC8", !lSeek )
		
		JC8->JC8_FILIAL	:= cFilJC8
		JC8->JC8_DISC1	:= TRB145->JC8_DISC1
		JC8->JC8_DISC2	:= TRB145->JC8_DISC2
		JC8->JC8_CURSO	:= TRB145->JC8_CURSO
		JC8->JC8_VERSAO	:= TRB145->JC8_VERSAO
		JC8->JC8_TIPO	:= TRB145->JC8_TIPO
		JC8->( msUnlock() )
	
		end transaction
	endif
	
	TRB145->( dbSkip() )	
end

Return !lEnd