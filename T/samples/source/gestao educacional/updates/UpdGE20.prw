#INCLUDE "Protheus.ch"        
#INCLUDE "Fileio.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �UpdGE20    �Autora �Flavia Monzano        � Data � 24/10/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualizacao do Dicionario de Dados e Base de Dados para 	  ���
���          � contemplar a melhoria de Sub-Divisao(Tipo Candidato / 	  ���
���          � Tipo Deficiencia / Religiao)	  							  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAGE                                                     ���
�������������������������������������������������������������������������Ĵ��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���			 �        �      �							                  ���
���          �        �      �                                            ���
���          �        �      �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function UpdGE20()
Local cMsg := ""         

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

Private cMessage
Private aArqUpd	 := {}
Private aREOPEN	 := {}
Private oMainWnd          

Set Dele On

cMsg += "Este programa tem como objetivo ajustar os dicion�rios e base de dados "
cMsg += "para a implementa��o da melhoria de (TP.Candidato, Nec.Especiais e Religi�o.) "
cMsg += "Esta rotina deve ser processada em modo exclusivo! "
cMsg += "Fa�a um backup dos dicion�rios e base de dados antes do processamento!" 

oMainWnd := MSDIALOG():Create()
oMainWnd:cName := "oMainWnd"
oMainWnd:cCaption := "Implementando Melhoria (Tipo de Candidato, Necessidades Especiais e Religi�o)"
oMainWnd:nLeft := 0
oMainWnd:nTop := 0
oMainWnd:nWidth := 680
oMainWnd:nHeight := 540
oMainWnd:lShowHint := .F.
oMainWnd:lCentered := .T.
oMainWnd:bInit := {|| if( Aviso( "Atualizador de Base", cMsg, {"Cancelar", "Prosseguir"}, 2 ) == 2 , ( Processa({|lEnd| GEProc(@lEnd)} , "Atualizador de Base" ) , oMainWnd:End() ), ( MsgAlert( "Opera�ao cancelada!" ), oMainWnd:End() ) ) }

oMainWnd:Activate()
	
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GEProc    � Autora�Flavia Monzano        � Data � 24/10/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Processamento da Gravacao dos Arquivos           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao GE                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function GEProc(lEnd)
Local cTexto    := '' 				//Exibira o log ao final do processo
Local cFile     :="" 				//Nome do arquivo, caso o usuario deseje salvar o log das operacoes
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    := 0
Local nI        := 0                //Contador para laco
Local nX        := 0	            //Contador para laco
Local aRecnoSM0 := {}			
Local lOpen     := .F. 				//Retorna se conseguiu acesso exclusivo a base de dados
Local nModulo	:= 49 				//SIGAGE - GESTAO EDUCACIONAL

Private cArquivo   	:= "UpdGE20.LOG"
Private cErros   	:= "UpdErr.LOG"

//��������������������������������������������������������������������������Ŀ
//�Inicia o Processamento													 �
//����������������������������������������������������������������������������
IncProc("Verificando integridade dos dicion�rios....")

