#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AC680Prf  �Autor  �Rafael Rodrigues    � Data �  13/jun/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �PE na rotina ACAW680Prf para retornar um array com a legenda���
���          �dos prefixos de titulos                                     ���
�������������������������������������������������������������������������͹��
���Param.    �Nenhum                                                      ���
�������������������������������������������������������������������������͹��
���Retorno   � Array: Contendo a seguinte estrutura:                      ���
���          � ExpA[i][1] - String: Prefixo                               ���
���          � ExpA[i][2] - String: Descricao do Prefixo                  ���
�������������������������������������������������������������������������͹��
���Uso       �Gestao Educacional - Hypersite                              ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AC680Prf()
local aReturn	:= {}

aAdd(aReturn, {"ADA", "Adapta��o"})
aAdd(aReturn, {"DEP", "Depend�ncia"})
aAdd(aReturn, {"MAT", "Matr�cula"})
aAdd(aReturn, {"MES", "Mensalidade"})
aAdd(aReturn, {"DIS", "Disciplina"})
aAdd(aReturn, {"NEG", "Negocia��o"})
aAdd(aReturn, {"REQ", "Requerimento"})
aAdd(aReturn, {"TUT", "Tutoria"})

Return aReturn