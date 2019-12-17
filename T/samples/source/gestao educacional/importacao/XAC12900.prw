#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC12900  �Autor  �Rafael Rodrigues    � Data �  19/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Grades de Aulas                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAC12900( nOpcX, aTables )
Local aStru		:= {}
Local aFiles	:= {}
Local cNameFile := 'AC12900'
Local cPathFile := __RelDir
Local cExtFile	:= ".##R"
Local cLogFile	:= cPathFile + cNameFile + cExtFile
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local aDriver	:= {"Arquivo Texto", "Arquivo DBF", "TopConnect" }
Local cQuery	:= ""
Local cFiliais  := ""
Local nDrv      := 0

Default nOpcX	:= 0
Default aTables	:= {}

Private lOver	:= .T.
Private nOpc	:= nOpcX

aAdd( aStru, { "JBL_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBL_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBL_HABILI", "C", 006, 0 } )
aAdd( aStru, { "JBL_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JBL_DIASEM", "C", 001, 0 } )
aAdd( aStru, { "JBL_ITEM"  , "C", 003, 0 } )
aAdd( aStru, { "JBL_CODHOR", "C", 006, 0 } )
aAdd( aStru, { "JBL_HORA1" , "C", 005, 0 } )
aAdd( aStru, { "JBL_HORA2" , "C", 005, 0 } )
aAdd( aStru, { "JBL_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JBL_MATPRF", "C", 006, 0 } )
aAdd( aStru, { "JBL_MATPR2", "C", 006, 0 } )
aAdd( aStru, { "JBL_MATPR3", "C", 006, 0 } )
aAdd( aStru, { "JBL_MATPR4", "C", 006, 0 } )
aAdd( aStru, { "JBL_MATPR5", "C", 006, 0 } )
aAdd( aStru, { "JBL_MATPR6", "C", 006, 0 } )
aAdd( aStru, { "JBL_MATPR7", "C", 006, 0 } )
aAdd( aStru, { "JBL_MATPR8", "C", 006, 0 } )
aAdd( aStru, { "JBL_CODLOC", "C", 006, 0 } )
aAdd( aStru, { "JBL_CODPRE", "C", 006, 0 } )
aAdd( aStru, { "JBL_ANDAR" , "C", 003, 0 } )
aAdd( aStru, { "JBL_CODSAL", "C", 006, 0 } )
aAdd( aStru, { "JBL_DATA1" , "D", 008, 0 } )
aAdd( aStru, { "JBL_DATA2" , "D", 008, 0 } )
aAdd( aStru, { "JBL_REMUNE", "C", 001, 0 } )
aAdd( aStru, { "JBK_ATIVO" , "C", 001, 0 } )

aStru := U_xSetSize( aStru )

aAdd( aFiles, { 'Grades de Aulas', 'AC12900', aClone( aStru ), 'TRB129', .T., 'JBL_CODCUR, JBL_PERLET, JBL_HABILI, JBL_TURMA, JBL_DIASEM, JBL_ITEM', {|| "JBL_CODCUR in ( select JAH_CODIGO from "+RetSQLName("JAH")+" JAH where JAH.JAH_FILIAL = '"+xFilial("JAH")+"' and JAH.D_E_L_E_T_ = ' ' and JAH.JAH_CODIGO = QRY.JBL_CODCUR and JAH.JAH_CURSO between '"+mv_par01+"' and '"+mv_par02+"' and JAH.JAH_UNIDAD between '"+mv_par03+"' and '"+mv_par04+"' )" } } )

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

if Empty( aTables )
	AcaLog( cLogFile, '  Nenhum arquivo p�de ser importado para este processo.' )
	if nOpc == 0
		Aviso( 'Problema', 'Nenhum arquivo p�de ser importado para este processo.', {'Ok'} )
	endif
