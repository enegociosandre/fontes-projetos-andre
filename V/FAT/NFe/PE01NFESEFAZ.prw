#Include 'Protheus.ch'

//POSICOES ARRAY aNfVinc
#define EMISSAO 	1
#define SERIE 		2
#define DOC	 		3
#define CNPJ 		4
#define ESTCOB 		5
#define ESPECIE 	6
#define CHAVENFE 	7

/*/{Protheus.doc} PE01NFESEFAZ

Ponto de Entrada para customização dos dados do XML da Nota Fiscal Eletrônica
	
@author Diego de Angelo
@since 17/11/2014
/*/
user function PE01NFESEFAZ()
	
	local aRetorno		:= {}
	local aParam 		:= PARAMIXB
	local aProd			:= PARAMIXB[01]
	local cMensCli		:= PARAMIXB[02]
	local cMensFis		:= PARAMIXB[03]
	local aDest			:= PARAMIXB[04]
	local aNota   		:= PARAMIXB[05]
	local aInfoItem		:= PARAMIXB[06]
	local aDupl			:= PARAMIXB[07]
	local aTransp		:= PARAMIXB[08]
	local aEntrega		:= PARAMIXB[09]
	local aRetirada		:= PARAMIXB[10]
	local aVeiculo		:= PARAMIXB[11]
	local aReboque		:= PARAMIXB[12]
	local aNfVincRur	:= PARAMIXB[13]
	local aAreas 		:= Lj7GetArea({"SC5","SC6","SF1","SF2","SD1","SD2","SA1","SA2","SB1","SB5","SF4","SA3"})
	local cTipo			:= aNota[04]
	
	infAdicionais(aNota,aInfoItem,@aProd,@cMensCli,@cMensFis,aDupl)
	aVeiculo := adicionaPlaca(cTipo)
	
	aAdd(aRetorno , aProd)
	aAdd(aRetorno , cMensCli)
	aAdd(aRetorno , cMensFis)
	aAdd(aRetorno , aDest)
	aAdd(aRetorno , aNota)
	aAdd(aRetorno , aInfoItem)
	aAdd(aRetorno , aDupl)
	aAdd(aRetorno , aTransp)
	aAdd(aRetorno , aEntrega)
	aAdd(aRetorno , aRetirada)
	aAdd(aRetorno , aVeiculo)
	aAdd(aRetorno , aReboque)
	aAdd(aRetorno , aNfVincRur)
	
	Lj7RestArea(aAreas)

return aRetorno

static function adicionaPlaca(cTipo)
	
	local aRetorno := {}
	
	if cTipo == '1'
		if !empty(SF2->F2_ZZPLACA)
			aadd(aRetorno, SF2->F2_ZZPLACA)
			aadd(aRetorno, SF2->F2_ZZUFPLA)
			aadd(aRetorno, "")//RNTC
		endIf
	else
		if !empty(SF1->F1_PLACA)
			aadd(aRetorno, SF1->F1_PLACA)
			aadd(aRetorno, SF1->F1_ZZUFPLA)
			aadd(aRetorno, "") //RNTC
		endIf
	endIf
	
return (aRetorno)

/**
 * Tratativa das Mensagens Adicionais
 */
