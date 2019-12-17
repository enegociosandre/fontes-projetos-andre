#include "protheus.ch"
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC13700  บAutor  ณRafael Rodrigues    บ Data ณ  26/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta o cadastro de Faltas x Alunos                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณImportacao de Bases, GE.                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC13700( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC13700'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local nDrv		:= 0
Local lOracle	:= "ORACLE"$Upper(TCGetDB())
Local cProcName
Local nThreads := 10
Local nCommit	:= 500	// A cada quantas gravacoes deve efetuar commit no banco

Default nOpcX	:= 0
Default aTables := {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JCH_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JCH_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JCH_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JCH_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JCH_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JCH_DISCIP", "C", 015, 0 } )
aAdd( aStru, { "JCH_DATA"  , "D", 008, 0 } )
aAdd( aStru, { "JCH_QTD"   , "N", 003, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Faltas x Alunos', 'AC13700', aClone( aStru ), 'TRB137', .T., 'JCH_CODCUR, JCH_PERLET, JCH_HABILI, JCH_TURMA, JCH_DISCIP, JCH_DATA, JCH_NUMRA', {|| "JCH_CODCUR in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JCH_CODCUR and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a janela para selecao de arquivos e importacao dos temporariosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if nOpc == 2	// So processamento
	if File( "Abort.log" )
		AcaLog( cLogFile, "  O processo de faltas nใo serแ iniciado em decorr๊ncia do cancelamento do processo de matrํculas." )
		Return
	endif
		
	U_xOpen( aTables, aFiles, aDriver, .T. )
else
	aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver, .T., nOpc == 1 )
	if nOpc == 1
		Return aTables
	endif
endif

if Empty( aTables )
	AcaLog( cLogFile, '  Nenhum arquivo p๔de ser importado para este processo.' )
	if nOpc == 0
		Aviso( 'Problema', 'Nenhum arquivo p๔de ser importado para este processo.', {'Ok'} )
	endif
else
	                
	nDrv := aScan( aDriver, aTables[1,3] )	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณverifica chaves unicasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida็ใo do arquivo "'+aFiles[1,1]+'".' )	
	if nOpc == 0
		Processa( {|lEnd| lOK := xAC137Chk( aTables[1,2], cLogFile, aTables[1,4] ) }, 'Buscando chaves duplicadas' )
	else
		lOK := xAC137Chk( aTables[1,2], cLogFile, aTables[1,4] )
	endif
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida็ใo do arquivo "'+aFiles[1,1]+'".' )	

	if lOk
		if lOracle .and. nDrv == 3	// So utiliza procedure se for Oracle e tabela diretamente no banco
			// Cria as Stored Procedures
			cProcName := CreateSP( aTables[1,2] )
			
			if nOpc == 0
				Processa( {|| lOk := xAC137Wait( cProcName, aTables[1,4], nThreads, cLogFile, nCommit ) } )
            else
				lOk := xAC137Wait( cProcName, aTables[1,4], nThreads, cLogFile, nCommit )
            endif
            
			if !lOk
				AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '! Foram detectadas inconsist๊ncias. A grava็ใo nใo foi completa.' )
				if nOpc == 0 .and. Aviso( 'Problemas!', 'Foram detectadas inconsist๊ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'}, 2 ) == 2
					OurSpool( cNameFile )
				endif
			else
				AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '! Grava็ใo realizada com sucesso.' )
				if nOpc == 0
					Aviso( 'Sucesso!', 'Importa็ใo realizada com sucesso.', {'Ok'} )
				endif
			endif
		else
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณprepara as consistencias a serem feitas no arquivo temporarioณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAdd( aObrig, { 'JCH_NUMRA == Posicione( "JC7", 1, xFilial("JC7")+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+JCH_DISCIP, "JC7_NUMRA" ) .or. JCH_NUMRA == Posicione( "JC7", 8, xFilial("JC7")+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+JCH_DISCIP, "JC7_NUMRA" )', 'Matrํcula do aluno para esta disciplina nใo cadastrada na tabela JC7.' } )
			aAdd( aObrig, { '!Empty(JCH_DATA)   ', 'Data nใo informada.' } )
			aAdd( aObrig, { 'JCH_TURMA  == Posicione( "JBO", 1, xFilial("JBO")+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA, "JBO_TURMA" )', 'Turma nใo cadastrada na tabela JBO.' } )
			aAdd( aObrig, { 'JCH_DISCIP == Posicione( "JAS", 2, xFilial("JAS")+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_DISCIP, "JAS_CODDIS" )', 'Disciplina nใo cadastrada na tabela JAS.' } )
			aAdd( aObrig, { '!Empty(JCH_QTD) ', 'Quantidade nใo informada.' } )
			aAdd( aObrig, { 'Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET+JCH_HABILI, "JAR_APFALT") != "2" .or. JCH_DATA == LastDay(JCH_DATA)', 'Quando o apontamento for mensal, a data deve ser igual ao ๚ltimo dia do m๊s.' } )
			aAdd( aObrig, { 'Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET+JCH_HABILI, "JAR_APFALT") != "3" .or. JCH_DATA == Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET+JCH_HABILI, "JAR_DATA2")', 'Quando o apontamento for por perํodo letivo, a data deve ser igual ao ๚ltimo dia do perํodo letivo.' } )
			
			if nOpc == 0
				Processa( { |lEnd| lOk := xAC137Grv( aTables[1,2], aObrig, cLogFile, @lEnd, aTables[1,4] ) }, 'Grava็ao em andamento' )
			else
				lOk := xAC137Grv( aTables[1,2], aObrig, cLogFile, @lEnd, aTables[1,4] )
			endif
			
			if !lOk
				AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() + '! Foram detectadas inconsist๊ncias. A grava็ใo nใo foi completa.' )
				if nOpc == 0 .and. Aviso( 'Problemas!', 'Foram detectadas inconsist๊ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'}, 2 ) == 2
					OurSpool( cNameFile )
				endif
			else
				AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() + '! Grava็ใo realizada com sucesso.' )
				if nOpc == 0
					Aviso( 'Sucesso!', 'Importa็ใo realizada com sucesso.', {'Ok'} )
				endif
			endif
		endif
	else
		AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() + '! Foram detectadas duplicidades de chave primแria. A grava็ใo nใo foi realizada.' )
		if nOpc == 0 .and. Aviso( 'Problemas!', 'Foram detectadas duplicidades de chave primแria. A grava็ใo nใo foi realizada. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'}, 2 ) == 2
			OurSpool( cNameFile )
		endif
	endif
