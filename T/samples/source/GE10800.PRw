#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE10800   �Autor  �Rafael Rodrigues    � Data �  11/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Curso Padrao                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE10800()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC10800.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local lDBF01	:= .F.
Local lDBF02	:= .F.
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JAF_COD"   , "C", 006, 0 } )
aAdd( aStru, { "JAF_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAF_DESC"  , "C", 060, 0 } )
aAdd( aStru, { "JAF_AREA"  , "C", 006, 0 } )
aAdd( aStru, { "JAF_CLASFI", "C", 015, 0 } )
aAdd( aStru, { "JAF_CCUSTO", "C", 009, 0 } )
aAdd( aStru, { "JAF_ATIVO" , "C", 001, 0 } )
aAdd( aStru, { "JAF_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAF_CARMIN", "N", 004, 0 } )
aAdd( aStru, { "JAF_TIPHOR", "C", 001, 0 } )
aAdd( aStru, { "JAF_PROVAO", "C", 001, 0 } )
aAdd( aStru, { "JAF_REGIME", "C", 003, 0 } )
aAdd( aStru, { "JAF_CRIAVA", "C", 001, 0 } )
aAdd( aStru, { "JAF_EQVCON", "C", 006, 0 } )
aAdd( aStru, { "JAF_CONCEI", "C", 001, 0 } )
aAdd( aStru, { "JAF_AVANDI", "N", 003, 0 } )
aAdd( aStru, { "JAW_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAW_DPERLE", "C", 030, 0 } )
aAdd( aStru, { "JAW_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAW_QTDOPT", "N", 002, 0 } )

aAdd( aFiles, { 'Cursos Padr�o', '\Import\AC10801.TXT', aClone( aStru ), 'TRB01', .F. } )

aStru := {}

