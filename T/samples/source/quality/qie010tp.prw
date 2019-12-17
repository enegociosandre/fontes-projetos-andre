#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 03/12/99
User Function qie010tp()     // incluido pelo assistente de conversao do AP5 IDE em 03/12/99

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("ASAVHEADER,ASAVACOLS,NSAVN,LRETURN,NPOSTIPLAM,NPOSPLAMO")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � QIE010TP � Autor � Antonio Aurelio F C   � Data � 11/05/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se o NQA foi especificado na Descricao do Prod.   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �  X3_WHEN - SIGAQIE QIE010TP()                              ���
�������������������������������������������������������������������������Ĵ��
���			ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.			  ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data	� BOPS �  Motivo da Alteracao 					  ���
�������������������������������������������������������������������������Ĵ��
���Paulo Emidio�15/09/00�META  �Implementacao do Plano de Amostragem por  ���
���            �        �      �Ensaios                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

IIF(aSavHeader == NIL, aSavHeader := {},)
IIF(aSavaCols == NIL, aSavaCols := {},)
IIF(nSavn == NIL, nSavn := 0,)

//�����������������������������������������������������������������Ŀ
//�	Obs. As Vari�veis aSavHeader, aSavaCols e nSavn estao declradas �
//�  como Private na fun�ao de de chamamento AIEA010                �
//�������������������������������������������������������������������

lReturn := .F.

nPosTiPlaM := AScan(aSavHeader, { |x| Alltrim(x[2]) == 'QE7_TIPLAM' })

If AllTrim(aSavaCols[nSavn][nPosTiPlaM]) == "2"	
	//�����������������������������������������������������������������Ŀ
	//�	Se o QE9_PLAMO nao for o corrente, testa   						�
	//�������������������������������������������������������������������
	If ReadVar() <> "M->QE9_PLAMO"
		nPosPlaMo  := AScan(aHeader, { |x| Alltrim(x[2]) == 'QE9_PLAMO'})
		If nPosPlaMo > 0
			If !Empty(aCols[n][nPosPlaMo])
				lReturn := .T.
			EndIf
		EndIf		
	Else
		lReturn := .T.
	EndIf	
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 03/12/99 ==> __Return(lReturn)
Return(lReturn)        // incluido pelo assistente de conversao do AP5 IDE em 03/12/99
