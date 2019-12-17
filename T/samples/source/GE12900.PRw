#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE12900   �Autor  �Rafael Rodrigues    � Data �  19/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Grades de Aulas                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE12900()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC12900.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JBL_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBL_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBL_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JBL_ITEM"  , "C", 002, 0 } )
aAdd( aStru, { "JBL_CODHOR", "C", 006, 0 } )
aAdd( aStru, { "JBL_HORA1" , "C", 005, 0 } )
aAdd( aStru, { "JBL_HORA2" , "C", 005, 0 } )
aAdd( aStru, { "JBL_CODDIS", "C", 015, 0 } )
aAdd( aStru, { "JBL_CARGA" , "N", 004, 0 } )
aAdd( aStru, { "JBL_MATPRF", "C", 006, 0 } )
aAdd( aStru, { "JBL_MATPR2", "C", 006, 0 } )
aAdd( aStru, { "JBL_MATPR3", "C", 006, 0 } )
aAdd( aStru, { "JBL_DIASEM", "C", 001, 0 } )
aAdd( aStru, { "JBL_CODLOC", "C", 006, 0 } )
aAdd( aStru, { "JBL_CODPRE", "C", 006, 0 } )
aAdd( aStru, { "JBL_ANDAR" , "C", 003, 0 } )
aAdd( aStru, { "JBL_CODSAL", "C", 006, 0 } )
aAdd( aStru, { "JBK_ATIVO" , "C", 001, 0 } )
aAdd( aStru, { "JBL_REMUNE", "C", 001, 0 } )
aAdd( aStru, { "JBL_DATA1" , "D", 008, 0 } )
aAdd( aStru, { "JBL_DATA2" , "D", 008, 0 } )

