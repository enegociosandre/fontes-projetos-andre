#INCLUDE "Protheus.ch"
#DEFINE DATASOURCE "'OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=DESKTOP-C6DUM7E\SQLEXPRESS; USER ID=sa;PASSWORD=sa').database.dbo.'"
//#DEFINE DATASOURCE "'OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=DESKTOP-C6DUM7E\SQLEXPRESS; USER ID=sa;PASSWORD=sa').database.dbo.'"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDADOSSIGA บ Autor ณPaulo Bindo         บ Data ณ  26/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importa os dados do site para o Protheus                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function DADOSSIGA()
Local cTabela
Local cSincD
Local cSincH
Local cCampo
Local cCampoTRB
Local aCabec		:= {}
Local aItem			:= {}
Local aEstrutura 	:= {}
Local nTabela		:= 0

//SELECIONA TODAS AS ROTINAS QUE SERAO REPLICADAS
cQuery := " SELECT  * FROM "+DATASOURCE+"sigafuncionalidades"
//cQuery += " OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=192.168.0.120\SIGA; USER ID=SIGAWEB;PASSWORD=SIGAWEB').DADOSWEB.dbo."+TABELA+"sigafuncionalidades"
//cQuery += ""SELECT  * FROM  "+OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=DESKTOP-C6DUM7E\SQLEXPRESS; USER ID=sa;PASSWORD=sa').database.dbo+"sigafuncionalidades"
//cQuery += " WHERE ... <> ''

