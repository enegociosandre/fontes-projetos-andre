#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE10400   �Autor  �Rafael Rodrigues    � Data �  10/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Disciplinas                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE10400()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC10400.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local cIDX03	:= CriaTrab( nil, .F. )
Local cIDX04	:= CriaTrab( nil, .F. )
Local cIDX05	:= CriaTrab( nil, .F. )
Local lDBF01	:= .F.
Local lDBF02	:= .F.
Local lDBF03	:= .F.
Local lDBF04	:= .F.
Local lDBF05	:= .F.
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JAE_CODIGO", "C", 015, 0 } )
aAdd( aStru, { "JAE_DESC"  , "C", 100, 0 } )
aAdd( aStru, { "JAE_MEC"   , "C", 100, 0 } )
aAdd( aStru, { "JAE_TIPO"  , "C", 003, 0 } )
aAdd( aStru, { "JAE_AREA"  , "C", 006, 0 } )
aAdd( aStru, { "JAE_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAE_APLICA", "C", 001, 0 } )
aAdd( aStru, { "JAE_DISPAI", "C", 015, 0 } )
aAdd( aStru, { "JAE_COREQ" , "C", 015, 0 } )
aAdd( aStru, { "JAE_MODALI", "C", 002, 0 } )
aAdd( aStru, { "JAE_NOTUNI", "C", 001, 0 } )
aAdd( aStru, { "JAE_CARGEX", "N", 004, 0 } )
aAdd( aStru, { "JAE_CONVAG", "C", 001, 0 } )

aAdd( aFiles, { 'Cadastro de Disciplinas', '\Import\AC10401.TXT', aClone( aStru ), 'TRB01', .F. } )

aStru := {}

