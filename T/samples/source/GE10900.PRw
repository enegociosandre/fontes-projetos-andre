#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE10900   �Autor  �Rafael Rodrigues    � Data �  12/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Grade Curricular do Curso Padrao      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE10900()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC10900.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local cIDX03	:= CriaTrab( nil, .F. )
Local lDBF01	:= .F.
Local lDBF02	:= .F.
Local lDBF03	:= .F.
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JAY_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAY_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAY_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAY_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAY_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAY_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JAY_FRQMIN", "N", 003, 0 } )
aAdd( aStru, { "JAY_QTDFAT", "N", 003, 0 } )
aAdd( aStru, { "JAY_VALOR" , "N", 012, 2 } )
aAdd( aStru, { "JAY_CONSDP", "C", 001, 0 } )
aAdd( aStru, { "JAY_STATUS", "C", 001, 0 } )

aAdd( aFiles, { 'Grades Curr. dos Cursos', '\Import\AC10901.TXT', aClone( aStru ), 'TRB01', .F. } )

aStru := {}

aAdd( aStru, { "JAY_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAY_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAY_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAY_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAY_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAY_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Conte�dos das Grades', '\Import\AC10902.TXT', aClone( aStru ), 'TRB02', .F. } )

aStru := {}

aAdd( aStru, { "JAY_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAY_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAY_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAY_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAY_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAY_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Bibliografias das Grades', '\Import\AC10903.TXT', aClone( aStru ), 'TRB03', .F. } )

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

	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	if lDBF01
		TRB01->( dbGoBottom() )
		if Empty( TRB01->JAY_CURSO )
			RecLock( "TRB01", .F. )
			TRB01->( dbDelete() )
			TRB01->( msUnlock() )
		endif
	endif

	if lDBF02
		TRB02->( dbGoBottom() )
		if Empty( TRB02->JAY_CURSO )
			RecLock( "TRB02", .F. )
			TRB02->( dbDelete() )
			TRB02->( msUnlock() )
		endif
	endif
	
	if lDBF03
		TRB03->( dbGoBottom() )
		if Empty( TRB03->JAY_CURSO )
			RecLock( "TRB03", .F. )
			TRB03->( dbDelete() )
			TRB03->( msUnlock() )
		endif
	endif

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	MsgRun( 'Ordenando arquivos...',, {||	if( lDBF01, IndRegua( "TRB01", cIDX01, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS" ), NIL ),;
											if( lDBF02, IndRegua( "TRB02", cIDX02, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS+JAY_SEQ" ), NIL ),;
											if( lDBF02, IndRegua( "TRB03", cIDX03, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS+JAY_SEQ" ), NIL ) } )

	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	if lDBF01
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAY_CURSO)  '	, 'Curso n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAY_VERSAO) '	, 'Vers�o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_PERLET) '	, 'Per�odo letivo �o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_CODDIS) '	, 'Disciplina n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_CARGA)  '	, 'Carga hor�ria n�o informada.' } )
		aAdd( aObrig, { 'JAY_TIPO$"12"' 		, 'Tipo deve ser 1 (Obrigat�rio) ou 2 (Optativo).' } )
		aAdd( aObrig, { '!Empty(JAY_FRQMIN)'	, 'Frequ�ncia m�nima n�o informada.' } )
		aAdd( aObrig, { 'JAY_CONSDP$"12"' 		, '"Considera DP na Quantidade M�xima" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAY_STATUS$"12"' 		, 'Tipo na grade deve ser 1 (Obrigat�rio) ou 2 (Optativo).' } )
		aAdd( aObrig, { 'JAY_CURSO == Posicione( "JAF", 1, xFilial("JAF")+JAY_CURSO+JAY_VERSAO, "JAF_COD" )', 'Curso/Vers�o n�o cadastrado na tabela JAF.' } )
		aAdd( aObrig, { 'JAY_PERLET == Posicione( "JAW", 1, xFilial("JAW")+JAY_CURSO+JAY_VERSAO+JAY_PERLET, "JAW_PERLET" )'	, 'Per�odo Letivo n�o cadastrado na tabela JAW.' } )
		aAdd( aObrig, { 'JAY_CODDIS == Posicione( "JAE", 1, xFilial("JAE")+JAY_CODDIS, "JAE_CODIGO" )'	, 'Disciplina n�o cadastrada na tabela JAE.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB01", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk, lOk := U_GE109CH( @lEnd, cLog, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[1,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF02
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAY_CURSO)  '	, 'C�digo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAY_VERSAO) '	, 'Vers�o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_PERLET) '	, 'Per�odo letivo �o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_CODDIS) '	, 'Disciplina n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAY_CURSO == Posicione( "JAY", 1, xFilial("JAY")+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS, "JAY_CURSO" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB02->JAY_CURSO+TRB02->JAY_VERSAO+TRB02->JAY_PERLET+TRB02->JAY_CODDIS, .F. ) ) )', 'Grade curricular n�o cadastrada na tabela JAY e n�o presente nos arquivos de importa��o.' } )
		
		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB02", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS+JAY_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[2,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF03
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAY_CURSO)  '	, 'C�digo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAY_VERSAO) '	, 'Vers�o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_PERLET) '	, 'Per�odo letivo �o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_CODDIS) '	, 'Disciplina n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAY_CURSO == Posicione( "JAY", 1, xFilial("JAY")+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS, "JAY_CURSO" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB03->JAY_CURSO+TRB03->JAY_VERSAO+TRB03->JAY_PERLET+TRB03->JAY_CODDIS, .F. ) ) )', 'Grade curricular n�o cadastrada na tabela JAY e n�o presente nos arquivos de importa��o.' } )
		
		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB03", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_CODDIS+JAY_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[3,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
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

		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := GE10901Grv( @lEnd, aFiles[1,1] ) .and. GE10902Grv( @lEnd, aFiles[2,1] ) .and. GE10903Grv( @lEnd, aFiles[3,1] ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE10901Grv �Autor  �Rafael Rodrigues   � Data �  12/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados do arquivo principal na base.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE10900                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE10901Grv( lEnd, cTitulo )
Local cFilJAY	:= xFilial("JAY")	// Criada para ganhar performance
Local cChave	:= ""
Local nItem		:= 0
Local i			:= 0

if Select( "TRB01" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB01->( dbGoTop() )

JAY->( dbSetOrder(1) )

while TRB01->( !eof() ) .and. !lEnd
	
	IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB01->( RecCount() ), 6 )+'...' )

	if cChave <> TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET
		cChave	:= TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET
		nItem	:= 0
	endif
	
	begin transaction
	
	RecLock( "JAY", JAY->( !dbSeek( cFilJAY+TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET+TRB01->JAY_CODDIS ) ) )
	JAY->JAY_FILIAL	:= cFilJAY
	JAY->JAY_CURSO	:= TRB01->JAY_CURSO
	JAY->JAY_VERSAO	:= TRB01->JAY_VERSAO
	JAY->JAY_PERLET	:= TRB01->JAY_PERLET
	JAY->JAY_CODDIS	:= TRB01->JAY_CODDIS
	JAY->JAY_ITEM	:= StrZero( ++nItem, TamSX3("JAY_ITEM")[1] )
	JAY->JAY_CARGA	:= TRB01->JAY_CARGA
	JAY->JAY_TIPO	:= TRB01->JAY_TIPO
	JAY->JAY_FRQMIN	:= TRB01->JAY_FRQMIN
	JAY->JAY_QTDFAT	:= TRB01->JAY_QTDFAT
	JAY->JAY_VALOR	:= TRB01->JAY_VALOR
	JAY->JAY_CONSDP	:= TRB01->JAY_CONSDP
	JAY->JAY_STATUS	:= TRB01->JAY_STATUS

	JAY->( msUnlock() )
		
	end transaction

	TRB01->( dbSkip() )
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE10902Grv �Autor  �Rafael Rodrigues   � Data �  12/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE10900                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE10902Grv( lEnd, cTitulo )
Local cFilJAY	:= xFilial("JAY")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB02" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB02->( dbGoTop() )

