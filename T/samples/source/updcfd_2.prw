#Include "Protheus.ch"
#define X3_USADO_EMUSO "���������������"
#define X3_USADO_NAOUSADO "���������������"
#define X3_USADO_NAOALTERA "��������������� "		//Nao permite alteracao do campo
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �UPDCFD_2  � Autor �Marcello               � Data �10/01/2006���
�������������������������������������������������������������������������Ĵ��
���Descricao �Programa de atualizacao das tabelas para o uso de comprova- ���
���          �tes fiscais digitais - Mexico                               ���
���          �                                                            ���
���          �COMPLEMENTO DO PROGRAMA UPDCFD                              ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CFD                                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function UpdCFD_2

cArqEmp := "SigaMat.Emp"
nModulo		:= 44
__cInterNet := Nil
PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd
//
PRIVATE cDirCFD := "\cfd"
PRIVATE cDirAnul:= "\anuladas\"

Set Dele On

lHistorico 	:= MsgYesNo("Desea actualizar las tablas para el uso de Comprobantes Fiscales Digitales ? Esta rutina debe ser utilizada en modo exclusivo ! Haga una copia de los diccionarios y de la base de Datos antes de actualizar los archivos para eventuales fallas de actualizacion !", "Atencion !")
lEmpenho	:= .F.
lAtuMnu		:= .F.
DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE "Comprobantes Fiscales Digitais" BORDER SINGLE
ACTIVATE WINDOW oMainWnd ;
ON INIT If(lHistorico,(Processa({|lEnd| FISProc(@lEnd)},"Procesando","Aguarde , Preparando archivos",.F.), oMainWnd:End() ), oMainWnd:End() )
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FISProc   � Autor �Marcello               � Data �10/01/2006���
�������������������������������������������������������������������������Ĵ��
���Descricao �Funcao de processamento da gravacao dos arquivos            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FisProc(lEnd)

Local cTexto    := ""
Local cFile     := ""
Local cAmbiente := ""
Local nRecno    := 0
Local nI        := 0
Local nX		:= 0
Local nNCFD		:= 0
Local aRecnoSM0 := {}     
Local lOpen     := .F. 

ProcRegua(1)
IncProc("Verificando la integridad de los diccionarios....")
If MyOpenSm0Ex()
	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
		Aadd(aRecnoSM0,SM0->(RECNO()))
		dbSkip()
	EndDo
	For nI := 1 To Len(aRecnoSM0)
		SM0->(dbGoto(aRecnoSM0[nI]))
		RpcSetType(2)
		RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
		RpcClearEnv()
		If !( lOpen := MyOpenSm0Ex() )
			Exit
		EndIf
	Next nI
	
	nNCFD := 0
	cAmbiente := ""
	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			
			If !UPD2Verif()
				nNCFD++
				cAmbiente += SM0->M0_CODIGO + "/" + SM0->M0_CODFIL + CRLF
			Else
				cTexto := Replicate("-",128)+CHR(13)+CHR(10)
				cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)
				//���������������������������������Ŀ
				//�Atualiza o dicionario de dados   �
				//�����������������������������������
				IncProc("Verificando Diccionario de Datos...")
				cTexto += FISAtuSX3()
				
				//���������������������������������Ŀ
				//�Atualiza o arquivo de parametros �
				//�����������������������������������
				IncProc("Verificando Archivo de parametros...")
				cTexto += FISAtuSX6()
				
				//���������������������������������Ŀ
				//�Criando os diretorios            �
				//�����������������������������������
				IncProc("Verificando Archivo de parametros...")
				cTexto += FISAtuDir()
				
				ProcRegua(Len(aArqUpd))
				__SetX31Mode(.F.)
				For nX := 1 To Len(aArqUpd)
					IncProc("Actualizando estructuras. Aguarde... ["+aArqUpd[nx]+"]"+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME)
					If Select(aArqUpd[nx])>0
						dbSelecTArea(aArqUpd[nx])
						dbCloseArea()
					EndIf
					X31UpdTable(aArqUpd[nx])
					If __GetX31Error()
						Alert(__GetX31Trace())
						Aviso("Atencion!","Ocorrio un error en la actualizacion de la tabla : "+ aArqUpd[nx] + ". Verifique la integridad del diccionario y de la tabla.",{"Proseguir"},2)
						cTexto += "Ocorrio un error en la actualizacion de la tabla : "+aArqUpd[nx] +CHR(13)+CHR(10)
					EndIf
				Next nX
				cTexto := "Log de actualizacion de los CFD's"+CHR(13)+CHR(10)+cTexto
				__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
				DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
				DEFINE MSDIALOG oDlg TITLE "Proceso concluido" From 3,0 to 340,417 PIXEL
					@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
					oMemo:bRClicked := {||AllwaysTrue()}
					oMemo:lReadOnly := .T.
					oMemo:oFont:=oFont
					DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				ACTIVATE MSDIALOG oDlg CENTERED
				
				RpcClearEnv()
				If !( lOpen := MyOpenSm0Ex() )
					Exit
				EndIf
			Endif
		Next nI
		If nNCFD > 0
			cTexto := "Hay bases de datos que no estan preparadas para el uso de CFD. "
			ctexto += 'Se debe, primeramente, ejecutar el programa UPDCFD (vea el bolet�n t�cnico "Comprobantes Fiscales Digitales - Facturas Eletr�nicas").' + CRLF + CRLF
			cTexto += "Las bases abajo no fueron actualizadas." + CRLF + CRLF
			ctexto += "Empresa" + CRLF + cAmbiente
			__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Proceso concluido" From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:lReadOnly := .T.
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
			ACTIVATE MSDIALOG oDlg CENTERED
		Endif
	Endif
