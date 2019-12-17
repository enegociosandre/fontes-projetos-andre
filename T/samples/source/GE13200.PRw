#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GE13200   �Autor  �Rafael Rodrigues    � Data �  27/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa o cadastro de Matriculas dos Alunos                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Importacao de Bases, GE.                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GE13200()
Local aStru		:= {}
Local aFiles	:= {}
Local aTables	:= {}
Local cLogFile	:= 'AC13200.log'
Local cLog		:= U_xCreateLog()
Local lForceLog	:= .F.
Local aObrig	:= {}
Local lEnd		:= .F.
Local lOk		:= .T.
Local cIDX		:= CriaTrab( nil, .F. )
Local i         := 0

aAdd( aStru, { "JBE_NUMRA" , "C", 015, 0 } )
aAdd( aStru, { "JBE_CODCUR", "C", 006, 0 } )
aAdd( aStru, { "JBE_PERLET", "C", 002, 0 } )
aAdd( aStru, { "JBE_TURMA" , "C", 003, 0 } )
aAdd( aStru, { "JBE_TIPO"  , "C", 001, 0 } )
aAdd( aStru, { "JBE_ATIVO" , "C", 001, 0 } )
aAdd( aStru, { "JBE_SITUAC", "C", 001, 0 } )
aAdd( aStru, { "JBE_DTMATR", "D", 008, 0 } )
aAdd( aStru, { "JBE_ANOLET", "C", 004, 0 } )
aAdd( aStru, { "JBE_PERIOD", "C", 002, 0 } )
aAdd( aStru, { "JC7_DISCIP", "C", 015, 0 } )
aAdd( aStru, { "JC7_CODLOC", "C", 006, 0 } )
aAdd( aStru, { "JC7_CODPRE", "C", 006, 0 } )
aAdd( aStru, { "JC7_ANDAR" , "C", 003, 0 } )
aAdd( aStru, { "JC7_CODSAL", "C", 006, 0 } )
aAdd( aStru, { "JC7_SITDIS", "C", 003, 0 } )
aAdd( aStru, { "JC7_SITUAC", "C", 001, 0 } )
aAdd( aStru, { "JC7_DIASEM", "C", 001, 0 } )
aAdd( aStru, { "JC7_CODHOR", "C", 006, 0 } )
aAdd( aStru, { "JC7_HORA1" , "C", 005, 0 } )
aAdd( aStru, { "JC7_HORA2" , "C", 005, 0 } )
aAdd( aStru, { "JC7_CODPRF", "C", 006, 0 } )
aAdd( aStru, { "JC7_CODPR2", "C", 006, 0 } )
aAdd( aStru, { "JC7_CODPR3", "C", 006, 0 } )
aAdd( aStru, { "JC7_OUTCUR", "C", 006, 0 } )
aAdd( aStru, { "JC7_OUTPER", "C", 002, 0 } )
aAdd( aStru, { "JC7_OUTTUR", "C", 003, 0 } )
aAdd( aStru, { "JC7_MEDFIM", "N", 005, 2 } )
aAdd( aStru, { "JC7_MEDCON", "C", 001, 0 } )
aAdd( aStru, { "JC7_DISDP" , "C", 015, 0 } )
aAdd( aStru, { "JC7_SITDP" , "C", 003, 0 } )
aAdd( aStru, { "JC7_DPBAIX", "C", 001, 0 } )
aAdd( aStru, { "JC7_CURDP" , "C", 006, 0 } )
aAdd( aStru, { "JC7_PERDP" , "C", 002, 0 } )
aAdd( aStru, { "JC7_TURDP" , "C", 003, 0 } )
aAdd( aStru, { "JC7_CURORI", "C", 006, 0 } )
aAdd( aStru, { "JC7_PERORI", "C", 002, 0 } )
aAdd( aStru, { "JC7_TURORI", "C", 003, 0 } )
aAdd( aStru, { "JC7_DISORI", "C", 015, 0 } )
aAdd( aStru, { "JC7_SITORI", "C", 003, 0 } )
aAdd( aStru, { "JC7_APROVE", "C", 001, 0 } )
aAdd( aStru, { "JC7_CODINS", "C", 006, 0 } )
aAdd( aStru, { "JC7_ANOINS", "C", 006, 0 } )

