#include "protheus.ch"
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC13200  บAutor  ณRafael Rodrigues    บ Data ณ  27/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta o cadastro de Matriculas dos Alunos                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณImportacao de Bases, GE.                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC13200( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC13200'
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
Local nThreads  := 10
Local nCommit	:= 500	// A cada quantas gravacoes deve efetuar commit no banco

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

// Se existe flag para abortar notas e faltas, zera o flag.
if File( "Abort.log" )
	FErase( "Abort.log" )
endif

aAdd( aStru, { "JBE_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JBE_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBE_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBE_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JBE_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JBE_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JBE_ATIVO" , "C", 001, 0 } )
aAdd( aStru, { "JBE_SITUAC", "C", 001, 0 } )
aAdd( aStru, { "JBE_BOLETO", "C", 013, 0 } )
aAdd( aStru, { "JBE_DTMATR", "D", 008, 0 } )
aAdd( aStru, { "JBE_ANOLET", "C", 004, 0 } )
aAdd( aStru, { "JBE_PERIOD", "C", 002, 0 } )
aAdd( aStru, { "JBE_KITMAT", "C", 001, 0 } )
aAdd( aStru, { "JBE_DCOLAC", "D", 008, 0 } )
aAdd( aStru, { "JBE_DTENC" , "D", 008, 0 } )
aAdd( aStru, { "JC7_DISCIP", "C", 015, 0 } )
aAdd( aStru, { "JC7_DIASEM", "C", 001, 0 } )
aAdd( aStru, { "JC7_CODHOR", "C", 006, 0 } )
aAdd( aStru, { "JC7_HORA1" , "C", 005, 0 } )
aAdd( aStru, { "JC7_HORA2" , "C", 005, 0 } )
aAdd( aStru, { "JC7_CODLOC", "C", 006, 0 } )
aAdd( aStru, { "JC7_CODPRE", "C", 006, 0 } )
aAdd( aStru, { "JC7_ANDAR" , "C", 003, 0 } )
aAdd( aStru, { "JC7_CODSAL", "C", 006, 0 } )
aAdd( aStru, { "JC7_SITDIS", "C", 003, 0 } )
aAdd( aStru, { "JC7_SITUAC", "C", 001, 0 } )
aAdd( aStru, { "JC7_CODPRF", "C", 006, 0 } )
aAdd( aStru, { "JC7_CODPR2", "C", 006, 0 } )
aAdd( aStru, { "JC7_CODPR3", "C", 006, 0 } )
aAdd( aStru, { "JC7_CODPR4", "C", 006, 0 } )
aAdd( aStru, { "JC7_CODPR5", "C", 006, 0 } )
aAdd( aStru, { "JC7_CODPR6", "C", 006, 0 } )
aAdd( aStru, { "JC7_CODPR7", "C", 006, 0 } )
aAdd( aStru, { "JC7_CODPR8", "C", 006, 0 } )
aAdd( aStru, { "JC7_OUTCUR", "C", 006, 0 } )
aAdd( aStru, { "JC7_OUTPER", "C", 002, 0 } )
aAdd( aStru, { "JC7_OUTHAB", "C", 006, 0 } )
aAdd( aStru, { "JC7_OUTTUR", "C", 003, 0 } )
aAdd( aStru, { "JC7_MEDANT", "N", 005, 2 } )
aAdd( aStru, { "JC7_AMG"   , "N", 005, 2 } )
aAdd( aStru, { "JC7_MEDFIM", "N", 005, 2 } )
aAdd( aStru, { "JC7_MEDCON", "C", 004, 0 } )
aAdd( aStru, { "JC7_DESMCO", "C", 030, 0 } )
aAdd( aStru, { "JC7_DISDP" , "C", 015, 0 } )
aAdd( aStru, { "JC7_SITDP" , "C", 003, 0 } )
aAdd( aStru, { "JC7_CURDP" , "C", 006, 0 } )
aAdd( aStru, { "JC7_PERDP" , "C", 002, 0 } )
aAdd( aStru, { "JC7_HABDP" , "C", 006, 0 } )
aAdd( aStru, { "JC7_TURDP" , "C", 003, 0 } )
aAdd( aStru, { "JC7_DPBAIX", "C", 001, 0 } )
aAdd( aStru, { "JC7_CURORI", "C", 006, 0 } )
aAdd( aStru, { "JC7_PERORI", "C", 002, 0 } )
aAdd( aStru, { "JC7_HABORI", "C", 006, 0 } )
aAdd( aStru, { "JC7_TURORI", "C", 003, 0 } )
aAdd( aStru, { "JC7_DISORI", "C", 015, 0 } )
aAdd( aStru, { "JC7_SITORI", "C", 003, 0 } )
aAdd( aStru, { "JC7_CODINS", "C", 006, 0 } )
aAdd( aStru, { "JC7_ANOINS", "C", 020, 0 } )
aAdd( aStru, { "R_E_C_N_O_", "N", 010, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Matrํculas dos Alunos', 'AC13200', aClone( aStru ), 'TRB', .T., 'JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA, JC7_DISCIP, JC7_DIASEM, JC7_HORA1, JC7_HORA2, JC7_CODLOC, JC7_CODPRE, JC7_ANDAR, JC7_CODSAL, JC7_OUTCUR, JC7_OUTPER, JC7_OUTHAB, JC7_OUTTUR', {|| "JBE_CODCUR in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JBE_CODCUR and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a janela para selecao de arquivos e importacao dos temporariosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if nOpc == 2	// So processamento
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
	AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() + '  .Iniciando valida็ใo de chave ๚nica do arquivo "'+aFiles[1,1]+'".' )
	if nOpc == 0
		Processa( {|lEnd| lOK := xAC132Chk( aTables[1,2], cLogFile, aTables[1,4] ) }, 'Buscando chaves duplicadas' )
	else
		lOK := xAC132Chk( aTables[1,2], cLogFile, aTables[1,4] )
	endif
	AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() + '  .Fim da valida็ใo de chave ๚nica do arquivo "'+aFiles[1,1]+'".' )

	if lOk
		if lOracle .and. nDrv == 3	// So utiliza procedure se for Oracle e tabela diretamente no banco
			// Cria as Stored Procedures
			cProcName := CreateSP( aTables[1,2] )
			
			if nOpc == 0
				Processa( {|| lOk := xAC132Wait( cProcName, aTables[1,4], nThreads, cLogFile, nCommit ) } )
			else
				lOk := xAC132Wait( cProcName, aTables[1,4], nThreads, cLogFile, nCommit )
			endif

			if !lOk
				AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '! Foram detectadas inconsist๊ncias. A grava็ใo nใo foi completa.' )
				if nOpc == 0 .or. Aviso( 'Problemas!', 'Foram detectadas inconsist๊ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'}, 2 ) == 2
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
			aAdd( aObrig, { 'JBE_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JBE_NUMRA, "JA2_NUMRA" )', 'Aluno nใo cadastrado na tabela JA2.' } )
			aAdd( aObrig, { 'JBE_TIPO$"123456"      ', 'Tipo deve ser 1, 2, 3, 4, 5 ou 6.' } )
			aAdd( aObrig, { 'JBE_ATIVO$"1234567"', 'Ativo deve ser 1=Sim, 2=Nใo, 3=Transferido, 4=Trancado, 5=Formado, 6=Cancelado, 7=Desist๊ncia.' } )
			aAdd( aObrig, { 'JBE_SITUAC$"12"    ', 'Situa็ใo deve ser 1=Pre-matrํcula ou 2=Matrํcula.' } )
			aAdd( aObrig, { '!Empty(JBE_DTMATR) ', 'Data de matrํcula nใo informada.' } )
			aAdd( aObrig, { '!Empty(JBE_ANOLET) ', 'Ano letivo nใo informado.' } )
			aAdd( aObrig, { 'JBE_ANOLET == StrZero( Val(JBE_ANOLET), 4 ) ', 'Ano letivo deve ser informado com 4 dํgitos.' } )
			aAdd( aObrig, { '!Empty(JBE_PERIOD) ', 'Perํodo do ano nใo informado.' } )
			aAdd( aObrig, { 'JBE_PERIOD == StrZero( Val(JBE_PERIOD), 2 ) ', 'Perํodo do ano deve ser informado com zero เ esquerda.' } )
			aAdd( aObrig, { 'Empty(JC7_OUTCUR) .or. ( JC7_DISCIP == Posicione("JBL",7,xFilial("JBL")+JC7_OUTCUR+JC7_OUTPER+JC7_OUTHAB+JC7_OUTTUR+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_CODHOR+JC7_HORA1+JC7_HORA2, "JBL_CODDIS" ) .and. JC7_CODPRF+JC7_CODPR2+JC7_CODPR3+JC7_CODPR4+JC7_CODPR5+JC7_CODPR6+JC7_CODPR7+JC7_CODPR8 == JBL->(JBL_MATPRF+JBL_MATPR2+JBL_MATPR3+JBL_MATPR4+JBL_MATPR5+JBL_MATPR6+JBL_MATPR7+JBL_MATPR8) )', 'Aula ou Professores nใo cadastrados na tabela JBL.' } )
			aAdd( aObrig, { '!Empty(JC7_OUTCUR) .or. ( JC7_DISCIP == Posicione("JBL",7,xFilial("JBL")+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_CODHOR+JC7_HORA1+JC7_HORA2, "JBL_CODDIS" ) .and. JC7_CODPRF+JC7_CODPR2+JC7_CODPR3+JC7_CODPR4+JC7_CODPR5+JC7_CODPR6+JC7_CODPR7+JC7_CODPR8 == JBL->(JBL_MATPRF+JBL_MATPR2+JBL_MATPR3+JBL_MATPR4+JBL_MATPR5+JBL_MATPR6+JBL_MATPR7+JBL_MATPR8) )', 'Aula ou Professores nใo cadastrados na tabela JBL.' } )
			aAdd( aObrig, { 'JC7_SITDIS == Left( Posicione( "SX5", 1, xFilial("SX5")+"F3"+JC7_SITDIS, "X5_CHAVE" ), 3)', 'A situa็ใo da disciplina nใo estแ cadastrada na sub-tabela F3 da tabela SX5.' } )
			aAdd( aObrig, { 'JC7_SITUAC$"123456789A"', 'Situa็ใo acad๊mica da disciplina deve ser 1=Cursando, 2=Aprovado, 3=Reprovado por Nota, 4=Reprovado por Faltas, 5=Reprovado por Nota e Faltas, 6=Exame, 7=Trancado, 8=Dispensado ou 9=Cancelado.' } )
		
			aAdd( aObrig, { 'Empty(JC7_OUTCUR) .or. JC7_OUTTUR == Posicione( "JBO", 1, xFilial("JBO")+JC7_OUTCUR+JC7_OUTPER+JC7_OUTHAB+JC7_OUTTUR, "JBO_TURMA" )', 'Outra Turma nใo cadastrada na tabela JBO.' } )
			aAdd( aObrig, { 'Empty(JC7_OUTCUR) == Empty(JC7_OUTPER) .and. Empty(JC7_OUTPER) == Empty(JC7_OUTTUR)', 'Os campos JC7_OUTCUR, JC7_OUTPER e JC7_OUTTUR devem ser informados conjuntamente.' } )
		
			aAdd( aObrig, { 'JC7_MEDANT <= 10', 'Media anterior ao exame maior que 10.' } )
			aAdd( aObrig, { 'JC7_AMG    <= 10', 'AMG maior que 10.' } )
			aAdd( aObrig, { 'JC7_MEDFIM <= 10', 'Media final maior que 10.' } )
			aAdd( aObrig, { 'JC7_DPBAIX$" 12"', '"DP baixada?" deve ser 1=Sim ou 2=Nใo.' } )
		
			aAdd( aObrig, { 'Empty(JC7_CURDP) .or. JC7_TURDP == Posicione( "JBO", 1, xFilial("JBO")+JC7_CURDP+JC7_PERDP+JC7_HABDP+JC7_TURDP, "JBO_TURMA" )', 'Turma DP nใo cadastrada na tabela JBO.' } )
			aAdd( aObrig, { 'Empty(JC7_SITDP) .or. JC7_SITDP == Left( Posicione( "SX5", 1, xFilial("SX5")+"F3"+JC7_SITDP, "X5_CHAVE" ), 3)', 'A situa็ใo da disciplina DP nใo estแ cadastrada na sub-tabela F3 da tabela SX5.' } )
			aAdd( aObrig, { 'Empty(JC7_CURDP) == Empty(JC7_PERDP) .and. Empty(JC7_PERDP) == Empty(JC7_TURDP) .and.  Empty(JC7_TURDP) == Empty(JC7_DISDP) .and. Empty(JC7_DISDP) == Empty(JC7_SITDP)', 'Os campos JC7_CURDP, JC7_PERDP, JC7_TURDP, JC7_DISDP e JC7_SITDP devem ser informados conjuntamente.' } )
		
			aAdd( aObrig, { 'Empty(JC7_CURORI) .or. JC7_TURORI == Posicione( "JBO", 1, xFilial("JBO")+JC7_CURORI+JC7_PERORI+JC7_HABORI+JC7_TURORI, "JBO_TURMA" )', 'Turma Origem da DP nใo cadastrada na tabela JBO.' } )
			aAdd( aObrig, { 'Empty(JC7_SITORI) .or. JC7_SITORI == Left( Posicione( "SX5", 1, xFilial("SX5")+"F3"+JC7_SITORI, "X5_CHAVE" ), 3)', 'A situa็ใo da disciplina DP origem nใo estแ cadastrada na sub-tabela F3 da tabela SX5.' } )
			aAdd( aObrig, { 'Empty(JC7_CURORI) == Empty(JC7_PERORI) .and. Empty(JC7_PERORI) == Empty(JC7_TURORI) .and.  Empty(JC7_TURORI) == Empty(JC7_DISORI) .and. Empty(JC7_DISORI) == Empty(JC7_SITORI)', 'Os campos JC7_CURORI, JC7_PERORI, JC7_TURORI, JC7_DISORI e JC7_SITORI devem ser informados conjuntamente.' } )
		
			aAdd( aObrig, { 'Empty(JC7_CODINS) .or. JC7_SITDIS == "003"', 'Aproveitamento de estudos s๓ pode existir se a situa็ใo da disciplina for 003=Dispensado.' } )
			aAdd( aObrig, { 'Empty(JC7_CODINS) .or. JC7_CODINS == Posicione("JCL",1,xFilial("JCL")+JC7_CODINS,"JCL_CODIGO")'	, 'Institui็ใo onde cursou a disciplina nใo cadastrada na tabela JCL.' } )
			
			if nOpc == 0
				Processa( { |lEnd| lOk := xAC132Grv( aTables[1,2], aObrig, cLogFile, @lEnd, aTables[1,4] ) }, 'Grava็ao em andamento' )
			else
				lOk := xAC132Grv( aTables[1,2], aObrig, cLogFile, @lEnd, aTables[1,4] )
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

