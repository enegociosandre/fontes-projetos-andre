#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC14300  �Autor  �Rafael Rodrigues    � Data �  27/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa os Conteudos Programaticos Previstos                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC14300()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cNameFile := 'AC14300'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local nDrv		:= 0

Private lOver	:= .T.

aAdd( aStru, { "JAZ_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAZ_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAZ_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAZ_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JAZ_ANO"   , "C", 004, 0 } )
aAdd( aStru, { "JAZ_PERIOD", "C", 002, 0 } )
aAdd( aStru, { "JAZ_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAZ_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JAZ_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAZ_CODPRE", "C", 080, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Conte�dos Program�ticos Previstos', 'AC14300', aClone( aStru ), 'TRB143', .F., 'JAZ_CURSO, JAZ_VERSAO, JAZ_PERLET, JAZ_HABILI, JAZ_ANO, JAZ_PERIOD, JAZ_CODDIS, JAZ_ITEM, JAZ_SEQ' } )

//����������������������������������������������������������������������Ŀ
//�Executa a janela para selecao de arquivos e importacao dos temporarios�
//������������������������������������������������������������������������
aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver )
nDrv    := aScan( aDriver, aTables[1,3] )	

if Empty( aTables )	//Nenhum arquivo importado.
	AcaLog( cLogFile, '  Nenhum arquivo p�de ser importado para este processo.' )
	Aviso( 'Problema', 'Nenhum arquivo p�de ser importado para este processo.', {'Ok'} )
else
	
	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	if nDrv # 3
		TRB143->( dbGoBottom() )
		if Empty( TRB143->JAZ_CURSO )
			RecLock( "TRB143", .F. )
			TRB143->( dbDelete() )
			TRB143->( msUnlock() )
		endif
	endif
	
	aObrig := {}
	aAdd( aObrig, { 'JAZ_PERLET == Posicione("JAW", 1, xFilial("JAW")+JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_HABILI, "JAW_PERLET")', 'Per�odo letivo n�o cadastrado na tabela JAW.' } )
	aAdd( aObrig, { '!Empty(JAZ_ANO)    '	, 'Ano letivo n�o informado.' } )
	aAdd( aObrig, { 'JAZ_ANO == StrZero( Val(JAZ_ANO), 4)'	, 'Ano deve ser informado com 4 d�gitos.' } )
	aAdd( aObrig, { '!Empty(JAZ_PERIOD) '	, 'Per�odo do ano n�o informado.' } )
	aAdd( aObrig, { 'JAZ_PERIOD == StrZero( Val(JAZ_PERIOD), 2)'	, 'Per�odo do ano deve ser informado com zeros � esquerda.' } )
	aAdd( aObrig, { 'JAZ_CODDIS == Posicione("JAY", 1, xFilial("JAY")+JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_HABILI+JAZ_CODDIS, "JAY_CODDIS")', 'Disciplina n�o cadastrada na tabela JAY.' } )
	aAdd( aObrig, { '!Empty(JAZ_ITEM)   '	, 'Aula n�o informada.' } )
	aAdd( aObrig, { 'JAZ_ITEM == StrZero( Val(JAZ_ITEM), 2)'	, 'Aula deve ser informada com zeros � esquerda.' } )
	aAdd( aObrig, { '!Empty(JAZ_SEQ)    '	, 'Sequencial de linha n�o informado.' } )
	aAdd( aObrig, { 'JAZ_SEQ == StrZero( Val(JAZ_SEQ), 3)'	, 'Sequencial de linha deve ser informado com zeros � esquerda.' } )

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	if nDrv # 3
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB143", cIDX, "JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_HABILI+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS+JAZ_ITEM+JAZ_SEQ")})
	endif
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB143", "JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_HABILI+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS+JAZ_ITEM+JAZ_SEQ", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Validando '+aFiles[1,1] )
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )

	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.' )
		if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else
		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| lOk := xAC14300Grv( @lEnd, aFiles[1,1], aTables[1,4] ) }, 'Grava��o em andamento' )
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Processo de grava��o interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.' )
			Aviso( 'Opera��o Cancelada!', 'O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', {'Ok'} )
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Grava��o realizada com sucesso.' )
			Aviso( 'Sucesso!', 'Importa��o realizada com sucesso.', {'Ok'} )
		endif
	endif

	//���������������������������������������Ŀ
	//�Elimina os arquivos de trabalho criados�
	//�����������������������������������������

