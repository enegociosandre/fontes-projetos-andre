#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC10200  �Autor  �Rafael Rodrigues    � Data �  09/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Locais + Predios + Salas.             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC10200()
Private lRobo	:= .T.
Private lOver	:= .T.

aFiles := U_xAC102GA()

Return
      
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XAC10200  �Autor  �Microsiga           � Data �  12/07/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC132Do( aFiles, lBlind )
Local aStru		:= {}
Local aTables	:= {}
Local cNameFile := 'AC10200'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local nErro		:= 0
Local i

Default lBlind := .F.

if Emtpy( aFiles )
	// Gera os arrays necess�rios.
	lRobo := .F.
	
	//����������������������������������������������������������������������Ŀ
	//�Executa a janela para selecao de arquivos e importacao dos temporarios�
	//������������������������������������������������������������������������
	aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver, .F., cPerg )
endif

if Empty( aTables )	//Nenhum arquivo importado.
	AcaLog( cLogFile, '  Nenhum arquivo p�de ser importado para este processo.' )
	nErro := 1	// 	Aviso( 'Problema', 'Nenhum arquivo p�de ser importado para este processo.', {'Ok'} )
else
	
	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	nDrv := aScan( aDriver, aTables[1, 3] )

	if nDrv <> 3
		TRB->( dbGoBottom() )
		if Empty( TRB->JA3_CODLOC )
			RecLock( "TRB", .F. )
			TRB->( dbDelete() )
			TRB->( msUnlock() )
		endif
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JA3_CODLOC) '						, 'C�digo de Local/Unidade n�o informado.' } )
	aAdd( aObrig, { '!Empty(JA3_DESLOC) '						, 'Descri��o do Local/Unidade n�o informada.' } )
	aAdd( aObrig, { '!Empty(JA3_TIPO) .and. JA3_TIPO$"12"  '	, 'Tipo inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Empty(JA3_CGC) .or. U_xACChkCGC(JA3_CGC)'	, 'CNPJ inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Empty(JA3_CEP) .or. Posicione("JC2",1,xFilial("JC2")+JA3_CEP,"JC2_CEP") == JA3_CEP'	, 'CEP inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Empty(JA3_EST) .or. Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA3_EST,"X5_CHAVE"),2) == JA3_EST'	, 'Estado inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA4_CODPRE)'	, 'C�digo do Pr�dio n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA4_DESPRE)'	, 'Descri��o do Pr�dio n�o informada.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. JA4_TERREO$"12"'		, '"Considera Andar Terreo" deve ser 1 (Sim) ou 2 (N�o).' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Empty(JA4_CEP) .or. Posicione("JC2",1,xFilial("JC2")+JA4_CEP,"JC2_CEP") == JA4_CEP'	, 'CEP do pr�dio inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. Empty(JA4_EST) .or. Left(Posicione("SX5",1,xFilial("SX5")+"12"+JA4_EST,"X5_CHAVE"),2) == JA4_EST'	, 'Estado do pr�dio inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. ( Val( JA5_ANDAR ) <= ( JA4_ANDINI + JA4_ANDAR ) .and. Val( JA5_ANDAR ) >= JA4_ANDINI )'	, 'Andar da sala inv�lido.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. JA5_ANDAR == StrZero( Val( JA5_ANDAR ), Len( JA5_ANDAR ) ) '	, 'Andar da sala deve ser informado com zeros � esquerda.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA5_CODSAL)'	, 'C�digo da sala n�o informado.' } )
	aAdd( aObrig, { 'JA3_TIPO == "2" .or. !Empty(JA5_DESCSA)'	, 'Descri��o da sala n�o informada.' } )
	
	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	if nDrv <> 3
		if !lBlind
			MsgRun( 'Ordenando arquivo...',, {|| TRB->( IndRegua( "TRB", cIDX, "JA3_CODLOC+JA4_CODPRE+JA5_ANDAR+JA5_CODSAL" ) ) } )
		else
			TRB->( IndRegua( "TRB", cIDX, "JA3_CODLOC+JA4_CODPRE+JA5_ANDAR+JA5_CODSAL" ) )
		endif
	endif
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
	if !lRobo
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB", "JA3_CODLOC+JA4_CODPRE+JA5_ANDAR+JA5_CODSAL", .F., aObrig, cLogFile, @lEnd ) }, 'Valida��o do Arquivo' )
	else
		lOk := U_xACChkInt( "TRB", "JA3_CODLOC+JA4_CODPRE+JA5_ANDAR+JA5_CODSAL", .F., aObrig, cLogFile, @lEnd )
	endif
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )
	
	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.' )
		if !lRobo
			if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
				OurSpool( cNameFile )
			endif
		endif
	else
		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		if lRobo
			Processa( { |lEnd| ProcRegua( aTables[1,4] ), lOk := xAC10200Grv( @lEnd, aTables[1,4] ) }, 'Grava��o em andamento' )
		else
			lOk := xAC10200Grv( @lEnd, aTables[1,4] )
		endif
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Processo de grava��o interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.' )
			if !lRobo
				Aviso( 'Opera��o Cancelada!', 'O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', {'Ok'} )
			endif
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Grava��o realizada com sucesso.' )
			if !lRobo
				Aviso( 'Sucesso!', 'Importa��o realizada com sucesso.', {'Ok'} )
			endif
		endif
	endif
