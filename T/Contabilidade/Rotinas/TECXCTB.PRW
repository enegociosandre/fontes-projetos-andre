#include "topconn.ch"
#include "protheus.ch"
#include "msobjects.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ TecxCtb  บ Autor ณMarcos Wey da Mata  บ Data ณ 28/07/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณClasse com funcionalidades do modulo Contabilidade Gerencialบฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ																		  บฑฑ
ฑฑบ																		  บฑฑ
ฑฑบ																		  บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Class TecxCtb
	
	Method 	New()				&& Construtor
	Method	RetCliForCta()     	&& Retorna as Contas Contabeis de Clientes e Fornecedores
	Method	CriaCtaCtb()		&& Inclusao Automatica de Contas Contabeis
	
EndClass 

&&Descricao	:	Construtor 
Method New() Class TecxCtb

Return
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณRetCliForCtaบ Autor ณMarcos Wey da Mata  บ Data ณ 28/07/2011  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna as Contas Contabeis de Clientes e Fornecedores        บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametros	:	cTabela - Tabela ( SA1 - Clientes ou SA2 - Fornecedores)บฑฑ
ฑฑบ					cCampo	- Campo a ser atribuida a Conta Contabil		บฑฑ
ฑฑบ					cAlias	- Alias da Tabela caso a funcao seja chamada viaบฑฑ
ฑฑบ							  Query ( por padrao assume a Tabela informada) บฑฑ
ฑฑบ							  											    บฑฑ
ฑฑบRetorno		:	cConta - Item Contabil      						    บฑฑ
ฑฑบ							  											    บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Method RetCliForCta( cTabela , cCampo , cAlias ) Class TecxCtb			    
	
Local 	cConta		:= 	""	
Local 	cCodLoja   	:= 	""

Default cAlias 		:=	Upper(AllTrim(cTabela))	

cTabela := Upper(AllTrim(cTabela))
cCampo 	:= Upper(AllTrim(cCampo))

&& Clientes		
If 	cTabela == "SA1"         
	&&cCodLoja := AllTrim((cAlias)->A1_COD)+AllTrim((cAlias)->A1_LOJA)
	cCodLoja := AllTrim(SubStr((cAlias)->A1_COD,2,5))+AllTrim((cAlias)->A1_LOJA)
	&& Item Contabil
	If cCampo == "A1_ZZITEM"
		cConta := "C"			     
	EndIf

&& Fornecedores		
Else
	cCodLoja := AllTrim((cAlias)->A2_COD)+AllTrim((cAlias)->A2_LOJA)
	&& Item Contabil
	If cCampo == "A2_ZZITEM"
		cConta := ""
	EndIf
EndIf

cConta += cCodLoja
	
Return cConta                                                                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณCriaCtaCtb  บ Autor ณMarcos Wey da Mata  บ Data ณ 28/07/2011  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclusao Automatica do Item Contabil                          บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametros	:	xContas - String com a Conta Contabil ou Vetor com      บฑฑ
ฑฑบ                           Varias Contas      				            บฑฑ
ฑฑบ					cTabela - Tabela ( SA1 - Clientes ou SA2 - Fornecedores)บฑฑ
ฑฑบ					cAlias	- Alias da Tabela caso a funcao seja chamada viaบฑฑ
ฑฑบ							  Query ( por padrao assume a Tabela informada) บฑฑ
ฑฑบ							  											    บฑฑ
ฑฑบRetorno		:	Logico - Indica se uma ou mais Itens foram Incluidas    บฑฑ
ฑฑบ							  											    บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Method CriaCtaCtb( xContas , cTabela , cAlias ) Class TecxCtb
	
Local nI		:= 	0
Local lGravou 	:= 	.f.
Local lOk		:= 	.f.
Local aContas	:= 	iif( ValType(xContas) == "C" , { xContas } , aClone(xContas) )

Default cAlias 	:= 	cTabela

For nI := 1 To Len(aContas)		
	If	!ExistConta( aContas[nI] )
		If 	GravaConta( aContas[nI] , cTabela , cAlias )		
			lGravou := .t.			
		EndIf
	EndIf
Next nI

Return lGravou

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณExistConta  บ Autor ณMarcos Wey da Mata  บ Data ณ 28/07/2011  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se o Item Contabil Existe                            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametros	:	cConta - String com a Conta Contabil                    บฑฑ
ฑฑบ							  											    บฑฑ
ฑฑบRetorno		:	Logico - Indica se o Item Existe                        บฑฑ
ฑฑบ							  											    บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExistConta( cConta )
	
Local lAchei	:=	.f.
Local aArea		:=	GetArea()

cConta 	:=	Substr( cConta + Space(100) , 01 , Len(CriaVar("CTD_ITEM",.f.)) )

dbselectarea("CTD")
dbsetorder(1)

lAchei	:=	CTD->( dbseek( xFilial("CTD") + cConta , .f. ) )

RestArea( aArea )

