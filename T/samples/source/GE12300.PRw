#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12300   �Autor  �Rafael Rodrigues    � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Avaliacoes dos Cursos Vigentes        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE12300()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC12300.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JBQ_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBQ_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBQ_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JBQ_DATA1" , "D", 008, 0 } )
aAdd( aStru, { "JBQ_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JBQ_CODAVA", "C", 002, 0 } )
aAdd( aStru, { "JBQ_DESC"  , "C", 030, 0 } )
aAdd( aStru, { "JBQ_PESO"  , "N", 002, 0 } )
aAdd( aStru, { "JBQ_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JBQ_CHAMAD", "C", 001, 0 } )
aAdd( aStru, { "JBQ_DTAPON", "D", 008, 0 } )

aAdd( aFiles, { 'Avalia��es dos Cursos Vigentes', '\Import\AC12300.TXT', aStru, 'TRB', .T. } )

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
	if Empty( TRB->JBQ_CODCUR )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JBQ_CODCUR) ', 'C�digo do curso vigente n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_PERLET) ', 'Per�odo letivo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_ITEM)   ', 'Item n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_DATA1)  ', 'Data inicial n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_DATA2)  ', 'Data final n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_CODAVA) ', 'C�digo da avalia��o n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBQ_DESC)   ', 'Descri��o n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBQ_PESO)   ', 'Peso n�o informado.' } )
	aAdd( aObrig, { 'JBQ_TIPO$"1234"    ', 'Tipo deve ser 1 (Regular), 2 (Exame), 3 (Integrada) ou 4 (Nota �nica).' } )
	aAdd( aObrig, { 'JBQ_CHAMAD$"12"    ', 'Segunda chamada deve ser 1 (Sim) ou 2 (N�o).' } )
	aAdd( aObrig, { '!Empty(JBQ_DTAPON) ', 'Data limite para apontamento n�o informado.' } )
	aAdd( aObrig, { 'JBQ_DTAPON >= JBQ_DATA1', 'Data limite para apontamento deve ser maior ou igual � data inicial da avalia��o.' } )
	aAdd( aObrig, { 'JBQ_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JBQ_CODCUR, "JAH_CODIGO" )', 'Curso vigente n�o cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'JBQ_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET, "JAR_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JBQ_DATA1 >= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET, "JAR_DATA1" ) .and. JBQ_DATA1 <= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET, "JAR_DATA2" )', 'Data inicial fora do limite de datas do per�odo letivo.' } )
	aAdd( aObrig, { 'JBQ_DATA2 >= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET, "JAR_DATA1" ) .and. JBQ_DATA2 <= Posicione( "JAR", 1, xFilial("JAR")+JBQ_CODCUR+JBQ_PERLET, "JAR_DATA2" )', 'Data final fora do limite de datas do per�odo letivo.' } )
	aAdd( aObrig, { 'JBQ_DATA1 <= JBQ_DATA2', 'Data inicial deve ser menor ou igual � data final.' } )

	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JBQ_CODCUR+JBQ_PERLET+JBQ_ITEM" ) } )
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JBQ_CODCUR+JBQ_PERLET+JBQ_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk, lOk := U_GE123Av( @lEnd, cLog, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Valida��o do Arquivo' )
	
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
		Processa( { |lEnd| lOk := GE12300Grv( @lEnd ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE12300Grv �Autor  �Rafael Rodrigues   � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12300                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12300Grv( lEnd )
Local cFilJBQ	:= xFilial("JBQ")	// Criada para ganhar performance
Local i			:= 0

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JBQ->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )
	
	begin transaction
	
	RecLock( "JBQ", JBQ->( !dbSeek( cFilJBQ+TRB->JBQ_CODCUR+TRB->JBQ_PERLET+TRB->JBQ_ITEM ) ) )
	JBQ->JBQ_FILIAL	:= cFilJBQ
	JBQ->JBQ_CODCUR	:= TRB->JBQ_CODCUR
	JBQ->JBQ_PERLET	:= TRB->JBQ_PERLET
	JBQ->JBQ_ITEM	:= TRB->JBQ_ITEM
	JBQ->JBQ_DATA	:= TRB->JBQ_DATA1
	JBQ->JBQ_DATA2	:= TRB->JBQ_DATA2
	JBQ->JBQ_CODAVA	:= TRB->JBQ_CODAVA
	JBQ->JBQ_DESC	:= TRB->JBQ_DESC
	JBQ->JBQ_PESO	:= TRB->JBQ_PESO
	JBQ->JBQ_TIPO	:= TRB->JBQ_TIPO
	JBQ->JBQ_CHAMAD	:= TRB->JBQ_CHAMAD
	JBQ->JBQ_DTAPON	:= TRB->JBQ_DTAPON
	JBQ->( msUnlock() )
	
	end transaction

	TRB->( dbSkip() )
end

Return !lEnd

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE123Av   �Autor  �Rafael Rodrigues    � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida se nao existe a mesma avaliacao duas vezes no mesmo  ���
���          �periodo letivo.                                             ���
�������������������������������������������������������������������������͹��
���Uso       �GE12300                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE123Av( lEnd, cLog, cLogFile )
Local lRet		:= .T.
Local cChave	:= ""
Local lLog		:= cLog <> NIL
Local aAvas		:= {}
Local cAva		:= ""
Local dData

TRB->( dbGoTop() )

ProcRegua( TRB->( RecCount() ) )
IncProc( 'Verificando as avalia��es do curso '+Alltrim( TRB->JBQ_CODCUR )+'...' )

while TRB->( !eof() ) .and. !lEnd

	cChave	:= TRB->JBQ_CODCUR+TRB->JBQ_PERLET
	aAvas	:= {}
	dData	:= TRB->JBQ_DATA1 - 1
	
	while cChave == TRB->JBQ_CODCUR+TRB->JBQ_PERLET .and. TRB->( !eof() ) .and. !lEnd .and. ( lLog .or. lRet )
		if aScan( aAvas, TRB->JBQ_CODAVA ) > 0
			lRet := .F.
			if lLog
				U_xAddLog( cLog, '  Inconsist�ncia na linha '+StrZero( TRB->( Recno() ), 6 )+': Avalia��o "'+TRB->JBQ_CODAVA+'" encontrada duas vezes no mesmo curso vigente/per�odo letivo.', cLogFile )
			else
				exit
			endif
		else
			aAdd( aAvas, TRB->JBQ_CODAVA )
		endif
		
		if TRB->JBQ_DATA1 <= dData
			U_xAddLog( cLog, '  Inconsist�ncia na linha '+StrZero( TRB->( Recno() ), 6 )+': As datas das avalia��es '+cAva+' e '+TRB->JBQ_CODAVA+' est�o conflitantes.', cLogFile )
		endif
		
		dData	:= TRB->JBQ_DATA2
		cAva	:= TRB->JBQ_CODAVA
		TRB->( dbSkip() )
	end
	
	if !lLog .and. !lRet
		exit
	endif
end

lRet := lRet .and. !lEnd

Return lRet