#include "Protheus.ch" 
#include "Rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRIASX    ºAutor  ³Microsiga           º Data ³  05/24/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CriaSX(cEmp,cFil)

Private oEXPORT
Private lDrop      := .f.
Private lTudo      := .T.
Private cTimeStart := Time()
Private cTimeEnd	 := Time()
Private lSched		:= .F.    

//VERIFICA SE ESTA SENDO EXECUTADO VIA MENU OU SCHEDULE
If Select("SX6") == 0
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil
	lSched		:= .T.
	RunCont()
Else
	@ 200,001 TO 380,400 DIALOG oEXPORT TITLE OemToAnsi("Exporta para WEB")
	@ 002,010 TO 080,190
	@ 010,018 Say " Este programa ira copiar os SXS e sincroniza-los   "
	@ 018,018 Say " do ambiente selecionado para web.                  "
	
	@ 70,128 BMPBUTTON TYPE 01 ACTION (OkEXPORT(),oEXPORT:End())
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oEXPORT)
	
	Activate Dialog oEXPORT Centered
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EXPORTDTC ºAutor  ³Microsiga           º Data ³  10/26/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function OkEXPORT()

Processa({|| RunCont() },"Processando...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SINCRO    ºAutor  ³Microsiga           º Data ³  05/23/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunCont()
Local aTabelas		:= {"SX3"} //{"SM0","SX1","SX2","SX3","SX5","SX7","SXA","SXB"}
Local ExisteX2		:= .F.
Local aEstrutura2	:= {}
Local aEstrutura3	:= {}
Local cQueryA		:= ""
Local cQuery3		:= ""
Local cQuery		:= ""
Local aCampos		:= {}
Local aAlt			:= {}
Local cAliasDbf		:= ""
Local cAlias		:= ""
Local lAltEst		:= .F.
Local lSM0			:= .F.
Local aEmp1			:= {}
Local cEmp
Private cCampos		:= ""
Private cPerg		:= "CRIASX"


dbSelectArea("SM0")
cEmp := SM0->M0_CODIGO
dbGoTop()
While !Eof()
	If !SM0->M0_CODIGO $ "04"
		dbSkip()
		Loop
	EndIf
	If Ascan(aEmp1, {|x| x[1] == SM0->M0_CODIGO})==0
		aAdd(aEmp1,{SM0->M0_CODIGO,SM0->(Recno())})
	EndIf
	dbSkip()
End


For d:= 1 To Len(aEmp1)
	dbSelectArea("SM0")
	dbGoTo(aEmp1[d][2])
	If !lSched
		ProcRegua(Len(aTabelas))
	EndIf
	For k:= 1 to Len(aTabelas)
		
		
		aEstrutura3		:= {}
		cQueryA			:= ""
		cQuery3			:= ""
		cQuery			:= ""
		aCampos			:= {}
		aAlt			:= {}
		
		
		//monta a query com os dados da estrutura da SX3 que estao armazenadas na aEstrutura3
		
		If aTabelas[k] =="SM0" .And. !lSM0
			cAlias		:= "SIGAMATVETI"
			cAliasDbf	:= aTabelas[k]
			lSM0		:= .T.
		ElseIf aTabelas[k] =="SM0" .And. lSM0
			k++
			cAliasDbf	:= aTabelas[k]
			cAlias		:= cAliasDbf+"VETI"+SM0->M0_CODIGO+"0"
		Else
			cAliasDbf	:= aTabelas[k]
			cAlias		:= cAliasDbf+"VETI"+SM0->M0_CODIGO+"0"
		EndIf
		If !lSched
			IncProc(OemToAnsi("Tabela ")+aTabelas[k]+" da Empresa: "+aEmp1[d][1])
			ProcessMessages()
		EndIf
		
		If SM0->M0_CODIGO # cEmp .And. !aTabelas[k] $ "SM0|SX5"
			cNemp := cAliasDbf+SM0->M0_CODIGO+"0"
			dbUseArea(.T.,"DBFCDXADS",cNemp,cNemp,.T.,.F.)
			DbSelectArea(cNemp)
		Else
			DbSelectArea(cAliasDbf)
		EndIf
		
		If cAliasDbf == "SX5"
			
			cQuery := "DELETE FROM SX5"+SM0->M0_CODIGO+"0
			TcSqlExec(cQuery)
			
			cQuery := " INSERT INTO SX5"+SM0->M0_CODIGO+"0
//			cQuery += " SELECT * FROM  OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=192.168.1.5; USER ID = sa;PASSWORD = Linksys1').PARAIBUNA.dbo.SX5"+SM0->M0_CODIGO+"0"
			cQuery += " OPENDATASOURCE('SQLOLEDB', 'DATA SOURCE=DESKTOP-C6DUM7E\SQLEXPRESS; USER ID=sa;PASSWORD=sa').database.dbo.+SX5"+SM0->M0_CODIGO+"0"
			cQuery += " WHERE D_E_L_E_T_ <> '*'  "
			MEMOWRITE("CRIASXf.SQL",cQuery)
			TcSqlExec(cQuery)
		EndIf
		
		If cAliasDbf # "SX5"
			
			aEstrutura3 := DbStruct()
			
			cQuery3 		:= " If NOT EXISTS (SELECT * FROM sysobjects WHERE NAME = '" + cAlias + "')"
			cQuery3			+= " CREATE table "+cAlias+" ("
			For n:= 1 to Len(aEstrutura3)-1
				cQuery3		+= " "+ aEstrutura3[n][1] + " "
				If aEstrutura3[n][2] = 'C' .or. aEstrutura3[n][2] = 'D'
					cQuery3		+= "VARCHAR(" + ALLTRIM(STR(aEstrutura3[n][3])) + "),"
				ElseIf aEstrutura3[n][2] = 'N'
					cQuery3		+= "FLOAT,"
				EndIf
			Next
			
			If aEstrutura3[Len(aEstrutura3)][2] = 'C'
				cQuery3		+= aEstrutura3[Len(aEstrutura3)][1] + " VARCHAR(" + ALLTRIM(STR(aEstrutura3[Len(aEstrutura3)][3])) + ")"
			ElseIf aEstrutura3[Len(aEstrutura3)][2] = 'N'
				cQuery3		+= aEstrutura3[Len(aEstrutura3)][1] + " FLOAT"
			EndIf
			cQuery3		+= ")"
			MemoWrite("CRIASX.SQL",cQuery3)
			TcSqlExec(cQuery3)
			
			If cAliasDbf # "SX7"
				//ADICIONA CAMPOS NO SX3
				If cAliasDbf == "SX3"
					//inclui o campo X3_VISINT no SQL
					cQueryA		:= "ALTER TABLE "+ cAlias +"  ADD  X3_VISINT  char(1) NOT NULL  DEFAULT  '"+Space(1)+"' "
					MemoWrite("CRIASXa.SQL",cQuery3)
					TcSqlExec(cQueryA)
					
					//inclui o campo X3_ORDAUT no SQL
					cQueryA		:= "ALTER TABLE "+ cAlias +"  ADD X3_ORDAUT varchar(2) NOT NULL  DEFAULT  '"+Space(21)+"' "
					MemoWrite("CRIASXb.SQL",cQuery3)
					TcSqlExec(cQueryA)
				EndIf
				
				
				If SM0->M0_CODIGO # cEmp .And. !aTabelas[k] $ "SM0|SX5"
					DbSelectArea(cNemp)
				Else
					DbSelectArea(cAliasDbf)
				EndIf
				DbSetOrder(1)
				DbGoTop()
				
				
				cCampos		:= ""
				aEstrutura3		:=DbStruct()
				//Prepara cCampos para receber todos os nomes dos campos da tabela SX para replicacao dos registros existentes nela
				For n:=1 to Len(aEstrutura3)
					cCampos		+=aEstrutura3[n,1]+","
				Next
				cCampos		:= SubStr(cCampos,1,(Len(cCampos)-1))
				cCampos		:= "{" + ALLTRIM(cCampos) + "}"
				//armazena os valores de todos os registros da SX na array aCampos
				//QUANDO FOR SX5 TEM DE PEGAR DA BASE DE DADOS SQL
				
				While !EOF()

					AADD(aCampos, &cCampos)
					DbSkip()
				EndDo
				
				//Retira o caracter ' dos campos que iriam dar erro nas querys
				For n:=1 to Len(aCampos)
					For x:=1 to Len(aEstrutura3)
						If !aEstrutura3[x,2] $ "DN"
							aCampos[n,x]		:= StrTran(aCampos[n,x],"'",'"')
						EndIf
					Next
				Next
				
				cCampos		:= "(" + SubStr(cCampos,2,(Len(cCampos)-2)) + ")"
				
				//verifica se foram excluidos campos da SX?.dbf para deletar na tabela SQL tambem
				cQuery3		:= " SELECT * FROM " +cAlias+ "  ORDER BY " + aEstrutura3[1,1]+ "," +aEstrutura3[2,1]+ "," +aEstrutura3[3,1]+ "," +aEstrutura3[4,1]
				MemoWrite("CriaSX3g.sql",cQuery3)
				dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery3),"X3", .F., .T.)
				DbSelectArea("X3")
				DbGoTop()
				cVar01			:= "X3->"+ALLTRIM(aEstrutura[1,1])
				cVar02			:= "X3->"+ALLTRIM(aEstrutura[2,1])
				cVar03			:= "X3->"+ALLTRIM(aEstrutura[3,1])
				cVar04			:= "X3->"+ALLTRIM(aEstrutura[4,1])
				cQueryEx		:= ""
				n2				:= 0
				While !EOF()
					n		:=Ascan(aCampos, {|x|	x[1] == &cVar01 .and. x[2] == &cVar02 .and. x[3] == &cVar03 .and. x[4] == &cVar04})
					If n == 0 .and. (cAliasDbf == "SX3" .or. cAliasDbf == "SXA")
						n		:= Ascan(aCampos, {|x|	x[1] == &cVar01 .and. x[3] == &cVar03 .and. x[4] == &cVar04})
					EndIf
					//Ocorre quando o registro da SX? foi deletado
					If n == 0 		// .and. !(Ascan(aCampos, {|x|	x[1] == &cVar01 .and. x[3] == &cVar03}) <> 0 .and. cAliasDbf == "SX3")
						cQueryEx	:= " DELETE  FROM " + cAlias + " WHERE " + aEstrutura3[1,1] + " = '"+ &cVar01 +"' AND "
						If cAliasDbf == "SX3" .or. cAliasDbf == "SXA"
							cQueryEx	+= aEstrutura3[3,1] + " = '"+ &cVar03 +"' AND " +aEstrutura3[4,1] + " = '"+ &cVar04 +"'"
						Else
							cQueryEx	+= aEstrutura3[2,1] + " = '"+ &cVar02 +"' AND " +aEstrutura3[3,1] + " = '"+ &cVar03 +"' AND " +aEstrutura3[4,1] + " = '"+ &cVar04 +"'"
						EndIf
						//Alert("CAampo " +aEstrutura3[3,1]+ " = " + &cVar03 + "foi excluida da SX3 sql.")
						
						If cAliasDbf == "SX3"
							AADD(aAlt,{X3->X3_ARQUIVO,"Excluido",X3->X3_CAMPO,1,X3->X3_TAMANHO})
						EndIf
						If cAliasDbf == "SX2"
							AADD(aAlt,{X3->X2_ARQUIVO,"Excluido",X3->X2_CHAVE})
						EndIf
						TcSqlExec(cQueryEx)
					Else		//no caso da SX3 ele pode ter sido alterado(alterar a estrutura da tabela)
						If cAliasDbf == "SX3"
							If X3->X3_TAMANHO <> aCampos[n,5]
								AADD(aAlt,{X3->X3_ARQUIVO,"Alterado",aCampos[n,3],5,aCampos[n,5]})
							EndIf
						EndIf
					EndIf
					DbSkip()
				EndDo
				X3->(DbCloseArea())
				
				//verifica inclusoes e alteracoes na SXs.dbf
				For n := 1 to Len(aCampos)
					
					cQuery:= " SELECT * FROM " + cAlias+ " WHERE " + aEstrutura3[1,1] + " = '"+ALLTRIM(aCampos[n][1])+"' AND "
					If cAliasDbf == "SX3"
						cQuery+= aEstrutura3[3,1] + " = '"+ALLTRIM(aCampos[n][3])+"' AND " +aEstrutura3[4,1] + " = '"+ALLTRIM(aCampos[n][4])+"'"
					Else
						cQuery+= aEstrutura3[2,1] + " = '"+ALLTRIM(aCampos[n][2])+"' AND " +aEstrutura3[3,1] + " = '"+ALLTRIM(aCampos[n][3])+"' AND " +aEstrutura3[4,1] + " = '"+ALLTRIM(aCampos[n][4])+"'"
					EndIf
					dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"EXIST", .F., .T.)

					
					
					
					COUNT TO NREC
					DbSelectArea("EXIST")
					If nRec <= 0
						
						cQueryC		:= " INSERT INTO "+cAlias+" "+cCampos+ " VALUES ("
						For coluna:=1 to Len(aEstrutura3)
							If aEstrutura3[coluna,2] == "N"
								cQueryC		+= +ALLTRIM(STR(aCampos[n][coluna]))+","
							ElseIf cAliasDbf == "SX3" .and. coluna == 26
								If SubStr(aCampos[n,19],1,1) == "ƒ" .or. aCampos[n,26] == "€"
									cQueryC		+= "'S',"
								Else
									cQueryC		+= "'',"
								EndIf
							Else
								cQueryC		+= "'"+ALLTRIM(aCampos[n][coluna])+"',"
							EndIf
						Next
						cQueryC		:= SubStr(cQueryC,1,(Len(cQueryC)-1)) + ")"
						//adiciona a array que guarda as tabelas que terao de alterar a estrutura
						If cAliasDbf == "SX3"
							AADD(aAlt,{aCampos[n,1],"Incluido",aCampos[n,3],1,aCampos[n,5],aCampos[n,4]})
						EndIf
					Else
						cQueryC		:= " UPDATE " + cAlias + " SET "
						For x:=1 to Len(aEstrutura3)
							cQueryC		+= ALLTRIM(aEstrutura3[x,1]) + " = "
							If aEstrutura[x,2] == "N"
								cQueryC		+= ALLTRIM(STR(aCampos[n][x]))+ ","
							ElseIf cAliasDbf == "SX3" .and. x == 26 .and. (aCampos[n,26] == "€" .or. SubStr(aCampos[n,19],1,1) == "ƒ")
								cQueryC		+= "'S',"
							Else
								cQueryC		+= "'"+ALLTRIM(aCampos[n][x])+ "',"
							EndIf
						Next
						cQueryC		:= SubStr(cQueryC,1,(Len(cQueryC)-1)) + " WHERE " + aEstrutura3[1,1] + " = '"+ALLTRIM(aCampos[n][1])+"' AND "
						//tratamento para a SX3 e a SXA onde os registros podem nao serem localizados na condicao WHERE pois existe o campo _ORDEM na posicao 2
						//nesses casos o campo ordem deve ser desconsiderado na busca, pois quando eh excluido a ordem muda para toda a sequencia abaixo.
						If cAliasDbf == "SX3" .or. cAliasDbf == "SXA"
							cQueryC		+= aEstrutura3[3,1] + " = '"+ALLTRIM(aCampos[n][3])+"' AND " +aEstrutura3[4,1] + " = '"+ALLTRIM(aCampos[n][4])+"'"
						Else
							cQueryC		+= aEstrutura3[2,1] + " = '"+ALLTRIM(aCampos[n][2])+"' AND " +aEstrutura3[3,1] + " = '"+ALLTRIM(aCampos[n][3])+"' AND " +aEstrutura3[4,1] + " = '"+ALLTRIM(aCampos[n][4])+"'"
						EndIf
					EndIF
					TcSqlExec(cQueryC)
					EXIST->(DbCloseArea())
				Next
				
				//replica a alteracao na especifico na SX3 para a estrutura da tabela que foi incluido ou excluido o campo
				For n:=1 to Len(aAlt)
					If aAlt[n,2] == "Incluido"
						If aAlt[n,6] == "N"
							cQueryA		:= "ALTER TABLE "+aAlt[n,1]+SM0->M0_CODIGO+"0 ADD " + aAlt[n,3] + " float(" + ALLTRIM(STR(aAlt[n,5])) + ") NOT NULL  DEFAULT  '"+Space(aAlt[n,5])+"' "
						Else
							cQueryA		:= "ALTER TABLE "+aAlt[n,1]+SM0->M0_CODIGO+"0 ADD " + aAlt[n,3] + " varchar(" + ALLTRIM(STR(aAlt[n,5])) + ") NOT NULL  DEFAULT  '"+Space(aAlt[n,5])+"' "
						EndIf
					ElseIf aAlt[n,2] == "Excluido"
						If cAliasDbf == "SX2"
							cQueryA		:= "DROP TABLE "+aAlt[n,1]+SM0->M0_CODIGO+"0"
						Else
							cQueryA		:= "ALTER TABLE "+aAlt[n,1]+SM0->M0_CODIGO+"0 DROP COLUMN " + aAlt[n,3]
						EndIf
					Else
						cQueryA		:= "ALTER TABLE "+aAlt[n,1]+SM0->M0_CODIGO+"0 ALTER COLUMN " + aAlt[n,3] + " varchar(" + ALLTRIM(STR(aAlt[n,5])) + ")"
					EndIf
					MemoWrite("CRIASXH.SQL",cQueryA)
					TcSqlExec(cQueryA)
				Next
			EndIf
		EndIf
		
		If lSM0
			dbSelectArea("SM0")
			dbGoTo(aEmp1[d][2])
			
		EndIf
	Next
Next
If !lSched
    Final("Finalizado com sucesso!")
Else
	Conout("Finalizado com sucesso!")
	RESET ENVIRONMENT
EndIf

Return