endif

if Select("TRB143") > 0
	TRB143->( dbCloseArea() )
endif	

if nDrv # 3
	FErase( cIDX + OrdBagExt() )
endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC14300Grv�Autor  �Rafael Rodrigues   � Data �  27/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC14300                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC14300Grv( lEnd, cTitulo, nRecs )
Local cFilJB3	:= xFilial("JB3")	// Criada para ganhar performance
Local cFilJAZ	:= xFilial("JAZ")	// Criada para ganhar performance
Local i			:= 0
Local cKeyJB3	:= ""
Local cKeyJAZ	:= ""
Local cMemo
Local lSeek

ProcRegua( nRecs )

if Select( "TRB143" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB143->( dbGoTop() )

JB3->( dbSetOrder(1) )
JAZ->( dbSetOrder(1) )

while TRB143->( !eof() ) .and. !lEnd

	if cKeyJB3 != TRB143->(JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_HABILI+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS)
		cKeyJB3	:= TRB143->(JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_HABILI+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS)
		
		lSeek := JB3->( dbSeek( cFilJB3+cKeyJB3 ) )
		if lOver .or. !lSeek
			begin transaction
	
			RecLock( "JB3", !lSeek )
			JB3->JB3_FILIAL	:= cFilJAZ
			JB3->JB3_CURSO	:= TRB143->JAZ_CURSO
			JB3->JB3_VERSAO	:= TRB143->JAZ_VERSAO
			JB3->JB3_PERLET	:= TRB143->JAZ_PERLET
			JB3->JB3_HABILI	:= TRB143->JAZ_HABILI
			JB3->JB3_ANO	:= TRB143->JAZ_ANO
			JB3->JB3_PERIOD	:= TRB143->JAZ_PERIOD
			JB3->JB3_CODDIS	:= TRB143->JAZ_CODDIS
			JB3->( msUnlock() )
	
			end transaction
		endif
	endif
	
	cKeyJAZ	:= TRB143->(JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_HABILI+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS+JAZ_ITEM)
	
	lSeek := JAZ->( dbSeek( cFilJAZ+cKeyJAZ ) )
	if lOver .or. !lSeek
		begin transaction
	
		RecLock( "JAZ", !lSeek )
		
		JAZ->JAZ_FILIAL	:= cFilJAZ
		JAZ->JAZ_CURSO	:= TRB143->JAZ_CURSO
		JAZ->JAZ_VERSAO	:= TRB143->JAZ_VERSAO
		JAZ->JAZ_PERLET	:= TRB143->JAZ_PERLET
		JAZ->JAZ_HABILI	:= TRB143->JAZ_HABILI
		JAZ->JAZ_ANO	:= TRB143->JAZ_ANO
		JAZ->JAZ_PERIOD	:= TRB143->JAZ_PERIOD
		JAZ->JAZ_CODDIS	:= TRB143->JAZ_CODDIS
		JAZ->JAZ_ITEM	:= TRB143->JAZ_ITEM
	
		cMemo	:= ""
		while cKeyJAZ == TRB143->(JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_HABILI+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS+JAZ_ITEM) .and. TRB143->( !eof() ) .and. !lEnd
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	
			cMemo += StrTran( TRB143->JAZ_CODPRE, '\13\10', CRLF )
			
			TRB143->( dbSkip() )
		end
	
		MSMM( JAZ->JAZ_CODPRE, TamSX3("JAZ_CPPREV")[1],, cMemo, 1,,, "JAZ", "JAZ_CODPRE" )
	
		JAZ->( msUnlock() )
	
		end transaction
	else
		while cKeyJAZ == TRB143->(JAZ_CURSO+JAZ_VERSAO+JAZ_PERLET+JAZ_HABILI+JAZ_ANO+JAZ_PERIOD+JAZ_CODDIS+JAZ_ITEM) .and. TRB143->( !eof() ) .and. !lEnd
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
			TRB143->( dbSkip() )
		end
	endif
end

Return !lEnd