endif

if Select( "TRB137" ) > 0
	TRB137->( dbCloseArea() )
endif	                            

if len(aTables) # 0 .And. nDrv <> 3
	FErase( cIDX + OrdBagExt() )
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC137Grv  บAutor  ณRafael Rodrigues   บ Data ณ  26/12/02   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a gravacao dos dados na base do AP6.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC13700                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC137Grv( cTable, aObrig, cLogFile, lEnd, nRecs )
Local cFilJCH	:= xFilial("JCH")	// Criada para ganhar performance
Local cFilJCG	:= xFilial("JCG")	// Criada para ganhar performance
Local i			:= 0
Local j			:= 0
Local cChave	:= ""
Local lLinOk	:= .T.
Local lOk		:= .T.
Local lSeek

if nOpc == 0
	ProcRegua( nRecs )
endif

TRB137->( dbGoTop() )

JCG->( dbSetOrder(1) )
JCH->( dbSetOrder(3) )

while TRB137->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( 'Gravando linha '+StrZero( ++i, 8 )+' de '+StrZero( nRecs, 8 )+'...' )
	endif
	
	lLinOk := .T.
	for j := 1 to len( aObrig )
		if TRB137->( !Eval( &("{ || "+aObrig[j, 1]+" }") ) )
			lLinOk := .F.
			AcaLog( cLogFile, '  Inconsist๊ncia no apontamento do curso '+TRB137->JCH_CODCUR+', perํodo '+TRB137->JCH_PERLET+', turma '+TRB137->JCH_TURMA+', disciplina '+TRB137->JCH_DISCIP+', data '+dtoc( TRB137->JCH_DATA )+', aluno '+TRB137->JCH_NUMRA+': '+aObrig[j, 2] )
		endif
	next j

	if !lLinOk
		lOk := .F.
		TRB137->( dbSkip() )
		loop
	endif

	if cChave <> TRB137->(JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP)
		cChave := TRB137->(JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP)

		lSeek := JCG->( dbSeek( cFilJCG+TRB137->(JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP) ) )
		if lOver .or. !lSeek
			begin transaction
	
			RecLock( "JCG", !lSeek )
			JCG->JCG_FILIAL	:= cFilJCG
			JCG->JCG_CODCUR	:= TRB137->JCH_CODCUR
			JCG->JCG_PERLET	:= TRB137->JCH_PERLET
			JCG->JCG_HABILI	:= TRB137->JCH_HABILI
			JCG->JCG_TURMA	:= TRB137->JCH_TURMA
			JCG->JCG_DISCIP	:= TRB137->JCH_DISCIP
			JCG->JCG_TIPO	:= Posicione( "JAR", 1, xFilial("JAR")+TRB137->( JCH_CODCUR+JCH_PERLET+JCH_HABILI ), "JAR_APFALT" )
			JCG->JCG_DATA	:= TRB137->JCH_DATA
			JCG->( msUnlock() )
	
			end transaction
		endif
	endif

	lSeek := JCH->( dbSeek( cFilJCH+TRB137->(JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_HABILI+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP) ) )	
	if lOver .or. !lSeek
		begin transaction
	
		RecLock( "JCH", !lSeek )
		JCH->JCH_FILIAL	:= cFilJCH
		JCH->JCH_NUMRA	:= TRB137->JCH_NUMRA
		JCH->JCH_CODCUR	:= TRB137->JCH_CODCUR
		JCH->JCH_PERLET	:= TRB137->JCH_PERLET
		JCH->JCH_HABILI	:= TRB137->JCH_HABILI
		JCH->JCH_TURMA	:= TRB137->JCH_TURMA
		JCH->JCH_DATA	:= TRB137->JCH_DATA
		JCH->JCH_DISCIP	:= TRB137->JCH_DISCIP
		JCH->JCH_QTD	:= TRB137->JCH_QTD
		JCH->( msUnlock() )
	
		end transaction
	endif
	
	TRB137->( dbSkip() )
