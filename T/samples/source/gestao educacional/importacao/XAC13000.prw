#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC13000  �Autor  �Rafael Rodrigues    � Data � 10/Fev/2004 ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Atividades das Avaliacoes             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC13000( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC13000'
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

aAdd( aStru, { "JDA_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JDA_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JDA_HABILI" , "C", 003, 0 } )
aAdd( aStru, { "JDA_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JDA_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JDA_CODAVA", "C", 002, 0 } )
aAdd( aStru, { "JDA_ATIVID", "C", 002, 0 } )
aAdd( aStru, { "JDA_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JDA_DATA1" , "D", 008, 0 } )
aAdd( aStru, { "JDA_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JDA_PESO"  , "N", 002, 0 } )
aAdd( aStru, { "JDA_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JDA_CHAMAD", "C", 001, 0 } )
aAdd( aStru, { "JDA_DTAPON", "D", 008, 0 } )    

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Atividades das Avalia��es', 'AC13000', aClone( aStru ), 'TRB', .T., 'JDA_CODCUR, JDA_PERLET, JDA_HABILI, JDA_TURMA, JDA_CODDIS, JDA_CODAVA, JDA_ATIVID' } )

//����������������������������������������������������������������������Ŀ
//�Executa a janela para selecao de arquivos e importacao dos temporarios�
//������������������������������������������������������������������������
if nOpc == 2	// So processamento
	U_xOpen( aTables, aFiles, aDriver, .F. ) 
else
	aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver, .F., nOpc == 1 )
	if nOpc == 1
		Return aTables
	endif
endif

if Empty( aTables )	//Nenhum arquivo importado.
	AcaLog( cLogFile, '  Nenhum arquivo p�de ser importado para este processo.' )
	Aviso( 'Problema', 'Nenhum arquivo p�de ser importado para este processo.', {'Ok'} )