aAdd( aStru, { "JAF_COD"   , "C", 006, 0 } )
aAdd( aStru, { "JAF_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAF_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAF_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Dispositivos legais dos Cursos Padr�o', '\Import\AC10802.TXT', aClone( aStru ), 'TRB02', .F. } )

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

	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	if lDBF01
		TRB01->( dbGoBottom() )
		if Empty( TRB01->JAF_COD )
			RecLock( "TRB01", .F. )
			TRB01->( dbDelete() )
			TRB01->( msUnlock() )
		endif
	endif

	if lDBF02
		TRB02->( dbGoBottom() )
		if Empty( TRB02->JAF_COD )
			RecLock( "TRB02", .F. )
			TRB02->( dbDelete() )
			TRB02->( msUnlock() )
		endif
	endif
	
	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	MsgRun( 'Ordenando arquivos...',, {||	if( lDBF01, IndRegua( "TRB01", cIDX01, "JAF_COD+JAF_VERSAO+JAW_PERLET" ), NIL ),;
											if( lDBF02, IndRegua( "TRB02", cIDX02, "JAF_COD+JAF_VERSAO+JAF_SEQ" ), NIL ) } )

	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	if lDBF01
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAF_COD)    '	, 'C�digo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAF_VERSAO) '	, 'Vers�o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAF_DESC)   '	, 'Descri��o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAF_AREA)   '	, '�rea n�o informada.' } )
		aAdd( aObrig, { 'JAF_ATIVO$"12"'		, 'Curso ativo deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { '!Empty(JAF_CARGA)  '	, 'Carga hor�ria n�o informada.' } )
		aAdd( aObrig, { 'JAF_TIPHOR$"12"'		, 'Tipo de hora da carga hor�ria deve ser 1 (Hora Aula) ou 2 (Hora Rel�gio).' } )
		aAdd( aObrig, { 'JAF_PROVAO$"12"'		, '"Participa do prov�o do MEC?" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAF_CRIAVA$"12"'		, 'Crit�rio de Avalia��o deve ser 1 (Nota) ou 2 (Conceito).' } )
		aAdd( aObrig, { 'JAF_REGIME$"001^002^003^004"'	, 'Regime do curso deve ser 001 (Anual), 002 (Semestral), 003 (Trimestral) ou 004 (Bimestral).' } )
		aAdd( aObrig, { '!Empty(JAW_PERLET) '	, 'Per�odo letivo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAW_DPERLE) '	, 'Descri��o do per�odo letivo n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAW_CARGA)  '	, 'Carga horaria do per�odo letivo n�o informada.' } )
		aAdd( aObrig, { 'JAF_AREA == Posicione( "JAG", 1, xFilial("JAG")+JAF_AREA, "JAG_CODIGO" )'	, '�rea n�o cadastrada na tabela JAG.' } )
		aAdd( aObrig, { 'Empty(JAF_CLASFI) .or. JAF_CLASFI == Posicione( "JBX", 1, xFilial("JBX")+JAF_CLASFI, "JBX_CODIGO" )'	, 'Classifica��o ISCED n�o cadastrado na tabela JBX.' } )
		aAdd( aObrig, { 'Empty(JAF_CCUSTO) .or. JAF_CCUSTO == Posicione( "SI3", 1, xFilial("SI3")+JAF_CCUSTO, "I1_CUSTO" )'	, 'Centro de custo n�o cadastrado na tabela SI3.' } )
		aAdd( aObrig, { 'JAF_CRIAVA == "1" .or. !Empty(JAF_EQVCON)'	, 'Tabela de equival�ncia de conceitos deve ser informado quando crit�rio de avalia��o for conceito.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB01", "JAF_COD+JAF_VERSAO+JAW_PERLET", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk, lOk := U_GE108CH( @lEnd, cLog, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[1,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF02
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAF_COD)    '	, 'C�digo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAF_VERSAO) '	, 'Vers�o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAF_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAF_COD == Posicione( "JAF", 1, xFilial("JAF")+JAF_COD+JAF_VERSAO, "JAF_COD" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB02->JAF_COD+TRB02->JAF_VERSAO, .F. ) ) )'	, 'Curso Padr�o n�o cadastrado na tabela JAF e n�o presente nos arquivos de importa��o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB02", "JAF_COD+JAF_VERSAO+JAF_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[2,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
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

		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := GE10801Grv( @lEnd, aFiles[1,1] ) .and. GE10802Grv( @lEnd, aFiles[2,1] ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE10801Grv �Autor  �Rafael Rodrigues   � Data �  11/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados do arquivo principal na base.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE10800                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE10801Grv( lEnd, cTitulo )
Local cFilJAF	:= xFilial("JAF")	// Criada para ganhar performance
Local cFilJAW	:= xFilial("JAW")	// Criada para ganhar performance
Local cCurso	:= ""
Local i			:= 0

if Select( "TRB01" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB01->( dbGoTop() )

JAF->( dbSetOrder(1) )

while TRB01->( !eof() ) .and. !lEnd
	
	IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB01->( RecCount() ), 6 )+'...' )
	
	begin transaction
	
	if cCurso <> TRB01->JAF_COD+TRB01->JAF_VERSAO
		RecLock( "JAF", JAF->( !dbSeek( cFilJAF+TRB01->JAF_COD+TRB01->JAF_VERSAO ) ) )
		JAF->JAF_FILIAL	:= cFilJAF
		JAF->JAF_COD	:= TRB01->JAF_COD
		JAF->JAF_VERSAO	:= TRB01->JAF_VERSAO
		JAF->JAF_DESC	:= TRB01->JAF_DESC
		JAF->JAF_AREA	:= TRB01->JAF_AREA
		JAF->JAF_CLASFI	:= TRB01->JAF_CLASFI
		JAF->JAF_CCUSTO	:= TRB01->JAF_CCUSTO
		JAF->JAF_ATIVO	:= TRB01->JAF_ATIVO
		JAF->JAF_CARGA	:= TRB01->JAF_CARGA
		JAF->JAF_CARMIN	:= if( Empty( TRB01->JAF_CARMIN ), TRB01->JAF_CARGA, TRB01->JAF_CARMIN )
		JAF->JAF_TIPHOR	:= TRB01->JAF_TIPHOR
		JAF->JAF_PROVAO	:= TRB01->JAF_PROVAO
		JAF->JAF_REGIME	:= TRB01->JAF_REGIME
		JAF->JAF_CONCEI	:= TRB01->JAF_CONCEI
		JAF->JAF_CRIAVA	:= TRB01->JAF_CRIAVA
		JAF->JAF_EQVCON	:= TRB01->JAF_EQVCON
		JAF->JAF_AVANDI	:= TRB01->JAF_AVANDI
		JAF->( msUnlock() )
		
		cCurso := TRB01->JAF_COD+TRB01->JAF_VERSAO
	endif

	RecLock( "JAW", JAW->( !dbSeek( cFilJAW+TRB01->JAF_COD+TRB01->JAF_VERSAO+TRB01->JAW_PERLET ) ) )
	JAW->JAW_FILIAL	:= cFilJAW
	JAW->JAW_CURSO	:= TRB01->JAF_COD
	JAW->JAW_VERSAO	:= TRB01->JAF_VERSAO
	JAW->JAW_PERLET	:= TRB01->JAW_PERLET
	JAW->JAW_DPERLE	:= TRB01->JAW_DPERLE
	JAW->JAW_CARGA	:= TRB01->JAW_CARGA
	JAW->JAW_QTDOPT	:= TRB01->JAW_QTDOPT
	JAW->( msUnlock() )
	
	end transaction

	TRB01->( dbSkip() )
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE10802Grv �Autor  �Rafael Rodrigues   � Data �  11/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE10800                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE10802Grv( lEnd, cTitulo )
Local cFilJAF	:= xFilial("JAF")	// Criada para ganhar performance
Local i			:= 0
Local cCurso
Local cMemo

if Select( "TRB02" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB02->( dbGoTop() )

JAF->( dbSetOrder(1) )

while TRB02->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cCurso	:= TRB02->JAF_COD+TRB02->JAF_VERSAO
	
	while cCurso == TRB02->JAF_COD+TRB02->JAF_VERSAO .and. TRB02->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB02->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB02->JAF_MEMO1, '\13\10', CRLF )
		
		TRB02->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAF->( dbSeek( cFilJAF+cCurso ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAF_DISLEG�
		//�e armazena o codigo do memo no campo JAF_MEMO1. Sobrescreve caso JAF_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAF", .F. )
		MSMM( JAF->JAF_MEMO1, TamSX3("JAF_DISLEG")[1],, cMemo, 1,,, "JAF", "JAF_MEMO1" )
		JAF->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE108CH   �Autor  �Rafael Rodrigues    � Data �  11/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida se a carga horaria dos periodos eh igual aa carga    ���
���          �horaria do curso.                                           ���
�������������������������������������������������������������������������͹��
���Uso       �GE10800                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE108CH( lEnd, cLog, cLogFile )
Local lRet		:= .T.
Local nCHCur	:= 0
Local nCHPer	:= 0
Local cCurso	:= ""
Local nLinha	:= 0
Local lLog		:= cLog <> NIL

TRB01->( dbGoTop() )

cCurso	:= TRB01->JAF_COD+TRB01->JAF_VERSAO
nCHCur	:= TRB01->JAF_CARGA
nLinha	:= TRB01->( Recno() )
while TRB01->( !eof() ) .and. !lEnd

	if cCurso <> TRB01->JAF_COD+TRB01->JAF_VERSAO
		if nCHCur <> nCHPer
			lRet := .F.
			if lLog
				U_xAddLog( cLog, '  Inconsist�ncia na linha '+StrZero( nLinha, 6 )+': A soma das cargas hor�rias dos per�odos ('+StrZero( nCHPer, 4 )+') n�o corresponde � carga hor�ria total do curso ('+StrZero( nCHCur, 4 )+').', cLogFile )
			else
				exit
			endif
		endif
		
		cCurso	:= TRB01->JAF_COD+TRB01->JAF_VERSAO
		nCHCur	:= TRB01->JAF_CARGA
		nLinha	:= TRB01->( Recno() )
		nCHPer	:= 0
	endif

	nCHPer += TRB01->JAW_CARGA
	
	TRB01->( dbSkip() )
end

lRet := lRet .and. !lEnd

Return lRet