Endif
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FISAtuSX3 � Autor � Marcello              � Data �10/01/2006���
�������������������������������������������������������������������������Ĵ��
���Descricao �Funcao de processamento da gravacao do SX3                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FISAtuSX3()
Local aSX3   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local aCpos  := {}

aEstrut := { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
	"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
	"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
	"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER"}

//���������������������������������Ŀ
//� SF3                             �
//�����������������������������������
//Numero de aprobacion
Aadd(aSX3,{"SF3",;				//Arquivo
	"ZZ",;						//Ordem
	"F3_HORA",;					//Campo
	"C",;						//Tipo
	5,;							//Tamanho
	0,;							//Decimal
	"Hora",;					//Titulo
	"Hora",;					//Titulo SPA
	"Time",;					//Titulo ENG
	"Hora",;					//Descricao
	"Hora",;					//Descricao SPA
	"Time",;					//Descricao ENG
	"@!",;						//Picture
	"",;						//VALID
	X3_USADO_NAOUSADO,;			//USADO
	"",;						//RELACAO
	"",;						//F3
	1,;							//NIVEL
	"",;						//RESERV
	"",;						//CHECK
	"",;						//TRIGGER
	"",;						//PROPRI
	"N",;						//BROWSE
	"",;						//VISUAL
	"",;						//CONTEXT
	"",;						//OBRIGAT
	"",;						//VLDUSER
	"",;						//CBOX
	"",;						//CBOX SPA
	"",;						//CBOX ENG
	"",;						//PICTVAR
	"",;						//WHEN
	"",;						//INIBRW
	"",;						//SXG
	""})						//FOLDER
//Serie del certificado
Aadd(aSX3,{"SF3",;				//Arquivo
	"ZZ",;						//Ordem
	"F3_FIMP",;					//Campo
	"C",;						//Tipo
	1,;							//Tamanho
	0,;							//Decimal
	"Flag Impres.",;			//Titulo
	"Indica.Impr.",;			//Titulo SPA
	"Print Flag",;				//Titulo ENG
	"Flag de Impressao",;		//Descricao
	"Flag de Impresion",;		//Descricao SPA
	"Printing Flag",;			//Descricao ENG
	"@!",;						//Picture
	"",;						//VALID
	X3_USADO_NAOUSADO,;			//USADO
	"",;						//RELACAO
	"",;						//F3
	1,;							//NIVEL
	"",;						//RESERV
	"",;						//CHECK
	"",;						//TRIGGER
	"",;						//PROPRI
	"N",;						//BROWSE
	"",;						//VISUAL
	"",;						//CONTEXT
	"",;						//OBRIGAT
	"",;						//VLDUSER
	"",;						//CBOX
	"",;						//CBOX SPA
	"",;						//CBOX ENG
	"",;						//PICTVAR
	"",;						//WHEN
	"",;						//INIBRW
	"",;						//SXG
	""})						//FOLDER
