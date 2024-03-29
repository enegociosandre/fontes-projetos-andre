#include "RWMAKE.CH"
#Include "MSOLE.CH"
#Include "Protheus.CH"

#define CRLF	Chr(13)+Chr(10)

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0022A    � Autor � Gustavo Henrique     � Data � 03/04/02  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砎alida os cursos de destino.                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0022A        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410 - Requerimento de Transferencia de Curso - Veteranos  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function SEC0022A(lWeb)

Local lRet		:= .F.
Local lUnid		:= iif(lWeb == nil,!Empty( M->JBH_SCP10 ),!Empty(httppost->PERG08))
Local cVersao	:= ""
Local aRet		:= {}

lWeb		:= iif(lWeb == nil,.F.,lWeb)

If !lWeb
	If NaoVazio()
	
		JAF->( dbSetOrder( 1 ) ) //JAF_FILIAL, JAF_COD, JAF_VERSAO, R_E_C_N_O_, D_E_L_E_T_

		If JAF->( dbSeek( xFilial( "JAF" ) + M->JBH_SCP12 + M->JBH_SCP14 ) )
		                                                              
			If Empty( M->JBH_SCP14 )
				M->JBH_SCP14 := ""
			EndIf	
	
			cVersao := Iif( Empty(M->JBH_SCP14), JAF->JAF_VERSAO, M->JBH_SCP14)
		          
			JAH->( dbSetOrder( 4 ) )
	
			If JAH->( dbSeek( xFilial( "JAH" ) + M->JBH_SCP12 + cVersao ) )
	
				Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == M->JBH_SCP12 .and. JAH_VERSAO == cVersao ) )
					// Em aberto e curso vigente diferente do curso matriculado
					If JAH->JAH_STATUS == "1" .and. JAH->JAH_CODIGO # M->JBH_SCP01 .and.;
						If( lUnid, JAH->JAH_UNIDAD == M->JBH_SCP10, .T. )
						lRet := .T.
						Exit
					EndIf
					JAH->( dbSkip() )
				EndDo
		
				If lRet
					M->JBH_SCP13 := JAF->JAF_DESC
					M->JBH_SCP14 := JAF->JAF_VERSAO
				Else
					MsgInfo( "N鉶 existe nenhum curso vigente ativo definido para o curso e versao informada." )
				EndIf	
				                                                                                                
			Else
				MsgInfo( "N鉶 existe nenhum curso vigente ativo definido para o curso e versao informada." )			
			EndIf	
		Else
			MsgInfo( "Curso padr鉶 n鉶 cadastrado." )
		EndIf	
	    
	EndIf

else //lWeb             

    
       if httppost->PERG08 <> Httpsession->unidade
 		  aadd(aRet,{.F.,"N鉶 � permitido transfer阯cias entre unidades."})
 		endif  

		JAF->( dbSetOrder( 1 ) )
		If JAF->( dbSeek( xFilial( "JAF" ) + httppost->PERG10 + httppost->PERG12 ) )
		                                                              
			If Empty( httppost->PERG12 )
				httppost->PERG12 := ""
			EndIf	
	
			cVersao := Iif( Empty(httppost->PERG12), JAF->JAF_VERSAO, httppost->PERG12)
		          
			JAH->( dbSetOrder( 4 ) )
	
			If JAH->( dbSeek( xFilial( "JAH" ) + httppost->PERG10 + cVersao ) )
	
				Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == httppost->PERG10 .and. JAH_VERSAO == cVersao ) )
					// Em aberto e curso vigente diferente do curso matriculado
					If JAH->JAH_STATUS == "1" .and. JAH->JAH_CODIGO # httppost->PERG01 .and.;
						If( lUnid, JAH->JAH_UNIDAD == httppost->PERG08, .T. )
						lRet := .T.
						Exit
					EndIf
					JAH->( dbSkip() )
				EndDo
		
				If !lRet
					aadd(aRet,{.F.,"O curso selecionado n鉶 esta dispon韛el para Transfer阯cia."})
				EndIf	
				                                                                                                
			Else
				aadd(aRet,{.F.,"O curso selecionado n鉶 esta dispon韛el para Transfer阯cia."})
			EndIf	
		Else
			aadd(aRet,{.F.,"Curso padr鉶 n鉶 cadastrado."})
		EndIf	