if Select("TRB") > 0
	TRB->( dbCloseArea() )
endif
if len(aTables) # 0 .And. nDrv # 3
	FErase( aTables[1,2]+GetDBExtension() )
	FErase( cIDX + OrdBagExt() )
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC132Grv  บAutor  ณRafael Rodrigues   บ Data ณ 11/Fev/2004 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a gravacao dos dados na base do AP6.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxAC13200                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC132Grv( cTable, aObrig, cLogFile, lEnd, nRecs )
Local cFilJBE	:= xFilial("JBE")	// Criada para ganhar performance
Local cFilJC7	:= xFilial("JC7")	// Criada para ganhar performance
Local cFilJCO	:= xFilial("JCO")	// Criada para ganhar performance
Local i			:= 0
Local j			:= 0
Local cKeyJBE	:= ""
Local lOk		:= .T.
Local lLinOk
Local lSeek

if nOpc == 0
	ProcRegua( nRecs )
endif

TRB->( dbGoTop() )

JBE->( dbSetOrder(1) )
JC7->( dbSetOrder(1) )
JCO->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( 'Analisando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif
	
	lLinOk := .T.
	for j := 1 to len( aObrig )
		if TRB->( !Eval( &("{ || "+aObrig[j, 1]+" }") ) )
			lLinOk := .F.
			AcaLog( cLogFile, '  Inconsist๊ncia na grade do aluno '+TRB->JBE_NUMRA+' curso '+TRB->JBE_CODCUR+', perํodo '+TRB->JBE_PERLET+', turma '+TRB->JBE_TURMA+', dia '+TRB->JC7_DIASEM+', disciplina '+TRB->JC7_DISCIP+', dia '+TRB->JC7_DIASEM+', horario '+TRB->JC7_HORA1+'-'+TRB->JC7_HORA2+': '+aObrig[j, 2] )
		endif
	next j

	if !lLinOk
		lOk := .F.
		TRB->( dbSkip() )
		loop
	endif
	
	if cKeyJBE <> TRB->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA )
		cKeyJBE := TRB->( JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA )
		
		lSeek := JBE->( dbSeek( cFilJBE+TRB->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA) ) )
		
		if lOver .or. !lSeek
			RecLock( "JBE", !lSeek )
			JBE->JBE_FILIAL	:= cFilJBE
			JBE->JBE_NUMRA	:= TRB->JBE_NUMRA
			JBE->JBE_CODCUR	:= TRB->JBE_CODCUR
			JBE->JBE_PERLET	:= TRB->JBE_PERLET
			JBE->JBE_HABILI	:= TRB->JBE_HABILI
			JBE->JBE_TURMA	:= TRB->JBE_TURMA
			JBE->JBE_TIPO	:= TRB->JBE_TIPO
			JBE->JBE_ATIVO	:= TRB->JBE_ATIVO
			JBE->JBE_SITUAC	:= TRB->JBE_SITUAC
			JBE->JBE_BOLETO	:= TRB->JBE_BOLETO
			JBE->JBE_DTMATR	:= TRB->JBE_DTMATR
			JBE->JBE_ANOLET	:= TRB->JBE_ANOLET
			JBE->JBE_PERIOD	:= TRB->JBE_PERIOD
			JBE->JBE_KITMAT	:= TRB->JBE_KITMAT
			JBE->JBE_DCOLAC	:= TRB->JBE_DCOLAC
			JBE->JBE_DTENC 	:= TRB->JBE_DTENC
			JBE->( msUnlock() )
		endif
	endif
	
	if !Empty( TRB->JC7_CODINS )
		lSeek := JCO->( dbSeek( cFilJCO+TRB->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JC7_DISCIP) ) )
		if lOver .or. !lSeek
			RecLock( "JCO", !lSeek )
			JCO->JCO_FILIAL	:= cFilJCO
			JCO->JCO_NUMRA	:= TRB->JBE_NUMRA
			JCO->JCO_CODCUR	:= TRB->JBE_CODCUR
			JCO->JCO_PERLET	:= TRB->JBE_PERLET
			JCO->JCO_HABILI	:= TRB->JBE_HABILI
			JCO->JCO_DISCIP	:= TRB->JC7_DISCIP
			JCO->JCO_MEDFIM	:= TRB->JC7_MEDFIM
			JCO->JCO_MEDCON	:= TRB->JC7_MEDCON
			JCO->JCO_CODINS	:= TRB->JC7_CODINS
			JCO->JCO_ANOINS	:= TRB->JC7_ANOINS
			JCO->( msUnlock() )
		endif
	endif

	lSeek := JC7->( dbSeek( cFilJC7+TRB->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1) ) )
	if lOver .or. !lSeek
		RecLock( "JC7", !lSeek )
		JC7->JC7_FILIAL	:= cFilJC7
		JC7->JC7_NUMRA	:= TRB->JBE_NUMRA
		JC7->JC7_CODCUR	:= TRB->JBE_CODCUR
		JC7->JC7_PERLET	:= TRB->JBE_PERLET
		JC7->JC7_HABILI	:= TRB->JBE_HABILI
		JC7->JC7_TURMA	:= TRB->JBE_TURMA
		JC7->JC7_DISCIP	:= TRB->JC7_DISCIP
		JC7->JC7_CODLOC	:= TRB->JC7_CODLOC
		JC7->JC7_CODPRE	:= TRB->JC7_CODPRE
		JC7->JC7_ANDAR	:= TRB->JC7_ANDAR
		JC7->JC7_CODSAL	:= TRB->JC7_CODSAL
		JC7->JC7_SITDIS	:= TRB->JC7_SITDIS
		JC7->JC7_SITUAC	:= TRB->JC7_SITUAC
		JC7->JC7_DIASEM	:= TRB->JC7_DIASEM
		JC7->JC7_CODHOR	:= TRB->JC7_CODHOR
		JC7->JC7_HORA1	:= TRB->JC7_HORA1
		JC7->JC7_HORA2	:= TRB->JC7_HORA2
		JC7->JC7_CODPRF	:= TRB->JC7_CODPRF
		JC7->JC7_CODPR2	:= TRB->JC7_CODPR2
		JC7->JC7_CODPR3	:= TRB->JC7_CODPR3
		JC7->JC7_CODPR4	:= TRB->JC7_CODPR4
		JC7->JC7_CODPR5	:= TRB->JC7_CODPR5
		JC7->JC7_CODPR6	:= TRB->JC7_CODPR6
		JC7->JC7_CODPR7	:= TRB->JC7_CODPR7
		JC7->JC7_CODPR8	:= TRB->JC7_CODPR8
		JC7->JC7_OUTCUR	:= TRB->JC7_OUTCUR
		JC7->JC7_OUTPER	:= TRB->JC7_OUTPER
		JC7->JC7_OUTHAB	:= TRB->JC7_OUTHAB
		JC7->JC7_OUTTUR	:= TRB->JC7_OUTTUR
		JC7->JC7_MEDANT	:= TRB->JC7_MEDANT
		JC7->JC7_AMG   	:= TRB->JC7_AMG
		JC7->JC7_MEDFIM	:= TRB->JC7_MEDFIM
		JC7->JC7_DISDP	:= TRB->JC7_DISDP
		JC7->JC7_SITDP	:= TRB->JC7_SITDP
		JC7->JC7_DPBAIX	:= TRB->JC7_DPBAIX
		JC7->JC7_CURDP	:= TRB->JC7_CURDP
		JC7->JC7_PERDP	:= TRB->JC7_PERDP
		JC7->JC7_HABDP	:= TRB->JC7_HABDP
		JC7->JC7_TURDP	:= TRB->JC7_TURDP
		JC7->JC7_CURORI	:= TRB->JC7_CURORI
		JC7->JC7_PERORI	:= TRB->JC7_PERORI
		JC7->JC7_HABORI	:= TRB->JC7_HABORI
		JC7->JC7_TURORI	:= TRB->JC7_TURORI
		JC7->JC7_DISORI	:= TRB->JC7_DISORI
		JC7->JC7_SITORI	:= TRB->JC7_SITORI
		JC7->JC7_MEDCON	:= TRB->JC7_MEDCON
		JC7->JC7_CODINS	:= TRB->JC7_CODINS
		JC7->JC7_ANOINS	:= TRB->JC7_ANOINS
		JC7->( msUnlock() )
	endif
	
	TRB->( dbSkip() )
