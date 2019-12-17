#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC13500  �Autor  �Rafael Rodrigues    � Data �  23/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Bolsas x Alunos.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC13500()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cNameFile := 'AC13500'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local nPos		:= 0
Local nDrv		:= 0

Private lOver	:= .T.

aAdd( aStru, { "JC5_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JC5_TIPBOL", "C", 006, 0 } )
aAdd( aStru, { "JC5_BOLSA" , "C", 006, 0 } )
aAdd( aStru, { "JC5_PERBOL", "N", 006, 2 } )
aAdd( aStru, { "JC5_VLRBOL", "N", 009, 2 } )
aAdd( aStru, { "JC5_DTVAL1", "D", 008, 0 } )
aAdd( aStru, { "JC5_DTVAL2", "D", 008, 0 } )
aAdd( aStru, { "JC5_PERDE" , "C", 001, 0 } )
aAdd( aStru, { "JC5_MATR"  , "C", 001, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Bolsas x Alunos', 'AC13500', aClone( aStru ), 'TRB135', .F., 'JC5_NUMRA, JC5_TIPBOL, JC5_DTVAL1, JC5_DTVAL2' } )

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
		TRB135->( dbGoBottom() )
		if Empty( TRB135->JC5_NUMRA )
			RecLock( "TRB135", .F. )
			TRB135->( dbDelete() )
			TRB135->( msUnlock() )
		endif
	endif

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	if nDrv # 3
		MsgRun( 'Ordenando arquivos...',, {|| IndRegua( "TRB135", cIDX, "JC5_NUMRA+JC5_TIPBOL+dtos(JC5_DTVAL1)+dtos(JC5_DTVAL2)" ) } )
	endif

	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aObrig := {}
	aAdd( aObrig, { 'JC5_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JC5_NUMRA, "JA2_NUMRA" )', 'Aluno n�o cadastrado na tabea JA2.' } )
	aAdd( aObrig, { 'JC5_TIPBOL == Posicione( "JC4", 1, xFilial("JC4")+JC5_TIPBOL, "JC4_COD" )', 'Tipo de bolsa n�o cadastrado na tabela JC4.' } )
	aAdd( aObrig, { 'JC5_PERBOL <= 100'		, 'Percentual de bolsa superior a 100%.' } )
	aAdd( aObrig, { '!Empty(JC5_BOLSA)  '	, 'N�mero de controle da bolsa n�o informado.' } )
	aAdd( aObrig, { 'JC5_PERDE$"12"'		, '"Perde Bolsa?" deve ser 1 (Sim) ou 2 (N�o).' } )
	aAdd( aObrig, { 'JC5_MATR$"12"'			, '"Bolsa incide na matr�cula?" deve ser 1 (Sim) ou 2 (N�o).' } )
	aAdd( aObrig, { 'Empty(JC5_DTVAL1) == Empty(JC5_DTVAL2)', 'Datas de inicio e fim de validade devem ser informadas conjuntamente.' } )
	aAdd( aObrig, { 'Empty(JC5_DTVAL1) .or. JC5_DTVAL1 <= JC5_DTVAL2', 'Data de inicio da validade deve ser menor ou igual � data final.' } )

	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB135", "JC5_NUMRA+JC5_TIPBOL+dtos(JC5_DTVAL1)+dtos(JC5_DTVAL2)", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Validando '+aFiles[1,1] )
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )

	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.' )
		if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else
		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| lOk := xAC13500Grv( @lEnd, aFiles[1,1], aTables[1,4] ) }, 'Grava��o em andamento' )
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Processo de grava��o interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.' )
			Aviso( 'Opera��o Cancelada!', 'O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', {'Ok'} )
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Grava��o realizada com sucesso.' )
			Aviso( 'Sucesso!', 'Importa��o realizada com sucesso.', {'Ok'} )
		endif
	endif
endif

//���������������������������������������Ŀ
//�Elimina os arquivos de trabalho criados�
//�����������������������������������������
if Select("TRB135") > 0
	TRB135->( dbCloseArea() )
endif	

if len(aTables) # 0 .and. nDrv # 3
	FErase( cIDX + OrdBagExt() )
endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC13500Grv�Autor  �Rafael Rodrigues   � Data �  23/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados do arquivo principal na base.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC13500                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC13500Grv( lEnd, cTitulo, nRecs )
Local cFilJC5	:= xFilial("JC5")	// Criada para ganhar performance
Local i			:= 0
Local lSeek

ProcRegua( nRecs )

if Select( "TRB135" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB135->( dbGoTop() )

JC5->( dbSetOrder(3) )

while TRB135->( !eof() ) .and. !lEnd
	
	IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )

	lSeek := JC5->( dbSeek( cFilJC5+TRB135->JC5_NUMRA+TRB135->JC5_ITEM ) )	
	if lOver .or. !lSeek
		begin transaction
		
		RecLock( "JC5", !lSeek )
		JC5->JC5_FILIAL	:= cFilJC5
		JC5->JC5_NUMRA	:= TRB135->JC5_NUMRA
		JC5->JC5_ITEM	:= TRB135->JC5_ITEM
		JC5->JC5_TIPBOL	:= TRB135->JC5_TIPBOL
		JC5->JC5_CURSO	:= TRB135->JC5_CURSO
		JC5->JC5_BOLSA	:= TRB135->JC5_BOLSA
		JC5->JC5_PERBOL	:= TRB135->JC5_PERBOL
		JC5->JC5_VLRBOL	:= TRB135->JC5_VLRBOL
		JC5->JC5_DTVAL1	:= TRB135->JC5_DTVAL1
		JC5->JC5_DTVAL2	:= TRB135->JC5_DTVAL2
		JC5->JC5_PERDE	:= TRB135->JC5_PERDE
		JC5->JC5_CLIENT	:= TRB135->JC5_CLIENT
		JC5->JC5_LOJA	:= TRB135->JC5_LOJA
		JC5->JC5_MATR	:= TRB135->JC5_MATR
		JC5->( msUnlock() )
		
		end transaction
	endif
	
	TRB135->( dbSkip() )
end

Return !lEnd