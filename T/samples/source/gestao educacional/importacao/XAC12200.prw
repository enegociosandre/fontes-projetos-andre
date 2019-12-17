#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12200  �Autor  �Rafael Rodrigues    � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Grade Curricular dos Cursos Vigentes  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC12200( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC12200'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local cIDX03	:= CriaTrab( nil, .F. )
Local lTRB12201	:= .F.
Local lTRB12202	:= .F.
Local lTRB12203	:= .F.
Local nRec01	:= 0
Local nRec02	:= 0
Local nRec03	:= 0
Local nRecs		:= 0
Local nPos
Local cArq01	:= ""
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local i

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JAS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JAS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAS_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JAS_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAS_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAS_FRQMIN", "N", 003, 0 } )
aAdd( aStru, { "JAS_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JAS_DATA1" , "D", 008, 0 } )
aAdd( aStru, { "JAS_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JAS_TIPNOT", "C", 001, 0 } )
aAdd( aStru, { "JAS_ESCDIA", "C", 001, 0 } )
aAdd( aStru, { "JAS_AMG_"  , "C", 001, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Grades dos Cursos Vigentes', 'AC12201', aClone( aStru ), 'TRB12201', .F., 'JAS_CODCUR, JAS_PERLET, JAS_HABILI, JAS_CODDIS', {|| "JAS_CODCUR in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JAS_CODCUR and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

aStru := {}

aAdd( aStru, { "JAS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JAS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAS_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JAS_CODDIS", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAS_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAS_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Conte�dos Program�ticos', 'AC12202', aClone( aStru ), 'TRB12202', .F., 'JAS_CODCUR, JAS_PERLET, JAS_HABILI, JAS_CODDIS, JAS_SEQ', {|| "JAS_CODCUR in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JAS_CODCUR and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

aStru := {}

aAdd( aStru, { "JAS_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JAS_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAS_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JAS_CODDIS", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAS_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAS_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Bibliografias', 'AC12203', aClone( aStru ), 'TRB12203', .F., 'JAS_CODCUR, JAS_PERLET, JAS_HABILI, JAS_CODDIS, JAS_SEQ', {|| "JAS_CODCUR in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JAS_CODCUR and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

//����������������������������������������������������������������������Ŀ
//�Executa a janela para selecao de arquivos e importacao dos temporarios�
//������������������������������������������������������������������������
if nOpc == 2	// So processamento
	U_xOpen( aTables, aFiles, aDriver, .F. )
else
	aTables	:= U_xACGetF( aFiles, aDriver, cLogFile, @lOver )
	if nOpc == 1
		Return aTables
	endif
endif

if Empty( aTables )	//Nenhum arquivo importado.
	AcaLog( cLogFile, '  Nenhum arquivo p�de ser importado para este processo.' )
	if nOpc == 0
		Aviso( 'Problema', 'Nenhum arquivo p�de ser importado para este processo.', {'Ok'} )
	endif
else
	
	nPos := aScan( aTables, {|x| x[1] == "TRB12201"} )
	if nPos > 0
		lTRB12201	:= .T.
		nDrv01	:= aScan( aDriver, aTables[nPos, 3] )
		nRec01	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
		cArq01	:= aTables[nPos, 2]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB12202"} )
	if nPos > 0
		lTRB12202	:= .T.
		nDrv02	:= aScan( aDriver, aTables[nPos, 3] )
		nRec02	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB12203"} )
	if nPos > 0
		lTRB12203	:= .T.
		nDrv03	:= aScan( aDriver, aTables[nPos, 3] )
		nRec03	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	if lTRB12201 .and. nDrv01 <> 3
		TRB12201->( dbGoBottom() )
		if Empty( TRB12201->JAS_CODCUR )
			RecLock( "TRB12201", .F. )
			TRB12201->( dbDelete() )
			TRB12201->( msUnlock() )
		endif
	endif

	if lTRB12202 .and. nDrv02 <> 3
		TRB12202->( dbGoBottom() )
		if Empty( TRB12202->JAS_CODCUR )
			RecLock( "TRB12202", .F. )
			TRB12202->( dbDelete() )
			TRB12202->( msUnlock() )
		endif
	endif

	if lTRB12203 .and. nDrv03 <> 3
		TRB12203->( dbGoBottom() )
		if Empty( TRB12203->JAS_CODCUR )
			RecLock( "TRB12203", .F. )
			TRB12203->( dbDelete() )
			TRB12203->( msUnlock() )
		endif
	endif

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	if nOpc == 0
		MsgRun( 'Ordenando arquivos...',, {||	if( lTRB12201 .and. nDrv01 <> 3, TRB12201->( IndRegua( "TRB12201", cIDX01, "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS" ) ), NIL ),;
												if( lTRB12202 .and. nDrv02 <> 3, TRB12202->( IndRegua( "TRB12202", cIDX02, "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS+JAS_SEQ" ) ), NIL ),;
												if( lTRB12203 .and. nDrv03 <> 3, TRB12203->( IndRegua( "TRB12203", cIDX03, "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS+JAS_SEQ" ) ), NIL ) } )
	else
		Eval( {||	if( lTRB12201 .and. nDrv01 <> 3, TRB12201->( IndRegua( "TRB12201", cIDX01, "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS" ) ), NIL ),;
					if( lTRB12202 .and. nDrv02 <> 3, TRB12202->( IndRegua( "TRB12202", cIDX02, "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS+JAS_SEQ" ) ), NIL ),;
					if( lTRB12203 .and. nDrv03 <> 3, TRB12203->( IndRegua( "TRB12203", cIDX03, "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS+JAS_SEQ" ) ), NIL ) } )
	endif
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	if lTRB12201
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAS_CODCUR) '	, 'C�digo do curso vigente n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_PERLET) '	, 'Per�odo letivo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_CODDIS) '	, 'Disciplina n�o informada.' } )
		//aAdd( aObrig, { '!Empty(JAS_CARGA)  '	, 'Carga Hor�ria n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAS_FRQMIN) '	, 'Frequ�ncia m�nima n�o informada.' } )
		aAdd( aObrig, { 'JAS_TIPO$"12"'			, 'Tipo deve ser 1 (Obrigat�ria) ou 2 (Optativa).' } )
		aAdd( aObrig, { 'JAS_TIPNOT$"123"'		, 'Tipo de nota deve ser 1 (Nota �nica), 2 (Por Avalia��o) ou 3 (Por Atividades).' } )
		aAdd( aObrig, { 'JAS_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JAS_CODCUR+JAS_PERLET+JAS_HABILI+, "JAR_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
		aAdd( aObrig, { 'U_xAC122AY( JAS_CODCUR, JAS_PERLET, JAS_HABILI, JAS_CODDIS )', 'Disciplina n�o cadastrada na grade curricular do curso padrao.' } )
		aAdd( aObrig, { '( Empty( JAS_DATA1 ) .and. Empty( JAS_DATA2 ) ) .or. ( !Empty( JAS_DATA1 ) .and. !Empty( JAS_DATA2 ) )', 'Datas de in�cio e fim da disciplina devem ser informadas conjuntamente.' } )
		aAdd( aObrig, { 'Empty( JAS_DATA1 ) .or. Empty( JAS_DATA2 ) .or. JAS_DATA1 <= JAS_DATA2', 'Data de in�cio da disciplina deve ser menor que a data final.' } )
		aAdd( aObrig, { 'JAS_ESCDIA$"12"', '"Escolhe dia?" deve ser 1=Sim ou 2=N�o.' } )
		aAdd( aObrig, { 'JAS_AMG_$"12"', 'AMG deve ser 1=Sim ou 2=N�o.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB12201", "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS", .F., aObrig, cLogFile, @lEnd, nRec01 ) .and. lOk }, 'Validando '+aFiles[1,1] )
		else
			lOk := U_xACChkInt( "TRB12201", "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS", .F., aObrig, cLogFile, @lEnd, nRec01 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )
	endif	

	if lTRB12202
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAS_CODCUR) '	, 'C�digo do curso vigente n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_PERLET) '	, 'Per�odo letivo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_CODDIS) '	, 'Disciplina n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAS_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAS_CODCUR == Posicione( "JAS", 2, xFilial("JAS")+JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS, "JAS_CODCUR" ) .or. ( Select("TRB12201") > 0 .and. TRB12201->( dbSeek( TRB12202->JAS_CODCUR+TRB12202->JAS_PERLET+TRB12202->JAS_HABILI+TRB12202->JAS_CODDIS, .F. ) ) )'	, 'Curso vigente n�o cadastrado na tabela JAS e n�o presente nos arquivos de importa��o.' } )
		else
			aAdd( aObrig, { 'JAS_CODCUR == Posicione( "JAS", 2, xFilial("JAS")+JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS, "JAS_CODCUR" ) .or. ( Select("TRB12201") > 0 .and. U_xAC122Qry( JAS_CODCUR, JAS_PERLET, JAS_HABILI, JAS_CODDIS, "'+cArq01+'" ) )'	, 'Curso vigente n�o cadastrado na tabela JAS e n�o presente nos arquivos de importa��o.' } )
		endif
		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[2,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB12202", "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS+JAS_SEQ", .F., aObrig, cLogFile, @lEnd, nRec02 ) .and. lOk }, 'Validando '+aFiles[2,1] )
		else
			lOk := U_xACChkInt( "TRB12202", "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS+JAS_SEQ", .F., aObrig, cLogFile, @lEnd, nRec02 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[2,1]+'".' )
	endif	

	if lTRB12203
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAS_CODCUR) '	, 'C�digo do curso vigente n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_PERLET) '	, 'Per�odo letivo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAS_CODDIS) '	, 'Disciplina n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAS_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAS_CODCUR == Posicione( "JAS", 2, xFilial("JAS")+JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS, "JAS_CODCUR" ) .or. ( Select("TRB12201") > 0 .and. TRB12201->( dbSeek( TRB12203->JAS_CODCUR+TRB12202->JAS_PERLET+TRB12202->JAS_HABILI+TRB12202->JAS_CODDIS, .F. ) ) )'	, 'Curso vigente n�o cadastrado na tabela JAS e n�o presente nos arquivos de importa��o.' } )
		else
			aAdd( aObrig, { 'JAS_CODCUR == Posicione( "JAS", 2, xFilial("JAS")+JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS, "JAS_CODCUR" ) .or. ( Select("TRB12201") > 0 .and. U_xAC122Qry( JAS_CODCUR, JAS_PERLET, JAS_HABILI, JAS_CODDIS, "'+cArq01+'" ) )'	, 'Curso vigente n�o cadastrado na tabela JAS e n�o presente nos arquivos de importa��o.' } )
		endif
		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[3,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB12203", "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS+JAS_SEQ", .F., aObrig, cLogFile, @lEnd, nRec03 ) .and. lOk }, 'Validando '+aFiles[3,1] )
		else
			lOk := U_xACChkInt( "TRB12203", "JAS_CODCUR+JAS_PERLET+JAS_HABILI+JAS_CODDIS+JAS_SEQ", .F., aObrig, cLogFile, @lEnd, nRec03 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[3,1]+'".' )
	endif	

	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Foram detectadas inconsist�ncias. Imposs�vel prosseguir.' )
		if nOpc == 0 .and. Aviso( 'Imposs�vel Prosseguir!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'} ) == 2
			OurSpool( cNameFile )
		endif
	else

		//���������������������������������������������������Ŀ
		//�Realiza a gravacao dos dados nas tabelas do sistema�
		//�����������������������������������������������������
		if nOpc == 0
			Processa( { |lEnd| ProcRegua( nRecs ), lOk := xAC12201Grv( @lEnd, aFiles[1,1], nRec01 ) .and. xAC12202Grv( @lEnd, aFiles[2,1], nRec02 ) .and. xAC12203Grv( @lEnd, aFiles[3,1], nRec03 ) }, 'Grava��o em andamento' )
		else
		endif
		
		if !lOk
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Processo de grava��o interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.' )
			if nOpc == 0
				Aviso( 'Opera��o Cancelada!', 'O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', {'Ok'} )
			endif
		else
			AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '! Grava��o realizada com sucesso.' )
			if nOpc == 0
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

if lTRB12201 .and. nDrv01 <> 3
	FErase( cIDX01 + OrdBagExt() )
endif
if lTRB12202 .and. nDrv02 <> 3
	FErase( cIDX02 + OrdBagExt() )
endif
if lTRB12203 .and. nDrv03 <> 3
	FErase( cIDX03 + OrdBagExt() )
endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12201Grv�Autor  �Rafael Rodrigues   � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados do arquivo principal na base.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC12200                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC12201Grv( lEnd, cTitulo, nRecs )
Local cFilJAS	:= xFilial("JAS")	// Criada para ganhar performance
Local i			:= 0
Local nItem		:= 0
Local nItemSize	:= TamSX3("JAS_ITEM")[1]
Local cChave	:= ""
Local lSeek

if Select( "TRB12201" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB12201->( dbGoTop() )

JAS->( dbSetOrder(2) )

while TRB12201->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif
	
	if cChave <> TRB12201->( JAS_CODCUR+JAS_PERLET+JAS_HABILI )
		cChave := TRB12201->( JAS_CODCUR+JAS_PERLET+JAS_HABILI )
		nItem  := 0
	endif

	begin transaction
	
	lSeek := JAS->( dbSeek( cFilJAS+TRB12201->JAS_CODCUR+TRB12201->JAS_PERLET+TRB12201->JAS_HABILI+TRB12201->JAS_CODDIS ) )
	if lOver .or. !lSeek
		RecLock( "JAS", !lSeek )
		JAS->JAS_FILIAL	:= cFilJAS
		JAS->JAS_CODCUR	:= TRB12201->JAS_CODCUR
		JAS->JAS_PERLET	:= TRB12201->JAS_PERLET
		JAS->JAS_HABILI	:= TRB12201->JAS_HABILI
		JAS->JAS_ITEM	:= StrZero( ++nItem, nItemSize )
		JAS->JAS_CODDIS	:= TRB12201->JAS_CODDIS
		JAS->JAS_CARGA	:= TRB12201->JAS_CARGA
		JAS->JAS_FRQMIN	:= TRB12201->JAS_FRQMIN
		JAS->JAS_TIPO	:= TRB12201->JAS_TIPO
		JAS->JAS_DATA1	:= TRB12201->JAS_DATA1
		JAS->JAS_DATA2	:= TRB12201->JAS_DATA2
		JAS->JAS_ESCDIA	:= TRB12201->JAS_ESCDIA
		JAS->JAS_AMG_	:= TRB12201->JAS_AMG_
		JAS->( msUnlock() )
	endif
	
	end transaction

	TRB12201->( dbSkip() )
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12202Grv�Autor  �Rafael Rodrigues   � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC12200                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC12202Grv( lEnd, cTitulo, nRecs )
Local cFilJAS	:= xFilial("JAS")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB12202" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB12202->( dbGoTop() )

JAS->( dbSetOrder(2) )

while TRB12202->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB12202->JAS_CODCUR+TRB12202->JAS_PERLET+TRB12202->JAS_HABILI+TRB12202->JAS_CODDIS
	
	while cChave == TRB12202->JAS_CODCUR+TRB12202->JAS_PERLET+TRB12202->JAS_HABILI+TRB12202->JAS_CODDIS .and. TRB12202->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif

		cMemo += StrTran( TRB12202->JAS_MEMO1, '\13\10', CRLF )
		
		TRB12202->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAS->( dbSeek( cFilJAS+cChave ) ) .and. ( lOver .or. Empty( JAS->JAS_MEMO1 ) )
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
���Programa  �xAC12203Grv�Autor  �Rafael Rodrigues   � Data �  16/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados das Bibliografias na base.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC12200                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC12203Grv( lEnd, cTitulo, nRecs )
Local cFilJAS	:= xFilial("JAS")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB12203" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB12203->( dbGoTop() )

JAS->( dbSetOrder(2) )

while TRB12203->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB12203->JAS_CODCUR+TRB12203->JAS_PERLET+TRB12203->JAS_HABILI+TRB12203->JAS_CODDIS
	
	while cChave == TRB12203->JAS_CODCUR+TRB12203->JAS_PERLET+TRB12203->JAS_HABILI+TRB12203->JAS_CODDIS .and. TRB12203->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
		endif

		cMemo += StrTran( TRB12203->JAS_MEMO2, '\13\10', CRLF )
		
		TRB12203->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAS->( dbSeek( cFilJAS+cChave ) ) .and. ( lOver .or. Empty( JAS->JAS_MEMO2 ) )
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


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC122AY  �Autor  �Rafael Rodrigues    � Data � 10/Fev/2004 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC122AY( cCodCur, cPerlet, cHabili, cDiscip )
Local lRet
Local cQuery
Local cArqTRB122 := CriaTrab(, .F.)

cQuery := "select count(*) as QUANT "
cQuery += "  from "+RetSQLName("JAY")+" JAY, "
cQuery += "       "+RetSQLName("JAH")+" JAH "
cQuery += " where JAY_FILIAL = '"+xFilial("JAY")+"' "
cQuery += "   and JAH_FILIAL = '"+xFilial("JAH")+"' "
cQuery += "   and JAH_CODIGO = '"+cCodCur+"' "
cQuery += "   and JAH_CURSO  = JAY_CURSO "
cQuery += "   and JAH_VERSAO = JAY_VERSAO "
cQuery += "   and JAY_PERLET = '"+cPerLet+"' "
cQuery += "   and JAY_HABILI = '"+cHabili+"' "
cQuery += "   and JAY_CODDIS = '"+cDiscip+"' "
cQuery += "   and JAH.D_E_L_E_T_ != '*' "
cQuery += "   and JAY.D_E_L_E_T_ != '*' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTRB122, .F., .F. )
TCSetField( cArqTRB122, "QUANT", "N", 1, 0 )

lRet := (cArqTRB122)->QUANT > 0

(cArqTRB122)->( dbCloseArea() )

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC122Qry �Autor  �Rafael Rodrigues    � Data � 10/Fev/2004 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC122Qry( cCodCur, cPerlet, cHabili, cDiscip, cTable )
Local lRet
Local cQuery
Local cArqTRB122 := CriaTrab(, .F.)

cQuery := "select count(*) as QUANT "
cQuery += "  from "+cTable
cQuery += " where JAS_CODCUR = '"+cCodCur+"' "
cQuery += "   and JAS_PERLET = '"+cPerLet+"' "
cQuery += "   and JAS_HABILI = '"+cHabili+"' "
cQuery += "   and JAS_CODDIS = '"+cDiscip+"' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTRB122, .F., .F. )
TCSetField( cArqTRB122, "QUANT", "N", 1, 0 )

lRet := (cArqTRB122)->QUANT > 0

(cArqTRB122)->( dbCloseArea() )

Return lRet