end

Return !lEnd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC137Chk บAutor  ณRafael Rodrigues    บ Data ณ 11/Fev/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca duplicidades de chaves no arquivo de importacao       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMigracao de bases                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC137Chk( cTable, cLogFile, nRecs )
Local cQuery
Local lOk := .T.
Local i   := 0

if nOpc == 0
	ProcRegua( nRecs )
endif

cQuery := "select JCH_CODCUR, JCH_PERLET, JCH_HABILI, JCH_TURMA, JCH_DISCIP, JCH_DATA, JCH_NUMRA "
cQuery += "  from "+cTable
cQuery += " group by JCH_CODCUR, JCH_PERLET, JCH_HABILI, JCH_TURMA, JCH_DISCIP, JCH_DATA, JCH_NUMRA "
cQuery += "having count(*) > 1 "
	
cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )
TCSetField( "QRY", "JCH_DATA", "D", 8, 0 )

lOk := lOk .and. QRY->( eof() )
while QRY->( !eof() )
	if nOpc == 0
		IncProc( 'Validando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif
	AcaLog( cLogFile, '  Inconsist๊ncia na tabela. Chave duplicada para o curso '+QRY->JCH_CODCUR+', perํodo '+QRY->JCH_PERLET+', turma '+QRY->JCH_TURMA+', disciplina '+QRY->JCH_DISCIP+', data '+dtoc( QRY->JCH_DATA )+', aluno '+QRY->JCH_NUMRA+'.' )
	QRY->( dbSkip() )
end

QRY->( dbCloseArea() )
Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCreateSP  บAutor  ณRafael Rodrigues    บ Data ณ  11/16/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณStored Procedures desenvolvidas por Emerson Tobar           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMigracao de Dados - GE                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CreateSP( cTabela )
Local cProcName
Local cProced

cProcName := CriaTrab(,.F.)

TCSQLExec( "truncate table IMP_LOG37" )
TCSQLExec( "delete from IMP_STATUS where TIPO = '37'" )

cProced := "create or replace procedure "+cProcName+" "
cProced += Chr(10) + "( "
cProced += Chr(10) + " IN_OVER    in  integer, "
cProced += Chr(10) + " IN_MIN     in  integer, "
cProced += Chr(10) + " IN_MAX     in  integer, "
cProced += Chr(10) + " IN_THRD    in  integer, "
cProced += Chr(10) + " IN_COMMIT  in  integer, "
cProced += Chr(10) + " OUT_TOTAL  out integer, "
cProced += Chr(10) + " OUT_REJECT out integer "
cProced += Chr(10) + ") is "

cProced += Chr(10) + "nLoop   integer; "
cProced += Chr(10) + "nErro1  exception; "
cProced += Chr(10) + "cMsgFix varchar2( 500 ); "
cProced += Chr(10) + "cMsgErr varchar2( 500 ); "
cProced += Chr(10) + "cKeyJCH varchar2( 500 ); "
cProced += Chr(10) + "nRecno  integer; "
cProced += Chr(10) + "cJCH_TIPO "+RetSQLName("JCH")+".JCH_TIPO%Type; "
cProced += Chr(10) + "nCommit integer; "

cProced += Chr(10) + "cursor cur01 is  "
cProced += Chr(10) + "select /*+ FIRST_ROWS */ JCH_NUMRA, JCH_CODCUR, JCH_PERLET, JCH_HABILI, JCH_TURMA, JCH_DISCIP, JCH_DATA, JCH_QTD, R_E_C_N_O_ "
cProced += Chr(10) + "  from "+cTabela
cProced += Chr(10) + " where R_E_C_N_O_ between IN_MIN and IN_MAX; "

cProced += Chr(10) + "begin "
cProced += Chr(10) + "   insert into IMP_STATUS ( TIPO, THRD, MINREC, MAXREC, LASTREC, HORA, RECTRY ) values ( '37', IN_THRD, IN_MIN, IN_MAX, 0, sysdate, 0 ); "
cProced += Chr(10) + "   commit; "
cProced += Chr(10) + "   OUT_TOTAL  := 0; "
cProced += Chr(10) + "   OUT_REJECT := 0; "
cProced += Chr(10) + "   cKeyJCH := ' '; "
cProced += Chr(10) + "   for x in cur01 loop "
cProced += Chr(10) + "   begin "
cProced += Chr(10) + "      OUT_TOTAL := OUT_TOTAL + 1; "
cProced += Chr(10) + "      cMsgFix   := '  Inconsist๊ncia no apontamento do curso ' || x.JCH_CODCUR || ', perํodo ' || x.JCH_PERLET || ', turma ' || x.JCH_TURMA || ', disciplina ' || x.JCH_DISCIP || ', data ' || x.JCH_DATA || ', aluno ' || x.JCH_NUMRA || ': '; "
cProced += Chr(10) + "      cMsgErr   := null; "

//aAdd( aObrig, { 'JCH_NUMRA == Posicione( "JC7", 1, xFilial("JC7")+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_TURMA+JCH_DISCIP, "JC7_NUMRA" )', 'Matrํcula do aluno para esta disciplina nใo cadastrada na tabela JC7.' } )
cProced += Chr(10) + "      select Min(R_E_C_N_O_) into nRecno "
cProced += Chr(10) + "        from "+RetSQLName("JC7")
cProced += Chr(10) + "       where JC7_FILIAL = '"+xFilial("JC7")+"' "
cProced += Chr(10) + "         and JC7_NUMRA  = x.JCH_NUMRA "
cProced += Chr(10) + "         and ( ( JC7_CODCUR = x.JCH_CODCUR "
cProced += Chr(10) + "             and JC7_PERLET = x.JCH_PERLET "
cProced += Chr(10) + "             and JC7_HABILI = x.JCH_HABILI "
cProced += Chr(10) + "             and JC7_TURMA  = x.JCH_TURMA "
cProced += Chr(10) + "             and JC7_OUTCUR = ' ' ) "
cProced += Chr(10) + "            or ( JC7_OUTCUR = x.JCH_CODCUR "
cProced += Chr(10) + "             and JC7_OUTPER = x.JCH_PERLET "
cProced += Chr(10) + "             and JC7_OUTHAB = x.JCH_HABILI "
cProced += Chr(10) + "             and JC7_OUTTUR = x.JCH_TURMA ) ) "
cProced += Chr(10) + "         and JC7_DISCIP = x.JCH_DISCIP "
cProced += Chr(10) + "         and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "      if nRecno is null then "
cProced += Chr(10) + "         cMsgErr := 'Matrํcula do aluno para esta disciplina nใo cadastrada na tabela JC7.'; "
cProced += Chr(10) + "         Grava_Log( '37', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//aAdd( aObrig, { '!Empty(JCH_DATA)   ', 'Data nใo informada.' } )
cProced += Chr(10) + "      if x.JCH_DATA = ' ' then "
cProced += Chr(10) + "         cMsgErr := 'Data nใo informada.'; "
cProced += Chr(10) + "         Grava_Log( '37', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//aAdd( aObrig, { 'JCH_TURMA  == Posicione( "JBO", 1, xFilial("JBO")+JCH_CODCUR+JCH_PERLET+JCH_TURMA, "JBO_TURMA" )', 'Turma nใo cadastrada na tabela JBO.' } )
cProced += Chr(10) + "      select Min(R_E_C_N_O_) into nRecno "
cProced += Chr(10) + "        from "+RetSQLName("JBO")
cProced += Chr(10) + "       where JBO_FILIAL = '"+xFilial("JBO")+"' "
cProced += Chr(10) + "         and JBO_CODCUR = x.JCH_CODCUR "
cProced += Chr(10) + "         and JBO_PERLET = x.JCH_PERLET "
cProced += Chr(10) + "         and JBO_HABILI = x.JCH_HABILI "
cProced += Chr(10) + "         and JBO_TURMA  = x.JCH_TURMA "
cProced += Chr(10) + "         and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "      if nRecno is null then "
cProced += Chr(10) + "         cMsgErr := 'Turma nใo cadastrada na tabela JBO.'; "
cProced += Chr(10) + "         Grava_Log( '37', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//aAdd( aObrig, { 'JCH_DISCIP == Posicione( "JAS", 2, xFilial("JAS")+JCH_CODCUR+JCH_PERLET+JCH_DISCIP, "JAS_CODDIS" )', 'Disciplina nใo cadastrada na tabela JAS.' } )
cProced += Chr(10) + "      select Min(R_E_C_N_O_) into nRecno "
cProced += Chr(10) + "        from "+RetSQLName("JAS")
cProced += Chr(10) + "       where JAS_FILIAL = '"+xFilial("JAS")+"' "
cProced += Chr(10) + "         and JAS_CODCUR = x.JCH_CODCUR "
cProced += Chr(10) + "         and JAS_PERLET = x.JCH_PERLET "
cProced += Chr(10) + "         and JAS_HABILI = x.JCH_HABILI "
cProced += Chr(10) + "         and JAS_CODDIS = x.JCH_DISCIP "
cProced += Chr(10) + "         and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "      if nRecno is null then "
cProced += Chr(10) + "         cMsgErr := 'Disciplina nใo cadastrada na tabela JAS.'; "
cProced += Chr(10) + "         Grava_Log( '37', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//aAdd( aObrig, { '!Empty(JCH_QTD) ', 'Quantidade nใo informada.' } )
cProced += Chr(10) + "      if x.JCH_QTD = 0 then "
cProced += Chr(10) + "         cMsgErr := 'Quantidade nใo informada.'; "
cProced += Chr(10) + "         Grava_Log( '37', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//aAdd( aObrig, { 'Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_APFALT") != "2" .or. JCH_DATA == LastDay(JCH_DATA)', 'Quando o apontamento for mensal, a data deve ser igual ao ๚ltimo dia do m๊s.' } )
cProced += Chr(10) + "      select Min(R_E_C_N_O_) into nRecno "
cProced += Chr(10) + "        from "+RetSQLName("JAR")
cProced += Chr(10) + "       where JAR_FILIAL = '"+xFilial("JAR")+"' "
cProced += Chr(10) + "         and JAR_CODCUR = x.JCH_CODCUR "
cProced += Chr(10) + "         and JAR_PERLET = x.JCH_PERLET "
cProced += Chr(10) + "         and JAR_HABILI = x.JCH_HABILI "
cProced += Chr(10) + "         and JAR_APFALT = '2' "
cProced += Chr(10) + "         and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "      if nRecno is not null then "
cProced += Chr(10) + "         if x.JCH_DATA <> TO_CHAR( LAST_DAY( TO_DATE( x.JCH_DATA, 'YYYYMMDD' ) ), 'YYYYMMDD' ) then "
cProced += Chr(10) + "            cMsgErr := 'Quando o apontamento for mensal, a data deve ser igual ao ๚ltimo dia do m๊s.'; "
cProced += Chr(10) + "            Grava_Log( '37', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "
      
