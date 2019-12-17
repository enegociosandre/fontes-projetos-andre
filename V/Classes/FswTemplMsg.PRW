#include 'Protheus.ch' 
#include 'msobjects.ch' 
#include 'fileio.ch' 
#include 'RWMAKE.CH'
#include 'FONT.CH'
#include 'COLORS.CH'

#define USADO Chr(0) + Chr(0) + Chr(1)

***************************************************************************************************************************************************
/****c* classes/FswTemplMsg
  *  NAME
  *    FswTemplMsg - Classe - Template de Mensagens de Notas Fiscais
  *  AUTHOR 
  *    Deivid A. C. de Lima
  *  CREATION DATE 
  *    07-06-2010
  *  SYNOPSIS
  *    object := FswTemplMsg():TemplMsg()
  *  FUNCTION
  *    Classe - Template de Mensagens de Notas Fiscais
  *  ATTRIBUTES
  *    cAlias	 - alias da tabela de mensagens de NF
  *    cPrfAlias	 - prefixo do alias da tabela de mensagens de NF
  *    cTpNF	 - Tipo da Nota Fiscal (E/S)
  *    cDoc		 - Numero da NF
  *    cSerie	 - Serie da NF
  *    cCliFor	 - Codigo do Cliente/Fornecedor
  *    cLoja	 - Loja do Cliente/Fornecedor
  *    aCampos	 - Array com os campos de dados adicionas da NF
  *    aMsg		 - Array com as mensagens da NF
  *  METHODS
  *    TemplMsg()		 - Metodo construtor
  *    processa()		 - Metodo de processamento dos dados adicionais e mensagens da NF
  *    excMsg()		 - Metodo de exclusao das mensagens da NF
  *    grvMsg()		 - Metodo de gravacao das mensagens da NF
  *    carMsg()		 - Metodo  para carregar as mensagens gravadas da NF
  *    intDadosNF()	 - Metodo de Interface dos dados adicionais e mensagens da NF
  *    grvDadosNF()		 - Metodo de gravacao dos dados adicionais da NF
  *    getCpo()		 - Metodo de retorno de campo da tabela
  *  INPUTS
  *      *  RESULT
  *    algum resultado
  *  EXAMPLE
  *    object := FswTemplMsg():TemplMsg()
  *  NOTES
  *    Nao execute as sextas feiras depois das 18h.
  *  BUGS
  *    Trabalhamos para que nao surjam.
  *  SEE ALSO
  *    Descansar.
  ******
  * Outras informacoes a respeito da classe ou funcao.
  */
***************************************************************************************************************************************************
                       

***************************************************************************************************************************************************
&& 'dummy' function - Uso Interno
***************************************************************************************************************************************************
User Function _FswTemplMsg; Return && 'dummy' function - Uso Interno


***************************************************************************************************************************************************
&& Definicao da classe
***************************************************************************************************************************************************
Class FswTemplMsg

	Data cAlias		as string		&& alias da tabela de mensagens de NF
	Data cPrfAlias		as string		&& prefixo do alias da tabela de mensagens de NF
	Data cTpNF		as string		&& Tipo da Nota Fiscal (E/S)
	Data cDoc		as string		&& Numero da NF
	Data cSerie		as string		&& Serie da NF
	Data cCliFor	as string		&& Codigo do Cliente/Fornecedor
	Data cLoja		as string		&& Loja do Cliente/Fornecedor
	Data aCampos	as array		&& Array com os campos de dados adicionas da NF
	Data aMsg		as array		&& Array com as mensagens da NF

	Method TemplMsg() Constructor
	Method processa()
	Method excMsg()
	Method grvMsg()
	Method carMsg()
	Method intDadosNF()
	Method grvDadosNF()
	Method getCpo(cCampo,lConteud)
	Method getTipoCli()	

EndClass


***************************************************************************************************************************************************
&& Metodo Construtor da Classe
***************************************************************************************************************************************************
Method TemplMsg(cTpNF,cDoc,cSerie,cCliFor,cLoja) Class FswTemplMsg

::cAlias    := GetMv("ZZ_ALIASTM")
::cPrfAlias := IIF(Left(::cAlias,1)=="S",Substr(::cAlias,2,2),::cAlias)
::cTpNF     := cTpNF
::cDoc      := cDoc
::cSerie    := cSerie
::cCliFor   := cCliFor
::cLoja     := cLoja
::aCampos   := {}
::aMsg      := {}

Return Self


***************************************************************************************************************************************************
&& Metodo de processamento dos dados adicionais e mensagens da NF
***************************************************************************************************************************************************
Method processa() Class FswTemplMsg

::carMsg(.F.)

::intDadosNF()

