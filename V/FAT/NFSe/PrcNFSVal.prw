#Include 'Protheus.ch'

#DEFINE NF_DE		1
#DEFINE NF_ATE		2
#DEFINE SERIE_DE	3
#DEFINE SERIE_ATE	4
#DEFINE EMISSAO_DE	5
#DEFINE EMISSAO_ATE	6
#DEFINE DIRETORIO	7


/*/{Protheus.doc} PrcNFSVal
Processamento de Nota Fiscal de Serviço Valinhos
@author Thiago Meschiatti
@since 23/11/2015
@version 1.0
/*/
User Function PrcNFSVal()
	local oNFSe		:= ApoioNFsVal():NewApoioNFsVal()
	local cPerg		:= 'NFSValinhos'
	
	if !oNFSe:CriaPerg(cPerg)
		return "ERRO"
	endIf
	
	Processa({|| ExecNFs(@oNFSe)},"Gerando Arquivo NFSe...")
	
Return


/*
** Execução da rotina
*/
static function ExecNFs(oNFSe)
	local cAliasNfs	:= ""
	local cNomeArq	:= 'NFSE_Valinhos_'+DtoS(Date())+StrTran(Time(),':','')+'.TXT'
	
	oNFSe:setArqDir(oNFSe:getParambox(DIRETORIO))
	oNFSe:setNomeArq(cNomeArq)
	oNFSe:setNfDe(oNFSe:getParambox(NF_DE))
	oNFSe:setNfAte(oNFSe:getParambox(NF_ATE))
	oNFSe:setSerDe(oNFSe:getParambox(SERIE_DE))
	oNFSe:setSerAte(oNFSe:getParambox(SERIE_ATE))
	oNFSe:setEmiDe(oNFSe:getParambox(EMISSAO_DE))
	oNFSe:setEmiAte(oNFSe:getParambox(EMISSAO_ATE))
	
	cAliasNfs := oNFSe:buscNF()
	ProcRegua(oNFSe:getTotRegs())
	
	while (cAliasNfs)->(!eof())
		IncProc()
		SF3->(dbGoTo((cAliasNfs)->F3REC))
		SFT->(dbGoTo((cAliasNfs)->FTREC))
			
		oNFSe:addRegNFs(cAliasNfs)
	
		(cAliasNfs)->(dbSkip()) 
	end
	
	oNFSe:GravArq()
	
return
