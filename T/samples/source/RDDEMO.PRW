/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RDDemo    � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Demostracao do Interpretador xBase Windows                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �RDMake <Programa.Ext> -w                                    ���
�������������������������������������������������������������������������Ĵ��
��� Exemplo  �RDMake RDDemo.prw -w                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
cVar := "com PICTURE, VALID, WHEN e F3"
cCombo := "Linha 02"
nVar := 0
nVar1 := 10
nList := 4
lCheck1 := .t.
lCheck2 := .f.
lCheck3 := .t.
lCheck4 := .f.
aItems := {"Elemento 01","Elemento 02","Elemento 03","Elemento 04"}
aRadio := {"Sim","Nao","Talvez","Quem sabe?"}
nRadio := 2

@ 0,0 TO 430,500 DIALOG oDlg TITLE "Interpretador xBase for Windows"
@ 10,10 BITMAP SIZE 110,40 FILE "RDDEMO.BMP"
@ 60,5 TO 185,245
@ 070,010 BUTTON "_Objetos B�sicos" SIZE 70,20 ACTION Execute(BasicObj)
@ 070,090 BUTTON "_Browses" SIZE 70,20 ACTION Execute(Browse)
@ 070,170 BUTTON "_Entrada de Dados" SIZE 70,20 ACTION Execute(Multiline)
@ 100,010 BUTTON "_Cadastros" SIZE 70,20 ACTION Execute(DemoCad)
@ 100,090 BUTTON "Bo_t�es Padr�o" SIZE 70,20 ACTION Execute(DemoButton)
@ 100,170 BUTTON "_Mensagens" SIZE 70,20 ACTION Execute(DefaultDlg)
@ 130,010 BUTTON "_Relat�rios" SIZE 70,20 ACTION Execute(Report)
@ 130,090 BUTTON "_Processamento" SIZE 70,20 ACTION Execute(ProcDemo)
@ 130,170 BUTTON "Dlg c/Refresh " SIZE 70,20 ACTION Execute(DlgDinam)
@ 160,090 BUTTON "SQL" SIZE 70,20 ACTION Execute(SqlDemo)

@ 192,218 BMPBUTTON TYPE 1 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �BasicObj  � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Objetos b�sicos Windows                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function BasicObj
@ 0,0 TO 250,450 DIALOG oDlg1 TITLE "Objetos b�sicos do Windows"
@ 10,10 SAY "ListBox:"
@ 20,10 LISTBOX nList ITEMS aItems SIZE 50,50
@ 16,70 TO 67,120 TITLE "CheckBox"
@ 23,75 CHECKBOX "Op��o 1" VAR lCheck1
@ 33,75 CHECKBOX "Op��o 2" VAR lCheck2
@ 43,75 CHECKBOX "Op��o 3" VAR lCheck3
@ 53,75 CHECKBOX "Op��o 4" VAR lCheck4
@ 16,130 TO 67,180 TITLE "RadioButton"
@ 23,130 RADIO aRadio VAR nRadio
@ 75,10 Say "ComboBox:"
@ 85,10 COMBOBOX cCombo ITEMS aItems SIZE 50,50
@ 75,70 Say "Entrada de dados:"
@ 85,70 GET cVar PICTURE "@!" VALID .t. F3 "SI1"
@ 20,185 BUTTON "_Ok" SIZE 35,15 ACTION Close(oDlg1)
@ 45,189 BMPBUTTON TYPE 12 ACTION PlayWave("RDDemo.wav")
ACTIVATE DIALOG oDlg1 CENTER
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �DefaultDlg� Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Dialogos padronizados                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function DefaultDlg
MsgBox ("Dialogo para mensagens de erro","Erro!!!","STOP")
MsgBox ("Informa��o ao usu�rio","Informa��o","INFO")
MsgBox ("Mensagens de alerta","Aten��o","ALERT")
MsgBox ("Dialogo com perguntas...","Escolha","YESNO")
MsgBox ("mais perguntas...","Escolha","RETRYCANCEL")
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Browse    � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Objeto para manipulacao de Browses                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function Browse

@ 200,1 TO 400,530 DIALOG oDlg2 TITLE "Utiliza��o de Browses"

// Para Utilizacao de um arquivo qualquer sem o SX3 em um browse padrao
//aCampos := {}
//AADD(aCampos,{"X6_FIL","Filial do SX6","@!"})
//AADD(aCampos,{"X6_VAR","Parametro do SX6"})   // Nao precisa por Picture
//AADD(aCampos,{"X6_DESCRIC","Descricao do Parametro do SX6"})
//@ 6,5 TO 93,150 BROWSE "SX6" FIELDS aCampos 

