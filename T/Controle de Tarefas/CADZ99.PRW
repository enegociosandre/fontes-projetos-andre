//#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"
#include "ap5mail.ch"

User Function CADZ99()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADZ99    ºAutor  ³Donizete            º Data ³  10/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este programa tem a função de montar um browser para       º±±
±±º          ³ edição do cadastro de tarefas bem como colorir os registrosº±±
±±º          ³ de acordo com sua priorida.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Menu                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Public _aCores 		:= {}
Public aRotina		:= {}
Public cCadastro	:= ""
Public _lYesNo		:= .F.
Public _cEmpresa1	:= ""
Public _cEmpresa2	:= ""
Public _cPri		:= ""
Public _cSt			:= ""
Public _cCopia		:= GETMV("MV_Z99CC")
Public _nOpc 		:= 0

_aCores := {{ 'Z99_PRIOR     == "1"  .And. !Z99_STATUS $ "CXP" .And. (Empty(Z99_DTPRV).Or.Z99_DTPRV>=ddatabase)   ', 'BR_VERMELHO'      },; // Prioridade Alta
{ 'Z99_PRIOR     == "2"  .And. !Z99_STATUS $ "CXP" .And. (Empty(Z99_DTPRV).Or.Z99_DTPRV>=ddatabase)', 'BR_AMARELO'       },; // Prioriade Normal
{ 'Z99_PRIOR     == "3"  .And. !Z99_STATUS $ "CXP"   ', 'BR_AZUL'          },; // Prioriade Baixa
{ 'Z99_STATUS    == "X"                              ', 'BR_CINZA'         },; // Atividade Cancelada
{ 'Z99_STATUS    == "P"                              ', 'BR_BRANCO'        },; // Atividade Adiada
{ 'Z99_STATUS    == "C"                              ', 'BR_VERDE'        },; // Atividade Adiada
{ '!Empty(Z99_DTPRV).And.Z99_DTPRV<ddatabase         ', 'BR_PRETO'    }}   // Atividade Atrasada

aRotina	:=   {{"Pesquisar","AXPESQUI" ,0,1},;
{"Visualizar"  ,"AXVISUAL       "    ,0,2},;
{"Incluir"     ,"U_Z99INCLUI    "    ,0,3},;
{"Alterar"     ,"U_Z99ALTERA    "    ,0,4},;
{"Excluir"     ,"U_Z99DELETA    "    ,0,5},;
{"View"        ,"U_Z99VIEW      "      ,0,6},;
{"Envia E-Mail","U_Z99EMAIL     "  ,0,7},;
{"Relatório"   ,"U_Z99IMPRIMEREQ",0,8},;
{"Legenda"     ,"U_Z99LEGENDA   "   ,0,9}}

cCadastro := "Controle de Tarefas - 1.11"

//Verifica se a base é top.
If Alltrim(__crdd) = "TOPCONN"
	mBrowse(6, 1, 22, 75, "Z99",,,,,, _aCores)
Else
	
	_lYesNo := MsgBox("Filtrar tarefas concluídas/canceladas? (Tem efeito no browse e relatórios)","Pergunta","YESNO")
	
	If _lYesNo	== .F.
		mBrowse(6, 1, 22, 75, "Z99",,,,,, _aCores)
	Else
		cIndex := CriaTrab(nil,.f.)
		dbSelectArea("Z99")
		dbSetOrder(1)
		dbGoTop()
		cKey := IndexKey()
		cCondicao := "Z99_STATUS <> 'X' .And. Z99_STATUS <> 'C'"
		
		IndRegua("Z99",cIndex,cKey,,cCondicao)
		
		mBrowse(6,1,22,75,"Z99",,,,,,_aCores)
		
		Z99->(dbCloseArea())
		Ferase(cIndex+OrdBagExt())
	EndIf
EndIf

Return(.T.)

User Function Z99Inclui()
_nOpc := AxInclui("Z99",, 3)
If _nOpc = 1
	EnviarEmail()
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Altera    ºAutor  ³Donizete            º Data ³  11/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Permite alteração somente registros não concluídos/        º±±
±±º          ³ cancelados.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CADZ99                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Z99Altera()

