#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12800  �Autor  �Rafael Rodrigues    � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Horarios de Aula                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC12800()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cNameFile := 'AC12800'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local nDrv		:= 0
Local i

Private lOver	:= .T.

aAdd( aStru, { "JBC_CODIGO", "C", 006, 0 } )
aAdd( aStru, { "JBC_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JBC_TURNO" , "C", 003, 0 } )
aAdd( aStru, { "JBD_HORA1" , "C", 005, 0 } )
aAdd( aStru, { "JBD_HORA2" , "C", 005, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Hor�rios de Aula', 'AC12800', aClone( aStru ), 'TRB128', .T., 'JBC_CODIGO, JBD_HORA1, JBD_HORA2' } )

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
		TRB128->( dbGoBottom() )
		if Empty( TRB128->JBC_CODIGO )
			RecLock( "TRB128", .F. )
			TRB128->( dbDelete() )
			TRB128->( msUnlock() )
		endif
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JBC_CODIGO) ', 'C�digo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBC_DESC)   ', 'Descu��o n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBC_TURNO)  ', 'Turno n�o informado.' } )
	aAdd( aObrig, { 'U_xACIsHora(JBD_HORA1, .F.)', 'Hor�rio inicial n�o informado ou inv�lido.' } )
	aAdd( aObrig, { 'U_xACIsHora(JBD_HORA2, .F.)', 'Hor�rio final n�o informado ou inv�lido.' } )
	aAdd( aObrig, { '!U_xACIsHora(JBD_HORA1, .F.) .or. !U_xACIsHora(JBD_HORA2, .F.) .or. JBD_HORA1 <= JBD_HORA2', 'Hor�rio inicial maior que o hor�rio final.' } )
	aAdd( aObrig, { 'JBC_TURNO == Left( Posicione( "SX5", 1, xFilial("SX5")+"F5"+JBC_TURNO, "X5_CHAVE" ), 3 )', 'Turno n�o cadastrado na sub-tabela F5 da tabela SX5.' } )

	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	if nDrv <> 3
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB128", cIDX, "JBC_CODIGO+JBD_HORA1+JBD_HORA2" ) } )
	endif
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
	Processa( { |lEnd| lOk := U_xACChkInt( "TRB128", "JBC_CODIGO+JBD_HORA1+JBD_HORA2", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk, lOk := U_xAC128SP( @lEnd, cLogFile, aTables[1,4] ) .and. lOk }, 'Valida��o do Arquivo' )
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )
	
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.' )
		if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else
		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| lOk := xAC12800Grv( @lEnd, aTables[1,4] ) }, 'Grava��o em andamento' )
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Processo de grava��o interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.' )
			Aviso( 'Opera��o Cancelada!', 'O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', {'Ok'} )
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Grava��o realizada com sucesso.' )
			Aviso( 'Sucesso!', 'Importa��o realizada com sucesso.', {'Ok'} )
		endif
	endif

	//���������������������������������������Ŀ
	//�Elimina os arquivos de trabalho criados�
	//�����������������������������������������
	for i := 1 to len( aTables )
		( aTables[i,1] )->( dbCloseArea() )
		if nDrv # 3
			FErase( aTables[i][2]+GetDBExtension() )
		endif	
	next i
	
	if nDrv # 3
		FErase( cIDX + OrdBagExt() )
	endif	

endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12800Grv�Autor  �Rafael Rodrigues   � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC12800                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC12800Grv( lEnd, nRecs )
Local cFilJBC	:= xFilial("JBC")	// Criada para ganhar performance
Local cFilJBD	:= xFilial("JBD")	// Criada para ganhar performance
Local cChave	:= ""
Local i			:= 0
Local nItem		:= 0
Local lSeek

ProcRegua( nRecs )

TRB128->( dbGoTop() )

JBC->( dbSetOrder(1) )
JBD->( dbSetOrder(2) )

while TRB128->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	
	if cChave <> TRB128->JBC_CODIGO
		lSeek := JBC->( dbSeek( cFilJBC+TRB128->JBC_CODIGO ) )
		if lOver .or. !lSeek
			begin transaction
		
			RecLock( "JBC", !lSeek )
			JBC->JBC_FILIAL	:= cFilJBC
			JBC->JBC_CODIGO	:= TRB128->JBC_CODIGO
			JBC->JBC_DESC	:= TRB128->JBC_DESC
			JBC->JBC_TURNO	:= TRB128->JBC_TURNO
			JBC->( msUnlock() )
			
			end transaction
		endif
		cChave := TRB128->JBC_CODIGO
		nItem  := 0
	endif

	lSeek := JBD->( dbSeek( cFilJBD+TRB128->JBC_CODIGO+TRB128->JBD_HORA1+TRB128->JBD_HORA2 ) )
	if lOver .or. !lSeek
		begin transaction
		
		RecLock( "JBD", !lSeek )
		JBD->JBD_FILIAL	:= cFilJBD
		JBD->JBD_CODIGO	:= TRB128->JBC_CODIGO
		JBD->JBD_TURNO	:= TRB128->JBC_TURNO
		JBD->JBD_ITEM	:= StrZero( ++nItem, 2 )
		JBD->JBD_HORA1	:= TRB128->JBD_HORA1
		JBD->JBD_HORA2	:= TRB128->JBD_HORA2
		JBD->( msUnlock() )
		
		end transaction
	endif
	
	TRB128->( dbSkip() )
end

Return !lEnd

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC128SP  �Autor  �Rafael Rodrigues    � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica sobreposicao de horarios.                          ���
�������������������������������������������������������������������������͹��
���Uso       �xAC12800                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC128SP( lEnd, cLogFile, nRecs )
Local lRet		:= .T.
Local cChave
Local cHora

TRB128->( dbGoTop() )

ProcRegua( nRecs )

while TRB128->( !eof() ) .and. !lEnd
	cChave	:= TRB128->JBC_CODIGO
	aAvas	:= {}
	cHora	:= ""
	
	while cChave == TRB128->JBC_CODIGO .and. TRB128->( !eof() ) .and. !lEnd
		IncProc( 'Verificando sobreposi��o de hor�rios...' )

		if TRB128->JBD_HORA1 < cHora .And. ! Empty( cHora )
			AcaLog( cLogFile, '  Inconsist�ncia no hor�rio '+TRB128->JBC_CODIGO+': O hora inicial '+TRB128->JBD_HORA1+' conflita com o hora final ' + cHora + ' do item anterior.' )
		endif
		
		cHora := TRB128->JBD_HORA2
		TRB128->( dbSkip() )
	end
end

lRet := lRet .and. !lEnd

Return lRet