If ( lOpen := MyOpenSm0Ex() )

	dbSelectArea("SM0")
	dbGotop()
	While !Eof() 
		//��������������������������������������������������������������������������Ŀ
		//�Somente adiciona no aRecnoSM0 se a Empresa for Diferente					 �
		//����������������������������������������������������������������������������
  		If ( nI := Ascan( aRecnoSM0, {|x| x[2] == M0_CODIGO} ) ) == 0 
			aAdd(aRecnoSM0,{Recno(),M0_CODIGO,{}})
			nI := Len(aRecnoSM0)
		EndIf
		
		aAdd( aRecnoSM0[nI,3], SM0->M0_CODFIL )
		
		dbSkip()
	EndDo	
		
	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2) 
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			lMsFinalAuto := .F.

			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua( nI)
			IncProc("Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME)			

			//�����������������������������������Ŀ
			//�Atualiza o Dicionario de Dados SX1 �
			//�������������������������������������
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados SX1")			
			cTexto += "Analisando Dicionario de Dados SX1..."+CHR(13)+CHR(10)
			GEAtuSX1()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Dados SX1")              
			AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Processado Dicionario de Dados - SX1" )
			cTexto += "Processado Dicionario de Dados SX1..."+CHR(13)+CHR(10)
														
			//�����������������������������������Ŀ
			//�Atualiza o Dicionario de Dados SX3 �
			//�������������������������������������
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados SX3")			
			cTexto += "Analisando Dicionario de Dados SX3..."+CHR(13)+CHR(10)
			GEAtuSX3()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Dados SX3")              
			AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Processado Dicionario de Dados SX3" )
			cTexto += "Processado Dicionario de Dados SX3..."+CHR(13)+CHR(10)
			
			//�����������������������������������Ŀ
			//�Atualiza o Dicionario de Dados SIX �
			//�������������������������������������
			IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio - Dicionario de Dados SIX")
			cTexto += "Analisando Dicionario de Dados SIX..."+CHR(13)+CHR(10)
			GEAtuSIX()
			IncProc( dtoc( Date() )+" "+Time()+" "+"Fim - Dicionario de Dados SIX")
   			AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Processado Dicionario de Dados SIX" )
			cTexto += "Processado Dicionario de Dados SIX..."+CHR(13)+CHR(10)

			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc( dtoc( Date() )+" "+Time()+" "+"Inicio Atualizando Estruturas "+aArqUpd[nx])
				AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Inicio Atualizando Estruturas "+aArqUpd[nx] )
				
				cTexto += "Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]"+CHR(13)+CHR(10)
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
				IncProc( dtoc( Date() )+" "+Time()+" "+"Fim Atualizando Estruturas "+aArqUpd[nx])
				AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Fim Atualizando Estruturas "+aArqUpd[nx] )				
			Next nX
		
			RpcClearEnv()
			
		Next nI 

		//��������������������������������������������������������������������������Ŀ
		//�Atualiza a base de dados da Empresa para cada Filial						 �
		//����������������������������������������������������������������������������
		For nI := 1 To Len(aRecnoSM0)
		
			For nX := 1 To Len(aRecnoSM0[nI,3])
	
				RpcSetType(2)
				RpcSetEnv(aRecnoSM0[nI,2], aRecnoSM0[nI,3,nX])
				lMsFinalAuto := .F.
				
				IncProc( dtoc( Date() )+" "+Time()+" "+"Atualizando Base de Dados: "+aRecnoSM0[nI,3,nX] )
				cTexto += "Atualizando Base de Dados: "+aRecnoSM0[nI,3,nX]+CHR(13)+CHR(10)
				AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Atualizando Base de Dados: "+aRecnoSM0[nI,3,nX] )
				
				AtuBase(aRecnoSM0[nI,2], aRecnoSM0[nI,3,nX])
				
				ProcRegua()
	
				RpcClearEnv()
			Next nX                                                                     
			
			If !( lOpen := MyOpenSm0Ex() )
				Exit 
			EndIf 
		Next nI		
			   
		If lOpen

			IncProc( dtoc( Date() )+" "+Time()+" "+"Atualiza��o Conclu�da." )
		
			cTexto := "Log da Atualiza��o "+CHR(13)+CHR(10)+cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
			DEFINE MSDIALOG oDlg TITLE "Atualizacao Conclu�da." From 3,0 to 340,417 PIXEL
			@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			oMemo:oFont:=oFont
			DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
			DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
			
		EndIf
		
	EndIf
		
EndIf 	

Return(.T.)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GEAtuSX1  � Autora�Flavia Monzano        � Data � 24/10/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Processamento da Gravacao do SX1 - Perguntas     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao GE                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function GEAtuSX1()
dbSelectArea("SX1")
SX1->(DbSetOrder(1))

//��������������������������������������������������������������������������Ŀ
//�Alterar o Pergunte 07 - Somente Deficientes   							 �
//����������������������������������������������������������������������������
if SX1->( dbSeek( "ACAR0807" ) )
	RecLock("SX1",.F.)
	SX1->X1_PERGUNT	:= "Somente Cand. com Nec.Especiais?"
	SX1->(MsUnlock())
endif	
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GEAtuSX3  � Autora�Flavia Monzano        � Data � 24/10/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Processamento da Gravacao do SX3 - Campos        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao GE                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function GEAtuSX3()
Local aSX3           := {}		//Array com os campos das tabelas
Local aEstrut        := {}     	//Array com a estrutura da tabela SX3
Local i              := 0		//Laco para contador
Local j              := 0		//Laco para contador
Local lSX3	         := .F.    	//Indica se houve atualizacao
Local cAlias         := ''		//String para utilizacao do noem da tabela

//��������������������������������������������������������������������������Ŀ
//�Define a Estrutura do Array												 �
//����������������������������������������������������������������������������
aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
			"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
			"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
			"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER", "X3_PYME"}

