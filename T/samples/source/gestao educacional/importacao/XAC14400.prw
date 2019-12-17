#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC14400  �Autor  �Rafael Rodrigues    � Data �  17/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa os Aproveitamentos de Estudos dos Alunos            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC14400()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cNameFile := 'AC14400'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local nRecs		:= 0
Local nDrv		:= 0

Private lOver	:= .T.

aAdd( aStru, { "JCO_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JCO_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JCO_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JCO_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JCO_DISCIP", "C", 015, 0 } )
aAdd( aStru, { "JCO_MEDFIM", "N", 005, 2 } )
aAdd( aStru, { "JCO_MEDCON", "C", 004, 0 } )
aAdd( aStru, { "JCO_CODINS", "C", 006, 0 } )
aAdd( aStru, { "JCO_ANOINS", "C", 020, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Aproveitamentos de Estudos', 'AC14400', aClone( aStru ), 'TRB144', .F., 'JCO_NUMRA, JCO_CODCUR, JCO_PERLET, JCO_HABILI, JCO_DISCIP' } )

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
		TRB144->( dbGoBottom() )
		if Empty( TRB144->JCO_NUMRA )
			RecLock( "TRB144", .F. )
			TRB144->( dbDelete() )
			TRB144->( msUnlock() )
		endif
	endif
	
	aObrig := {}
	aAdd( aObrig, { 'JCO_NUMRA == Posicione("JA2", 1, xFilial("JA2")+JCO_NUMRA, "JA2_NUMRA")', 'Aluno n�o cadastrado na tabela JA2.' } )
	aAdd( aObrig, { 'JCO_CODCUR == Posicione("JBE", 1, xFilial("JBE")+JCO_NUMRA+JCO_CODCUR, "JBE_CODCUR")', 'N�o existe matr�cula do aluno para o curso especificado.' } )
	aAdd( aObrig, { 'JCO_PERLET == Posicione("JAR", 1, xFilial("JAR")+JCO_CODCUR+JCO_PERLET+JCO_HABILI, "JAR_PERLET")', 'Per�odo letivo n�o existe no curso especificado.' } )
	aAdd( aObrig, { 'JCO_DISCIP == Posicione("JAS", 2, xFilial("JAS")+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP, "JAS_CODDIS")', 'Disciplina n�o cadastrada na grade curricular do per�odo letivo/curso especificado.' } )
	aAdd( aObrig, { 'JCO_MEDFIM <= 10 '	, 'Nota n�o pode ser maior que 10.' } )
	aAdd( aObrig, { 'JCO_CODINS == Posicione("JCL",1,xFilial("JCL")+JCO_CODINS,"JCL_CODIGO")'	, 'Institui��o n�o cadastrada na tabela JCL.' } )

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	if nDrv # 3
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB144", cIDX, "JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP" ) } )
	endif

	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB144", "JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Validando '+aFiles[1,1] )
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )	
	
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.' )
		if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else

		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| lOk := xAC14400Grv( @lEnd, aFiles[1,1], aTables[1,4] ) }, 'Grava��o em andamento' )
		
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
	TRB144->( dbCloseArea() )
	if nDrv # 3
		FErase( cIDX + OrdBagExt() )
	endif

endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC14400Grv�Autor  �Rafael Rodrigues   � Data �  17/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC14400                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC14400Grv( lEnd, cTitulo, nRecs )
Local cFilJCO	:= xFilial("JCO")	// Criada para ganhar performance
Local i			:= 0
Local lSeek

ProcRegua( nRecs )

if Select( "TRB144" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB144->( dbGoTop() )

JCO->( dbSetOrder(1) )

while TRB144->( !eof() ) .and. !lEnd

	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	
	lSeek := JCO->( dbSeek( cFilJCO+TRB144->(JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP ) ) )
	if lOver .or. !lSeek
		begin transaction
	
		RecLock( "JCO", !lSeek )
		
		JCO->JCO_FILIAL	:= cFilJCO
		JCO->JCO_NUMRA	:= TRB144->JCO_NUMRA
		JCO->JCO_CODCUR	:= TRB144->JCO_CODCUR
		JCO->JCO_PERLET	:= TRB144->JCO_PERLET
		JCO->JCO_HABILI	:= TRB144->JCO_HABILI
		JCO->JCO_DISCIP	:= TRB144->JCO_DISCIP
		JCO->JCO_MEDFIM	:= TRB144->JCO_MEDFIM
		JCO->JCO_MEDCON	:= TRB144->JCO_MEDCON
		JCO->JCO_CODINS	:= TRB144->JCO_CODINS
		JCO->JCO_ANOINS	:= TRB144->JCO_ANOINS
	
		JCO->( msUnlock() )
	
		end transaction
	endif
	
	TRB144->( dbSkip() )	
end

Return !lEnd