If Z99->Z99_STATUS == "X" .Or. (Z99->Z99_STATUS == "C" .And. !Empty(Z99->Z99_DTFINS))
	MsgInfo("Tarefa concluída ou cancelada não pode ser alterada.","Atenção")
ElseIf Z99->Z99_USRID1 == Alltrim(RetCodUsr()) .Or. Z99->Z99_USRID2 == Alltrim(RetCodUsr())
	_nOpc := AxAltera("Z99",RecNo(),4,,)
	If _nOpc = 1
		EnviarEmail()
	EndIf
Else
	MsgInfo("Somente os usuários amarrados a esta Tarefa podem fazer atualizações.","Atenção")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Deleta    ºAutor  ³Donizete            º Data ³  11/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Permite excluir somente registros não iniciados            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CADZ99                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Z99Deleta()

If Z99->Z99_STATUS <> "N"
	MsgInfo("Somente registros com status 'N=Não Iniciado' podem ser excluídos.","Atencao")
	//Elseif Upper(SubStr(cUsuario,7,15)) <> Z99->Z99_PROPRI .And. ;
	//	Alltrim(Upper(SubStr(cUsuario,7,15))) <> "ADMINISTRADOR"
ElseIf Z99->Z99_USRID1 <> Alltrim(RetCodUsr())
	MsgInfo("Somente usuário que incluiu o registro poderá apagá-lo!","Atencao")
Else
	AxDeleta("Z99",RecNo(),5,,)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Legenda   ºAutor  ³Donizete            º Data ³  11/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mostra a legenda dos registros.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CADZ99                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Z99Legenda()

Local cCadastro := "Controle de Tarefas"
Local aCores2	:= {}

aCores2 := {{ 'BR_VERMELHO'	, "Prioridade Alta"         },;
{ 'BR_AMARELO'  , "Prioridade Normal"       },;
{ 'BR_AZUL'     , "Prioridade Baixa"        },;
{ 'BR_VERDE'    , "Tarefa Concluída"        },;
{ 'BR_BRANCO'   , "Tarefa Adiada"           },;
{ 'BR_CINZA'    , "Tarefa Cancelada"        },;
{ 'BR_PRETO'    , "Tarefa Atrasada"        }}

BrwLegenda(cCadastro,"Legenda do Browse",aCores2)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³View      ºAutor  ³Donizete            º Data ³  11/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mostra os dados da tarefa em uma janela de diálogo.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CADZ99                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Z99View()

// Declaração de Variáveis.
Local _nTam		:= 100
Local _nLinha	:= MLCount(Z99->Z99_DESCM,_nTam)
Local _nLinTela := 60
Local _nInc		:= 0

//Carrega dados.
DefDados()

// Início da janela.
@ 065, 001 TO 560, 700 DIALOG oMyDlg TITLE "View da Tarefa (para resolução 800 x 600)"
@ 005, 003 To 200, 350
@ 010, 010 Say "[ DADOS ] "
@ 020, 010 Say "Tarefa: " + Z99->Z99_NUM + " - Area: " + Z99->Z99_AREA + " - Fase: " + Z99->Z99_FASE + ;
" - Rotina: " + Z99->Z99_ROTINA + ;
"    - Prioridade: " + _cPri + "    - Criado em: " + Transform(Z99->Z99_DTINCL,"@D")
@ 030, 010 Say "Solicitante: " + Alltrim(Z99->Z99_SOLIC)+"/"+Iif(Z99->Z99_EMPR=="M","Microsiga","Cliente") + ;
"    - Responsavel: " + Alltrim(Z99->Z99_RESP) +"/"+Iif(Z99->Z99_EMPRES=="M","Microsiga","Cliente")
@ 040, 010 Say "Para data: " + Transform(Z99->Z99_DTPRV,"@D") + "    - Data início: " + ;
Transform(Z99->Z99_DTINI,"D") + ;
"    - Data conclusão: " + Transform(Z99->Z99_DTCONC,"@D")
@ 050, 010 Say "Status: " + _cSt + "    - % Concluído: " + Transform(Z99->Z99_PERC,"999") + ;
"    - Chamado: " + If(Empty(Z99->Z99_CHAM),"(Não Tem)",Z99->Z99_CHAM)