// Para utilizacao padrao Pelo SX3
@ 6,5 TO 93,150 BROWSE "SX6" ENABLE "!X6_CONTEUD"

// Para utilizar o recurso de marcacao de registros utilize a linha abaixo"
// @ 6,5 TO 93,150 BROWSE "SC6" ENABLE "C6_QTDENT" MARK "C6_OK"

// Para avaliar se o registro esta marcado utilize:
// ...
// if Marked("C6_OK") 
//   ...
// endif

@ 10,155 SAY "- Baseado no dicion�rio de dados"
@ 20,155 SAY "- Registros Habilitados/desabilitados"
@ 30,155 SAY "- Marcar/Desmarcar registros"
@ 40,155 SAY "- Movimenta��o/Resize de colunas"
@ 70,180 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg2)
ACTIVATE DIALOG oDlg2 CENTERED
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MultiLine � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Objeto para entrada de dados (ITEMS)                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function Multiline
@ 200,1 TO 400,540 DIALOG oDlg3 TITLE "Edi��o de m�ltiplos �tens"
cAlias := "SX5"
dbSelectArea( cAlias )
dbGoTop()
cTabela := X5_TABELA
aHeader := {}
Select Sx2
Seek cAlias
Select Sx3
Seek cAlias
nUsado := 0
While !EOF() .And. X3_ARQUIVO == cAlias
	If x3_usado != " " .And. cNivel >= X3_NIVEL
        nUsado := nUsado + 1
		AADD(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,;
			X3_TAMANHO, X3_DECIMAL, X3_VALID,;
			X3_USADO, X3_TIPO, X3_ARQUIVO } )
	EndIf
	Skip
EndDo
dbSelectArea( cAlias )
Seek xFilial()+cTabela
nCnt := 0
While !EOF() .And. X5_FILIAL+X5_TABELA == xFilial()+cTabela
    nCnt := nCnt+1
	Skip
EndDo
aCOLS := Array(nCnt,nUsado+1)
dbSelectArea( cAlias )
Seek xFilial()+cTabela
nCnt := 0
While !EOF() .And. X5_FILIAL+X5_TABELA == xFilial()+cTabela
    nCnt := nCnt+1
	nUsado:=0
	Select SX3
	Seek cAlias
	While !EOF() .And. X3_ARQUIVO == cAlias
		If x3_usado != " " .And. cNivel >= X3_NIVEL
            nUsado := nUsado+1
            aCOLS[nCnt][nUsado] := &(cAlias+"->"+x3_campo)
		EndIf
		Skip
	EndDo
    aCOLS[nCnt][nUsado+1] := .f. //Flag de Delecao
	dbSelectArea( cAlias )
	Skip
