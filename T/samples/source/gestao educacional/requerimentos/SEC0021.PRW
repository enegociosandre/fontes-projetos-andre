#include "rwmake.ch"

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0021A    � Autor � Gustavo Henrique     � Data � 05/07/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Filtra os cursos de destino para trazer so os que forem da    ���
���          �mesma area do curso de origem.                                ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0021A        					    						���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPL1 - Indica se a funcao estah sendo chamada do SXB ou do 	���
���          �campo do script.                                            	���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function SEC0021A( lScript, lWeb, cNumRa, cCodCur, cPerlet, cTurma, cCodCurDes, cPerDes )

Local cRA			:= ""			// RA do aluno 
Local cCursoDes		:= ""			// Curso de destino
Local cCurso1		:= ""			// Curso principal do curso de origem
Local cCurso2		:= ""			// Curso principal do curso de destino
Local lRet			:= .T.          

lWeb        := If( lWeb == NIL, .F., .T. )
lScript		:= If( lScript == NIL, .F., .T. )
cCodCur    := Iif(cCodCur    == Nil, M->JBH_SCP01, cCodCur)
cCodCurDes := Iif(cCodCurDes == Nil, M->JBH_SCP12, cCodCurDes)

If !lWeb                                         

	cRA			:= Left( M->JBH_CODIDE, TamSX3( "JA2_NUMRA" )[1] )
	cCursoDes	:= JBK->JBK_CODCUR
	
	If lScript
		lRet := ExistCpo( "JBK", M->JBH_SCP12 + M->JBH_SCP03 )
		If lRet
			cCursoDes := M->JBH_SCP12
			JBK->( dbSetOrder( 1 ) )
			lRet := JBK->( dbSeek( xFilial( "JBK" ) + M->JBH_SCP12 + M->JBH_SCP03 ) )
			If ! lRet
				MsgStop( "N�o existe grade de aluas definida para o 1o. per�odo deste curso." )
			EndIf
		EndIf
	EndIf

	If lRet
	
		// Soh permite selecionar os cursos que o aluno nao estah ativo
		JBE->( dbSetOrder( 3 ) )
	
		lRet := ! JBE->( dbSeek( xFilial( "JBE" ) + "1" + cRA + cCursoDes ) )
	
		If lScript .and. ! lRet
			MsgStop( "O Aluno j� est� matriculado neste curso." )
		EndIf
	
		If lRet
		
			// Verifica se o curso selecionado estah com grade ativa e o perido letivo eh o mesmo
			// do curso de origem.
			lRet := ( JBK->JBK_ATIVO == "1" .and. JBK->JBK_PERLET == M->JBH_SCP03 )
			   
			If lScript .and. ! lRet
				MsgStop( "O curso deve ter grade de aulas ativa no 1o. periodo letivo." )
			EndIf	
			
			If lRet
			            
				// Se a unidade foi preenchida, apresenta apenas os cursos da unidade
				JAH->( dbSetOrder( 1 ) )
				JAH->( dbSeek( xFilial( "JAH" ) + JBK->JBK_CODCUR ) )

				lRet := If( ! Empty( M->JBH_SCP10 ), ( M->JBH_SCP10 == JAH->JAH_UNIDAD ), .T. )
				
				If lRet
			                      
					// Guarda o curso do curso vigente de destino e posiciona no curso vigente de destino
					cCurso2 := JAH->JAH_CURSO				
        			JAH->( dbSeek( xFilial( "JAH" ) + M->JBH_SCP01 ) )

					// O curso do curso vigente atual deve ser diferente do que caracteriza o curso vigente de destino
					lRet := ( JAH->JAH_CURSO # cCurso2 )
		            
					If lScript                                               
						If ! lRet
							MsgStop( "O aluno est� matriculado no mesmo curso selecionado." )
						Else
							M->JBH_SCP13 := Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+M->JBH_SCP10,"JAH_CURSO")+JAH->JAH_VERSAO,"JAF_DESMEC")
							M->JBH_SCP14 := JBK->JBK_PERLET
							M->JBH_SCP15 := JBK->JBK_HABILI
							M->JBH_SCP16 := Posicione("JDK",1,xFilial("JDK")+JBK->JBK_HABILI,"JDK_DESC")
						EndIf	
					EndIf

				EndIf
		
			EndIf
			
		EndIf
		
	EndIf	

