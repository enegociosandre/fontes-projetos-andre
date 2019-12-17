#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

User Function AVALIATES()
Local oReport
If TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()	
EndIf
Return

Static Function ReportDef()
Local oReport
Local oTES

oReport := TReport():New("AVALIATES","Avaliador de TES",, {|oReport| ReportPrint(oReport)},"Avaliador de TES")	
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)                                                                                               

oTES := TRSection():New(oReport,"TES",{"TRB"})

TRCell():New(oTES,"TRB_TIPO"		,"TRB"    ,"Tipo",,8)
TRCell():New(oTES,"TRB_TES"			,"TRB"    ,"TES",,8)
TRCell():New(oTES,"TRB_CAMPO"		,"TRB"    ,"Campo Avaliado",,10)
TRCell():New(oTES,"TRB_NOMECAMP"	,"TRB"    ,"Titulo Campo",,20)
TRCell():New(oTES,"TRB_VLENCONT"	,"TRB"    ,"Valor Encontrado")
TRCell():New(oTES,"TRB_VLESPERA"	,"TRB"    ,"Valor Esperado  ")
TRCell():New(oTES,"TRB_DESCRIC"		,"TRB"    ,"Descricao",,120)

oBreak := TRBreak():New(oTES,oTES:Cell("TRB_TES"))

Return oReport