EndIf		

Return( iif(!lWeb,lRet,aRet) )

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  砈EC0022b  篈utor  矴ustavo Henrique    � Data �  11/jul/02  罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escricao 砇egra para gravacao da Grade Curricular do Externo para     罕�
北�          砤nalise.                                                    罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篟etorno   矱xpL1 : Informando se obteve sucesso                        罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       矴estao Educacional - Requerimentos                          罕�
北媚哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             潮�
北媚哪哪哪哪哪穆哪哪哪哪履哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅rogramador � Data   � BOPS �  Motivo da Alteracao                     潮�
北媚哪哪哪哪哪呐哪哪哪哪拍哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�            �        �      �                                          潮�
北滥哪哪哪哪哪牧哪哪哪哪聊哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function SEC0022B()

Local aScript := ACScriptReq( JBH->JBH_NUM )

RecLock("JCS", .T.)
JCS->JCS_FILIAL	:= xFilial("JCS")
JCS->JCS_NUMREQ	:= JBH->JBH_NUM
JCS->JCS_CURPAD	:= aScript[12]
JCS->JCS_VERSAO	:= aScript[14]
msUnlock("JCS")

Return( .T. )

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0022d    � Autor � Gustavo Henrique     � Data � 25/09/02  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砎alida a unidade selecionada.                                 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0022d        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/                                                                            
User Function SEC0022d(lWeb)

Local lRet	:= .T.
Local aArea	:= GetArea()

lWeb	:= iif(lWeb == nil,.F.,lWeb)

dbSelectArea( "JA3" )                 

If !lWeb
	If ! Empty( M->JBH_SCP10 )
	
		lRet := ExistCpo( "JA3", M->JBH_SCP10 )
		    
		If lRet
			M->JBH_SCP11 := Posicione( "JA3", 1, xFilial("JA3") + M->JBH_SCP10, "JA3_DESLOC" )
		EndIf
	
	Else                  
	
		M->JBH_SCP11 := ""
		
	EndIf

else //lWeb

	If ! Empty( httppost->PERG08 )
	
		lRet := ExistCpo( "JA3", httppost->PERG08 )
		    
		If lRet
			httppost->PERG09 := Posicione( "JA3", 1, xFilial("JA3") + httppost->PERG08, "JA3_DESLOC" )
		EndIf
	
	Else                  
	
		httppost->PERG09 := ""
		
	EndIf
EndIf

		
RestArea( aArea )

Return( lRet )

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0022e    � Autor � Gustavo Henrique     � Data � 25/09/02  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 矷mprime o documento referente ao Conteudo Programatico e      潮�
北�          矵istorico Escolar.                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0022e        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros矱XPL1 - Se estah sendo chamada do requerimento de             潮�
北�          砤proveitamento de estudos.                                    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function SEC0022e( lAprov )
                        
Local lRet 		:= .T.
Local aRet		:= ACScriptReq( JBH->JBH_NUM )
Local lImprime	:= .T.

lAprov := iif( lAprov == NIL, .F., lAprov )
            
