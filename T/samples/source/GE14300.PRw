#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE14300   �Autor  �Rafael Rodrigues    � Data �  27/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa os Conteudos Programaticos Previstos                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE14300()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC14300.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JAZ_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAZ_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAZ_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAZ_ANO"   , "C", 004, 0 } )
aAdd( aStru, { "JAZ_PERIOD", "C", 002, 0 } )
aAdd( aStru, { "JAZ_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAZ_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JAZ_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAZ_CODPRE", "C", 080, 0 } )

aAdd( aFiles, { 'Conte�dos Program�ticos Previstos', '\Import\AC14300.TXT', aClone( aStru ), 'TRB', .F. } )

//����������������������������������������������������������������������Ŀ
//�Executa a janela para selecao de arquivos e importacao dos temporarios�
//������������������������������������������������������������������������
aTables	:= U_GEGetF( aFiles, @lForceLog )

if Empty( aTables )	//Nenhum arquivo importado.
	U_xAddLog( cLog, '  Nenhum arquivo p�de ser importado para este processo.', if( lForceLog, cLogFile, nil ) )
	Aviso( 'Problema', 'Nenhum arquivo p�de ser importado para este processo.', {'Ok'} )
else
	
	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	TRB->( dbGoBottom() )
	if Empty( TRB->JAZ_CURSO )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	aObrig := {}
	aAdd( aObrig, { '!Empty(JAZ_CURSO)    '	, 'Curso n�o informado.' } )
	aAdd( aObrig, { '!Empty(JAZ_VERSAO) '	, 'Vers�o n�o informada.' } )
	aAdd( aObrig, { 'JAZ_CURSO == Posicione("JAF", 1, xFilial("JAF")+JAZ_CURSO+JAZ_VERSAO, "JAF_COD")', 'Curso/Vers�o n�o cadastrados na tabela JAF.' } )
	aAdd( aObrig, { '!Empty(JAZ_PERLET) '	, 'Per�odo letivo n�o informado.' } )
	aAdd( aObrig, { 'JAZ_PERLET == Posicione("JAW", 1, xFilial("JAW")+JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET, "JAW_PERLET")', 'Per�odo letivo n�o cadastrado na tabela JAW.' } )
	aAdd( aObrig, { '!Empty(JAZ_ANO)    '	, 'Ano letivo n�o informado.' } )
	aAdd( aObrig, { 'JAZ_ANO == StrZero( Val(JAZ_ANO), 4)'	, 'Ano deve ser informado com 4 d�gitos.' } )
	aAdd( aObrig, { '!Empty(JAZ_PERIOD) '	, 'Per�odo do ano n�o informado.' } )
	aAdd( aObrig, { 'JAZ_PERIOD == StrZero( Val(JAZ_PERIOD), 2)'	, 'Per�odo do ano deve ser informado com zeros � esquerda.' } )
	aAdd( aObrig, { '!Empty(JAZ_CODDIS) '	, 'Disciplina n�o informada.' } )
	aAdd( aObrig, { 'JAZ_CODDIS == Posicione("JAY", 1, xFilial("JAY")+JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_CODDIS, "JAY_CODDIS")', 'Disciplina n�o cadastrada na tabela JAY.' } )
	aAdd( aObrig, { '!Empty(JAZ_ITEM)   '	, 'Aula n�o informada.' } )
	aAdd( aObrig, { 'JAZ_ITEM == StrZero( Val(JAZ_ITEM), 2)'	, 'Aula deve ser informada com zeros � esquerda.' } )
	aAdd( aObrig, { '!Empty(JAZ_SEQ)    '	, 'Sequencial de linha n�o informado.' } )
	aAdd( aObrig, { 'JAZ_SEQ == StrZero( Val(JAZ_SEQ), 3)'	, 'Sequencial de linha deve ser informado com zeros � esquerda.' } )

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS+JAZ_ITEM+JAZ_SEQ" ) } )

	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS+JAZ_ITEM+JAZ_SEQ", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[2,1] )
	
	if !lOk
		U_xAddLog( cLog, '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.', if( lForceLog, cLogFile, nil ) )
		if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			U_xSaveLog( cLog, 'c:\'+cLogFile )
			WinExec( 'Notepad.exe c:\'+cLogFile )
		endif
	else

		nRecs := TRB->( RecCount() )

		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := GE14300Grv( @lEnd, aFiles[1,1] ) }, 'Grava��o em andamento' )
		
		if !lOk
			U_xAddLog( cLog, '! Processo de grava��o interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Opera��o Cancelada!', 'O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', {'Ok'} )
		else
			U_xAddLog( cLog, '! Grava��o realizada com sucesso.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Sucesso!', 'Importa��o realizada com sucesso.', {'Ok'} )
		endif
	endif
	
	FErase( cIDX + OrdBagExt() )
	
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
���Programa  �GE14300Grv �Autor  �Rafael Rodrigues   � Data �  27/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE14300                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE14300Grv( lEnd, cTitulo )
Local cFilJB3	:= xFilial("JB3")	// Criada para ganhar performance
Local cFilJAZ	:= xFilial("JAZ")	// Criada para ganhar performance
Local i			:= 0
Local cKeyJB3	:= ""
Local cKeyJAZ	:= ""
Local cMemo

if Select( "TRB" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB->( dbGoTop() )

JB3->( dbSetOrder(1) )
JAZ->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd

	if cKeyJB3 != TRB->(JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS)
		cKeyJB3	:= TRB->(JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS)

		begin transaction

		RecLock( "JB3", JB3->( !dbSeek( cFilJB3+cKeyJB3 ) ) )
		JB3->JB3_FILIAL	:= cFilJAZ
		JB3->JB3_CURSO	:= TRB->JAZ_CURSO
		JB3->JB3_VERSAO	:= TRB->JAZ_VERSAO
		JB3->JB3_PERLET	:= TRB->JAZ_PERLET
		JB3->JB3_ANO	:= TRB->JAZ_ANO
		JB3->JB3_PERIOD	:= TRB->JAZ_PERIOD
		JB3->JB3_CODDIS	:= TRB->JAZ_CODDIS
		JB3->( msUnlock() )

		end transaction
		
	endif
	
	cKeyJAZ	:= TRB->(JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS+JAZ_ITEM)
	
	begin transaction

	RecLock( "JAZ", JAZ->( !dbSeek( cFilJAZ+cKeyJAZ ) ) )
	
	JAZ->JAZ_FILIAL	:= cFilJAZ
	JAZ->JAZ_CURSO	:= TRB->JAZ_CURSO
	JAZ->JAZ_VERSAO	:= TRB->JAZ_VERSAO
	JAZ->JAZ_PERLET	:= TRB->JAZ_PERLET
	JAZ->JAZ_ANO	:= TRB->JAZ_ANO
	JAZ->JAZ_PERIOD	:= TRB->JAZ_PERIOD
	JAZ->JAZ_CODDIS	:= TRB->JAZ_CODDIS
	JAZ->JAZ_ITEM	:= TRB->JAZ_ITEM

	cMemo	:= ""
	while cKeyJAZ == TRB->(JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS+JAZ_ITEM) .and. TRB->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB->JAZ_CODPRE, '\13\10', CRLF )
		
		TRB->( dbSkip() )
	end

	MSMM( JAZ->JAZ_CODPRE, TamSX3("JAZ_CPPREV")[1],, cMemo, 1,,, "JAZ", "JAZ_CODPRE" )

	JAZ->( msUnlock() )

	end transaction
	
end

Return !lEnd