#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC14500  �Autor  �Rafael Rodrigues    � Data �  17/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa as equivalencias de disciplinas                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC14500()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cNameFile := 'AC14500'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local nRecs		:= 0

Private lOver	:= .T.

aAdd( aStru, { "JC8_DISC1" , "C", 015, 0 } )
aAdd( aStru, { "JC8_DISC2" , "C", 015, 0 } )
aAdd( aStru, { "JC8_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JC8_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JC8_TIPO"  , "C", 001, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Disciplinas Equivalentes', 'AC14500', aClone( aStru ), 'TRB145', .F., 'JC8_DISC1, JC8_DISC2, JC8_CURSO, JC8_VERSAO' } )

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
		TRB145->( dbGoBottom() )
		if Empty( TRB145->JC8_DISC1 )
			RecLock( "TRB145", .F. )
			TRB145->( dbDelete() )
			TRB145->( msUnlock() )
		endif
	endif
		
	aObrig := {}
	aAdd( aObrig, { '!Empty(JC8_DISC1)', 'Disciplina 1 n�o informada.' } )
	aAdd( aObrig, { 'JC8_DISC1 == Posicione("JAE", 1, xFilial("JAE")+JC8_DISC1, "JAE_CODIGO")', 'Disciplina 1 n�o existe na tabela JAE.' } )
	aAdd( aObrig, { '!Empty(JC8_DISC2)', 'Disciplina 2 n�o informada.' } )
	aAdd( aObrig, { 'JC8_DISC2 == Posicione("JAE", 1, xFilial("JAE")+JC8_DISC2, "JAE_CODIGO")', 'Disciplina 2 n�o existe na tabela JAE.' } )
	aAdd( aObrig, { 'JC8_DISC1 <> JC8_DISC2', 'Disciplinas 1 e 2 n�o podem ser a mesma.' } )
	aAdd( aObrig, { 'Empty(JC8_CURSO) .or. JC8_CURSO == Posicione("JAF", 1, xFilial("JAF")+JC8_CURSO, "JAF_COD")', 'Curso informado n�o existe na tabela JAF.' } )
	aAdd( aObrig, { 'Empty(JC8_VERSAO) == Empty(JC8_CURSO)', 'A vers�o deve ser informada quando o curso for informado.' } )
	aAdd( aObrig, { 'Empty(JC8_VERSAO) .or. JC8_VERSAO == Posicione("JAF", 1, xFilial("JAF")+JC8_CURSO+JC8_VERSAO, "JAF_VERSAO")', 'Vers�o informada n�o existe para o curso informado.' } )
	aAdd( aObrig, { 'JC8_TIPO$"123"', 'Tipo de Equival�ncia deve ser 1, 2 ou 3.' } )

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	if nDrv # 3
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB145", cIDX, "JC8_DISC1+JC8_DISC2+JC8_CURSO+JC8_VERSAO" ) } )	
	endif	

	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB145", "JC8_DISC1+JC8_DISC2+JC8_CURSO+JC8_VERSAO", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Validando '+aFiles[1,1] )
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )
	
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.' )
		if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else

		nRecs := TRB145->( RecCount() )

		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| lOk := xAC14500Grv( @lEnd, aTables[1,4] ) }, 'Grava��o em andamento' )
		
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
	TRB145->( dbCloseArea() )
	if nDrv # 3
		FErase( cIDX + OrdBagExt() )
	endif

endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC14500Grv�Autor  �Rafael Rodrigues   � Data �  17/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC14500                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC14500Grv( lEnd, nRecs )
Local cFilJC8	:= xFilial("JC8")	// Criada para ganhar performance
Local i			:= 0
Local lSeek

ProcRegua( nRecs )

if Select( "TRB145" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB145->( dbGoTop() )

JC8->( dbSetOrder(1) )

while TRB145->( !eof() ) .and. !lEnd

	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	
	lSeek := JC8->( dbSeek( cFilJC8+TRB145->JC8_DISC1+TRB145->JC8_DISC2+TRB145->JC8_CURSO+TRB145->JC8_VERSAO ) )
	if lOver .or. !lSeek
		begin transaction
	
		RecLock( "JC8", !lSeek )
		
		JC8->JC8_FILIAL	:= cFilJC8
		JC8->JC8_DISC1	:= TRB145->JC8_DISC1
		JC8->JC8_DISC2	:= TRB145->JC8_DISC2
		JC8->JC8_CURSO	:= TRB145->JC8_CURSO
		JC8->JC8_VERSAO	:= TRB145->JC8_VERSAO
		JC8->JC8_TIPO	:= TRB145->JC8_TIPO
		JC8->( msUnlock() )
	
		end transaction
	endif
	
	TRB145->( dbSkip() )	
end

Return !lEnd