endif

//���������������������������������������Ŀ
//�Elimina os arquivos de trabalho criados�
//�����������������������������������������
for i := 1 to len( aTables )
	(aTables[i][1])->( dbCloseArea() )
	if aTables[i][3] == aDriver[1]
		FErase( aTables[i][2]+GetDBExtension() )
	endif
next i

if nDrv <> 3
	FErase( cIDX + OrdBagExt() )
endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC10200Grv�Autor  �Rafael Rodrigues   � Data �  09/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC10200                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC10200Grv( lEnd, nRecs )
Local cLocal	:= ""
Local cPredio	:= ""
Local cFilJA3	:= xFilial("JA3")	// Criada para ganhar performance
Local cFilJA4	:= xFilial("JA4")	// Criada para ganhar performance
Local cFilJA5	:= xFilial("JA5")	// Criada para ganhar performance
Local i			:= 0
Local lSeek

TRB->( dbGoTop() )

JA3->( dbSetOrder(1) )
JA4->( dbSetOrder(1) )
JA5->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	if !lRobo
		IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif
	
	begin transaction
	
	if cLocal <> TRB->JA3_CODLOC
		lSeek := JA3->( dbSeek( cFilJA3+TRB->JA3_CODLOC ) )
		if lOver .or. !lSeek
			RecLock( "JA3", !lSeek )
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
		endif
		cLocal := TRB->JA3_CODLOC
	endif
	
	if TRB->JA3_TIPO == '1'
		if cLocal <> TRB->JA3_CODLOC .or. cPredio <> TRB->JA4_CODPRE
			lSeek := JA4->( dbSeek( cFilJA4+TRB->JA3_CODLOC+TRB->JA4_CODPRE ) )
			if lOver .or. !lSeek
				RecLock( "JA4", !lSeek )
				JA4->JA4_FILIAL	:= cFilJA4
				JA4->JA4_CODLOC	:= TRB->JA3_CODLOC
				JA4->JA4_CODPRE	:= TRB->JA4_CODPRE
				JA4->JA4_DESPRE	:= TRB->JA4_DESPRE
				JA4->JA4_ANDAR	:= TRB->JA4_ANDAR
				JA4->JA4_TERREO	:= TRB->JA4_TERREO
				JA4->JA4_ANDINI	:= TRB->JA4_ANDINI
				JA4->( msUnlock() )
			endif
			cPredio	:= TRB->JA4_CODPRE
		endif
		
		lSeek := JA5->( dbSeek( cFilJA5+TRB->JA3_CODLOC+TRB->JA4_CODPRE+TRB->JA5_ANDAR+TRB->JA5_CODSAL ) )
		if lOver .or. !lSeek
			RecLock( "JA5", !lSeek )
			JA5->JA5_FILIAL	:= cFilJA5
			JA5->JA5_CODLOC	:= TRB->JA3_CODLOC
			JA5->JA5_CODPRE	:= TRB->JA4_CODPRE
			JA5->JA5_ANDAR	:= TRB->JA5_ANDAR
			JA5->JA5_CODSAL	:= TRB->JA5_CODSAL
			JA5->JA5_DESCSA	:= TRB->JA5_DESCSA
			JA5->JA5_LUGAR	:= TRB->JA5_LUGAR
			JA5->( msUnlock() )
		endif
	endif
	
	end transaction

	TRB->( dbSkip() )
end

Return !lEnd

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XAC102GA  �Autor  �Rafael Rodrigues    � Data �  11/30/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera os arrays utilizados na importacao                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xac10200 e xacrobot                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC102GA()
Local aStru  := {}
Local aFiles := {}

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
aAdd( aStru, { "JA4_CEP"   , "C", 008, 0 } )
aAdd( aStru, { "JA4_END"   , "C", 040, 0 } )
aAdd( aStru, { "JA4_NUMEND", "C", 005, 0 } )
aAdd( aStru, { "JA4_COMPLE", "C", 020, 0 } )
aAdd( aStru, { "JA4_BAIRRO", "C", 020, 0 } )
aAdd( aStru, { "JA4_CIDADE", "C", 020, 0 } )
aAdd( aStru, { "JA4_EST"   , "C", 002, 0 } )
aAdd( aStru, { "JA4_OBSERV", "C", 080, 0 } )
aAdd( aStru, { "JA5_ANDAR" , "C", 003, 0 } )
aAdd( aStru, { "JA5_CODSAL", "C", 006, 0 } )
aAdd( aStru, { "JA5_DESCSA", "C", 030, 0 } )
aAdd( aStru, { "JA5_LUGAR" , "N", 004, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Cadastro de Locais', 'AC10200', aClone( aStru ), 'TRB', .T., "JA3_CODLOC, JA4_CODPRE, JA5_ANDAR, JA5_CODSAL" } )

Return aFiles