#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12500   �Autor  �Rafael Rodrigues    � Data �  08/01/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa os Calend�rios Financeiros.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE12500()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC12500.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JCB_CODFIN", "C", 010, 0 } )
aAdd( aStru, { "JCB_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JCB_ANOLET", "C", 004, 0 } )
aAdd( aStru, { "JCB_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JCB_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JCC_PARCEL", "C", 002, 0 } )
aAdd( aStru, { "JCC_PERC"  , "N", 006, 2 } )
aAdd( aStru, { "JCC_DATA"  , "D", 008, 0 } )

aAdd( aFiles, { 'Calend�rios Financeiros', '\Import\AC12500.TXT', aStru, 'TRB', .T. } )

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
	if Empty( TRB->JCB_CODFIN )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
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
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JCB_CODFIN+JCB_ANOLET+JCB_PERLET+JCB_TIPO+JCB_PARCEL" ) } )
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JCB_CODFIN+JCB_ANOLET+JCB_PERLET+JCB_TIPO+JCB_PARCEL", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Valida��o do Arquivo' )
	
	if !lOk
		U_xAddLog( cLog, '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.', if( lForceLog, cLogFile, nil ) )
		if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			U_xSaveLog( cLog, 'c:\'+cLogFile )
			WinExec( 'Notepad.exe c:\'+cLogFile )
		endif
	else
		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| lOk := GE12500Grv( @lEnd ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE12500Grv �Autor  �Rafael Rodrigues   � Data �  08/01/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12500                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12500Grv( lEnd )
Local cFilJCB	:= xFilial("JCB")	// Criada para ganhar performance
Local cFilJCC	:= xFilial("JCC")	// Criada para ganhar performance
Local cChave	:= ""
Local lFound	:= .F.
Local nItem		:= 1
Local i			:= 0

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JCB->( dbSetOrder(1) )
JCC->( dbSetOrder(2) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )

	if cChave <> TRB->JCB_CODFIN+TRB->JCB_ANOLET+TRB->JCB_PERLET+TRB->JCB_TIPO
		cChave := TRB->JCB_CODFIN+TRB->JCB_ANOLET+TRB->JCB_PERLET+TRB->JCB_TIPO
		
		lFound := .F.
		
		JCB->( dbSeek( cFilJCB+TRB->JCB_ANOLET+TRB->JCB_PERLET+TRB->JCB_TIPO ) )
		while !lFound .and. JCB->( !eof() ) .and. cFilJCB+TRB->( JCB_ANOLET+JCB_PERLET+JCB_TIPO ) == JCB->( JCB_FILIAL+JCB_ANOLET+JCB_PERLET+JCB_TIPO )
			lFound := lFound .or. ( JCB->JCB_CODFIN == TRB->JCB_CODFIN )
			JCB->( dbSkip() )
		end

		begin transaction

		RecLock( "JCB", !lFound )
		JCB->JCB_FILIAL	:= cFilJCB
		JCB->JCB_CODFIN	:= TRB->JCB_CODFIN
		JCB->JCB_DESC	:= TRB->JCB_DESC
		JCB->JCB_ANOLET	:= TRB->JCB_ANOLET
		JCB->JCB_PERLET	:= TRB->JCB_PERLET
		JCB->JCB_TIPO	:= TRB->JCB_TIPO
		JCB->( msUnlock() )
	
		end transaction

		nItem := 1
		
	endif
	
	begin transaction
	
	RecLock( "JCC", JCC->( !dbSeek( cFilJCC+TRB->JCB_CODFIN+TRB->JCB_ANOLET+TRB->JCB_PERLET+TRB->JCB_TIPO+TRB->JCC_PARCEL ) ) )
	JCC->JCC_FILIAL	:= cFilJCC
	JCC->JCC_CODFIN	:= TRB->JCB_CODFIN
	JCC->JCC_ANOLET	:= TRB->JCB_ANOLET
	JCC->JCC_PERLET	:= TRB->JCB_PERLET
	JCC->JCC_TIPO	:= TRB->JCB_TIPO
	JCC->JCC_ITEM	:= StrZero( nItem++, 2 )
	JCC->JCC_PARCEL	:= TRB->JCC_PARCEL
	JCC->JCC_PERC	:= TRB->JCC_PERC
	JCC->JCC_DATA	:= TRB->JCC_DATA
	JCC->( msUnlock() )
	
	end transaction

	TRB->( dbSkip() )
end

Return !lEnd