#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOPCONN.ch'

user function retornaValor(cProduto,cCampo,cProcesso,cPadrao) 

local cQuery := "" 
local cAlias := getNextAlias() 
local aArea := getArea()
local xValor := cPadrao    

if cProcesso == "ET"
	//MsgAlert("Analisando em Entreposto") 
	if cCampo <> "MEMO"     
	
		//MsgAlert("Somando quantidade e trazendo a data em Entreposto") 
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
		cQuery += "and W6_TIPODES = '02' " + CRLF   
		cQuery += "and C7_NUMSC = C1_NUM " + CRLF   
		cQuery += "and C7_ITEMSC = C1_ITEM " + CRLF   
		cQuery += "and SC1010.D_E_L_E_T_ = '' " + CRLF   
		cQuery += "and W6_DT_ENTR = '' and B1_COD = '"+cProduto+"' " + CRLF   
		cQuery += "group by B1_COD, B1_DESC, W7_HAWB,C7_PO_EIC,C1_OBS,W6_VIA_TRA,C7_FILIAL,W6_PRVENTR,C7_CONTROL,C7_CONTROL,C7_CONTROL,C7_CONTROL " + CRLF       
		
		tcQuery cQuery NEW Alias &cAlias 
		
		if (cAlias)->(!eof()) 
			xValor :=(cAlias)->(&cCampo)
		endif    
	
	
	end if
	if cCampo == "MEMO"  
	
	
			//MsgAlert("Detalhando em transito")
			cQuery += "select CONCAT(' [ ', C7_PO_EIC, ' - ', C7_QUANT, '       - ', (SUBSTRING(W6_PRVENTR, 7, 2) + '/' + SUBSTRING(W6_PRVENTR, 5, 2) + '/' + SUBSTRING(W6_PRVENTR, 1, 4)), ' ] ') AS [MEMO], B1_COD AS [CODIGO] " + CRLF   
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
			cQuery += "and W6_TIPODES = '02' " + CRLF   
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
	
	
	
	
	
	end if	
endif

if cProcesso == "EST"
	//MsgAlert("Analisando Estoque") 
      
	if cCampo <> "MEMO"

		cQuery += "select B2_COD AS [CODIGO], B1_DESC AS [DESCRICAO], B2_QATU AS [QUANTIDADE], B2_LOCALIZ AS [LOCALIZ], B2_DINVFIM AS [VAZIO], B2_DINVFIM AS [VAZIO], B2_DINVFIM AS [VAZIO2]," + CRLF    
		cQuery += "case B2_FILIAL" + CRLF    
		cQuery += "	when '0101' then 'ESTOQUE'" + CRLF    
		cQuery += "end as [STATUS], B2_DINVFIM AS [VAZIO3], B2_RESERVA, B2_QPEDVEN, B2_SALPEDI, B1_ESTSEG" + CRLF    
		cQuery += "from SB2010, SB1010" + CRLF    
		cQuery += "where 1=1" + CRLF    
		cQuery += "and SB2010.D_E_L_E_T_ = ''" + CRLF    
		cQuery += "and SB1010.D_E_L_E_T_ = ''" + CRLF    
		cQuery += "and B2_COD = B1_COD" + CRLF    
		cQuery += "and B2_LOCAL in ('01', '04')" + CRLF    
		cQuery += "and B2_QATU > 0  and B1_COD = '"+cProduto+"'" + CRLF    
	
	
			tcQuery cQuery NEW Alias &cAlias 
			
			if (cAlias)->(!eof()) 
				xValor :=(cAlias)->(&cCampo)
			endif     

	endif
	
	if cCampo == "MEMO"   
	
	
		cQuery += "select B2_COD AS [CODIGO], B2_QATU AS [QUANTIDADE]," + CRLF      
		cQuery += "CONCAT(' [ ', 'RESERVA:', B2_RESERVA, ' | ', 'Q PED VEN:',B2_QPEDVEN, ' | ', 'SAL PED:', B2_SALPEDI, ' | ', 'EST SEG:',B1_ESTSEG, ' ] ') AS [MEMO]" + CRLF    
		cQuery += "from SB2010, SB1010" + CRLF    
		cQuery += "where 1=1" + CRLF    
		cQuery += "and SB2010.D_E_L_E_T_ = ''" + CRLF    
		cQuery += "and SB1010.D_E_L_E_T_ = ''" + CRLF    
		cQuery += "and B2_COD = B1_COD" + CRLF    
		cQuery += "and B2_LOCAL in ('01', '04')" + CRLF    
		cQuery += "and B2_QATU > 0  and B1_COD = '"+cProduto+"'" + CRLF    
	


			tcQuery cQuery NEW Alias &cAlias 
			xValor := ""  
		
			While !(cAlias)->(Eof())
				xValor +=(cAlias)->(&cCampo)			
				(cAlias)->(dbSkip())
				Loop
			EndDo    

	endif	
	