//aAdd( aObrig, { 'Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_APFALT") != "3" .or. JCH_DATA == Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_DATA2")', 'Quando o apontamento for por perํodo letivo, a data deve ser igual ao ๚ltimo dia do perํodo letivo.' } )
cProced += Chr(10) + "      select Min(R_E_C_N_O_) into nRecno "
cProced += Chr(10) + "        from "+RetSQLName("JAR")
cProced += Chr(10) + "       where JAR_FILIAL = '"+xFilial("JAR")+"' "
cProced += Chr(10) + "         and JAR_CODCUR = x.JCH_CODCUR "
cProced += Chr(10) + "         and JAR_PERLET = x.JCH_PERLET "
cProced += Chr(10) + "         and JAR_HABILI = x.JCH_HABILI "
cProced += Chr(10) + "         and JAR_APFALT = '3' "
cProced += Chr(10) + "         and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "      if nRecno is not null then "
cProced += Chr(10) + "         select Min(R_E_C_N_O_) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("JAR")
cProced += Chr(10) + "          where JAR_FILIAL = '"+xFilial("JAR")+"' "
cProced += Chr(10) + "            and JAR_CODCUR = x.JCH_CODCUR "
cProced += Chr(10) + "            and JAR_PERLET = x.JCH_PERLET "
cProced += Chr(10) + "            and JAR_HABILI = x.JCH_HABILI "
cProced += Chr(10) + "            and JAR_DATA2  = x.JCH_DATA "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            cMsgErr := 'Quando o apontamento for por perํodo letivo, a data deve ser igual ao ๚ltimo dia do perํodo letivo.'; "
cProced += Chr(10) + "            Grava_Log( '37', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