else
	
	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	nDrv := aScan( aDriver, aTables[1,3] )
	if nDrv # 3
		TRB->( dbGoBottom() )
		if Empty( TRB->JDA_CODCUR )
			RecLock( "TRB", .F. )
			TRB->( dbDelete() )
			TRB->( msUnlock() )
		endif
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//��������������������������������������������������������������� 

	aAdd( aObrig, { '!Empty(JDA_CODCUR) ', 'C�digo do curso vigente n�o informado.' } )
	aAdd( aObrig, { '!Empty(JDA_PERLET) ', 'Per�odo letivo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JDA_TURMA)  ', 'Turma n�o informada.' } )
	aAdd( aObrig, { '!Empty(JDA_CODDIS) ', 'Disciplina n�o informada.' } )
	aAdd( aObrig, { '!Empty(JDA_CODAVA) ', 'Avalia��o n�o informada.' } )
	aAdd( aObrig, { '!Empty(JDA_ATIVID) ', 'Atividade n�o informada.' } )
	aAdd( aObrig, { '!Empty(JDA_DESC)   ', 'Descri��o n�o informada.' } )
	aAdd( aObrig, { '!Empty(JDA_DATA1)  ', 'Data inicial n�o informada.' } )
	aAdd( aObrig, { '!Empty(JDA_DATA2)  ', 'Data final n�o informada.' } )
	aAdd( aObrig, { '!Empty(JDA_PESO)   ', 'Peso n�o informado.' } )
	aAdd( aObrig, { 'JDA_TIPO$"12"      ', 'Tipo deve ser 1 (Regular) ou 2 (Integrada).' } )
	aAdd( aObrig, { 'JDA_CHAMAD$"12"    ', 'Segunda chamada deve ser 1 (Sim) ou 2 (N�o).' } )
	aAdd( aObrig, { '!Empty(JDA_DTAPON) ', 'Data limite para apontamento n�o informado.' } )
	aAdd( aObrig, { 'JDA_CODAVA == Posicione( "JBQ", 1, xFilial("JBQ")+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_CODAVA, "JBQ_CODAVA" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JDA_TURMA == Posicione( "JBO", 1, xFilial("JBO")+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA, "JBO_TURMA" )', 'Turma n�o cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'JDA_CODDIS == Posicione( "JAS", 2, xFilial("JAS")+JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_CODDIS, "JAS_CODDIS" )', 'Disciplina n�o cadastrada na tabela JAS.' } )
	aAdd( aObrig, { 'JDA_DATA1 >= Posicione( "JAR", 1, xFilial("JAR")+JDA_CODCUR+JDA_PERLET+JDA_HABILI, "JAR_DATA1" ) .and. JDA_DATA1 <= Posicione( "JAR", 1, xFilial("JAR")+JDA_CODCUR+JDA_PERLET+JDA_HABILI, "JAR_DATA2" )', 'Data inicial fora do limite de datas do per�odo letivo.' } )
	aAdd( aObrig, { 'JDA_DATA2 >= Posicione( "JAR", 1, xFilial("JAR")+JDA_CODCUR+JDA_PERLET+JDA_HABILI, "JAR_DATA1" ) .and. JDA_DATA2 <= Posicione( "JAR", 1, xFilial("JAR")+JDA_CODCUR+JDA_PERLET+JDA_HABILI, "JAR_DATA2" )', 'Data final fora do limite de datas do per�odo letivo.' } )
	aAdd( aObrig, { 'JDA_DATA1 <= JDA_DATA2', 'Data inicial deve ser menor ou igual � data final.' } )  

	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	if nDrv # 3  
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID" ) } )
	endif
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )

	Processa( { |lEnd| lOk := U_xACChkInt( "TRB", "JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Valida��o do Arquivo' )

	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )

	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.' )
		if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else 

		nRecs := TRB->( RecCount() ) 

		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		if nOpc == 0
			Processa( { |lEnd| lOk := u_x13000Grv( @lEnd, aTables[1,4] ) }, 'Grava��o em andamento' )
		else	
			lOk := xAC13000Grv( @lEnd, aTables[1,4] )
		endif	

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
	TRB->( dbCloseArea() )
	if nDrv # 3 
		FErase( cIDX + OrdBagExt() )
	endif
endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC13000Grv�Autor  �Rafael Rodrigues   � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC13000                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/
Static Function xAC13000Grv( lEnd, nRecs )
Local cFilJDA	:= xFilial("JDA")	// Criada para ganhar performance
Local cFilJD9	:= xFilial("JD9")	// Criada para ganhar performance
Local i			:= 0
Local cChave	:= ""

ProcRegua( nRecs )

if Select( "TRB" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB->( dbGoTop() )
JDA->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )

	if cChave <> TRB->( JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA )
		cChave := TRB->( JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA )
		Reclock("JD9",.T.)
		JD9->JD9_FILIAL := cFilJD9
		JD9->JD9_CODCUR := TRB->JDA_CODCUR
		JD9->JD9_PERLET := TRB->JDA_PERLET
		JD9->JD9_HABILI := TRB->JDA_HABILI
		JD9->JD9_TURMA  := TRB->JDA_TURMA
		JD9->JD9_CODDIS := TRB->JDA_CODDIS
		JD9->JD9_CODAVA := TRB->JDA_CODAVA
		JD9->JD9_MATPRF := Posicione( "JBL", 1, xFilial("JBL")+TRB->( JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS ), "JBL_MATPRF" )
		JD9->( MsUnlock() )
	endif
	RecLock( "JDA", JDA->( !dbSeek( cFilJDA+TRB->( JDA_CODCUR+JDA_PERLET+JDA_HABILI+JDA_TURMA+JDA_CODDIS+JDA_CODAVA+JDA_ATIVID ) ) ) )
	JDA->JDA_FILIAL	:= cFilJDA
	JDA->JDA_CODCUR	:= TRB->JDA_CODCUR
	JDA->JDA_PERLET	:= TRB->JDA_PERLET
	JDA->JDA_HABILI	:= TRB->JDA_HABILI
	JDA->JDA_TURMA	:= TRB->JDA_TURMA
	JDA->JDA_CODDIS	:= TRB->JDA_CODDIS
	JDA->JDA_CODAVA	:= TRB->JDA_CODAVA
	JDA->JDA_ATIVID	:= TRB->JDA_ATIVID
	JDA->JDA_DATA1	:= TRB->JDA_DATA1
	JDA->JDA_DATA2	:= TRB->JDA_DATA2
	JDA->JDA_DESC	:= TRB->JDA_DESC
	JDA->JDA_PESO	:= TRB->JDA_PESO
	JDA->JDA_TIPO	:= TRB->JDA_TIPO
	JDA->JDA_CHAMAD	:= TRB->JDA_CHAMAD
	JDA->JDA_DTAPON	:= TRB->JDA_DTAPON
	JDA->( msUnlock() )
	
	TRB->( dbSkip() )
end
Return !lEnd