if lAprov
	lImprime := (aRet[3] # "01")
endif

if lImprime
	U_SEC0002()		// Imprime Historico Escolar
endif

Return( lRet )

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  砈EC0022f  篈utor  矴ustavo Henrique    � Data �  18/out/02  罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escricao 矲iltro para consulta J13 do curso refeente ao campo curso do罕�
北�          硈cript do requerimento de de Transferencia Externos         罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篟etorno   矱xpL1 : Informando se obteve sucesso                        罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       矴estao Educacional  									      罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function SEC0022f()

Local lRet := .F.
              
If JAF->JAF_ATIVO == "1"
     
	JAH->( dbSetOrder( 4 ) )
	JAH->( dbSeek( xFilial( "JAH" ) + JAF->( JAF_COD + JAF_VERSAO ) ) )
	
	If JAH->JAH_STATUS == "1" .and. Iif( ! Empty( M->JBH_SCP10 ), JAH->JAH_UNIDAD == M->JBH_SCP10, .T. )
		lRet := (Posicione( "JBK", 3, xFilial( "JBK" ) + "1" + JAH->JAH_CODIGO, "JBK_ATIVO" ) == "1")
	EndIf
	                        
EndIf

Return( lRet )


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0022h    � Autor � Gustavo Henrique     � Data � 15/04/03  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砎erifica se mudou de curso vigente, caso nao mudou apenas     潮�
北�          砤tualiza a situacao das disciplinas da grade do aluno.        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0022h        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 砇equerimento de Aproveitamento de Estudos	(000032)   			潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function SEC0022h()

Local lRet			:= .T.
Local aRet			:= ACScriptReq( JBH->JBH_NUM )
Local cRA			:= PadR( JBH->JBH_CODIDE, TamSX3( "JA2_NUMRA" )[1] )
Local cCurso		:= aRet[ 01 ]
Local cTurma    	:= aRet[ 06 ]
Local cMemo1		:= ""
Local lExisteJBE	:= .F.
Local cPerlet		:= ""
Local cHabili		:= ""
Local cPerAnt		:= ""
Local cHabAnt		:= ""
Local lJCTJust		:= If(Posicione("SX3",2,"JCT_JUSTIF","X3_CAMPO" )=="JCT_JUSTIF",.T.,.F.)
Local lJCOJust		:= If(Posicione("SX3",2,"JCO_JUSTIF","X3_CAMPO" )=="JCO_JUSTIF",.T.,.F.)
               
JCS->( dbSetOrder( 1 ) )
JCS->( dbSeek( xFilial( "JCS" ) + JBH->JBH_NUM ) )

lRet := ( cCurso == JCS->JCS_CURSO )
                 
if lRet

	JCT->( dbSetOrder(1) )		// JCT_FILIAL+JCT_NUMREQ+JCT_PERLET+JCT_HABILI+JCT_DISCIP
	JCT->( dbSeek(xFilial("JCT")+JBH->JBH_NUM ) )
				
	do while JCT->( ! EoF() .and. JCT->JCT_NUMREQ == JBH->JBH_NUM )

		JC7->( dbSetOrder( 1 ) )
		JC7->( dbSeek( xFilial( "JC7" ) + cRA + cCurso + JCT->JCT_PERLET + JCT->JCT_HABILI + cTurma + JCT->JCT_DISCIP ) )
		                    
	   	do while JC7->( ! EoF() .And. JC7_FILIAL + JC7_NUMRA + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA + JC7_DISCIP ==;
			xFilial( "JC7" ) + cRA + cCurso + JCT->JCT_PERLET + JCT->JCT_HABILI + cTurma + JCT->JCT_DISCIP )
	                             
			cPerlet := JCT->JCT_PERLET
			cHabili := JCT->JCT_HABILI
			
			RecLock( "JC7", .F. )
	            					
			JC7->JC7_SITUAC := iif( JCT->JCT_SITUAC == "003", "8", iif( JCT->JCT_SITUAC == "001", "A", JC7->JC7_SITUAC ) )
			JC7->JC7_SITDIS := JCT->JCT_SITUAC
	        
	        If JCT->JCT_SITUAC == "003"
	                                              
	        	JC7->JC7_MEDFIM := JCT->JCT_MEDFIM
	        	JC7->JC7_MEDCON := JCT->JCT_MEDCON
	        	JC7->JC7_DESMCO := JCT->JCT_DESMCO
	        	JC7->JC7_CODINS := JCT->JCT_CODINS
	        	JC7->JC7_ANOINS := JCT->JCT_ANOINS
	        
	        EndIf
	            					
			MsUnlock()			
	                                 
			JC7->( dbSkip() )
	
		enddo               

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		//� Gera disciplinas dispensadas do aluno       �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		JCO->( dbSetOrder(1) )		// JCO_FILIAL+JCO_NUMRA+JCO_CODCUR+JCO_PERLET+JCO_HABILI+JCO_DISCIP
		lAchouJCO := JCO->( dbSeek( xFilial( "JCO" ) + cRA + cCurso + JCT->JCT_PERLET + JCT->JCT_HABILI + JCT->JCT_DISCIP ) )
			
		If JCT->JCT_SITUAC == "003" .and. ! lAchouJCO
				
			RecLock( "JCO", ! lAchouJCO )
				
			JCO->JCO_FILIAL := xFilial("JCO")
			JCO->JCO_NUMRA  := cRA
			JCO->JCO_CODCUR := cCurso
			JCO->JCO_PERLET := JCT->JCT_PERLET
			JCO->JCO_HABILI := JCT->JCT_HABILI
			JCO->JCO_DISCIP := JCT->JCT_DISCIP
			JCO->JCO_MEDFIM := JCT->JCT_MEDFIM
			JCO->JCO_MEDCON := JCT->JCT_MEDCON
			JCO->JCO_CODINS := JCT->JCT_CODINS
			JCO->JCO_ANOINS := JCT->JCT_ANOINS
				
			if lJCTJust .and. lJCOJust
						
				cMemo1 := JCT->( MSMM( JCT->JCT_MEMO1 ) )
				JCO->( MSMM(if(lAchouJCO,JCO->JCO_MEMO1, ),TamSx3("JCO_JUSTIF")[1],,cMemo1,1,,,"JCO","JCO_MEMO1") )		// Justificativa de dispensa
			endif	
				
			JCO->( MsUnLock() )
				
		ElseIf JCT->JCT_SITUAC == "010" .and. lAchouJCO
				
			RecLock( "JCO", ! lAchouJCO )
				
			JCO->( dbDelete() )
			
			JCO->( MsUnLock() )
				
		EndIf
			
		JCT->( dbSkip() )
			
	enddo	

endif

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//矱fetua o Bloqueio ou Desbloqueio do Aluno�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
If !Empty(cRA) .And. !Empty(cCurso) .And. !Empty(cTurma) .And. !Empty(cPerLet)
			
	lExisteJBE := .F.

	cPerAnt := StrZero(Val(cPerLet)-1,2)
	cHabAnt := AcTrazHab(cCurso, cPerAnt, cHabili)
	
	JBE->( dbSetOrder(1) )
	If JBE->( dbSeek( xFilial("JBE") + cRA + cCurso + cPerLet + cHabili + cTurma) )
		While JBE->( !eof() .and. JBE_FILIAL+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA == xFilial("JBE")+cRA+cCurso+cPerLet+cHabili+cTurma )
			IF JBE->JBE_ATIVO $ "125" // 1=Ativo;2=Inativo;5=Formado
				lExisteJBE := .T.
				Exit
			EndIf
			JBE->(dbSkip())
		End
	EndIF
				
	If lExisteJBE
		JAR->(dbSetOrder(1))		// Ordem: Codigo do Curso Vigente + Periodo Letivo
		If JAR->( dbSeek(xFilial("JAR") + cCurso + cPerLet + cHabili ))
			AcBloqAlu(cRA,cCurso,cPerlet,cHabili,cTurma,JAR->JAR_DPMAX,cPerAnt,cHabAnt)
		EndIf
	Endif
	
EndIf

Return( lRet )

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0022I    � Autor � Luis Ricardo Cinalli � Data � 06/02/06  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砎alida os cursos de destino para transferencia entre filiais. 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0022I        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410 - Requerimento de Transferencia de Filial             潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function SEC0022I(lWeb)
Local lRet		:= .F.
Local lUnid		:= iif(lWeb == nil,!Empty( M->JBH_SCP13 ),!Empty(httppost->PERG08))
Local cVersao	:= ""
Local aRet		:= {}

lWeb		:= iif(lWeb == nil,.F.,lWeb)

If !lWeb
	If NaoVazio()
	
		JAF->( dbSetOrder( 6 ) )   //-- JAF_FILIAL+JAF_ATIVO+JAF_COD
		If JAF->( dbSeek( M->JBH_SCP11 + "1" + M->JBH_SCP15 ) )
		                                                              
			If Empty( M->JBH_SCP17 )  //-- Vers鉶 do Curso Padrao
				M->JBH_SCP17 := ""
			EndIf	
	
			cVersao := Iif( Empty( M->JBH_SCP17 ), JAF->JAF_VERSAO, M->JBH_SCP17 )
		          
			JAH->( dbSetOrder( 4 ) ) //-- JAH_FILIAL+JAH_CURSO+JAH_VERSAO
	
			If JAH->( dbSeek( M->JBH_SCP11 + M->JBH_SCP15 + cVersao ) )
	
				Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == M->JBH_SCP15 .and. JAH_VERSAO == cVersao ) )
					// Em aberto e curso vigente diferente do curso matriculado
					If JAH->JAH_STATUS == "1" .and.	If( lUnid, JAH->JAH_UNIDAD == M->JBH_SCP13, .T. )
						lRet := .T.
						Exit
					EndIf
					JAH->( dbSkip() )
				EndDo
		
				If lRet
					M->JBH_SCP16 := JAF->JAF_DESC
					M->JBH_SCP17 := JAF->JAF_VERSAO
				Else
					MsgInfo( "N鉶 existe nenhum curso vigente ativo definido para o curso e versao informada." )
				EndIf	
				                                                                                                
			Else
				MsgInfo( "N鉶 existe nenhum curso vigente ativo definido para o curso e versao informada." )			
			EndIf	
		Else
			MsgInfo( "Curso padr鉶 n鉶 cadastrado." )
		EndIf	
	    
	EndIf