cProced += Chr(10) + "      if cMsgErr is not null then "
cProced += Chr(10) + "         raise nErro1; "
cProced += Chr(10) + "      end if; "

//Insert na tabela JCG e JCH ---
cProced += Chr(10) + "      if cKeyJCH <> x.JCH_CODCUR || x.JCH_PERLET || x.JCH_HABILI || x.JCH_TURMA || x.JCH_DATA || x.JCH_DISCIP then "
cProced += Chr(10) + "         cKeyJCH := x.JCH_CODCUR || x.JCH_PERLET || x.JCH_HABILI || x.JCH_TURMA || x.JCH_DATA || x.JCH_DISCIP ; "

//Posicione( "JAR", 1, xFilial("JAR")+JCH->JCH_CODCUR+JCH->JCH_PERLET, "JAR_APFALT" )
cProced += Chr(10) + "         select Nvl( Min( JAR_APFALT ), ' ' ) into cJCH_TIPO "
cProced += Chr(10) + "           from "+RetSQLName("JAR")
cProced += Chr(10) + "          where JAR_FILIAL = '"+xFilial("JAR")+"' "
cProced += Chr(10) + "            and JAR_CODCUR = x.JCH_CODCUR "
cProced += Chr(10) + "            and JAR_PERLET = x.JCH_PERLET "
cProced += Chr(10) + "            and JAR_HABILI = x.JCH_HABILI "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "

cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno  "
cProced += Chr(10) + "           from "+RetSQLName("JCG")
cProced += Chr(10) + "          where JCG_FILIAL = '"+xFilial("JCG")+"' "
cProced += Chr(10) + "            and JCG_CODCUR = x.JCH_CODCUR "
cProced += Chr(10) + "            and JCG_PERLET = x.JCH_PERLET "
cProced += Chr(10) + "            and JCG_HABILI = x.JCH_HABILI "
cProced += Chr(10) + "            and JCG_TURMA  = x.JCH_TURMA "
cProced += Chr(10) + "            and JCG_DATA   = x.JCH_DATA "
cProced += Chr(10) + "            and JCG_DISCIP = x.JCH_DISCIP "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "

cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            nLoop := 0;"
cProced += Chr(10) + "            while nLoop = 0 loop "
cProced += Chr(10) + "            begin "
cProced += Chr(10) + "               insert into "+RetSQLName("JCG")
cProced += Chr(10) + "                  (JCG_FILIAL, JCG_CODCUR,   JCG_PERLET,   JCG_HABILI,    JCG_TURMA,   JCG_DISCIP,   JCG_TIPO,  JCG_DATA,   R_E_C_N_O_) "
cProced += Chr(10) + "               values   "
cProced += Chr(10) + "                  ('"+xFilial("JCG")+"',        x.JCH_CODCUR, x.JCH_PERLET, x.JCH_HABILI, x.JCH_TURMA, x.JCH_DISCIP, cJCH_TIPO, x.JCH_DATA, "+RetSQLName("JCG")+"_RECNO.NextVal ); "
cProced += Chr(10) + "	             nLoop := 1; "
cProced += Chr(10) + "            exception "
cProced += Chr(10) + "               when DUP_VAL_ON_INDEX then "
cProced += Chr(10) + "                     nLoop := 0; "
cProced += Chr(10) + "            end; "
cProced += Chr(10) + "            end loop; "
cProced += Chr(10) + "         elsif IN_OVER = 1 then "
cProced += Chr(10) + "            update "+RetSQLName("JCG")+" set JCG_TIPO = cJCH_TIPO "
cProced += Chr(10) + "             where R_E_C_N_O_ = nRecno; "
cProced += Chr(10) + "         end if; "

cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno  "
cProced += Chr(10) + "           from "+RetSQLName("JCH")
cProced += Chr(10) + "          where JCH_FILIAL = '"+xFilial("JCH")+"' "
cProced += Chr(10) + "            and JCH_NUMRA  = x.JCH_NUMRA "
cProced += Chr(10) + "            and JCH_CODCUR = x.JCH_CODCUR "
cProced += Chr(10) + "            and JCH_PERLET = x.JCH_PERLET "
cProced += Chr(10) + "            and JCH_HABILI = x.JCH_HABILI "
cProced += Chr(10) + "            and JCH_TURMA  = x.JCH_TURMA "
cProced += Chr(10) + "            and JCH_DATA   = x.JCH_DATA "
cProced += Chr(10) + "            and JCH_DISCIP = x.JCH_DISCIP "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "

cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            nLoop := 0;"
cProced += Chr(10) + "            while nLoop = 0 loop "
cProced += Chr(10) + "            begin "
cProced += Chr(10) + "               insert into "+RetSQLName("JCH")
cProced += Chr(10) + "                  (JCH_FILIAL, JCH_NUMRA,    JCH_CODCUR,   JCH_PERLET,   JCH_HABILI,   JCH_TURMA,    "
cProced += Chr(10) + "                   JCH_DATA,   JCH_DISCIP,   JCH_QTD,      R_E_C_N_O_) "
cProced += Chr(10) + "               values   "
cProced += Chr(10) + "                  ('"+xFilial("JCH")+"',        x.JCH_NUMRA,  x.JCH_CODCUR, x.JCH_PERLET, x.JCH_HABILI, x.JCH_TURMA,  "
cProced += Chr(10) + "                   x.JCH_DATA, x.JCH_DISCIP, x.JCH_QTD, "+RetSQLName("JCH")+"_RECNO.NextVal ); "
cProced += Chr(10) + "	             nLoop := 1; "
cProced += Chr(10) + "            exception "
cProced += Chr(10) + "               when DUP_VAL_ON_INDEX then "
cProced += Chr(10) + "                    nLoop := 0; "
cProced += Chr(10) + "            end; "
cProced += Chr(10) + "            end loop; "
cProced += Chr(10) + "         elsif IN_OVER = 1 then "
cProced += Chr(10) + "            update "+RetSQLName("JCH")+" set JCH_QTD = x.JCH_QTD "
cProced += Chr(10) + "             where R_E_C_N_O_ = nRecno; "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "
cProced += Chr(10) + "   exception "
cProced += Chr(10) + "      when nErro1 then "
cProced += Chr(10) + "         OUT_REJECT := OUT_REJECT + 1; "
cProced += Chr(10) + "   end; "
cProced += Chr(10) + "   update IMP_STATUS set LASTREC = x.R_E_C_N_O_, HORA = sysdate where TIPO = '37' and THRD = IN_THRD; "
cProced += Chr(10) + "   nCommit := nCommit + 1; "
cProced += Chr(10) + "   if nCommit = IN_COMMIT or IN_COMMIT = 0 then "
cProced += Chr(10) + "      commit; "
cProced += Chr(10) + "      nCommit := 0; "
cProced += Chr(10) + "   end if; "
cProced += Chr(10) + "end loop; "
cProced += Chr(10) + "update IMP_STATUS set LASTREC = IN_MAX, HORA = sysdate where TIPO = '37' and THRD = IN_THRD; "
cProced += Chr(10) + "commit; "
cProced += Chr(10) + "end "+cProcName+"; "

if TCSQLExec( cProced ) <> 0
	UserException("Falha na cria็ใo da procedure - " + TCSQLError() )
endif