aAdd( aStru, { "JAE_CODIGO", "C", 015, 0 } )
aAdd( aStru, { "JAE_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAE_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Conte�dos das Disciplinas', '\Import\AC10402.TXT', aClone( aStru ), 'TRB02', .F. } )

aStru := {}

aAdd( aStru, { "JAE_CODIGO", "C", 015, 0 } )
aAdd( aStru, { "JAE_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAE_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Ementas das Disciplinas', '\Import\AC10403.TXT', aClone( aStru ), 'TRB03', .F. } )

aStru := {}

aAdd( aStru, { "JAE_CODIGO", "C", 015, 0 } )
aAdd( aStru, { "JAE_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAE_MEMO3" , "C", 080, 0 } )

aAdd( aFiles, { 'Bibliografias das Disciplinas', '\Import\AC10404.TXT', aClone( aStru ), 'TRB04', .F. } )

aStru := {}

aAdd( aStru, { "JAE_CODIGO", "C", 015, 0 } )
aAdd( aStru, { "JAE_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAE_MEMO4" , "C", 080, 0 } )

aAdd( aFiles, { 'Objetivos das Disciplinas', '\Import\AC10405.TXT', aClone( aStru ), 'TRB05', .F. } )

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
	lDBF05	:= aScan( aTables, {|x| x[1] == "TRB05"} ) > 0

	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	if lDBF01
		TRB01->( dbGoBottom() )
		if Empty( TRB01->JAE_CODIGO )
			RecLock( "TRB01", .F. )
			TRB01->( dbDelete() )
			TRB01->( msUnlock() )
		endif
	endif

	if lDBF02
		TRB02->( dbGoBottom() )
		if Empty( TRB02->JAE_CODIGO )
			RecLock( "TRB02", .F. )
			TRB02->( dbDelete() )
			TRB02->( msUnlock() )
		endif
	endif

	if lDBF03
		TRB03->( dbGoBottom() )
		if Empty( TRB03->JAE_CODIGO )
			RecLock( "TRB03", .F. )
			TRB03->( dbDelete() )
			TRB03->( msUnlock() )
		endif
	endif

	if lDBF04
		TRB04->( dbGoBottom() )
		if Empty( TRB04->JAE_CODIGO )
			RecLock( "TRB04", .F. )
			TRB04->( dbDelete() )
			TRB04->( msUnlock() )
		endif
	endif

	if lDBF05
		TRB05->( dbGoBottom() )
		if Empty( TRB05->JAE_CODIGO )
			RecLock( "TRB05", .F. )
			TRB05->( dbDelete() )
			TRB05->( msUnlock() )
		endif
	endif
	
	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	MsgRun( 'Ordenando arquivos...',, {||	if( lDBF01, IndRegua( "TRB01", cIDX01, "JAE_CODIGO" ), NIL ),;
											if( lDBF02, IndRegua( "TRB02", cIDX02, "JAE_CODIGO+JAE_SEQ" ), NIL ),;
											if( lDBF03, IndRegua( "TRB03", cIDX03, "JAE_CODIGO+JAE_SEQ" ), NIL ),;
											if( lDBF04, IndRegua( "TRB04", cIDX04, "JAE_CODIGO+JAE_SEQ" ), NIL ),;
											if( lDBF05, IndRegua( "TRB05", cIDX05, "JAE_CODIGO+JAE_SEQ" ), NIL ) } )

	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	if lDBF01
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAE_CODIGO) '	, 'C�digo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAE_DESC)   '	, 'Descri��o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAE_MEC)    '	, 'Descri��o do MEC n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAE_AREA)   '	, '�rea n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAE_CARGA)  '	, 'Carga Hor�ria n�o informada.' } )
		aAdd( aObrig, { 'JAE_TIPO$"001^002"'	, 'Tipo da Disciplina deve ser 001 (Te�rica) ou 002 (Laborat�rio).' } )
		aAdd( aObrig, { 'JAE_APLICA$"123"'		, 'Aplica��o deve ser 1 (Curso) ou 2 (Processo Seletivo) ou 3 (Concurso).' } )
		aAdd( aObrig, { 'JAE_NOTUNI$"123"'		, 'Tipo de Nota deve ser 1 (Nota �nica), 2 (Por Avalia��o) ou 3 (Por Atividade).' } )
		aAdd( aObrig, { 'JAE_CONVAG$"12"'		, 'Controle de Vagas por Disciplina deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAE_DISPAI <> JAE_CODIGO'	, 'A Disciplina n�o pode ser Disciplina Pai de si mesma.' } )
		aAdd( aObrig, { 'JAE_COREQ <> JAE_CODIGO'	, 'A Disciplina n�o pode ser Co-Requisito de si mesma.' } )
		aAdd( aObrig, { 'JAE_AREA == Posicione( "JAG", 1, xFilial("JAG")+JAE_AREA, "JAG_CODIGO" )'	, '�rea n�o cadastrada na tabela JAG.' } )
		aAdd( aObrig, { 'JAE_MODALI$"01^02"'	, 'Modalidade deve ser 01 (Presencial) ou 02 (Semi-Presencial).' } )
		aAdd( aObrig, { 'Empty(JAE_DISPAI) .or. JAE_DISPAI == Posicione( "JAE", 1, xFilial("JAE")+JAE_DISPAI, "JAE_CODIGO" ) .or. Eval( {|_nPos, _lOk| _nPos := Recno(), _lOk := dbSeek(JAE_DISPAI, .F.), dbGoTo(_nPos), _lOk} )'	, 'Disciplina Pai n�o cadastrada na tabela JAE e inexistente no arquivo de importa��o.' } )
		aAdd( aObrig, { 'Empty(JAE_COREQ) .or. JAE_COREQ == Posicione( "JAE", 1, xFilial("JAE")+JAE_COREQ, "JAE_CODIGO" ) .or. Eval( {|_nPos, _lOk| _nPos := Recno(), _lOk := dbSeek(JAE_COREQ, .F.), dbGoTo(_nPos), _lOk} )'	, 'Co-requisito n�o cadastrado na tabela JAE e inexistente no arquivo de importa��o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB01", "JAE_CODIGO", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk  }, 'Validando '+aFiles[1,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF02
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAE_CODIGO) '	, 'C�digo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAE_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB02->JAE_CODIGO, .F. ) ) )'	, 'Disciplina n�o cadastrada na tabela JAE e n�o presente nos arquivos de importa��o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB02", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[2,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF03
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAE_CODIGO) '	, 'C�digo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAE_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB03->JAE_CODIGO, .F. ) ) )'	, 'Disciplina n�o cadastrada na tabela JAE e n�o presente nos arquivos de importa��o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB03", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[3,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF04
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAE_CODIGO) '	, 'C�digo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAE_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB04->JAE_CODIGO, .F. ) ) )'	, 'Disciplina n�o cadastrada na tabela JAE e n�o presente nos arquivos de importa��o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[4,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB04", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[4,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[4,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF05
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAE_CODIGO) '	, 'C�digo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAE_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAE_CODIGO == Posicione( "JAE", 1, xFilial("JAE")+JAE_CODIGO, "JAE_CODIGO" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB05->JAE_CODIGO, .F. ) ) )'	, 'Disciplina n�o cadastrada na tabela JAE e n�o presente nos arquivos de importa��o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[5,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB05", "JAE_CODIGO+JAE_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[5,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[5,1]+'".', if( lForceLog, cLogFile, nil ) )
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
		nRecs += if( lDBF05, TRB05->( RecCount() ), 0 )

		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := GE10401Grv( @lEnd, aFiles[1,1] ) .and. GE10402Grv( @lEnd, aFiles[2,1] ) .and. GE10403Grv( @lEnd, aFiles[3,1] ) .and. GE10404Grv( @lEnd, aFiles[4,1] ) .and. GE10405Grv( @lEnd, aFiles[5,1] ) }, 'Grava��o em andamento' )
		
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
	FErase( cIDX05 + OrdBagExt() )
	
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
���Programa  �GE10401Grv �Autor  �Rafael Rodrigues   � Data �  10/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados do arquivo principal na base.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE10400                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE10401Grv( lEnd, cTitulo )
Local cFilJAE	:= xFilial("JAE")	// Criada para ganhar performance
Local i			:= 0

