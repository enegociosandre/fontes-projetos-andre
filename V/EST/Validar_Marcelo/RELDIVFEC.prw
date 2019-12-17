#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "MsObjects.ch"    

&& Desenvolvido por João Gustavo Orsi.
&& Específico para ambiente COSAN (distribuidores).

&& Relatório para verificar 
&& B2_QFIM < 0
&& B2_VFIM1 < 0 
&& B2_QFIM = 0 e B2_VFIM1 <> 0
&& B2_QFIM <> 0 e B2_VFIM1 = 0  
&& Após o recálculo do custo médio.

User Function RelDivFec() && U_RELDIVFEC()
*************************

&& Declaração de variaveis
Private oReport
Private oSectCab
Private cNomeRel	:= FunName()
Private cTitulo		:= "Relatorio divergencias do fechamento"
Private cDescrRel	:= "Este relatorio tem por funcao eliminar a necessidade de realizar as consultas referentes ao processo de fechamento, minimizando todas elas em um unico relatorio que pode ser gerado em EXCEL."
Private cAlias		:= ""
Private cCodigo		:= ""

&& Criacao do objeto TReports
oReport := TReport():new(cNomeRel, cTitulo, " " , { || ProcRel() }, cDescrRel)

oReport:SetPortrait()

&& Define o Titulo do Relatorio
oReport:SetTitle(cTitulo)

&& Dialogo do TReport
oReport:PrintDialog()

Return

&& Funcao de impressao do relatorio
Static Function ProcRel()
*************************

&& Declaração de variaveis
Local nRegs		:= 0
Local cAlias	:= ""
Local cCodigo	:= ""

&& Seleciona os Registros para Impressao
cAlias := QryRegs()   

&& Cabecalho
oSectCab := TRSection():new(oReport, cTitulo)
TRCell():new(oSectCab, "FILIAL", 	cAlias, "Filial", 		PesqPict("SB2","B2_FILIAL", ), 	TAMSX3("B2_FILIAL")[1],	/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():new(oSectCab, "CODIGO", 	cAlias, "Codigo", 		PesqPict("SB2","B2_COD", ), 	TAMSX3("B2_COD")[1],	/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():new(oSectCab, "DESCRICAO", cAlias, "Descricao", 	PesqPict("SB1","B1_DESC", ), 	TAMSX3("B1_DESC")[1],	/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():new(oSectCab, "TIPO", 		cAlias, "Tipo", 		PesqPict("SB1","B1_TIPO", ), 	TAMSX3("B1_TIPO")[1],	/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():new(oSectCab, "ARMAZEM", 	cAlias, "Armazem", 		PesqPict("SB2","B2_LOCAL", ), 	TAMSX3("B2_LOCAL")[1],	/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():new(oSectCab, "QNTFIM", 	cAlias, "Quant Final", 	PesqPict("SB2","B2_QFIM", ), 	TAMSX3("B2_QFIM")[1],	/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():new(oSectCab, "VALFIM", 	cAlias, "Valor Final", 	PesqPict("SB2","B2_VFIM1", ), 	TAMSX3("B2_VFIM1")[1],	/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():new(oSectCab, "CUSMED", 	cAlias, "Custo Medio", 	PesqPict("SB2","B2_CM1", ), 	TAMSX3("B2_CM1")[1],	/*lPixel*/,/*{|| code-block de impressao }*/)         

&& Contagem dos Registros a serem Impressos
DbSelectArea(cAlias)
Count to nRegs
oReport:SetMeter(nRegs)

&& Impressao dos Registros
(cAlias)->(DbGoTop())
While !(cAlias)->(EOF())
	&& Salva para tratar a Quebra
	cCodigo := (cAlias)
	&& Impressao dos dados
	oSectCab:Init()
	oSectCab:PrintLine()
	(cAlias)->(DbSkip())
EndDo
oSectCab:Finish()

(cAlias)->(DbCloseArea())

Return

&& Funcao de montagem e execucao da query
Static Function QryRegs()  
*************************

Local cAlias := GetNextAlias()

&& Montagem da Query
BeginSql Alias cAlias
	SELECT 	B2_FILIAL FILIAL, 
			B2_COD CODIGO, 
			B1_DESC DESCRICAO,
			B1_TIPO TIPO, 
			B2_LOCAL ARMAZEM, 
			B2_QFIM QNTFIM, 
			B2_VFIM1 VALFIM, 
			B2_CM1 CUSMED 
	FROM %table:SB2% SB2
	INNER JOIN %table:SB1% SB1
		ON 	B1_FILIAL = %xFilial:SB1% AND 
			B1_COD = B2_COD AND 
			SUBSTRING(B1_COD,1,3) <> 'MOD' AND SB1.%NotDel%
	WHERE 	B2_FILIAL = %xFilial:SB2% AND 
			((B2_QFIM < 0 OR B2_VFIM1 < 0) OR 
			(B2_QFIM = 0 AND B2_VFIM1 <> 0) OR 
			(B2_QFIM <> 0 AND B2_VFIM1 = 0)) AND 
			SB2.%NotDel%
	ORDER BY B2_LOCAL, B2_COD 	
EndSql

Return(cAlias)