//����������������������������Ŀ
//�Atualizacion del diccionario�
//������������������������������
dbSelectArea("SX3")
ProcRegua(Len(aSX3)+Len(aCpos))
dbSetOrder(2)
For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If Ascan(aArqUpd,aSX3[i,1]) == 0
			cTexto += "Actualizacion de la tabla " + aSX3[i,1] + CRLF
			Aadd(aArqUpd,aSX3[i,1])
		Endif
		If !dbSeek(aSX3[i,3])
			RecLock("SX3",.T.)
			cTexto += "    Creacion del campo " + aSX3[i,3] + CRLF
			For j:=1 To Len(aSX3[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
		EndIf
	EndIf
	IncProc("Actualizando Diccionario de Datos...")
Next i
Return cTexto

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FISAtuSX6 � Autor � Marcello              � Data �11/01/2006���
�������������������������������������������������������������������������Ĵ��
���Descricao �Funcao de processamento da gravacao do SX6                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FISAtuSX6()
Local aEstrut := {}
Local aSX6   := {}
Local i      := 0
Local j      := 0
Local cTexto := ''

aEstrut :=	{	"X6_FIL",;
				"X6_VAR",;
				"X6_TIPO",;
				"X6_DESCRIC",;
				"X6_DSCSPA",;
				"X6_DSCENG",;
				"X6_DESC1",;
				"X6_DSCENG1",;
				"X6_DSCSPA1",;
				"X6_CONTEUD",;
				"X6_CONTSPA",;
				"X6_CONTENG",;
				"X6_PROPRI",;
				"X6_PYME"}

cTexto += "Actualizacion del archivo de parametros" + CRLF
//������������������������������������������������������Ŀ
//�MV_CFDANUL                                            �
//��������������������������������������������������������
Aadd(aSX6,{	"  ",;
			"MV_CFDANUL",;
			"C",;
			"Local para onde serao movidos os cfd's",;
			"Indica para donde los cfd's anulados",;
			"Indica para donde los cfd's anulados",;
			"cancelados",;
			"seran movidos",;
			"seran movidos",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirAnul+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirAnul+"'",;
			"GetSrvProfString('startpath','')+'"+cDirCFD+cDirAnul+"'",;
			"S",;
			"S"})
//������������������������������������������������������Ŀ
//�MV_CFDNAF2                                            �
//��������������������������������������������������������
Aadd(aSX6,{	"  ",;
			"MV_CFDNAF2",;
			"C",;
			"Padrao para nome dos arquivos gerados",;
			"Padron para el nombre de los archivos",;
			"Padron para el nombre de los archivos",;
			"para CFD's (SF2)",;
			"generados para CFD's (SF2)",;
			"generados para CFD's (SF2)",;
			"Lower(AllTrim(SF2->F2_ESPECIE)) + '_' + Lower(AllTrim(SF2->F2_SERIE)) + '_'  + Lower(AllTrim(SF2->F2_DOC)) + '.xml'",;
			"Lower(AllTrim(SF2->F2_ESPECIE)) + '_' + Lower(AllTrim(SF2->F2_SERIE)) + '_'  + Lower(AllTrim(SF2->F2_DOC)) + '.xml'",;
			"Lower(AllTrim(SF2->F2_ESPECIE)) + '_' + Lower(AllTrim(SF2->F2_SERIE)) + '_'  + Lower(AllTrim(SF2->F2_DOC)) + '.xml'",;
			"S",;
			"S"})
//������������������������������������������������������Ŀ
//�MV_CFDNAF1                                            �
//��������������������������������������������������������
Aadd(aSX6,{	"  ",;
			"MV_CFDNAF1",;
			"C",;
			"Padrao para nome dos arquivos gerados",;
			"Padron para el nombre de los archivos",;
			"Padron para el nombre de los archivos",;
			"para CFD's (SF1)",;
			"generados para CFD's (SF1)",;
			"generados para CFD's (SF1)",;
			"Lower(AllTrim(SF1->F1_ESPECIE)) + '_' + Lower(AllTrim(SF1->F1_SERIE)) + '_'  + Lower(AllTrim(SF1->F1_DOC)) + '.xml'",;
			"Lower(AllTrim(SF1->F1_ESPECIE)) + '_' + Lower(AllTrim(SF1->F1_SERIE)) + '_'  + Lower(AllTrim(SF1->F1_DOC)) + '.xml'",;
			"Lower(AllTrim(SF1->F1_ESPECIE)) + '_' + Lower(AllTrim(SF1->F1_SERIE)) + '_'  + Lower(AllTrim(SF1->F1_DOC)) + '.xml'",;
			"S",;
			"S"})
//������������������������������Ŀ
//�Atualizacion de los parametros�
//��������������������������������
dbSelectArea("SX6")
ProcRegua(Len(aSX6))
dbSetOrder(1)
For i:= 1 To Len(aSX6)
	If !dbSeek(aSX6[i,1]+aSX6[i,2])
		RecLock("SX6",.T.)
		cTexto += "    Creacion del parametro " + AllTrim(aSX6[i,2]) + CRLF
		For j:=1 To Len(aSX6[i])
			If FieldPos(aEstrut[j])>0
				FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
			EndIf
		Next j
		dbCommit()
		MsUnLock()
	EndIf
	IncProc("Actualizando parametros...")
Next i
Return cTexto

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FISAtuDir � Autor � Marcello              � Data �11/01/2006���
�������������������������������������������������������������������������Ĵ��
���Descricao �Funcao para criacao para armazenamento dos arquivos         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FISAtuDir()
Local cTexto := ""
Local nDir := 0
Local cStartP := ""

cStartP := GetSrvProfString("startpath","")
cTexto += "Directorios" + CRLF
cTexto += "    Principal: " + cDirCFD
If !ExistDir(cStartP + cDirCFD)
	nDir := MakeDir(cStartP+cDirCFD)
Else
	nDir := 0
Endif
If nDir == 0
	cTexto +=   + CRLF
	cTexto += "    documentos anulados: " + cDirCFD + cDirAnul
	If !ExistDir(cStartP+cDirCFD+cDirAnul)
		If MakeDir(cStartP+cDirCFD+cDirAnul) <> 0 
			cTexto += "    (ERROR)"
		Endif
	Endif
	cTexto +=   + CRLF
Else
	cTexto += "    (ERROR)"
	cTexto +=   + CRLF
Endif
Return(cTexto)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �MyOpenSM0Ex� Autor �Sergio Silveira       � Data �07/01/2003���
�������������������������������������������������������������������������Ĵ��
���Descricao � Efetua a abertura do SM0 exclusivo                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
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
	Aviso( "Atencion !", "No fue posible abrir la tabla de empresas de forma exclusiva !", { "Ok" }, 2 ) 
EndIf                                 

Return( lOpen ) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �CFDVERIF()� Autor � Marcello              � Data �12/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descricao �Verifica se a base ja esta preparada para o uso de CFD,     ���
���          �isto e, com as alteracoes feitas pelo programa UPDCFD.      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function UPD2Verif()
Local lRet      := .T.
Local nE        := 0
Local nLen      := 0
Local aGerarCFD := {}

lRet := .F.
If FindFunction("CFDVerific")
	aGerarCFD := CFDVerific()
Else
	aGerarCFD := {"0"}
Endif
If aGerarCFD[1] <> "0"
	lRet := .T.
	nE := 0
	nLen := Len(aGerarCFD[2])
	While lRet .And. (nE < nLen)
		nE++
		lRet := (aGerarCFD[2,nE,1] $ "10/11/99")
	Enddo
Endif
Return lRet