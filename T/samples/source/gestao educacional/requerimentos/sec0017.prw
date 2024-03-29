#include "rwmake.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0017A    � Autor � Gustavo Henrique     � Data � 02/07/02  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 矲iltra os cursos utilizando o turno escolhido no script do    潮�
北�          硆equerimento de Transferencia de Turno - Veteranos            潮�
北�          �1) Traz os cursos da mesma unidade, curso de origem e periodo 潮�
北�          砽etivo do curso matriculado, e  que estejam com grade de aulas潮�
北�          砤tiva, e correspondem ao turno selecionado.                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0017A        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros矱XPL1 - .T. - Validacao pelo Script da solicitacao.           潮�
北�          �        .F. - Chamado do filtro da consulta SXB J18.          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function Sec0017A( lWeb,cCodCur,cPeriodo,cUnid,cJBKperlet)
         
Local lRet	:= .T.
Local cMsg	:= ""

lWeb     := IIf( lWeb     == Nil , .F., lWeb)
cCodCur  := IIf( cCodCur  == Nil , "", cCodCur)
cPeriodo := IIf( cPeriodo == Nil , "", cPeriodo)

If ! lWeb

	lRet := ( Posicione( "JBK", 1, xFilial( "JBK" ) + M->( JBH_SCP14 + JBH_SCP03 + JBH_SCP04 ), "JBK_ATIVO" ) == "1" )
		                                       
	cMsg := " Este curso n鉶 tem grade de aulas ativa no per韔do letivo " + M->JBH_SCP03 + " habilita玢o " + M->JBH_SCP04 + "."
		
	If lRet
		      
		JAH->( dbSetOrder( 1 ) )
		JAH->( dbSeek( xFilial( "JAH" ) + M->JBH_SCP14 ) )
		         
		// Filtra somente os cursos que tem o mesmo curso, periodo letivo e unidade do curso 
		// vigente de origem escolhido no script. , verifica tambem se o periodo letivo escolhido estah ativo
		lRet := ( JAH->JAH_CURSO == M->JBH_SCP10 .and. JAH->JAH_UNIDAD == M->JBH_SCP11 )
		
		cMsg := " Curso padr鉶 ou unidade diferem do curso padr鉶 ou unidade do curso origem."
						
		If lRet
			
			// O turno escolhido tambem deve ser diferente do turno do curso de origem				
			lRet := ( ! Empty( JAH->JAH_TURNO ) .and. M->JBH_SCP12 == JAH->JAH_TURNO )
			
			cMsg := " Turno difere do turno escolhido."
			
			// O curso de origem nao pode ser o mesmo curso de destino e soh apresenta 
			// os cursos ativos.
			If lRet                                    
				
				lRet := ( M->JBH_SCP01 # M->JBH_SCP14 )
				
				cMsg := " Escolha um curso vigente diferente do curso origem. "
					
			EndIf
				
		EndIf
		
	EndIf
	
	If ! lRet
		
		// Este curso n鉶 pode ser selecionado.	
		MsgStop( "Este curso n鉶 pode ser selecionado." + cMsg )
		
	Else          
		
		M->JBH_SCP15 := Posicione("JAH",1,xFilial("JAH")+M->JBH_SCP14,"JAH_DESC")		// "Descricao" do curso no script
		M->JBH_SCP16 := JBK->JBK_PERLET		// "Periodo Letivo" do curso no script
		M->JBH_SCP17 := JBK->JBK_HABILI		// "Habilitacao" do curso no script
		M->JBH_SCP18 := Posicione("JDK",1,xFilial("JDK")+JBK->JBK_HABILI,"JDK_DESC")
		M->JBH_SCP19 := JBK->JBK_TURMA		// "Turma" do curso no script
	 
	EndIf
		
Else

	// Busca o curso e unidade do curso vigente de origem
	JAH->( dbSetOrder( 1 ) )
	If JAH->( dbSeek( xFilial( "JAH" ) + cCodCur ) )	// Campo "Curso Origem" do script
		// Filtra somente os cursos que tem o mesmo curso, periodo letivo e unidade do curso 
		// vigente de origem escolhido no script. , verifica tambem se o periodo letivo escolhido estah ativo
		lRet := (	cCodCur == JAH->JAH_CURSO .and. cUnid == JAH->JAH_UNIDAD .and. cPeriodo == cJBKperlet )
	Else
	    lRet := .F.
	EndIf   	
			
EndIf

Return( lRet )


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0017B    � Autor � Gustavo Henrique     � Data � 04/07/02  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砎alidacao do turno digitado no script do requerimento de      潮�
北�          砊ransferencia de Turno - Veteranos.                           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0017B        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function Sec0017B(lWeb)
   
Local lRet := .T.         
Local aRet := {}

lWeb := IIf( lWeb == Nil , .F., lWeb)

M->JBH_SCP13 := Tabela( "F5", M->JBH_SCP12, .T. )
lRet := ! Empty( M->JBH_SCP13 )

If lRet 
    
    If !lWeb
		M->JBH_SCP14 := Space( TamSX3("JAH_CODIGO")[1] )
		M->JBH_SCP15 := Space( TamSX3("JAH_DESC")[1] )
		M->JBH_SCP16 := Space( TamSX3("JBK_PERLET")[1] )    
		M->JBH_SCP17 := Space( TamSX3("JBK_HABILI")[1] )
		M->JBH_SCP18 := Space( TamSX3("JDK_DESC")[1] )
		M->JBH_SCP19 := Space( TamSX3("JBK_TURMA")[1] )
	Else
        aadd(aRet,{.F.,"Turno Inv醠ido."})	
        Return aRet		
	EndIf
EndIf

Return( lRet )

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0017C    � Autor � Gustavo Henrique     � Data � 10/10/02  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砊ransfere o aluno de permuta para o turno do aluno solicitante潮�
北�          砪aso o tipo seja 2=Permuta.                                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0017C        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function SEC0017C()

Local aRet  := ACScriptRet( M->JBH_NUM )
Local lRet	:= .T.

If aRet[ 20 ] == "2"		//	Permuta
	lRet := ACTransfere( 1, 3, 4, 6, 14, 16, 17, 19, .F., , 20 )
EndIf

Return( lRet )

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0017D    � Autor � Gustavo Henrique     � Data � 10/10/02  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砎aririca se o aluno informado no script pode fazer permuta com潮�
北�          硂 aluno que solicitou o requerimento.                         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0017D        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function SEC0017d( lScript )
                         
Local lRet
Local cTurno
          
lScript := Iif( lScript == NIL, .F., lScript )
           
If lScript

	lRet := .F.

	If JA2->( ExistCpo( "JA2", M->JBH_SCP21 ) )
	
		JBE->( dbSetOrder( 3 ) )
		JBE->( dbSeek( xFilial( "JBE" ) + "1" + M->JBH_SCP21 + M->JBH_SCP14 ) )

		cTurno := Posicione( "JAH", 1, xFilial( "JAH" ) + JBE->JBE_CODCUR, "JAH_TURNO" )
		
		If JBE->( ! Found() )
			MsgStop( "O aluno informado n鉶 est� matriculado no curso informado como destino." )
		ElseIf JBE->JBE_PERLET # M->JBH_SCP16
			MsgStop( "O aluno informado deve estar matriculado no mesmo periodo letivo do aluno solicitante." )
		ElseIf cTurno # M->JBH_SCP12
			MsgStop( "O aluno deve estar matriculado no turno de destino selecionado." )
		Else
			lRet := .T.	
		EndIf
		
	EndIf

Else
                        
	cTurno := Posicione( "JAH", 1, xFilial( "JAH" ) + JBE->JBE_CODCUR, "JAH_TURNO" )

	lRet := JBE->(	JBE_NUMRA # Left(M->JBH_CODIDE,TamSX3("JBE_NUMRA")[1]) .and.;	// Alunos diferentes do solicitante
					JBE_ATIVO == "1" .and.;											// Que estejam ativos 
					JBE_CODCUR == M->JBH_SCP14 .and.;								// Matriculados no curso de destino
					JBE_PERLET == M->JBH_SCP16 .and.;								// Periodo letivo do destino
					JBE_HABILI == M->JBH_SCP17 .and.;								// Habilitacao do destino
					JBE_TURMA == M->JBH_SCP19 .and.;								// Turma do destino
					cTurno == M->JBH_SCP12 )										// e no Turno de destino selecionados

EndIf
	
Return( lRet )


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  � SEC0017e � Autor � Gustavo Henrique   � Data �  01/04/04   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escricao � Expressao de filtro tipo 07 para a consulta J2C.           罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � Requerimento de transferencia de turno.                    罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function SEC0017e()

Return( xFilial("JBO")+M->(JBH_SCP14+JBH_SCP16+JBH_SCP17) )      



