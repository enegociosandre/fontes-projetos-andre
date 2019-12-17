#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} ApoioNFsVal
Classe de Apoio para Geração de Nota Fiscal de Serviço de Valinhos
@author Thiago Meschiatti
@since 23/11/2015
@version 1.0
/*/
class ApoioNFsVal

	data cArqDir
	data cNomeArq
	data aRet
	data cNfDe  
	data cNfAte 
	data cSerDe 
	data cSerAte
	data dEmiDe 
	data dEmiAte
	data nNfTot
	data aRegsNF

	method NewApoioNFsVal() CONSTRUCTOR
	
	method setNfDe(cNfDe) 
	method getNfDe() 
	
	method setNfAte(cNfAte) 
	method getNfAte() 
	
	method setSerDe(cSerDe) 
	method getSerDe() 
	
	method setSerAte(cSerAte) 
	method getSerAte() 
	
	method setEmiDe(dEmiDe) 
	method getEmiDe() 

	method setEmiAte(dEmiAte) 
	method getEmiAte() 
	
	method setArqDir(cArqDir)
	method getArqDir() 
	
	method setTotRegs(nNfTot) 
	method getTotRegs() 
	
	method setNomeArq(cNomeArq) 
	method getNomeArq() 
	
	method getParamBox(nPos) 
	method addRegNFs() 
	method gravArq() 
	method CriaPerg(cPerg)
	method buscNf()
	
endclass

method setNfDe(cNfDe) class ApoioNFsVal
	::cNfDe := cNfDe
return

method getNfDe() class ApoioNFsVal
return ::cNfDe

method setNfAte(cNfAte) class ApoioNFsVal
	::cNfAte := cNfAte
return

method getNfAte() class ApoioNFsVal
return ::cNfAte	

method setSerDe(cSerDe) class ApoioNFsVal
	::cSerDe := cSerDe
return

method getSerDe() class ApoioNFsVal
return ::cSerDe

method setSerAte(cSerAte) class ApoioNFsVal
	::cSerAte := cSerAte
return

method getSerAte() class ApoioNFsVal
return ::cSerAte

method setEmiDe(dEmiDe) class ApoioNFsVal
	::dEmiDe := dEmiDe
return dEmiDe

method getEmiDe() class ApoioNFsVal
return ::dEmiDe

method setEmiAte(dEmiAte) class ApoioNFsVal
	::dEmiAte := dEmiAte
return

method getEmiAte() class ApoioNFsVal
return ::dEmiAte

method setArqDir(cArqDir) class ApoioNFsVal
	::cArqDir := cArqDir
return

method getArqDir() class ApoioNFsVal
return ::cArqDir

method getParamBox(nPos) class ApoioNFsVal
return ::aRet[nPos]

method setTotRegs(nNfTot) class ApoioNFsVal
	::nNfTot := nNfTot
return

method getTotRegs() class ApoioNFsVal
return ::nNfTot

method setNomeArq(cNomeArq) class ApoioNFsVal
	::cNomeArq := cNomeArq
return

method getNomeArq() class ApoioNFsVal
return ::cNomeArq

/*/{Protheus.doc} NewApoioNFsVal
Construtor
@author Thiago Meschiatti
@since 23/11/2015
@version 1.0
/*/
method NewApoioNFsVal() class ApoioNFsVal
	::aRet 	:= {}
	::aRegsNF := {}
	::setArqDir("")
	::setNfDe("")
	::setNfAte("")
	::setSerDe("")
	::setSerAte("")
	::setEmiDe("")
	::setEmiAte("")
Return



/*/{Protheus.doc} CriaPerg
Criação de Parambox
@author Thiago Meschiatti
@since 23/11/2015
@version 1.0
@param cPerg, character, Nome da Pergunta
/*/
method CriaPerg(cPerg) class ApoioNFsVal

	local aHelp			:= Array(9,1)
	local aRegs 		:= {}
	local nI 			:= 0
	local nJ 			:= 0
	local nH			:= 0
	local lRet			:= .f.
	local aParambox		:= {}
	
	cPerg := PadR(cPerg,Len(SX1->X1_GRUPO))
	
	AADD(aParamBox,{1,"Nota Fiscal De "			, Space(TamSX3("F2_DOC")[1]),"@!","","","", TamSX3("F2_DOC")[1],.F.})	// MV_PAR01
	AADD(aParamBox,{1,"Nota Fiscal Ate "		, Space(TamSX3("F2_DOC")[1]),"@!","","","", TamSX3("F2_DOC")[1],.F.})	// MV_ PAR02
	AADD(aParamBox,{1,"Serie De "				, Space(TamSX3("F2_SERIE")[1]),"@!","","","", TamSX3("F2_SERIE")[1],.F.})	// MV_PAR03
	AADD(aParamBox,{1,"Serie Ate "				, Space(TamSX3("F2_SERIE")[1]),"@!","","","", TamSX3("F2_SERIE")[1],.F.})	// MV_PAR04
	AADD(aParamBox,{1,"Emissao de "				, ctod(""),"","","","", 50,.F.})	// MV_PAR05
	AADD(aParamBox,{1,"Emissao Ate "			, ctod(""),"","","","", 50,.F.})	// MV_PAR06
	
//	AADD(aParamBox,{2,"Ambiente "			, 2,{"1=Homologação","2=Produção"},50,".T.",.F.}) //MV_PAR07
	
	aadd(aParamBox,{6,"Diretório "   ,padr("",150),"",,"",90 ,.T.,"",alltrim("c:\"),GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
		
return ParamBox(aParamBox,"Exportação de arquivo NFSe", ::aRet,,,,,,,cPerg,.T.,.T.)


/*/{Protheus.doc} buscNf
Consulta SQL para retorno das Notas Fiscais
@author Thiago Meschiatti
@since 23/11/2015
@version 1.0
/*/
method buscNf() class ApoioNFsVal
	local cPerg	  	:= 'NFSValinhos'
	local cAliasLiv	:= GetnextAlias()
	local cQryLiv	:= ""
	local nCont		:= 0

		
	cQryLiv := " SELECT F3_NFISCAL AS NUMERO,F3_SERIE AS SERIE,F3_EMISSAO, " + CRLF
	cQryLiv += " 	MAX(SF3.R_E_C_N_O_) AS F3REC, MAX(SFT.R_E_C_N_O_) AS FTREC " + CRLF
	cQryLiv += " FROM "+ RetSqlName("SF3") +" SF3 				" + CRLF
	cQryLiv +=	"	INNER JOIN "+RetSqlName("SFT")+" SFT ON 	" + CRLF
	cQryLiv +=	"		(	 SFT.FT_FILIAL	= SF3.F3_FILIAL 	" + CRLF
	cQryLiv +=	"		 AND SFT.FT_TIPOMOV	= 'S' 				" + CRLF
	cQryLiv +=	"		 AND SFT.FT_SERIE	= SF3.F3_SERIE 		" + CRLF
	cQryLiv +=	"		 AND SFT.FT_NFISCAL	= SF3.F3_NFISCAL 	" + CRLF
	cQryLiv +=	"		 AND SFT.FT_CLIEfor	= SF3.F3_CLIEfor 	" + CRLF
	cQryLiv +=	"		 AND SFT.FT_LOJA	= SF3.F3_LOJA 		" + CRLF
	cQryLiv +=	"		 AND SFT.D_E_L_E_T_ 	= '')			" + CRLF
	cQryLiv += " WHERE
	cQryLiv += " 		F3_FILIAL 	= '"+xFilial("SF3")+ "' " + CRLF
	cQryLiv += " 	AND F3_TIPO 	= 'S' 				" + CRLF
	cQryLiv += " 	AND (F3_NFISCAL >= '"+ ::getNfDe()   +"' 	" + CRLF
	cQryLiv += " 	AND  F3_NFISCAL <= '"+ ::getNfAte()  +"')	" + CRLF
	cQryLiv += " 	AND (F3_SERIE 	>= '"+ ::getSerDe()  +"'	" + CRLF
	cQryLiv += " 	AND  F3_SERIE 	<= '"+ ::getSerAte() +"')	" + CRLF
	cQryLiv += " 	AND (F3_EMISSAO >= '"+ dTos(::getEmiDe())  +"'	" + CRLF
	cQryLiv += " 	AND  F3_EMISSAO <= '"+ dTos(::getEmiAte()) +"')	" + CRLF
	cQryLiv += " 	AND SF3.D_E_L_E_T_ = '' 	" + CRLF
	cQryLiv += " GROUP BY F3_NFISCAL,F3_SERIE,F3_EMISSAO " + CRLF
	cQryLiv += " ORDER BY F3_EMISSAO " + CRLF
	
	cQryLiv := ChangeQuery(cQryLiv)
	
	TcQuery cQryLiv New Alias &cAliasLiv
	Count to nCont
	
	::setTotRegs(nCont)
	(cAliasLiv)->(DbGotop())
   	
	if (cAliasLiv)->(EOF())
		Help( ,, FunDesc(),, 'Não existe dados para os parâmetros informados! Verifique os parâmetros.', 1, 0 )
		return "ERRO"
	endIf
return cAliasLiv


/*/{Protheus.doc} addRegNFs
Criaçaõ de conteúdo do arquivo, mas ainda sem gravação no arquivo físico
@author Thiago Meschiatti
@since 23/11/2015
@version 1.0
@param cAliasNfs, character, Alias com resultset de Notas Fiscais
/*/
method addRegNFs(cAliasNfs) class ApoioNFsVal
	local nPos		:= 0
	local cCodCli	:= ""
	local cLojCli	:= ""
	local cRecISS	:= ""
	local cSmplNac  := Iif(GETMV('MV_CODREG') $ '12','1','0')
	local cMsg		:= ""
	local nAliISS 	:= 0
	local nValISS 	:= 0
	local nDedISS 	:= 0
	local nValPis	:= 0
	local nAliPis   := 0
	local nValCofi  := 0
	local nAliCofi  := 0
	local nValCSSL  := 0
	local nAliCSSL  := 0
	local nValIR	:= 0
	local nAliIR	:= 0
	local nValINSS  := 0
	local nAliINSS  := 0
	
	aadd(::aRegsNF, {})
	nPos := len(::aRegsNF)
	
	cMsg := InfAdi((cAliasNfs)->NUMERO, (cAliasNfs)->SERIE)
	
	dbselectArea("SF2")
	SF2->(DbSetOrder(1))
	SF2->(dbGoTop())
	SF2->(dbSeek(xFilial("SF2")+(cAliasNfs)->NUMERO +(cAliasNfs)->SERIE))
	
	dbselectArea("SD2")
	SD2->(DbSetOrder(3))
	SD2->(dbGoTop())
	SD2->(dbSeek(xFilial("SD2")+(cAliasNfs)->NUMERO +(cAliasNfs)->SERIE + SFT->(FT_CLIEFOR + FT_LOJA + FT_PRODUTO + FT_ITEM)))
	
	dbselectArea("SF4")
	SF4->(DbSetOrder(1))
	SF4->(dbGoTop())
	SF4->(dbSeek(xFilial("SF4") + SD2->D2_TES))
	
	dbselectArea("SC6")
	SC6->(DbSetOrder(4))
	SC6->(dbSeek(xFilial('SC6')+PadR((cAliasNfs)->NUMERO,TamSx3("C6_NOTA")[1]) + PadR((cAliasNfs)->SERIE,TamSx3("C6_NOTA")[1])))
	
	dbselectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(dbSeek(xFilial('SC5') + SC6->C6_NUM))
	
	cCodCli	:= SF3->F3_CLIEFOR
	cLojCli	:= SF3->F3_LOJA
    
	//Posiciona cliente                                                   	
	SA1->(DbSetOrder(1))
	SA1->(dbGoTop())
	SA1->(dbSeek(xFilial("SA1")+cCodCli+cLojCli))
	if SA1->(EOF())
		Help( ,, 'Dado não encontrado',, 'Cliente '+cCodCli+'/'+cLojCli+' não encontrado na tabela SA1', 1, 0 )
		return "ERRO"
	endIf

	//Verifica se recolhe ISS Retido 	
	if SF3->(FieldPos("F3_RECISS"))>0
		if SF3->F3_RECISS $ "1"
			cRecISS := '1'
			nAliISS := SF3->F3_ALIQICM
			nValISS := SF3->F3_VALICM
		else
			cRecISS := '0'
			nAliISS := SF3->F3_ALIQICM
			nValISS	:= SF3->F3_VALICM
		endIf
	elseif SA1->A1_RECISS $ "1"
		cRecISS := '1'
		nAliISS := SF3->F3_ALIQICM
		nValISS := SF3->F3_VALICM
	else
		cRecISS := '0'
		nAliISS := SF3->F3_ALIQICM
		nValISS	:= SF3->F3_VALICM
	endIf
	
	//Pega as deduções			
	if SF3->F3_RECISS $ "1S"
		nDedISS := 0
		if SF3->(FieldPos("F3_ISSSUB"))>0  .And. SF3->F3_ISSSUB > 0
			nDedISS += SF3->F3_ISSSUB
		endIf
	
		if SF3->(FieldPos("F3_ISSMAT"))>0 .And. SF3->F3_ISSMAT > 0
			nDedISS += SF3->F3_ISSMAT
		endIf
	else
		nDedISS := 0
	endIf
	
	//Posiciona Natureza                                                      
	SED->(DbSetOrder(1))
	SED->(dbSeek(xFilial("SED")+SA1->A1_NATUREZ))

	if SF2->(EOF()) // Nota Fiscal Cancelada
		nValPis		:=	0
		nAliPis 	:= 	0
		nValCofi	:=	0
		nAliCofi	:=	0
		nValCSSL	:=	0
		nAliCSSL	:=	0
		nValIR		:=	0
		nAliIR		:=	0
		nValINSS	:=	0
		nAliINSS	:=	0
	else // Nota Fiscal Normal
		nValPis		:=	SF2->F2_VALPIS
		nAliPis 	:= 	iif(SF2->F2_VALPIS > 0, SED->ED_PERCPIS, 0)
		nValCofi	:=	SF2->F2_VALCOFI
		nAliCofi	:=	iif(SF2->F2_VALCOFI > 0, SED->ED_PERCCOF, 0)
		nValCSSL	:=	SF2->F2_VALCSLL
		nAliCSSL	:=	iif(SF2->F2_VALCSLL > 0, SED->ED_PERCCSL, 0)
		nValIR		:=	SF2->F2_VALIRRF
		nAliIR		:=	iif(SF2->F2_VALIRRF > 0, SED->ED_PERCIRF, 0)
		nValINSS	:=	SF2->F2_VALINSS
		nAliINSS	:=	iif(SF2->F2_VALINSS > 0, SED->ED_PERCINS, 0)
	endIf
	
	aadd(::aRegsNF[nPos], "7") 
	aadd(::aRegsNF[nPos], "0") 
	aadd(::aRegsNF[nPos], PADL(alltrim(strTran(SM0->M0_INSCM, '/', '')), 9, '0')) 
	aadd(::aRegsNF[nPos], PADL((cAliasNfs)->NUMERO, 12, '0')) 
	aadd(::aRegsNF[nPos], "1") 
	aadd(::aRegsNF[nPos], StrZero(SF3->F3_VALCONT * 100,15)) 
	aadd(::aRegsNF[nPos], StrZero(nDedISS * 100	,15)) 
	aadd(::aRegsNF[nPos], PadR(SF3->F3_CODISS, 6)) 
	aadd(::aRegsNF[nPos], StrZero(nAliISS * 100,4)) 
	aadd(::aRegsNF[nPos], SF4->F4_ISSST)// Local da Tributacao
	aadd(::aRegsNF[nPos], cSmplNac ) 
	aadd(::aRegsNF[nPos], SC5->C5_ZZTPTRB)// Tipo de Tributacao
	aadd(::aRegsNF[nPos], GetNewPar("ZZ_REGESP", "0"))// Regime Especial Prestador
	aadd(::aRegsNF[nPos], SA1->A1_ZZRGESP)// Regime Especial Tomador
	aadd(::aRegsNF[nPos], cRecISS)
	aadd(::aRegsNF[nPos], StrZero(nValISS * 100,15))
	aadd(::aRegsNF[nPos], StrZero(nValIR * 100,15))
	aadd(::aRegsNF[nPos], StrZero(nValPis * 100,15))
	aadd(::aRegsNF[nPos], StrZero(nValCofi * 100,15))
	aadd(::aRegsNF[nPos], StrZero(nValCSSL * 100,15))
	aadd(::aRegsNF[nPos], StrZero(nValINSS * 100,15))
	aadd(::aRegsNF[nPos], iif(SA1->A1_TIPO $ 'X', 'E', SA1->A1_PESSOA))
	aadd(::aRegsNF[nPos], PADL(iIf(SA1->A1_TIPO $ 'X', '0', SA1->A1_CGC), 14, '0'))
	aadd(::aRegsNF[nPos], PADL(alltrim(SA1->A1_INSCRM), 14, '0'))
	aadd(::aRegsNF[nPos], PADL(alltrim(SA1->A1_INSCR), 14, '0'))
	aadd(::aRegsNF[nPos], PADR(alltrim(SA1->A1_NOME), 50))
	aadd(::aRegsNF[nPos], PADR(Substr(alltrim(SA1->A1_END),1,at(',',SA1->A1_END)-1) , 50))
	aadd(::aRegsNF[nPos], PADR(alltrim(Substr(SA1->A1_END, at(',',SA1->A1_END)+1, len(SA1->A1_END))) , 10))
	aadd(::aRegsNF[nPos], PADR(alltrim(SA1->A1_COMPLEM), 30))
	aadd(::aRegsNF[nPos], PADR(alltrim(SA1->A1_BAIRRO), 30))
	aadd(::aRegsNF[nPos], iif(alltrim(SM0->M0_CODMUN) == alltrim(SA1->A1_COD_MUN), '1', '0')) 
	aadd(::aRegsNF[nPos], iif(empty(SC5->C5_MUNPRES), '0', iif(alltrim(SC5->C5_MUNPRES) ==  alltrim(SM0->M0_CODMUN), '0', '1')))
	aadd(::aRegsNF[nPos], PADR(alltrim(SA1->A1_MUN), 50))
	aadd(::aRegsNF[nPos], PADR(SA1->A1_EST, 2))
	aadd(::aRegsNF[nPos], PADL(SA1->A1_CEP, 8, '0'))
	aadd(::aRegsNF[nPos], PADR(SA1->A1_EMAIL, 80))
	aadd(::aRegsNF[nPos], StrZero(SF2->F2_TOTIMP * 100,15))
	aadd(::aRegsNF[nPos], PADR('', 20))
	aadd(::aRegsNF[nPos], cMsg)
	aadd(::aRegsNF[nPos], CHR(13) + CHR(10))
	
return 


/**
 * Adiciona informações adicionais na descricao do servico 
 */