end

Return !lEnd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAC132Chk บAutor  ณRafael Rodrigues    บ Data ณ 11/Fev/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca duplicidades de chaves no arquivo de importacao       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMigracao de bases                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC132Chk( cTable, cLogFile, nRecs )
Local cQuery
Local lOk := .T.                        
Local i   := 0

if nOpc == 0
	ProcRegua( nRecs )
endif

cQuery := "select JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA, JC7_DISCIP, JC7_DIASEM, JC7_HORA1, JC7_HORA2, JC7_CODLOC, JC7_CODPRE, JC7_ANDAR, JC7_CODSAL, JC7_OUTCUR, JC7_OUTPER, JC7_OUTTUR "
cQuery += "  from "+cTable
cQuery += " group by JBE_NUMRA, JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA, JC7_DISCIP, JC7_DIASEM, JC7_HORA1, JC7_HORA2, JC7_CODLOC, JC7_CODPRE, JC7_ANDAR, JC7_CODSAL, JC7_OUTCUR, JC7_OUTPER, JC7_OUTTUR "
cQuery += "having count(*) > 1 "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )

lOk := lOk .and. QRY->( eof() )
while QRY->( !eof() )
	if nOpc == 0
		IncProc( 'Validando linha '+StrZero( ++i, 8 )+' de '+StrZero( nRecs, 8 )+'...' )
	endif
	AcaLog( cLogFile, '  Inconsist๊ncia na grade. Chave duplicada para o aluno '+QRY->JBE_NUMRA+' curso '+QRY->JBE_CODCUR+', perํodo '+QRY->JBE_PERLET+', turma '+QRY->JBE_TURMA+', dia '+QRY->JC7_DIASEM+', disciplina '+QRY->JC7_DISCIP+'.' )
	QRY->( dbSkip() )
end

QRY->( dbCloseArea() )
Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXAC132SP  บAutor  ณRafael Rodrigues    บ Data ณ  11/16/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณStored Procedures desenvolvidas por Emerson Tobar           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMigracao de Dados - GE                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CreateSP( cTabela )
Local cProcName
Local cProced

cProcName := CriaTrab(,.F.)

TCSQLExec( "truncate table IMP_LOG32" )
TCSQLExec( "delete from IMP_STATUS where TIPO = '32'" )

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

cProced += Chr(10) + "nRecno  integer; "
cProced += Chr(10) + "nLoop   integer; "
cProced += Chr(10) + "nErro1  exception; "
cProced += Chr(10) + "cMsgErr varchar2(500); "
cProced += Chr(10) + "cAnoAux varchar2(004); "
cProced += Chr(10) + "cPerAux varchar2(002); "
cProced += Chr(10) + "cKeyJBE varchar2(026); "
cProced += Chr(10) + "cMsgFix varchar2(500); "
cProced += Chr(10) + "nCommit integer; "

cProced += Chr(10) + "cursor cur01 is "
cProced += Chr(10) + "select /*+ FIRST_ROWS */ JBE_NUMRA,  JBE_CODCUR, JBE_PERLET, JBE_HABILI, JBE_TURMA,  JBE_TIPO,   JBE_ATIVO,  JBE_SITUAC, JBE_BOLETO, JBE_DTMATR,  "
cProced += Chr(10) + "       JBE_ANOLET, JBE_PERIOD, JBE_KITMAT, JBE_DCOLAC, JBE_DTENC,  JC7_DISCIP, JC7_DIASEM, JC7_CODHOR, JC7_HORA1,   "
cProced += Chr(10) + "       JC7_HORA2,  JC7_CODLOC, JC7_CODPRE, JC7_ANDAR,  JC7_CODSAL, JC7_SITDIS, JC7_SITUAC, JC7_CODPRF, JC7_CODPR2,  "
cProced += Chr(10) + "       JC7_CODPR3, JC7_CODPR4, JC7_CODPR5, JC7_CODPR6, JC7_CODPR7, JC7_CODPR8, JC7_OUTCUR, JC7_OUTPER, JC7_OUTTUR,  "
cProced += Chr(10) + "       JC7_MEDANT, JC7_AMG,    JC7_MEDFIM, JC7_MEDCON, JC7_DESMCO, JC7_DISDP,  JC7_SITDP,  JC7_CURDP,  JC7_PERDP,  "
cProced += Chr(10) + "       JC7_TURDP,  JC7_DPBAIX, JC7_CURORI, JC7_PERORI, JC7_TURORI, JC7_DISORI, JC7_SITORI, JC7_CODINS, JC7_ANOINS, R_E_C_N_O_ "
cProced += Chr(10) + "  from "+cTabela+" "
cProced += Chr(10) + " where R_E_C_N_O_ between IN_MIN and IN_MAX; "

cProced += Chr(10) + "begin "
cProced += Chr(10) + "   insert into IMP_STATUS ( TIPO, THRD, MINREC, MAXREC, LASTREC, HORA ) values ( '32', IN_THRD, IN_MIN, IN_MAX, 0, sysdate ); "
cProced += Chr(10) + "   commit; "
cProced += Chr(10) + "   OUT_TOTAL  := 0; "
cProced += Chr(10) + "   OUT_REJECT := 0; "
cProced += Chr(10) + "   cKeyJBE := ' '; "

