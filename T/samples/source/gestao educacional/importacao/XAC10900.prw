#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC10900  �Autor  �Rafael Rodrigues    � Data �  12/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Grade Curricular do Curso Padrao      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC10900( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC10900'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX01	:= CriaTrab( nil, .F. )
Local cIDX02	:= CriaTrab( nil, .F. )
Local cIDX03	:= CriaTrab( nil, .F. )
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local nPos		:= 0
Local cArq01	:= ""
Local lTRB10901	:= .F.
Local lTRB10902	:= .F.
Local lTRB10903	:= .F.
Local nRec01	:= 0
Local nRec02	:= 0
Local nRec03	:= 0
Local nRecs		:= 0
Local i

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JAY_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAY_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAY_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAY_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JAY_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JAY_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JAY_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JAY_FRQMIN", "N", 003, 0 } )
aAdd( aStru, { "JAY_CONSDP", "C", 001, 0 } )
aAdd( aStru, { "JAY_STATUS", "C", 001, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Grades Curr. dos Cursos', 'AC10901', aClone( aStru ), 'TRB10901', .F., 'JAY_CURSO, JAY_VERSAO, JAY_PERLET, JAY_HABILI, JAY_CODDIS', {|| "JAY_CURSO between '"+mv_par01+"' and '"+mv_par02+"'" } } )

aStru := {}

aAdd( aStru, { "JAY_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAY_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAY_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAY_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JAY_CODDIS", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAY_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAY_MEMO1" , "C", 080, 0 } )

aAdd( aFiles, { 'Conte�dos das Grades', 'AC10902', aClone( aStru ), 'TRB10902', .F., 'JAY_CURSO, JAY_VERSAO, JAY_PERLET, JAY_HABILI, JAY_CODDIS, JAY_SEQ', {|| "JAY_CURSO between '"+mv_par01+"' and '"+mv_par02+"'" } } )

aStru := {}

aAdd( aStru, { "JAY_CURSO" , "C", 006, 0 } )
aAdd( aStru, { "JAY_VERSAO", "C", 003, 0 } )
aAdd( aStru, { "JAY_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JAY_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JAY_CODDIS", "C", 015, 0 } )
aStru := U_xSetSize( aStru )
aAdd( aStru, { "JAY_SEQ"   , "C", 003, 0 } )
aAdd( aStru, { "JAY_MEMO2" , "C", 080, 0 } )

aAdd( aFiles, { 'Bibliografias das Grades', 'AC10903', aClone( aStru ), 'TRB10903', .F., 'JAY_CURSO, JAY_VERSAO, JAY_PERLET, JAY_HABILI, JAY_CODDIS, JAY_SEQ', {|| "JAY_CURSO between '"+mv_par01+"' and '"+mv_par02+"'" } } )

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

	nPos := aScan( aTables, {|x| x[1] == "TRB10901"} )
	if nPos > 0
		lTRB10901	:= .T.
		nDrv01	:= aScan( aDriver, aTables[nPos, 3] )
		nRec01	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
		cArq01	:= aTables[nPos, 2]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB10902"} )
	if nPos > 0
		lTRB10902	:= .T.
		nDrv02	:= aScan( aDriver, aTables[nPos, 3] )
		nRec02	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	nPos := aScan( aTables, {|x| x[1] == "TRB10903"} )
	if nPos > 0
		lTRB10903	:= .T.
		nDrv03	:= aScan( aDriver, aTables[nPos, 3] )
		nRec03	:= aTables[nPos, 4]
		nRecs	+= aTables[nPos, 4]
	endif

	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	if lTRB10901 .and. nDrv01 <> 3
		TRB10901->( dbGoBottom() )
		if Empty( TRB10901->JAY_CURSO )
			RecLock( "TRB10901", .F. )
			TRB10901->( dbDelete() )
			TRB10901->( msUnlock() )
		endif
	endif

	if lTRB10902 .and. nDrv02 <> 3
		TRB10902->( dbGoBottom() )
		if Empty( TRB10902->JAY_CURSO )
			RecLock( "TRB10902", .F. )
			TRB10902->( dbDelete() )
			TRB10902->( msUnlock() )
		endif
	endif
	
	if lTRB10903 .and. nDrv03 <> 3
		TRB10903->( dbGoBottom() )
		if Empty( TRB10903->JAY_CURSO )
			RecLock( "TRB10903", .F. )
			TRB10903->( dbDelete() )
			TRB10903->( msUnlock() )
		endif
	endif

	//������������������������������Ŀ
	//�ordena os arquivos de trabalho�
	//��������������������������������
	if nOpc == 0
		MsgRun( 'Ordenando arquivos...',, {||	if( lTRB10901 .and. nDrv01 <> 3, TRB10901->( IndRegua( "TRB10901", cIDX01, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS" ) ), NIL ),;
												if( lTRB10902 .and. nDrv02 <> 3, TRB10902->( IndRegua( "TRB10902", cIDX02, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS+JAY_SEQ" ) ), NIL ),;
												if( lTRB10903 .and. nDrv03 <> 3, TRB10903->( IndRegua( "TRB10903", cIDX03, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS+JAY_SEQ" ) ), NIL ) } )
	else
		Eval( {||	if( lTRB10901 .and. nDrv01 <> 3, TRB10901->( IndRegua( "TRB10901", cIDX01, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS" ) ), NIL ),;
					if( lTRB10902 .and. nDrv02 <> 3, TRB10902->( IndRegua( "TRB10902", cIDX02, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS+JAY_SEQ" ) ), NIL ),;
					if( lTRB10903 .and. nDrv03 <> 3, TRB10903->( IndRegua( "TRB10903", cIDX03, "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS+JAY_SEQ" ) ), NIL ) } )
	endif

	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	if lTRB10901
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAY_CURSO)  '	, 'Curso n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAY_VERSAO) '	, 'Vers�o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_PERLET) '	, 'Per�odo letivo �o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_CODDIS) '	, 'Disciplina n�o informada.' } )
		//aAdd( aObrig, { '!Empty(JAY_CARGA)  '	, 'Carga hor�ria n�o informada.' } )
		aAdd( aObrig, { 'JAY_TIPO$"12"' 		, 'Tipo deve ser 1 (Obrigat�rio) ou 2 (Optativo).' } )
		aAdd( aObrig, { 'JAY_FRQMIN >= 0 .and. JAY_FRQMIN <= 100'	, 'Frequ�ncia m�nima deve ser de 0 a 100.' } )
		aAdd( aObrig, { 'JAY_CONSDP$"12"' 		, '"Considera DP na Quantidade M�xima" deve ser 1 (Sim) ou 2 (N�o).' } )
		aAdd( aObrig, { 'JAY_STATUS$"12"' 		, 'Tipo na grade deve ser 1 (Obrigat�rio) ou 2 (Optativo).' } )
		aAdd( aObrig, { 'JAY_PERLET == Posicione( "JAW", 1, xFilial("JAW")+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI, "JAW_PERLET" )'	, 'Per�odo Letivo n�o cadastrado na tabela JAW.' } )
		aAdd( aObrig, { 'JAY_CODDIS == Posicione( "JAE", 1, xFilial("JAE")+JAY_CODDIS, "JAE_CODIGO" )'	, 'Disciplina n�o cadastrada na tabela JAE.' } )

		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB10901", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS", .F., aObrig, cLogFile, @lEnd, nRec01 ) .and. lOk, lOk := U_xAC109CH( @lEnd, cLogFile ) .and. lOk }, 'Validando '+aFiles[1,1] )
		else
			lOk := U_xACChkInt( "TRB10901", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS", .F., aObrig, cLogFile, @lEnd, nRec01 ) .and. U_xAC109CH( @lEnd, cLogFile ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )
	endif	

	if lTRB10902
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAY_CURSO)  '	, 'C�digo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAY_VERSAO) '	, 'Vers�o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_PERLET) '	, 'Per�odo letivo �o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_CODDIS) '	, 'Disciplina n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAY_CURSO == Posicione( "JAY", 1, xFilial("JAY")+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS, "JAY_CURSO" ) .or. ( Select("TRB10901") > 0 .and. TRB10901->( dbSeek( TRB10902->JAY_CURSO+TRB10902->JAY_VERSAO+TRB10902->JAY_PERLET+TRB10902->JAY_HABILI+TRB10902->JAY_CODDIS, .F. ) ) )', 'Grade curricular n�o cadastrada na tabela JAY e n�o presente nos arquivos de importa��o.' } )
		else
			aAdd( aObrig, { 'JAY_CURSO == Posicione( "JAY", 1, xFilial("JAY")+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS, "JAY_CURSO" ) .or. ( Select("TRB10901") > 0 .and. U_xAC109Qry( JAY_CURSO, JAY_VERSAO, JAY_PERLET, JAY_HABILI, JAY_CODDIS, "'+cArq01+'" ) )', 'Grade curricular n�o cadastrada na tabela JAY e n�o presente nos arquivos de importa��o.' } )
		endif
		
		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[2,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB10902", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS+JAY_SEQ", .F., aObrig, cLogFile, @lEnd, nRec02 ) .and. lOk }, 'Validando '+aFiles[2,1] )
		else
			lOk := U_xACChkInt( "TRB10902", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS+JAY_SEQ", .F., aObrig, cLogFile, @lEnd, nRec02 ) .and. lOk
		endif
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[2,1]+'".' )
	endif	

	if lTRB10903
		aObrig := {}
		aAdd( aObrig, { '!Empty(JAY_CURSO)  '	, 'C�digo n�o informado.' } )
		aAdd( aObrig, { '!Empty(JAY_VERSAO) '	, 'Vers�o n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_PERLET) '	, 'Per�odo letivo �o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_CODDIS) '	, 'Disciplina n�o informada.' } )
		aAdd( aObrig, { '!Empty(JAY_SEQ)    '	, 'Sequencial de linha n�o informada.' } )
		if nDrv01 <> 3
			aAdd( aObrig, { 'JAY_CURSO == Posicione( "JAY", 1, xFilial("JAY")+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS, "JAY_CURSO" ) .or. ( Select("TRB10901") > 0 .and. TRB10901->( dbSeek( TRB10903->JAY_CURSO+TRB10903->JAY_VERSAO+TRB10903->JAY_PERLET+TRB10903->JAY_HABILI+TRB10903->JAY_CODDIS, .F. ) ) )', 'Grade curricular n�o cadastrada na tabela JAY e n�o presente nos arquivos de importa��o.' } )
		else
			aAdd( aObrig, { 'JAY_CURSO == Posicione( "JAY", 1, xFilial("JAY")+JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS, "JAY_CURSO" ) .or. ( Select("TRB10901") > 0 .and. U_xAC109Qry( JAY_CURSO, JAY_VERSAO, JAY_PERLET, JAY_HABILI, JAY_CODDIS, "'+cArq01+'" ) )', 'Grade curricular n�o cadastrada na tabela JAY e n�o presente nos arquivos de importa��o.' } )
		endif
		
		//����������������������������������������������������Ŀ
		//�verifica chaves unicas e consistencias pre-definidas�
		//������������������������������������������������������
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[3,1]+'".' )
		if nOpc == 0
			Processa( { |lEnd| lOk := U_xACChkInt( "TRB10903", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS+JAY_SEQ", .F., aObrig, cLogFile, @lEnd, nRec03 ) .and. lOk }, 'Validando '+aFiles[3,1] )
		else
			lOk := U_xACChkInt( "TRB10903", "JAY_CURSO+JAY_VERSAO+JAY_PERLET+JAY_HABILI+JAY_CODDIS+JAY_SEQ", .F., aObrig, cLogFile, @lEnd, nRec03 ) .and. lOk
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
			Processa( { |lEnd| ProcRegua( nRecs ), lOk := xAC10901Grv( @lEnd, aFiles[1,1], nRec01 ) .and. xAC10902Grv( @lEnd, aFiles[2,1], nRec02 ) .and. xAC10903Grv( @lEnd, aFiles[3,1], nRec03 ) }, 'Grava��o em andamento' )
		else
			lOk := xAC10901Grv( @lEnd, aFiles[1,1], nRec01 ) .and. xAC10902Grv( @lEnd, aFiles[2,1], nRec02 ) .and. xAC10903Grv( @lEnd, aFiles[3,1], nRec03 )
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

if lTRB10901 .and. nDrv01 <> 3
	FErase( cIDX01 + OrdBagExt() )
endif
if lTRB10902 .and. nDrv02 <> 3
	FErase( cIDX02 + OrdBagExt() )
endif
if lTRB10903 .and. nDrv03 <> 3
	FErase( cIDX03 + OrdBagExt() )
endif


Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC10901Grv�Autor  �Rafael Rodrigues   � Data �  12/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados do arquivo principal na base.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC10900                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC10901Grv( lEnd, cTitulo, nRecs )
Local cFilJAY	:= xFilial("JAY")	// Criada para ganhar performance
Local cChave	:= ""
Local nItem		:= 0
Local nItemSize	:= TamSX3("JAY_ITEM")[1]
Local i			:= 0
Local lSeek

if Select( "TRB10901" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB10901->( dbGoTop() )

JAY->( dbSetOrder(1) )

while TRB10901->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif
	
	if cChave <> TRB10901->JAY_CURSO+TRB10901->JAY_VERSAO+TRB10901->JAY_PERLET+TRB10901->JAY_HABILI
		cChave	:= TRB10901->JAY_CURSO+TRB10901->JAY_VERSAO+TRB10901->JAY_PERLET+TRB10901->JAY_HABILI
		nItem	:= 0
	endif
	
	begin transaction
	
	lSeek := JAY->( dbSeek( cFilJAY+TRB10901->JAY_CURSO+TRB10901->JAY_VERSAO+TRB10901->JAY_PERLET+TRB10901->JAY_HABILI+TRB10901->JAY_CODDIS ) )
	if lOver .or. !lSeek
		RecLock( "JAY", !lSeek )
		JAY->JAY_FILIAL	:= cFilJAY
		JAY->JAY_CURSO	:= TRB10901->JAY_CURSO
		JAY->JAY_VERSAO	:= TRB10901->JAY_VERSAO
		JAY->JAY_PERLET	:= TRB10901->JAY_PERLET
		JAY->JAY_HABILI	:= TRB10901->JAY_HABILI
		JAY->JAY_CODDIS	:= TRB10901->JAY_CODDIS
		JAY->JAY_ITEM	:= StrZero( ++nItem, nItemSize )
		JAY->JAY_CARGA	:= TRB10901->JAY_CARGA
		JAY->JAY_TIPO	:= TRB10901->JAY_TIPO
		JAY->JAY_FRQMIN	:= TRB10901->JAY_FRQMIN
		JAY->JAY_CONSDP	:= TRB10901->JAY_CONSDP
		JAY->JAY_STATUS	:= TRB10901->JAY_STATUS
	
		JAY->( msUnlock() )
	endif
	
	end transaction

	TRB10901->( dbSkip() )
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC10902Grv�Autor  �Rafael Rodrigues   � Data �  12/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados dos Conteudos na base.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC10900                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC10902Grv( lEnd, cTitulo )
Local cFilJAY	:= xFilial("JAY")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB10902" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB10902->( dbGoTop() )

JAY->( dbSetOrder(1) )

while TRB10902->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB10902->JAY_CURSO+TRB10902->JAY_VERSAO+TRB10902->JAY_PERLET+TRB10902->JAY_HABILI+TRB10902->JAY_CODDIS		
	
	while cChave == TRB10902->JAY_CURSO+TRB10902->JAY_VERSAO+TRB10902->JAY_PERLET+TRB10902->JAY_HABILI+TRB10902->JAY_CODDIS .and. TRB10902->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB10902->( RecCount() ), 6 )+'...' )
		endif
		
		cMemo += StrTran( TRB10902->JAY_MEMO1, '\13\10', CRLF )
		
		TRB10902->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAY->( dbSeek( cFilJAY+cChave ) ) .and. ( lOver .or. Empty( JAY->JAY_MEMO1 ) )
		begin transaction
		
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAY_CONTEU�
		//�e armazena o codigo do memo no campo JAY_MEMO1. Sobrescreve caso JAY_MEMO1 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAY", .F. )
		MSMM( JAY->JAY_MEMO1, TamSX3("JAY_CONTEU")[1],, cMemo, 1,,, "JAY", "JAY_MEMO1" )
		JAY->( msUnlock() )
		
		end transaction
	endif
	
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC10903Grv�Autor  �Rafael Rodrigues   � Data �  12/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados das Bibliografias na base.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC10900                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC10903Grv( lEnd, cTitulo )
Local cFilJAY	:= xFilial("JAY")	// Criada para ganhar performance
Local i			:= 0
Local cChave
Local cMemo

if Select( "TRB10903" ) == 0 .or. lEnd
	Return !lEnd
endif

TRB10903->( dbGoTop() )

JAY->( dbSetOrder(1) )

while TRB10903->( !eof() ) .and. !lEnd

	cMemo	:= ""
	cChave	:= TRB10903->JAY_CURSO+TRB10903->JAY_VERSAO+TRB10903->JAY_PERLET+TRB10903->JAY_HABILI+TRB10903->JAY_CODDIS
	
	while cChave == TRB10903->JAY_CURSO+TRB10903->JAY_VERSAO+TRB10903->JAY_PERLET+TRB10903->JAY_HABILI+TRB10903->JAY_CODDIS .and. TRB10903->( !eof() ) .and. !lEnd
		if nOpc == 0
			IncProc( cTitulo+', linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB10903->( RecCount() ), 6 )+'...' )
		endif

		cMemo += StrTran( TRB10903->JAY_MEMO2, '\13\10', CRLF )
		
		TRB10903->( dbSkip() )
	end
	
	if !Empty( cMemo ) .and. JAY->( dbSeek( cFilJAY+cChave ) ) .and. ( lOver .or. Empty( JAY->JAY_MEMO2 ) )
		begin transaction
	
		//��������������������������������������������������������������������������������������������Ŀ
		//�grava o conteudo de cMemo no SYP de acordo com o tamanho de linha especificado em JAY_BIBLIO�
		//�e armazena o codigo do memo no campo JAY_MEMO2. Sobrescreve caso JAY_MEMO2 esteja preenchido�
		//����������������������������������������������������������������������������������������������
		RecLock( "JAY", .F. )
		MSMM( JAY->JAY_MEMO2, TamSX3("JAY_CONTEU")[1],, cMemo, 1,,, "JAY", "JAY_MEMO2" )
		JAY->( msUnlock() )

		end transaction
	endif
	
end

Return !lEnd


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC109CH  �Autor  �Rafael Rodrigues    � Data �  12/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida se a carga horaria dos periodos eh igual aa carga    ���
���          �horaria do curso.                                           ���
�������������������������������������������������������������������������͹��
���Uso       �xAC10900                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC109CH( lEnd, cLogFile )
Local lRet		:= .T.
Local nCHTot	:= 0
Local nCHDis	:= 0
Local cCurso	:= ""
Local cVersao	:= ""
Local cPerLet	:= ""
Local cHabili	:= ""
Local nLinha	:= 0

TRB10901->( dbGoTop() )

ProcRegua( TRB10901->( RecCount() ) )

cCurso	:= TRB10901->JAY_CURSO
cVersao	:= TRB10901->JAY_VERSAO
cPerLet := TRB10901->JAY_PERLET
cHabili := TRB10901->JAY_HABILI
nCHTot	:= Posicione( "JAW", 1, xFilial("JAW")+cCurso+cVersao+cPerLet+cHabili, "JAW_CARGA" )
nLinha	:= TRB10901->( Recno() )
while TRB10901->( !eof() ) .and. !lEnd

	if nOpc == 0
		IncProc( 'Verificando carga hor�ria do curso '+Alltrim( TRB10901->JAY_CURSO )+'...' )
	endif
	
	if cCurso+cVersao+cPerLet+cHabili <> TRB10901->JAY_CURSO+TRB10901->JAY_VERSAO+TRB10901->JAY_PERLET+TRB10901->JAY_HABILI
		if nCHTot <> nCHDis
			lRet := .F.
			AcaLog( cLogFile, '  Inconsist�ncia no curso '+cCurso+', vers�o '+cVersao+', per�odo '+cPerLet+', habilita��o '+cHabili+': A soma das cargas hor�rias das disciplinas ('+StrZero( nCHDis, 4 )+') n�o corresponde � carga hor�ria total do per�odo ('+StrZero( nCHTot, 4 )+').', cLogFile )
		endif
		
		cCurso	:= TRB10901->JAY_CURSO
		cVersao	:= TRB10901->JAY_VERSAO
		cPerLet := TRB10901->JAY_PERLET
		cHabili := TRB10901->JAY_HABILI
		nCHTot	:= Posicione( "JAW", 1, xFilial("JAW")+cCurso+cVersao+cPerLet+cHabili, "JAW_CARGA" )
		nLinha	:= TRB10901->( Recno() )
		nCHDis	:= 0
	endif

	nCHDis += TRB10901->JAY_CARGA
	
	TRB10901->( dbSkip() )
end

lRet := lRet .and. !lEnd

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC109Qry �Autor  �Rafael Rodrigues    � Data � 10/Fev/2004 ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se uma disciplina esta sendo importada no arquivo  ���
���          �de trabalho                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � xAC10800                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC109Qry( cCurso, cVersao, cPerLet, cHabili, cDiscip, cTable )
Local lOk
Local cQuery := ""

cQuery := "select count(*) as QUANT "
cQuery += "  from "+cTable
cQuery += " where JAY_CURSO  = '"+cCurso+"' "
cQuery += "   and JAY_VERSAO = '"+cVersao+"' "
cQuery += "   and JAY_PERLET = '"+cPerLet+"' "
cQuery += "   and JAY_HABILI = '"+cHabili+"' "
cQuery += "   and JAY_CODDIS = '"+cDiscip+"' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY09", .F., .F. )
TCSetField( "QRY09", "QUANT", "N", 1, 0 )

lOk := QRY09->QUANT > 0

QRY09->( dbCloseArea() )

Return lOk