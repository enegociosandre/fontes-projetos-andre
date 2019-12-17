#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12600  �Autor  �Rafael Rodrigues    � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Cursos Vigentes x Financeiro          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC12600( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC12600'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local nDrv 		:= 0
Local i

Default nOpcX	:= 0
Default aTables := {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JB5_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JB5_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JB5_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JB5_PARCEL", "C", 002, 0 } )
aAdd( aStru, { "JB5_CODFIN", "C", 010, 0 } )
aAdd( aStru, { "JB5_VALOR" , "N", 012, 2 } )
aAdd( aStru, { "JB5_MATPG" , "C", 001, 0 } )
aAdd( aStru, { "JB5_PAGTO1", "C", 002, 0 } )
aAdd( aStru, { "JB5_TPPAG1", "C", 001, 0 } )
aAdd( aStru, { "JB5_DESC1" , "N", 012, 2 } )
aAdd( aStru, { "JB5_PERC1" , "N", 006, 2 } )
aAdd( aStru, { "JB5_PAGTO2", "C", 002, 0 } )
aAdd( aStru, { "JB5_TPPAG2", "C", 001, 0 } )
aAdd( aStru, { "JB5_DESC2" , "N", 012, 2 } )
aAdd( aStru, { "JB5_PERC2" , "N", 006, 2 } )
aAdd( aStru, { "JB5_PAGTO3", "C", 002, 0 } )
aAdd( aStru, { "JB5_TPPAG3", "C", 001, 0 } )
aAdd( aStru, { "JB5_DESC3" , "N", 012, 2 } )
aAdd( aStru, { "JB5_PERC3" , "N", 006, 2 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Cursos vigentes x Financeiro', 'AC12600', aClone( aStru ), 'TRB126', .T., 'JB5_CODCUR, JB5_PERLET, JB5_HABILI, JB5_PARCEL', {|| "JB5_CODCUR in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JB5_CODCUR and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

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
	
	//�������������������������������������������������������������������������������������������������������������Ŀ
	//�antes de iniciar, verifica se foi incluido um registro em branco ao final do arquivo, e elimina este registro�
	//���������������������������������������������������������������������������������������������������������������
	nDrv := aScan( aDriver, aTables[1,3] )
	if nDrv # 3
		TRB126->( dbGoBottom() )
		if Empty( TRB126->JB5_CODCUR )
			RecLock( "TRB126", .F. )
			TRB126->( dbDelete() )
			TRB126->( msUnlock() )
		endif
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JB5_CODCUR) ', 'C�digo do curso vigente n�o informado.' } )
	aAdd( aObrig, { '!Empty(JB5_PERLET) ', 'Per�odo letivo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JB5_PARCEL) ', 'Parcela n�o informada.' } )
	aAdd( aObrig, { '!Empty(JB5_CODFIN) ', 'Calend�rio financeiro n�o informado.' } )
	aAdd( aObrig, { '!Empty(JB5_VALOR)  ', 'Valor n�o informado.' } )
	aAdd( aObrig, { 'JB5_MATPG$"12"     ', '"Matr�cula vinculada ao pagamento?" deve ser 1 (Sim) ou 2 (N�o).' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO1) .or. JB5_PAGTO1 == StrZero( Val( JB5_PAGTO1), 2 )', 'Dia para Pagamento 1, quando informado, deve ser preenchido com zeros � esquerda.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO1) .or. JB5_TPPAG1$"123"', 'Tipo de dias 1 deve ser informado sempre que Dia para Pagamento 1 for informado. Seu valor deve ser 1 (Corridos), 2 (�teis) ou 3 (Antecipados).' } )
	aAdd( aObrig, { '!Empty(JB5_PAGTO1) .or. Empty(JB5_TPPAG1)', 'Tipo de dias 1 informado e Dia para Pagamento 1 em branco. Devem ser informados ou deixados em branco conjuntamente.' } )
	aAdd( aObrig, { 'JB5_PERC1 <= 100', 'Percentual de desconto 1 maior que 100%.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO2) .or. JB5_PAGTO2 == StrZero( Val( JB5_PAGTO2), 2 )', 'Dia para Pagamento 2, quando informado, deve ser preenchido com zeros � esquerda.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO2) .or. JB5_TPPAG2$"123"', 'Tipo de dias 2 deve ser informado sempre que Dia para Pagamento 2 for informado. Seu valor deve ser 1 (Corridos), 2 (�teis) ou 3 (Antecipados).' } )
	aAdd( aObrig, { '!Empty(JB5_PAGTO2) .or. Empty(JB5_TPPAG2)', 'Tipo de dias 2 informado e Dia para Pagamento 2 em branco. Devem ser informados ou deixados em branco conjuntamente.' } )
	aAdd( aObrig, { 'JB5_PERC2 <= 100', 'Percentual de desconto 2 maior que 100%.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO3) .or. JB5_PAGTO3 == StrZero( Val( JB5_PAGTO3), 2 )', 'Dia para Pagamento 3, quando informado, deve ser preenchido com zeros � esquerda.' } )
	aAdd( aObrig, { 'Empty(JB5_PAGTO3) .or. JB5_TPPAG3$"123"', 'Tipo de dias 3 deve ser informado sempre que Dia para Pagamento 3 for informado. Seu valor deve ser 1 (Corridos), 2 (�teis) ou 3 (Antecipados).' } )
	aAdd( aObrig, { '!Empty(JB5_PAGTO3) .or. Empty(JB5_TPPAG3)', 'Tipo de dias 3 informado e Dia para Pagamento 3 em branco. Devem ser informados ou deixados em branco conjuntamente.' } )
	aAdd( aObrig, { 'JB5_PERC3 <= 100', 'Percentual de desconto 3 maior que 100%.' } )
	aAdd( aObrig, { 'JB5_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JB5_CODCUR+JB5_PERLET+JB5_HABILI, "JAR_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JB5_PARCEL == Posicione( "JCC", 4, xFilial("JCC")+JB5_CODFIN+JB5_PARCEL, "JCC_PARCEL" )', 'Parcela n�o existente no calend�rio financeiro informado.' } )
	aAdd( aObrig, { 'Posicione( "JCB", 2, xFilial("JCB")+JB5_CODFIN, "JCB_ANOLET" ) == Posicione( "JAR", 1, xFilial("JAR")+JB5_CODCUR+JB5_PERLET, "JAR_ANOLET" )', 'Ano letivo do calend�rio financeiro n�o coincide com o ano letivo do per�odo letivo informado.' } )

	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	if nDrv # 3
		if nOpc == 0
			MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB126", cIDX, "JB5_CODCUR+JB5_PERLET+JB5_HABILI+JB5_PARCEL" ) } )
		else
			Eval( {|| IndRegua( "TRB126", cIDX, "JB5_CODCUR+JB5_PERLET+JB5_HABILI+JB5_PARCEL" ) } )
		endif
	endif
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
	if nOpc == 0
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB126", "JB5_CODCUR+JB5_PERLET+JB5_HABILI+JB5_PARCEL", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Valida��o do Arquivo' )
	else
		lOk := U_xACChkInt( "TRB126", "JB5_CODCUR+JB5_PERLET+JB5_HABILI+JB5_PARCEL", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk
	endif
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )
		
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
			Processa( { |lEnd| lOk := xAC12600Grv( @lEnd, aTables[1,4] ) }, 'Grava��o em andamento' )
		else
			lOk := xAC12600Grv( @lEnd, aTables[1,4] )
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
	dbSelectArea( aTables[i][1] )
	dbCloseArea()
	FErase( aTables[i][2]+GetDBExtension() )
next i

FErase( cIDX + OrdBagExt() )

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12600Grv�Autor  �Rafael Rodrigues   � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC12600                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC12600Grv( lEnd, nRecs )
Local cFilJB5	:= xFilial("JB5")	// Criada para ganhar performance
Local i			:= 0
Local lSeek

if nOpc == 0
	ProcRegua( nRecs )
endif

TRB126->( dbGoTop() )

JB5->( dbSetOrder(1) )

while TRB126->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif
	
	lSeek := JB5->( dbSeek( cFilJB5+TRB126->JB5_CODCUR+TRB126->JB5_PERLET+TRB126->JB5_HABILI+TRB126->JB5_PARCEL ) )
	
	if lOver .or. !lSeek
		begin transaction

		RecLock( "JB5", !lSeek )
		JB5->JB5_FILIAL	:= cFilJB5
		JB5->JB5_CODCUR	:= TRB126->JB5_CODCUR
		JB5->JB5_PERLET	:= TRB126->JB5_PERLET
		JB5->JB5_HABILI	:= TRB126->JB5_HABILI
		JB5->JB5_PARCEL	:= TRB126->JB5_PARCEL
		JB5->JB5_CODFIN	:= TRB126->JB5_CODFIN
		JB5->JB5_VALOR	:= TRB126->JB5_VALOR
		JB5->JB5_MATPAG	:= TRB126->JB5_MATPG
		JB5->JB5_PAGTO1	:= TRB126->JB5_PAGTO1
		JB5->JB5_TPPAG1	:= TRB126->JB5_TPPAG1
		JB5->JB5_DESC1	:= TRB126->JB5_DESC1
		JB5->JB5_PERC1	:= TRB126->JB5_PERC1
		JB5->JB5_PAGTO2	:= TRB126->JB5_PAGTO2
		JB5->JB5_TPPAG2	:= TRB126->JB5_TPPAG2
		JB5->JB5_DESC2	:= TRB126->JB5_DESC2
		JB5->JB5_PERC2	:= TRB126->JB5_PERC2
		JB5->JB5_PAGTO3	:= TRB126->JB5_PAGTO3
		JB5->JB5_TPPAG3	:= TRB126->JB5_TPPAG3
		JB5->JB5_DESC3	:= TRB126->JB5_DESC3
		JB5->JB5_PERC3	:= TRB126->JB5_PERC3
		JB5->( msUnlock() )

		end transaction
	endif

	TRB126->( dbSkip() )
end

Return !lEnd