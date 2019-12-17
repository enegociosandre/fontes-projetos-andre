#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE cEOL CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRelatorio ³RELCTB01  ºAutor  ³Ademar P. Silva Jr. º Data ³  29/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³NFs nao contabilizadas.								  	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RELCTB01()  // u_RELCTB01()
Local cPerg		:= "RELCTB01"

cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return
EndIf

MsgRun("Preparando relatório ...","Aguarde",{ || RunRelat() })

Return

Static Function RunRelat()
Local cQuery 	:= ""
Local cAlias 	:= ""
Local cPref 	:= ""
Local oPrint	:= Nil
Local nLinha	:= 0                 

Local cTitulo	:= "Não contabilizados"
Local cTit1		:= ""
Local cTit2		:= ""
Local cTit3		:= ""         
Local cTit4		:= ""         
Local cTit5		:= ""         
Local cTit6		:= ""         

Local nIniItn	:= 50
Local nQntItn	:= nIniItn

Private oFontT		:= TFont():New("Arial",09,15,,.T.,,,,,.F.)
Private oFont1 		:= TFont():New("Arial",09,10,,.F.,,,,,.F.)
Private oFont1B 	:= TFont():New("Arial",09,10,,.T.,,,,,.F.)

	If mv_par03 == 1 .Or. mv_par03 == 2         
		cTitulo += If(mv_par03 == 1," - Documento de Entrada"," - Documento de Saída")
		cAlias 	:= If(mv_par03 == 1,"SF1","SF2")
		cAlias2 := If(mv_par03 == 1,"SA2","SA1")
		cPref 	:= If(mv_par03 == 1,"F1","F2")
		cPref2 	:= If(mv_par03 == 1,"A2","A1")

		cTit1		:= "Documento"
		cTit2		:= "Série"
		cTit3		:= "Valor"
		cTit4		:= "TES Contab."
		cTit5		:= "Nome"
		cTit6		:= "Data"
		
		cQuery := 	"SELECT " + cEOL
		cQuery += 	"DISTINCT " + cEOL
		cQuery += 		cPref + "_DOC INF1," + cPref + "_SERIE INF2," + cPref + "_VALBRUT INF3,CT2_LOTE SHOW,"+ cEOL
		cQuery += 		If(mv_par03 == 1,"A2_NOME INF5,","A1_NOME INF5,") + cPref + "_" + If(mv_par03 == 1,"DTDIGIT INF6 ","EMISSAO INF6 ") + cEOL
		cQuery += 	"FROM " + cEOL
		cQuery += 		RetSQLName(cAlias) + " " + cPref + cEOL

		cQuery += 	"INNER JOIN " + cEOL
		cQuery += 		RetSQLName(cAlias2) + " " + cAlias2 + " " + cEOL                                      
		cQuery += 	"ON " + cEOL                                      			
		cQuery += 		cPref2 + "_COD = " + cPref + "_" + If(mv_par03 == 1,"FORNECE","CLIENTE") + " AND " + cEOL                                      			
		cQuery += 		cPref2 + "_LOJA = " + cPref + "_LOJA AND " + cEOL                                      			
		cQuery += 		cAlias2 + ".D_E_L_E_T_ = ' ' " + cEOL                                      			
		
		If mv_par03 == 2
			cQuery += 	"INNER JOIN " + cEOL
			cQuery += 		RetSQLName("SD2") + " SD2 " + cEOL
			cQuery += 	"ON " + cEOL
			cQuery += 		"D2_DOC = F2_DOC AND " + cEOL
			cQuery += 		"D2_SERIE = F2_SERIE AND " + cEOL
			cQuery += 		"SD2.D_E_L_E_T_ = ' ' " + cEOL
				
			cQuery += 	"INNER JOIN " + cEOL
			cQuery += 		RetSQLName("SF4") + " SF4 " + cEOL
			cQuery += 	"ON " + cEOL
			cQuery += 		"F4_CODIGO = D2_TES AND " + cEOL
			cQuery += 		"SF4.D_E_L_E_T_ = ' ' " + cEOL
		Else
			cQuery += 	"INNER JOIN " + cEOL
			cQuery += 		RetSQLName("SD1") + " SD1 " + cEOL                                      
			cQuery += 	"ON " + cEOL                                      			
			cQuery += 		"D1_DOC = F1_DOC AND " + cEOL                                      			
			cQuery += 		"D1_SERIE = F1_SERIE AND " + cEOL                                      			
			cQuery += 		"SD1.D_E_L_E_T_ = ' ' " + cEOL                                      			

			cQuery += 	"INNER JOIN " + cEOL
			cQuery += 		RetSQLName("SF4") + " SF4 " + cEOL                                      
			cQuery += 	"ON " + cEOL                                      			
			cQuery += 		"F4_CODIGO = D1_TES AND " + cEOL                                      			
			cQuery += 		"SF4.D_E_L_E_T_ = ' ' " + cEOL                                      			
		EndIf

		cQuery += 	"LEFT JOIN " + cEOL
		cQuery += 		RetSQLName("CT2") + " CT2 " + cEOL                                      
		cQuery += 	"ON " + cEOL
		cQuery += 		"CT2_FILIAL = '" + xFilial("CT2") + "' AND " + cEOL
		cQuery += 		"CT2_ZZDOC = " + cPref + "_DOC AND " + cEOL
		cQuery += 		"CT2_ZZSERI = " + cPref + "_SERIE AND " + cEOL
		cQuery += 		If(mv_par03 == 1,"CT2_ZZFORN = F1_FORNECE AND ","CT2_ZZCLIE = F2_CLIENTE AND ") + cEOL
		cQuery += 		If(mv_par03 == 1,"CT2_ZZLOJF = F1_LOJA AND ","CT2_ZZLOJC = F2_LOJA AND ") + cEOL
		cQuery += 		"CT2_ZZTPNF = " + If(mv_par03 == 1,"F1_TIPO AND ","F2_TIPO AND ") + cEOL
		cQuery += 		"CT2.D_E_L_E_T_ = ' ' " + cEOL

		cQuery += 	"WHERE " + cEOL
		cQuery += 		cPref + "_FILIAL = '" + xFilial(cAlias) + "' AND " + cEOL
		cQuery += 		cPref + "_" + If(mv_par03 == 1,"DTDIGIT","EMISSAO") +  " "
		cQuery += 		"BETWEEN  '" + AllTrim(DtoS(mv_par01)) + "' AND '" + AllTrim(DtoS(mv_par02)) + "' AND " + cEOL
		cQuery += 		cPref + ".D_E_L_E_T_ = ' ' " + cEOL
		
		cQuery += 	"ORDER BY " + cEOL
		cQuery += 		"INF1,INF2 "
	ElseIf  mv_par03 == 3 .Or. mv_par03 == 4
		cTitulo += If(mv_par03 == 3," - Contas a pagar"," - Contas a Receber")
		
		cAlias 	:= If(mv_par03 == 3,"SE2","SE1")
		cAlias2 := If(mv_par03 == 3,"SA2","SA1")
		cPref 	:= If(mv_par03 == 3,"E2","E1")
		cPref2 	:= If(mv_par03 == 3,"A2","A1")
    
		cTit1		:= "Número"
		cTit2		:= "Prefixo"
		cTit3		:= "Valor"
		cTit4		:= "TES Contab."
		cTit5		:= "Nome"
		cTit6		:= "Data"

		cQuery := 	"SELECT " + cEOL
		cQuery += 		cPref + "_NUM INF1," + cPref + "_PREFIXO INF2," + cPref + "_VALOR INF3,CT2_LOTE SHOW,"+ cEOL
		cQuery += 		If(mv_par03 == 3,"A2_NOME INF5,","A1_NOME INF5,") + cPref + "_EMISSAO INF6 " + cEOL
		cQuery += 	"FROM " + cEOL
		cQuery += 		RetSQLName(cAlias) + " " + cPref + cEOL
		cQuery += 	"LEFT JOIN " + cEOL
		cQuery += 		RetSQLName("CT2") + " CT2 " + cEOL
		cQuery += 	"ON " + cEOL
		cQuery += 		"CT2_FILIAL = '" + xFilial("CT2") + "' AND " + cEOL
		cQuery += 		"CT2_ZZNUM = " + cPref + "_NUM AND " + cEOL
		cQuery += 		"CT2_ZZPREF = " + cPref + "_PREFIXO AND " + cEOL
		cQuery += 		"CT2_ZZPARC = " + cPref + "_PARCELA AND " + cEOL
		cQuery += 		"CT2_ZZTPTI = " + cPref + "_TIPO AND " + cEOL
		cQuery += 		"CT2.D_E_L_E_T_ = ' ' " + cEOL

		cQuery += 	"INNER JOIN " + cEOL
		cQuery += 		RetSQLName(cAlias2) + " " + cAlias2 + " " + cEOL                                      
		cQuery += 	"ON " + cEOL                                      			
		cQuery += 		cPref2 + "_COD = " + cPref + "_" + If(mv_par03 == 3,"FORNECE","CLIENTE") + " AND " + cEOL                                      			
		cQuery += 		cPref2 + "_LOJA = " + cPref + "_LOJA AND " + cEOL                                      			
		cQuery += 		cAlias2 + ".D_E_L_E_T_ = ' ' " + cEOL                                      			

		cQuery += 	"WHERE " + cEOL
		cQuery += 		cPref + "_FILIAL = '" + xFilial(cAlias) + "' AND " + cEOL
		cQuery += 		cPref + "_EMISSAO BETWEEN  '" + AllTrim(DtoS(mv_par01)) + "' AND '" + AllTrim(DtoS(mv_par02)) + "' AND " + cEOL
		cQuery += 		cPref + ".D_E_L_E_T_ = ' '" + cEOL
		cQuery += 	"ORDER BY " + cEOL
		cQuery += 		"INF1,INF2 "
    EndIf


	TcQuery cQuery ALIAS TQRY NEW
	
