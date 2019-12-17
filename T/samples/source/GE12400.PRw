#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12400   �Autor  �Rafael Rodrigues    � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Turmas (Cursos Vigentes x Salas)      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE12400()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC12400.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JBO_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBO_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBO_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JBO_CODLOC", "C", 006, 0 } )
aAdd( aStru, { "JBO_CODPRE", "C", 006, 0 } )
aAdd( aStru, { "JBO_ANDAR" , "C", 003, 0 } )
aAdd( aStru, { "JBO_CODSAL", "C", 006, 0 } )
aAdd( aStru, { "JBO_LUGAR" , "N", 004, 0 } )
aAdd( aStru, { "JBO_OCUPAD", "N", 004, 0 } )
aAdd( aStru, { "JBO_LIVRE" , "N", 004, 0 } )
aAdd( aStru, { "JBO_QTDRES", "N", 004, 0 } )

aAdd( aFiles, { 'Turmas (Cursos Vigentes x Salas)', '\Import\AC12400.TXT', aStru, 'TRB', .T. } )

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
	if Empty( TRB->JBO_CODCUR )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JBO_CODCUR) ', 'C�digo do curso vigente n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_PERLET) ', 'Per�odo letivo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_TURMA)  ', 'Turma n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBO_CODLOC) ', 'C�digo do local n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_CODPRE) ', 'C�digo do pr�dio n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_ANDAR)  ', 'Andar n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_CODSAL) ', 'C�digo da sala n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_LUGAR)  ', 'Capacidade da sala n�o informada.' } )
	aAdd( aObrig, { 'JBO_OCUPAD + JBO_LIVRE + JBO_QTDRES == JBO_LUGAR', 'Total de lugares ocupados, livres e reservados n�o coincide com a capacidade da sala.' } )
	aAdd( aObrig, { 'JBO_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JBO_CODCUR, "JAH_CODIGO" )', 'Curso vigente n�o cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'JBO_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JBO_CODCUR+JBO_PERLET, "JAR_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JBO_CODLOC == Posicione( "JA3", 1, xFilial("JA3")+JBO_CODLOC, "JA3_CODLOC" )', 'Local n�o cadastrado na tabela JA3.' } )
	aAdd( aObrig, { 'JBO_CODPRE == Posicione( "JA4", 1, xFilial("JA4")+JBO_CODLOC+JBO_CODPRE, "JA4_CODPRE" )', 'Pr�dio n�o cadastrado na tabela JA4.' } )
	aAdd( aObrig, { 'JBO_CODSAL == Posicione( "JA5", 1, xFilial("JA5")+JBO_CODLOC+JBO_CODPRE+JBO_ANDAR+JBO_CODSAL, "JA5_CODSAL" )', 'Andar/Sala n�o cadastrados na tabela JA5.' } )

	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JBO_CODCUR+JBO_PERLET+JBO_TURMA" ) } )
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JBO_CODCUR+JBO_PERLET+JBO_TURMA", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Valida��o do Arquivo' )
	
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
		Processa( { |lEnd| lOk := GE12400Grv( @lEnd ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE12400Grv �Autor  �Rafael Rodrigues   � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12400                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12400Grv( lEnd )
Local cFilJBN	:= xFilial("JBN")	// Criada para ganhar performance
Local cFilJBO	:= xFilial("JBO")	// Criada para ganhar performance
Local cChave	:= ""
Local i			:= 0

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JBN->( dbSetOrder(1) )
JBO->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )

	if cChave <> TRB->JBO_CODCUR+TRB->JBO_PERLET
		cChave := TRB->JBO_CODCUR+TRB->JBO_PERLET

		begin transaction

		RecLock( "JBN", JBN->( !dbSeek( cFilJBN+TRB->JBO_CODCUR+TRB->JBO_PERLET ) ) )
		JBN->JBN_FILIAL	:= cFilJBN
		JBN->JBN_CODCUR := TRB->JBO_CODCUR
		JBN->JBN_PERLET	:= TRB->JBO_PERLET
		JBN->( msUnlock() )
	
		end transaction

	endif
	
	begin transaction
	
	RecLock( "JBO", JBO->( !dbSeek( cFilJBO+TRB->JBO_CODCUR+TRB->JBO_PERLET+TRB->JBO_TURMA ) ) )
	JBO->JBO_FILIAL	:= cFilJBO
	JBO->JBO_CODCUR	:= TRB->JBO_CODCUR
	JBO->JBO_PERLET	:= TRB->JBO_PERLET
	JBO->JBO_TURMA	:= TRB->JBO_TURMA
	JBO->JBO_CODLOC	:= TRB->JBO_CODLOC
	JBO->JBO_CODPRE	:= TRB->JBO_CODPRE
	JBO->JBO_ANDAR	:= TRB->JBO_ANDAR
	JBO->JBO_CODSAL	:= TRB->JBO_CODSAL
	JBO->JBO_LUGAR	:= TRB->JBO_LUGAR
	JBO->JBO_OCUPAD	:= TRB->JBO_OCUPAD
	JBO->JBO_LIVRE	:= TRB->JBO_LIVRE
	JBO->JBO_QTDRES	:= TRB->JBO_QTDRES
	JBO->( msUnlock() )
	
	end transaction

	TRB->( dbSkip() )
end

Return !lEnd