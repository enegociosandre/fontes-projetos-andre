#Include 'Protheus.ch'
#Include 'TOPCONN.ch'
/*
* Relatório	   :   REVARCAMBIAL
* Autor        :   Cassiano G. Ribeiro - Totvs Campinas
* Data         :   04/03/16
* Descricao    :   Relatorio Personalizado de VARIACAO CAMBIAL
*/
user function RelVarCambial()
	
	local oReport := Nil
	
	private oFont14		:= TFont():New("Arial",09,14,		,.T.,,,,,.F.) // Parametros TFonte("Tipo Fonte",,Tamanho Fonte,,,Italico (.T./.F.))
	private oFont12B	:= TFont():New("Arial",09,12,		,.T.,,,,,.F.) // Negrito
	private oFont12Bs	:= TFont():New("Arial",09,12,.T.	,.T.,,,,,.T.) // Negrito - Sublinhado
	private oFont12		:= TFont():New("Arial",09,12,   	,.F.,,,,,.F.) // Nornal
	private oFont10		:= TFont():New("Arial",08,08,		,.F.,,,,,.F.) // Normal
	private oFont10a	:= TFont():New("MS Sans Serif",09,09,,.F.,,,,,.F.)// Normal
	private oFont3 		:= TFont():New("Arial",09,10,.T.	,.T.,,,,,.F.) // Negrito
	private oFont4 		:= TFont():New("Arial",09,14,.T.	,.T.,,,,,.T.) // Negrito - Sublinhado
	private oFont5 		:= TFont():New("Arial",09,10,   	,.F.,,,,,.F.) // Negrito
	private oFont16B	:= TFont():New("Arial",09,16,.T.	,.T.,,,,,.F.) // Negrito
	
	if perg()
		
		oReport := ReportDef()
		
		//Configurando layout e no. pagina.
		oReport:SetPageNumber(1)
		oReport:PrintDialog()
	endIf
	
return