JAY->( dbSetOrder(1) )

while TRB02->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB02->JAY_CURSO+TRB02->JAY_VERSAO+TRB02->JAY_PERLET+TRB02->JAY_CODDIS
	
	while cChave == TRB02->JAY_CURSO+TRB02->JAY_VERSAO+TRB02->JAY_PERLET+TRB02->JAY_CODDIS .and. TRB02->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB02->( RecCount() ), 6 )+'...' )
		
		cMemo += StrTran( TRB02->JAY_MEMO1, '\13\10', CRLF )
		
		TRB02->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAY->( dbSeek( cFilJAY+cChave ) )
		begin transaction
		
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAY_CONTEU�
		//�e armazena o codigo do memo no campo JAY_MEMO1. Sobrescreve caso JAY_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAY", .F. )
		MSMM( JAY->JAY_MEMO1, TamSX3("JAY_CONTEU")[1],, cMemo, 1,,, "JAY", "JAY_MEMO1" )
		JAY->( msUnlock() )
		
		end transaction
	endif
	
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE10903Grv �Autor  �Rafael Rodrigues   � Data �  12/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados das Bibliografias na base.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE10900                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE10903Grv( lEnd, cTitulo )
Local cFilJAY	:= xFilial("JAY")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB03" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB03->( dbGoTop() )