::grvMsg()

Return


***************************************************************************************************************************************************
&& Metodo de exclusao das mensagens da NF
***************************************************************************************************************************************************
Method excMsg() Class FswTemplMsg

Local aArea   := Lj7GetArea({::cAlias})
Local cSeek   := xFilial(::cAlias) + ::cTpNF + ::cDoc + ::cSerie + ::cCliFor + ::cLoja
Local bWhile  := {|| ::getCpo("FILIAL") + ::getCpo("TIPODOC") + ::getCpo("DOC") + ::getCpo("SERIE") + ::getCpo("CLIFOR") + ::getCpo("LOJA") == cSeek}

dbSelectArea(::cAlias)
(::cAlias)->(dbSetOrder(1))
(::cAlias)->(dbSeek(cSeek))
Do While !(::cAlias)->(Eof()) .and. Eval(bWhile)
	RecLock(::cAlias,.F.)
	(::cAlias)->(dbDelete())
	MsUnlock()
	
	(::cAlias)->(dbSkip())
Enddo

Lj7RestArea(aArea)

Return


***************************************************************************************************************************************************
&& Metodo de gravacao das mensagens da NF
***************************************************************************************************************************************************
Method grvMsg() Class FswTemplMsg

Local nI   := 0
Local nJ   := 0
Local nCnt := 0
Local nSeq := 0

dbSelectArea(::cAlias)

For nI := 1 to Len(::aMsg)
		nCnt := MlCount(::aMsg[nI,2], Len(::getCpo("TXTMENS")))
		
		For nJ := 1 to nCnt
			nSeq++
			
			RecLock(::cAlias,.T.)
			SZZ -> ZZ_FILIAL  := xFilial(::cAlias)
			SZZ -> ZZ_TIPODOC := ::cTpNF
			SZZ -> ZZ_DOC     := ::cDoc
			SZZ -> ZZ_SERIE   := ::cSerie
			SZZ -> ZZ_CLIFOR  := ::cCliFor
			SZZ -> ZZ_LOJA    := ::cLoja
			SZZ -> ZZ_SEQMENS := StrZero(nSeq,Len(::getCpo("SEQMENS")))
			SZZ -> ZZ_CODMENS := ::aMsg[nI,1]
			SZZ -> ZZ_TXTMENS := MemoLine(::aMsg[nI,2], Len(::getCpo("TXTMENS")), nJ)
			MsUnlock()
		Next nJ
Next nI

Return


***************************************************************************************************************************************************
&& Metodo de gravacao dos dados adicionais da NF
***************************************************************************************************************************************************
Method grvDadosNF() Class FswTemplMsg

Local cAliasG := IIF(::cTpNF == "E","SF1","SF2")
Local nI      := 0

RecLock(cAliasG,.F.)

For nI := 1 to Len(::aCampos)
	&(cAliasG+"->"+::aCampos[nI,1]) := &("M->"+::aCampos[nI,1])
Next nI

MsUnlock()

Return


***************************************************************************************************************************************************
&& Metodo  para carregar as mensagens gravadas da NF
***************************************************************************************************************************************************
Method carMsg(lGravado) Class FswTemplMsg

Local aArea   := Lj7GetArea({"SD2","SD1","SC5","SB1","SF4",::cAlias})
Local cSeek   := ::cDoc + ::cSerie + ::cCliFor + ::cLoja
Local bWhile  := {|| ::getCpo("FILIAL") + ::getCpo("TIPODOC") + ::getCpo("DOC") + ::getCpo("SERIE") + ::getCpo("CLIFOR") + ::getCpo("LOJA") == xFilial(::cAlias) + ::cTpNF + cSeek}
Local nP      := 0
Local cCod    := ""

Default lGravado := .T.

::aMsg := {}

If lGravado
	dbSelectArea(::cAlias)
	(::cAlias)->(dbSetOrder(1))
	(::cAlias)->(dbSeek(xFilial(::cAlias) + ::cTpNF + cSeek))
	Do While !(::cAlias)->(Eof()) .and. Eval(bWhile)
		aAdd(::aMsg,{::getCpo("CODMENS"),::getCpo("TXTMENS")})
		
		(::cAlias)->(dbSkip())
	Enddo
