#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOPCONN.ch'

user function retornaValor(cProduto,cCampo) 

local cQuery := "" 
local cAlias := getNextAlias() 
local aArea := getArea()
local xValor := CTOD("//")        

//cQuery := "select QUANTIDADE, PREVISAO from ESTOQUE where CODIGO = '"+cProduto+"' and STATUS = 'TRANSITO' " + CRLF   

if cCampo <> "MEMO"
	cQuery += "select B1_COD AS [CODIGO], B1_DESC AS [DESCRICAO], sum(C7_QUANT) AS [QUANTIDADE],W7_HAWB AS [PROCESSO], C7_PO_EIC[PO NUM], C1_OBS, W6_VIA_TRA [TRANSPORTE], " + CRLF   
	cQuery += "case C7_FILIAL  " + CRLF   
	cQuery += "when '0101' then 'TRANSITO' " + CRLF   
	cQuery += "end as [STATUS], W6_PRVENTR AS [PREVISAO], C7_CONTROL AS [RESERVA], C7_CONTROL AS [QTD EM PEDIDO], C7_CONTROL AS [SAL PED], C7_CONTROL AS [EST SEG]
	cQuery += "from SC7010, SB1010 , SW7010, SW6010, SC1010 " + CRLF   
	cQuery += "where 1=1  " + CRLF   
	cQuery += "and SC7010.D_E_L_E_T_ = '' " + CRLF   
	cQuery += "and SW7010.D_E_L_E_T_ = '' " + CRLF   
	cQuery += "and SB1010.D_E_L_E_T_ = '' " + CRLF   
	cQuery += "and SW6010.D_E_L_E_T_ = '' " + CRLF   
	cQuery += "and C7_LOCAL = '01' " + CRLF   
	cQuery += "and C7_QUJE = 0 " + CRLF   
	cQuery += "and C7_QTDACLA = 0 " + CRLF   
	cQuery += "and C7_RESIDUO = '' " + CRLF   
	cQuery += "and C7_CONTRA = '' " + CRLF   
	cQuery += "and C7_PRODUTO = B1_COD  " + CRLF   
	cQuery += "and C7_NUM = W7_PO_NUM " + CRLF   
	cQuery += "and W7_HAWB = W6_HAWB " + CRLF   
	cQuery += "and C7_ITEM = W7_POSICAO " + CRLF   
	cQuery += "and W6_DT_EMB <> '' " + CRLF   
	cQuery += "and W6_TIPODES <> '02' " + CRLF   
	cQuery += "and C7_NUMSC = C1_NUM " + CRLF   
	cQuery += "and C7_ITEMSC = C1_ITEM " + CRLF   
	cQuery += "and SC1010.D_E_L_E_T_ = '' " + CRLF   
	cQuery += "and W6_DT_ENTR = '' and B1_COD = '"+cProduto+"' " + CRLF   
	cQuery += "group by B1_COD, B1_DESC, W7_HAWB,C7_PO_EIC,C1_OBS,W6_VIA_TRA,C7_FILIAL,W6_PRVENTR,C7_CONTROL,C7_CONTROL,C7_CONTROL,C7_CONTROL " + CRLF       
	
	
	tcQuery cQuery NEW Alias &cAlias 
	
	if (cAlias)->(!eof()) 
		//antigo//nQuantidade := (cAlias)->QUANTIDADE 
		xValor :=(cAlias)->(&cCampo)
	endif         

endif
	
if cCampo == "MEMO"                

	cQuery += "select CONCAT(' [ ', C7_PO_EIC, ' - ', C7_QUANT, ' - ', (SUBSTRING(W6_PRVENTR, 7, 2) + '/' + SUBSTRING(W6_PRVENTR, 5, 2) + '/' + SUBSTRING(W6_PRVENTR, 1, 4)), ' ] ') AS [MEMO], B1_COD AS [CODIGO] " + CRLF   
	cQuery += "from SC7010, SB1010 , SW7010, SW6010, SC1010 " + CRLF   
	cQuery += "where 1=1  " + CRLF   
	cQuery += "and SC7010.D_E_L_E_T_ = '' " + CRLF   
	cQuery += "and SW7010.D_E_L_E_T_ = '' " + CRLF   
	cQuery += "and SB1010.D_E_L_E_T_ = '' " + CRLF   
	cQuery += "and SW6010.D_E_L_E_T_ = '' " + CRLF   
	cQuery += "and C7_LOCAL = '01' " + CRLF   
	cQuery += "and C7_QUJE = 0 " + CRLF   
	cQuery += "and C7_QTDACLA = 0 " + CRLF   
	cQuery += "and C7_RESIDUO = '' " + CRLF   
	cQuery += "and C7_CONTRA = '' " + CRLF   
	cQuery += "and C7_PRODUTO = B1_COD  " + CRLF   
	cQuery += "and C7_NUM = W7_PO_NUM " + CRLF   
	cQuery += "and W7_HAWB = W6_HAWB " + CRLF         
	cQuery += "and C7_ITEM = W7_POSICAO " + CRLF   
	cQuery += "and W6_DT_EMB <> '' " + CRLF   
	cQuery += "and W6_TIPODES <> '02' " + CRLF   
	cQuery += "and C7_NUMSC = C1_NUM " + CRLF   
	cQuery += "and C7_ITEMSC = C1_ITEM " + CRLF   
	cQuery += "and SC1010.D_E_L_E_T_ = '' " + CRLF   
	cQuery += "and W6_DT_ENTR = '' and B1_COD = '"+cProduto+"' " + CRLF   

	tcQuery cQuery NEW Alias &cAlias 
	xValor := ""  

	While !(cAlias)->(Eof())
		xValor +=(cAlias)->(&cCampo)			
		(cAlias)->(dbSkip())
		Loop
	EndDo

endif



//tcQuery cQuery NEW Alias &cAlias 

//if (cAlias)->(!eof()) 
	//antigo//nQuantidade := (cAlias)->QUANTIDADE 
//	xValor :=(cAlias)->(&cCampo)
//endif
                                   
(cAlias)->(dbCloseArea())     //novo 

restArea(aArea) 
return xValor