dbSelectArea("SX3")
SX3->(DbSetOrder(2))

//��������������������������������������������������������������������������Ŀ
//�Procura o Campo de Exemplo para criar o JA1_TIPREL (Religiao)    		 �
//����������������������������������������������������������������������������
If SX3->( dbSeek("JA1_TPCAND") )
	cUsado 	:= SX3->X3_USADO
	cReserv :=	SX3->X3_RESERV
EndIf  

//��������������������������������������������������������������������������Ŀ
//�Caso nao encontrar o Campo no SX3 cria-lo						   		 �
//����������������������������������������������������������������������������
If !SX3->( dbSeek("JA1_TIPREL") )
	//��������������������������������������������������������������������������Ŀ
	//�Procura a proxima Ordem para o Novo Campo (Tabela JA1 - Candidatos)   	 �
	//����������������������������������������������������������������������������
	i := 0
	SX3->( dbSetOrder(1) )
	SX3->( dbSeek("JA1") )
	while SX3->( !eof() .and. X3_ARQUIVO == "JA1" )
		i++
		SX3->( dbSkip() )
	end
	i++  
	
	//��������������������������������������������������������������������������Ŀ
	//�Cria o Novo Campo JA1_TIPREL (Religiao)       		 					 �
	//����������������������������������������������������������������������������
	aAdd(aSX3,{	"JA1",;								//Arquivo
				StrZero(i,2),;						//Ordem
				"JA1_TIPREL",;						//Campo
				"C",;								//Tipo
				1,;									//Tamanho
				0,;									//Decimal
				"Religi�o",; 					    //Titulo
				"Religi�o",;					   	//Titulo SPA
				"Religi�o",;	    				//Titulo ENG
				"Religi�o",;						//Descricao
				"Religi�o",;						//Descricao SPA
				"Religi�o",;						//Descricao ENG
				"@!",;								//Picture
				'Pertence("12")',;					//VALID
				cUsado,;							//USADO
				'"2"',;								//RELACAO
				"",;								//F3
				1,;									//NIVEL
				cReserv,;							//RESERV
				"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
				"","","",;							//CONTEXT, OBRIGAT, VLDUSER
				"1=Adventista;2=Outros","1=Adventista;2=Outros","1=Adventista;2=Outros",;		//CBOX, CBOX SPA, CBOX ENG
				"","","","","1","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	
Endif

//��������������������������������������������������������������������������Ŀ
//�Procura a proxima Ordem para o Novo Campo (Tabela JA9 - Proc.Seletivo / 	 �
//�Fase / Local )															 �
//����������������������������������������������������������������������������
i := 0
SX3->( dbSetOrder(1) )
SX3->( dbSeek("JA9") )
while SX3->( !eof() .and. X3_ARQUIVO == "JA9" )
	i++
	SX3->( dbSkip() )
end
i++ 

//��������������������������������������������������������������������������Ŀ
//�Caso nao encontrar o Campo no SX3 cria-lo						   		 �
//����������������������������������������������������������������������������
SX3->( dbSetOrder(2) )
If !SX3->( dbSeek("JA9_TIPDEF") )
	//��������������������������������������������������������������������������Ŀ
	//�Cria o Novo Campo JA9_TIPDEF (Tipo Deficiencia)       		 			 �
	//����������������������������������������������������������������������������
	aAdd(aSX3,{	"JA9",;								//Arquivo
				StrZero(i,2),;						//Ordem
				"JA9_TIPDEF",;						//Campo
				"C",;								//Tipo
				1,;									//Tamanho
				0,;									//Decimal
				"Nec.Especial",; 				    //Titulo
				"Nec.Especial",;				   	//Titulo SPA
				"Nec.Especial",;    				//Titulo ENG
				"Necessidade Especial",;			//Descricao
				"Necessidade Especial",;			//Descricao SPA
				"Necessidade Especial",;			//Descricao ENG
				"@!",;								//Picture
				'Pertence("1234")',;					//VALID
				cUsado,;							//USADO
				'"4"',;								//RELACAO
				"",;								//F3
				1,;									//NIVEL
				cReserv,;							//RESERV
				"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
				"","","",;							//CONTEXT, OBRIGAT, VLDUSER
				"1=Visual;2=Auditiva;3=F�sica;4=Nenhum","1=Visual;2=Auditiva;3=F�sica;4=Nenhum","1=Visual;2=Auditiva;3=F�sica;4=Nenhum",;	//CBOX, CBOX SPA, CBOX ENG
				"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	
Endif
i++ 

//��������������������������������������������������������������������������Ŀ
//�Caso nao encontrar o Campo no SX3 cria-lo						   		 �
//����������������������������������������������������������������������������
If !SX3->( dbSeek("JA9_TIPDEF") )
	//��������������������������������������������������������������������������Ŀ
	//�Cria o Novo Campo JA9_TIPREL (Religiao)       		 					 �
	//����������������������������������������������������������������������������
	aAdd(aSX3,{	"JA9",;								//Arquivo
				StrZero(i,2),;						//Ordem
				"JA9_TIPREL",;						//Campo
				"C",;								//Tipo
				1,;									//Tamanho
				0,;									//Decimal
				"Religi�o",; 					    //Titulo
				"Religi�o",;					   	//Titulo SPA
				"Religi�o",;	    				//Titulo ENG
				"Religi�o",;						//Descricao
				"Religi�o",;						//Descricao SPA
				"Religi�o",;						//Descricao ENG
				"@!",;								//Picture
				'Pertence("12")',;					//VALID
				cUsado,;							//USADO
				'"2"',;								//RELACAO
				"",;								//F3
				1,;									//NIVEL
				cReserv,;							//RESERV
				"","","","N","",;					//CHECK, TRIGGER, PROPRI, BROWSE, VISUAL
				"","","",;							//CONTEXT, OBRIGAT, VLDUSER
				"1=Adventista;2=Outros","1=Adventista;2=Outros","1=Adventista;2=Outros",;		//CBOX, CBOX SPA, CBOX ENG
				"","","","","","S"})				//PICTVAR, WHEN, INIBRW, SXG, FOLDER, PYME	
Endif
				
//��������������������������������������������������������������������������Ŀ
//�Grava Informacoes do Array no Dicionario de Dados						 �
//����������������������������������������������������������������������������
ProcRegua(Len(aSX3))
SX3->(DbSetOrder(2))	

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])

		If !dbSeek(aSX3[i,3])
			RecLock("SX3",.T.)		
		Else
			RecLock("SX3",.F.)		
		EndIf
		lSX3	:= .T.
		If !(aSX3[i,1]$cAlias)
			cAlias += aSX3[i,1]+"/"
			if aScan(aArqUpd, aSX3[i,1] ) == 0
				aAdd(aArqUpd,aSX3[i,1])
			endif
		EndIf

		For j:=1 To Len(aSX3[i])
			If FieldPos(aEstrut[j])>0 .And. aSX3[i,j] != NIL
				FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
			EndIf
		Next j
		MsUnLock()
	EndIf
Next i

//��������������������������������������������������������������������������Ŀ
//�Alterar o campo Tipo de Candidato (Tabela JA1-Candidatos)    			 �
//����������������������������������������������������������������������������
SX3->(DbSetOrder(2))
if SX3->( dbSeek( "JA1_TPCAND" ) )
	RecLock("SX3",.F.)
	SX3->X3_VALID	:= 'Pertence("12")'
	SX3->X3_CBOX	:= "1=Destro;2=Canhoto"	
	SX3->X3_CBOXSPA	:= "1=Diestro;2=Zurdo"	
	SX3->X3_CBOXENG	:= "1=Right Hd.;2=Left Hd."	
	SX3->X3_TITULO	:= "Particular."
	SX3->X3_TITENG	:= "Particular."
	SX3->X3_TITSPA	:= "Particular."
	SX3->X3_DESCRIC	:= "Particularidade"
	SX3->X3_DESCSPA	:= "Particularidade"
	SX3->X3_DESCENG	:= "Particularidade"	
	SX3->(MsUnlock())
endif	
//��������������������������������������������������������������������������Ŀ
//�Alterar o campo Tipo de Candidato (Tabela JA9 - Proc.Seletivo/Fase/Local) �
//����������������������������������������������������������������������������
if SX3->( dbSeek( "JA9_TPCAND" ) )
	RecLock("SX3",.F.)
	SX3->X3_VALID	:= 'Pertence("12")'
	SX3->X3_CBOX	:= "1=Destro;2=Canhoto;3=Geral"	
	SX3->X3_CBOXSPA	:= "1=Diestro;2=Zurdo;3=General"	
	SX3->X3_CBOXENG	:= "1=Right Hd.;2=Left Hd.;3=General"	
	SX3->X3_TITULO	:= "Particular."
	SX3->X3_TITENG	:= "Particular."
	SX3->X3_TITSPA	:= "Particular."
	SX3->X3_DESCRIC	:= "Particularidade"
	SX3->X3_DESCSPA	:= "Particularidade"
	SX3->X3_DESCENG	:= "Particularidade"	
	SX3->(MsUnlock())
endif
//��������������������������������������������������������������������������Ŀ
//�Alterar o campo Tipo de Deficiencia (Necessidades Especiais)				 �
//�(Tabela JA1-Candidatos)													 �
//����������������������������������������������������������������������������
SX3->(DbSetOrder(2))
if SX3->( dbSeek( "JA1_TIPDEF" ) )
	RecLock("SX3",.F.)
	SX3->X3_WHEN	:= ""
	SX3->X3_CONDSQL	:= ""	
	SX3->X3_CHKSQL	:= ""		
	SX3->X3_TITULO	:= "Nec.Especial"
	SX3->X3_TITENG	:= "Nec.Especial"
	SX3->X3_TITSPA	:= "Nec.Especial"
	SX3->X3_DESCRIC	:= "Necessidade Especial"
	SX3->X3_DESCSPA	:= "Necessidade Especial"
	SX3->X3_DESCENG	:= "Necessidade Especial"	
	SX3->(MsUnlock())
endif

Return


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GEAtuSIX  � Autora�Flavia Monzano        � Data � 24/10/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Processamento da Gravacao do SIX - Indices       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao GE                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function GEAtuSIX()
Local lSix      := .F. 		//Verifica se houve atualizacao
Local aSix      := {}		//Array que armazenara os indices
Local aEstrut   := {}		//Array com a estrutura da tabela SIX
Local i         := 0 		//Contador para For-Next
Local j         := 0 		//Contador para For-Next
Local cAlias    := ''		//Alias para tabelas
Local lDelInd   := .F.
//��������������������������������������������������������������������������Ŀ
//�Define a Estrutura do Array												 �
//����������������������������������������������������������������������������
aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3",;
		   "NICKNAME","SHOWPESQ"}

aAdd(aSIX,{"JA9",;   										//Indice
		"4",;                 								//Ordem
		"JA9_FILIAL+JA9_CODIGO+JA9_FASE+DTOS(JA9_DTNOR)+JA9_CODLOC+JA9_TPCAND+JA9_TIPDEF+JA9_TIPREL",;	//Chave
		"Codigo P.S. + Codigo Fase + Data Prova + Codigo Local + Tipo Candid. + Tipo Deficie. + Religiao",;	//Descicao Port.
		"Codigo P.S. + Codigo Fase + Data Prova + Codigo Local + Tipo Candid. + Tipo Deficie. + Religiao",;	//Descicao Port.
		"Codigo P.S. + Codigo Fase + Data Prova + Codigo Local + Tipo Candid. + Tipo Deficie. + Religiao",;	//Descicao Port.
		"S",; 												//Proprietario
		"",;  												//F3
		"",;  												//NickName
		"S"}) 												//ShowPesq  

//��������������������������������������������������������������������������Ŀ
//�Grava as Informacoes do Array na Tabela SIX   							 �
//����������������������������������������������������������������������������
ProcRegua(Len(aSIX))

dbSelectArea("SIX")
SIX->(DbSetOrder(1))	

For i:= 1 To Len(aSIX)
   
	If !Empty(aSIX[i,1])
		If !DbSeek(aSIX[i,1]+aSIX[i,2])
			RecLock("SIX",.T.)
			lDelInd := .F.
		Else
			RecLock("SIX",.F.)
			lDelInd := .T. 		//Caso Alteracao Apagar o Indice do Banco de Dados
		EndIf
		
		If UPPER(AllTrim(CHAVE)) != UPPER(Alltrim(aSIX[i,3]))
			if aScan(aArqUpd, aSIX[i,1]) == 0
				aAdd(aArqUpd,aSIX[i,1])
			endif
			
			lSix := .T.
			If !(aSIX[i,1]$cAlias)
				cAlias += aSIX[i,1]+"/"
			EndIf
			For j:=1 To Len(aSIX[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
				EndIf
			Next j
			MsUnLock()
			If lDelInd
				TcInternal(60,RetSqlName(aSix[i,1]) + "|" + RetSqlName(aSix[i,1]) + aSix[i,2]) //Exclui sem precisar baixar o TOP
			Endif	
		EndIf
	EndIf
Next i

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MyOpenSM0Ex� Autor �Sergio Silveira       � Data �07/01/2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetua a abertura do SM0 exclusivo                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao FIS                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function MyOpenSM0Ex()

Local lOpen := .F. 
Local nLoop := 0 

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .T., .F. )
	If !Empty( Select( "SM0" ) ) 
		lOpen := .T. 
		dbSetIndex("SIGAMAT.IND") 
		Exit	
	EndIf
	Sleep( 500 ) 
Next nLoop

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 ) 
EndIf

Return( lOpen )                                                             

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AtuBase   � Autora�Flavia Monzano        � Data � 24/10/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Prepara as Empresas para Processo de Atualizacao	          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao GE                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function AtuBase(cEmp, cFil)
Local cQuery := ""

IncProc( dtoc(dDataBase) + " " + Time()+ " Inicio Atualizacao da Base de Dados")
AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Inicio Atualizacao da Base de Dados"+cEmp + " " +cFil )

//��������������������������������������������������������������������������Ŀ
//�Grava TODOS Candidatos com Religiao JA1_TIPREL igual 2=Outros			 �
//����������������������������������������������������������������������������
dbSelectArea("JA1")
JA1->( dbSetOrder(1) )
While JA1->( !Eof() )
	RecLock("JA1",.F.)
	JA1->JA1_TIPREL := '2'
	JA1->( MsUnlock() )
	JA1->(dbSkip())	
End

//��������������������������������������������������������������������������Ŀ
//�Seleciona os Candidatos que estiverem com JA1_TPCAND igual 4=Adventista,	 �
//�gravar na Religiao JA1_TIPREL igual 1=Adventista e JA1_TPCAND igual       �
//�1=Destro.														         �
//����������������������������������������������������������������������������
dbSelectArea("JA1")
JA1->( dbSetOrder(1) )

cQuery := "select JA1.JA1_CODINS "
cQuery += "from  "+RetSQLName("JA1")+" JA1 "
cQuery += " where JA1.JA1_FILIAL  = '" + xFilial("JA1") +"'"
cQuery += " and JA1_TPCAND = '4' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

TRB->(dbGoTop())
While TRB->(!Eof())
	If JA1->( dbSeek(xFilial("JA1")+TRB->JA1_CODINS) )
		RecLock("JA1",.F.)
		JA1->JA1_TIPREL := '1'
		JA1->JA1_TPCAND := '1'		
		JA1->( MsUnlock() )	 	
	Endif

	TRB->(dbSkip())
End
TRB->(dbCloseArea())  

//��������������������������������������������������������������������������Ŀ
//�Seleciona os Candidatos que estiverem com JA1_TPCAND igual 5=Outros, 	 �
//�gravar na Religiao JA1_TIPREL igual 2=Outros e JA1_TPCAND igual           �
//�1=Destro.														         �
//����������������������������������������������������������������������������
dbSelectArea("JA1")
JA1->( dbSetOrder(1) )

cQuery := "select JA1.JA1_CODINS "
cQuery += "from  "+RetSQLName("JA1")+" JA1 "
cQuery += " where JA1.JA1_FILIAL  = '" + xFilial("JA1") +"'"
cQuery += " and JA1_TPCAND = '5' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

TRB->(dbGoTop())
While TRB->(!Eof())
	If JA1->( dbSeek(xFilial("JA1")+TRB->JA1_CODINS) )
		RecLock("JA1",.F.)
		JA1->JA1_TIPREL := '2'
		JA1->JA1_TPCAND := '1'		
		JA1->( MsUnlock() )	 	
	Endif

	TRB->(dbSkip())
End
TRB->(dbCloseArea())  

//��������������������������������������������������������������������������Ŀ
//�Seleciona os Candidatos que estiverem com JA1_TPCAND igual 3=Deficiente,	 �
//�gravar JA1_TPCAND igual 1=Destro, pois seu campo natural sera JA1_TIPDEF  �
//����������������������������������������������������������������������������
dbSelectArea("JA1")
JA1->( dbSetOrder(1) )

cQuery := "select JA1.JA1_CODINS "
cQuery += "from  "+RetSQLName("JA1")+" JA1 "
cQuery += " where JA1.JA1_FILIAL  = '" + xFilial("JA1") +"'"
cQuery += " and JA1_TPCAND = '3' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

TRB->(dbGoTop())
While TRB->(!Eof())
	If JA1->( dbSeek(xFilial("JA1")+TRB->JA1_CODINS) )
		RecLock("JA1",.F.)
		JA1->JA1_TPCAND := '1'		
		JA1->( MsUnlock() )	 	
	Endif

	TRB->(dbSkip())
End
TRB->(dbCloseArea())  

//��������������������������������������������������������������������������Ŀ
//�Grava TODOS Locais com Deficiencia JA9_TIPDEF igual 4=Nenhum e Religiao   �
//�JA9_TIPREL igual 2=Outros												 �
//����������������������������������������������������������������������������
dbSelectArea("JA9")
JA9->( dbSetOrder(1) )
While JA9->( !Eof() )
	RecLock("JA9",.F.)
	JA9->JA9_TIPREL := '2'
	JA9->JA9_TIPDEF := '4'
	JA9->( MsUnlock() )
	JA9->(dbSkip())	
End

//��������������������������������������������������������������������������Ŀ
//�Seleciona os Locais que estiverem com JA9_TPCAND igual 6=Candidato Geral, �
//�gravar JA9_TPCAND igual 3=Candidato Geral.								 �
//����������������������������������������������������������������������������
dbSelectArea("JA9")
JA9->( dbSetOrder(1) )

cQuery := "select JA9.JA9_FILIAL, JA9.JA9_CODIGO, JA9.JA9_FASE, JA9.JA9_DTNOR, JA9.JA9_CODLOC, JA9.JA9_CODPRE, JA9.JA9_ANDAR, JA9.JA9_CODSAL "
cQuery += "from  "+RetSQLName("JA9")+" JA9 "
cQuery += " where JA9.JA9_FILIAL  = '" + xFilial("JA9") +"'"
cQuery += " and JA9_TPCAND = '6' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

TRB->(dbGoTop())
While TRB->(!Eof())
	If JA9->( dbSeek(xFilial("JA9")+TRB->JA9_CODIGO+TRB->JA9_FASE+TRB->JA9_DTNOR+TRB->JA9_CODLOC+TRB->JA9_CODPRE+TRB->JA9_ANDAR+TRB->JA9_CODSAL) )
		RecLock("JA9",.F.)
		JA9->JA9_TPCAND := '3'		
		JA9->( MsUnlock() )	 	
	Endif

	TRB->(dbSkip())
End
TRB->(dbCloseArea())  

//��������������������������������������������������������������������������Ŀ
//�Seleciona os Locais que estiverem com JA9_TPCAND igual 4=Adventista,		 �
//�gravar JA9_TPCAND igual 3=Candidato Geral, Religiao JA9_TIPREL igual 	 �
//�1=Adventista e JA9_TIPDEF igual 4=Nenhum.														 	 �
//����������������������������������������������������������������������������
dbSelectArea("JA9")
JA9->( dbSetOrder(1) )

cQuery := "select JA9.JA9_FILIAL, JA9.JA9_CODIGO, JA9.JA9_FASE, JA9.JA9_DTNOR, JA9.JA9_CODLOC, JA9.JA9_CODPRE, JA9.JA9_ANDAR, JA9.JA9_CODSAL "
cQuery += "from  "+RetSQLName("JA9")+" JA9 "
cQuery += " where JA9.JA9_FILIAL  = '" + xFilial("JA9") +"'"
cQuery += " and JA9_TPCAND = '4' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

TRB->(dbGoTop())
While TRB->(!Eof())
	If JA9->( dbSeek(xFilial("JA9")+TRB->JA9_CODIGO+TRB->JA9_FASE+TRB->JA9_DTNOR+TRB->JA9_CODLOC+TRB->JA9_CODPRE+TRB->JA9_ANDAR+TRB->JA9_CODSAL) )
		RecLock("JA9",.F.)
		JA9->JA9_TIPREL := '1'
		JA9->JA9_TPCAND := '3'		
		JA9->JA9_TIPDEF := '4'				
		JA9->( MsUnlock() )	 	
	Endif
	TRB->(dbSkip())
End
TRB->(dbCloseArea())  

//��������������������������������������������������������������������������Ŀ
//�Seleciona os Locais que estiverem com JA9_TPCAND igual 3=Deficiente,		 �
//�gravar JA9_TPCAND igual 3=Candidato Geral, JA9_TIPDEF igual 3=Fisica e  	 �
//�Religiao JA9_TIPREL igual 2=Outros.								 	     �
//����������������������������������������������������������������������������
dbSelectArea("JA9")
JA9->( dbSetOrder(1) )

cQuery := "select JA9.JA9_FILIAL, JA9.JA9_CODIGO, JA9.JA9_FASE, JA9.JA9_DTNOR, JA9.JA9_CODLOC, JA9.JA9_CODPRE, JA9.JA9_ANDAR, JA9.JA9_CODSAL "
cQuery += "from  "+RetSQLName("JA9")+" JA9 "
cQuery += " where JA9.JA9_FILIAL  = '" + xFilial("JA9") +"'"
cQuery += " and JA9_TPCAND = '3' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

TRB->(dbGoTop())
While TRB->(!Eof())
	If JA9->( dbSeek(xFilial("JA9")+TRB->JA9_CODIGO+TRB->JA9_FASE+TRB->JA9_DTNOR+TRB->JA9_CODLOC+TRB->JA9_CODPRE+TRB->JA9_ANDAR+TRB->JA9_CODSAL) )
		RecLock("JA9",.F.)
		JA9->JA9_TIPREL := '2'
		JA9->JA9_TIPDEF := '3'				
		JA9->( MsUnlock() )	 	
	Endif
	TRB->(dbSkip())
End
TRB->(dbCloseArea())  

//��������������������������������������������������������������������������Ŀ
//�Seleciona os Locais que estiverem com JA9_TPCAND igual 5=Outros,			 �
//�gravar JA9_TPCAND igual 3=Candidato Geral, JA9_TIPDEF igual 4=Nenhum e  	 �
//�Religiao JA9_TIPREL igual 2=Outros.								 	     �
//����������������������������������������������������������������������������
dbSelectArea("JA9")
JA9->( dbSetOrder(1) )

cQuery := "select JA9.JA9_FILIAL, JA9.JA9_CODIGO, JA9.JA9_FASE, JA9.JA9_DTNOR, JA9.JA9_CODLOC, JA9.JA9_CODPRE, JA9.JA9_ANDAR, JA9.JA9_CODSAL "
cQuery += "from  "+RetSQLName("JA9")+" JA9 "
cQuery += " where JA9.JA9_FILIAL  = '" + xFilial("JA9") +"'"
cQuery += " and JA9_TPCAND = '5' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

TRB->(dbGoTop())
While TRB->(!Eof())
	If JA9->( dbSeek(xFilial("JA9")+TRB->JA9_CODIGO+TRB->JA9_FASE+TRB->JA9_DTNOR+TRB->JA9_CODLOC+TRB->JA9_CODPRE+TRB->JA9_ANDAR+TRB->JA9_CODSAL) )
		RecLock("JA9",.F.)
		JA9->JA9_TIPREL := '2'
		JA9->JA9_TIPDEF := '4'				
		JA9->JA9_TPCAND := '3'
		JA9->( MsUnlock() )	 	
	Endif

	TRB->(dbSkip())
End
TRB->(dbCloseArea())  

IncProc( dtoc(dDataBase) + " " + Time()+ " Fim Atualizacao da Base de Dados")
AcaLog( cArquivo, dtoc( Date() )+" "+Time()+" "+"Fim Atualizacao da Base de Dados"+cEmp + " " +cFil )

Return