// Definição do layout do Relatório
static function ReportDef()
	
	local oReport   := nil
	local oSection  := nil
	local oCel1 	:= nil
	local oCel2 	:= nil
	local oCel3 	:= nil
	local oCel4 	:= nil
	local oCel5 	:= nil
	local oCel6 	:= nil
	local oCel7 	:= nil
	local oCel8 	:= nil
	local oCel9 	:= nil
	local oCel10 	:= nil
	local oCel11	:= nil
	local oCel12	:= nil
	local oCel13	:= nil
	local oCel14	:= nil
	local oCel15	:= nil
	local nTamData  := Len(DTOC(MsDate()))
	
	oReport := TReport():New("RELVARCAMB","RELATÓRIO DE VARIAÇÃO CAMBIAL - "+"De: "+DtoC(MV_PAR03)+" Até: "+DtoC(MV_PAR04),	{|| Perg()},{|oReport| PrintReport(oReport) })
	oReport:SetLandScape()	// Impressao em Paisagem
	oReport:SetTotalInLine(.F.)
	
	oSection := TRSection():New(oReport,"Variação Cambial")
	oSection:AutoSize()
	oSection:SetTotalInLine(.F.)
	
	oCel1 := TRCell():New(oSection,"EMISSAO"				,"", "Emissão"			,Nil,nTamData)
	oCel1:oFontBody := oFont10	
	oCel2 := TRCell():New(oSection,"DOC"					,"", "Documento"		,Nil,TamSX3("E1_NUM")[1]+5)
	oCel2:oFontBody := oFont10	
	oCel3 := TRCell():New(oSection,"VLR_MOEDA_ESTRANGEIRA"	,"", "Vlr Estrangeira"	,PesqPict("SE1","E1_VALOR"),TamSX3("E1_VALOR")[1])
	oCel3:oFontBody := oFont10
	oCel4 := TRCell():New(oSection,"TX_CONV_INICIAL"		,"", "Tx Inicial"		,PesqPict("SM2","M2_MOEDA4"),TamSX3("M2_MOEDA4")[1])
	oCel4:oFontBody := oFont10
	oCel5 := TRCell():New(oSection,"VLR_REAIS"				,"", "Vlr R$"			,PesqPict("SE1","E1_VALOR"),TamSX3("E1_VALOR")[1])
	oCel5:oFontBody := oFont10
	oCel6 := TRCell():New(oSection,"DT_PAGTO"				,"", "Dt Pagto"			,"@D",nTamData)
	oCel6:oFontBody := oFont10
	oCel7 := TRCell():New(oSection,"VLR_PAGTO"				,"", "Vlr Pagto Estrg."	,PesqPict("SE1","E1_VALOR"),TamSX3("E1_VALOR")[1])
	oCel7:oFontBody := oFont10
	oCel8 := TRCell():New(oSection,"TX_CONVERSAO"			,"", "Tx Final"			,PesqPict("SE1","E1_PORCJUR"),TamSX3("E1_PORCJUR")[1])
	oCel8:oFontBody := oFont10
	oCel9 := TRCell():New(oSection,"VLR_VAR_CTB"			,"", "V Camb CTB"		,PesqPict("SE1","E1_VALOR"),TamSX3("E1_VALOR")[1])
	oCel9:oFontBody := oFont10
	oCel10 := TRCell():New(oSection,"VLR_ATIV"				,"", "Var. Ativa Pagto"	,PesqPict("SE1","E1_VALOR"),TamSX3("E1_VALOR")[1])
	oCel10:oFontBody := oFont10
	oCel11 := TRCell():New(oSection,"VLR_PASS"				,"", "Var. Passiva Pagto",PesqPict("SE1","E1_VALOR"),TamSX3("E1_VALOR")[1])
	oCel11:oFontBody := oFont10
	oCel12 := TRCell():New(oSection,"VLR_REAIS_PAGTO"		,"", "Vlr R$ Pagto"		,PesqPict("SE1","E1_VALOR"),TamSX3("E1_VALOR")[1])
	oCel12:oFontBody := oFont10
	oCel13 := TRCell():New(oSection,"SALDO_ESTRANGEIRA"		,"", "Sld Inv Entrg."	,PesqPict("SE1","E1_VALOR"),TamSX3("E1_VALOR")[1])
	oCel13:oFontBody := oFont10
	oCel14 := TRCell():New(oSection,"SLD_REAIS"				,"", "Sld Inv R$"		,PesqPict("SE1","E1_VALOR"),TamSX3("E1_VALOR")[1])
	oCel14:oFontBody := oFont10
	oCel15 := TRCell():New(oSection,"SLD_REAIS_ATU"			,"", "Sld.Inv.R$.Atu"	,PesqPict("SE1","E1_VALOR"),TamSX3("E1_VALOR")[1])
	oCel15:oFontBody := oFont10
	
	oCel3:SetAlign("RIGHT")
	oCel4:SetAlign("RIGHT")
	oCel5:SetAlign("RIGHT")
	oCel7:SetAlign("RIGHT")
	oCel8:SetAlign("RIGHT")
	oCel9:SetAlign("RIGHT")
	oCel10:SetAlign("RIGHT")
	oCel11:SetAlign("RIGHT")
	oCel12:SetAlign("RIGHT")
	oCel13:SetAlign("RIGHT")
	oCel14:SetAlign("RIGHT")
	oCel15:SetAlign("RIGHT")
	
return (oReport)

// Impressão da informações
static function PrintReport(oReport)
	
	if alltrim(MV_PAR01) == "A receber"
		prtAReceber(@oReport)
	elseIf alltrim(MV_PAR01) == "A pagar"
		prtAPagar(@oReport)
	endIf
	
return

