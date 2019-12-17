#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE13800   �Autor  �Rafael Rodrigues    � Data �  26/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Notas x Alunos                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE13800()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC13800.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JBS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBS_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JBS_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JBS_CODAVA", "C", 002, 0 } )
aAdd( aStru, { "JBS_ATIVID", "C", 002, 0 } )
aAdd( aStru, { "JBS_MATPRF", "C", 006, 0 } )
aAdd( aStru, { "JBS_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JBS_CONCEI", "C", 001, 0 } )
aAdd( aStru, { "JBS_NOTA"  , "N", 005, 2 } )
aAdd( aStru, { "JBS_COMPAR", "C", 001, 0 } )
aAdd( aStru, { "JBS_DTCHAM", "D", 008, 0 } )
aAdd( aStru, { "JBS_OUTRAT", "C", 001, 0 } )
aAdd( aStru, { "JBS_DTAPON", "D", 008, 0 } )

aAdd( aFiles, { 'Notas x Alunos', '\Import\AC13800.TXT', aStru, 'TRB', .T. } )

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
	if Empty( TRB->JBS_NUMRA )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JBS_CODCUR) ', 'C�digo do curso vigente n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBS_PERLET) ', 'Per�odo letivo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBS_TURMA)  ', 'Turma n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBS_CODDIS) ', 'Disciplina n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBS_CODAVA) ', 'Avalia��o n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBS_MATPRF) ', 'Matr�cula do professor n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBS_NUMRA)  ', 'RA do aluno n�o informado.' } )
	aAdd( aObrig, { 'JBS_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JBS_CODCUR, "JAH_CODIGO" )', 'Curso vigente n�o cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'JBS_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JBS_CODCUR+JBS_PERLET, "JAR_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JBS_TURMA  == Posicione( "JBO", 1, xFilial("JBO")+JBS_CODCUR+JBS_PERLET+JBS_TURMA, "JBO_TURMA" )', 'Turma n�o cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'JBS_CODDIS == Posicione( "JAS", 2, xFilial("JAS")+JBS_CODCUR+JBS_PERLET+JBS_CODDIS, "JAS_CODDIS" )', 'Disciplina n�o cadastrada na tabela JAS.' } )
	aAdd( aObrig, { 'JBS_CODAVA == Posicione( "JBQ", 3, xFilial("JBQ")+JBS_CODCUR+JBS_PERLET+JBS_CODAVA, "JBQ_CODAVA" )', 'Avalia��o n�o cadastrada na tabela JBQ.' } )
	aAdd( aObrig, { 'JBS_NUMRA == Posicione( "JC7", if(JBS_OUTRAT=="1",8,1), xFilial("JC7")+JBS_NUMRA+JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS, "JC7_NUMRA" )', 'Matr�cula do aluno para esta disciplina n�o cadastrada na tabela JC7.' } )
	aAdd( aObrig, { 'Empty(JBS_ATIVID) .or. JBS_ATIVID == Posicione( "JDA", 1, xFilial("JDA")+JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID, "JDA_ATIVID" )', 'Atividade n�o cadastrada na tabela JDA.' } )
	aAdd( aObrig, { '!Empty(AcNomeProf(JBS_MATPRF))  ', 'Professor n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'JBS_COMPAR$"12"      ', '"Compareceu?" deve ser 1 (sim) ou 2 (n�o).' } )
	aAdd( aObrig, { 'JBS_OUTRAT$"12"      ', '"Aluno de outra turma?" deve ser 1 (sim) ou 2 (n�o).' } )
	aAdd( aObrig, { '!Empty(JBS_DTAPON) ', 'Data de apontamento n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBS_CONCEI) .or. Posicione( "JAR", 1, xFilial("JAR")+JBS_CODCUR+JBS_PERLET, "JAR_CRIAVA" ) != "2" ', 'Conceito n�o informado. Este per�odo letivo avalia por conceito.' } )
	aAdd( aObrig, { 'JBS_NOTA <= 10', 'Nota maior que 10.' } )

	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+JBS_NUMRA+JBS_OUTRAT" ) } )

	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+JBS_NUMRA", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Valida��o do Arquivo' )
	
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
		Processa( { |lEnd| lOk := GE13800Grv( @lEnd ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE13800Grv �Autor  �Rafael Rodrigues   � Data �  26/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE13800                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE13800Grv( lEnd )
Local cFilJBR	:= xFilial("JBR")	// Criada para ganhar performance
Local cFilJBS	:= xFilial("JBS")	// Criada para ganhar performance
Local cFilJDB	:= xFilial("JDB")	// Criada para ganhar performance
Local cFilJDC	:= xFilial("JDC")	// Criada para ganhar performance
Local i			:= 0
Local cKeyJBR	:= ""
Local cKeyJBS	:= ""
Local cKeyJDB	:= ""

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JBR->( dbSetOrder(1) )
JBS->( dbSetOrder(1) )
JDB->( dbSetOrder(1) )
JDC->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )

	if cKeyJBR <> TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_OUTRAT)
		cKeyJBR := TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_OUTRAT)

		begin transaction

		RecLock( "JBR", JBR->( !dbSeek( cFilJBR+TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA) ) ) )
		JBR->JBR_FILIAL	:= cFilJBR
		JBR->JBR_CODCUR	:= TRB->JBS_CODCUR
		JBR->JBR_PERLET	:= TRB->JBS_PERLET
		JBR->JBR_TURMA	:= TRB->JBS_TURMA
		JBR->JBR_CODDIS	:= TRB->JBS_CODDIS
		JBR->JBR_CODAVA	:= TRB->JBS_CODAVA
		JBR->JBR_MATPRF	:= TRB->JBS_MATPRF
		JBR->( msUnlock() )

		end transaction
	endif
	
	if cKeyJBS <> TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_NUMRA)
		cKeyJBS := TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_NUMRA)

		begin transaction

		RecLock( "JBS", JBS->( !dbSeek( cFilJBS+TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_NUMRA) ) ) )
		JBS->JBS_FILIAL	:= cFilJBS
		JBS->JBS_NUMRA	:= TRB->JBS_NUMRA
		JBS->JBS_CODCUR	:= TRB->JBS_CODCUR
		JBS->JBS_PERLET	:= TRB->JBS_PERLET
		JBS->JBS_TURMA	:= TRB->JBS_TURMA
		JBS->JBS_CODAVA	:= TRB->JBS_CODAVA
		JBS->JBS_CODDIS	:= TRB->JBS_CODDIS
		JBS->JBS_MATPRF	:= TRB->JBS_MATPRF
		JBS->JBS_CONCEI	:= TRB->JBS_CONCEI
		JBS->JBS_NOTA	:= TRB->JBS_NOTA
		JBS->JBS_COMPAR	:= TRB->JBS_COMPAR
		JBS->JBS_DTCHAM	:= TRB->JBS_DTCHAM
		JBS->JBS_OUTRAT	:= TRB->JBS_OUTRAT
		JBS->JBS_DTAPON	:= TRB->JBS_DTAPON
		JBS->( msUnlock() )

		end transaction
	endif

	if !Empty( TRB->JBS_ATIVID )
		if cKeyJDB <> TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+JBS_OUTRAT)
			cKeyJDB := TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+JBS_OUTRAT)
	
			begin transaction
	
			RecLock( "JDB", JDB->( !dbSeek( cFilJDB+TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+if(JBS_OUTRAT=="1","2","1") ) ) ) )
			JDB->JDB_FILIAL	:= cFilJDB
			JDB->JDB_CODCUR	:= TRB->JBS_CODCUR
			JDB->JDB_PERLET	:= TRB->JBS_PERLET
			JDB->JDB_TURMA	:= TRB->JBS_TURMA
			JDB->JDB_CODDIS	:= TRB->JBS_CODDIS
			JDB->JDB_CODAVA	:= TRB->JBS_CODAVA
			JDB->JDB_ATIVID	:= TRB->JBS_ATIVID
			JDB->( msUnlock() )
	
			end transaction
		endif
	
		begin transaction
	
		RecLock( "JDC", JDC->( !dbSeek( cFilJDC+TRB->(JBS_CODCUR+JBS_PERLET+JBS_TURMA+JBS_CODDIS+JBS_CODAVA+JBS_ATIVID+if(JBS_OUTRAT=="1","2","1")+JBS_NUMRA ) ) ) )
		JDC->JDC_FILIAL	:= cFilJBC
		JDC->JDC_CODCUR	:= TRB->JBS_CODCUR
		JDC->JDC_PERLET	:= TRB->JBS_PERLET
		JDC->JDC_TURMA	:= TRB->JBS_TURMA
		JDC->JDC_CODDIS	:= TRB->JBS_CODDIS
		JDC->JDC_CODAVA	:= TRB->JBS_CODAVA
		JDC->JDC_ATIVID	:= TRB->JBS_ATIVID
		JDC->JDC_NUMRA	:= TRB->JBS_NUMRA
		JDC->JDC_OUTRAT	:= TRB->JBS_OUTRAT
		JDC->JDC_CONCEI	:= TRB->JBS_CONCEI
		JDC->JDC_NOTA	:= TRB->JBS_NOTA
		JDC->JDC_COMPAR	:= TRB->JBS_COMPAR
		JDC->JDC_DTCHAM	:= TRB->JBS_DTCHAM
		JDC->( msUnlock() )
	
		end transaction
	endif

	TRB->( dbSkip() )
end

Return !lEnd