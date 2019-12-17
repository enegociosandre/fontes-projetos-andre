#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12300  �Autor  �Rafael Rodrigues    � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Avaliacoes dos Cursos Vigentes        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC12300( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC12300'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local nDrv		:= 0

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JBQ_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBQ_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBQ_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JBQ_CODAVA", "C", 002, 0 } )
aAdd( aStru, { "JBQ_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JBQ_DATA"  , "D", 008, 0 } )
aAdd( aStru, { "JBQ_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JBQ_PESO"  , "N", 002, 0 } )
aAdd( aStru, { "JBQ_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JBQ_CHAMAD", "C", 001, 0 } )
aAdd( aStru, { "JBQ_DTAPON", "D", 008, 0 } )
aAdd( aStru, { "JBQ_EXASUB", "C", 001, 0 } )
aAdd( aStru, { "JBQ_ATIVID", "C", 001, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Avalia��es dos Cursos Vigentes', 'AC12300', aClone( aStru ), 'TRB123', .T., 'JBQ_CODCUR, JBQ_PERLET, JBQ_HABILI, JBQ_CODAVA', {|| "JBQ_CODCUR in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JBQ_CODCUR and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

//����������������������������������������������������������������������Ŀ
//�Executa a janela para selecao de arquivos e importacao dos temporarios�
//������������������������������������������������������������������������
if nOpc == 2	// So processamento
	U_xOpen( aTables, aFiles, aDriver, .F. )
else
	aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver )
	if nOpc == 1
		Return aTables
	endif
endif

if Empty( aTables )	//Nenhum arquivo importado.
	AcaLog( cLogFile, '  Nenhum arquivo p�de ser importado para este processo.' )
	if nOpc == 0
		Aviso( 'Problema', 'Nenhum arquivo p�de ser importado para este processo.', {'Ok'} )
	endif
else
	
	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	nDrv := aScan( aDriver, aTables[1,3] ) 
	if nDrv # 3
		TRB123->( dbGoBottom() )
		if Empty( TRB123->JBQ_CODCUR )
			RecLock( "TRB123", .F. )
			TRB123->( dbDelete() )
			TRB123->( msUnlock() )
		endif
	endif
		
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JBQ_CODCUR) ', 'C�digo do curso vigente n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_PERLET) ', 'Per�odo letivo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_CODAVA) ', 'C�digo da avalia��o n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_DESC)   ', 'Descri��o n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_DATA)   ', 'Data inicial n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_DATA2)  ', 'Data final n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_PESO)   ', 'Peso n�o informado.' } )
	aAdd( aObrig, { 'JBQ_TIPO$"1234"    ', 'Tipo deve ser 1 (Regular), 2 (Exame), 3 (Integrada) ou 4 (Nota �nica).' } )
	aAdd( aObrig, { 'JBQ_CHAMAD$"12"    ', 'Segunda chamada deve ser 1 (Sim) ou 2 (N�o).' } )
	aAdd( aObrig, { 'JBQ_EXASUB$"12"    ', 'JBQ_EXASUB deve ser 1 (Sim) ou 2 (N�o).' } )
	aAdd( aObrig, { 'JBQ_ATIVID$"12"    ', 'JBQ_ATIVID deve ser 1 (Sim) ou 2 (N�o).' } )
	aAdd( aObrig, { '!Empty(JBQ_DTAPON) ', 'Data limite para apontamento n�o informado.' } )
	aAdd( aObrig, { 'JBQ_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI, "JAR_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JBQ_DATA >= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI, "JAR_DATA1" ) .and. JBQ_DATA <= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI, "JAR_DATA2" )', 'Data inicial fora do limite de datas do per�odo letivo.' } )
	aAdd( aObrig, { 'JBQ_DATA2 >= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI, "JAR_DATA1" ) .and. JBQ_DATA2 <= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI, "JAR_DATA2" )', 'Data final fora do limite de datas do per�odo letivo.' } )
	aAdd( aObrig, { 'JBQ_DATA <= JBQ_DATA2', 'Data inicial deve ser menor ou igual � data final.' } )

	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	if nDrv # 3
		if nOpc == 0
			MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB123", cIDX, "JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI+JBQ_CODAVA" ) } )
		else
			Eval( {|| IndRegua( "TRB123", cIDX, "JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI+JBQ_CODAVA" ) } )
		endif
	endif
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
	if nOpc == 0
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB123", "JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI+JBQ_CODAVA", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Valida��o do Arquivo' )
	else
		lOk := U_xACChkInt( "TRB123", "JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI+JBQ_CODAVA", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk
	endif
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )
	
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.' )
		if nOpc == 0 .and. Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else
		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		if nOpc == 0
			Processa( { |lEnd| lOk := xAC12300Grv( @lEnd, aTables[1,4] ) }, 'Grava��o em andamento' )
		else
			lOk := xAC12300Grv( @lEnd, aTables[1,4] )
		endif
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Processo de grava��o interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.' )
			if nOpc == 0
				Aviso( 'Opera��o Cancelada!', 'O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', {'Ok'} )
			endif
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Grava��o realizada com sucesso.' )
			if nOpc == 0
				Aviso( 'Sucesso!', 'Importa��o realizada com sucesso.', {'Ok'} )
			endif
		endif
	endif

	//���������������������������������������Ŀ
	//�Elimina os arquivos de trabalho criados�
	//�����������������������������������������
	( aTables[1,1] )->( dbCloseArea() )
	if nDrv # 3
		FErase( aTables[1,2]+GetDBExtension() )
		FErase( cIDX+OrdBagExt() )
	endif	
	
endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12300Grv�Autor  �Rafael Rodrigues   � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC12300                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC12300Grv( lEnd, nRecs )
Local cFilJBQ	:= xFilial("JBQ")	// Criada para ganhar performance
Local i			:= 0
Local cChave	:= ""
Local nItem		:= 0
Local lSeek

if nOpc == 0
	ProcRegua( TRB123->( RecCount() ) )
endif

TRB123->( dbGoTop() )

JBQ->( dbSetOrder(3) )

while TRB123->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif

	if cChave <> TRB123->( JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI )
		cChave := TRB123->( JBQ_CODCUR+JBQ_PERLET+JBQ_HABILI )
		nItem  := 0
	endif
		
	begin transaction
	
	lSeek := JBQ->( dbSeek( cFilJBQ+TRB123->JBQ_CODCUR+TRB123->JBQ_PERLET+TRB123->JBQ_HABILI+TRB123->JBQ_CODAVA ) )
	if lOver .or. !lSeek
		RecLock( "JBQ", !lSeek )
		JBQ->JBQ_FILIAL	:= cFilJBQ
		JBQ->JBQ_CODCUR	:= TRB123->JBQ_CODCUR
		JBQ->JBQ_PERLET	:= TRB123->JBQ_PERLET
		JBQ->JBQ_HABILI	:= TRB123->JBQ_HABILI
		JBQ->JBQ_ITEM	:= StrZero( ++nItem, 2 )
		JBQ->JBQ_DATA	:= TRB123->JBQ_DATA
		JBQ->JBQ_DATA2	:= TRB123->JBQ_DATA2
		JBQ->JBQ_CODAVA	:= TRB123->JBQ_CODAVA
		JBQ->JBQ_DESC	:= TRB123->JBQ_DESC
		JBQ->JBQ_PESO	:= TRB123->JBQ_PESO
		JBQ->JBQ_TIPO	:= TRB123->JBQ_TIPO
		JBQ->JBQ_CHAMAD	:= TRB123->JBQ_CHAMAD
		JBQ->JBQ_DTAPON	:= TRB123->JBQ_DTAPON
		JBQ->JBQ_EXASUB	:= TRB123->JBQ_EXASUB
		JBQ->JBQ_ATIVID	:= TRB123->JBQ_ATIVID
		JBQ->( msUnlock() )
	endif
	
	end transaction

	TRB123->( dbSkip() )
end

Return !lEnd