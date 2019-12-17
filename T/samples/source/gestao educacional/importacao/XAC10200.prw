#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC10200  บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta o cadastro de Locais + Predios + Salas.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณImportacao de Bases, GE.                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC10200()
Private lRobo	:= .T.
Private lOver	:= .T.

aFiles := U_xAC102GA()

Return
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXAC10200  บAutor  ณMicrosiga           บ Data ณ  12/07/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC132Do( aFiles, lBlind )
Local aStru		:= {}
Local aTables	:= {}
Local cNameFile := 'AC10200'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local nErro		:= 0
Local i

Default lBlind := .F.

if Emtpy( aFiles )
	// Gera os arrays necessแrios.
	lRobo := .F.
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExecuta a janela para selecao de arquivos e importacao dos temporariosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver, .F., cPerg )
endif

if Empty( aTables )	//Nenhum arquivo importado.
	AcaLog( cLogFile, '  Nenhum arquivo p๔de ser importado para este processo.' )
	nErro := 1	// 	Aviso( 'Problema', 'Nenhum arquivo p๔de ser importado para este processo.', {'Ok'} )
else
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณantes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registroณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nDrv := aScan( aDriver, aTables[1, 3] )

	if nDrv <> 3
		TRB->( dbGoBottom() )
		if Empty( TRB->JA3_CODLOC )
			RecLock( "TRB", .F. )
			TRB->( dbDelete() )
			TRB->( msUnlock() )
		endif
	endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณprepara as consistencias a serem feitas no arquivo temporarioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd( aObrig, { '!Empty(JA3_CODLOC) '						, 'C๓digo de Local/Unidade nใo informado.' } )
	aAdd( aObrig, { '!Empty(JA3_DESLOC) '						, 'Descri็ใo do Local/Unidade nใo informada.' } )
	aAdd( aObrig, { '!Empty(JA3_TIPO) .and. JA3_TIPO$"12"  '	, 'Tipo invแlido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Empty(JA3_CGC) .or. U_xACChkCGC(JA3_CGC)'	, 'CNPJ invแlido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Empty(JA3_CEP) .or. Posicione("JC2",1,xFilial("JC2")+JA3_CEP,"JC2_CEP") == JA3_CEP'	, 'CEP invแlido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Empty(JA3_EST) .or. Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA3_EST,"X5_CHAVE"),2) == JA3_EST'	, 'Estado invแlido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA4_CODPRE)'	, 'C๓digo do Pr้dio nใo informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA4_DESPRE)'	, 'Descri็ใo do Pr้dio nใo informada.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. JA4_TERREO$"12"'		, '"Considera Andar Terreo" deve ser 1 (Sim) ou 2 (Nใo).' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Empty(JA4_CEP) .or. Posicione("JC2",1,xFilial("JC2")+JA4_CEP,"JC2_CEP") == JA4_CEP'	, 'CEP do pr้dio invแlido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Empty(JA4_EST) .or. Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA4_EST,"X5_CHAVE"),2) == JA4_EST'	, 'Estado do pr้dio invแlido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. ( Val( JA5_ANDAR ) <= ( JA4_ANDINI + JA4_ANDAR ) .and. Val( JA5_ANDAR ) >= JA4_ANDINI )'	, 'Andar da sala invแlido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. JA5_ANDAR == StrZero( Val( JA5_ANDAR ), Len( JA5_ANDAR ) ) '	, 'Andar da sala deve ser informado com zeros เ esquerda.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA5_CODSAL)'	, 'C๓digo da sala nใo informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA5_DESCSA)'	, 'Descri็ใo da sala nใo informada.' } )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณordena o arquivo de trabalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if nDrv <> 3
		if !lBlind
			MsgRun( 'Ordenando arquivo...',, {|| TRB->( IndRegua( "TRB", cIDX, "JA3_CODLOC+JA4_CODPRE+JA5_ANDAR+JA5_CODSAL" ) ) } )
		else
			TRB->( IndRegua( "TRB", cIDX, "JA3_CODLOC+JA4_CODPRE+JA5_ANDAR+JA5_CODSAL" ) )
		endif
	endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณverifica chaves unicas e consistencias pre-definidasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Iniciando valida็ใo do arquivo "'+aFiles[1,1]+'".' )
	if !lRobo
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB", "JA3_CODLOC+JA4_CODPRE+JA5_ANDAR+JA5_CODSAL", .F., aObrig, cLogFile, @lEnd ) }, 'Valida็ใo do Arquivo' )
	else
		lOk := U_xACChkInt( "TRB", "JA3_CODLOC+JA4_CODPRE+JA5_ANDAR+JA5_CODSAL", .F., aObrig, cLogFile, @lEnd )
	endif
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Fim da valida็ใo do arquivo "'+aFiles[1,1]+'".' )
	
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsist๊ncias. Impossํvel prosseguir.' )
		if !lRobo
			if Aviso( 'Impossํvel Prosseguir!', 'Foram detectadas inconsist๊ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
				OurSpool( cNameFile )
			endif
		endif
	else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRealiza a gravacao dos dados nas tabelas do sistemaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		if lRobo
			Processa( { |lEnd| ProcRegua( aTables[1,4] ), lOk := xAC10200Grv( @lEnd, aTables[1,4] ) }, 'Grava็ใo em andamento' )
		else
			lOk := xAC10200Grv( @lEnd, aTables[1,4] )
		endif
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Processo de grava็ใo interrompido pelo usuแrio. Serแ necessแrio reiniciar o processo de importa็ใo.' )
			if !lRobo
				Aviso( 'Opera็ใo Cancelada!', 'O processo de grava็ใo foi interrompido pelo usuแrio. Serแ necessแrio reiniciar o processo de importa็ใo.', {'Ok'} )
			endif
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Grava็ใo realizada com sucesso.' )
			if !lRobo
				Aviso( 'Sucesso!', 'Importa็ใo realizada com sucesso.', {'Ok'} )
			endif
		endif
	endif
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณElimina os arquivos de trabalho criadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
for i := 1 to len( aTables )
	(aTables[i][1])->( dbCloseArea() )
	if aTables[i][3] == aDriver[1]
		FErase( aTables[i][2]+GetDBExtension() )
	endif
next i

if nDrv <> 3
	FErase( cIDX + OrdBagExt() )
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC10200GrvบAutor  ณRafael Rodrigues   บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a gravacao dos dados na base do AP6.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC10200                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC10200Grv( lEnd, nRecs )
Local cLocal	:= ""
Local cPredio	:= ""
Local cFilJA3	:= xFilial("JA3")	// Criada para ganhar performance
Local cFilJA4	:= xFilial("JA4")	// Criada para ganhar performance
Local cFilJA5	:= xFilial("JA5")	// Criada para ganhar performance
Local i			:= 0
Local lSeek

TRB->( dbGoTop() )

JA3->( dbSetOrder(1) )
JA4->( dbSetOrder(1) )
JA5->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	if !lRobo
		IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif
	
	begin transaction
	
	if cLocal <> TRB->JA3_CODLOC
		lSeek := JA3->( dbSeek( cFilJA3+TRB->JA3_CODLOC ) )
		if lOver .or. !lSeek
			RecLock( "JA3", !lSeek )
			JA3->JA3_FILIAL	:= cFilJA3
			JA3->JA3_CODLOC	:= TRB->JA3_CODLOC
			JA3->JA3_DESLOC	:= TRB->JA3_DESLOC
			JA3->JA3_CGC	:= TRB->JA3_CGC
			JA3->JA3_CEP	:= TRB->JA3_CEP
			JA3->JA3_END	:= TRB->JA3_END
			JA3->JA3_NUMEND	:= TRB->JA3_NUMEND
			JA3->JA3_COMPLE	:= TRB->JA3_COMPLE
			JA3->JA3_BAIRRO	:= TRB->JA3_BAIRRO
			JA3->JA3_CIDADE	:= TRB->JA3_CIDADE
			JA3->JA3_EST	:= TRB->JA3_EST
			JA3->JA3_FONE	:= TRB->JA3_FONE
			JA3->JA3_TIPO	:= TRB->JA3_TIPO
			JA3->JA3_LOGO	:= TRB->JA3_LOGO
			JA3->JA3_MAPA	:= TRB->JA3_MAPA
			JA3->( msUnlock() )
		endif
		cLocal := TRB->JA3_CODLOC
	endif
	
	if TRB->JA3_TIPO == '1'
		if cLocal <> TRB->JA3_CODLOC .or. cPredio <> TRB->JA4_CODPRE
			lSeek := JA4->( dbSeek( cFilJA4+TRB->JA3_CODLOC+TRB->JA4_CODPRE ) )
			if lOver .or. !lSeek
				RecLock( "JA4", !lSeek )
				JA4->JA4_FILIAL	:= cFilJA4
				JA4->JA4_CODLOC	:= TRB->JA3_CODLOC
				JA4->JA4_CODPRE	:= TRB->JA4_CODPRE
				JA4->JA4_DESPRE	:= TRB->JA4_DESPRE
				JA4->JA4_ANDAR	:= TRB->JA4_ANDAR
				JA4->JA4_TERREO	:= TRB->JA4_TERREO
				JA4->JA4_ANDINI	:= TRB->JA4_ANDINI
				JA4->( msUnlock() )
			endif
			cPredio	:= TRB->JA4_CODPRE
		endif
		
		lSeek := JA5->( dbSeek( cFilJA5+TRB->JA3_CODLOC+TRB->JA4_CODPRE+TRB->JA5_ANDAR+TRB->JA5_CODSAL ) )
		if lOver .or. !lSeek
			RecLock( "JA5", !lSeek )
			JA5->JA5_FILIAL	:= cFilJA5
			JA5->JA5_CODLOC	:= TRB->JA3_CODLOC
			JA5->JA5_CODPRE	:= TRB->JA4_CODPRE
			JA5->JA5_ANDAR	:= TRB->JA5_ANDAR
			JA5->JA5_CODSAL	:= TRB->JA5_CODSAL
			JA5->JA5_DESCSA	:= TRB->JA5_DESCSA
			JA5->JA5_LUGAR	:= TRB->JA5_LUGAR
			JA5->( msUnlock() )
		endif
	endif
	
	end transaction

	TRB->( dbSkip() )
end

Return !lEnd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXAC102GA  บAutor  ณRafael Rodrigues    บ Data ณ  11/30/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera os arrays utilizados na importacao                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxac10200 e xacrobot                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC102GA()
Local aStru  := {}
Local aFiles := {}

aAdd( aStru, { "JA3_CODLOC", "C", 006, 0 } )
aAdd( aStru, { "JA3_DESLOC", "C", 030, 0 } )
aAdd( aStru, { "JA3_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JA3_CGC"   , "C", 014, 0 } )
aAdd( aStru, { "JA3_CEP"   , "C", 008, 0 } )
aAdd( aStru, { "JA3_END"   , "C", 040, 0 } )
aAdd( aStru, { "JA3_NUMEND", "C", 005, 0 } )
aAdd( aStru, { "JA3_COMPLE", "C", 020, 0 } )
aAdd( aStru, { "JA3_BAIRRO", "C", 020, 0 } )
aAdd( aStru, { "JA3_CIDADE", "C", 020, 0 } )
aAdd( aStru, { "JA3_EST"   , "C", 002, 0 } )
aAdd( aStru, { "JA3_FONE"  , "C", 015, 0 } )
aAdd( aStru, { "JA3_LOGO"  , "C", 030, 0 } )
aAdd( aStru, { "JA3_MAPA"  , "C", 030, 0 } )
aAdd( aStru, { "JA4_CODPRE", "C", 006, 0 } )
aAdd( aStru, { "JA4_DESPRE", "C", 030, 0 } )
aAdd( aStru, { "JA4_ANDAR" , "N", 003, 0 } )
aAdd( aStru, { "JA4_TERREO", "C", 001, 0 } )
aAdd( aStru, { "JA4_ANDINI", "N", 003, 0 } )
aAdd( aStru, { "JA4_CEP"   , "C", 008, 0 } )
aAdd( aStru, { "JA4_END"   , "C", 040, 0 } )
aAdd( aStru, { "JA4_NUMEND", "C", 005, 0 } )
aAdd( aStru, { "JA4_COMPLE", "C", 020, 0 } )
aAdd( aStru, { "JA4_BAIRRO", "C", 020, 0 } )
aAdd( aStru, { "JA4_CIDADE", "C", 020, 0 } )
aAdd( aStru, { "JA4_EST"   , "C", 002, 0 } )
aAdd( aStru, { "JA4_OBSERV", "C", 080, 0 } )
aAdd( aStru, { "JA5_ANDAR" , "C", 003, 0 } )
aAdd( aStru, { "JA5_CODSAL", "C", 006, 0 } )
aAdd( aStru, { "JA5_DESCSA", "C", 030, 0 } )
aAdd( aStru, { "JA5_LUGAR" , "N", 004, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Cadastro de Locais', 'AC10200', aClone( aStru ), 'TRB', .T., "JA3_CODLOC, JA4_CODPRE, JA5_ANDAR, JA5_CODSAL" } )

Return aFiles