static function prtAPagar(oReport)
	
	local oSec1		:= oReport:Section(1)
	local cAlias	:= GetNextAlias()
	local oBreak	:= Nil
	local oTotTipo	:= Nil	
	local oTotTipo1 := Nil
	local oTotTipo2 := Nil
	local oTotTipo3 := Nil
	local oTotTipo4 := Nil
	local oTotGeral	:= Nil
	local oTotGeral2:= Nil
	local oTotGeral3:= Nil
	local oTotGeral4:= Nil
	local oTotGeral5:= Nil
	local oTotGeral6:= Nil
	local oTotGeral7:= Nil
	local cWhere 	:= "%"
	local cWhereBx 	:= "%"
	local cMoeda 	:= "%"
	
	if MV_PAR05 == "Sim"
		cWhere += "AND E2_SALDO = 0 "
		cWhereBx += "AND E5.E5_DATA BETWEEN '"+ dtos(MV_PAR06) +"' AND '"+ dtos(MV_PAR07) +"' "
	elseif MV_PAR05 == "Não"
		cWhere += "AND E2_SALDO <> 0 "
	endIf
	
	cMoeda += "M2_MOEDA" + alltrim(MV_PAR02) + " "
	
	cWhere += "%" 
	cWhereBx += "%" 
	cMoeda += "%" 
	
	oSec1:BeginQuery()
	
		BeginSql Alias cAlias
			
			%noparser%
			COLUMN EMISSAO AS DATE
			COLUMN DT_PAGTO AS DATE
			
			SELECT A.DOC, A.EMISSAO, 
			       A.VLR_MOEDA_ESTRANGEIRA, 
				   A.DT_PAGTO, A.VLR_REAIS, 
				   A.VLR_REAIS_PAGTO, 
				   A.VLR_REAIS,
				   A.VLR_PAGTO,
				   A.VLR_VAR_CTB, 
				   A.SALDO_ESTRANGEIRA, 
				   A.SLD_REAIS, 
				   A.SLD_REAIS_ATU, 
			       A.TX_CONV_INICIAL, 
				   A.TX_CONVERSAO,
				   CASE WHEN A.VLR_VAR_PAGTO > 0 THEN A.VLR_VAR_PAGTO ELSE 0 END AS VLR_ATIV,
				   CASE WHEN A.VLR_VAR_PAGTO < 0 THEN A.VLR_VAR_PAGTO ELSE 0 END AS VLR_PASS 
			FROM
			(
			SELECT E2_EMISSAO AS EMISSAO,
			       E2_PREFIXO || E5.E5_NUMERO || E5.E5_PARCELA AS DOC,
			       E2_VALOR AS VLR_MOEDA_ESTRANGEIRA,
			       %exp:cMoeda% AS TX_CONV_INICIAL,
			       E2_VALOR * %exp:cMoeda% AS VLR_REAIS,
				  CASE WHEN E5.E5_TIPODOC = 'CM' THEN E5.E5_DATA ELSE '' END AS DT_PAGTO,
				  CASE WHEN E5.E5_TIPODOC = 'CM' THEN E5.E5_VALOR ELSE 0 END AS VLR_PAGTO,
				  CASE WHEN E5.E5_TIPODOC = 'CM' THEN E5.E5_TXMOEDA ELSE 0 END AS TX_CONVERSAO,
				  CASE WHEN E5.E5_TIPODOC = 'VM' THEN E5.E5_VALOR ELSE 0 END AS VLR_VAR_CTB,
				  
				  CASE WHEN  E5.E5_TIPODOC = 'CM' AND NVL((SELECT E5B.E5_VALOR 
				  											 FROM %TABLE:SE5% E5B 
				  											WHERE E5B.E5_FILIAL = E5.E5_FILIAL 
				  											  AND E5B.D_E_L_E_T_ = ' ' 
				  											  AND E5B.E5_DATA < E5.E5_DATA 
				  											  AND E5B.E5_NUMERO = E5.E5_NUMERO 
				  											  AND E5B.E5_PREFIXO = E5.E5_PREFIXO
				  											  AND E5B.E5_TIPO = E5.E5_TIPO 
															  AND E5B.E5_PARCELA = E5.E5_PARCELA 
															  AND E5B.E5_CLIFOR = E5.E5_CLIFOR 
															  AND E5B.E5_LOJA = E5.E5_LOJA 
				  											  AND E5B.E5_TIPODOC = 'CM'),0) > 0
          				THEN (SELECT (E5B.E5_VLMOED2 * %exp:cMoeda%) - E5B.E5_VALOR 
          						FROM %TABLE:SE5% E5B 
          					   WHERE E5B.E5_FILIAL = E5.E5_FILIAL 
          					     AND E5B.D_E_L_E_T_ = ' ' 
          					     AND E5B.E5_DATA = E5.E5_DATA 
          					     AND E5B.E5_NUMERO = E5.E5_NUMERO 
          					     AND E5B.E5_PREFIXO = E5.E5_PREFIXO 
          					     AND E5B.E5_TIPO = E5.E5_TIPO 
								 AND E5B.E5_PARCELA = E5.E5_PARCELA 
								 AND E5B.E5_CLIFOR = E5.E5_CLIFOR 
								 AND E5B.E5_LOJA = E5.E5_LOJA 
          					     AND E5B.E5_TIPODOC = 'VL') 
					 WHEN E5.E5_TIPODOC = 'CM' AND NVL((SELECT E5B.E5_VALOR 
					 									  FROM %TABLE:SE5% E5B 
					 									 WHERE E5B.E5_FILIAL = E5.E5_FILIAL 
					 									   AND E5B.D_E_L_E_T_ = ' ' 
					 									   AND E5B.E5_DATA < E5.E5_DATA 
					 									   AND E5B.E5_NUMERO = E5.E5_NUMERO 
					 									   AND E5B.E5_PREFIXO = E5.E5_PREFIXO
					 									   AND E5B.E5_TIPO = E5.E5_TIPO 
														   AND E5B.E5_PARCELA = E5.E5_PARCELA 
														   AND E5B.E5_CLIFOR = E5.E5_CLIFOR 
														   AND E5B.E5_LOJA = E5.E5_LOJA 
					 									   AND E5B.E5_TIPODOC = 'CM'),0) = 0
          				THEN NVL((SELECT E5B.E5_VALOR 
          				            FROM %TABLE:SE5% E5B 
          				           WHERE E5B.E5_FILIAL = E5.E5_FILIAL 
          				             AND E5B.D_E_L_E_T_ = ' ' 
          				             AND E5B.E5_DATA = E5.E5_DATA 
          				             AND E5B.E5_NUMERO = E5.E5_NUMERO 
          				             AND E5B.E5_PREFIXO = E5.E5_PREFIXO
          				             AND E5B.E5_TIPO = E5.E5_TIPO 
									 AND E5B.E5_PARCELA = E5.E5_PARCELA 
									 AND E5B.E5_CLIFOR = E5.E5_CLIFOR 
									 AND E5B.E5_LOJA = E5.E5_LOJA 
          				             AND E5B.E5_TIPODOC = 'VL') - (E2_VALOR * %exp:cMoeda%),0) 
					ELSE 0 END  AS VLR_VAR_PAGTO,
  
				  CASE WHEN E5.E5_TIPODOC = 'VL' THEN E5.E5_VALOR ELSE 0 END AS VLR_REAIS_PAGTO,
				  CASE WHEN E5.E5_TIPODOC = 'VM' THEN E2_SALDO ELSE 0 END AS SALDO_ESTRANGEIRA,
				  CASE WHEN E5.E5_TIPODOC = 'VM' THEN E2_SALDO * %exp:cMoeda% ELSE 0 END AS SLD_REAIS,
				  (CASE WHEN E5.E5_TIPODOC = 'VM' THEN E2_SALDO * %exp:cMoeda% ELSE 0 END) + (CASE WHEN E5.E5_TIPODOC = 'VM' THEN E5.E5_VALOR ELSE 0 END) AS SLD_REAIS_ATU
				  FROM %TABLE:SE5% E5
				       INNER JOIN %TABLE:SE2% E2
				               ON E2_FILIAL = E5.E5_FILIAL
						  	  %EXP:cWhere%
							  AND E2_PREFIXO = E5.E5_PREFIXO
				              AND E2_NUM = E5.E5_NUMERO
							  AND E2_PARCELA = E5.E5_PARCELA
							  AND E2_TIPO = E5.E5_TIPO
							  AND E2_FORNECE = E5.E5_CLIFOR
							  AND E2_LOJA = E5.E5_LOJA
							  AND E2_EMISSAO BETWEEN %EXP:DTOS(MV_PAR03)% AND %EXP:DTOS(MV_PAR04)%
							  AND E2_MOEDA = %EXP:MV_PAR02%
							  AND E2.D_E_L_E_T_ = ' '
					    INNER JOIN %TABLE:SM2% M2 
							    ON M2_DATA = E2_EMISSAO
							   AND M2.D_E_L_E_T_ = ' '
				 WHERE E5.E5_FILIAL = %XFILIAL:SE5%
				   AND E5.E5_RECPAG = 'P'
				   AND E5.E5_CLIFOR BETWEEN %EXP:MV_PAR08% AND %EXP:MV_PAR10%
				   AND E5.E5_LOJA BETWEEN %EXP:MV_PAR09% AND %EXP:MV_PAR11%
				   AND E5.D_E_L_E_T_ = ' ') A
		EndSql
	oSec1:EndQuery()
	
