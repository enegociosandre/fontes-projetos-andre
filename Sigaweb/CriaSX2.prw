#include "rwmake.ch"  
#include "topconn.ch"  

User Function CriaSX2   
Local aTabelas		:= {"SX3"}//,"SX2","SX3"}//,"SX5","SX7","SXA","SXB"}
Local ExisteX2		:= .F.
Local aEstrutura2	:= {} 
Local aEstrutura3	:= {} 
Local cQueryA		:= ""
Local cQuery3		:= ""
Local cQuery		:= "" 
Local aCampos		:= {}
Local aAlt			:= {}
Local cAliasDbf		:= "SX3"
Local cAlias		:= ""
Local lAltEst		:= .F.
Private cCampos		:= ""
Private cPerg		:= "CRIASX"  
//ValidPerg()
//pergunte(cPerg,.T.)      

//VERIFICA SE ESTA SENDO EXECUTADO VIA MENU OU SCHEDULE
If Select("SX6") == 0
//	PREPARE ENVIRONMENT EMPRESA SM0->M0_CODIGO FILIAL SM0->M0_FILIAL
	//lWeb	  	:= IsBlind()
EndIf

For k:= 1 to Len(aTabelas)
aEstrutura3		:= {}
cQueryA			:= ""
cQuery3			:= ""
cQuery			:= ""
aCampos			:= {}
aAlt			:= {}
//cAliasDbf	:= mv_par01
cAliasDbf	:= aTabelas[k]
//monta a query com os dados da estrutura da SX3 que estao armazenadas na aEstrutura3
cAlias		:= cAliasDbf+"VETI"+SM0->M0_CODIGO+"0"
DbSelectArea(cAliasDbf)
aEstrutura3 := DbStruct()   

cQuery3 		:= " If NOT EXISTS (SELECT * FROM sysobjects WHERE NAME = '" + cAlias + "')"
cQuery3			+= " CREATE table "+cAlias+" ("
For n:= 1 to Len(aEstrutura3)-1
	cQuery3		+= " "+ aEstrutura3[n][1] + " "
	If aEstrutura3[n][2] = 'C' .or. aEstrutura3[n][2] = 'D'
		cQuery3		+= "VARCHAR(" + ALLTRIM(STR(aEstrutura3[n][3])) + "),"
	ElseIf aEstrutura3[n][2] = 'N'
		cQuery3		+= "FLOAT,"    
	Else
		//Alert("Tipo de campo não previsto! Tipo:"+aEstrutura3[n][2])
	EndIf 
Next

If aEstrutura3[Len(aEstrutura3)][2] = 'C'
	cQuery3		+= aEstrutura3[Len(aEstrutura3)][1] + " VARCHAR(" + ALLTRIM(STR(aEstrutura3[Len(aEstrutura3)][3])) + ")"
ElseIf aEstrutura3[Len(aEstrutura3)][2] = 'N'
	cQuery3		+= aEstrutura3[Len(aEstrutura3)][1] + " FLOAT"    
Else
	//Alert("Tipo de campo não previsto! Tipo:"+aEstrutura3[Len(aEstrutura3)][2])
EndIf 
cQuery3		+= ")"                                                      
       
//Alert(cQuery3)
TcSqlExec(cQuery3)

    
DbSelectArea(cAliasDbf)
DbSetOrder(1)
DbGoTop()
cCampos		:= "" 
aEstrutura3		:=DbStruct() 
For n:=1 to Len(aEstrutura3) 
	cCampos		+=aEstrutura3[n,1]+","
Next 

cCampos		:= SubStr(cCampos,1,(Len(cCampos)-1))
cCampos		:= "{" + ALLTRIM(cCampos) + "}"
//Alert(cCampos)
//cCampos	:= "{X3_CAMPO,X3_ORDEM,X3_ORDEM}"
While !EOF()
	AADD(aCampos, &cCampos)
	DbSkip()
EndDo                                                         

//Retira o caracter ' dos campos que iriam dar erro nas querys
For n:=1 to Len(aCampos)
	For x:=1 to Len(aEstrutura3)
		If aEstrutura3[x,2] <> "N"
			aCampos[n,x]		:= StrTran(aCampos[n,x],"'",'"')
		EndIf
	Next
Next

//Alert(Len(aCampos))
cCampos		:= "(" + SubStr(cCampos,2,(Len(cCampos)-2)) + ")" 

//verifica se foram excluidos campos da SX?.dbf para deletar na tabela SQL tambem
cQuery3		:= " SELECT * FROM " +cAlias+ " ORDER BY " + aEstrutura3[1,1]+ "," +aEstrutura3[2,1]+ "," +aEstrutura3[3,1]+ "," +aEstrutura3[4,1]
MemoWrite("CriaSX3a.sql",cQuery3)
TcQuery cQuery3 New Alias "X3"  
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
	//n		:= 0