cProced += Chr(10) + "   for x in cur01 loop "
cProced += Chr(10) + "   begin "
cProced += Chr(10) + "      cMsgErr   := null;"
cProced += Chr(10) + "      cMsgFix   := '  Inconsist๊ncia na grade do aluno ' || x.JBE_NUMRA || ' curso ' || x.JBE_CODCUR || ', perํodo ' || x.JBE_PERLET || ', turma ' || x.JBE_TURMA || ', dia ' || x.JC7_DIASEM || ', disciplina ' || x.JC7_DISCIP || ', dia ' || x.JC7_DIASEM || ', horario ' || x.JC7_HORA1 || '-' || x.JC7_HORA2 || ': ';"
cProced += Chr(10) + "      OUT_TOTAL := OUT_TOTAL + 1; "

//-- 01 aAdd( aObrig, { 'JBE_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JBE_NUMRA, "JA2_NUMRA" )', 'Aluno nใo cadastrado na tabela JA2.' } ) "
cProced += Chr(10) + "      select Min( R_E_C_N_O_ ) into nRecno  "
cProced += Chr(10) + "        from "+RetSQLName("JA2")+" "
cProced += Chr(10) + "       where JA2_FILIAL = '"+xFilial("JA2")+"' "
cProced += Chr(10) + "         and JA2_NUMRA  = x.JBE_NUMRA "
cProced += Chr(10) + "         and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "      if nRecno is null then  "
cProced += Chr(10) + "         cMsgErr := 'Aluno nใo cadastrado na tabela JA2.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 02 aAdd( aObrig, { 'JBE_TIPO$"123456"      ', 'Tipo deve ser 1, 2, 3, 4, 5 ou 6.' } ) "
cProced += Chr(10) + "      if x.JBE_TIPO < '1' or x.JBE_TIPO > '6' then  "
cProced += Chr(10) + "         cMsgErr := 'Tipo deve ser 1, 2, 3, 4, 5 ou 6.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 03 aAdd( aObrig, { 'JBE_ATIVO$"1234567"', 'Ativo deve ser 1=Sim, 2=Nใo, 3=Transferido, 4=Trancado, 5=Formado, 6=Cancelado, 7=Desist๊ncia.' } ) "
cProced += Chr(10) + "      if x.JBE_ATIVO < '1' or x.JBE_ATIVO > '7' then "
cProced += Chr(10) + "         cMsgErr := 'Ativo deve ser 1=Sim, 2=Nใo, 3=Transferido, 4=Trancado, 5=Formado, 6=Cancelado, 7=Desist๊ncia.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 04 aAdd( aObrig, { 'JBE_SITUAC$"12"    ', 'Situa็ใo deve ser 1=Pre-matrํcula ou 2=Matrํcula.' } ) "
cProced += Chr(10) + "      if x.JBE_SITUAC < '1' or x.JBE_SITUAC > '2' then "
cProced += Chr(10) + "         cMsgErr := 'Situa็ใo deve ser 1=Pre-matrํcula ou 2=Matrํcula.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 05 aAdd( aObrig, { '!Empty(JBE_DTMATR) ', 'Data de matrํcula nใo informada.' } ) "
cProced += Chr(10) + "      if x.JBE_DTMATR = ' ' then "
cProced += Chr(10) + "         cMsgErr := 'Data de matrํcula nใo informada.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 06 aAdd( aObrig, { '!Empty(JBE_ANOLET) ', 'Ano letivo nใo informado.' } ) "
cProced += Chr(10) + "      if x.JBE_ANOLET = ' ' then "
cProced += Chr(10) + "         cMsgErr := 'Ano letivo nใo informado.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 07 aAdd( aObrig, { 'JBE_ANOLET == StrZero( Val(JBE_ANOLET), 4 ) ', 'Ano letivo deve ser informado com 4 dํgitos.' } ) "
cProced += Chr(10) + "      cAnoAux := trim( x.JBE_ANOLET ); "
cProced += Chr(10) + "      if length( cAnoAux ) <> 4 then "
cProced += Chr(10) + "         cMsgErr := 'Ano letivo deve ser informado com 4 dํgitos.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 08 aAdd( aObrig, { '!Empty(JBE_PERIOD) ', 'Perํodo do ano nใo informado.' } ) "
cProced += Chr(10) + "      if x.JBE_PERIOD = ' ' then "
cProced += Chr(10) + "         cMsgErr := 'Perํodo do ano nใo informado.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 09 aAdd( aObrig, { 'JBE_PERIOD == StrZero( Val(JBE_PERIOD), 2 ) ', 'Perํodo do ano deve ser informado com zero เ esquerda.' } ) "
cProced += Chr(10) + "      cPerAux := trim( x.JBE_PERIOD ); "
cProced += Chr(10) + "      if length( cPerAux ) <> 2 then "
cProced += Chr(10) + "         cMsgErr := 'Perํodo do ano deve ser informado com zero เ esquerda.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 10 aAdd( aObrig, { 'Empty(JC7_OUTCUR) .or. ( JC7_DISCIP == Posicione("JBL",7,xFilial("JBL")+JC7_OUTCUR+JC7_OUTPER+JC7_OUTTUR+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_CODHOR+JC7_HORA1+JC7_HORA2, "JBL_CODDIS" ) .and. JC7_CODPRF+JC7_CODPR2+JC7_CODPR3+JC7_CODPR4+JC7_CODPR5+JC7_CODPR6+JC7_CODPR7+JC7_CODPR8 == JBL->(JBL_MATPRF+JBL_MATPR2+JBL_MATPR3+JBL_MATPR4+JBL_MATPR5+JBL_MATPR6+JBL_MATPR7+JBL_MATPR8) )', 'Aula ou Professores nใo cadastrados na tabela JBL.' } ) "
cProced += Chr(10) + "      if x.JC7_OUTCUR <> ' ' then "
cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("JBL")+" "
cProced += Chr(10) + "          where JBL_FILIAL = '"+xFilial("JBL")+"' "
cProced += Chr(10) + "            and JBL_CODDIS = x.JC7_DISCIP "
cProced += Chr(10) + "            and JBL_CODCUR = x.JC7_OUTCUR "
cProced += Chr(10) + "            and JBL_PERLET = x.JC7_OUTPER "
cProced += Chr(10) + "            and JBL_HABILI = x.JC7_OUTHAB "
cProced += Chr(10) + "            and JBL_TURMA  = x.JC7_OUTTUR "
cProced += Chr(10) + "            and JBL_CODDIS = x.JC7_DISCIP "
cProced += Chr(10) + "            and JBL_CODLOC = x.JC7_CODLOC "
cProced += Chr(10) + "            and JBL_CODPRE = x.JC7_CODPRE "
cProced += Chr(10) + "            and JBL_ANDAR  = x.JC7_ANDAR "
cProced += Chr(10) + "            and JBL_CODSAL = x.JC7_CODSAL "
cProced += Chr(10) + "            and JBL_DIASEM = x.JC7_DIASEM "
cProced += Chr(10) + "            and JBL_CODHOR = x.JC7_CODHOR "
cProced += Chr(10) + "            and JBL_HORA1  = x.JC7_HORA1 "
cProced += Chr(10) + "            and JBL_HORA2  = x.JC7_HORA2 "
cProced += Chr(10) + "            and JBL_MATPRF = x.JC7_CODPRF "
cProced += Chr(10) + "            and JBL_MATPR2 = x.JC7_CODPR2 "
cProced += Chr(10) + "            and JBL_MATPR3 = x.JC7_CODPR3 "
cProced += Chr(10) + "            and JBL_MATPR4 = x.JC7_CODPR4 "
cProced += Chr(10) + "            and JBL_MATPR5 = x.JC7_CODPR5 "
cProced += Chr(10) + "            and JBL_MATPR6 = x.JC7_CODPR6 "
cProced += Chr(10) + "            and JBL_MATPR7 = x.JC7_CODPR7 "
cProced += Chr(10) + "            and JBL_MATPR8 = x.JC7_CODPR8 "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            cMsgErr := 'Aula ou Professores nใo cadastrados na tabela JBL.'; "
cProced += Chr(10) + "            Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