else

	nDrv := aScan( aDriver, aTables[1,3] )	

	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { 'JBK_ATIVO$"12"'     , '"Grade Ativa?" deve ser 1(Sim) ou 2(N�o).' } )
	aAdd( aObrig, { '!Empty(JBL_ITEM)   ', 'Aula n�o informada.' } )
	aAdd( aObrig, { 'U_xACIsHora(JBL_HORA1,.F.) ', 'Hor�rio inicial n�o informado ou inv�lido.' } )
	aAdd( aObrig, { 'U_xACIsHora(JBL_HORA2,.F.) ', 'Hor�rio final n�o informado ou inv�lido.' } )
	aAdd( aObrig, { '!(JBL_DIASEM$"1234567") .or. Posicione( "JAR", 1, xFilial("JAR")+JBL_CODCUR+JBL_PERLET+JBL_HABILI, "JAR_AULA"+JBL_DIASEM ) == "1"', 'O curso vigente n�o possui aula neste dia da semana.' } )
	aAdd( aObrig, { 'JBL_TURMA  == Posicione( "JBO", 1, xFilial("JBO")+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_TURMA, "JBO_TURMA" )', 'Turma n�o cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'JBL_CODHOR == Posicione( "JBD", 2, xFilial("JBD")+JBL_CODHOR+JBL_HORA1+JBL_HORA2, "JBD_CODIGO" )', 'C�digo do horario + Hora inicial + Hora final n�o cadastrados na tabela JBD.' } )
	aAdd( aObrig, { 'JBL_CODDIS == Posicione( "JAS", 2, xFilial("JAS")+JBL_CODCUR+JBL_PERLET+JBL_HABILI+JBL_CODDIS, "JAS_CODDIS" )', 'Disciplina n�o cadastrada na tabela JAS.' } )
	aAdd( aObrig, { 'Empty(JBL_MATPRF) .or. !Empty(ACNomeProf(JBL_MATPRF))', 'Professor 1 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'Empty(JBL_MATPR2) .or. !Empty(ACNomeProf(JBL_MATPR2))', 'Professor 2 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'Empty(JBL_MATPR3) .or. !Empty(ACNomeProf(JBL_MATPR3))', 'Professor 3 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'Empty(JBL_MATPR4) .or. !Empty(ACNomeProf(JBL_MATPR4))', 'Professor 4 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'Empty(JBL_MATPR5) .or. !Empty(ACNomeProf(JBL_MATPR5))', 'Professor 5 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'Empty(JBL_MATPR6) .or. !Empty(ACNomeProf(JBL_MATPR6))', 'Professor 6 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'Empty(JBL_MATPR7) .or. !Empty(ACNomeProf(JBL_MATPR7))', 'Professor 7 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'Empty(JBL_MATPR8) .or. !Empty(ACNomeProf(JBL_MATPR8))', 'Professor 8 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'JBL_CODSAL == Posicione( "JA5", 1, xFilial("JA5")+JBL_CODLOC+JBL_CODPRE+JBL_ANDAR+JBL_CODSAL, "JA5_CODSAL" )', 'Andar/Sala n�o cadastrados na tabela JA5.' } )
	aAdd( aObrig, { 'JBL_REMUNE$"12"', '"Aula remunerada?" dever ser 1=Sim ou 2=N�o.' } )
	aAdd( aObrig, { '(Empty(JBL_DATA2) .and. Empty(JBL_DATA1)) .or. (!Empty(JBL_DATA2) .and. !Empty(JBL_DATA1))', 'As datas inicial e final devem ser informadas conjuntamente.' } )
	aAdd( aObrig, { 'Empty(JBL_DATA2) .or. JBL_DATA2 >= JBL_DATA1', 'A data final deve ser maior ou igual � data inicial.' } )
	aAdd( aObrig, { 'Empty(JBL_DATA1) .or. JBL_DATA1 >= Posicione( "JAR", 1, xFilial("JAR")+JBL_CODCUR+JBL_PERLET+JBL_HABILI, "JAR_DATA1" )', 'Data inicial deve estar dentro das datas de realiza��o do per�odo letivo.' } )
	aAdd( aObrig, { 'Empty(JBL_DATA2) .or. JBL_DATA2 <= Posicione( "JAR", 1, xFilial("JAR")+JBL_CODCUR+JBL_PERLET+JBL_HABILI, "JAR_DATA2" )', 'Data final deve estar dentro das datas de realiza��o do per�odo letivo.' } )
	
	//��������������������������Ŀ
	//�verifica chaves duplicadas�
	//����������������������������
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Iniciando valida��o do arquivo "'+aFiles[1,1]+'".' )
	if nOpc == 0
		MsgRun( 'Buscando chaves duplicadas...',, { |lEnd| lOk := xAC129Chk( cLogFile, aTables[1,2] ) } ) 
	else
		Eval( { |lEnd| lOk := xAC129Chk( cLogFile, aTables[1,2] ) } ) 
	endif
	AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() + '  .Fim da valida��o do arquivo "'+aFiles[1,1]+'".' )

	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas duplicidades de chave prim�ria. A grava��o n�o foi realizada.' )
	endif

	if nOpc == 0
		Processa( { |lEnd| lEnd := xAC129Grv( aTables[1,2], aObrig, cLogFile, @lEnd, aTables[1,4] ) }, 'Grava��o em andamento' )
	else
		lEnd := xAC129Grv( aTables[1,2], aObrig, cLogFile, @lEnd, aTables[1,4] )
	endif

	if !lOk
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Foram detectadas inconsist�ncias. A grava��o n�o foi completa.' )
		if nOpc == 0 .and. Aviso( 'Problemas!', 'Foram detectadas inconsist�ncias. Verifique o arquivo "'+cLogFile+'" para detalhes.', {'Ok', 'Exibir log'}, 2 ) == 2
			OurSpool( cNameFile )
		endif
	elseif lEnd
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.' )
		if nOpc == 0
			Aviso( 'Opera��o Cancelada!', 'O processo de grava��o foi interrompido pelo usu�rio. Ser� necess�rio reiniciar o processo de importa��o.', {'Ok'} )
		endif
	else
		AcaLog( cLogFile, DtoC( dDataBase ) + ' - ' + Time() +  '! Grava��o realizada com sucesso.' )
		if nOpc == 0
			Aviso( 'Sucesso!', 'Importa��o realizada com sucesso.', {'Ok'} )
		endif
	endif
endif

if Select("TRB129") > 0
	TRB129->( dbCloseArea() )
endif
	
if len(aTables) # 0 .And. nDrv # 3
	FErase( aTables[1,2]+GetDBExtension() )
	FErase( cIDX + OrdBagExt() )
endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC129Grv  �Autor  �Rafael Rodrigues   � Data �  20/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �xAC12900                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC129Grv( cTable, aObrig, cLogFile, lEnd, nRecs )
Local cFilJBL	:= xFilial("JBL")	// Criada para ganhar performance
Local cFilJBK	:= xFilial("JBK")	// Criada para ganhar performance
Local cChave	:= ""
Local i			:= 0
Local j			:= 0
Local lOk		:= .T.
Local lLinOk
Local lSeek

if nOpc == 0
	ProcRegua( nRecs )
endif

TRB129->( dbGoTop() )

JBL->( dbSetOrder(3) )
JBK->( dbSetOrder(3) )

while TRB129->( !eof() ) .and. !lEnd
	
	if nOpc == 0
		IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( nRecs, 6 )+'...' )
	endif

	lLinOk := .T.
	for j := 1 to len( aObrig )
		if TRB129->( !Eval( &("{ || "+aObrig[j, 1]+" }") ) )
			lLinOk := .F.
			AcaLog( cLogFile, '  Inconsist�ncia na grade do curso '+TRB129->JBL_CODCUR+', per�odo '+TRB129->JBL_PERLET+', habilita��o '+TRB129->JBL_HABILI+', turma '+TRB129->JBL_TURMA+', dia '+TRB129->JBL_DIASEM+', disciplina '+TRB129->JBL_CODDIS+', dia '+TRB129->JBL_DIASEM+', horario '+TRB129->JBL_HORA1+'-'+TRB129->JBL_HORA2+': '+aObrig[j, 2] )
		endif
	next j

	if !lLinOk
		lOk := .F.
		TRB129->( dbSkip() )
		loop
	endif

	if cChave <> TRB129->JBL_CODCUR+TRB129->JBL_PERLET+TRB129->JBL_HABILI+TRB129->JBL_TURMA
		cChave := TRB129->JBL_CODCUR+TRB129->JBL_PERLET+TRB129->JBL_HABILI+TRB129->JBL_TURMA
		
		lSeek := JBK->( dbSeek( cFilJBK+TRB129->JBL_CODCUR+TRB129->JBL_PERLET+TRB129->JBL_HABILI+TRB129->JBL_TURMA ) )
		if lOver .or. !lSeek
			begin transaction
	
			RecLock( "JBK", !lSeek )
			JBK->JBK_FILIAL	:= cFilJBK
			JBK->JBK_CODCUR	:= TRB129->JBL_CODCUR
			JBK->JBK_PERLET	:= TRB129->JBL_PERLET
			JBK->JBK_HABILI	:= TRB129->JBL_HABILI
			JBK->JBK_TURMA	:= TRB129->JBL_TURMA
			JBK->JBK_ATIVO	:= TRB129->JBK_ATIVO
			JBK->( msUnlock() )
		
			end transaction
		endif
	endif
	
	lSeek := JBL->( dbSeek( cFilJBL+TRB129->JBL_CODCUR+TRB129->JBL_PERLET+TRB129->JBL_HABILI+TRB129->JBL_TURMA+TRB129->JBL_DIASEM+TRB129->JBL_ITEM ) )
	if lOver .or. !lSeek
		begin transaction
		
		RecLock( "JBL", !lSeek )
		JBL->JBL_FILIAL	:= cFilJBL
		JBL->JBL_CODCUR	:= TRB129->JBL_CODCUR
		JBL->JBL_PERLET	:= TRB129->JBL_PERLET
		JBL->JBL_HABILI	:= TRB129->JBL_HABILI
		JBL->JBL_TURMA	:= TRB129->JBL_TURMA
		JBL->JBL_ITEM	:= StrZero( Val( TRB129->JBL_ITEM ), 2 )
		JBL->JBL_CODHOR	:= TRB129->JBL_CODHOR
		JBL->JBL_HORA1	:= TRB129->JBL_HORA1
		JBL->JBL_HORA2	:= TRB129->JBL_HORA2
		JBL->JBL_CODDIS	:= TRB129->JBL_CODDIS
		JBL->JBL_MATPRF	:= TRB129->JBL_MATPRF
		JBL->JBL_MATPR2	:= TRB129->JBL_MATPR2
		JBL->JBL_MATPR3	:= TRB129->JBL_MATPR3
		JBL->JBL_MATPR4	:= TRB129->JBL_MATPR4
		JBL->JBL_MATPR5	:= TRB129->JBL_MATPR5
		JBL->JBL_MATPR6	:= TRB129->JBL_MATPR6
		JBL->JBL_MATPR7	:= TRB129->JBL_MATPR7
		JBL->JBL_MATPR8	:= TRB129->JBL_MATPR8
		JBL->JBL_DIASEM	:= TRB129->JBL_DIASEM
		JBL->JBL_CODLOC	:= TRB129->JBL_CODLOC
		JBL->JBL_CODPRE	:= TRB129->JBL_CODPRE
		JBL->JBL_ANDAR	:= TRB129->JBL_ANDAR
		JBL->JBL_CODSAL	:= TRB129->JBL_CODSAL
		JBL->JBL_REMUNE	:= TRB129->JBL_REMUNE
		JBL->JBL_DATA1	:= TRB129->JBL_DATA1
		JBL->JBL_DATA2	:= TRB129->JBL_DATA2
		JBL->( msUnlock() )
		
		end transaction
	endif
	
	TRB129->( dbSkip() )
