#include "rwmake.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0020A    � Autor � Gustavo Henrique     � Data � 04/07/02  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 矲iltra as turmas disponiveis para o requerimento de           潮�
北�          砊ransferencia de Turma - Veteranos.                           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0020A        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros矱XPL1 - .T. - Validacao pelo Script da solicitacao.           潮�
北�          �        .F. - Chamado do filtro da consulta SXB J27.          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function SEC0020A( lWeb )

Local lRet := .T.
Local aRet := {}

lWeb := IIf( lWeb == Nil , .F., lWeb)
lRet := ExistCpo( "JBK", M->JBH_SCP01 + M->JBH_SCP03 + M->JBH_SCP04 + M->JBH_SCP10, 1)

If lRet

	JBK->(DbSetOrder(1))
	JBK->(DbSeek(xFilial("JBK")+M->JBH_SCP01 + M->JBH_SCP03 + M->JBH_SCP04 + M->JBH_SCP10))
	// Seleciona apenas as turmas do mesmo curso e periodo letivo do curso de origem selecionado.
	lRet := (	JBK->JBK_CODCUR == M->JBH_SCP01 .and. JBK->JBK_PERLET == M->JBH_SCP03 .and. JBK->JBK_HABILI == M->JBH_SCP04 .and.;
				M->JBH_SCP10 # M->JBH_SCP06 .and. JBK->JBK_ATIVO == "1" )
	
	If ! lRet             
	    If !lWEb
			MsgStop( "Esta turma n鉶 pode ser selecionada." )
		Else
	        aadd(aRet,{.F.,"Esta turma n鉶 pode ser selecionada."})
        	Return aRet	
        EndIf	
	EndIf

EndIf

Return( lRet )

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0020b    � Autor � Gustavo Henrique     � Data � 25/09/02  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砎aririca se o aluno informado no script pode fazer permuta com潮�
北�          硂 aluno que solicitou o requerimento.                         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0020b        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function SEC0020b( lScript )
                         
Local lRet
          
lScript := Iif( lScript == NIL, .F., lScript )
           
If lScript

	lRet := .F.
	    
	If JA2->( ExistCpo( "JA2", M->JBH_SCP12 ) )
	
		JBE->( dbSetOrder( 3 ) )
		
		If ! JBE->( dbSeek( xFilial( "JBE" ) + "1" + M->JBH_SCP12 + M->JBH_SCP01 ) )
			MsgStop( "O aluno informado n鉶 est� matriculado no curso do aluno solicitante." )
		ElseIf JBE->JBE_PERLET # M->JBH_SCP03
			MsgStop( "O aluno informado deve estar matriculado no mesmo periodo letivo do aluno solicitante." )
		ElseIf JBE->JBE_HABILI # M->JBH_SCP04
			MsgStop( "O aluno informado deve estar matriculado na mesma habilitacao do aluno solicitante." )
		ElseIf JBE->JBE_TURMA == M->JBH_SCP06
			MsgStop( "O aluno informado n鉶 pode estar matriculado na mesma turma do aluno solicitante." )
		Else
			lRet := .T.	
		EndIf
		
	EndIf

Else

	lRet := JBE->(	JBE_NUMRA # Left(M->JBH_CODIDE,TamSX3("JBE_NUMRA")[1]) .and.;	// Alunos diferentes do solicitante
					JBE_ATIVO == "1" .and.;											// Que estejam ativos 
					JBE_CODCUR == M->JBH_SCP01 .and.;								// Matriculados no mesmo curso
					JBE_PERLET == M->JBH_SCP03 .and.;								// Periodo letivo
					JBE_HABILI == M->JBH_SCP04 .and.;								// Habilitacao
					JBE_TURMA # M->JBH_SCP06 )										// e em Turmas diferentes

EndIf
	
Return( lRet )

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0020c    � Autor � Gustavo Henrique     � Data � 25/09/02  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砃ao permitir deixar o numero do RA do aluno de permuta do     潮�
北�          硈cript em branco.                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0020c        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function SEC0020c( lWeb )

Local uRet := .T.

lWeb := Iif( lWeb == NIL, .F., lWeb )
    
If M->JBH_SCP11 == "2" .and. Empty( M->JBH_SCP12 )

	If lWeb
		AAdd( aRet, { .F., "O RA do aluno de permuta deve ser informado." } )
		uRet := aRet	
	Else
		MsgStop( "O RA do aluno de permuta deve ser informado." )
		uRet := .F.
	EndIf

EndIf

Return( uRet )

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0020d    � Autor � Gustavo Henrique     � Data � 25/09/02  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砊ransfere o aluno de permuta para a turma do aluno solicitante潮�
北�          砪aso o tipo seja 2=Permuta.                                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0020d        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function SEC0020d()

Local aRet  := ACScriptRet( M->JBH_NUM )
Local lRet	:= .T.

If aRet[ 11 ] == "2"		//	Permuta
	lRet := ACTransfere( 1, 3, 4, 6, 1, 3, 4, 10, .F.,, 12 )
EndIf

Return( lRet )



/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噭o	 砈EC0020e    � Autor � Eduardo de Souza     � Data �10/Out/2006潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噭o 砎erifica as subturmas do curso                                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe	 砈EC0020e        					    						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros矱XPL1 - .T. - Validacao pelo Script da solicitacao.           潮�
北�          �        .F. - Chamado do filtro da consulta SXB J27.          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so		 矨CAA410	        										    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function SEC0020e( lWeb )

Local lRet 	  := .T.
Local aRet 	  := {}
Local cQuery  := ""
Local cTipGrd := ""

lWeb := IIf( lWeb == Nil , .F., lWeb)

If lRet
	lRet := (JBK->JBK_CODCUR == M->JBH_SCP01 .and. JBK->JBK_PERLET == M->JBH_SCP03 .and. JBK->JBK_HABILI == M->JBH_SCP04 .and.;
				M->JBH_SCP10 # M->JBH_SCP06 .and. JBK->JBK_ATIVO == "1" )
			
	If lRet		
	/*谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//砎erifica qual o tipo de grade para poder realizar a consulta�
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁*/
		DbSelectArea("JAF")
		JAH->(DbSetOrder(1))
		JAH->(DbSeek(xFilial("JAH") + JBK->JBK_CODCUR))
		cTipGrd := Iif(JAF->( FieldPos( "JAF_TIPGRD" ) ) > 0, Posicione("JAF",1,xFilial("JAF") + JAH->(JAH_CURSO + JAH_VERSAO), "JAF_TIPGRD"), "1")
		
		If cTipGrd == "1" //Grade Semanal
			cQuery := "SELECT DISTINCT JBL_SUBTUR FROM " + RetSQLName("JBL")
			cQuery += " WHERE JBL_FILIAL = '" + xFilial("JBL") + "' "
			cQuery += "   AND JBL_CODCUR = '" + M->JBH_SCP01 + "' "
			cQuery += "   AND JBL_PERLET = '" + M->JBH_SCP03 + "' "
			cQuery += "   AND JBL_HABILI = '" + M->JBH_SCP04 + "' "
			cQuery += "   AND JBL_TURMA  = '" + M->JBH_SCP10 + "' "
			cQuery += "   AND JBL_SUBTUR = '" + M->JBH_SCP14 + "' "
			cQuery += "   AND D_E_L_E_T_ = ' '"	
		Else //Diaria
			cQuery := "SELECT DISTINCT JD2_SUBTUR FROM " + RetSQLName("JD2")
			cQuery += " WHERE JD2_FILIAL = '" + xFilial("JD2") + "' "
			cQuery += "   AND JD2_CODCUR = '" + M->JBH_SCP01 + "' "
			cQuery += "   AND JD2_PERLET = '" + M->JBH_SCP03 + "' "
			cQuery += "   AND JD2_HABILI = '" + M->JBH_SCP04 + "' "
			cQuery += "   AND JD2_TURMA  = '" + M->JBH_SCP10 + "' "
			cQuery += "   AND JD2_SUBTUR = '" + M->JBH_SCP14 + "' "
			cQuery += "   AND D_E_L_E_T_ = ' '"	
		Endif		
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "_QRYSUBTUR", .F., .F. )
		
		If _QRYSUBTUR->(Eof())
			lRet := .F.
			If !lWeb
				MsgStop( "A sub-turma informada n鉶 existe" )
			Else
				aadd(aRet,{.F.,"A sub-turma informada n鉶 existe."})
		        Return aRet
			Endif
		Endif
		_QRYSUBTUR->(DbCloseArea())
		DbSelectArea("JA2")
	EndIf
EndIf

Return( lRet )
