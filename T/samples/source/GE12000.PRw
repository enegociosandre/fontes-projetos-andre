#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12000   �Autor  �Rafael Rodrigues    � Data �  13/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Cursos Vigentes                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE12000()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC12000.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local cIDX03	:= CriaTrab( nil, .F. )
Local cIDX04	:= CriaTrab( nil, .F. )
Local lDBF01	:= .F.
Local lDBF02	:= .F.
Local lDBF03	:= .F.
Local lDBF04	:= .F.
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JAH_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAH_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAH_CODIGO", "C", 006, 0 } )
aAdd( aStru, { "JAH_DESC"  , "C", 050, 0 } )
aAdd( aStru, { "JAH_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAH_TURNO" , "C", 003, 0 } )
aAdd( aStru, { "JAH_GRPDOC", "C", 006, 0 } )
aAdd( aStru, { "JAH_TIPO"  , "C", 003, 0 } )
aAdd( aStru, { "JAH_TEMPOJ", "N", 002, 0 } )
aAdd( aStru, { "JAH_QTDTRA", "N", 002, 0 } )
aAdd( aStru, { "JAH_STATUS", "C", 001, 0 } )
aAdd( aStru, { "JAH_GRUPO" , "C", 003, 0 } )
aAdd( aStru, { "JAH_UNIDAD", "C", 006, 0 } )
aAdd( aStru, { "JAH_VALOR" , "C", 001, 0 } )
aAdd( aStru, { "JAH_PRCSEL", "C", 001, 0 } )
aAdd( aStru, { "JAH_MATSEQ", "C", 001, 0 } )
aAdd( aStru, { "JAR_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAR_DPERLE", "C", 030, 0 } )
aAdd( aStru, { "JAR_DATA1" , "D", 008, 0 } )
aAdd( aStru, { "JAR_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JAR_ANOLET", "C", 004, 0 } )
aAdd( aStru, { "JAR_PERIOD", "C", 002, 0 } )
aAdd( aStru, { "JAR_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAR_DPMAX" , "N", 002, 0 } )
aAdd( aStru, { "JAR_ALTGRA", "C", 001, 0 } )
aAdd( aStru, { "JAR_DTMAT1", "D", 008, 0 } )
aAdd( aStru, { "JAR_DTMAT2", "D", 008, 0 } )
aAdd( aStru, { "JAR_MEDAPR", "N", 005, 2 } )
aAdd( aStru, { "JAR_EXAME" , "C", 001, 0 } )
aAdd( aStru, { "JAR_DEPREP", "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA1" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA2" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA3" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA4" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA5" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA6" , "C", 001, 0 } )
aAdd( aStru, { "JAR_AULA7" , "C", 001, 0 } )
aAdd( aStru, { "JAR_QTDVAG", "N", 004, 0 } )
aAdd( aStru, { "JAR_QTDRES", "N", 004, 0 } )
aAdd( aStru, { "JAR_QTDMAT", "N", 004, 0 } )
aAdd( aStru, { "JAR_QTDLIV", "N", 004, 0 } )
aAdd( aStru, { "JAR_TRANSF", "N", 004, 0 } )
aAdd( aStru, { "JAR_CALACA", "C", 010, 0 } )
aAdd( aStru, { "JAR_PERPRE", "C", 001, 0 } )
aAdd( aStru, { "JAR_APFALT", "C", 001, 0 } )
aAdd( aStru, { "JAR_FALTAS", "C", 001, 0 } )
aAdd( aStru, { "JAR_FRQMIN", "N", 003, 0 } )
aAdd( aStru, { "JAR_MAXDIS", "N", 002, 0 } )
aAdd( aStru, { "JAR_NOTMIN", "N", 005, 2 } )
aAdd( aStru, { "JAR_CRIAVA", "C", 001, 0 } )
aAdd( aStru, { "JAR_EQVCON", "C", 006, 0 } )

aAdd( aFiles, { 'Cursos Vigentes', '\Import\AC12001.TXT', aClone( aStru ), 'TRB01', .F. } )

aStru := {}

aAdd( aStru, { "JAH_CODIGO", "C", 015, 0 } )
aAdd( aStru, { "JAH_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAH_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Escopos', '\Import\AC12002.TXT', aClone( aStru ), 'TRB02', .F. } )

aStru := {}

aAdd( aStru, { "JAH_CODIGO", "C", 015, 0 } )
aAdd( aStru, { "JAH_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAH_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Observa��es', '\Import\AC12003.TXT', aClone( aStru ), 'TRB03', .F. } )

aStru := {}

aAdd( aStru, { "JAH_CODIGO", "C", 015, 0 } )
aAdd( aStru, { "JAH_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAH_MEMO3" , "C", 080, 0 } )

aAdd( aFiles, { 'Atos legais', '\Import\AC12004.TXT', aClone( aStru ), 'TRB04', .F. } )

//����������������������������������������������������������������������Ŀ
//�Executa a janela para selecao de arquivos e importacao dos temporarios�
//������������������������������������������������������������������������
aTables	:= U_GEGetF( aFiles, @lForceLog )

if Empty( aTables )	//Nenhum arquivo importado.
	U_xAddLog( cLog, '  Nenhum arquivo p�de ser importado para este processo.', if( lForceLog, cLogFile, nil ) )
	Aviso( 'Problema', 'Nenhum arquivo p�de ser importado para este processo.', {'Ok'} )
else
	
	lDBF01	:= aScan( aTables, {|x| x[1] == "TRB01"} ) > 0
	lDBF02	:= aScan( aTables, {|x| x[1] == "TRB02"} ) > 0
	lDBF03	:= aScan( aTables, {|x| x[1] == "TRB03"} ) > 0
	lDBF04	:= aScan( aTables, {|x| x[1] == "TRB04"} ) > 0

	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	if lDBF01
		TRB01->( dbGoBottom() )
		if Empty( TRB01->JAH_CODIGO )
			RecLock( "TRB01", .F. )
			TRB01->( dbDelete() )
			TRB01->( msUnlock() )
		endif
	endif

	if lDBF02
		TRB02->( dbGoBottom() )
		if Empty( TRB02->JAH_CODIGO )
			RecLock( "TRB02", .F. )
			TRB02->( dbDelete() )
			TRB02->( msUnlock() )
		endif
	endif

	if lDBF03
		TRB03->( dbGoBottom() )
		if Empty( TRB03->JAH_CODIGO )
			RecLock( "TRB03", .F. )
			TRB03->( dbDelete() )
			TRB03->( msUnlock() )
		endif
	endif

	if lDBF04
		TRB04->( dbGoBottom() )
		if Empty( TRB04->JAH_CODIGO )
			RecLock( "TRB04", .F. )
			TRB04->( dbDelete() )
			TRB04->( msUnlock() )
		endif
	endif

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	MsgRun( 'Ordenando arquivos...',, {||	if( lDBF01, IndRegua( "TRB01", cIDX01, "JAH_CODIGO+JAR_PERLET+JAH_CURSO+JAH_VERSAO" ), NIL ),;
											if( lDBF02, IndRegua( "TRB02", cIDX02, "JAH_CODIGO+JAH_SEQ" ), NIL ),;
											if( lDBF03, IndRegua( "TRB03", cIDX03, "JAH_CODIGO+JAH_SEQ" ), NIL ),;
											if( lDBF04, IndRegua( "TRB04", cIDX04, "JAH_CODIGO+JAH_SEQ" ), NIL ) } )

	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	if lDBF01
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAH_CURSO)  '	, 'C�digo do curso padr�o n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAH_VERSAO) '	, 'Vers�o do curso padr�o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAH_CODIGO) '	, 'C�digo do curso vigente n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAH_DESC)   '	, 'Descri��o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAH_CARGA)  '	, 'Carga Hor�ria n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAH_TURNO)  '	, 'Carga Hor�ria n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAH_GRPDOC) '	, 'Grupo de documentos n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAH_GRUPO)  '	, 'Grupo de cursos n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAH_UNIDAD) '	, 'Unidade n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAR_PERLET) '	, 'Per�odo letivo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAR_DPERLE) '	, 'Descri��o do per�odo letivo n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAR_DATA1)  '	, 'Data in�cial do per�odo letivo n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAR_DATA2)  '	, 'Data final do per�odo letivo n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAR_CARGA)  '	, 'Carga hor�ria do per�odo letivo n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAR_DTMAT1) '	, 'Data de matr�cula in�cial do per�odo letivo n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAR_DTMAT2) '	, 'Data de matr�cula final do per�odo letivo n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAR_MEDAPR) '	, 'Media de aprova��o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAR_QTDVAG) '	, 'Quantidade de vagas do per�odo letivo n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAR_CALACA) '	, 'Calend�rio acad�mico n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAR_FRQMIN) '	, 'Frequ�ncia m�nima n�o informada.' } )
		aAdd( aObrig, { 'JAH_TIPO$"001^002" '	, 'Tipo deve ser 001 (Normal) ou 002 (Depend�ncia).' } )
		aAdd( aObrig, { 'JAH_STATUS$"12"'		, 'Status deve ser 1 (Em Aberto) ou 2 (Encerrado).' } )
		aAdd( aObrig, { 'JAH_VALOR$"12"'		, '"Possui valor?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAH_PRCSEL$"12"'		, '"Requer processo seletivo?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAH_MATSEQ$"12"'		, '"Matr�cula sequencial?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAR_ALTGRA$"12"'		, '"Altera grade?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAR_EXAME$"12"'		, '"Possui exame?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAR_DEPREP$"12"'		, '"DP ou Reprova?" deve ser 1 (DP) ou 2 (Reprova).' } )
		aAdd( aObrig, { 'JAR_AULA1$"12"'		, '"Aula Domingo?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAR_AULA2$"12"'		, '"Aula Segunda?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAR_AULA3$"12"'		, '"Aula Ter�a?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAR_AULA4$"12"'		, '"Aula Quarta?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAR_AULA5$"12"'		, '"Aula Quinta?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAR_AULA6$"12"'		, '"Aula Sexta?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAR_AULA7$"12"'		, '"Aula S�bado?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAR_PERPRE$"12"'		, '"Per�odo previsto?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAR_APFALT$"123"'		, 'Tipo de apontamento de faltas deve ser 1 (Di�rio), 2 (Mensal) ou 3 (Per�odo Letivo).' } )
		aAdd( aObrig, { 'JAR_FALTAS$"12"'		, 'Tipo de faltas deve ser 1 (Disciplina) ou 2 (Curso).' } )
		aAdd( aObrig, { 'JAR_CRIAVA$"12"'		, 'Crit�rio de avalia��o deve ser 1 (Nota) ou 2 (Conceito).' } )
		aAdd( aObrig, { 'Len(Alltrim(JAR_ANOLET)) == 4'	, 'Ano civil do per�odo letivo deve ser informado com 4 d�gitos.' } )
		aAdd( aObrig, { 'Len(Alltrim(JAR_PERIOD)) == 2'	, 'Per�odo do ano civil deve ser informado com 2 d�gitos.' } )
		aAdd( aObrig, { 'JAR_ANOLET == StrZero( Year( JAR_DATA1 ), 4 )'	, 'Data in�cial do per�odo letivo n�o confere com o ano letivo informado.' } )
		aAdd( aObrig, { 'JAH_CURSO == Posicione( "JAF", 1, xFilial("JAF")+JAH_CURSO+JAH_VERSAO, "JAF_COD" )', 'Curso padr�o/vers�o n�o cadastrados na tabela JAF.' } )
		aAdd( aObrig, { 'JAH_TURNO == Left( Posicione( "SX5", 1, xFilial("SX5")+"F5"+JAH_TURNO, "X5_CHAVE" ), Len( JAH_TURNO ) )', 'Turno n�o cadastrado na sub-tabela F5 da tabela SX5.' } )
		aAdd( aObrig, { 'JAH_GRPDOC == Posicione( "JAK", 1, xFilial("JAK")+JAH_GRPDOC, "JAK_CODIGO" )', 'Grupo de documentos n�o cadastrado na tabela JAK.' } )
		aAdd( aObrig, { 'JAH_GRUPO == Left( Posicione( "SX5", 1, xFilial("SX5")+"FC"+JAH_GRUPO, "X5_CHAVE" ), Len( JAH_GRUPO ) )', 'Grupo n�o cadastrado na sub-tabela FC da tabela SX5.' } )
		aAdd( aObrig, { 'JAH_UNIDAD == Posicione( "JA3", 1, xFilial("JA3")+JAH_UNIDAD, "JA3_CODLOC" )', 'Unidade n�o cadastrada na tabela JA3.' } )
		aAdd( aObrig, { 'JAR_CRIAVA == "1" .or. !Empty(JAR_EQVCON)'	, 'Tabela de equival�ncia de conceitos deve ser informado quando crit�rio de avalia��o for conceito.' } )
		aAdd( aObrig, { 'JAR_PERLET == Posicione( "JAW", 1, xFilial("JAW")+JAH_CURSO+JAH_VERSAO+JAR_PERLET, "JAW_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAW.' } )
		aAdd( aObrig, { 'JAR_DATA1 <= JAR_DATA2', 'Data inicial do per�odo letivo deve ser menor ou igual � data final.' } )
		aAdd( aObrig, { 'JAR_DTMAT1 <= JAR_DTMAT2', 'Data inicial de matr�cula do per�odo letivo deve ser menor ou igual � data final.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB01", "JAH_CODIGO+JAR_PERLET", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk, lOk := U_GE120PL( @lEnd, cLog, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[1,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF02
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAH_CODIGO) '	, 'C�digo do curso vigente n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAH_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAH_CODIGO == Posicione( "JAH", 1, xFilial("JAH")+JAH_CODIGO, "JAH_CODIGO" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB02->JAH_CODIGO, .F. ) ) )'	, 'Curso vigente n�o cadastrado na tabela JAH e n�o presente nos arquivos de importa��o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB02", "JAH_CODIGO+JAH_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[2,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF03
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAH_CODIGO) '	, 'C�digo do curso vigente n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAH_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAH_CODIGO == Posicione( "JAH", 1, xFilial("JAH")+JAH_CODIGO, "JAH_CODIGO" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB03->JAH_CODIGO, .F. ) ) )'	, 'Curso vigente n�o cadastrado na tabela JAH e n�o presente nos arquivos de importa��o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB03", "JAH_CODIGO+JAH_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[3,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	


	if lDBF04
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAH_CODIGO) '	, 'C�digo do curso vigente n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAH_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAH_CODIGO == Posicione( "JAH", 1, xFilial("JAH")+JAH_CODIGO, "JAH_CODIGO" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB04->JAH_CODIGO, .F. ) ) )'	, 'Curso vigente n�o cadastrado na tabela JAH e n�o presente nos arquivos de importa��o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[4,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB04", "JAH_CODIGO+JAH_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[4,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[4,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if !lOk
		U_xAddLog( cLog, '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.', if( lForceLog, cLogFile, nil ) )
		if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			U_xSaveLog( cLog, 'c:\'+cLogFile )
			WinExec( 'Notepad.exe c:\'+cLogFile )
		endif
	else

		nRecs += if( lDBF01, TRB01->( RecCount() ), 0 )
		nRecs += if( lDBF02, TRB02->( RecCount() ), 0 )
		nRecs += if( lDBF03, TRB03->( RecCount() ), 0 )
		nRecs += if( lDBF04, TRB04->( RecCount() ), 0 )

		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := GE12001Grv( @lEnd, aFiles[1,1] ) .and. GE12002Grv( @lEnd, aFiles[2,1] ) .and. GE12003Grv( @lEnd, aFiles[3,1] ) .and. GE12004Grv( @lEnd, aFiles[4,1] ) }, 'Grava��o em andamento' )
		
		if !lOk
			U_xAddLog( cLog, '! Processo de grava��o interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Opera��o Cancelada!', 'O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', {'Ok'} )
		else
			U_xAddLog( cLog, '! Grava��o realizada com sucesso.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Sucesso!', 'Importa��o realizada com sucesso.', {'Ok'} )
		endif
	endif
	
	FErase( cIDX01 + OrdBagExt() )
	FErase( cIDX02 + OrdBagExt() )
	FErase( cIDX03 + OrdBagExt() )
	FErase( cIDX04 + OrdBagExt() )
	
endif

U_xSaveLog( cLog, cLogFile )
U_xKillLog( cLog )

//���������������������������������������Ŀ
//�Elimina os arquivos de trabalho criados�
//�����������������������������������������
for i := 1 to len( aTables )
	dbSelectArea( aTables[i][1] )
	dbCloseArea()
	FErase( aTables[i][2]+GetDBExtension() )
next i

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12001Grv �Autor  �Rafael Rodrigues   � Data �  13/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados do arquivo principal na base.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12000                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12001Grv( lEnd, cTitulo )
Local cFilJAH	:= xFilial("JAH")	// Criada para ganhar performance
Local cFilJAR	:= xFilial("JAR")	// Criada para ganhar performance
Local cCurso	:= ""
Local i			:= 0

if Select( "TRB01" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB01->( dbGoTop() )

JAH->( dbSetOrder(1) )
JAR->( dbSetOrder(1) )

while TRB01->( !eof() ) .and. !lEnd
	
	IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB01->( RecCount() ), 6 )+'...' )
	
	begin transaction
	
	if cCurso <> TRB01->JAH_CODIGO
		RecLock( "JAH", JAH->( !dbSeek( cFilJAH+TRB01->JAH_CODIGO ) ) )
		JAH->JAH_FILIAL	:= cFilJAH
		JAH->JAH_CURSO	:= TRB01->JAH_CURSO
		JAH->JAH_VERSAO	:= TRB01->JAH_VERSAO
		JAH->JAH_CODIGO	:= TRB01->JAH_CODIGO
		JAH->JAH_DESC	:= TRB01->JAH_DESC
		JAH->JAH_CARGA	:= TRB01->JAH_CARGA
		JAH->JAH_TURNO	:= TRB01->JAH_TURNO
		JAH->JAH_GRPDOC	:= TRB01->JAH_GRPDOC
		JAH->JAH_TIPO	:= TRB01->JAH_TIPO
		JAH->JAH_TEMPOJ	:= TRB01->JAH_TEMPOJ
		JAH->JAH_QTDTRA	:= TRB01->JAH_QTDTRA
		JAH->JAH_STATUS	:= TRB01->JAH_STATUS
		JAH->JAH_GRUPO	:= TRB01->JAH_GRUPO
		JAH->JAH_UNIDAD	:= TRB01->JAH_UNIDAD
		JAH->JAH_VALOR	:= TRB01->JAH_VALOR
		JAH->JAH_PRCSEL	:= TRB01->JAH_PRCSEL
		JAH->JAH_MATSEQ	:= TRB01->JAH_MATSEQ
		JAH->( msUnlock() )
		
		cCurso := TRB01->JAH_CODIGO
	endif
	
	RecLock( "JAR", JAR->( !dbSeek( cFilJAR+TRB01->JAH_CODIGO+TRB01->JAR_PERLET ) ) )
	JAR->JAR_FILIAL	:= cFilJAR
	JAR->JAR_CODCUR	:= TRB01->JAH_CODIGO
	JAR->JAR_PERLET	:= TRB01->JAR_PERLET
	JAR->JAR_DPERLE	:= TRB01->JAR_DPERLE
	JAR->JAR_DATA1	:= TRB01->JAR_DATA1
	JAR->JAR_DATA2	:= TRB01->JAR_DATA2
	JAR->JAR_ANOLET	:= TRB01->JAR_ANOLET
	JAR->JAR_PERIOD	:= TRB01->JAR_PERIOD
	JAR->JAR_CARGA	:= TRB01->JAR_CARGA
	JAR->JAR_DPMAX	:= TRB01->JAR_DPMAX
	JAR->JAR_ALTGRA	:= TRB01->JAR_ALTGRA
	JAR->JAR_DTMAT1	:= TRB01->JAR_DTMAT1
	JAR->JAR_DTMAT2	:= TRB01->JAR_DTMAT2
	JAR->JAR_MEDAPR	:= TRB01->JAR_MEDAPR
	JAR->JAR_EXAME	:= TRB01->JAR_EXAME
	JAR->JAR_DEPREP	:= TRB01->JAR_DEPREP
	JAR->JAR_AULA1	:= TRB01->JAR_AULA1
	JAR->JAR_AULA2	:= TRB01->JAR_AULA2
	JAR->JAR_AULA3	:= TRB01->JAR_AULA3
	JAR->JAR_AULA4	:= TRB01->JAR_AULA4
	JAR->JAR_AULA5	:= TRB01->JAR_AULA5
	JAR->JAR_AULA6	:= TRB01->JAR_AULA6
	JAR->JAR_AULA7	:= TRB01->JAR_AULA7
	JAR->JAR_QTDVAG	:= TRB01->JAR_QTDVAG
	JAR->JAR_QTDRES	:= TRB01->JAR_QTDRES
	JAR->JAR_QTDMAT	:= TRB01->JAR_QTDMAT
	JAR->JAR_QTDLIV	:= TRB01->JAR_QTDLIV
	JAR->JAR_TRANSF	:= TRB01->JAR_TRANSF
	JAR->JAR_CALACA	:= TRB01->JAR_CALACA
	JAR->JAR_PERPRE	:= TRB01->JAR_PERPRE
	JAR->JAR_APFALT	:= TRB01->JAR_APFALT
	JAR->JAR_FALTAS	:= TRB01->JAR_FALTAS
	JAR->JAR_FRQMIN	:= TRB01->JAR_FRQMIN
	JAR->JAR_MAXDIS	:= TRB01->JAR_MAXDIS
	JAR->JAR_NOTMIN	:= TRB01->JAR_NOTMIN
	JAR->JAR_CRIAVA	:= TRB01->JAR_CRIAVA
	JAR->JAR_EQVCON	:= TRB01->JAR_EQVCON
	JAR->( msUnlock() )
		
	end transaction

	TRB01->( dbSkip() )
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12002Grv �Autor  �Rafael Rodrigues   � Data �  13/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12000                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12002Grv( lEnd, cTitulo )
Local cFilJAH	:= xFilial("JAH")	// Criada para ganhar performance
Local i			:= 0
Local cCurso
Local cMemo

if Select( "TRB02" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB02->( dbGoTop() )

JAH->( dbSetOrder(1) )

while TRB02->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cCurso	:= TRB02->JAH_CODIGO
	
	while cCurso == TRB02->JAH_CODIGO .and. TRB02->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB02->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB02->JAH_MEMO1, '\13\10', CRLF )
		
		TRB02->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAH->( dbSeek( cFilJAH+cCurso ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAH_ESCOPO�
		//�e armazena o codigo do memo no campo JAH_MEMO1. Sobrescreve caso JAH_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAH", .F. )
		MSMM( JAH->JAH_MEMO1, TamSX3("JAH_ESCOPO")[1],, cMemo, 1,,, "JAH", "JAH_MEMO1" )
		JAH->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12003Grv �Autor  �Rafael Rodrigues   � Data �  13/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12000                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12003Grv( lEnd, cTitulo )
Local cFilJAH	:= xFilial("JAH")	// Criada para ganhar performance
Local i			:= 0
Local cCurso
Local cMemo

if Select( "TRB03" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB03->( dbGoTop() )

JAH->( dbSetOrder(1) )

while TRB03->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cCurso	:= TRB03->JAH_CODIGO
	
	while cCurso == TRB03->JAH_CODIGO .and. TRB03->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB03->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB03->JAH_MEMO2, '\13\10', CRLF )
		
		TRB03->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAH->( dbSeek( cFilJAH+cCurso ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAH_PREREQ�
		//�e armazena o codigo do memo no campo JAH_MEMO2. Sobrescreve caso JAH_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAH", .F. )
		MSMM( JAH->JAH_MEMO2, TamSX3("JAH_PREREQ")[1],, cMemo, 1,,, "JAH", "JAH_MEMO2" )
		JAH->( msUnlock() )

		end transaction
	endif

end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12004Grv �Autor  �Rafael Rodrigues   � Data �  13/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12000                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12004Grv( lEnd, cTitulo )
Local cFilJAH	:= xFilial("JAH")	// Criada para ganhar performance
Local i			:= 0
Local cCurso
Local cMemo

if Select( "TRB04" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB04->( dbGoTop() )

JAH->( dbSetOrder(1) )

while TRB04->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cCurso	:= TRB04->JAH_CODIGO
	
	while cCurso == TRB04->JAH_CODIGO .and. TRB04->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB04->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB04->JAH_MEMO3, '\13\10', CRLF )
		
		TRB04->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAH->( dbSeek( cFilJAH+cCurso ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAH_DECRET�
		//�e armazena o codigo do memo no campo JAH_MEMO3. Sobrescreve caso JAH_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAH", .F. )
		MSMM( JAH->JAH_MEMO3, TamSX3("JAH_DECRET")[1],, cMemo, 1,,, "JAH", "JAH_MEMO3" )
		JAH->( msUnlock() )

		end transaction
	endif

end

Return !lEnd

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE120CH   �Autor  �Rafael Rodrigues    � Data �  13/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida se todos os periodos letivos do curso padrao constam ���
���          �no curso vigente. Eh obrigatorio informar todos os periodos ���
���          �letivos no momento do cadastramento do curso vigente.       ���
�������������������������������������������������������������������������͹��
���Uso       �GE12000                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE120PL( lEnd, cLog, cLogFile )
Local lRet		:= .T.
Local cChave	:= ""
Local nLinha	:= 0
Local lLog		:= cLog <> NIL
Local cPeriod	:= ""
Local cCurPad	:= ""
Local dData

JAW->( dbSetOrder(1) )

TRB01->( dbGoTop() )

ProcRegua( TRB01->( RecCount() ) )
IncProc( 'Verificando os per�odos do curso '+Alltrim( TRB01->JAH_CODIGO )+'...' )

while TRB01->( !eof() ) .and. !lEnd .and. ( lLog .or. lRet )

	cChave	:= TRB01->JAH_CODIGO
	nLinha	:= TRB01->( Recno() )
	cCurPad	:= TRB01->JAH_CURSO+TRB01->JAH_VERSAO

	JAW->( dbSeek( xFilial("JAW")+TRB01->JAH_CURSO+TRB01->JAH_VERSAO ) )
	
	while JAW->( !eof() ) .and. JAW->JAW_FILIAL+JAW->JAW_CURSO+JAW->JAW_VERSAO == xFilial("JAW")+cCurPad .and. !lEnd .and. ( lLog .or. lRet )
		if TRB01->( !dbSeek( cChave+JAW->JAW_PERLET ) )
			lRet := .F.
			if lLog
				U_xAddLog( cLog, '  Inconsist�ncia na linha '+StrZero( nLinha, 6 )+': Per�odo letivo '+JAW->JAW_PERLET+' do curso vigente '+Alltrim(cChave)+' n�o encontrado no arquivo de importa��o.', cLogFile )
			else
				exit
			endif
		endif
		JAW->( dbSkip() )
	end
	
	if !lRet .and. !lLog
		exit
	endif

	//���������������������������������������Ŀ
	//�Verifica datas de periodos conflitantes�
	//�����������������������������������������
	TRB01->( dbGoTo( nLinha ) )
	dData	:= TRB01->JAR_DATA1 - 1
	while TRB01->( !eof() ) .and. TRB01->JAH_CODIGO == cChave .and. ( lRet .or. lLog )
		IncProc( 'Verificando os per�odos do curso '+Alltrim( TRB01->JAH_CODIGO )+'...' )

		if TRB01->JAR_DATA1 <= dData
			lRet := .F.
			if lLog
				U_xAddLog( cLog, '  Inconsist�ncia na linha '+StrZero( TRB01->( Recno() ), 6 )+': As datas dos per�odos letivos '+cPeriod+' e '+TRB01->JAR_PERLET+' do curso vigente '+Alltrim(cChave)+' est�o conflitantes.', cLogFile )
			else
				exit
			endif
		endif
		
		if cCurPad <> TRB01->JAH_CURSO+TRB01->JAH_VERSAO
			lRet := .F.
			if lLog
				U_xAddLog( cLog, '  Inconsist�ncia na linha '+StrZero( TRB01->( Recno() ), 6 )+': Existe mais de um curso padr�o/vers�o associados ao curso vigente '+Alltrim(cChave)+'.', cLogFile )
			else
				exit
			endif
		endif
		
		dData	:= TRB01->JAR_DATA2
		cPeriod	:= TRB01->JAR_PERLET
		TRB01->( dbSkip() )
	end
end

lRet := lRet .and. !lEnd

Return lRet