else //lWeb             
    
        //if httppost->PERG10 <> Httpsession->unidade
 		//  aadd(aRet,{.F.,"N鉶 � permitido transfer阯cias entre unidades."})
 		//endif  

		JAF->( dbSetOrder( 6 ) )
		If JAF->( dbSeek( M->JBH_SCP11 + "1" + httppost->PERG15 ) )
		                                                              
			If Empty( httppost->PERG15 )
				httppost->PERG15 := ""
			EndIf	
	
			cVersao := Iif( Empty(httppost->PERG17), JAF->JAF_VERSAO, httppost->PERG17)
		          
			JAH->( dbSetOrder( 4 ) )
	
			If JAH->( dbSeek( M->JBH_SCP11 + httppost->PERG15 + cVersao ) )
	
				Do While JAH->( ! EoF() .and. JAH->( JAH_CURSO == httppost->PERG15 .and. JAH_VERSAO == cVersao ) )
					// Em aberto e curso vigente diferente do curso matriculado
					If JAH->JAH_STATUS == "1" .and. JAH->JAH_CODIGO # httppost->PERG01 .and.;
						If( lUnid, JAH->JAH_UNIDAD == httppost->PERG13, .T. )
						lRet := .T.
						Exit
					EndIf
					JAH->( dbSkip() )
				EndDo
		
				If !lRet
					aadd(aRet,{.F.,"O curso selecionado n鉶 esta dispon韛el para Transfer阯cia."})
				EndIf	
				                                                                                                
			Else
				aadd(aRet,{.F.,"O curso selecionado n鉶 esta dispon韛el para Transfer阯cia."})
			EndIf	
		Else
			aadd(aRet,{.F.,"Curso padr鉶 n鉶 cadastrado."})
		EndIf	