//-- 11 aAdd( aObrig, { '!Empty(JC7_OUTCUR) .or. ( JC7_DISCIP == Posicione("JBL",7,xFilial("JBL")+JBE_CODCUR+JBE_PERLET+JBE_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_CODHOR+JC7_HORA1+JC7_HORA2, "JBL_CODDIS" ) .and. JC7_CODPRF+JC7_CODPR2+JC7_CODPR3+JC7_CODPR4+JC7_CODPR5+JC7_CODPR6+JC7_CODPR7+JC7_CODPR8 == JBL->(JBL_MATPRF+JBL_MATPR2+JBL_MATPR3+JBL_MATPR4+JBL_MATPR5+JBL_MATPR6+JBL_MATPR7+JBL_MATPR8) )', 'Aula ou Professores nใo cadastrados na tabela JBL.' } ) "
cProced += Chr(10) + "      if x.JC7_OUTCUR = ' ' then "
cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("JBL")+" "
cProced += Chr(10) + "          where JBL_FILIAL = '"+xFilial("JBL")+"' "
cProced += Chr(10) + "            and JBL_CODDIS = x.JC7_DISCIP "
cProced += Chr(10) + "            and JBL_CODCUR = x.JBE_CODCUR "
cProced += Chr(10) + "            and JBL_PERLET = x.JBE_PERLET "
cProced += Chr(10) + "            and JBL_HABILI = x.JBE_HABILI "
cProced += Chr(10) + "            and JBL_TURMA  = x.JBE_TURMA "
cProced += Chr(10) + "            and JBL_CODDIS = x.JC7_DISCIP "
cProced += Chr(10) + "            and JBL_CODLOC = x.JC7_CODLOC "
cProced += Chr(10) + "            and JBL_CODPRE = x.JC7_CODPRE "
cProced += Chr(10) + "            and JBL_ANDAR  = x.JC7_ANDAR "
cProced += Chr(10) + "            and JBL_CODSAL = x.JC7_CODSAL "
cProced += Chr(10) + "            and JBL_DIASEM = x.JC7_DIASEM "
cProced += Chr(10) + "            and JBL_CODHOR = x.JC7_CODHOR "
cProced += Chr(10) + "            and JBL_HORA1  = x.JC7_HORA1 "
cProced += Chr(10) + "            and JBL_HORA2  = x.JC7_HORA2 "
cProced += Chr(10) + "            and JBL_MATPRF = x.JC7_CODPRF  "
cProced += Chr(10) + "            and JBL_MATPR2 = x.JC7_CODPR2 "
cProced += Chr(10) + "            and JBL_MATPR3 = x.JC7_CODPR3 "
cProced += Chr(10) + "            and JBL_MATPR4 = x.JC7_CODPR4 "
cProced += Chr(10) + "            and JBL_MATPR5 = x.JC7_CODPR5 "
cProced += Chr(10) + "            and JBL_MATPR6 = x.JC7_CODPR6 "
cProced += Chr(10) + "            and JBL_MATPR7 = x.JC7_CODPR7 "
cProced += Chr(10) + "            and JBL_MATPR8 = x.JC7_CODPR8 "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            cMsgErr := 'Aula ou Professores nใo cadastrados na tabela JBL.'; "
cProced += Chr(10) + "            Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

//-- 12 aAdd( aObrig, { 'JC7_SITDIS == Left( Posicione( "SX5", 1, xFilial("SX5")+"F3"+JC7_SITDIS, "X5_CHAVE" ), 3)', 'A situa็ใo da disciplina nใo estแ cadastrada na sub-tabela F3 da tabela SX5.' } ) "
cProced += Chr(10) + "      select Min( R_E_C_N_O_ ) into nRecno "
cProced += Chr(10) + "        from "+RetSQLName("SX5")+" "
cProced += Chr(10) + "       where X5_FILIAL = '"+xFilial("SX5")+"' "
cProced += Chr(10) + "         and X5_TABELA = 'F3' "
cProced += Chr(10) + "         and X5_CHAVE  = x.JC7_SITDIS "
cProced += Chr(10) + "         and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "      if nRecno is null then "
cProced += Chr(10) + "         cMsgErr := 'A situa็ใo da disciplina nใo estแ cadastrada na sub-tabela F3 da tabela SX5.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 13 aAdd( aObrig, { 'JC7_SITUAC$"123456789A"', 'Situa็ใo acad๊mica da disciplina deve ser 1=Cursando, 2=Aprovado, 3=Reprovado por Nota, 4=Reprovado por Faltas, 5=Reprovado por Nota e Faltas, 6=Exame, 7=Trancado, 8=Dispensado ou 9=Cancelado.' } ) "
cProced += Chr(10) + "      if x.JC7_SITUAC not in ('1', '2',  '3',  '4',  '5',  '6',  '7',  '8',  '9', 'A' ) then "
cProced += Chr(10) + "         cMsgErr := 'Situa็ใo acad๊mica da disciplina deve ser 1=Cursando, 2=Aprovado, 3=Reprovado por Nota, 4=Reprovado por Faltas, 5=Reprovado por Nota e Faltas, 6=Exame, 7=Trancado, 8=Dispensado ou 9=Cancelado.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 14 aAdd( aObrig, { 'Empty(JC7_OUTCUR) .or. JC7_OUTTUR == Posicione( "JBO", 1, xFilial("JBO")+JC7_OUTCUR+JC7_OUTPER+JC7_OUTTUR, "JBO_TURMA" )', 'Outra Turma nใo cadastrada na tabela JBO.' } ) "
cProced += Chr(10) + "      if x.JC7_OUTCUR <> ' ' then "
cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("JBO")+" "
cProced += Chr(10) + "          where JBO_FILIAL = '"+xFilial("JBO")+"' "
cProced += Chr(10) + "            and JBO_CODCUR = x.JC7_OUTCUR "
cProced += Chr(10) + "            and JBO_PERLET = x.JC7_OUTPER "
cProced += Chr(10) + "            and JBO_HABILI = x.JC7_OUTHAB "
cProced += Chr(10) + "            and JBO_TURMA  = x.JC7_OUTTUR "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            cMsgErr := 'Outra Turma nใo cadastrada na tabela JBO.'; "
cProced += Chr(10) + "            Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

//-- 15 aAdd( aObrig, { 'Empty(JC7_OUTCUR) == Empty(JC7_OUTPER) .and. Empty(JC7_OUTPER) == Empty(JC7_OUTTUR)', 'Os campos JC7_OUTCUR, JC7_OUTPER e JC7_OUTTUR devem ser informados conjuntamente.' } ) "
cProced += Chr(10) + "      if  not ( ( x.JC7_OUTCUR <> ' ' and x.JC7_OUTPER <> ' ' and x.JC7_OUTTUR <> ' ' )  "
cProced += Chr(10) + "             or ( x.JC7_OUTCUR =  ' ' and x.JC7_OUTPER =  ' ' and x.JC7_OUTTUR =  ' ' ) ) then "
cProced += Chr(10) + "         cMsgErr := 'Os campos JC7_OUTCUR, JC7_OUTPER e JC7_OUTTUR devem ser informados conjuntamente.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 16 aAdd( aObrig, { 'JC7_MEDANT <= 10', 'Media anterior ao exame maior que 10.' } ) "
cProced += Chr(10) + "      if x.JC7_MEDANT > 10 then "
cProced += Chr(10) + "         cMsgErr := 'Media anterior ao exame maior que 10.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 17 aAdd( aObrig, { 'JC7_AMG    <= 10', 'AMG maior que 10.' } ) "
cProced += Chr(10) + "      if x.JC7_AMG > 10 then "
cProced += Chr(10) + "         cMsgErr := 'AMG maior que 10.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 18 aAdd( aObrig, { 'JC7_MEDFIM <= 10', 'Media final maior que 10.' } ) "
cProced += Chr(10) + "      if x.JC7_MEDFIM > 10 then "
cProced += Chr(10) + "         cMsgErr := 'Media final maior que 10.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 19 aAdd( aObrig, { 'JC7_DPBAIX$" 12"', '"DP baixada?" deve ser 1=Sim ou 2=Nใo.' } ) "
cProced += Chr(10) + "      if x.JC7_DPBAIX <> ' ' and x.JC7_DPBAIX <> '1' and x.JC7_DPBAIX <> '2' then "
cProced += Chr(10) + "         cMsgErr := 'DP baixada? deve ser 1=Sim ou 2=Nใo.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 20 aAdd( aObrig, { 'Empty(JC7_CURDP) .or. JC7_TURDP == Posicione( "JBO", 1, xFilial("JBO")+JC7_CURDP+JC7_PERDP+JC7_TURDP, "JBO_TURMA" )', 'Turma DP nใo cadastrada na tabela JBO.' } ) "
cProced += Chr(10) + "      if x.JC7_CURDP <> ' ' then "
cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno  "
cProced += Chr(10) + "           from "+RetSQLName("JBO")+" "
cProced += Chr(10) + "          where JBO_FILIAL = '"+xFilial("JBO")+"' "
cProced += Chr(10) + "            and JBO_CODCUR = x.JC7_CURDP "
cProced += Chr(10) + "            and JBO_PERLET = x.JC7_PERDP "
cProced += Chr(10) + "            and JBO_HABILI = x.JC7_HABDP "
cProced += Chr(10) + "            and JBO_TURMA  = x.JC7_TURDP "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            cMsgErr := 'Turma DP nใo cadastrada na tabela JBO.'; "
cProced += Chr(10) + "            Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

//-- 21 aAdd( aObrig, { 'Empty(JC7_SITDP) .or. JC7_SITDP == Left( Posicione( "SX5", 1, xFilial("SX5")+"F3"+JC7_SITDP, "X5_CHAVE" ), 3)', 'A situa็ใo da disciplina DP nใo estแ cadastrada na sub-tabela F3 da tabela SX5.' } ) "
cProced += Chr(10) + "      if x.JC7_SITDP <> ' ' then "
cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("SX5")+" "
cProced += Chr(10) + "          where X5_FILIAL = '"+xFilial("SX5")+"' "
cProced += Chr(10) + "            and X5_TABELA = 'F3' "
cProced += Chr(10) + "            and X5_CHAVE  = x.JC7_SITDP "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            cMsgErr := 'A situa็ใo da disciplina DP nใo estแ cadastrada na sub-tabela F3 da tabela SX5.'; "
cProced += Chr(10) + "            Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

