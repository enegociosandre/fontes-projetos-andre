#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE13700   �Autor  �Rafael Rodrigues    � Data �  26/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Faltas x Alunos                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE13700()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC13700.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JCH_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JCH_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JCH_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JCH_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JCH_DATA"  , "D", 008, 0 } )
aAdd( aStru, { "JCH_DISCIP", "C", 015, 0 } )
aAdd( aStru, { "JCH_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JCH_HORA1" , "C", 005, 0 } )
aAdd( aStru, { "JCH_QTD"   , "N", 003, 0 } )

aAdd( aFiles, { 'Faltas x Alunos', '\Import\AC13700.TXT', aStru, 'TRB', .T. } )

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
	if Empty( TRB->JCH_NUMRA )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JCH_NUMRA)  ', 'RA do aluno n�o informado.' } )
	aAdd( aObrig, { 'JCH_NUMRA == Posicione( "JC7", 1, xFilial("JC7")+JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_TURMA+JCH_DISCIP, "JC7_NUMRA" )', 'Matr�cula do aluno para esta disciplina n�o cadastrada na tabela JC7.' } )
	aAdd( aObrig, { '!Empty(JCH_CODCUR) ', 'C�digo do curso vigente n�o informado.' } )
	aAdd( aObrig, { '!Empty(JCH_PERLET) ', 'Per�odo letivo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JCH_TURMA)  ', 'Turma n�o informada.' } )
	aAdd( aObrig, { '!Empty(JCH_DATA)   ', 'Data n�o informada.' } )
	aAdd( aObrig, { '!Empty(JCH_DISCIP) ', 'Disciplina n�o informada.' } )
	aAdd( aObrig, { 'JCH_TIPO$"12"      ', 'Tipo deve ser 1 (indeferida) ou 2 (deferida).' } )
	aAdd( aObrig, { 'JCH_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JCH_CODCUR, "JAH_CODIGO" )', 'Curso vigente n�o cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'JCH_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JCH_TURMA  == Posicione( "JBO", 1, xFilial("JBO")+JCH_CODCUR+JCH_PERLET+JCH_TURMA, "JBO_TURMA" )', 'Turma n�o cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'JCH_DISCIP == Posicione( "JAS", 2, xFilial("JAS")+JCH_CODCUR+JCH_PERLET+JCH_DISCIP, "JAS_CODDIS" )', 'Disciplina n�o cadastrada na tabela JAS.' } )
	aAdd( aObrig, { '!Empty(JCH_QTD) ', 'Quantidade n�o informada.' } )
	aAdd( aObrig, { 'Empty(JCH_HORA1) .or. U_GEIsHora(JCH_HORA1,.T.) ', 'Hor�rio inv�lido.' } )
	aAdd( aObrig, { 'Empty(JCH_HORA1) .or. Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_APFALT") != "1" ', 'Hor�rio somente deve ser informado quando o apontamento for di�rio.' } )
	aAdd( aObrig, { 'JCH_QTD == 1 .or. Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_APFALT") != "1" ', 'O per�odo letivo possui apontamento di�rio, ent�o a quantidade deve ser 1.' } )
	aAdd( aObrig, { 'Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_APFALT") != "2" .or. JCH_DATA == LastDay(JCH_DATA)', 'Quando o apontamento for mensal, a data deve ser igual ao �ltimo dia do m�s.' } )
	aAdd( aObrig, { 'Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_APFALT") != "3" .or. JCH_DATA == Posicione("JAR", 1, xFilial("JAR")+JCH_CODCUR+JCH_PERLET, "JAR_DATA2")', 'Quando o apontamento for por per�odo letivo, a data deve ser igual ao �ltimo dia do per�odo letivo.' } )

	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP+JCH_HORA1" ) } )

	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP+JCH_HORA1", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Valida��o do Arquivo' )
	
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
		Processa( { |lEnd| lOk := GE13700Grv( @lEnd ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE13700Grv �Autor  �Rafael Rodrigues   � Data �  26/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE13700                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE13700Grv( lEnd )
Local cFilJCH	:= xFilial("JCH")	// Criada para ganhar performance
Local cFilJCG	:= xFilial("JCG")	// Criada para ganhar performance
Local i			:= 0
Local cChave	:= ""

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JCG->( dbSetOrder(1) )
JCH->( dbSetOrder(3) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )

	if cChave <> TRB->(JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP)
		cChave := TRB->(JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP)

		begin transaction

		RecLock( "JCG", JCG->( !dbSeek( cFilJCG+TRB->(JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP) ) ) )
		JCG->JCG_FILIAL	:= cFilJCG
		JCG->JCG_CODCUR	:= JCH->JCH_CODCUR
		JCG->JCG_PERLET	:= JCH->JCH_PERLET
		JCG->JCG_TURMA	:= JCH->JCH_TURMA
		JCG->JCG_DISCIP	:= JCH->JCH_DISCIP
		JCG->JCG_TIPO	:= Posicione( "JAR", 1, xFilial("JAR")+JCH->JCH_CODCUR+JCH->JCH_PERLET, "JAR_APFALT" )
		JCG->JCG_DATA	:= JCH->JCH_DATA
		JCG->( msUnlock() )

		end transaction
	endif
	
	begin transaction

	RecLock( "JCH", JCH->( !dbSeek( cFilJCH+TRB->(JCH_NUMRA+JCH_CODCUR+JCH_PERLET+JCH_TURMA+Dtos(JCH_DATA)+JCH_DISCIP+JCH_HORA1) ) ) )
	JCH->JCH_FILIAL	:= cFilJCH
	JCH->JCH_NUMRA	:= TRB->JCH_NUMRA
	JCH->JCH_CODCUR	:= TRB->JCH_CODCUR
	JCH->JCH_PERLET	:= TRB->JCH_PERLET
	JCH->JCH_TURMA	:= TRB->JCH_TURMA
	JCH->JCH_DATA	:= TRB->JCH_DATA
	JCH->JCH_DISCIP	:= TRB->JCH_DISCIP
	JCH->JCH_HORA1	:= TRB->JCH_HORA1
	JCH->JCH_TIPO	:= TRB->JCH_TIPO
	JCH->JCH_QTD	:= TRB->JCH_QTD
	JCH->( msUnlock() )

	end transaction

	TRB->( dbSkip() )
end

Return !lEnd