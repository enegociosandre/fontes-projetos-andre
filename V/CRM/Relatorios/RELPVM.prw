#Include 'Protheus.ch'
#INCLUDE "MSOLE.CH"
#INCLUDE "DBTREE.CH"

/*/{Protheus.doc} VlMoPrp
RDMAKE para Impressao Customizada da Proposta Comercial 

@author  TOTVS SP
@version P12
@since 	 13/09/2016
@return  Nil
/*/
user function RELPVM()
	
	local nI 	:= 0
	local nPos	:= 0
	
	private cComponenteSelecionado	:= ""
	private cNomeFile	:= ""
	private cPath		:= ""
	private cFullPath	:= ""
	private cSrvPath	:= ""
	private cSrvFull	:= ""
	private aComps		:= {}
	
	private cMailSA1	:= ""
	private cMailSUS	:= ""
	
	abreTela()
	
	nPos := Ascan(aComps, {|x|x[5] == cComponenteSelecionado})
	
	if	nPos > 0
	
		cNomeFile	:= alltrim(aComps[nPos][5]) + '.dot'
		cPath		:= AllTrim(SuperGetMv("MV_PATWORD"))
		cFullPath	:= cPath + cNomeFile
		cSrvPath	:= alltrim(GetNewPar("MV_DOCAR","\system\modelos\"))
		cSrvFull	:= cSrvPath + cNomeFile
		
		if CpDotPrp()
			GrDocPrp()
		else
			MsgStop('Erro na execução da copia do arquivo Modelo do Microsoft Word para a estação de trabalho')
		endIf
	endIf
	
return

/*/{Protheus.doc} CpDotPrp
Funcao responsavel por promover a copia do arquivo DOT da impressao de orcamentos 
do servidor Protheus para a Estacao de Trabalho do Usuario. Arquivo fica armazenado no diretorio
TEMP da estacao local. Sempre apaga o arquivo caso ele exista na estacao 

@author  TOTVS SP
@version P12
@since 	 13/09/2016
@return  Nil
/*/
static Function CpDotPrp()
	
	Local nTry	:= 5
	Local nI 	:= 1
	Local lOk	:= .T.
	
	//Verifica se o arquivo existe. Se existe, apaga ele.
	If File(cNomeFile) 
		For nI := 1 to nTry 
			If FErase(cNomeFile) <> -1
				lOk := .T.
				exit
			Else
				lOk := .F.
				Sleep(1000)
			EndIf
		Next nT
		lOk := CpyS2T(cSrvFull,cPath,.T.)
	EndIf
	
	//Copia o Arquivo para a estacao
	If lOk
		lOk := CpyS2T(cSrvFull,cPath,.T.) 
	EndIf
	
Return lOk

/*/{Protheus.doc} GrDocPrp
RDMAKE para Impressao Customizada da Proposta Comercial 

@author  TOTVS SP
@version P12
@since 	 13/09/2016
@return  Nil
/*/
static function GrDocPrp(cPath,cNomeFile)

	local aArea			:= GetArea()						//Armazena area atual
	local hWord 		:= Nil								//Objeto usado para preenchimento
	local cProposta		:= Space(TamSX3("ADY_PROPOS")[1])	//Numero da proposta comercial
	local cDtEmissao	:= Space(TamSX3("CJ_EMISSAO")[1])	//Data de emissao
	local cCodigo		:= Space(TamSX3("A1_COD")[1])		//Codigo da entidade (cliente ou prospect)
	local cLoja			:= Space(TamSX3("A1_LOJA")[1])		//Loja
	local cNome 		:= Space(TamSX3("A1_NOME")[1])		//Nome
	local cEndereco		:= Space(TamSX3("A1_END")[1])   	//Endereco
	local cBairro		:= Space(TamSX3("A1_BAIRRO")[1])    //Bairro
	local cCidade		:= Space(TamSX3("A1_MUN")[1])  		//Cidade
	local cUF			:= Space(TamSX3("A1_ESTADO")[1])  	//Estado (UF)
	local cPRevisa		:= ' '                              //Revisao dos itens da proposta comercial gravado na tabela ADZ
	local aTipo09		:= {}								//Array que armazena o tipo de pagamento 9
	local aCronoFin		:= {}								//Array que armazena o cronograma financeiro
	local cRevisao		:= ' '                              //Controla a revisao do documento
	local nTotProsp		:= 0								//Total da proposta comercial
	local nI			:= 0                               	//Usado no laco do While
	local nX            := 0                                //Usado no laco do For
	local nY			:= 0								//Usado no laco do While
	local nCount		:= 0								//Incremento para utilizar no itens de cond. pagto.
	local aAreasx 		:= LJ7GetArea({"ADZ","ADY","SX5","SA3","SA1","SE4","SB1"})
	
	hWord := OLE_CreateLink()
	OLE_NewFile(hWord, cFullPath)

	if ADY->ADY_ENTIDA == "1"
		cabecSA1(@hWord)
	else
		cabecSUS(@hWord)
	endIf
	
	if type("cNomeWord") <> "U"
		cNomeWord := 'Proposta Vemeer - ' + alltrim(ADY->ADY_PROPOS) + alltrim(ADY->ADY_PREVIS) + " - " + alltrim(Posicione("SA3",1,xFilial("SA3") + ADY->ADY_VEND,"A3_NOME"))
	endIf
	
	detalhesProposta(@hWord)
	
	//Atualiza todos os campos do documento DOT (Refresh)
	OLE_UpDateFields(hWord)
	
	//Trava o Protheus enquanto o Word Estiver Aberto
	While .T.
		If OLE_WordIsOk(hWord)
			Sleep(1000)
		Else
			OLE_CloseLink(hWord)
			exit
		EndIf
	EndDo
	
	RestArea(aARea)
	LJ7RestArea(aAreasx)

Return

static function cabecSA1(hWord)
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	if msSeek(xFilial("SA1") + ADY->ADY_CODIGO + ADY->ADY_LOJA)
		
		OLE_SetDocumentVar(hWord,'cProposta'	,ADY->ADY_PROPOS + "-" + ADY->ADY_PREVIS)
		//OLE_SetDocumentVar(hWord,'dData'		,Dtoc(ADY->ADY_DATA))
		OLE_SetDocumentVar(hWord,'dData'		,Dtoc(ADY->ADY_DTREVI))
		OLE_SetDocumentVar(hWord,'cNome'		,alltrim(SA1->A1_NOME))
		OLE_SetDocumentVar(hWord,'cCGC'			,alltrim(transform(SA1->A1_CGC,pesqpict("SA1","A1_CGC"))))
		OLE_SetDocumentVar(hWord,'cIE'			,alltrim(SA1->A1_INSCR))
		OLE_SetDocumentVar(hWord,'cEndereco'	,alltrim(SA1->A1_END))
		OLE_SetDocumentVar(hWord,'cBairro'		,alltrim(SA1->A1_BAIRRO))			
		OLE_SetDocumentVar(hWord,'cCidade'		,alltrim(SA1->A1_MUN))
		OLE_SetDocumentVar(hWord,'cUF'			,alltrim(SA1->A1_EST))
		OLE_SetDocumentVar(hWord,'cCEP'			,alltrim(SA1->A1_CEP))
		OLE_SetDocumentVar(hWord,'cTelefone'	,alltrim(SA1->A1_DDD) + " - " + alltrim(SA1->A1_TEL))
		OLE_SetDocumentVar(hWord,'cContato'		,contCli())
		OLE_SetDocumentVar(hWord,'cEmail'		,cMailSA1)
		OLE_SetDocumentVar(hWord,'cPrazo'		,if(!empty(ADY->ADY_ZZPREN),alltrim(Posicione("SX5",1,xFilial("SX5") + "ZY" + ADY->ADY_ZZPREN,"X5_DESCRI")),""))
		OLE_SetDocumentVar(hWord,'cCondicao'	,Posicione("SE4",1,xFilial("SE4") + ADY->ADY_CONDPG,"E4_DESCRI"))
		OLE_SetDocumentVar(hWord,'cObs'			,alltrim(ADY->ADY_OBS))
		//OLE_SetDocumentVar(hWord,'cValidade'	,dtoc(ADY->ADY_DATA + pegaSomaVld()))
		OLE_SetDocumentVar(hWord,'cValidade'	,dtoc(ADY->ADY_DTREVI + pegaSomaVld()))
		OLE_SetDocumentVar(hWord,'cNomeVen'		,alltrim(Posicione("SA3",1,xFilial("SA3") + ADY->ADY_VEND,"A3_NOME")))
		OLE_SetDocumentVar(hWord,'cEmailVen'	,alltrim(Posicione("SA3",1,xFilial("SA3") + ADY->ADY_VEND,"A3_EMAIL")))
		OLE_SetDocumentVar(hWord,'cTelVen'		,alltrim(Posicione("SA3",1,xFilial("SA3") + ADY->ADY_VEND,"A3_DDDTEL")) + " - " +;
												 alltrim(Posicione("SA3",1,xFilial("SA3") + ADY->ADY_VEND,"A3_TEL")))
		OLE_SetDocumentVar(hWord,'cNomeGer'		,retNomGerente(ADY->ADY_VEND))
		OLE_SetDocumentVar(hWord,'cEmailGer'	,retMailGerente(ADY->ADY_VEND))
		
	endif
	
return

static function cabecSUS(hWord)

	dbSelectArea("SUS")
	dbSetOrder(1)
	if msSeek(xFilial("SUS")+ADY->ADY_CODIGO+ADY->ADY_LOJA)
		
		OLE_SetDocumentVar(hWord,'cProposta'	,ADY->ADY_PROPOS + "-" + ADY->ADY_PREVIS)
		//OLE_SetDocumentVar(hWord,'dData'		,Dtoc(ADY->ADY_DATA))
		OLE_SetDocumentVar(hWord,'dData'		,Dtoc(ADY->ADY_DTREVI))
		OLE_SetDocumentVar(hWord,'cNome'		,alltrim(SUS->US_NOME))
		OLE_SetDocumentVar(hWord,'cCGC'			,alltrim(transform(SUS->US_CGC,pesqpict("SUS","US_CGC"))))
		OLE_SetDocumentVar(hWord,'cIE'			,alltrim(SUS->US_INSCR))
		OLE_SetDocumentVar(hWord,'cEndereco'	,alltrim(SUS->US_END))
		OLE_SetDocumentVar(hWord,'cBairro'		,alltrim(SUS->US_BAIRRO))			
		OLE_SetDocumentVar(hWord,'cCidade'		,alltrim(SUS->US_MUN))
		OLE_SetDocumentVar(hWord,'cUF'			,alltrim(SUS->US_EST))
		OLE_SetDocumentVar(hWord,'cCEP'			,alltrim(SUS->US_CEP))
		OLE_SetDocumentVar(hWord,'cTelefone'	,alltrim(SUS->US_DDD) + " - " + alltrim(SUS->US_TEL))
		OLE_SetDocumentVar(hWord,'cContato'		,contContato())
		OLE_SetDocumentVar(hWord,'cEmail'		,cMailSUS)
		OLE_SetDocumentVar(hWord,'cPrazo'		,if(!empty(ADY->ADY_ZZPREN),alltrim(Posicione("SX5",1,xFilial("SX5") + "ZY" + ADY->ADY_ZZPREN,"X5_DESCRI")),""))
		OLE_SetDocumentVar(hWord,'cCondicao'	,Posicione("SE4",1,xFilial("SE4") + ADY->ADY_CONDPG,"E4_DESCRI"))
		OLE_SetDocumentVar(hWord,'cObs'			,alltrim(ADY->ADY_OBS))
		//OLE_SetDocumentVar(hWord,'cValidade'	,dtoc(ADY->ADY_DATA + pegaSomaVld()))
		OLE_SetDocumentVar(hWord,'cValidade'	,dtoc(ADY->ADY_DTREVI + pegaSomaVld()))
		OLE_SetDocumentVar(hWord,'cNomeVen'		,alltrim(Posicione("SA3",1,xFilial("SA3") + ADY->ADY_VEND,"A3_NOME")))
		OLE_SetDocumentVar(hWord,'cEmailVen'	,alltrim(Posicione("SA3",1,xFilial("SA3") + ADY->ADY_VEND,"A3_EMAIL")))
		OLE_SetDocumentVar(hWord,'cTelVen'		,alltrim(Posicione("SA3",1,xFilial("SA3") + ADY->ADY_VEND,"A3_DDDTEL")) + " - " +;
												 alltrim(Posicione("SA3",1,xFilial("SA3") + ADY->ADY_VEND,"A3_TEL")))
		OLE_SetDocumentVar(hWord,'cNomeGer'		,retNomGerente(ADY->ADY_VEND))
		OLE_SetDocumentVar(hWord,'cEmailGer'	,retMailGerente(ADY->ADY_VEND))
	endIf
	
return

static function detalhesProposta(hWord)
	
	local nI 		:= 0
	local nTotProsp := 0
	local cSimbMoeda:= ""
	local cMoedaADZ := ""
	
	DbSelectArea("ADZ")
	DbSetOrder(3)
	if dbSeek(xFilial("ADZ")+ADY->ADY_PROPOS+ADY->ADY_PREVIS)
		
		while ADZ->(!Eof()) .and. xFilial("ADZ") == ADZ->ADZ_FILIAL .AND. ADY->ADY_PROPOS == ADZ->ADZ_PROPOS .AND.;
																		  ADY->ADY_PREVIS == ADZ->ADZ_REVISA	
			
			nI++
			cSimbMoeda := alltrim(getMv("MV_SIMB" + ADZ->ADZ_MOEDA))
			cMoedaADZ  := ADZ->ADZ_MOEDA
			
			OLE_SetDocumentVar(hWord,"item"+Alltrim(str(nI))  		,ADZ->ADZ_ITEM)
			OLE_SetDocumentVar(hWord,"produto"+Alltrim(str(nI)) 	,Alltrim(Posicione("SB1",1,xFilial("SB1") + ADZ->ADZ_PRODUT,"B1_DESC")))
			OLE_SetDocumentVar(hWord,"ncm"+Alltrim(str(nI))			,Alltrim(Posicione("SB1",1,xFilial("SB1") + ADZ->ADZ_PRODUT,"B1_POSIPI")))
			OLE_SetDocumentVar(hWord,"quantidade"+Alltrim(str(nI)) 	,Alltrim(Transform(ADZ->ADZ_QTDVEN,pesqpict("ADZ","ADZ_QTDVEN"))))
			//OLE_SetDocumentVar(hWord,"vunitario"+Alltrim(str(nI)) 	,cSimbMoeda + " " + Alltrim(Transform(ADZ->ADZ_PRCVEN,pesqpict("ADZ","ADZ_PRCVEN"))))
			OLE_SetDocumentVar(hWord,"vunitario"+Alltrim(str(nI)) 	,cSimbMoeda + " " + Alltrim(Transform(ADZ->ADZ_ZZPRCB,pesqpict("ADZ","ADZ_ZZPRCB"))))
			OLE_SetDocumentVar(hWord,"desconto"+Alltrim(str(nI)) 	,cSimbMoeda + " " + Alltrim(Transform(ADZ->ADZ_VALDES,pesqpict("ADZ","ADZ_VALDES"))))
			OLE_SetDocumentVar(hWord,"vliquido"+Alltrim(str(nI)) 	,cSimbMoeda + " " + Alltrim(Transform(ADZ->ADZ_TOTAL,pesqpict("ADZ","ADZ_TOTAL"))))
			
			nTotProsp += ADZ->ADZ_TOTAL
			
			ADZ->(dbSkip())
			
		endDo
		
		if nI > 0
//			OLE_SetDocumentVar(hWord,'nVTotal', cSimbMoeda + " " + Alltrim(Transform(nTotProsp,pesqpict("ADZ","ADZ_TOTAL"))))
//			OLE_SetDocumentVar(hWord,'nVTotal', cSimbMoeda + " " + Extenso(nTotProsp ,,val(cMoedaADZ)))
			OLE_SetDocumentVar(hWord,'nVTotal', cSimbMoeda + " " + Alltrim(Transform(nTotProsp,pesqpict("ADZ","ADZ_TOTAL"))) + " - " + Extenso(nTotProsp ,,val(cMoedaADZ)))
		endIf
		
	endIf
	
	if nI > 0
		
		OLE_SetDocumentVar(hWord,'nItens_proposta',alltrim(Str(nI)))
		OLE_ExecuteMacro(hWord,"tabitens") 
		
	endIf
	
return

//static function mailSA1()
//	
//	local cAlias 		:= getNextAlias()
//	local cMailContato	:= ""
//	local cChave 		:= SA1->A1_COD + SA1->A1_LOJA
//	
//	beginSql Alias cAlias
//		SELECT U5_EMAIL
//	      FROM %TABLE:AC8% AC8
//	      	   INNER JOIN %TABLE:SA1% A1
//	      	           ON A1_FILIAL = %XFILIAL:SA1%
//	      	          AND A1_COD+A1_LOJA = %exp:cChave%
//	      	          AND A1.%NOTDEL%
//	      	   INNER JOIN %TABLE:SU5% U5
//	      	           ON %XFILIAL:SU5% = U5_FILIAL
//	      	          AND U5_CODCONT = AC8_CODCON
//	      	          AND U5.%NOTDEL%
//	     WHERE %XFILIAL:AC8% = AC8_FILIAL
//	       AND AC8_ENTIDA = "SA1"
//	       AND AC8_CODENT = %exp:cChave%
//	       AND AC8.%NOTDEL%
//	      ORDER BY AC8.R_E_C_N_O_
//	endSql
//	
//	(cAlias)->(dbGoTop())
//	
//	if !( (cAlias)->(Eof()) )
//		cMailContato := (cAlias)->U5_EMAIL
//	EndIf
//		
//	(cAlias)->(dbCloseArea())
//	
//return cMailContato
//
//static function mailSUS()
//	
//	local cAlias 		:= getNextAlias()
//	local cMailContato	:= ""
//	local cChave 		:= SUS->US_COD + SUS->US_LOJA
//	
//	beginSql Alias cAlias
//		SELECT U5_EMAIL
//	      FROM %TABLE:AC8% AC8
//	      	   INNER JOIN %TABLE:SUS% US
//	      	           ON US_FILIAL = %XFILIAL:SUS%
//	      	          AND US_COD+US_LOJA = %exp:cChave%
//	      	          AND US.%NOTDEL%
//	      	   INNER JOIN %TABLE:SU5% U5
//	      	           ON %XFILIAL:SU5% = U5_FILIAL
//	      	          AND U5_CODCONT = AC8_CODCON
//	      	          AND U5.%NOTDEL%
//	     WHERE %XFILIAL:AC8% = AC8_FILIAL
//	       AND AC8_ENTIDA = "SUS"
//	       AND AC8_CODENT = %exp:cChave%
//	       AND AC8.%NOTDEL%	
//	       ORDER BY AC8.R_E_C_N_O_	
//	endSql
//	
//	(cAlias)->(dbGoTop())
//	
//	if !( (cAlias)->(Eof()) )
//		cMailContato := (cAlias)->U5_EMAIL
//	endIf
//		
//	(cAlias)->(dbCloseArea())
//	
//return cMailContato

static function contCli()

	local cAlias 		:= getNextAlias()
	local cNomeContato	:= ""
	local cChave 		:= SA1->A1_COD + SA1->A1_LOJA
	local cDadosCliente := SA1->A1_COD +"/"+ SA1->A1_LOJA +" - "+ Alltrim(SA1->A1_NOME)
	local aContatos		:= {}
	
	beginSql Alias cAlias
		SELECT U5_CONTAT, U5_EMAIL
	      FROM %TABLE:AC8% AC8
	      	   INNER JOIN %TABLE:SU5% U5
	      	           ON %XFILIAL:SU5% = U5_FILIAL
	      	          AND U5_CODCONT = AC8_CODCON
	      	          AND U5.%NOTDEL%	      	   
	     WHERE %XFILIAL:AC8% = AC8_FILIAL
	       AND AC8_ENTIDA = "SA1"
	       AND AC8_CODENT = %exp:cChave%
	       AND AC8.%NOTDEL%
	       ORDER BY AC8.R_E_C_N_O_		
	endSql
	
	(cAlias)->(dbGoTop())
	
	do while !( (cAlias)->(Eof()) )
			Aadd(aContatos,{.F., AllTrim((cAlias)->U5_CONTAT), AllTrim((cAlias)->U5_EMAIL)})
		(cAlias)->(dbSkip())
	EndDo
	
	cNomeContato := escolheContato(aContatos, .T., cDadosCliente)
		
	(cAlias)->(dbCloseArea())
	
return cNomeContato

static function contContato()

	local cAlias 		:= getNextAlias()
	local cNomeContato	:= ""
	local cChave 		:= SUS->US_COD + SUS->US_LOJA
	local cDadosProspect:= SUS->US_COD +"/"+ SUS->US_LOJA +" - "+ Alltrim(SUS->US_NOME)
	local aContatos		:= {}
	
	beginSql Alias cAlias
		SELECT U5_CONTAT, U5_EMAIL
	      FROM %TABLE:AC8% AC8
	      	   INNER JOIN %TABLE:SU5% U5
	      	           ON %XFILIAL:SU5% = U5_FILIAL
	      	          AND U5_CODCONT = AC8_CODCON
	      	          AND U5.%NOTDEL%	      	   
	     WHERE %XFILIAL:AC8% = AC8_FILIAL
	       AND AC8_ENTIDA = "SUS"
	       AND AC8_CODENT = %exp:cChave%
	       AND AC8.%NOTDEL%
	       ORDER BY AC8.R_E_C_N_O_		
	endSql
	
	(cAlias)->(dbGoTop())
	
	do while !( (cAlias)->(Eof()) )
			Aadd(aContatos,{.F., AllTrim((cAlias)->U5_CONTAT), AllTrim((cAlias)->U5_EMAIL)})
		(cAlias)->(dbSkip())
	EndDo
	
	cNomeContato := escolheContato(aContatos, .F., cDadosProspect)
	
	(cAlias)->(dbCloseArea())
	
return cNomeContato

static function pegaSomaVld()
	
	local nRet 		:= 0
	local cAlias 	:= getNextAlias()
	
	beginSql Alias cAlias
		SELECT ADZ_MOEDA
	      FROM %TABLE:ADZ% ADZ
	     WHERE %XFILIAL:ADZ% = ADZ_FILIAL
	       AND ADZ_PROPOS = %exp:ADY->ADY_PROPOS%
	       AND ADZ_REVISA = %exp:ADY->ADY_PREVIS%
	       AND ADZ_MOEDA = '4'
	       AND ADZ.%NOTDEL%		
	endSql
	
	(cAlias)->(dbGoTop())
		
	if !( (cAlias)->(Eof()) )
		nRet := 15
	else
		nRet := 7
	endIf
		
	(cAlias)->(dbCloseArea())
	
return (nRet)

static function retNomGerente(cCodVend)
	
	local cAlias 	:= getNextAlias()
	local cNomeGer 	:= ""
		
	beginSql Alias cAlias
		SELECT SA3B.A3_NOME AS A3NOMGER
	      FROM %TABLE:SA3% SA3
	      	   INNER JOIN %TABLE:SA3% SA3B
	      	           ON SA3B.A3_FILIAL = SA3.A3_FILIAL
	      	          AND SA3B.A3_COD = SA3.A3_GEREN
	      	          AND SA3B.%NOTDEL% 
	     WHERE %XFILIAL:SA3% = SA3.A3_FILIAL
	       AND SA3.A3_COD = %EXP:cCodVend%
	       AND SA3.%NOTDEL%		
	endSql
		
	(cAlias)->(dbGoTop())
	
	if ( (cAlias)->(!Eof()) )
		cNomeGer := (cAlias)->A3NOMGER
	EndIf
	
	(cAlias)->(dbCloseArea())
	
return (cNomeGer)

static function retMailGerente(cCodVend)
	
	local cAlias 	:= getNextAlias()
	local cMailGer 	:= ""
		
	beginSql Alias cAlias
		SELECT SA3B.A3_EMAIL AS A3MAILGER
	      FROM %TABLE:SA3% SA3
	      	   INNER JOIN %TABLE:SA3% SA3B
	      	           ON SA3B.A3_FILIAL = SA3.A3_FILIAL
	      	          AND SA3B.A3_COD = SA3.A3_GEREN
	      	          AND SA3B.%NOTDEL% 
	     WHERE %XFILIAL:SA3% = SA3.A3_FILIAL
	       AND SA3.A3_COD = %EXP:cCodVend%
	       AND SA3.%NOTDEL%		
	endSql
		
	(cAlias)->(dbGoTop())
	
	if ( (cAlias)->(!Eof()) )
		cMailGer := (cAlias)->A3MAILGER
	EndIf
	
	(cAlias)->(dbCloseArea())
	
return (cMailGer)

static function abreTela()

	local aArea			:= GetArea()						//Guarda area atual
	local cPais			:= Criavar("AG4_PAIS")				//Pais selecionado
	local cIdioma		:= Criavar("AG4_IDIOMA")			//Idiona selecionado
	local cCodigo		:= SPACE(len(AG1->AG1_CODIGO))		//Codigo do modelo selecionado
	local aComponente	:= {}								//Array para os componentes do modelo selecionado
	local oObrigat 											//Objeto utilizado no Tree  (Obrigatorio)
	local oOpcSelec   										//Objeto utilizado no Tree  (Opcional Selecionado)
	local oOpcNSelec 										//Objeto utilizado no Tree  (Opcional nao selecionado)
	local oTree												//Objeto para o Tree do aComponentes
	local lHtml 		:= IsHTML()  						// Verifica se e Html
	local nOpc			:= 0
	
	//Nao e permitido realizar impressao pelo remote HTML
	If lHtml
		FWAvisoHTML()
		Return(.T.)
	EndIf 
	
	Define MSDialog oDlg Title "Impressão de Modelo - Integração com Word" From 000,000 To 425,450 Of oMainWnd Pixel 
	
	@ 07,015  	Say "País" PIXEL 
	@ 06,040  	MSGET cPais	Picture "@!" F3 "SYA" Valid ExistCpo( "SYA", cPais ) When(IIF(Empty(Alltrim(cPais)),.T.,.F.)) PIXEL
	
	@ 07,072    Say "Idioma" pixel 
	@ 06,097  	MSGET cIdioma Picture "@!" F3 "F8" Valid ExistCpo( "SX5","F8" + cIdioma ) When(IIF(Empty(Alltrim(cIdioma)),.T.,.F.)) PIXEL
	
	@ 21,015  	SAY "Modelo" PIXEL 
	@ 19,040  	MSGET cCodigo	Picture "@!" F3 "AG1MOD"  Valid (ExistCpo("AG1",M->cCodigo,1) .AND. MsgRun("Aguarde","Carregando modelo ...",{||R600Tree(cCodigo,@aComponente,cPais,cIdioma,oTree)})) When(IIF(Empty(Alltrim(cCodigo)),.T.,.F.)) PIXEL 
	@ 19,073   	MSGET Posicione("AG1", 01, xFilial("AG1")+cCodigo, "AG1_DESCRI") When .F.  Size 135,10 PIXEL
	
	///--- tree
	oTree := DbTree():New(060,015,190,210,oDlg,{||R600MudaStatus(aComponente,@oTree:GetCargo(),oTree),oTree:Refresh()},,.T.,.F.)
	
	oObrigat 	:= TBitmap():New(003,002,008,008,"br_vermelho",,.T.,oDlg)
	@ 42,025 	SAY "Item Obrigatorio"	PIXEL 
	
	oOpcSelec	:= TBitmap():New(003,009,008,008,"br_azul",,.T.,oDlg)
	@ 42,081  	SAY "Opcional Selecionado"		PIXEL 
	
	oOpcNSelec 	:= TBitmap():New(003,018,008,008,"br_cinza",,.T.,oDlg)
	@ 42,153  	SAY "Opcional nao selecinado"	PIXEL 
	
//	DEFINE SBUTTON oBtnV1 FROM 195,140 TYPE 1 ENABLE OF oDlg ACTION (VlMoPrp(aComponente,cIdioma,cCodigo,cTemplate),oDlg:End(),RestArea(aArea))
	DEFINE SBUTTON oBtnV1 FROM 195,140 TYPE 1 ENABLE OF oDlg ACTION (nOpc := 1,oDlg:End(),RestArea(aArea))
	DEFINE SBUTTON oBtnV2 FROM 195,180 TYPE 2 ENABLE OF oDlg ACTION (RestArea(aArea),oDlg:End())
	
	Activate MSDialog oDlg Centered
	
	if nOpc == 1
		aComps := aClone(aComponente)
	endIf
	
	RestaRea( aArea )

return

Static Function R600MudaStatus(aComponente,cItens,oTree)

	//³ Estrutura do aComponente:    ³
	//³------------------------------³
	//³01 Cod Capitulo               ³
	//³02 Nm Capitulo                ³
	//³03 Nm Componente              ³
	//³04 Obrigat                    ³
	//³05 DocWord                    ³
	//³06 cCargo                     ³
	//³07 Vai para o Dot?[.T./.F.]   ³
	//³08 Rotina que aciona macros   ³
	//³09 Quantidade Niveis do doc   ³
	//³10 Quantidade SubNiveis do doc³
	//³11 Incrementa Cap [1|2]       ³
	//³12 Atualiza o doc via web     ³
	//³13 Cod Componente associado   ³
	
	nPos := Ascan(aComponente,{|x|x[6]==cItens})
	
	If 	cItens == "!" .or. cItens == " "
		//-> Se for capitulo, ou houver dados errados no BD, não fara nada
		Return
	ElseIf 	aComponente[nPos][4] == "1"
		//-> Se for item obrigatorio, chumbar que o componente ira para o Doc, mesmo que ja estaja marcado
		aComponente[nPos][7] 	:= .T.
		cComponenteSelecionado  := aComponente[nPos][5]
	ElseIf 	aComponente[nPos][7]== .F. .and. aComponente[nPos][4]=="2"
		//-> troca componente opcional de desmarcado para marcado
		aComponente[nPos][7]:= .T.
		//-> muda bitmap de desmarcado para marcado
		oTree:ChangeBMP("br_azul","br_azul")
		oTree:Refresh()
	ElseIf aComponente[nPos][7]== .T. .and. aComponente[nPos][4]=="2"
		//-> troca componente opcional de marcado para desmarcado
		aComponente[nPos][7]:= .F.
		//-> muda bitmap de marcado para desmarcado
		oTree:ChangeBMP("br_cinza","br_cinza")
		oTree:Refresh()
	Else
		//-> caso haja erro no cadastro, o componente nao ira para o dot e permanecera desmarcado
		aComponente[nPos][7]:= .F.
		oTree:ChangeBMP("br_cinza","br_cinza")
	Endif
	
Return

Static Function R600Tree(cCodigo,aComponente,cPais,cIdioma,oTree)

	Local nItemArray	:= 0
	Local cProcessa		:= "2"
	
	aComponente := {}
	
	If 	Empty(cCodigo) .or. Empty(cPais) .or. Empty(cIdioma)
		Return (.T.)
	Endif
	
	oTree:Reset() 			//Limpar a tree
	oTree:BeginUpdate() 	//Iniciar Inclusao de itens
	
	oTree:AddTree(PADR("Impressão de Proposta Comercial",TAMSX3("AG3_DESCRI")[1]),.T.,"MENUDOWN","MENURIGHT",,,"!") 
	
	DbSelectArea("AG2")
	DbSetOrder(1)
	MsSeek(xFilial("AG2") + cCodigo)
	
	cComp  	:=	AG2->AG2_COMPPR //Componente Capitulo
	cCompAs	:=  AG2->AG2_COMPAS //Componente Item
	
	DbSelectArea("AG3")
	DbSetOrder(1)
	MsSeek(xFilial("AG3") + AG2->AG2_COMPPR)
	
	cCompPrDs := AG3->AG3_DESCRI// Descricao do componente capitulo
	
	MsSeek(xFilial("AG3")+AG2->AG2_COMPAS)
	
	cCompAsDs := AG3->AG3_DESCRI //Descricao do componente item
	
	DbSelectArea("AG4")
	DbSetorder(2)
	
	If 	MsSeek(xFilial("AG4")+cCompAs+cPais+cIdioma)
		cRotina 	:=  AG4->AG4_FUNCAO //Rotina que ira realizar a integracao com word
		cAtualiza	:=  AG4->AG4_ATUALI //Se atualiza o documento via web
	Else
		oTree:EndTree()
		oTree:EndUpdate()
		Return .F.
	Endif
	
	If 	Empty(AG4->AG4_VLDCOM)
		cProcessa := AG2->AG2_OBRIGA
	Else
		cProcessa := &(AllTrim(AG4->AG4_VLDCOM))
	Endif
	
	If 	cProcessa <> "3"
		
		nItemArray := 1
		
		//³ Estrutura do aComponente:    ³
		//³------------------------------³
		//³01 Cod Capitulo               ³
		//³02 Nm Capitulo                ³
		//³03 Nm Componente              ³
		//³04 Obrigat                    ³
		//³05 DocWord                    ³
		//³06 cCargo                     ³
		//³07 Vai para o Dot?[.T./.F.]   ³
		//³08 Rotina que aciona macros   ³
		//³09 Quantidade Niveis do doc   ³
		//³10 Quantidade SubNiveis do doc³
		//³11 Incrementa Cap [1|2]       ³
		//³12 Atualiza o doc via web     ³
		//³13 Cod Componente associado   ³

		aadd(aComponente,{cComp,cCompPrDs,cCompAsDs,cProcessa,alltrim(AG4->AG4_DOCWOR),chr(nItemArray+33),iif(cProcessa=="1",.T.,.F.),AllTrim(cRotina),AG4->AG4_NIVEL,AG4->AG4_SUBNIV,AG2->AG2_INCCAP,cAtualiza,cCompAs})
		
		///-> Alimenta 1.o item da Tree
		oTree:AddTree(aComponente[nItemArray][2],.T.,"MENUDOWN","MENURIGHT",,,"!")
		oTree:AddTreeItem(aComponente[nItemArray][3],,R600Status(aComponente,aComponente[nItemArray][6]),chr(nItemArray+33))
	Endif
	
	cComp   	:=	AG2->AG2_COMPPR
	
	AG2->(DbSkip())
	
	While cCodigo == AG2->AG2_COD .and. AG2->(!Eof())
		
		DbSelectArea("AG3")
		DbSetOrder(1)
		MsSeek(xFilial("AG3")+AG2->AG2_COMPPR)
		
		cCompPrDs 	:=AG3->AG3_DESCRI// Descricao do componente capitulo
		
		MsSeek(xFilial("AG3")+AG2->AG2_COMPAS)
		
		cCompAsDs 	:=  AG3->AG3_DESCRI //Descricao do componente item
		
		DbSelectArea("AG4")
		DbSetorder(2)
		
		If 	MsSeek(xFilial("AG4")+AG2->AG2_COMPAS+cPais+cIdioma)
			cRotina 	:=  AG4->AG4_FUNCAO //Rotina que ira realizar a integracao com word
			cAtualiza	:=  AG4->AG4_ATUALI //Se atualiza o documento via web
		Else
			oTree:EndTree()
			oTree:EndUpdate()
			MsgAlert("Este modelo não está disponível para impressão nesse PAIS/IDIOMA. Tradução não encontrada para: " + cCompAsDs, "Atenção")
		Endif
		
		cCompPr		:=  AG2->AG2_COMPPR
		cCompAs		:=	AG2->AG2_COMPAS
		
		If 	Empty(AG4->AG4_VLDCOM)
			cProcessa:=AG2->AG2_OBRIGA
		Else
			cProcessa:=&(AllTrim(AG4->AG4_VLDCOM))
		Endif
		
		If 	cProcessa <> "3"
			
			nItemArray++
			
			//³ Estrutura do aComponente:    ³
			//³------------------------------³
			//³01 Cod Capitulo               ³
			//³02 Nm Capitulo                ³
			//³03 Nm Componente              ³
			//³04 Obrigat                    ³
			//³05 DocWord                    ³
			//³06 cCargo                     ³
			//³07 Vai para o Dot?[.T./.F.]   ³
			//³08 Rotina que aciona macros   ³
			//³09 Quantidade Niveis do doc   ³
			//³10 Quantidade SubNiveis do doc³
			//³11 Incrementa Cap [1|2]       ³
			//³12 Atualiza o doc via web     ³
			//³13 Cod Componente associado   ³
			
			//Adiciona cada Item do BD de modelo para o Array
			aadd(aComponente,{cCompPr,cCompPrDs,cCompAsDs,cProcessa,alltrim(AG4->AG4_DOCWOR),chr(nItemArray+33),iif(cProcessa=="1",.T.,.F.),AllTrim(cRotina),AG4->AG4_NIVEL,AG4->AG4_SUBNIV,AG2->AG2_INCCAP,cAtualiza,cCompAs})
			//Se o componente capitulo for diferente, encerra o capitulo atual da tree e abre um novo
			If 	cComp<> AG2->AG2_COMPPR
				If 	nItemArray > 1
					oTree:EndTree()
				Endif
				oTree:AddTree(aComponente[nItemArray][2],.T.,"MENUDOWN","MENURIGHT",,,"!")
			Endif
			
			// Adiciona Item no capitulo
			oTree:AddTreeItem(aComponente[nItemArray][3],,R600Status(aComponente,aComponente[nItemArray][6]),chr(nItemArray+33))
		Endif
		
		cComp := AG2->AG2_COMPPR
		AG2->(DbSkip())
		
	Enddo
	
	oTree:EndTree()
	oTree:EndUpdate()

Return

Static Function R600Status(aComponente,cItens)

	Local cRetorno	:= ""
	Local nPos		:= Ascan(aComponente,{|x|x[6]==cItens})
	
	//³ Estrutura do aComponente:    ³
	//³------------------------------³
	//³01 Cod Capitulo               ³
	//³02 Nm Capitulo                ³
	//³03 Nm Componente              ³
	//³04 Obrigat                    ³
	//³05 DocWord                    ³
	//³06 cCargo                     ³
	//³07 Vai para o Dot?[.T./.F.]   ³
	//³08 Rotina que aciona macros   ³
	//³09 Quantidade Niveis do doc   ³
	//³10 Quantidade SubNiveis do doc³
	//³11 Incrementa Cap [1|2]       ³
	//³12 Atualiza o doc via web     ³
	//³13 Cod Componente associado   ³
	
	If cItens == "!" .or. cItens == " " .or. nPos == 0
		Return Iif (nFunc == 1,NIL,cRetorno)
	ElseIf aComponente[nPos][4]=="1"
		Return ("br_vermelho") //-> Bitmap do Componente obrigatorio
	ElseIf aComponente[nPos][4]=="2" .and. aComponente[nPos][7]== .F.
		Return("br_cinza")  //-> Bitmap do componente opcional não selecionado
	ElseIf aComponente[nPos][4]=="2" .and. aComponente[nPos][7]== .T.
		Return ("br_azul")//-> Bitmap do componente opcional selecionado
	Else
		//-> Se tiver alguma coisas diferente no BD, o bitmap sera de componente nao selecionado,
		//	porem nao conseguira selecionar o componente
		Return ("br_cinza")
	Endif
	
	//Atualiza Tree
	oTree:Refresh()

Return

static function escolheContato(aOpc, lCli, cEntidade)
	
	local aSizeTela		:= MsAdvSize(.f.)
	local nBottomComp	:= 166
	local nRightComp	:= 407
	local oFont 		:= nil
	local oDlg 			:= nil
	local oOpc 			:= nil
	local lRet			:= .F.
	local cRet			:= ""
	local nPos			:= 0
	local oOk			:= LoadBitMap(GetResources(), "LBOK")
	local oNo			:= LoadBitMap(GetResources(), "LBNO")
	
	local aInfo       	:= {}
	local aObj        	:= {}
	local aPObj       	:= {}
	local aPGet       	:= {}
	local aPosEn      	:= {}
	
	aAdd(aObj, {100, 70, .T., .t., .T.})
	
	aInfo 	:= {aSizeTela[1], aSizeTela[2], aSizeTela[3], aSizeTela[4], 3, 3}
	aPObj 	:= MsObjSize(aInfo, aObj,.t.)
	
	Define Font oFont  Name "Tahoma" Size 0,-11 Bold
	Define MsDialog oDlg Title "Selecione um contato do "+ iif(lCli,"Cliente","Prospect") + ": " + cEntidade From aSizeTela[7]-500,0 To aSizeTela[6]-800,aSizeTela[5]-100 PIXEL
	oDlg:lEscClose := .F.
	oDlg:bInit := {|| EnchoiceBar(oDlg,{|| lRet := .T., oDlg:End()},{|| lRet := .F., oDlg:End()},,{})}
	
	oOpc := TcBrowse():New(01 , 01, 360, 150,,,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,.T.,.T.,.T.)   
	oOpc:Align := CONTROL_ALIGN_ALLCLIENT    
	
	oOpc:AddColumn( TcColumn():New( " "				,{ ||if(aOpc[oOpc:nAt,1],oOk,oNo)}	,       ,,,"LEFT" ,010,.T.,.T.,,,,.F.,) )
	oOpc:AddColumn( TcColumn():New( "Nome Contato"	,{ ||aOpc[oOpc:nAt,2]}				, "@!" 	,,,"LEFT" ,050,.F.,.F.,,,,.F.,) )
	oOpc:AddColumn( TcColumn():New( "E-mail Contato",{ ||aOpc[oOpc:nAt,3]}				, "@!" 	,,,"LEFT" ,050,.F.,.F.,,,,.F.,) )
	
	oOpc:SetArray(aOpc)
	oOpc:bLDblClick	:= { ||  marcaUmaOpcao(@oOpc) }

	activate msDialog oDlg centered
	
	if lRet
		nPos := Ascan(aOpc,{|x|  x[1] })

		if nPos > 0
			cRet := aOpc[nPos,2]
			if lCli
				cMailSA1 := aOpc[nPos,3] 
			else
				cMailSUS := aOpc[nPos,3]
			endIf
		endIf
	endIf
	
return cRet

static function marcaUmaOpcao(oOpc)
	
	local nI := 0
	
	oOpc:aArray[oOpc:nAt,1] := !oOpc:aArray[oOpc:nAt,1]
	
	for nI := 1 to Len(oOpc:aArray)
		if oOpc:nAt <> nI
			oOpc:aArray[nI,1] := .F.
		endIf
	next nI
	
	oOpc:Refresh()
	
return