//	memowrite("qry.txt",cQuery)
		
	oPrint := TMSPrinter():New()
	oPrint:StartPage()
	oPrint:SetPortrait()
    
	PrtHeader(oPrint,cTitulo,cTit1,cTit2,cTit3,cTit4,cTit5,cTit6,@nLinha)	
	
	If TQRY->(EOF())
		oPrint:Say(nLinha,50,'Sem dados para imprimir...',oFont1,100,,,0)
	EndIf	
	
	While TQRY->(!EOF())

		If nQntItn == 0
			oPrint:Line(nLinha,40,nLinha,2160)
			oPrint:EndPage()		
			oPrint:StartPage()
			oPrint:SetPortrait()             
			nQntItn := nIniItn
			PrtHeader(oPrint,cTitulo,cTit1,cTit2,cTit3,cTit4,cTit5,cTit6,@nLinha)
		EndIf
	
		If Empty(AllTrim(TQRY->SHOW))
			oPrint:Line(nLinha - 5,40,nLinha - 5,2160)
			oPrint:Line(nLinha - 5,40,nlinha + 50,40)
			
			oPrint:Line(nLinha - 5,340,nlinha + 50,340)
			oPrint:Line(nLinha - 5,640,nlinha + 50,640)
			oPrint:Line(nLinha - 5,960,nlinha + 50,960)

			oPrint:Line(nLinha - 5,1260,nlinha + 50,1260)
			oPrint:Line(nLinha - 5,1860,nlinha + 50,1860)
			oPrint:Line(nLinha - 5,2160,nlinha + 50,2160)
	
			cAuxCmp := "TQRY->INF1"
			oPrint:Say(nLinha,50,&cAuxCmp,oFont1,100,,,0)
			cAuxCmp := "TQRY->INF2"
			oPrint:Say(nLinha,350,&cAuxCmp,oFont1,100,,,0)
			cAuxCmp := "AllTrim(Transform(TQRY->INF3,'@e 9999,999,999.99'))"
			oPrint:Say(nLinha,650,&cAuxCmp,oFont1,100,,,0)
			cAuxCmp := "SUBSTR(ALLTRIM(TQRY->INF5),1,30)"
			oPrint:Say(nLinha,1270,&cAuxCmp,oFont1,100,,,0)
			cAuxCmp := "ALLTRIM(DTOC(STOD(TQRY->INF6)))"
			oPrint:Say(nLinha,1870,&cAuxCmp,oFont1,100,,,0)
			nLinha += 50
			nQntItn -= 1
		EndIf
		
		TQRY->(DbSkip())
	EndDo 
	oPrint:Line(nLinha,40,nLinha,2160)  
	TQRY->(DbCloseArea())	
	oPrint:EndPage()
	
	
	&& Por Fabio Assarice em 04/05/11
	&& Solicitado por Viviane Fantinati para emitir dados de titulos nao contabilizado e 
	&& nao existem no faturamento, ou esta sem o lancamento de exclusao
	If mv_par03 == 2  && Documento de saida

		cQuery := " SELECT"
		cQuery += " 	CT2_ZZNUM AS INF1, CT2_ZZPREF AS INF2, SUM(CASE WHEN CT2_CREDIT='' THEN CT2_VALOR ELSE CT2_VALOR*-1 END) AS INF3, "
		cQuery += " 	'' AS INF5,Max(CT2_DATA) AS INF6, MAX(F2_CLIENTE) AS CLIENTE"
		cQuery += " FROM "
		cQuery += " 	"+RetSqlName('CT2')+" CT2"
		cQuery += " LEFT JOIN"
		cQuery += " 	"+RetSqlName('SF2')+" SF2"
		cQuery += " 	ON F2_FILIAL = CT2_FILIAL AND F2_DOC = CT2_ZZNUM AND F2_SERIE = CT2_ZZPREF AND SF2.D_E_L_E_T_ = ' '"
		cQuery += " WHERE"
		cQuery += " 	CT2_FILIAL = '"+xFilial('CT2')+"'"
		cQuery += " 	AND (CT2_DATA >= '"+DtoS(mv_par01)+"'"
		cQuery += " 	AND CT2_DATA <= '"+DtoS(mv_par02)+"')"
		cQuery += " 	AND (CT2_ZZNUM <> '' "
		cQuery += " 	AND CT2_ZZPREF <> '')"
		cQuery += " 	AND SUBSTRING(CT2_LOTE,1,3)='FAT'"
		cQuery += " 	AND CT2.D_E_L_E_T_ = ' '"
		cQuery += " GROUP BY"
		cQuery += "     CT2_FILIAL,CT2_ZZNUM,CT2_ZZPREF"
	
		TcQuery cQuery ALIAS TQRY NEW	
		oPrint:StartPage()
		PrtHeader(oPrint,'Críticas - Contabilidade x Faturamento','Documento','Serie','Valor',cTit4,cTit5,'Data',@nLinha)
		nQntItn := nIniItn
		If TQRY->(EOF())
			oPrint:Say(nLinha,50,'Sem dados para imprimir...',oFont1,100,,,0)
		Else	
			While TQRY->(!EOF())
		
				If nQntItn == 0
					oPrint:Line(nLinha,40,nLinha,2160)
					oPrint:EndPage()		
					oPrint:StartPage()
					oPrint:SetPortrait()             
					nQntItn := nIniItn
				EndIf
		        
				If (AllTrim(TQRY->CLIENTE)!='' .AND. TQRY->INF3 > 0) .OR. AllTrim(TQRY->F2_CLIENTE)==''
					oPrint:Line(nLinha - 5,40,nLinha - 5,2160)
					oPrint:Line(nLinha - 5,40,nlinha + 50,40)
					
					oPrint:Line(nLinha - 5,340,nlinha + 50,340)
					oPrint:Line(nLinha - 5,640,nlinha + 50,640)
					oPrint:Line(nLinha - 5,960,nlinha + 50,960)
		
					oPrint:Line(nLinha - 5,1260,nlinha + 50,1260)
					oPrint:Line(nLinha - 5,1860,nlinha + 50,1860)
					oPrint:Line(nLinha - 5,2160,nlinha + 50,2160)
			
					cAuxCmp := "TQRY->INF1"
					oPrint:Say(nLinha,50,&cAuxCmp,oFont1,100,,,0)
					cAuxCmp := "TQRY->INF2"
					oPrint:Say(nLinha,350,&cAuxCmp,oFont1,100,,,0)
					cAuxCmp := "AllTrim(Transform(TQRY->INF3,'@e 9999,999,999.99'))"
					oPrint:Say(nLinha,650,&cAuxCmp,oFont1,100,,,0)
					cAuxCmp := "SUBSTR(ALLTRIM(TQRY->INF5),1,30)"
					oPrint:Say(nLinha,1270,&cAuxCmp,oFont1,100,,,0)
					cAuxCmp := "ALLTRIM(DTOC(STOD(TQRY->INF6)))"
					oPrint:Say(nLinha,1870,&cAuxCmp,oFont1,100,,,0)
					nLinha += 50
					nQntItn -= 1
				EndIf		
				TQRY->(DbSkip())	
			EndDo	
		EndIf
		&& Encerra o relatorio
		oPrint:Line(nLinha,40,nLinha,2160)  
		TQRY->(DbCloseArea())	
		oPrint:EndPage()
		
	EndIf                       
	&& Fim


	&& MsDialog oDlg: exibi as opcoes para tratativa do relatorio.
	Define MsDialog oDlg Title cTitulo From 0,0 To 80,430 Pixel
	Define Font oBold Name "Arial" Size 0, -13 Bold
		@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30, 120 NoBorder When .f. Pixel
		@ 003, 040 Say cTitulo Font oBold Pixel
		@ 014, 030 To 016, 400 Label '' Of oDlg  Pixel
		@ 020, 040 Button "Configurar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Setup()
		@ 020, 082 Button "Imprimir"   	Size 40, 13 Pixel Of oDlg Action oPrint:Print()
		@ 020, 124 Button "Visualizar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Preview()
		@ 020, 166 Button "Sair"       	Size 40, 13 Pixel Of oDlg Action oDlg:End()
	Activate MsDialog oDlg Centered