static function infAdicionais(aNota, aInfoItem, aProd, cMensCli, cMensFis, aDupl)
	
	local nI		:= 0
	local cCliFor	:= ""
	local cLoja		:= ""
	local cProduto	:= ""
	local cItem		:= ""
	local cSerie	:= aNota[01]
	local cDoc		:= aNota[02]
	local cTipo		:= aNota[04]
	local cTipoNF	:= aNota[05]
	local cMsgPed	:= ""
	local cCliTrib	:= ""
	local cEstCliFor:= ""
	local nCount	:= 0
	local nValII	:= 0
	local nAFRMM	:= 0
	local nCapataz	:= 0 
	local nSiscomex	:= 0
	local nFrete	:= 0 
	local nSeguro	:= 0
	local aMsgs		:= {}
	
	if cTipo == '1'
	
		cCliFor	:= SF2->F2_CLIENTE
		cLoja	:= SF2->F2_LOJA  
		
		//aNota[3] := SF2->F2_EMISSAO  //SF2->F2_ZZDTSAI
		//aNota[6] := SF2->F2_HORA     //SF2->F2_ZZHRSAI 
		
		for nI:=1 to Len(aProd)
	
			cItem			:= aInfoItem[nI,04]
			cProduto		:= aProd[nI,02]
			aProd[nI,03] 	:= ""  //Remove Codigo EAN - B1_CODBAR - Tiago Quintana - 14/06/16
			
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(MsSeek(xFilial("SB1")+cProduto))
			
			if cTipoNF $ "BD"
				dbSelectArea("SA2")
				SA2->(dbSetOrder(1))
				SA2->(dbSeek(xFilial("SA2")+cCliFor+cLoja))
				cCliTrib 	:= SA2->A2_GRPTRIB
			else
				dbSelectArea("SA1")
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+cCliFor+cLoja))
				
				cCliTrib 	:= SA1->A1_GRPTRIB
				cUFDestino	:= SA1->A1_EST
				retProdMsg(SA1->A1_CONTRIB, @aMsgs, .F.)
			endIf
			
			verifOrig(@aProd[nI])
			retPedidos(@cMsgPed, SD2->D2_PEDIDO)
						
			dbSelectArea("SD2")
			SD2->(dbSetOrder(3))
			if SD2->(dbSeek(xFilial("SD2")+cDoc+cSerie+cCliFor+cLoja+cProduto+cItem))
				if !empty(SD2->D2_NUMSERI)
					aProd[nI,25] := aProd[nI,25] + " N/S: " + SD2->D2_NUMSERI
				endif
				
				retTesMsg(SD2->D2_TES, @aMsgs)
				
				if !(cTipoNF $ "BD")
					retSF7Msg(SB1->B1_GRTRIB, cCliTrib, cUFDestino, SD2->D2_CF, @aMsgs)
					retCFCMsg(cUFDestino, cProduto, @aMsgs)
				endif
			endif
			
		next nI
		
		if !empty(cMsgPed)
			cMensCli := cMensCli + " PV: "+ cMsgPed + ". "
		endif                                                     
				
		//Faturas 
		addFaturas(@cMensCli, aDupl)
		
		montMsg(@cMensCli, aMsgs)
		
		//Mensagem XX - Redespacho
		dbSelectArea("SF2")
		
		If !Empty(SF2->F2_REDESP)
			If !AllTrim("OBS FRETE (REDESPACHO)") $ cMensCli
				If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
					cMensCli += " - "
				EndIf
				cCnpj := POSICIONE("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_CGC")
				cIE   := POSICIONE("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_INSEST")
				cMensCli += "OBS FRETE (REDESPACHO) - REDESPACHAR POR: " + AllTrim(POSICIONE("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_NOME"))+' - '
				cMensCli += AllTrim(POSICIONE("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_END"))+' - '
				cMensCli += AllTrim(POSICIONE("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_BAIRRO"))+' - '
				cMensCli += AllTrim(POSICIONE("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_MUN"))+' - '
				cMensCli += AllTrim(POSICIONE("SA4",1,xFilial("SA4")+SF2->F2_REDESP,"A4_EST"))+' - '
				cMensCli += IIF(!Empty(cCnpj),'CNPJ: '+Transform(cCnpj,"@R 99.999.999/9999-99"),"")+' - '
				cMensCli += IIF(!Empty(cIE),'IE: '+Transform(cIE,"@R 999.999.999.999"),"")
			EndIf
		EndIf
				
	else
		
		for nI:=1 to Len(aProd)
	
			cItem			:= aInfoItem[nI,04]
			cProduto		:= aProd[nI,02]
			aProd[nI,03] 	:= ""  //Remove Codigo EAN - B1_CODBAR - Tiago Quintana - 14/06/16
			
			cCliFor	:= SF1->F1_FORNECE
			cLoja	:= SF1->F1_LOJA
    	
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(MsSeek(xFilial("SB1")+cProduto))
			
			if cTipoNF $ "BD"
				dbSelectArea("SA1")
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+cCliFor+cLoja))
				cCliTrib 	:= SA1->A1_GRPTRIB
				if cTipoNF == "D"
					retProdMsg(SA1->A1_CONTRIB, @aMsgs,.F.)
				endIf
			else
				dbSelectArea("SA2")
				SA2->(dbSetOrder(1))
				SA2->(dbSeek(xFilial("SA2")+cCliFor+cLoja))
				
				cCliTrib 	:= SA2->A2_GRPTRIB
				cUFDestino	:= SA2->A2_EST
				retProdMsg(SA2->A2_CONTRIB, @aMsgs,.T.)
			endIf
						
			dbSelectArea("SD1")
			SD1->(dbSetOrder(1))
			if SD1->(dbSeek(xFilial("SD1")+cDoc+cSerie+cCliFor+cLoja+cProduto+cItem))
				nValII 		+= SD1->D1_ZZVALII
				nAFRMM		+= SD1->D1_ZZAFRMM
				nCapataz	+= SD1->D1_ZZDPADU
				nSiscomex	+= SD1->D1_ZZDPICM
				nFrete		+= SD1->D1_ZZFRETE
				nSeguro		+= SD1->D1_ZZSEGUR
				if !empty(SD1->D1_ZZNRSER)
					aProd[nI,25] := Alltrim(aProd[nI,25]) + "N/S: " + Alltrim(SD1->D1_ZZNRSER)
				endif
				
				retTesMsg(SD1->D1_TES, @aMsgs)
				
				if (cTipoNF <> "B")
					retSF7Msg(SB1->B1_GRTRIB, cCliTrib, cUFDestino, SD1->D1_CF, @aMsgs)
				endif
				
			endif			
		next nI
		
		montMsg(@cMensCli, aMsgs)
		
		retImport(@cMensCli, nValII, nAFRMM, nCapataz, nSiscomex, nFrete, nSeguro)
		
	endIf

