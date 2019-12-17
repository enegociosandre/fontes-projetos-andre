#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12800   �Autor  �Rafael Rodrigues    � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Horarios de Aula                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE12800()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC12800.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JBC_CODIGO", "C", 006, 0 } )
aAdd( aStru, { "JBC_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JBC_TURNO" , "C", 003, 0 } )
aAdd( aStru, { "JBD_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JBD_HORA1" , "C", 005, 0 } )
aAdd( aStru, { "JBD_HORA2" , "C", 005, 0 } )

aAdd( aFiles, { 'Hor�rios de Aula', '\Import\AC12800.TXT', aStru, 'TRB', .T. } )

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
	if Empty( TRB->JBC_CODIGO )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JBC_CODIGO) ', 'C�digo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBC_DESC)   ', 'Descu��o n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBC_TURNO)  ', 'Turno n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBD_ITEM)   ', 'Item n�o informado.' } )
	aAdd( aObrig, { 'U_GEIsHora(JBD_HORA1, .F.)', 'Hor�rio inicial n�o informado ou inv�lido.' } )
	aAdd( aObrig, { 'U_GEIsHora(JBD_HORA2, .F.)', 'Hor�rio final n�o informado ou inv�lido.' } )
	aAdd( aObrig, { '!U_GEIsHora(JBD_HORA1, .F.) .or. !U_GEIsHora(JBD_HORA2, .F.) .or. JBD_HORA1 <= JBD_HORA2', 'Hor�rio inicial maior que o hor�rio final.' } )
	aAdd( aObrig, { 'JBC_TURNO == Left( Posicione( "SX5", 1, xFilial("SX5")+"F5"+JBC_TURNO, "X5_CHAVE" ), 3 )', 'Turno n�o cadastrado na sub-tabela F5 da tabela SX5.' } )

	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JBC_CODIGO+JBD_ITEM" ) } )
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JBC_CODIGO+JBD_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk, lOk := U_GE128SP( @lEnd, cLog, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Valida��o do Arquivo' )
	
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
		Processa( { |lEnd| lOk := GE12800Grv( @lEnd ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE12800Grv �Autor  �Rafael Rodrigues   � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12800                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12800Grv( lEnd )
Local cFilJBC	:= xFilial("JBC")	// Criada para ganhar performance
Local cFilJBD	:= xFilial("JBD")	// Criada para ganhar performance
Local cChave	:= ""
Local i			:= 0

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JBC->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )
	
	begin transaction
	
	if cChave <> TRB->JBC_CODIGO
		RecLock( "JBC", JBC->( !dbSeek( cFilJBC+TRB->JBC_CODIGO ) ) )
		JBC->JBC_FILIAL	:= cFilJBC
		JBC->JBC_CODIGO	:= TRB->JBC_CODIGO
		JBC->JBC_DESC	:= TRB->JBC_DESC
		JBC->JBC_TURNO	:= TRB->JBC_TURNO
		JBC->( msUnlock() )
		
		cChave := TRB->JBC_CODIGO
	endif

	RecLock( "JBD", JBD->( !dbSeek( cFilJBD+TRB->JBC_CODIGO+TRB->JBD_ITEM ) ) )
	JBD->JBD_FILIAL	:= cFilJBD
	JBD->JBD_CODIGO	:= TRB->JBC_CODIGO
	JBD->JBD_TURNO	:= TRB->JBC_TURNO
	JBD->JBD_ITEM	:= TRB->JBD_ITEM
	JBD->JBD_HORA1	:= TRB->JBD_HORA1
	JBD->JBD_HORA2	:= TRB->JBD_HORA2
	JBD->( msUnlock() )
	
	end transaction

	TRB->( dbSkip() )
end

Return !lEnd

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE128SP   �Autor  �Rafael Rodrigues    � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica sobreposicao de horarios.                          ���
�������������������������������������������������������������������������͹��
���Uso       �GE12800                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE128SP( lEnd, cLog, cLogFile )
Local lRet		:= .T.
Local lLog		:= cLog <> NIL
Local cChave
Local cHora
Local cItem

TRB->( dbGoTop() )

ProcRegua( TRB->( RecCount() ) )

while TRB->( !eof() ) .and. !lEnd

	cChave	:= TRB->JBC_CODIGO
	aAvas	:= {}
	cHora	:= "00:00"
	cItem	:= ""
	
	while cChave == TRB->JBC_CODIGO .and. TRB->( !eof() ) .and. !lEnd .and. ( lLog .or. lRet )
		IncProc( 'Verificando sobreposi��o de hor�rios...' )

		if TRB->JBD_HORA1 < cHora .and. !Empty( cItem )
			U_xAddLog( cLog, '  Inconsist�ncia na linha '+StrZero( TRB01->( Recno() ), 6 )+': Os hor�rios dos itens '+cItem+' e '+TRB->JBD_ITEM+' est�o conflitantes.', cLogFile )
		endif
		
		cHora	:= TRB->JBD_HORA2
		cItem	:= TRB->JBD_ITEM
		TRB->( dbSkip() )
	end
	
	if !lLog .and. !lRet
		exit
	endif
end

lRet := lRet .and. !lEnd

Return lRet