Return      


&& Function	: PrtHeader(oPrint)
&& Desc.	: Imprime cabecalho
Static Function PrtHeader(oPrint,cTitulo,cTit1,cTit2,cTit3,cTit4,cTit5,cTit6,nLinha)
	nLinha := 100

	oPrint:Say(nLinha,50,cTitulo,oFontT,100,,,0)

	nLinha := 200

	oPrint:Say(nLinha,050,cTit1,oFont1B,100,,,0)
	oPrint:Say(nLinha,350,cTit2,oFont1B,100,,,0)
	oPrint:Say(nLinha,650,cTit3,oFont1B,100,,,0)
	oPrint:Say(nLinha,970,cTit4,oFont1B,100,,,0)
	oPrint:Say(nLinha,1270,cTit5,oFont1B,100,,,0)
	oPrint:Say(nLinha,1870,cTit6,oFont1B,100,,,0)

	oPrint:Line(nLinha - 5,40,nLinha - 5,2160)
	oPrint:Line(nLinha - 5,40,nlinha + 50,40) // Colunas
	oPrint:Line(nLinha - 5,340,nlinha + 50,340) // Colunas
	oPrint:Line(nLinha - 5,640,nlinha + 50,640) // Colunas
	oPrint:Line(nLinha - 5,960,nlinha + 50,960) // Colunas
	oPrint:Line(nLinha - 5,1260,nlinha + 50,1260) // Colunas
	oPrint:Line(nLinha - 5,1860,nlinha + 50,1860) // Colunas
	oPrint:Line(nLinha - 5,2160,nlinha + 50,2160) // Colunas

	nLinha += 50
Return


&& Function	: ValidPerg(cPerg)
&& Desc.	: Cria grupo de perguntas
Static Function ValidPerg(cPerg)
Local _sAlias := Alias()
Local aRegs := {}
Local i,j
Local lRet := .T.

SX1->(DbSelectArea("SX1"))
SX1->(DbSetOrder(1))

If SX1->(DbSeek(cPerg))
	Return
EndIf

&& Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Digitacao de ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Digitacao ate","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Tipo de NF   ","","","mv_ch3","N",01,0,1,"C","","mv_par03","Entrada","","","","","Saida","","","","","Cnt Pagar","","","","","Cnt Receber"})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

DbSelectArea(_sAlias)

Return(lRet)