end

Return !lEnd

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAC129Top �Autor  �Rafael Rodrigues    � Data � 10/Fev/2004 ���
�������������������������������������������������������������������������͹��
���Desc.     �Faz as verificacoes para ambiente TopConnect                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Migracao de Bases                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAC129Chk( cLogFile, cTable )
Local cQuery
Local lOk := .T.

//���������������������������������������������
//�Verifica duplicidades para a primeira chave�
//���������������������������������������������
cQuery := "select JBL_CODCUR, JBL_PERLET, JBL_HABILI, JBL_TURMA, JBL_DIASEM, JBL_ITEM "
cQuery += "  from "+cTable
cQuery += " group by JBL_CODCUR, JBL_PERLET, JBL_HABILI, JBL_TURMA, JBL_DIASEM, JBL_ITEM "
cQuery += "having count(*) > 1 "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )
                
QRY->(dbGoTop())
lOk := lOk .and. QRY->( eof() )
while QRY->( !eof() ) .and. !lEnd
	AcaLog( cLogFile, '  Inconsist�ncia na grade. Chave duplicada para o curso '+QRY->JBL_CODCUR+', per�odo '+QRY->JBL_PERLET+', habilitacao '+QRY->JBL_HABILI+', turma '+QRY->JBL_TURMA+', dia '+QRY->JBL_DIASEM+', aula '+QRY->JBL_ITEM+'.' )
	QRY->( dbSkip() )
