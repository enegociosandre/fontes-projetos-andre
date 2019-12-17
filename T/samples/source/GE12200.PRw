#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12200   �Autor  �Rafael Rodrigues    � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Grade Curricular dos Cursos Vigentes  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE12200()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC12200.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local cIDX03	:= CriaTrab( nil, .F. )
Local lDBF01	:= .F.
Local lDBF02	:= .F.
Local lDBF03	:= .F.
Local nRecs		:= 0
Local i         := 0

aAdd( aStru, { "JAS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JAS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAS_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JAS_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAS_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAS_FRQMIN", "N", 003, 0 } )
aAdd( aStru, { "JAS_QTDFAT", "N", 003, 0 } )
aAdd( aStru, { "JAS_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JAS_VALOR" , "N", 012, 2 } )
aAdd( aStru, { "JAS_DATA1" , "D", 008, 0 } )
aAdd( aStru, { "JAS_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JAS_TIPNOT", "C", 001, 0 } )
aAdd( aStru, { "JAS_ESCDIA", "C", 001, 0 } )

aAdd( aFiles, { 'Grades dos Cursos Vigentes', '\Import\AC12201.TXT', aClone( aStru ), 'TRB01', .F. } )

aStru := {}

aAdd( aStru, { "JAS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JAS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAS_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JAS_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAS_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAS_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Conte�dos Program�ticos', '\Import\AC12202.TXT', aClone( aStru ), 'TRB02', .F. } )

aStru := {}

aAdd( aStru, { "JAS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JAS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAS_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JAS_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAS_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAS_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Bibliografias', '\Import\AC12203.TXT', aClone( aStru ), 'TRB03', .F. } )

//����������������������������������������������������������������������Ŀ
//�Executa a janela para selecao de arquivos e importacao dos temporarios�
//������������������������������������������������������������������������
aTables	:= U_GEGetF( aFiles, @lForceLog )

if Empty( aTables )	//Nenhum arquivo importado.
	U_xAddLog( cLog, '  Nenhum arquivo p�de ser importado para este processo.', if( lForceLog, cLogFile, nil ) )
	Aviso( 'Problema', 'Nenhum arquivo p�de ser importado para este processo.', {'Ok'} )
else
	
	lDBF01	:= aScan( aTables, {|x| x[1] == "TRB01"} ) > 0
	lDBF02	:= aScan( aTables, {|x| x[1] == "TRB02"} ) > 0
	lDBF03	:= aScan( aTables, {|x| x[1] == "TRB03"} ) > 0

	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	if lDBF01
		TRB01->( dbGoBottom() )
		if Empty( TRB01->JAS_CODCUR )
			RecLock( "TRB01", .F. )
			TRB01->( dbDelete() )
			TRB01->( msUnlock() )
		endif
	endif

	if lDBF02
		TRB02->( dbGoBottom() )
		if Empty( TRB02->JAS_CODCUR )
			RecLock( "TRB02", .F. )
			TRB02->( dbDelete() )
			TRB02->( msUnlock() )
		endif
	endif

	if lDBF03
		TRB03->( dbGoBottom() )
		if Empty( TRB03->JAS_CODCUR )
			RecLock( "TRB03", .F. )
			TRB03->( dbDelete() )
			TRB03->( msUnlock() )
		endif
	endif

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	MsgRun( 'Ordenando arquivos...',, {||	if( lDBF01, IndRegua( "TRB01", cIDX01, "JAS_CODCUR+JAS_PERLET+JAS_ITEM" ), NIL ),;
											if( lDBF02, IndRegua( "TRB02", cIDX02, "JAS_CODCUR+JAS_PERLET+JAS_ITEM+JAS_SEQ" ), NIL ),;
											if( lDBF03, IndRegua( "TRB03", cIDX03, "JAS_CODCUR+JAS_PERLET+JAS_ITEM+JAS_SEQ" ), NIL ) } )

	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	if lDBF01
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAS_CODCUR) '	, 'C�digo do curso vigente n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_PERLET) '	, 'Per�odo letivo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_ITEM)   '	, 'Item n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_CODDIS) '	, 'Disciplina n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAS_CARGA)  '	, 'Carga Hor�ria n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAS_FRQMIN) '	, 'Frequ�ncia m�nima n�o informada.' } )
		aAdd( aObrig, { 'StrZero( Val( JAS_ITEM ), 2 ) == JAS_ITEM', 'Item deve ser preenchido com zeros � esquerda (ex: 01, 02...).' } )
		aAdd( aObrig, { 'JAS_TIPO$"12"'			, 'Tipo deve ser 1 (Obrigat�ria) ou 2 (Optativa).' } )
		aAdd( aObrig, { 'JAS_TIPNOT$"123"'		, 'Tipo de nota deve ser 1 (Nota �nica), 2 (Por Avalia��o) ou 3 (Por Atividades).' } )
		aAdd( aObrig, { 'JAS_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JAS_CODCUR, "JAH_CODIGO" )', 'Curso vigente n�o cadastrado na tabela JAH.' } )
		aAdd( aObrig, { 'JAS_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JAS_CODCUR+JAS_PERLET, "JAR_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
		aAdd( aObrig, { 'JAS_CODDIS == Posicione( "JAE", 1, xFilial("JAE")+JAS_CODDIS, "JAE_CODIGO" )', 'Disciplina n�o cadastrada na tabela JAE.' } )
		aAdd( aObrig, { '( Empty( JAS_DATA1 ) .and. Empty( JAS_DATA2 ) ) .or. ( !Empty( JAS_DATA1 ) .and. !Empty( JAS_DATA2 ) )', 'Datas de in�cio e fim da disciplina devem ser informadas conjuntamente.' } )
		aAdd( aObrig, { 'Empty( JAS_DATA1 ) .or. Empty( JAS_DATA2 ) .or. JAS_DATA1 <= JAS_DATA2', 'Data de in�cio da disciplina deve ser menor que a data final.' } )
		aAdd( aObrig, { 'JAS_ESCDIA$"12"', '"Escolhe dia?" deve ser 1=Sim ou 2=N�o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB01", "JAS_CODCUR+JAS_PERLET+JAS_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[1,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF02
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAS_CODCUR) '	, 'C�digo do curso vigente n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_PERLET) '	, 'Per�odo letivo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_ITEM)   '	, 'Item n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_CODDIS) '	, 'Disciplina n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAS_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAS_CODCUR == Posicione( "JAS", 1, xFilial("JAS")+JAS_CODCUR+JAS_PERLET+JAS_ITEM, "JAS_CODCUR" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB02->JAS_CODCUR+TRB02->JAS_PERLET+TRB02->JAS_ITEM, .F. ) ) )'	, 'Curso vigente n�o cadastrado na tabela JAS e n�o presente nos arquivos de importa��o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB02", "JAS_CODCUR+JAS_PERLET+JAS_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[2,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[2,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if lDBF03
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAS_CODCUR) '	, 'C�digo do curso vigente n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_PERLET) '	, 'Per�odo letivo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_ITEM)   '	, 'Item n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_CODDIS) '	, 'Disciplina n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAS_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		aAdd( aObrig, { 'JAS_CODCUR == Posicione( "JAS", 1, xFilial("JAS")+JAS_CODCUR+JAS_PERLET+JAS_ITEM, "JAS_CODCUR" ) .or. ( Select("TRB01") > 0 .and. TRB01->( dbSeek( TRB03->JAS_CODCUR+TRB03->JAS_PERLET+TRB03->JAS_ITEM, .F. ) ) )'	, 'Curso vigente n�o cadastrado na tabela JAS e n�o presente nos arquivos de importa��o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		U_xAddLog( cLog, '  .Iniciando valida��o do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
		Processa( { |lEnd| lOk := U_GEChkInt( "TRB03", "JAS_CODCUR+JAS_PERLET+JAS_ITEM", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Validando '+aFiles[3,1] )
		U_xAddLog( cLog, '  .Fim da valida��o do arquivo "'+aFiles[3,1]+'".', if( lForceLog, cLogFile, nil ) )
	endif	

	if !lOk
		U_xAddLog( cLog, '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.', if( lForceLog, cLogFile, nil ) )
		if Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			U_xSaveLog( cLog, 'c:\'+cLogFile )
			WinExec( 'Notepad.exe c:\'+cLogFile )
		endif
	else

		nRecs += if( lDBF01, TRB01->( RecCount() ), 0 )
		nRecs += if( lDBF02, TRB02->( RecCount() ), 0 )
		nRecs += if( lDBF03, TRB03->( RecCount() ), 0 )

		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		Processa( { |lEnd| ProcRegua( nRecs ), lOk := GE12201Grv( @lEnd, aFiles[1,1] ) .and. GE12202Grv( @lEnd, aFiles[2,1] ) .and. GE12203Grv( @lEnd, aFiles[3,1] ) }, 'Grava��o em andamento' )
		
		if !lOk
			U_xAddLog( cLog, '! Processo de grava��o interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Opera��o Cancelada!', 'O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', {'Ok'} )
		else
			U_xAddLog( cLog, '! Grava��o realizada com sucesso.', if( lForceLog, cLogFile, nil ) )
			Aviso( 'Sucesso!', 'Importa��o realizada com sucesso.', {'Ok'} )
		endif
	endif
	
	FErase( cIDX01 + OrdBagExt() )
	FErase( cIDX02 + OrdBagExt() )
	FErase( cIDX03 + OrdBagExt() )
	
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
���Programa  �GE12201Grv �Autor  �Rafael Rodrigues   � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados do arquivo principal na base.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12200                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12201Grv( lEnd, cTitulo )
Local cFilJAS	:= xFilial("JAS")	// Criada para ganhar performance
Local i			:= 0

if Select( "TRB01" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB01->( dbGoTop() )

JAS->( dbSetOrder(1) )

while TRB01->( !eof() ) .and. !lEnd
	
	IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB01->( RecCount() ), 6 )+'...' )
	
	begin transaction
	
	RecLock( "JAS", JAS->( !dbSeek( cFilJAS+TRB01->JAS_CODCUR+TRB01->JAS_PERLET+TRB01->JAS_ITEM ) ) )
	JAS->JAS_FILIAL	:= cFilJAS
	JAS->JAS_CODCUR	:= TRB01->JAS_CODCUR
	JAS->JAS_PERLET	:= TRB01->JAS_PERLET
	JAS->JAS_ITEM	:= TRB01->JAS_ITEM
	JAS->JAS_CODDIS	:= TRB01->JAS_CODDIS
	JAS->JAS_CARGA	:= TRB01->JAS_CARGA
	JAS->JAS_FRQMIN	:= TRB01->JAS_FRQMIN
	JAS->JAS_QTDFAT	:= TRB01->JAS_QTDFAT
	JAS->JAS_TIPO	:= TRB01->JAS_TIPO
	JAS->JAS_VALOR	:= TRB01->JAS_VALOR
	JAS->JAS_DATA1	:= TRB01->JAS_DATA1
	JAS->JAS_DATA2	:= TRB01->JAS_DATA2
	JAS->JAS_ESCDIA	:= TRB01->JAS_ESCDIA
	JAS->( msUnlock() )
	
	end transaction

	TRB01->( dbSkip() )
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12202Grv �Autor  �Rafael Rodrigues   � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12200                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12202Grv( lEnd, cTitulo )
Local cFilJAS	:= xFilial("JAS")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB02" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB02->( dbGoTop() )

JAS->( dbSetOrder(1) )

while TRB02->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB02->JAS_CODCUR+TRB02->JAS_PERLET+TRB02->JAS_ITEM
	
	while cChave == TRB02->JAS_CODCUR+TRB02->JAS_PERLET+TRB02->JAS_ITEM .and. TRB02->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB02->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB02->JAS_MEMO1, '\13\10', CRLF )
		
		TRB02->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAS->( dbSeek( cFilJAS+cChave ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAS_CONTEU�
		//�e armazena o codigo do memo no campo JAS_MEMO1. Sobrescreve caso JAS_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAS", .F. )
		MSMM( JAS->JAS_MEMO1, TamSX3("JAS_CONTEU")[1],, cMemo, 1,,, "JAS", "JAS_MEMO1" )
		JAS->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12203Grv �Autor  �Rafael Rodrigues   � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados das Bibliografias na base.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12200                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12203Grv( lEnd, cTitulo )
Local cFilJAS	:= xFilial("JAS")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB03" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB03->( dbGoTop() )

JAS->( dbSetOrder(1) )

while TRB03->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB03->JAS_CODCUR+TRB03->JAS_PERLET+TRB03->JAS_ITEM
	
	while cChave == TRB03->JAS_CODCUR+TRB03->JAS_PERLET+TRB03->JAS_ITEM .and. TRB03->( !eof() ) .and. !lEnd
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB03->( RecCount() ), 6 )+'...' )

		cMemo += StrTran( TRB03->JAS_MEMO2, '\13\10', CRLF )
		
		TRB03->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAS->( dbSeek( cFilJAS+cChave ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAS_BIBLIO�
		//�e armazena o codigo do memo no campo JAS_MEMO2. Sobrescreve caso JAS_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAS", .F. )
		MSMM( JAS->JAS_MEMO2, TamSX3("JAS_BIBLIO")[1],, cMemo, 1,,, "JAS", "JAS_MEMO2" )
		JAS->( msUnlock() )

		end transaction
	endif

end

Return !lEnd