Return cProcName

                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC137SP  บAutor  ณRafael Rodrigues    บ Data ณ  11/17/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณThread para executar Stored Procedure no banco.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC137SP( aDados )
Local aResult := {}

prepare environment empresa aDados[1] filial aDados[2] tables "JA2"

aResult := TCSPExec( aDados[3], if(aDados[6], 1, 2), aDados[4], aDados[5], aDados[9], aDados[10] )

if type( 'aResult' ) <> 'A'
	AcaLog( aDados[8], "Thread "+Right(aDados[7],3)+" --> Nใo retornou totais." )
else
	AcaLog( aDados[8], "Thread "+Right(aDados[7],3)+" --> Total Processado: " + Str( aResult[1], 7 ) + " - Total Rejeitado: " + Str( aResult[2], 7 ) )
endif

RPCClearEnv()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC137WaitบAutor  ณRafael Rodrigues    บ Data ณ  11/16/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC137Wait( cProcName, nRecs, nThreads, cLogFile, nCommit )
Local i := 0
Local j := 0
Local lOk
Local nThrdSize := NoRound( nRecs / nThreads, 0 ) + 1
Local cQryOff, cQryTot, cQuery, cQryStat
Local nTot := 0
Local aThrdOff := {}
Local nTimeOut := 0
Local nTickCount	:= 0
Local cNotIn

// Antes de iniciar as threads, cria as sequencias no banco
CreateSeq("JCH")
CreateSeq("JCG")

for i := 1 to nThreads
	if (i*nThrdSize)-nThrdSize+1 <= nRecs
		//if File( "xAC137SP."+StrZero(i,3) )
		//	FErase( "xAC137SP."+StrZero(i,3) )
		//endif
		//AcaLog( "xAC137SP."+StrZero(i,3), "Thread de importacao iniciada" )
		//U_xAC137SP( { SM0->M0_CODIGO, SM0->M0_CODFIL, cProcName, (i*nThrdSize)-nThrdSize+1 ,i*nThrdSize, lOver, "xAC137SP."+StrZero(i,3), cLogFile, i } )
		StartJob( "U_xAC137SP", GetEnvServer(), .F., { SM0->M0_CODIGO, SM0->M0_CODFIL, cProcName, (i*nThrdSize)-nThrdSize+1 ,i*nThrdSize, lOver, "xAC137SP."+StrZero(i,3), cLogFile, i, nCommit } )
		j++
	endif
next i

// Deixa i com o numero da proxima thread, se necessario
i := j + 1

if nOpc == 0
	ProcRegua( nRecs )
endif

// So inicia a checagem da IMP_STATUS quando todas as threads estiverem em operacao
cQuery := "select count(*) QUANT from IMP_STATUS where TIPO = '37'"
while !KillApp()
	for j := 1 to 10
		if nOpc == 0
			IncProc( "Aguardando inicializa็ใo dos processos.."+Repl(".",mod(j,2)) )
		endif
		sleep(1000)
		nTimeOut++
	next j
	dbUseArea( .T., "TopConn", TCGenQry(,, ChangeQuery( cQuery )), "QRY", .F., .F. )
	TCSetField( "QRY", "QUANT", "N", 3, 0 )
	if QRY->QUANT == i-1
		QRY->( dbCloseArea() )
		exit
	endif
	QRY->( dbCloseArea() )
	if nTimeOut > 600	// 10 minutos
		AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '  Ap๓s 10 minutos as threads nใo foram todas iniciadas. O processo serแ abortado.' )
		Return .F.
	endif
end

// Seleciona todas que nao possuem atualizacao a mais de 3 minutos
cQryStat := "select THRD, MINREC, MAXREC, LASTREC as LAST, ( ( LASTREC - MINREC ) + 1 ) AS PROCESSADO, ROUND( ( ( LASTREC - MINREC ) + 1 )/ ( ( MAXREC - MINREC ) - 1 ) * 100, 2) AS PERCENTUAL, To_Char( HORA, 'dd/mm/yyyy hh:mi:ss' ) as HORA from imp_status where TIPO = '37' order by HORA, THRD"
cQryOff  := "select THRD, MINREC, MAXREC, LASTREC as LAST from IMP_STATUS where TIPO = '37' and MAXREC > LASTREC and sysdate > ( HORA+(10/1440) )"
cQryTot  := "select sum( ( LASTREC - MINREC ) + 1 ) as TOTAL from IMP_STATUS where TIPO = '37'"

