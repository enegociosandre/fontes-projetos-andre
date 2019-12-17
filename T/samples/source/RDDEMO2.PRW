/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RDDEMO2  � Autor � Luiz Carlos Vieira � Data �Wed  23/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Demo. Interpretador XBase para Windows. Versao 2 com mais  ���
���          � exemplos, de comandos e uso de metodos e propriedades.     ���
�������������������������������������������������������������������������͹��
���Uso	     � Espec�fico para clientes Microsiga		          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//���������������������������������������������������������������������Ŀ
//� Variaveis do programa                                               �
//�����������������������������������������������������������������������

oRDDEMO2 := NIL
oTimer   := NIL

cMsg     := Space(20)
cMsg     := cMsg + "Esta vers�o do RDDEMO demostra novos conceitos e o uso de novas "
cMsg     := cMsg + "possibilidades para os comandos do interpretador para Windows. "
cMsg     := cMsg + "Al�m disso, demostra formas de acesso a propriedades de objetos "
cMsg     := cMsg + "e m�todos, o que facilita a programa��o nesse ambiente. Escolha atrav�s "
cMsg     := cMsg + "das duas listas abaixo as demostra��es que deseja visualizar e pressione "
cMsg     := cMsg + "o bot�o EXECUTAR.                                                        "
cMsg     := OemToAnsi(cMsg)

nPosMsg  := 1

bTimer   := {|| cTopBar := Substr(cMsg,nPosMsg,65)            , ;
                nPosMsg := If(nPosMsg>Len(cMsg),1,nPosMsg + 1), ;
                ObjectMethod(oGt,"Refresh()")                     }

cTopBar  := Space(65)

nSource  := 0
aSource  := {"Uso de Senhas","Novos Dialogos","Refresh de Objetos","Campos MEMO"}
nTarget  := 0
aTarget  := {}

//���������������������������������������������������������������������Ŀ
//� Criacao do dialogo principal                                        �
//�����������������������������������������������������������������������

@ 105,074 To 304,716 Dialog oRDDEMO2 Title "RDDEMO2 - Demostra��o do Interpretador XBase for Windows"

//���������������������������������������������������������������������Ŀ
//� Define o timer que ira executar por detras do dialogo               �
//�����������������������������������������������������������������������

oTimer := IW_Timer(100,bTimer)
ObjectMethod(oTimer,"Activate()")

//���������������������������������������������������������������������Ŀ
//� Objetos do dialogo principal                                        �
//�����������������������������������������������������������������������

@ 020,003 Say OemToAnsi("Demonstra��es dispon�veis:")
@ 020,133 Say OemToAnsi("Executar Demonstra��es:")

//���������������������������������������������������������������������Ŀ
//� Nova clausula disponivel para todos os comandos -> OBJECT <NOME>    �
//�����������������������������������������������������������������������

@ 004,000 Get cTopBar     When .F.                 Object oGt
@ 030,004 ListBox nSource Items aSource Size 86,65 Object oSource
@ 029,133 ListBox nTarget Items aTarget Size 85,65 Object oTarget

@ 030,093 Button OemToAnsi("_Adicionar >>") Size 36,16 Action Execute(AddDemo)    Object oBtnAdd
@ 048,093 Button OemToAnsi("<< _Remover")   Size 36,16 Action Execute(RemoveDemo) Object oBtnRem

@ 030,250 Button OemToAnsi("_Executar")  Size 36,16 Action Execute(RunDemos)

@ 082,277 BmpButton Type 1 Action Close(oRDDEMO2)

Activate Dialog oRDDEMO2

//���������������������������������������������������������������������Ŀ
//� Funcao para acesso aos metodos de um objeto -> OBJECTMETHOD         �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� Libera o timer                                                      �
//�����������������������������������������������������������������������

#IFNDEF PROTHEUS
	ObjectMethod(oTimer,"DeActivate()")
	ObjectMethod(oTimer,"Release()")
#ENDIF

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � ADDDEMO  � Autor � Luiz Carlos Vieira � Data �Wed  23/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Adiciona o item da lista Source para a lista Target        ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function AddDemo
    If nSource != 0
        aAdd(aTarget,aSource[nSource])
        ObjectMethod(oTarget,"SetItems(aTarget)")
        nNewTam := Len(aSource) - 1
        aSource := aSize(aDel(aSource,nSource),nNewTam)
        ObjectMethod(oSource,"SetItems(aSource)")
    Endif
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �REMOVEDEMO� Autor � Luiz Carlos Vieira � Data �Wed  23/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Remove um item da lista Target e adiciona na lista Source  ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

function RemoveDemo
    If nTarget != 0
        aAdd(aSource,aTarget[nTarget])
        ObjectMethod(oSource,"SetItems(aSource)")
        nNewTam := Len(aTarget) - 1
        aTarget := aSize(aDel(aTarget,nTarget), nNewTam)
        ObjectMethod(oTarget,"SetItems(aTarget)")
    Endif
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNDEMOS � Autor � Luiz Carlos Vieira � Data �Wed  23/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Executa os demos da lista Target                           ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function RunDemos