MemoWrite("DADOSSIGA.sql",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB1", .F., .T.)

Count To nRec

If nRec == 0
	MsgStop("Nใo existem dados para esta consulta","Aten็ใo - DADOSSIGA")
EndIf


DbSelectArea("TRB1")
DbGoTop()
While !Eof()
	cRel1 := TRB1->REL1
	cRel2 := TRB1->REL2
	cRotmat := TRB1->ROTINAAUTOMATICA
	
	//VERIFICA SE A FUNCIONALIDADE E MODELO 1 OU MODELO 3
	If Empty(TRB1->tabela2)//MODELO1
		nTabela := 1
	Else
		nTabela := 2
	EndIf
	
	cRotina := cRotmat						//ARMAZENA O NOME DA ROTINA AUTOMATICA EM VARIAVEL
	
	
	//ARMAZENA O NOME DA TABELA CORRENTE EM UMA VARIAVEL
	cTabela 	:= TRB1->tabela1
	cTabela2	:= TRB1->tabela2
	
	
	//MONTA OS NOMES DOS CAMPOS DE SINCRONIZACAO
	If SubStr(cTabela,1,1) == "S"
		cSincD		:= SubStr(cTabela,2,2) + "_SINCDT"
		cSincH		:= SubStr(cTabela,2,2) + "_SINCHR"
	Else
		cSincD		:= cTabela + "_SINCDT"
		cSincH		:= cTabela + "_SINCHR"
	EndIf
	//QUANDO FOR ROTINA AUTOMATICA SELECIONA OS CAMPOS QUE IRAO NA QUERY EM ORDEM DE GRAVAO
	If AllTrim(cRotmat) <> 'XXXX'
		//BUSCA A ORDEM DOS CAMPOS NA ROTINA AUTOMATICA NO SX3VETI
		cQuery := " SELECT X3_CAMPO FROM "+DATASOURCE+"SX3VETI"+SM0->M0_CODIGO+"0"
		cQuery += " WHERE X3_ARQUIVO = '"+cTabela+"' AND X3_ORDAUT <> ''"
		cQuery += " ORDER BY X3_ORDAUT"
		
		MemoWrite("DADOSSIGAI.sql",cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRX3", .F., .T.)
		
		Count To nRecX3
		If nRecX3 > 0
			DbSelectArea("TRX3")
			dbgotop()
			cCampos := ""
			While!EOF()
				cCampos += X3_CAMPO+","
				dbSkip()
			End
			cCampos := SubStr(cCampos,1,Len(cCampos)-1)
		Else
			dbSelectArea("TRB1")
			dbSkip()
			Loop
		EndIf
		TRX3->(dbCloseArea())
	EndIf
	
	//BUSCAS OS DADOS A SEREM SINCRONIZADOS DA TABELA 1 NA WEB
	If AllTrim(cRotmat) <> 'XXXX'
		cQuery := " SELECT "+cCampos+" FROM "+DATASOURCE+RetSqlName(cTabela)
	Else
		cQuery := " SELECT * FROM "+DATASOURCE+RetSqlName(cTabela)
	EndIf
	//	cQuery += " OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=192.168.0.120\SIGA; USER ID=SIGAWEB;PASSWORD=SIGAWEB').DADOSWEB.dbo."+cTabela+"VETI"+SM0->M0_CODIGO+"0"
	/*
	If AllTrim(cRotmat) <> 'XXXX'
	cQuery += " INNER JOIN "+DATASOURCE+"SX3VETI"+SM0->M0_CODIGO+"0"
	cQuery += " ON X3_ARQUIVO = '"+cTabela+"'"
	EndIf
	*/
	cQuery += " WHERE "+cSincH+" = '' AND  "+cSincD+" = ''"
	/*
	If AllTrim(cRotmat) <> 'XXXX'
	cQuery += " AND X3_ORDAUT <> ''"
	cQuery += " ORDER BY X3_ORDAUT"
	EndIf
	*/
	MemoWrite("DADOSSIGAa.sql",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB2", .F., .T.)
	
	Count To nRec2
	
	If nRec2 > 0
		
		DbSelectArea("TRB2")
		DbGoTop()
		aEstrutura := DbStruct()
		
		While !Eof()
			//VERIFICA SE SERA UMA ROTINA AUTOMATICA OU UM RECLOCK
			If AllTrim(cRotmat) == 'XXXX' //RECLOCK
				//GRAVA A PRIMEIRA TABELA
				dbSelectArea(cTabela)
				aEstrut2 := DbStruct()
				RecLock(cTabela,.T.)
				For z:= 1 To Len(aEstrutura)
					nPos := Ascan(aEstrut2, {|x| x[1] == aEstrutura[z][1]})
					If nPos >0
						cCampoTRB	:= "TRB2->"+aEstrutura[z][1]
						cCampo	 	:= aEstrutura[z][1]
						If !Empty(&cCampoTRB)
							&cCampo		:= Iif(aEstrut2[nPos][2] == 'D',CtoD(&cCampoTRB),&cCampoTRB)
						EndIf
					EndIf
				Next
				MsUnlock()
				
				//ATUALIZA CAMPOS DE SINCRONIZACAO NA BASE WEB
				cChave := "TRB2->"+cRel1
				cQuery := " UPDATE  "+DATASOURCE+RetSqlName(cTabela)+""
				//cQuery += " OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=192.168.0.120\SIGA; USER ID=SIGAWEB;PASSWORD=SIGAWEB').DADOSWEB.dbo."+RetSqlName(TRB1->CAMPO1)+""
				cQuery += " SET "+cSincD+" = '"+dTos(Date())+"' , "+cSincH+" = '"+SubStr(Time(),1,5)+"' WHERE "+cSincH+" = '' AND  "+cSincD+" = ''"
				cQuery += " AND "+cRel1+" = '"+&cChave+"'"
				MemoWrite("DADOSSIGAd.SQL",cQuery)
				TcSqlExec(cQuery)
				
				//QUANDO EXISTIR UMA SEGUNDA TABELA GRAVA OS DADOS DELA
				If nTabela == 2
					//MONTA OS NOMES DOS CAMPOS DE SINCRONIZACAO
					If SubStr(cTabela2,1,1) == "S"
						cSincD		:= SubStr(cTabela2,2,2) + "_SINCDT"
						cSincH		:= SubStr(cTabela2,2,2) + "_SINCHR"
					Else
						cSincD		:= cTabela2 + "_SINCDT"
						cSincH		:= cTabela2 + "_SINCHR"
					EndIf
					
					
					//SELECIONA OS DADOS DA SEGUNDA TABELA
					cChave := "TRB2->"+cRel1
					cQuery := " SELECT * FROM "+DATASOURCE+RetSqlName(cTabela2)
					//cQuery += " OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=192.168.0.120\SIGA; USER ID=SIGAWEB;PASSWORD=SIGAWEB').DADOSWEB.dbo."+RetSqlName(cTabela2)
					cQuery += " WHERE "+cSincH+" = '' AND  "+cSincD+" = '' AND "+TRB1->RELA2+" = '"+&cChave+"'"
					MemoWrite("DADOSSIGAc.sql",cQuery)
					dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB3", .F., .T.)
					
					Count To nRec3
					
					If nRec3 > 0
						
						DbSelectArea("TRB3")
						DbGoTop()
						aEstrutura3 := DbStruct()
						dbSelectArea(cTabela2)
						RecLock(cTabela2,.T.)
						For z:= 1 To Len(aEstrutura3)
							cCampoTRB	:= "TRB1->"+aEstrutura3[z][1]
							cCampo	 	:= aEstrutura3[z][1]
							&cCampo		:= &cCampoTRB
						Next
						MsUnlock()
						
						DbSelectArea("TRB3")
						dbSkip()
					End
					TRB3->(dbCloseArea())
					
					//ATUALIZA CAMPOS DE SINCRONIZACAO NA BASE WEB
					cChave := "TRB2->"+cRel1
					cQuery := " UPDATE  "+DATASOURCE+RetSqlName(cTabela2)+""
					//cQuery += " OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=192.168.0.120\SIGA; USER ID=SIGAWEB;PASSWORD=SIGAWEB').DADOSWEB.dbo."+RetSqlName(TRB1->CAMPO2)+""
					cQuery += " SET "+cSincD+" = '"+dTos(Date())+"' , "+cSincH+" = '"+SubStr(Time(),1,5)+"' WHERE "+cSincH+" = '' AND  "+cSincD+" = ''"
					cQuery += " AND "+TRB1->RELA2+" = '"+&cChave+"'"
					MemoWrite("DADOSSIGAd.SQL",cQuery)
					TcSqlExec(cQuery)
					
				EndIf
			Else	//ROTINA AUTOMATICA
				aCabec := {}
				dbSelectArea(cTabela)
				aEstrut2 := DbStruct()
				RecLock(cTabela,.T.)
				For z:= 1 To Len(aEstrutura)
					nPos := Ascan(aEstrut2, {|x| x[1] == aEstrutura[z][1]})
					If nPos >0
						cCampoTRB	:= "TRB2->"+aEstrutura[z][1]
						cCampo	 	:= aEstrutura[z][1]
						If !Empty(&cCampoTRB)
							AAdd(aCabec,{cCampo,Iif(aEstrut2[nPos][2] == 'D',CtoD(&cCampoTRB),&cCampoTRB),Nil})
						EndIf
					EndIf
				Next
				
				If nTabela ==2 //DUAS TABELAS
					
					
					//BUSCA OS DADOS DA SEGUNDA TABELA
					cChave := "TRB2->"+cRel1
					cQuery := " SELECT * FROM "+DATASOURCE+RetSqlName(cTabela)
					//cQuery += " OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=192.168.0.120\SIGA; USER ID=SIGAWEB;PASSWORD=SIGAWEB').DADOSWEB.dbo."+RetSqlName(cTabela)
					cQuery += " INNER JOIN "+DATASOURCE+"SX3VETI"+SM0->M0_CODIGO+"0"
					cQuery += " ON X3_ARQUIVO = "+cTabela2+""
					cQuery += " WHERE "+cSincH+" = '' AND  "+cSincD+" = '' AND "+TRB1->RELA2+" = '"+&cChave+"'"
					cQuery += " AND X3_ORDAUT <> '' "
					cQuery += " ORDER BY X3_ORDAUT"
					MemoWrite("DADOSSIGAc.sql",cQuery)
					dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB3", .F., .T.)
					
					Count To nRec3
					
					If nRec3 > 0
						
						DbSelectArea("TRB3")
						DbGoTop()
						aEstrutura3 := DbStruct()
						
						aItem := {}
						While !Eof()
							For z:= 1 To Len(aEstrutura3)
								AAdd(aCabec,{TRB3->(Field(z)),TRB3->(FieldGet(z)),Nil})
							Next
							dbSkip()
						End
						TRB3->(dbCloseArea())
					EndIf
				EndIf
				
				lMSErroAuto := .F.
				//EXECUTA AS ROTINAS AUTOMATICAS
				If nTabela == 1     //UMA TABELA
					If cRotina == "MATA030"
						msExecAuto({|x|MATA030(x)},aCabec,3)
					EndIf
				Else				//DUAS TABELAS
					msExecAuto({|x,y|cRotina(x,y)},aCabec,aItem,3)
				EndIf
				lMSHelpAuto := .F.
				If lMSErroAuto
					cNomArqErro := NomeAutoLog()
					cNomNovArq  := __RELDIR+"DADOSSIGA.##R"
					If MsErase(cNomNovArq)
						__CopyFile(cNomArqErro,cNomNovArq)
					EndIf
					MsErase(cNomArqErro)
					fVerLog()
					MsgStop("Falha na gravacao da movimentacao da Rotina "+cRotina+", tente novamente.","Aviso")
					Conout("Falha na gravacao da movimentacao da Rotina "+cRotina+", tente novamente.","Aviso")
				Else
					//ATUALIZA CAMPOS DE SINCRONIZACAO NA BASE OFICIAL
					cChave := "TRB2->"+cRel1
					cQuery := " UPDATE  "+DATASOURCE+RetSqlName(cTabela)+""
					//cQuery += " OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=192.168.0.120\SIGA; USER ID=SIGAWEB;PASSWORD=SIGAWEB').DADOSWEB.dbo."+RetSqlName(TRB1->CAMPO1)+""
					cQuery += " SET "+cSincD+" = '"+dTos(Date())+"' , "+cSincH+" = '"+SubStr(Time(),1,5)+"' WHERE "+cSincH+" = '' AND  "+cSincD+" = ''"
					cQuery += " AND "+cRel1+" = '"+&cChave+"'""
					MemoWrite("DADOSSIGAd.SQL",cQuery)
					TcSqlExec(cQuery)
					
					If nTabela ==2
						cChave := "TRB2->"+cRel1
						//ATUALIZA CAMPOS DE SINCRONIZACAO NA BASE OFICIAL DA TABELA SECUNDARIA
						cQuery := " UPDATE  "+DATASOURCE+RetSqlName(cTabela2)+""
						//cQuery += " OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=192.168.0.120\SIGA; USER ID=SIGAWEB;PASSWORD=SIGAWEB').DADOSWEB.dbo."+RetSqlName(TRB1->CAMPO2)+""
						cQuery += " SET "+cSincD+" = '"+dTos(Date())+"' , "+cSincH+" = '"+SubStr(Time(),1,5)+"' WHERE "+cSincH+" = '' AND  "+cSincD+" = ''"
						cQuery += " AND "+TRB1->RELA2+" = '"+&cChave+"'""
						MemoWrite("DADOSSIGAf.SQL",cQuery)
						TcSqlExec(cQuery)
					EndIf
				EndIf
				
			EndIf
			DbSelectArea("TRB2")
			dbSkip()
		End
	EndIf
	TRB2->(dbCloseArea())
	
	
	DbSelectArea("TRB1")
	dbSkip()
End
TRB1->(dbCloseArea())
Return
