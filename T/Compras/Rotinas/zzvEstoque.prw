#Include "rwmake.ch"
#Include "Topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �zzvEstoque� Autor � Andre Luiz Rosa       � Data � 27/04/12 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa de validacao da Conta Contabil de Estoque         ���
���relacionado a TES					                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������Ŀ��
���Alterado  � Andre Luiz Rosa                          � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Chamada da Funcao na Validacao do Usuario                  ���
���          � U_zzVEstoque		                    					  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/

User Function zzVEstoque()

Local cContaDig:=M->D1_CONTA
Local cTESDig:=aCols[n,GdFieldPos("D1_TES")]

Local cTESEstoque:=POSICIONE("SF4",1,xFilial("SF4")+cTESDig,"F4_Estoque")


	If SUBSTR(cContaDig,1,3)$ "113"	
	
		If (cTESEstoque)$ "S"	 
				
			Return .T.   	
   		else
   			ALERT('Informe um TES que gera estoque!')
   	   		Return .F.
   		EndIf
	         		            	
	EndIf
	
	
	

	
		If (cTESEstoque)$ "S"	 
				If SUBSTR(cContaDig,1,3)$ "113"	
						Return .T.   	
	   			else
	   				ALERT('A TES informada gera estoque verifique a TES')
	   	   	   		Return .F.
   	   			EndIf
   	
   	else
   	    
   		Return .T.
   	         		            	
	EndIf
	         
Return .T. 