return


/*
** Retorna Pedidos de Venda da NF
*/
static function retPedidos(cMsgPed, cNumPed)


	if !(alltrim(upper(cNumPed)) $ alltrim(upper(cMsgPed)))
		if empty(cMsgPed)
			cMsgPed :=  cNumPed
		else
			cMsgPed := cMsgPed + "/" + cNumPed
		endif
	endif
return


/* 
** Retorna dados da importação
*/
static function retImport(cMensCli, nValII, nAFRMM, nCapataz, nSiscomex, nFrete, nSeguro)
	local aAreaSW6	:= SW6->(GetArea())
	local cMsg		:= ""
	
	dbSelectArea("SW6")
	SW6->(dbSetOrder(1))
	if SW6->(dbSeek(xFilial("SW6") + SF1->F1_HAWB))
		if !empty(SW6->W6_DI_NUM )
			cMsg	+= "Número da DI: " + SW6->W6_DI_NUM + ". "
		endif
		
		if !empty(SW6->W6_DTREG_D )
			cMsg	+= "Data DI: " + Dtoc(SW6->W6_DTREG_D) + ". "
		endif
		
		if !empty(SW6->W6_TX_US_D )
			cMsg	+= "Taxa de câmbio: R$ " + alltrim(Transform( SW6->W6_TX_US_D, "@E 9,999,999,999,999.99")) + ". "
		endif
	endif
		
	if !empty(SF1->F1_HAWB )
		cMsg	+= "Número do processo: " + alltrim(SF1->F1_HAWB) + ". "
	endif
	
	if SF1->F1_VALIMP6 > 0
		cMsg	+= "Valor do PIS: R$ " + alltrim(Transform( SF1->F1_VALIMP6, "@E 9,999,999,999,999.99")) + ". "
	endif
	
	if SF1->F1_VALIMP5 > 0
		cMsg	+= "Valor COFINS: R$ " + alltrim(Transform( SF1->F1_VALIMP5, "@E 9,999,999,999,999.99")) + ". "
	endif
	
	if nValII > 0
		cMsg	+= "Valor do II: R$ " + alltrim(Transform( nValII, "@E 9,999,999,999,999.99")) + ". "
	endif
	
	if nAFRMM > 0
		cMsg	+= "AFRMM: R$ " + alltrim(Transform( nAFRMM, "@E 9,999,999,999,999.99")) + ". "
	endif
	
	if nCapataz > 0
		cMsg	+= "Capatazias: R$ " + alltrim(Transform( nCapataz, "@E 9,999,999,999,999.99")) + ". "
	endif
	
	if nSiscomex > 0
		cMsg	+= "Tx. Siscomex: R$ " + alltrim(Transform( nSiscomex, "@E 9,999,999,999,999.99")) + ". "
	endif
	
	if nFrete > 0
		cMsg	+= "Frete: R$ " + alltrim(Transform( nFrete, "@E 9,999,999,999,999.99")) + ". "
	endif
	
	if !empty(nSeguro)
		cMsg	+= "Seguro: R$ " + alltrim(Transform( nSeguro, "@E 9,999,999,999,999.99")) + ". "
	endif
	
	if !empty(cMsg)
		cMensCli := cMensCli + "#" + cMsg
	endif
               
	RestArea(aAreaSW6)

return


