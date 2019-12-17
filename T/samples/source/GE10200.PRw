#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE10200   �Autor  �Rafael Rodrigues    � Data �  09/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Locais + Predios + Salas.             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE10200()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC10200.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JA3_CODLOC", "C", 006, 0 } )
aAdd( aStru, { "JA3_DESLOC", "C", 030, 0 } )
aAdd( aStru, { "JA3_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JA3_CGC"   , "C", 014, 0 } )
aAdd( aStru, { "JA3_CEP"   , "C", 008, 0 } )
aAdd( aStru, { "JA3_END"   , "C", 040, 0 } )
aAdd( aStru, { "JA3_NUMEND", "C", 005, 0 } )
aAdd( aStru, { "JA3_COMPLE", "C", 020, 0 } )
aAdd( aStru, { "JA3_BAIRRO", "C", 020, 0 } )
aAdd( aStru, { "JA3_CIDADE", "C", 020, 0 } )
aAdd( aStru, { "JA3_EST"   , "C", 002, 0 } )
aAdd( aStru, { "JA3_FONE"  , "C", 015, 0 } )
aAdd( aStru, { "JA3_LOGO"  , "C", 030, 0 } )
aAdd( aStru, { "JA3_MAPA"  , "C", 030, 0 } )
aAdd( aStru, { "JA4_CODPRE", "C", 006, 0 } )
aAdd( aStru, { "JA4_DESPRE", "C", 030, 0 } )
aAdd( aStru, { "JA4_ANDAR" , "N", 003, 0 } )
aAdd( aStru, { "JA4_TERREO", "C", 001, 0 } )
aAdd( aStru, { "JA4_ANDINI", "N", 003, 0 } )
aAdd( aStru, { "JA5_ANDAR" , "C", 003, 0 } )
aAdd( aStru, { "JA5_CODSAL", "C", 006, 0 } )
aAdd( aStru, { "JA5_DESCSA", "C", 030, 0 } )
aAdd( aStru, { "JA5_LUGAR" , "N", 004, 0 } )

