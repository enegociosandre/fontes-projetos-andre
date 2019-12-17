#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12500  �Autor  �Rafael Rodrigues    � Data �  08/01/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa os Calend�rios Financeiros.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC12500()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cNameFile := 'AC12500'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local nDrv		:= 0
Local i

Private lOver	:= .T.

aAdd( aStru, { "JCB_CODFIN", "C", 010, 0 } )
aAdd( aStru, { "JCB_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JCB_ANOLET", "C", 004, 0 } )
aAdd( aStru, { "JCB_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JCB_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JCB_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JCC_PARCEL", "C", 002, 0 } )
aAdd( aStru, { "JCC_PERC"  , "N", 006, 2 } )
aAdd( aStru, { "JCC_DATA"  , "D", 008, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Calend�rios Financeiros', '\Import\AC12500.TXT', aClone( aStru ), 'TRB125', .T., 'JCB_CODFIN, JCC_PARCEL, JCC_DATA' } )

//����������������������������������������������������������������������Ŀ
//�Executa a janela para selecao de arquivos e importacao dos temporarios�
//������������������������������������������������������������������������
aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver )

if Empty( aTables )	//Nenhum arquivo importado.
	AcaLog( cLogFile, '  Nenhum arquivo p�de ser importado para este processo.' )
	Aviso( 'Problema', 'Nenhum arquivo p�de ser importado para este processo.', {'Ok'} )
else
	
	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	nDrv := aScan( aDriver, aTables[1,3] )
	if nDrv # 3
		TRB125->( dbGoBottom() )
		if Empty( TRB125->JCB_CODFIN )
			RecLock( "TRB125", .F. )
			TRB125->( dbDelete() )
			TRB125->( msUnlock() )
		endif
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JCB_CODFIN) ', 'C�digo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JCB_DESC)   ', 'Descri��o n�o informada.' } )
	aAdd( aObrig, { '!Empty(JCB_ANOLET) ', 'Ano de Vig�ncia n�o informado.' } )
	aAdd( aObrig, { '!Empty(JCB_PERLET) ', 'Per�odo n�o informado.' } )
	aAdd( aObrig, { 'JCB_TIPO$"1234"    ', 'Tipo deve ser 1=Mensalidade, 2=Substitutiva, 3=Depend�ncia ou 4=Tutoria.' } )
	aAdd( aObrig, { '!Empty(JCC_PARCEL) ', 'Parcela n�o informada.' } )
	aAdd( aObrig, { 'JCC_PARCEL == StrZero( Val( JCC_PARCEL ), 2 )', 'Parcela deve ser informada com dois d�gitos.' } )
	aAdd( aObrig, { '!Empty(JCC_PERC)   ', 'Percentual do valor n�o informado.' } )
	aAdd( aObrig, { '!Empty(JCC_DATA)   ', 'Data de vencimento n�o informada.' } )

	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	if nDrv <> 3
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB125", cIDX, "JCB_CODFIN+JCB_PARCEL+dtos(JCC_DATA)" ) } )
	endif
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB125", "JCB_CODFIN+JCB_PARCEL+dtos(JCC_DATA)", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Valida��o do Arquivo' )
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )
		
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.' )
		if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else
		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| lOk := xAC12500Grv( @lEnd, aTables[1,4] ) }, 'Grava��o em andamento' )
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Processo de grava��o interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.' )
			Aviso( 'Opera��o Cancelada!', 'O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', {'Ok'} )
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Grava��o realizada com sucesso.' )
			Aviso( 'Sucesso!', 'Importa��o realizada com sucesso.', {'Ok'} )
		endif
	endif
endif

//���������������������������������������Ŀ
//�Elimina os arquivos de trabalho criados�
//�����������������������������������������
for i := 1 to len( aTables )
	dbSelectArea( aTables[i][1] )
	dbCloseArea()
	FErase( aTables[i][2]+GetDBExtension() )
next i

FErase( cIDX + OrdBagExt() )

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12500Grv�Autor  �Rafael Rodrigues   � Data �  08/01/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC12500                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC12500Grv( lEnd, nRecs )
Local cFilJCB	:= xFilial("JCB")	// Criada para ganhar performance
Local cFilJCC	:= xFilial("JCC")	// Criada para ganhar performance
Local cChave	:= ""
Local nItem		:= 1
Local i			:= 0
Local lSeek

ProcRegua( nRecs )

TRB125->( dbGoTop() )

JCB->( dbSetOrder(2) )
JCC->( dbSetOrder(2) )

while TRB125->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )

	if TRB125->JCB_CODFIN <> cChave
		cChave	:= TRB125->JCB_CODFIN
		nItem	:= 1
		
		lSeek := JCB->( dbSeek( cFilJCB+TRB125->JCB_CODFIN ) )
		if lOver .or. !lSeek
			begin transaction

			RecLock( "JCB", !lSeek )
			JCB->JCB_FILIAL	:= cFilJCB
			JCB->JCB_CODFIN	:= TRB125->JCB_CODFIN
			JCB->JCB_DESC	:= TRB125->JCB_DESC
			JCB->JCB_ANOLET	:= TRB125->JCB_ANOLET
			JCB->JCB_PERLET	:= TRB125->JCB_PERLET
			JCB->JCB_TIPO	:= TRB125->JCB_TIPO
			JCB->( msUnlock() )
			
			end transaction
		endif
	endif

	lSeek := JCC->( !dbSeek( cFilJCC+TRB125->JCB_CODFIN+TRB125->JCB_ANOLET+TRB125->JCB_PERLET+TRB125->JCB_TIPO+TRB125->JCC_PARCEL ) )
	if lOver .or. !lSeek
		begin transaction

		RecLock( "JCC", !lSeek )
		JCC->JCC_FILIAL	:= cFilJCC
		JCC->JCC_CODFIN	:= TRB125->JCB_CODFIN
		JCC->JCC_ANOLET	:= TRB125->JCB_ANOLET
		JCC->JCC_PERLET	:= TRB125->JCB_PERLET
		JCC->JCC_TIPO	:= TRB125->JCB_TIPO
		JCC->JCC_ITEM	:= StrZero( nItem++, 2 )
		JCC->JCC_PARCEL	:= TRB125->JCC_PARCEL
		JCC->JCC_PERC	:= TRB125->JCC_PERC
		JCC->JCC_DATA	:= TRB125->JCC_DATA
		JCC->( msUnlock() )

		end transaction
	endif
	
	TRB125->( dbSkip() )
end

Return !lEnd