/*
** Mensagens de Exceção Fiscal
*/
/***********************************************************************************************************************************************************
ATENÇÃO: Só haverá mensagem cadastrado na rotina "Exceção Fiscal" (F7_ZZMENS) caso o campo "Situação Tributária" (F7_SITTRIB) esteja preenchida.          //
Independe da informação da origem do produto e da Exceção (B1_ORIGEM e F7_ORIGEM). Regra validado por Angelita Bortolotti (Fiscal-Vermeer) em 16/03/2016. //
***********************************************************************************************************************************************************/
static function retSF7Msg(cPrdTrib, cCliTrib, cUFCli, cCfop, aMsgs)      

	local cCodMsg 	:= ""
	local cExc		:= GetNewPar("MV_ZZEXCF1", "") + GetNewPar("MV_ZZEXCF2", "") + GetNewPar("MV_ZZEXCF2", "")
	
	dbSelectArea("SF7")
	SF7->(dbSetOrder(1))
	if SF7->(dbSeek(xFilial("SF7")+cPrdTrib))
		while (xFilial("SF7")+cPrdTrib) == SF7->(F7_FILIAL + F7_GRTRIB)
			if SF7-> F7_GRPCLI == cCliTrib
				if (SF7->F7_TIPOCLI $ '*' .and. cUFCli == SF7->F7_EST) .or. (SF7->F7_TIPOCLI == SA1->A1_TIPO  .and. cUFCli == SF7->F7_EST)
					if !(alltrim(cCfop) $ alltrim(cExc))
						if SF7->F7_SITTRIB == SF4->F4_SITTRIB
							cCodMsg := SF7->F7_ZZMENS
						endif	
					endif
				endif
				
				if !empty(cCodMsg)
					if ascan(aMsgs,{|x| alltrim(upper(x)) == alltrim(upper(cCodMsg))}) == 0
						aadd(aMsgs, cCodMsg)
					endif
				endif
			endif
			SF7->(dbskip())
		enddo
	endif
	
return


/*
** Mensagens de Produtos
*/
static function retProdMsg(cContrib, aMsgs, lEntrada)
	local cEstEmp	:= GetNewPar("MV_ESTADO", "")
	local cEstCli	:= iif(lEntrada, SA2->A2_EST, SA1->A1_EST)
	local cCodMsg	:= ""

	if alltrim(cContrib) == '1'
		if cEstCli == cEstEmp
			cCodMsg := SB1->B1_ZZMEN1
		else
			cCodMsg := SB1->B1_ZZMEN2
		endif
		
		if !empty(cCodMsg)
			if ascan(aMsgs,{|x| alltrim(upper(x)) == alltrim(upper(cCodMsg))}) == 0
				aadd(aMsgs, cCodMsg)
			endif
		endif
	endif
return


/*
** Mensagens da TES
*/
static function retTesMsg(cTes, aMsgs)
	local cCodMsg	:= ""
	
	cCodMsg := Posicione("SF4", 1, xFilial("SF4") + cTes, "F4_ZZMENS")
	
	if !empty(cCodMsg)
		if ascan(aMsgs,{|x| alltrim(upper(x)) == alltrim(upper(cCodMsg))}) == 0
			aadd(aMsgs, cCodMsg)
		endif
	endif
return


/*
** Mensagens CFC - Fundo de Combate a Pobreza
*/
static function retCFCMsg(cUFDestino, cProduto, aMsgs)
	local lMsg 		:= getNewPar("MV_ZZCFC", .f.)
	local cUfOrig	:= getNewPar("MV_ESTADO", "")
	local cCodMsg	:= ""
	local aAreaCFC	:= CFC->(GetArea())
	
	if lMsg
		dbSelectArea("CFC")
		CFC->(dbSetOrder(1))
		if CFC->(dbSeek(xFilial("CFC") + cUfOrig + cUFDestino + cProduto))
			cCodMsg := CFC->CFC_ZZMENS
		elseif CFC->(dbSeek(xFilial("CFC") + cUfOrig + cUFDestino ))
			cCodMsg := CFC->CFC_ZZMENS
		endif
			
		if !empty(cCodMsg)
			if ascan(aMsgs,{|x| alltrim(upper(x)) == alltrim(upper(cCodMsg))}) == 0
				aadd(aMsgs, cCodMsg)
			endif
		endif
	endif
	RestArea(aAreaCFC)
return	
	 
	 
/*
** Monta mensagens do array
*/
static function montMsg(cMensCli, aMsgs)
	local nI := 0
	
	for nI := 1 to len(aMsgs)
		cMensCli := cMensCli + " " + alltrim(posicione("ZZ2", 1, xFilial("ZZ2") + aMsgs[nI], "ZZ2_MSG")) 
	next nI
return	 


/*
** Adiciona faturas quando quantidade maior de 9 parcelas.
*/
static function addFaturas(cMensCli, aDupl)
	local cMsg	:= "Faturas: "
	local nI	:= 0	 
	
	if len(aDupl) > 9 
		for nI := 10 to len(aDupl)
			cMsg += alltrim(str(nI)) + ". " + aDupl[nI,1] + " - " + Dtoc(aDupl[nI,2]) + " - " + alltrim(Transform( aDupl[nI,3], "@E 9,999,999,999,999.99")) + "| " 
		next
		cMensCli := cMsg +"#"+ cMensCli
	endif
	
return


/*
** Verifica origem para produto e informação da tag EXTIPI
*/
static function verifOrig(aProd)
	local nPosExNcm	:= 6
	
	aProd[nPosExNcm] := ""
			 
return