//	Aviso("Atenção", getLastQuery()[2], {"OK"}, 3, FunDesc())
	
	Count to nCnt
	(cAlias)->(dbGoTop())
	if !(nCnt > 0)
		MsgAlert("Não há dados para os parâmetros informados!")
		oReport:CancelPrint()
	else
		oReport:SetMeter(nCnt)
		if !oReport:Cancel()
			
			// Sub Total por Titulo
			oBreak	:= TRBreak():New(oReport,oSec1:Cell("DOC"),"Total por Titulo")
			oBreak:oFontBody := oFont12B
			oTotTipo1:= TRFunction():New(oSec1:Cell("VLR_PAGTO"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo1:oFontBody := oFont12B			
			oTotTipo2:= TRFunction():New(oSec1:Cell("VLR_REAIS_PAGTO"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo2:oFontBody := oFont12B
			oTotTipo3:= TRFunction():New(oSec1:Cell("VLR_ATIV"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo3:oFontBody := oFont12B
			oTotTipo4:= TRFunction():New(oSec1:Cell("VLR_PASS"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo4:oFontBody := oFont12B
			oTotTipo5:= TRFunction():New(oSec1:Cell("SALDO_ESTRANGEIRA"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo5:oFontBody := oFont12B
			oTotTipo6:= TRFunction():New(oSec1:Cell("SLD_REAIS"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo6:oFontBody := oFont12B
			oTotTipo7:= TRFunction():New(oSec1:Cell("SLD_REAIS_ATU"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo7:oFontBody := oFont12B
						
			// Total Geral do Relatório
			oBreak2 := TRBreak():New( oReport, {|| }, "Total Geral") //"Total Geral"
			oTotGeral:= TRFunction():New(oSec1:Cell("VLR_PAGTO"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotGeral:oFontBody := oFont12B
			oTotGeral2:= TRFunction():New(oSec1:Cell("VLR_REAIS_PAGTO"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotGeral2:oFontBody := oFont12B
			oTotGeral3:= TRFunction():New(oSec1:Cell("VLR_ATIV"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotGeral3:oFontBody := oFont12B
			oTotGeral4:= TRFunction():New(oSec1:Cell("VLR_PASS"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotGeral4:oFontBody := oFont12B
			
			oSec1:Print()
		EndIf
	EndIf
	
	(cAlias)->(dbCloseArea())
	
return

static function prtAReceber(oReport)
	
	local oSec1		:= oReport:Section(1)
	local cAlias	:= GetNextAlias()
	local oBreak	:= Nil
	local oTotTipo	:= Nil	
	local oTotTipo1 := Nil
	local oTotTipo2 := Nil
	local oTotTipo3 := Nil
	local oTotTipo4 := Nil
	local oTotGeral	:= Nil
	local oTotGeral2:= Nil
	local oTotGeral3:= Nil
	local oTotGeral4:= Nil
	local oTotGeral5:= Nil
	local oTotGeral6:= Nil
	local oTotGeral7:= Nil
	local cWhere 	:= "%"
	local cWhereBx 	:= "%"
	local cMoeda 	:= "%"
	
	if MV_PAR05 == "Sim"
		cWhere += "AND E1_SALDO = 0 "
		cWhereBx += "AND E5.E5_DATA BETWEEN '"+ dtos(MV_PAR06) +"' AND '"+ dtos(MV_PAR07) +"' "
	elseif MV_PAR05 == "Não"
		cWhere += "AND E1_SALDO <> 0 "
	endIf
	
	cMoeda += "M2_MOEDA" + alltrim(MV_PAR02) + " "
	
	cWhere += "%" 
	cWhereBx += "%" 
	cMoeda += "%" 
	
	oSec1:BeginQuery()
	
		BeginSql Alias cAlias
			
			%noparser%
			COLUMN EMISSAO AS DATE
			COLUMN DT_PAGTO AS DATE
			
			SELECT A.DOC, A.EMISSAO, 
			       A.VLR_MOEDA_ESTRANGEIRA, 
				   A.DT_PAGTO, A.VLR_REAIS, 
				   A.VLR_REAIS_PAGTO, 
				   A.VLR_REAIS,
				   A.VLR_PAGTO,
				   A.VLR_VAR_CTB, 
				   A.SALDO_ESTRANGEIRA, 
				   A.SLD_REAIS, 
				   A.SLD_REAIS_ATU, 
			       A.TX_CONV_INICIAL, 
				   A.TX_CONVERSAO,
				   CASE WHEN A.VLR_VAR_PAGTO > 0 THEN A.VLR_VAR_PAGTO ELSE 0 END AS VLR_ATIV,
				   CASE WHEN A.VLR_VAR_PAGTO < 0 THEN A.VLR_VAR_PAGTO ELSE 0 END AS VLR_PASS 
			FROM
			(
			SELECT E1_EMISSAO AS EMISSAO,
			       E1_PREFIXO || E5.E5_NUMERO || E5.E5_PARCELA AS DOC,
			       E1_VALOR AS VLR_MOEDA_ESTRANGEIRA,
			       %exp:cMoeda% AS TX_CONV_INICIAL,
			       E1_VALOR * %exp:cMoeda% AS VLR_REAIS,
				  CASE WHEN E5.E5_TIPODOC = 'CM' THEN E5.E5_DATA ELSE '' END AS DT_PAGTO,
				  CASE WHEN E5.E5_TIPODOC = 'CM' THEN E5.E5_VALOR ELSE 0 END AS VLR_PAGTO,
				  CASE WHEN E5.E5_TIPODOC = 'CM' THEN E5.E5_TXMOEDA ELSE 0 END AS TX_CONVERSAO,
				  CASE WHEN E5.E5_TIPODOC = 'VM' THEN E5.E5_VALOR ELSE 0 END AS VLR_VAR_CTB,
				  
				  CASE WHEN  E5.E5_TIPODOC = 'CM' AND NVL((SELECT E5B.E5_VALOR 
				  											 FROM %TABLE:SE5% E5B 
				  											WHERE E5B.E5_FILIAL = E5.E5_FILIAL 
				  											  AND E5B.D_E_L_E_T_ = ' ' 
				  											  AND E5B.E5_DATA < E5.E5_DATA 
				  											  AND E5B.E5_NUMERO = E5.E5_NUMERO 
				  											  AND E5B.E5_PREFIXO = E5.E5_PREFIXO
				  											  AND E5B.E5_TIPO = E5.E5_TIPO 
															  AND E5B.E5_PARCELA = E5.E5_PARCELA 
															  AND E5B.E5_CLIFOR = E5.E5_CLIFOR 
															  AND E5B.E5_LOJA = E5.E5_LOJA 
				  											  AND E5B.E5_TIPODOC = 'CM'),0) > 0
          				THEN (SELECT (E5B.E5_VLMOED2 * %exp:cMoeda%) - E5B.E5_VALOR 
          						FROM %TABLE:SE5% E5B 
          					   WHERE E5B.E5_FILIAL = E5.E5_FILIAL 
          					     AND E5B.D_E_L_E_T_ = ' ' 
          					     AND E5B.E5_DATA = E5.E5_DATA 
          					     AND E5B.E5_NUMERO = E5.E5_NUMERO 
          					     AND E5B.E5_PREFIXO = E5.E5_PREFIXO 
          					     AND E5B.E5_TIPO = E5.E5_TIPO 
							  AND E5B.E5_PARCELA = E5.E5_PARCELA 
							  AND E5B.E5_CLIFOR = E5.E5_CLIFOR 
							  AND E5B.E5_LOJA = E5.E5_LOJA 
          					     AND E5B.E5_TIPODOC = 'VL') 
					 WHEN E5.E5_TIPODOC = 'CM' AND NVL((SELECT E5B.E5_VALOR 
					 									  FROM %TABLE:SE5% E5B 
					 									 WHERE E5B.E5_FILIAL = E5.E5_FILIAL 
					 									   AND E5B.D_E_L_E_T_ = ' ' 
					 									   AND E5B.E5_DATA < E5.E5_DATA 
					 									   AND E5B.E5_NUMERO = E5.E5_NUMERO 
					 									   AND E5B.E5_PREFIXO = E5.E5_PREFIXO
					 									   AND E5B.E5_TIPO = E5.E5_TIPO 
															  AND E5B.E5_PARCELA = E5.E5_PARCELA 
															  AND E5B.E5_CLIFOR = E5.E5_CLIFOR 
															  AND E5B.E5_LOJA = E5.E5_LOJA 
					 									   AND E5B.E5_TIPODOC = 'CM'),0) = 0
          				THEN NVL((SELECT E5B.E5_VALOR 
          				            FROM %TABLE:SE5% E5B 
          				           WHERE E5B.E5_FILIAL = E5.E5_FILIAL 
          				             AND E5B.D_E_L_E_T_ = ' ' 
          				             AND E5B.E5_DATA = E5.E5_DATA 
          				             AND E5B.E5_NUMERO = E5.E5_NUMERO 
          				             AND E5B.E5_PREFIXO = E5.E5_PREFIXO 
          				             AND E5B.E5_TIPO = E5.E5_TIPO 
									  AND E5B.E5_PARCELA = E5.E5_PARCELA 
									  AND E5B.E5_CLIFOR = E5.E5_CLIFOR 
									  AND E5B.E5_LOJA = E5.E5_LOJA 
          				             AND E5B.E5_TIPODOC = 'VL') - (E1_VALOR * %exp:cMoeda%),0) 
					ELSE 0 END  AS VLR_VAR_PAGTO,
  
				  CASE WHEN E5.E5_TIPODOC = 'VL' THEN E5.E5_VALOR ELSE 0 END AS VLR_REAIS_PAGTO,
				  CASE WHEN E5.E5_TIPODOC = 'VM' THEN E1_SALDO ELSE 0 END AS SALDO_ESTRANGEIRA,
				  CASE WHEN E5.E5_TIPODOC = 'VM' THEN E1_SALDO * %exp:cMoeda% ELSE 0 END AS SLD_REAIS,
				  (CASE WHEN E5.E5_TIPODOC = 'VM' THEN E1_SALDO * %exp:cMoeda% ELSE 0 END) + (CASE WHEN E5.E5_TIPODOC = 'VM' THEN E5.E5_VALOR ELSE 0 END) AS SLD_REAIS_ATU
				  FROM %TABLE:SE5% E5
				       INNER JOIN %TABLE:SE1% E1
				               ON E1_FILIAL = E5.E5_FILIAL
						  	  %EXP:cWhere%
							  AND E1_PREFIXO = E5.E5_PREFIXO
				              AND E1_NUM = E5.E5_NUMERO
							  AND E1_PARCELA = E5.E5_PARCELA
							  AND E1_TIPO = E5.E5_TIPO
							  AND E1_CLIENTE = E5.E5_CLIFOR
							  AND E1_LOJA = E5.E5_LOJA
							  AND E1_EMISSAO BETWEEN %EXP:DTOS(MV_PAR03)% AND %EXP:DTOS(MV_PAR04)%
							  AND E1_MOEDA = %EXP:MV_PAR02%
							  AND E1.D_E_L_E_T_ = ' '
					    INNER JOIN %TABLE:SM2% M2 
							    ON M2_DATA = E1_EMISSAO
							   AND M2.D_E_L_E_T_ = ' '
				 WHERE E5.E5_FILIAL = %XFILIAL:SE5%
				   AND E5.E5_RECPAG = 'R'
				   AND E5.E5_CLIFOR BETWEEN %EXP:MV_PAR08% AND %EXP:MV_PAR10%
				   AND E5.E5_LOJA BETWEEN %EXP:MV_PAR09% AND %EXP:MV_PAR11%
				   AND E5.D_E_L_E_T_ = ' ') A
		EndSql
	oSec1:EndQuery()
	
	//Aviso("Atenção", getLastQuery()[2], {"OK"}, 3, FunDesc())
	
	Count to nCnt
	(cAlias)->(dbGoTop())
	if !(nCnt > 0)
		MsgAlert("Não há dados para os parâmetros informados!")
		oReport:CancelPrint()
	else
		oReport:SetMeter(nCnt)
		if !oReport:Cancel()
			
			// Sub Total por Titulo
			oBreak	:= TRBreak():New(oReport,oSec1:Cell("DOC"),"Total por Titulo")
			oBreak:oFontBody := oFont12B
			oTotTipo1:= TRFunction():New(oSec1:Cell("VLR_PAGTO"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo1:oFontBody := oFont12B			
			oTotTipo2:= TRFunction():New(oSec1:Cell("VLR_REAIS_PAGTO"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo2:oFontBody := oFont12B
			oTotTipo3:= TRFunction():New(oSec1:Cell("VLR_ATIV"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo3:oFontBody := oFont12B
			oTotTipo4:= TRFunction():New(oSec1:Cell("VLR_PASS"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo4:oFontBody := oFont12B
			oTotTipo5:= TRFunction():New(oSec1:Cell("SALDO_ESTRANGEIRA"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo5:oFontBody := oFont12B
			oTotTipo6:= TRFunction():New(oSec1:Cell("SLD_REAIS"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo6:oFontBody := oFont12B
			oTotTipo7:= TRFunction():New(oSec1:Cell("SLD_REAIS_ATU"),NIL,"SUM",oBreak,"Total por Titulo",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotTipo7:oFontBody := oFont12B
			
			// Total Geral do Relatório
			oBreak2 := TRBreak():New( oReport, {|| }, "Total Geral") //"Total Geral"
			oTotGeral:= TRFunction():New(oSec1:Cell("VLR_PAGTO"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotGeral:oFontBody := oFont12B
			oTotGeral2:= TRFunction():New(oSec1:Cell("VLR_REAIS_PAGTO"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotGeral2:oFontBody := oFont12B
			oTotGeral3:= TRFunction():New(oSec1:Cell("VLR_ATIV"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotGeral3:oFontBody := oFont12B
			oTotGeral4:= TRFunction():New(oSec1:Cell("VLR_PASS"),NIL,"SUM",oBreak2,"Total Geral",PesqPict("SE2","E2_VALOR"),NIL,.F.,.F.)
			oTotGeral4:oFontBody := oFont12B
			
			oSec1:Print()
		EndIf
	EndIf
	
	(cAlias)->(dbCloseArea())
	
return

static function perg()
	
	local aParBox 	:= {}
	local cPerg		:= "Relatório de Variação Cambial"
	local aTitBx	:= {"Sim","Não"}
	local aRecPag	:= {"A receber","A pagar"}
	local aMoedas	:= strtokarr(SUPERGETMV("MV_ZZMDVC",,"4"),"/")
	
	aAdd(aParBox,{2,"Carteira", "A receber", aRecPag, 50, ".F.",	.F.}) 									// MV_PAR01
	
	aAdd(aParBox,{2,"Moeda", "4", aMoedas, 50, ".F.",	.F.}) 												// MV_PAR02
	
	aAdd(aParBox,{1,"Emissão de"		,STOD(""),	"",	"",	""	,	"",	 50, .f.})							// MV_PAR03
	aAdd(aParBox,{1,"Emissão Até"		,STOD(""),	"",	"",	""	,	"",	 50, .f.})							// MV_PAR04
	
	aAdd(aParBox,{2,"Considera Títulos baixados", "Sim", aTitBx, 50, ".F.",	.F.}) 							// MV_PAR05
	
	aAdd(aParBox,{1,"Data da Baixa de"	,STOD(""),	"",	"",	""	,	"MV_PAR05=='Sim'", 50, .f.})				// MV_PAR06
	aAdd(aParBox,{1,"Data da Baixa Até"	,STOD(""),	"",	"",	""	,	"MV_PAR05=='Sim'", 50, .f.})				// MV_PAR07
	
	aAdd(aParBox,{1,"Fornecedor De"	,space(TamSX3("A2_COD")[1]),	"",	"",	"SA2",	"alltrim(MV_PAR01)=='A pagar'", 50, .f.})// MV_PAR08
	aAdd(aParBox,{1,"Loja De"		,space(TamSX3("A2_LOJA")[1]),	"",	"",	"",		"alltrim(MV_PAR01)=='A pagar'", 02, .f.})// MV_PAR09
	aAdd(aParBox,{1,"Fornecedor Até",space(TamSX3("A2_COD")[1]),	"",	"",	"SA2",	"alltrim(MV_PAR01)=='A pagar'", 50, .f.})// MV_PAR10
	aAdd(aParBox,{1,"Loja Até"		,space(TamSX3("A2_LOJA")[1]),	"",	"",	"",		"alltrim(MV_PAR01)=='A pagar'", 02, .f.})// MV_PAR11
		
	aAdd(aParBox,{1,"Cliente De"	,space(TamSX3("A1_COD")[1]),	"",	"",	"SA1",	"alltrim(MV_PAR01)=='A receber'", 50, .f.})// MV_PAR12
	aAdd(aParBox,{1,"Loja De"		,space(TamSX3("A1_LOJA")[1]),	"",	"",	"",		"alltrim(MV_PAR01)=='A receber'", 02, .f.})// MV_PAR13
	aAdd(aParBox,{1,"Cliente Até"	,space(TamSX3("A1_COD")[1]),	"",	"",	"SA1",	"alltrim(MV_PAR01)=='A receber'", 50, .f.})// MV_PAR14
	aAdd(aParBox,{1,"Cliente Até"	,space(TamSX3("A1_LOJA")[1]),	"",	"",	"",		"alltrim(MV_PAR01)=='A receber'", 02, .f.})// MV_PAR15
	
return ParamBox(aParBox,"Relatorio Variacao Cambial",,,,,,,,cPerg,.T.,.T.)