static function InfAdi(cNota,cSerie) 
	local cRet			:=	''
	local nValTotNF		:=	0
	local cAuxProd		:= ""
	local cNumPed		:= ""
	local cAuxMsg 		:= ""  
	local cPedMsg		:= ""
	local aPedMsg		:= {}
	local cForMsg		:= ""
	local cCpoPrd		:= GetNewPar("MV_DESCBAR","")
	local lPedMsg		:= .F.
	local i				:= 0
	
			
	SC6->(DbSetOrder(4))
	if SC6->(dbSeek(xFilial('SC6')+PadR(cNota,TamSx3("C6_NOTA")[1]) + PadR(cSerie,TamSx3("C6_NOTA")[1])))
		while !(SC6->(EOF())) .AND. SC6->C6_FILIAL==xFilial('SC6') .AND. SC6->C6_NOTA==cNota .AND. SC6->C6_SERIE==cSerie
    		
    		if !empty(cCpoPrd)
				cAuxProd := Posicione("SB1" ,1,xFilial("SB1") + SC6->C6_PRODUTO,cCpoPrd)
			endif
			
			cRet += Alltrim(cAuxProd) + Space(2)
			cRet += "|"
			
			if !(Alltrim(SC6->C6_NUM) $ cPedMsg)
				cPedMsg += "|" + Alltrim(SC6->C6_NUM)
				
				SC5->(DbSetOrder(1))
				if SC5->(dbSeek(xFilial('SC5') + SC6->C6_NUM))
					
					//Adiciona a C5_MENNOTA que ainda não foi incluido no array
					for i:= 1 to Len(aPedMsg)
						if(aPedMsg[i] == Upper(Alltrim(SC5->C5_MENNOTA)))
							lPedMsg := .T.
							exit
						endIf
					next
					
					if(!lPedMsg .AND. !Empty(Alltrim(SC5->C5_MENNOTA)))
						AAdd(aPedMsg,Upper(Alltrim(SC5->C5_MENNOTA)))
						cAuxMsg += Alltrim(SC5->C5_MENNOTA) + "|"
					endIf
					
					//Adicionado a mensagem do formulas que ainda não foi incluida				
					if(!(Alltrim(SC5->C5_MENPAD) $ cForMsg) .AND. !Empty(Alltrim(SC5->C5_MENPAD)))
						cForMsg += "|" + Alltrim(SC5->C5_MENPAD)
						
						SM4->(DbSetOrder(1))
						if(SM4->(DbSeek(xFilial("SM4") + SC5->C5_MENPAD)))
							cAuxMsg += Alltrim(&(SM4->M4_FORMULA)) + "|"
						endIf
					endIf
				endIf
			endIf
				 	
			SC6->(dbSkip())
		endDo
	endIf
	  	
	cRet += "|" + Alltrim(cAuxMsg)
	cAuxMsg := ""
	cPedMsg	:= ""
	aPedMsg	:= {}
	cForMsg	:= ""
return (cRet)



/*/{Protheus.doc} gravArq
Criação e gravação do conteúdo do arquivo.
@author Thiago Meschiatti
@since 23/11/2015
@version 1.0
/*/
method gravArq() class ApoioNFsVal
	local cFileName := alltrim(::getArqDir()) + alltrim(::getNomeArq())
	local nHdlArq   := 0
	local nPos		:= 1
	local nI		:= 0
	local cTexto	:= ""
						
	// Gravacao do arquivo	
	if File(cFileName)
		FErase(cFileName)
	endIf
	
	if (nHdlArq := FCreate(cFileName,0)) == -1
		Help( ,, 'Arquivo não criado',, 'Arquivo Texto não pode ser criado!', 1, 0 )
		return "ERRO"
	endIf
      
	for nPos := 1 to Len(::aRegsNF)
		cTexto := ""
		for nI:=1 to Len(::aRegsNF[nPos])
			cTexto += ::aRegsNF[nPos][nI]
		next nI
		FWrite(nHdlArq,cTexto)
	next nPos
		
	FClose(nHdlArq)
    
    MsgInfo('Arquivo gerado com sucesso : ' + cFileName,FunDesc())
	
return