If Len(aTarget) != 0
    For nDemo := 1 To Len(aTarget)

        cDemo := AllTrim(Upper(aTarget[nDemo]))

        Do Case
        Case cDemo == "USO DE SENHAS"
            Execute(FunSenhas)
        Case cDemo == "NOVOS DIALOGOS"
            Execute(FunNovos)
        Case cDemo == "REFRESH DE OBJETOS"
            Execute(FunRefresh)
        Case cDemo == "CAMPOS MEMO"
            Execute(FunMEMO)
        EndCase

    Next nDemo
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � FUNSENHAS� Autor � Luiz Carlos Vieira � Data �Wed  23/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Demostracao do uso de senhas                               ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function FunSenhas

cSenha    := Space(200)
cConteudo := Space(200)

@ 115,085 To 267,727 Dialog oSenhas Title "Demostra��o de Objetos GET com senhas"
@ 002,002 To 038,315
@ 009,008 Say OemToAnsi('Para se trabalhar com caixas de edi��o que n�o exibem o conte�do digitado, basta acrescentar a cl�usula')
@ 020,008 Say OemToAnsi('PASSWORD ao comando GET do programa. Por exemplo: @00,00 Get cSenha Picture "@!" Valid .T. PASSWORD')
@ 042,004 Say OemToAnsi("Senha   :")
@ 057,004 Say OemToAnsi("Conte�do:")
@ 042,042 Get cSenha    Picture "@S40" Valid .T.  PASSWORD   Object oSenha
@ 057,042 Get cConteudo Picture "@S40" When .F.              Object oConteudo

@ 059,277 BmpButton Type 1 Action Close(oSenhas)

oAtuCont := Iw_Timer(100,{|| cConteudo := cSenha , ObjectMethod(oConteudo,"Refresh()") })
ObjectMethod(oAtuCont,"Activate()")

Activate Dialog oSenhas
#IFNDEF  PROTHEUS
 ObjectMethod(oAtuCont,"DeActivate()")
 ObjectMethod(oAtuCont,"Release()")
#ENDIF

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �FUNNOVOS  � Autor � Luiz Carlos Vieira � Data �Wed  23/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Demonstracao de dialogos diversificados.                   ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function FunNovos

nTipo := 1
aTipo := {"Selecao de Arquivo","Selecao de Cores"}

@ 150,133 To 361,716 Dialog oDialogos Title "Demostra��o de Di�logos Diversificados"
@ 003,002 To 039,282

@ 011,008 Say OemToAnsi("Al�m dos di�logos para simples exibi��o de mensagens, existem os di�logos para sele��o de arquivos,")
@ 023,008 Say OemToAnsi("entradas de dados, etc, que facilitam a vida do programador RDMAKE.")
@ 049,003 Say OemToAnsi("Tipo do Di�logo:")

@ 060,004 Radio aTipo Var nTipo

@ 060,160 Button    OemToAnsi("_Executar") Size 36,16 Action Execute(RunDlg)
@ 089,248 BmpButton Type 1                            Action Close(oDialogos)

Activate Dialog oDialogos

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNDLG   � Autor � Luiz Carlos Vieira � Data �Thu  24/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Executa o dialogo selecionado pelo usuario em FunNovos     ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function RunDlg

cTipo :=         "Executaveis (*.EXE)        | *.EXE | "
cTipo := cTipo + "Figuras (*.BMP)            | *.BMP | "
cTipo := cTipo + "Arquivos de Dados (*" + GetDBExtension() + ")  | *" + GetDBExtension() + " | "
cTipo := cTipo + "Arquivos de Indice (*.CDX) | *.CDX | "
cTipo := cTipo + "Todos os Arquivos  (*.*)   | *.*     "

If nTipo == 1 // Selecao de Arquivos

    cFile := cGetFile(cTipo,"Dialogo de Selecao de Arquivos")

    If !Empty(cFile)
        Aviso("Arquivo Selecionado",cFile,{"Ok"})
    Else
        Aviso("Cancelada a Selecao!","Voce cancelou a selecao do arquivo.",{"Ok"})
    Endif

ElseIf nTipo == 2 // Selecao de Cores

    nCor := ChooseColor(255)

Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �FUNREFRESH� Autor � Luiz Carlos Vieira � Data �Wed  23/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Demostracao de metodos para refresh em objetos             ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function FunRefresh

lPrimeiro := .T.
cPrimeiro := PADR("Este texto faz parte do PRIMEIRO GET",36)
cSegundo  := PADR("Este texto faz parte do SEGUNDO GET" ,36)

@ 116,090 To 416,707 Dialog oRefresh Title OemToAnsi("Refresh de Objetos")
@ 003,002 To 040,305

@ 012,008 Say OemToAnsi("Alguns dos objetos no Windows, como o SAY e o GET, possuem um m�todo REFRESH(). Desse modo")
@ 024,009 Say OemToAnsi("pode-se atualizar as informa��es desses objetos sem for�ar a atualiza��o de todo o di�logo.")

@ 055,005 Say OemToAnsi("Hora atual:")

oTimerHora := Iw_Timer(500,{|| ObjectMethod(oHoraAtual,"SetText(Time())") })
ObjectMethod(oTimerHora,"Activate()")