EndDo
dbSelectArea( cAlias )
Seek xFilial()+cTabela
nRegistro := RecNo( )
dbSelectArea( "SX5" )
dbSeek( xFilial() + "00" + cTabela )
dbGoTo( nRegistro )
@ 6,5 TO 93,150 MULTILINE MODIFY DELETE VALID Execute(LineOk) FREEZE 1
@ 10,155 SAY "- Valida��o e Picture configuravel por coluna"
@ 20,155 SAY "- Congelamento de colunas"
@ 30,155 SAY "- Valida��o linha a linha"
@ 40,155 SAY "- Gatilhos, etc..."
@ 70,190 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg3)
ACTIVATE DIALOG oDlg3 CENTERED
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LineOk    � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Validacao da linha digitada na funcao MultiLine             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function LineOk
MsgBox("Linha Ok!","Validando o Item...")
Return .t.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �DemoButton� Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Botoes com Bitmaps padronizados                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function DemoButton
@ 200,1 TO 400,450 DIALOG oDlg4 TITLE "Bot�es com Bitmaps"
@ 5,10 TO 75,215
@ 15,018 BMPBUTTON TYPE 01 ACTION MsgBox("Tipo 1","Bot�o Selecionado...")
@ 15,058 BMPBUTTON TYPE 02 ACTION MsgBox("Tipo 2","Bot�o Selecionado...")
@ 15,098 BMPBUTTON TYPE 03 ACTION MsgBox("Tipo 3","Bot�o Selecionado...")
@ 15,138 BMPBUTTON TYPE 04 ACTION MsgBox("Tipo 4","Bot�o Selecionado...")
@ 15,178 BMPBUTTON TYPE 05 ACTION MsgBox("Tipo 5","Bot�o Selecionado...")
@ 35,018 BMPBUTTON TYPE 06 ACTION MsgBox("Tipo 6","Bot�o Selecionado...")
@ 35,058 BMPBUTTON TYPE 07 ACTION MsgBox("Tipo 7","Bot�o Selecionado...")
@ 35,098 BMPBUTTON TYPE 08 ACTION MsgBox("Tipo 8","Bot�o Selecionado...")
@ 35,138 BMPBUTTON TYPE 09 ACTION MsgBox("Tipo 9","Bot�o Selecionado...")
@ 35,178 BMPBUTTON TYPE 10 ACTION MsgBox("Tipo 10","Bot�o Selecionado...")
@ 55,018 BMPBUTTON TYPE 11 ACTION MsgBox("Tipo 11","Bot�o Selecionado...")
@ 55,058 BMPBUTTON TYPE 12 ACTION MsgBox("Tipo 12","Bot�o Selecionado...")
@ 55,098 BMPBUTTON TYPE 13 ACTION MsgBox("Tipo 13","Bot�o Selecionado...")
@ 55,138 BMPBUTTON TYPE 14 ACTION MsgBox("Tipo 14","Bot�o Selecionado...")
@ 80,175 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg4)
ACTIVATE DIALOG oDlg4 CENTERED
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �DemoCad   � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Tela de cadastramento padrao                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function DemoCad
AxCadastro("SX6","AX_Cadastro() - Cadastramento Padr�o")
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Report    � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exemplo de programacao relatorios                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function Report
cString:="SX5"
cDesc1:= OemToAnsi("Este programa tem como objetivo, demostrar a utiliza��o ")
cDesc2:= OemToAnsi("das ferramentas de impress�o do Interpretador xBase.      ")
cDesc3:= ""
tamanho:="P"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="RDTESTE"
aLinha  := { }
nLastKey := 0
lEnd := .f.
titulo      :="Teste de impressao - Interpretador xBase"
cabec1      :="TESTE DE IMPRESSAO"
cabec2      :=""
cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 0  //Variavel que acumula numero da pagina

wnrel:="RDTESTE"            //Nome Default do relatorio em Disco
SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

RptStatus({|| Execute(RptDetail) })
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RptDetail � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao do corpo do relatorio                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function RptDetail

SetRegua(50) //Ajusta numero de elementos da regua de relatorios
Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //Impressao do cabecalho
For nLin := 1 to 50
    if lEnd
        Exit
    endif
    //Para impressao utiliza-se o comando PSAY
    @ nLin+8,0 PSAY "Linha ==>"
    @ nLin+8,10 PSAY nLin PICTURE "@E 999,999.99"
    IncRegua() //Incrementa a posicao da regua de relatorios
Next
Roda(0,"","P")
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ProcDemo  � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Exemplo de utilizacao de rotinas de processamento           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function ProcDemo

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rotina de Processamento"
@ 8,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("MTA010")
@ 91,168 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa e uma demontra��o da utilizacao das rotinas de processamento."
@ 33,14 SAY "   -Processa()  - Dispara Dialogo de Processamento"
@ 43,14 SAY "   -ProcRegua() - Ajusta tamanho da regua"
@ 53,14 SAY "   -IncProc() - Incrementa posicao da regua"
ACTIVATE DIALOG oDlg5

Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �OkProc    � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Confirma o Processamento                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

Function OkProc
Close(oDlg5)
Processa( {|| Execute(RunProc) } )
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RunProc   � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o Processamento                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function RunProc

ProcRegua(1000)
For i:= 1 to 1000
    IncProc()
Next
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �DlgDinam  � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Dialogos com Refresh                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function DlgDinam
cSay1 := "Demo 01"
cSay2 := "Demo 02"
cGet1 := "Get  01"
cGet2 := "Get  02"


@ 96,42 TO 323,505 DIALOG oDlg6 TITLE "Rotina de Refresh"
@ 8,10 TO 84,222
@ 91,139 BUTTON "Refresh" Size 70,20  ACTION Execute(RefrDlg)
@ 23,14 SAY cSay1
@ 33,14 SAY cSay2
@ 43,14 Get cGet1
@ 53,14 Get cGet2
ACTIVATE DIALOG oDlg6 CENTERED
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �refrDlg   � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o Refresh do Dialogo                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function RefrDlg

cSay1 := IIF(cSay1=="Demo 01","Demo 03","Demo 01")
cSay2 := IIF(cSay2=="Demo 02","Demo 04","Demo 02")
cGet1 := IIF(cGet1=="Get 01","Get 03","Get 01")
cGet2 := IIF(cGet2=="Get 02","Get 04","Get 02")
dlgRefresh(oDlg6)

Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SQLDemo   � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Demostra o uso do RDMake com SQL                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Function SQLDemo
#INCLUDE "TOPCONN.CH"

