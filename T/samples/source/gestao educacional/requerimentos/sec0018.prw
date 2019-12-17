#include "rwmake.ch"

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0018A    � Autor � Gustavo Henrique     � Data � 03/07/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Filtra as unidades disponiveis para o requerimento de         ���
���          �Transferencia de Unidade - Veteranos.                         ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0018A        					    						���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPL1 - .T. - Validacao pelo Script da solicitacao.           ���
���          �        .F. - Chamado do filtro da consulta SXB J25.          ���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function Sec0018A( lScript , lWeb)
         
Local lRet := .T.
Local aRet := {}

lScript := If( lScript == NIL, .F., lScript )
lWeb    := IIf( lWEb == Nil , .F., lWEb )

If lScript

	lRet := ExistCpo( "JA3", M->JBH_SCP11 )    

	If lRet
		
		lRet := ( M->JBH_SCP11 # Posicione( "JAH", 1, xFilial("JAH") + M->JBH_SCP01, "JAH_UNIDAD" ) )
		
		If ! lRet
			If !lWEb
				MsgStop( "A unidade selecionada deve ser diferente da unidade do curso de origem." )
			Else
		        aadd(aRet,{.F.,"A unidade selecionada deve ser diferente da unidade do curso de origem."})			        
		        Return aRet		
		    EndIf    
		Else 
		    M->JBH_SCP10 := Posicione("JAH",1,xFilial("JAH")+M->JBH_SCP01,"JAH_CURSO")                        
			M->JBH_SCP12 := Posicione( "JA3", 1, xFilial( "JA3" ) + M->JBH_SCP11, "JA3_DESLOC" )
			M->JBH_SCP13 := Space(TamSX3( "JAH_CODIGO" )[1])
			M->JBH_SCP14 := Space(TamSX3( "JAH_DESC" )[1])
			M->JBH_SCP15 := Space(TamSX3( "JBK_PERLET" )[1])
			M->JBH_SCP16 := Space(TamSX3( "JBK_HABILI" )[1])
			M->JBH_SCP17 := Space(TamSX3( "JDK_DESC" )[1])
		EndIf
		
	EndIf

Else
                                                        
	lRet := ( JA3->JA3_CODLOC # Posicione( "JAH", 1, xFilial("JAH") + JBE->JBE_CODCUR, "JAH_UNIDAD" ) )

EndIf
	
Return( lRet )


/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0018B    � Autor � Gustavo Henrique     � Data � 03/07/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Utilizado no requerimento de Transferencia de Unidade - Vet.  ���
���          �Filtra os cursos de destino de acordo com a unidade escolhida ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0018B        					    						���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPL1 - .T. - Validacao pelo Script da solicitacao.           ���
���          �        .F. - Chamado do filtro da consulta SXB J26.          ���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function Sec0018B( lWeb, cWCurOri, cWPeriOri, cWUnidOri, cWCurDest )
         
Local lRet		:= .T.
Local cCursoOri	:= ""	// Curso principal do curso origem selecionado no script.
Local cCurso	:= ""	// Curso principal do curso de origem
Local cUnidade	:= ""	// Unidade do curso de origem
                             
lWeb := iif( lWeb == Nil, .F., lWeb)

if ! lWeb

	lRet := ExistCpo( "JBK", M->JBH_SCP13 + M->JBH_SCP03 + M->JBH_SCP04 )
		
	if lRet
		
		lRet := ( Posicione( "JAH", 1, xFilial( "JAH" ) + M->JBH_SCP13, "JAH_UNIDAD" ) == M->JBH_SCP11 )
			
		if lRet
			           
	        // Somente os cursos com o curso padrao do curso de origem
			lRet := ( Posicione( "JAH", 1, xFilial( "JAH" ) + M->JBH_SCP01, "JAH_CURSO" ) == Posicione( "JAH", 1, xFilial( "JAH" ) + M->JBH_SCP13, "JAH_CURSO" ) )
				
			if ! lRet          
				if Empty( M->JBH_SCP11 )       
				  	if !lWeb
						MsgStop( "Unidade n�o pode ser deixada em branco." )
			 		endif    
				else		
					if !lWEb
						MsgStop( "Este curso n�o pode ser selecionado." )
			 		endif    
				endif	
			else 
				M->JBH_SCP14 := Posicione("JAF",1,xFilial("JAF")+Posicione( "JAH", 1, xFilial( "JAH" ) + M->JBH_SCP11, "JAH_CURSO" )+JAH->JAH_VERSAO,"JAF_DESMEC")
				M->JBH_SCP15 := JBK->JBK_PERLET
				M->JBH_SCP16 := JBK->JBK_HABILI
				M->JBH_SCP17 := Posicione("JDK",1,xFilial("JDK") + JBK->JBK_HABILI,"JDK_DESC")
			endif		
			
		endif
	
	else     
	
        if ! lWeb
			MsgStop( "Curso de destino invalido." )
		endif

	endif
		
else

	// Seleciona apenas cursos ativos
	JAH->( dbSetOrder( 1 ) )
	JAH->( dbSeek( xFilial( "JAH" ) + cWCurOri ) )
	                                
	cCursoOri := JAH->JAH_CURSO
	
	JAH->( dbSetOrder( 1 ) )
	JAH->( dbSeek( xFilial( "JAH" ) + cWCurDest ) )
		
	cUnidade := JAH->JAH_UNIDAD
	cCurso	 := JAH->JAH_CURSO
	                                                                                                              
 	// Traz apenas os cursos da unidade selecionada, que tenham o mesmo curso pricipal 
 	// do curso origem selecionado.
	lRet := ( cUnidade <> cWUnidOri .and. cCursoOri == cCurso )
	
endIf

Return( lRet )   

 