aAdd( aFiles, { 'Grades de Aulas', '\Import\AC12900.TXT', aStru, 'TRB', .T. } )

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
	if Empty( TRB->JBL_CODCUR )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { 'JBK_ATIVO$"12"'     , '"Grade Ativa?" deve ser 1(Sim) ou 2(N�o).' } )
	aAdd( aObrig, { '!Empty(JBL_CODCUR) ', 'C�digo do curso vigente n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBL_PERLET) ', 'Per�odo letivo n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBL_TURMA)  ', 'Turma n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBL_ITEM)   ', 'Aula n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBL_CODHOR) ', 'C�digo do hor�rio n�o informado.' } )
	aAdd( aObrig, { 'U_GEIsHora(JBL_HORA1,.F.) ', 'Hor�rio inicial n�o informado ou inv�lido.' } )
	aAdd( aObrig, { 'U_GEIsHora(JBL_HORA2,.F.) ', 'Hor�rio final n�o informado ou inv�lido.' } )
	aAdd( aObrig, { '!Empty(JBL_CODDIS) ', 'Disciplina n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBL_CARGA)  ', 'Carga hor�ria n�o informada.' } )
	aAdd( aObrig, { 'JBL_DIASEM$"1234567"', 'Dia da semana deve ser entre 1 e 7 (1=domingo, 7=s�bado).' } )
	aAdd( aObrig, { '!Empty(JBL_CODLOC) ', 'Local n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBL_CODPRE) ', 'Predio n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBL_ANDAR)  ', 'Andar n�o informado.' } )
	aAdd( aObrig, { '!Empty(JBL_CODSAL) ', 'Sala n�o informada.' } )
	aAdd( aObrig, { '!(JBL_DIASEM$"1234567") .or. Posicione( "JAR", 1, xFilial("JAR")+JBL_CODCUR+JBL_PERLET, "JAR_AULA"+JBL_DIASEM ) == "1"', 'O curso vigente n�o possui aula neste dia da semana.' } )
	aAdd( aObrig, { 'JBL_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JBL_CODCUR, "JAH_CODIGO" )', 'Curso vigente n�o cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'JBL_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JBL_CODCUR+JBL_PERLET, "JAR_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'JBL_TURMA  == Posicione( "JBO", 1, xFilial("JBO")+JBL_CODCUR+JBL_PERLET+JBL_TURMA, "JBO_TURMA" )', 'Turma n�o cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'JBL_CODHOR == Posicione( "JBD", 2, xFilial("JBD")+JBL_CODHOR+JBL_HORA1+JBL_HORA2, "JBD_CODIGO" )', 'C�digo do horario + Hora inicial + Hora final n�o cadastrados na tabela JBD.' } )
	aAdd( aObrig, { 'JBL_CODDIS == Posicione( "JAS", 2, xFilial("JAS")+JBL_CODCUR+JBL_PERLET+JBL_CODDIS, "JAS_CODDIS" )', 'Disciplina n�o cadastrada na tabela JAS.' } )
	aAdd( aObrig, { 'Empty(JBL_MATPRF) .or. !Empty(ACNomeProf(JBL_MATPRF))', 'Professor 1 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'Empty(JBL_MATPR2) .or. !Empty(ACNomeProf(JBL_MATPR2))', 'Professor 2 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'Empty(JBL_MATPR3) .or. !Empty(ACNomeProf(JBL_MATPR3))', 'Professor 3 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'JBL_CODLOC == Posicione( "JA3", 1, xFilial("JA3")+JBL_CODLOC, "JA3_CODLOC" )', 'Local n�o cadastrado na tabela JA3.' } )
	aAdd( aObrig, { 'JBL_CODPRE == Posicione( "JA4", 1, xFilial("JA4")+JBL_CODLOC+JBL_CODPRE, "JA4_CODPRE" )', 'Pr�dio n�o cadastrado na tabela JA4.' } )
	aAdd( aObrig, { 'JBL_CODSAL == Posicione( "JA5", 1, xFilial("JA5")+JBL_CODLOC+JBL_CODPRE+JBL_ANDAR+JBL_CODSAL, "JA5_CODSAL" )', 'Andar/Sala n�o cadastrados na tabela JA5.' } )
	aAdd( aObrig, { 'JBL_REMUNE$"12"', '"Aula remunerada?" dever ser 1=Sim ou 2=N�o.' } )
	aAdd( aObrig, { '(Empty(JBL_DATA2) .and. Empty(JBL_DATA1)) .or. (!Empty(JBL_DATA2) .and. !Empty(JBL_DATA1))', 'As datas inicial e final devem ser informadas conjuntamente.' } )
	aAdd( aObrig, { 'Empty(JBL_DATA2) .or. JBL_DATA2 > JBL_DATA1', 'A data final deve ser maior que a data inicial.' } )
	aAdd( aObrig, { 'Empty(JBL_DATA1) .or. JBL_DATA1 >= Posicione( "JAR", 1, xFilial("JAR")+JBL_CODCUR+JBL_PERLET, "JAR_DATA1" )', 'Data inicial deve estar dentro das datas de realiza��o do per�odo letivo.' } )
	aAdd( aObrig, { 'Empty(JBL_DATA2) .or. JBL_DATA2 <= Posicione( "JAR", 1, xFilial("JAR")+JBL_CODCUR+JBL_PERLET, "JAR_DATA2" )', 'Data final deve estar dentro das datas de realiza��o do per�odo letivo.' } )

	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JBL_CODCUR+JBL_PERLET+JBL_TURMA+JBL_DIASEM+JBL_HORA1+JBL_CODDIS+JBL_CODLOC+JBL_CODPRE+JBL_ANDAR+JBL_CODSAL", .T., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk, lOk := U_GEChkInt( "TRB", "JBL_CODCUR+JBL_PERLET+JBL_TURMA+JBL_DIASEM+JBL_ITEM", .T., {}, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Valida��o do Arquivo' )
	
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
		Processa( { |lEnd| lOk := GE12900Grv( @lEnd ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE12900Grv �Autor  �Rafael Rodrigues   � Data �  20/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE12900                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE12900Grv( lEnd )
Local cFilJBL	:= xFilial("JBL")	// Criada para ganhar performance
Local cFilJBK	:= xFilial("JBK")	// Criada para ganhar performance
Local cChave	:= ""
Local i			:= 0

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JBL->( dbSetOrder(3) )
JBK->( dbSetOrder(3) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )

	if cChave <> TRB->JBL_CODCUR+TRB->JBL_PERLET+TRB->JBL_TURMA
		cChave := TRB->JBL_CODCUR+TRB->JBL_PERLET+TRB->JBL_TURMA
		
		begin transaction

		RecLock( "JBK", JBK->( !dbSeek( cFilJBK+TRB->JBL_CODCUR+TRB->JBL_PERLET+TRB->JBL_TURMA ) ) )
		JBK->JBK_FILIAL	:= cFilJBK
		JBK->JBK_CODCUR	:= TRB->JBL_CODCUR
		JBK->JBK_PERLET	:= TRB->JBL_PERLET
		JBK->JBK_TURMA	:= TRB->JBL_TURMA
		JBK->JBK_ATIVO	:= TRB->JBK_ATIVO
		JBK->( msUnlock() )
	
		end transaction
		
	endif
	
	begin transaction
	
	RecLock( "JBL", JBL->( !dbSeek( cFilJBL+TRB->JBL_CODCUR+TRB->JBL_PERLET+TRB->JBL_TURMA+TRB->JBL_DIASEM+TRB->JBL_ITEM ) ) )
	JBL->JBL_FILIAL	:= cFilJBL
	JBL->JBL_CODCUR	:= TRB->JBL_CODCUR
	JBL->JBL_PERLET	:= TRB->JBL_PERLET
	JBL->JBL_TURMA	:= TRB->JBL_TURMA
	JBL->JBL_ITEM	:= TRB->JBL_ITEM
	JBL->JBL_CODHOR	:= TRB->JBL_CODHOR
	JBL->JBL_HORA1	:= TRB->JBL_HORA1
	JBL->JBL_HORA2	:= TRB->JBL_HORA2
	JBL->JBL_CODDIS	:= TRB->JBL_CODDIS
	JBL->JBL_MATPRF	:= TRB->JBL_MATPRF
	JBL->JBL_MATPR2	:= TRB->JBL_MATPR2
	JBL->JBL_MATPR3	:= TRB->JBL_MATPR3
	JBL->JBL_DIASEM	:= TRB->JBL_DIASEM
	JBL->JBL_CODLOC	:= TRB->JBL_CODLOC
	JBL->JBL_CODPRE	:= TRB->JBL_CODPRE
	JBL->JBL_ANDAR	:= TRB->JBL_ANDAR
	JBL->JBL_CODSAL	:= TRB->JBL_CODSAL
	JBL->JBL_REMUNE	:= TRB->JBL_REMUNE
	JBL->JBL_DATA1	:= if( !Empty(TRB->JBL_DATA1), TRB->JBL_DATA1, Posicione("JAS",1,xFilial("JAS")+TRB->JBL_CODCUR+TRB->JBL_PERLET+TRB->JBL_CODDIS, "JAS_DATA1") )
	JBL->JBL_DATA2	:= if( !Empty(TRB->JBL_DATA2), TRB->JBL_DATA2, Posicione("JAS",1,xFilial("JAS")+TRB->JBL_CODCUR+TRB->JBL_PERLET+TRB->JBL_CODDIS, "JAS_DATA2") )
	JBL->( msUnlock() )
	
	end transaction

	TRB->( dbSkip() )
end

Return !lEnd