EndDo             
//Alert("TcSqlExec()"+cQueryEx) 
X3->(DbCloseArea())

//verifica inclusoes e alteracoes na SXs.dbf
For n := 1 to Len(aCampos)    

	cQuery:= " SELECT * FROM " + cAlias+ " WHERE " + aEstrutura3[1,1] + " = '"+ALLTRIM(aCampos[n][1])+"' AND " 
	If cAliasDbf == "SX3"
		cQuery+= aEstrutura3[3,1] + " = '"+ALLTRIM(aCampos[n][3])+"' AND " +aEstrutura3[4,1] + " = '"+ALLTRIM(aCampos[n][4])+"'"
	Else
		cQuery+= aEstrutura3[2,1] + " = '"+ALLTRIM(aCampos[n][2])+"' AND " +aEstrutura3[3,1] + " = '"+ALLTRIM(aCampos[n][3])+"' AND " +aEstrutura3[4,1] + " = '"+ALLTRIM(aCampos[n][4])+"'"
	EndIf
	TcQuery cQuery New Alias "EXIST"  
	

	
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
	    /*If cAliasDbf == "SX3"
	    	cQueryC		:= "IF (SELECT X3_TAMANHO, X3_DECIMAL FROM SX3VETI010 WHERE X3_CAMPO = " +ALLTRIM(aCampos[n][3])+ ") = " +aCampos[n][5]
	    EndIf*/
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
		If cAliasDbf == "SX3" .or. cAliasDbf == "SXA" 
			cQueryC		+= aEstrutura3[3,1] + " = '"+ALLTRIM(aCampos[n][3])+"' AND " +aEstrutura3[4,1] + " = '"+ALLTRIM(aCampos[n][4])+"'"
		Else
			cQueryC		+= aEstrutura3[2,1] + " = '"+ALLTRIM(aCampos[n][2])+"' AND " +aEstrutura3[3,1] + " = '"+ALLTRIM(aCampos[n][3])+"' AND " +aEstrutura3[4,1] + " = '"+ALLTRIM(aCampos[n][4])+"'"
		EndIf
	EndIF	
		TcSqlExec(cQueryC)
		//Alert(cQueryC)
		EXIST->(DbCloseArea())
Next
//Alert("TcSqlExec()"+cQueryC) 
//Alert(TcSqlError())
//Alert(nrec)


//replica a alteracao na especifico na SX3 para a estrutura da tabela que foi incluido ou excluido o campo
For n:=1 to Len(aAlt)
	//Alert(aAlt[n,1] + " " + aAlt[n,2] + " " + STR(aAlt[n,4])) 
	If aAlt[n,2] == "Incluido" 
		If aAlt[n,6] == "N"
			cQueryA		:= "ALTER TABLE "+ aAlt[n,1] + "VETI"+SM0->M0_CODIGO+"0 ADD " + aAlt[n,3] + " float(" + ALLTRIM(STR(aAlt[n,5])) + ")"
		Else
			cQueryA		:= "ALTER TABLE "+ aAlt[n,1] + "VETI"+SM0->M0_CODIGO+"0 ADD " + aAlt[n,3] + " varchar(" + ALLTRIM(STR(aAlt[n,5])) + ")"
		EndIf
	ElseIf aAlt[n,2] == "Excluido"
		If cAliasDbf == "SX2"
			cQueryA		:= "DROP TABLE "+aAlt[n,3]+"VETI"+SM0->M0_CODIGO+"0"
		Else
			cQueryA		:= "ALTER TABLE "+ aAlt[n,1] + "VETI"+SM0->M0_CODIGO+"0 DROP COLUMN " + aAlt[n,3] 
		EndIf
	Else
		cQueryA		:= "ALTER TABLE "+ aAlt[n,1] + "VETI"+SM0->M0_CODIGO+"0 ALTER COLUMN " + aAlt[n,3] + " varchar(" + ALLTRIM(STR(aAlt[n,5])) + ")"
	EndIf
	//Alert(cQueryA)
	TcSqlExec(cQueryA)
Next    
Next 
Alert("Finalizado com sucesso")
Return     

Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := PADR(cPerg,6)
aRegs   :={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Tabela             ?","","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For w_i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[w_i,2])
		RecLock("SX1",.T.)
		For w_j:=1 to FCount()
			If w_j <= Len(aRegs[w_i])
				FieldPut(w_j,aRegs[w_i,w_j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return          