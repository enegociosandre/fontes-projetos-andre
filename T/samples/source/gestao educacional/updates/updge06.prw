#INCLUDE "Protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � UpdGE06  � Autor � Gustavo Henrique     � Data � 20/Abr/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualizacao do dicionario de dados para correcao do campo  ���
���          � memo de informacao da justificativa de dispensa, para os   ���
���          � itens do cadastro de analise de grade curricular.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SigaGE                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function UpdGE06()

cArqEmp := "SigaMAT.Emp"
__cInterNet := Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd

Set Dele On

lHistorico 	:= MsgYesNo(	"Deseja apagar a tabela JDM do dicion�rio? Esta rotina deve ser utilizada em modo exclusivo! "+;
							"Fa�a um backup dos dicion�rios e da base de dados para ser utilizado em eventuais falhas de "+;
							"atualiza��o!", "Aten��o")

If lHistorico
	Processa({|lEnd| GEProc(@lEnd)},"Processando","Aguarde, preparando os arquivos")
	Final("Atualiza��o efetuada!")
endif
	
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GEProc    � Autor �Gustavo Henrique      � Data � 20/Abr/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de processamento da correcao na tabela JCT          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao GE                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function GEProc(lEnd)
Local cTexto    := '' 				//Exibira o log ao final do processo
Local cFile     :="" //Nome do arquivo, caso o usuario deseje salvar o log das operacoes
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    := 0
Local nI        := 0                //Contador para laco
Local nX        := 0	            //Contador para laco
Local aRecnoSM0 := {}				     
Local lOpen     := .F. 				//Retorna se conseguiu acesso exclusivo a base de dados
Local nModulo 	:= 49 				//SIGAGE - GESTAO EDUCACIONAL

/********************************************************************************************
Inicia o processamento.
********************************************************************************************/
If ( lOpen := MyOpenSm0Ex() )

	dbSelectArea("SM0")
	dbGotop()
	While !Eof() 
  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0 //--So adiciona no aRecnoSM0 se a empresa for diferente
			aAdd(aRecnoSM0,{Recno(),M0_CODIGO})
		EndIf			
		dbSkip()
	EndDo	

	If lOpen
		ProcRegua(2*Len(aRecnoSM0))

		For nI := 1 To Len(aRecnoSM0)

			SM0->(dbGoto(aRecnoSM0[nI,1]))

			RpcSetType(2) 
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)

			lMsFinalAuto := .F.

			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			//���������������������������������������Ŀ
			//� Exclui a tabela JDM do banco de dados �
			//�����������������������������������������
			IncProc("Excluindo tabela JDM do banco de dados..."+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME) 
			if ChkFile("JDM",.T.)
				// Fecha a tabela antes de dropar indice e estrutura
				JDM->( dbCloseArea() )
							
				// Apaga estrutura e indices do banco de dados
				TcSqlExec( "DROP TABLE "+RetSqlName("JDM") )
			else
				cTexto += "Nao foi possivel excluir a tabela do banco de dados. Erro ao abrir a tabela em modo exclusivo." + CHR(13)+CHR(10)
			endif

			//�������������������������������Ŀ
			//�Atualiza o dicionario de dados.�
			//���������������������������������
			IncProc("Excluindo dicionario de dados da tabela JDM..."+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME)
			cTexto += GEAtuSX3()
			cTexto += GEAtuSIX()
			cTexto += GEAtuSX2()

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit 
			EndIf 
			
		Next nI 
		   
		If lOpen
			
			cTexto := "Log da atualizacao "+CHR(13)+CHR(10)+cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
			DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida." From 3,0 to 340,417 PIXEL
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
���Fun��o    �GEAtuSIX  � Autor � Gustavo Henrique     � Data � 20/Abr/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de processamento de atualizacao SIX - Campos        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao GE                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function GEAtuSIX()

Local aAreaSIX	:= SIX->( GetArea() )	// Guarda a area de indice SIX
Local cTexto	:= ""					// Mensagem para compor o Log de erro

SIX->(dbSetOrder(1))
                                                  
If SIX->( dbSeek("JDM") )

	Do While SIX->( ! EoF() .And. INDICE = "JDM" )
		RecLock( "SIX", .F. )
		SIX->( dbDelete() )
		SIX->( MsUnlock() )
		SIX->( dbSkip() )
	EndDo

	cTexto := 'Foi excluido os �ndices das seguinte tabela : JDM '+CHR(13)+CHR(10)

EndIf

RestArea( aAreaSIX )

Return cTexto

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GEAtuSX2  � Autor � Gustavo Henrique     � Data � 20/Abr/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de processamento da gravacao do SX3 - Campos        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao GE                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function GEAtuSX2()

Local aAreaSX2 	:= SX2->( GetArea() )	// Salva area do SX2
Local cTexto	:= ""					// Mensagem para compor o Log

SX2->(dbSetOrder(1))
                                                  
If SX2->( dbSeek("JDM") )
	RecLock( "SX2", .F. )
	SX2->( dbDelete() )
	SX2->( MsUnlock() )
	cTexto := 'Foi excluida as informacoes de cabecalho da seguinte tabela : JDM'+CHR(13)+CHR(10)
EndIf

RestArea( aAreaSX2 )

Return cTexto


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GEAtuSX3  � Autor � Gustavo Henrique     � Data � 20/Abr/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de processamento da gravacao do SX3 - Campos        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao GE                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function GEAtuSX3()

Local aAreaSX3		:= SX3->( GetArea() )   // Guarda a area SX3
Local nTotCpos		:= 0					// Total de campos da tabela JDM
Local cTexto		:= ""					// Mensagem para gerar log

SX3->(dbSetOrder(1))
                                                  
If SX3->( dbSeek("JDM") )

	nTotCpos := JDM->( FCount() )          
	
	Do While SX3->( ! EoF() .And. X3_ARQUIVO = "JDM" )
		RecLock( "SX3", .F. )
		SX3->( dbDelete() )
		SX3->( MsUnlock() )
		SX3->( dbSkip() )
	EndDo

	cTexto := 'Foi excluida a estrutura das seguinte tabela : JDM '+CHR(13)+CHR(10)

EndIf

RestArea( aAreaSX3 )

Return cTexto

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
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. ) 	
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