end

QRY->( dbCloseArea() )

//���������������������������������������������
//�Verifica duplicidades para a segunda chave �
//���������������������������������������������
cQuery := "select JBL_CODCUR, JBL_PERLET, JBL_HABILI, JBL_TURMA, JBL_DIASEM, JBL_HORA1, JBL_HORA2, JBL_CODDIS, JBL_CODLOC, JBL_CODPRE, JBL_ANDAR, JBL_CODSAL, JBL_DATA1, JBL_DATA2 "
cQuery += "  from "+cTable
cQuery += " group by JBL_CODCUR, JBL_PERLET, JBL_HABILI, JBL_TURMA, JBL_DIASEM, JBL_HORA1, JBL_HORA2, JBL_CODDIS, JBL_CODLOC, JBL_CODPRE, JBL_ANDAR, JBL_CODSAL, JBL_DATA1, JBL_DATA2 "
cQuery += "having count(*) > 1 "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "QRY", .F., .F. )

QRY->(dbGoTop())
lOk := lOk .and. QRY->( eof() )
while QRY->( !eof() )
	AcaLog( cLogFile, '  Inconsist�ncia na grade. Chave duplicada para o curso '+QRY->JBL_CODCUR+', per�odo '+QRY->JBL_PERLET+', habilita��o '+QRY->JBL_HABILI+', turma '+QRY->JBL_TURMA+', dia '+QRY->JBL_DIASEM+', horario '+QRY->JBL_HORA1+' a '+QRY->JBL_HORA2+', disciplina '+QRY->JBL_CODDIS+'.' )
	QRY->( dbSkip() )
end

QRY->( dbCloseArea() )

Return lOk