if Select( "TRB01" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB01->( dbGoTop() )

JAE->( dbSetOrder(1) )

while TRB01->( !eof() ) .and. !lEnd
	
	IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB01->( RecCount() ), 6 )+'...' )
	
	begin transaction
	
	RecLock( "JAE", JAE->( !dbSeek( cFilJAE+TRB01->JAE_CODIGO ) ) )
	JAE->JAE_FILIAL	:= cFilJAE
	JAE->JAE_CODIGO	:= TRB01->JAE_CODIGO
	JAE->JAE_DESC	:= TRB01->JAE_DESC
	JAE->JAE_MEC	:= TRB01->JAE_MEC
	JAE->JAE_TIPO	:= TRB01->JAE_TIPO
	JAE->JAE_AREA	:= TRB01->JAE_AREA
	JAE->JAE_CARGA	:= TRB01->JAE_CARGA
	JAE->JAE_APLICA	:= TRB01->JAE_APLICA
	JAE->JAE_DISPAI	:= TRB01->JAE_DISPAI
	JAE->JAE_COREQ	:= TRB01->JAE_COREQ
	JAE->JAE_MODALI	:= TRB01->JAE_MODALI
	JAE->JAE_NOTUNI	:= TRB01->JAE_NOTUNI
	JAE->JAE_CARGEX	:= TRB01->JAE_CARGEX
	JAE->JAE_CONVAG	:= TRB01->JAE_CONVAG
	JAE->( msUnlock() )
	
	end transaction

	TRB01->( dbSkip() )
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE10402Grv �Autor  �Rafael Rodrigues   � Data �  10/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE10400                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE10402Grv( lEnd, cTitulo )
Local cFilJAE	:= xFilial("JAE")	// Criada para ganhar performance
Local i			:= 0
Local cDiscip
Local cMemo