EndIf		

Return( iif(!lWeb,lRet,aRet) )

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0022j    � Autor � Luis Ricardo Cinalli � Data � 06/02/06  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砎alida a unidade da filial destino selecionada.               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0022j        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/                                                                            
User Function SEC0022j( lWeb )
Local lRet		:= .T.
Local aArea		:= GetArea()
Local cQuery	:= ""
Local cProcFil  := ""
Local cProcLoc  := ""

// Se a tabela de Unidades for compartilhada, nao sera realizado o filtro na Query
Local cFilJA3    := xFilial( 'JA3' )

lWeb		:= iif( lWeb == nil, .F., lWeb )
cProcFil	:= iif( lWeb, httppost->PERG11, M->JBH_SCP11 )
cProcLoc	:= iif( lWeb, httppost->PERG13, M->JBH_SCP13 )

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Filtra somente as unidades da filial de destino �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
cQuery := "SELECT DISTINCT "
cQuery += "JA3.JA3_CODLOC , JA3.JA3_DESLOC ,  "
cQuery += " ( SELECT DISTINCT COUNT( * ) "
cQuery += "   FROM " + RetSQLName("JA3") + " JA3 "
cQuery += "   WHERE "

If ! Empty( cFilJA3 )
	cQuery += "   JA3.JA3_FILIAL = '" + cProcFil + "' and "