//-- 22 aAdd( aObrig, { 'Empty(JC7_CURDP) == Empty(JC7_PERDP) .and. Empty(JC7_PERDP) == Empty(JC7_TURDP) .and.  Empty(JC7_TURDP) == Empty(JC7_DISDP) .and. Empty(JC7_DISDP) == Empty(JC7_SITDP)', 'Os campos JC7_CURDP, JC7_PERDP, JC7_TURDP, JC7_DISDP e JC7_SITDP devem ser informados conjuntamente.' } ) "
cProced += Chr(10) + "      if not ( ( x.JC7_CURDP <> ' ' and x.JC7_PERDP <> ' ' and x.JC7_TURDP <> ' ' and x.JC7_DISDP <> ' ' and x.JC7_SITDP <> ' ' )  "
cProced += Chr(10) + "            or ( x.JC7_CURDP =  ' ' and x.JC7_PERDP =  ' ' and x.JC7_TURDP =  ' ' and x.JC7_DISDP =  ' ' and x.JC7_SITDP =  ' ' ) ) then "
cProced += Chr(10) + "         cMsgErr := 'Os campos JC7_CURDP, JC7_PERDP, JC7_TURDP, JC7_DISDP e JC7_SITDP devem ser informados conjuntamente.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 23 aAdd( aObrig, { 'Empty(JC7_CURORI) .or. JC7_TURORI == Posicione( "JBO", 1, xFilial("JBO")+JC7_CURORI+JC7_PERORI+JC7_TURORI, "JBO_TURMA" )', 'Turma Origem da DP nใo cadastrada na tabela JBO.' } ) "
cProced += Chr(10) + "      if x.JC7_CURORI <> ' ' then "
cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("JBO")+" "
cProced += Chr(10) + "          where JBO_FILIAL = '"+xFilial("JBO")+"' "
cProced += Chr(10) + "            and JBO_CODCUR = x.JC7_CURORI "
cProced += Chr(10) + "            and JBO_PERLET = x.JC7_PERORI "
cProced += Chr(10) + "            and JBO_HABILI = x.JC7_HABORI "
cProced += Chr(10) + "            and JBO_TURMA  = x.JC7_TURORI "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            cMsgErr := 'Turma Origem da DP nใo cadastrada na tabela JBO.'; "
cProced += Chr(10) + "            Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

//-- 24 aAdd( aObrig, { 'Empty(JC7_SITORI) .or. JC7_SITORI == Left( Posicione( "SX5", 1, xFilial("SX5")+"F3"+JC7_SITORI, "X5_CHAVE" ), 3)', 'A situa็ใo da disciplina DP origem nใo estแ cadastrada na sub-tabela F3 da tabela SX5.' } ) "
cProced += Chr(10) + "      if x.JC7_SITORI <> ' ' then "
cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("SX5")+" "
cProced += Chr(10) + "          where X5_FILIAL = '"+xFilial("SX5")+"' "
cProced += Chr(10) + "            and X5_TABELA = 'F3' "
cProced += Chr(10) + "            and X5_CHAVE  = x.JC7_SITORI "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            cMsgErr := 'A situa็ใo da disciplina DP origem nใo estแ cadastrada na sub-tabela F3 da tabela SX5.'; "
cProced += Chr(10) + "            Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

//-- 25 aAdd( aObrig, { 'Empty(JC7_CURORI) == Empty(JC7_PERORI) .and. Empty(JC7_PERORI) == Empty(JC7_TURORI) .and.  Empty(JC7_TURORI) == Empty(JC7_DISORI) .and. Empty(JC7_DISORI) == Empty(JC7_SITORI)', 'Os campos JC7_CURORI, JC7_PERORI, JC7_TURORI, JC7_DISORI e JC7_SITORI devem ser informados conjuntamente.' } ) "
cProced += Chr(10) + "      if not ( ( x.JC7_CURORI <> ' ' and x.JC7_PERORI <> ' ' and x.JC7_TURORI <> ' ' and x.JC7_DISORI <> ' ' and x.JC7_SITORI <> ' ' ) "
cProced += Chr(10) + "            or ( x.JC7_CURORI =  ' ' and x.JC7_PERORI =  ' ' and x.JC7_TURORI =  ' ' and x.JC7_DISORI =  ' ' and x.JC7_SITORI =  ' ' ) ) then "
cProced += Chr(10) + "         cMsgErr := 'Os campos JC7_CURORI, JC7_PERORI, JC7_TURORI, JC7_DISORI e JC7_SITORI devem ser informados conjuntamente.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 26 aAdd( aObrig, { 'Empty(JC7_CODINS) .or. JC7_SITDIS == "003"', 'Aproveitamento de estudos s๓ pode existir se a situa็ใo da disciplina for 003=Dispensado.' } ) "
cProced += Chr(10) + "      if  (x.JC7_CODINS <> ' ' and x.JC7_SITDIS <> '003' )   "
cProced += Chr(10) + "       or (x.JC7_CODINS = ' '  and x.JC7_SITDIS = '003' )  then "
cProced += Chr(10) + "         cMsgErr := 'Aproveitamento de estudos s๓ pode existir se a situa็ใo da disciplina for 003=Dispensado.'; "
cProced += Chr(10) + "         Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "      end if; "

//-- 27 aAdd( aObrig, { 'Empty(JC7_CODINS) .or. JC7_CODINS == Posicione("JCL",1,xFilial("JCL")+JC7_CODINS,"JCL_CODIGO")'	, 'Institui็ใo onde cursou a disciplina nใo cadastrada na tabela JCL.' } ) "
cProced += Chr(10) + "      if x.JC7_CODINS <> ' ' then "
cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("JCL")+" "
cProced += Chr(10) + "          where JCL_FILIAL = '"+xFilial("JCL")+"' "
cProced += Chr(10) + "            and JCL_CODIGO = x.JC7_CODINS "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "
cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            cMsgErr := 'Institui็ใo onde cursou a disciplina nใo cadastrada na tabela JCL.'; "
cProced += Chr(10) + "            Grava_log( '32', cMsgFix || cMsgErr ); "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

cProced += Chr(10) + "      if cMsgErr is not null then "
cProced += Chr(10) + "         raise nErro1;"
cProced += Chr(10) + "      end if; "

//-- Insert na tabela JBE --- "
cProced += Chr(10) + "      if cKeyJBE <> x.JBE_NUMRA || x.JBE_CODCUR || x.JBE_PERLET || x.JBE_HABILI || x.JBE_TURMA then "
cProced += Chr(10) + "         cKeyJBE := x.JBE_NUMRA || x.JBE_CODCUR || x.JBE_PERLET || x.JBE_HABILI || x.JBE_TURMA; "

cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno  "
cProced += Chr(10) + "           from "+RetSQLName("JBE")+" "
cProced += Chr(10) + "          where JBE_FILIAL = '"+xFilial("JBE")+"' "
cProced += Chr(10) + "            and JBE_NUMRA  = x.JBE_NUMRA "
cProced += Chr(10) + "            and JBE_CODCUR = x.JBE_CODCUR "
cProced += Chr(10) + "            and JBE_PERLET = x.JBE_PERLET "
cProced += Chr(10) + "            and JBE_HABILI = x.JBE_HABILI "
cProced += Chr(10) + "            and JBE_TURMA  = x.JBE_TURMA "
cProced += Chr(10) + "            and D_E_L_E_T_ = ' '; "

cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            nLoop := 0; "
cProced += Chr(10) + "            while nLoop = 0 loop "
cProced += Chr(10) + "            begin "
cProced += Chr(10) + "               insert into "+RetSQLName("JBE")+" "
cProced += Chr(10) + "                (JBE_FILIAL,   JBE_NUMRA,    JBE_CODCUR,   JBE_PERLET,   JBE_HABILI,   JBE_TURMA,    JBE_TIPO,     JBE_ATIVO, "
cProced += Chr(10) + "                 JBE_SITUAC,   JBE_BOLETO,   JBE_DTMATR,   JBE_ANOLET,   JBE_PERIOD,   JBE_KITMAT,   JBE_DCOLAC, "
cProced += Chr(10) + "                 JBE_DTENC,    R_E_C_N_O_) "
cProced += Chr(10) + "               values "
cProced += Chr(10) + "                ('"+xFilial("JBE")+"',   x.JBE_NUMRA,  x.JBE_CODCUR, x.JBE_PERLET, x.JBE_HABILI, x.JBE_TURMA,  x.JBE_TIPO,   x.JBE_ATIVO, "
cProced += Chr(10) + "                 x.JBE_SITUAC, x.JBE_BOLETO, x.JBE_DTMATR, x.JBE_ANOLET, x.JBE_PERIOD, x.JBE_KITMAT, x.JBE_DCOLAC, "
cProced += Chr(10) + "                 x.JBE_DTENC,  "+RetSQLName("JBE")+"_RECNO.NextVal); "
cProced += Chr(10) + "	             nLoop := 1; "
cProced += Chr(10) + "            exception "
cProced += Chr(10) + "               when DUP_VAL_ON_INDEX then "
cProced += Chr(10) + "                    nLoop := 0; "
cProced += Chr(10) + "            end; "
cProced += Chr(10) + "            end loop; "
cProced += Chr(10) + "         elsif IN_OVER = 1 then "
cProced += Chr(10) + "            update "+RetSQLName("JBE")+" set  "
cProced += Chr(10) + "              JBE_TIPO = x.JBE_TIPO,     JBE_ATIVO  = x.JBE_ATIVO,  JBE_SITUAC = x.JBE_SITUAC, JBE_BOLETO = x.JBE_BOLETO,  "
cProced += Chr(10) + "              JBE_DTMATR = x.JBE_DTMATR, JBE_ANOLET = x.JBE_ANOLET, JBE_PERIOD = x.JBE_PERIOD, JBE_KITMAT = x.JBE_KITMAT, "
cProced += Chr(10) + "              JBE_DCOLAC = x.JBE_DCOLAC, JBE_DTENC  = x.JBE_DTENC "
cProced += Chr(10) + "             where R_E_C_N_O_ = nRecno; "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