endif


if cProcesso == "P"
	//MsgAlert("Analisando Pedido") 

	if cCampo <> "MEMO"            
	
		cQuery += "select B1_COD AS [CODIGO], SUM(C7_QUANT) AS [QUANTIDADE]" + CRLF     
		cQuery += "from SC7010, SB1010, SC1010" + CRLF    
		cQuery += "where 1=1" + CRLF    
		cQuery += "and SC7010.D_E_L_E_T_ = ''" + CRLF    
		cQuery += "and SB1010.D_E_L_E_T_ = ''" + CRLF    
		cQuery += "and C7_LOCAL = '01'" + CRLF    
		cQuery += "and C7_QUJE = 0" + CRLF    
		cQuery += "and C7_QTDACLA = 0" + CRLF    
		cQuery += "and C7_RESIDUO = ''" + CRLF    
		cQuery += "and C7_CONTRA = ''" + CRLF    
		cQuery += "and C7_PRODUTO = B1_COD" + CRLF    
		cQuery += "and C7_NUMSC = C1_NUM" + CRLF    
		cQuery += "and C7_ITEMSC = C1_ITEM" + CRLF    
		cQuery += "and SC1010.D_E_L_E_T_ = ''  and B1_COD = '"+cProduto+"'" + CRLF    
		cQuery += "and C7_PO_EIC NOT IN (select W7_PO_NUM from SW7010 where SW7010.D_E_L_E_T_ = '' )" + CRLF          
		cQuery += "group by B1_COD" + CRLF   
		
				tcQuery cQuery NEW Alias &cAlias 
			
			if (cAlias)->(!eof()) 
				xValor :=(cAlias)->(&cCampo)
			endif     
                   
	endif
	
	if cCampo == "MEMO"

		cQuery += "select B1_COD AS [CODIGO], C7_QUANT AS [QUANTIDADE], C7_PO_EIC AS [PO NUM], C1_OBS, C1_UNIDREQ AS [TRANSPORTE], " + CRLF 
		cQuery += "CONCAT(' [ ', 'NUM PO:', C7_PO_EIC, ' | ', 'SOL OBS:',C1_OBS, ' | ', 'UNID REQ:', C1_UNIDREQ, ' ]                                               ') AS [MEMO]" + CRLF       
		cQuery += "from SC7010, SB1010, SC1010" + CRLF    
		cQuery += "where 1=1" + CRLF    
		cQuery += "and SC7010.D_E_L_E_T_ = ''" + CRLF    
		cQuery += "and SB1010.D_E_L_E_T_ = ''" + CRLF    
		cQuery += "and C7_LOCAL = '01'" + CRLF    
		cQuery += "and C7_QUJE = 0" + CRLF    
		cQuery += "and C7_QTDACLA = 0" + CRLF    
		cQuery += "and C7_RESIDUO = ''" + CRLF    
		cQuery += "and C7_CONTRA = ''" + CRLF    
		cQuery += "and C7_PRODUTO = B1_COD" + CRLF    
		cQuery += "and C7_NUMSC = C1_NUM" + CRLF    
		cQuery += "and C7_ITEMSC = C1_ITEM" + CRLF    
		cQuery += "and SC1010.D_E_L_E_T_ = ''  and B1_COD = '"+cProduto+"'" + CRLF    
		cQuery += "and C7_PO_EIC NOT IN (select W7_PO_NUM from SW7010 where SW7010.D_E_L_E_T_ = '' )" + CRLF 
    
			tcQuery cQuery NEW Alias &cAlias 
			xValor := ""  
		
			While !(cAlias)->(Eof())
				xValor +=(cAlias)->(&cCampo)			
				(cAlias)->(dbSkip())
				Loop
			EndDo    

	endif	