while !KillApp() .and. nTot < nRecs
	dbUseArea( .T., "TopConn", TCGenQry(,, ChangeQuery( cQryOff )), "QRY", .F., .F. )

	while QRY->( !eof() )
		if aScan( aThrdOff, QRY->THRD ) == 0 .and. len( aThrdOff ) < 50
			aAdd(  aThrdOff, QRY->THRD )
			
			AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '  Thread '+StrZero(QRY->THRD,3)+' nao processa ha mais de 10 minutos e pode ter sido terminada inesperadamente. Analise log do TopConnect para maiores detalhes. A thread '+StrZero(i,3)+' foi iniciada em substituicao.' )
			StartJob( "U_xAC137SP", GetEnvServer(), .F., { SM0->M0_CODIGO, SM0->M0_CODFIL, cProcName, QRY->LAST+1 , QRY->MAXREC, lOver, "xAC137SP."+StrZero(i,3), cLogFile, i, nCommit } )
			i++
		elseif len( aThrdOff ) >= 50
			AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '  O numero de threads terminadas inesperadamente atingiu 50. O processo sera abortado. Analise o log do TopConnect para maiores informacoes.' )

			QRY->( dbCloseArea() )
			Return .F.
		endif
		QRY->( dbSkip() )
	end
	QRY->( dbCloseArea() )
    
	if Len( aThrdOff ) > 0
		cNotIn := " and THRD not in ("
		aEval( aThrdOff, {|x| cNotIn += "'"+x+"', " } )
		cNotIn := Left( cNotIn, len(cNotIn)-2 )+")"
	else
		cNotIn := " "
	endif
	
	// Controla o status da grava็ใo
	dbUseArea( .T., "TopConn", TCGenQry(,, ChangeQuery( cQryTot )), "QRY", .F., .F. )
	nTot := QRY->TOTAL
	QRY->( dbCloseArea() )

	// Atualiza relatorio de status das threads.
	//cQryStat := "select THRD, MINREC, MAXREC, LASTREC as LAST, ( LASTREC - MINREC ) AS PROCESSADO, ROUND( ( LASTREC - MINREC ) / ( MAXREC - MINREC ) * 100, 2) AS PERCENTUAL, To_Char( HORA, 'dd/mm/yyyy hh:mi:ss' ) as HORA from imp_status where TIPO = '37' order by HORA, THRD"
	
	dbUseArea( .T., "TopConn", TCGenQry(,, ChangeQuery( cQryStat )), "QRY", .F., .F. )
	AcaLog( "xRelat137.log", Repl("=",75) )
	AcaLog( "xRelat137.log", " " )
	AcaLog( "xRelat137.log", "Status das threads as "+Time()+" de "+dtoc(date()) )
	AcaLog( "xRelat137.log", " " )
	AcaLog( "xRelat137.log", "Thrd  MinRec    MaxRec    LastRec   Process.  Percent.  dd/mm/aaaa hh:mi:ss" )
	AcaLog( "xRelat137.log", "----  --------  --------  --------  --------  --------  -------------------" )
	while QRY->( !eof() )
		QRY->( AcaLog( "xRelat137.log", PadR( THRD, 4 ) + "  " + Transform( MINREC, "@E 99999999" ) + "  " + Transform( MAXREC, "@E 99999999" ) + "  " + Transform( LAST, "@E 99999999" ) + "  " + Transform( PROCESSADO, "@E 99999999" ) + "  " + Transform( PERCENTUAL, "@E 99999.99" ) + "  " + HORA ) )
		QRY->( dbSkip() )
	end
	AcaLog( "xRelat137.log", " " )
	QRY->( dbCloseArea() )

	if nTot < nRecs
		// Aguarda 30 segundos at้ fazer nova verifica็ใo.
		nTickCount++
		for j := 1 to 30
			if nOpc == 0
				IncProc( Alltrim(Str((nTot/nRecs)*100,6,2))+"% concluํdo.."+Repl(".",mod(j,2)) )
			endif
			sleep(1000)	// 1 segundo
		next j
	endif

	// DEBUG
	AcaLog( 'xDebug37.log', dtoc(date())+" "+Time()+" - "+Alltrim(Str((nTot/nRecs)*100,6,2))+"% concluํdo..." )
	
	if nTickCount == 60	// 30 minutos
		nTickCount := 0
	endif
end

AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '  Todas as threads finalizadas.' )

// Elimina as sequencias do banco
DropSeq("JCH")
DropSeq("JCG")


// Grava log's de rejeicao
i := 0
dbUseArea( .T., "TopConn", TCGenQry(,,ChangeQuery("Select * from IMP_LOG37")), "QRYLOG", .F., .F. )
while QRYLOG->( !eof() )
	i++
	AcaLog( cLogFile, RTrim( QRYLOG->MSG_LOG ) )
	QRYLOG->( dbSkip() )
end
QRYLOG->( dbCloseArea() )

Return i == 0


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXAC13700  บAutor  ณMicrosiga           บ Data ณ  12/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CreateSeq( cAlias )
Local nRecno	:= 0
Local cQuery	:= "SELECT Max(R_E_C_N_O_) REC from "+RetSQLName(cAlias)

dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRBGETREC", .F., .F. )
nRecno := TRBGETREC->REC + 1

TRBGETREC->( dbCloseArea() )


if TCSQLExec( "Create sequence "+RetSQLName(cAlias)+"_RECNO start with "+Alltrim(Str(nRecno))+" increment by 1" ) <> 0
	UserException("Falha na cria็ใo da sequence para o alias "+cAlias+": " + TCSQLError() )
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXAC13700  บAutor  ณMicrosiga           บ Data ณ  12/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DropSeq( cAlias )

TCSQLExec( "Drop sequence "+RetSQLName(cAlias)+"_RECNO " )

Return