EndIf

cQuery += "   JA3.JA3_CODLOC = '" + cProcLoc + "' and "
cQuery += "   JA3.JA3_TIPO = '1' and "
cQuery += "   JA3.D_E_L_E_T_ <> '*' ) AS QTDREG "
cQuery += "FROM "
cQuery += RetSQLName("JA3") + " JA3 "
cQuery += "WHERE "

If ! Empty( cFilJA3 )
	cQuery += "JA3.JA3_FILIAL = '" + cProcFil + "' and "
EndIf

cQuery += "JA3.JA3_CODLOC = '" + cProcLoc + "' and "
cQuery += "JA3.JA3_TIPO = '1' and "
cQuery += "JA3.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY JA3_CODLOC "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

lRet := ( TRB->QTDREG == 1 )

If !lWeb
	M->JBH_SCP14 := iif( lRet, TRB->JA3_DESLOC, "" )
else //lWeb
	httppost->PERG14 := iif( lRet, TRB->JA3_DESLOC, "" )
EndIf

TRB->( DbCloseArea() )
RestArea( aArea )

Return( lRet )

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北赏屯屯屯屯脱屯屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯突北
北篜rograma  � SEC22XB1   篈utor  矻uis Ricardo Cinalli � Data �  07/02/06   罕�
北掏屯屯屯屯拓屯屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯凸北
北篋esc.     � Pesquisa SXB customizada para exibir o cadastro de Unidades   罕�
北�          � da Filial de Destino                                          罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯图北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
User Function SEC22XB1()
Local oDlg, oBtOk, oBtCancel, oOrder, oChave, oSelect
Local nOpc		 := 0
Local cOrder	 := "Codigo"
Local cChave	 := PadR( &( ReadVar() ), TamSX3( "JA3_CODLOC" )[1] )
Local aOrders	 := { "Codigo", "Descricao" }	
Local aCpoBrw	 := {}
Local cFilter	 := ""
Local cTitle	 := " Sele玢o de Unidade "
Local cCampo     := ""
Local cChavePesq := ""                      	
Local aCodLoc    := {}
Local nInd       := 0
Local cQuery     := ""  

// Se a tabela de Unidades for compartilhada, nao sera realizado o filtro na Query
Local cFilJA3    := xFilial( 'JA3' )

Public _RetCodLoc := ""

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Filtra somente as unidades da filial de destino �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
cQuery := "SELECT DISTINCT "
cQuery += "JA3.JA3_CODLOC , JA3.JA3_DESLOC "
cQuery += "FROM "
cQuery += RetSQLName("JA3") + " JA3 "
cQuery += "WHERE "                                                               

If ! Empty( cFilJA3 )
	cQuery += "JA3.JA3_FILIAL = '"+ M->JBH_SCP11 +"' and "
EndIf

cQuery += "JA3.JA3_TIPO = '1' and "
cQuery += "JA3.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY JA3_CODLOC "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

SX3->( dbSetOrder(2) )