cMsg := "Este demo somente podera ser executado na versao SQL do SIGA Advanced."
cMsg := cMsg+CHR(13)+"Para sua execucao e necessario que tenha sido migrada a base de dados"
cMsg := cmsg+CHR(13)+"exemplo da empresa Teste(99)."
MsgInfo(cMsg)

dbSelectArea("SX5")
if RDDName() <> "TOPCONN"
   MsgStop("Este demo somente podera ser executado na versao SQL do SIGA Advanced.")
   Return nil
endif

@ 200,1 TO 400,600 DIALOG oDlg7 TITLE "Utiliza��o de Queries SQL"

aCampos := {}
AADD(aCampos,{"A1_COD","Codigo","@!"})
AADD(aCampos,{"A1_NOME","Nome"})
AADD(aCampos,{"X5_DESCRI","Estado"})

cQuery := "SELECT A.A1_COD , A.A1_NOME, X.X5_DESCRI"
cQuery := cQuery + " FROM SA1990 A, SX5990 X"
cQuery := cQuery + " WHERE A.A1_FILIAL = X.X5_FILIAL AND"
cQuery := cQuery + " X.X5_TABELA = '12' AND"
cQuery := cQuery + " A.A1_EST = X.X5_CHAVE"

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "QUERY"

@ 6,5 TO 93,150 BROWSE "Query" FIELDS aCampos
@ 10,155 SAY "- Disponibiliza para o RDMake todo o poder das Queries"
@ 20,155 SAY "- O resultado da query fica disponivel em uma WorkArea"
@ 30,155 SAY "  onde poderao ser executados:"
@ 40,155 SAY "  -dbGoTop(), dbSkip(), Eof(), etc."
@ 50,155 SAY "- IMPORTANTE: Uma Query e sempre Read-Only"
@ 70,180 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg7)
ACTIVATE DIALOG oDlg7 CENTERED

dbCloseArea() //Fecha a Query

nOpt := Alert("Qual base de Dados voce utiliza?",{"Oracle","SQL-Server","AS/400"})

//A funcao TCSQLExec() utilizada abaixo, executa qualquer sintaxe SQL, como:
//UPDATE, INSERT, DELETE, etc.

//Os Statements abaixo criam uma Stored Procedure chamada RDDEMO
//Os seguintes padroes devem ser Obedecidos:
// - Todas os nomes de variaveis devem comecar com IN_ para variaveis de input
//   e OUT_ para variaveis de Output.
if nOpt == 1 //ORACLE

    cQuery := "CREATE OR REPLACE PROCEDURE RDDEMO"
    cQuery := cQuery + "( IN_STR in varchar2, "
    cQuery := cQuery + " IN_VALOR in number, "
    cQuery := cQuery + " OUT_STR out varchar2, "
    cQuery := cQuery + " OUT_VALOR out number) "
    cQuery := cQuery + " is "
    cQuery := cQuery + " BEGIN "
    cQuery := cQuery + " OUT_STR := 'Retornando uma String'"+CHR(59)
    cQuery := cQuery + " OUT_VALOR := IN_VALOR * 2"+CHR(59)
    cQuery := cQuery + " END"+CHR(59)

    TCSQLExec(cQuery)

elseif nOpt == 2 //MS-SQL
    //Verifica se a procedure RDDEMO existe no SQL-Server. Se ja existir faz um Drop.
    cQuery := "if exists (select * from sysobjects where type = 'P' and name = 'RDDEMO') drop procedure dbo.RDDEMO"
    TCSQLExec(cQuery)

    cQuery := "Create Procedure RDDEMO (@IN_STR char(255), @IN_VALOR int , @OUT_STR char(255) OUTPUT, @OUT_VALOR int OUTPUT)"
    cQuery := cQuery + " WITH RECOMPILE "
    cQuery := cQuery + " AS BEGIN "
    cQuery := cQuery + " select @OUT_STR = 'Retorno de Strings' "
    cQuery := cQuery + " select @OUT_VALOR = @IN_VALOR * 2 "
    cQuery := cQuery + " END "
    TCSQLExec(cQuery)
else
   MsgStop("Stored Procedures nao estao disponiveis para AS/400","TCSPExec()")
   Return nil
endif

aRet := TCSPExec("RDDEMO","Isto e uma string",2)
cMsg := "Retorno de Variaveis vem em um array: "
MsgInfo(cMsg + CHR(13)+ "Elemento 1: "+aRet[1]+CHR(13)+"Elemento 2"+Str(aRet[2]),"TCSPExec()")


Return nil

