#include "rwmake.ch"

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0017A    � Autor � Gustavo Henrique     � Data � 02/07/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Filtra os cursos utilizando o turno escolhido no script do    ���
���          �requerimento de Transferencia de Turno - Veteranos            ���
���          �1) Traz os cursos da mesma unidade, curso de origem e periodo ���
���          �letivo do curso matriculado, e  que estejam com grade de aulas���
���          �ativa, e correspondem ao turno selecionado.                   ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0017A        					    						���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPL1 - .T. - Validacao pelo Script da solicitacao.           ���
���          �        .F. - Chamado do filtro da consulta SXB J18.          ���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function Sec0017A( lWeb,cCodCur,cPeriodo,cUnid,cJBKperlet)
         
Local lRet	:= .T.
Local cMsg	:= ""

lWeb     := IIf( lWeb     == Nil , .F., lWeb)
cCodCur  := IIf( cCodCur  == Nil , "", cCodCur)
cPeriodo := IIf( cPeriodo == Nil , "", cPeriodo)

If ! lWeb

	lRet := ( Posicione( "JBK", 1, xFilial( "JBK" ) + M->( JBH_SCP14 + JBH_SCP03 + JBH_SCP04 ), "JBK_ATIVO" ) == "1" )
		                                       
	cMsg := " Este curso n�o tem grade de aulas ativa no per�odo letivo " + M->JBH_SCP03 + " habilita��o " + M->JBH_SCP04 + "."
		
	If lRet
		      
		JAH->( dbSetOrder( 1 ) )
		JAH->( dbSeek( xFilial( "JAH" ) + M->JBH_SCP14 ) )
		         
		// Filtra somente os cursos que tem o mesmo curso, periodo letivo e unidade do curso 
		// vigente de origem escolhido no script. , verifica tambem se o periodo letivo escolhido estah ativo
		lRet := ( JAH->JAH_CURSO == M->JBH_SCP10 .and. JAH->JAH_UNIDAD == M->JBH_SCP11 )
		
		cMsg := " Curso padr�o ou unidade diferem do curso padr�o ou unidade do curso origem."
						
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
		
		// Este curso n�o pode ser selecionado.	
		MsgStop( "Este curso n�o pode ser selecionado." + cMsg )
		
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
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0017B    � Autor � Gustavo Henrique     � Data � 04/07/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Validacao do turno digitado no script do requerimento de      ���
���          �Transferencia de Turno - Veteranos.                           ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0017B        					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
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
        aadd(aRet,{.F.,"Turno Inv�lido."})	
        Return aRet		
	EndIf
EndIf

Return( lRet )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0017C    � Autor � Gustavo Henrique     � Data � 10/10/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Transfere o aluno de permuta para o turno do aluno solicitante���
���          �caso o tipo seja 2=Permuta.                                   ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0017C        					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function SEC0017C()

Local aRet  := ACScriptRet( M->JBH_NUM )
Local lRet	:= .T.

If aRet[ 20 ] == "2"		//	Permuta
	lRet := ACTransfere( 1, 3, 4, 6, 14, 16, 17, 19, .F., , 20 )
EndIf

Return( lRet )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0017D    � Autor � Gustavo Henrique     � Data � 10/10/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Varirica se o aluno informado no script pode fazer permuta com���
���          �o aluno que solicitou o requerimento.                         ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0017D        					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
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
			MsgStop( "O aluno informado n�o est� matriculado no curso informado como destino." )
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SEC0017e � Autor � Gustavo Henrique   � Data �  01/04/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Expressao de filtro tipo 07 para a consulta J2C.           ���
�������������������������������������������������������������������������͹��
���Uso       � Requerimento de transferencia de turno.                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SEC0017e()

Return( xFilial("JBO")+M->(JBH_SCP14+JBH_SCP16+JBH_SCP17) )      