aAdd( aFiles, { 'Cadastro de Locais', '\Import\AC10200.TXT', aStru, 'TRB', .T. } )

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
	if Empty( TRB->JA3_CODLOC )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JA3_CODLOC) '						, 'C�digo de Local/Unidade n�o informado.' } )
	aAdd( aObrig, { '!Empty(JA3_DESLOC) '						, 'Descri��o do Local/Unidade n�o informada.' } )
	aAdd( aObrig, { '!Empty(JA3_TIPO) .and. JA3_TIPO$"12"  '		, 'Tipo inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA3_CGC)'		, 'CNPJ n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. U_GEChkCGC(JA3_CGC)'	, 'CNPJ inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA3_CEP)'		, 'CEP n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Posicione("JC2",1,xFilial("JC2")+JA3_CEP,"JC2_CEP") == JA3_CEP'	, 'CEP inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA3_END)'		, 'Logradouro n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA3_NUMEND)'	, 'N�mero do logradouro n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA3_BAIRRO)'	, 'Bairro n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA3_CIDADE)'	, 'Cidade n�o informada.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA3_EST)'		, 'Estado n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA3_EST,"X5_CHAVE"),2) == JA3_EST'	, 'Estado inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA3_FONE)'		, 'Telefone n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA4_CODPRE)'	, 'C�digo do Pr�dio n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA4_CODPRE)'	, 'C�digo do Pr�dio n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA4_DESPRE)'	, 'Descri��o do Pr�dio n�o informada.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. JA4_TERREO$"12"'		, '"Considera Andar Terreo" deve ser 1 (Sim) ou 2 (N�o).' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA4_ANDINI)'	, 'Andar inicial n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. ( Val( JA5_ANDAR ) <= ( JA4_ANDINI + JA4_ANDAR ) .and. Val( JA5_ANDAR ) >= JA4_ANDINI )'	, 'Andar da sala inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. JA5_ANDAR == StrZero( Val( JA5_ANDAR ), Len( JA5_ANDAR ) ) '	, 'Andar da sala deve ser informado com zeros � esquerda.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA5_CODSAL)'	, 'C�digo da sala n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA5_DESCSA)'	, 'Descri��o da sala n�o informada.' } )
	
	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JA3_CODLOC+JA4_CODPRE+JA5_ANDAR+JA5_CODSAL" ) } )
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JA3_CODLOC+JA4_CODPRE+JA5_ANDAR+JA5_CODSAL", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) }, 'Valida��o do Arquivo' )
	
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
		Processa( { |lEnd| lOk := GE10200Grv( @lEnd ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE10200Grv �Autor  �Rafael Rodrigues   � Data �  09/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE10200                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE10200Grv( lEnd )
Local cLocal	:= ""
Local cPredio	:= ""
Local cFilJA3	:= xFilial("JA3")	// Criada para ganhar performance
Local cFilJA4	:= xFilial("JA4")	// Criada para ganhar performance
Local cFilJA5	:= xFilial("JA5")	// Criada para ganhar performance
Local i			:= 0

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JA3->( dbSetOrder(1) )
JA4->( dbSetOrder(1) )
JA5->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )
	
	begin transaction
	
	if cLocal <> TRB->JA3_CODLOC
		RecLock( "JA3", JA3->( !dbSeek( cFilJA3+TRB->JA3_CODLOC ) ) )
		JA3->JA3_FILIAL	:= cFilJA3
		JA3->JA3_CODLOC	:= TRB->JA3_CODLOC
		JA3->JA3_DESLOC	:= TRB->JA3_DESLOC
		JA3->JA3_CGC	:= TRB->JA3_CGC
		JA3->JA3_CEP	:= TRB->JA3_CEP
		JA3->JA3_END	:= TRB->JA3_END
		JA3->JA3_NUMEND	:= TRB->JA3_NUMEND
		JA3->JA3_COMPLE	:= TRB->JA3_COMPLE
		JA3->JA3_BAIRRO	:= TRB->JA3_BAIRRO
		JA3->JA3_CIDADE	:= TRB->JA3_CIDADE
		JA3->JA3_EST	:= TRB->JA3_EST
		JA3->JA3_FONE	:= TRB->JA3_FONE
		JA3->JA3_TIPO	:= TRB->JA3_TIPO
		JA3->JA3_LOGO	:= TRB->JA3_LOGO
		JA3->JA3_MAPA	:= TRB->JA3_MAPA
		JA3->( msUnlock() )
		cLocal := TRB->JA3_CODLOC
	endif
	
	if TRB->JA3_TIPO == '1'
		if cLocal <> TRB->JA3_CODLOC .or. cPredio <> TRB->JA4_CODPRE
			RecLock( "JA4", JA4->( !dbSeek( cFilJA4+TRB->JA3_CODLOC+TRB->JA4_CODPRE ) ) )
			JA4->JA4_FILIAL	:= cFilJA4
			JA4->JA4_CODLOC	:= TRB->JA3_CODLOC
			JA4->JA4_CODPRE	:= TRB->JA4_CODPRE
			JA4->JA4_DESPRE	:= TRB->JA4_DESPRE
			JA4->JA4_ANDAR	:= TRB->JA4_ANDAR
			JA4->JA4_TERREO	:= TRB->JA4_TERREO
			JA4->JA4_ANDINI	:= TRB->JA4_ANDINI
			JA4->( msUnlock() )
			cPredio	:= TRB->JA4_CODPRE
		endif
		
		RecLock( "JA5", JA5->( !dbSeek( cFilJA5+TRB->JA3_CODLOC+TRB->JA4_CODPRE+TRB->JA5_ANDAR+TRB->JA5_CODSAL ) ) )
		JA5->JA5_FILIAL	:= cFilJA5
		JA5->JA5_CODLOC	:= TRB->JA3_CODLOC
		JA5->JA5_CODPRE	:= TRB->JA4_CODPRE
		JA5->JA5_ANDAR	:= TRB->JA5_ANDAR
		JA5->JA5_CODSAL	:= TRB->JA5_CODSAL
		JA5->JA5_DESCSA	:= TRB->JA5_DESCSA
		JA5->JA5_LUGAR	:= TRB->JA5_LUGAR
		JA5->( msUnlock() )
	endif
	
	end transaction

	TRB->( dbSkip() )
end

Return !lEnd