@ 060, 010 Say "[ ATIVIDADE (somente 3 primeiras linhas) ]"
For _nInc := 1 to 3
	_nLinTela := _nLinTela + 10
	@ _nLinTela, 010 Say MemoLine(Z99->Z99_DESCM,_nTam,_nInc)
Next

_nLinTela := _nLinTela + 10
@ _nLinTela, 010 Say "[ ANOTAÇÕES (8 últimas linhas) ]"

_nLinha := MLCount(Z99->Z99_NOTAM,_nTam)
For _nInc := Iif(_nLinha>8,_nLinha-7,1) To _nLinha
	_nLinTela := _nLinTela + 10
	@ _nLinTela, 010 Say MemoLine(Z99->Z99_NOTAM,_nTam,_nInc)
Next

@ 203,230 Button "Editar" SIZE 50,15 Action (U_Z99Altera(), Close(oMyDlg))
@ 203,285 Button "Fechar" SIZE 50,15 Action Close(oMyDlg)
Activate Dialog oMyDlg Centered
// Fim do Formulário.
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImprimeReqºAutor  ³Donizete            º Data ³  11/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime a Requisicao de tarefas.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CADZ99                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Z99IMPRIMEREQ()
Local	cPerg	:=	PADR("ZZCZ99",Len(SX1->X1_GRUPO))
//Acerta perguntas.
VldPerg(cPerg)

// Carrega parâmetros de impressão.
If Pergunte(cPerg,.T.) == .F.
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Requisição de Tarefas"
Private cPict          := ""
Private titulo       	 := "Requisicao de Tarefas - " + SM0->M0_NOME
Private nLin           := 80

Private Cabec1       := ""
Private Cabec2       := ""
Private imprime      := .T.
Private aOrd             := {"Num.Ativid." , ;
"Responsavel+Empresa+Prioridade+Num.Ativid.", ;
"Solicitante+Empresa+Prioridade+Num.Ativid.", ;
"Area/Categ.+Prioridade+Num.Ativid.+Responsavel+Empr.Resp.", ;
"Prioridade+Num.Ativid.+Area/Categ."}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := Iif(MV_PAR07==1,220,80)
Private tamanho          := Iif(MV_PAR07==1,"G","P")
Private nomeprog         := "CADZ99" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CADZ99" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "Z99"

dbSelectArea("Z99")
dbSetOrder(1)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

//Redefine parâmetros de impressão
Private Cabec1           := Iif(MV_PAR07==1,"Tarefa|Dt.Incl.|Priori|F|Categ|Solicitante      |Responsavel      |Tarefa                                                                                         |Para Dt.|Status       |Dt.Inic.|Dt.Conc.|Chamado","")
Private limite           := Iif(MV_PAR07==1,220,80)
Private tamanho          := Iif(MV_PAR07==1,"G","P")

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  11/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local _nTam		:= 70
lOCAL _nInc		:= 0
Local _nLinha	:= 0  
Local	cPerg	:=	PADR("ZZCZ99",Len(SX1->X1_GRUPO))

dbSelectArea(cString)

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento das ordens. A ordem selecionada pelo usuario esta contida³
//³ na posicao 8 do array aReturn. E um numero que indica a opcao sele- ³
//³ cionada na mesma ordem em que foi definida no array aOrd. Portanto, ³
//³ basta selecionar a ordem do indice ideal para a ordem selecionada   ³
//³ pelo usuario, ou criar um indice temporario para uma que nao exista.³
//³ Por exemplo:                                                        ³
//³                                                                     ³
//³ nOrdem := aReturn[8]                                                ³
//³ If nOrdem < 5                                                       ³
//³     dbSetOrder(nOrdem)                                              ³
//³ Else                                                                ³
//³     cInd := CriaTrab(NIL,.F.)                                       ³
//³     IndRegua(cString,cInd,"??_FILIAL+??_ESPEC",,,"Selec.Registros") ³
//³ Endif                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nOrdem := aReturn[8]