Return ( lAchei )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณGravaConta  บ Autor ณMarcos Wey da Mata  บ Data ณ 28/07/2011  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclusao do Item Contabil                                     บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametros	:	cConta 	- String com a Conta Contabil                   บฑฑ
ฑฑบ					cTabela - Tabela ( SA1 - Clientes ou SA2 - Fornecedores)บฑฑ
ฑฑบ					cAlias	- Alias da Tabela caso a funcao seja chamada viaบฑฑ
ฑฑบ							  Query ( por padrao assume a Tabela informada) บฑฑ
ฑฑบ							  											    บฑฑ
ฑฑบRetorno		:	Logico - Indica se uma ou mais Itens foram Incluidas    บฑฑ
ฑฑบ							  											    บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaConta( cConta , cTabela , cAliasT )

Local nI
Local nResUpd	:= 	0
Local aCposCtd	:=	{}
Local cCampos	:= 	""
Local cQryUpd 	:=	""
Local cValores	:= 	""
Local lGravou	:= 	.t.
Local aArea		:=	GetArea()
Local nTmDesc	:= 	TamSx3("CTD_DESC01")[1]
Local cAlias	:=	iif( cAliasT <> Nil 	, cAliasT 			, cTabela 			)
Local lCliente	:= 	iif( cTabela == "SA1" 	, .t.				, .f.				)                                
Local cCodigo	:= 	iif( lCliente	 		, (cAlias)->A1_COD	, (cAlias)->A2_COD	)
Local cLoja		:=	iif( lCliente 			, (cAlias)->A1_LOJA	, (cAlias)->A2_LOJA	)
Local cDescr	:=	iif( lCliente 			, (cAlias)->A1_NOME	, (cAlias)->A2_NOME	)
Local cCodRes	:= 	AllTrim( cCodigo ) + AllTrim( cLoja )

aAdd(aCposCtd, {"D_E_L_E_T_"	, Space(1)				})
aAdd(aCposCtd, {"R_E_C_D_E_L_"	, 0						})	
aAdd(aCposCtd, {"R_E_C_N_O_"	, ProxRecno("CTD")		})	
aAdd(aCposCtd, {"CTD_FILIAL"	, xFilial("CTD")		})
aAdd(aCposCtd, {"CTD_ITEM"		, cConta				})
aAdd(aCposCtd, {"CTD_DESC01"	, Left(cDescr,nTmDesc)	})
aAdd(aCposCtd, {"CTD_CLASSE"	, "2"					})
aAdd(aCposCtd, {"CTD_NORMAL"	, "0" 					})
aAdd(aCposCtd, {"CTD_RES"    	, cConta	       		})
aAdd(aCposCtd, {"CTD_BLOQ"		, "2"					})
aAdd(aCposCtd, {"CTD_ITSUP"		, Left(cConta,1)		})
aAdd(aCposCtd, {"CTD_ACCLVL"	, "1"					})
aAdd(aCposCtd, {"CTD_DTEXIS" 	, "19800101"			})
aAdd(aCposCtd, {"CTD_ITLP"		, cConta 				})
aAdd(aCposCtd, {"CTD_BOOK"		, "001/002/003/004/005"	})
aAdd(aCposCtd, {"CTD_CLOBRG"	, "2"					})

For nI := 1 To Len(aCposCtd)
	cCampos		+= 	iif( nI <> 1 , "," , "" ) + aCposCtd[nI,1] 
	cValores	+= 	iif( nI <> 1 , "," , "" ) + iif( ValType(aCposCtd[nI,2]) == "N" , AllTrim(Str(aCposCtd[nI,2])) , "'" + aCposCtd[nI,2] + "'" )
Next nI
	
cQryUpd	:= 	"INSERT INTO " + RetSqlName("CTD") + " ( " + cCampos + " ) "
cQryUpd += 	"VALUES ( " + cValores + " ) "
	
nResUpd	:= 	TcSqlExec(cQryUpd)  
	
if 	nResUpd <> 0
	lGravou	:= .f.
	cErro 	:= TcSqlError()
	Aviso( FunDesc() , cErro , {"Ok"} , 03 , "Erro ao Gravar Conta Contabil [" + cConta + "]"  	)
Else 
	TcSqlExec("COMMIT")
	TcRefresh(RetSqlName("CTD")) 	
EndIf	

Return ( lGravou )
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณProxRecno   บ Autor ณMarcos Wey da Mata  บ Data ณ 28/07/2011  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o Proximo Recno de uma Tabela                         บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametros	:	cTabela - Tabela a ser pesquisada                       บฑฑ
ฑฑบ							  											    บฑฑ
ฑฑบRetorno		:	nRecno - Proximo Recno da Tabela                        บฑฑ
ฑฑบ							  											    บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
Static Function ProxRecno( cTabela ) 
	
Local cQuery	:=	"SELECT MAX(R_E_C_N_O_) AS PROXRECNO FROM " + RetSqlName(cTabela)
Local nRecno	:= 	0
	
TcQuery ChangeQuery(cQuery) New Alias "TTTMP"
	
nRecno := ( TTTMP->PROXRECNO + 1 )

TTTMP->(dbCloseArea())

Return ( nRecno )