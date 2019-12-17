#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 03/12/99

User Function qie010vp()     // incluido pelo assistente de conversao do AP5 IDE em 03/12/99

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("LRETURN,NPOSNIVEL,NPOSNQA,ATAM,ACOLS,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � QIE010VP � Autor � Antonio Aurelio F C   � Data � 11/05/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Limpa os campos Nivel e NQA se Pl. Amostragem estiver vazio���
�������������������������������������������������������������������������Ĵ��
��� Uso      �X3_VALID - SIGAQIE (QE9_PLAMO)                              ���
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

//��������������������������������������������������������������Ŀ
//�  Par�metros para a fun��o SetPrint () 						 �
//����������������������������������������������������������������

lReturn := .T.

//��������������������������������������������������������������Ŀ
//� Posiciona o Campo QE9_PLAMO na GetDados 					 �
//����������������������������������������������������������������
If (AllTrim(ReadVar()) == "M->QE9_PLAMO")

	//��������������������������������������������������������������Ŀ
	//� ReadVar mostra o conteudo da variavel corrente, enquanto     �
	//�  aCols mostra a conteudo anterior a edicao                   �
	//����������������������������������������������������������������
	If Empty(&ReadVar())

		//��������������������������������������������������������������Ŀ
		//� Posiciona os campos QE9_NIVEL e QE9_NQA  					 �
		//����������������������������������������������������������������

		nPosNivel := AScan(aHeader, { |x| Alltrim(x[2]) == 'QE9_NIVEL'})
		nPosNQA   := AScan(aHeader, { |x| Alltrim(x[2]) == 'QE9_NQA'})
		lReturn   := .F.

		//��������������������������������������������������������������Ŀ
		//� zerar os campos com valores maiores que "" 					 �
		//����������������������������������������������������������������
		If nPosNivel > 0
			aTam := TamSX3("QE9_NIVEL")
			aCols[n][nPosNivel] := Space(aTam[1])
			If nPosNQA > 0
				aTam := TamSX3("QE9_NQA")
				aCols[n][nPosNQA] := Space(aTam[1])
				//��������������������������������������������������������������Ŀ
				//� Depois de fazer a atribui�ao retorna .T.					 �
				//����������������������������������������������������������������
				lReturn := .T.
			EndIf
		EndIf
	EndIf
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 03/12/99 ==> __Return(lReturn)
Return(lReturn)        // incluido pelo assistente de conversao do AP5 IDE em 03/12/99