//-- Insert na tabela JCO --- "
cProced += Chr(10) + "      if x.JC7_CODINS <> ' ' then "
cProced += Chr(10) + "         select Min( R_E_C_N_O_ ) into nRecno "
cProced += Chr(10) + "           from "+RetSQLName("JCO")+" "
cProced += Chr(10) + "          where JCO_FILIAL = '"+xFilial("JCO")+"' "
cProced += Chr(10) + "            and JCO_NUMRA  = x.JBE_NUMRA "
cProced += Chr(10) + "            and JCO_CODCUR = x.JBE_CODCUR  "
cProced += Chr(10) + "            and JCO_PERLET = x.JBE_PERLET "
cProced += Chr(10) + "            and JCO_HABILI = x.JBE_HABILI "
cProced += Chr(10) + "            and JCO_DISCIP = x.JC7_DISCIP; "
cProced += Chr(10) + "         if nRecno is null then "
cProced += Chr(10) + "            nLoop := 0; "
cProced += Chr(10) + "            while nLoop = 0 loop "
cProced += Chr(10) + "            begin "
cProced += Chr(10) + "               insert into "+RetSQLName("JCO")+" "
cProced += Chr(10) + "                (JCO_FILIAL,   JCO_NUMRA,    JCO_CODCUR,   JCO_PERLET,   JCO_HABILI, JCO_DISCIP,   JCO_MEDFIM,   JCO_MEDCON,    "
cProced += Chr(10) + "                 JCO_CODINS,   JCO_ANOINS,   R_E_C_N_O_ ) "
cProced += Chr(10) + "               values  "
cProced += Chr(10) + "                ('"+xFilial("JCO")+"',   x.JBE_NUMRA,  x.JBE_CODCUR, x.JBE_PERLET, x.JBE_HABILI, x.JC7_DISCIP, x.JC7_MEDFIM, x.JC7_MEDCON,  "
cProced += Chr(10) + "                 x.JC7_CODINS, x.JC7_ANOINS, "+RetSQLName("JCO")+"_RECNO.NextVal ); "
cProced += Chr(10) + "	             nLoop := 1; "
cProced += Chr(10) + "            exception "
cProced += Chr(10) + "               when DUP_VAL_ON_INDEX then "
cProced += Chr(10) + "                    nLoop := 0; "
cProced += Chr(10) + "            end; "
cProced += Chr(10) + "            end loop; "
cProced += Chr(10) + "         elsif IN_OVER = 1 then "
cProced += Chr(10) + "            update "+RetSQLName("JCO")+" set JCO_MEDFIM = x.JC7_MEDFIM, JCO_MEDCON = x.JC7_MEDCON,  "
cProced += Chr(10) + "                              JCO_CODINS = x.JC7_CODINS, JCO_ANOINS = x.JC7_ANOINS "
cProced += Chr(10) + "             where R_E_C_N_O_  = nRecno; "
cProced += Chr(10) + "         end if; "
cProced += Chr(10) + "      end if; "

//-- Insert na tabela JC7 --- "
cProced += Chr(10) + " 	     select Min( R_E_C_N_O_ ) into nRecno "
cProced += Chr(10) + "        from "+RetSQLName("JC7")+" "
cProced += Chr(10) + "       where JC7_FILIAL = '"+xFilial("JC7")+"' "
cProced += Chr(10) + "         and JC7_NUMRA  = x.JBE_NUMRA "
cProced += Chr(10) + "         and JC7_CODCUR = x.JBE_CODCUR "
cProced += Chr(10) + "         and JC7_PERLET = x.JBE_PERLET "
cProced += Chr(10) + "         and JC7_HABILI = x.JBE_HABILI "
cProced += Chr(10) + "         and JC7_TURMA  = x.JBE_TURMA "
cProced += Chr(10) + "         and JC7_DISCIP = x.JC7_DISCIP "
cProced += Chr(10) + "         and JC7_CODLOC = x.JC7_CODLOC "
cProced += Chr(10) + "         and JC7_CODPRE = x.JC7_CODPRE "
cProced += Chr(10) + "         and JC7_ANDAR  = x.JC7_ANDAR "
cProced += Chr(10) + "         and JC7_CODSAL = x.JC7_CODSAL "
cProced += Chr(10) + "         and JC7_DIASEM = x.JC7_DIASEM "
cProced += Chr(10) + "         and JC7_HORA1  = x.JC7_HORA1 "
cProced += Chr(10) + "         and JC7_OUTCUR = x.JC7_OUTCUR "
cProced += Chr(10) + "         and JC7_OUTPER = x.JC7_OUTPER "
cProced += Chr(10) + "         and JC7_OUTHAB = x.JC7_OUTHAB "
cProced += Chr(10) + "         and JC7_OUTTUR = x.JC7_OUTTUR "
cProced += Chr(10) + "         and D_E_L_E_T_ = ' '; "

cProced += Chr(10) + "      if nRecno is null then "
//cProced += Chr(10) + "         select Nvl( Max( R_E_C_N_O_ ), 0 )+1 into nRecno from "+RetSQLName("JC7")+"; "
cProced += Chr(10) + "         nLoop := 0; "
cProced += Chr(10) + "         while nLoop = 0 loop "
cProced += Chr(10) + "         begin "
cProced += Chr(10) + "            insert into "+RetSQLName("JC7")+" "
cProced += Chr(10) + "             (JC7_FILIAL,   JC7_NUMRA,    JC7_CODCUR,   JC7_PERLET,   JC7_HABILI,   JC7_TURMA,    JC7_DISCIP,   JC7_CODLOC,   JC7_CODPRE, "
cProced += Chr(10) + "              JC7_ANDAR,    JC7_CODSAL,   JC7_SITDIS,   JC7_SITUAC,   JC7_DIASEM,   JC7_CODHOR,   JC7_HORA1,    JC7_HORA2, "
cProced += Chr(10) + "              JC7_CODPRF,   JC7_CODPR2,   JC7_CODPR3,   JC7_CODPR4,   JC7_CODPR5,   JC7_CODPR6,   JC7_CODPR7,   JC7_CODPR8, "
cProced += Chr(10) + "              JC7_OUTCUR,   JC7_OUTPER,   JC7_OUTHAB,   JC7_OUTTUR,   JC7_MEDANT,   JC7_AMG,      JC7_MEDFIM,   JC7_DISDP,    JC7_SITDP, "
cProced += Chr(10) + "              JC7_DPBAIX,   JC7_CURDP,    JC7_PERDP,    JC7_HABDP,    JC7_TURDP,    JC7_CURORI,   JC7_PERORI,   JC7_HABORI,   JC7_TURORI,   JC7_DISORI, "
cProced += Chr(10) + "              JC7_SITORI,   JC7_MEDCON,   JC7_CODINS,   JC7_ANOINS,   R_E_C_N_O_) "
cProced += Chr(10) + "            values "
cProced += Chr(10) + "             ('"+xFilial("JC7")+"',   x.JBE_NUMRA,  x.JBE_CODCUR, x.JBE_PERLET, x.JBE_HABILI, x.JBE_TURMA,  x.JC7_DISCIP, x.JC7_CODLOC, x.JC7_CODPRE, "
cProced += Chr(10) + "              x.JC7_ANDAR,  x.JC7_CODSAL, x.JC7_SITDIS, x.JC7_SITUAC, x.JC7_DIASEM, x.JC7_CODHOR, x.JC7_HORA1,  x.JC7_HORA2, "
cProced += Chr(10) + "              x.JC7_CODPRF, x.JC7_CODPR2, x.JC7_CODPR3, x.JC7_CODPR4, x.JC7_CODPR5, x.JC7_CODPR6, x.JC7_CODPR7, x.JC7_CODPR8, "
cProced += Chr(10) + "              x.JC7_OUTCUR, x.JC7_OUTPER, x.JC7_OUTHAB, x.JC7_OUTTUR, x.JC7_MEDANT, x.JC7_AMG,    x.JC7_MEDFIM, x.JC7_DISDP,  x.JC7_SITDP, "
cProced += Chr(10) + "              x.JC7_DPBAIX, x.JC7_CURDP,  x.JC7_PERDP,  x.JC7_HABDP,  x.JC7_TURDP,  x.JC7_CURORI, x.JC7_PERORI, x.JC7_HABORI, x.JC7_TURORI, x.JC7_DISORI, "
cProced += Chr(10) + "              x.JC7_SITORI, x.JC7_MEDCON, x.JC7_CODINS, x.JC7_ANOINS, "+RetSQLName("JC7")+"_RECNO.NextVal ); "
cProced += Chr(10) + "            nLoop := 1; "
cProced += Chr(10) + "         exception "
cProced += Chr(10) + "            nLoop := 0; "
cProced += Chr(10) + "         end; "
cProced += Chr(10) + "         end loop; "
cProced += Chr(10) + "      elsif IN_OVER = 1 then "
cProced += Chr(10) + "         update "+RetSQLName("JC7")+" set "
cProced += Chr(10) + "            JC7_SITDIS = x.JC7_SITDIS, JC7_SITUAC = x.JC7_SITUAC, JC7_CODHOR = x.JC7_CODHOR, JC7_HORA2  = x.JC7_HORA2, "
cProced += Chr(10) + "            JC7_CODPRF = x.JC7_CODPRF, JC7_CODPR2 = x.JC7_CODPR2, JC7_CODPR3 = x.JC7_CODPR3, JC7_CODPR4 = x.JC7_CODPR4,  "
cProced += Chr(10) + "            JC7_CODPR5 = x.JC7_CODPR5, JC7_CODPR6 = x.JC7_CODPR6, JC7_CODPR7 = x.JC7_CODPR7, JC7_CODPR8 = x.JC7_CODPR8,  "
cProced += Chr(10) + "            JC7_MEDANT = x.JC7_MEDANT,    "
cProced += Chr(10) + "            JC7_AMG    = x.JC7_AMG,    JC7_MEDFIM = x.JC7_MEDFIM, JC7_DISDP  = x.JC7_DISDP,  JC7_SITDP  = x.JC7_SITDP, "
cProced += Chr(10) + "            JC7_DPBAIX = x.JC7_DPBAIX, JC7_CURDP  = x.JC7_CURDP,  JC7_PERDP  = x.JC7_PERDP,  JC7_HABDP  = x.JC7_HABDP,  JC7_TURDP  = x.JC7_TURDP,   "
cProced += Chr(10) + "            JC7_CURORI = x.JC7_CURORI, JC7_PERORI = x.JC7_PERORI, JC7_HABORI = x.JC7_HABORI, JC7_TURORI = x.JC7_TURORI, JC7_DISORI = x.JC7_DISORI, "
cProced += Chr(10) + "            JC7_SITORI = x.JC7_SITORI, JC7_MEDCON = x.JC7_MEDCON, JC7_CODINS = x.JC7_CODINS, JC7_ANOINS = x.JC7_ANOINS "
cProced += Chr(10) + "          where R_E_C_N_O_ = nRecno; "
cProced += Chr(10) + "      end if; "
cProced += Chr(10) + "   exception "
cProced += Chr(10) + "      when nErro1 then "
cProced += Chr(10) + "         OUT_REJECT := OUT_REJECT + 1;"
cProced += Chr(10) + "   end; "
cProced += Chr(10) + "   update IMP_STATUS set LASTREC = x.R_E_C_N_O_, HORA = sysdate where TIPO = '32' and THRD = IN_THRD; "
cProced += Chr(10) + "   nCommit := nCommit + 1; "
cProced += Chr(10) + "   if nCommit = IN_COMMIT or IN_COMMIT = 0 then "
cProced += Chr(10) + "      commit; "
cProced += Chr(10) + "      nCommit := 0; "
cProced += Chr(10) + "   end if; "
cProced += Chr(10) + "end loop; "
cProced += Chr(10) + "update IMP_STATUS set LASTREC = IN_MAX, HORA = sysdate where TIPO = '32' and THRD = IN_THRD; "
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
ฑฑบPrograma  ณxAC132SP  บAutor  ณRafael Rodrigues    บ Data ณ  11/17/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณThread para executar Stored Procedure no banco.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xAC132SP( aDados )
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
ฑฑบPrograma  ณxAC132WaitบAutor  ณRafael Rodrigues    บ Data ณ  11/16/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAC132Wait( cProcName, nRecs, nThreads, cLogFile, nCommit )
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
CreateSeq("JC7")
CreateSeq("JBE")
CreateSeq("JCO")