endif


if cProcesso == "T"
	//MsgAlert("Analisando em Transito") 
	if cCampo <> "MEMO"
		//MsgAlert("Somando quantidade e trazendo a data em transito") 
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
			xValor :=(cAlias)->(&cCampo)
		endif         	
	endif
		
	if cCampo == "MEMO"                
		//MsgAlert("Detalhando em transito")
		cQuery += "select CONCAT(' [ ', C7_PO_EIC, ' - ', C7_QUANT, '       - ', (SUBSTRING(W6_PRVENTR, 7, 2) + '/' + SUBSTRING(W6_PRVENTR, 5, 2) + '/' + SUBSTRING(W6_PRVENTR, 1, 4)), ' ] ') AS [MEMO], B1_COD AS [CODIGO] " + CRLF   
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

endif                  


if cProcesso == "E"
	//MsgAlert("Analisando em EMBARQUE")
	if cCampo <> "MEMO"
		//MsgAlert("Somando quantidade e trazendo a data em EMBARQUE") 
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
		cQuery += "and W6_DT_EMB = '' " + CRLF   
		cQuery += "and W6_TIPODES <> '02' " + CRLF   
		cQuery += "and C7_NUMSC = C1_NUM " + CRLF   
		cQuery += "and C7_ITEMSC = C1_ITEM " + CRLF   
		cQuery += "and SC1010.D_E_L_E_T_ = '' " + CRLF   
		cQuery += "and W6_DT_ENTR = '' and B1_COD = '"+cProduto+"' " + CRLF   
		cQuery += "group by B1_COD, B1_DESC, W7_HAWB,C7_PO_EIC,C1_OBS,W6_VIA_TRA,C7_FILIAL,W6_PRVENTR,C7_CONTROL,C7_CONTROL,C7_CONTROL,C7_CONTROL " + CRLF       
		
		tcQuery cQuery NEW Alias &cAlias 
		
		if (cAlias)->(!eof()) 
			xValor :=(cAlias)->(&cCampo)
		endif         
	endif
		
	if cCampo == "MEMO"                
		//MsgAlert("Detalhando em EMBARQUE")
		cQuery += "select CONCAT(' [ ', C7_PO_EIC, ' - ', C7_QUANT, '       - ', (SUBSTRING(W6_PRVENTR, 7, 2) + '/' + SUBSTRING(W6_PRVENTR, 5, 2) + '/' + SUBSTRING(W6_PRVENTR, 1, 4)), ' ] ', '                                                   ') AS [MEMO], B1_COD AS [CODIGO] " + CRLF   
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
		cQuery += "and W6_DT_EMB = '' " + CRLF   
		cQuery += "and W6_TIPODES <> '02' " + CRLF   
		cQuery += "and C7_NUMSC = C1_NUM " + CRLF   
		cQuery += "and C7_ITEMSC = C1_ITEM " + CRLF   
		cQuery += "and SC1010.D_E_L_E_T_ = '' " + CRLF   
		cQuery += "and W6_DT_ENTR = '' and B1_COD = '"+cProduto+"' " + CRLF   
	
		tcQuery cQuery NEW Alias &cAlias 
		xValor := ""  
	
		While !(cAlias)->(Eof())  
			//MsgAlert("Tem PO")
			xValor +=(cAlias)->(&cCampo)			
			(cAlias)->(dbSkip())
			Loop
		EndDo
	endif
endif
                                   
(cAlias)->(dbCloseArea())

restArea(aArea) 

return xValor