dbSetOrder(1)
dbSetOrder(nOrdem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbGoTop()
While !EOF() .And. xFilial() == Z99->Z99_FILIAL
	
	If (Z99->Z99_NUM < Alltrim(MV_PAR01)) .Or. (Z99->Z99_NUM > Alltrim(MV_PAR02))
		dbSkip()
		Loop
	EndIf
	
	if ((Z99->Z99_USRID1==Alltrim(MV_PAR03) .Or. Z99->Z99_USRID2==Alltrim(MV_PAR04))) .Or. ;
		(Empty(MV_PAR03) .and. Empty(MV_PAR04))
 		// Imprime os dados...
	Else
		dbSkip()
		Loop
	EndIf
	
	if MV_PAR05 == 1
		if Z99->Z99_STATUS == "X" .Or. Z99->Z99_STATUS == "C" 
			dbSkip()
			loop
		EndIf
	EndIf

	if MV_PAR08 == 1
		if Z99->Z99_STATUS == "P"
			dbSkip()
			loop
		EndIf
	EndIf
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicialização de Variáveis.                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DefDados()
	
	_nTam		:= 70
	_nInc		:= 0
	_nLinha		:= MLCount(Z99->Z99_DESCM,_nTam)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := Iif(MV_PAR07==2,3,7)
	Endif
	
	If MV_PAR07==2
		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
		
		nLin := nLin + 2
		@nLin,00 PSAY "Empresa/Filial      : " + SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)
		
		//nLin := nLin + 2
		//@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 2
		@nLin,00 PSAY "Tarefa n.           : "+ Z99->Z99_NUM
		@nLin,29 PSAY "- Dt.Criação: "+ Transform(Z99->Z99_DTINCL,"@D")
		@nLin,55 PSAY "- Prioridade: [" + _cPri + "]"
		
		nLin := nLin + 2
		@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 1
		@nLin,00 PSAY "Area                : "+ Z99->Z99_AREA
		@nLin,28 PSAY " - Rotina: " + Z99->Z99_ROTINA
		@nLin,50 PSAY "- Fase: " + Z99->Z99_FASE
		
		//nLin := nLin + 2
		//@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 2
		@nLin,00 PSAY "Solicitante         : " + Z99->Z99_SOLIC + " / " + _cEmpresa1
		
		nLin := nLin + 1
		@nLin,00 PSAY "Respons.pela tarefa : " + Z99->Z99_RESP + " / " + _cEmpresa2
		
		//nLin := nLin + 2
		//@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 2
		@nLin,00 PSAY "Descricao da Tarefa : "
		
		nLin := nLin + 1
		For _nInc := 1 To _nLinha
			nLin := nLin + 1
			@ nLin, 00 PSay MemoLine(Z99->Z99_DESCM,_nTam,_nInc)
		Next
		
		nLin := nLin + 2
		@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 2
		@nLin,00 PSAY "Para Data   : " + Transform(Z99->Z99_DTPRV,"@D")
		@nLin,25 PSAY "- Status       : " + _cSt
		
		nLin := nLin + 1
		@nLin,00 PSAY "Iniciada em : " +  Transform(Z99->Z99_DTINI,"@D")
		@nLin,25 PSAY "- Encerrada em : " + Transform(Z99->Z99_DTCONC,"@D")
		
		//nLin := nLin + 2
		//@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 2
		@nLin,00 PSAY "Chamado : " + Z99->Z99_CHAM
		@nLin,25 PSAY "- % Concluido  : " + Transform(Z99->Z99_PERC,"999")
		
		//nLin := nLin + 2
		//@nLin,00 PSAY Replicate("-",80)
		
		nLin := nLin + 3
		@nLin,00 PSAY "Solic.:___________________ __/__/__"
		@nLin,35 PSAY "Resp. :___________________ __/__/__"
		
		nLin := nLin + 3
		@nLin,00 PSAY Replicate("=",80)
		
		nLin := nLin + 1
		@nLin,15 PSAY "IMPORTANTE: para o bom andamento dos trabalhos/cronograma"
		nLin := nLin + 1
		@nLin,15 PSAY "a tarefa devera ser concluida ate a data solicitada."
		
		nLin := nLin + 1
		@nLin,00 PSAY Replicate("=",80)
		
		nLin := nLin + 3
		
		If MV_PAR06 == 1
			@nLin,00 PSAY "Situacao da Tarefa: "
			
			_nLinha		:= MLCount(Z99->Z99_NOTAM,_nTam)
			nLin := nLin + 1
			For _nInc := 1 To _nLinha
				nLin := nLin + 1
				@ nLin, 00 PSay MemoLine(Z99->Z99_NOTAM,_nTam,_nInc)
			Next
		EndIf
		nLin := 60
		
	Else
		
		nLin := nLin + 1
		@nLin,00 PSAY Z99->Z99_NUM + "|" + Transform(Z99->Z99_DTINCL,"@D") + "|" + _cPri + ;
		"|" + Z99->Z99_FASE+"|"+Z99->Z99_AREA + "|" + Z99->Z99_SOLIC + "/" + Z99->Z99_EMPR + ;
		"|" + Z99->Z99_RESP + "/" + Z99->Z99_EMPRES + "|" + MemoLine(Z99->Z99_DESCM,95,1) + ;
		"|" + Transform(Z99->Z99_DTPRV,"@D") + "|" + _cSt + "|" + Transform(Z99->Z99_DTINI,"@D") + ;
		"|" + Transform(Z99->Z99_DTCONC,"@D") + "|" + Z99->Z99_CHAM
	EndIf
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldPerg   ºAutor  ³Donizete            º Data ³  12/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Montagem dos parâmetros para execução da rotina.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Template                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldPerg(cPerg)
	PutSX1(cPerg/*cGrupo*/,'01'/*cOrdem*/,"Tarefa de?              	:"/*cPergunt*/,"Tarefa de?  "/*cPergSpa*/,"Tarefa de?  "/*cPergEng*/,"MV_CH1"/*cVar*/,'C'/*cTipo*/,06/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR01"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{''}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
	PutSX1(cPerg/*cGrupo*/,'02'/*cOrdem*/,"Tarefa ate?   		   	:"/*cPergunt*/,"Tarefa ate?  "/*cPergSpa*/,"Tarefa ate?  "/*cPergEng*/,"MV_CH2"/*cVar*/,'C'/*cTipo*/,06/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR02"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{''}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
	PutSX1(cPerg/*cGrupo*/,'03'/*cOrdem*/,"Solic.(Bco=Todos)?      	:"/*cPergunt*/,"Solic.(Bco=Todos)?  "/*cPergSpa*/,"Solic.(Bco=Todos)?  "/*cPergEng*/,"MV_CH3"/*cVar*/,'C'/*cTipo*/,06/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,/*cValid*/,'USR'/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR03"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{''}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
	PutSX1(cPerg/*cGrupo*/,'04'/*cOrdem*/,"Resp.Solic.(Bco=Todos)? 	:"/*cPergunt*/,"Resp.Solic.(Bco=Todos)? "/*cPergSpa*/,"Resp.Solic.(Bco=Todos)? "/*cPergEng*/,"MV_CH4"/*cVar*/,'C'/*cTipo*/,06/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'G'/*cGSC*/,/*cValid*/,'USR'/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR04"/*cVar01*/,/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{''}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
	PutSX1(cPerg/*cGrupo*/,'05'/*cOrdem*/,"Filtrar Canc./Concl.?   	:"/*cPergunt*/,"Filtrar Canc./Concl.? "/*cPergSpa*/,"Filtrar Canc./Concl.? "/*cPergEng*/,"MV_CH5"/*cVar*/,'C'/*cTipo*/,01/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'C'/*cGSC*/,/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR05"/*cVar01*/,'Sim'/*cDef01*/,'Sim'/*cDefSpa1*/,'Sim'/*cDefEng1*/,/*cCnt01*/,'Não'/*cDef02*/,'Não'/*cDefSpa2*/,'Não'/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{''}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
	PutSX1(cPerg/*cGrupo*/,'06'/*cOrdem*/,"Imprimir Situação?     	:"/*cPergunt*/,"Imprimir Situação? "/*cPergSpa*/,"Imprimir Situação? "/*cPergEng*/,"MV_CH6"/*cVar*/,'C'/*cTipo*/,01/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'C'/*cGSC*/,/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR06"/*cVar01*/,'Sim'/*cDef01*/,'Sim'/*cDefSpa1*/,'Sim'/*cDefEng1*/,/*cCnt01*/,'Não'/*cDef02*/,'Não'/*cDefSpa2*/,'Não'/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{''}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
	PutSX1(cPerg/*cGrupo*/,'07'/*cOrdem*/,"Somente Listagem?     	:"/*cPergunt*/,"Somente Listagem? "/*cPergSpa*/,"Somente Listagem? "/*cPergEng*/,"MV_CH7"/*cVar*/,'C'/*cTipo*/,01/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'C'/*cGSC*/,/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR07"/*cVar01*/,'Sim'/*cDef01*/,'Sim'/*cDefSpa1*/,'Sim'/*cDefEng1*/,/*cCnt01*/,'Não'/*cDef02*/,'Não'/*cDefSpa2*/,'Não'/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{''}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )	
	PutSX1(cPerg/*cGrupo*/,'08'/*cOrdem*/,"Filtra Adiada?     		:"/*cPergunt*/,"Filtra Adiada? "/*cPergSpa*/,"Filtra Adiada? "/*cPergEng*/,"MV_CH8"/*cVar*/,'C'/*cTipo*/,01/*nTamanho*/,0/*nDecimal*/,0/*nPreSel*/,'C'/*cGSC*/,/*cValid*/,/*cF3*/,/*cGrpSXG*/,/*cPyme*/,"MV_PAR08"/*cVar01*/,'Sim'/*cDef01*/,'Sim'/*cDefSpa1*/,'Sim'/*cDefEng1*/,/*cCnt01*/,'Não'/*cDef02*/,'Não'/*cDefSpa2*/,'Não'/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,{''}/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )		
Return

Static Function EnviarEmail()
_lYesNo := MsgBox("Deseja enviar e-mail?","Pergunta","YESNO")
If _lYesNo
	U_Z99EMail()
EndIf
Return

User Function Z99EMail(_cAssunto,_cEmailDest,_cMensagem)

local lConect 			:= .F.
local lFim 				:= .F.
local _cMailConta		:= ""
local cMailContaD		:= ""
local cMailContaDest	:= ""
//local cMailContaX	 	:= GETMV("MV_EMCONTA") * Tiago
local cMailCtaRem	 	:= GETMV("MV_EMCONTA")
local cMailServer		:= GETMV("MV_RELSERV")
local cMailSenha		:= GETMV("MV_EMSENHA")
local cRet				:= chr(13)+chr(10)
local nLin				:= 0
Local _nLinha			:= MLCount(Z99->Z99_DESCM,50)
Local cMailInt1			:= ""
Local cMailInt2			:= ""
Local cMailInt3			:= ""  
Local _cSup				:= ""

If Z99->Z99_USRID1 == Alltrim(RetCodUsr()) .Or. Z99->Z99_USRID2 == Alltrim(RetCodUsr())
	//Ok
Else
	MsgInfo("Somente os usuários amarrados a esta Tarefa podem enviar e-mail.","Atenção")
	Return
EndIf

// Solicita confirmação.
_nOpc := Aviso("Envio de e-mail","Para quem enviar?",{"Responsavel","Solicitante","Resp./Solic","Cancela"})

If _nOpc == 4
	Return
EndIf

//Inicializa Valores
DefDados()

// Busca email dos usuarios
psworder(1)  // Indice por Codigo

//If pswseek(alltrim(__cUserId),.t.)
If pswseek(alltrim(Z99->Z99_USRID1),.t.)
	_dAdUser  	:= pswret(1)
	_cMailConta  := Alltrim(_dAdUser[1,14])  // conta do emitente do email
	If Empty(_cMailConta)
	  	If (_cMailConta)
			_cMailConta := GETMV("MV_EMCONTA")
			if Empty(_cMailConta)
		  		MsgInfo("O remetente não possui endereço de e-mail.")
				EndIf
				Return
			EndIf
		EndIf
endif

If pswseek(alltrim(Z99->Z99_USRID2),.t.)
	_dAdUser  	:= pswret(1)
	cMailContaD  := Alltrim(_dAdUser[1,14])  // conta do destinatario do e-mail
	_cSup        := Alltrim(_dAdUser[1,11])  // conta do destinatario do e-mail superior
	If Empty(cMailContaD)
		MsgInfo("O destinatário não possui endereço de e-mail.")
		Return
	EndIf
endif

If pswseek(alltrim(_cSup),.t.)
	_dAdUser  	:= pswret(1)
	_cSup := Alltrim(_dAdUser[1,14])  // conta do destinatario do e-mail
	If Empty(_cSup)
		MsgInfo("Destinatário Superior não possui endereço de e-mail.")
		Return
	EndIf
endif

// Interessados
If !Empty(Z99->Z99_INT1)
	If pswseek(alltrim(Z99->Z99_INT1),.t.)
		_dAdUser  	:= pswret(1)
		cMailInt1  := Alltrim(_dAdUser[1,14])  // conta do destinatario do e-mail
		If Empty(cMailInt1)
			MsgInfo("O destinatário Interessado1 não possui endereço de e-mail.")
			Return
		EndIf
	endif
EndIf

If !Empty(Z99->Z99_INT2)
	If pswseek(alltrim(Z99->Z99_INT2),.t.)
		_dAdUser  	:= pswret(1)
		cMailInt2  := Alltrim(_dAdUser[1,14])  // conta do destinatario do e-mail
		If Empty(cMailInt2)
			MsgInfo("O destinatário Interessado2 não possui endereço de e-mail.")
			Return
		EndIf
	endif
EndIf

If !Empty(Z99->Z99_INT3)
	If pswseek(alltrim(Z99->Z99_INT3),.t.)
		_dAdUser  	:= pswret(1)
		cMailInt3  := Alltrim(_dAdUser[1,14])  // conta do destinatario do e-mail
		If Empty(cMailInt3)
			MsgInfo("O destinatário Interessado3 não possui endereço de e-mail.")
			Return
		EndIf
	endif
EndIf

_cAssunto   := Alltrim(SM0->M0_NOME)+" - Req.de Tarefa " + Z99->Z99_NUM + " - Prioridade: " + _cPri
If _nOpc == 1
	_cEmailDest := cMailContaD
ElseIf _nOpc == 2
	_cEmailDest := _cMailConta
ElseIf _nOpc == 3
	_cEmailDest := cMailContaD + ";" + _cMailConta
EndIf

If !Empty(_cCopia)
	_cEmailDest := 	_cEmailDest + ";" + _cCopia
EndIf

_cEmailDest := _cEmailDest +Iif(!Empty(cMailInt1),";"+cMailInt1,"")
_cEmailDest := _cEmailDest +Iif(!Empty(cMailInt2),";"+cMailInt2,"")
_cEmailDest := _cEmailDest +Iif(!Empty(cMailInt3),";"+cMailInt3,"")
_cEmailDest := _cEmailDest +Iif(Z99->Z99_ENVSUP=="S".And.!Empty(_cSup),";"+_cSup,"")

_cMensagem	:= Replicate("*",65) + cRet
_cMensagem  := _cMensagem + "Mensagem enviada pelo Controle de Tarefas - Versão 1.11" + cRet
_cMensagem	:= _cMensagem + Replicate("*",65) + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Empresa/Filial: " + SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL) + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Tarefa n.: "+ Z99->Z99_NUM + " - Dt.Criação: " + Transform(Z99->Z99_DTINCL,"@D") + ;
"- Prioridade: [" + _cPri + "]" + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Area: "+ Z99->Z99_AREA + " - Fase: "+Z99->Z99_FASE + " - Rotina: " + Z99->Z99_ROTINA + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Solicitante        : " + Z99->Z99_SOLIC + " / " + _cEmpresa1 + cRet
_cMensagem	:= _cMensagem + "Respons.pela tarefa: " + Z99->Z99_RESP + " / " + _cEmpresa2 + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + Replicate("-",65) + cRet
_cMensagem	:= _cMensagem + "Descricao da Tarefa: " + cRet
For _nInc := 1 To _nLinha
	_cMensagem	:= _cMensagem + MemoLine(Z99->Z99_DESCM,50,_nInc) + cRet
Next
_cMensagem	:= _cMensagem + Replicate("-",65) + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Para Data: " + Transform(Z99->Z99_DTPRV,"@D") + ;
" - Status: " + _cSt + cRet
_cMensagem	:= _cMensagem + "Iniciada em: " +  Transform(Z99->Z99_DTINI,"@D") + ;
"- Encerrada em: " + Transform(Z99->Z99_DTCONC,"@D") + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Chamado: " + Z99->Z99_CHAM + ;
"- % Concluido: " + Transform(Z99->Z99_PERC,"999") + cRet
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + "Situação da tarefa: " + cRet
_nLinha		:= MLCount(Z99->Z99_NOTAM,50)
For _nInc := 1 To _nLinha
	_cMensagem	:= _cMensagem + MemoLine(Z99->Z99_NOTAM,50,_nInc) + cRet
Next
_cMensagem	:= _cMensagem + "" + cRet
_cMensagem	:= _cMensagem + Replicate("*",65) + cRet
_cMensagem	:= _cMensagem + "IMPORTANTE: para o bom andamento dos trabalhos/cronograma" + cRet
_cMensagem	:= _cMensagem + "a tarefa devera ser concluida ate a data solicitada." + cRet
_cMensagem	:= _cMensagem + Replicate("*",65) + cRet

//CONNECT SMTP SERVER cMailServer ACCOUNT _cMailContaX PASSWORD cMailSenha RESULT lConect * Tiago
CONNECT SMTP SERVER cMailServer ACCOUNT cMailCtaRem PASSWORD cMailSenha RESULT lConect
If ! (lConect)  // testa se a conexão foi feita com sucesso
	MsgInfo("Erro na conexão.")
Else

	If MailAuth(cMailCtaRem, cMailSenha)

	//	SEND MAIL FROM _cMailConta TO _cEmailDest SUBJECT _cAssunto BODY _cMensagem RESULT lEnv * Tiago
		SEND MAIL FROM cMailCtaRem TO _cEmailDest SUBJECT _cAssunto BODY _cMensagem RESULT lEnv
			
		If ! (lEnv)  // testa se a mensagem foi enviada com sucesso
			MsgInfo("Erro no envio automático de e-mail.")
		Else
			If _nOpc = 1 .Or. _nOpc = 3
				If RecLock("Z99",.f.)
					Z99->Z99_DTEM := ddatabase
					msUnlock()
				EndIf
			EndIf
			Msginfo("E-mail enviado com sucesso para "+_cEmailDest)
		Endif
		
	EndIf		
		
Endif

DISCONNECT SMTP SERVER RESULT lFim

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DefDados  ºAutor  ³Donizete            º Data ³  18/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna variáveis inicializadas.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CADZ99                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DefDados

//Define a empresa.
If Z99->Z99_EMPR == "M"
	_cEmpresa1 := "Microsiga"
Else
	_cEmpresa1 := "Cliente  "
EndIf

If Z99->Z99_EMPRES == "M"
	_cEmpresa2 := "Microsiga"
Else
	_cEmpresa2 := "Cliente  "
EndIf

// Retorna texto da prioridade.
Do Case
	Case Z99->Z99_PRIOR == "1"
		_cPri := "ALTA  "
	Case Z99->Z99_PRIOR == "2"
		_cPri := "Normal"
	Case Z99->Z99_PRIOR == "3"
		_cPri := "Baixa "
EndCase

// Retorna o Status.
Do Case
	Case Z99->Z99_STATUS == "N"
		_cSt := "Nao Iniciado "
	Case Z99->Z99_STATUS == "E"
		_cSt := "Em Andamento "
	Case Z99->Z99_STATUS == "C"
		_cSt := "Concluido    "
	Case Z99->Z99_STATUS == "A"
		_cSt := "Aguardando..."
	Case Z99->Z99_STATUS == "P"
		_cSt := "Adiada       "
	Case Z99->Z99_STATUS == "X"
		_cSt := "Cancelada    "
EndCase

Return