SX3->( dbSeek( "JA3_CODLOC" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )

SX3->( dbSeek( "JA3_DESLOC" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )
                         
aStru     := TRB->( dbStruct() )
cFileWork := CriaTrab( aStru, .T. )
cIndWork  := Left( cFileWork, 7 ) + "A"

dbUseArea(.T.,,cFileWork,"TRB2",.F.)

IndRegua( "TRB2", cFileWork, "JA3_CODLOC",,, "Selecionando Registros..." )
IndRegua( "TRB2", cIndWork , "JA3_DESLOC",,, "Selecionando Registros..." )

dbClearIndex()
dbSetIndex(cFileWork + OrdBagExt() )
dbSetIndex(cIndWork  + OrdBagExt() )

While TRB->( !Eof() )
	RecLock("TRB2", .T.)
	TRB2->JA3_CODLOC := TRB->JA3_CODLOC
	TRB2->JA3_DESLOC := TRB->JA3_DESLOC
	MsUnLock()

	TRB->( dbSkip() )
EndDo

TRB2->(DbGoTop())

define msDialog oDlg title cTitle from 000,000 to 300,400 pixel

oSelect := MsSelect():New("TRB2",,,aCpoBrw,,,{ 003, 003, 117, 166 },,,oDlg)
oSelect:bAval := {|| nOpc := 1, oDlg:End() }
oSelect:oBrowse:Refresh()

@ 125,004 say "Ordenar por:" size 40,08 of oDlg pixel	//"Ordenar por:"
@ 125,042 combobox oOrder var cOrder items aOrders size 125,08 of oDlg pixel valid ( TRB2->( dbSetOrder( oOrder:nAt ) ), oSelect:oBrowse:Refresh(), .T. )
@ 137,004 say "Localizar:" size 40,08 of oDlg pixel	//"Localizar:"
@ 137,042 get oChave var cChave size 125,08 of oDlg pixel valid ( TRB2->( dbSeek( RTrim( cChave ), .T. ) ), oSelect:oBrowse:Refresh(), .T. )
define sbutton oBtOk     from 003,170 type 1 enable action ( nOpc := 1, oDlg:End() ) of oDlg pixel
define sbutton oBtCancel from 017,170 type 2 enable action ( nOpc := 0, oDlg:End() ) of oDlg pixel

activate msDialog oDlg centered

if nOpc == 1
	_RetCodLoc := TRB2->JA3_CODLOC
endif
             
TRB->( DbCloseArea() )
TRB2->( DbCloseArea() )

fErase( cFileWork + GetDbExtension() )
fErase( cFileWork + OrdBagExt() )
fErase( cIndWork + OrdBagExt() )

Return nOpc == 1

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北赏屯屯屯屯脱屯屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯突北
北篜rograma  � SEC22XB2   篈utor  矻uis Ricardo Cinalli � Data �  07/02/06   罕�
北掏屯屯屯屯拓屯屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯凸北
北篋esc.     � Pesquisa SXB customizada para exibir o cadastro de Cursos     罕�
北�          � da Filial de Destino                                          罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯图北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
User Function SEC22XB2()
Local oDlg, oBtOk, oBtCancel, oOrder, oChave, oSelect
Local nOpc		 := 0
Local cOrder	 := "Codigo"
Local cChave	 := PadR( &( ReadVar() ), TamSX3( "JAF_COD" )[1] )
Local aOrders	 := { "Codigo", "Descricao" }	
Local aCpoBrw	 := {}
Local cFilter	 := ""
Local cTitle	 := " Sele玢o de Unidade "
Local cCampo     := ""
Local cChavePesq := ""                      	
Local aCodLoc    := {}
Local nInd       := 0
Local cQuery     := ""

Public _RetCodCur := ""

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Filtra somente os cursos da filial de destino   �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
cQuery := "SELECT DISTINCT "
cQuery += "JAF.JAF_COD , JAF.JAF_DESC "
cQuery += "FROM "
cQuery += RetSQLName("JAF") + " JAF "
cQuery += "WHERE "
cQuery += "JAF.JAF_FILIAL = '"+ M->JBH_SCP11 +"' and "
cQuery += "JAF.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY JAF_COD "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

SX3->( dbSetOrder(2) )
SX3->( dbSeek( "JAF_COD" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )
SX3->( dbSeek( "JAF_DESC" ) )
aAdd( aCpoBrw, { RTrim( SX3->X3_CAMPO ),, X3Titulo(), Rtrim( SX3->X3_PICTURE ) } )
                         
aStru     := TRB->( dbStruct() )
cFileWork := CriaTrab( aStru, .T. )
cIndWork  := Left( cFileWork, 7 ) + "A"

dbUseArea(.T.,,cFileWork,"TRB2",.F.)

IndRegua( "TRB2", cFileWork, "JAF_COD",,, "Selecionando Registros..." )
IndRegua( "TRB2", cIndWork , "JAF_DESC",,, "Selecionando Registros..." )

dbClearIndex()
dbSetIndex(cFileWork + OrdBagExt() )
dbSetIndex(cIndWork  + OrdBagExt() )

While TRB->( !Eof() )
	RecLock("TRB2", .T.)
	TRB2->JAF_COD  := TRB->JAF_COD
	TRB2->JAF_DESC := TRB->JAF_DESC
	MsUnLock()

	TRB->( dbSkip() )
EndDo

TRB2->(DbGoTop())

define msDialog oDlg title cTitle from 000,000 to 300,400 pixel

oSelect := MsSelect():New("TRB2",,,aCpoBrw,,,{ 003, 003, 117, 166 },,,oDlg)
oSelect:bAval := {|| nOpc := 1, oDlg:End() }
oSelect:oBrowse:Refresh()

@ 125,004 say "Ordenar por:" size 40,08 of oDlg pixel	//"Ordenar por:"
@ 125,042 combobox oOrder var cOrder items aOrders size 125,08 of oDlg pixel valid ( TRB2->( dbSetOrder( oOrder:nAt ) ), oSelect:oBrowse:Refresh(), .T. )
@ 137,004 say "Localizar:" size 40,08 of oDlg pixel	//"Localizar:"
@ 137,042 get oChave var cChave size 125,08 of oDlg pixel valid ( TRB2->( dbSeek( RTrim( cChave ), .T. ) ), oSelect:oBrowse:Refresh(), .T. )
define sbutton oBtOk     from 003,170 type 1 enable action ( nOpc := 1, oDlg:End() ) of oDlg pixel
define sbutton oBtCancel from 017,170 type 2 enable action ( nOpc := 0, oDlg:End() ) of oDlg pixel

activate msDialog oDlg centered

if nOpc == 1
	_RetCodCur := TRB2->JAF_COD
endif
             
TRB->( DbCloseArea() )
TRB2->( DbCloseArea() )

fErase( cFileWork + GetDbExtension() )
fErase( cFileWork + OrdBagExt() )
fErase( cIndWork + OrdBagExt() )

Return nOpc == 1

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0022K    � Autor � Luis Ricardo Cinalli � Data � 06/02/06  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砎alida a filial destino selecionada.                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0022K        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/                                                                            
User Function SEC0022K( lWeb )

Local lRet		:= .T.
Local aArea		:= GetArea()
Local cProcFil  := ""
Local cEmpAntes	:= SM0->M0_CODIGO
Local cFilAntes	:= SM0->M0_CODFIL

lWeb	 := iif( lWeb == nil, .F., lWeb )
cProcFil := iif( lWeb, httppost->PERG11, M->JBH_SCP11 )
lRet 	 := SM0->( dbSeek( cEmpAntes + cProcFil ) )
                                                    
If !lWeb                                                                                      
	If xFilial() == M->JBH_SCP11
		lRet := .F.	
		MsgAlert(OemtoAnsi("Filial destino � a mesma que a origem."), "Aviso")
	Else
		M->JBH_SCP12 := iif( lRet, Alltrim(SM0->M0_NOME) + " / " + Alltrim(SM0->M0_FILIAL), "" )
	EndIf
else //lWeb
	httppost->PERG12 := iif( lRet, Alltrim(SM0->M0_NOME) + " / " + Alltrim(SM0->M0_FILIAL), "" )
EndIf

SM0->( dbSeek( cEmpAntes + cFilAntes ) )

RestArea( aArea )

Return( lRet )