Else
	If ::cTpNF == "E"
		SB1->(dbSetOrder(1))
		SF4->(dbSetOrder(1))

		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))
		SD1->(dbSeek(xFilial("SD1")+cSeek))

		Do While !SD1->(Eof()) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SD1")+cSeek
			// Recupera Mensagem Padrao no Produto.
			SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
			cCod := SB1->B1_ZZMEN1
			nP := aScan(::aMsg, {|x| x[1] == cCod})
			If nP == 0 .and. !Empty(cCod)
				aAdd(::aMsg,{cCod,Formula(cCod)})
			Endif
	
			// Recupera Mensagem Padrao no TES (3 mensagens).
			SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
			cCod := SF4->F4_ZZMENS
			nP := aScan(::aMsg, {|x| x[1] == cCod})
			If nP == 0 .and. !Empty(cCod)
				aAdd(::aMsg,{cCod,Formula(cCod)})
			Endif
	        /*
			cCod := SF4->F4_ZZMEN2
			nP := aScan(::aMsg, {|x| x[1] == cCod})
			If nP == 0 .and. !Empty(cCod)
				aAdd(::aMsg,{cCod,Formula(cCod)})
			Endif
	
			cCod := SF4->F4_ZZMEN3
			nP := aScan(::aMsg, {|x| x[1] == cCod})
			If nP == 0 .and. !Empty(cCod)
				aAdd(::aMsg,{cCod,Formula(cCod)})
			Endif
			*/
			SD1->(dbSkip())
		Enddo
	Else
		SC5->(dbSetOrder(1))
		SB1->(dbSetOrder(1))
		SF4->(dbSetOrder(1))

		dbSelectArea("SD2")
		SD2->(dbSetOrder(3))
		SD2->(dbSeek(xFilial("SD2")+cSeek))

		Do While !SD2->(Eof()) .and. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == xFilial("SD2")+cSeek
			// Recupera Mensagem Padrao no Pedido de Venda.
			SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
			cCod := SC5->C5_MENPAD
			nP := aScan(::aMsg, {|x| x[1] == cCod})
			If nP == 0 .and. !Empty(cCod)
				aAdd(::aMsg,{cCod,Formula(cCod)})
			Endif
	
			// Recupera Mensagem Padrao no Produto.
			SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
			cCod := SB1->B1_ZZMEN1
			nP := aScan(::aMsg, {|x| x[1] == cCod})
			If nP == 0 .and. !Empty(cCod)
				aAdd(::aMsg,{cCod,Formula(cCod)})
			Endif
	
			// Recupera Mensagem Padrao no TES (3 mensagens).
			SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
			cCod := SF4->F4_ZZMENS
			nP := aScan(::aMsg, {|x| x[1] == cCod})
			If nP == 0 .and. !Empty(cCod)
				aAdd(::aMsg,{cCod,Formula(cCod)})
			Endif
	        /*
			cCod := SF4->F4_ZZMEN2
			nP := aScan(::aMsg, {|x| x[1] == cCod})
			If nP == 0 .and. !Empty(cCod)
				aAdd(::aMsg,{cCod,Formula(cCod)})
			Endif
	
			cCod := SF4->F4_ZZMEN3
			nP := aScan(::aMsg, {|x| x[1] == cCod})
			If nP == 0 .and. !Empty(cCod)
				aAdd(::aMsg,{cCod,Formula(cCod)})
			Endif
			*/
			SD2->(dbSkip())
		Enddo
	Endif
Endif

Lj7RestArea(aArea)

Return


***************************************************************************************************************************************************
&& Metodo de Interface dos dados adicionais e mensagens da NF
***************************************************************************************************************************************************
Method intDadosNF() Class FswTemplMsg

Local aAlterEnch := {}  //Vetor com nome dos campos que poderao ser editados
Local aCpoEnch   := {}// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
Local aPos       := {068,012,160,328}  //Vetor com coordenadas para criacao da enchoice no formato <top>, <left>, <bottom>, <right>
Local cAliasE    := IIF(::cTpNF == "E","SF1","SF2")  //Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
//Local cAliasC    := IIF(::cTpNF == "E","SA2","SA1")
Local cAliasC    := ::getTipoCli()
Local caTela     := ""  // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lColumn    := .F.  //Indica se a apresentacao dos campos sera em forma de coluna
Local lF3        := .F.  //Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria   := .T.  //Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lNoFolder  := .F.  //Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty  := .T.  //Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local nModelo    := 3  //Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local nOpc       := GD_INSERT+GD_DELETE+GD_UPDATE
Local nOpcE      := 3  //Numero da linha do aRotina que definira o tipo de edicao (Inclusao, Alteracao, Exclucao, Visualizacao)
Local nRegE      := 0  //Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)
Local aHoBrw1    := {}
Local aCoBrw1    := {}
Local nI         := 0
Local cNF        := ::cDoc + "/" + ::cSerie
//Local cCli       := ::cCliFor + "/" + ::cLoja + " - " + Posicione(cAliasC,1,xFilial(cAliasC)+::cCliFor+::cLoja,IIF(::cTpNF=="E","A2_NOME","A1_NOME"))
Local cCli       := ::cCliFor + "/" + ::cLoja + " - " + Posicione(cAliasC,1,xFilial(cAliasC)+::cCliFor+::cLoja,IIF(cAliasC == "SA1","A1_NOME","A2_NOME"))
Local aTam       := {}
Local bOk        := {|| aCoBrw1 := aClone(oBrw1:aCols) ,oDlg1:End()}
Local bCancel    := {|| aCoBrw1 := aClone(oBrw1:aCols) ,oDlg1:End()}