Static Function ReportPrint(oReport)  
Local vPIS := {}
Local vICMS := {}
Local oTES := oReport:Section(1) 
 

	sQuery := " SELECT * " 
	sQuery += " FROM " +RetSqlName("SF4")+ " " 
	TCQUERY SQuery Alias TRB New


	TRB->( dbGoTop() )
	oTES:Init()	
	While !EOF()
		//ICMS
		If TRB->( F4_CREDICM == 'S' .AND. F4_ICM = 'N' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_CREDICM",F4_CREDICM,"S","Credito de ICMS = SIM, mas Cálculo = NÃO") )
		Endif
		If TRB->( F4_ICM == 'N' .AND. F4_LFICM != 'N')
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_ICM",F4_ICM,"S","Para considerar o Livro, Calcula ICMS deve ser [SIM]") )
		Endif
				
		// LIVRO FISCAL -> ICMS
		If TRB->( F4_LFICM == 'T' .AND. F4_BASEICM != 0)
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_LFICM",F4_LFICM,"I ou O","Base reduzida, livro de ICMS deve ser Isento ou Outros") )		
		Endif
		If TRB->( F4_LFICM == 'T' .AND. F4_SITTRIB $ '20|70' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_LFICM",F4_LFICM,"I ou O","CST 20 ou 70,Base Reduzida,  livro de ICMS deve ser Isento ou Outros") )
		Endif
		If TRB->( F4_LFICM $ 'I|O' .AND. F4_SITTRIB $ '00|10' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_LFICM",F4_LFICM,"T","CST 00 ou 10, livro de ICMS deve ser Tributado") )
		Endif

		//SIT TRIB ICMS
		If TRB->( F4_SITTRIB $'20|70' .AND. F4_BASEICM == 0 )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_LFICM",F4_LFICM,"T","CST 20 ou 70,Base Reduzida, deve ter valor de reducao de base") )
		Endif
		If TRB->( F4_SITTRIB ='' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_SITTRIB",F4_SITTRIB,"Não Vazio","Sit Trib de ICMS não pode ser vazia") )
		Endif
		If TRB->( !(F4_SITTRIB $ ('00','10')) .AND. F4_LFICM == 'T' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_SITTRIB",F4_SITTRIB,"00 OU 10","Livro Tributado, Sit trib de ICMS deve ser 00 ou 10") )
		Endif

		// CST PIS diferente do CST COFINS		
		If TRB->( F4_CSTPIS != F4_CSTCOF )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_CSTPIS",F4_CSTPIS,F4_CSTCOF,"CST PIS != CST COFINS") )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_CSTCOF",F4_CSTCOF,F4_CSTPIS,"CST PIS != CST COFINS") )		  	
		Endif
		If TRB->( F4_CSTPIS == '' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_CSTPIS",F4_CSTPIS,"Não Vazio","CST PIS vazio") )		
		Endif		
		If TRB->( F4_CSTCOF == '' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_CSTCOF",F4_CSTCOF,"Não Vazio","CST COFINS vazio") )		
		Endif		
                                                                                                                                       
		//TNATREC para NF saída
		If TRB->( F4_CSTCOF=='02' .AND. F4_TNATREC != '4310' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_TNATREC",F4_TNATREC,"4310","Aliq Diferenciada de PIS e COFINS (CST 02) precisa que o campo seja preenchido com [4310]") )
		Endif		
		If TRB->( F4_CSTCOF=='03' .AND. F4_TNATREC != '4311' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_TNATREC",F4_TNATREC,"4311","Aliq Unid Medida de PIS e COFINS (CST 03) precisa que o campo seja preenchido com [4311]") )
		Endif
		If TRB->( F4_CSTCOF=='06' .AND. F4_TNATREC != '4313' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_TNATREC",F4_TNATREC,"4313","Aliq Zero de PIS e COFINS (CST 06) precisa que o campo seja preenchido com [4313]") )
		Endif
		If TRB->( F4_CSTCOF=='07' .AND. F4_TNATREC != '4314' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_TNATREC",F4_TNATREC,"4314","PIS e COFINS Isento (CST 07) precisa que o campo seja preenchido com [4314]") )
		Endif
		If TRB->( F4_CSTCOF=='08' .AND. F4_TNATREC != '4315' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_TNATREC",F4_TNATREC,"4315","PIS e COFINS Sem Incidencia (CST 08) precisa que o campo seja preenchido com [4315]") )
		Endif
		If TRB->( F4_CSTCOF=='09' .AND. F4_TNATREC != '4316' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_TNATREC",F4_TNATREC,"4316","PIS e COFINS em Suspensão (CST 09) precisa que o campo seja preenchido com [4316]") )
		Endif
		If TRB->(F4_TNATREC != '' .AND. F4_CNATREC = '' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_CNATREC",F4_CNATREC,"Nao Vazio","TNATREC preenchido, mas CNATREC em branco") )		
		Endif		 
		
		//PIS e COFINS Saida x CSTPIS
		If TRB->( F4_PISCOF != '3' .AND. F4_CSTPIS $'01|02|03|06' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCOF",F4_PISCOF,"3 - Ambos","CST PIS 01,02,03 ou 06, PIS e COFINS deve ser [Ambos]") )		
		Endif		
		If TRB->( F4_PISCOF != '4' .AND. F4_CSTPIS $'07|08|09' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCOF",F4_PISCOF,"4 - Nao Considera","CST PIS 07,08 ou 09, PIS/COFINS deve ser [Não Considera]") )		
		Endif		

	//Cred PIS COFINS Saida x CSTPIS
		If TRB->( F4_PISCRED != '2' .AND. F4_CSTPIS $'01|02|03' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"2 - Debita","CST PIS 01,02 ou 03, Cred PIS/COF deve ser [Debita]") )		
		Endif	
		If TRB->( F4_PISCRED != '3' .AND. F4_CSTPIS $'06' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"3 - Calcula","CST PIS 06, Cred PIS/COF deve ser [Calcula]") )		
		Endif	
		If TRB->( F4_PISCRED != '4' .AND. F4_CSTPIS $'07|08|09' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"4 - Nao Calcula","CST PIS 07,08 ou 09, Cred PIS/COF deve ser [Nao Calcula]") )		
		Endif	

		//PIS e COFINS Saida x CSTPIS
		If TRB->( F4_PISCOF != '3' .AND. F4_CSTCOF $'01|02|03|06' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCOF",F4_PISCOF,"3 - Ambos","CST COF 01,02,03 ou 06, PIS e COFINS deve ser [Ambos]") )		
		Endif		
		If TRB->( F4_PISCOF != '4' .AND. F4_CSTCOF $'07|08|09' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCOF",F4_PISCOF,"4 - Nao Considera","CST COF 07,08 ou 09, PIS/COFINS deve ser [Não Considera]") )		
		Endif		

		//Cred PIS COFINS Saida x CSTPIS
		If TRB->( F4_PISCRED != '2' .AND. F4_CSTCOF $'01|02|03' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"2 - Debita","CST COF 01,02 ou 03, Cred PIS/COF deve ser [Debita]") )		
		Endif	
		If TRB->( F4_PISCRED != '4' .AND. F4_CSTCOF $'06' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"4 - Calcula","CST COF 06, Cred PIS/COF deve ser [Calcula]") )		
		Endif	
		If TRB->( F4_PISCRED != '3' .AND. F4_CSTCOF $'07|08|09' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"3 - Nao Calcula","CST COF 07,08 ou 09, Cred PIS/COF deve ser [Nao Calcula]") )		
		Endif

	
		//Cred PIS e COFINS Entrada x CST PIS
		If TRB->( F4_PISCRED != '1' .AND. F4_CSTPIS $'50' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"1 - Credita","CST PIS 50, Cred PIS/COF deve ser [Credita]") )		
		Endif			
		If TRB->( F4_PISCRED != '3' .AND.( F4_CSTPIS >= '67' .OR. F4_CSTPIS <= '98') .AND. F4_CSTPIS != '73'  )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"3 - Nao Calcula","CST PIS de 67 a 98, exceto 73, Cred PIS/COF deve ser [Nao Calcula]") )		
		Endif			
		If TRB->( F4_PISCRED != '4' .AND. F4_CSTPIS $'73' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"4 - Calcula","CST PIS 73, Cred PIS/COF deve ser [Calcula]") )		
		Endif			

		//Cred PIS e COFINS Entrada x CST COFINS
		If TRB->( F4_PISCRED != '1' .AND. F4_CSTCOF $'50' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"1 - Credita","CST COF 50, Cred PIS/COF deve ser [Credita]") )		
		Endif			
		If TRB->( F4_PISCRED != '3' .AND.( F4_CSTCOF >= '67' .OR. F4_CSTCOF <= '98') .AND. F4_CSTCOF != '73'  )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"3 - Nao Calcula","CST COF de 67 a 98, exceto 73, Cred PIS/COF deve ser [Nao Calcula]") )		
		Endif			
		If TRB->( F4_PISCRED != '4' .AND. F4_CSTCOF $'73' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_PISCRED",F4_PISCRED,"4 - Calcula","CST COF 73, Cred PIS/COF deve ser [Calcula]") )		
		Endif		


		//CST em NF saída, < 50
		If TRB->( F4_TIPO == 'S' .AND. F4_CSTPIS >= '50' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_CSTPIS",F4_CSTPIS,"< 50","TES de Saída deve ter CST 01, 02, 03, 06, 07, 08 ou 09") )		
		Endif
		If TRB->( F4_TIPO == 'S' .AND. F4_CSTCOF >= '50' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_CSTCOF",F4_CSTCOF,"< 50","TES de Saída deve ter CST 01, 02, 03, 06, 07, 08 ou 09") )		
		Endif		

		//CST em NF Entrada, >= 50
		If TRB->( F4_TIPO == 'E' .AND. F4_CSTPIS < '50' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_CSTPIS",F4_CSTPIS,">= 50","TES de Entrada deve ter CST 50 ou 67 a 98") )		
		Endif		
		If TRB->( F4_TIPO == 'E' .AND. F4_CSTCOF < '50' )
		  	TRB->( GeraCell(oTES,"ERRO",F4_CODIGO,"F4_CSTCOF",F4_CSTCOF,">= 50","TES de Entrada deve ter CST 50 ou 67 a 98") )		
		Endif		
			
		TRB->( dbSkip() )
	End	
	oTES:finish()
	TRB->( dbCloseArea() )	
Return

Static Function GeraCell(oSession,cTipo,cCodigo,cCampo,cVLEncont,cVlEspera,cDescric)
	SX3->( dbSetOrder(2) )
	SX3->( dbGoTop() )
	SX3->( dbSeek(cCampo) )
	oTes:= oSession
	oTES:Cell("TRB_TIPO"):SetValue(cTipo)
	oTES:Cell("TRB_TES"):SetValue(cCodigo)	
	oTES:Cell("TRB_CAMPO"):SetValue(cCampo)
	oTES:Cell("TRB_NOMECAMP"):SetValue(x3Titulo())
	oTES:Cell("TRB_VLENCONT"):SetValue(cVLEncont)
	oTES:Cell("TRB_VLESPERA"):SetValue(cVlEspera)
	oTES:Cell("TRB_DESCRIC"):SetValue(cDescric)	
	oTES:PrintLine()
Return