#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE14400   �Autor  �Rafael Rodrigues    � Data �  17/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa os Aproveitamentos de Estudos dos Alunos            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE14400()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC14400.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JCO_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JCO_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JCO_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JCO_DISCIP", "C", 015, 0 } )
aAdd( aStru, { "JCO_MEDFIM", "N", 005, 2 } )
aAdd( aStru, { "JCO_MEDCON", "C", 004, 0 } )
aAdd( aStru, { "JCO_CODINS", "C", 006, 0 } )
aAdd( aStru, { "JCO_ANOINS", "C", 020, 0 } )

aAdd( aFiles, { 'Aproveitamentos de Estudos', '\Import\AC14400.TXT', aClone( aStru ), 'TRB', .F. } )

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
	if Empty( TRB->JCO_NUMRA )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	aObrig := {}
	aAdd( aObrig, { '!Empty(JCO_NUMRA)  '	, 'RA do aluno n�o informado.' } )
	aAdd( aObrig, { 'JCO_NUMRA == Posicione("JA2", 1, xFilial("JA2")+JCO_NUMRA, "JA2_NUMRA")', 'Aluno n�o cadastrado na tabela JA2.' } )
	aAdd( aObrig, { '!Empty(JCO_CODCUR) '	, 'C�digo do curso n�o informado.' } )
	aAdd( aObrig, { 'JCO_CODCUR == Posicione("JAH", 1, xFilial("JAH")+JCO_CODCUR, "JAH_CODIGO")', 'Curso Vigente n�o cadastrado na tabela.' } )
	aAdd( aObrig, { 'JCO_CODCUR == Posicione("JBE", 1, xFilial("JBE")+JCO_NUMRA+JCO_CODCUR, "JBE_CODCUR")', 'N�o existe matr�cula do aluno para o curso especificado.' } )
	aAdd( aObrig, { '!Empty(JCO_PERLET) '	, 'Per�odo Letivo n�o informado.' } )
	aAdd( aObrig, { 'JCO_PERLET == Posicione("JAR", 1, xFilial("JAR")+JCO_CODCUR+JCO_PERLET, "JAR_PERLET")', 'Per�odo letivo n�o existe no curso especificado.' } )
	aAdd( aObrig, { '!Empty(JCO_DISCIP) '	, 'C�digo da disciplina n�o informado.' } )
	aAdd( aObrig, { 'JCO_DISCIP == Posicione("JAS", 2, xFilial("JAS")+JCO_CODCUR+JCO_PERLET+JCO_DISCIP, "JAS_CODDIS")', 'Disciplina n�o cadastrada na grade curricular do per�odo letivo/curso especificado.' } )
	aAdd( aObrig, { 'JCO_MEDFIM <= 10 '	, 'Nota n�o pode ser maior que 10.' } )
	aAdd( aObrig, { 'JCO_CODINS == Posicione("JCL",1,xFilial("JCL")+JCO_CODINS,"JCL_CODIGO")'	, 'Institui��o n�o cadastrada na tabela JCL.' } )

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_DISCIP" ) } )

	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_DISCIP", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[1,1] )
	
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
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := GE14400Grv( @lEnd, aFiles[1,1] ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE14400Grv �Autor  �Rafael Rodrigues   � Data �  17/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE14400                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE14400Grv( lEnd, cTitulo )
Local cFilJCO	:= xFilial("JCO")	// Criada para ganhar performance
Local i			:= 0

ProcRegua( TRB->( RecCount() ) )

if Select( "TRB" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB->( dbGoTop() )

JCO->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd

	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )
	
	begin transaction

	RecLock( "JCO", JCO->( !dbSeek( cFilJCO+TRB->JCO_NUMRA+TRB->JCO_CODCUR+TRB->JCO_PERLET+TRB->JCO_DISCIP ) ) )
	
	JCO->JCO_FILIAL	:= cFilJCO
	JCO->JCO_NUMRA	:= TRB->JCO_NUMRA
	JCO->JCO_CODCUR	:= TRB->JCO_CODCUR
	JCO->JCO_PERLET	:= TRB->JCO_PERLET
	JCO->JCO_DISCIP	:= TRB->JCO_DISCIP
	JCO->JCO_MEDFIM	:= TRB->JCO_MEDFIM
	JCO->JCO_MEDCON	:= TRB->JCO_MEDCON
	JCO->JCO_CODINS	:= TRB->JCO_CODINS
	JCO->JCO_ANOINS	:= TRB->JCO_ANOINS

	JCO->( msUnlock() )

	end transaction

	TRB->( dbSkip() )	
end

Return !lEnd