Else 

	// Soh permite selecionar os cursos que o aluno nao estah ativo
	JBE->( dbSetOrder( 3 ) )		
	If ! (JBE->( dbSeek( xFilial( "JBE" ) + "1" + cNumRa + cCodCurDes)))
		// Verifica se o curso selecionado estah com grade ativa e o perido letivo eh o mesmo
		// do curso de origem.      
		JBK->( dbSetOrder( 1 ) )
		JBK->( dbSeek( xFilial( "JBK" ) + cCodCurDes + cPerDes ))
		If ! JBK->( Eof() )
		    If ( JBK->JBK_ATIVO == "1" .and. JBK->JBK_PERLET == cPerlet )
			    // O curso de destino selecionado deve ter o curso principal diferente do curso de origem
				cCurso1 := Posicione( "JAH", 1, xFilial( "JAH" ) + cCodCur, "JAH_CURSO" )
				cCurso2 := Posicione( "JAH", 1, xFilial( "JAH" ) + cCodCurDes, "JAH_CURSO" )
				lRet := ( cCurso1 # cCurso2 )                          
			Else 
			    lRet := .F.	
		    EndIf
		Else    
			lRet := .F.
		EndIf	
	Else
    	lRet := .F.
	EndIf

EndIf

Return( lRet )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0021B    � Autor � Gustavo Henrique     � Data � 08/07/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Filtra os periodos letivos para selecao utilizando a opcao    ���
���          �manutencao no requerimento de Transferencia de Curso - Calouro���
���          �e Transferencia de Curso - Veteranos.                         ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0021B        					    						���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPL1 - Indica se a funcao estah sendo chamada do SXB ou do 	���
���          �campo do script.                                            	���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function SEC0021B( lScript, lWeb )

Local aRet      := {}
Local lRet		:= .T.
Local cPerLet	:= ""
Local cCurso	:= ""
Local cHabili  := ""

lScript := If( lScript == NIL, .F., lScript )
lWeb    := IIf( lWeb == Nil , .F. , lWeb)
cCurso	:= JAR->JAR_CODCUR
cPerLet	:= JAR->JAR_PERLET
cHabili  := JAR->JAR_HABILI

If lScript
	lRet	:= ExistCpo( "JAR", M->JBH_SCP12 + M->JBH_SCP14 + M->JBH_SCP15 )
	cCurso	:= M->JBH_SCP12
	cPerLet	:= M->JBH_SCP14
	cHabili := M->JBH_SCP15
EndIf

If lRet
                                        
	JBK->( dbSetOrder( 1 ) )
	JBK->( dbSeek( xFilial( "JBK" ) + M->JBH_SCP12 + cPerLet + cHabili) )

	lRet := ( cCurso == JBK->JBK_CODCUR .and. JBK->JBK_ATIVO == "1" )

	If lScript .and. ! lRet
		If !lWeb
			MsgStop( "Nao existe grade de aulas ativa para este periodo letivo." )
		Else 
    	    aadd(aRet,{.F.,"Nao existe grade de aulas ativa para este periodo letivo."})	
	        Return aRet			
		EndIf
	EndIf

EndIf	

Return( lRet )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0021C    � Autor � Gustavo Henrique     � Data � 24/09/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Valida a unidade selecionada.                                 ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0021C        					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/                                                                            
User Function SEC0021c(lWeb)

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
			M->JBH_SCP09 := Posicione( "JA3", 1, xFilial("JA3") + httppost->PERG08, "JA3_DESLOC" )
		EndIf
	
	Else                  
	
		httppost->PERG09 := ""
		
	EndIf

EndIf


		
RestArea( aArea )

Return( lRet )
              
/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0021d    � Autor � Gustavo Henrique     � Data � 24/09/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Valida se o aluno esta matriculado nao eh calouro, ou seja,   ���
���          �estah matriculado no segundo periodo letivo em diante.        ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0021d        					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/                                                                            
User Function SEC0021d(lWeb)

Local lRet := .T.
Local aRet := {}

lWeb := Iif( lWeb == NIL, .F., lWeb )                

If Val(M->JBH_SCP03) > 1 	// Jah cursou o primeiro periodo letivo do curso
    If !lWeb                                               
		MsgInfo( "Este aluno n�o est� matriculado no primeiro semestre." + Chr(13) + Chr(10) +;
				 "Utilize a Transfer�ncia de Curso para Veteranos." )
		lRet := .F.
	Else 
        aadd(aRet,{.F.,"Este aluno n�o est� matriculado no primeiro semestre e n�o pode ser transferido."})	
        Return aRet
	EndIf	
EndIf

Return( lRet )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0021E    � Autor � Marcos Cesar         � Data � 28/06/03  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Fazer a verificacao da Habilitacao informada no Script.       ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0021E             					    						       ���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPL1 - Indica se a funcao estah sendo chamada do SXB ou do 	 ���
���          �campo do script.                                            	 ���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										                ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function SEC0021e(lWeb)

Local lRet := .T.
Local aRet := {}

lWeb := Iif( lWeb == NIL, .F., lWeb )                

//��������������������������������������������������Ŀ
//�Pesquisa o Cadastro de Habilitacao.               �
//����������������������������������������������������
JDK->(dbSetOrder(1))
JDK->(dbSeek(xFilial("JDK") + M->JBH_SCP15))

If JDK->(!Found())
	If !lWeb
		MsgInfo("Essa Habilita��o n�o est� cadastrada.")
		lRet := .F.
	Else
		Aadd(aRet, { .F., "Essa Habilita��o n�o est� cadastrada." })

		Return aRet
	EndIf
EndIf

If lRet
	//��������������������������������������������������Ŀ
	//�Pesquisa o Arquivo Curso Vigente x Per�odo Letivo.�
	//����������������������������������������������������
	JAR->(dbSetOrder(1))
	JAR->(dbSeek(xFilial("JAR") + M->JBH_SCP12 + M->JBH_SCP14 + M->JBH_SCP15))

	If JAR->(!Found())
		If !lWeb
			MsgInfo("Essa Habilita��o n�o existe no Curso/Per�odo Letivo informado.")
			lRet := .F.
		Else
			Aadd(aRet, { .F., "Essa Habilita��o n�o existe no Curso/Per�odo Letivo informado." })

			Return aRet
		EndIf
	EndIf
EndIf

Return( lRet )
