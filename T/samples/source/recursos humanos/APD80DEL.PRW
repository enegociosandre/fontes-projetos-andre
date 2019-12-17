#Include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � APD80del � Autor � Marcos Alves          � Data � 23/03/05    ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para apagar todos os registros das tabelas   ���
���          � RD7, RDB e RDD de uma avaliacao								 ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � APD080DEL(ExpA1,ExpL1)									     ���
����������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array do log do relacionamento Ex.                    ���
���          � RDB     0000000127 000013001244      00124420040101000007000..���
���          � ExpL1 = Flag indica se solicitado exibicao do log de tela     ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � APD - Rh microsiga                                            ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������*/
User function APD80DEL()
Local aArea		:=GetArea()				// Salvar a area atual
Local aAreaRD6	:=ParamIxb[1]   		// Array de restauracao da area RD6
Local lShowLog	:=ParamIxb[2]			// Recebe parametro de exibi��o do log de tela
Local aLog		:=aClone(ParamIxb[3])   // Armazenar o array do LOG, de relacionamento

If Len(aLog)>0
   aLog		:=aClone(aLog[1])   // Armazenar o array do LOG, de relacionamento
   If MsgNoYes("Confirma exclus�o dos registros relacionados no Log?")
      	// Deletar todos os registros que estao klistados no LOG (aLog)
		MsAguarde( APD80DELPROCESS(aLog,aAreaRD6), NIL, OemToAnsi( "Excluindo Avalia��o") )
   EndIf
   RestArea( aArea )
EndIf

Return Nil

/*/
�����������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � APD80DELPROCESS  � Autor � Marcos Alves    � Data � 23/03/05  ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Processo de exclusao dos registros das tabelas                ���
���          � RD7, RDB e RDD de uma avaliacao								 ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � APD080DEL(ExpA1,ExpA2)									     ���
����������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array do log do relacionamento Ex.                    ���
���          � RDB     0000000127 000013001244      00124420040101000007000..���
���          � ExpA2 = Array da area RD6, salva no icio no processo          ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � APD - Rh microsiga                                            ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
*/
Static function APD80DELPROCESS(aLog,aAreaRD6)
Local nI		:=0 					// Variavel para laco for ..next
// Deletar todos os registros que estao klistados no LOG (aLog)
For nI :=4 to Len(aLog) 					// as 3 primeiras linhas sao de cabe�alho
   cAlias:=Subs(aLog[nI],1,3)  		 	// "RDB     0000000127 000013001244      00124420040101000007000.."
   nReg	 :=Val(Subs(aLog[nI],9,10))		// "RDB     0000000127 000013001244      00124420040101000007000..."
   If !Empty(cAlias)
       dbSelectArea(cAlias) 
       dbGoto(nReg)	
       RecLock( cAlias, .F. , .T.)
       dbDelete()
       (cAlias)->( MsUnlock() )
   EndIf
Next nI
//Deletar o registro da tebela principal (RD6)
RestArea( aAreaRD6 )
RecLock( aAreaRD6[1], .F. , .T.)
dbDelete()
(aAreaRD6[1])->( MsUnlock() )
Return Nil