JAY->( dbSetOrder(1) )

while TRB03->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB03->JAY_CURSO+TRB03->JAY_VERSAO+TRB03->JAY_PERLET+TRB03->JAY_CODDIS
	
	while cChave == TRB03->JAY_CURSO+TRB03->JAY_VERSAO+TRB03->JAY_PERLET+TRB03->JAY_CODDIS .and. TRB03->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB03->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB03->JAY_MEMO2, '\13\10', CRLF )
		
		TRB03->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAY->( dbSeek( cFilJAY+cChave ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAY_BIBLIO�
		//�e armazena o codigo do memo no campo JAY_MEMO2. Sobrescreve caso JAY_MEMO2 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAY", .F. )
		MSMM( JAY->JAY_MEMO2, TamSX3("JAY_CONTEU")[1],, cMemo, 1,,, "JAY", "JAY_MEMO2" )
		JAY->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE109CH   �Autor  �Rafael Rodrigues    � Data �  12/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida se a carga horaria dos periodos eh igual aa carga    ���
���          �horaria do curso.                                           ���
�������������������������������������������������������������������������͹��
���Uso       �GE10900                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE109CH( lEnd, cLog, cLogFile )
Local lRet		:= .T.
Local nCHTot	:= 0
Local nCHDis	:= 0
Local cChave	:= ""
Local nLinha	:= 0
Local lLog		:= cLog <> NIL

TRB01->( dbGoTop() )

ProcRegua( TRB01->( RecCount() ) )

cChave	:= TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET
nCHTot	:= Posicione( "JAW", 1, xFilial("JAW")+cChave, "JAW_CARGA" )
nLinha	:= TRB01->( Recno() )
while TRB01->( !eof() ) .and. !lEnd

	IncProc( 'Verificando carga hor�ria do curso '+Alltrim( TRB01->JAY_CURSO )+'...' )
	
	if cChave <> TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET
		if nCHTot <> nCHDis
			lRet := .F.
			if lLog
				U_xAddLog( cLog, '  Inconsist�ncia na linha '+StrZero( nLinha, 6 )+': A soma das cargas hor�rias das disciplinas ('+StrZero( nCHDis, 4 )+') n�o corresponde � carga hor�ria total do per�odo ('+StrZero( nCHTot, 4 )+').', cLogFile )
			else
				exit
			endif
		endif
		
		cChave	:= TRB01->JAY_CURSO+TRB01->JAY_VERSAO+TRB01->JAY_PERLET
		nCHTot	:= Posicione( "JAW", 1, xFilial("JAW")+cChave, "JAW_CARGA" )
		nLinha	:= TRB01->( Recno() )
		nCHDis	:= 0
	endif

	nCHDis += TRB01->JAY_CARGA
	
	TRB01->( dbSkip() )
end

lRet := lRet .and. !lEnd

Return lRet