aAdd( aFiles, { 'Matr�culas dos Alunos', '\Import\AC13200.TXT', aStru, 'TRB', .T. } )

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
	if Empty( TRB->JBE_NUMRA )
		RecLock( "TRB", .F. )
		TRB->( dbDelete() )
		TRB->( msUnlock() )
	endif
	
	//�������������������������������������������������������������Ŀ
	//�prepara as consistencias a serem feitas no arquivo temporario�
	//���������������������������������������������������������������
	aAdd( aObrig, { '!Empty(JBE_NUMRA)  ', 'RA do aluno n�o informado.' } )
	aAdd( aObrig, { 'JBE_NUMRA == Posicione( "JA2", 1, xFilial("JA2")+JBE_NUMRA, "JA2_NUMRA" )', 'Aluno n�o cadastrado na tabela JA2.' } )
	aAdd( aObrig, { '!Empty(JBE_CODCUR) ', 'C�digo do curso vigente n�o informado.' } )
	aAdd( aObrig, { 'JBE_CODCUR == Posicione( "JAH", 1, xFilial("JAH")+JBE_CODCUR, "JAH_CODIGO" )', 'Curso vigente n�o cadastrado na tabela JAH.' } )
	aAdd( aObrig, { '!Empty(JBE_PERLET) ', 'Per�odo letivo n�o informado.' } )
	aAdd( aObrig, { 'JBE_PERLET == Posicione( "JAR", 1, xFilial("JAR")+JBE_CODCUR+JBE_PERLET, "JAR_PERLET" )', 'Per�odo letivo n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { '!Empty(JBE_TURMA)  ', 'Turma n�o informada.' } )
	aAdd( aObrig, { 'JBE_TURMA  == Posicione( "JBO", 1, xFilial("JBO")+JBE_CODCUR+JBE_PERLET+JBE_TURMA, "JBO_TURMA" )', 'Turma n�o cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'JBE_TIPO$"12"      ', 'Tipo deve ser 1=Regular ou 2=Depend�ncia).' } )
	aAdd( aObrig, { 'JBE_ATIVO$"1234567"', 'Ativo deve ser 1=Sim, 2=N�o, 3=Transferido, 4=Trancado, 5=Formado, 6=Cancelado, 7=Desist�ncia.' } )
	aAdd( aObrig, { 'JBE_SITUAC$"12"    ', 'Situa��o deve ser 1=Pre-matr�cula ou 2=Matr�cula.' } )
	aAdd( aObrig, { '!Empty(JBE_DTMATR) ', 'Data de matr�cula n�o informada.' } )
	aAdd( aObrig, { '!Empty(JBE_ANOLET) ', 'Ano letivo n�o informado.' } )
	aAdd( aObrig, { 'JBE_ANOLET == StrZero( Val(JBE_ANOLET), 4 ) ', 'Ano letivo deve ser informado com 4 d�gitos.' } )
	aAdd( aObrig, { '!Empty(JBE_PERIOD) ', 'Per�odo do ano n�o informado.' } )
	aAdd( aObrig, { 'JBE_PERIOD == StrZero( Val(JBE_PERIOD), 2 ) ', 'Per�odo do ano deve ser informado com zero � esquerda.' } )
	aAdd( aObrig, { '!Empty(JC7_DISCIP) ', 'Disciplina n�o informada.' } )
	aAdd( aObrig, { 'JC7_DISCIP == Posicione( "JAE", 1, xFilial("JAE")+JC7_DISCIP, "JAE_CODIGO" )', 'Disciplina n�o cadastrada na tabela JAE.' } )
	aAdd( aObrig, { '!Empty(JC7_CODLOC) ', 'C�digo do local n�o informado.' } )
	aAdd( aObrig, { 'JC7_CODLOC == Posicione( "JA3", 1, xFilial("JA3")+JC7_CODLOC, "JA3_CODLOC" )', 'Local n�o cadastrado na tabela JA3.' } )
	aAdd( aObrig, { '!Empty(JC7_CODPRE) ', 'C�digo do pr�dio n�o informado.' } )
	aAdd( aObrig, { 'JC7_CODPRE == Posicione( "JA4", 1, xFilial("JA4")+JC7_CODLOC+JC7_CODPRE, "JA4_CODPRE" )', 'Pr�dio n�o cadastrado na tabela JA4.' } )
	aAdd( aObrig, { '!Empty(JC7_ANDAR) ', 'Andar n�o informado.' } )
	aAdd( aObrig, { '!Empty(JC7_CODSAL) ', 'C�digo da sala n�o informado.' } )
	aAdd( aObrig, { 'JC7_CODSAL == Posicione( "JA5", 1, xFilial("JA5")+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL, "JA5_CODSAL" )', 'Andar/Sala n�o cadastrados na tabela JA5.' } )
	aAdd( aObrig, { 'JC7_SITDIS == Left( Posicione( "SX5", 1, xFilial("SX5")+"F3"+JC7_SITDIS, "X5_CHAVE" ), 3)', 'A situa��o da disciplina n�o est� cadastrada na sub-tabela F3 da tabela SX5.' } )
	aAdd( aObrig, { 'JC7_SITUAC$"123456789"', 'Situa��o acad�mica da disciplina deve ser 1=Cursando, 2=Aprovado, 3=Reprovado por Nota, 4=Reprovado por Faltas, 5=Reprovado por Nota e Faltas, 6=Exame, 7=Trancado, 8=Dispensado ou 9=Cancelado.' } )
	aAdd( aObrig, { 'JC7_DIASEM$"1234567"', 'Dia da semana deve ser 1=Domingo, 2=Segunda... 7=S�bado.' } )
	aAdd( aObrig, { '!Empty(JC7_CODHOR) ', 'C�digo do hor�rio n�o informado.' } )
	aAdd( aObrig, { '!Empty(JC7_HORA1) ', 'Hora inicial n�o informada.' } )
	aAdd( aObrig, { '!Empty(JC7_HORA2) ', 'Hora final n�o informada.' } )
	aAdd( aObrig, { 'JC7_CODHOR == Posicione( "JBD", 2, xFilial("JBD")+JC7_CODHOR+JC7_HORA1+JC7_HORA2, "JBD_CODIGO" )', 'C�digo do horario + Hora inicial + Hora final n�o cadastrados na tabela JBD.' } )
	aAdd( aObrig, { 'Empty(JC7_CODPRF) .or. !Empty(AcNomeProf(JC7_CODPRF))  ', 'Professor 1 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'Empty(JC7_CODPR2) .or. !Empty(AcNomeProf(JC7_CODPR2))  ', 'Professor 2 n�o cadastrado na tabela SRA.' } )
	aAdd( aObrig, { 'Empty(JC7_CODPR3) .or. !Empty(AcNomeProf(JC7_CODPR3))  ', 'Professor 3 n�o cadastrado na tabela SRA.' } )

	aAdd( aObrig, { 'Empty(JC7_OUTCUR) .or. JBE_OUTCUR == Posicione( "JAH", 1, xFilial("JAH")+JBE_OUTCUR, "JAH_CODIGO" )', 'Curso da disciplina n�o cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'Empty(JC7_OUTPER) .or. JBE_OUTPER == Posicione( "JAR", 1, xFilial("JAR")+JBE_OUTCUR+JBE_OUTPER, "JAR_PERLET" )', 'Per�odo letivo da disciplina n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'Empty(JC7_OUTTUR) .or. JBE_OUTTUR == Posicione( "JBO", 1, xFilial("JBO")+JBE_OUTCUR+JBE_OUTPER+JBE_OUTTUR, "JBO_TURMA" )', 'Turma da disciplina n�o cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'Empty(JC7_OUTCUR) == Empty(JC7_OUTPER) .and. Empty(JC7_OUTPER) == Empty(JC7_OUTTUR)', 'Os campos JC7_OUTCUR, JC7_OUTPER e JC7_OUTTUR devem ser informados conjuntamente.' } )

	aAdd( aObrig, { 'JC7_MEDFIM <= 10', 'Media final maior que 10.' } )
	aAdd( aObrig, { 'JC7_DPBAIX$"12 "', '"DP baixada?" deve ser 1=Sim ou 2=N�o.' } )

	aAdd( aObrig, { 'Empty(JC7_CURDP) .or. JBE_CURDP == Posicione( "JAH", 1, xFilial("JAH")+JBE_CURDP, "JAH_CODIGO" )', 'Curso DP n�o cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'Empty(JC7_PERDP) .or. JBE_PERDP == Posicione( "JAR", 1, xFilial("JAR")+JBE_CURDP+JBE_PERDP, "JAR_PERLET" )', 'Per�odo letivo DP n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'Empty(JC7_TURDP) .or. JBE_TURDP == Posicione( "JBO", 1, xFilial("JBO")+JBE_CURDP+JBE_PERDP+JBE_TURDP, "JBO_TURMA" )', 'Turma DP n�o cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'Empty(JC7_DISDP) .or. JC7_DISDP == Posicione( "JAE", 1, xFilial("JAE")+JC7_DISDP, "JAE_CODIGO" )', 'Disciplina cursada como DP n�o cadastrada na tabela JAE.' } )
	aAdd( aObrig, { 'Empty(JC7_SITDP) .or. JC7_SITDP == Left( Posicione( "SX5", 1, xFilial("SX5")+"F3"+JC7_SITDP, "X5_CHAVE" ), 3)', 'A situa��o da disciplina DP n�o est� cadastrada na sub-tabela F3 da tabela SX5.' } )
	aAdd( aObrig, { 'Empty(JC7_CURDP) == Empty(JC7_PERDP) .and. Empty(JC7_PERDP) == Empty(JC7_TURDP) .and.  Empty(JC7_TURDP) == Empty(JC7_DISDP) .and. Empty(JC7_DISDP) == Empty(JC7_SITDP)', 'Os campos JC7_CURDP, JC7_PERDP, JC7_TURDP, JC7_DISDP e JC7_SITDP devem ser informados conjuntamente.' } )

	aAdd( aObrig, { 'Empty(JC7_CURORI) .or. JBE_CURORI == Posicione( "JAH", 1, xFilial("JAH")+JBE_CURORI, "JAH_CODIGO" )', 'Curso DP origem n�o cadastrado na tabela JAH.' } )
	aAdd( aObrig, { 'Empty(JC7_PERORI) .or. JBE_PERORI == Posicione( "JAR", 1, xFilial("JAR")+JBE_CURORI+JBE_PERORI, "JAR_PERLET" )', 'Per�odo letivo DP origem n�o cadastrado na tabela JAR.' } )
	aAdd( aObrig, { 'Empty(JC7_TURORI) .or. JBE_TURORI == Posicione( "JBO", 1, xFilial("JBO")+JBE_CURORI+JBE_PERORI+JBE_TURORI, "JBO_TURMA" )', 'Turma DP origem n�o cadastrada na tabela JBO.' } )
	aAdd( aObrig, { 'Empty(JC7_DISORI) .or. JC7_DISORI == Posicione( "JAE", 1, xFilial("JAE")+JC7_DISORI, "JAE_CODIGO" )', 'Disciplina DP origem n�o cadastrada na tabela JAE.' } )
	aAdd( aObrig, { 'Empty(JC7_SITORI) .or. JC7_SITORI == Left( Posicione( "SX5", 1, xFilial("SX5")+"F3"+JC7_SITORI, "X5_CHAVE" ), 3)', 'A situa��o da disciplina DP origem n�o est� cadastrada na sub-tabela F3 da tabela SX5.' } )
	aAdd( aObrig, { 'Empty(JC7_CURORI) == Empty(JC7_PERORI) .and. Empty(JC7_PERORI) == Empty(JC7_TURORI) .and.  Empty(JC7_TURORI) == Empty(JC7_DISORI) .and. Empty(JC7_DISORI) == Empty(JC7_SITORI)', 'Os campos JC7_CURORI, JC7_PERORI, JC7_TURORI, JC7_DISORI e JC7_SITORI devem ser informados conjuntamente.' } )

	aAdd( aObrig, { 'JC7_APROVE$"12 "', '"Tem aproveitamento de estudos?" deve ser 1=Sim ou 2=N�o.' } )
	aAdd( aObrig, { '(JC7_APROVE$"12" .and. JC7_SITDIS == "003") .or. (JC7_APROVE$"2 " .and. JC7_SITDIS != "003")', 'Aproveitamento de estudos s� pode existir se a situa��o da disciplina for 003=Dispensado.' } )
	aAdd( aObrig, { 'JC7_APROVE$"2 " .or. !Empty(JC7_CODINS)', 'Institui��o onde cursou a disciplina deve ser informada quando houver aproveitamento de estudos.' } )
	aAdd( aObrig, { 'Empty(JC7_CODINS) .or. JC7_CODINS == Posicione("JCL",1,xFilial("JCL")+JC7_CODINS,"JCL_CODIGO")'	, 'Institui��o onde cursou a disciplina n�o cadastrada na tabela JCL.' } )
	aAdd( aObrig, { 'JC7_APROVE$"2 " .or. !Empty(JC7_ANOINS)', 'Ano de conclus�o da disciplina deve ser informado quando houver aproveitamento de estudos.' } )
	
	//����������������������������Ŀ
	//�ordena o arquivo de trabalho�
	//������������������������������
	MsgRun( 'Ordenando arquivo...',, {|| IndRegua( "TRB", cIDX, "JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1" ) } )
	//����������������������������������������������������Ŀ
	//�verifica chaves unicas e consistencias pre-definidas�
	//������������������������������������������������������
	Processa( { |lEnd| lOk := U_GEChkInt( "TRB", "JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1", .F., aObrig, cLog, @lEnd, if( lForceLog, cLogFile, nil ) ) .and. lOk }, 'Valida��o do Arquivo' )
	
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
		Processa( { |lEnd| lOk := GE13200Grv( @lEnd ) }, 'Grava��o em andamento' )
		
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
���Programa  �GE13200Grv �Autor  �Rafael Rodrigues   � Data �  27/12/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a gravacao dos dados na base do AP6.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GE13200                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GE13200Grv( lEnd )
Local cFilJBE	:= xFilial("JBE")	// Criada para ganhar performance
Local cFilJC7	:= xFilial("JC7")	// Criada para ganhar performance
Local cFilJCO	:= xFilial("JCO")	// Criada para ganhar performance
Local i			:= 0
Local cKeyJBE	:= ""

ProcRegua( TRB->( RecCount() ) )

TRB->( dbGoTop() )

JBE->( dbSetOrder(1) )
JC7->( dbSetOrder(1) )
JCO->( dbSetOrder(1) )

while TRB->( !eof() ) .and. !lEnd
	
	IncProc( 'Gravando linha '+StrZero( ++i, 6 )+' de '+StrZero( TRB->( RecCount() ), 6 )+'...' )

	if cKeyJBE <> TRB->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_TURMA)
		cKeyJBE := TRB->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_TURMA)

		begin transaction

		RecLock( "JBE", JBE->( !dbSeek( cFilJBE+TRB->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_TURMA) ) ) )
		JBE->JBE_FILIAL	:= cFilJBE
		JBE->JBE_CODCUR	:= TRB->JBE_CODCUR
		JBE->JBE_PERLET	:= TRB->JBE_PERLET
		JBE->JBE_TURMA	:= TRB->JBE_TURMA
		JBE->JBE_NUMRA	:= TRB->JBE_NUMRA
		JBE->JBE_TIPO	:= TRB->JBE_TIPO
		JBE->JBE_ATIVO	:= TRB->JBE_ATIVO
		JBE->JBE_SITUAC	:= TRB->JBE_SITUAC
		JBE->JBE_DTMATR	:= TRB->JBE_DTMATR
		JBE->JBE_ANOLET	:= TRB->JBE_ANOLET
		JBE->JBE_PERIOD	:= TRB->JBE_PERIOD
		JBE->( msUnlock() )

		end transaction
	endif
	
	if TRB->JC7_APROVE == "1"
		begin transaction

		RecLock( "JCO", JCO->( !dbSeek( cFilJCO+TRB->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JC7_DISCIP) ) ) )
		JCO->JCO_FILIAL	:= cFilJCO
		JCO->JCO_NUMRA	:= TRB->JBE_NUMRA
		JCO->JCO_CODCUR	:= TRB->JBE_CODCUR
		JCO->JCO_PERLET	:= TRB->JBE_PERLET
		JCO->JCO_DISCIP	:= TRB->JC7_DISCIP
		JCO->JCO_MEDFIM	:= TRB->JC7_MEDFIM
		JCO->JCO_MEDCON	:= TRB->JC7_MEDCON
		JCO->JCO_CODINS	:= TRB->JC7_CODINS
		JCO->JCO_ANOINS	:= TRB->JC7_ANOINS
		JCO->( msUnlock() )
	
		end transaction
	
	endif

	begin transaction
	
	RecLock( "JC7", JC7->( !dbSeek( cFilJC7+TRB->(JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_TURMA+JC7_DISCIP+JC7_CODLOC+JC7_CODPRE+JC7_ANDAR+JC7_CODSAL+JC7_DIASEM+JC7_HORA1) ) ) )
	JC7->JC7_FILIAL	:= cFilJC7
	JC7->JC7_NUMRA	:= TRB->JBE_NUMRA
	JC7->JC7_CODCUR	:= TRB->JBE_CODCUR
	JC7->JC7_PERLET	:= TRB->JBE_PERLET
	JC7->JC7_TURMA	:= TRB->JBE_TURMA
	JC7->JC7_DISCIP	:= TRB->JC7_DISCIP
	JC7->JC7_CODLOC	:= TRB->JC7_CODLOC
	JC7->JC7_CODPRE	:= TRB->JC7_CODPRE
	JC7->JC7_ANDAR	:= TRB->JC7_ANDAR
	JC7->JC7_CODSAL	:= TRB->JC7_CODSAL
	JC7->JC7_SITDIS	:= TRB->JC7_SITDIS
	JC7->JC7_SITUAC	:= TRB->JC7_SITUAC
	JC7->JC7_DIASEM	:= TRB->JC7_DIASEM
	JC7->JC7_CODHOR	:= TRB->JC7_CODHOR
	JC7->JC7_HORA1	:= TRB->JC7_HORA1
	JC7->JC7_HORA2	:= TRB->JC7_HORA2
	JC7->JC7_CODPRF	:= TRB->JC7_CODPRF
	JC7->JC7_CODPR2	:= TRB->JC7_CODPR2
	JC7->JC7_CODPR3	:= TRB->JC7_CODPR3
	JC7->JC7_OUTCUR	:= TRB->JC7_OUTCUR
	JC7->JC7_OUTPER	:= TRB->JC7_OUTPER
	JC7->JC7_OUTTUR	:= TRB->JC7_OUTTUR
	JC7->JC7_MEDFIM	:= TRB->JC7_MEDFIM
	JC7->JC7_MEDAJU	:= TRB->JC7_MEDFIM
	JC7->JC7_DISDP	:= TRB->JC7_DISDP
	JC7->JC7_SITDP	:= TRB->JC7_SITDP
	JC7->JC7_DPBAIX	:= TRB->JC7_DPBAIX
	JC7->JC7_CURDP	:= TRB->JC7_CURDP
	JC7->JC7_PERDP	:= TRB->JC7_PERDP
	JC7->JC7_TURDP	:= TRB->JC7_TURDP
	JC7->JC7_CURORI	:= TRB->JC7_CURORI
	JC7->JC7_PERORI	:= TRB->JC7_PERORI
	JC7->JC7_TURORI	:= TRB->JC7_TURORI
	JC7->JC7_DISORI	:= TRB->JC7_DISORI
	JC7->JC7_SITORI	:= TRB->JC7_SITORI
	JC7->JC7_MEDCON	:= TRB->JC7_MEDCON
	JC7->JC7_CODINS	:= TRB->JC7_CODINS
	JC7->JC7_ANOINS	:= TRB->JC7_ANOINS
	JC7->( msUnlock() )

	end transaction

	TRB->( dbSkip() )
end

Return !lEnd