for i := 1 to nThreads
	if (i*nThrdSize)-nThrdSize+1 <= nRecs
		//if File( "xAC132SP."+StrZero(i,3) )
		//	FErase( "xAC132SP."+StrZero(i,3) )
		//endif
		//AcaLog( "xAC132SP."+StrZero(i,3), "Thread de importacao iniciada" )
		//U_xAC132SP( { SM0->M0_CODIGO, SM0->M0_CODFIL, cProcName, (i*nThrdSize)-nThrdSize+1 ,i*nThrdSize, lOver, "xAC132SP."+StrZero(i,3), cLogFile, i } )
		StartJob( "U_xAC132SP", GetEnvServer(), .F., { SM0->M0_CODIGO, SM0->M0_CODFIL, cProcName, (i*nThrdSize)-nThrdSize+1 ,i*nThrdSize, lOver, "xAC132SP."+StrZero(i,3), cLogFile, i, nCommit } )
		j++
	endif
next i

// Deixa i com o numero da proxima thread, se necessario
i := j + 1

if nOpc == 0
	ProcRegua( nRecs )
endif

// So inicia a checagem da IMP_STATUS quando todas as threads estiverem em operacao
cQuery := "select count(*) QUANT from IMP_STATUS where TIPO = '32'"
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
cQryStat := "select THRD, MINREC, MAXREC, LASTREC as LAST, ( ( LASTREC - MINREC ) + 1 ) AS PROCESSADO, ROUND( ( ( LASTREC - MINREC ) + 1 )/ ( ( MAXREC - MINREC ) - 1 ) * 100, 2) AS PERCENTUAL, To_Char( HORA, 'dd/mm/yyyy hh:mi:ss' ) as HORA from imp_status where TIPO = '32' order by HORA, THRD"
cQryOff  := "select THRD, MINREC, MAXREC, LASTREC as LAST from IMP_STATUS where TIPO = '32' and MAXREC > LASTREC and sysdate > ( HORA+(10/1440) )"
cQryTot  := "select sum( ( LASTREC - MINREC ) + 1 ) as TOTAL from IMP_STATUS where TIPO = '32'"

while !KillApp() .and. nTot < nRecs
	dbUseArea( .T., "TopConn", TCGenQry(,, ChangeQuery( cQryOff )), "QRY", .F., .F. )

	while QRY->( !eof() )
		if aScan( aThrdOff, QRY->THRD ) == 0 .and. len( aThrdOff ) < 50
			aAdd(  aThrdOff, QRY->THRD )
		
			AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '  Thread '+StrZero(QRY->THRD,3)+' nใo processa hแ mais de 10 minutos e pode ter sido terminada inesperadamente. Analise log do TopConnect para maiores detalhes. A thread '+StrZero(i,3)+' foi iniciada em substitui็ใo.' )
			StartJob( "U_xAC132SP", GetEnvServer(), .F., { SM0->M0_CODIGO, SM0->M0_CODFIL, cProcName, QRY->LAST+1 , QRY->MAXREC, lOver, "xAC132SP."+StrZero(i,3), cLogFile, i, nCommit } )
			i++
		elseif len( aThrdOff ) >= 50
			AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '  O n๚mero de threads terminadas inesperadamente atingiu 50. O processo serแ abortado. Analise o log do TopConnect para maiores informa็๕es.' )
			AcaLog( "Abort.log", "Os processos de notas e faltas nใo serใo iniciados em decorr๊ncia do cancelamento do processo de matrํculas." )
			QRY->( dbCloseArea() )
			Return .F.
		endif
		QRY->( dbSkip() )
	end
	QRY->( dbCloseArea() )
    
	if Len( aThrdOff ) > 0
	    varinfo("Threads",aThrdOff)
		cNotIn := " and THRD not in ("
		aEval( aThrdOff, {|x| cNotIn += "'"+x+"', " } )
		cNotIn := Left( cNotIn, len(cNotIn)-2 )+")"
	else
		cNotIn := " "
	endif
	
	// Controla o status da grava็ใo
	dbUseArea( .T., "TopConn", TCGenQry(,, ChangeQuery( cQryTot+cNotIn )), "QRY", .F., .F. )
	nTot := QRY->TOTAL
	QRY->( dbCloseArea() )

	// Atualiza relatorio de status das threads.
	//cQryStat := "select THRD, MINREC, MAXREC, LASTREC as LAST, ( LASTREC - MINREC + 1 ) AS PROCESSADO, ROUND( ( LASTREC - MINREC ) / ( MAXREC - MINREC ) * 100, 2) AS PERCENTUAL, To_Char( HORA, 'dd/mm/yyyy hh:mi:ss' ) as HORA from imp_status where TIPO = '32' order by HORA, THRD"
	
	dbUseArea( .T., "TopConn", TCGenQry(,, ChangeQuery( cQryStat )), "QRY", .F., .F. )
	AcaLog( "xRelat132.log", Repl("=",75) )
	AcaLog( "xRelat132.log", " " )
	AcaLog( "xRelat132.log", "Status das threads as "+Time()+" de "+dtoc(date()) )
	AcaLog( "xRelat132.log", " " )
	AcaLog( "xRelat132.log", "Thrd  MinRec    MaxRec    LastRec   Process.  Percent.  dd/mm/aaaa hh:mi:ss" )
	AcaLog( "xRelat132.log", "----  --------  --------  --------  --------  --------  -------------------" )
	while QRY->( !eof() )
		QRY->( AcaLog( "xRelat132.log", PadR( THRD, 4 ) + "  " + Transform( MINREC, "@E 99999999" ) + "  " + Transform( MAXREC, "@E 99999999" ) + "  " + Transform( LAST, "@E 99999999" ) + "  " + Transform( PROCESSADO, "@E 99999999" ) + "  " + Transform( PERCENTUAL, "@E 99999.99" ) + "  " + HORA ) )
		QRY->( dbSkip() )
	end
	AcaLog( "xRelat132.log", " " )
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
	AcaLog( 'xDebug32.log', dtoc(date())+" "+Time()+" - "+Alltrim(Str((nTot/nRecs)*100,6,2))+"% concluํdo..." )
	
	if nTickCount == 60	// 30 minutos
		nTickCount := 0
	endif
end

AcaLog( cLogFile, DtoC( Date() ) + ' - ' + Time() +  '  Todas as threads finalizadas.' )
// Elimina as sequencias do banco
DropSeq("JC7")
DropSeq("JBE")
DropSeq("JCO")


// Grava log's de rejeicao
i := 0
dbUseArea( .T., "TopConn", TCGenQry(,,ChangeQuery("Select * from IMP_LOG32")), "QRYLOG", .F., .F. )
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
ฑฑบPrograma  ณXAC13200  บAutor  ณMicrosiga           บ Data ณ  12/02/05   บฑฑ
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
ฑฑบPrograma  ณXAC13200  บAutor  ณMicrosiga           บ Data ณ  12/02/05   บฑฑ
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