@ 055,040 Say OemToAnsi(Time())       Object oHoraAtual
@ 080,005 Say OemToAnsi("1o. Get: ")  Object oLabel1
@ 104,005 Say OemToAnsi("2o. Get: ")  Object oLabel2
@ 080,040 Get cPrimeiro               Object oGet1
@ 104,040 Get cSegundo                Object oGet2

@ 088,262 Button OemToAnsi("_Trocar") Size 36,16 Action Execute(FRTroca)
@ 132,263 BmpButton Type 1 Action Close(oRefresh)

Activate Dialog oRefresh
#IFNDEF PROTHEUS
 ObjectMethod(oTimerHora,"DeActivate()")
 ObjectMethod(oTimerHora,"Release()")
#ENDIF

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � FRTROCA  � Autor � Luiz Carlos Vieira � Data �Wed  23/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Faz a troca dos objetos no dialogo da funcao FUNREFRESH    ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function FRTroca

cAux1     := cPrimeiro
cAux2     := cSegundo

cSegundo  := cAux1
cPrimeiro := cAux2

ObjectMethod(oGet1,"Refresh()")
ObjectMethod(oGet2,"Refresh()")

If lPrimeiro
    ObjectMethod(oLabel1,"SetText('2o. Get: ')")
    ObjectMethod(oLabel2,"SetText('1o. Get: ')")
    lPrimeiro := .F.
Else
    ObjectMethod(oLabel1,"SetText('1o. Get: ')")
    ObjectMethod(oLabel2,"SetText('2o. Get: ')")
    lPrimeiro := .T.
Endif
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � FUNMEMO  � Autor � Luiz Carlos Vieira � Data �Thu  24/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Demo. da edicao de campos memo                             ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function FunMEMO

cTexto  := ""
cFOpen  := ""

@ 116,090 To 416,707 Dialog oDlgMemo Title "Demonstra��o de Campos MEMO - Editor de Arquivos Texto"
@ 003,002 To 040,305

@ 012,008 Say OemToAnsi("Para editar um campo MEMO, ou mesmo o conte�do de um arquivo texto, utiliza-se o pr�prio")
@ 024,009 Say OemToAnsi("comando GET, adicionando as cl�usulas SIZE e MEMO. Por exemplo: @10,10 GET cVar Size 50,50 MEMO")

@ 045,005 Say OemToAnsi("Arquivo: <SEM NOME>"+Space(100)) Object oNome
@ 055,005 Get cTexto   Size 250,080  MEMO                 Object oMemo

@ 045,263 Button OemToAnsi("_Abrir...")       Size 36,16 Action Execute(FRAbre)
@ 063,263 Button OemToAnsi("_Fechar")         Size 36,16 Action Execute(FRFecha)
@ 081,263 Button OemToAnsi("_Salvar")         Size 36,16 Action Execute(FRSalva)
@ 099,263 Button OemToAnsi("_Salvar Como...") Size 36,16 Action Execute(FRSalvaComo)

@ 132,263 BmpButton Type 1 Action Close(oDlgMemo)

Activate Dialog oDlgMemo

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � FRABRE   � Autor � Luiz Carlos Vieira � Data �Thu  24/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Rotina para a abertura do arquivo texto na FunMEMO         ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function FRAbre

cFOpen := cGetFile("Arquivos Texto|*.TXT|Todos os Arquivos|*.*",OemToAnsi("Abrir Arquivo..."))
If !Empty(cFOpen)
    cTexto := MemoRead(cFOpen)
    ObjectMethod(oMemo,"Refresh()")
    ObjectMethod(oNome,"SetText('Arquivo: '+cFOpen)")
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � FRFECHA  � Autor � Luiz Carlos Vieira � Data �Thu  24/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Rotina para fechamento do arquivo texto em FunMEMO         ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function FRFecha
    cTexto := ""
    cFOpen := ""
    ObjectMethod(oMemo,"Refresh()")
    ObjectMethod(oNome,"SetText('Arquivo: <SEM NOME>')")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � FRSALVA  � Autor � Luiz Carlos Vieira � Data �Thu  24/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Rotina para salvar o arquivo texto em FunMEMO              ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function FRSalva
If !Empty(cFOpen)
    MemoWrit(cFOpen,cTexto)
Endif
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �FRSALVACOM� Autor � Luiz Carlos Vieira � Data �Thu  24/09/98���
�������������������������������������������������������������������������͹��
���Descri��o � Rotina para salvar arquivo texto com outro nome em FunMEMO ���
�������������������������������������������������������������������������͹��
���Uso		 � Espec�fico para clientes Microsiga						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Function FRSalvaComo
cAux   := cFOpen
cFOpen := cGetFile("Arquivos Texto|*.TXT|Todos os Arquivos|*.*",OemToAnsi("Salvar Arquivo Como..."))
If !Empty(cFOpen)
    MemoWrit(cFOpen,cTexto)
    ObjectMethod(oNome,"SetText('Arquivo: '+cFOpen)")
Else
    cFOpen := cAux
Endif
Return