if Select( "TRB02" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB02->( dbGoTop() )

JAE->( dbSetOrder(1) )

while TRB02->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cDiscip	:= TRB02->JAE_CODIGO
	
	while cDiscip == TRB02->JAE_CODIGO .and. TRB02->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB02->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB02->JAE_MEMO1, '\13\10', CRLF )
		
		TRB02->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAE->( dbSeek( cFilJAE+cDiscip ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAE_CONTEU�
		//�e armazena o codigo do memo no campo JAE_MEMO1. Sobrescreve caso JAE_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAE", .F. )
		MSMM( JAE->JAE_MEMO1, TamSX3("JAE_CONTEU")[1],, cMemo, 1,,, "JAE", "JAE_MEMO1" )
		JAE->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE10403Grv �Autor  �Rafael Rodrigues   � Data �  10/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE10400                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE10403Grv( lEnd, cTitulo )
Local cFilJAE	:= xFilial("JAE")	// Criada para ganhar performance
Local i			:= 0
Local cDiscip
Local cMemo

if Select( "TRB03" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB03->( dbGoTop() )

JAE->( dbSetOrder(1) )

while TRB03->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cDiscip	:= TRB03->JAE_CODIGO
	
	while cDiscip == TRB03->JAE_CODIGO .and. TRB03->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB03->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB03->JAE_MEMO2, '\13\10', CRLF )
		
		TRB03->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAE->( dbSeek( cFilJAE+cDiscip ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAE_CONTEU�
		//�e armazena o codigo do memo no campo JAE_MEMO2. Sobrescreve caso JAE_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAE", .F. )
		MSMM( JAE->JAE_MEMO2, TamSX3("JAE_FINALI")[1],, cMemo, 1,,, "JAE", "JAE_MEMO2" )
		JAE->( msUnlock() )

		end transaction
	endif

end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE10404Grv �Autor  �Rafael Rodrigues   � Data �  10/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE10400                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE10404Grv( lEnd, cTitulo )
Local cFilJAE	:= xFilial("JAE")	// Criada para ganhar performance
Local i			:= 0
Local cDiscip
Local cMemo

if Select( "TRB04" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB04->( dbGoTop() )

JAE->( dbSetOrder(1) )

while TRB04->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cDiscip	:= TRB04->JAE_CODIGO
	
	while cDiscip == TRB04->JAE_CODIGO .and. TRB04->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB04->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB04->JAE_MEMO3, '\13\10', CRLF )
		
		TRB04->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAE->( dbSeek( cFilJAE+cDiscip ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAE_CONTEU�
		//�e armazena o codigo do memo no campo JAE_MEMO3. Sobrescreve caso JAE_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAE", .F. )
		MSMM( JAE->JAE_MEMO3, TamSX3("JAE_BIBLIO")[1],, cMemo, 1,,, "JAE", "JAE_MEMO3" )
		JAE->( msUnlock() )

		end transaction
	endif

end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE10405Grv �Autor  �Rafael Rodrigues   � Data �  10/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE10400                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE10405Grv( lEnd, cTitulo )
Local cFilJAE	:= xFilial("JAE")	// Criada para ganhar performance
Local i			:= 0
Local cDiscip
Local cMemo

if Select( "TRB05" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB05->( dbGoTop() )

JAE->( dbSetOrder(1) )

while TRB05->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cDiscip	:= TRB05->JAE_CODIGO
	
	while cDiscip == TRB05->JAE_CODIGO .and. TRB05->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB05->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB05->JAE_MEMO4, '\13\10', CRLF )
		
		TRB05->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAE->( dbSeek( cFilJAE+cDiscip ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAE_CONTEU�
		//�e armazena o codigo do memo no campo JAE_MEMO3. Sobrescreve caso JAE_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAE", .F. )
		MSMM( JAE->JAE_MEMO4, TamSX3("JAE_OBJETI")[1],, cMemo, 1,,, "JAE", "JAE_MEMO4" )
		JAE->( msUnlock() )

		end transaction
	endif

end

Return !lEnd