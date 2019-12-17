#Include "GPECR01.CH"

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
��� Funcao    � GPECR010 � Autor � Advanced RH              � Data � 17/05/01 ���
�����������������������������������������������������������������������������Ĵ��
��� Descricao � Calculo de dissidio retroativo.							      ���
�����������������������������������������������������������������������������Ĵ��
��� Sintaxe   � GPECR010()													  ���
�����������������������������������������������������������������������������Ĵ��
��� Uso       � Especifico.													  ���
�����������������������������������������������������������������������������Ĵ��
���			ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.				  ���
�����������������������������������������������������������������������������Ĵ��
��� Programador � Data   � BOPS �             Motivo da alteracao             ���
�����������������������������������������������������������������������������Ĵ��
��� Desenv-RH   �19/07/01�------�Colocar parametros: filial, centro de custo, ���
���-------------�--------�------�matricula e nome (De/Ate) na rotina  de  im- ���
���-------------�--------�------�pressao e gravacao. Verificar  totalizadores ���
���-------------�--------�------�na rotina de impressao e posicionar resgistro���
���-------------�--------�------�original no browse apos impressao e gravacao ���
���Emerson      �25/09/01�------�Verificar se o arquivo do dissidio criado em ���
���             �        �------�disco esta de acordo com a nova estrutura.   ���
���Priscila     �09/01/03�------�Alteracao p/ filtrar os dados na Geracao de  ���
���             �        �------�acordo com os parametros selecionados.       ���
���Andreia      �25/07/03�------�Alteracao para calcular as diferencas das ver���
���             �        �------�bas fazendo o recalculo da folha, a partir   ���
���             �        �------�dos arquivos de fechamento, e atualizando o  ���
���             �        �------�historico salarial na geracao dos lancamentos���
���             �        �------�futuros, valores mensais ou valores extras.  ���
���Desenv-RH    �02/09/04�------�Acerto dDataBase qdo usuario utiliza 4 digito���
���             �        �------�na data                                      ���
���Desenv-RH    �18/11/04�------�Retirada nTotal  - Total a Pagar             ���
���Emerson      �24/11/04�------�Ajuste na geracao dos valores p/ a folha, nos���
���             �        �------�casos de transferencia entre C. de Custo, nao���
���             �        �------�estava totalizando os valores para pagto.    ���
���Ricardo D.   �27/12/04�------�Ajuste na pesquisa de salarios no SR3 pois   ���
���             �        �------�nao estava buscando corretamente o salario.  ���
���Ricardo D.   �27/12/04�077386�Incluido parametro MV_GPECR01 para informar  ���
���             �        �------�os tipos de aumento que serao desconsiderados���
���Ricardo D.   �28/01/05�FNC173�Incluida validacao p/permitir que o usuario  ���
���             �        �------�informe o mes entre 01 e 12 somente.         ���
���Emerson      �03/02/05�------�Destravar registro do SRC - MsUnLock.        ���
���Emerson      �17/02/05�078019�Inverter texto "% Aum" e "Mes/Ano" no relat. ���
���Ricardo D.   �22/02/05�071672�Incluida a funcionalidade para proporcionali-���
���             �        �------�zar o aumento aos meses trabalhados e para   ���
���             �        �------�informar a data de admissao de/ate nas faixas���
���             �        �------�de aumento salarial por dissidio retroativo. ���
���Emerson      �01/03/05�079300�Gravar dissidio somente se indice > 0.       ���
���Ricardo D.   �25/04/05�080976�Ajuste na busca dos salarios dos meses passa-���
���             �        �------�dos e retirado tratamento do param.MV_GPECR01���
���             �        �------�Ajuste na coordenadas da janela e getdados.  ���
���Andreia S.   �27/07/05�083788�Ajuste para respeitar os indices de reajuste ���
���             �        �------�quando e selecionada a opcao de indice mensal���
���Emerson G.R. �12/08/05�085106�Permitir calculo do dissidio tambem em valor.���
���Andreia S.   �24/08/05�085118�Utilizar o campo R3_ANTEAUM quando ele exis -���
���             �        �------�tir no historico de salarios e estiver com   ���
���             �        �------�valor.                                       ���
���Andreia S.   �06/10/05�086496�Ajuste na busca do salario no SR3 para so con���
���             �        �------�siderar o maior valor a partir de julho/94,  ���
���             �        �------�quando entrou em vigor o Plano Real.         ���
���Andreia S.   �06/10/05�Fnc   �Verificacao se as datas de inicio e fim do   ���
���             �        �3148/ �periodo estao preenchidas. Se estiverem em   ���
���             �        �2005  �branco, da aviso e nao deixa prosseguir.     ���
���R.H.         �01/11/05�081018�Acerto na montagem  do indice                ���
���             �        �      �Inclusao da opcao de exclusao -opcao Menu    ���
���             �        �      �Apos efetuado o calculo eh possivel recalcu- ���
���             �        �      �lar o dissidio sem  que os anteriores sejam  ���
���             �        �      �excluidos automaticamente- usuario pode optar���
���             �        �      �entre excluir anteriores ou nao              ���
���R.H.         �11/11/05�081018�Acerto na montagem  do indice                ���
���R.H.         �23/11/05�088787�Passamos a tratar o calculo do dissidio retro���
���             �        �      �ativo como uma funcao padrao do SIGAGPE.     ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������*/
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/09/00

User Function GPECR01()

GPEM690()

Return