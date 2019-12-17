#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12400  �Autor  �Rafael Rodrigues    � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Turmas (Cursos Vigentes x Salas)      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC12400( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC12400'
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

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JBO_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBO_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBO_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JBO_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JBO_CODLOC", "C", 006, 0 } )
aAdd( aStru, { "JBO_CODPRE", "C", 006, 0 } )
aAdd( aStru, { "JBO_ANDAR" , "C", 003, 0 } )
aAdd( aStru, { "JBO_CODSAL", "C", 006, 0 } )
aAdd( aStru, { "JBO_LUGAR" , "N", 004, 0 } )
aAdd( aStru, { "JBO_OCUPAD", "N", 004, 0 } )
aAdd( aStru, { "JBO_LIVRE" , "N", 004, 0 } )
aAdd( aStru, { "JBO_QTDRES", "N", 004, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Turmas (Cursos Vigentes x Salas)', 'AC12400', aClone( aStru ), 'TRB124', .T., 'JBO_CODCUR, JBO_PERLET, JBO_HABILI, JBO_TURMA', {|| "JBO_CODCUR in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JBO_CODCUR and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

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
		TRB124->( dbGoBottom() )
		if Empty( TRB124->JBO_CODCUR )
			RecLock( "TRB124", .F. )
			TRB124->( dbDelete() )
			TRB124->( msUnlock() )
		endif
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JBO_CODCUR) ', 'C�digo do curso vigente n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_PERLET) ', 'Per�odo letivo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_TURMA)  ', 'Turma n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBO_CODLOC) ', 'C�digo do local n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_CODPRE) ', 'C�digo do pr�dio n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_ANDAR)  ', 'Andar n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_CODSAL) ', 'C�digo da sala n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBO_LUGAR)  ', 'Capacidade da sala n�o informada.' } )
	aAdd( aObrig, { 'JBO_OCUPAD + JBO_LIVRE + JBO_QTDRES == JBO_LUGAR', 'Total de lugares ocupados, livres e reservados n�o coincide com a capacidade da sala.' } )
	aAdd( aObrig, { 'JBO_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JBO_CODCUR+JBO_PERLET+JBO_HABILI, "JAR_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JBO_CODSAL == Posicione( "JA5", 1, xFilial("JA5")+JBO_CODLOC+JBO_CODPRE+JBO_ANDAR+JBO_CODSAL, "JA5_CODSAL" )', 'Andar/Sala n�o cadastrados na tabela JA5.' } )

	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	if nDrv <> 3
		if nOpc == 0
			MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB124", cIDX, "JBO_CODCUR+JBO_PERLET+JBO_HABILI+JBO_TURMA" ) } )
		else
			Eval( {|| IndRegua( "TRB124", cIDX, "JBO_CODCUR+JBO_PERLET+JBO_HABILI+JBO_TURMA" ) } )
		endif
	endif
	
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
	if nOpc == 0
		Processa( { |lEnd| lOk := U_xACChkInt( "TRB124", "JBO_CODCUR+JBO_PERLET+JBO_HABILI+JBO_TURMA", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk }, 'Valida��o do Arquivo' )
	else
		lOk := U_xACChkInt( "TRB124", "JBO_CODCUR+JBO_PERLET+JBO_HABILI+JBO_TURMA", .F., aObrig, cLogFile, @lEnd, aTables[1,4] ) .and. lOk
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
			Processa( { |lEnd| lOk := xAC12400Grv( @lEnd, aTables[1,4] ) }, 'Grava��o em andamento' )
		else
			lOk := xAC12400Grv( @lEnd, aTables[1,4] )
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
	( aTables[i][1] )->( dbCloseArea() )
	FErase( aTables[i][2]+GetDBExtension() )
next i
FErase( cIDX + OrdBagExt() )

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12400Grv�Autor  �Rafael Rodrigues   � Data �  17/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC12400                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC12400Grv( lEnd, nRecs )
Local cFilJBN	:= xFilial("JBN")	// Criada para ganhar performance
Local cFilJBO	:= xFilial("JBO")	// Criada para ganhar performance
Local cChave	:= ""
Local i			:= 0
Local lSeek

if nOpc == 0
	ProcRegua( nRecs )
endif

TRB124->( dbGoTop() )

JBN->( dbSetOrder(1) )
JBO->( dbSetOrder(1) )

while TRB124->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif

	if cChave <> TRB124->JBO_CODCUR+TRB124->JBO_PERLET+TRB124->JBO_HABILI
		cChave := TRB124->JBO_CODCUR+TRB124->JBO_PERLET+TRB124->JBO_HABILI
		
		begin transaction
		
		lSeek := JBN->( dbSeek( cFilJBN+TRB124->JBO_CODCUR+TRB124->JBO_PERLET+TRB124->JBO_HABILI ) )
		if lOver .or. !lSeek
			RecLock( "JBN", !lSeek )
			JBN->JBN_FILIAL	:= cFilJBN
			JBN->JBN_CODCUR := TRB124->JBO_CODCUR
			JBN->JBN_PERLET	:= TRB124->JBO_PERLET
			JBN->JBN_HABILI	:= TRB124->JBO_HABILI
			JBN->( msUnlock() )
		endif
		
		end transaction

	endif
	
	begin transaction
	
	lSeek := JBO->( dbSeek( cFilJBO+TRB124->JBO_CODCUR+TRB124->JBO_PERLET+TRB124->JBO_HABILI+TRB124->JBO_TURMA ) )
	if lOver .or. !lSeek
		RecLock( "JBO", !lSeek )
		JBO->JBO_FILIAL	:= cFilJBO
		JBO->JBO_CODCUR	:= TRB124->JBO_CODCUR
		JBO->JBO_PERLET	:= TRB124->JBO_PERLET
		JBO->JBO_HABILI	:= TRB124->JBO_HABILI
		JBO->JBO_TURMA	:= TRB124->JBO_TURMA
		JBO->JBO_CODLOC	:= TRB124->JBO_CODLOC
		JBO->JBO_CODPRE	:= TRB124->JBO_CODPRE
		JBO->JBO_ANDAR	:= TRB124->JBO_ANDAR
		JBO->JBO_CODSAL	:= TRB124->JBO_CODSAL
		JBO->JBO_LUGAR	:= TRB124->JBO_LUGAR
		JBO->JBO_OCUPAD	:= TRB124->JBO_OCUPAD
		JBO->JBO_LIVRE	:= TRB124->JBO_LIVRE
		JBO->JBO_QTDRES	:= TRB124->JBO_QTDRES
		JBO->( msUnlock() )
	endif
	
	end transaction

	TRB124->( dbSkip() )
end

Return !lEnd