Private aTELA:=Array(0,0),aGets:=Array(0)

&& aHeader
aTam := TamSX3(::getCpo("CODMENS",.F.))
aAdd(aHoBrw1,{"Código"   ,::getCpo("CODMENS",.F.),"@!",aTam[1],aTam[2],"",USADO,"C","",""} )

aTam := TamSX3(::getCpo("TXTMENS",.F.))
aAdd(aHoBrw1,{"Descrição",::getCpo("TXTMENS",.F.),"@!",aTam[1],aTam[2],"",USADO,"C","",""} )

&& aCols
If Len(::aMsg) == 0
	aAdd(aCoBrw1,{CriaVar(::getCpo("CODMENS",.F.)),CriaVar(::getCpo("TXTMENS",.F.)),.F.})
Else
	aEval(::aMsg,{|x| aAdd(aCoBrw1,{PADR(x[1],Len(::getCpo("CODMENS"))),PADR(x[2],Len(::getCpo("TXTMENS"))),.F.}) })
Endif

SetPrvt("oFont1","oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oGrp2","oBrw1","oGrp3")

oFont1     := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 105,276,615,952,"Dados Adicionais da NF",,,.F.,,,,,,.T.,,,.T. )
oDlg1:bInit := {||EnchoiceBar(oDlg1,bOk,bCancel,.F.,{})}
oGrp1      := TGroup():New( 028,004,052,336,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 032,012,{||"Nota Fiscal"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 043,012,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 032,048,{||cNF },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,060,008)
oSay4      := TSay():New( 043,048,{||cCli},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,280,008)

oGrp2      := TGroup():New( 172,004,252,336,"Mensagens da NF",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBrw1      := MsNewGetDados():New(184,012,244,328,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp2,aHoBrw1,aCoBrw1 )

oGrp3      := TGroup():New( 056,004,168,336,"Dados Adicionais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

RegToMemory(cAliasE,.T.)

aEval(::aCampos,{|x| aAdd(aCpoEnch,x[1]), aAdd(aAlterEnch,x[1]), &("M->"+x[1]) := x[2] })

aAdd(aCpoEnch,"NOUSER")

Enchoice(cAliasE,nRegE,nOpcE,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPos,aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oDlg1,lF3,lMemoria,lColumn,/*caTela*/,lNoFolder,lProperty)

oDlg1:Activate(,,,.T.)

&& organiza mensagens
::aMsg := {}

aEval(aCoBrw1,{|x| IIF(!x[3],aAdd(::aMsg,{x[1],x[2]}),"") })

&& grava dados adicionais da NF
::grvDadosNF()

Return


***************************************************************************************************************************************************
&& Metodo de retorno de campo da tabela
***************************************************************************************************************************************************
Method getCpo(cCampo,lConteud) Class FswTemplMsg

Local uRet

Default lConteud := .T.

If lConteud
	uRet := &(::cAlias+"->"+::cPrfAlias+"_"+cCampo)
Else
	uRet := ::cPrfAlias+"_"+cCampo
Endif

Return(uRet)

***************************************************************************************************************************************************
&& Metodo de retorno o tipo de Cliente (Fornecedor/Cliente)
***************************************************************************************************************************************************
Method getTipoCli() Class FswTemplMsg

Local cTab			:= IIF(::cTpNF == "E","SA2","SA1")
Local cAlias		:= GetNextAlias()
Local cDoc			:= ::cDoc
Local cSerie		:= ::cSerie

BeginSql Alias cAlias
			
SELECT
	C5_TIPO
FROM 
	%Table:SC5% SC5
WHERE
	SC5.C5_FILIAL = %xFilial:SC5% AND
	SC5.C5_NOTA = %Exp:cDoc% AND
	SC5.C5_SERIE = %Exp:cSerie% AND
	SC5.%notdel%
EndSql

If (cAlias)->(!Eof())
	If (cAlias)->C5_TIPO $ "B/D"
		cTab := "SA2"
	EndIf
EndIf

(cAlias)->(DbCloseArea())

Return (cTab)

***************************************************************************************************************************************************
&& Fim da rotina
***************************************************************************************************************************************************