#include 'protheus.ch'
#include 'parmtype.ch'
#Include "FWMVCDEF.CH"
/*/{Protheus.doc} TMKA260

PE DO MODEL TMKA260 
	
@author Cassiano Gonçalves Ribeiro
@since 21/06/2016
/*/
user function TMKA260()

	local cPontoId 	:= PARAMIXB[2]
	local oObj      := PARAMIXB[1]
	local lRet 		:= .T.
	local nI 		:= 0
	local oMdlSUS 	:= oObj:getModel("SUSMASTER")
	
	if cPontoId == "MODELPOS"
		
		if type("__aAOVVermeer") <> "U"
			
			lRet := (len(__aAOVVermeer) > 0)
						
			__aAOVVermeer := nil
		else
			lRet :=  existeAOW(oMdlSUS:getValue("US_COD"), oMdlSUS:getValue("US_LOJA"), oMdlSUS:getValue("US_CODSEG"))
		endIf
		
		if !lRet
			msgAlert("É obrigatório preencher o subsegmento. "+ CRLF +"Acesse o botão: 'Outras Ações' > subsegmento para cadastra-lo.")
		endIf
		
	elseIf cPontoId == "MODELCOMMITTTS"
		
		if ! (temOportunidadeGenerica(oMdlSUS:getValue("US_COD"), oMdlSUS:getValue("US_LOJA")))
			GeraOportGenerica(oMdlSUS:getValue("US_COD"), oMdlSUS:getValue("US_LOJA"))
		endIf
		
	endIf
	
return (lRet)

static function GeraOportGenerica(cProspe, cLojPro)
	
	local aAutoRot 	:= {}
	local aDados	:= {}
	
	private lMsHelpAuto := .T. // se .t. direciona as mensagens de help para o arq. de log
	private lMsErroAuto := .F. //necessario a criacao, pois sera //atualizado quando houver
	
	aDados:=   {{"AD1_NROPOR" 	, Soma1(GETSXENUM("AD1","AD1_NROPOR"))  ,nil},; 
				{"AD1_REVISA" 	, '01'  								,nil},;
				{"AD1_DESCRI" 	, 'GENERICO'     						,nil},;
				{"AD1_VEND" 	, SuperGetMv('ZZ_VENDGEN',.F.,'000008')	,nil},;
				{"AD1_DTINI"    , dDatabase    							,nil},;
				{"AD1_PROSPE"   , cProspe    							,nil},;
				{"AD1_LOJPRO"   , cLojPro    							,nil},;
				{"AD1_DTPFIM" 	, dDatabase 				  			,nil},;				
				{"AD1_RCFECH" 	, 10			   	  					,nil},;
				{"AD1_FEELIN" 	, '1' 			   	  					,nil},; 
		   		{"AD1_PROVEN" 	, '000001' 			   	  				,nil},;
				{"AD1_STAGE" 	, '000006' 			   	  				,nil},;
		   		{"AD1_CODPRO" 	, SuperGetMv('ZZ_PRODGEN',.F.,'SV0017')	,nil}}
	
	//somente cabeçalho da oportunidade de venda
	aAdd(aAutoRot,{"AD1MASTER",aDados})	
	
	FwMvcRotAuto(FWLoadModel( 'FATA300' ),"AD1",3,aAutoRot,/*lSeek*/,.T.) 
	
	if lMsErroAuto
		msgAlert("Erro na criação da oportunidade genérica!")		
		Mostraerro()
		RollBackSX8()
	else
		msgInfo("Oportunidade genérica criada com sucesso!")
	endIf
	
return

static function temOportunidadeGenerica(cCod,cLoj)
	
	local lRet 		:= .F.
	local cProdGen	:= SuperGetMv('ZZ_PRODGEN',.F.,'SV0017')
	
	local cAliasAD1 := getNextAlias()
		
	beginSql Alias cAliasAD1
		SELECT AD1_NROPOR
	      FROM %TABLE:AD1% AD1
	    WHERE %XFILIAL:AD1% = AD1_FILIAL
	      AND AD1_PROSPE = %exp:cCod% 
	      AND AD1_LOJPRO = %exp:cLoj% 
	      AND AD1_CODPRO = %exp:cProdGen% 
	      AND AD1.%NOTDEL%		
	endSql
		
	(cAliasAD1)->(dbGoTop())
		
	lRet := ! ( (cAliasAD1)->(Eof()) )
	
	(cAliasAD1)->(dbCloseArea())
		
return lRet

static function existeAOW(cCodCnt,cLojCnt,cCodSeg)

	local lRet := .F.
	
	local cAliasAOW := getNextAlias()
		
	beginSql Alias cAliasAOW
		SELECT AOW_CODSEG
	      FROM %TABLE:AOW% AOW
	    WHERE %XFILIAL:AOW% = AOW_FILIAL
	      AND AOW_ENTIDA = "SUS" 
	      AND AOW_CODCNT = %exp:cCodCnt% 
	      AND AOW_LOJCNT = %exp:cLojCnt% 
	      AND AOW_CODSEG = %exp:cCodSeg% 
	      AND AOW.%NOTDEL%		
	endSql
		
	(cAliasAOW)->(dbGoTop())
		
	lRet := ( (cAliasAOW)->(!Eof()) )
			
	(cAliasAOW)->(dbCloseArea())
return lRet