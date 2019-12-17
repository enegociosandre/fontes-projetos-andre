#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE14500   �Autor  �Rafael Rodrigues    � Data �  17/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa os Aproveitamentos de Estudos dos Alunos            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE14500()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC14500.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JC8_DISC1" , "C", 015, 0 } )
aAdd( aStru, { "JC8_DISC2" , "C", 015, 0 } )
aAdd( aStru, { "JC8_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JC8_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JC8_TIPO"  , "C", 001, 0 } )

aAdd( aFiles, { 'Disciplinas Equivalentes', '\Import\AC14500.TXT', aClone( aStru ), 'TRB', .F. } )

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
	if Empty( TRB->JC8_DISC1 )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	aObrig := {}
	aAdd( aObrig, { '!Empty(JC8_DISC1)', 'Disciplina 1 n�o informada.' } )
	aAdd( aObrig, { 'JC8_DISC1 == Posicione("JAE", 1, xFilial("JAE")+JC8_DISC1, "JAE_CODIGO")', 'Disciplina 1 n�o existe na tabela JAE.' } )
	aAdd( aObrig, { '!Empty(JC8_DISC2)', 'Disciplina 2 n�o informada.' } )
	aAdd( aObrig, { 'JC8_DISC2 == Posicione("JAE", 1, xFilial("JAE")+JC8_DISC2, "JAE_CODIGO")', 'Disciplina 2 n�o existe na tabela JAE.' } )
	aAdd( aObrig, { 'JC8_DISC1 <> JC8_DISC2', 'Disciplinas 1 e 2 n�o podem ser a mesma.' } )
	aAdd( aObrig, { 'Posicione("JAE", 1, xFilial("JAE")+JC8_DISC1, "JAE_CARGA") == Posicione("JAE", 1, xFilial("JAE")+JC8_DISC2, "JAE_CARGA") .or. JC8_TIPO <> "1"', 'A carga hor�ria da Disciplina 1 n�o pode ser diferente da carga hor�ria da Disciplina 2 quando o tipo de equival�ncia for 1.' } )
	aAdd( aObrig, { 'Empty(JC8_CURSO) .or. JC8_CURSO == Posicione("JAF", 1, xFilial("JAF")+JC8_CURSO, "JAF_COD")', 'Curso informado n�o existe na tabela JAF.' } )
	aAdd( aObrig, { 'Empty(JC8_VERSAO) == Empty(JC8_CURSO)', 'A vers�o deve ser informada quando o curso for informado.' } )
	aAdd( aObrig, { 'Empty(JC8_VERSAO) .or. JC8_VERSAO == Posicione("JAF", 1, xFilial("JAF")+JC8_CURSO+JC8_VERSAO, "JAF_VERSAO")', 'Vers�o informada n�o existe para o curso informado.' } )
	aAdd( aObrig, { 'JC8_TIPO$"123"', 'Tipo de Equival�ncia deve ser 1, 2 ou 3.' } )

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JC8_DISC1+JC8_DISC2+JC8_CURSO+JC8_VERSAO" ) } )

	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JC8_DISC1+JC8_DISC2+JC8_CURSO+JC8_VERSAO", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[1,1] )
	
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
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := GE14500Grv( @lEnd, aFiles[1,1] ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE14500Grv �Autor  �Rafael Rodrigues   � Data �  17/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE14500                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE14500Grv( lEnd, cTitulo )
Local cFilJC8	:= xFilial("JC8")	// Criada para ganhar performance
Local i			:= 0

ProcRegua( TRB->( RecCount() ) )

if Select( "TRB" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB->( dbGoTop() )

JC8->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd

	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )
	
	begin transaction

	RecLock( "JC8", JC8->( !dbSeek( cFilJC8+TRB->JC8_DISC1+TRB->JC8_DISC2+TRB->JC8_CURSO+TRB->JC8_VERSAO ) ) )
	
	JC8->JC8_FILIAL	:= cFilJC8
	JC8->JC8_DISC1	:= TRB->JC8_DISC1
	JC8->JC8_DISC2	:= TRB->JC8_DISC2
	JC8->JC8_CURSO	:= TRB->JC8_CURSO
	JC8->JC8_VERSAO	:= TRB->JC8_VERSAO
	JC8->JC8_TIPO	:= TRB->JC8_TIPO
	JC8->( msUnlock() )

	end transaction

	TRB->( dbSkip() )	
end

Return !lEnd